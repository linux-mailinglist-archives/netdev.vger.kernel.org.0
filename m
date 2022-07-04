Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD03565ACF
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 18:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiGDQQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 12:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiGDQQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 12:16:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A04210C2
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOktDS3b7wzNl2GfOR04Y4on7+eT8h46lxSoLuyQCkV4aoG+xM376HW8IFtJrrraopmerOo+O2/IZZBnD4S2uRVGHNw7rkmDORvGtCCrkkezUOanjBeAnK31WJvsBkTgaEtGwRm+egj6UY4lLUV6OUsiDKN/bjTDAkVqDovo83udkPvVIH1M693/I3ejafZMmu8628MkpsJLRSYX9Pypc+KXHSqllWAeI32n0GgOIGO2Nes+H+Gcj9EQi96pxp/yKiQhVgMNlthBRYjxmHm9tOQ6TPtPMmBgyG8VHGEPV2va1ZH02MVFLaXSteBrR+c1idIBSKsZk7MrEgXA/rYktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OViCdK6hUTFXf+8HHypP/j995eFY9LLmLsomeNlpaVw=;
 b=E2nu80d4TWtUftuLYT6TVgN/5k+mh7CiGLjPcTG50ySHf1KE9SqhSSvIucdSsIxj2WJ3eBwM4PvNDMQU5sA4fzxY8m4ci/DrlDqmDDZr+U9hbj7wvaOK2z00kLJ66c3zC4ZRxu1vRqhB2zO0oEgEoWvrbyvEkFCyUQqHu6FzHySdf2HcmkxRqPmxVpPPoahwexO15w6FM+o4O8eo5Xu2qDyB6kERAv4oTdQkl7Gq7wT46qopR60mUCpuYnem8MOSxlH3x0H/wA/p6i6uznNwNziwSykHeL/NyCWt4RtqtfXqWlQkFhXaupS/AzFx394C0woJrvAgtohYHBPYSPiCUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OViCdK6hUTFXf+8HHypP/j995eFY9LLmLsomeNlpaVw=;
 b=qagRse0Xn6BSwbCYDfkHTIWKhMEfxYcP7M9K7FeSgE3zJnzUmvBksSjNa1CA90GJ6bhpqhyQPA4/KZR75rwnN4zLFGb7oVhC8H7dHXcWY7+R03YVcGIwiUN9YkV8O9baMhvvnD1hfhPa6Qi0A0R5KdQsq5Dr2PVaAbuvOm9IifcBX9WRPktjQpKLj47L5u15Ptur6dUmy7Z2gVcoDLGtBzmKeMlVyJvUmIZZFnBjtga83zS8Pa9Fb3ReOHkrZh7TDunfu8o5T+XeTuxp7wQO5pVunNCndbWd/uI2kk68zWm+80kujdh4NSO1tFRBotprb/01nhtRSLwN8pZBHg8KPQ==
