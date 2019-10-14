Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35A6D66EF
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbfJNQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:12:21 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54332 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732195AbfJNQMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 12:12:21 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9EGCIwq086213;
        Mon, 14 Oct 2019 11:12:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571069538;
        bh=ZwPD5oKAiu7Ikuno6OgGb/yLQerRbpX8pLV14P22vvk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=CVgNMlfEB6VZM/CNa+0DPNJpimeHhFuLxYvF4+BOIv2Uf4soZ5yfjjdvDSiqpkK9H
         +gL86nACwQn0rz1b+E1H+3rtyuIFQTWu4U6g9IkqabsPh0A2nskBNZMs25nbnNbVC/
         /MHPkqZejNqWHuaTTIe+BLY7+RYucwr7Z7YNwyQk=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9EGCIfL097393
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Oct 2019 11:12:18 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 14
 Oct 2019 11:12:12 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 14 Oct 2019 11:12:12 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9EGCHnE037147;
        Mon, 14 Oct 2019 11:12:17 -0500
Subject: taprio testing with multiple streams
To:     Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com>
 <87v9sv3uuf.fsf@linux.intel.com>
 <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
 <87r23j3rds.fsf@linux.intel.com>
 <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
 <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <6b7a5bf5-0cd0-dd7c-7ecb-f08fdbd2e8b8@ti.com>
Date:   Mon, 14 Oct 2019 12:18:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

Would like to branch off to a separate discussion on taprio testing
with multiple streams. Below is what I have discussed earlier in the
context of the other thread on 'Re: taprio testing - Any help?'
Could you please review the below and let me know if I am doing
anything wrong to configure taprio. I understand that Gate open/close
wouldn't be acurate for software implementation, but this behavior
I am seeing is not correct IMO. So wondering if I missed any steps or
my understanding is wrong.

Additionally I see a kernel crash when I configure using 8 Gates
where my driver has support for 8 hw queues. With 7 Gates, it works
fine without crash. I can provide more logs on this if needed.

Thanks and regards,

Murali
On 10/14/2019 11:33 AM, Murali Karicheri wrote:
> On 10/13/2019 05:10 PM, Vladimir Oltean wrote:
>> Hi Vinicius,
>>

