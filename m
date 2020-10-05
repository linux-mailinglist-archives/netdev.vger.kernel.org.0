Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FAB28421B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 23:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgJEV2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 17:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJEV2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 17:28:24 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D77CC0613CE;
        Mon,  5 Oct 2020 14:28:22 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q5so14060435qkc.2;
        Mon, 05 Oct 2020 14:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2HGNGlBJw7bi6Ui2XR2LPCsGN9UVzIY2LSrHY7U7TDc=;
        b=uiSyf3v1GH479lnM34ILNDcDtWlIKGdvsV7swBh6+UQF61+Cvx9PQVbv10W03ex7bY
         y7X1B+P5emDihY69OrH3aDW1iXOxTtJVf2+K9bs3V0M35ky0zbOrOW0b+XqMDG40nzsw
         +I8MWuCRC2ZetVYR8CpY73BgkAiXmJtETzTPpBi7k0zRQr3xMvLPmZmLs8ZND7ZqPbtC
         xu9fae+JABrxBua8kuuwQPKj62ir+/Oi60Cga72WxRGRQg3OgGqMAM5p/SMYVGqDpHZn
         C4l2e1dhw7/8rz0Yfi+HW5ujFEW63fq7fXUKvJEaScGOkK5Y+rhnerUDdSYdFhuVjuok
         V85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2HGNGlBJw7bi6Ui2XR2LPCsGN9UVzIY2LSrHY7U7TDc=;
        b=Tvwpj1XygJaa9Sr101hNykJsL9YclX4gifFyf4B1Xdzv8AmAE6BJrDLjiQcWhLfF92
         aqTZ78J1YTOiLzJ0bPCoOjEnQ4Xqe2yoeZTPmz3NuMlY/v85cwe1FDnybUnqid7666qO
         O4zRlndlf7Lc3Zd6OI+i+NJh9B8iwVR2Mkwxoq+Bj1U5wR2BE/oF2rYvghtJFJRf5J6L
         FIhS8w4Db3DmQEpTRFw6U/dfxAgSPxXkic3Hud+38I+1oRNuCeyatOKfuViOof9DJfXr
         nz8BYfRVKzkQpR2E1PaHepY6tdW0+62W56FduPIIrqkmUUEAJkSkobr93G/Q2y5OBzVj
         IEXA==
X-Gm-Message-State: AOAM532I/yxkXsPIGCxrVacxCMoKAavOcEcVvk6YbcDBnIO5rVPhg1+4
        xRPhGy7smaxedla0mxLRNxfCAL6/fbbC/5BrPNk=
X-Google-Smtp-Source: ABdhPJwIuuoHqD6t4QarPaFZTS/CD0ycIp8P/TuD3y7MYAzk0LRoSRlM8Tus3Ud5nFLelPIx7pNsJ8z+dgdXlZI5La8=
X-Received: by 2002:a25:2687:: with SMTP id m129mr2574144ybm.425.1601933301808;
 Mon, 05 Oct 2020 14:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
 <20201003085505.3388332-1-liuhangbin@gmail.com> <20201003085505.3388332-4-liuhangbin@gmail.com>
In-Reply-To: <20201003085505.3388332-4-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Oct 2020 14:28:10 -0700
Message-ID: <CAEf4BzYh4kSOJmjVrmZ2VLiO9GsZPiSpFXkXevy74_ByS6S12A@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 3/3] selftest/bpf: test pinning map with reused map fd
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 1:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> This add a test to make sure that we can still pin maps with
> reused map fd.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/pinning.c        | 46 ++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
> index 041952524c55..299f99ef92b2 100644
> --- a/tools/testing/selftests/bpf/prog_tests/pinning.c
> +++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
> @@ -37,7 +37,7 @@ void test_pinning(void)
>         struct stat statbuf = {};
>         struct bpf_object *obj;
>         struct bpf_map *map;
> -       int err;
> +       int err, map_fd;
>         DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
>                 .pin_root_path = custpath,
>         );
> @@ -213,6 +213,50 @@ void test_pinning(void)
>         if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
>                 goto out;
>
> +       /* remove the custom pin path to re-test it with reuse fd below */
> +       err = unlink(custpinpath);
> +       if (CHECK(err, "unlink custpinpath", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       err = rmdir(custpath);
> +       if (CHECK(err, "rmdir custpindir", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       bpf_object__close(obj);
> +
> +       /* test pinning at custom path with reuse fd */
> +       obj = bpf_object__open_file(file, NULL);
> +       if (CHECK_FAIL(libbpf_get_error(obj))) {

please use CHECK, might try new ASSERT_OK_PTR(obj, "obj_open") as well

> +               obj = NULL;
> +               goto out;
> +       }
> +
> +       map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(__u32),
> +                               sizeof(__u64), 1, 0);
> +       if (CHECK(map_fd < 0, "create pinmap manually", "fd %d\n", map_fd))
> +               goto out;
> +
> +       map = bpf_object__find_map_by_name(obj, "pinmap");
> +       if (CHECK(!map, "find map", "NULL map"))

here and below you are not closing map_fd on error

> +               goto out;
> +
> +       err = bpf_map__reuse_fd(map, map_fd);
> +       if (CHECK(err, "reuse pinmap fd", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       err = bpf_map__set_pin_path(map, custpinpath);
> +       if (CHECK(err, "set pin path", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       err = bpf_object__load(obj);
> +       if (CHECK(err, "custom load", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       /* check that pinmap was pinned at the custom path */
> +       err = stat(custpinpath, &statbuf);
> +       if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
> +               goto out;
> +
>  out:
>         unlink(pinpath);
>         unlink(nopinpath);
> --
> 2.25.4
>
