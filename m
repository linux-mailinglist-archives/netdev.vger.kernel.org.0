Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFB1E78AF
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfJ1Sn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:43:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38095 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJ1Sn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:43:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id t26so6041237qtr.5;
        Mon, 28 Oct 2019 11:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3BNJfD66jRJDdvcQiIti5lw3kf5uDFmZbb4exmHMhAA=;
        b=RDya/XLS2h+byE7Kaar9+V7Nu+RRvjBJ+cJ7aOlcq1Mk7bA3pP9ZdO8FfEhWOpuBCR
         E8OQ12fHG99z0wRFV/4HFSnKSaaEP0Fq3RWY6tygNrodKpDqmDrHY/+bJSJWY/I0bIdO
         mlRj6JMTa1Pxh/toQbzW3O2DyPPYQ4OpuB1UOQSt7EZafNY81MNkMcO5u5ZLcRbL1aLM
         B6Glhxaaj42r9UHjVvnCj36Ke4f+eSbZXA9fDsWrj9i7NvnzCCntAPUg5o0g0OmPmi0o
         PnqwmbWHqXc45mnG1pcyLEoQ6HKLK3NKOXK7ev0OWPXKSmwkIfL1Q0C+imLxhhizWzwH
         mDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3BNJfD66jRJDdvcQiIti5lw3kf5uDFmZbb4exmHMhAA=;
        b=pg/Z/vcq9m1THc4DiLuZ8tgoC8GiMrNPUOnbDKB93vNuzJcM1vxdPp0K5Fl6rgg7+T
         u5K4sd4pB4XM3Bl5NY/ApStPsMNStkYHuHPQXejQ7yfi6HaGHM9MufofBH49TgBC2IaJ
         dPXV7y97sFcIsm29Vanu4O6nsTqujR9YLZcj19l3UaZ8S9UtGm3hLE+ELiUqkLuaBimG
         e/YL5EgQy/YQv7E1E7nwM8HO9eLomg8mu/D08lh50cpvJPL656/YzxQPKOLwVUMozK/P
         pz6/lbWOfZJr8Jr+vh6WvOJ95be9LugWyeocXQhgQRUPdOhKpHqaslj0SgzoEcEQgDPV
         ZaUA==
X-Gm-Message-State: APjAAAUggNSYGO3RrmCRmJhqPQ2LrfOeenKTELo5qjMnBXt8ZVtPZotn
        d0J1bxdI8Ir9Npuns21QHgDdpeKMffJc+VoSXZI=
X-Google-Smtp-Source: APXvYqwQuhj5NPy3nlTzAz6h++Thd7OKuFGzicOxBIGZNdb+nUwx8dUDWWdwJEnEEf6lbz91zbVjf9/WkdxNcoBS4bU=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr18618698qte.59.1572288203373;
 Mon, 28 Oct 2019 11:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk> <157220959980.48922.12100884213362040360.stgit@toke.dk>
