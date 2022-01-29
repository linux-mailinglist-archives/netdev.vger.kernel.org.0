Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3964A2C25
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 07:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241742AbiA2GcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 01:32:04 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17467 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiA2GcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 01:32:04 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643437913; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=HfLD89kTy0VKqFGI5s8jGNWtlpVEkbm20k2wCV8k3khGBuEMPRtPGAYZsk+wJOX4MRtKCKKUJON3LzT/Rh//NW/7Mg8ztsxa4Ysok03zwAG2GgKbFAYhKGIwNUINvv+DMpmrkmcw2RUuve+hveLQvZD5XYjZoT3eZI6Oo0Npk3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643437913; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=wDG+AstTqrpwJwvMX6JhaZuSN8b49fqyGtLBFH6q3GI=; 
        b=KKsmQHtuSnd3fuapJvs6Ye+Rdzm2z6NatLigloY+I6sPGAydkpK08fDO4GE6mk2Lm2x1SCh0GWj3aJjKwC2XcpjqxojKi30elMDsbazRcwcN+J3+yAc3T2aMnH65AccZMSKFylBlxzblZYauOtZMKWtibqc/455z705Gsn/phS8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643437913;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=wDG+AstTqrpwJwvMX6JhaZuSN8b49fqyGtLBFH6q3GI=;
        b=IZQcD0vScEok3qh2F/Caz5xXzswblb7uVoM1Q4wggt6DM02DsLJS6z8rCjeZoH/B
        IdiwC/g+YpQdO8mgAbjztnB31nKMJJeET1pVBN8zSKIylIYqX0z8qDDRvLQwgUd4LsF
        NDVI/Li6UNsHUtvjMyZ2HKNPYGr6O0Z2A4O8xdow=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1643437911843264.6132416332499; Fri, 28 Jan 2022 22:31:51 -0800 (PST)
Message-ID: <b64e8982-a001-c153-0b2d-8df0a7634fb8@arinc9.com>
Date:   Sat, 29 Jan 2022 09:31:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select
 MEDIATEK_GE_PHY
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org
References: <20220128170544.4131-1-arinc.unal@arinc9.com>
 <20220128143112.35d9d03c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220128143112.35d9d03c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/01/2022 01:31, Jakub Kicinski wrote:
> On Fri, 28 Jan 2022 20:05:45 +0300 Arınç ÜNAL wrote:
>> Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
>> properly control MT7530 and MT7531 switch PHYs.
>>
>> A noticeable change is that the behaviour of switchport interfaces going
>> up-down-up-down is no longer there.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Sounds like a fix, can we get a Fixes tag?

Sent v2. I didn't realise you weren't in the recipients, sorry.

https://lore.kernel.org/netdev/20220129062703.595-1-arinc.unal@arinc9.com/T/#u

Arınç
