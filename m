Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0712359C94
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhDILDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:03:43 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:60800
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232469AbhDILDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 07:03:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaFTdQSNUrQ4sTuLMCjlohQFfnZpPYQMLCPRD5ywsuVVO850V9YhVWmrRHkv2MS7Bj/S6o0n1JxW8e6bJlbvvcCOlDakAH+Saj8XctUvyrP/vbjnolqgyxXjamfjTp733vRqTBg1xYp8HpNZnJ5qjLYU6LhMPyUI47DbudCbXffyPXTGBOKNZLPGZPJA8FTl+g55Aptj3nKkn6kuGfvvMNgMTMeLlbNAphV3ZmxB/1z5u5eqZOUMfZm8igcR+7lfBseGAQwoVHwddBtp1AZlCvcvJdXh2gB/fpatdllz3494RLQqvJNKI3OwOllQcy57DsA+hdrAjVcRp0mf9Sjy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCVVnDoAy553y49SyfCfvqdAzVLDyMcwMwBBeyjlY2w=;
 b=mZcydkdga4fYmq09pBZ46KxUx3vJFbFEhSq1wqvlHYi5a97Wjdc750fbYSJRsaf/zIOLlfSc6tNsoSIZbkkMyrxaLIu0eNY2kw/bko4gB0Db4bl4ble0kZnlubaGsXCxn+l8EGafKggNcjE1g4Ao4IdKGt5ECtmUwkVUeesxEte7v6vJGlGBoc/C061/TXP0ZMP6GfR96GuXMGfsHLmXy7RF50Ro4cjTZjw0xRbIQf3NpLXNv3mYNqd65kmPD2PcaJ8CN1mHgQ/914rSqqpzu60pOPVoRJ6s+ABcEoN2uVpx+Oo+79O1GboLr//cidXLT0x5tM3VfKi0csaiz8Y3dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCVVnDoAy553y49SyfCfvqdAzVLDyMcwMwBBeyjlY2w=;
 b=VcgVg2wCsn4NVaeOec/NnXHRK6CiHonFomB/oJs5nyJ5NoIG0MVdu30Az0uxNIZ28k0wv1Pkt72hUqTn7ZX9A3i9LCnyAu5RcG9HZjfJ0zU0eFtVaLZplljxFVFtopi3QBRTxmEIGEYX2a+tnVsmhf/xl1PhNxfXaBv4RDoIhZTDAt1kilIhsHj4VSY32rBOR3E57uc/SmFiE8WBy5h8RfFfErKGAOMx1m/3I3wYiunvyXhteYU2VRtsXzeJxYuqNN6K1uK5nURkeB2bd7L2hJjTkjF1BRgnTnkbkmEiDCmy+Fd5TPu0MYpsNQB+QW72BSVk5XWMag+y4bF/892eIw==
Received: from BN9PR03CA0306.namprd03.prod.outlook.com (2603:10b6:408:112::11)
 by MN2PR12MB3837.namprd12.prod.outlook.com (2603:10b6:208:166::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Fri, 9 Apr
 2021 11:03:27 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::6b) by BN9PR03CA0306.outlook.office365.com
 (2603:10b6:408:112::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Fri, 9 Apr 2021 11:03:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 11:03:27 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr 2021 11:03:23
 +0000
References: <20210408133829.2135103-1-petrm@nvidia.com>
 <20210408133829.2135103-2-petrm@nvidia.com>
 <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
In-Reply-To: <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
Date:   Fri, 9 Apr 2021 13:03:19 +0200
Message-ID: <877dlb67pk.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccb7432c-dee4-481a-eb76-08d8fb471a25
X-MS-TrafficTypeDiagnostic: MN2PR12MB3837:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3837F0AB54B8CB79EE347C17D6739@MN2PR12MB3837.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYDaRcEH+l+x8f0f+hk5sWS9WfxrIAZ1nwC3+3gprvxrrlkkdzXM/LAAMY53bYC+pyLbX7q0SBitvmthQZNzHeIPx7ezkxfiakYKIQmB3oyehDSrUSVhaoTsswVSyUqYC0WvRZ0xJ8satmcyS33opZOeV2n9qwH6Nc2JuqF8Yu+C1N/MgtimEcP2a+1SLlsTuSeFrfQ5EOev9XIWZAdbeztT5ZDRD/IgabVLBAdUsNX1eTwQp/SIaX/qyBFUNW5WsRsRm0Xsq2DfQSyfpwr696aprQy7Y6e6rDQeYctzAKdbRMudKj8LNFgE4Sy9fI3d7XqMuuvV+CqgHMZJTYyqvCOaOEBCaubPjq7TFi01G05sjUTvNoVgyYXHqZ0EQXDkDBbx9RYmwSUPMRP/B905KKhT6jYjFnD4p502600T1jMh73z+MHvDAPh6Wypjx3SuWL2GSQUDzZGOXpCY46GtH0BfeRQcEhFkPDeqdPs0WBZS2nTXPYFtYNUPu26dWeTOolm1XtZjan4qfpTS77r1neosCq7Qf+mwx4bphNBoH7sPTr4DtPgjS8LilLdbC5AdGxJ9ttUOeMsVHiheSAedm1LK2yV/Eq5IjU648vuHsdiQXmZbx2vzX7eYUGxuMgBCPiqpRbAGHu63I+JBYuEDrhdSesqhSvIRjGDBWH3zvq5bt/jz1qY2x9SykaOjl6lQmdshK7BBa3E1n+uCTx4PC+ZFpTHYopdEIrigvqr62os=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(36840700001)(46966006)(47076005)(8676002)(356005)(316002)(36860700001)(6916009)(26005)(8936002)(478600001)(70586007)(36756003)(70206006)(36906005)(186003)(16526019)(2616005)(5660300002)(54906003)(86362001)(7636003)(336012)(966005)(426003)(6666004)(2906002)(4326008)(82740400003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 11:03:27.1238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb7432c-dee4-481a-eb76-08d8fb471a25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jamal Hadi Salim <jhs@mojatatu.com> writes:

> I am concerned about adding new opcodes which only make sense if you
> offload (or make sense only if you are running in s/w).
>
> Those opcodes are intended to be generic abstractions so the dispatcher
> can decide what to do next. Adding things that are specific only
> to scenarios of hardware offload removes that opaqueness.
> I must have missed the discussion on ACT_TRAP because it is the
> same issue there i.e shouldnt be an opcode. For details see:
> https://people.netfilter.org/pablo/netdev0.1/papers/Linux-Traffic-Control-Classifier-Action-Subsystem-Architecture.pdf

Trap has been in since 4.13, so 2017ish. It's done and dusted at this
point.

> IMO:
> It seems to me there are two actions here encapsulated in one.
> The first is to "trap" and the second is to "drop".
>
> This is no different semantically than say "mirror and drop"
> offload being enunciated by "skip_sw".
>
> Does the spectrum not support multiple actions?
> e.g with a policy like:
>  match blah action trap action drop skip_sw

Trap drops implicitly. We need a "trap, but don't drop". Expressed in
terms of existing actions it would be "mirred egress redirect dev
$cpu_port". But how to express $cpu_port except again by a HW-specific
magic token I don't know.
