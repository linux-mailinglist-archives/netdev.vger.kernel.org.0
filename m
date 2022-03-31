Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719024ED94F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiCaMJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiCaMJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:09:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCED01FE567;
        Thu, 31 Mar 2022 05:07:35 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22V9d183016846;
        Thu, 31 Mar 2022 12:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gRPtGdpAZ/q0V+YfyGFvf0Q6ubH5G8jmX+S9U6IIRIg=;
 b=QIi1x0fPC7PoYfUGPu4udKItoBiAgAYM/PDRb6o0UCZUKEgcr1wUkXl/ugIFTIBjxpSb
 m0sq8fl2JUSNthlLAqb2upCrujVX/Okm94Febz5wBwp82Cs7Mr1vT7rV6yADWHscKnNt
 9MRkGIWX0x+/RK8QVXympUtUQME78S6QOcpSSAD56oM3rAEfCrkIfkPNcA4finnri/Yw
 jUU2QTWQ2IIMiI52x5BZLZVGFCRY6cu7AdXYOzgruUb3jkl4yrI+owceN3CrKT+GZ0Zm
 Lv6w4ULQTLquS1bfXTkVn1NIyhy07XbLXAJ8xvcIV6DnYLz5gKbJvCqJBBHGblJaNGRg Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f57tnwq3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 12:07:26 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VC2KU0014441;
        Thu, 31 Mar 2022 12:07:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f57tnwq2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 12:07:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VBvhDk026585;
        Thu, 31 Mar 2022 12:07:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9jqe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 12:07:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VC7L1T19595674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 12:07:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 828BB42045;
        Thu, 31 Mar 2022 12:07:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDA2942042;
        Thu, 31 Mar 2022 12:07:20 +0000 (GMT)
