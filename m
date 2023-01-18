Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C735671B15
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjARLpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjARLoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:44:18 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDCA65EFB;
        Wed, 18 Jan 2023 03:05:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHZxgyiD5X7MFEaLma8sh/Lu9lgm22PB1vCVmFkeyoIWA8QvWug1ePJI63EGX9cOs9j/KgruPBc/bqF/2p2AU/Z1uh//9gIf1VqnPdsZ/HCPTGAif0YmudhZn/1L/2BTltvNAfqbDVFVO00m4RP6v7UQG19hFA9JDPTa2LhFV6L0Bg86ALuBrwe7Bjc6Qt0xhEZqH6gX8Be/V0+B1pl0Oi1TSSfZCgTdumbkeffGKeb+0eXl9rdIpA/er9RABYyXbWxXCZwCi9u67QgTp2nqYdXueDbQssQ4Q8lwD5Dyj/eV4sUbGDFUK52Slc6166kJAZEVXgSf7gwDF92ETIi2Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjX2htdRV1mNpnjILR0h2Y3iykgIG+ozxaCDWxS9xis=;
 b=YkY+vuPcdlLgscuvndEiJfQMRtJao+Rv168c9Q3hPsVebSu36pUg4G/OHoHZwTJpIxnl4RYx7kcYZmcPsgPDicOgs01ABeuDWyxLFirp/LrhDvwXr1nmt1uXzzA2Sn2qLJPcLbNo5bPVl4777kp0ZozwMgxt82NyQMZx3JSQ+ABLnb89+pZsUVYr/BFjyKmRnmFtoZw8LOmGvpFc0B9Y8hU1dkU4JmFL1GSP/Tjn/vcYH+PviDawDI9g0GEyZgDMxMEyJTw8qU68OqXJM6eWkGbQM9ov3fpMg/wp1aoB3VI15zE2b6s+Yi8HoUQxAMY2RnrghY2X/a9cQxFLt4f+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjX2htdRV1mNpnjILR0h2Y3iykgIG+ozxaCDWxS9xis=;
 b=cuf6UHdDLhaDsyBE2240zWzO1vTZ0Pgly5ikuHy+anmNWevx+2iL2QfXxyRrVs4Bxkrj7uOwll8tFHuNdYyk7MAah1utZNEdtS6Ya3/v3UUlQ0AcIuCZN1+n9hj7TVDOFkAUS3voAgdJW3uFZmLXJUpYYsdZyaS4SCrPtZ5xPsT9eqiV8qhtVogKgxlmf3wff4P7VbrsboxQjGqIDMxwa3Vh7ElYcfqumSyBIO92doKqWJnBu7JsFKYKIW7woLMC2Nf6A9tiCF7CVvY6opFIkpYa8CKJTwV+qqYaNmYE2bP3SF0Bj9Gzm+x9P/0f6yyk1NCXVgqiCE3U+ufGtQYj1Q==
Received: from DM6PR02CA0153.namprd02.prod.outlook.com (2603:10b6:5:332::20)
 by DS0PR12MB8317.namprd12.prod.outlook.com (2603:10b6:8:f4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 11:05:20 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::9a) by DM6PR02CA0153.outlook.office365.com
 (2603:10b6:5:332::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 11:05:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 18 Jan 2023 11:05:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:05:12 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:05:05 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-3-daniel.machon@microchip.com>
 <87cz7cw1g5.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Date:   Wed, 18 Jan 2023 12:03:17 +0100
In-Reply-To: <87cz7cw1g5.fsf@nvidia.com>
Message-ID: <874jsow1b6.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT062:EE_|DS0PR12MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: fda1ac12-8d4d-41d4-c071-08daf943e3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PO17yNC95Wi+Rtpz3BN0L9QqRw05Al3PLg3VwcqRUYZVbbsZPJWj98AT6ci9LF5NP7A2UlqfrRDF9JiSpb/UvR7nIErVEBhdydtgLgdc7Wy0B/reZagWTByE82nlWi/XxAJAtw0qDS22A/YQN5BcI9IU6fCphRKN5t+KmXnPkihVzkL0NRQm//QR76Dcs7pFnLP+kyUFOS6MHPyckXuFwH37BQLdpZKAiipXcgLORpvFfm64PZkQo7jLoyVfSSTf2hgJoxfmqABCTMawZjafrmstqaMjHsvN4V2qYg9FKImjVGIA8ljKhwcqt7FhznMpGOwY2jCAtOk43GJ4TbPpFrLAHKWDkmquyenwrkX4aIeQNd6L4D5HobQLEd0dnjDpu34nyphPbfL+KwCQ4ew94YWK/EstEufYshIDMaB95ue9bMCvQz8ftG7gUxU7J9A9uPbC2JPIn7fzf6OraaOp4CulhPdscwEZflG1vu+5MUXENFJyV1VpiikaGyR6UumP228IiGEBwG0eh81Q0pPQC/2AOr2o49B+ZZSc8Wte/YbZ9SAHm+8TewTMzQlBNPfIp9O55sv26a+JXjxdkT0eFwavJyEEXZXdQ7sdOQ4XDjU3Wl4YwyIe7Rp9cTYqkPxEMeGqmZJV4lm/XIEyWtxKPq2eFPAzmv7BMQAG6JWkfPmQamjvIRQmIfJRpZVlYMzztDjzF9v+PqFAz0IS6rv3w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(426003)(47076005)(6862004)(8936002)(4326008)(8676002)(83380400001)(40460700003)(5660300002)(7416002)(41300700001)(336012)(70206006)(70586007)(2906002)(37006003)(316002)(54906003)(6200100001)(186003)(26005)(6666004)(82740400003)(2616005)(36860700001)(7636003)(36756003)(82310400005)(356005)(478600001)(86362001)(40480700001)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:05:20.6615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fda1ac12-8d4d-41d4-c071-08daf943e3e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8317
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Daniel Machon <daniel.machon@microchip.com> writes:
>
>> In preparation for DCB rewrite. Add a new function for setting and
>> deleting both app and rewrite entries. Moving this into a separate
>> function reduces duplicate code, as both type of entries requires the
>> same set of checks. The function will now iterate through a configurable
>> nested attribute (app or rewrite attr), validate each attribute and call
>> the appropriate set- or delete function.
>>
>> Note that this function always checks for nla_len(attr_itr) <
>> sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not in
>> dcbnl_ieee_del prior to this patch. This means, that any userspace tool
>> that used to shove in data < sizeof(struct dcb_app) would now receive
>> -ERANGE.
>>
>> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>
> Reviewed-by: Petr Machata <petrm@nvidia.com>

... though, now that I found some issues in 3/6, if you would somehow
reformat the ?: expression that's now awkwardly split to two unaligned
lines, that would placate my OCD:

+		err = dcbnl_app_table_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
+					     netdev, ops->ieee_setapp ?:
+					     dcb_ieee_setapp);

(and the one other).
