Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2815F54B751
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiFNRHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiFNRHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:07:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3508B6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655226436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mp0VzrK5BtHanNi7VZbWPXMeHyGQHr9WEMrhnKm8eWg=;
        b=jF281h+qTOi27f/8FJsOWulihOojyVxjJ3TdHVBt+IZG+zytVUrFHXnuyrlYhTx+K0RqIO
        w9FIltOnSAaB+Mhy9HikcJAJUTFol4ycHyCtwCJl77y9ErLNlCvARRbKxNJxIC8H3bJI2X
        xBiA8g3bUeKGoFwtnrmX9cCR/yg+JnQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-6CTGy283OrCwv7Zo3K3a6A-1; Tue, 14 Jun 2022 13:07:14 -0400
X-MC-Unique: 6CTGy283OrCwv7Zo3K3a6A-1
Received: by mail-qv1-f69.google.com with SMTP id r14-20020ad4576e000000b0046bbacd783bso6346714qvx.14
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mp0VzrK5BtHanNi7VZbWPXMeHyGQHr9WEMrhnKm8eWg=;
        b=f2cetgirRXc5hGjPgmc2ovBH1gaHq5T4oc/OigOluZlWBGavsL2Q9bn4/f17HXJdVE
         CFGCbSVAD9jhbcn4qsM+Yq92JrPjCoztdHgMgKZXg7jZf3HPdAb9v0CP3t00jLoLzMHY
         ZcePmKkGJRZtEwQ2XnIegaYeYhiHKT0X/B3+3C63fRuh8j0DFhG/B1JDMJWSfgFUgZ9F
         SybupuvuQeuZ9Sa/GaRD7tRHnIqp7S25CpqHiz2/EeJApf6e/HrYs36ZU2fNDW61uBS9
         /zaWP/fW2L1L7gRiWVFIhWTE5T2AApeWiXmgni+hWNO1vUP2n6zVsVQaz1hltgXLfRPN
         9Zkw==
X-Gm-Message-State: AOAM533wuO0ApXtbPIiit81H/51tWfiGvQI04D+7RnydYXzQiRurhTFH
        ocH3zBcIjd8ur9GatWOiPEV3F2XhzB/3U7APtK+nBgH6bjEkiWQBwvsKWVXKeDkFjiVoYW2oAOn
        3CAf+ozIbQ7U+ZncV
X-Received: by 2002:ac8:5a50:0:b0:305:20c4:791d with SMTP id o16-20020ac85a50000000b0030520c4791dmr5062432qta.437.1655226433401;
        Tue, 14 Jun 2022 10:07:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwph2dMhZyUSODsJjioctzmGJ/wHXT/czbIS7Ax/52fFOcgYT2OfQvt2l9fJr+kFSNxpM2qsA==
X-Received: by 2002:ac8:5a50:0:b0:305:20c4:791d with SMTP id o16-20020ac85a50000000b0030520c4791dmr5062394qta.437.1655226432934;
        Tue, 14 Jun 2022 10:07:12 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id r18-20020a05620a299200b006a746826feesm10355130qkp.120.2022.06.14.10.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 10:07:12 -0700 (PDT)
Message-ID: <0ea8519c-4289-c409-2e31-44574cdefde3@redhat.com>
Date:   Tue, 14 Jun 2022 13:07:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Any reason why arp monitor keeps emitting netlink failover
 events?
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com>
 <10584.1655220562@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <10584.1655220562@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/22 11:29, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> On net-next/master from today, I see netlink failover events being emitted
>>from an active-backup bond. In the ip monitor dump you can see the bond is
>> up (according to the link status) but keeps emitting failover events and I
>> am not sure why. This appears to be an issue also on Fedora 35 and CentOS
>> 8 kernels. The configuration appears to be correct, though I could be
>> missing something. Thoughts?
> 
> 	Anything showing up in the dmesg?  There's only one place that
> generates the FAILOVER notifier, and it ought to have a corresponding
> message in the kernel log.
> 
> 	Also, I note that the link1_1 veth has a lot of failures:

Yes all those failures are created by the setup, I waited about 5 
minutes before dumping the link info. The failover occurs about every 
second. Note this is just a representation of a physical network so that 
others can run the setup. The script `bond-bz2094911.sh`, easily 
reproduces the issue which I dumped with cat below in the original email.

