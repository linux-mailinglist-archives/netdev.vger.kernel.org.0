Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D903E37A3
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 02:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhHHAJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 20:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229842AbhHHAJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 20:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628381375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wzr6n8UYZ6q8bOB5ouUUhUM2nbUy/QZCXP20ifY7+EI=;
        b=P61Fjgqcu1WXC3cbVe72SEinU3/g1WNp0l2JPKq7KKBCIudiWr59O8h51DVUkEHEtctnrD
        dxzkc/6x037fiKdVogPJdM8aNRWWbqK07Na5mX9oMITfrQoFODkmeeYCh+53AIUhyaPxDE
        MUv5vBusTcGmATxxFxoaOaI5HUaQa5g=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-o9RRabZEPiGAFLGEcvRFtw-1; Sat, 07 Aug 2021 20:09:34 -0400
X-MC-Unique: o9RRabZEPiGAFLGEcvRFtw-1
Received: by mail-qv1-f71.google.com with SMTP id j13-20020a0cf30d0000b029032dd803a7edso9316454qvl.2
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 17:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wzr6n8UYZ6q8bOB5ouUUhUM2nbUy/QZCXP20ifY7+EI=;
        b=HYwDEMtqbYB9cT2/42BNrl714soaKOsnLL/26GkU01dsmV4zP1fN59iN7J/w1i4Ws7
         FWI9GL5k64tvu81bo71PzJJazsl8FSjIUGLEe7j+ACeDbLTE30VxoRbaLuES2g5ueMJl
         AYbGSgtam6B1gCXL3sdgmcGlIWz48QSDH1sT6tWYgkxLx7dmBNQLjNsbXZUuMcYOjxDu
         8VA4yo/YGJjfeYQVGbj0pnlqVVeCnuxpAMOfnalZIvRZ/6t+KyQoTwNMBN5ErnrjlOkL
         wTh520eI1FZh8cibzTFkqqQLP30bJdttU9orrjEvwJFpUdfXRuLvpyxY8Jw27xErLaym
         oJMg==
X-Gm-Message-State: AOAM530i0vtyygwimCTlkAbbIVmWINe/8myiXMX798yPSS0Al5zGp6+Z
        MISO/WIklCgX884u4FcsbA1XfenxRdH+kRoossyOKr6VnMgs2fbQK8jIwFM1KiZeYIIf4HK/zJ+
        Oj39mdTt4n+n9Di2J
X-Received: by 2002:ac8:5a12:: with SMTP id n18mr14449085qta.173.1628381373707;
        Sat, 07 Aug 2021 17:09:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6sNJsN5U4HkvI33O0X+rGI1NH54xPr2jknIIvVmrju01zxf9HXfsxwTX4/WVTaVxNpetOHw==
X-Received: by 2002:ac8:5a12:: with SMTP id n18mr14449070qta.173.1628381373465;
        Sat, 07 Aug 2021 17:09:33 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id n189sm3383768qka.69.2021.08.07.17.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Aug 2021 17:09:33 -0700 (PDT)
Subject: Re: bonding: link state question
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <020577f3-763d-48fd-73ce-db38c3c7fdf9@redhat.com>
 <22626.1628376134@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <d2dfeba3-6cd6-1760-0abb-6005659ac125@redhat.com>
Date:   Sat, 7 Aug 2021 20:09:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <22626.1628376134@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/21 6:42 PM, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> Is there any reason why bonding should have an operstate of up when none
>> of its slaves are in an up state? In this particular scenario it seems
>> like the bonding device should at least assert NO-CARRIER, thoughts?
>>
>> $ ip -o -d link show | grep "bond5"
>> 2: enp0s31f6: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
>> fq_codel master bond5 state DOWN mode DEFAULT group default qlen 1000\
>> link/ether 8c:8c:aa:f8:62:16 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68
>> maxmtu 9000 \    bond_slave state ACTIVE mii_status UP link_failure_count
>> 0 perm_hwaddr 8c:8c:aa:f8:62:16 queue_id 0 numtxqueues 1 numrxqueues 1
>> gso_max_size 65536 gso_max_segs 65535
>> 41: bond5: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>> state UP mode DEFAULT group default qlen 1000\    link/ether
>> 8c:8c:aa:f8:62:16 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu
>> 65535 \    bond mode balance-xor miimon 0 updelay 0 downdelay 0
>> peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none
> 
> 	I'm going to speculate that your problem is that miimon and
> arp_interval are both 0, and the bond then doesn't have any active
> mechanism to monitor the link state of its interfaces.  There might be a
> warning in dmesg to this effect.
> 
> 	Do you see what you'd consider to be correct behavior if miimon
> is set to 100?
> 

setting miimon = 100 does appear to fix it.

It is interesting that there is no link monitor on by default. For 
example when I enslave enp0s31f6 to a new bond with miimon == 0, 
enp0s31f6 starts admin down and will never de-assert NO-CARRIER the bond 
always results in an operstate of up. It seems like miimon = 100 should 
be the default since some modes cannot use arpmon.

Thank you for the discussion, see below for the steps taken.

$ sudo ip link set dev enp0s31f6 nomaster
$ sudo ip link add dev bond6 type bond mode balance-xor
$ sudo ip -o -d link set dev bond6 up
$ ip -o -d link show dev bond6
62: bond6: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc 
noqueue state DOWN mode DEFAULT group default qlen 1000\    link/ether 
3e:12:01:8a:ed:b1 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 
65535 \    bond mode balance-xor miimon 0 updelay 0 downdelay 0 
peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none 
arp_all_targets any primary_reselect always fail_over_mac none 
xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 1 all_slaves_active 0 
min_links 0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select 
stable tlb_dynamic_lb 1 numtxqueues 16 numrxqueues 16 gso_max_size 65536 
gso_max_segs 65535
$ ip -o -d link show dev enp0s31f6
2: enp0s31f6: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel state DOWN 
mode DEFAULT group default qlen 1000\    link/ether 8c:8c:aa:f8:62:16 
brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 9000 numtxqueues 1 
numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
$ sudo ip -o -d link set dev enp0s31f6 master bond6
$ ip -o -d link show dev bond6
62: bond6: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc 
noqueue state UP mode DEFAULT group default qlen 1000\    link/ether 
8c:8c:aa:f8:62:16 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 
65535 \    bond mode balance-xor miimon 0 updelay 0 downdelay 0 
peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none 
arp_all_targets any primary_reselect always fail_over_mac none 
xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 1 all_slaves_active 0 
min_links 0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select 
stable tlb_dynamic_lb 1 numtxqueues 16 numrxqueues 16 gso_max_size 65536 
gso_max_segs 65535
$ sudo ip link set dev enp0s31f6 nomaster
$ ip -o -d link show dev bond6
62: bond6: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc 
noqueue state DOWN mode DEFAULT group default qlen 1000\    link/ether 
ae:b8:6e:b3:ca:3f brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 
65535 \    bond mode balance-xor miimon 0 updelay 0 downdelay 0 
peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none 
arp_all_targets any primary_reselect always fail_over_mac none 
xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 1 all_slaves_active 0 
min_links 0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select 
stable tlb_dynamic_lb 1 numtxqueues 16 numrxqueues 16 gso_max_size 65536 
gso_max_segs 65535

