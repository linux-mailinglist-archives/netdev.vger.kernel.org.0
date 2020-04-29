Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFB1BE4BC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 19:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgD2RGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 13:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2RGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 13:06:23 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45A1C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 10:06:22 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so3431781wrb.8
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 10:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aEPxyvXnmrv0lKzfPZxfPT+WsKfMDsaiPIWT0QzMmGU=;
        b=Vvzlc+92zBUg7NoL8uR2ONhMRjiE8WfIi3pGGh/0CTZmBVlXSdKDQA4Oj5cVwxbu/E
         9st5sr0qKh43Pn4vT/iIM+ujs0nRoaAF+IGdb82JG76v0fJO4VYsQoMh5kVMVfuPETtB
         GlcOqTNS0g+3hDBu7bk4lWy7gNf9TuHSOivY54ru6GXYHG1lfkMnzeEitDUUEqChTqsD
         /ur9PNKX70lixznCpKVP+sYRhTyjVtNZFVdpr3mCJB8/5NULtCxDLybeFgINVtLXUV9Q
         C5CwJNIWTMhPV80xgt/tPjksXJGMO9ii2MfkyiylEN1WkeZIpP+rXcv2c36Mr7C/auV+
         iBYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aEPxyvXnmrv0lKzfPZxfPT+WsKfMDsaiPIWT0QzMmGU=;
        b=fK+6vqwvwWnqj4MCIXlaWIp0bk8UmbXreiLiKWYP/CCRCTkTwLO/I46bLFnCHHJf3b
         90jZXGlA7dqNDkXb3bBZZDBjEik0miqVRwT2ksmj431ZJArda0N/L1gtBPXVhwXs+gqB
         AT8tZBzYIOhj3st/JERose5k3oT8QRV5Bi0EAXUag2bcd9z5x10bF2w7W0Um1vRqFFd6
         wRTeodoeacTW+mTF8EXKA96B+Iy8MTm1bd45xDAyszyabYVRgANziY0l9J1GYeVpg1PV
         DVmK7i0f+UEWcr/JJvr2yfG1vzT4fteczR5DWbrE6BSBUIZA9YSDGH2xQ1hvhd3lbq81
         nPyg==
X-Gm-Message-State: AGi0Pubujnsed9MOl2K1tkEwtcSs/kfFhmq18f56QMqLehVKdjQpBOtX
        vcS2YZcns0swG/Pe0vJ15WU=
X-Google-Smtp-Source: APiQypJhM7mszMg6zpXF1ZOwC1flfusD5OcI2WvosbF2Mlkzo94se+Dq9o0BgEXu/VQbI8vLorTL6A==
X-Received: by 2002:a5d:6148:: with SMTP id y8mr39259342wrt.236.1588179981628;
        Wed, 29 Apr 2020 10:06:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f44:e300:74d0:2441:790c:f026? (p200300EA8F44E30074D02441790CF026.dip0.t-ipconnect.de. [2003:ea:8f44:e300:74d0:2441:790c:f026])
        by smtp.googlemail.com with ESMTPSA id x23sm8034484wmj.6.2020.04.29.10.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 10:06:21 -0700 (PDT)
Subject: Re: [PATCH 2/2] Reset PHY in phy_init_hw() before interrupt
 configuration
To:     "Badel, Laurent" <LaurentBadel@eaton.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
References: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <338bd206-673d-6f3e-0402-822707af5075@gmail.com>
Date:   Wed, 29 Apr 2020 19:06:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.04.2020 11:03, Badel, Laurent wrote:
> ﻿Description: this patch adds a reset of the PHY in phy_init_hw() 
> for PHY drivers bearing the PHY_RST_AFTER_CLK_EN flag.
> 
> Rationale: due to the PHY reset reverting the interrupt mask to default, 
> it is necessary to either perform the reset before PHY configuration, 
> or re-configure the PHY after reset. This patch implements the former
> as it is simpler and more generic. 
> 
> Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add phy_reset_after_clk_enable() support")
> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
> 
> ---
>  drivers/net/phy/phy_device.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 28e3c5c0e..2cc511364 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1082,8 +1082,11 @@ int phy_init_hw(struct phy_device *phydev)
>  {
>  	int ret = 0;
>  
> -	/* Deassert the reset signal */
> -	phy_device_reset(phydev, 0);
> +	/* Deassert the reset signal
> +	 * If the PHY needs a reset, do it now
> +	 */
> +	if (!phy_reset_after_clk_enable(phydev))

If reset is asserted when entering phy_init_hw(), then
phy_reset_after_clk_enable() basically becomes a no-op.
Still it should work as expected due to the reset signal being
deasserted. It would be worth describing in the comment
why the code still works in this case.

> +		phy_device_reset(phydev, 0);
>  
>  	if (!phydev->drv)
>  		return 0;
> 

