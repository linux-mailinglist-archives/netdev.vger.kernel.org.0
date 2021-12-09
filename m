Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B046E386
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhLIH5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 02:57:34 -0500
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:28897
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232321AbhLIH5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 02:57:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4dWEse/gxkFtkuAnP7r/tnKSCEoHTXv10irJ7IKKM7muFUyK3yfIUMOT9vgkzbesJpHfZ6sw9MZ1rPQ/SpCP5VN5FMY/dkKyFZn2x7OTr1x3oaLaYp4RdLnAmjoOLT4MaSSNmrrP2TzoPRdh4uA3Tr3hPFxqJRcSq41UcYeRDdya6X6e/HKvE47dUT9RSlmZV2kIYqAJmOZ7p9n50JlLB4WJl5iBV/0BSCIs/xzVmAmi6XS4e9hBwxr0W55egQ/ksdQRpAoetn6Btjx/76hS9WpkqPws45nIlXD+8LekxF8OuLgu/teRu0BcQmmdcyQj270ZmNSEDd5yd61lgPlRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv5Y3oRvOJVzpfwfVBjP70Rmm4im/k8X16s34MOZHxc=;
 b=Ps9Y+nvrDx63M/TpWQ0RamgcKPBA3tmbMwx0OW5ldjwz3BRJ1Sz7mf08RQoTL4aP0bnjqdXkvtQ/vVpbsEF08CgdZospG3z30QeRBLkzePDEPSAHIPJVj48qzCs0PFrLUC9kmgFOtS0MmxVGg170Z65bvbj0KsCz5NbKdhpg02SOoUdG7n8qFceJSMnt6IZ72opn3J06Vv9ngeq//ftnoxFhkSOX+DnW+sHnAYPrDSAaY+cfoRV++fskzzBvO/kclhs8ybx7k4lsv8/SGRL1a9xCGK3iVP4sMMYf5IRVZOp9ypzbfhrDPU8BupntG76+1yrEeHvtxQrIYN9KoKbxJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yv5Y3oRvOJVzpfwfVBjP70Rmm4im/k8X16s34MOZHxc=;
 b=LMxzR1+wOmDa3POW+aMyMwEqYOsdKZ+NxTJtrQ1E2ugB0yjeahd2yj+QVhyWQjDg0cDOew//UVIJsybgQprTx9Wpllwlu+EgdWXLFDFsGYtrj9cEcpXmd2crO5GZ7Ou9hUp57Eo6+lUI4BpaRaUbRQERNrjPpxbElyYxhJzGys3churNnAVqOrvgj+61nboRo69WT7Z/TzM/SWV4GBngXR3wJrVXi9cxFnOhNFpz0AY6Z0dHnU0bZVJ4Bih7bmRN2HT0wbPpABVACUZzURnc18boYPSyX+XvKxFuPzlTXS1tBLbckvRFmgQDi6BtaVurQpgxMXBRrihkdjUJ3MZ1PA==
Received: from BN6PR13CA0059.namprd13.prod.outlook.com (2603:10b6:404:11::21)
 by CY4PR12MB1366.namprd12.prod.outlook.com (2603:10b6:903:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 07:53:59 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::e0) by BN6PR13CA0059.outlook.office365.com
 (2603:10b6:404:11::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7 via Frontend
 Transport; Thu, 9 Dec 2021 07:53:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 07:53:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:53:41 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 8 Dec 2021 23:53:37 -0800
Date:   Thu, 9 Dec 2021 09:53:27 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net 0/3] net/sched: Fix ct zone matching for invalid
 conntrack state
In-Reply-To: <20211208173508.4a9a7f3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <84ba22d5-2bf5-cae2-f46d-8f431879564d@nvidia.com>
References: <20211208170240.13458-1-paulb@nvidia.com> <20211208173508.4a9a7f3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631e6f4d-c96f-43a7-7424-08d9bae90f06
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB13666D06E5E6FB3E236A59B6C2709@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +8c90WdBrJJK4VfxTtXEyEyO3f0vAqDEX3Xjlv6lj0FEWttkAOC+ptJNqQjAmBNJLUHg3LKKMeMr0M8Qmc2++GDcAth+9cFzl7wdNKDlSt5I9FfEJJV1nObgQRBJwZpzdcEp1bM66mc3FVHCIlMaFITCyrSWCB/YFL7GvisdCQ7i+H6U77uR+WEVKBiKvh/ugzyzYpzMzz09IEQOvQ8j8NM7sTY6DdAfGnUjIZuybpVQCJIEsocqmqG1Ty/bpnIUEJKCxJTeVrAeR0ZSwQWBAzUhngvZAh0G0esPJK0K9WAJUArg4D+LU/E/4+x7PGBn/Y9qf4XzxXYy9cIbWhA3bnWfeaR5fm3NiQAzTJ0Bud7ac81FHEbvxEqIKbBOSHG2f7OvHilr/Qg+suE11vsHjD8cFdemJoab7auAUDLaapQceCL2j1c9NXhj2XVSw38K3KNkHJL2SWcrMhyF90wZb2hoEN2vrEtxAnkSMrsZ+f544QP9ODTCsijonBrNFVsf/V0isUq2uH3ounRJdPF36Tp+qA6izSE7xvW5hSW6/pjyk40Zvos94BcvHCJaew+ARYnIbfFtsMdDcl9pgLqw2lEObmm9Yf7P7EoH8BWB8Wwdtlj4c/uSmn8Vm+gyFSfISMt6I/LIKnGBspGmVc7VnXQssefPJXVT8Tpwh0rgVsnQyI3AHG2JyyZM+3fJPxSzpwUYmDaE48iJj9l9ibxWBEeLVl1rpADMZT11GqKCsmlChEfHtcJ3DDULjPnriR3bH1ygr5BDijQ99Ing52/mL19GXprQthO8d9ebnjUnuVY=
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(508600001)(316002)(426003)(26005)(36860700001)(8676002)(8936002)(16526019)(2616005)(34070700002)(86362001)(54906003)(186003)(107886003)(2906002)(336012)(4326008)(70586007)(82310400004)(70206006)(31686004)(7636003)(40460700001)(356005)(6666004)(47076005)(31696002)(36756003)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:53:58.6863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 631e6f4d-c96f-43a7-7424-08d9bae90f06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 9 Dec 2021, Jakub Kicinski wrote:

> On Wed, 8 Dec 2021 19:02:37 +0200 Paul Blakey wrote:
> > Currently, when a packet is marked as invalid conntrack_in in act_ct,
> > post_ct will be set, and connection info (nf_conn) will be removed
> > from the skb. Later openvswitch and flower matching will parse this
> > as ct_state=+trk+inv. But because the connection info is missing,
> > there is also no zone info to match against even though the packet
> > is tracked.
> > 
> > This series fixes that, by passing the last executed zone by act_ct.
> > The zone info is passed along from act_ct to the ct flow dissector
> > (used by flower to extract zone info) and to ovs, the same way as post_ct
> > is passed, via qdisc layer skb cb to dissector, and via skb extension
> > to OVS.
> > 
> > Since there was no more for BPF skb cb to extend the qdisc skb cb,
> > tc info on the qdisc skb cb is moved to a tc specific cb that extend it
> > instead of within it (same as BPF).
> 
> The last paragraph is missing words.
> 
> Please repost and cast a wider net for reviewers, you must CC blamed
> authors.
> 

sure, posted v2. Thanks
