Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9E3353357
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 12:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhDCKB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 06:01:27 -0400
Received: from mail-mw2nam08on2049.outbound.protection.outlook.com ([40.107.101.49]:18305
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236214AbhDCKBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 06:01:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE7KzwpNX9hJWQctvhKgzJnBhjF0mQD3VZqtvCYZhmBAPgS6a7jazPR6+7lvf4m1HVfRXmSoaVvDf6RWUHLOLN4AnHfqOGDKtjufAm+F8rPpp89F9rvhyIKDBpi8bm91SMDDnv6VPWOXH5v7kK4Zywi7hSh8ENYqJj2+S2tNkyMeF7Ggede4hiavdOu67GwaFlrWQGvSwf+f6GbfszZB4MdZyqZ1z7IkAWkrsiGqrQCXuvE9r4cpgYdln9AGojIqDB0vxIzqSjyoL2c/RztpDPpKFfGKQZ6LOuW3h7nUyB+H7Cq7fOgV0TR+z5YsEW4u3Ly01cAv3syqbJ4nTvJavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiLDwDUU/JQ0ZroYqzv1pigL+uoCMC1r96w5ylcnzMA=;
 b=gQHjH5Q1ypIsPQ1qwWIPa7ZcSfxD3ZtF8pJ8Ya3qSmyzuN0+/cVi++cBqpqhw/Kr7kQJXIs2DWWHmtXplcg8bgU/pk6TQBZgN+AN0Ma6qXISMCAZZF1WIoNwT0Sa8U7WzMkfARd1pA5Kiyxv3MTKZUxFMd5JTCqA2xuQzNwrzg58KN4Zh6zZTPvycJBRGh7/RpZufRHJlRmJmNgOlck+2pqP4fs/KPNhU2FHqVVysKyt2XR1YZqPVdivYH0ALGguaidR+nLiLDXjRfL5A4PgGAnt1rj6ou6wk8ZkTkbK+D5zHvvW40R7RHUldDxZvGseWC2jC+c67LCmcNWhNBIRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiLDwDUU/JQ0ZroYqzv1pigL+uoCMC1r96w5ylcnzMA=;
 b=jVUm40FWj7D/DZdaO2665a2vBcSNotJEWtoC9wEE62/MFS4sygCfKm/x0LXaGV/RA3kC3zSeDg/nqVgGtlIQy7fMfWcU1bxlNGwxElfLiyaCNYP5VvE44byohXnfauLcFOtVqZ683LIpb0FxrCj0lreZb+96VsxPXwp87mDkQbKTIdiprCTg5E3J/PkjQcaSLB4nA3+34kYQDC/WHv4+RKfGma394gDMyj1fY0hY37VEudnA3V7PpzQ4eawi+TWqGURShuIdXqLjv2NPWHDau0hLQlMzXooxrd8QutS6j87Z2SgsMByIYmhrCYAeVWtemP57QVLTixKv5IwhuKmk2g==
Received: from BN9PR03CA0443.namprd03.prod.outlook.com (2603:10b6:408:113::28)
 by MW2PR12MB4683.namprd12.prod.outlook.com (2603:10b6:302:5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 10:01:21 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::85) by BN9PR03CA0443.outlook.office365.com
 (2603:10b6:408:113::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend
 Transport; Sat, 3 Apr 2021 10:01:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Sat, 3 Apr 2021 10:01:20 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 3 Apr 2021 10:01:17 +0000
References: <20210331164012.28653-1-vladbu@nvidia.com>
 <20210331164012.28653-3-vladbu@nvidia.com>
 <CAM_iQpXRfHQ=Hzhon=ggjPJGjfS1CCkM6iV8oJ3iHZiTpnJFmw@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH RFC 2/4] net: sched: fix err handler in tcf_action_init()
In-Reply-To: <CAM_iQpXRfHQ=Hzhon=ggjPJGjfS1CCkM6iV8oJ3iHZiTpnJFmw@mail.gmail.com>
Date:   Sat, 3 Apr 2021 13:01:14 +0300
Message-ID: <ygnhy2dzadqt.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc6b68d1-f63a-4840-4181-08d8f6876e63
X-MS-TrafficTypeDiagnostic: MW2PR12MB4683:
X-Microsoft-Antispam-PRVS: <MW2PR12MB468371E47B156BE0BCA452A2A0799@MW2PR12MB4683.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCwdgPcNCtkeui24Aa8dhMtCjZZMOEVVqTxe+xT4Cvy7DEy71OfH/NmUrzIV14lVd+iVqSzP/yifPNyapYI84IBp6onKQAfIwEnzPG2UFpo3Z0HloTRM3CXcXZerrr3Q0GsyqVn6Z8/bavDqFLwkInrSqVMrV3gzQfINXhuEAZFHxG7A6GR+oGHszVkkFZ7Uebol2w0pJIuGVrxiUUEEc7EyrjDmZnyCNRBRqTVhrATD3J+hfIu9xFIwQTqpzFpyf9CININzfkDYU7fn/zQsUHr5kYwBZJHw8jL5Pd0yCwG1DDSNhqOVESgaKIzeyU4l9vekH5gCblluj0HD4eCoiguuWZWru+l5eDBhpr8Jv1ZYoqmveWriAIMVaYHVm72GwB3N7ssM8aFMgX8Baj0BBiJ6C4WApZViFTT4Ab9/o4W9qO4R1R2OS/aZaexxyrOpaE+2OIC5Z7wvPzwQ1VHj11dP245vhfwsjgdAMinJFqxJG3+DiAmwq3yY8GkRjHvcn7m4q0hGv2Hk3DN2RHOC6WGIIz/8EhsKPCoU3afwUNDczA3004rOUk/or2YGPhPjE8hozxobkgbPTY6wtH51kOnI2++cXeSj9pi06THYEJfu5NhMc3XfN7VzYd3fwN174dfKcTQ2rtcl8LprhIGS8Zr0O6ATV0CVNxkzxAd/MNE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(36840700001)(46966006)(36906005)(356005)(54906003)(53546011)(7696005)(478600001)(4326008)(36756003)(83380400001)(8676002)(82740400003)(316002)(82310400003)(6666004)(7636003)(6916009)(47076005)(8936002)(2906002)(86362001)(186003)(36860700001)(26005)(426003)(336012)(5660300002)(70586007)(70206006)(2616005)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 10:01:20.4322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6b68d1-f63a-4840-4181-08d8f6876e63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB4683
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 03 Apr 2021 at 02:14, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Mar 31, 2021 at 9:41 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>> With recent changes that separated action module load from action
>> initialization tcf_action_init() function error handling code was modified
>> to manually release the loaded modules if loading/initialization of any
>> further action in same batch failed. For the case when all modules
>> successfully loaded and some of the actions were initialized before one of
>> them failed in init handler. In this case for all previous actions the
>> module will be released twice by the error handler: First time by the loop
>> that manually calls module_put() for all ops, and second time by the action
>> destroy code that puts the module after destroying the action.
>
> This is really strange. Isn't tc_action_load_ops() paired with module_put()
> under 'err_mod'? And the one in tcf_action_destroy() paired with
> tcf_action_init_1()? Is it the one below which causes the imbalance?
>
> 1038         /* module count goes up only when brand new policy is created
> 1039          * if it exists and is only bound to in a_o->init() then
> 1040          * ACT_P_CREATED is not returned (a zero is).
> 1041          */
> 1042         if (err != ACT_P_CREATED)
> 1043                 module_put(a_o->owner);
> 1044

This problem is not related to action change reference counting
imbalance which is addressed in previous commit. The issue is that
function tcf_action_init_1() doesn't take another reference to module.
It expects caller to get the reference before calling init and "takes
over" the reference in case of success (e.g. action instance now owns
the reference which will be released when action instance is destroyed).

