Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF5567497
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiGEQkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiGEQkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:40:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019E61CB3F
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 09:40:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmSMg2Xa9gZdbgwJSjXZMzvIZdpgGgMTla/qu5ih4gb6XC+ct+Xe5bOKdWzCQDfyXH1ulpybuWCg6/I6fY+hTVhgpWPMyqMhIxMItbdVvwpY/vzf62b40+lb/7FRklZdLnUrtehxFDwQncStRXLkD43cYhqMAiJqJXwg78OfadjVAuitkNC8NgP9/BcK1KaMfbLmX8EzENPRRBD1tJAU+G2Be4IYymA/OaflidMdylFLzU0RE7iP+NUodica3OU8hRAM3nsJ8L1vFGF3fMbjVoqKP9Wd2fEiZT6uUu+tCc1BpUoFQrZVjbrMuG0VrbIxF2tXrG05jdaAZrBY1yP2Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4c7ELw86avaweyr9FHa9am/owYgFAU+C6P7itlRkVU=;
 b=n/Ru76K/SJTyaRKNNuo7OX2foINhVTAQ7pBx7nLDTy4ihMHJ19LZw6zXxH9Hql/pb8e5L8QtiuNi85h0c+jczVnZFsZt4akOpAUK3N0pAnsY+QAnyF+TVwfRs+9tLCDdpIco6cTnlhXI3S4sF4BRuq3m/cH+6STgjoFc7arSOgcsgXiwjR0YHMneRAjp37goITpP0MVXwtmPX4QQyCSWtQRRHEuFn7s4ta/0PiMF9LbTT7Qstc0wBLtLSIL3rdJqXno3UtRo8W4YQKzuYp3r52mzlqHYIkp/7cEJjvXyzQOjo0q06TMIt4bHhg5Ht+hr4UU8ORHIogmxGkIZrAJ9mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4c7ELw86avaweyr9FHa9am/owYgFAU+C6P7itlRkVU=;
 b=QWb6VYF4f7VE0PCNW376fjW61J08u7gUVP/h9JwcuxvEKHomj/FunZBzDtLgOxRDnWwvyINIELygwbPB2w3cJ6wvvzn9zRyEPqLjSZAOA8MLow4vVPTebpN3rV2Ps6rZIbo9Kju//FKe0A3VUWfm4qsH1IA36IuCpxmPsXZdrfb0X8REu+irK5dK0G9oDP8GktzCwobKUuUPrczR+DzY736BncRV3++zuAmg41z9qZlG6VKQmO3tptPLjLwEPqW7W1A7Wccg7wl1DMPSfm7ImHidvrUOnCI+SaGRuTGtS9oFwDzREjFm04IqUxjOk0IWKOMHGCmPMKDhhHDJhEpoCw==
Received: from DM6PR02CA0047.namprd02.prod.outlook.com (2603:10b6:5:177::24)
 by DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Tue, 5 Jul 2022 16:40:40 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::b0) by DM6PR02CA0047.outlook.office365.com
 (2603:10b6:5:177::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 16:40:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 16:40:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 5 Jul
 2022 16:40:39 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 5 Jul 2022
 09:40:35 -0700
References: <87a69oc0qs.fsf@nvidia.com> <YsRCzTrajO5GZemf@shredder>
 <875ykbboi0.fsf@nvidia.com> <YsRb/cJJ+zSKQkdD@shredder>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, <razor@blackwall.org>
Subject: Re: Bridge VLAN memory leak
Date:   Tue, 5 Jul 2022 19:25:14 +0300
In-Reply-To: <YsRb/cJJ+zSKQkdD@shredder>
Message-ID: <871quzbji8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9a39251-cb1d-4f81-ffc5-08da5ea51894
X-MS-TrafficTypeDiagnostic: DM8PR12MB5413:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4oq6ePA3MqmablCeRFiT0yGQ5yEFfNRu65Jh6OUxDZVwWE15N1qRMkd9F3hY?=
 =?us-ascii?Q?cRFMc6NvOmy0MyjR4Qzszi/WFKOgTnyd+RH6Bmuv3K/DglaXAKdcLrdEAaVy?=
 =?us-ascii?Q?dWOYpTI8NaTslmBidHL9dG77f89uMGSNlRIl4FrQVxR5ZDxfWCxdGQWUud9P?=
 =?us-ascii?Q?p37QdCVdTXRwJueoV2TNAd2B91BMLQI0CNSUb6vVP4yuuXKhUMN85v2EnQP+?=
 =?us-ascii?Q?Do1S1A/0UylClkojuFRJp6xCtRmzgOicoxYluKcJLywNwldIrT0kwJwzBmJJ?=
 =?us-ascii?Q?pPkbF8WP8DkCNqc/6MrUJ9RNy+wLO6k6PZ/zpPXcnY1JjiH8sLIX+cW0Vsz6?=
 =?us-ascii?Q?ay3uam49bgSvbbkFQJyTXPITdpW9XXrOEahnkWwWgdxGtE5B1c8VKBT+PQby?=
 =?us-ascii?Q?kVLUIV5FrQoRfdlBNIQ3MqYTjPOukydXr7ig3rXJEo5yYufuSxf5fYozhGjN?=
 =?us-ascii?Q?b7wLuEE5o8F7CEcwUS3yNTfyXMZvncf3DjUPJlm/J0qSa82Is+U38/Q0tVR/?=
 =?us-ascii?Q?iamr1J67UW25ZqfZmYBb5D1zC4IWEQX0GpsVSt3l8pu6urs5LgHivwGaFA9x?=
 =?us-ascii?Q?EmRQhGDYQ7K1Z+rLDLhhnWKQzkysoLv/Mm9zTJm596mGd/cQshCU7SNXOoWK?=
 =?us-ascii?Q?LfCSrHF9FNY4kxecRXxn2xiZpXEWhvy4xr6k+HZeJmHgnIP2G47wG6faJVBK?=
 =?us-ascii?Q?Fz82fC417dDrpNESv4571AQ95sZL/KyrPLRvh7y+K9ZiapCT6Z/Gk3RywrWN?=
 =?us-ascii?Q?ZIZ5qu/uWLRUTIt5yLXGXcz7lGPTNkKNd6OkTMWJbmdT3PMS9/AKGmG+zybG?=
 =?us-ascii?Q?gtCwg8TG6MNJNAOV7O+jF09OEDkgZRmppTapUCfhtcmCpH03LpA24AtEurya?=
 =?us-ascii?Q?jSzsCWjJ1ok3QxtAEJCtJjEdwh1OYeZhjwmjzE11wDVTtgn+ajjAC7WyaV+H?=
 =?us-ascii?Q?ea4lM7y8dJtZ8Oh/gfxrFQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(376002)(46966006)(40470700004)(36840700001)(26005)(37006003)(54906003)(5660300002)(6636002)(8936002)(6862004)(2616005)(36756003)(6666004)(41300700001)(336012)(426003)(47076005)(83380400001)(16526019)(186003)(7696005)(82310400005)(356005)(478600001)(2906002)(966005)(86362001)(81166007)(82740400003)(40480700001)(3480700007)(36860700001)(40460700003)(8676002)(4326008)(316002)(70206006)(70586007)(36900700001)(505234007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 16:40:40.0285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a39251-cb1d-4f81-ffc5-08da5ea51894
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 05 Jul 2022 at 18:42, Ido Schimmel <idosch@nvidia.com> wrote:
> On Tue, Jul 05, 2022 at 05:46:49PM +0300, Vlad Buslov wrote:
>> On Tue 05 Jul 2022 at 16:55, Ido Schimmel <idosch@nvidia.com> wrote:
>> > On Mon, Jul 04, 2022 at 06:47:29PM +0300, Vlad Buslov wrote:
>> >> Hi Ido,
>> >> 
>> >> While implementing QinQ offload support in mlx5 I encountered a memory
>> >> leak[0] in the bridge implementation which seems to be related to the new
>> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag that you have recently added.
>> >
>> > FTR, added here:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=279737939a8194f02fa352ab4476a1b241f44ef4
>> >
>> >> 
>> >> To reproduce the issue netdevice must support bridge VLAN offload, so I
>> >> can't provide a simple script that uses veth or anything like that.
>> >> Instead, I'll describe the issue step-by-step:
>> >> 
>> >> 1. Create a bridge, add offload-capable netdevs to it and assign some
>> >> VLAN to them. __vlan_vid_add() function will set the
>> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag since br_switchdev_port_vlan_add()
>> >> should return 0 if dev can offload VLANs and will also skip call to
>> >> vlan_vid_add() in such case:
>> >> 
>> >>         /* Try switchdev op first. In case it is not supported, fallback to
>> >>          * 8021q add.
>> >>          */
>> >>         err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
>> >>         if (err == -EOPNOTSUPP)
>> >>                 return vlan_vid_add(dev, br->vlan_proto, v->vid);
>> >>         v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
>> >> 
>> >> 2. Enable filtering and set VLAN protocol to 802.1ad. That will trigger
>> >> the following code in __br_vlan_set_proto() that re-creates existing
>> >> VLANs with vlan_vid_add() function call whether they have the
>> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set or not:
>> >> 
>> >>          /* Add VLANs for the new proto to the device filter. */
>> >>          list_for_each_entry(p, &br->port_list, list) {
>> >>                  vg = nbp_vlan_group(p);
>> >>                  list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>> >>                          err = vlan_vid_add(p->dev, proto, vlan->vid);
>> >>                          if (err)
>> >>                                  goto err_filt;
>> >>                  }
>> >>          }
>> >> 
>> >> 3. Now delete the bridge. That will delete all existing VLANs via
>> >> __vlan_vid_del() function, which skips calling vlan_vid_del() (that is
>> >> necessary to clean up after vlan_vid_add()) if VLAN has
>> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set:
>> >> 
>> >>          /* Try switchdev op first. In case it is not supported, fallback to
>> >>           * 8021q del.
>> >>           */
>> >>          err = br_switchdev_port_vlan_del(dev, v->vid);
>> >>          if (!(v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV))
>> >>                  vlan_vid_del(dev, br->vlan_proto, v->vid);
>> >
>> > Looking at the code before the change, I'm pretty sure you will be able
>> > to reproduce the leak prior to above mentioned commit:
>> >
>> > ```
>> > -	err = br_switchdev_port_vlan_del(dev, vid);
>> > -	if (err == -EOPNOTSUPP) {
>> > -		vlan_vid_del(dev, br->vlan_proto, vid);
>> > -		return 0;
>> > -	}
>> > -	return err;
>> > ```
>> >
>> >> 
>> >> 
>> >> The issue doesn't reproduce for me anymore if I just clear the
>> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag when re-creating VLANs on step 2.
>> >> However, I'm not sure whether it is the right approach in this case.
>> >> WDYT?
>> >
>> > As a switchdev driver you already know about the new VLAN protocol via
>> > 'SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL' so do we really need the VLANs
>> > to be programmed again? The VLAN protocol is not communicated in
>> > 'SWITCHDEV_OBJ_ID_PORT_VLAN' anyway.
>> 
>> In my WIP implementation of 802.1ad offload I just re-create all
>> existing VLANs in hardware with new protocol upon receiving
>> SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification.
>
> Would it be easier for you if you got the VLAN protocol in
> 'SWITCHDEV_OBJ_ID_PORT_VLAN' and __br_vlan_set_proto() would invoke
> __vlan_vid_add() and __vlan_vid_del() instead of calling the 8021q
> driver directly?

For me it is easy to iterate and re-create existing VLANs with new
protocol inside the driver since I already have all the necessary
structures for that. Also, with current architecture I pre-create
required flow groups based on current bridge VLAN proto (during new
bridge creation or on reception of
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL event), so having protocol inside
switchdev_obj_port_vlan will be redundant.

>
>> 
>> >
>> > Can you try the below (compile tested only)?
>> 
>> With the patch applied memleak no longer reproduces.
>> 
>> >
>> > ```
>> > diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>> > index 6e53dc991409..9ffd40b8270c 100644
>> > --- a/net/bridge/br_vlan.c
>> > +++ b/net/bridge/br_vlan.c
>> > @@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
>> >  	list_for_each_entry(p, &br->port_list, list) {
>> >  		vg = nbp_vlan_group(p);
>> >  		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>> > +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>> > +				continue;
>> >  			err = vlan_vid_add(p->dev, proto, vlan->vid);
>> >  			if (err)
>> >  				goto err_filt;
>> > @@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
>> >  	/* Delete VLANs for the old proto from the device filter. */
>> >  	list_for_each_entry(p, &br->port_list, list) {
>> >  		vg = nbp_vlan_group(p);
>> > -		list_for_each_entry(vlan, &vg->vlan_list, vlist)
>> > +		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>> > +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>> > +				continue;
>> >  			vlan_vid_del(p->dev, oldproto, vlan->vid);
>> > +		}
>> >  	}
>> >  
>> >  	return 0;
>> > @@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
>> >  	attr.u.vlan_protocol = ntohs(oldproto);
>> >  	switchdev_port_attr_set(br->dev, &attr, NULL);
>> >  
>> > -	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
>> > +	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
>> > +		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>> > +			continue;
>> >  		vlan_vid_del(p->dev, proto, vlan->vid);
>> > +	}
>> >  
>> >  	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
>> >  		vg = nbp_vlan_group(p);
>> > -		list_for_each_entry(vlan, &vg->vlan_list, vlist)
>> > +		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>> > +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>> > +				continue;
>> >  			vlan_vid_del(p->dev, proto, vlan->vid);
>> > +		}
>> >  	}
>> >  
>> >  	return err;
>> > ```
>> >
>> >> 
>> >> [0]:
>> >> 
>> >> unreferenced object 0xffff8881f6771200 (size 256):
>> >>   comm "ip", pid 446855, jiffies 4298238841 (age 55.240s)
>> >>   hex dump (first 32 bytes):
>> >>     00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  ................
>> >>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> >>   backtrace:
>> >>     [<00000000012819ac>] vlan_vid_add+0x437/0x750
>> >>     [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
>> >>     [<000000000632b56f>] br_changelink+0x3d6/0x13f0
>> >>     [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
>> >>     [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
>> >>     [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
>> >>     [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
>> >>     [<0000000010588814>] netlink_unicast+0x438/0x710
>> >>     [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
>> >>     [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
>> >>     [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
>> >>     [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
>> >>     [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
>> >>     [<000000004538b104>] do_syscall_64+0x3d/0x90
>> >>     [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> >> 
>> >> 
>> >> Regards,
>> >> Vlad
>> 

