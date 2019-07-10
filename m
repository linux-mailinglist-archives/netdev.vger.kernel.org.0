Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD064F60
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 01:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfGJXwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 19:52:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39916 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGJXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 19:52:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so4450673qtu.6;
        Wed, 10 Jul 2019 16:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lshyIJu954v2r/7XKXLH1/amde3r4n1sA3qGLei0xOw=;
        b=RbOV08DQF30yaBGCedUyuFI4e87n2/cGIvwajOkKhV6VPJaZJKAK1fsyEDE7Ig7vgh
         eWrQJN0kGIozDdlvYa0O/839xFHhIu6yLXuTp6mGBaMLTuCjMLwrzAv4Dv8p6ABLO7mM
         qQHJi6Il7/B7gPjzpxD/sCRYT4F0y/TY8PP3XZU+OrdI/30rWBH7ouhdJsr1zcxrFLxj
         FGKWp3x5LKW6/z1OUqiVc9OTXPsBnp2mIP+ff651wjdrM0YpqR5BSx91fXe81DukuaTj
         l+DtEABNrftVsinFEL/u5JUdg4b10bFf761mBhARk1WgVTfDk3DOB78ek6RYY3BdJFN7
         FbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lshyIJu954v2r/7XKXLH1/amde3r4n1sA3qGLei0xOw=;
        b=FdTnO2NlQIkqkZkpvxYYRi6XkyBjzjffUQqbkBeBV7pxiLhpB1c/24Gprh5npbpFOT
         gPf/7sDXkgdXbSWtiQqOhvR3HvdGZbeNXTRjgTvSQ86VLPfIZt649ZFpfkg/XcYiS7vB
         yE0AGiDNVZUyn7ZwyUlhvOYwOB3X/g0r+xyLgbDOSQd+HBbbBUrxjzXqf0n/FaZ4YHP3
         H9uJ8RokwV3llmTuobx2S21M04yVrWIC/6dsrHlXd0E5QcfbCie3viIdNNiJeR/5Zj2x
         gl6c0g85VjGnrRbGhabLEcX1i85prL79XVYzfK4GivSqzfgdkBzAzeKZW6IjrrCu8/6Y
         WukA==
X-Gm-Message-State: APjAAAVXwUvI1hWmY3RPyLUA41nDLtRUMkZHBDyjoHKo88oPos0Tz8pT
        CSmcmhwke+HbBbvOrcycBJu4PujsjWHyQDEfZ6Q=
X-Google-Smtp-Source: APXvYqxe/l7pZ4dnvE7+PRMPc4A4wDIw6MCWFNLCzSz9fy+bNipjZmRwefK+gwpAGRiEg3Ah0EJwYwPYYO1pmfWzj20=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr561834qta.171.1562802721973;
 Wed, 10 Jul 2019 16:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-3-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-3-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 16:51:51 -0700
Message-ID: <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com>
Subject: Re: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> Save errno right after bpf_prog_test_run returns, so we later check
> the error code actually set by bpf_prog_test_run, not by some libcap
> function.
>
> Changes since v1:
> - Fix the "Fixes:" tag to mention actual commit that introduced the
>   bug
>
> Changes since v2:
> - Move the declaration so it fits the reverse christmas tree style.
>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in test_verifier")
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index b8d065623ead..3fe126e0083b 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>         __u8 tmp[TEST_DATA_LEN << 2];
>         __u32 size_tmp = sizeof(tmp);
>         uint32_t retval;
> +       int saved_errno;
>         int err;
>
>         if (unpriv)
>                 set_admin(true);
>         err = bpf_prog_test_run(fd_prog, 1, data, size_data,
>                                 tmp, &size_tmp, &retval, NULL);

Given err is either 0 or -1, how about instead making err useful right
here without extra variable?

if (bpf_prog_test_run(...))
        err = errno;

> +       saved_errno = errno;
>         if (unpriv)
>                 set_admin(false);
>         if (err) {
> -               switch (errno) {
> +               switch (saved_errno) {
>                 case 524/*ENOTSUPP*/:

ENOTSUPP is defined in include/linux/errno.h, is there any problem
with using this in selftests?

>                         printf("Did not run the program (not supported) ");
>                         return 0;
> --
> 2.20.1
>
