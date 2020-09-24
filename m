Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FDF277199
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgIXMvM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Sep 2020 08:51:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56118 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgIXMvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 08:51:12 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kLQiL-0003vO-3X
        for netdev@vger.kernel.org; Thu, 24 Sep 2020 12:51:09 +0000
Received: by mail-pf1-f197.google.com with SMTP id 8so1794955pfx.6
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 05:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DjILAW2W1Nia4thAbmZLofAgJjNgLzZMs6DEDIxBnIo=;
        b=AcfpgkWPOcCWyACJ6+O+rxqeGh6L797XIR6sTpsASSJJiq+b7UY+g50NrTU0ttStVu
         gcihJ+3P/SYU8XEA+OpzTiSuK1fNKJYDDxQ27l7P/S20dBD+yiIiaHZHGSKGvWF/Dpod
         E96qidkGk9qaXXzMhiEI7Py3gK/lGDEgfCI2KU5ushW/edjG32TfeN1oIALKbq57hjN7
         IXBEZeHN9L2smMm2uE+QU0vpEgIq8q3s7tU9HyHGj7pkFx7OByy/GqZX1/L5KDpK6MOq
         zcBNA/4MuzR3yVVzZbrBgumlMKuS0TxcsZC36ObuAVfEChrX5zbrXrJ5KvmIB73GG+Ns
         pnyg==
X-Gm-Message-State: AOAM532lm/xTxyL0euG8bmokJbQayBfr0vfEU9FawjRilnGyw8mqaY2l
        nKgYhaaBbh5R5b0kUMV1oXUXJ/XMhMafM0XFpZeYDICpTRo3+pTnI9oyB3+VUfKjRS4MiLieOQe
        BZ4vVzrrO1OIE/Pnlfq7zjEq/7Hw+TcPTWQ==
X-Received: by 2002:a17:902:b109:b029:d1:e5e7:be53 with SMTP id q9-20020a170902b109b02900d1e5e7be53mr4459772plr.45.1600951867653;
        Thu, 24 Sep 2020 05:51:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+Y5i1WCdrHedy2G1MLAQKaJqLzvRJx54jTzBEz2xfl0cI8jcWhte7k+YO7+uWHFPAIn3tqQ==
X-Received: by 2002:a17:902:b109:b029:d1:e5e7:be53 with SMTP id q9-20020a170902b109b02900d1e5e7be53mr4459743plr.45.1600951867169;
        Thu, 24 Sep 2020 05:51:07 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id y4sm2879537pgl.67.2020.09.24.05.51.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 05:51:06 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] e1000e: Power cycle phy on PM resume
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200923153703.GC3764123@lunn.ch>
Date:   Thu, 24 Sep 2020 20:50:59 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B5008979-2999-4141-B373-2F649462DD0A@canonical.com>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200923121748.GE3770354@lunn.ch>
 <F6075687-7BC4-4348-86A8-29D83B7E5AAC@canonical.com>
 <20200923153703.GC3764123@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> On Sep 23, 2020, at 23:37, Andrew Lunn <andrew@lunn.ch> wrote:
