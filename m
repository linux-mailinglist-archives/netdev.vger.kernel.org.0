Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C9310E11C
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 10:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfLAI51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 03:57:27 -0500
Received: from rfvt.org.uk ([37.187.119.221]:34164 "EHLO rfvt.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfLAI51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 03:57:27 -0500
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id 64D3D80260;
        Sun,  1 Dec 2019 08:57:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1575190643;
        bh=29cszX6aZLgHdNyNDyMwbejh5VGlamLD7vKvb4ThRiI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=wAx4IxYLS0NRDagp+wfH+Ag9ewx1jaGjViyA0ceH48zGpPHOgIYAWPWMhsqPGmG9j
         C4422tU4U0jHjKPWN5hBK5Njab+muLKSRYMxPIC4EQiul7RozL8Ttvfi+YamSraLoJ
         n0EJJF65aBA2sEMFp0a0hruw4yy/piadLBDBvNHuCBceI+PA8cddIb3+AzF2wLY8Nq
         F4ObViihB0kVDB3zz1TAekWOS1g+j35p5+vijoUHmMixZSR8qxAS8abBkeTHlnnz87
         jATGMSN8GkONGznKJ/M/g4OIL0ndp0ClhhXUVoWh1H3BoqR3BNzMMDb9GAU//qAUT3
         X5R5O6/iNZmIA==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24035.32883.173899.812456@wylie.me.uk>
Date:   Sun, 1 Dec 2019 08:57:23 +0000
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: 5.4 Regression in r8169 with jumbo frames - packet loss/delays
In-Reply-To: <75146b50-9518-8588-81fa-f2811faf6cca@gmail.com>
References: <24034.56114.248207.524177@wylie.me.uk>
        <75146b50-9518-8588-81fa-f2811faf6cca@gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

at 22:37 on Sat 30-Nov-2019 Heiner Kallweit (hkallweit1@gmail.com) wrote:

> Thanks for the report. A jumbo fix for one chip version may have
> revealed an issue with another chip version. Could you please try
> the following?
> I checked the vendor driver r8168 and there's no special sequence
> to configure jumbo mode.
> 
> What would be interesting:
> Do you set the (jumbo) MTU before bringing the device up?
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 0b47db2ff..38d212686 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3873,7 +3873,7 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
>  		r8168dp_hw_jumbo_enable(tp);
>  		break;
> -	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
> +	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
>  		r8168e_hw_jumbo_enable(tp);
>  		break;
>  	default:
> -- 
> 2.24.0

That patch fixes the issue for me.

Thanks

Alan

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
