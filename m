Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BEF22BD5C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXFNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgGXFNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:13:48 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D27C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 22:13:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x9so3858701plr.2
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 22:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5nolneEg5Z+rxSgnnf47ZOOrB1soNpwDZVp3An22XuM=;
        b=tjP/fgn24yprtnvDDyyOx4ihp4ZReNMTKKNcv5V8svAU3FtzIhpoC94tixPK1pjYkb
         MfuQdDqg5fiRa/XkyMzp+/ESIRLPmKxs8tzKx/PXfHglbhkykXi/PauTwHhhzSkG+x78
         Vh5r8smghfMlWA1mOGWfuCM3P/64WlBFETmFWpZ7DUnDGVaFTB/c/5Ogw01V6W+ZrBFB
         CdVwzwd+hWuHp3iS/i8D1YhrYUXfGJyZDhtAM40c0e74D560ff/WJ8r8Vok4FBOuYEwB
         Cn03tb2OmR+I73NTLTg1RfOi17HZ5XR6QxgJijJ7QIRNmCCKW7qBuwqFinVbCrBJG3RE
         12OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5nolneEg5Z+rxSgnnf47ZOOrB1soNpwDZVp3An22XuM=;
        b=oiIz+oGLPBt+J7akj4hyRtC1ykmDyZng2JZpvHNbyTjgJmctvTSBC6eFjhprNF+lfn
         GpMteD5ztPbMwy/oAuXRKgDAbzA3h5RrvBc+1ahXVcePKKsn9ikFo5zP8TIRLOZerAad
         g1B/ae9sf9hypftlHJcP8MevWxqBY+PYSrxay+P7J32sUC701+sAqIzm6eVyPWv78tZZ
         x97bxpJ/RgRVkDktlxZmNVEEe22pWE2/bHzAHY4Rowze0u+s/r6ROw1Y1d44H6ixGgcN
         4ZIzZy788c2MndmmCpt80W/VWn5qeZvSlL49yyvmB3QStC34AFtm/cUneJi9qGUiKZY6
         sHhg==
X-Gm-Message-State: AOAM532GadmSdYrbGZ3zsdjwtH86uBSdpJ4gtYLoPoeh+odDRtdMZldo
        gFzSW2MXuWILBldf5zokAKlfzvbB
X-Google-Smtp-Source: ABdhPJzxO7PBDYKlbbbme8VzR6YSKEauDMUWhdAKIDwOHX+dcaBLQd6BtLdv4mKKWUHh0bEWJBx9iA==
X-Received: by 2002:a17:902:6506:: with SMTP id b6mr6405994plk.13.1595567627481;
        Thu, 23 Jul 2020 22:13:47 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s187sm4981290pfs.83.2020.07.23.22.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 22:13:46 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENILHYyXSBpcHZsYW46IGFkZCB0aGUgY2hl?=
 =?UTF-8?Q?ck_of_ip_header_checksum?=
To:     "Guodeqing (A)" <geffrey.guo@huawei.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "maheshb@google.com" <maheshb@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1595409499-25008-1-git-send-email-geffrey.guo@huawei.com>
 <20200722.130408.2000579366934431355.davem@davemloft.net>
 <6c050a3a1111445287edc52ca6cb056d@huawei.com>
 <CANn89i+OyQcZvAHi5ScehV2fyDyS0KsOpigU-KUokbD0z-NkmA@mail.gmail.com>
 <7bb7522a2bda40b8b4a9aac54ea1098b@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <05c52750-7f22-74f1-2470-d3e246a25113@gmail.com>