In-Reply-To: <157220959980.48922.12100884213362040360.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Oct 2019 11:43:11 -0700
Message-ID: <CAEf4BzZdXX0P=3O_-tWWUqZwDHNofme+_nC6+TyUV+ngW343GA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map pinning
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a new BPF selftest to exercise the new automatic map pinning
> code.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/pinning.c |   91 ++++++++++++++++=
++++++
>  tools/testing/selftests/bpf/progs/test_pinning.c |   29 +++++++
>  2 files changed, 120 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/tes=
ting/selftests/bpf/prog_tests/pinning.c
> new file mode 100644
> index 000000000000..d4a63de72f5a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <test_progs.h>
> +
> +__u32 get_map_id(struct bpf_object *obj, const char *name)
> +{
> +       __u32 map_info_len, duration, retval;
> +       struct bpf_map_info map_info =3D {};
> +       struct bpf_map *map;
> +       int err;
> +
> +       map_info_len =3D sizeof(map_info);
> +
> +       map =3D bpf_object__find_map_by_name(obj, name);
> +       if (!CHECK(!map, "find map", "NULL map")) {

please follow the pattern of "if (CHECK()) { return or goto cleanup
}". There is literally zero cases where we have `if (!CHECK())` in
selftests.

> +               err =3D bpf_obj_get_info_by_fd(bpf_map__fd(map),
> +                                            &map_info, &map_info_len);
> +               CHECK(err, "get map info", "err %d errno %d", err, errno)=
;
> +               return map_info.id;
> +       }
> +       return 0;
> +}
> +
> +void test_pinning(void)
> +{
> +       __u32 duration, retval, size, map_id, map_id2;
> +       const char *custpinpath =3D "/sys/fs/bpf/custom/pinmap";
> +       const char *nopinpath =3D "/sys/fs/bpf/nopinmap";
> +       const char *custpath =3D "/sys/fs/bpf/custom";
> +       const char *pinpath =3D "/sys/fs/bpf/pinmap";
> +       const char *file =3D "./test_pinning.o";
> +       struct stat statbuf =3D {};
> +       struct bpf_object *obj;
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +               .auto_pin_path =3D custpath,
> +       );
> +
> +       int err;
> +       obj =3D bpf_object__open_file(file, NULL);
> +       if (CHECK_FAIL(libbpf_get_error(obj)))
> +               return;
> +
> +       err =3D bpf_object__load(obj);
> +       CHECK(err, "default load", "err %d errno %d\n", err, errno);

cleanup and exit, you don't have a valid set up to proceed with
testing. Same for almost every check below.

> +
> +       /* check that pinmap was pinned */
> +       err =3D stat(pinpath, &statbuf);
> +       CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno);
> +
> +        /* check that nopinmap was *not* pinned */
> +       err =3D stat(nopinpath, &statbuf);
> +       CHECK(errno !=3D ENOENT, "stat nopinpath", "err %d errno %d\n", e=
rr, errno);

if previous stat succeeded, errno might be from other syscall, you
have to check both

> +
> +        map_id =3D get_map_id(obj, "pinmap");

formatting? check that get_map_id succeeded?

> +       bpf_object__close(obj);
> +
> +       obj =3D bpf_object__open_file(file, NULL);
> +       if (CHECK_FAIL(libbpf_get_error(obj)))
> +               return;
> +
> +       err =3D bpf_object__load(obj);
> +       CHECK(err, "default load", "err %d errno %d\n", err, errno);
> +
> +       /* check that same map ID was reused for second load */
> +       map_id2 =3D get_map_id(obj, "pinmap");
> +       CHECK(map_id !=3D map_id2, "check reuse",
> +             "err %d errno %d id %d id2 %d\n", err, errno, map_id, map_i=
d2);
> +       unlink(pinpath);
> +       bpf_object__close(obj);
> +
> +       err =3D mkdir(custpath, 0700);
> +       CHECK(err, "mkdir custpath",  "err %d errno %d\n", err, errno);
> +
> +       obj =3D bpf_object__open_file(file, &opts);
> +       if (CHECK_FAIL(libbpf_get_error(obj)))
> +               return;
> +
> +       err =3D bpf_object__load(obj);
> +       CHECK(err, "custom load", "err %d errno %d\n", err, errno);
> +
> +       /* check that pinmap was pinned at the custom path */
> +       err =3D stat(custpinpath, &statbuf);
> +       CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno);
> +
> +       unlink(custpinpath);
> +       rmdir(custpath);
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/tes=
ting/selftests/bpf/progs/test_pinning.c
> new file mode 100644
> index 000000000000..ff2d7447777e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +int _version SEC("version") =3D 1;
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u64);
> +       __uint(pinning, LIBBPF_PIN_BY_NAME);
> +} pinmap SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u64);
> +} nopinmap SEC(".maps");
> +
> +SEC("xdp_prog")
> +int _xdp_prog(struct xdp_md *xdp)
> +{
> +       return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
>
