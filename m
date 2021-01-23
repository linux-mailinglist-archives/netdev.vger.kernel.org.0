Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD053017A9
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 19:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbhAWSfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 13:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbhAWSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 13:35:46 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F51C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 10:35:05 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id n19so881472ooj.11
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 10:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uOUAj1ysgb+0j1HujC6gwf//1nyiH7g1tdbPs6Cv2YA=;
        b=gYEAYIH6iYA/1MrcTKdv9dG/mKGAPKoCmFvR54eIJ022/7QDF78qYr7zHuQA950FCM
         fdq7HMTCF1lkw+TWLp+QB6Jz9/0fcrqhztOTntY+c80JBBygDb94J9sKLPc5sUX0HHs6
         hoohJcvrXxxaVYzA+rT7/3yMIKzrpE4gDFIPrao/2irmZnVf6e1nYTlEUlQ9MkJXkEdQ
         IqWNFRFKYt4LESSqT/NtmJIxvR1b16PLvC39j9bgJ7Dpakw0iZwJ2F2gazfpcvZvuk1T
         nL7KEQcMj0z7AS5RF6YecdVLMP9owipC5naCjD6GbfE2J7QE/CJnGinsWwjQtfV/eQ7i
         0E0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uOUAj1ysgb+0j1HujC6gwf//1nyiH7g1tdbPs6Cv2YA=;
        b=UwTnLTuGGOdupEzxgrBkRSA9YyLsHksU2mUcWY67whDSRFuhWgM+8ClST/0vZzQpAI
         BgsDrKjTxzSeEw3Gp+g+E/AF6G8XBurmjR2rolc+cBlAWaFZGNqJozQzPA81s9nNHoFa
         K+eUt9I7PKVtvAbPZMtuQVC4krKyq5INMRh83ZQkG8quQ6p2uS3Y/EL6cApqMoeJmyVS
         5yBZYOEdGtAFBZGMmf5oo2CR6GSk7GuMWzQLUQFKiEKaRDmsJUMTIiA0bIpN0UJ/DWw5
         eO4ponE5zCujkv8f+MEZ8VepLHTL6xPgpibKI//wrxuscx2xMhRESldQpnVVbwbYfmKw
         ofww==
X-Gm-Message-State: AOAM531+YIWXJnMZCcxLKqSe0ZDtRclDVo5Uy7fra5pW2z7jxX702jWs
        ZdZQzQcLOwrgrQ0fo3nrmGU=
X-Google-Smtp-Source: ABdhPJws1ethEM9qc36JLRnXsVVhMpJK7WOIh9gDTwHmxvr2OQyWrNN9l8PYwkbNclkOYHDoixPVxg==
X-Received: by 2002:a4a:dc13:: with SMTP id p19mr5334115oov.83.1611426905102;
        Sat, 23 Jan 2021 10:35:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id d17sm2477029oic.12.2021.01.23.10.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 10:35:04 -0800 (PST)
Subject: Re: [PATCH iproute2 v2] bond: support xmit_hash_policy=vlan+srcmac
To:     Jarod Wilson <jarod@redhat.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>
References: <20210113234117.3805255-1-jarod@redhat.com>
 <20210115192137.1878336-1-jarod@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <35de645e-0d2b-8131-12df-9bca8259e6ce@gmail.com>
Date:   Sat, 23 Jan 2021 11:35:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115192137.1878336-1-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 12:21 PM, Jarod Wilson wrote:
> There's a new transmit hash policy being added to the bonding driver that
> is a simple XOR of vlan ID and source MAC, xmit_hash_policy vlan+srcmac.
> This trivial patch makes it configurable and queryable via iproute2.
> 
> $ sudo modprobe bonding mode=2 max_bonds=1 xmit_hash_policy=0
> 
> $ sudo ip link set bond0 type bond xmit_hash_policy vlan+srcmac
> 
> $ ip -d link show bond0
> 11: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether ce:85:5e:24:ce:90 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>     bond mode balance-xor miimon 0 updelay 0 downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none arp_all_targets any
> primary_reselect always fail_over_mac none xmit_hash_policy vlan+srcmac resend_igmp 1 num_grat_arp 1 all_slaves_active 0 min_links 0 lp_interval 1
> packets_per_slave 1 lacp_rate slow ad_select stable tlb_dynamic_lb 1 addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 gso_max_segs
> 65535
> 
> $ grep Hash /proc/net/bonding/bond0
> Transmit Hash Policy: vlan+srcmac (5)
> 
> $ sudo ip link add test type bond help
> Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]
>                 [ clear_active_slave ] [ miimon MIIMON ]
>                 [ updelay UPDELAY ] [ downdelay DOWNDELAY ]
>                 [ peer_notify_delay DELAY ]
>                 [ use_carrier USE_CARRIER ]
>                 [ arp_interval ARP_INTERVAL ]
>                 [ arp_validate ARP_VALIDATE ]
>                 [ arp_all_targets ARP_ALL_TARGETS ]
>                 [ arp_ip_target [ ARP_IP_TARGET, ... ] ]
>                 [ primary SLAVE_DEV ]
>                 [ primary_reselect PRIMARY_RESELECT ]
>                 [ fail_over_mac FAIL_OVER_MAC ]
>                 [ xmit_hash_policy XMIT_HASH_POLICY ]
>                 [ resend_igmp RESEND_IGMP ]
>                 [ num_grat_arp|num_unsol_na NUM_GRAT_ARP|NUM_UNSOL_NA ]
>                 [ all_slaves_active ALL_SLAVES_ACTIVE ]
>                 [ min_links MIN_LINKS ]
>                 [ lp_interval LP_INTERVAL ]
>                 [ packets_per_slave PACKETS_PER_SLAVE ]
>                 [ tlb_dynamic_lb TLB_DYNAMIC_LB ]
>                 [ lacp_rate LACP_RATE ]
>                 [ ad_select AD_SELECT ]
>                 [ ad_user_port_key PORTKEY ]
>                 [ ad_actor_sys_prio SYSPRIO ]
>                 [ ad_actor_system LLADDR ]
> 
> BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb
> ARP_VALIDATE := none|active|backup|all
> ARP_ALL_TARGETS := any|all
> PRIMARY_RESELECT := always|better|failure
> FAIL_OVER_MAC := none|active|follow
> XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+srcmac
> LACP_RATE := slow|fast
> AD_SELECT := stable|bandwidth|count
> 
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  ip/iplink_bond.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

applied to iproute2-next.

