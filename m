Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F013513CC
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 12:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhDAKmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 06:42:08 -0400
Received: from mail-eopbgr1320109.outbound.protection.outlook.com ([40.107.132.109]:26816
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232565AbhDAKlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 06:41:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6QR7E0r9BzwHXiGwg/5yCTh5k7vYOgsGlEW1YKGbHSff+inLdC1E2EdjghYRprs1PwlNcaTSssUsp3rimSLCqCSUr3XkEUZYAY6i7XXuCH2UTjDaUMedM8FfXsppMFKdBx4VSfGwDbJR0PekGXrDfWq0hmGbDwGoPvsqTI2XgcRLKT9LEJE+tJJzvxRbKzMmzVClUM1SdvcdIu56kSMEux4OYVhj9unRu1R0fnzx0QEysUaMvX09CWLbV+uOo3EyoA2y+WFDIzieiIg7VbjfH3e7/5V3SUF15vGtVUivq8ekQ+5HAS5bex7LUaRI7lCwAvSxjtQ1nQPTOfIuHozUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAL2O4InHbzP2qDkKsLc9L2g7ltSwqcchpfGk5cVPoU=;
 b=LXEwOnV7cXCtZhyiqe8HKwJHZ0o0O6mcWqmn20cr7gZ4f0RAt/68NMY3eFgPhntoRdh3khPBgsO5N4fVQEfa8Vms5Ok3uptNVDATuaOEVWrcNzi+XEWXxb6N1a2W9ADwLuVsMi4lA/rimrF9OJIt2UrxOduHv/6W7w5b7P2lOss+xEOLcEElql4E9+bcykTTBx1qLS7a2x/Iz/ELk3QwiIZ5NHeouYZdQbhOmwaF/NR7KYWs1M+lu+HlZms9acvWjN/8IMrVc4VwB4EZMrxY0BSoiiFyyRgFWlRyeg0XosYuorIoD/T0fJfzmAz3WZiB0Ofn0ucPSQsu8H4GKUgMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zenithal.me; dmarc=pass action=none header.from=zenithal.me;
 dkim=pass header.d=zenithal.me; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenithal.me;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAL2O4InHbzP2qDkKsLc9L2g7ltSwqcchpfGk5cVPoU=;
 b=JXKOzG0gsRICjHUij/vTMCfc7oqwt4sqHwMeYGMfoBR496jIeMVwxkjTR8q9MOPqkitBV9fZzDwH5HDKNJiIMtE9Vx/w0KwJ6OceihdW6f3NG3Amje3DqAYBJNvY6ayfGi+l6CZjwXMpg7cC/UYNBHm2iZDCvcOKzi9AYoO6FFs=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=zenithal.me;
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com (2603:1096:203:3c::10)
 by HK0PR03MB4883.apcprd03.prod.outlook.com (2603:1096:203:b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.15; Thu, 1 Apr
 2021 10:21:57 +0000
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::8492:e28e:e777:6d05]) by HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::8492:e28e:e777:6d05%6]) with mapi id 15.20.3977.025; Thu, 1 Apr 2021
 10:21:57 +0000
Date:   Thu, 1 Apr 2021 18:21:56 +0800
From:   Hongren Zheng <i@zenithal.me>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [RFC] add extack errors for iptoken
Message-ID: <YGWexLzHmm0YgEMR@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
 <20210331204902.78d87b40@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331204902.78d87b40@hermes.local>
