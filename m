Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480AFD988E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390436AbfJPRiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:38:18 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:54144 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388899AbfJPRiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:38:17 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9GHGkwW047926;
        Wed, 16 Oct 2019 12:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571246207;
        bh=CUdc+rcnc6msHfXepIk9RIj1IGL+6ehXxq4FBzYUYEQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ZLHzqNv3EoHM69peQBqM4u2Y5FLenfyMScHhM0Bad1sfpSB28yMZ+wfx736NmZ9+v
         hz5KoT624F4K2coHj57E+ykT/rx70Cx7BOyNRz8R9IeIPO3/jemNSnhpEVhD0qOTVg
         NEonsFXjVtHpW2LkaP3hHeLU18Eqvb7ByUK63tUU=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9GHGkWY060079;
        Wed, 16 Oct 2019 12:16:46 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 16
 Oct 2019 12:16:46 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 16 Oct 2019 12:16:46 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9GHGks1116057;
        Wed, 16 Oct 2019 12:16:46 -0500
Subject: Re: taprio testing - Any help?
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com>
 <87v9sv3uuf.fsf@linux.intel.com>
 <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
 <87r23j3rds.fsf@linux.intel.com>
 <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
 <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
 <871rve5229.fsf@linux.intel.com>
 <f6fb6448-35f0-3071-bda1-7ca5f4e3e11e@ti.com>
 <acaa8a5f-3862-6751-672c-dc02ab1c054f@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <1ba4841a-0108-c1d6-f64e-94d81cc32d9e@ti.com>
Date:   Wed, 16 Oct 2019 13:22:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <acaa8a5f-3862-6751-672c-dc02ab1c054f@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/2019 01:14 PM, Murali Karicheri wrote:
> On 10/16/2019 01:02 PM, Murali Karicheri wrote:
>> Hi Vinicius,
>>
>> On 10/14/2019 07:39 PM, Vinicius Costa Gomes wrote:
>>> Murali Karicheri <m-karicheri2@ti.com> writes:
>>>>
>>>> My expectation is as follows
>>>>
>>>> AAAAAABBBBBCCCCCDDDDDEEEEE
>>>>
>>>> Where AAAAA is traffic from TC0, BBBBB is udp stream for port 10000
>>>> CCCCC is stream for port 20000, DDDDD for 30000 and EEEEE for 40000.
>>>> Each can be max of 4 msec. Is the expection correct? At least that
>>>> is my understanding.
>>>
>>> Your expectation is correct.
>>>
>>>>
>>>> But what I see is alternating packets with port 10000/20000/30000/40000
>>>> at the wireshark capture and it doesn't make sense to me. If you
>>>> look at the timestamp, there is nothing showing the Gate is honored
>>>> for Tx. Am I missing something?
>>>
>>> Remember that taprio (in software mode) has no control after the packet
>>> is delivered to the driver. So, even if taprio obeys your traffic
>>> schedule perfectly, the driver/controller may decide to send packets
>>> according to some other logic.
>>>
>> That is true.
>>
>> I think I get why it can't work without ETF offload which is missing in
>> our hardware. Here is what my understanding. Please correct it if wrong.
>>
>> Our hardware has priority queues implemented. So if there are no
>> packets in the higher priority queue, it would send from the lower
>> priority ones. Assuming packets gets dequeue-ed correctly by
>> taprio and that packets are only in one of the lower priority TC.
>> i.e in the above example, BBBBBB are present when TC1 Gate is open.
>> Assuming there are more packets than actually sent out during TC1
>> window, and assuming no packets in the TC0 queue (AAAAA is absent)
>> then hardware will continue to send from TC1 queue. So that might
>> be what is happening, right?
>>
>> So it is required to deliver frames to driver only when the Gate for
>> the specific traffic class is open.
> Plus, number of packets delivered should be based on available time
> in the current window.
> 
Also I see in the taprio code

/* There are a few scenarios where we will have to modify the txtime from
  * what is read from next_txtime in sched_entry. They are:
  * 1. If txtime is in the past,
  *    a. The gate for the traffic class is currently open and packet can be
  *       transmitted before it closes, schedule the packet right away.
  *    b. If the gate corresponding to the traffic class is going to 
open later
  *       in the cycle, set the txtime of packet to the interval start.
  * 2. If txtime is in the future, there are packets corresponding to the
  *    current traffic class waiting to be transmitted. So, the following
  *    possibilities exist:
  *    a. We can transmit the packet before the window containing the txtime
  *       closes.
  *    b. The window might close before the transmission can be completed
  *       successfully. So, schedule the packet in the next open window.
  */
