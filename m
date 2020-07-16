Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133F7222859
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgGPQh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:37:29 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:33603
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729253AbgGPQh3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 12:37:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVM16umzB6vpCWrRImIhbk082LscjMsyQaViqBa+AwI5P58ZUmfV/GM3QPOefTUPvKrzXrnrY3WJQ3sP0iiTWek6tS78Nin/7d6ORMUrr28eK4p17JE6Ok6+nkPyQDLTsy/3zDlwXSPVwqsEdnMG+IZpi0EBr1mwV2bcVy9QQXWw/EUBH8KzECIMfTfHqv3iStBWUObuC4LgTN+FDJiJzYhT0GX4tmzfRJK3fHXeBTEHkx2kEfffM9NVGwxs9pqKeIx2LCb/8vMRsk33E/o4+EwQOgMoPuzIDh7VJC+hte9SEKGEEFak1rYPdkc975VNkEuZ+T/eRd6xWjdLWHRCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZLSEJ75AhjpDs693+sm+qUTxgClM4+AWmu8nWeJLDQ=;
 b=GnIsfNGwvEv6gh4c8ivhGK+prTtmcnb6HDPMz0FkD1yZgFGKDktWTbrnl19QxtuftL23PyjQJqwR9psrluIhpjXEZX4VYEU9kp4mg7tbMrGFNmeiuGqGAtSy2YR92T9PJQpvEPTHvrx//ZP87UKuT1BL+fzCzvNwhK4cW3r+bs7O3OagIudRD32PoeGVchxoYfW6B7R4i7NpVcUCqPYrznd2R237xd0rl8f+E7XWtKxoLZpoj3RkC9uxU2kl6/pwI8u2zJPswfvuhb4JR0naz1TG6IVBbZln5O7VtXGZr0Nn1LBAVqp5iPO8B+l268AK8upcNmryyT+KhPlxMsJ52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZLSEJ75AhjpDs693+sm+qUTxgClM4+AWmu8nWeJLDQ=;
 b=eR+MzClil1r0eNAzG7FA/rU9a7p/xusJAvAv2VRypS9Dn2w+YdfnHsdsiomuwnZuMcT2LChkh3f8by7KM/+6jPfwMZvbej18h6BK0bhEN06eIUiRH7YhrwfyW5xp3DU/iLpER2lqL4JaFufwf15bQ3WhK44ffnjrIuP8DmObAfE=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2684.eurprd05.prod.outlook.com (2603:10a6:3:cd::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Thu, 16 Jul 2020 16:37:25 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 16:37:25 +0000
References: <cover.1594914405.git.petrm@mellanox.com> <18f80c432a0d278d32711bdafdd9d2376028ad50.1594914405.git.petrm@mellanox.com> <20200716160729.GC23663@nanopsycho.orion>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/2] tc: q_red: Implement has_block for RED
In-reply-to: <20200716160729.GC23663@nanopsycho.orion>
Date:   Thu, 16 Jul 2020 18:37:22 +0200
Message-ID: <87mu3zifgd.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0010.eurprd03.prod.outlook.com
 (2603:10a6:205:2::23) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR0302CA0010.eurprd03.prod.outlook.com (2603:10a6:205:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 16:37:24 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b50d0a25-dc9a-47e7-6cac-08d829a68515
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2684:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB26847A3ED8156A555C066193DB7F0@HE1PR0501MB2684.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aH2dzoG7ZE62/zZR2LVyjgzj/i+fEcR0D/H/TLM+HRVaYGg70cH0DLlxUi/9sScfivHryzUuL7rzbmNZasDwc1AmNXeyWozBcTbdzuKZbEJhIlu3ChvuZ4i7vOkHGVPFhGClhK4P+LfvFMZipDerDAfW+oES30l3RwwhMtMybcvierpsBBbZYS0gchOA5keKuBSrojjtnFUlJBZ6JQzQdpJMYlz75lUABzLmjwdFlwmF0Xpo0bvt1GJbJ9K42qvEPyOIhS1Och2wy5KIdcnmpketGKf0pFWxk3mOOxDAVXnjlwN2hV7S8P4rHJpD7IDf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(107886003)(956004)(2616005)(36756003)(2906002)(52116002)(478600001)(54906003)(8676002)(8936002)(6916009)(316002)(6496006)(16526019)(86362001)(186003)(5660300002)(26005)(6486002)(4744005)(4326008)(66476007)(66556008)(83380400001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uhN9DtzIrpLbofQDgMxssdXni8hM8CYeJFUoOrxubV3MUvJ5Uba2P6kg69LUaL57vrv30k+jKr2+8m7lDjtzZisyO50Fq1INUIS+EtzFFYuJrxELUVR0nbdkBqxD97aqGHknw2XvMpyuBxVsqo1SoU2JzF6X1rkjru/nRW62toOc8DIh8hTb4FLk5XvRr2SFNEFKPKCWKKHSfcQ/xk8tyYoI21QQI4vB4zi3Hoqmq3Jdw5zLkXlC0hSEiG55CPSRsSW4DP2wY2eX1V4A5YRgrA7pHucwpQoXD5Pd9ntAMwT6Ar7qiLMv3rZprVGHuAdFNfyCTQVG1hN2JnZBwa5YC1kmpb/Z5mkdf4435zWRsdrjvvLi4dPjvEvjYyQy3VR95ii512EsseBbYbMUBsG1zaIQ2oCgwKxiQMip47NJxkdBW43slb9PWhAvoCjLFpU93AKAMwJbe1xPTGUaTYLoFpK485l8/SEBzdNDACT7lye+QRI8OEkeT708ENNbNiOb
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50d0a25-dc9a-47e7-6cac-08d829a68515
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 16:37:24.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 184Drxp8wzgJ3VeRsKRhUx0Gtxa23NnUY9qfW4BKWYSn/O4Hp6wORkg4zojhxy5MTPXUvj9Gf9ITaDaNfAdsTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jiri Pirko <jiri@resnulli.us> writes:

> Thu, Jul 16, 2020 at 05:49:46PM CEST, petrm@mellanox.com wrote:
>>In order for "tc filter show block X" to find a given block, implement the
>>has_block callback.
>>
>>Signed-off-by: Petr Machata <petrm@mellanox.com>
>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Actually it's broken. When there are several qdiscs, the latter one's
result overwrites the previous one.