> 
> Using taprio, I am trying the below testcase and expect traffic for
> 4 msec from a specific traffic class (port in this case) and then
> follwed traffic from the other based on the taprio schedule.But a
> wireshark capture shows inter-mixed traffic at the wire.
> 
> For example I set up my taprio as follows:-
> 
> tc qdisc replace dev eth0 parent root handle 100 taprio \
>      num_tc 5 \
>      map 0 1 2 3 4 4 4 4 4 4 4 4 4 4 4 4 \
>      queues 1@0 1@1 1@2 1@3 1@4 \
>      base-time 1564768921123459533 \
>      sched-entry S 01 4000000 \
>      sched-entry S 02 4000000 \
>      sched-entry S 04 4000000 \
>      sched-entry S 08 4000000 \
>      sched-entry S 10 4000000 \
>      clockid CLOCK_TAI
> 
> 
> My taprio schedule shows a 20 msec cycle-time as below
> 
> root@am57xx-evm:~# tc qdisc show  dev eth0
> qdisc taprio 100: root refcnt 9 tc 5 map 0 1 2 3 4 4 4 4 4 4 4 4 4 4 4 4
> queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 
> 1 offset 4 count 1
> clockid TAI offload 0   base-time 0 cycle-time 0 cycle-time-extension 0 
> base-time 1564768921123459533 cycle-time 20000000 cycle-
> time-extension 0
>          index 0 cmd S gatemask 0x1 interval 4000000
>          index 1 cmd S gatemask 0x2 interval 4000000
>          index 2 cmd S gatemask 0x4 interval 4000000
>          index 3 cmd S gatemask 0x8 interval 4000000
>          index 4 cmd S gatemask 0x10 interval 4000000
> 
> qdisc pfifo 0: parent 100:5 limit 1000p
> qdisc pfifo 0: parent 100:4 limit 1000p
> qdisc pfifo 0: parent 100:3 limit 1000p
> qdisc pfifo 0: parent 100:2 limit 1000p
> qdisc pfifo 0: parent 100:1 limit 1000p
> 
> 
> Now I classify packets using the iptables command from Vincius which
> works to do the job for this test.
> 
> 
> iptables -t mangle -A POSTROUTING -p udp --dport 10000 -j CLASSIFY 
> --set-class 0:1
> iptables -t mangle -A POSTROUTING -p udp --dport 20000 -j CLASSIFY 
> --set-class 0:2
> iptables -t mangle -A POSTROUTING -p udp --dport 30000 -j CLASSIFY 
> --set-class 0:3
> iptables -t mangle -A POSTROUTING -p udp --dport 40000 -j CLASSIFY 
> --set-class 0:4
> 
> I set up 4 iperf UDP streams as follows:-
> 
> iperf -c 192.168.2.10 -u -p 10000 -t60&
> iperf -c 192.168.2.10 -u -p 20000 -t60&
> iperf -c 192.168.2.10 -u -p 30000 -t60&
> iperf -c 192.168.2.10 -u -p 40000 -t60&
> 
> My expectation is as follows
> 
> AAAAAABBBBBCCCCCDDDDDEEEEE
> 
> Where AAAAA is traffic from TC0, BBBBB is udp stream for port 10000
> CCCCC is stream for port 20000, DDDDD for 30000 and EEEEE for 40000.
> Each can be max of 4 msec. Is the expection correct? At least that
> is my understanding.
> 
> But what I see is alternating packets with port 10000/20000/30000/40000
> at the wireshark capture and it doesn't make sense to me. If you
> look at the timestamp, there is nothing showing the Gate is honored
> for Tx. Am I missing something?
> 
> The tc stats shows packets are going through specific TC/Gate
> 
> root@am57xx-evm:~# tc -d -p -s qdisc show dev eth0
> qdisc taprio 100: root refcnt 9 tc 5 map 0 1 2 3 4 4 4 4 4 4 4 4 4 4 4 4
> queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 
> 1 offset 4 count 1
> clockid TAI offload 0   base-time 0 cycle-time 0 cycle-time-extension 0 
> base-time 1564768921123459533 cycle-time 20000000 cycle-
> time-extension 0
>          index 0 cmd S gatemask 0x1 interval 4000000
>          index 1 cmd S gatemask 0x2 interval 4000000
>          index 2 cmd S gatemask 0x4 interval 4000000
>          index 3 cmd S gatemask 0x8 interval 4000000
>          index 4 cmd S gatemask 0x10 interval 4000000
> 
>   Sent 80948029 bytes 53630 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:5 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:4 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:3 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:2 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:1 limit 1000p
>   Sent 16210237 bytes 10814 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> 
> Also my hardware queue stats shows frames going through correct queues.
> Am I missing something?
> 
> root@am57xx-evm:~# ethtool -S eth0
> NIC statistics:
>       Good Rx Frames: 251
>       Broadcast Rx Frames: 223
>       Multicast Rx Frames: 2
>       Pause Rx Frames: 0
>       Rx CRC Errors: 0
>       Rx Align/Code Errors: 0
>       Oversize Rx Frames: 0
>       Rx Jabbers: 0
>       Undersize (Short) Rx Frames: 0
>       Rx Fragments: 0
>       Rx Octets: 99747
>       Good Tx Frames: 75837
>       Broadcast Tx Frames: 89
>       Multicast Tx Frames: 97
>       Pause Tx Frames: 0
>       Deferred Tx Frames: 0
>       Collisions: 0
>       Single Collision Tx Frames: 0
>       Multiple Collision Tx Frames: 0
>       Excessive Collisions: 0
>       Late Collisions: 0
>       Tx Underrun: 0
>       Carrier Sense Errors: 0
>       Tx Octets: 114715759
>       Rx + Tx 64 Octet Frames: 11
>       Rx + Tx 65-127 Octet Frames: 89
>       Rx + Tx 128-255 Octet Frames: 6
>       Rx + Tx 256-511 Octet Frames: 326
>       Rx + Tx 512-1023 Octet Frames: 0
>       Rx + Tx 1024-Up Octet Frames: 75656
>       Net Octets: 114815506
>       Rx Start of Frame Overruns: 0
>       Rx Middle of Frame Overruns: 0
>       Rx DMA Overruns: 0
>       Rx DMA chan 0: head_enqueue: 2
>       Rx DMA chan 0: tail_enqueue: 505
>       Rx DMA chan 0: pad_enqueue: 0
>       Rx DMA chan 0: misqueued: 0
>       Rx DMA chan 0: desc_alloc_fail: 0
>       Rx DMA chan 0: pad_alloc_fail: 0
>       Rx DMA chan 0: runt_receive_buf: 0
>       Rx DMA chan 0: runt_transmit_bu: 0
>       Rx DMA chan 0: empty_dequeue: 0
>       Rx DMA chan 0: busy_dequeue: 244
>       Rx DMA chan 0: good_dequeue: 252
>       Rx DMA chan 0: requeue: 1
>       Rx DMA chan 0: teardown_dequeue: 127
>       Tx DMA chan 0: head_enqueue: 15631
>       Tx DMA chan 0: tail_enqueue: 1
>       Tx DMA chan 0: pad_enqueue: 0
>       Tx DMA chan 0: misqueued: 1
>       Tx DMA chan 0: desc_alloc_fail: 0
>       Tx DMA chan 0: pad_alloc_fail: 0
>       Tx DMA chan 0: runt_receive_buf: 0
>       Tx DMA chan 0: runt_transmit_bu: 11
>       Tx DMA chan 0: empty_dequeue: 15632
>       Tx DMA chan 0: busy_dequeue: 0
>       Tx DMA chan 0: good_dequeue: 15632
>       Tx DMA chan 0: requeue: 0
>       Tx DMA chan 0: teardown_dequeue: 0
>       Tx DMA chan 1: head_enqueue: 15284
>       Tx DMA chan 1: tail_enqueue: 0
>       Tx DMA chan 1: pad_enqueue: 0
>       Tx DMA chan 1: misqueued: 0
>       Tx DMA chan 1: desc_alloc_fail: 0
>       Tx DMA chan 1: pad_alloc_fail: 0
>       Tx DMA chan 1: runt_receive_buf: 0
>       Tx DMA chan 1: runt_transmit_bu: 0
>       Tx DMA chan 1: empty_dequeue: 15284
>       Tx DMA chan 1: busy_dequeue: 0
>       Tx DMA chan 1: good_dequeue: 15284
>       Tx DMA chan 1: requeue: 0
>       Tx DMA chan 1: teardown_dequeue: 0
>       Tx DMA chan 2: head_enqueue: 23513
>       Tx DMA chan 2: tail_enqueue: 0
>       Tx DMA chan 2: pad_enqueue: 0
>       Tx DMA chan 2: misqueued: 0
>       Tx DMA chan 2: desc_alloc_fail: 0
>       Tx DMA chan 2: pad_alloc_fail: 0
>       Tx DMA chan 2: runt_receive_buf: 0
>       Tx DMA chan 2: runt_transmit_bu: 2
>       Tx DMA chan 2: empty_dequeue: 23513
>       Tx DMA chan 2: busy_dequeue: 0
>       Tx DMA chan 2: good_dequeue: 23513
>       Tx DMA chan 2: requeue: 0
>       Tx DMA chan 2: teardown_dequeue: 0
>       Tx DMA chan 3: head_enqueue: 10704
>       Tx DMA chan 3: tail_enqueue: 0
>       Tx DMA chan 3: pad_enqueue: 0
>       Tx DMA chan 3: misqueued: 0
>       Tx DMA chan 3: desc_alloc_fail: 0
>       Tx DMA chan 3: pad_alloc_fail: 0
>       Tx DMA chan 3: runt_receive_buf: 0
>       Tx DMA chan 3: runt_transmit_bu: 0
>       Tx DMA chan 3: empty_dequeue: 10704
>       Tx DMA chan 3: busy_dequeue: 0
>       Tx DMA chan 3: good_dequeue: 10704
>       Tx DMA chan 3: requeue: 0
>       Tx DMA chan 3: teardown_dequeue: 0
>       Tx DMA chan 4: head_enqueue: 10704
>       Tx DMA chan 4: tail_enqueue: 0
>       Tx DMA chan 4: pad_enqueue: 0
>       Tx DMA chan 4: misqueued: 0
>       Tx DMA chan 4: desc_alloc_fail: 0
>       Tx DMA chan 4: pad_alloc_fail: 0
>       Tx DMA chan 4: runt_receive_buf: 0
>       Tx DMA chan 4: runt_transmit_bu: 0
>       Tx DMA chan 4: empty_dequeue: 10704
>       Tx DMA chan 4: busy_dequeue: 0
>       Tx DMA chan 4: good_dequeue: 10704
>       Tx DMA chan 4: requeue: 0
>       Tx DMA chan 4: teardown_dequeue: 0
> 
> 
> I am on a 4.19.y kernel with patches specific to taprio
> backported. Am I missing anything related to taprio. I will
> try on the latest master branch as well. But if you can point out
> anything that will be helpful.
> 
Just want to let you know that I see the same behavior with the
v5.3 on upstream master branch.

