Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A7A637E02
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKXRFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKXRFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:05:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3074E2B1BB
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:05:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ts5CHlhhBl1Guxcnwl6S5UYwfnPcQGugbT78+m0XXSMk95uTGpcoHEeDMqj+btFHCHWKshFgeHCKvtAgoZerliOqH+BnlcKnA2uKTJr7mDx8JO+/gHMGq1UYJgHGKF9Rqyn9RJ4RVJPnf6TciZPKU+DAYX79K+vPAdhohPixW62gItJG4fjJ/ZcAXXpbia6yBalJMp69Kzt4fIoeSQM9meJfjDkY735UlqEHceF4vilvUoZYYG1u11yFNpNAdvxlcI/a1PwpziwVF+mbRIBwhlEGMcPc3o5sI8oGI8Ff2JBpHr6qI+K/knCFJDxdtdUQK/h2bPYuGjHgU8s96iICiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKu8/wquBNWgzzsZhgVDUL/X6r/vU8gciaZKQgoA7z4=;
 b=mqTeD2G28gS/lkvqCdo66IV9U+R2YyQ+QUUwhN8cDVYp6t0W2B1Ni++qwLiCZtwQ2lfbC8iG1kSiWrSrBBNziUtyHkLt2C2dixg/RLkyyJkcs1GTjdipyqR74iU4FReJH4/6JNl5zdHYbFYW3GxsTUrNHfGO2DG984iA5x53jYU2RdlsnzBLUzYl1AnSZeOD08M1dduiFTSVLa6IE/+oLccNzjkF8nuwEaZGgTlUSqAfnHCgvH14yIhTNsMUMukRpJIt6QyPBqQou9mJpBSmPcP+55xJVgoS4hTys5iqO7c5wsaRQg9oJt/jwCvF2naWnBi+YDWa8Azcm2xA0nuKDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKu8/wquBNWgzzsZhgVDUL/X6r/vU8gciaZKQgoA7z4=;
 b=km03U1l4OkHX0iuBFXQYpk0AXGpGNkVDq08cRU0tRSEMVjkDhKEb/8R0P7QnhmPwzFuq6XA1vVzdzrQ9YvsL8y1wzIsBrQvk7c3/XedeBr+QdZDMFXJ9A9LyZCQpG+d02ZwdSy959GjgWSQdPVhgyBLv+iu6GZd2XvzeSRVjpf1rSlaOA6US1WgpA3Ct1oq0HA03mpyKneRqxFm1euApgeIol1tLs6nGg13sQd1pnzmx881hBhswArGg7FdHd3wD2HDww6/q2TjnaB7Sqr94T9Sg5GKXy8HXUQXUm/k5QPXzi4wX9zfW9pM0/3F9A9C9vF9S/T8gBB8aGlleB1yYOQ==
Received: from DM6PR05CA0059.namprd05.prod.outlook.com (2603:10b6:5:335::28)
 by CH2PR12MB4937.namprd12.prod.outlook.com (2603:10b6:610:64::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:05:39 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::e7) by DM6PR05CA0059.outlook.office365.com
 (2603:10b6:5:335::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.13 via Frontend
 Transport; Thu, 24 Nov 2022 17:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:05:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:05:35 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:05:32 -0800
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-2-daniel.machon@microchip.com>
 <87wn7kibn8.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Thu, 24 Nov 2022 17:53:06 +0100
In-Reply-To: <87wn7kibn8.fsf@nvidia.com>
Message-ID: <87k03ki8py.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT041:EE_|CH2PR12MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: 1258f240-ade2-4592-eb8b-08dace3e1cd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2hEOcjDmZ1vQ2HK0k60LheO6l5zFF3uZx5mMYY1QihPFBFsONzjaq3Si68cCRKD3EQ8V03YKzNa3vDhC4LyGj8kdOZyQSHKbDvn3rrorm1hHlrkcUTG8slyGfwWUk+IVIeLMmtM3sP/YjQwEMlzZneE5FX2Shmxv1Tsn+RO/9v8n2zEdp9/LJj9N4T+k2Cn2OTGtWl4O5mpoGDEzQuRiCNZ9Vdb8tfl05iFW1E6cv8W30mwu400L7zK0p6VPfeH+9adzUv37tKp5TfB6phKP6Unv0B+3GnjCW03qkJ8PSE8p/hDns/KhlyxRlZLkbQcnGfhwHFAkx77ED8M+98+7LoD6e4bxTq1Y6qYWWaPP3F6ZH/y9JFV5YOVUnNJEKe6s2Hf+VvUXyEgj7TI55uMACCBOcM0InI9wCCKG5X6Nju40p6mxMAcsgXYIhvGYsxhoBZZ4BgydQjnGX04o7IBCigXZZTZkltKz1x6Z3QjRZjNu8TSeiTSCV46FH0a3cvwDEADys+WIFRruWqv6yxySsB+Vn3OhOMNEr4CjwUFeBD5COOw1M89hgm5ba4Uby4+ZgB2d0grJh4x8uzLMMB0QuagueZC9upQWcnYzcRUzks79J3OSj9fx+4p6Dl7bPD8YW+IxGmJpuDE2QdVr+Ve3J8wReH+QFYDZp4js+4/8OEc75aqLnS4MmjYAVT9gFht8anU52GLpKapyUN8bkrG9w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(41300700001)(5660300002)(4744005)(4326008)(6862004)(8936002)(70206006)(8676002)(70586007)(2906002)(36756003)(37006003)(54906003)(426003)(47076005)(478600001)(316002)(6200100001)(336012)(16526019)(26005)(7636003)(86362001)(186003)(2616005)(82740400003)(36860700001)(82310400005)(40460700003)(6666004)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:05:39.2056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1258f240-ade2-4592-eb8b-08dace3e1cd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4937
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

> This looks good to me overall, I just have a few nits.

Actually, one more fairly fundamental thing that occurred to me. If a
user doesn't care about DEI, they need to do this using two rules: say
1:1 and 1de:1.

I wonder if it would make sense to assume that people are more likely to
not care about DEI at all, and make the 1:1 mean that. Then 1:1 would be
a shorthand for expressing two rules, one for DE=0, one for DE=1.

If the user does care about DEI, they would either say 1de:1 or 1nd:1,
depending on what they want the DEI to be.

If you generally agree with this idea, but don't have spare cycles to
code it up, would you please just make the PCP keys "${prio}de" and
"${prio}nd"? (Or whatever, but have the syntax reflect the DEI state in
both cases.) I think I'll be able to scrape a bit of a free time on some
weekend to add the syntax sugar.
