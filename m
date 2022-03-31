Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10CF4ED76F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiCaKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiCaKBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:01:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A5C4C7AE;
        Thu, 31 Mar 2022 03:00:01 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22V9dAwK017497;
        Thu, 31 Mar 2022 09:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dsx5ldU95Alojy9t4EAoOZs0FEpNz8tK6IzHtjOw/y0=;
 b=Jg6zzfez7uPfHvE2+PhZ43CYodkHOf17Suxa17jeULDaVUmy1JHKTl0kDR4+giGVbrO5
 lUcTV66FQKvyHZBMBkLSA4bSIxp/v3pTLays4R8omqmxZeewcOeRDnPE04/Ono+MoFRH
 3RiED0PseRU2eHLM3oEkkTxGCU4ZYRiO7ODmmJ8BP2MbTxuXoQ96XI7gWsnsqDhNIH/M
 2JyTobPsrTh8clNJ3ZE9JC19z8FP10FRZLGgk1SXs1i/4jdWmpoZMqkxG3vcBPCBT2Uq
 YiidMBs6QeAlac8af5N688CoumYA6ds64WrX91b3ElnOg1cLa0wx2/pw9BtDvcu2TwrA bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f57tnu0um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 09:59:53 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22V9gRGq028894;
        Thu, 31 Mar 2022 09:59:52 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f57tnu0ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 09:59:52 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22V9qqlZ013340;
        Thu, 31 Mar 2022 09:59:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf92ene-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 09:59:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22V9xs1u19661252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 09:59:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 152244203F;
        Thu, 31 Mar 2022 09:59:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76C6A42041;
        Thu, 31 Mar 2022 09:59:47 +0000 (GMT)
