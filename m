Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618504422C7
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 22:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhKAVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 17:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKAVkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 17:40:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDF4C061714;
        Mon,  1 Nov 2021 14:37:40 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b2-20020a1c8002000000b0032fb900951eso261063wmd.4;
        Mon, 01 Nov 2021 14:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=a/iBGqw2NIrXj3sQARZGGrb2Lhi9C/NDYbdc3fbJ4bo=;
        b=XmgNCH+7IGKsc5JaWK3EoncNu2ThZekliSmnIN5c2h43ipT7fMrTc0305In+vEcFzN
         HxEIfvhHt3QefexJedq991c2RmOS1wbXu5dCq541o24HRYDsBw6luYB+11dSmilJZcuF
         tLrJaeFF+QO9/vGraEC8LrPZvJEPuDUeMn8GsiSEwgBAPMXFBam4uJcKjEjIajF5JOSg
         5GS7flpib5NZ/H6gADc2LCxEjHUSo4THNpOD16/yl2PVpyshAZQkx5Qx5rIELVvr26gB
         DXasM4UUEyyM9AYrK4Q0QRD7lxpdXQ1yzCi/aroLdjzMsJErwEuUtkP9xBOK7ZXCQTM/
         a2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=a/iBGqw2NIrXj3sQARZGGrb2Lhi9C/NDYbdc3fbJ4bo=;
        b=EZdUlCn2yTyVa0/NaCvWBZodQ7CDcNBUCVrXExjqHnXJRgchR89aFLp8eaiYP6dpC5
         fpek6IN2R7Zgkamf/omKIRm8lBF1FPnU2v+aw7bfYnkSXck2BgM9ACxJF/z9gVX5MuIN
         kqeS2Hh0byjqZMohHRYBLUkOg4wlsmUwyOtiQNQXAT2T6EftBmJRl5+8qg0xiI2MFD84
         AZrW53tHxpTtF/F2MBON8Civ85zORQqz2360DOAyWMULz2Awu22pF4SQ5XfiD0s7uuAF
         2AwzyWHvXIjtILP1BuWDddNIuX/Z3i3l0syPZidTrLhbdnhwUSYw1kn/A8judDZN8bo1
         xxKA==
X-Gm-Message-State: AOAM531vB5ZTRYUuudPTmUcCPLJ5Y8JXfWE6OY88A+zzikUz1Odl6/Pb
        LdaZIa3dPVBByY9El+j5v4pOq3MXR5w=
X-Google-Smtp-Source: ABdhPJxLfe00+Xn0aI0xYvzRX7Jiym+bcbL3q3hLKXSHHwkWvxrYSIojo3VDc8Bxd4DmNpzD6skCpg==
X-Received: by 2002:a1c:1fd6:: with SMTP id f205mr1855477wmf.98.1635802658796;
        Mon, 01 Nov 2021 14:37:38 -0700 (PDT)
Received: from ?IPV6:2003:ea:8f1a:f00:7d73:a9fc:189f:a5e5? (p200300ea8f1a0f007d73a9fc189fa5e5.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:7d73:a9fc:189f:a5e5])
        by smtp.googlemail.com with ESMTPSA id m12sm640123wms.25.2021.11.01.14.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:37:38 -0700 (PDT)
Message-ID: <717f16a3-e25b-bb3d-5e73-1a0397f351de@gmail.com>
Date:   Mon, 1 Nov 2021 22:37:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Content-Language: en-US
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1635759875-5927-1-git-send-email-zhangchangzhong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: fix duplex out of sync problem while
 changing settings
In-Reply-To: <1635759875-5927-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.11.2021 10:44, Zhang Changzhong wrote:
> Before commit 2bd229df5e2e ("net: phy: remove state PHY_FORCING") if
> phy_ethtool_ksettings_set() is called with autoneg off, phy_start_aneg()
> will set phydev->state to PHY_FORCING, so adjust_link will always be
> called.
> 
> But after that commit, if phy_ethtool_ksettings_set() changes the local
> link from 10Mbps/Half to 10Mbps/Full when the link partner is
> 10Mbps/Full, phy_check_link_status() will not trigger the link change,
> because phydev->link and phydev->state has not changed. This will causes
> the duplex of the PHY and MAC to be out of sync.
> 
> Fix it by re-adding the PHY_FORCING state to force adjust_link to be
> called in fixed mode.
> 
> Fixes: 2bd229df5e2e ("net: phy: remove state PHY_FORCING")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/phy/phy.c | 10 ++++++++--
>  include/linux/phy.h   |  6 ++++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index a3bfb15..b114f15 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -49,6 +49,7 @@ static const char *phy_state_to_str(enum phy_state st)
>  	PHY_STATE_STR(UP)
>  	PHY_STATE_STR(RUNNING)
>  	PHY_STATE_STR(NOLINK)
> +	PHY_STATE_STR(FORCING)
>  	PHY_STATE_STR(CABLETEST)
>  	PHY_STATE_STR(HALTED)
>  	}
> @@ -724,8 +725,12 @@ static int _phy_start_aneg(struct phy_device *phydev)
>  	if (err < 0)
>  		return err;
>  
> -	if (phy_is_started(phydev))
> -		err = phy_check_link_status(phydev);
> +	if (phy_is_started(phydev)) {
> +		if (phydev->autoneg == AUTONEG_ENABLE)
> +			err = phy_check_link_status(phydev);
> +		else
> +			phydev->state = PHY_FORCING;
> +	}
>  
>  	return err;
>  }
> @@ -1120,6 +1125,7 @@ void phy_state_machine(struct work_struct *work)
>  		needs_aneg = true;
>  
>  		break;
> +	case PHY_FORCING:
>  	case PHY_NOLINK:
>  	case PHY_RUNNING:
>  		err = phy_check_link_status(phydev);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 736e1d1..e639729 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -446,6 +446,11 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
>   * - irq or timer will set @PHY_NOLINK if link goes down
>   * - phy_stop moves to @PHY_HALTED
>   *
> + * @PHY_FORCING: PHY is being configured with forced settings.
> + * - if link is up, move to @PHY_RUNNING
> + * - if link is down, move to @PHY_NOLINK
> + * - phy_stop moves to @PHY_HALTED
> + *
>   * @PHY_CABLETEST: PHY is performing a cable test. Packet reception/sending
>   * is not expected to work, carrier will be indicated as down. PHY will be
>   * poll once per second, or on interrupt for it current state.
> @@ -463,6 +468,7 @@ enum phy_state {
>  	PHY_UP,
>  	PHY_RUNNING,
>  	PHY_NOLINK,
> +	PHY_FORCING,
>  	PHY_CABLETEST,
>  };
>  
> 

I see your point, but the proposed fix may not be fully correct. You rely
on the phylib state machine, but there are drivers that use
phy_ethtool_ksettings_set() and some parts of phylib but not the phylib
state machine. One example is AMD xgbe.

Maybe the following is better, could you please give it a try?
By the way: With which MAC driver did you encounter the issue?


diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb156c..beb2b66da 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -815,7 +815,12 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	_phy_start_aneg(phydev);
+	if (phy_is_started(phydev)) {
+		phydev->state = PHY_UP;
+		phy_trigger_machine(phydev);
+	} else {
+		_phy_start_aneg(phydev);
+	}
 
 	mutex_unlock(&phydev->lock);
 	return 0;
-- 
2.33.1


