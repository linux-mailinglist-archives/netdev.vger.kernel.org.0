Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5E67F96D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjA1QIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbjA1QIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:08:18 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918A82658F;
        Sat, 28 Jan 2023 08:08:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ1XIkztbXS+AmYJaxGwyWj0MxHmJ9/V8t9/oUoGL+S1mTcGt8vsp9Iqhe0mcUUqPhbkvjB9sqYiYN6W6dOUCwJrGeE6Yz0Jco7SRfqvLW+PV4HdQclW35P/zcRwiv9wRM9pKexRTCXWZTRbUqmTtJpZCmOYtxAF0NIzF4N+CqUYWG0vXjqzZ7enN8iVxgb/vV9Qn4b+SKEHkupu/6PTNZU+JZWpCcS+jo7z6jsG9ruyYbRpZUqNtZeuHy4rT9UnXq3hVvJJfqBIrRrkG4tqk+I+Vn9XSEC4xJAFbyo4QRln5k7wTyYMGl2roAbtoxjkXATTtiL8mPsFJTFvwI1Xyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ytj+gd4suHIFb2oy3OlaL3OSdEalEvgFFooN7Qmm18s=;
 b=e0xjsZRAI7o7gnCY/nbJBEHIjlLEHjiHT7qSBqGqVqmC8vecccsxya0NAcoNpQAT90nGB4wD5SX4tNhQFjo/oDyDiK0PE+OyM1AZrAJPg2tIdFivObujo2SOANy+sPc33tTXf8jc23EAfIBIYWAVB8Wj0bduDLYFfGNXyv9WOpsekygpqUYf67fGh6XrtVu7yOlRq5iTRixI9MzZXt7z8NJLWSoXUos7NIkx7ue6sZvSmOCYA5Dul4AAps2//ZL43jyhE/ND8fxz+pB2QV7YM1rydjYjvDN85nKmUyxrsghMrPM6l/0NOJLCXAAmGprJ1clGYm6DY3H43RWUgaNhDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ytj+gd4suHIFb2oy3OlaL3OSdEalEvgFFooN7Qmm18s=;
 b=hM5mSn8FV9AMjkz/fve9cF1RjLp6so9npuR5ZlX2NOe85xqgHQT6jDa/b//Z3RSwHBV6exUw2rhWKMyPs8veS54kRH4k7395hB2vP7fzqX+JaN1fRclgYDqRGUs+9zw2gcQeG2AXbE444Fgom3h3S49rwLonTQtmSQzmXDRBuBcREnx+sMwtRnFL1AjhaugoB4lIesomPUouOwbt7tWMfv+Bgdj8Vd1LTlujvjIgWLUxxx9EXc+zVwwgQyll0sKd1ps9vA9HcvIaG3FWRYmE4lgzkSoizIHqMi5uiG637dwgU/ah0DgF3DUmzgkuJaq1ItA8bQwk8V1rLkMHHs092w==
Received: from DM6PR01CA0009.prod.exchangelabs.com (2603:10b6:5:296::14) by
 CY5PR12MB6525.namprd12.prod.outlook.com (2603:10b6:930:32::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21; Sat, 28 Jan 2023 16:08:13 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::4e) by DM6PR01CA0009.outlook.office365.com
 (2603:10b6:5:296::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30 via Frontend
 Transport; Sat, 28 Jan 2023 16:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Sat, 28 Jan 2023 16:08:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 08:08:12 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 08:08:09 -0800
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <Y9VEdYnSLH8YKTZA@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v5 0/7] Allow offloading of UDP NEW connections
 via act_ct