Here is the kernel log, I have dynamic debug enabled for the entire 
bonding module:
[66898.926972] bond0: bond_netdev_event received NETDEV_BONDING_FAILOVER
[66898.926978] bond0: bond_master_netdev_event called
[66898.928717] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66898.928744] bond0: bond_netdev_event received NETDEV_NOTIFY_PEERS
[66898.928746] bond0: bond_master_netdev_event called
[66898.928839] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66898.928853] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.7
[66898.928867] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66898.928915] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66898.928919] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66898.928920] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66898.928948] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.5
[66898.928954] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66898.929045] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66898.929050] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66898.929051] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66898.932441] bond0: (slave link1_1): bond_slave_netdev_event called
[66898.932449] bond0: (slave link2_1): bond_slave_netdev_event called
[66898.934145] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66898.935030] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66898.935043] bond0: bond_netdev_event received NETDEV_RESEND_IGMP
[66898.935045] bond0: bond_master_netdev_event called
[66899.982620] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.7
[66899.982661] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66899.982894] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66899.982909] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66899.982913] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66899.983110] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.5
[66899.983130] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66899.983247] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66899.983258] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66899.983262] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66901.006314] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.7
[66901.006347] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66901.006495] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66901.006507] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66901.006511] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66901.006573] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.5
[66901.006587] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66901.006679] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66901.006688] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66901.006691] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66902.031207] bond0: (slave link1_1): bond_slave_netdev_event called
[66902.033041] bond0: (slave link1_1): bond_slave_netdev_event called
[66902.033045] bond0: (slave link1_1): link status definitely down, 
disabling slave
[66902.033052] bond0: (slave link2_1): making interface the new active one
[66902.035774] bond0: (slave link2_1): bond_slave_netdev_event called
[66902.035790] bond0: (slave link2_1): bond_slave_netdev_event called
[66902.038924] bond0: (slave link2_1): bond_slave_netdev_event called
[66902.038954] bond0: (slave link1_1): bond_slave_netdev_event called
[66902.042318] bond0: (slave link1_1): bond_slave_netdev_event called
[66902.042343] bond0: bond_should_notify_peers: slave link2_1
[66902.044818] bond0: bond_netdev_event received NETDEV_BONDING_FAILOVER
[66902.044822] bond0: bond_master_netdev_event called
[66902.046611] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66902.046623] bond0: bond_netdev_event received NETDEV_NOTIFY_PEERS
[66902.046626] bond0: bond_master_netdev_event called
[66902.046710] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66902.046723] bond0: (slave link2_1): bond_arp_send_all: target 
192.168.30.7
[66902.046754] bond0: (slave link2_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66902.046807] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66902.046812] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66902.046813] bond0: (slave link2_1): bond_arp_rcv: link2_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66902.046841] bond0: (slave link2_1): bond_arp_send_all: target 
192.168.30.5
[66902.046848] bond0: (slave link2_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66902.046892] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66902.046896] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66902.046897] bond0: (slave link2_1): bond_arp_rcv: link2_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66902.050879] bond0: (slave link1_1): bond_slave_netdev_event called
[66902.050888] bond0: (slave link2_1): bond_slave_netdev_event called
[66902.053036] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66902.054391] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66902.054402] bond0: bond_netdev_event received NETDEV_RESEND_IGMP
[66902.054405] bond0: bond_master_netdev_event called
[66903.056566] bond0: (slave link1_1): bond_slave_netdev_event called
[66903.056573] bond0: (slave link1_1): link status definitely up
[66903.056585] bond0: (slave link1_1): making interface the new active one
[66903.063511] bond0: (slave link2_1): bond_slave_netdev_event called
[66903.067482] bond0: (slave link1_1): bond_slave_netdev_event called
[66903.067495] bond0: (slave link1_1): bond_slave_netdev_event called
[66903.075563] bond0: (slave link1_1): bond_slave_netdev_event called
[66903.075622] bond0: (slave link2_1): bond_slave_netdev_event called
[66903.081868] bond0: (slave link2_1): bond_slave_netdev_event called
[66903.081912] bond0: bond_should_notify_peers: slave link1_1
[66903.085588] bond0: bond_netdev_event received NETDEV_BONDING_FAILOVER
[66903.085593] bond0: bond_master_netdev_event called
[66903.088050] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66903.088075] bond0: bond_netdev_event received NETDEV_NOTIFY_PEERS
[66903.088077] bond0: bond_master_netdev_event called
[66903.088132] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.7
[66903.088147] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66903.088159] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.5
[66903.088165] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66903.089132] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66903.089139] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66903.089142] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66903.089143] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66903.089170] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66903.089173] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66903.089174] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66903.092128] bond0: (slave link1_1): bond_slave_netdev_event called
[66903.092137] bond0: (slave link2_1): bond_slave_netdev_event called
[66903.092976] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66903.094791] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66903.094803] bond0: bond_netdev_event received NETDEV_RESEND_IGMP
[66903.094805] bond0: bond_master_netdev_event called
[66904.142116] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.7
[66904.142135] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66904.142214] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66904.142219] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66904.142221] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66904.142256] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.5
[66904.142263] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66904.142307] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66904.142312] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66904.142313] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66905.166309] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.7
[66905.166356] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.7 
src 192.168.30.10
[66905.166568] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66905.166586] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66905.166591] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.7 tip 192.168.30.10
[66905.166683] bond0: (slave link1_1): bond_arp_send_all: target 
192.168.30.5
[66905.166703] bond0: (slave link1_1): arp 1 on slave: dst 192.168.30.5 
src 192.168.30.10
[66905.166865] bond0: (slave link2_1): bond_rcv_validate: skb->dev link2_1
[66905.166878] bond0: (slave link1_1): bond_rcv_validate: skb->dev link1_1
[66905.166883] bond0: (slave link1_1): bond_arp_rcv: link1_1/0 av 1 sv 1 
sip 192.168.30.5 tip 192.168.30.10
[66906.193475] bond0: (slave link1_1): bond_slave_netdev_event called
[66906.198304] bond0: (slave link1_1): bond_slave_netdev_event called
[66906.198312] bond0: (slave link1_1): link status definitely down, 
disabling slave
[66906.198328] bond0: (slave link2_1): making interface the new active one
[66906.205523] bond0: (slave link2_1): bond_slave_netdev_event called
[66906.205557] bond0: (slave link2_1): bond_slave_netdev_event called
[66906.212198] bond0: (slave link2_1): bond_slave_netdev_event called
[66906.212258] bond0: (slave link1_1): bond_slave_netdev_event called
[66906.218529] bond0: (slave link1_1): bond_slave_netdev_event called
[66906.218572] bond0: bond_should_notify_peers: slave link2_1
[66906.223263] bond0: bond_netdev_event received NETDEV_BONDING_FAILOVER

