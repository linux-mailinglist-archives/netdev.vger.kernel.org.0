Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B77275A87
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIWOoS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 10:44:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51941 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWOoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:44:18 -0400
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kL60F-00087t-SQ
        for netdev@vger.kernel.org; Wed, 23 Sep 2020 14:44:16 +0000
Received: by mail-pg1-f198.google.com with SMTP id x20so154728pgx.11
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 07:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=pLpsqwyAc34XRY67/IthHjRexsEe8HGW6p/p61VILpo=;
        b=uLq1Wck5EWJzPTGuEtuCxXpDE0DyOo+XwviRo72CcixeOSgIswhAAXHXQ1tI7F3gBL
         zTasDkFkJXPFmnSQ1aOUfIqdLP9XvNe7yek6Y7z5z3eQ70f181wGV5JR8+ErcEA4ahwG
         7cka+4KQcEdYB4CRL4ASMr8aGDJ34xDaQPR6ZQWfGs4sbkxXJ3T4U/n39UkvQ6qpIoSk
         jIst1O8VgKaSSnVe4hgZiCvbHE8WidOYOpZAUa4eJweJew5bOmnfOueLlejTugjgbBaU
         BUWd5O2Qf4VDqTPtPl+FPKveFzKOrnXH3Q7UcZqSO1/iPvLJliNkP5G3oC+O1i+ZDHJ6
         HFIA==
X-Gm-Message-State: AOAM531K4FrtBJGfabi/ZskCYF4FmUYHWcOk2Zh2c39Yr8pF52VT8ZC8
        oOH7vk/vXBIYYL/HIcRpSTk1moMhkD2oCn5Fsjs8rGhJdZDU0oa76QgkiWW37iEC1I/OkZOFfMZ
        Vy9fm1lz1FVf64AItYPbgYSPIvBKXW3Eptw==
X-Received: by 2002:a17:90a:e207:: with SMTP id a7mr9024635pjz.117.1600872254107;
        Wed, 23 Sep 2020 07:44:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwIIlGXDZa+VMJLNOd0CPYXdHbIh3zAqmGsa0AyAjb9Kn7ZGhqNeA+AcMSXkAZcadbGJc7UA==
X-Received: by 2002:a17:90a:e207:: with SMTP id a7mr9024604pjz.117.1600872253706;
        Wed, 23 Sep 2020 07:44:13 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id l141sm28777pfd.47.2020.09.23.07.44.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 07:44:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] e1000e: Power cycle phy on PM resume
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200923121748.GE3770354@lunn.ch>
Date:   Wed, 23 Sep 2020 22:44:10 +0800
Cc:     jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F6075687-7BC4-4348-86A8-29D83B7E5AAC@canonical.com>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200923121748.GE3770354@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> On Sep 23, 2020, at 20:17, Andrew Lunn <andrew@lunn.ch> wrote:
> 
> On Wed, Sep 23, 2020 at 03:47:51PM +0800, Kai-Heng Feng wrote:
>> We are seeing the following error after S3 resume:
>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>> ...
>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>> 
>> Since we don't know what platform firmware may do to the phy, so let's
>> power cycle the phy upon system resume to resolve the issue.
>> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>> 1 file changed, 2 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 664e8ccc88d2..c2a87a408102 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -6968,6 +6968,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>> 	    !e1000e_check_me(hw->adapter->pdev->device))
>> 		e1000e_s0ix_exit_flow(adapter);
>> 
>> +	e1000_power_down_phy(adapter);
>> +
> 
> static void e1000_power_down_phy(struct e1000_adapter *adapter)
> {
> 	struct e1000_hw *hw = &adapter->hw;
> 
> 	/* Power down the PHY so no link is implied when interface is down *
> 	 * The PHY cannot be powered down if any of the following is true *
> 	 * (a) WoL is enabled
> 	 * (b) AMT is active
> 	 * (c) SoL/IDER session is active
> 	 */
> 	if (!adapter->wol && hw->mac_type >= e1000_82540 &&
> 	   hw->media_type == e1000_media_type_copper) {

Looks like the the function comes from e1000, drivers/net/ethernet/intel/e1000/e1000_main.c.
However, this patch is for e1000e, so the function with same name is different.

> 
> Could it be coming out of S3 because it just received a WoL?

No, the issue can be reproduced by pressing keyboard or rtcwake.

> 
> It seems unlikely that it is the MII_CR_POWER_DOWN which is helping,
> since that is an MDIO write itself. Do you actually know how this call
> to e1000_power_down_phy() fixes the issues?

I don't know from hardware's perspective, but I think the comment on e1000_power_down_phy_copper() can give us some insight:

/**
 * e1000_power_down_phy_copper - Restore copper link in case of PHY power down
 * @hw: pointer to the HW structure
 *
 * In the case of a PHY power down to save power, or to turn off link during a
 * driver unload, or wake on lan is not enabled, restore the link to previous
 * settings.                       
 **/
void e1000_power_down_phy_copper(struct e1000_hw *hw)
{
        u16 mii_reg = 0;

        /* The PHY will retain its settings across a power down/up cycle */
        e1e_rphy(hw, MII_BMCR, &mii_reg);
        mii_reg |= BMCR_PDOWN;
        e1e_wphy(hw, MII_BMCR, mii_reg);
        usleep_range(1000, 2000);
}

Kai-Heng

> 
>   Andrew

