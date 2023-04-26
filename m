Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5128C6EF9B4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbjDZR7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbjDZR7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:59:52 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0226C618B;
        Wed, 26 Apr 2023 10:59:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682531954; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QTP1nSuy3stytDdseimcCoXtiORzUrZ/QMDABvyPNc3fsSlqJRU3MkxrOKj/yGggz+FNvBuxBKlq+O6XuU4mQN6bpmnasCaNVy9YaOuWaa2GorthIuQhUPRQRsZl0uk3pBBW7RzwVaSOwMSONrefoMy3NvvFmv2PRDG2/qDGtZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682531954; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9Wi/8nMN9gJCaCyCSAg2V0pWF7JRystcZiffV/EP5n4=; 
        b=LNUxwyTGv7+KwRZV9M+mdnj4lKHJa7NJiPEtbzen7rgs1UGmTzFcbnFoB1P/L4RCAuzrAPXgBRpojcRBKJppx5woFLZD7b7qdGHao5X1xo4MTFHjokrHG4vOsG5lc+In3V2YGSbi+8HHrtoji7AeQyunbDfRObpHrc++QQVGyew=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682531954;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9Wi/8nMN9gJCaCyCSAg2V0pWF7JRystcZiffV/EP5n4=;
        b=ExP8dtkFjqQUa+eyrv7X5/ci8YBpV10iB0bdZMsomOUbcJBbHTcrZm3ZmL67sJAT
        g/4uKOvIlxi+e/9yzFgKC+dYoMtqoHl6AGmkmRNyjx2iW7pX4FJ2Z2uIFAs8BSh/M4w
        7bi2vLliB9tmoEMes2bbBFEATUKpcc2bqOdc7daI=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 16825319531255.417524925558041; Wed, 26 Apr 2023 10:59:13 -0700 (PDT)
Message-ID: <d4ebfe62-f951-1646-f3e2-66f419b6ecd4@arinc9.com>
Date:   Wed, 26 Apr 2023 20:58:58 +0300
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
 <trinity-a7837941-a0d2-4f38-aa65-0f0bd4759624-1682531537098@3c-app-gmx-bs05>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <trinity-a7837941-a0d2-4f38-aa65-0f0bd4759624-1682531537098@3c-app-gmx-bs05>
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

On 26/04/2023 20:52, Frank Wunderlich wrote:
> Hi
>> Gesendet: Mittwoch, 26. April 2023 um 19:25 Uhr
>> Von: "Arınç ÜNAL" <arinc.unal@arinc9.com>
> 
>>> tested this on bananapi-r3 on non-dsa gmac1 and dsa eth0 (wan).
>>> on both vlan is working, but maybe it breaks HW-vlan-untagging
>>
>> I'm confused by this. What is HW-vlan-untagging, and which SoCs do you
>> think this patch would break this feature? How can I utilise this
>> feature on Linux so I can confirm whether it works or not?
> 
> oh, you mean my wording about "hw-vlan-untagging"...i mean the hw vlan offload feature which may
> not be working on non-mt7621/7622 devices as i have no idea how to check this. i hope felix can
> answer this. at least the feature activeated on mt7986 breaks sw-vlan on the gmac1 (without
> switch).

The "hw vlan offload" feature being broken on non-mt7621/7622 devices is 
already established, hence this patch disabling it for the 
non-mt7621/7622 devices. I still don't understand why you're mentioning 
it in this way, unless you're trying to say something else?

Could you also not trim the relevant parts of the mail on your response. 
It's getting hard to keep track of the conversation.

Arınç