Date:   Thu, 23 Jul 2020 22:13:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7bb7522a2bda40b8b4a9aac54ea1098b@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please do not top-post on netdev / lkml  ( https://www.mediawiki.org/wiki/Mailing_list_etiquette )



On 7/23/20 8:35 PM, Guodeqing (A) wrote:
> The ihl check maybe not suitable in ip_fast_csum, the correct of the ihl value can be checked before calling the ip_fast_csum.
> 
> The implementation of ip_fast_csum is different in different cpu architecture. the IP packet will do ip forward in the ipvlan l3/l3s mode and the corrupted ip packet
> 
> should be discarded as soon as possible. Thanks.

Then the "as soon as possible" should be done in netem, right ?

Alternatively fix arm64 ip_fast_csum() so that it matches the reference implementation (lib/checksum.c)

We do not want adding code in ipvlan that is essentially dead code for normal usages.

ip_fast_csum() is not free.

So, this is a NACK from my side, in case this was not clear enough.



> 
> 
> -----邮件原件-----
> 发件人: Eric Dumazet [mailto:edumazet@google.com] 
> 发送时间: Thursday, July 23, 2020 10:15
> 收件人: Guodeqing (A) <geffrey.guo@huawei.com>
> 抄送: David Miller <davem@davemloft.net>; kuba@kernel.org; maheshb@google.com; netdev@vger.kernel.org
> 主题: Re: [PATCH,v2] ipvlan: add the check of ip header checksum
> 
> On Wed, Jul 22, 2020 at 6:59 PM Guodeqing (A) <geffrey.guo@huawei.com> wrote:
>>
>> I am sorry, the mail is not sent to you directly;
>>
>> If do the following test,this will cause a panic in a arm64 VM. this can be reproduced easily.
>>
>> Linux osc 5.8.0-rc6+ #3 SMP Thu Jul 23 01:40:47 UTC 2020 aarch64
>>
>> The programs included with the Debian GNU/Linux system are free 
>> software; the exact distribution terms for each program are described 
>> in the individual files in /usr/share/doc/*/copyright.
>>
>> Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent 
>> permitted by applicable law.
>> root@osc:~# ifconfig eth0 up
>> root@osc:~# ip netns add ns1
>> root@osc:~# ip link add gw link eth0 type ipvlan root@osc:~# ip addr 
>> add 168.16.0.1/24 dev gw root@osc:~# ip link set dev gw up root@osc:~# 
>> ip link add ip1 link eth0 type ipvlan root@osc:~# ip link set ip1 
>> netns ns1 root@osc:~# ip netns exec ns1 ip link set ip1 up root@osc:~# 
>> ip netns exec ns1 ip addr add 168.16.0.2/24 dev ip1 root@osc:~# ip 
>> netns exec ns1 ip link set lo up root@osc:~# ip netns exec ns1 ip addr 
>> add 127.0.0.1/8 dev lo RTNETLINK answers: File exists root@osc:~# ip 
>> netns exec ns1 tc qdisc add dev ip1 root netem corrupt 100% 
>> root@osc:~# ip netns exec ns1 ping 168.16.0.1 PING 168.16.0.1 
>> (168.16.0.1) 56(84) bytes of data.
>> From 168.16.0.1 icmp_seq=2 Destination Host Unreachable From 
>> 168.16.0.1 icmp_seq=12 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=30 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=48 ttl=64 time=0.052 ms
>> 64 bytes from 168.16.0.1: icmp_seq=65 ttl=64 time=0.060 ms From 
>> 168.16.0.1 icmp_seq=80 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=97 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=100 ttl=64 time=0.022 ms
>> 64 bytes from 168.16.0.1: icmp_seq=101 ttl=64 time=0.054 ms
>> 64 bytes from 168.16.0.1: icmp_seq=103 ttl=64 time=0.053 ms From 
>> 168.16.0.1 icmp_seq=102 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=127 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=132 ttl=64 time=0.057 ms
>> 64 bytes from 168.16.0.1: icmp_seq=135 ttl=64 time=0.051 ms
>> 64 bytes from 168.16.0.1: icmp_seq=141 ttl=64 time=0.051 ms From 
>> 168.16.0.1 icmp_seq=140 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=142 Destination Host Unreachable From 168.16.0.1 icmp_seq=150 
>> Destination Host Unreachable From 168.16.0.1 icmp_seq=154 Destination 
>> Host Unreachable From 168.16.0.1 icmp_seq=164 Destination Host 
>> Unreachable From 168.16.0.1 icmp_seq=169 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=173 ttl=64 time=0.056 ms
>> 64 bytes from 168.16.0.1: icmp_seq=185 ttl=64 time=0.058 ms
>> 64 bytes from 168.16.0.1: icmp_seq=202 ttl=64 time=0.056 ms
>> 64 bytes from 168.16.0.1: icmp_seq=203 ttl=64 time=0.057 ms
>> 64 bytes from 168.16.0.1: icmp_seq=219 ttl=64 time=0.050 ms
>> 64 bytes from 168.16.0.1: icmp_seq=227 ttl=64 time=0.057 ms
>> 64 bytes from 168.16.0.1: icmp_seq=228 ttl=64 time=0.044 ms From 
>> 168.16.0.1 icmp_seq=237 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=239 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=243 ttl=64 time=0.053 ms From 
>> 168.16.0.1 icmp_seq=242 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=246 ttl=64 time=0.056 ms
>> 64 bytes from 168.16.0.1: icmp_seq=254 ttl=64 time=0.056 ms
>> 64 bytes from 168.16.0.1: icmp_seq=255 ttl=64 time=0.054 ms From 
>> 168.16.0.1 icmp_seq=263 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=269 Destination Host Unreachable From 168.16.0.1 icmp_seq=273 
>> Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=279 ttl=64 time=0.057 ms From 
>> 168.16.0.1 icmp_seq=284 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=286 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=291 ttl=64 time=0.054 ms
>> 64 bytes from 168.16.0.1: icmp_seq=293 ttl=64 time=0.058 ms From 
>> 168.16.0.1 icmp_seq=294 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=298 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=309 ttl=64 time=0.056 ms From 
>> 168.16.0.1 icmp_seq=310 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=312 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=332 ttl=64 time=0.055 ms From 
>> 168.16.0.1 icmp_seq=334 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=340 ttl=64 time=0.055 ms
>> 64 bytes from 168.16.0.1: icmp_seq=344 ttl=64 time=0.050 ms
>> 64 bytes from 168.16.0.1: icmp_seq=355 ttl=64 time=0.057 ms
>> 64 bytes from 168.16.0.1: icmp_seq=358 ttl=64 time=0.050 ms From 
>> 168.16.0.1 icmp_seq=356 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=369 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=382 ttl=64 time=0.053 ms From 
>> 168.16.0.1 icmp_seq=381 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=396 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=400 ttl=64 time=0.058 ms From 
>> 168.16.0.1 icmp_seq=406 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=414 Destination Host Unreachable From 168.16.0.1 icmp_seq=417 
>> Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=422 ttl=64 time=0.018 ms
>> 64 bytes from 168.16.0.1: icmp_seq=423 ttl=64 time=0.058 ms
>> 64 bytes from 168.16.0.1: icmp_seq=429 ttl=64 time=0.056 ms
>> 64 bytes from 168.16.0.1: icmp_seq=445 ttl=64 time=0.049 ms From 
>> 168.16.0.1 icmp_seq=444 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=453 Destination Host Unreachable From 168.16.0.1 icmp_seq=455 
>> Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=456 ttl=64 time=0.024 ms
>> 64 bytes from 168.16.0.1: icmp_seq=469 ttl=64 time=0.058 ms From 
>> 168.16.0.1 icmp_seq=475 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=483 ttl=64 time=0.054 ms From 
>> 168.16.0.1 icmp_seq=488 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=504 ttl=64 time=0.056 ms
>> 64 bytes from 168.16.0.1: icmp_seq=505 ttl=64 time=0.055 ms From 
>> 168.16.0.1 icmp_seq=510 Destination Host Unreachable From 168.16.0.1 
>> icmp_seq=511 Destination Host Unreachable
>> 64 bytes from 168.16.0.1: icmp_seq=516 ttl=64 time=0.055 ms From 
>> 168.16.0.1 icmp_seq=519 Destination Host Unreachable [  582.368938] 
>> Unable to handle kernel paging request at virtual address 
>> ffff0000f85f0000 [  582.369732] Mem abort info:
>> [  582.369987]   ESR = 0x96000007
>> [  582.370266]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [  582.370833]   SET = 0, FnV = 0
>> [  582.371113]   EA = 0, S1PTW = 0
>> [  582.371391] Data abort info:
>> [  582.371671]   ISV = 0, ISS = 0x00000007
>> [  582.372017]   CM = 0, WnR = 0
>> [  582.372299] swapper pgtable: 4k pages, 48-bit VAs, 
>> pgdp=000000012dab7000 [  582.372896] [ffff0000f85f0000] 
>> pgd=000000013fff8003, p4d=000000013fff8003, pud=000000013f9f4003, 
>> pmd=000000013f838003, pte=0000000000000000 [  582.374033] Internal error: Oops: 96000007 [#1] SMP [  582.374468] Modules linked in:
>> [  582.374795] CPU: 1 PID: 525 Comm: ping Not tainted 5.8.0-rc6+ #3 [  
>> 582.375468] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 
>> 02/06/2015 [  582.376215] pstate: 20400005 (nzCv daif +PAN -UAO 
>> BTYPE=--) [  582.376805] pc : __ip_local_out+0x84/0x188 [  582.377234] 
>> lr : ip_local_out+0x34/0x68 [  582.377635] sp : ffff800013263440 [  
>> 582.377986] x29: ffff800013263440 x28: 0000000000000001 [  582.378536] 
>> x27: ffff8000111d2018 x26: ffff8000114cba80 [  582.379093] x25: 
>> ffff0000ec4e7400 x24: 0000000000000000 [  582.379653] x23: 
>> 0000000000000062 x22: ffff8000114c9000 [  582.380221] x21: 
>> ffff0000d97ac600 x20: ffff0000ec519000 [  582.380778] x19: 
>> ffff8000115b5bc0 x18: 0000000000000000 [  582.381324] x17: 
>> 0000000000000000 x16: 0000000000000000 [  582.381876] x15: 
>> 0000000000000000 x14: 0000000000000000 [  582.382431] x13: 
>> 0000000000000000 x12: 0000000000000001 [  582.382986] x11: 
>> ffff800010d21838 x10: 0000000000000001 [  582.383567] x9 : 
>> 0000000000000001 x8 : 0000000000000000 [  582.384136] x7 : 
>> 0000000000000000 x6 : ffff0000ec4e5e00 [  582.384693] x5 : 
>> 024079ca54000184 x4 : ffff0000ec4e5e10 [  582.385246] x3 : 
>> 0000000000000000 x2 : ffff0004ec4e5e20 [  582.385808] x1 : 
>> ffff0000f85f0000 x0 : 031d079626a9c7ae [  582.386365] Call trace:
>> [  582.386629]  __ip_local_out+0x84/0x188 [  582.387030]  
>> ip_local_out+0x34/0x68 [  582.387400]  ipvlan_queue_xmit+0x548/0x5c0 [  
>> 582.387845]  ipvlan_start_xmit+0x2c/0x90 [  582.388283]  
>> dev_hard_start_xmit+0xb4/0x260 [  582.388732]  
>> sch_direct_xmit+0x1b4/0x550 [  582.389145]  __qdisc_run+0x140/0x648 [  
>> 582.389524]  __dev_queue_xmit+0x6a4/0x8b8 [  582.389948]  
>> dev_queue_xmit+0x24/0x30 [  582.390339]  ip_finish_output2+0x324/0x580 
>> [  582.390770]  __ip_finish_output+0x130/0x218 [  582.391218]  
>> ip_finish_output+0x38/0xd0 [  582.391633]  ip_output+0xb4/0x130 [  
>> 582.391984]  ip_local_out+0x58/0x68 [  582.392369]  
>> ip_send_skb+0x2c/0x88 [  582.392729]  ip_push_pending_frames+0x44/0x50 
>> [  582.393189]  raw_sendmsg+0x7a4/0x988 [  582.393569]  
>> inet_sendmsg+0x4c/0x78 [  582.393942]  sock_sendmsg+0x58/0x68 [  
>> 582.394311]  ____sys_sendmsg+0x284/0x2c0 [  582.394721]  
>> ___sys_sendmsg+0x90/0xd0 [  582.395113]  __sys_sendmsg+0x78/0xd0 [  
>> 582.395504]  __arm64_sys_sendmsg+0x2c/0x38 [  582.395942]  
>> el0_svc_common.constprop.2+0x70/0x128
>> [  582.396472]  do_el0_svc+0x34/0xa0
>> [  582.396834]  el0_sync_handler+0xec/0x128 [  582.397249]  
>> el0_sync+0x140/0x180 [  582.397611] Code: ab030005 91001442 9a030000 
>> 8b020882 (b8404423) [  582.398264] ---[ end trace 92adb54c8611f8c5 
>> ]--- [  582.398754] Kernel panic - not syncing: Fatal exception in 
>> interrupt [  582.399481] SMP: stopping secondary CPUs [  582.399923] 
>> Kernel Offset: 0xc0000 from 0xffff800010000000 [  582.400561] 
>> PHYS_OFFSET: 0x40000000 [  582.400939] CPU features: 0x040002,22a08238 
>> [  582.401380] Memory Limit: none [  582.401710] ---[ end Kernel panic 
>> - not syncing: Fatal exception in interrupt ]---
>>
>> This panic is because the ip header is corrupted. The ihl of the ip header is error，this cause ip_fast_csum access the illegal address.
>> 23 static inline __sum16 ip_fast_csum(const void *iph, unsigned int 
>> ihl)
>>  24 {
>>  25     __uint128_t tmp;
>>  26     u64 sum;
>>  27
>>  28     tmp = *(const __uint128_t *)iph;
>>  29     iph += 16;
>>  30     ihl -= 4;                                           -----here, if ihl is smaller than 5, the next will access the illegal address.
> 
> 
> Well, the bug is there then.
> 
> Code for other arches is different.
> 
> x86 for instance has a test for silly ihl
> 
> static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl) { unsigned int sum;
> 
> asm("  movl (%1), %0\n"
>     "  subl $4, %2\n"
>     "  jbe 2f\n"                          --- here
>     "  addl 4(%1), %0\n"
>     "  adcl 8(%1), %0\n"
>     "  adcl 12(%1), %0\n"
>     "1: adcl 16(%1), %0\n"
>     "  lea 4(%1), %1\n"
>     "  decl %2\n"
>     "  jne 1b\n"
>     "  adcl $0, %0\n"
>     "  movl %0, %2\n"
>     "  shrl $16, %0\n"
>     "  addw %w2, %w0\n"
>     "  adcl $0, %0\n"
>     "  notl %0\n"
>     "2:"
> /* Since the input registers which are loaded with iph and ihl
>    are modified, we must also specify them as outputs, or gcc
>    will assume they contain their original values. */
>     : "=r" (sum), "=r" (iph), "=r" (ihl)
>     : "1" (iph), "2" (ihl)
>     : "memory");
> return (__force __sum16)sum;
> }
> 
> 
>>  31     tmp += ((tmp >> 64) | (tmp << 64));
>>  32     sum = tmp >> 64;
>>  33     do {
>>  34         sum += *(const u32 *)iph;
>>  35         iph += 4;
>>  36     } while (--ihl);
>>  37
>>  38     sum += ((sum >> 32) | (sum << 32));
>>  39     return csum_fold((__force u32)(sum >> 32));
>>  40 }
>>
>> I think this panic may be a problem, thanks.
>>
>>
>>
>> -----邮件原件-----
>> 发件人: Cong Wang [mailto:xiyou.wangcong@gmail.com]
>> 发送时间: Wednesday, July 22, 2020 3:39
>> 收件人: Guodeqing (A) <geffrey.guo@huawei.com>
>> 抄送: David Miller <davem@davemloft.net>; Jakub Kicinski 
>> <kuba@kernel.org>; Mahesh Bandewar <maheshb@google.com>; Eric Dumazet 
>> <edumazet@google.com>; Linux Kernel Network Developers 
>> <netdev@vger.kernel.org>
>> 主题: Re: [PATCH] ipvlan: add the check of ip header checksum
>>
>> On Tue, Jul 21, 2020 at 6:17 AM guodeqing <geffrey.guo@huawei.com> wrote:
>>>
>>> The ip header checksum can be error in the following steps.
>>> $ ip netns add ns1
>>> $ ip link add gw link eth0 type ipvlan $ ip addr add 168.16.0.1/24 
>>> dev gw $ ip link set dev gw up $ ip link add ip1 link eth0 type 
>>> ipvlan $ ip link set ip1 netns ns1 $ ip netns exec ns1 ip link set 
>>> ip1 up $ ip netns exec ns1 ip addr add 168.16.0.2/24 dev ip1 $ ip 
>>> netns exec ns1 tc qdisc add dev ip1 root netem corrupt 50% $ ip 
>>> netns exec ns1 ping
>>> 168.16.0.1
>>>
>>> The ip header of a packet maybe modified when it steps in 
>>> ipvlan_process_v4_outbound because of the netem, the corruptted 
>>> packets should be dropped.
>>
>> This does not make much sense, as you intentionally corrupt the header. More importantly, the check you add is too late, right?
>> ipvlan_xmit_mode_l3() already does the addr lookup with IP header,
>>
>> Thanks.
>>
>> -----邮件原件-----
>> 发件人: David Miller [mailto:davem@davemloft.net]
>> 发送时间: Thursday, July 23, 2020 4:04
>> 收件人: Guodeqing (A) <geffrey.guo@huawei.com>
>> 抄送: kuba@kernel.org; maheshb@google.com; edumazet@google.com; 
>> netdev@vger.kernel.org
>> 主题: Re: [PATCH,v2] ipvlan: add the check of ip header checksum
>>
>> From: guodeqing <geffrey.guo@huawei.com>
>> Date: Wed, 22 Jul 2020 17:18:19 +0800
>>
>>> The ip header checksum can be error in the following steps.
>>
>> You did not respond to my feedback from your previous submissions.
>>
>> Packets created inside of the kernel have correct checksums, and the ipvlan driver can depend upon this precondition.
>>
>> I am not applying this patch, sorry.
