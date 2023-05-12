Return-Path: <netdev+bounces-2023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B606FFFD7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4260F2818AC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2909BEC8;
	Fri, 12 May 2023 05:15:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16212818
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 05:15:23 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1373E358A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:15:22 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so3129204b3a.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1683868521; x=1686460521;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=an4XJKeQqf7OoOgS11GPyZ4SDpr/99NOhPCDcCwJiOk=;
        b=rYzyQCRmVJ0tjVcyPwxX/GT7/s2z4G2+jZW0n5w83A6XZVAaFyxp9nVAB7LyVHovGl
         XTbCaIVLtEvfgP3eCSlOGjxoS4jYeVQcp4HLxPMcDjhRRvuTVMaA841fgIdYQ8N8TvLb
         mVeFqIazJmpFbovn43oWHuopxJGUhOppbfxOs5NQHE5ASg3BqFdwPHnzBVdR3+CBgSIe
         vLjTADXd4JuCHCFdWh1w/UhhXjC53pzUvDvKoBt8HxiJ7m89zMFstxXZNkjT2wXOQKKi
         7bdNZ5zx5dYHRcyHG9E8hk1JsN9JkLNJRWucBdBaF+NiQHlSK2limanuKFud/UVzaL12
         5+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683868521; x=1686460521;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=an4XJKeQqf7OoOgS11GPyZ4SDpr/99NOhPCDcCwJiOk=;
        b=OUkcdXmq/ibflSdgT6xURRz66ZnTh56Pe4VV/DULBm5L6FPItWT/Vuc682xrKLcG9C
         elNpGI6kwx49b2UZ62L2MhXQ/YNbbtjncFrPCs7Bdp2cqhobH/g4BSgx3Et+U52b3of7
         +DhmKnYwk2Wh4YgqRC0CIQ7SlZDuzngNlS1H21CHF0GfeU8n09y5piVicYdp4CgNzyu2
         wqTQMyYEjAF2bHqvHE3x6GGe3yvGQH/Lgwxl2KlJrdmgSA3eE8roXL4TBsWfkGfEJz2h
         oGbWKr+L9Z8Pzf/h9DjdOD+/1+VdEJz8bwP2vwXWPwCXbEEBk7Ldt+2Q2S0O5/zUc75A
         8wOw==
X-Gm-Message-State: AC+VfDx6ChO+PEMLiKs4GoA33YLGX34p14FaBEWjVSz1Dnd64uKHlftb
	y5czFlVRMgsJlYU9f1dQ2/WJPQ==
X-Google-Smtp-Source: ACHHUZ7UJfje/VDcAqigjPeixrrPUnKBam4OISDhruAflTEGyYjnvX36eS/Sy3TmX3vpuGInb5roIA==
X-Received: by 2002:a17:902:c943:b0:1a9:2a9e:30a8 with SMTP id i3-20020a170902c94300b001a92a9e30a8mr37417876pla.9.1683868521081;
        Thu, 11 May 2023 22:15:21 -0700 (PDT)
Received: from [192.168.98.6] (remote.mistywest.io. [184.68.30.58])
        by smtp.gmail.com with ESMTPSA id be8-20020a170902aa0800b001ac897026cesm6869337plb.102.2023.05.11.22.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 22:15:20 -0700 (PDT)
Message-ID: <08d021d2-a612-d52d-73ba-06492c070144@mistywest.com>
Date: Thu, 11 May 2023 22:15:19 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: PHY VSC8531 MDIO data not reflected in ethernet/ sub-module
From: Ron Eggler <ron.eggler@mistywest.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
References: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
 <69d0d5d9-5ed0-4254-adaf-cf3f85c103b9@lunn.ch>
 <759ac0e2-9d5e-17ea-83e2-573a762492c2@mistywest.com>