static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
{

So if I enable ETF, looks like packets get dequeue-ed based on txtime
which match with the schedule entries. So packets would arrive at the
driver at the correct time. Of course need to play with delta of the
ETF configuration.

Thanks

Murali
>> Is that what is done by ETF qdisc?
>>  From ETF description at
>> http://man7.org/linux/man-pages/man8/tc-etf.8.html
>> 'The ETF (Earliest TxTime First) qdisc allows applications to control
>> the instant when a packet should be dequeued from the traffic control
>> layer into the netdevice'. So I assume, when I use iperf (there is
>> no txtime information in the packet), I still can use ETF and
>> packet time will be modified to match with schedule and then get
>> dequeue-ed at correct time to arrive at the driver during the Gate
>> open of taprio. Is this correct?
>>
>> If ETF can schedule packet to arrive at the driver just during th
>> Gate open and work in sync with taprio scheduler, that would do the
>> work.I understand the border may be difficult to manage. However if we
>> add a guard band by adding an extra entry with all Gates closed
>> between schedules for guard band duration, it should allow hardware to
>> flush out any remaining frames from the queue outside its Gate duration.
>> If my understanding is correct, can I use software ETF qdisc in this
>> case? If so how do I configure it? Any example?
>>
>>>>
>>>> The tc stats shows packets are going through specific TC/Gate
>>>>
>>>> root@am57xx-evm:~# tc -d -p -s qdisc show dev eth0
>>>> qdisc taprio 100: root refcnt 9 tc 5 map 0 1 2 3 4 4 4 4 4 4 4 4 4 4 
>>>> 4 4
>>>> queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 
>>>> count
>>>> 1 offset 4 count 1
>>>> clockid TAI offload 0   base-time 0 cycle-time 0 cycle-time-extension 0
>>>> base-time 1564768921123459533 cycle-time 20000000 cycle-
>>>> time-extension 0
>>>>           index 0 cmd S gatemask 0x1 interval 4000000
>>>>           index 1 cmd S gatemask 0x2 interval 4000000
>>>>           index 2 cmd S gatemask 0x4 interval 4000000
>>>>           index 3 cmd S gatemask 0x8 interval 4000000
>>>>           index 4 cmd S gatemask 0x10 interval 4000000
>>>>
>>>>    Sent 80948029 bytes 53630 pkt (dropped 0, overlimits 0 requeues 0)
>>>>    backlog 0b 0p requeues 0
>>>> qdisc pfifo 0: parent 100:5 limit 1000p
>>>>    Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>>>>    backlog 0b 0p requeues 0
>>>> qdisc pfifo 0: parent 100:4 limit 1000p
>>>>    Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>>>>    backlog 0b 0p requeues 0
>>>> qdisc pfifo 0: parent 100:3 limit 1000p
>>>>    Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>>>>    backlog 0b 0p requeues 0
>>>> qdisc pfifo 0: parent 100:2 limit 1000p
>>>>    Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>>>>    backlog 0b 0p requeues 0
>>>> qdisc pfifo 0: parent 100:1 limit 1000p
>>>>    Sent 16210237 bytes 10814 pkt (dropped 0, overlimits 0 requeues 0)
>>>>    backlog 0b 0p requeues 0
>>>>
>>>> Also my hardware queue stats shows frames going through correct queues.
>>>> Am I missing something?
>>>>
>>>
>>> What I usually see in these cases, are that the borders (from A to B,
>>> for example) are usually messy, the middle of each entry are more well
>>> behaved.
>>>
>> OK
>>
>>> But there are things that could improve the behavior: reducing TX DMA
>>> coalescing, reducing the number of packet buffers in use in the
>>> controller, disabling power saving features, that kind of thing.
>> I can try playing with the number if descriptors used. But from my above
>> response, I might have to use software ETF qdisc along with taprio to
>> have packets in the correct order on the wire. So will wait on this for
>> now.
>>>
>>> If you are already doing something like this, then I would like to know
>>> more, that could indicate a problem.
>>>
>> No. The hardware just implement a priority queue scheme. I can control
>> the number of buffers or descriptors.
>>
>> Murali
>>> [...]
>>>
>>>> I am on a 4.19.y kernel with patches specific to taprio
>>>> backported. Am I missing anything related to taprio. I will
>>>> try on the latest master branch as well. But if you can point out
>>>> anything that will be helpful.
>>>>
>>>
>>> [...]
>>>
>>>> lcpd/ti-linux-4.19.y) Merged TI feature connectivity into
>>>> ti-linux-4.19.y
>>>
>>> I can't think of anything else.
>>>
>>>>
>>>>>
>>>>> Regards,
>>>>> -Vladimir
>>>>>
>>>
>>> Cheers,
>>> -- 
>>> Vinicius
>>>
>>
>>
> 
> 

