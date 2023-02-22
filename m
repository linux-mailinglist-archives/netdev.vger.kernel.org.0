Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E230969FAC4
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjBVSIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjBVSIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 13:08:31 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F321814D
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 10:08:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677089294; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mruGcdb7nWbnu1FrACDnuq1si7QdMjOIIxENeY4ylLJ+Y3BjSGExo7KoSBzL3tUSliG5tcoixRuy1RFDRHAfBNKyu76OtOwuxUY6N6wSzVfg2WG0VLy0ENfcQAPuYwCWrJxCOaYK4B5Z8cVQR5vYxw8HQv+PBMcu/ATmaPpR22o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1677089294; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=IxT1l/pSy8LqayDFMfiXHLFGNDqxzABWwwojmHRvjCY=; 
        b=J7HIR3ytM7OXEDJxjqTYMFNT5ggwOtBqJrlyJSAXQ0vj1noZukRR8uNvWpjJ9jedhgqcQbjKQtoe5XSQYHJYIaIGs7txABk2WVfW8sqcRbiPjxUEp6JyZ4YeERb97vV3i5za4XArhFk3Byp7+Kyy/NtNldFbC89XON6z5kXU4Oo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1677089294;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=IxT1l/pSy8LqayDFMfiXHLFGNDqxzABWwwojmHRvjCY=;
        b=PRV1O6TQoD/o8X3d+Jimmpsb503PyUEgvIYRmrmDa41C3o+ig+AGZyLbPiIc+5Ma
        z2vWvndyhXyvDRgfUbtWRXrVAqijWZHES+VkJfOOBt1WWfN7MNwcoaQ3m7opXAxIKlO
        inYVGDU7f+kVdSO5bBFRwHyHnyqekJWHFOqEDZOU=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 167708929335699.57906719266555; Wed, 22 Feb 2023 10:08:13 -0800 (PST)
Message-ID: <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
Date:   Wed, 22 Feb 2023 21:08:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Choose a default DSA CPU port
To:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
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
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230222180623.cct2kbhyqulofzad@skbuf>
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

On 22.02.2023 21:06, Vladimir Oltean wrote:
> On Wed, Feb 22, 2023 at 06:17:42PM +0100, Frank Wunderlich wrote:
>> without Arincs Patch i got 940Mbit on gmac0, so something seems to affect the gmac when port5 is enabled.
> 
> which patch?

I believe Frank is referring to the patch series I submitted which adds 
port@5 to Bananapi BPI-R2. Without the patch, gmac0 is the default DSA 
master.

https://lore.kernel.org/linux-mediatek/20230210182505.24597-1-arinc.unal@arinc9.com/

Arınç
