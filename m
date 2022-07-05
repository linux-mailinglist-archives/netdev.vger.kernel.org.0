Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733ED567190
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiGEOwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiGEOwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:52:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C54E13EA9
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 07:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cn+sFm/NRr9TG2VN2Uo7MifbuxGAors6UlRJJkhBXnCf5lzY1bEWvd6CHg5pFKO5Kz/04uUVsZOC1en4FvDu7xYW7hp1P6MHDv4jFy6peWsSgaFaR6F52zIRNZZqo6Hc3S9oHmii1BxOq0mh9wFXCNtEBvKnxQG3dM9JsuHd60fWw8uwMW4lrKAepq4wkMDWZQMVZ8tWVxr/2M6CaHr8wrpqLOpXiWhxdsUgVwVA0tCzdKNj/gHjebNT5mbX1zI+/oYtzbgl33bh3Ki4fHZ5IZLO4AND8/HNaG0mzxmxdhJaZWTSmZfqGIQvaRFPByd4UZR69OqD2j1Knrqexk9YFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nt8X4t7FkcNftijg0ikn1+G4le7gGLHQWnaT0UyO8F4=;
 b=g2Syz2Yj4GD9Andjj86flrffvMYEdsrDk97XLCTPAzFo2xiT7CXQt8gCsxMKqSkL3I9JLj4pPrfNSlUVUePnXphk/GLMu9xnjfaWXH0McEdrCA5QNg+pcbUZ/tSlBOUGgEb5O/5LOtxAMsCEm/nboodhJRIsDQSE4zgpHOhSqjLjd5Eslc61rXgQXvXcDRghSVG3Qx2sd2Hsmcihs13wonIdJlBje93KIFVh/uaouXAlpUHuYyio0vGdYZ85G8ajvhJ/5IHZPEoIfP/O07sZwTdr5XyMBj2g09z4xJqiyaM7DcdOqsomhexUyVs3YylJz+sKbBlDfvh4ACBkdp1afg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt8X4t7FkcNftijg0ikn1+G4le7gGLHQWnaT0UyO8F4=;
 b=jnGon+7dHYKQ9Ll5qKJs4/G8jLlJOR5lck+d3TgVm9B8bbR6ted/pK4pMVAHPmCQYhtmwqA01uLvMISoyJBbypur+oVnM6BDkCszADjjGeZv3BRHUCGWI1Vce6LaL2YTBwDx0sB4djM5gSkobtYyYuCYGqgQv9e9P58Gn0yIT1sANvgUR0Iyf91MDk0zsfQgBpPsLKj9FXTWFIW18lDIY2o94wGehEmAd0PC1pMvq+G6D5+fD5/XZ+zaSxKSM9oYHrC+BlD2xm8qZHk6HL42dlLGDNjCwIfxt3Azh3DaCC5IkaDmZTHofc94YSTRYj+A09XIg9d5rjW6InuHzUrqoA==
