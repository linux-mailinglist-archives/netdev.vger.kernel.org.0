Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC2345B06
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 10:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCWJiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 05:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCWJiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 05:38:04 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54006C061574;
        Tue, 23 Mar 2021 02:38:04 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b9so20032852wrt.8;
        Tue, 23 Mar 2021 02:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dRxUTJo1X4YBpeS2eupNc6JnBsfiVUk5WuMPy/AR7a8=;
        b=gwDKmRCwCbwC3dNsrSg3pVXJzFnqegym3ikkXFkwlo0YFRc5O5VbJfq9TSkCdpAVot
         B49qSRixTZQeVlmjerDTMawFcZhk1C6tmh8h+8scpD8ZtJIpg+zbfRIBlwWQbwkQGbw4
         g+R1+w/Gw7n+56iKI80UE3EgJepQCrdgdq+jrKLlw7kNQJxmbzSkzLAxeuY0x+cOYdAg
         nxsfSEIzkjJUAoZgbj00pAVoihK4C8eM7NJqRNLBQzrclIDr/LLC+7FLyfmZuQmi1OwX
         mOuAgQZV153gF6daP3nvb3av75tbexAYyaD1ws8oJelx5UWgSnuqKGO+Lz3uWKKjPWPF
         ki7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dRxUTJo1X4YBpeS2eupNc6JnBsfiVUk5WuMPy/AR7a8=;
        b=NdroveaYOTgWhngv4LSFu5GKw/ZO7b/T2Seja6CIWEAllVqo9c5xjNaGsdpDTOwWgR
         MtDWvdsQp2vw6/NW59uVBDy5QU8b9fDTyzeij2jo4resl7Pg+OwLNDkzI6CYOr4XEpyN
         cv4hnXo3/kMNL4hzmxGMNJvuOYSApdrqq4/NylatUWoaAvH1Fq86gf9lOBzGNwADv9Aa
         /HJilVTHJSz0/ulNp7LD0KnIWeoFhhaWkThBr/+OYyOZ09hqSYhEc3ORnutASIDVptiV
         OLDPjdUugqYZcJbZFttJ8Plm1bBeLSGZ2uFfPf+v48hFs4nnLevzL9PN9i6mdmbhB/Z0
         Cc+w==
X-Gm-Message-State: AOAM532XZ67Uvn2a0mzs8s5mpUqKzPRMhLCOR6tB4GJme1c1sK5/84vH
        zt6M+CbeLh4Hz8zmxH7oTBo=
X-Google-Smtp-Source: ABdhPJwfvqv+gNfmNDK5/2l00PPx6Nk/bJVl4cadI5OHQGWd4ggfrWBKix0g0DS91B3ZVsqUMKKg/w==
X-Received: by 2002:a5d:5411:: with SMTP id g17mr3022647wrv.194.1616492283005;
        Tue, 23 Mar 2021 02:38:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:ddd2:d1dc:586d:77c1? (p200300ea8f1fbb00ddd2d1dc586d77c1.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:ddd2:d1dc:586d:77c1])
        by smtp.googlemail.com with ESMTPSA id u3sm22982109wrt.82.2021.03.23.02.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 02:38:02 -0700 (PDT)
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boong Leong <boon.leong.ong@intel.com>
References: <20210323084853.25432-1-vee.khee.wong@linux.intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add PHY loopback
 support for 88E2110 PHY
Message-ID: <1745f2b8-b5f9-dc2a-20e4-6a8fd0e7b2d4@gmail.com>
Date:   Tue, 23 Mar 2021 10:37:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323084853.25432-1-vee.khee.wong@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.03.2021 09:48, Wong Vee Khee wrote:
> From: Tan Tee Min <tee.min.tan@intel.com>
> 
> Add support for PHY loopback for the Marvell 88E2110 PHY.
> 
> This allow user to perform selftest using ethtool.
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/phy/marvell10g.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index b1bb9b8e1e4e..c45a8f11bdcf 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -89,6 +89,8 @@ enum {
>  	MV_V2_TEMP_CTRL_DISABLE	= 0xc000,
>  	MV_V2_TEMP		= 0xf08c,
>  	MV_V2_TEMP_UNKNOWN	= 0x9600, /* unknown function */
> +
> +	MV_LOOPBACK		= BIT(14), /* Loopback (88E2110 only) */

Why do you state 88E2110 only?
This is the standard PCS loopback bit as described in clause 45.2.3.1.2
It's defined already as MDIO_PCS_CTRL1_LOOPBACK.
E.g. the 88x3310 spec also describes this bit.

>  };
>  
>  struct mv3310_priv {
> @@ -765,6 +767,15 @@ static int mv3310_set_tunable(struct phy_device *phydev,
>  	}
>  }
>  
> +static int mv3310_loopback(struct phy_device *phydev, bool enable)
> +{
> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88E2110)
> +		return -EOPNOTSUPP;

If you use the function in the 2110 PHY driver only, then why this check?
And why name it 3310 if it can be used with 2110 only?

This function uses c45 standard functionality only, therefore it should
go to generic code (similar to genphy_loopback for c22).


> +
> +	return phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_PCS_BASE_T,
> +			      MV_LOOPBACK, enable ? MV_LOOPBACK : 0);
> +}
> +
>  static struct phy_driver mv3310_drivers[] = {
>  	{
>  		.phy_id		= MARVELL_PHY_ID_88X3310,
> @@ -796,6 +807,7 @@ static struct phy_driver mv3310_drivers[] = {
>  		.get_tunable	= mv3310_get_tunable,
>  		.set_tunable	= mv3310_set_tunable,
>  		.remove		= mv3310_remove,
> +		.set_loopback	= mv3310_loopback,
>  	},
>  };
>  
> 

