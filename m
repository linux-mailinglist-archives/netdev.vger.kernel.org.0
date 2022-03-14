Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634904D85CB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241680AbiCNNP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241677AbiCNNP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:15:26 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2011DA51
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 06:14:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1647263636; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=R7KloPLEBYb8lsmC07OcK2+KYcRd6jwcI9dx/3foA8m5ODVs6NnzDWRlAB0E35TcygMgD0yx0VLN4gQB8yAtvhpldKjQmoenjErA+fg930ntmqFXbaoY+MmWPwzKgUTJ6SA1lsc2wvkLfYKqGrHjFLjDTVuC6y7g9IkT0FjpbKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1647263636; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=aUWhWW9KhxpXJVEHaCUYsLo9QdsZkFL8y5SxSpdTvuA=; 
        b=oEsxAc7UzgCNfu0rIxtQdcWowhDuYAwi/QV+yx2mIINcofXdqgpes2L+5ykSZgKaAIbhjJLVbzN5jREtn72ZJAIEO3O9TyPSGr4Gkx5gdHdMVqI+QEy5Me7K8RRDdrH5Kx3tyfJdZZ7d4AAN5OwHShfO61lhrFUVl3yXiBUzxgk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1647263636;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=aUWhWW9KhxpXJVEHaCUYsLo9QdsZkFL8y5SxSpdTvuA=;
        b=b5NeWG14giORc4Sr21sWXVnIdDJY09tOW3zojpAe5ji9w8AOoj1mcHV9vdy8zOC2
        G6MC7uUvc+I0pGAmdRhLxH54ICa4A+utz2OcODvEiCc/eDSl7487CfU56RtNzBEESN2
        LvGwnc1+5a655TyjsLV2U1Ei3AqhFFOVVfiq79Pw=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1647263633677502.1430765024811; Mon, 14 Mar 2022 06:13:53 -0700 (PDT)
Message-ID: <ee47c555-1b9c-ec97-1533-04aae2526406@arinc9.com>
Date:   Mon, 14 Mar 2022 16:13:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Isolating DSA Slave Interfaces on a Bridge with Bridge Offloading
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
References: <7c046a25-1f84-5dc6-02ad-63cb70fbe0ec@arinc9.com>
 <20220313133228.iff4tbkod7fmjgqn@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220313133228.iff4tbkod7fmjgqn@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Vladimir,

On 13/03/2022 16:32, Vladimir Oltean wrote:
> Hello Arınç,
> 
> On Sun, Mar 13, 2022 at 02:23:47PM +0300, Arınç ÜNAL wrote:
>> Hi all,
>>
>> The company I work with has got a product with a Mediatek MT7530 switch.
>> They want to offer isolation for the switch ports on a bridge. I have run a
>> test on a slightly modified 5.17-rc1 kernel. These commands below should
>> prevent communication between the two interfaces:
>>
>> bridge link set dev sw0p4 isolated on
>>
>> bridge link set dev sw0p3 isolated on
>>
>> However, computers connected to each of these ports can still communicate
>> with each other. Bridge TX forwarding offload is implemented on the MT7530
>> DSA driver.
>>
>> What I understand is isolation works on the software and because of the
>> bridge offloading feature, the frames never reach the CPU where we can block
>> it.
>>
>> Two solutions I can think of:
>>
>> - Disable bridge offloading when isolation is enabled on a DSA slave
>> interface. Not the best solution but seems easy to implement.
>>
>> - When isolation is enabled on a DSA slave interface, do not mirror the
>> related FDB entries to the switch hardware so we can keep the bridge
>> offloading feature for other ports.
>>
>> I suppose this could only be achieved on switch specific DSA drivers so the
>> implementation would differ by each driver.
>>
>> Cheers.
>> Arınç
> 
> To be clear, are you talking about a patched or unpatched upstream
> kernel? Because mt7530 doesn't implement bridge TX forwarding offload.
> This can be seen because it is missing the "*tx_fwd_offload = true;"
> line from its ->port_bridge_join handler (of course, not only that).

I'm compiling the kernel using OpenWrt SDK so it's patched but mt7530 
DSA driver is untouched. I've seen this commit which made me think of that:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/dsa/mt7530.c?id=b079922ba2acf072b23d82fa246a0d8de198f0a2

I'm very inexperienced in coding so I must've made a wrong assumption.

I've tested that mt7530 DSA driver delivers frames between switch ports 
without the frames appearing on either the slave interfaces or the 
master interface. I suppose I was confusing this feature with 
tx_fwd_offload?

For example, the current state of the rtl8365mb DSA driver doesn't do 
this. Each frame goes in and out of the DSA master interface to deliver 
frames between the switch ports.

> 
> You are probably confused as to why is the BR_ISOLATED brport flag is
> not rejected by a switchdev interface when it will only lead to
> incorrect behavior.
> 
> In fact we've had this discussion with Qingfang, who sent this patch to
> allow switchdev drivers to *at the very least* reject the flag, but
> didn't want to write up a correct commit description for the change:
> https://lore.kernel.org/all/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/T/
> https://patchwork.kernel.org/project/netdevbpf/patch/20210811135247.1703496-1-dqfext@gmail.com/
> https://patchwork.kernel.org/project/netdevbpf/patch/20210812142213.2251697-1-dqfext@gmail.com/

With v2 applied, when I issue the port isolation command, I get 
"RTNETLINK answers: Not supported" as it's not implemented in mt7530 yet?

> 
> As a result, currently not even the correctness issue has still not yet
> been fixed, let alone having any driver act upon the feature correctly.

It's unfortunate that this patch was put on hold just because of 
incomplete commit description. In my eyes, this is a significant fix.

> 
> In my opinion, it isn't mandatory that bridge ports with BR_ISOLATED
> have forwarding handled in software. All that needs to change is that
> their forwarding domain, as managed by the ->port_bridge_join and
> ->port_bridge_leave callbacks, is further restricted. Isolated ports can
> forward only to non-isolated ports, and non-isolated ports cannot
> forward to isolated ports. Things may become more interesting with
> bridge TX forwarding offload though, but as I mentioned, at least
> upstream this isn't a concern for mt7530 (yet).

Makes sense, thank you.

Arınç
