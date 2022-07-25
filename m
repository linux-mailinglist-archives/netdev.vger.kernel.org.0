Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2445806E2
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiGYVjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiGYVjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:39:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A7EA120A4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 14:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658785183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6pic0i+a5ccILTIdlv55ml+aAsYqZGp3bdlj9/0t5Fg=;
        b=YNulybSxHiFQ/JV9TOPdCdSsxfqXxPOFwiV09IC502VfaS07I2WmhEcwhhMLKTPdrDc2VB
        J1uIqz1Ep5YJLrPQokT6MB5lHk9xfgY/w20gv42lmyzdXKYnEVZA8Mj6z5wJzrzYSJp8rB
        3qGdoAyoEup2864sYScQqMPr1r7QLho=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-6WyaKCxaPxquG-HjSHQT0A-1; Mon, 25 Jul 2022 17:39:41 -0400
X-MC-Unique: 6WyaKCxaPxquG-HjSHQT0A-1
Received: by mail-oi1-f199.google.com with SMTP id a6-20020a05680804c600b0033ad6fb7ddeso1537343oie.16
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 14:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6pic0i+a5ccILTIdlv55ml+aAsYqZGp3bdlj9/0t5Fg=;
        b=0NZmMkQwRMEDLd1b+lrzkH+auQe18GeY58hXr4vdpFpePVt62SubgY7G2n081fWanO
         2DmRF5poAkUQjWylPXeIfYAeeZE24/YWrFkulNuFG1oq5+cWb33RR+0CIQO6k2X+GuyO
         Wtyx/4qCXkyimcwDgnJcwDSK1Sw+KJMmjqKfEjBlTHkQuCXsVCt4d0ttpayiajv+q5cz
         S/vtTKh2zDd2NiLYhTh//lSG9aSwtTkKEEjT7iZBbumOFJ+m/FnjiUOhiS1uKAhdviL9
         RNl70bmKwQowi0vz7HpnjPxfCBiFMTi84sXzfsJq2Yj8Piw8xP7BZdpZhogpjcpooVBl
         4tLg==
X-Gm-Message-State: AJIora/6O1fLk4wB4V2pKbavjaLzzB1E7YuI33+X6vI5FuyUDgXr3avH
        P+8Zm9MmDYA7V90t+gKFuDtrMvS5qJePGKHN/QDats3W7KW5fG5zoYXwx7t+U7aTjKZuq6Ggt1j
        ebJsIzy/PQKSW8pUL
X-Received: by 2002:a05:6808:2291:b0:33a:4317:e326 with SMTP id bo17-20020a056808229100b0033a4317e326mr13045413oib.11.1658785181174;
        Mon, 25 Jul 2022 14:39:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tVZAU3Quq7i0H7TLomc1yTbkfXKC/GwrpYFX/XQDhjg0rPDs+7BV+HjAIs8x/MQa8qTBIAPQ==
X-Received: by 2002:a05:6808:2291:b0:33a:4317:e326 with SMTP id bo17-20020a056808229100b0033a4317e326mr13045400oib.11.1658785180883;
        Mon, 25 Jul 2022 14:39:40 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id k23-20020a056870959700b000f5f4ad194bsm7048411oao.25.2022.07.25.14.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 14:39:40 -0700 (PDT)
Message-ID: <24e1144d-2dcc-6b33-eec0-f668d51c7a80@redhat.com>
Date:   Mon, 25 Jul 2022 17:39:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
 <20220715170042.4e6e2a32@kernel.org> <20220716001443.aooyf5kpbpfjzqgn@skbuf>
 <20220715171959.22e118d7@kernel.org> <20220716002612.rd6ir65njzc2g3cc@skbuf>
 <20220715175516.6770c863@kernel.org> <20220716133009.eaqthcfyz4bcbjbd@skbuf>
 <20220716163338.189738a4@kernel.org> <20220725203125.kaxokkhyrb4aerp5@skbuf>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220725203125.kaxokkhyrb4aerp5@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/22 16:31, Vladimir Oltean wrote:
> Hi Jakub,
> 
> On Sat, Jul 16, 2022 at 04:33:38PM -0700, Jakub Kicinski wrote:
>> On Sat, 16 Jul 2022 13:30:10 +0000 Vladimir Oltean wrote:
>>> I would need some assistance from Jay or other people more familiar with
>>> bonding to do that. I'm not exactly clear which packets the bonding
>>> driver wants to check they have been transmitted in the last interval:
>>> ARP packets? any packets?
>>
>> And why - stack has queued a packet to the driver, how is that useful
>> to assess the fact that the link is up? Can bonding check instead
>> whether any queue is running? Or maybe the whole thing is just a remnant
>> of times before the centralized watchdog tx and should be dropped?
> 
> Yes, indeed, why? I don't know.
> 
>>> With DSA and switchdev drivers in general,
>>> they have an offloaded forwarding path as well, so expect that what you
>>> get through ndo_get_stats64 may also report packets which egressed a
>>> physical port but weren't originated by the network stack.
>>> I simply don't know what is a viable substitute for dev_trans_start()
>>> because I don't understand very well what it intends to capture.
>>
>> Looking thru the code I stumbled on the implementation of
>> dev_trans_start() - it already takes care of some upper devices.
>> Adding DSA handling there would offend my sensibilities slightly
>> less, if you want to do that. At least it's not on the fast path.
> 
> How are your sensibilities feeling about this change?
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index cc6eabee2830..b844eb0bde7e 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -427,20 +427,43 @@ void __qdisc_run(struct Qdisc *q)
>   
>   unsigned long dev_trans_start(struct net_device *dev)
>   {
> +	struct net_device *lower;
> +	struct list_head *iter;
>   	unsigned long val, res;
> +	bool have_lowers;
>   	unsigned int i;
>   
> -	if (is_vlan_dev(dev))
> -		dev = vlan_dev_real_dev(dev);
> -	else if (netif_is_macvlan(dev))
> -		dev = macvlan_dev_real_dev(dev);
> +	rcu_read_lock();
> +
> +	/* Stacked network interfaces usually have NETIF_F_LLTX so
> +	 * netdev_start_xmit() -> txq_trans_update() fails to do anything,
> +	 * because they don't lock the TX queue. However, layers such as the
> +	 * bonding arp monitor may still use dev_trans_start() on slave
> +	 * interfaces such as vlan, macvlan, DSA (or potentially stacked
> +	 * combinations of the above). In this case, walk the adjacency lists
> +	 * all the way down, hoping that the lower-most device won't have
> +	 * NETIF_F_LLTX.
> +	 */

I am not sure this assumption holds for virtual devices like veth unless 
the virtual interfaces are updated to modify trans_start, see
e66e257a5d83 ("veth: Add updating of trans_start")

And not all the virtual interfaces update trans_start iirc.

> +	do {
> +		have_lowers = false;
> +
> +		netdev_for_each_lower_dev(dev, lower, iter) {
> +			have_lowers = true;
> +			dev = lower;
> +			break;
> +		}
> +	} while (have_lowers);
> +
>   	res = READ_ONCE(netdev_get_tx_queue(dev, 0)->trans_start);
> +
>   	for (i = 1; i < dev->num_tx_queues; i++) {
>   		val = READ_ONCE(netdev_get_tx_queue(dev, i)->trans_start);
>   		if (val && time_after(val, res))
>   			res = val;
>   	}
>   
> +	rcu_read_unlock();
> +
>   	return res;
>   }
>   EXPORT_SYMBOL(dev_trans_start);
> 

