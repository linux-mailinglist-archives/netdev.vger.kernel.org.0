Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F65F59F869
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 13:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiHXLMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 07:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbiHXLMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 07:12:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B67858500
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:12:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExT9tnhMFwmr6X/YQpEB5skHgj7x6h/CQpxQiAXQYwZdAomYVKASl/9dvC4yhJIt1L8ACPWgxAqMTYRXLMLGcEyEOqF0fCNLeTyrkkIUV3qXoO4CMawtp6m2u2vmPAnGNd6mUsNu6t861XQNWRvMdv8kBrMct/PJXuyJALv2mU8HXxWO2RB9NcMKoJcZ+PYD1jaTRPBP7fzGhQY1LDx+0JvBNpiI77/iqjAxBG+kr6yfuckByVeAfaL5fQVvM4x+FZ1U9S7qJ2LW+9A3r9j9VqmWmjjtD/xRbPp330Lo3RhCyfECa+/S63eI/mWHNkiFpaVGhRwzj1QCDnZyTBsNtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp3LhogPzYOujdA0Ep+CeJ3aFGqE/EehImFGItqecBs=;
 b=fKlNdtlqU8qMuB/FovROQlxDzsQOI3vdgfJ7TCxg44qH2yO5NLYNaKNmofLwHHySNP2c0qgyRFZD47r2HXc4mcB9oW6Ug5Ggv06AQiij1Rab7imB9b63yX3rN+k4ODpvaSSuXhavkItLVl81ytN4OYcysQgIAoMavHyYBndQ+b+w/gizSuCLUwfLBTj/bYL404P5aUd17KM5nFbzEw1YUcCq1qjWj5NJUPIk8imEjGAHz9D8QmtWop1nSaCXnWmcbYBWEFy4Rq3y1rA8BnqDV8yjF3rkqCT2gDGS45VR5oHj1R6el0HRDrpckBJt8qXGeqXgDzgt0e2FvOvRaOTyWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp3LhogPzYOujdA0Ep+CeJ3aFGqE/EehImFGItqecBs=;
 b=HnwF0FD05NbB0/v+VdvEp6HfjHLhLUFEYE/iINMTZ1460ol0oj6L7CNTAY2hMWSDGnwD8bmqd1X2Qf9JQx265JIV0Pg3CdMaT6GpzABJ+GSSf5zcHZvr9EXWMp4Pl/GSyvH7/z50MmhWF9bAUMt97SWW6Hdi2+34vb9Cgxj3qbe0+uNna3wIbbQzKFPf0GUkl6jTqY6iM0LiDvKCpcRVvbCJZYYMwJhlZBBQvTn7qNF4QxlUBJ+wF7PMJgBPN16UOVVWDkQr3/1VUsY1Dse7Xsb69n8mj4cekBv8vNy9vwcxbzFLPZ1UiV6FUgEGVIcsXVR5mO7uOqPDxGGXRKsQOA==
