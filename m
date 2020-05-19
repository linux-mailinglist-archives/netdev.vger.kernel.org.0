Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF001DA2D6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgESUhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgESUhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:37:52 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C42C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 13:37:51 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h17so851889wrc.8
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 13:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K1+Jy3DWdtIrZ8bpyCyjtSK3AFAvCwdBpGkzXcUAu0c=;
        b=mad5mr1mPe8/i9iG5r3ByWlzWZeea4GYARJe8a2rdEMapno3wGjY6wyWGQToFL8wkq
         MHq4nPe5mOgVo45ryP5/zQ2BURm5JH9JGla1y3jITo0DTR+soOXSvwB+nR9JNWcrS/nL
         znA79cV8KJj/+Uy2PCUBuuIP5VEjB5+TWJo1VZdgIqfTiOptzs5PuXPJmBC3aoUDyx5d
         CywSdbfh7+Cf/9BPaN4aRlu693YsxFkdCs3JYpswn8X5ZrBDooGoAEtJxYMd2l0NESUc
         vi5V8HTRlmoKa+A7JyyPzndEYafNIKfzYo6ac88Tzv0CUKyAfkon4n26JrcOagtmpOpT
         oF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K1+Jy3DWdtIrZ8bpyCyjtSK3AFAvCwdBpGkzXcUAu0c=;
        b=Jp0L5DjvlSMxo6lsEgUdp/keOoyPakVhU1bvvPSFlmnE773+6jHfalrD5CskshmHW9
         ImUGprlM2eMBG0k1ZD985VRPHafLee5d1Djiq3LrvUO/7yGSZkSXaHwnxlF+ZBwGjqJ3
         8g1brWe+OPY50nD65NBN65V+TwCNPlFTP2MhMG2A+gjUxNnEkk+t10PoS/pD8p79IjLI
         yDgi4w1pY7B137SBky8uZEHICl7fw0xqwihLv75CU29t7+TY//9ZSkYaITP0pIv2GmOG
         ZliwO9pt+i7jMo8a/t8bu99WyMbmSe5L9z+tsE2oL1hWmkpGr/EPbd50U7y8Yx/55Fqa
         EUpg==
X-Gm-Message-State: AOAM532f4m3J+Irxx/7Nla7vG0qiQsZ+wreBWr7VpoYf1pYk1AL2vTTg
        g2DZhBQcCT/0KlJwpRkrfXY=
X-Google-Smtp-Source: ABdhPJxMlCYdpktqved7RTqbzIVcV5D9He/JyUqnzdepZclCyrqpBO5Kvry7mbOuKMdTIDvHu85KHA==
X-Received: by 2002:adf:9482:: with SMTP id 2mr661199wrr.328.1589920670453;
        Tue, 19 May 2020 13:37:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:5dfe:2e4f:3d0d:daaa? (p200300ea8f2852005dfe2e4f3d0ddaaa.dip0.t-ipconnect.de. [2003:ea:8f28:5200:5dfe:2e4f:3d0d:daaa])
        by smtp.googlemail.com with ESMTPSA id w15sm559764wrl.73.2020.05.19.13.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 13:37:49 -0700 (PDT)
Subject: Re: phydev control race condition while AUTONEG_DISABLE
To:     Val Jurin <valjurin@nsg.net.ru>
References: <5c5ee244-d40c-4e34-8652-a3f82b453543@nsg.net.ru>
 <0b91c527-0cc3-f37a-9ce7-4c33a19fb6c6@nsg.net.ru>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8fe8cb57-7d63-894a-9550-938991e1bf67@gmail.com>