X-Operating-System: Linux Sun 5.10.26-1-lts
X-Mailer: Mutt 2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [2402:f000:6:6009::11]
X-ClientProxiedBy: HK2PR0401CA0020.apcprd04.prod.outlook.com
 (2603:1096:202:2::30) To HK0PR03MB3795.apcprd03.prod.outlook.com
 (2603:1096:203:3c::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2402:f000:6:6009::11) by HK2PR0401CA0020.apcprd04.prod.outlook.com (2603:1096:202:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 10:21:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17c3463c-0c79-47e4-2ab2-08d8f4f7fad2
X-MS-TrafficTypeDiagnostic: HK0PR03MB4883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR03MB48835A3A383D168C932DF04BBC7B9@HK0PR03MB4883.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SZxrecwWt7sq1hbyb8NfAP2NHz4jzAIa5lbH+iXX2Onp6E6CHBPsCb7n7SnqODxxmCLKfuilJ9v31toJIB3UMrW0q4OexdP5dWfpHq803qq7jmP6/++ANngiakS+JgSv8AWIfUkNwIKYzFNU50sB7dFevTmFsCEevywyY8R4F/qAxDgH5EwyF3yA9VoEbjFSvBUZRJOpUc3T36c2p26QliaTNOnLHjFSotnaaIyXss5UOi54N6tH0oBzp0RlJoQSGCAJmn/WHr4fuzJT45OW2TQG5RGHdQccCmIGtI+VguLWfdfg9UmRa95kYIvrzExqd/2xnPlnM71w2fUBUnxgUobTDRP57u1QBC7rxPaeuNBUhsiwaP5VLoHS2ArGDMEr/d9cZSsM6iIphRZ0ipgCEwcCGn9e4Is7r/aKdD3TNTYT0wk/9AwvUHcLXLD20pB97p+VIp2gH/LeVrKx/Zdno+7NACfeHKXEXLX6OjpN7NSYf0QfwW9tuB8X+ccj8T6Ovv7SVr5b/OPpuQjvMS2NNGkyHr+Xtu/PhXqvg2U0yL1d5E3DrN48Wm9JmLYuCkLve4mOPTaIbHCgVkh9fOftJTHb3NsfAZdmc78R/Zdj0OPFsuG/ppTSwQqZK7x/WFDc9M3ks540Njg32+w0Oy3izrGqnEnusVhl+y3B2t7ra4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR03MB3795.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(39830400003)(346002)(396003)(376002)(136003)(66476007)(66556008)(5660300002)(86362001)(38100700001)(4744005)(6486002)(8936002)(478600001)(8676002)(2906002)(186003)(316002)(786003)(9686003)(83380400001)(16526019)(6916009)(6496006)(66946007)(33716001)(52116002)(4326008)(49092004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Dg6PhcNALmrxURlVODE/ZHA5OnnfbLG9eMjvgXFyABkrJkkdRPvbM/xfFwfa?=
 =?us-ascii?Q?p5x2amBQ0N9i/kGEf0p5InHPFKazWirM7aMWlzcudT2Mcs50Uvae2hXM0g8U?=
 =?us-ascii?Q?en3qIqnuNN8tp4m92Y+2z0svBcXidzvEDLa+RrhKCE6v4+QXnC2r2o466Mkt?=
 =?us-ascii?Q?knVcaok/V0AK68lbu6X7sKkGvg5QcHT08CrWYKS3qHqMwQ88KQeYszPL75kQ?=
 =?us-ascii?Q?bAA40MHMGex8s7oVCD7+o2YJPpabkgdWwMh+NVnkd0ccJSAP+X33a1pmZBYM?=
 =?us-ascii?Q?YAXZI/xfjnhkveFLM+9J80S+BT1OamkiZTojJjktyEmHW3KzhILLjo4ATMh+?=
 =?us-ascii?Q?XTkDJsdNRTvViRZz/x8Zc3BqZEz/FsfWW7Wv1jUbtyWK3BVxG7W6m89WjdvB?=
 =?us-ascii?Q?q3Nc+W6iY4KbhszS2zBsG4P+8E56yk+HgVI3Xf2PYcsd+KPeZE/T6t0O0xGI?=
 =?us-ascii?Q?tR1Q77GK4gXM82fA7nyrcFr+sUHM4eo2q4OS6DTLxf7OX9QFNWlSnwV8PheI?=
 =?us-ascii?Q?nHhGNrI11LKkoh0YUidN3blxCiCU6YXOSUy7MrcGVU4UqbaC0KnWBO/1dNhQ?=
 =?us-ascii?Q?nhYOXog9O/Zeoo17KC1KsUwidcqKO6dtaG6b0ZErqUQy0ISqbjZh+QQ6ThS7?=
 =?us-ascii?Q?bqSGikYTnfjFYaze/r6hcHmjGszYZFKRcp+xTgzA//gk6JxoTUQi414wM5RM?=
 =?us-ascii?Q?FHwKWK7h6MBR/d0wDGB1vCt5TA/6AdNb9Bh0G9UPZkOWPWo2pGAEojVI3jvg?=
 =?us-ascii?Q?w1C8pTOwPWX7w4cOZQ9BVYt1PlxnNIxK+ebjctfSWTYhdGACZAarOTi1AxIo?=
 =?us-ascii?Q?t3AKbFxYrB8yej/yamZvfb3sr8u4pGAI8WxMQGT2Tb5LWYup1eiHOaXSDbLm?=
 =?us-ascii?Q?UecXmiD2JrFkewZWWcL5bTNGt3ZIcxOijtSqlnaF80+TG4PZ7gftSv9iwRGk?=
 =?us-ascii?Q?sZ4zYyGAcovkY40kphlLW0UMgJ75XNXEQWB34uh/XJltzvYshQvgMzCq2XwE?=
 =?us-ascii?Q?UhLmB3rRBFJ1xfW5LdZqRZ1FDtk1WIyb5lwx3LL4NLN66pXPtuu/ZQOob3L+?=
 =?us-ascii?Q?sl1gIFqqIOG/BVrceOCoZi+QoY7wLC9jjqcdH6VT87HwXmPILOrUmMf7+38c?=
 =?us-ascii?Q?hePpyx6tcfn4TfYq3Qf/1OcGnAuRuSnAN3kkX81sPH+gOn8LE8vyDtYfTPi4?=
 =?us-ascii?Q?eQ8Fhzb1pKi/PMoblBZ4YSqdZMcjGQlYvxD1lKvXzvgHFBYd1pLz0/rTtRP2?=
 =?us-ascii?Q?xT2vtjxCIHPqS/G05Nubpv528XxNywxPAsMYtYO8a6mQNTa5kUSPQB0tItS2?=
 =?us-ascii?Q?KQ+N0ReXY80udTgeth5e3K5KA1xpbioXq6Ww+QCud4sqJg=3D=3D?=
X-OriginatorOrg: zenithal.me
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c3463c-0c79-47e4-2ab2-08d8f4f7fad2
X-MS-Exchange-CrossTenant-AuthSource: HK0PR03MB3795.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 10:21:57.8130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 436d481c-43b1-4418-8d7f-84c1e4887cf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7atdNTUJHKhcZ/eLUU7k3buZ4CRyTOqcEwqcW69+Npzv848MH6rZ8aeVICwIUabz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR03MB4883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 08:49:02PM -0700, Stephen Hemminger wrote:
> Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
> could be added.

This is an elegant solution. I found extack is extensively used in 
the other parts of the kernel code for similar purposes.

I also checked the code of iproute2 and found a good support for
extack.

So I am OK with this PATCH.

Also I tested this patch against v5.12-rc5, it compiles and can boot 
with `make ARCH=x86_64 x86_64_defconfig` config in qemu.

I tested it with iproute2 and found a more friendly error prompt:

    $ ip token set ::2 dev enp0s3
    Error: ipv6: Device does accept route adverts.

Tested-by: Hongren Zheng <i@zenithal.me>

> +		NL_SET_ERR_MSG_MOD(extack, "Device does accept route adverts");

Should be "Device does not accept route adverts".
