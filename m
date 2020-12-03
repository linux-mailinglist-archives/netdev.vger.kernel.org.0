Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A22CE06C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgLCVOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgLCVOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:14:20 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CE8C061A51;
        Thu,  3 Dec 2020 13:13:40 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id l14so3390659ybq.3;
        Thu, 03 Dec 2020 13:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ti5mhIVq95auaPRHn01H7dvDj52ZG3ZMCcynug+Vee4=;
        b=Pqhbj/zCRAy8x15QJUIzYW/7lAbso5As4/lxENF9aFkgYzqmQAlx+E9A/Ot15YHraE
         RHZTrd+5T3pAgSLlEKBSAdxeICL3mEXsVRKiZxqT/rDQUrf5mXdETC72oh/LDRHcZDAT
         ZMpwoJvdtlzN5HbXbNpUXWmBrUfxeQSZtV2NClWDoLyvcwNgHiXwjrBfH5rwyZRHC7DM
         vGMTPI+YawfgptihV+UD5SLTcSKxAC4xKneKenB4/J5SkNKU6TcC3TI5+jsSIwAgA6dP
         hfwZ+bVKfBZTNCSqycdDzqfzenasKiywctI3cqHanRAvQ9DOyuC2F0HEj66DVytQzP3P
         d5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ti5mhIVq95auaPRHn01H7dvDj52ZG3ZMCcynug+Vee4=;
        b=jNDcMDKV4kBeksnu6tEisExHR+60SOuyFTGKOWjyL3Y5F3/bJDRi7qIVNnownMJ/Y+
         jeSdFGaMijtRpyxETLUU350eyr0Vx6t1zanWvekp4HR4lcQWGHYknPnsoBQCMUOPysNl
         U+JzmqFHHVGykpys7BN4zKECSl0j8QB3BnfZha0DDttJ3Ak8NZ6hzTeiXCbJdoOwH+L0
         UYtAqw7ikabuE5Vbv3OUFPwkvFr6pt4H+8K4s88fo85mHphjJnxrCwsX3iOObzJlvN+O
         923Sxo2fjEyxv+KNOE/V4l3kwUAViqp7oInXjCl7GO+KqBAz+6MqXwHr0wLXvCfv8Dbv
         +wrQ==
X-Gm-Message-State: AOAM531mu8lPqG1VkWrw6QGzpjUNj6tMfSLFl9J08tFF25ajhCb8Ro/5
        t9tTuNsnq65dBqbDRN2rKK5Hpg2UcIw01cYVy/gI+CYKVP4oyQ==
X-Google-Smtp-Source: ABdhPJyQc8sLoVD0AxJW+jx/HXOW8k2mGz4m1a4ZPqgxxuCfGaJD6TwdC2qET7E0iPygrAL1S11ymIjz1aUida5S/w0=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr1529792ybg.230.1607030019773;
 Thu, 03 Dec 2020 13:13:39 -0800 (PST)
MIME-Version: 1.0
References: <20201202194532.12879-1-dev@der-flo.net> <20201202194532.12879-3-dev@der-flo.net>
In-Reply-To: <20201202194532.12879-3-dev@der-flo.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Dec 2020 13:13:29 -0800
Message-ID: <CAEf4BzbgH4Ezo-LmP0i=bMzT07vo2nfgB6ossnGHCDsRXBi8yg@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: Avoid errno clobbering
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 11:46 AM Florian Lehner <dev@der-flo.net> wrote:
>
> Print a message when the returned error is about a program type being
> not supported or because of permission problems.
> These messages are expected if the program to test was actually
> executed.
>
> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> Signed-off-by: Florian Lehner <dev@der-flo.net>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 26 +++++++++++++++++----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index ceea9409639e..86ef28dd9919 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -875,19 +875,35 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>         __u8 tmp[TEST_DATA_LEN << 2];
>         __u32 size_tmp = sizeof(tmp);
>         uint32_t retval;
> -       int err;
> +       int err, saved_errno;
>
>         if (unpriv)
>                 set_admin(true);
>         err = bpf_prog_test_run(fd_prog, 1, data, size_data,
>                                 tmp, &size_tmp, &retval, NULL);
> +       saved_errno = errno;
> +
>         if (unpriv)
>                 set_admin(false);
> -       if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
> -               printf("Unexpected bpf_prog_test_run error ");
> -               return err;
> +
> +       if (err) {
> +               switch (saved_errno) {
> +               case 524/*ENOTSUPP*/:
> +                       printf("Did not run the program (not supported) ");
> +                       return 0;
> +               case EPERM:
> +                       if (unpriv) {
> +                               printf("Did not run the program (no permission) ");
> +                               return 0;
> +                       }

I see people specifying /* fallthrough; */ to make explicit that we
expect falling through into default case?

> +               default:
> +                       printf("FAIL: Unexpected bpf_prog_test_run error (%s) ",
> +                               strerror(saved_errno));
> +                       return err;
> +               }
>         }
> -       if (!err && retval != expected_val &&
> +
> +       if (retval != expected_val &&
>             expected_val != POINTER_VALUE) {
>                 printf("FAIL retval %d != %d ", retval, expected_val);
>                 return 1;
> --
> 2.28.0
>
