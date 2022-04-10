Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D4B4FADFB
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 15:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiDJNDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 09:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiDJNC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 09:02:59 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807F7B7DF
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 06:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649595626; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Nd6L8wcY5fU6u1Hx/eJxE3//juhL45gs/jeaY3EITc4aTe30zh6BKXKqEeCX1Q9Nhm5rxAteNHVjivBep4EyTqMbMmRfaavekLTvMsKRAtu4VZL/nhi1+wzCA7eviMIXpu7Pwn8ArHGOXxNZpKcTH7hJCU9l/vP5nkQPaPUjhjE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1649595626; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=QCBcDgsIJ3Ex2fUcOOIVfCPnq3SE7SOYPM+pV4HepLQ=; 
        b=SwHj8mpq6Krl7pdnyaBnVZ0HEdH7A5RDQX04f8J0JQA4rxZisic7UWzKIk02I87W53nEjwAfjeInvA/fNSo0qURb2oQ6jH0SWSci4kp0j2CLtLRQtQUw6qEq+JLDV/GnlhygVttnG4pcbgs8hix1GnHgWZ/IWV3OJlDrkKRlOZo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1649595626;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=QCBcDgsIJ3Ex2fUcOOIVfCPnq3SE7SOYPM+pV4HepLQ=;
        b=W0ScBtG3msNV4wzVTwn+LSOInaEYf5APtq9SfWx/uVYAWfDelyKJwe2QDiW83GOg
        fAl+x7rjCz82paOyxwcKHaWRlIyQu0nq0VoowuJfIq0uE7XTotQCpZ9jDF0lsxZv/SZ
        skiEs3Exx5/hwk4Dj5u5fuDkO7XOqbQgneeIn9ek=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1649595624463134.99901432557851; Sun, 10 Apr 2022 06:00:24 -0700 (PDT)
Message-ID: <e427d390-0cd4-d322-1665-4176cd134884@arinc9.com>
Date:   Sun, 10 Apr 2022 16:00:19 +0300
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
 <ee47c555-1b9c-ec97-1533-04aae2526406@arinc9.com>
 <20220314140011.idmbyc33e7zfezu2@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220314140011.idmbyc33e7zfezu2@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2022 17:00, Vladimir Oltean wrote:
