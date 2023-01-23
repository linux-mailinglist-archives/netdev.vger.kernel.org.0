Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9096779A2
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjAWKy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjAWKy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:54:57 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E95CA10
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 02:54:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674471285; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QciispmoNJM/rHeCZAyTba8NV7ljG4OeScLJv3VJ1yVuUHs0KWiDyJ2W8ZaU1mR4nGkLMH7CVN/RwHyg6+bWVf8u4IEowK8UCtr/uSAeWf+ACfHW3jU+MHVRbxEZ1FsH6gbE/TGfzVjzqRl4irtf3e7GdQiqScL1uPDyC1g1vMc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674471285; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=RTYO4Db6m1kVA76Pp0mL4TjvMAItrNoZoyPIYpQIeTA=; 
        b=ac2mwZZYayIFzb+E8FgKn8M3MbffmVYvAX1g6gdRWAvbkuGSB0CgZdYLL7I2k6Rl6/jAH8M0uM9DY/XdpeoU29ruNXtSvfOSYZ1pQx+qduocFZs4TUy/mfcHcsgI91P1lATQJI8MDPqtmcRRNUT1bJKlSrb61zG/WahsBRJAj5o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674471285;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=RTYO4Db6m1kVA76Pp0mL4TjvMAItrNoZoyPIYpQIeTA=;
        b=G9QqhF6jwH32X7sjL5+1bb3gI+ZAuukTOo8g8DFNgJIcr5NKL6Ejej2N+jeoBDK+
        U6JEAUuCrWcR5DYgRBRKJbtorZj4ybpUV7aKwfjmsSO2la/ZR5MgCRZpwm0ehd4g8XL
        MdFPX7jo/QPSP4oaHDnVZvNxltOxQr0pQ7AA49qU=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674471284006941.8486581034124; Mon, 23 Jan 2023 02:54:44 -0800 (PST)
Message-ID: <d00767eb-b443-730d-bd94-5f61e22ae723@arinc9.com>
Date:   Mon, 23 Jan 2023 13:54:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: gmac1 issues with mtk_eth_soc & port 5 issues with MT7530 DSA
 driver
To:     frank-w@public-files.de, netdev <netdev@vger.kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
 <84BAEBE0-0026-45A4-89AB-FB20E9F9063B@public-files.de>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <84BAEBE0-0026-45A4-89AB-FB20E9F9063B@public-files.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.09.2022 16:45, Frank Wunderlich wrote:
> Am 13. September 2022 14:54:20 MESZ schrieb "Arınç ÜNAL" <arinc.unal@arinc9.com>:
>> I'd like to post a few more issues I stumbled upon on mtk_eth_soc and MT7530 DSA drivers. All of this is tested on vanilla 6.0-rc5 on GB-PC2.
>>
>> ## MT7621 Ethernet gmac1 won’t work when gmac1 is used as DSA master for MT7530 switch
>>
>> There’s recently been changes on the MT7530 DSA driver by Frank to support using port 5 as a CPU port.
>>
>> The MT7530 switch’s port 5 is wired to the MT7621 SoC’s gmac1.
>>
>> Master eth1 and slave interfaces initialise fine. Packets are sent out from eth1 fine but won't be received on eth1.
>>
>> This issue existed before Lorenzo’s changes on 6.0-rc1.
>>
>> I’m not sure if this is an issue with mtk_eth_soc or the MT7530 DSA driver.
>>
>> ---
>>
>> ## MT7530 sends malformed packets to/from CPU at port 5 when port 6 is not defined on devicetree
>>
>> In this case, I can see eth1 receiving traffic as the receive counter on ifconfig goes up with the ARP packets sent to the mt7621 CPU.
>>
>> I see the mt7621 CPU not responding to the ARP packets (no malformed packets or anything), which likely means ARP packets received on the mt7621 CPU side are also malformed.
>>
>> I think this confirms that the above issue is related to the MT7530 DSA driver as I can see eth1 receiving traffic in this case.
>>
>> Packet capture of the malformed packets are in the attachments.
>>
>> ---
>>
>> ## MT7621 Ethernet gmac1 won’t work when gmac0 is not defined on devicetree
>>
>> eth0 interface is initalised even though it’s not defined on the devicetree, eth1 interface is not created at all.
>>
>> This is likely not related to the MT7530 DSA driver.
>>
>> Arınç
> There are some patches fixing ethernet and dsa driver for getting sfps to work.
> 
> https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=commit;h=9469ba3568d7d9de31dc63de5269c848a1cc1dc7
> 
> And on dsa side imho only to support sfp
> 
> https://github.com/openwrt/openwrt/commit/bd6783f4fb8f6171927e9067c0005a6d69fc13fe
> 
> Hope the first patches help you with your issue

Thanks for pointing these patches out Frank. I tried these but it didn't 
fix any of the issues I described.

It's been a while since this post. In the meantime, I've gained access 
to a Bananapi BPI-R2 and tested whether the first issue I described 
exists there too. It does. The behaviour on that one was slightly 
different which helped me actually figure out what part of the code 
causes this. I'll send another reply to this post to explain all that.

Arınç
