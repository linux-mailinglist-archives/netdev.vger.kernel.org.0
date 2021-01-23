Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD2A301389
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 07:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbhAWGLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 01:11:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11485 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbhAWGLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 01:11:23 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DN5LR3k7tzj6VZ;
        Sat, 23 Jan 2021 14:09:19 +0800 (CST)
Received: from [10.67.103.6] (10.67.103.6) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Sat, 23 Jan 2021
 14:10:21 +0800
Subject: Re: question about bonding mode 4
To:     Jiri Pirko <jiri@resnulli.us>, Jay Vosburgh <j.vosburgh@gmail.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20201228101145.GC3565223@nanopsycho.orion>
 <20210107235813.GB29828@redhat.com>
 <20210108131256.GG3565223@nanopsycho.orion>
 <ef692814-fdea-ea59-6b52-93630b5b5570@huawei.com>
CC:     "lipeng (Y)" <lipeng321@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, Salil Mehta <salil.mehta@huawei.com>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <52630cba-cc60-a024-8dd0-8319e5245044@huawei.com>
Date:   Sat, 23 Jan 2021 14:10:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <ef692814-fdea-ea59-6b52-93630b5b5570@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping...
Any comments? Thanks!

On 2021/1/15 10:02, moyufeng wrote:
> Hi Team,
> 
> I have a question about bonding. During testing bonding mode 4
> scenarios, I find that there is a very low probability that
> the pointer is null. The following information is displayed:
> 
> [99359.795934] bond0: (slave eth13.2001): Port 2 did not find a suitable aggregator
> [99359.796960] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> [99359.798127] Mem abort info:
> [99359.798526]   ESR = 0x96000004
> [99359.798938]   EC = 0x25: DABT (current EL), IL = 32 bits
> [99359.799673]   SET = 0, FnV = 0
> [99359.800106]   EA = 0, S1PTW = 0
> [99359.800554] Data abort info:
> [99359.800952]   ISV = 0, ISS = 0x00000004
> [99359.801522]   CM = 0, WnR = 0
> [99359.801970] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000c64e6000
> [99359.802876] [0000000000000020] pgd=0000000000000000
> [99359.803555] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [99359.804369] Modules linked in: bonding hns3(-) hclgevf hnae3 [last unloaded: bonding]
> [99359.805494] CPU: 1 PID: 951 Comm: kworker/u10:2 Not tainted 5.7.0-rc4+ #1
> [99359.806455] Hardware name: linux,dummy-virt (DT)
> [99359.807107] Workqueue: bond0 bond_3ad_state_machine_handler [bonding]
> [99359.808056] pstate: 60c00005 (nZCv daif +PAN +UAO)
> [99359.808722] pc : bond_3ad_state_machine_handler+0x7fc/0xdb8 [bonding]
> [99359.809652] lr : bond_3ad_state_machine_handler+0x7f4/0xdb8 [bonding]
> [99359.810535] sp : ffff80001882bd20
> [99359.811012] x29: ffff80001882bd20 x28: ffff000085939a38
> [99359.811791] x27: ffff00008649bb68 x26: 00000000aaaaaaab
> [99359.812871] x25: ffff800009401000 x24: ffff800009408de4
> [99359.814049] x23: ffff80001882bd98 x22: ffff00008649b880
> [99359.815210] x21: 0000000000000000 x20: ffff000085939a00
> [99359.816401] x19: ffff00008649b880 x18: ffff800012572988
> [99359.817637] x17: 0000000000000000 x16: 0000000000000000
> [99359.818870] x15: ffff80009882b987 x14: 726f746167657267
> [99359.820090] x13: 676120656c626174 x12: 697573206120646e
> [99359.821374] x11: 696620746f6e2064 x10: 696420322074726f
> [99359.822659] x9 : 50203a2931303032 x8 : 0000000000081391
> [99359.823891] x7 : ffff8000108e3ad0 x6 : ffff8000128858bb
> [99359.825109] x5 : 0000000000000000 x4 : 0000000000000000
> [99359.826262] x3 : 00000000ffffffff x2 : 906b329bb5362a00
> [99359.827394] x1 : 906b329bb5362a00 x0 : 0000000000000000
> [99359.828540] Call trace:
> [99359.829071]  bond_3ad_state_machine_handler+0x7fc/0xdb8 [bonding]
> [99359.830367]  process_one_work+0x15c/0x4a0
> [99359.831216]  worker_thread+0x50/0x478
> [99359.832022]  kthread+0x130/0x160
> [99359.832716]  ret_from_fork+0x10/0x18
> [99359.833487] Code: 910c0021 95f704bb f9403f80 b5ffe300 (f9401000)
> [99359.834742] ---[ end trace c7a8e02914afc4e0 ]---
> [99359.835817] Kernel panic - not syncing: Fatal exception in interrupt
> [99359.837334] SMP: stopping secondary CPUs
> [99359.838277] Kernel Offset: disabled
> [99359.839086] CPU features: 0x080002,22208218
> [99359.840053] Memory Limit: none
> [99359.840783] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> 
> The test procedure is as follows:
> 1. Configure bonding and set it to mode 4.
>     echo "4" > /sys/class/net/bond0/bonding/mode
>     ifconfig bond0 up
> 
> 2. Configure two VLANs and add them to the bonding in step 1.
>     vconfig add eth0 2001
>     vconfig add eth1 2001
>     ifenslave bond0 eth0.2001 eth1.2001
> 
> 3. Unload the network device driver and bonding driver.
>     rmmod hns3
>     rmmod hclge
>     rmmod hnae3
>     rmmod bonding.ko
> 
> 4. Repeat the preceding steps for a long time.
> 
> By checking the logic in ad_port_selection_logic(), I find that
> if enter the branch "Port %d did not find a suitable aggregator",
> the value of port->aggregator will be NULL, causing the problem.
> 
> So I'd like to ask what circumstances will be involved in this
> branch, and what should be done in this case?
> 
> 
> The detailed code analysis is as follows:
> 
> static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
> {
> [...]
> 	/* if the port is connected to other aggregator, detach it */
> 	if (port->aggregator) {
> 		/* detach the port from its former aggregator */
> 		temp_aggregator = port->aggregator;
> 		for (curr_port = temp_aggregator->lag_ports; curr_port;
> 		     last_port = curr_port,
> 		     curr_port = curr_port->next_port_in_aggregator) {
> 			if (curr_port == port) {
> 				temp_aggregator->num_of_ports--;
> 				/* if it is the first port attached to the
> 				 * aggregator
> 				 */
> 				if (!last_port) {
> 					temp_aggregator->lag_ports =
> 						port->next_port_in_aggregator;
> 				} else {
> 					/* not the first port attached to the
> 					 * aggregator
> 					 */
> 					last_port->next_port_in_aggregator =
> 						port->next_port_in_aggregator;
> 				}
> 
> 				/* clear the port's relations to this
> 				 * aggregator
> 				 */
> 				port->aggregator = NULL;
> 
> ----analysis: set port->aggregator NULL at the beginning of ad_port_selection_logic().
> 
> 				port->next_port_in_aggregator = NULL;
> 				port->actor_port_aggregator_identifier = 0;
> 
> 				slave_dbg(bond->dev, port->slave->dev, "Port %d left LAG %d\n",
> 					  port->actor_port_number,
> 					  temp_aggregator->aggregator_identifier);
> 				/* if the aggregator is empty, clear its
> 				 * parameters, and set it ready to be attached
> 				 */
> 				if (!temp_aggregator->lag_ports)
> 					ad_clear_agg(temp_aggregator);
> 				break;
> 			}
> 		}
> 		if (!curr_port) {
> 			/* meaning: the port was related to an aggregator
> 			 * but was not on the aggregator port list
> 			 */
> 			net_warn_ratelimited("%s: (slave %s): Warning: Port %d was related to aggregator %d but was not on its port list\n",
> 					     port->slave->bond->dev->name,
> 					     port->slave->dev->name,
> 					     port->actor_port_number,
> 					     port->aggregator->aggregator_identifier);
> 		}
> 	}
> 	/* search on all aggregators for a suitable aggregator for this port */
> 	bond_for_each_slave(bond, slave, iter) {
> 		aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
> 		/* keep a free aggregator for later use(if needed) */
> 		if (!aggregator->lag_ports) {
> 			if (!free_aggregator)
> 				free_aggregator = aggregator;
> 
> ----analysis: Save free_aggregator if found a free aggregator. But in this case, no free aggregator is available.
> 
> 			continue;
> 		}
> 		/* check if current aggregator suits us */
> 		if (((aggregator->actor_oper_aggregator_key == port->actor_oper_port_key) && /* if all parameters match AND */
> 		     MAC_ADDRESS_EQUAL(&(aggregator->partner_system), &(port->partner_oper.system)) &&
> 		     (aggregator->partner_system_priority == port->partner_oper.system_priority) &&
> 		     (aggregator->partner_oper_aggregator_key == port->partner_oper.key)
> 		    ) &&
> 		    ((!MAC_ADDRESS_EQUAL(&(port->partner_oper.system), &(null_mac_addr)) && /* partner answers */
> 		      !aggregator->is_individual)  /* but is not individual OR */
> 		    )
> 		   ) {
> 			/* attach to the founded aggregator */
> 			port->aggregator = aggregator;
> 
> ----analysis: If a proper aggregator is found, port->aggregator is assigned here.
> 
> 			port->actor_port_aggregator_identifier =
> 				port->aggregator->aggregator_identifier;
> 			port->next_port_in_aggregator = aggregator->lag_ports;
> 			port->aggregator->num_of_ports++;
> 			aggregator->lag_ports = port;
> 			slave_dbg(bond->dev, slave->dev, "Port %d joined LAG %d (existing LAG)\n",
> 				  port->actor_port_number,
> 				  port->aggregator->aggregator_identifier);
> 
> 			/* mark this port as selected */
> 			port->sm_vars |= AD_PORT_SELECTED;
> 			found = 1;
> 
> ----analysis: Set found to 1 if port->aggregator is assigned.
> 
> 			break;
> 		}
> 	}
> 	/* the port couldn't find an aggregator - attach it to a new
> 	 * aggregator
> 	 */
> 	if (!found) {
> 		if (free_aggregator) {
> 			/* assign port a new aggregator */
> 			port->aggregator = free_aggregator;
> 
> ----analysis: No proper free_aggregator is found. Therefore, port->aggregator cannot be assigned here.
> 
> 			port->actor_port_aggregator_identifier =
> 				port->aggregator->aggregator_identifier;
> 
> 			/* update the new aggregator's parameters
> 			 * if port was responsed from the end-user
> 			 */
> 			if (port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS)
> 				/* if port is full duplex */
> 				port->aggregator->is_individual = false;
> 			else
> 				port->aggregator->is_individual = true;
> 
> 			port->aggregator->actor_admin_aggregator_key =
> 				port->actor_admin_port_key;
> 			port->aggregator->actor_oper_aggregator_key =
> 				port->actor_oper_port_key;
> 			port->aggregator->partner_system =
> 				port->partner_oper.system;
> 			port->aggregator->partner_system_priority =
> 				port->partner_oper.system_priority;
> 			port->aggregator->partner_oper_aggregator_key = port->partner_oper.key;
> 			port->aggregator->receive_state = 1;
> 			port->aggregator->transmit_state = 1;
> 			port->aggregator->lag_ports = port;
> 			port->aggregator->num_of_ports++;
> 
> 			/* mark this port as selected */
> 			port->sm_vars |= AD_PORT_SELECTED;
> 
> 			slave_dbg(bond->dev, port->slave->dev, "Port %d joined LAG %d (new LAG)\n",
> 				  port->actor_port_number,
> 				  port->aggregator->aggregator_identifier);
> 		} else {
> 			slave_err(bond->dev, port->slave->dev,
> 				  "Port %d did not find a suitable aggregator\n",
> 				  port->actor_port_number);
> 
> ----analysis: The fault scenario goes to this branch, and port->aggregator remains NULL.
> 
> 		}
> 	}
> 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
> 	 * in all aggregator's ports, else set ready=FALSE in all
> 	 * aggregator's ports
> 	 */
> 	__set_agg_ports_ready(port->aggregator,
> 			      __agg_ports_are_ready(port->aggregator));
> 
> ----analysis: port->aggregator is still NULL, which causes problem.
> 
> 
> 	aggregator = __get_first_agg(port);
> 	ad_agg_selection_logic(aggregator, update_slave_arr);
> 
> 	if (!port->aggregator->is_active)
> 		port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
> }
> 
> 
> Thanks.
> .
> 