> 
>>     bond_slave state BACKUP mii_status DOWN link_failure_count 466
> 
> 	Perhaps the bridge within netns ns1 is disabling the port for
> some reason?
> 

I do not see a specific issue on the bridge port:

# ip netns exec ns1 ip -d link show link1_2
10: link1_2@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc 
noqueue master br0 state UP mode DEFAULT group default qlen 1000
     link/ether 6a:0d:5b:0c:e8:ab brd ff:ff:ff:ff:ff:ff link-netnsid 0 
promiscuity 1 minmtu 68 maxmtu 65535
     veth
     bridge_slave state forwarding priority 32 cost 2 hairpin off guard 
off root_block off fastleave off learning on flood on port_id 0x8001 
port_no 0x1 designated_port 32769 designated_cost 0 designated_bridge 
8000.6a:d:5b:c:e8:ab designated_root 8000.6a:d:5b:c:e8:ab hold_timer 
0.00 message_age_timer    0.00 forward_delay_timer    0.00 
topology_change_ack 0 config_pending 0 proxy_arp off proxy_arp_wifi off 
mcast_router 1 mcast_fast_leave off mcast_flood on bcast_flood on 
mcast_to_unicast off neigh_suppress off group_fwd_mask 0 
group_fwd_mask_str 0x0 vlan_tunnel off isolated off locked off 
addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 
gso_max_segs 65535 gro_max_size 65536