So, the following happens in reproduction provided in commit message
when executing "tc actions add action simple sdata \"1\" index 1
action simple sdata \"2\" index 2" command:

1. tcf_action_init() is called with batch of two actions of same type,
no module references are held, 'actions' array is empty:

act_simple refcnt balance = 0
actions[] = {}

2. tc_action_load_ops() is called for first action:

act_simple refcnt balance = +1
actions[] = {}

3. tc_action_load_ops() is called for second action:

act_simple refcnt balance = +2
actions[] = {}

4. tcf_action_init_1() called for first action, succeeds, action
instance is assigned to 'actions' array:

act_simple refcnt balance = +2
actions[] = { [0]=act1 }

5. tcf_action_init_1() fails for second action, 'actions' array not
changed, goto err:

act_simple refcnt balance = +2
actions[] = { [0]=act1 }

6. tcf_action_destroy() is called for 'actions' array, last reference to
first action is released, tcf_action_destroy_1() calls module_put() for
actions module:

act_simple refcnt balance = +1
actions[] = {}

7. err_mod loop starts iterating over ops array, executes module_put()
for first actions ops:

act_simple refcnt balance = 0
actions[] = {}

7. err_mod loop executes module_put() for second actions ops:

act_simple refcnt balance = -1
actions[] = {}


The goal of my fix is to not unconditionally release the module
reference for successfully initialized actions because this is already
handled by action destroy code. Hope this explanation clarifies things.

Regards,
Vlad
