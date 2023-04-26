Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68706EF9A0
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjDZRwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjDZRwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:52:19 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D601635AD;
        Wed, 26 Apr 2023 10:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682531500; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=UCY20pq6hBUDq0BErUNSiq1JHZ08krIPzKXZK7mW/4B2BuIcCj66ICA2dghtnCRJLxvc86ynDnyizCk9nZEmARNqW//E5+jIQmg1fAsZGPBs9iX7xumDZ2hFuNmWAEK4FQLG/uLYfURSCKeVZ8LDoLgmmlOrVp0WgPQyY0mmmfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682531500; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=4lj3hzEx9aj2YGe6xhhebIwqwsB+duLc+uUUaIkR490=; 
        b=eEAM0y2k8X1ksxQ1DnRUJZAXbzmGMjrE5+W7xFSfZZ9VkYEzgI66FFRxWKa+lBIMv28a3crOWsqmctGkH4JgR+gFLwH9htoLXLFwnLhCSI8jlwbnwhhE8aFYGolb24L55L/+tk6IGiVpUnvCbbSVaddLyC584ZpRDJZWllVDlho=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682531500;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=4lj3hzEx9aj2YGe6xhhebIwqwsB+duLc+uUUaIkR490=;
        b=ddav/KHAVz77stAmuPr8bcAfjb9xzsS2PNTT5Nz2hBTOS/cS/e3T52npvHN6oOs/
        qFAtunt4wBYth5yPzcTQ4+R2q2PogL1gEtQFxbG5mTedydRWpGERdZdvaDBocb+wk+k
        9G6wWw4ba44fRRB630eg6Rwiik3QgGFfEQZ27b6I=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682531497603365.41163959637413; Wed, 26 Apr 2023 10:51:37 -0700 (PDT)
Message-ID: <9f8f082d-7bc7-2271-9b6c-cd7bf96c755b@arinc9.com>
Date:   Wed, 26 Apr 2023 20:51:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Aw: Re: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
References: <20230426172153.8352-1-linux@fw-web.de>
 <61ea49b7-8a04-214d-ef02-3ef6181619e9@arinc9.com>
 <trinity-bb65fd35-fe52-45d2-975c-230e504cc93f-1682530288982@3c-app-gmx-bs05>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <trinity-bb65fd35-fe52-45d2-975c-230e504cc93f-1682530288982@3c-app-gmx-bs05>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2023 20:31, Frank Wunderlich wrote:
> 
>> Gesendet: Mittwoch, 26. April 2023 um 19:25 Uhr
>> Von: "Arınç ÜNAL" <arinc.unal@arinc9.com>
>> On 26/04/2023 20:21, Frank Wunderlich wrote:
>>> From: Felix Fietkau <nbd@nbd.name>
>>>
>>> Through testing I found out that hardware vlan rx offload support seems to
>>> have some hardware issues. At least when using multiple MACs and when
>>> receiving tagged packets on the secondary MAC, the hardware can sometimes
>>> start to emit wrong tags on the first MAC as well.
>>>
>>> In order to avoid such issues, drop the feature configuration and use
>>> the offload feature only for DSA hardware untagging on MT7621/MT7622
>>> devices where this feature works properly.
>>>
>>> Fixes: 08666cbb7dd5 ("net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload")
>>> Tested-by: Frank Wunderlich <frank-w@public-files.de>
>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
>>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> I'm confused by this. What is HW-vlan-untagging, and which SoCs do you
>> think this patch would break this feature? How can I utilise this
>> feature on Linux so I can confirm whether it works or not?
> 
> the feature itself breaks vlan on mac of bpi-r3
> 
> 1 mac is connected to switch and uses dsa tags, the other mac is directly accessible and vlan-tag
> there is stripped by this feature.
> 
> with this patch i can use vlans on the "standalone" mac again (see tagged packets incoming).

Ok, since this patch is disabling the feature, the patch cannot possibly 
break the feature. That's why I was confused as to why you mentioned 
this in a way that gives the impression that this patch may break the 
said feature.

Anyhow:

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç
