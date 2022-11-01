Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AFE614C2A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKAODQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiKAODP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:03:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5EC1A396;
        Tue,  1 Nov 2022 07:03:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it1TSaPaTqb3K35adnWncrD2XFq93UzdP8gPjJ/qX11bimzqmlnLFsuTt6gXzI6wWLl65XgXW/X8/K9SW2qQo3RnJ83AnmFwKd/aQIJ8umbnZpQuAmKqcZVGleYlhELZMyA1+r5EWY48HOL07Fd2WClFWuyO1qBOCbR0/PCDFxoJ4orP8jtLOl0gek+degzUF8KRpa+Fhr8jAHYJuOAwsx00wnDgRv4P9NOmdUiDEboXh9R3MzTJo6Ncy6XRnTrcBMtb+TReqL07UaPWmr+J25f2NNZUZTvXi+gAAdZI3Oqsx3BS32ShTB+8OZNmVRf1L//LSlpoWjf/jPtZ99KRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5x8OT49HlUb+KWJiYD7gswyOpc2iZMcG+vlpcPm4eo=;
 b=PSqtP0rO2sQayjqPv+0qfgbjLg+A/r80eJcaoT4B/gxrLKM252Nr88lLsxiZIa0yWV/XAQW0CWrUmEwFdlQJo7eqzErrTZ08xzhOCa83oG8TYSR+oojh+gTtTvrXEsOuRZq5BAtltQh6OFz4lHnEpKgB5bPn9pgXsvZdbJFnxIK86Qa28wcvfX0nStAxekD+kDa/QuN2lC+uwMUNO+TiQO2EwqVwWMl2T6ICIrIMKzld1kurFcInBdWeWWpC3s2oEG64mPd2tcl6kcdilGzo/N0VwIesOrhP8ZmOI+EJvQHO9omrYbpUdAzYsn/RVyG9ZZIQ6G/Mia3qgrckI5c+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5x8OT49HlUb+KWJiYD7gswyOpc2iZMcG+vlpcPm4eo=;
 b=DcJLz+7Hz5mSW1yE88/9sRF8OxK+SZaMwOOc2IE9vGcemvwytBOhCWRVLs09L5V1h8OqGya1YzukJhg/wfalFrPQ9BiP+2jrh5KNQa0ezTs1RzEKowplj4oMmJ1tVAuDiHiX0gSspLuq414D2A5hRues8i9K9kLrirq9M+h0yaR+A2FtGKmwcLTRZkoj7LU6WffGyS5DhtHZ1kszijaanxa3bMFga3k8Nbf3r0f+QsGcIJPmMeoIDYQUyEt4CdtifB3nne+a8vT8GTS+HwtKvKpdF6RfQOUyhOpWeM5EIL+IEPLVh+wyAMSOTilJiR9fJkEcMUwh8OA0l1akEbWEog==
Received: from MW4PR04CA0052.namprd04.prod.outlook.com (2603:10b6:303:6a::27)
 by DM6PR12MB4284.namprd12.prod.outlook.com (2603:10b6:5:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 14:03:11 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::6f) by MW4PR04CA0052.outlook.office365.com
 (2603:10b6:303:6a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21 via Frontend
 Transport; Tue, 1 Nov 2022 14:03:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Tue, 1 Nov 2022 14:03:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 1 Nov 2022
 07:03:00 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 1 Nov 2022
 07:02:56 -0700
References: <20221101094834.2726202-1-daniel.machon@microchip.com>
 <20221101094834.2726202-2-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v6 1/6] net: dcb: add new pcp selector to app
 object
Date:   Tue, 1 Nov 2022 15:02:39 +0100
In-Reply-To: <20221101094834.2726202-2-daniel.machon@microchip.com>
Message-ID: <87edumvkkx.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT005:EE_|DM6PR12MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c45ed46-0a03-4dc5-c81e-08dabc11cfb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hr4rX6PiRvODECmV30zbHveFDa7eLzrrMYRdB/4DMhXDYcxo6igF7H4UrDbfTIL7PrmMuFGIyAergb1dlg2xbI5tm2GUDMwz4Ca3RDGMBMQHiixBOby4/Xios43rsxr0SrWoOoQze3pGPuwdresqK3gUJb1O2Lzqf1JtRalseywkAQj4cEzYVNb9uNdhC05PcqEX9/CQJZnZ6tzHvIFkTYhghmtZFhSgvV8VV1MjGmCUfVeZUsOM+lSYLMzZqio9Y3zHMPfn5zaMr+YKus+9ZhozVGgXFam2vbo2XvY8klK6NT3AetYWavFO/0FJrvxt+YxGsJvjPaAdC1FDNpEge5r33CU2gg7ZN6zGOgOxZbfsH01KAxpH6GFT8zv9ya5pNlj3wWZt/2F5d5IXIyQYhI9W4mh1k2GaJNfCfyTGYH1aS4QEjdN9zfj+ZSdt+PhICLWbftPZyqW/hUwIycWlco0ppC7Fx6dnAO4aoNufMrkY2T7P7s7P7DH0D8/uTCe6kPaSYqSakPQ0coK7c7BN94rAYz5L+tGIE9WgjkD82i5HiWI5uJ40Du5tqTTPFiYe/UT2nV1mlWb4Cn+1FWtckp4AMFVlDQwDfm4F/mYNWk+a6jtvTKgn0pCTVKfXMz3rHypE32jgVtVHBSQ8+dbHpUBbQscw3JGo+f5cI3aTk+s53wkcrvUDv4Noy0dEe25gNlRC7oMw6tFKzJT6h/C0hD9ucih7eRFtl9IfZJXIOm7iRHSLCYkcH6XpIfRSyV8ivzcXw1RdKSpGdMIdPO+sCg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(6666004)(5660300002)(7416002)(26005)(2906002)(82740400003)(86362001)(36860700001)(478600001)(82310400005)(54906003)(6916009)(40460700003)(40480700001)(426003)(47076005)(41300700001)(2616005)(356005)(336012)(4326008)(186003)(16526019)(70586007)(70206006)(8676002)(8936002)(83380400001)(7636003)(316002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 14:03:11.0188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c45ed46-0a03-4dc5-c81e-08dabc11cfb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4284
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new PCP selector for the 8021Qaz APP managed object.
>
> As the PCP selector is not part of the 8021Qaz standard, a new non-std
> extension attribute DCB_ATTR_DCB_APP has been introduced. Also two
> helper functions to translate between selector and app attribute type
> has been added. The new selector has been given a value of 255, to
> minimize the risk of future overlap of std- and non-std attributes.
>
> The new DCB_ATTR_DCB_APP is sent alongside the ieee std attribute in the
> app table. This means that the dcb_app struct can now both contain std-
> and non-std app attributes. Currently there is no overlap between the
> selector values of the two attributes.
>
> The purpose of adding the PCP selector, is to be able to offload
> PCP-based queue classification to the 8021Q Priority Code Point table,
> see 6.9.3 of IEEE Std 802.1Q-2018.
>
> PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