Content-Language: en-US
In-Reply-To: <759ac0e2-9d5e-17ea-83e2-573a762492c2@mistywest.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023-05-11 16:21, Ron Eggler wrote:
> Hi Andrew,
>
> Thanks for your response:
>
> On 2023-05-11 8:34 a.m., Andrew Lunn wrote:
>>> ***[ 6.728165] DEBUG: in ravb_emac_init_gbeth(), calling
>>> ravb_set_rate_gbeth(), priv->duplex: 0, priv->speed: 0*
>>> ***[ 6.751973] DEBUG: in ravb_set_rate_gbeth() - priv->speed 0*
>>> ***[ 6.831153] DEBUG: in ravb_adjust_link(), phydev->speed -1, 
>>> priv->speed
>>> 0*
>>> ***[ 6.839952] DEBUG: in ravb_adjust_link(), priv->no_avb_link 0,
>>> phydev->link 0*
>> If there is no link, everything else is meaningless. You cannot have
>> speed without link.
> Makes sense!
>>> While I also receive the following using the mii-tool utility:
>>> # mii-tool -vv eth0
>>> Using SIOCGMIIPHY=0x8947
>>> eth0: negotiated 1000baseT-FD flow-control, link ok
>>>    registers for MII PHY 0:
>>>      1040 796d 0007 0572 01e1 cde1 000f 2001
>>>      4006 0300 7800 0000 0000 4002 0000 3000
>>>      0000 f000 0088 0000 0000 0001 3200 1000
>>>      0000 0000 0000 0000 a035 0054 0400 0000
>>>    product info: vendor 00:01:c1, model 23 rev 2
>>>    basic mode:   autonegotiation enabled
>>>    basic status: autonegotiation complete, link ok
>>>    capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>>> 10baseT-FD 10baseT-HD
>>>    advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 
>>> 10baseT-HD
>>>    link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>>> 10baseT-FD 10baseT-HD flow-control
>> Assuming you are not using interrupts, phylib will poll the PHY once a
>> second, calling
>> phy_check_link_status()->
>
> I don't see it being invoked every Seconds but it gets invoked on 
> boot, I added debug logs and see the following:
>
> [    6.669425] DEBUG: in phy_check_link_status(), phy_read_status() 
> ret err 0, phydev->loopback_enabled 0,
> [    6.696237] DEBUG: in phy_check_link_status(), phydev->link 0, 
> phydev->state UP
>
> state = UP which means it's ready to start auto negotiation(in 
> phy_state_machine())  but instead in phy_check_link_status(), 
> phydev->state should be set to  PHY_RUNNING but it only can get set to 
> PHY_RUNNING when phydev->link is 1 (in phy_check_link_status()):
>
>>    phy_read_status()->
>>      phydev->drv->read_status()
>> or
>>      genphy_read_status()
>>
>> Check what these are doing, why do they think the link is down.
>
> Yes, so in phy_read_status, phydev->drv->read_status appears to be set 
> but I cannot figure out where it gets set. (I obviously need to find 
> the function to find why the link isn't read correctly).
> I temporarily set phydev->drv->read_status to 0 to force invocation of 
> genphy_read_status() function to see how that would work.
>
> genphy_update_link(0 is called from genphy_read_status() and I get the 
> below data:
>
> [    6.795480] DEBUG: in genphy_update_link(), after phy_read() bmcr 4160
> [    6.805225] DEBUG: in genphy_update_link(), bmcr 0x1040 & 0x200
> [    6.815730] DEBUG: in genphy_read_status(), genphy_update_link() 0 
> phydev->autoneg 1, phydev->link 0
>
>
> Could it be that the link needs a second to come up when when the 
> network drivers get started and hence I should make sure that the 
> polling once a second works (which currently doesn't appear to be the 
> case)? Am I missing a configuration option?

For now I've tried to add:
phydev->irq = PHY_POLL;
to phy_attached_info_irq() in drivers/net/phy/phy_device.c which turns 
out totally locks-up the system, i.e. I can't even type root to login 
anymore. This is after I removed the log messages now but while I still 
had them in there, they would just fill up my screen, the polling 
appears to use up all the CPU power.

A little cut-out from the logs, looked like this:

...
[  418.485394] DEBUG: in phy_check_link_status(), phy_read_status() err 
0, phydev->loopback_enabled 0,
[  418.503700] DEBUG: in phy_check_link_status(), phydev->link 1, 
phydev->state RUNNING
[  418.511463] DEBUG: in phy_state_machine(), phydev->state RUNNING, 
needs_aneg 0
[  418.518727] DEBUG: in phy_state_machine(), phy_start_aneg() 0, 
needs_aneg 826560768
[  419.361074] DEBUG: in phy_read_status(), phydev->drv->read_status 0
[  419.367474] DEBUG: in genphy_update_link(), after phy_read() bmcr 4160
[  419.375665] DEBUG: in genphy_update_link(), bmcr 0x1040 & 0x200
[  419.382324] DEBUG: in genphy_read_status(), genphy_update_link() 0 
phydev->autoneg 1, phydev->link 0
[  419.382547] DEBUG: in phy_check_link_status(), phy_read_status() err 
0, phydev->loopback_enabled 0,
[  419.400837] DEBUG: in phy_check_link_status(), phydev->link 0, 
phydev->state NOLINK
[  419.408521] DEBUG: in phy_state_machine(), phydev->state NOLINK, 
needs_aneg 0
[  419.415718] DEBUG: in phy_state_machine(), phy_start_aneg() 0, 
needs_aneg 826560768
[  419.553089] DEBUG: in phy_read_status(), phydev->drv->read_status 0
[  419.559486] DEBUG: in genphy_update_link(), after phy_read() bmcr 4160
[  419.566858] DEBUG: in genphy_update_link(), bmcr 0x1040 & 0x200
[  419.573423] DEBUG: in genphy_read_status(), genphy_update_link() 0 
phydev->autoneg 1, phydev->link 1
[  419.573432] DEBUG: in phy_check_link_status(), phy_read_status() err 
0, phydev->loopback_enabled 0,
[  419.591738] DEBUG: in phy_check_link_status(), phydev->link 1, 
phydev->state RUNNING
[  419.599505] DEBUG: in phy_state_machine(), phydev->state RUNNING, 
needs_aneg 0
[  419.606764] DEBUG: in phy_state_machine(), phy_start_aneg() 0, 
needs_aneg 826560768
...

The state toggled between RUNNING & NOLINK and the phydev->link toggeled 
between 1 and 0

The reason why I had interrupts activated is because the device tree 
that's used as a base had a PHY with the interrupt pin hooked up and 
while I override the original phy node in the device tree with 
https://github.com/MistySOM/meta-mistysom/blob/phy-enable/recipes-kernel/linux/smarc-rzg2l/0001-add-vsc8531-userspace-dts.patch 
, the interrupt attribute from the original device tree will persist. I 
will have to create a patch that removes the attrribute in the dtsi file 
where the original phy node is defined. I think that should give me the 
poll functionality

-- 

Ron


