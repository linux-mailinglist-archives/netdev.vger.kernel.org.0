Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE762432995
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 00:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhJRWL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJRWL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 18:11:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1E3C06161C;
        Mon, 18 Oct 2021 15:09:44 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ez7-20020a17090ae14700b001a132a1679bso511088pjb.0;
        Mon, 18 Oct 2021 15:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H5plDVfLym4DCxkqi3A/lCSwKMy22F+3nE8YU1+Fk3Q=;
        b=LjpXS+VX5QSEGF0MgldKc3k+G6Hm7VxokQXKoDlp0qOczGF/hw9ZZ2Ad2e+H6x02Wx
         Cc+3fetHNJQkhzxHFQaUkcNZihZVJ82lCT62+fUL9kEMXXuJAJKnER355qupbtd8Q7bY
         IhzGkAyrMww/R3r8E52VEtRAcjK/ZuHsg7ct4ONSiZvUTvc3SEHb5vwMZQLKg2t8mOqF
         5NeT3DDEG/dK/MQLV2HHqKMU/LnlISfGx01f5H9SumlhEM8RXjsaoUTLTZ3YJRiQbAik
         aqSGY+bE8K9VeGfZblDW0ky21WLKWkRWFjnGyT713Djldm9NMb2bw0DXfwXQcw134/tg
         l3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H5plDVfLym4DCxkqi3A/lCSwKMy22F+3nE8YU1+Fk3Q=;
        b=22E46iNdTHGEEemrLWDlYuGhsXB34WfWKVzI7T5t8laW6tQnjrSBBypXzG5sgTwsJY
         L5D/4Ow8jeePpM0sFjWaIOXIpMaQvwc3Dpjbw8gy0Dv5dLLQQf92a0x0GUxqJnscCMmU
         ApKqPGnlHz6Hodw+ltvvh6UhVG/JvFPCv+euQ0JsMutq7PXFnSGF/bDo24NSrcNloiwn
         X1f6PkUGKITgHRYULqkjJ6p+gKcGeN878OjvNTtwO88KTUiWfCWnHFamKZ9W6LHHdglj
         OcQD4j7+OgirtmgxeWtY+qhaHrpyO5h9At8mgxswSj2H8oFXkbBIG3DSxyklITTxy69u
         YZyQ==
X-Gm-Message-State: AOAM5333kWbS2Hxjy4KJrpxnyJ5mmUnbYG6V7Hu01rEKVXn5F2xNHgC1
        EImTuLLYvDNZzw/btMFof9Y=
X-Google-Smtp-Source: ABdhPJwBuX0YfkZlNC4y8ARTgf6HrkKl0tTLg8jxUW8pK8tINEkVkVgQBojyZXwn5UEfhL5SfZHqBg==
X-Received: by 2002:a17:90a:3ec2:: with SMTP id k60mr1845560pjc.176.1634594983966;
        Mon, 18 Oct 2021 15:09:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k127sm14437588pfd.1.2021.10.18.15.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 15:09:43 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: Convert more users of mdiobus_* to mdiodev_*
To:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        George McCollister <george.mccollister@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20211018215448.1723702-1-sean.anderson@seco.com>
 <20211018215448.1723702-3-sean.anderson@seco.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <441bf04b-8dcf-d300-946d-3a6af72396d3@gmail.com>
Date:   Mon, 18 Oct 2021 15:09:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018215448.1723702-3-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 2:54 PM, Sean Anderson wrote:
> This converts users of mdiobus to mdiodev using the following semantic
> patch:
> 
> @@
> identifier mdiodev;
> expression regnum;
> @@
> 
> - mdiobus_read(mdiodev->bus, mdiodev->addr, regnum)
> + mdiodev_read(mdiodev, regnum)
> 
> @@
> identifier mdiodev;
> expression regnum, val;
> @@
> 
> - mdiobus_write(mdiodev->bus, mdiodev->addr, regnum, val)
> + mdiodev_write(mdiodev, regnum, val)
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> I am not too experienced with coccinelle, so pointers would be
> appreciated. In particular, is it possible to convert things like
> 
> bus = mdiodev->bus;
> addr = mdiodev->addr;
> mdiobus_foo(bus, addr, ...);
> 
> in a generic way?
> 
>  drivers/base/regmap/regmap-mdio.c       |  6 +++---
>  drivers/net/dsa/xrs700x/xrs700x_mdio.c  | 12 ++++++------
>  drivers/phy/broadcom/phy-bcm-ns-usb3.c  |  2 +-
>  drivers/phy/broadcom/phy-bcm-ns2-pcie.c |  6 ++----

For the two above:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
