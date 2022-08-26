Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863E35A2E18
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiHZSQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiHZSQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:16:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE56CCCD58
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 11:16:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUdFbVKHnFhKmptF2xmvHfHgnfCy4zIK/xrauZQDOFubc+j7bh7ZlcyK68g/ID+ycq4h3Z8J84l3AN1+OQYR6PilRB3eAVxDz4RmHV5IGsBD6W30sWPTxFjWPBYdX9nXSghyyn8WoB7yFF/NdZWrGVVEMl2UIkvdSnQ2/UnzcA1e5z8IJk0BfsJaxofmvf/pqE+GHKIoLqhLjHL9g6A8rYicpiY/NlRYrdXxZIiZjmOrKI+VMAkGZbsmDepAw6AUJMYjuNZwbqOKfjqrxgDk/dST8HVNcCuVe0Ew0Y6ybYUiumTVL8ngunCWOqqW7CQ0mEVH+fh8l+Lx7jODQaZBww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58U1IsfuoYHxdO8ASJjiM4mL1NdqK55whLMSWLMGqAo=;
 b=ScL/NBeHOOMDkMQ7AKWGEbbhQfOL6iv67w04iPzdJp4wUgOl6T0eOgSrMnkKFRBM61otNYQvqk7YyQ+3hrPiGx44kASjD71q502DGSUKX+LRN73lpM0BkDLWG/hA+kIY4c0itrdcNcGmlxAHC2z/1uj1ul6BNSY+xpQBW5kwmYWRHxiO13dBlajwELjdzI+wicnu7fSZ980cYUmacoTX2sNZz1H+cZny3EnAMz5q43GonDK8nevFYpZ8JLMNZCo/y5P7LzfOq0tJbT7NNc9Lq1uXHP7jHvyDj2TAsOuL9CvpQKqlq1b3uVRa5WjzJx3/+dCRzgzUzauykTsn3bdCCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58U1IsfuoYHxdO8ASJjiM4mL1NdqK55whLMSWLMGqAo=;
 b=Q0RnBgZLxGG+IsaJ5CXXfmVnEe4zkXRSYf8CMdTmqY4xKRjoxMy+mbvvGxJR8nJHcA1v0eThZzOTeoZ92D3IQVtMFiI8qAK5LK2kaD5WpG8YRJ0XakCXmi+3PEMNhTEQZNuwWpk2eAOXLs+Qg/c3EhZ/uA7uropBUhjwNHuX2iLH/IBcNnFqWX+xPU8LA7N/T9EapZOcut6q81xmrUrXnHf5tHNOUAK4+I86vZ6huXb1cL6x6j3vEEJ3p1YoTY6noo2d85mey+ujVCYHtEhZGB2Om9RUxTKs7VymoFDOPxZgnwNMmJYwhnTKbHR0yoiLsoDmJDA05l/9NXHzXEy9sw==
Received: from DM6PR10CA0005.namprd10.prod.outlook.com (2603:10b6:5:60::18) by
 BN6PR12MB1508.namprd12.prod.outlook.com (2603:10b6:405:f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Fri, 26 Aug 2022 18:16:08 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::17) by DM6PR10CA0005.outlook.office365.com
 (2603:10b6:5:60::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Fri, 26 Aug 2022 18:16:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 18:16:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 18:16:07 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 11:16:04 -0700
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <Daniel.Machon@microchip.com>,
        <netdev@vger.kernel.org>, <vinicius.gomes@intel.com>,
        <vladimir.oltean@nxp.com>, <thomas.petazzoni@bootlin.com>,
        <Allan.Nielsen@microchip.com>, <maxime.chevallier@bootlin.com>,
        <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Fri, 26 Aug 2022 20:11:52 +0200
In-Reply-To: <20220824175453.0bc82031@kernel.org>
Message-ID: <87leraj2fx.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89eb8ad2-5c9e-4bea-d950-08da878f0c5c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1508:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 27llwK7AjenYU/vqDc+JvJcVBsrjy1xDrB8gs4PN5aTQzqKsmIo2wO2iapJ4Z5H4cB8RqjMb40hEKhRkERvYbIJssphwTgy/PyvbE3jWW79yWNKr/+mSXRwaP3jShmbmawyqqsw5SQYpJQ2bC94HSY4qotbAppnNWjrilsVpeicivFwkjMvQ2a7WOgSEGcBIBPz4lh+kCWlL9PZQfEyZcdT2sK4UmZHnILFz/QmS3dIYB43ldSmlKdkGgSQftct2/AYTzKBAiIXBATJv6hCjq+1ffu7W2+iveBJR2jtQAAHbjLtFS1vxq0FaJAotWAC52qU6q5XOPXENZn37QucJl6b5uz0yRshU2fJtQWEDLCF9YdTf8IX1yDj8bVBOJMkjHuUMd/qJU68mq0cA6FeDzdkrwlKzcMar/CugWaQ2grjqr1RIuxLZcw+MMjniL2jwMUXaqgcCWikWhdRLZO5bpIA85k87WIT4mnnV4w6cj6pJmSILQGnQ55EiZCHvlk2p0Ajecl76HoOw9TPXSNwrruEfY+9oQ8u6fHhKPY7Vp7P9Hsw7chZbzlwhe2309iiS3midxtaNmOilZ30+NBEr/H1SjvshWwY2D3pJJimroCVUnHZd5mDRSfzAap+iTVOyw7g68Q5WhNFtRyqCy+aGDoueLsVP3K3v5UAQBPaEo3TIBhv1F0tzkOeceVumLbNS/HKGdDw+riAlpAa/NSsQ5EvAJUSRdAzP88h9/BpOA+yT9DbWPbp/cXF0u5SE5xFww9u0VkyQp1pb/GKx2VqoptORbHbeRMxSY1k2NKB4N0VsedVA98dth7vH5JbWJRkm
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(40470700004)(316002)(82310400005)(36756003)(82740400003)(81166007)(6916009)(54906003)(36860700001)(356005)(40480700001)(47076005)(478600001)(41300700001)(8676002)(4744005)(107886003)(426003)(2906002)(6666004)(4326008)(70586007)(70206006)(2616005)(16526019)(336012)(5660300002)(8936002)(26005)(40460700003)(86362001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 18:16:08.2581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89eb8ad2-5c9e-4bea-d950-08da878f0c5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1508
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> For an uneducated maintainer like myself, how do embedded people look
> at DCB? Only place I've seen it used is in RDMA clusers.

(Not an embedded person, but FWIW our use case for supporting all these
prioritizations and buffer assignments in mlxsw is exactly RDMA / RoCE.)
