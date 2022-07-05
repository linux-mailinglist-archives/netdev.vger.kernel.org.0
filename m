Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34491567048
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiGEOHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiGEOG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:06:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF2B13D39
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 06:55:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5rf4iAaiu/XvFg4UT9X+ujbFZ+I5S+oQWQ3T1mR7q227cxSfddod7BM374uIS7+FB47AvZo37zam4yuHLQPkmAsJ8VSgOaJZfY50CCpOb6FWdByshckOMujgoUGnE3Km0C75HqqRxy7LRow5Zs71nQJgmzzlUlBB5B3u5aJoRBYf7zOi8SgehcqsHwawltcv7OWxKd5eUEmOAOp+1wKrKr81ElJTcMPG0610XBx1yIbYErgvh8kCElyeZ7NAujjmY07zpWtGo0VPGiJTcnrdykkULejXRHz1kheqh7FUHBQe2dWLvvOajwxkvD/1A7kfzoPdAU6O6DjohMeqSPfxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tlyzo9d3TkxKafqfURh83EanQHpstpIIzWgqzAzYf4=;
 b=NkknJAlLZfovS7FiHegiUa7eEn02QcgnRKcYTxAVZIi1MARrRR6fAiICCGR57y1YAfzybAbkCdDZRf5y2aoUcWn6NmOqqiR7fRVJ5H4xSC7BBkivTs5cM4kXyjNFnmjhl1NGy3bDGOXCorspY4bJd07UsRlT73YRPpZ0XAUO0lIGHdqXbhVV1YPP7MZPMEVMvlUBXBrwGYxvmihe4GmDHRFekCwZMweeQsFwzDnDrPv5JDmwAQRl939MICEPa8U3uLUILFU4uj4nEe1UtWQuPRVKeHByVL0OrYdGwgXzpfH0hMkf12OeQ4Sx25lnnNyOXceE3I7D7WlbES7GUTRlcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tlyzo9d3TkxKafqfURh83EanQHpstpIIzWgqzAzYf4=;
 b=q/WfaKnokNp4qbUuhStO1LPVXSnMOfB7XCI7OI7Y6n7HaMQZyHq4SHW6plbKX/R6ovfkmQKopoe/Vf+Joa38Elbn8wlkB/tpDpI8IMuhvmFRB1bUkMThpJECPwS6BDB1ccfU5DD/mNWyx1qQA85TU7unxnpCZo7Ko/5Lcz0J1Voea6tO+3h5Ku6isejjHIP1jCQzGDMlJwS2Nb/8o5U9WYLabAVK0mpyOmd0ijYJJGdHXAv2S0YMiWXnjZb7GzbQzJ0EVb/ixrQH9XXzofP9xRx3jHxabMBrYmOqW7BkbpRfkkbMRrAWyujM7H9sOBk4hvvH8hL75YwkyqNx4L48Dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1452.namprd12.prod.outlook.com (2603:10b6:4:a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Tue, 5 Jul 2022 13:55:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 13:55:31 +0000
Date:   Tue, 5 Jul 2022 16:55:25 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, razor@blackwall.org
Subject: Re: Bridge VLAN memory leak
Message-ID: <YsRCzTrajO5GZemf@shredder>
References: <87a69oc0qs.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a69oc0qs.fsf@nvidia.com>
X-ClientProxiedBy: LO3P265CA0017.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0be754da-bd72-4d8f-577b-08da5e8e061f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1452:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRxh0BC/p32mehx+TA8kp56NjeIwwcrpWz4HNpMcFSZ8XDiztwK9TJHo5pEObbvxkCuj8Xh105RWC+Jlj+SBnux1AeRUiDwHT+oIjrcyislFs9g8isjsppIHhHa40pWCrAAl2LnU3vL4CKE8cPNNrCeTyylCK+xkSXBK2kIsqso3Lyn4+Tcg4PSRaiRfzSiNAOusJIuC8IS5m4TV4pDhVxOT9dEdA/mrlVSpDuPxam2fAqrtfcSnHWeBZuc429SNvpqKBz1PnTt/dVtU9UxUpbngW3U9kQKH/CS9e2YkR7JIi2/KXdbI0BjwU65f5ughPvZuqUVCZo5R070OSrQJPO1FdT6CAwfoZUPto3pGGLsUAx91fi7um3vPx3MwCsMZphyXJN+0okjJ/b6Vry1wB1q/yVNv8wxdrgEOoWu2wig2QqwqRcr6RmqxLFZtYX1uh3JJf2T1yv/+bHIE8bwjEfUPw+VPQgvg2IGKiAFC3LysQXRqwtrg6Ui4lGUEb8HjkAhAHAJebg/7Tv+hiAWGN4BaryPYI1RPtSs29InPzQPgfoWGXEB4yGyt2fidVtDtGBbastdeXHSdNk8xT9/mJMVvtg8gbgtxENMJb1kTX+niB7O5zeneoT2RL07kgKJ44QwhvOTXu8qcwKTCdB6+J3QFTzcU/06Wy3I0OJa/TwS89i7jfJdrqtdjDmlS0VlTmg4zmnCTl1cJOZsaphlHsGRhKRio2Xz284n6GO/kvqNHZiyJI4BidkdqxJkuLcc1xc0efEQiLG0DNexd5CMotDFKd59Ta0OFm5lFLu3OVzysp51Wr0T/ykI1CZMtjx+otOkorPHZnaYrvTUNdsEv8pOrJTWI7P0G08vP0mtEj4KrQARJGLHtmhy/2og2pTmYw3bAVGl0Z88rSFCMiI1OKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(366004)(396003)(136003)(39860400002)(346002)(8936002)(6862004)(38100700002)(966005)(6486002)(86362001)(478600001)(66946007)(6512007)(4326008)(8676002)(3480700007)(9686003)(66476007)(66556008)(33716001)(5660300002)(26005)(186003)(316002)(6636002)(54906003)(2906002)(41300700001)(6506007)(83380400001)(6666004)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?auLEEyhYEXCbVwiY9BGiFql1cQ6h1wdffs97RSuegD+06LAxqEikejInE6Gr?=
 =?us-ascii?Q?WA8upKmF/mvFhDW1f1fyCojtXKDl03q7fRSfgsLSLTfVGvmkdma7YTNwH6cR?=
 =?us-ascii?Q?7kQpRS/zywitTHJdAJTvPks1aWEDPynVXubquz7rXHwYkFt0O4ftjqsfOAmW?=
 =?us-ascii?Q?XUw+QN95R8QLvy+63b8n1T2K62W3djBnl0GGxJ/zwGmRWXSBFl4+SKYzbEbT?=
 =?us-ascii?Q?Hi23lp0Il7IBp6LQyN4ClM+EwOFAfhPf3RPYZRZQmUmETFWqx1Ckgoro8Xf9?=
 =?us-ascii?Q?iGpmrOLXZcIyhBHP3QS3hGkpyFWQRc8OTQs2ZPkaJeE87J/taC9H9kwCElfK?=
 =?us-ascii?Q?a3mYVWObMt6UvLeSxsHmIPKpKtFaCvLSIEjPzqkCEKtVZHNwrfOceF2dYT/l?=
 =?us-ascii?Q?rDNTagAtoUQnfVOdw+gYFWPdXVArHSGSEODy1JS9aSAAAyyrfawnj2rS7ce4?=
 =?us-ascii?Q?lTibOrknvAC6Yh8wScI0F+PATcq4AmYjRRya+y4r6fVe03+Y1pH7ir7Tym7x?=
 =?us-ascii?Q?ZTAwnZ8VjspJ0InoRGnMGNPE1Gll56Ht7ek21uw80QLkyjZWkhlE0Q5RcM/6?=
 =?us-ascii?Q?l5GF496ab5Fik6Jocn679pmIdBgpYhLVHWZXyB+JJxnjcu/E1X4hvVmEN4gK?=
 =?us-ascii?Q?IGcEZblybudNS75cBvOEys4H+0jb23JnHCxqTSiTI2vKdYwytGnlS+M3io7k?=
 =?us-ascii?Q?uVbujg4HYKI8uTytQ+4ytnfMARdoD6PIB8zdyiKkYD0ouwpcH+wLDThehLK6?=
 =?us-ascii?Q?ZcY6MA4CzzwUfOTmvNBxbN83Di/djII511LMm8L8hiJV5aGnFtX9k3en3Dfx?=
 =?us-ascii?Q?XllPKnVbWw+0r7E9jKe8+dz8/3GO6AHg71fhLjdpdfkztxkK4bkuRgwNllGZ?=
 =?us-ascii?Q?UFRyveMcIj6PDt2eI91UpdSDdvlNbtNSQ/BSavn+KyUBsbTrq0k9OF21C5W6?=
 =?us-ascii?Q?YOBVxkCOcl+mfMp7Sfu1xRUlVhE0lZi8l73DDKqwSM1lDIn0VDE+QPeyKhp1?=
 =?us-ascii?Q?KEWvfr+wGS2F+64v9pENBSgccGSqNiMJ3byvWqlflbC0zqqQ/jupS1Os/dWe?=
 =?us-ascii?Q?xCcQOjJD1ZYJNgdb+9NBSgiTT21KBVo4lBa9mymcJ2opsNJx6FIytzz91usp?=
 =?us-ascii?Q?mS9e9xixqGq5IsmAeORMT1+l1HfsRGs/3hiydHwOZtcp+twu6T8iKI27j9QQ?=
 =?us-ascii?Q?32b7ika2gQPAQ+eK2aSY2W9G8pfJsRwoDnCEZGTnnLhbEGyMMWCS62W6FYSc?=
 =?us-ascii?Q?8OaPQpYDW6zuaqG0cOUnsugNCYd1812/EwXTVLpHcmKkvOQS7TEOTdzQVIiM?=
 =?us-ascii?Q?7EnqCQp93P5u8ZK1GMFXmpwThQUweOKG0CyGkMF2o1iyuVUIATtM2huHlfPi?=
 =?us-ascii?Q?0i1+VxCjOsn4abPL1uHR6qbWJbL5v9bKwfsThWzmrcoSh0rItRT9giQ81+M1?=
 =?us-ascii?Q?oVNeMLJF/Dm3hNIv9ZYrAqNEtUs2nsIdX/iWj73ADFycM2GWPk8eI5kG+XIw?=
 =?us-ascii?Q?LEcXTv5UsqqP77npatUtd0n3xvbPzGngU6PCLADOfFt1d/jr/uVcHqI9zieg?=
 =?us-ascii?Q?3u8SqIgUPU5ppIzrmOwJsujKr24D7oE34m6jF/BG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be754da-bd72-4d8f-577b-08da5e8e061f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 13:55:30.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DebJkVKWeqkC+m3V1bozh1weCOA6MgzZPwQ+j5IjVczaaohunwrjXvOErTV8Qn9TFWwDrdw2S2FvLdyeSIjtYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1452
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 06:47:29PM +0300, Vlad Buslov wrote:
> Hi Ido,
> 
> While implementing QinQ offload support in mlx5 I encountered a memory
> leak[0] in the bridge implementation which seems to be related to the new
> BR_VLFLAG_ADDED_BY_SWITCHDEV flag that you have recently added.

FTR, added here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=279737939a8194f02fa352ab4476a1b241f44ef4

> 
> To reproduce the issue netdevice must support bridge VLAN offload, so I
> can't provide a simple script that uses veth or anything like that.
> Instead, I'll describe the issue step-by-step:
> 
> 1. Create a bridge, add offload-capable netdevs to it and assign some
> VLAN to them. __vlan_vid_add() function will set the
> BR_VLFLAG_ADDED_BY_SWITCHDEV flag since br_switchdev_port_vlan_add()
> should return 0 if dev can offload VLANs and will also skip call to
> vlan_vid_add() in such case:
> 
>         /* Try switchdev op first. In case it is not supported, fallback to
>          * 8021q add.
>          */
>         err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
>         if (err == -EOPNOTSUPP)
>                 return vlan_vid_add(dev, br->vlan_proto, v->vid);
>         v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
> 
> 2. Enable filtering and set VLAN protocol to 802.1ad. That will trigger
> the following code in __br_vlan_set_proto() that re-creates existing
> VLANs with vlan_vid_add() function call whether they have the
> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set or not:
> 
>          /* Add VLANs for the new proto to the device filter. */
>          list_for_each_entry(p, &br->port_list, list) {
>                  vg = nbp_vlan_group(p);
>                  list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>                          err = vlan_vid_add(p->dev, proto, vlan->vid);
>                          if (err)
>                                  goto err_filt;
>                  }
>          }
> 
> 3. Now delete the bridge. That will delete all existing VLANs via
> __vlan_vid_del() function, which skips calling vlan_vid_del() (that is
> necessary to clean up after vlan_vid_add()) if VLAN has
> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set:
> 
>          /* Try switchdev op first. In case it is not supported, fallback to
>           * 8021q del.
>           */
>          err = br_switchdev_port_vlan_del(dev, v->vid);
>          if (!(v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV))
>                  vlan_vid_del(dev, br->vlan_proto, v->vid);

