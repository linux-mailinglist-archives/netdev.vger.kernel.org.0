Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC4223F39F
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHGUNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgHGUNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:13:36 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA78CC061756;
        Fri,  7 Aug 2020 13:13:36 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x10so1609628ybj.13;
        Fri, 07 Aug 2020 13:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NlOBWexyY0dInNPp/mSfboYY9fzvv33AGfW2HB+4EOM=;
        b=aPOevBWgD0Rb9PDi95sWQVC4og7b6PK74p49d64mvkRGJtjnHeMWgmAoLl6M5PVFms
         lrf6sra716RhvYwUs0oHi9ScRiR2oDqidZj3VanxfwhRjzo5D2/d+6MAPbYsOmdbtGzg
         roz09lyy3QJvnVybwQqG0ZME24b9vJquEWUgaanktSmqILCXUXpYl1nXUfnU48HsAgjW
         ulaMs4ze1Eh5pDu+htXxOxffsCRSTVX0j+tLO7Mr7917ghi8Z+TQG38yOngX8yN0flZc
         0Y1hJY+M0QMEYGaoJOu1aCrT7gWnrr2oDuJHGiXxchcglcmu+ndG/lDxc1GHtzlNC2p6
         VlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NlOBWexyY0dInNPp/mSfboYY9fzvv33AGfW2HB+4EOM=;
        b=Pq2o4bTHlxY9MLHJn5YLw37sOL35BRSEl3tyUDDh0e7NfQ2IdtkaihWxNkJI+e93qi
         zr1FpiP1KkVh9pwIHgc8iHjGm47CZBL2i2dyW/NP4uspeuCXEJ5eEHkY0PgBBxmDJZvd
         TnWg7auB99DI87vSsGBaUUUd6nAsToJ8meYuvTksPPgDKJ86qHC94wjSEB9qGSK99Xmi
         MDKaZ/vdSNzB1u/q5uVPopKUhRUiNJ2ins/FcDK6y5SzlgH0WDPoDtrt9s0vSRoRKYJ/
         gotQkZAo9A2yN9v2jmS7BZbvLC3hjwOGu/sREGCOJ+uQO7H5XlyUcuVB2EDaBTqMb5ba
         IiJg==
X-Gm-Message-State: AOAM531QBJJhqCv2csdN5m10C6YRl11HvGGTR+lSLQn5crQh6a+9dbfG
        KGv15dJ7FoF+5T4hV7ElcgtqZEygOpXX4ENjFJU=
X-Google-Smtp-Source: ABdhPJxWIoNXcSUcv/qMdTJM/8d2ZcqSOWxQZVAuYfWjwDUV58Dit91Vp7rR8Jm9fnHRs5ptwSuqPscUDJRO173oYOU=
X-Received: by 2002:a25:824a:: with SMTP id d10mr23418559ybn.260.1596831215942;
 Fri, 07 Aug 2020 13:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200731061600.18344-1-Jianlin.Lv@arm.com> <20200807172016.150952-1-Jianlin.Lv@arm.com>
In-Reply-To: <20200807172016.150952-1-Jianlin.Lv@arm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Aug 2020 13:13:25 -0700
Message-ID: <CAEf4Bza2vJYRbzo2Qbx_XRBPsS-n3dxhOaK+vzjqrhb2wUaCnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix segmentation fault of test_progs
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 10:21 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> test_progs reports the segmentation fault as below
>
> $ sudo ./test_progs -t mmap --verbose
> test_mmap:PASS:skel_open_and_load 0 nsec
> ......
> test_mmap:PASS:adv_mmap1 0 nsec
> test_mmap:PASS:adv_mmap2 0 nsec
> test_mmap:PASS:adv_mmap3 0 nsec
> test_mmap:PASS:adv_mmap4 0 nsec
> Segmentation fault
>
> This issue was triggered because mmap() and munmap() used inconsistent
> length parameters; mmap() creates a new mapping of 3*page_size, but the
> length parameter set in the subsequent re-map and munmap() functions is
> 4*page_size; this leads to the destruction of the process space.
>
> Another issue is that when unmap the second page fails, the length
> parameter to delete tmp1 mappings should be 3*page_size.
>
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/mmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
> index 43d0b5578f46..2070cfe19cac 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mmap.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
> @@ -192,7 +192,7 @@ void test_mmap(void)
>         /* unmap second page: pages 1, 3 mapped */
>         err = munmap(tmp1 + page_size, page_size);
>         if (CHECK(err, "adv_mmap2", "errno %d\n", errno)) {
> -               munmap(tmp1, map_sz);
> +               munmap(tmp1, 3 * page_size);

this is a good catch, thank you!

>                 goto cleanup;
>         }
>
> @@ -207,8 +207,8 @@ void test_mmap(void)
>         CHECK(tmp1 + page_size != tmp2, "adv_mmap4",
>               "tmp1: %p, tmp2: %p\n", tmp1, tmp2);
>
> -       /* re-map all 4 pages */
> -       tmp2 = mmap(tmp1, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
> +       /* re-map all 3 pages */
> +       tmp2 = mmap(tmp1, 3 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
>                     data_map_fd, 0);

"all 3 pages" is a lie, there are 4. I'd still want to work with all 4
pages. How about we mmap() 4 pages of anonymous memory first, then do
all the mmap() with MAP_FIXED, re-using that memory range. That will
ensure that we are not stepping on any other allocated memory, right?


>         if (CHECK(tmp2 == MAP_FAILED, "adv_mmap5", "errno %d\n", errno)) {
>                 munmap(tmp1, 3 * page_size); /* unmap page 1 */
> @@ -226,7 +226,7 @@ void test_mmap(void)
>         CHECK_FAIL(map_data->val[2] != 321);
>         CHECK_FAIL(map_data->val[far] != 3 * 321);
>
> -       munmap(tmp2, 4 * page_size);
> +       munmap(tmp2, 3 * page_size);
>
>         /* map all 4 pages, but with pg_off=1 page, should fail */
>         tmp1 = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
> --
> 2.17.1
>
