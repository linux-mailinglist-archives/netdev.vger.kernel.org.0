Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6A74BDD5D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiBURD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:03:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiBURD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:03:27 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11hn2230.outbound.protection.outlook.com [52.100.173.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331B425EAE;
        Mon, 21 Feb 2022 09:03:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJHYHG9gnRQJCTwuFWQGukzy0WybD1KwF8VIAqmLQoNGevQnx5mJqAxrahL3OkA9vFomgCQX/ziMQvNSBiwLuzcLOzQbncYJ1y3yQH9VIbbFY2gea26WWsidYtXBgnzPlLv6nB8BZZSORLH4sv8fR6CFpc/OSMr/QycpS/0VQ/NZSd8AHihQeQhS7pY1Q5BBTd/qsscXFipu01CRLLudzA/CWv3gyOFD7p6QgwCJX/Sf90fxa/fIfiM31v/0ezNmMHv2Qbsun4tCNN1Q9lT8Ih2z9ITdTvEH3MjKtDMkTg1Sb1yQVxnGigJeRXWLf6Z1hU/xK5ILJTwF6qsIbu8Q3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6R90xFzwP3GyIZDm4oX8bAQ3EPprjFWsp2cUrjCVT0k=;
 b=Okmg0zZxqt65saq5SVfQqSzXG6MGJV/NPfaz6DBmm6uUwWK4OC81AoNiPm4Gw3RrgTX29wlnh/Vn4Y3Eojsq1FCDVFa48Rsu1TMUVFKbR5HRfERNbHV1a2TE94H/5FaQMb7UhxEuAKfbLRdlha/0y44TWUcrF8BdtwGbjPvUBVz7oHbzPblBA8NCWYw8xXvtct0xg/sm2cFLzxIlk/jOP4mT3rDjw41jVUjEiHfCCamcEn3BgQrztIH82RV6M83N4yyBoyWOHKP5Sw7MY1a7QeO3LcXXXT6Fp20v9SXuYWgNBKi0UMKUd2Lv6ufcHqBCf+jkVCT4gnOl5M3RctWOyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6R90xFzwP3GyIZDm4oX8bAQ3EPprjFWsp2cUrjCVT0k=;
 b=HyLOAjV24jdiIlUDX5iTHO4E5meUfDdnnc7ZEXa4JgWP/QBGp7YsFuKulNzmB37D5SPNCs6D3Jd3e0jBH6PDOFuX1lsBj80XaVcRjxm9oZ4Xkhh4VPywDymEhaG0s6gbaAGc+uD78QGS4/3piCrbgHexkoRBWoOFdY0lTJ+romO9wlG9GYzrX09/LQFN8YpXEb+SE9p3Y0eKIbIAGEVH5NC45ES18YSZwJxDl40WS+iEh9xvB3gGr6DPKK8xzhEKIq9UymNif0Xk2RTsqt+P97knqrFpIn9oLyojN4U43XQMXbaAX99rA1FD+zdveitD3kTHvkGnDGHt1naMR8VeYg==
Received: from MWHPR14CA0048.namprd14.prod.outlook.com (2603:10b6:300:12b::34)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Mon, 21 Feb
 2022 17:03:02 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::81) by MWHPR14CA0048.outlook.office365.com
 (2603:10b6:300:12b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Mon, 21 Feb 2022 17:03:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 17:03:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 21 Feb
 2022 17:03:01 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 21 Feb 2022 09:02:57 -0800
Date:   Mon, 21 Feb 2022 19:02:45 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, <coreteam@netfilter.org>
Subject: Re: [PATCH net v2 1/1] net/sched: act_ct: Fix flow table lookup
 failure with no originating ifindex
In-Reply-To: <YhKCtlpgJlliT9Bc@salvia>
Message-ID: <c615b6c2-6a84-7348-2bd8-447e28cbb8b@nvidia.com>
References: <20220220093226.15042-1-paulb@nvidia.com> <YhKCtlpgJlliT9Bc@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc06433-122a-4937-a2f1-08d9f55c0555
X-MS-TrafficTypeDiagnostic: LV2PR12MB5846:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB584670D24C5692D55B722438C23A9@LV2PR12MB5846.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ptonqkrxjDr6sRdrneJmbVlNDytWW3bmSua757QHgYLSfoE7UsmK2qmweSVa?=
 =?us-ascii?Q?MLTO3E/d565qgotkg/ELphUAoo4VQXtm0hXgf/G4pNgLWljUvDUFPvGx5+Ez?=
 =?us-ascii?Q?1zaVtM3L7tkdqoBYXZZzTcPAo4YMu3PXPDEA6WuSroPncIUOv5OewwCl/uMm?=
 =?us-ascii?Q?JzcS6bPT7P9VuJCw7XWeN4PTj3Kq0z3J27PIuypI1IzlEKVC4CHAuKpuppxL?=
 =?us-ascii?Q?GtpDrmASgB90CQFwd6hik6eA5106CPA0Q9Q+2CRcAo1NaFlOhObhBUBfb1G4?=
 =?us-ascii?Q?KnG5NSM9cA1Z14ArEclR4dD5nA60U1qpROQf9UEJANztR4jbM2GCFPtIGLkq?=
 =?us-ascii?Q?FA4FSJsqvkym4fbaUmPn4S7SuiE757ZfGoAOVP5PR6/eMvEmqqEw9tosWC7Q?=
 =?us-ascii?Q?jT5bVXr6yPvDYBXcQhX9LW2yBSNTzo4jIWxCZcZYVJqf6KykRj1hugNMFpsm?=
 =?us-ascii?Q?1xbhXYF+03pNLTpOgJlSTypZoYrDsiLE+rhTGIyFU6P99BvGkz/H9iJoWoXm?=
 =?us-ascii?Q?8OX3f9frvwX9hQLU96eZgjiQZRYooWaFcpc16/FUBY0i+hnHDlmZ4npwF6AT?=
 =?us-ascii?Q?TqjnxaatBljywLWZZPanaHWkUg9dWm2bdQLzqNjmkk4M89PnaMhkHcvtHSG0?=
 =?us-ascii?Q?EF8U0NxkJOcM0F4uUkL5TwGK0u8Hq+seD6vEe/POnp5oKLSsbbPMbMKeV4B5?=
 =?us-ascii?Q?fqsLamIEkc6wmXb7pqiEFWTmnUJ4owWoxsnwZIxZt7ht2hHLd0gm4Nhr3qdt?=
 =?us-ascii?Q?OVkv8WPqnytgGNkgPIa/yicdg0G3glwoFKbXhFodTTleQm7k1i4Wnjb/mH+s?=
 =?us-ascii?Q?gyFhMQkAnu7wU9cTjTcpk67gqs05I6KnuTUktLD44P8cBWyeBO3wuU3sMk3u?=
 =?us-ascii?Q?PRf+xgwjS2P0Fg3NBDCKWr+f9ZOswMMf3XxEcFVWyNoHKjYuv8bgTAT2JHcQ?=
 =?us-ascii?Q?UVdIe4I96H+vbgDoH4BpynnQf//drbT9N4tXxWLG6hEcM/iINcXIHeAENw83?=
 =?us-ascii?Q?pe9TuKKMsi1LmcpFAv8uS0YBTAhjFxocsvdsAvJz023HTF8=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:5;SRV:;IPV:CAL;SFV:SPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:OSPM;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(2906002)(40460700003)(356005)(86362001)(82310400004)(81166007)(6916009)(54906003)(70206006)(16526019)(36756003)(186003)(6666004)(508600001)(70586007)(4326008)(5660300002)(2616005)(336012)(316002)(8676002)(8936002)(7416002)(47076005)(426003)(26005)(83380400001)(58440200007)(36900700001);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:03:02.3836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc06433-122a-4937-a2f1-08d9f55c0555
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Sun, 20 Feb 2022, Pablo Neira Ayuso wrote:

> Hi Paul,
> 
> On Sun, Feb 20, 2022 at 11:32:26AM +0200, Paul Blakey wrote:
> > After cited commit optimizted hw insertion, flow table entries are
> > populated with ifindex information which was intended to only be used
> > for HW offload. This tuple ifindex is hashed in the flow table key, so
> > it must be filled for lookup to be successful. But tuple ifindex is only
> > relevant for the netfilter flowtables (nft), so it's not filled in
> > act_ct flow table lookup, resulting in lookup failure, and no SW
> > offload and no offload teardown for TCP connection FIN/RST packets.
> > 
> > To fix this, remove ifindex from hash, and allow lookup without
> > the ifindex. Act ct will lookup without the ifindex filled.
> 
> I think it is good to add FLOW_OFFLOAD_XMIT_TC (instead of relying on
> FLOW_OFFLOAD_XMIT_UNSPEC), this allows for more tc specific fields in
> the future.
> 
> See attached patch.
> 
> Thanks.
> 

This patch will fix it, but ifindex which we fill is for the input device 
and not related to XMIT, exactly what tuple->iifidx means. We don't have 
XMIT, so I think it was ok to use  UNSPEC for now. If I use 
tuple->tc.iifidx as you suggest, tuple->iifidx  will remain unused.

I think once we have more fields that are really specific to TC, we 
can do what you sugguest, right now we can share the ifindex.