Received: from [9.145.190.237] (unknown [9.145.190.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 12:07:20 +0000 (GMT)
Message-ID: <1845d832-e36c-fff1-0ea6-1d7aa290919f@linux.ibm.com>
Date:   Thu, 31 Mar 2022 14:07:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
 <fa420a98-fb7b-a56b-7e13-2fa55b6ff6a9@linux.ibm.com>
 <cf713c75-718e-6705-fc9d-6844372348d2@blackwall.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <cf713c75-718e-6705-fc9d-6844372348d2@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jk8GBhxOGd4DCMK45juIeQbB2sj2SGdv
X-Proofpoint-ORIG-GUID: doJLC2TJjhO-l6jWj2x5CiOTsf8qoJoU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31.03.22 12:33, Nikolay Aleksandrov wrote:
> On 31/03/2022 12:59, Alexandra Winter wrote:
>> On Tue, 29 Mar 2022 13:40:52 +0200 Alexandra Winter wrote:
>>> Bonding drivers generate specific events during failover that trigger
>>> switch updates.  When a veth device is attached to a bridge with a
>>> bond interface, we want external switches to learn about the veth
>>> devices as well.
>>>
>>> Example:
>>>
>>> 	| veth_a2   |  veth_b2  |  veth_c2 |
>>> 	------o-----------o----------o------
>>> 	       \	  |	    /
>>> 		o	  o	   o
>>> 	      veth_a1  veth_b1  veth_c1
>>> 	      -------------------------
>>> 	      |        bridge         |
>>> 	      -------------------------
>>> 			bond0
>>> 			/  \
>>> 		     eth0  eth1
>>>
>>> In case of failover from eth0 to eth1, the netdev_notifier needs to be
>>> propagated, so e.g. veth_a2 can re-announce its MAC address to the
>>> external hardware attached to eth1.
>>
>> On 30.03.22 21:15, Jay Vosburgh wrote:
>>> Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>>> On Wed, 30 Mar 2022 19:16:42 +0300 Nikolay Aleksandrov wrote:
>>>>>> Maybe opt-out? But assuming the event is only generated on
>>>>>> active/backup switch over - when would it be okay to ignore
>>>>>> the notification?
>>>>>
>>>>> Let me just clarify, so I'm sure I've not misunderstood you. Do you mean opt-out as in
>>>>> make it default on? IMO that would be a problem, large scale setups would suddenly
>>>>> start propagating it to upper devices which would cause a lot of unnecessary bcast.
>>>>> I meant enable it only if needed, and only on specific ports (second part is not
>>>>> necessary, could be global, I think it's ok either way). I don't think any setup
>>>>> which has many upper vlans/macvlans would ever enable this.
>>>>
>>>> That may be. I don't have a good understanding of scenarios in which
>>>> GARP is required and where it's not :) Goes without saying but the
>>>> default should follow the more common scenario.
>>>
>>> 	At least from the bonding failover persective, the GARP is
>>> needed when there's a visible topology change (so peers learn the new
>>> path), a change in MAC address, or both.  I don't think it's possible to
>>> determine from bonding which topology changes are visible, so any
>>> failover gets a GARP.  The original intent as best I recall was to cover
>>> IP addresses configured on the bond itself or on VLANs above the bond.
>>>
>>> 	If I understand the original problem description correctly, the
>>> bonding failover causes the connectivity issue because the network
>>> segments beyond the bond interfaces don't share forwarding information
>>> (i.e., they are completely independent).  The peer (end station or
>>> switch) at the far end of those network segments (where they converge)
>>> is unable to directly see that the "to bond eth0" port went down, and
>>> has no way to know that anything is awry, and thus won't find the new
>>> path until an ARP or forwarding entry for "veth_a2" (from the original
>>> diagram) times out at the peer out in the network.
>>>
>>>>>>> My concern was about the Hangbin's alternative proposal to notify all
>>>>>>> bridge ports. I hope in my porposal I was able to avoid infinite loops.  
>>>>>>
>>>>>> Possibly I'm confused as to where the notification for bridge master
>>>>>> gets sent..  
>>>>>
>>>>> IIUC it bypasses the bridge and sends a notify peers for the veth peer so it would
>>>>> generate a grat arp (inetdev_event -> NETDEV_NOTIFY_PEERS).
>>>>
>>>> Ack, I was basically repeating the question of where does 
>>>> the notification with dev == br get generated.
>>>>
>>>> There is a protection in this patch to make sure the other 
>>>> end of the veth is not plugged into a bridge (i.e. is not
>>>> a bridge port) but there can be a macvlan on top of that
>>>> veth that is part of a bridge, so IIUC that check is either
>>>> insufficient or unnecessary.
>>>
>>> 	I'm a bit concerned this is becoming a interface plumbing
>>> topology change whack-a-mole.
>>>
>>> 	In the above, what if the veth is plugged into a bridge, and
>>> there's a end station on that bridge?  If it's bridges all the way down,
>>> where does the need for some kind of TCN mechanism stop?
>>>
>>> 	Or instead of a veth it's an physical network hop (perhaps a
>>> tunnel; something through which notifiers do not propagate) to another
>>> host with another bridge, then what?
>>>
>>> 	-J
>>>
>>> ---
>>> 	-Jay Vosburgh, jay.vosburgh@canonical.com
>>
>> I see 3 technologies that are used for network virtualization in combination with bond for redundancy
>> (and I may miss some):
>> (1) MACVTAP/MACVLAN over bond:
>> MACVLAN propagates notifiers from bond to endpoints (same as VLAN)
>> (drivers/net/macvlan.c:
>> 	case NETDEV_NOTIFY_PEERS:
>> 	case NETDEV_BONDING_FAILOVER:
>> 	case NETDEV_RESEND_IGMP:
>> 		/* Propagate to all vlans */
>> 		list_for_each_entry(vlan, &port->vlans, list)
>> 			call_netdevice_notifiers(event, vlan->dev);
>> 	})
>> (2) OpenVSwitch:
>> OVS seems to have its own bond implementation, but sends out reverse Arp on active-backup failover
>> (3) User defined bridge over bond:
>> propagates notifiers to the bridge device itself, but not to the devices attached to bridge ports.
>> (net/bridge/br.c:
>> 	case NETDEV_RESEND_IGMP:
>> 		/* Propagate to master device */
>> 		call_netdevice_notifiers(event, br->dev);)
>>
>> Active-backup may not be the best bonding mode, but it is a simple way to achieve redundancy and I've seen it being used.
>> I don't see a usecase for MACVLAN over bridge over bond (?)
> 
> If you're talking about this particular case (network virtualization) - sure. But macvlans over bridges
> are heavily used in Cumulus Linux and large scale setups. For example VRRP is implemented using macvlan
> devices. Any notification that propagates to the bridge and reaches these would cause a storm of broadcasts
> being sent down which would not scale and is extremely undesirable in general.
> 
>> The external HW network does not need to be updated about the instances that are conencted via tunnel,
>> so I don't see an issue there.
>>
>> I had this idea how to solve the failover issue it for veth pairs attached to the user defined bridge.
>> Does this need to be configurable? How? Per veth pair?
> 
> That is not what I meant (if you were referring to my comment), I meant if it gets implemented in the
> bridge and it starts propagating the notify peers notifier - that _must_ be configurable.
> 
>>
>> Of course a more general solution how bridge over bond could handle notifications, would be great,
>> but I'm running out of ideas. So I thought I'd address veth first.
>> Your help and ideas are highly appreciated, thank you.
> 
> I'm curious why it must be done in the kernel altogether? This can obviously be solved in user-space
> by sending grat arps towards flapped por for fdbs on other ports (e.g. veths) based on a netlink notification.
> In fact based on your description propagating NETDEV_NOTIFY_PEERS to bridge ports wouldn't help
> because in that case the remote peer veth will not generate a grat arp. The notification will
> get propagated only to local veth (bridge port), or the bridge itself depending on implementation.
> 
> So from bridge perspective, if you decide to pursue a kernel solution, I think you'll need
> a new bridge port option which acts on NOTIFY_PEERS and generates a grat arp for all fdbs
> on the port where it is enabled to the port which generated the NOTIFY_PEERS. Note that is
> also fragile as I'm sure some stacked device config would not work, so I want to re-iterate
> how much easier it is to solve it in user-space which has better visibility and you can
> change much faster to accommodate new use cases.
> 
> To illustrate: bond
>                    \ 
>                     bridge
>                    /
>                veth0
>                  |
>                veth1
> 
> When bond generates NOTIFY_PEERS, and you have this new option enabled on veth0 then
> the bridge should generate grat arps for all fdbs on veth0 towards bond so the new
> path would learn them. Note that is very dangerous as veth1 can generate thousands
> of fdbs and you can potentially DDoS the whole network, so again I'd advise to do
> this in user-space where you can better control it.
> 
> W.r.t to this patch, I think it will also work and will cause a single grat arp which
> is ok. Just need to make sure loops are not possible, for example I think you can loop
> your implementation by the following config (untested theory):
> bond
>     \
>      bridge 
>    \          \
> veth2.10       veth0 - veth1
>       \                \
>        \                veth1.10 (vlan)
>         \                \
>          \                bridge2
>           \              /
>            veth2 - veth3
> 
> 
> 1. bond generates NOTIFY_PEERS
> 2. bridge propagates to veth1 (through veth0 port)
> 3. veth1 propagates to its vlan (veth1.10)
> 4. bridge2 sees veth1.10 NOTIFY_PEERS and propagates to veth2 (through veth3 port)
> 5. veth2 propagates to its vlan (veth2.10)
> 6. veth2.10 propagates it back to bridge
> <loop>
> 
> I'm sure similar setup, and maybe even simpler, can be constructed with other devices
> which can propagate or generate NOTIFY_PEERS.
> 
> Cheers,
>  Nik
> 
Thank you very much Nik for your advice and your thourough explanations.

I think I could prevent the loop you describe above. But I agree that propagating
notifications through veth is more risky, because there is no upper-lower relationship.
Is there interest in a v3 of my patch, where I would also incorporate Jakub's comments?

Otherwise I would next explore a user-space solution like Nik proposed.

Thank you all very much
Alexandra