Date:   Tue, 19 May 2020 22:37:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0b91c527-0cc3-f37a-9ce7-4c33a19fb6c6@nsg.net.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.05.2020 18:40, Val Jurin wrote:
> Hello  everybody.
> 
> This letter was sent to you because you are signed in as MAINTAINERS
>  for  ETHERNET PHY LIBRARY topic.
> 
> Issue:
> It seems I found "race condition" situation for PHY devices in AUTONEG_DISABLE mode.
> 
> Description:
> I found this issue in my working kernel 4.11.7 but  I cloned git master from Linus' git master branch
> and practically the same code is still in master. ( for now ver. 5.7.0-rc5 )
> 
> Please look at  the part of file
> drivers/net/phy/phy.c
> with my comments:
> 
> === code ===
> int phy_ethtool_ksettings_set(struct phy_device *phydev,
>                               const struct ethtool_link_ksettings *cmd)
> {
> 
> /*  THE PART OF THE CODE SKIPPED */
> 
>         phydev->autoneg = autoneg;
> 
>         phydev->speed = speed;
> 
>         linkmode_copy(phydev->advertising, advertising);
> 
>         linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
>                          phydev->advertising, autoneg == AUTONEG_ENABLE);
> 
>         phydev->duplex = duplex;
> 
> /* LET'S MARK THIS CODE POINT AS THE "POINT 1" */
> 
>         phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
> 
>         /* Restart the PHY */
> 
> /* AND WE ARE GOING TO phy_start_aneg */
> 
>         phy_start_aneg(phydev);
> 
>         return 0;
> }
> EXPORT_SYMBOL(phy_ethtool_ksettings_set);
> === EoF code ===
> 
> Now look at the beginning of phy_start_aneg:
> 
> === code ===
> int phy_start_aneg(struct phy_device *phydev)
> {
>         int err;
> 
>         if (!phydev->drv)
>                 return -EIO;
> 
> /* LET'S MARK THIS CODE POINT AS THE "POINT 2" */
> /* JUST BEFORE MUTEX LOCK */
>         mutex_lock(&phydev->lock);
> 
> /* THE FOLLOWING CODE SKIPPED */
> === EoF code ===
> 
> 
> The statement.
> 
> If the short code chain between "POINT 1" and "POINT 2" is running
> and physical device is in AUTONEG_DISABLE mode
> and one of the following asynchronous events occur between these points of code:
> 
> a)  phydev related status change interrupt (with following hi-prio tasklet);
> b)  task rescheduling which may call phydev status POLL routine
> (if phydev is in non-interrupt-driven mode);
> 
> the following fields in struct phy_device:
> 
> phydev->speed
> phydev->duplex
> 
> will  be rewritten by phy_device  read_status function.
> 
> For example - genphy_read_status ( more strict by genphy_read_status_fixed in kernel v.5 )
> 
> and the command from ethtool will not set correct speed and duplex which
> stays with old values of speed/duplex.
> 
> The probability of this event is vanishingly small and practically may never
> occur because:
> a) most of phy devices work in AUTONEG_ENABLE mode;
> b) the affected code chain is too short. It's just a dozen of CPU commands
> mostly for functions epilogue and prologue and the probability of incoming
> async events for phydev status change is practically close to zero while
> this code chain is running.
> 
> Anyway, it is a cause for race condition.
> 
> How to emulate:
> Just inject something like
>  phydev->drv->config_aneg(phydev)
> in any place of the described code chain between "POINT 1" and "POINT 2"
> 
> How it was found :
> I've got a card with MX6UL (NXP ARM SOC) with 2x FEC + micrel 8081 PHY.
> The interrupt line of one of these PHY devices was tied low by adjusters :-E
> and this caused high frequency interrupts + phy read_status call with interrupt rate
> limited by interrupt controller or something else. But it was enough to see
> that ethtool sets speed and duplex one time of three (or more) tries.
> Elsewhere it may never occur and it will never be found :)
> 
> Possible solution:
> Everything is normal in AUTONEG_ENABLE mode because the fields
> "speed" and "duplex" are not used in ethtool command by config_aneg
> which uses advertise fields as command data in this case.
> 
> It looks like the struct phy_device must have separated fields for command
> and for status change:
> 
> phydev->speed
> phydev->duplex
> 
> must be left for status
> but, for example
> 
> phydev->speed_req
> phydev->duplex_req
> 
> must be used for ethtool in phy_ethtool_ksettings_set  (*)
> and then used as command data in phy_start_aneg or later
> in appropriate  place _after_  phy_start_aneg locks phydev mutex.
> 

I see the point. It should be sufficient to add an unlocked version
of phy_start_aneg() and protect the critical section in
phy_ethtool_ksettings_set() with the phydev mutex.
Could you please test with the two patches below?


> (*) as you know this is the default, other drivers may use their own ethtool ksettings
> 
> I can not do patch/changes myself because this code is historically very old and
> trusted and very important and can affect not only the functions described above.
> I think you better know what to do or leave it "as is"  because the
> probability is too low. But as I suspect and as I was taught ...
> if probability is very very close to zero and it is not  still strictly zero
> just find the way what needs to be done to fix it.
> That was the reason to send you this letter.
> 
> Thank you for attention.
> 
> Regards,
> Valentine Jurin,
>         hardware support, kernel and boot maintenance,
>         NSG Ltd. , http://www.nsg.ru
> 
> P.S Also we want to say respects to you and to all kernel team for your great job.
> Thank you very much.
> We like Linux.
> 

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d4bbf79da..d945be675 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -602,7 +602,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 }
 
 /**
- * phy_start_aneg - start auto-negotiation for this PHY device
+ * __phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
  *
  * Description: Sanitizes the settings (if we're not autonegotiating
@@ -610,25 +610,33 @@ static int phy_check_link_status(struct phy_device *phydev)
  *   If the PHYCONTROL Layer is operating, we change the state to
  *   reflect the beginning of Auto-negotiation or forcing.
  */
-int phy_start_aneg(struct phy_device *phydev)
+int __phy_start_aneg(struct phy_device *phydev)
 {
 	int err;
 
 	if (!phydev->drv)
 		return -EIO;
 
-	mutex_lock(&phydev->lock);
-
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
 
 	err = phy_config_aneg(phydev);
 	if (err < 0)
-		goto out_unlock;
+		return err;
 
 	if (phy_is_started(phydev))
 		err = phy_check_link_status(phydev);
-out_unlock:
+
+	return err;
+}
+EXPORT_SYMBOL(__phy_start_aneg);
+
+int phy_start_aneg(struct phy_device *phydev)
+{
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = __phy_start_aneg(phydev);
 	mutex_unlock(&phydev->lock);
 
 	return err;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5d8ff5428..ea9ba6d1c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1244,6 +1244,7 @@ void phy_disconnect(struct phy_device *phydev);
 void phy_detach(struct phy_device *phydev);
 void phy_start(struct phy_device *phydev);
 void phy_stop(struct phy_device *phydev);
+int __phy_start_aneg(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_speed_down(struct phy_device *phydev, bool sync);
-- 
2.26.2



diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d945be675..7bf37ec3f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -291,6 +291,8 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	      duplex != DUPLEX_FULL)))
 		return -EINVAL;
 
+	mutex_lock(&phydev->lock);
+
 	phydev->autoneg = autoneg;
 
 	phydev->speed = speed;
@@ -305,7 +307,9 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	phy_start_aneg(phydev);
+	__phy_start_aneg(phydev);
+
+	mutex_unlock(&phydev->lock);
 
 	return 0;
 }
-- 
2.26.2