> 
> On Wed, Sep 23, 2020 at 10:44:10PM +0800, Kai-Heng Feng wrote:
>> Hi Andrew,
>> 
>>> On Sep 23, 2020, at 20:17, Andrew Lunn <andrew@lunn.ch> wrote:
>>> 
>>> On Wed, Sep 23, 2020 at 03:47:51PM +0800, Kai-Heng Feng wrote:
>>>> We are seeing the following error after S3 resume:
>>>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>>>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>>>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>>>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>>>> ...
>>>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>>>> 
>>>> Since we don't know what platform firmware may do to the phy, so let's
>>>> power cycle the phy upon system resume to resolve the issue.
>>>> 
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>> ---
>>>> drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>>>> 1 file changed, 2 insertions(+)
>>>> 
>>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>> index 664e8ccc88d2..c2a87a408102 100644
>>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>> @@ -6968,6 +6968,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>>>> 	    !e1000e_check_me(hw->adapter->pdev->device))
>>>> 		e1000e_s0ix_exit_flow(adapter);
>>>> 
>>>> +	e1000_power_down_phy(adapter);
>>>> +
>>> 
>>> static void e1000_power_down_phy(struct e1000_adapter *adapter)
>>> {
>>> 	struct e1000_hw *hw = &adapter->hw;
>>> 
>>> 	/* Power down the PHY so no link is implied when interface is down *
>>> 	 * The PHY cannot be powered down if any of the following is true *
>>> 	 * (a) WoL is enabled
>>> 	 * (b) AMT is active
>>> 	 * (c) SoL/IDER session is active
>>> 	 */
>>> 	if (!adapter->wol && hw->mac_type >= e1000_82540 &&
>>> 	   hw->media_type == e1000_media_type_copper) {
>> 
>> Looks like the the function comes from e1000, drivers/net/ethernet/intel/e1000/e1000_main.c.
>> However, this patch is for e1000e, so the function with same name is different.
> 
> Ah! Sorry. Missed that. Also it is not nice there are two functions in
> the kernel with the same name.
> 
>>> Could it be coming out of S3 because it just received a WoL?
>> 
>> No, the issue can be reproduced by pressing keyboard or rtcwake.
> 
> Not relevant now, since i was looking at the wrong function. But i was
> meaning the call is a NOP in the case WoL caused the wake up. So if
> the issues can also happen after WoL, your fix is not going to fix it.
> 
>>> It seems unlikely that it is the MII_CR_POWER_DOWN which is helping,
>>> since that is an MDIO write itself. Do you actually know how this call
>>> to e1000_power_down_phy() fixes the issues?
>> 
> 
>> I don't know from hardware's perspective, but I think the comment on
>> e1000_power_down_phy_copper() can give us some insight:
> 
> And there is only one function called e1000_power_down_phy_copper()
> :-)
> 
>> 
>> /**
>> * e1000_power_down_phy_copper - Restore copper link in case of PHY power down
>> * @hw: pointer to the HW structure
>> *
>> * In the case of a PHY power down to save power, or to turn off link during a
>> * driver unload, or wake on lan is not enabled, restore the link to previous
>> * settings.                       
>> **/
>> void e1000_power_down_phy_copper(struct e1000_hw *hw)
>> {
>>        u16 mii_reg = 0;
>> 
>>        /* The PHY will retain its settings across a power down/up cycle */
>>        e1e_rphy(hw, MII_BMCR, &mii_reg);
>>        mii_reg |= BMCR_PDOWN;
>>        e1e_wphy(hw, MII_BMCR, mii_reg);
>>        usleep_range(1000, 2000);
>> }
> 
> I don't really see how this explains this:
> 
>>>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>>>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/e1000e/phy.c#L181
> 
> So first off, the comments are all cut/paste from
> e1000e_read_phy_reg_mdic(). It would be nice to s/read/write/g in that
> function.

Ah yes...

> 
> So it sets up the transaction and starts it. MDIO is a serial bus with
> no acknowledgements. You clock out around 64 bits, and hope the PHY
> receives it. The time it takes to send those 64 bits is fixed by the
> bus speed, typically 2.5MHz.

Thanks for the info.

> 
> So the driver polls waiting for the hardware to say the bits have been
> sent. And this is timing out. How long that takes has nothing to do
> with the PHY, or what state it is in. Powering down the PHY has no
> effect on the MDIO bus master, and how long it takes to shift those
> bits out. Which is why i don't think this patch is correct. This is
> probably an MDIO bus issue, not a PHY issue.

Thanks for pointing out the possible root cause.
Indeed this looks like an MDIO issue so this patch is completely wrong.

I'll send a V2, thanks.

Kai-Heng

> 
> Try dumping the value of MDIC in the good/bad case before the
> transaction starts.
> 
> 	 Andrew