Received: from BN6PR1201CA0003.namprd12.prod.outlook.com
 (2603:10b6:405:4c::13) by MN2PR12MB4205.namprd12.prod.outlook.com
 (2603:10b6:208:198::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 14:52:46 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::ff) by BN6PR1201CA0003.outlook.office365.com
 (2603:10b6:405:4c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 14:52:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 14:52:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 5 Jul
 2022 14:52:45 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 5 Jul 2022
 07:52:42 -0700
References: <87a69oc0qs.fsf@nvidia.com> <YsRCzTrajO5GZemf@shredder>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, <razor@blackwall.org>
Subject: Re: Bridge VLAN memory leak
Date:   Tue, 5 Jul 2022 17:46:49 +0300
In-Reply-To: <YsRCzTrajO5GZemf@shredder>
Message-ID: <875ykbboi0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 650ddb39-4f56-4574-4098-08da5e9605ec
X-MS-TrafficTypeDiagnostic: MN2PR12MB4205:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Et4OX2jM7DRHZqRxINPjXYcYiGxl9ucZaOGhPPqQXPotS4zlptXXAEx1xq0J?=
 =?us-ascii?Q?1a2C7sstVs8M9KNSUZi6jhgLA5cQZmSy+Jh+qpCzoYreSytvhl3sGiQzm26R?=
 =?us-ascii?Q?J7okXW0G6ur6iRT7RF2K0gaqIcILwzhGA0SErxFXuH6jm37CqdlCGJ2If7uN?=
 =?us-ascii?Q?Pg/AS42oWCkoBTWlck2B38cHc/eQqDmnzNArHUfYCwREKn6exu3w1EXjNINy?=
 =?us-ascii?Q?h5/thNH7fkXugp5RbCFcRfz4DITYSbYMFPx0T7IyTRHIIkk47HIPpXxhhrXM?=
 =?us-ascii?Q?UjrwItuGkQ3fYags/vRjTXVBOwqeSe5l5gP146hB9tesWoOXp0MgsNzwppxM?=
 =?us-ascii?Q?ynBFDbNstM73WrbyWYDZvTI5nbgpEEP00WjRsY91lExdYMJMLBZwQOK/iDXk?=
 =?us-ascii?Q?olO3RdP8P/krx2cLSrS7H3/4sDEGI7Js/stuTDf7LSWHnkZSXuTw72aPPFn+?=
 =?us-ascii?Q?dyHjD4CiBQ5UJVBkvDeuwXRq8y7DCbfPHXI1JcA2qj5seSX6gUVLxPnW0EYi?=
 =?us-ascii?Q?x4rGw1jv9AsT6Q8EFR6GujZSZIQrShiQgT0ckVf/e9HqGWlO2W/ww/ILxqDD?=
 =?us-ascii?Q?c6cklIY5Sm4jA8AWHiQHrYvQkQr3b6WnVSA+GP4C58TYKhgR14e3gzl0T1AG?=
 =?us-ascii?Q?olHVAFp7bkuF0rFn+vdXviV2gbTCIbDhq9Y61nZOIlNJezYHiCe1o05R7Wrq?=
 =?us-ascii?Q?WaMYgigdBLln//p0WUoUsQWew9TCwX7d6QWZNtT61HBjgfamvDpOB+R4DXQs?=
 =?us-ascii?Q?8auDtXKENogB7lrO3l4KYrSBSYYCnYXibHSfrZKHqSBZbLcbp6xX+vYO97w1?=
 =?us-ascii?Q?mHblap9m+TzbgFB2v/c31CyCcb1JGhki7am80UIY77OJ3u0Iwqk1feIc2V58?=
 =?us-ascii?Q?LvQuxjUIO689ArHdhrAoR8G2UPgeyISc/HVTgPobWGdyVyoAHPAJGs3K98lo?=
 =?us-ascii?Q?MvAV4RvpdGWmsOvNa5ZJRw=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(40470700004)(47076005)(26005)(336012)(426003)(70206006)(70586007)(83380400001)(41300700001)(2906002)(8676002)(4326008)(5660300002)(966005)(6862004)(8936002)(2616005)(478600001)(40460700003)(16526019)(186003)(36860700001)(6636002)(37006003)(54906003)(3480700007)(36756003)(356005)(81166007)(7696005)(40480700001)(316002)(82310400005)(82740400003)(86362001)(36900700001)(505234007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:52:46.2258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 650ddb39-4f56-4574-4098-08da5e9605ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4205
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 05 Jul 2022 at 16:55, Ido Schimmel <idosch@nvidia.com> wrote:
> On Mon, Jul 04, 2022 at 06:47:29PM +0300, Vlad Buslov wrote:
>> Hi Ido,
>> 
>> While implementing QinQ offload support in mlx5 I encountered a memory
>> leak[0] in the bridge implementation which seems to be related to the new
>> BR_VLFLAG_ADDED_BY_SWITCHDEV flag that you have recently added.
>
> FTR, added here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=279737939a8194f02fa352ab4476a1b241f44ef4
>
>> 
>> To reproduce the issue netdevice must support bridge VLAN offload, so I
>> can't provide a simple script that uses veth or anything like that.
>> Instead, I'll describe the issue step-by-step:
>> 
>> 1. Create a bridge, add offload-capable netdevs to it and assign some
>> VLAN to them. __vlan_vid_add() function will set the
>> BR_VLFLAG_ADDED_BY_SWITCHDEV flag since br_switchdev_port_vlan_add()
>> should return 0 if dev can offload VLANs and will also skip call to
>> vlan_vid_add() in such case:
>> 
>>         /* Try switchdev op first. In case it is not supported, fallback to
>>          * 8021q add.
>>          */
>>         err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
>>         if (err == -EOPNOTSUPP)
>>                 return vlan_vid_add(dev, br->vlan_proto, v->vid);
>>         v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
>> 
>> 2. Enable filtering and set VLAN protocol to 802.1ad. That will trigger
>> the following code in __br_vlan_set_proto() that re-creates existing
>> VLANs with vlan_vid_add() function call whether they have the
>> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set or not:
>> 
>>          /* Add VLANs for the new proto to the device filter. */
>>          list_for_each_entry(p, &br->port_list, list) {
>>                  vg = nbp_vlan_group(p);
>>                  list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>>                          err = vlan_vid_add(p->dev, proto, vlan->vid);
>>                          if (err)
>>                                  goto err_filt;
>>                  }
>>          }
>> 
>> 3. Now delete the bridge. That will delete all existing VLANs via
>> __vlan_vid_del() function, which skips calling vlan_vid_del() (that is
>> necessary to clean up after vlan_vid_add()) if VLAN has
>> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set:
>> 
>>          /* Try switchdev op first. In case it is not supported, fallback to
>>           * 8021q del.
>>           */
>>          err = br_switchdev_port_vlan_del(dev, v->vid);
>>          if (!(v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV))
>>                  vlan_vid_del(dev, br->vlan_proto, v->vid);
>
> Looking at the code before the change, I'm pretty sure you will be able
> to reproduce the leak prior to above mentioned commit:
>
> ```
> -	err = br_switchdev_port_vlan_del(dev, vid);
> -	if (err == -EOPNOTSUPP) {
> -		vlan_vid_del(dev, br->vlan_proto, vid);
> -		return 0;
> -	}
> -	return err;
> ```
>
>> 
>> 
>> The issue doesn't reproduce for me anymore if I just clear the
>> BR_VLFLAG_ADDED_BY_SWITCHDEV flag when re-creating VLANs on step 2.
>> However, I'm not sure whether it is the right approach in this case.
>> WDYT?
>
> As a switchdev driver you already know about the new VLAN protocol via
> 'SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL' so do we really need the VLANs
> to be programmed again? The VLAN protocol is not communicated in
> 'SWITCHDEV_OBJ_ID_PORT_VLAN' anyway.

In my WIP implementation of 802.1ad offload I just re-create all
existing VLANs in hardware with new protocol upon receiving
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification.

>
> Can you try the below (compile tested only)?

With the patch applied memleak no longer reproduces.

>
> ```
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 6e53dc991409..9ffd40b8270c 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
>  	list_for_each_entry(p, &br->port_list, list) {
>  		vg = nbp_vlan_group(p);
>  		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> +				continue;
>  			err = vlan_vid_add(p->dev, proto, vlan->vid);
>  			if (err)
>  				goto err_filt;
> @@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
>  	/* Delete VLANs for the old proto from the device filter. */
>  	list_for_each_entry(p, &br->port_list, list) {
>  		vg = nbp_vlan_group(p);
> -		list_for_each_entry(vlan, &vg->vlan_list, vlist)
> +		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> +				continue;
>  			vlan_vid_del(p->dev, oldproto, vlan->vid);
> +		}
>  	}
>  
>  	return 0;
> @@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
>  	attr.u.vlan_protocol = ntohs(oldproto);
>  	switchdev_port_attr_set(br->dev, &attr, NULL);
>  
> -	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
> +	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
> +		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> +			continue;
>  		vlan_vid_del(p->dev, proto, vlan->vid);
> +	}
>  
>  	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
>  		vg = nbp_vlan_group(p);
> -		list_for_each_entry(vlan, &vg->vlan_list, vlist)
> +		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> +				continue;
>  			vlan_vid_del(p->dev, proto, vlan->vid);
> +		}
>  	}
>  
>  	return err;
> ```
>
>> 
>> [0]:
>> 
>> unreferenced object 0xffff8881f6771200 (size 256):
>>   comm "ip", pid 446855, jiffies 4298238841 (age 55.240s)
>>   hex dump (first 32 bytes):
>>     00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<00000000012819ac>] vlan_vid_add+0x437/0x750
>>     [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
>>     [<000000000632b56f>] br_changelink+0x3d6/0x13f0
>>     [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
>>     [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
>>     [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
>>     [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
>>     [<0000000010588814>] netlink_unicast+0x438/0x710
>>     [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
>>     [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
>>     [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
>>     [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
>>     [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
>>     [<000000004538b104>] do_syscall_64+0x3d/0x90
>>     [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> 
>> 
>> Regards,
>> Vlad

