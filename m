Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170BC4EBFAA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343562AbiC3LQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiC3LQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:16:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8388ABF54;
        Wed, 30 Mar 2022 04:14:25 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22U8i6bM010013;
        Wed, 30 Mar 2022 11:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Rf/rgxd6qNOBM/p+PYQJHBSjZyI1VzCDF2pZLHjtnSA=;
 b=nO9SF6KTVOOVUo9F2l32qBIM6p0GJFL0DJ5IKi4zSMZs7M27fArYzBWCu3ZVAI+Qhk2s
 C8L2nZtIowYRD7IYCB0rzZNOcurMJiepfR6YsbLGiMtCHA/Myevch+nokCTWGiEEJFjH
 xLk5AzthuAt0Q7c9+K9i/n5KuYKQdhxKRzzHuCevIRVzUpGAgpAGPN3R+zC2GaVq9LRL
 vDFqXaQd7x0aC7FdRNn7jiikV2B4MmNM9tGs/O4KllR1F8kx8VprsdyWZk8jaKup2HRg
 qadra0sHA1cX3hayB1TVwJuZCGRHNyaTT/3qPYrhbM+hxTakRqtFyJXN/M950txluLP1 xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40t8uneu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 11:14:19 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UANv2E013461;
        Wed, 30 Mar 2022 11:14:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40t8undx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 11:14:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBAhLU004092;
        Wed, 30 Mar 2022 11:14:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8q4v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 11:14:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UBEDgi23527850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 11:14:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B45A9A404D;
        Wed, 30 Mar 2022 11:14:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44C23A4040;
        Wed, 30 Mar 2022 11:14:13 +0000 (GMT)
Received: from [9.152.224.43] (unknown [9.152.224.43])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 11:14:13 +0000 (GMT)
Message-ID: <c1ec0612-063b-dbfa-e10a-986786178c93@linux.ibm.com>
Date:   Wed, 30 Mar 2022 13:14:12 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
 <20220329175421.4a6325d9@kernel.org>
 <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M-Qp-TVtm9YMlDeKgjRXrBiTPuxfYVst
X-Proofpoint-GUID: 4zIMnoXWby1ikyK8jvhA0vzztfF0a9uh
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_03,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.03.22 12:23, Nikolay Aleksandrov wrote:
> On 30/03/2022 03:54, Jakub Kicinski wrote:
>> Dropping the BPF people from CC and adding Hangbin, bridge and
>> bond/team. Please exercise some judgment when sending patches.
Thank you. 
I did  'scripts/get_maintainer.pl drivers/net/veth.c'
but was a bit surprised about the outcome.

>>
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
>>>
>>> Without this patch we have seen cases where recovery after bond failover
>>> took an unacceptable amount of time (depending on timeout settings in the
>>> network).
>>>
>>> Due to the symmetric nature of veth special care is required to avoid
>>> endless notification loops. Therefore we only notify from a veth
>>> bridgeport to a peer that is not a bridgeport.
>>>
>>> References:
>>> Same handling as for macvlan:
>>> commit 4c9912556867 ("macvlan: Support bonding events")
>>> and vlan:
>>> commit 4aa5dee4d999 ("net: convert resend IGMP to notifier event")
>>>
>>> Alternatives:
>>> Propagate notifier events to all ports of a bridge. IIUC, this was
>>> rejected in https://www.spinics.net/lists/netdev/msg717292.html
>>
>> My (likely flawed) reading of Nik's argument was that (1) he was
>> concerned about GARP storms; (2) he didn't want the GARP to be
>> broadcast to all ports, just the bond that originated the request.
>>
> 
> Yes, that would be ideal. Trying to avoid unnecessary bcasts, that is
> especially important for large setups with lots of devices.

One way to target the bond that originated the request, would be if the
bridge itself would do GARPs/RARPS/..,  on this bond port for all MACs
that are in its FDB. What do you think about that?

