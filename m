Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443C669FC65
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjBVTna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjBVTn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:43:29 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583638B5F
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:43:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677094981; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ihE0IfxdwxozWxPl7ZwdG362HdUKK+6G7XE8L88cFFg5jG9dJG6s86ZAREGF/aoL5jBHYVMxhdhnxokEkx/4qxCsR5UFWNBiEvip79Gq96ScQFrGagu3A2le5DjUB7ozjih2dOXBUfyONUsIjE3vKqVoyoOGA78a6t3Gz9sB6vw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1677094981; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=msNJTYeACnSXiSABBxQ3HJQqgmRH2MI+W251OXO4ixQ=; 
        b=gmlAswCg2GRXhFbRrHQ8kFVAubH7BH0geIcbLzj6mkjGLxKrXRGN04lsB8hx3IFVbsiFUJW7ucg5NrqFIzSyC8H4854Hek5SR9un7lQQGwWYNWvaAADx6Qn4Yx0aQDCZdsf1QQUuc9CFZG3H9Nxy5XoL6roULF26xZeZI8QgkMA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1677094981;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=msNJTYeACnSXiSABBxQ3HJQqgmRH2MI+W251OXO4ixQ=;
        b=OaB9EOjznRIAzX6bI6LlxSAhY2PwxxwUX+YK7ci6uvvZu9wJWwWYZBnuDL439Olp
        h8d2PSLQQI74cSbsWgQVqO5JkuykZhbhCwcQVbsB5w7daz9XB38v/jU1T6ZMy0lzu6N
        +/hAzKRKZkmWgY7+r8qO7w0JKj7aIJ9Z/Mf+PAzg=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 167709497962565.21906022704559; Wed, 22 Feb 2023 11:42:59 -0800 (PST)
Message-ID: <e89af7bd-2f4c-3865-afa5-276a6acbc16f@arinc9.com>
Date:   Wed, 22 Feb 2023 22:42:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Choose a default DSA CPU port
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
 <20230222180623.cct2kbhyqulofzad@skbuf>
 <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
 <20230222193440.c2vzg7j7r32xwr5l@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230222193440.c2vzg7j7r32xwr5l@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.02.2023 22:34, Vladimir Oltean wrote:
> On Wed, Feb 22, 2023 at 09:08:03PM +0300, Arınç ÜNAL wrote:
>> On 22.02.2023 21:06, Vladimir Oltean wrote:
>>> On Wed, Feb 22, 2023 at 06:17:42PM +0100, Frank Wunderlich wrote:
>>>> without Arincs Patch i got 940Mbit on gmac0, so something seems to affect the gmac when port5 is enabled.
>>>
>>> which patch?
>>
>> I believe Frank is referring to the patch series I submitted which adds
>> port@5 to Bananapi BPI-R2. Without the patch, gmac0 is the default DSA
>> master.
>>
>> https://lore.kernel.org/linux-mediatek/20230210182505.24597-1-arinc.unal@arinc9.com/
>>
>> Arınç
> 
> And with your patch + my patch, gmac0 is still the default DSA master,
> but gmac1/port5 are also enabled. The claim is that switch port 6/gmac0
> has lower bandwidth when switch port 5/gmac1 is enabled, than when it isn't?
> 
> Frank's testing is done on the MT7623 SoC (with the MT7530 switch),
> an SoC which you have access to, since you've submitted those device
> tree changes, correct? Do you confirm his result?

I just sent a big patch series, doing some tests on this issue is next 
on my task list. So I can't confirm Frank's result for now.

> 
> The posted ethtool stats are not sufficient to determine the cause of
> the issue. It would be necessary to see all non-zero Ethernet counters
> on both CPU port pairs:
> 
> ethtool -S eth0 | grep -v ': 0'
> ethtool -S eth1 | grep -v ': 0'
> 
> to determine whether the cause of the performance degradation is packet
> loss or just a lossless slowdown of some sorts. For example, the
> degradation might be caused by the added flow control + uncalibrated
> watermarks, not by the activation of the other GMAC.

I'll keep this in mind thanks.

Frank, here's my task page for this issue, for your information.

https://arinc9.notion.site/MT7530-port5-performance-issue-98ac5fa19dc248e0b12fab08dcb2e387

Arınç