Received: from [9.145.190.237] (unknown [9.145.190.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 09:59:47 +0000 (GMT)
Message-ID: <fa420a98-fb7b-a56b-7e13-2fa55b6ff6a9@linux.ibm.com>
Date:   Thu, 31 Mar 2022 11:59:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
 <20220329175421.4a6325d9@kernel.org>
 <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
 <c1ec0612-063b-dbfa-e10a-986786178c93@linux.ibm.com>
 <20220330085154.34440715@kernel.org>
 <c512e765-f411-9305-013b-471a07e7f3ff@blackwall.org>
 <20220330101256.53f6ef48@kernel.org> <2600.1648667758@famine>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <2600.1648667758@famine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dau2ZCCV6d3ROraal4GCny6oevNrfnMT
X-Proofpoint-ORIG-GUID: LB2Y1xfEtkV2qIozgSeTUdi7a7iJyB2W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_03,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 13:40:52 +0200 Alexandra Winter wrote:
> Bonding drivers generate specific events during failover that trigger
> switch updates.  When a veth device is attached to a bridge with a
> bond interface, we want external switches to learn about the veth
> devices as well.
>
> Example:
>
> 	| veth_a2   |  veth_b2  |  veth_c2 |
> 	------o-----------o----------o------
> 	       \	  |	    /
> 		o	  o	   o
> 	      veth_a1  veth_b1  veth_c1
> 	      -------------------------
> 	      |        bridge         |
> 	      -------------------------
> 			bond0
> 			/  \
> 		     eth0  eth1
>
> In case of failover from eth0 to eth1, the netdev_notifier needs to be
> propagated, so e.g. veth_a2 can re-announce its MAC address to the
> external hardware attached to eth1.

On 30.03.22 21:15, Jay Vosburgh wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
>> On Wed, 30 Mar 2022 19:16:42 +0300 Nikolay Aleksandrov wrote:
>>>> Maybe opt-out? But assuming the event is only generated on
>>>> active/backup switch over - when would it be okay to ignore
>>>> the notification?
>>>
>>> Let me just clarify, so I'm sure I've not misunderstood you. Do you mean opt-out as in
>>> make it default on? IMO that would be a problem, large scale setups would suddenly
>>> start propagating it to upper devices which would cause a lot of unnecessary bcast.
>>> I meant enable it only if needed, and only on specific ports (second part is not
>>> necessary, could be global, I think it's ok either way). I don't think any setup
>>> which has many upper vlans/macvlans would ever enable this.
>>
>> That may be. I don't have a good understanding of scenarios in which
>> GARP is required and where it's not :) Goes without saying but the
>> default should follow the more common scenario.
> 
> 	At least from the bonding failover persective, the GARP is
> needed when there's a visible topology change (so peers learn the new
> path), a change in MAC address, or both.  I don't think it's possible to
> determine from bonding which topology changes are visible, so any
> failover gets a GARP.  The original intent as best I recall was to cover
> IP addresses configured on the bond itself or on VLANs above the bond.
> 
> 	If I understand the original problem description correctly, the
> bonding failover causes the connectivity issue because the network
> segments beyond the bond interfaces don't share forwarding information
> (i.e., they are completely independent).  The peer (end station or
> switch) at the far end of those network segments (where they converge)
> is unable to directly see that the "to bond eth0" port went down, and
> has no way to know that anything is awry, and thus won't find the new
> path until an ARP or forwarding entry for "veth_a2" (from the original
> diagram) times out at the peer out in the network.
> 
>>>>> My concern was about the Hangbin's alternative proposal to notify all
>>>>> bridge ports. I hope in my porposal I was able to avoid infinite loops.  
>>>>
>>>> Possibly I'm confused as to where the notification for bridge master
>>>> gets sent..  
>>>
>>> IIUC it bypasses the bridge and sends a notify peers for the veth peer so it would
>>> generate a grat arp (inetdev_event -> NETDEV_NOTIFY_PEERS).
>>
>> Ack, I was basically repeating the question of where does 
>> the notification with dev == br get generated.
>>
>> There is a protection in this patch to make sure the other 
>> end of the veth is not plugged into a bridge (i.e. is not
>> a bridge port) but there can be a macvlan on top of that
>> veth that is part of a bridge, so IIUC that check is either
>> insufficient or unnecessary.
> 
> 	I'm a bit concerned this is becoming a interface plumbing
> topology change whack-a-mole.
> 
> 	In the above, what if the veth is plugged into a bridge, and
> there's a end station on that bridge?  If it's bridges all the way down,
> where does the need for some kind of TCN mechanism stop?
> 
> 	Or instead of a veth it's an physical network hop (perhaps a
> tunnel; something through which notifiers do not propagate) to another
> host with another bridge, then what?
> 
> 	-J
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

I see 3 technologies that are used for network virtualization in combination with bond for redundancy
(and I may miss some):
(1) MACVTAP/MACVLAN over bond:
MACVLAN propagates notifiers from bond to endpoints (same as VLAN)
(drivers/net/macvlan.c:
	case NETDEV_NOTIFY_PEERS:
	case NETDEV_BONDING_FAILOVER:
	case NETDEV_RESEND_IGMP:
		/* Propagate to all vlans */
		list_for_each_entry(vlan, &port->vlans, list)
			call_netdevice_notifiers(event, vlan->dev);
	})
(2) OpenVSwitch:
OVS seems to have its own bond implementation, but sends out reverse Arp on active-backup failover
(3) User defined bridge over bond:
propagates notifiers to the bridge device itself, but not to the devices attached to bridge ports.
(net/bridge/br.c:
	case NETDEV_RESEND_IGMP:
		/* Propagate to master device */
		call_netdevice_notifiers(event, br->dev);)

Active-backup may not be the best bonding mode, but it is a simple way to achieve redundancy and I've seen it being used.
I don't see a usecase for MACVLAN over bridge over bond (?)
The external HW network does not need to be updated about the instances that are conencted via tunnel,
so I don't see an issue there.

I had this idea how to solve the failover issue it for veth pairs attached to the user defined bridge.
Does this need to be configurable? How? Per veth pair?

Of course a more general solution how bridge over bond could handle notifications, would be great,
but I'm running out of ideas. So I thought I'd address veth first.
Your help and ideas are highly appreciated, thank you.
Alexandra