Received: from MWHPR01CA0036.prod.exchangelabs.com (2603:10b6:300:101::22) by
 DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Mon, 4 Jul 2022 16:16:11 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::88) by MWHPR01CA0036.outlook.office365.com
 (2603:10b6:300:101::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Mon, 4 Jul 2022 16:16:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Mon, 4 Jul 2022 16:16:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 4 Jul
 2022 16:16:02 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 4 Jul 2022
 09:15:59 -0700
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, <razor@blackwall.org>
Subject: Bridge VLAN memory leak
Date:   Mon, 4 Jul 2022 18:47:29 +0300
Message-ID: <87a69oc0qs.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da57771-8505-4ccf-ccfe-08da5dd882b9
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aMFlttyjjUnySs6c9AfzpIAClxujI/ZGnRNIE91a4LH//E+Out3K3GwZs+8XZv26ahDuPigJvEOo/hclTm5AGESOgfPML2uZLfpJQLZobiFZVKMx6A0A3gc25RNSHQ9s4AS5Tppd9Sqx3KTS2NA4+zEmiwJsh5acM0MOq4L/nBrP/1v1IcL+YKu7wrZlDC6g4obCdlGis3BU24GzIG7nyP6ZDwSOXEBmXq5we2kH1mzOHy3bfkCBt/QAiGqJsR0aTstUQFwOyBthOYklblaa397cBUFv4Ci2CZ/z0ri55GiCQHUuyc5x94avXXAAycyHPb0ffKV8u1NWkWDZJp38b+yyHyD9I8RQij7QrOVdMNB44eSuM+KEo+/rhnzGeNhyPqh+F1Dee86uxFe0GfHmUwgvS0AuJpIQ7qMKaQQFz06Rhy8Ic6gaenlobZln2VQRa+k5nRfwPXCffN4lNqQRHPx/nlASisn2LIynEPOXYZY0WxsJ2gSrOciabK5DizzMIGneg+0fT/Xf41qDf78XzZ6M9HyVlmb8uCr+TLUqY1WZ/cI+VAqjOdJsWkpQhwt6s5VfFK6KnA+qLbSKd3Awg4NKEj3qc5jNKUtJBMHM8SE3BcyvqVINyIKsZOIcNA6zSav9xUfF5rNWiW6GIqRR1WEAWyqv5O9BwoLkVBJE0FMR2p+7W4phCqbyFEFyu2THStICTTw0vB660k+wx2lsIUAASl6MpujjQBKlSjftY7TQvfMFAqqd62pJzNThhqpgQVh0nwBA68a2KR8b3V0UrewD5hQJVcxyXRsoVUDGxzzRJXCVjj3UtkzzaaIVaRk9lxQlCdKS00Scy3TnBbU9vK0EF0e9+VBdJnVuIxB3RcNWq1439hHcabESgdmAUhd7
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(40470700004)(478600001)(16526019)(82310400005)(47076005)(426003)(336012)(40460700003)(86362001)(36756003)(2616005)(6666004)(186003)(3480700007)(36860700001)(40480700001)(41300700001)(8936002)(2906002)(6636002)(37006003)(54906003)(81166007)(70586007)(316002)(83380400001)(26005)(356005)(82740400003)(4326008)(8676002)(5660300002)(6862004)(7696005)(70206006)(36900700001)(505234007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 16:16:11.2786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da57771-8505-4ccf-ccfe-08da5dd882b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

While implementing QinQ offload support in mlx5 I encountered a memory
leak[0] in the bridge implementation which seems to be related to the new
BR_VLFLAG_ADDED_BY_SWITCHDEV flag that you have recently added.

To reproduce the issue netdevice must support bridge VLAN offload, so I
can't provide a simple script that uses veth or anything like that.
Instead, I'll describe the issue step-by-step:

1. Create a bridge, add offload-capable netdevs to it and assign some
VLAN to them. __vlan_vid_add() function will set the
BR_VLFLAG_ADDED_BY_SWITCHDEV flag since br_switchdev_port_vlan_add()
should return 0 if dev can offload VLANs and will also skip call to
vlan_vid_add() in such case:

        /* Try switchdev op first. In case it is not supported, fallback to
         * 8021q add.
         */
        err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
        if (err == -EOPNOTSUPP)
                return vlan_vid_add(dev, br->vlan_proto, v->vid);
        v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;

2. Enable filtering and set VLAN protocol to 802.1ad. That will trigger
the following code in __br_vlan_set_proto() that re-creates existing
VLANs with vlan_vid_add() function call whether they have the
BR_VLFLAG_ADDED_BY_SWITCHDEV flag set or not:

         /* Add VLANs for the new proto to the device filter. */
         list_for_each_entry(p, &br->port_list, list) {
                 vg = nbp_vlan_group(p);
                 list_for_each_entry(vlan, &vg->vlan_list, vlist) {
                         err = vlan_vid_add(p->dev, proto, vlan->vid);
                         if (err)
                                 goto err_filt;
                 }
         }

3. Now delete the bridge. That will delete all existing VLANs via
__vlan_vid_del() function, which skips calling vlan_vid_del() (that is
necessary to clean up after vlan_vid_add()) if VLAN has
BR_VLFLAG_ADDED_BY_SWITCHDEV flag set:

         /* Try switchdev op first. In case it is not supported, fallback to
          * 8021q del.
          */
         err = br_switchdev_port_vlan_del(dev, v->vid);
         if (!(v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV))
                 vlan_vid_del(dev, br->vlan_proto, v->vid);


The issue doesn't reproduce for me anymore if I just clear the
BR_VLFLAG_ADDED_BY_SWITCHDEV flag when re-creating VLANs on step 2.
However, I'm not sure whether it is the right approach in this case.
WDYT?

[0]:

unreferenced object 0xffff8881f6771200 (size 256):
  comm "ip", pid 446855, jiffies 4298238841 (age 55.240s)
  hex dump (first 32 bytes):
    00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000012819ac>] vlan_vid_add+0x437/0x750
    [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
    [<000000000632b56f>] br_changelink+0x3d6/0x13f0
    [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
    [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
    [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
    [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
    [<0000000010588814>] netlink_unicast+0x438/0x710
    [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
    [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
    [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
    [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
    [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
    [<000000004538b104>] do_syscall_64+0x3d/0x90
    [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0


Regards,
Vlad
