Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14DA3496E0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhCYQdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCYQc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:32:56 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC10C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:32:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ce10so3951599ejb.6
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CkLdbIpO84das4CVKNn98yiEzuAPlx98+qWEgnoAGiw=;
        b=moS/Vpv2QRSU5NbkkmEOsuqG3YCJZW3aOKlhHcRRJqr/wpk4MK8UzN0BdvMn3oJPH/
         rwO6/hgqPLHK17RtJFcM/sjVc4NuoM1d+UBf1tnrG2kaybKQBt2aoxyqBiywL1fO1hfV
         HEgUS8cQlLl+Guw7o4zX+Z14mcqrVBQ0GukzuNbM+MlqnCMewECyUBNVkTZDuGrNCANh
         7ZFX/2SNtiH+B9HqdW0PqWPZgWj2yEUI6Fgf3iNOoGbM15URth5DzIMMtZfc+ISRKYTc
         ukTMZlpy0s96iiSxAuQGE5WK38nGya7D8aOQKGHZ3uOCx6PaNl4jBmebfvHyQT+a8d0G
         mXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CkLdbIpO84das4CVKNn98yiEzuAPlx98+qWEgnoAGiw=;
        b=noR+j+Winx8xR3CgIceu+wBuaEodLoqgwkPS9fhkseUOB00h6GrZktUQHC/58f+VgY
         EDl5JwJidz81ElsDKRyHEebehUrseVm/b4HtgnQLXaV6vH+9v0JdTPZj0SzswNyr3hy0
         iQs2Kow6zNjQF/eEJgSciKtKzr3EQiOo7VCzO1SpqNORxTJIv+hC4xlKwX367vLGelfE
         tgugtOCf3HbLn7fMdykMa+8URRzrVsuwLsi52gFUQNo+s9uftWsVxckFd0sEiyvvlnh4
         yV0U6nDCcO9JbvuIgoa8kKAfhfaaj5b2I59BqKtFUZ+H8eOi3OcHYtGPb34iqzvs+tzW
         4AtA==
X-Gm-Message-State: AOAM532wRbvG/G6WpC7PgRbdUIBEYapupogYPf/NpPWoY6mfF5ec5bEM
        68zgI9N4Kv87qQ/nfsXfLv4PLotea0G4m3ogxvNF7A==
X-Google-Smtp-Source: ABdhPJwROsHupQrY++NQYuFWNnoav7uWGR6aKXCmw+srCYehHjt5CYtVFjF5JyReijJCQqT3QbE+hT6PtqpqPEnrhsY=
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr10218627ejb.503.1616689974377;
 Thu, 25 Mar 2021 09:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210323080229.28283-1-yangbo.lu@nxp.com>
In-Reply-To: <20210323080229.28283-1-yangbo.lu@nxp.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Mar 2021 22:02:43 +0530
Message-ID: <CA+G9fYuwh0QF7PwdYW9-QEGE909-a5y5Xqh7ki=ppUyDDHtyQA@mail.gmail.com>
Subject: Re: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI,

On Tue, 23 Mar 2021 at 13:26, Yangbo Lu <yangbo.lu@nxp.com> wrote:
>
> Current calculation for diff of TMR_ADD register value may have
> 64-bit overflow in this code line, when long type scaled_ppm is
> large.
>
> adj *= scaled_ppm;
>
> This patch is to resolve it by using mul_u64_u64_div_u64().
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/ptp/ptp_qoriq.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
> index 68beb1bd07c0..f7f220700cb5 100644
> --- a/drivers/ptp/ptp_qoriq.c
> +++ b/drivers/ptp/ptp_qoriq.c
> @@ -189,15 +189,16 @@ int ptp_qoriq_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>         tmr_add = ptp_qoriq->tmr_add;
>         adj = tmr_add;
>
> -       /* calculate diff as adj*(scaled_ppm/65536)/1000000
> -        * and round() to the nearest integer
> +       /*
> +        * Calculate diff and round() to the nearest integer
> +        *
> +        * diff = adj * (ppb / 1000000000)
> +        *      = adj * scaled_ppm / 65536000000
>          */
> -       adj *= scaled_ppm;
> -       diff = div_u64(adj, 8000000);
> -       diff = (diff >> 13) + ((diff >> 12) & 1);
> +       diff = mul_u64_u64_div_u64(adj, scaled_ppm, 32768000000);

While building Linux next 20210325 tag for powerpc architecture ppc6xx_defconfig
failed due to following warnings / errors.

 - powerpc (ppc6xx_defconfig) with gcc-8
 - powerpc (ppc6xx_defconfig) with gcc-9
 - powerpc (ppc6xx_defconfig) with gcc-10

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=powerpc
CROSS_COMPILE=powerpc64le-linux-gnu- 'CC=sccache
powerpc64le-linux-gnu-gcc' 'HOSTCC=sccache gcc'

INFO: Uncompressed kernel (size 0xd985ec) overlaps the address of the
wrapper(0x400000)
INFO: Fixing the link_address of wrapper to (0xe00000)
INFO: Uncompressed kernel (size 0xd985ec) overlaps the address of the
wrapper(0x400000)
INFO: Fixing the link_address of wrapper to (0xe00000)
INFO: Uncompressed kernel (size 0xd985ec) overlaps the address of the
wrapper(0x400000)
INFO: Fixing the link_address of wrapper to (0xe00000)
ERROR: modpost: "mul_u64_u64_div_u64" [drivers/ptp/ptp-qoriq.ko] undefined!

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Steps to reproduce:
-------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch powerpc --toolchain gcc-8
--kconfig ppc6xx_defconfig

-- 
Linaro LKFT
https://lkft.linaro.org