Received: from MW4PR03CA0124.namprd03.prod.outlook.com (2603:10b6:303:8c::9)
 by BN6PR12MB1201.namprd12.prod.outlook.com (2603:10b6:404:20::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 11:12:03 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::16) by MW4PR03CA0124.outlook.office365.com
 (2603:10b6:303:8c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 11:12:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 11:12:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 11:12:02 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 04:11:59 -0700
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Wed, 24 Aug 2022 11:45:36 +0200
In-Reply-To: <YwXXqB64QLDuKObh@DEN-LT-70577>
Message-ID: <87pmgpki9v.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b67bb7d-d180-4405-fb83-08da85c1792f
X-MS-TrafficTypeDiagnostic: BN6PR12MB1201:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFgCzMKWXe70Gf8nmVHjwv6cmZ+fcOIwQlSNGWFmra5+bfYx+L8JQF8ps9EfMKB7F703mufvh5tppTHmYY3GRUHLhFnZSQecbkQ/ndAJqqsmpWa0MJDQwVDnI4ZRqkiAKnHkZJPCXUCzwWdv/SWz+j9lPVN+eV02ujZQA589uGM6j8RER/GngMh1V6GyYME1nsoW5eNfuV5SMIZ8mTqImERzZ9KVf+WxuexUtwZJuqpQ+NidCJFclxT0l7gTrODz78P1KjBEjxwECjQKIIKdKYnl0+T1bkQH/EaO1ZXF6d1rwgm4QH3qdn1lR/3g6gqTGmWP/7eHmdn+ubEvbodyXbqu+2MtvHMsHnLfiQHGRLewsTbm6sXEmjTUxaTq/xXYoJUlNOm1i6wi50pc5gCyDw/4gimnn0Eukoa6lvnSYexMaDy39ryl270zTaTqwY91VHzyM8GYYXV7OpRIbdZ6x+RUSyJbkSLIBEcefa+dhixcmgd/Pn1SsifSsAAtDA8RVRJjvp1bIBtEBOQS1t/899fsB05zAL/dbe/wBGhWOFXjWMdlJXB2plLT/ACs2X3ay8ULhGl2hTXpZGlsxLq2sr4ttOSZq5ETyYCNn9ZxhWdNh5DGVzuIzEDtzjPIPpnmn5HBlQlsouWZb1VKBWKL+/3VUhJwmbAZcHA8YhXPfo5UBjskXZcyozVWI5Y9chTRM1vT7BqT11XaZx6unJNT4/BeQwQNtbL75MqNTQjMlmLLW3ki3bUWCk2Um+PHj+qAi54zdr++KxBPAVoPcY8jhq0WGCwLYQhdFm3s5iPoDHPt1bU628veV8P9VQyjLG7T
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(40470700004)(46966006)(70586007)(70206006)(8676002)(36756003)(86362001)(4326008)(36860700001)(82740400003)(356005)(81166007)(426003)(16526019)(336012)(47076005)(26005)(83380400001)(478600001)(6666004)(107886003)(41300700001)(82310400005)(316002)(54906003)(6916009)(40480700001)(40460700003)(2906002)(186003)(2616005)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 11:12:03.3466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b67bb7d-d180-4405-fb83-08da85c1792f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1201
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> How do the pcp-prio rules work with the APP rules? There's the dscp-prio
>> sparse table, then there will be the pcp-prio (sparse?) table, what
>> happens if a packet arrives that has both headers? In Spectrum switches,
>> DSCP takes precedence, but that may not be universal.
>
> In lan966x and sparx5 switches, dscp also takes precendence over pcp, in
> default mode. Wrt. trust: DSCP mapping can be enabled/disabled and trusted
> per-dscp-value. PCP mapping can be enabled/disabled, but not trusted
> per-pcp-value. If DSCP mapping is enabled, and the DSCP value is trusted,
> then DSCP mapping is used, otherwise PCP (if tagged).

Nice, so you can actually implement the sparsity of dscp-prio map. And
since PCP is always second in order, you can backfill any unspecified
PCP values from the default priority, or 0, and it will be semantically
the same.

>> It looks like adding "PCP" to APP would make the integration easiest.
>> Maybe we could use an out-of-band sel value for the selector, say 256,
>> to likely avoid incompatible standardization?
>> 
>> Then the trust level can be an array of selectors that shows how the
>> rules should be applied. E.g. [TCPUDP, DSCP, PCP]. Some of these
>> configurations are not supported by the HW and will be bounced by the
>> driver.
>
> We also need to consider the DEI bit. And also whether the mapping is for
> ingress or egress.

Yeah, I keep saying pcp-prio, but actually what I mean is (pcp,
dei)-prio. The standard likewise talks about DEI always in connection to
priority, I believe, nobody prioritizes on DEI alone.

> This suddenly becomes quite an intrusive addition to an already standardized
> APP interface.

The 802.1q DCB has APP selector at three bits. Even if the standard
decides to get more bits somewhere, it seems unlikely that they would
add very many, because how many different fields does one need to
prioritize on? So I would feel safe using a large value internally in
Linux. But yeah, it's a concern.

> As I hinted earlier, we could also add an entirely new PCP interface 
> (like with maxrate), this will give us a bit more flexibility and will 
> not crash with anything. This approach will not give is trust for DSCP, 
> but maybe we can disregard this and go with a PCP solution initially?

I would like to have a line of sight to how things will be done. Not
everything needs to be implemented at once, but we have to understand
how to get there when we need to. At least for issues that we can
already foresee now, such as the DSCP / PCP / default ordering.

Adding the PCP rules as a new APP selector, and then expressing the
ordering as a "selector policy" or whatever, IMHO takes care of this
nicely.

But OK, let's talk about the "flexibility" bit that you mention: what
does this approach make difficult or impossible?