> 
>> I'm not sure I follow (1), as Hangbin said the event is rare, plus 
>> GARP only comes from interfaces that have an IP addr, which IIUC
>> most bridge ports will not have.
>>
> 
> Indeed, such setups are not the most common ones.
> 
>> This patch in no way addresses (2). But then, again, if we put 
>> a macvlan on top of a bridge master it will shotgun its GARPS all 
>> the same. So it's not like veth would be special in that regard.
>>
>> Nik, what am I missing?
>>
> 
> If we're talking about macvlan -> bridge -> bond then the bond flap's
> notify peers shouldn't reach the macvlan. Generally broadcast traffic
> is quite expensive for the bridge, I have patches that improve on the
> technical side (consider ports only for the same bcast domain), but you also
> wouldn't want unnecessary bcast packets being sent around. :)
> There are setups with tens of bond devices and propagating that to all would be
> very expensive, but most of all unnecessary. It would also hurt setups with
> a lot of vlan devices on the bridge. There are setups with hundreds of vlans
> and hundreds of macvlans on top, propagating it up would send it to all of
> them and that wouldn't scale at all, these mostly have IP addresses too.
> 
> Perhaps we can enable propagation on a per-port or per-bridge basis, then we
> can avoid these walks. That is, make it opt-in.
> 
>>> It also seems difficult to avoid re-bouncing the notifier.
>>
>> syzbot will make short work of this patch, I think the potential
>> for infinite loops has to be addressed somehow. IIUC this is the 
>> first instance of forwarding those notifiers to a peer rather
>> than within a upper <> lower device hierarchy which is a DAG.

My concern was about the Hangbin's alternative proposal to notify all
bridge ports. I hope in my porposal I was able to avoid infinite loops.

>>
>>> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
>>> --- 
>>>  drivers/net/veth.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 53 insertions(+)
>>>
>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>> index d29fb9759cc9..74b074453197 100644
>>> --- a/drivers/net/veth.c
>>> +++ b/drivers/net/veth.c
>>> @@ -1579,6 +1579,57 @@ static void veth_setup(struct net_device *dev)
>>>  	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
>>>  }
>>>  
>>> +static bool netif_is_veth(const struct net_device *dev)
>>> +{
>>> +	return (dev->netdev_ops == &veth_netdev_ops);
>>
>> brackets unnecessary 
>>
>>> +}
>>> +
>>> +static void veth_notify_peer(unsigned long event, const struct net_device *dev)
>>> +{
>>> +	struct net_device *peer;
>>> +	struct veth_priv *priv;
>>> +
>>> +	priv = netdev_priv(dev);
>>> +	peer = rtnl_dereference(priv->peer);
>>> +	/* avoid re-bounce between 2 bridges */
>>> +	if (!netif_is_bridge_port(peer))
>>> +		call_netdevice_notifiers(event, peer);
>>> +}
>>> +
>>> +/* Called under rtnl_lock */
>>> +static int veth_device_event(struct notifier_block *unused,
>>> +			     unsigned long event, void *ptr)
>>> +{
>>> +	struct net_device *dev, *lower;
>>> +	struct list_head *iter;
>>> +
>>> +	dev = netdev_notifier_info_to_dev(ptr);
>>> +
>>> +	switch (event) {
>>> +	case NETDEV_NOTIFY_PEERS:
>>> +	case NETDEV_BONDING_FAILOVER:
>>> +	case NETDEV_RESEND_IGMP:
>>> +		/* propagate to peer of a bridge attached veth */
>>> +		if (netif_is_bridge_master(dev)) {
>>
>> Having veth sift thru bridge ports seems strange.
>> In fact it could be beneficial to filter the event based on
>> port state (whether it's forwarding, vlan etc). But looking
>> at details of port state outside the bridge would be even stranger.
>>
>>> +			iter = &dev->adj_list.lower;
>>> +			lower = netdev_next_lower_dev_rcu(dev, &iter);
>>> +			while (lower) {
>>> +				if (netif_is_veth(lower))
>>> +					veth_notify_peer(event, lower);
>>> +				lower = netdev_next_lower_dev_rcu(dev, &iter);
>>
>> let's add netdev_for_each_lower_dev_rcu() rather than open-coding
>>
>>> +			}
>>> +		}
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +	return NOTIFY_DONE;
>>> +}
>>> +
>>> +static struct notifier_block veth_notifier_block __read_mostly = {
>>> +		.notifier_call  = veth_device_event,
>>
>> extra tab here
>>
>>> +};
>>> +
>>>  /*
>>>   * netlink interface
>>>   */
>>> @@ -1824,12 +1875,14 @@ static struct rtnl_link_ops veth_link_ops = {
>>>  
>>>  static __init int veth_init(void)
>>>  {
>>> +	register_netdevice_notifier(&veth_notifier_block);
>>
>> this can fail
>>
>>>  	return rtnl_link_register(&veth_link_ops);
>>>  }
>>>  
>>>  static __exit void veth_exit(void)
>>>  {
>>>  	rtnl_link_unregister(&veth_link_ops);
>>> +	unregister_netdevice_notifier(&veth_notifier_block);
>>>  }
>>>  
>>>  module_init(veth_init);
>>
> 
