Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA562EB6C2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfJaSSP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 31 Oct 2019 14:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJaSSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 14:18:14 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D476F8535D
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 18:18:13 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id h3so1609342lfp.17
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 11:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hAO8gdMBwEsb3+ZUjKPzDGZ8KzTY+WTufgu7EjXj1ak=;
        b=eO6y8hAaKLdrbDmqb4iHlqBx6IuusqQUyPenINQeXXgrSfx2BNA4Riwp2jpfDD9v+I
         60V5iMY82UQS5DpM/DkCC2EC+EvJra16yoCm2K/QdR1xIBeupBLmVwhcbITmUXwx7Zvl
         Dftz/HDPq2W37Zi1LBNITXUSQNzB3S8VizWgd9lj7e8LABSeYLrrmmhCkhpuMbicaUUo
         jRzSmNPoVFtD29W9B4cp5LtRsm6Y4GiiGmZx+yiLG/w3uzQg73XQoERECxDaMOsOkktc
         9yC+kaMbZrd8gw2EKVhCiJYFYB0L/4s9Q/0CbgkLUo8z3GtLiKZkxRPfxlQ5wQP3bGJs
         xgmw==
X-Gm-Message-State: APjAAAUT/3H5KfdFD5l21K/szNBs9KEWNuBLedEU/0Non1Z9ZZ+KzHbk
        1z3zn2jYvPbnSaVZg8woImga5Cv+akZaSJYsCCGXxlO4vmWEg87haO39VNSRpvHXw3Q6ivQHa/w
        WBmYoevNAEp1A/xV0
X-Received: by 2002:a2e:93d7:: with SMTP id p23mr5134811ljh.251.1572545892337;
        Thu, 31 Oct 2019 11:18:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqywIUuJCljaOckz21Hz3YoX+FPI0NftFuyHwoDO6aGwGg0dt2LL/+dQbjNswvIG65jLu3YFsg==
X-Received: by 2002:a2e:93d7:: with SMTP id p23mr5134793ljh.251.1572545892132;
        Thu, 31 Oct 2019 11:18:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id o26sm1676354lfi.57.2019.10.31.11.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 11:18:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B34941818B5; Thu, 31 Oct 2019 19:18:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 5/5] selftests: Add tests for automatic map pinning
