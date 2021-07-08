Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7073BF5E2
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 08:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhGHHAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:00:16 -0400
Received: from mail-mw2nam10on2050.outbound.protection.outlook.com ([40.107.94.50]:32548
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229832AbhGHHAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 03:00:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj3b/Hzb4GVnqw44ungLPiDpMxhCvapxeNLlp94gCxZ9K+kJv8YCHAnHioZl3YlHR8/Jxv7lz86nqLbj49444bxv1xqzt7B1RYaAO6v3588gqxMRZ4dRC7mwQhkx2lSLeZCPpD8X+PEV5FXvPBjTPrm3Bp2x1l824C60k/MtE1edytCD6tXEblSox6TTaJYIG3HpEJtsOixy6FWs5N53HJjG/STXHB2SLQfTOl/y1N0DfvYT4bu8DkbDm8CBW9Zsy2m6POqGfS2CJdXPFwmTLcMs/Wjs/hN5mr7oZXvxMROkhBgGENDRtbNiaWouVaal53biFgSzwpbBnqgFlO37HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lASPTMhYQcAU4JDmELGF+KRp0l344fpSAqacDDZjAKM=;
 b=QK54chDBx34LJLwchY1b/dJpwIopckfHWqiOUYpoyszYkjO+wEw2/nFlS1JYFkbNXXBqmnLcD0TxXi4P1UsmnuTsaN0w1m4YdkSM3mpk86M+EiAyXLRdDFWs7F/qMvac2c/KVbusr0JHqzGlGj7GAG16Limlx814lX3DeJqAfrMZrbfn+sJa66/tbKBL/pVAxSGjSJzPHAu0gIXSPHPZGYVVyRdgkx23hcBUzaTY6qbBeAIeEV0diRPtp0tNB73tfmGGt+cQXssmInGUsR6jwVjnmFkTgQl/VpGkP6iawUijZdORLRiwETk7s2QOl9QAPHiTYu3g5OI8y0VBW11R8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lASPTMhYQcAU4JDmELGF+KRp0l344fpSAqacDDZjAKM=;
 b=fdcWxMmvp7bJvWqr88NnK32E0D4UXGQGXxg9w+2RNWUd0BdhuIUpfGfaYLlbqFEB4slz5BLuBaMLRRSmicYmgva4Hb8OxoLL4hlc90qjT7ZTD5njC9io8RzBSQIZ+8Nmg5jbEKWDeHYX6WScLA41XTu61PIwKrT/u/LsNwt7HpvnVLsf31MWWOKk4P8WdDrxsr6yB9jiiqUhkT6HkwMOLmplno1fEOkcoEvtUDs3DhGYVKTSlg0VGMLVdN0TyzVOdBcE2HuWz2aKRfokaufZhfj4lwcMC2lJCDsoZjJ3eb7lI5OGV9KM8VytHYiLkVCPTDvJfD4gLceW1ydW7OSNAg==
Received: from MW2PR2101CA0028.namprd21.prod.outlook.com (2603:10b6:302:1::41)
 by BN9PR12MB5366.namprd12.prod.outlook.com (2603:10b6:408:103::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 06:57:31 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::ff) by MW2PR2101CA0028.outlook.office365.com
 (2603:10b6:302:1::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.2 via Frontend
 Transport; Thu, 8 Jul 2021 06:57:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 06:57:31 +0000
Received: from [172.27.1.80] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 06:57:28 +0000
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
Date:   Thu, 8 Jul 2021 09:57:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOVPafYxzaNsQ1Qm@fedora>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0850511-bc15-4877-2ce8-08d941dda841
X-MS-TrafficTypeDiagnostic: BN9PR12MB5366:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5366D8DDD597121AF70C7B0CB8199@BN9PR12MB5366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpmrEW8MminUfo4EFHrYpo1PercgKOZk9/REaqJls3GAARgDhCxzmelnCLIm2teCOVqWj/MooaWJf1ZNT2gGatVCGxO1UV+Mmizs/tvRI3aSsE4AuXA3lHBbuCeoUhblbI4r64QXP4AaGiMpccWqo2WHOXwPztd1/VYpxRYtM0SXb+TF+aMf6+8mmf+9a24khSmwCXhrqi/gPIHm4HacyyT439dwpshggmJKGmGsQuo39HvrKAP6EJOSj1R/G/l8//ORX4WeZg8Qa7ouC2z6J6atTvcc/PApsr+Eur12UiwB1Hq8jIZMFIWXMBaLHvHAzHWqv9ip1+H93oSdZ3VrMQWYAcYhXjPvEmvL8AOt5pXn+Ypqu18eS05b6aswk/ORGE1IqKMBEo3qWbnRiL1D5DxEG29a4WjQ0e6cwLxiUiFn1mO+RxkGQlrdW3h/PRBJceJXv8mfYPvF89jpNBpjm2OhKsArEdNmHt/R2Mx02DZsR9IrlnpHXgRVBfB7mmTqWYN7Mu/ltc3ReYhqZOlu9GOJLhh3d30NCVR/G8+5Vt+FB/LBdyZnx71xV1IUhdrNYps+McUD3ihFpSsscl2YnpYvMmbFo7uH4yWb23IhCTRsIzKdA8M4dMevX7jJaIQpA88O76sQsFUUpjkOK9hgPmlonbrZbkLlBA1vjMfJw7KG52ttvjKGLUhrinGknCh22VdnWg32jzq8HtTb3K0fVwTdM4l8YTc6/W+xo1VPTVY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(46966006)(36840700001)(26005)(2616005)(31686004)(356005)(478600001)(336012)(8936002)(36756003)(426003)(8676002)(31696002)(83380400001)(5660300002)(186003)(16526019)(53546011)(86362001)(36906005)(47076005)(82310400003)(70586007)(316002)(54906003)(2906002)(110136005)(4326008)(70206006)(16576012)(82740400003)(7636003)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 06:57:31.5237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0850511-bc15-4877-2ce8-08d941dda841
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-07 9:53 AM, Hangbin Liu wrote:
> On Tue, Jul 06, 2021 at 10:27:34AM +0200, Davide Caratti wrote:
>> my 2 cents:
>>
>> what about using PRINT_FP / PRINT_JSON, so we fix the JSON output only to show "index", and
>> preserve the human-readable printout iproute and kselftests? besides avoiding failures because
>> of mismatching kselftests / iproute, this would preserve functionality of scripts that
>> configure / dump the "police" action. WDYT?
> 
> +1
> 


why not fix the kselftest to look for the correct output?

all actions output unsigned as the index.
though I did find an issue with the fp output that you pasted
that I missed.


         action order 0: police   index 1 rate 1Kbit burst 10Kb mtu 2Kb 
action reclassify overhead 0 ref 1 bind 0


You asked about the \t before index and actually there is a missing
print_nl() call before printing index and the rest as in the other
actions.

then the match should be something like this

	"matchPattern": "action order [0-9]*: police.*index 0x1 rate 1Kbit 
burst 10Kb"
