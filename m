Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47618DE56C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfJUHkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:40:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37932 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbfJUHkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 03:40:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id 3so11639951wmi.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 00:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ng56756ED51t/eT9lLH6m7o//0HHRK3T616Ko5nMUy4=;
        b=JA44TSOevliTPlhq00H9jaQeWe9uV4f8ob6IKN+5ArgMRESMEfxOuOwA3pFNDpzNFT
         +uieIYUtGo+lxiQKUFmMmIj8m2Vnhl2yxpm3mPLokaeA2ypFFtayhjrmEPvgYUR+Rz2h
         6roSCiET7zBlLikT+HWaypk8sKnn82tKqWEgJpsYsHRaHB4R42miY2nNef47BYOQZcvs
         mlo21tyQRRysvV3RfINhnY8glvCrPvm5P50ZR8Jdw2SFfBEk/K8zUimZg5bftIPJWAc1
         RoLNI8huBgZ8kLsfEuYgqJ1Y+7gOtVPHw2/x8lww50+HwmtObJ2vxkEeakvF5BCN9fQf
         0ACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ng56756ED51t/eT9lLH6m7o//0HHRK3T616Ko5nMUy4=;
        b=rzOO/QAXAOR5PTSL1Zxh4Zhq6YsnR4TiuttA0eXEYtygvgdcD2DTMv+q1TLv8JGtRC
         YhCJMJuPbm976j2+De58lD+eIU9hC6c+yqe2tYa4I1iIZpHT8V6nmWU/qg1KDK2zsDmD
         XrCfnDnZ70A7sy93cRAa9dP4fYajtoVMsSvmrLTrBIcpl00TwwiPnbLTvzfnSbCHCek4
         zxoJf3OTavz582yoBR37BVoID48zBt70IDd7ag49XFyd48LUMzTtTfwepLbp+L5aiEsm
         EPrXew3LtZMHz8mc/WWJADBLVmrcIWTKvQjOcrEvazlgg0nvSd3yhsJ+IbU44p9Rbjmq
         ueKQ==
X-Gm-Message-State: APjAAAUxLcp+kMWyscJY54KH7e6lQdFZ7doqKV3U3Kj6Go7W5SeyzfZB
        9pXgueSVIDevItMlNq/onbTnbijjPZs=
X-Google-Smtp-Source: APXvYqwjX7Tcab+POgt1uxmBgvVx7fZVvygGXYz3lncy8zOk0TCoO/yaEIjHAWP1xgza0wVzKLuXUw==
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr2009378wme.92.1571643633158;
        Mon, 21 Oct 2019 00:40:33 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id g69sm1427055wme.31.2019.10.21.00.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 00:40:32 -0700 (PDT)
Date:   Mon, 21 Oct 2019 09:40:31 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Russell King <rmk@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH 1/3] ethtool: correctly interpret bitrate of 255
Message-ID: <20191021074030.GB4486@netronome.com>
References: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:31:13PM +0100, Russell King wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> A bitrate of 255 is special, it means the bitrate is encoded in
> byte 66 in units of 250MBaud.  Add support for parsing these bit
> rates.

Hi Russell,

it seems from the code either that 0 is also special or its
handling has been optimised. Perhaps that would be worth mentioning
in the changelog too.

> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  sfpid.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/sfpid.c b/sfpid.c
> index a1753d3a535f..71f0939c6282 100644
> --- a/sfpid.c
> +++ b/sfpid.c
> @@ -328,11 +328,24 @@ void sff8079_show_all(const __u8 *id)
>  {
>  	sff8079_show_identifier(id);
>  	if (((id[0] == 0x02) || (id[0] == 0x03)) && (id[1] == 0x04)) {
> +		unsigned int br_nom, br_min, br_max;
> +
> +		if (id[12] == 0) {
> +			br_nom = br_min = br_max = 0;
> +		} else if (id[12] == 255) {
> +			br_nom = id[66] * 250;
> +			br_max = id[67];
> +			br_min = id[67];
> +		} else {
> +			br_nom = id[12] * 100;
> +			br_max = id[66];
> +			br_min = id[67];
> +		}
>  		sff8079_show_ext_identifier(id);
>  		sff8079_show_connector(id);
>  		sff8079_show_transceiver(id);
>  		sff8079_show_encoding(id);
> -		sff8079_show_value_with_unit(id, 12, "BR, Nominal", 100, "MBd");
> +		printf("\t%-41s : %u%s\n", "BR, Nominal", br_nom, "MBd");
>  		sff8079_show_rate_identifier(id);
>  		sff8079_show_value_with_unit(id, 14,
>  					     "Length (SMF,km)", 1, "km");
> @@ -348,8 +361,8 @@ void sff8079_show_all(const __u8 *id)
>  		sff8079_show_ascii(id, 40, 55, "Vendor PN");
>  		sff8079_show_ascii(id, 56, 59, "Vendor rev");
>  		sff8079_show_options(id);
> -		sff8079_show_value_with_unit(id, 66, "BR margin, max", 1, "%");
> -		sff8079_show_value_with_unit(id, 67, "BR margin, min", 1, "%");
> +		printf("\t%-41s : %u%s\n", "BR margin, max", br_max, "%");
> +		printf("\t%-41s : %u%s\n", "BR margin, min", br_min, "%");
>  		sff8079_show_ascii(id, 68, 83, "Vendor SN");
>  		sff8079_show_ascii(id, 84, 91, "Date code");
>  	}
> -- 
> 2.7.4
> 
