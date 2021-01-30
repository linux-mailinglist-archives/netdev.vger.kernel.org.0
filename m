Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A10309397
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhA3Jm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:42:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12054 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhA3Jmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:42:36 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DSThd2LwkzMS0x;
        Sat, 30 Jan 2021 17:40:17 +0800 (CST)
Received: from [10.67.103.6] (10.67.103.6) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Sat, 30 Jan 2021
 17:41:42 +0800
Subject: Re: question about bonding mode 4
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20201228101145.GC3565223@nanopsycho.orion>
 <20210107235813.GB29828@redhat.com>
 <20210108131256.GG3565223@nanopsycho.orion>
 <ef692814-fdea-ea59-6b52-93630b5b5570@huawei.com>
 <52630cba-cc60-a024-8dd0-8319e5245044@huawei.com> <10374.1611947473@famine>
CC:     Jiri Pirko <jiri@resnulli.us>, "lipeng (Y)" <lipeng321@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, Salil Mehta <salil.mehta@huawei.com>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <06edc913-a632-6c49-4bcc-30e793d184a0@huawei.com>
Date:   Sat, 30 Jan 2021 17:41:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <10374.1611947473@famine>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/1/30 3:11, Jay Vosburgh wrote:
> moyufeng <moyufeng@huawei.com> wrote:
> 
>> Ping...
>> Any comments? Thanks!
>>
>> On 2021/1/15 10:02, moyufeng wrote:
>>> Hi Team,
>>>
>>> I have a question about bonding. During testing bonding mode 4
>>> scenarios, I find that there is a very low probability that
>>> the pointer is null. The following information is displayed:
>>>
>>> [99359.795934] bond0: (slave eth13.2001): Port 2 did not find a suitable aggregator
>>> [99359.796960] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>>> [99359.798127] Mem abort info:
>>> [99359.798526]   ESR = 0x96000004
>>> [99359.798938]   EC = 0x25: DABT (current EL), IL = 32 bits
>>> [99359.799673]   SET = 0, FnV = 0
>>> [99359.800106]   EA = 0, S1PTW = 0
>>> [99359.800554] Data abort info:
>>> [99359.800952]   ISV = 0, ISS = 0x00000004
>>> [99359.801522]   CM = 0, WnR = 0
>>> [99359.801970] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000c64e6000
>>> [99359.802876] [0000000000000020] pgd=0000000000000000
>>> [99359.803555] Internal error: Oops: 96000004 [#1] PREEMPT SMP
>>> [99359.804369] Modules linked in: bonding hns3(-) hclgevf hnae3 [last unloaded: bonding]
>>> [99359.805494] CPU: 1 PID: 951 Comm: kworker/u10:2 Not tainted 5.7.0-rc4+ #1
>>> [99359.806455] Hardware name: linux,dummy-virt (DT)
>>> [99359.807107] Workqueue: bond0 bond_3ad_state_machine_handler [bonding]
>>> [99359.808056] pstate: 60c00005 (nZCv daif +PAN +UAO)
>>> [99359.808722] pc : bond_3ad_state_machine_handler+0x7fc/0xdb8 [bonding]
>>> [99359.809652] lr : bond_3ad_state_machine_handler+0x7f4/0xdb8 [bonding]
>>> [99359.810535] sp : ffff80001882bd20
>>> [99359.811012] x29: ffff80001882bd20 x28: ffff000085939a38
>>> [99359.811791] x27: ffff00008649bb68 x26: 00000000aaaaaaab
>>> [99359.812871] x25: ffff800009401000 x24: ffff800009408de4
>>> [99359.814049] x23: ffff80001882bd98 x22: ffff00008649b880
>>> [99359.815210] x21: 0000000000000000 x20: ffff000085939a00
>>> [99359.816401] x19: ffff00008649b880 x18: ffff800012572988
>>> [99359.817637] x17: 0000000000000000 x16: 0000000000000000
>>> [99359.818870] x15: ffff80009882b987 x14: 726f746167657267
>>> [99359.820090] x13: 676120656c626174 x12: 697573206120646e
>>> [99359.821374] x11: 696620746f6e2064 x10: 696420322074726f
>>> [99359.822659] x9 : 50203a2931303032 x8 : 0000000000081391
>>> [99359.823891] x7 : ffff8000108e3ad0 x6 : ffff8000128858bb
>>> [99359.825109] x5 : 0000000000000000 x4 : 0000000000000000
>>> [99359.826262] x3 : 00000000ffffffff x2 : 906b329bb5362a00
>>> [99359.827394] x1 : 906b329bb5362a00 x0 : 0000000000000000
>>> [99359.828540] Call trace:
>>> [99359.829071]  bond_3ad_state_machine_handler+0x7fc/0xdb8 [bonding]
>>> [99359.830367]  process_one_work+0x15c/0x4a0
>>> [99359.831216]  worker_thread+0x50/0x478
>>> [99359.832022]  kthread+0x130/0x160
>>> [99359.832716]  ret_from_fork+0x10/0x18
>>> [99359.833487] Code: 910c0021 95f704bb f9403f80 b5ffe300 (f9401000)
>>> [99359.834742] ---[ end trace c7a8e02914afc4e0 ]---
>>> [99359.835817] Kernel panic - not syncing: Fatal exception in interrupt
>>> [99359.837334] SMP: stopping secondary CPUs
>>> [99359.838277] Kernel Offset: disabled
>>> [99359.839086] CPU features: 0x080002,22208218
>>> [99359.840053] Memory Limit: none
>>> [99359.840783] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
>>>
>>> The test procedure is as follows:
>>> 1. Configure bonding and set it to mode 4.
>>>     echo "4" > /sys/class/net/bond0/bonding/mode
>>>     ifconfig bond0 up
>>>
>>> 2. Configure two VLANs and add them to the bonding in step 1.
>>>     vconfig add eth0 2001
>>>     vconfig add eth1 2001
>>>     ifenslave bond0 eth0.2001 eth1.2001
>>>
>>> 3. Unload the network device driver and bonding driver.
>>>     rmmod hns3
>>>     rmmod hclge
>>>     rmmod hnae3
>>>     rmmod bonding.ko
> 
> 	Are you running the above in a script, and can you share the
> entire thing?

Thanks for your reply.

Yes, it's a script, as below. However, the recurrence probability is
very low. So far, this problem occurs only once :(

#start
#!/bin/bash
Version=$(uname -r)
KoPath=/lib/modules/"${Version}"
while [ 1 ];do
	insmod ${KoPath}/hnae3.ko
	insmod ${KoPath}/hclgevf.ko
	insmod ${KoPath}/hns3.ko
	insmod ${KoPath}/bonding.ko

	ifconfig eth0 up
	ifconfig eth1 up

	echo "4" > /sys/class/net/bond0/bonding/mode
	ifconfig bond0 192.168.1.101
	echo 100 > "/sys/class/net/bond0/bonding/miimon"
	sleep 8

	vconfig add eth0 2001
	vconfig add eth1 2001
	ifconfig eth0.2001 192.168.2.101 up
	ifconfig eth1.2001 192.168.3.101 up
	sleep 8

	ifenslave bond0 eth0.2001 eth13.2001
	sleep 8

	rmmod hns3
	rmmod hclge
	rmmod hclgevf
	rmmod hnae3
	rmmod bonding.ko
	sleep 5
done
#end

> 
> 	Does the issue occur with the current net-next?
> 
Yes

>>> 4. Repeat the preceding steps for a long time.
> 
> 	When you run this test, what are the network interfaces eth0 and
> eth1 connected to, and are those ports configured for VLAN 2001 and
> LACP?
> 
Yes, the configurations at both ends are the same.

>>> By checking the logic in ad_port_selection_logic(), I find that
>>> if enter the branch "Port %d did not find a suitable aggregator",
>>> the value of port->aggregator will be NULL, causing the problem.
>>>
>>> So I'd like to ask what circumstances will be involved in this
>>> branch, and what should be done in this case?
> 
> 	Well, in principle, this shouldn't ever happen.  Every port
> structure contains an aggregator structure, so there should always be
> one available somewhere.  I'm going to speculate that there's a race
> condition somewhere in the teardown processing vs the LACP state machine
> that invalidates this presumption.
> 
I agree with your inference. But I don't have a better way to prove it,
since the recurrence probability is too low.

>>> The detailed code analysis is as follows:
> 
> [...]
> 
>>> 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
>>> 	 * in all aggregator's ports, else set ready=FALSE in all
>>> 	 * aggregator's ports
>>> 	 */
>>> 	__set_agg_ports_ready(port->aggregator,
>>> 			      __agg_ports_are_ready(port->aggregator));
>>>
>>> ----analysis: port->aggregator is still NULL, which causes problem.
>>>
>>> 	aggregator = __get_first_agg(port);
>>> 	ad_agg_selection_logic(aggregator, update_slave_arr);
>>>
>>> 	if (!port->aggregator->is_active)
>>> 		port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
> 
> 	Correct, if the "did not find a suitable aggregator" path is
> taken, port->aggregator is NULL and bad things happen in the above
> block.
> 
> 	This is something that needs to be fixed, but I'm also concerned
> that there are other issues lurking, so I'd like to be able to reproduce
> this.
> 
> 	-J
> 
I will continue to reproduce the problem and try to find ways to improve
the reproducibility probability.

Since this path is incorrect, could you help to fix it?

Thank you! :)

> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> .
> 