Date:   Sat, 28 Jan 2023 18:04:40 +0200
In-Reply-To: <Y9VEdYnSLH8YKTZA@salvia>
Message-ID: <87ilgqej6h.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|CY5PR12MB6525:EE_
X-MS-Office365-Filtering-Correlation-Id: 33aa72be-02ba-4630-ce63-08db0149db78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MPwzEce8eN1ftVgaKIpwmt+Lkh+9Uhel0uKommhWwRSp7sKrfj54RSD1X7EPshRgtB0ujcsyc507qtlVaovoRW5fe3UWyTml6ULI83gYxQM4FkgU2V0uqJ4krrkMAv4PS9etohXC5wv9BlI0DJhSSPDbUMG5NVSAEiTPpzWV5M5TfbXaxSTkgS7qviozX8CZdNZWBecRE8ZSUZjRWE206YJwrcrsT12XOSeWHs6Xbvx6QxjlYJ73lZW9c1H0JibXCDMLoWKe5+ZOGOpturGxII9JTKOSzv+cQ7KV3XSp2RXXHCJLrStFdnihmlbggufj098sHI1vI7pyeTzih2IXiOczULI46ty8JkpVK+12ZUHJBVNJ9W1UWCdblNHWfEH+ZXvyJkRiEPQG1AlF8OcUHTThVf8rSwfYU4QHGvR0t6An9h8F3PpkqSibD+Q3wK4s4COIvPKz2UrNLYg9f/TavcYYYbdM+QaMUkiqo81Qjuw2JjgwdRuujhsvRBtkvpDadgwOPDrTKuEbMrOZ7DAHxZuM5QCXE9iW8swX6RFByf7/+ZFMM5Ga72xBASBRiBH0DCeNYHbr60I2VVQ1DneFDrAeVXsfRdIQmqWmjORUo2E0D/qwq33HxLXxN+bRWOxKUVhf5thWqm0hd/qPIvtW8ahuUYm29dnJPUbWIj7BihVBliLQ2ZESzpFce4IlMANpXAKou+lhuy5SfwzRvDppA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(41300700001)(336012)(2616005)(426003)(36756003)(8936002)(47076005)(356005)(83380400001)(82740400003)(2906002)(7636003)(7416002)(5660300002)(86362001)(82310400005)(186003)(26005)(6666004)(478600001)(7696005)(70586007)(4326008)(70206006)(8676002)(6916009)(16526019)(316002)(36860700001)(40460700003)(40480700001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:08:12.8018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33aa72be-02ba-4630-ce63-08db0149db78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6525
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 28 Jan 2023 at 16:51, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jan 27, 2023 at 07:38:38PM +0100, Vlad Buslov wrote:
>> Currently only bidirectional established connections can be offloaded
>> via act_ct. Such approach allows to hardcode a lot of assumptions into
>> act_ct, flow_table and flow_offload intermediate layer codes. In order
>> to enabled offloading of unidirectional UDP NEW connections start with
>> incrementally changing the following assumptions:
>> 
>> - Drivers assume that only established connections are offloaded and
>>   don't support updating existing connections. Extract ctinfo from meta
>>   action cookie and refuse offloading of new connections in the drivers.
>> 
>> - Fix flow_table offload fixup algorithm to calculate flow timeout
>>   according to current connection state instead of hardcoded
>>   "established" value.
>> 
>> - Add new flow_table flow flag that designates bidirectional connections
>>   instead of assuming it and hardcoding hardware offload of every flow
>>   in both directions.
>> 
>> - Add new flow_table flow "ext_data" field and use it in act_ct to track
>>   the ctinfo of offloaded flows instead of assuming that it is always
>>   "established".
>> 
>> With all the necessary infrastructure in place modify act_ct to offload
>> UDP NEW as unidirectional connection. Pass reply direction traffic to CT
>> and promote connection to bidirectional when UDP connection state
>> changes to "assured". Rely on refresh mechanism to propagate connection
>> state change to supporting drivers.
>> 
>> Note that early drop algorithm that is designed to free up some space in
>> connection tracking table when it becomes full (by randomly deleting up
>> to 5% of non-established connections) currently ignores connections
>> marked as "offloaded". Now, with UDP NEW connections becoming
>> "offloaded" it could allow malicious user to perform DoS attack by
>> filling the table with non-droppable UDP NEW connections by sending just
>> one packet in single direction. To prevent such scenario change early
>> drop algorithm to also consider "offloaded" connections for deletion.
>
> If the two changes I propose are doable, then I am OK with this.
>
> I would really like to explore my proposal to turn the workqueue into
> a "scanner" that iterates over the entries searching for flows that
> need to be offloaded (or updated to bidirectional, like in this new
> case). I think it is not too far from what there is in the flowtable
> codebase.

I'm not sure I'm following. In order to accommodate your suggestions
I've already coded the algorithm in v4 in a way that always updates flow
to its current actual state according to conntrack atomic flags and
doesn't require any follow-up updated if state had been changed
concurrently. What else is missing?

