Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB3A3D0DA7
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbhGUKsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:48:14 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:43424
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239962AbhGUKHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 06:07:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9BhgmA1sommKOVKqRYhJ1rbKAnUCZBWdYZdTyNqwukHkBEYs0yoNqzpO/mEtdHTOT3FBoKv+hNivv8/pti5Cr7WZA1O9h4efugiYmhFPKmAQZfIYabBMth+qfC0D3r1Zl+QpVANXs9sStKAt55V1KdkWZTCz+P04fLOKLWjCvWGoxhFDUx1LAwr/ltdEqMU1HodlNsJko4B14QoaikSGewwZxouc/KSXA+z95TML5uxRqBh7bg5DaCjK7WKZTC3FkEQvlrCMuhbPhyxVC36AxBfVG+tPj/tUAZrMm98yHIXWJG/pag2rtCLWGwyzf3dGhkZ1+uVSdp8/9siBnOmfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKQStHi9XmRFGKEp8YPb8x/mxzuKTn53ndW7eUok4Lc=;
 b=SL49sfUq6Yx1Y1DaSYb5mNAOJJ28oMxOZMsN8mdT/+1E19pXcVi1RuXjVGU0CyHuO21YmAYxAeY9G/MuNQC6QOZup2E7saUpeB/ho1hcGrGFLkfJKngXbnSmiuuG3Zw6Zuy1rov7ZeKVfo+HgJOeOnWRM6VhaQeb1MtXoJECh0hu6r9sNe5zwvgzoNSXhcYe8DG7sh6mGI4KOANxEDpjPWuChyvmL53W7tBmNRDLfzNoYFTNgD+7+WzC4t7/vGOkKIYUHFNjmVG597kFi0o90+I6XMkDCGeHPaKtuB+M5U58GL0o1FYn+UfCKaDCzkVQa2NEqAvM8MMfS2auzFoAeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKQStHi9XmRFGKEp8YPb8x/mxzuKTn53ndW7eUok4Lc=;
 b=bkTM9jOOAOKYoa3WWc/pHYHDrkBGoR7kp/yrBSMwQUajqyf2GZtAKOKqHeIl4VdENbTNJXfttGRMOYr3ZprCezkgBNrOS/eEpAa8nSplml7WbJg8p4mtFPSrno9MZ37ssIaSBSRSPBw0/2Yc7UgFLNLW8X8hovAO1+OBYE+ecaKa68kaYe1lkXcOKr4E2YLwXUGkbzewfyzppH5hl01wdMIttwSgHlto7JA5SqgRdMdU9DQwGyXaNvkgx42se6wdUqHVPc6Q5pYHGgLK+wxTliWOd2iE41XPd6eCi8oWvWD5/cJNbnRDVDp/59tLNaFgYw2fOHSnPzPvNECrG01rMg==
Received: from MWHPR17CA0062.namprd17.prod.outlook.com (2603:10b6:300:93::24)
 by SA0PR12MB4462.namprd12.prod.outlook.com (2603:10b6:806:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.34; Wed, 21 Jul
 2021 10:48:19 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::38) by MWHPR17CA0062.outlook.office365.com
 (2603:10b6:300:93::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Wed, 21 Jul 2021 10:48:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 10:48:18 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 21 Jul 2021 10:48:17 +0000
References: <20210720233454.8311-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net-next] net_sched: refactor TC action init API
In-Reply-To: <20210720233454.8311-1-xiyou.wangcong@gmail.com>
Date:   Wed, 21 Jul 2021 13:48:15 +0300
Message-ID: <ygnho8awq6xc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27a7c3f0-8b41-4272-b345-08d94c350d54
X-MS-TrafficTypeDiagnostic: SA0PR12MB4462:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4462F26F0059C18E0FA7E955A0E39@SA0PR12MB4462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MyKvv5ZQyRHp6MMSEqPYIKsxbBn3BVTdSWUx7swCxfqH4TrVmalC7TNvtnweWV3rUvlIQsSFVoEG0t7D/ngteJwgdzbmdQ236UDsvHgZz3tw/TsblER8iVuu1MP3uEBCycL7TGMT3ho6WF8NyZbQm4Lw8dQBqYdJpWKBvBMJLsYyBW0fReQPXQI2NP3kimvuulDE48azKjqRmxsy9q0Mh9bZdGoiH6gXF9wODsGcxcILceytQw8ivZe4b5b0NBAB5awXkjjwNWKUMuP0n6txEDq33QI1y/7UrNYlwKschS7AHGPq9qs2Mmk0UL/Xmw+Dgmhyfgb35eDdz2EIWQI4OiQGxQh/87Mi8t4/wvZxABoFSiHKb+10BE2wW7u1npLzeovFl6A4dYXcs7tBBwhWN7yhaN+jXtxKf2Aa+v8mJ76eKa1crO7+o/MbuDxo4EKgvE6jhTwWsDYlPK6XwCOX3bhfTKOfYruGZX9EiqxaNEgmdvKk6IWbIFbPcF3cpvpmu6X1TkJ50tRf4QztAdVJcZA/agox3l0o786ye0ZB+mYHAzJsBavJzT8vZYF1euuyjZHmy4+tSV31ehkMN5KHExgXKChKr5pmqOMKBEmx26RKyMRBMDh6BuXJZGRHhk47rM8V8y7SdnRTuQcDNvlPGRqq10rtX5rLJqyCkIqpVY0U3nxunSzPE4CHoWHanSxRQqh+Ep3OvRX7mSKCNKYqDQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(46966006)(36840700001)(36860700001)(8676002)(7696005)(36906005)(6916009)(54906003)(4326008)(36756003)(336012)(316002)(47076005)(82740400003)(7636003)(478600001)(26005)(70586007)(86362001)(82310400003)(83380400001)(5660300002)(16526019)(356005)(8936002)(2616005)(2906002)(70206006)(186003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 10:48:18.9108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a7c3f0-8b41-4272-b345-08d94c350d54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 21 Jul 2021 at 02:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> TC action ->init() API has 10 parameters, it becomes harder
> to read. Some of them are just boolean and can be replaced
> by flags. Similarly for the internal API tcf_action_init()
> and tcf_exts_validate().
>
> This patch converts them to flags and fold them into
> the upper 16 bits of "flags", whose lower 16 bits are still
> reserved for user-space. More specifically, the following
> kernel flags are introduced:
>
> TCA_ACT_FLAGS_POLICE replace 'name' in a few contexts, to
> distinguish whether it is compatible with policer.
>
> TCA_ACT_FLAGS_BIND replaces 'bind', to indicate whether
> this action is bound to a filter.
>
> TCA_ACT_FLAGS_REPLACE  replaces 'ovr' in most contexts,
> means we are replacing an existing action.
>
> TCA_ACT_FLAGS_NO_RTNL replaces 'rtnl_held' but has the
> opposite meaning, because we still hold RTNL in most
> cases.
>
> The only user-space flag TCA_ACT_FLAGS_NO_PERCPU_STATS is
> untouched and still stored as before.
>
> I have tested this patch with tdc and I do not see any
> failure related to this patch.
>
> Cc: Vlad Buslov <vladbu@nvidia.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

I ran some of our tests with the patch applied and didn't encounter any
issues.

Tested-by: Vlad Buslov <vladbu@nvidia.com> 

[...]