In-Reply-To: <CAEf4BzZ6OYFYZNfQ4n7gPjyg0tWtsAaNWzZie3L23TE9KNtOoA@mail.gmail.com>
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796779.169521.16760790702202542513.stgit@toke.dk> <CAEf4BzZ6OYFYZNfQ4n7gPjyg0tWtsAaNWzZie3L23TE9KNtOoA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 19:18:10 +0100
Message-ID: <87wockn5i5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 29, 2019 at 12:39 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> This adds a new BPF selftest to exercise the new automatic map pinning
>> code.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  tools/testing/selftests/bpf/prog_tests/pinning.c |  157 ++++++++++++++++++++++
>>  tools/testing/selftests/bpf/progs/test_pinning.c |   29 ++++
>>  2 files changed, 186 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
>>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
>> new file mode 100644
>> index 000000000000..71f7dc51edc7
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
>> @@ -0,0 +1,157 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <sys/types.h>
>> +#include <sys/stat.h>
>> +#include <unistd.h>
>> +#include <test_progs.h>
>> +
>> +__u32 get_map_id(struct bpf_object *obj, const char *name)
>> +{
>> +       __u32 map_info_len, duration, retval;
>> +       struct bpf_map_info map_info = {};
>> +       struct bpf_map *map;
>> +       int err;
>> +
>> +       map_info_len = sizeof(map_info);
>> +
>> +       map = bpf_object__find_map_by_name(obj, name);
>> +       if (CHECK(!map, "find map", "NULL map"))
>> +               return 0;
>> +
>> +       err = bpf_obj_get_info_by_fd(bpf_map__fd(map),
>> +                                    &map_info, &map_info_len);
>> +       CHECK(err, "get map info", "err %d errno %d", err, errno);
>> +       return map_info.id;
>> +}
>> +
>> +void test_pinning(void)
>> +{
>> +       __u32 duration, retval, size, map_id, map_id2;
>> +       const char *custpinpath = "/sys/fs/bpf/custom/pinmap";
>> +       const char *nopinpath = "/sys/fs/bpf/nopinmap";
>> +       const char *custpath = "/sys/fs/bpf/custom";
>
> Should this test mount/unmount (if necessary) /sys/fs/bpf? They will
> all fail if BPF FS is not mounted, right?

Yeah; I was kinda expecting that the test harness takes care of this. Is
it really a good idea for a selftest to mess with mount()?

>> +       const char *pinpath = "/sys/fs/bpf/pinmap";
>> +       const char *file = "./test_pinning.o";
>> +       struct stat statbuf = {};
>> +       struct bpf_object *obj;
>> +       struct bpf_map *map;
>> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
>> +               .pin_root_path = custpath,
>> +       );
>> +
>> +       int err;
>> +       obj = bpf_object__open_file(file, NULL);
>> +       if (CHECK_FAIL(libbpf_get_error(obj)))
>> +               return;
>> +
>> +       err = bpf_object__load(obj);
>> +       if (CHECK(err, "default load", "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>> +       /* check that pinmap was pinned */
>> +       err = stat(pinpath, &statbuf);
>> +       if (CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>> +        /* check that nopinmap was *not* pinned */
>> +       err = stat(nopinpath, &statbuf);
>> +       if (CHECK(!err || errno != ENOENT, "stat nopinpath",
>> +                 "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>> +        map_id = get_map_id(obj, "pinmap");
>
> something wrong with whitespaces here? can you please run
> scripts/checkpatch.pl to double-check?

Yup, some space got in where a tab should be

>> +       if (!map_id)
>> +               goto out;
>> +
>> +       bpf_object__close(obj);
>> +
>> +       obj = bpf_object__open_file(file, NULL);
>> +       if (CHECK_FAIL(libbpf_get_error(obj)))
>
> obj = NULL here before you go to out

Yup

>
>> +               goto out;
>> +
>> +       err = bpf_object__load(obj);
>> +       if (CHECK(err, "default load", "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>
> [...]
>
>> +       err = rmdir(custpath);
>> +       if (CHECK(err, "rmdir custpindir", "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>> +       bpf_object__close(obj);
>> +
>> +       /* test auto-pinning at custom path with open opt */
>> +       obj = bpf_object__open_file(file, &opts);
>> +       if (CHECK_FAIL(libbpf_get_error(obj)))
>> +               return;
>
> obj = NULL; goto out; to ensure pinpath is unlinked?

Yeah.

>> +
>> +       err = bpf_object__load(obj);
>> +       if (CHECK(err, "custom load", "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>> +       /* check that pinmap was pinned at the custom path */
>> +       err = stat(custpinpath, &statbuf);
>> +       if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
>> +               goto out;
>> +
>> +out:
>> +       unlink(pinpath);
>> +       unlink(nopinpath);
>> +       unlink(custpinpath);
>> +       rmdir(custpath);
>> +       if (obj)
>> +               bpf_object__close(obj);
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
>> new file mode 100644
>> index 000000000000..ff2d7447777e
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
>> @@ -0,0 +1,29 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/bpf.h>
>> +#include "bpf_helpers.h"
>> +
>> +int _version SEC("version") = 1;
>> +
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_ARRAY);
>> +       __uint(max_entries, 1);
>> +       __type(key, __u32);
>> +       __type(value, __u64);
>> +       __uint(pinning, LIBBPF_PIN_BY_NAME);
>> +} pinmap SEC(".maps");
>> +
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_ARRAY);
>> +       __uint(max_entries, 1);
>> +       __type(key, __u32);
>> +       __type(value, __u64);
>> +} nopinmap SEC(".maps");
>
>
> would be nice to ensure that __uint(pinning, LIBBPF_PIN_NONE) also
> works as expected, do you mind adding one extra map?

Sure, can do...

>> +
>> +SEC("xdp_prog")
>> +int _xdp_prog(struct xdp_md *xdp)
>> +{
>> +       return XDP_PASS;
>> +}
>> +
>> +char _license[] SEC("license") = "GPL";
>>
