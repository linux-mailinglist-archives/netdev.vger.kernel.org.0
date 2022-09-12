Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025A65B5E6D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiILQld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiILQl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:41:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F3526AE1
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:41:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kH19YyyOFmkdOd4e3mrdlrNlnqB8Yd7lhuIfWwlHmTuvdej3YzYag7LQadlhlBTcD9qQ6Ef/3LPzEfyaPD9jz1zi2V/yZ0qveul1q6fApaE+pv76rwk3eQh2xohDGsiC7lBRormWTI1jTFV2OLaf1Ye9fv49TCQlRE0ENGOsJhzun7LuLQCTrbha+jJAneabZexiYAwfiWtG09wgjkoRVvu9oDUMnyCT5QtafOyixni/FRCnH9Agj07EXrURx2EGGIUuWXrqvXDquZIZH8Ky/1kHG91thnITH51u/uwF4789THEiZeOE565h7vKeMI9NPRDS6TgjPK73Rq9sVco+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ql2TffEviDKfMJhAeDcghMcKI1GedCGpVQbKX6IFow=;
 b=GJwwu7SR2LMf3248rM/OxVeMADtR5DaJdDSRlfUmd5OD4ZkVouyTbo1EWMK35ssxq9fsk++zSr6PG7CAalochJKQyJwXgZ2U4nH6MqNUUPhKixND7+yU2tTaQI+YFzgR9fzo16UUf49/s4d9uAuCpGWrKTCBqoQh5aItqejAIMpgx66TPNdAASr0UvolXqGa+l+RGe5Wk5+10f+Z9lJbQha8EOrKavoNY0uflgZ1NkUqqqngDlV3Cu+2akT7lT9iLMG0D6KMD/Yrmbqm6GlirVYrCF7xzkTalewZq7YmPxzqE/5/0Horp18FioZYUxwMqNSNiPVfb0cAz0V8xadeRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ql2TffEviDKfMJhAeDcghMcKI1GedCGpVQbKX6IFow=;
 b=R0KmkDbvowrBjaNpx51ijCqKDP6H5ETxovpi9prfr9YmhkU5bduuIpSA1PBrl0TKe8Zo5tKV2+xvMRflY7LcWQB+J5A1Jwvq1mQvOjj3MFLpJ+RnE3gaWYM1qGCb8cNJdBKSb5VCoASeXFPqN1640KsXApcxwMz9J/41q93yDUxwWmNQgloW+OkMj12luLJ8Tffx6ZQnE6SkKPQ/+cuROqd/P5cGbW8FO+FJ6IgpqeLM5mwM+1AZ1emYI/axQpz0OndS+tPSqcTR01e1q8wHO3ue6l7ZVompV0joCTy2VYMKBmD8s/b+zi2w/OcWeSKInVsj14/FFn49YzKqOlBirQ==