> ce4ca3f9dd9b6fc9652d65f4a9ddf29b58f8db33 (HEAD -> LCPD-17228-v1) net: 
> sched: sch_taprio: fix memleak in error path for sched list parse
> 11b521a046feff4373a499eadf4ecf884a9d8624 net: sched: sch_taprio: back 
> reverted counterpart for rebase
> 372d2da4ce26ff832a5693e909689fe2b76712c6 taprio: Adjust timestamps for 
> TCP packets
> 72039934f2f6c959010e2ba848e7e627a2432bfd taprio: make clock reference 
> conversions easier
> 7529028441203b3d80a3700e3694fd4147ed16fd taprio: Add support for 
> txtime-assist mode
> 9d96c8e4518b643b848de44986847408e9b6194a taprio: Remove inline directive
> 0294b3b4bc059427fceff20948f9b30fbb4e2d43 etf: Add skip_sock_check
> e4eb6c594326ea9d4dfe26241fc78df0c765d994 taprio: calculate cycle_time 
> when schedule is installed
> a4ed85ac58c396d257b823003c5c9a9d684563d9 etf: Don't use BIT() in UAPI 
> headers.
> fc5e4f7fcc9d39c3581e0a5ae15a04e609260dc7 taprio: add null check on 
> sched_nest to avoid potential null pointer dereference
> bc0749127e5a423ed9ef95962a83f526352a38a6 taprio: Add support for 
> cycle-time-extension
> aad8879bfc49bfb7a259377f64a1d44809b97552 taprio: Add support for setting 
> the cycle-time manually
> 768089594ced5386b748d9049f86355d620be92d taprio: Add support adding an 
> admin schedule
> 1298a8a6fe373234f0d7506cc9dc6182133151ef net: sched: sch_taprio: align 
> code the following patches to be applied
> 8c87fe004222625d79025f54eaa893b906f19cd4 taprio: Fix potencial use of 
> invalid memory during dequeue()
> 26cdb540c971b20b9b68a5fe8fff45099991c081 net/sched: taprio: fix build 
> without 64bit div
> 35e63bea024f00f0cb22e40b6e47d0c7290d588b net: sched: taprio: Fix 
> taprio_dequeue()
> 50d8609b6a09a12f019728474449d0e4f19ed297 net: sched: taprio: Fix 
> taprio_peek()
> bd6ad2179e7d0371d7051155626e11a5ce8eeb40 net: sched: taprio: Remove 
> should_restart_cycle()
> 4841094710044dd7f2556dd808e6c34ff0f40697 net: sched: taprio: Refactor 
> taprio_get_start_time()
> ec9b38a4a789cc82f1198f5135eb222852776d21 net/sched: taprio: fix 
> picos_per_byte miscalculation
> 28b669c38bf8d03c8d800cf63e33861886ea0100 tc: Add support for configuring 
> the taprio scheduler
> eed00d0cfbc52d8899d935f3c6f740aa6dadfa39 net_sched: sch_fq: remove dead 
> code dealing with retransmits
> d9c6403ca03399062a219a61f86dd3c86ed573d8 tcp: switch 
> tcp_internal_pacing() to tcp_wstamp_ns
> 1e7d920773743f58c3de660e47c3b72e5a50d912 tcp: switch tcp and sch_fq to 
> new earliest departure time model
> c0554b84146dd58893f0e0cb6ccdeadb0893e22c tcp: switch internal pacing 
> timer to CLOCK_TAI
> 5ac72108dd580ba9ace028e7dd7e325347bcbe69 tcp: provide earliest departure 
> time in skb->tstamp
> a59ff4b92003169483b2f3548e6f8245b1ae1f28 tcp: add tcp_wstamp_ns socket 
> field
> fb534f9a4e8e96f3688491a901df363d14f6806d net_sched: sch_fq: switch to 
> CLOCK_TAI
> fb898b71da8caadb6221e3f8a71417389cb58c46 tcp: introduce 
> tcp_skb_timestamp_us() helper
> 1948ca0e3cab893be3375b12e552e6c0751458b1 net: sched: rename 
> qdisc_destroy() to qdisc_put()
> 0cabba2b47949524cacbb68678767307a4f0a23e (tag: ti2019.04-rc4, 
> lcpd/ti-linux-4.19.y) Merged TI feature connectivity into ti-linux-4.19.y
> 
>>
>> Regards,
>> -Vladimir
>>
> 
> 

