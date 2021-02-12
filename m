Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7531A69F
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhBLVPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhBLVPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:15:34 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DBEC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 13:14:54 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id w4so874595wmi.4
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 13:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JXWZQwbzl15KXn8oM2DILUvAnBARAqG99Ga52vx+rTM=;
        b=oeprXlrAcP/gCu/IwnYsuh6RsWmh/bC1IFUtGBthLzVVMZAJTFkTsATbv6YG5Pumwr
         EoatPo2WEGewhYP3zQRHdpD+xEFagPKFDlJDub9bo206uT5Si/XEMOfT73XjLxrZ7EuW
         uSUgNi/fJpLFJC99ZbJckQzeNckoh1OA90yPw0uJUzROQUwJyG27WoXEQVj7AQGczrRt
         XUwplYpKL0eJ+l9dWJU7q8GMimBvmA4eGu48HWNDHQgl84+86yf2X+S67bL7WtqRes92
         VZfj4q0bW6VCD4sUp887KHe3w3Failke/d1FbBerMJNBk4S3V4X6TsjyZ2MUB4z/DR7B
         GA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JXWZQwbzl15KXn8oM2DILUvAnBARAqG99Ga52vx+rTM=;
        b=Uf2w1YpTYsGjoWJhqH2VPRgsrkHnWwlvtsouJ+4MLFnIJdchocm8Eofxe/cCq96khp
         EKWxyAghL5oYzAkeIp5rVzkAiHaguTs8jo+X2QG1hLCTuaKmh4VJmD5zDs0OulFYvFdk
         Z0xTiQDwPI+/OUFNdkP6uueuQsPucdzoTTtqCZ5+AQe3gyizf81mfcd/uXQnn0or6dRN
         c1oBvXtF0wsh/hoodqRWSy//kVAYjEej0w0YDXgfZ8CPs9CdYo9GYdZr3g79vVI/zTKV
         tg/8tTL+10hj8vJnzmKys9dPWNKzotjjIhwoBBNOf78Ooh4IrVRmReAkpNLUwKiKcu+1
         76bQ==
X-Gm-Message-State: AOAM531Bbsi/rWXf8wab5jiZSvWvg/JLpS2QA3kcNIWI/aC2nah+Fn0o
        kL3OiWKwsX9JEimLjAU+Np0URQ0fRBTshQ==
X-Google-Smtp-Source: ABdhPJzLVomPHZMdFRfSgRvp/94KVVWxf4YhRvm7GCQAE/3kdM3JDlI6s/pqgD65rJ/cyv+j7VWn7Q==
X-Received: by 2002:a05:600c:4857:: with SMTP id j23mr4372951wmo.66.1613164492911;
        Fri, 12 Feb 2021 13:14:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:6ca0:dfcc:de5d:f04e? (p200300ea8f1fad006ca0dfccde5df04e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:6ca0:dfcc:de5d:f04e])
        by smtp.googlemail.com with ESMTPSA id c18sm48082168wmk.0.2021.02.12.13.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 13:14:52 -0800 (PST)
Subject: Re: [PATCH 4/4] amd-xgbe: Fix network fluctuations when using 1G
 BELFUSE SFP
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
 <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4e899509-baa1-25be-b216-10c2b2ad047d@gmail.com>
Date:   Fri, 12 Feb 2021 22:14:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.02.2021 19:00, Shyam Sundar S K wrote:
> Frequent link up/down events can happen when a Bel Fuse SFP part is
> connected to the amd-xgbe device. Try to avoid the frequent link
> issues by resetting the PHY as documented in Bel Fuse SFP datasheets.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 1bb468ac9635..e328fd9bd294 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -922,6 +922,12 @@ static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
>  	if ((phy_id & 0xfffffff0) != 0x03625d10)
>  		return false;
>  
> +	/* Reset PHY - wait for self-clearing reset bit to clear */
> +	reg = phy_read(phy_data->phydev, 0x00);
> +	phy_write(phy_data->phydev, 0x00, reg | 0x8000);
> +	read_poll_timeout(phy_read, reg, !(reg & 0x8000) || reg < 0,
> +			  10000, 50000, true, phy_data->phydev, 0x0);
> +

Why don't you simply use genphy_soft_reset() ?
Also it's not too nice to use magic register and bit numbers,
there are constants available, e.g. 0x00 = MII_BMCR

>  	/* Disable RGMII mode */
>  	phy_write(phy_data->phydev, 0x18, 0x7007);
>  	reg = phy_read(phy_data->phydev, 0x18);
> 

