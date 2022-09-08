Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2C5B1B22
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiIHLRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiIHLRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:17:17 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BF4E42D6
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:17:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCRTNLm7FUsv/EgoN+bbGauew07DiK7HIaf+BfGT/eNG2bbe9QTpnhKcDHmNiEKj2LuTO+bJBXjswQjPvdGQXvjee85GhFX6nCzyK6dpEG3B7kYPDHNjff+d6CfOjLhjIxPNeRZnHYEF0JYgx2/6oT8HMR3RjZjR7VsSlgnd+NGpXWjHDJbdaFPxKSEgNAZ8yvZ/QzhM07tPbWHdHPAND48vI7kV8/Lcih1/DduN0kblsiZ/1wVXRsxZrrl19zF8Z0QrWfLDmZklZ7Skw5qVpXou35EWE22tF4kFY04Rn9q2uw8JuixPUIfin4tCr3FxzCvdbfs5oYZQ/VPQcMDgCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RpzamPZTygFP5eH5WnRzXlOQazwEui6u3fsj2WWrdA=;
 b=BqzbKV75we/4kbET189OBsKL2Usxfp2L6/pRFcSyVGZO6D/D02Xx9ZhJ3mPTQpD55XNxnIbl7jjJgm7CyOuIzX6nDsI+bXkIFlGE00o0tzuT0CHZUSqBBAw+OUc265XI0tc/clNrtL/NuwQJDQl9qCnznuwTfxzlcMPgx2PtSHSn02klgZ9zEr3PD3Y6arSypPZ0Kh/JhosX3BAgEmqT61Q9DrGm5tD+YlL3q94yfI7o4yuUyewdKTUk4+zRtJ2yEvAulx2cZf3qdXsCT+INZfg3tt6KEB513GHUWycMxFU6fRJa1j/xts5ZgEnAt+oeXyRKtUTZ1gFhZpb+lP5w9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RpzamPZTygFP5eH5WnRzXlOQazwEui6u3fsj2WWrdA=;
 b=Vv41/nHJNhHiEhk+kRa8Hj9k5FkHvHC4g8pmkUMbbkLME9HWyeSN8/KLbf644MA/wYRu4rCYX9AzADF1EgxlGAYVvxj2DAvsS2AAlfT9QCID+O54wRm/ejzsQwNO8n+2EArf7Fa0IGHXcRcK/T+EdPMdcOfpI6ApIvAcmhi8IBgvTGYYvRhCKAVAcT2r2LTPYOF5XyfQPccIVy8xiEykLZEj+xNEUk+XMssrGC0KsF+kvlZPkkMJUJLRwtRoc449V57hrsq/3aYEGS1evo0jWrBcKsyYoQIB+8eoFdzD8qZDUifXyRiYVg0TMPBMfgRsQiuZT63AV58T2YbbWQzaVA==
Received: from DS7PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:3b5::15)
 by SA1PR12MB5670.namprd12.prod.outlook.com (2603:10b6:806:239::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 11:17:14 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::6d) by DS7PR03CA0040.outlook.office365.com
 (2603:10b6:5:3b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Thu, 8 Sep 2022 11:17:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 11:17:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 11:17:13 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 04:17:10 -0700
References: <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf> <Yxh3ZOvfESYT36UN@DEN-LT-70577>
 <20220907172613.mufgnw3k5rt745ir@skbuf>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "Daniel.Machon@microchip.com" <Daniel.Machon@microchip.com>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Thu, 8 Sep 2022 10:27:58 +0200
In-Reply-To: <20220907172613.mufgnw3k5rt745ir@skbuf>
Message-ID: <875yhyf74c.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|SA1PR12MB5670:EE_
X-MS-Office365-Filtering-Correlation-Id: 28841464-7615-4992-6aa5-08da918baeb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rd0ebCUc7e212xupoUGG0ja45jqoDzrG2XyMkJ6k1s7HFzmy3EXI8eUhy0Lb0Q/4Ch9vTdaAi7qHr1INLLJWb4iL6qoSrTWVET1U/iKYj9w8cXweXqWs5mS7LExlz8IZrgA59sd/R9cCF0rVSd1NyqLSSL0A3SOLLHpb+6LB7bPIPL/xQhSz/slouUA/tQ9Lbn/ZCEb3cchs74yz7n0GvL0UvsBd1+qbEASzbjHYw8D1+Z6/wD3Ka25KWGK/nInPdsl8SllW/zE6I9dYP0FrjkR/57+knbkrB5zrWmdMtXFwjMxW+7Y2BGgHRM2dvWP+JaXt1QvAHksPNEoEXDtpzO5XZlP5lY1EO3zlQNgEGuYdgTyb/OnSehzwm5j8gRWbhUOcvfCQ9Y9H8H11hT3Kd5D5sIw6p0mDY5XqujM6lUTPvUUMOHukwLxeWFLUmQjuMMSYFszMouoV5+wC7OkfGu6p+iOXYXHwsjEqpTE3AvO/eqAmo3zPbOtYxLs9nAk2XCRVJVY0nRNgH8/kLAXcczfzWlFVF/fOA8SJd64uwovEshz73d6PlxymVFrCxC86HDqkJeTws1KAtPTo1C3IPQN+ccydvvMxKQ+SHEUudrgxYtUmn1n8ECM/45HFj7Z07h/RW3yKdilXzhLNJAW0XAx2bx0j5fCXGcx4/G0YfEP4/6IV77MbTFLcxfJtJZVHEIs7nD5tHv0ctBa2pYB/7Z1vEm7zclsVFzt05fJHwnEIsc0nG+AGmihOG6NGiZQZF9I18usiKfoLg2VcjM8wF5wkNOWbhRLQ6lGdxy3ZTCS89Brjq/T0WkXqQvQ4n0u1
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(40470700004)(46966006)(36840700001)(186003)(47076005)(426003)(81166007)(356005)(36860700001)(16526019)(336012)(82310400005)(478600001)(70206006)(54906003)(70586007)(36756003)(4326008)(316002)(6916009)(83380400001)(8676002)(2906002)(26005)(6666004)(40460700003)(107886003)(8936002)(41300700001)(5660300002)(2616005)(86362001)(82740400003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 11:17:14.2990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28841464-7615-4992-6aa5-08da918baeb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5670
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> The problem with the ingress-qos-map and egress-qos-map from 802.1Q that
> I see is that they allow for per-VID prioritization, which is way more
> fine grained than what we need. This, plus the fact that bridge VLANs
> don't have this setting, only termination (8021q) VLANs do.
>
> How about an ingress-qos-map and an egress-qos-map per port rather
> than per VID, potentially even a bridge_slave netlink attribute,
> offloadable through switchdev? We could make the bridge input fast
> path alter skb->priority for the VLAN-tagged code paths, and this
> could give us superior semantics compared to putting this
> non-standardized knob in the hardware only dcbnl.

Per-netdevice qos map is exactly what we are looking for. I think it
wasn't even considered because the layering is obviously wrong. Stuff
like this really belongs to TC.

Having them on bridge_slave would IMHO not solve much, besides the
layering violations :) If you use anything besides vlan_filtering
bridges, you have X places to configure compatibly. Which is not great
for either offload or configuration.

Given there's one piece of HW to actually do the prioritization, it
seems obvious to aim at having a single source of the mapping in Linux.
DCB or TC both fit the bill here.

Maybe we need to figure out how to tweak TC to make this stuff easier to
configure and offload...
