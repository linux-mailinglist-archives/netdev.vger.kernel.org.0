Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE651763E4
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgCBT2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:28:07 -0500
Received: from mout.gmx.net ([212.227.15.15]:58557 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBT2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:28:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583177276;
        bh=gPV0hmp+Pnm4irFf4XIVA77MBEFeyazwRgxs8ld92Es=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=krn+qlo0Wh8a8oYTSar2jPH1Lu5iVo/cfb014ve31HJnt9p707eR5brjb+/A2XUht
         1+eShOUJ+Q66tzUaIxXtSNuMO5GMUToFBaDed9uJRnmoMHLAfJ6cFpLiVfvoJzRZAn
         mPmMD6j83cQUb2U1StB35VVHHgScer/0fLQ2OkbE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.55] ([95.90.191.58]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MsYv3-1jOaEJ2hbv-00u0bg; Mon, 02
 Mar 2020 20:27:56 +0100
Subject: Re: [PATCH v2 2/2] ag71xx: Call phylink_disconnect_phy() in case
 ag71xx_hw_enable() fails
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com
References: <20200302000208.18260-1-hauke@hauke-m.de>
 <20200302000208.18260-2-hauke@hauke-m.de>
From:   Oleksij Rempel <linux@rempel-privat.de>
Autocrypt: addr=linux@rempel-privat.de; prefer-encrypt=mutual; keydata=
 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
 Rmpernzn0GXR0xYSTiUvuvpLsoo=
Message-ID: <f5af250e-a32f-1013-92c1-a978766f984f@rempel-privat.de>
Date:   Mon, 2 Mar 2020 20:27:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302000208.18260-2-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZOBx/R8fqsJZe12Ss5p9lcsAZkwiUv+v6VE3UtT21axiveAYLDx
 EeIUyd3qovtThbq02oRdpYqImgt8ViKgy9lYIb5EJ7DmKCEfB9dOTw/4qB4I10dovmFHvM8
 KFoKyAr55N2due+984uWYk0xdEFJTzPvXHF7UGCh2RYEvQVe+eRhK0T2w8xYo5LBmkKmnbV
 63JIC7XDQPbIxEeviNPDw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DozMmiiZGko=:mOCDdVYzer9o1fB39mitmf
 s9AZ5vZ9BVt2r+hVkCaLPtnLf/ldYRpgdoGORiAeQMscyql6gLf2/XxmCfyQw+10CJW5CsVnF
 g5VQfATwhA4stss0b4p0HDulr4g/25fqePpjRobwYrOJMmBTdAPl0gSBL5dWJfnpUmgcRkMms
 /FKDIfhdtvcmOJsbKImu4X8c1eAZcdha1VdmanolttJxk3sftIgzsoIWBtBUPSgMt0NvRCP3h
 aUBrlW+/wPiUXmybCVIFGxn9ZO1d53UEC92XpMW8FHU5Wg5jZL/D15rJ3Xl9v2TnwIaBgkNkV
 BaHVSY7XUODQWo1N5sp+yH1HaI5WoLLd6hQmsemTuH74SE1fJDUyurUzTboKO+gJjMUrzdszi
 DhzFlcVCdClCTfY/5pFlz+L5htYrjVZNKfbM1duIBLAe+T1vCTlaUWzsCLO98owWpdaT+2aec
 l1qCzEuXEBUMUHAG07w+jc3ij47FJeHyRl80q9kG8vGiS3VPOFAOtFcbBdqy0QEybK6vztU3g
 wAMdtSeLRZVBTO1cszeMZNxAuqDJV/C+uRaErLd74aTwYXpJ2N5dwSIlO4k1eks/Ajng8IwJo
 xB39yHXUZw+FnxZes+xdUa2Sc2MvmzszMwiwNveYjaHZDvNYJ1fFiCHz2fxYtDZe8VhUezSSv
 ed+7+XR0Xh2xQK/LrTW1PWQjQKlGnASaWyQk35oRfJPfExSGamNeXlrJNYiyActcOy82U7Mq3
 EZOwnn1vukIWXJNKGUpNGwANUYVD99gygiZ4Q/UjJ5ZycPxUyuhhSM0bdvqUZjuQ7Dq0keu2K
 KX8ZSk4alUIUTa6etuy/eS4lOEY6Yd3dt8WCZ52G01po/usNto5JQjyWuy6KRkVWeRtO5rnPb
 abyKvCq0bDYntZDEeQwhT+kUhc8tCrJW0iv4LcpmLU23lKTuXsRGwbwBj+4Pie9T0wqgJkr/K
 NFUJom2h0O+3GB8Ff/1pOc4A9Vu8XejonrPnHcDlAg/uNmI7HdqD0LNUMVxBl5dvWCVkLaU6D
 fSSj9E6g1bfeEXwN9i0wVpc68vvSZNnFMw0SgwQ27mslRmgErlvBF2kIPte4Oo2t7jCdzeOJQ
 Aakfsu6VpELIx2bekxVI6kOYOMgdToPvLZ/cDxYlhyT1aW9Jl8zlomq23XHrxoiAQs2jrqV+x
 jQZyPQTjeuKNtKFJHXwCV0NQrwMaeaYjp4Yqc0tllBu9TU25jGQ56LZ3caaPw0zncYWYqbdfm
 u5OcT0t9xkmy+rhLJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 02.03.20 um 01:02 schrieb Hauke Mehrtens:
> The ag71xx_rings_cleanup() should already be handled in the
> ag71xx_hw_enable() in case it fails internally. In this function we
> should call phylink_disconnect_phy() in case the ag71xx_hw_enable()
> failed to get back into the old state.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")

Reviewed-by: Oleksij Rempel <linux@rempel-privat.de>

Thank you!

> ---
>
> v2:
>  * rebased onm top of "net: ag71xx: port to phylink"
>
>  drivers/net/ethernet/atheros/ag71xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/etherne=
t/atheros/ag71xx.c
> index 38683224b70b..405db37c084f 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -1313,7 +1313,7 @@ static int ag71xx_open(struct net_device *ndev)
>  	return 0;
>
>  err:
> -	ag71xx_rings_cleanup(ag);
> +	phylink_disconnect_phy(ag->phylink);
>  	return ret;
>  }
>
>


=2D-
Regards,
Oleksij
