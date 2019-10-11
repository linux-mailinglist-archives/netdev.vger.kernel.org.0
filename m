Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3BD4974
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfJKUvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:51:02 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37798 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKUvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 16:51:01 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9BKoxLQ019910;
        Fri, 11 Oct 2019 15:50:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1570827059;
        bh=InSWyRvMxBPidvHCH82wkLcGaUc0yQCiCghdUTxUkgE=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=nJuH+z3feujTccP2sWZW6lspnda3jLClQqYSQaXTENucfhEbdiZXD7B4kyTVLvw4U
         jAVV8DdtRToYiVi/Omu+x5MkH5FxlQYESdJrlyZo4ONRQmNVMOyjx2qEI6pyLFgGVx
         2kAtlZHK2w9yCYapUphMCrKFYiR2u3gp5Or+7oLo=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9BKoxU7128762
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Oct 2019 15:50:59 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 11
 Oct 2019 15:50:54 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 11 Oct 2019 15:50:54 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9BKow8k038428;
        Fri, 11 Oct 2019 15:50:58 -0500
Subject: Re: taprio testing - Any help?
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com>
 <87v9sv3uuf.fsf@linux.intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
Date:   Fri, 11 Oct 2019 16:56:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <87v9sv3uuf.fsf@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 10/11/2019 04:12 PM, Vinicius Costa Gomes wrote:
> Hi Murali,
> 
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
>> Hi,
>>
>> I am testing the taprio (802.1Q Time Aware Shaper) as part of my
>> pre-work to implement taprio hw offload and test.
>>
>> I was able to configure tap prio on my board and looking to do
>> some traffic test and wondering how to play with the tc command
>> to direct traffic to a specfic queue. For example I have setup
>> taprio to create 5 traffic classes as shows below;-
>>
>> Now I plan to create iperf streams to pass through different
>> gates. Now how do I use tc filters to mark the packets to
>> go through these gates/queues? I heard about skbedit action
>> in tc filter to change the priority field of SKB to allow
>> the above mapping to happen. Any example that some one can
>> point me to?
> 
> What I have been using for testing these kinds of use cases (like iperf)
> is to use an iptables rule to set the priority for some kinds of traffic.
> 
> Something like this:
> 
> sudo iptables -t mangle -A POSTROUTING -p udp --dport 7788 -j CLASSIFY --set-class 0:3
Let me try this. Yes. This is what I was looking for. I was trying
something like this and I was getting an error

tc filter add  dev eth0 parent 100: protocol ip prio 10 u32 match ip 
dport 10000 0xffff flowid 100:3
RTNETLINK answers: Operation not supported
We have an error talking to the kernel, -1

Not sure why the above throws an error for me. If I understand it
right, match rule will add a filter to the parent to send packet to
100:3 which is for TC3 or Q3.

My taprio configuration is as follows:-

root@am57xx-evm:~# tc qdisc show  dev eth0
qdisc taprio 100: root refcnt 9 tc 5 map 0 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2
queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 
1 offset 4 count 1
clockid TAI offload 0   base-time 0 cycle-time 0 cycle-time-extension 0 
base-time 1564536613194451433 cycle-time 20000000 cycle-
time-extension 0
         index 0 cmd S gatemask 0x1 interval 4000000
         index 1 cmd S gatemask 0x2 interval 4000000
         index 2 cmd S gatemask 0x4 interval 4000000
         index 3 cmd S gatemask 0x8 interval 4000000
         index 4 cmd S gatemask 0x10 interval 4000000

qdisc pfifo 0: parent 100:5 limit 1000p
qdisc pfifo 0: parent 100:4 limit 1000p
qdisc pfifo 0: parent 100:3 limit 1000p
qdisc pfifo 0: parent 100:2 limit 1000p
qdisc pfifo 0: parent 100:1 limit 1000p

Thanks for your response!
>  
> This will set the skb->priority of UDP packets matching that rule to 3.
> 
> Another alternative is to create a net_prio cgroup, and the sockets
> created under that hierarchy would have have that priority. I don't have
> an example handy for this right now, sorry.
> 
> Is this what you were looking for?
> 
> 
> Cheers,
> --
> Vinicius
> 