-Jon
>>
>> Upstream Commit:
>>   c04245328dd7 net: make __sys_accept4_file() static
>>
>> Console Log:
>> [root@fedora ~]# cat ./bond-bz2094911.sh
>> #!/bin/sh
>>
>> set -e
>> set -x
>>
>> dmesg -C
>> ip -all netns delete || true
>> ip link del link1_1 || true
>> ip link del link2_1 || true
>> modprobe -r bonding
>>
>> ip link add name link1_1 type veth peer name link1_2
>> ip link add name link2_1 type veth peer name link2_2
>> ip netns add ns1
>> ip netns exec ns1 ip link add name br0 type bridge vlan_filtering 1
>> ip link set link1_2 up netns ns1
>> ip link set link2_2 up netns ns1
>> ip netns exec ns1 ip link set link1_2 master br0
>> ip netns exec ns1 ip link set link2_2 master br0
>> ip netns exec ns1 ip addr add 192.168.30.5/24 dev br0
>> ip netns exec ns1 ip addr add 192.168.30.7/24 dev br0
>> ip netns exec ns1 ip link set br0 up
>> ip link add name bond0 type bond mode active-backup arp_all_targets any \
>> 	arp_ip_target "192.168.30.7,192.168.30.5" arp_interval 1000 \
>> 	fail_over_mac follow arp_validate active primary_reselect always \
>> 	primary link1_1
>> ip link set bond0 up
>> ip addr add 192.168.30.10/24 dev bond0
>> ifenslave bond0 link1_1 link2_1
>> #ip -ts -o monitor link
>>
>>
>> [root@fedora ~]# ip -ts -o monitor link dev bond0
>> [2022-06-13T22:20:35.289034] [2022-06-13T22:20:35.289846]
>> [2022-06-13T22:20:35.289978] [2022-06-13T22:20:35.290089]
>> [2022-06-13T22:20:35.290200] [2022-06-13T22:20:35.290311] 14: bond0:
>> <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>> group default event BONDING FAILOVER \    link/ether fe:5b:52:88:61:68 brd
>> ff:ff:ff:ff:ff:ff
>> [2022-06-13T22:20:35.291055] 14: bond0:
>> <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>> group default event NOTIFY PEERS \    link/ether fe:5b:52:88:61:68 brd
>> ff:ff:ff:ff:ff:ff
>> [2022-06-13T22:20:35.324494] 14: bond0:
>> <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>> group default event RESEND IGMP \    link/ether fe:5b:52:88:61:68 brd
>> ff:ff:ff:ff:ff:ff
>> [2022-06-13T22:20:36.312078] [2022-06-13T22:20:36.312296]
>> [2022-06-13T22:20:36.312549] [2022-06-13T22:20:36.312670]
>> [2022-06-13T22:20:36.312782] [2022-06-13T22:20:36.312893] 14: bond0:
>> <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>> group default event BONDING FAILOVER \    link/ether fe:5b:52:88:61:68 brd
>> ff:ff:ff:ff:ff:ff
>> [2022-06-13T22:20:36.313134] 14: bond0:
>> <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>> group default event NOTIFY PEERS \    link/ether fe:5b:52:88:61:68 brd
>> ff:ff:ff:ff:ff:ff
>> [2022-06-13T22:20:36.346157] 14: bond0:
>> <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>> group default event RESEND IGMP \    link/ether fe:5b:52:88:61:68 brd
>> ff:ff:ff:ff:ff:ff
>>
>> [root@fedora tests]# ip -d link show dev bond0
>> 14: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>> state UP mode DEFAULT group default qlen 1000
>>     link/ether fe:5b:52:88:61:68 brd ff:ff:ff:ff:ff:ff promiscuity 0
>> minmtu 68 maxmtu 65535
>>     bond mode active-backup active_slave link1_1 miimon 0 updelay 0
>> downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 1000
>> arp_missed_max 2 arp_ip_target 192.168.30.7,192.168.30.5 arp_validate
>> active arp_all_targets any primary link1_1 primary_reselect always
>> fail_over_mac follow xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 1
>> all_slaves_active 0 min_links 0 lp_interval 1 packets_per_slave 1
>> lacp_active on lacp_rate slow ad_select stable tlb_dynamic_lb 1
>> addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536
>> gso_max_segs 65535 gro_max_size 65536
>> [root@fedora tests]#
>>
>> [root@fedora tests]# ip -d -s link show dev link1_1
>> 11: link1_1@if10: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
>> noqueue master bond0 state UP mode DEFAULT group default qlen 1000
>>     link/ether aa:48:a3:a3:2b:2b brd ff:ff:ff:ff:ff:ff link-netns ns1
>> promiscuity 0 minmtu 68 maxmtu 65535
>>     veth
>>     bond_slave state BACKUP mii_status DOWN link_failure_count 466
>> perm_hwaddr b6:19:b6:e3:29:c5 queue_id 0 addrgenmode eui64 numtxqueues 1
>> numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536
>>     RX:  bytes packets errors dropped  missed   mcast
>>         295004    5622      0       0       0       0
>>     TX:  bytes packets errors dropped carrier collsns
>>         254824    4678      0       0       0       0
>>
>> [root@fedora tests]# ip -d -s link show dev link2_1
>> 13: link2_1@if12: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
>> noqueue master bond0 state UP mode DEFAULT group default qlen 1000
>>     link/ether aa:48:a3:a3:2b:2b brd ff:ff:ff:ff:ff:ff link-netns ns1
>> promiscuity 0 minmtu 68 maxmtu 65535
>>     veth
>>     bond_slave state BACKUP mii_status UP link_failure_count 0 perm_hwaddr
>> aa:48:a3:a3:2b:2b queue_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1
>> gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536
>>     RX:  bytes packets errors dropped  missed   mcast
>>         303452    5776      0       0       0       0
>>     TX:  bytes packets errors dropped carrier collsns
>>         179592    2866      0       0       0       0
>>
> 