Received: from BN9PR03CA0171.namprd03.prod.outlook.com (2603:10b6:408:f4::26)
 by MW4PR12MB7383.namprd12.prod.outlook.com (2603:10b6:303:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 16:41:27 +0000
Received: from BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::6b) by BN9PR03CA0171.outlook.office365.com
 (2603:10b6:408:f4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Mon, 12 Sep 2022 16:41:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT096.mail.protection.outlook.com (10.13.177.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Mon, 12 Sep 2022 16:41:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 12 Sep
 2022 16:41:24 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 09:41:20 -0700
References: <20220909103701.468717-1-daniel.machon@microchip.com>
 <20220909103701.468717-3-daniel.machon@microchip.com>
 <20220909080631.6941a770@hermes.local> <Yx7PRgPKy0ruMDSE@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH iproute2-next 2/2] dcb: add new subcommand for
 apptrust object
Date:   Mon, 12 Sep 2022 18:34:31 +0200
In-Reply-To: <Yx7PRgPKy0ruMDSE@DEN-LT-70577>
Message-ID: <87wna8czpu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT096:EE_|MW4PR12MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: 43362898-111f-42f6-f6f0-08da94dda327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lXkpnwPmfPD3lrQ8CSVnY4EYB3rUThBTfCqEnk45yD86M+12Hss5g6t5LlFFad3/HF5Lm80UQr6P9ygFHQZQnxyfB7qnVelCRUWvTazboUrxMJrLdKYf9SRYpEiezM7nnYdIKIIsn/gyjt55W7dFsHabck1Ex+UeSU7ziXSUTb+vJXrc3l1vXzXxgCWnTo0MA8yVNt0JoLWtiWkxiAWRcaD47I9tW8Y6LbnjyYK1SdfCsUauk/9gjtSvYbwth6znAKskVz9krjGGwhCYHoaTPNPvOca8P7jpjJuO3osRhK52DztUUtXnKxY4Lmx4+pvDLzvGANBJPDsPlonW2dlNb+bQYg7g4oc7bUP+CLSbY4TwCOFp6IYzcuSo8msAynXUi4wIdsqGHEGv2SfV8WrmZLeikch4e97x1McWG7hVH/B1lblSUbQfZAsOyQZNwUJ80cfJDAKrTOYCzNTAYu2/LWQJ1iQpG/BRYckFrs8lv0ZKWkU1QuxTV3/ge6VY/7Ejo+licYbTf4vCoe6O7jAG4ZDNGIQ6gE5lFGdOx9mtwicdI38cvqjnMTHttY/9x6sw00z3/XjiY1YoJ+Tm7IFtcGrTcgXKhwejMKg9ruMkb0mbe7ZYvrcECUHODaV3qVFVmLSserRr5rkmteJNEHi8fOJwUl3rs+SFvS0qWNeMVFAQjvFNboLA5Ycu6LW3w+cusUT6pY/+1h01lF9vOn/BoWDwP5WrnIc0khwKKwga+Pd9EEEUGNXX4xW5na4zULPx/7dxwE0BNJFF2ML8hLddSaJujXMblvEzaASDF9jflvYlI/E+RJQg0+1aqjJOloP
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230017)(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(40470700004)(36756003)(47076005)(478600001)(2906002)(70206006)(336012)(70586007)(426003)(41300700001)(81166007)(40480700001)(6666004)(82310400005)(4326008)(40460700003)(966005)(316002)(6916009)(7416002)(5660300002)(8936002)(356005)(82740400003)(8676002)(54906003)(2616005)(86362001)(36860700001)(186003)(26005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:41:27.0460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43362898-111f-42f6-f6f0-08da94dda327
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7383
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> Den Fri, Sep 09, 2022 at 08:06:31AM -0700 skrev Stephen Hemminger:
>> [You don't often get email from stephen@networkplumber.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>> 
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> 
>> On Fri, 9 Sep 2022 12:37:01 +0200
>> Daniel Machon <daniel.machon@microchip.com> wrote:
>> 
>> >       } else if (matches(*argv, "app") == 0) {
>> >               return dcb_cmd_app(dcb, argc - 1, argv + 1);
>> > +     } else if (matches(*argv, "apptrust") == 0) {
>> > +             return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
>> >       } else if (matches(*argv, "buffer") == 0) {
>> 
>> Yet another example of why matches() is bad.
>> 
>> Perhaps this should be named trust instead of apptrust.
>
> Hah, that slipped my mind.
>
> Obviously this wont do. Will have to come up with some different naming 
> in an eventual non-RFC patch.

Wait, this doesn't change anything, does it? "a", "ap" and "app"
previously referred to dcb_cmd_app, which they still do with the patch.
"appt" etc. were previously rejected, now refer to apptrust.

I've been known to miss issues in this area in the past, and for that
reason agree with the sentiment on matches(). But what problem does this
patch introduce?

And yeah, +1 for "trust".