> On Mon, Mar 14, 2022 at 04:13:47PM +0300, Arınç ÜNAL wrote:
>> Hey Vladimir,
>>
>> On 13/03/2022 16:32, Vladimir Oltean wrote:
>>> Hello Arınç,
>>>
>>> On Sun, Mar 13, 2022 at 02:23:47PM +0300, Arınç ÜNAL wrote:
>>>> Hi all,
>>>>
>>>> The company I work with has got a product with a Mediatek MT7530 switch.
>>>> They want to offer isolation for the switch ports on a bridge. I have run a
>>>> test on a slightly modified 5.17-rc1 kernel. These commands below should
>>>> prevent communication between the two interfaces:
>>>>
>>>> bridge link set dev sw0p4 isolated on
>>>>
>>>> bridge link set dev sw0p3 isolated on
>>>>
>>>> However, computers connected to each of these ports can still communicate
>>>> with each other. Bridge TX forwarding offload is implemented on the MT7530
>>>> DSA driver.
>>>>
>>>> What I understand is isolation works on the software and because of the
>>>> bridge offloading feature, the frames never reach the CPU where we can block
>>>> it.
>>>>
>>>> Two solutions I can think of:
>>>>
>>>> - Disable bridge offloading when isolation is enabled on a DSA slave
>>>> interface. Not the best solution but seems easy to implement.
>>>>
>>>> - When isolation is enabled on a DSA slave interface, do not mirror the
>>>> related FDB entries to the switch hardware so we can keep the bridge
>>>> offloading feature for other ports.
>>>>
>>>> I suppose this could only be achieved on switch specific DSA drivers so the
>>>> implementation would differ by each driver.
>>>>
>>>> Cheers.
>>>> Arınç
>>>
>>> To be clear, are you talking about a patched or unpatched upstream
>>> kernel? Because mt7530 doesn't implement bridge TX forwarding offload.
>>> This can be seen because it is missing the "*tx_fwd_offload = true;"
>>> line from its ->port_bridge_join handler (of course, not only that).
>>
>> I'm compiling the kernel using OpenWrt SDK so it's patched but mt7530 DSA
>> driver is untouched. I've seen this commit which made me think of that:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/dsa/mt7530.c?id=b079922ba2acf072b23d82fa246a0d8de198f0a2
>>
>> I'm very inexperienced in coding so I must've made a wrong assumption.
>>
>> I've tested that mt7530 DSA driver delivers frames between switch ports
>> without the frames appearing on either the slave interfaces or the master
>> interface. I suppose I was confusing this feature with tx_fwd_offload?
>>
>> For example, the current state of the rtl8365mb DSA driver doesn't do this.
>> Each frame goes in and out of the DSA master interface to deliver frames
>> between the switch ports.
> 
> That is just "forwarding offload". It means "for each packet that a
> bridged switch port receives from the outside world, look up the
> hardware FDB and send the packet just to its intended destination. If
> there is no FDB entry, flood the packet in the entire forwarding domain
> and also to the CPU. The packet flooded to the CPU will have the
> skb->offload_fwd_mark bit set to true by the hardware driver to indicate
> to the bridge that flooding to this port's hardware domain has already
> been taken care of. Only flooding towards other (foreign) bridge ports
> needs to be done for this packet."
> 
> TX forwarding offload means "when the bridge wants to send a packet that
> needs to be replicated multiple times (either flooded or plain multicast)
> to swp0, swp1, swp2, swp3 (all in the same hardware forwarding domain),
> avoid replicating it in software (skb_clone) and send it just once to
> the device driver dealing with a port from that hardware domain (swp0).
> The driver will inject that single packet into the hardware in such a
> way that the packet is forwarded based on consulting the hardware FDB.
> If the hardware FDB and the bridge's software FDB are in sync, then
> (a) the packet was flooded by the bridge => the bridge has no FDB entry
>      for it. The hardware FDB has no entry for it either => the hardware
>      floods it too.
> (b) the packet was multicast => the bridge has an MDB entry, and so does
>      the hardware. The packet is forwarded to the ports in the MDB
>      entry."
> 
> This feature is basically the TX equivalent of the basic forwarding
> offload, hence the name. TX packets for which the bridge leaves the FDB
> lookup (and replication) responsibility to hardware have
> skb->offload_fwd_mark set to true, but by the bridge, this time.
> 
> I think it's very important to understand what the TX forwarding offload
> feature was meant to do and how it was meant to operate, because there
> was a discussion with Qingfang on this topic too, and it may be that
> mt7530 switch supports this in a different way.
> https://patchwork.kernel.org/project/netdevbpf/cover/20210703115705.1034112-1-vladimir.oltean@nxp.com/#24290759
> The approach of populating a port mask with more than 1 bit set in the
> tagger is complicated and may not even achieve all the benefits of TX
> forwarding offload. Forcing an FDB/MDB lookup is what is desirable,
> since typically this should also make those packets go through the
> address learning process (they will be treated as data plane packets).
> Address learning on the CPU port is desirable for packets send on behalf
> of a software bridge, and undesirable for packets sent from a standalone
> port.
> If you can enable address learning in the tagger for the packets that
> are sent with skb->offload_fwd_mark == true, then you should be able to
> remove ds->assisted_learning_on_cpu_port and still get the benefit
> described here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210106095136.224739-7-olteanv@gmail.com/
> 
>>>
>>> You are probably confused as to why is the BR_ISOLATED brport flag is
>>> not rejected by a switchdev interface when it will only lead to
>>> incorrect behavior.
>>>
>>> In fact we've had this discussion with Qingfang, who sent this patch to
>>> allow switchdev drivers to *at the very least* reject the flag, but
>>> didn't want to write up a correct commit description for the change:
>>> https://lore.kernel.org/all/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/T/
>>> https://patchwork.kernel.org/project/netdevbpf/patch/20210811135247.1703496-1-dqfext@gmail.com/
>>> https://patchwork.kernel.org/project/netdevbpf/patch/20210812142213.2251697-1-dqfext@gmail.com/
>>
>> With v2 applied, when I issue the port isolation command, I get "RTNETLINK
>> answers: Not supported" as it's not implemented in mt7530 yet?
> 
> The entire idea is to get -EINVAL as returned from here, because
> BR_ISOLATED will be present in flags.mask:
> 
> static int
> mt7530_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> 			     struct switchdev_brport_flags flags,
> 			     struct netlink_ext_ack *extack)
> {
> 	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> 			   BR_BCAST_FLOOD))
> 		return -EINVAL;
> 
> 	return 0;
> }
> 
> Now, the entire error handling from br_switchdev_set_port_flag() is a
> bit of a disaster.
> https://elixir.bootlin.com/linux/latest/source/net/bridge/br_switchdev.c#L77
> 
> 	/* We run from atomic context here */
> 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
> 				       &info.info, extack);
> 	err = notifier_to_errno(err);
> 	if (err == -EOPNOTSUPP) // Drivers need to return -EINVAL here to distinguish themselves from "no one responded to this notifier", which is a non-error.
> 		return 0;
> 
> 	if (err) {
> 		if (extack && !extack->_msg)
> 			NL_SET_ERR_MSG_MOD(extack,
> 					   "bridge flag offload is not supported");
> 		return -EOPNOTSUPP; // However, any other error code passed from the driver, like -EINVAL, is ignored and replaced with -EOPNOTSUPP by the bridge.
> 	}
> 
> I think this is where the "Not supported" error message comes from, in
> your case. It would be good to double-check with prints, though.
> 
> Also, you might want to consider compiling iproute2 with libmnl support,
> to get extack messages from the kernel. Here it seems like you're
> missing "bridge flag offload is not supported", which would have been a
> clear indication that this is the code path that was taken.

I added a pr_info here as it looked easier to test this:

	/* We run from atomic context here */
	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
				       &info.info, extack);
	err = notifier_to_errno(err);
	if (err == -EOPNOTSUPP)
		return 0;

	if (err) {
		if (extack && !extack->_msg)
			pr_info("Port flag is not supported");
			NL_SET_ERR_MSG_MOD(extack,
					   "bridge flag offload is not supported");
		pr_info("Port flag is not supported");
		return -EOPNOTSUPP;
	}

Looks like this is the expected result:

root@OpenWrt:/# bridge link set dev sw0p3 isolated on
[   55.862862] Port flag is not supported
RTNETLINK answers: Not supported
root@OpenWrt:/# bridge link set dev sw0p3 isolated on
[   55.862893] Port flag is not supported
[   58.492025] Port flag is not supported
RTNETLINK answers: Not supported

> 
>>> As a result, currently not even the correctness issue has still not yet
>>> been fixed, let alone having any driver act upon the feature correctly.
>>
>> It's unfortunate that this patch was put on hold just because of incomplete
>> commit description. In my eyes, this is a significant fix.
> 
> I agree here. You could send the patch yourself, after making some tests.

Will do.

Arınç