Looking at the code before the change, I'm pretty sure you will be able
to reproduce the leak prior to above mentioned commit:

```
-	err = br_switchdev_port_vlan_del(dev, vid);
-	if (err == -EOPNOTSUPP) {
-		vlan_vid_del(dev, br->vlan_proto, vid);
-		return 0;
-	}
-	return err;
```

> 
> 
> The issue doesn't reproduce for me anymore if I just clear the
> BR_VLFLAG_ADDED_BY_SWITCHDEV flag when re-creating VLANs on step 2.
> However, I'm not sure whether it is the right approach in this case.
> WDYT?

As a switchdev driver you already know about the new VLAN protocol via
'SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL' so do we really need the VLANs
to be programmed again? The VLAN protocol is not communicated in
'SWITCHDEV_OBJ_ID_PORT_VLAN' anyway.

Can you try the below (compile tested only)?

```
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc991409..9ffd40b8270c 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
 		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			err = vlan_vid_add(p->dev, proto, vlan->vid);
 			if (err)
 				goto err_filt;
@@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	/* Delete VLANs for the old proto from the device filter. */
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, oldproto, vlan->vid);
+		}
 	}
 
 	return 0;
@@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	attr.u.vlan_protocol = ntohs(oldproto);
 	switchdev_port_attr_set(br->dev, &attr, NULL);
 
-	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
+	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
+		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+			continue;
 		vlan_vid_del(p->dev, proto, vlan->vid);
+	}
 
 	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, proto, vlan->vid);
+		}
 	}
 
 	return err;
```

> 
> [0]:
> 
> unreferenced object 0xffff8881f6771200 (size 256):
>   comm "ip", pid 446855, jiffies 4298238841 (age 55.240s)
>   hex dump (first 32 bytes):
>     00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000012819ac>] vlan_vid_add+0x437/0x750
>     [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
>     [<000000000632b56f>] br_changelink+0x3d6/0x13f0
>     [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
>     [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
>     [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
>     [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
>     [<0000000010588814>] netlink_unicast+0x438/0x710
>     [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
>     [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
>     [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
>     [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
>     [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
>     [<000000004538b104>] do_syscall_64+0x3d/0x90
>     [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> 
> Regards,
> Vlad
