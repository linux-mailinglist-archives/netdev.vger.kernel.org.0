Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEE7668C70
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbjAMGVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjAMGU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:20:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAFF5C928;
        Thu, 12 Jan 2023 22:20:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGXWNrW0DXRSpqsxZ1dXY7iaC81wOxOK3ZtmYWdwv6rWlDQQB9vDelwuuTFqFnYJ+TTsZEfvWyF+N+MOtv5e3whqkx4i/kwIN3LwKQr5DMRudimm3SVo73cuWwPSn02DK6Ek/1CuwYWI7N6QTMFmtBqgP9CG1XVMRUXXu2x7Nn+0YzH6SW3x3nN3Pu0tFHQ4uWOnO5gYwH5I5/VyqW+r/Vjazoleemboxto2xzIpYMg08hENSzq83Yf4Qi2i+L6t3AcFuaMPffVdCFr2JMgyj7AfD8lYrX/U69XYrpxWIG12H1fh1DblSmaOZyqlWAhFl4KRAD/FwUoPVYv77OnCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKuxlAI6YpDtvn/krLpVz+hzEwh7xhIX12pLy6AtZCw=;
 b=df71Er9kqd3XR0ytugfyPUl4TUVI8Mg6SoEKOIm0rmNokYNsWROV+lIZ7w/IV3lxUDfj6VxOnIqbYTDo0I/tYTr48XQ4txaYvK+ked6b3Dx00HGbHVbibmPg64MEw0oSCPdHOfQX1plEEs5WbvgVod7b13N7tXo2vMx5MMlhCylLF3x0L+ugcoET2nyGP7xbHKmYTHouuG92oZP2C6lZHQ6Cug+2CkTjaGegU3/Myx4qcTvFrmQd7LY9yXPm/xXTNKfBzKLV8IWU5Ohg0zG5TZPrU2tsEj7Kyc79AFK3m+ByP0JSJvrg18KMeTRgcr2awPJFjI2dNKoTFgInuHro2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKuxlAI6YpDtvn/krLpVz+hzEwh7xhIX12pLy6AtZCw=;
 b=a1jRCxT97Q8//ZrBxmB5bClzJvFQ7ieP5Y5wAGfW9sxtene4gZmyRLMEmqTY3RLVQeMqAQxiS1U2fR909IMar1h9KfRDO3WK9gXpj5XLaVt8KiFam5k7rNdWWhklotEEUxFg5mhuCuLoWslvckfcJNuGy12RqxbI3PKIechJ6RDYKldEHzP1LhwFqRlU49fN7jkuW+wsMYYt5+1C01ItLgkvcwt7OOthjnYEuoFl6MwdVgvqJlK3QmH09vt3QPIZoZ0QFn+Puaav71LjsjPV8cW2fdKEa/1ur5gOnhj0ZSthBbaSEy1DFJPb0itfQDWObUGBae2AMwgAP8TU7TYVmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 06:20:20 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 06:20:20 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [net-next PATCH 0/5] octeontx2-pf: HTB offload support
References: <20230112173120.23312-1-hkelam@marvell.com>
        <20230112210738.72393731@kernel.org>
Date:   Thu, 12 Jan 2023 22:20:06 -0800
In-Reply-To: <20230112210738.72393731@kernel.org> (Jakub Kicinski's message of
        "Thu, 12 Jan 2023 21:07:38 -0800")
Message-ID: <87ilhbx8fd.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:a03:80::24) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|BL1PR12MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b274341-d2fe-4ec4-dd9d-08daf52e3f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hF3D1J2C/8YFjSb8XjoaLaV+5Q28u2hlXw69o5nfNQTBfWdGGWtwJN8ftLsC2aVKsrzW59FsC6bqiAYKd+Jw51Mch4kEEt3MZ+k4qAUd4UOHkF3xbTNaPuGhlqaPm+du+ZcOApKbgqB3xzZU7EWGBN9KeVK06cyqJn2vdZKyTYMlTOtCm43K96xluq0Owb+7e6jy00n6PCeQnIV8bbh+yakYqEs9Lkofuo3xlLtFkqc5CFGtbroWVRQN8isOW19/67ILCEDKhyhNQUr/SJIRyHPGHFofblqMI2NNkgPA0NHmXTp/nMIMw9bUL2D/s6oxNGwKaW7labP/zl1WwPEtiZNlAbcUt/EK/uNUVMnnjU7WxoD4UZxGj5q8JZ6+yfaR7utRS1mfiLQcBKaziOAjRpPw3lh/qg+cNNEh/fiKmZ8tja0JtKKnx6UKumVo4+00QPyhQ2az7C5uDuzSh9Nqv0EQBj5HOHvIiUYyiZAWsmO8m43Y57xrg0xM/DHjUBQIAXJMnR9NlqprXiZ2EH9zoBsJLfH61dLIuy12ppxvkOKEVO9u+RZxMUo4d0EVbj9GTHLQWIvCme2AS0nmRxiFc/HzHxYNfAtKkOECxQEGMh54CLXJJtCz+gPJisKueODJzkumUVKX42FbyudKh3t2EclpmeIcar1IbMWOxfsH81RTcxWrfkmZsW/61Kcux7l1P77dPJRzJCWtpvn4DK61JQzMaxfmMGPhNiw7kFnP8Tc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(478600001)(6486002)(966005)(41300700001)(6512007)(38100700002)(86362001)(316002)(54906003)(2616005)(66556008)(66946007)(186003)(66476007)(36756003)(5660300002)(7416002)(6506007)(2906002)(6666004)(8676002)(6916009)(4326008)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GOMRKLKqVCqa74zgQ5ORnKkU47l9IPT+NCwRZLSpvUbeTFcEhKDaiDGQDG/9?=
 =?us-ascii?Q?4gEOuxUVP3l0kcXsiVBaCpoVGkuQeYmv05dhNmFxDk+8bgoPr6p3Hpiy15X+?=
 =?us-ascii?Q?duWYZTy9V1hG6lxlXtLUF01DWWOS1RfSpxEIB4atMe5wpuYFtmXWekPNH7+Y?=
 =?us-ascii?Q?sH2Tay0RymjvGvQoZtDNTRYe+VUsPiLZiV1gpBLv1iwuUhO5Eg8zOKJuJGo2?=
 =?us-ascii?Q?AFmGKeZL51LbGjsbldo1+SNdD+K9rBccq1Un5k5gtiO9+Xm76caltlSQXvYN?=
 =?us-ascii?Q?sEU/WK+HryffGbMvjuhR8XqTfq8mi3K+Ek6A9ehddtZUUT9lIarxxh6YARRd?=
 =?us-ascii?Q?NgJRelT4puRgHvVIJHBdQ+1+Lk53FOnEigIDSyufm/+EhZLhp60ECbfdNIqv?=
 =?us-ascii?Q?CMtOqrbQop0WYSetkGsKYk9/GAA0mjoq30Of7eb7CXhQZ2YM7C7aSEt1Y0vB?=
 =?us-ascii?Q?BC49aqo7/X/J86+TR4yRUkC35b7fPEDn33vhAg7qVV1bLnn3Mfls3LZzoieY?=
 =?us-ascii?Q?BL07XE4u3JrnMDhV7H1l+H0mr2Z9c6ZE3NWAxcuDYI253t8Q2WBCUUASli3C?=
 =?us-ascii?Q?YPMfgB9ue/bC7b+xZstuYRoZaAuO60BX+BSdWAAChaJvVR7mB1xidfLY+lwR?=
 =?us-ascii?Q?czmRvvswzzhqjw1zVv9RC5S/x+bCSVYVH/0bm2cfhjIBuxU+LxsGxjGmo+6y?=
 =?us-ascii?Q?5C92wlw9nq/l9AZ5fSNaGN1TX6z7ROI6KfV9aqnslLLLgRWvyeNwECZ3e8xl?=
 =?us-ascii?Q?Fnr6aCfnP7ZTPp/pD1Xyy2PUmPYjxjYZb7SiHpsWS7InnRCZ52D4TE2cUNhP?=
 =?us-ascii?Q?0MS67Azp+X+MdP436vPkk6+642hUQLbLOo1uxLx4cvzH7tY97DiPj6Xmyw3z?=
 =?us-ascii?Q?VblGc30MVicvEpxs5zN8Ry02PA5r2wGSx1MbVc0G65OiFbO0icrgjHuOnG4+?=
 =?us-ascii?Q?TjgwoYk62ynnHvJwPVnU44gWkWqWcbVVBOcES1HCq4w/sNCTgnasPHpZexF+?=
 =?us-ascii?Q?j9o8BbTPbQuNOxR/5e2A8w8RrHmVJR+0QlZD562eskkQnV95Nh5XDbtrnhXn?=
 =?us-ascii?Q?8U2IJvMbZewmCMDK5hO8z3lyzYfjE1eWbtBqCO37odj5jLwBcVqK9AbSv856?=
 =?us-ascii?Q?TPwhViLWw2UXHz+H88LrkKex6OayQEmZXybJi/IrsOl4B8a1Hw6kkvTSY9CS?=
 =?us-ascii?Q?sWvaxyILmJGp73mXCT6GxUDgoxx5oHbGUhokjmUsULM7d+mGKCdooe+/xXpo?=
 =?us-ascii?Q?8uiGo2sqHiF58VEmI+Au3bZGfeWl7lwciPIzQc6iHD/Hl9PXp983XS+jVbiC?=
 =?us-ascii?Q?EwyJFnfebPBTrk5p/IefR513NRcvTm7ejOxEnsAs94KONI1za0SBFwDXTo6l?=
 =?us-ascii?Q?bmPuqlZYFE6sMpKcaoooZ+0MI1OkS6fcHfeDr8cR1T/9svxmg/VRkRt3/8WW?=
 =?us-ascii?Q?n9OwYdYW7qoqdnLHohLoE8rs8QyJ8Cw9R57hg3o043r5QZGK88IBH1S+vTWh?=
 =?us-ascii?Q?L2T9LFzVrpMM/r80k5GVdEbcNovWKjEvymJ5pgWQJggMEHXthP3UxfUvLgP4?=
 =?us-ascii?Q?54iIAblV+wy2e5/ngN5EiE1nbzomt8hi3yFuDyr2eGyuNiO/gHDUcoZxULTg?=
 =?us-ascii?Q?SmqOvNzxIdgNKHEG6heHsjW+pHpDMHxaEz2yBmG/I2/7BLMAfHybbv8pFYLQ?=
 =?us-ascii?Q?UhcNSQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b274341-d2fe-4ec4-dd9d-08daf52e3f3e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 06:20:20.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/9KG0WpXJUOXjhiuu1nypOcsp7co8hzvF2oCVlrhpI82F1I3ktaxTPBlXhL0umY3kWm0ujBvBpko2cd9BwLbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CCed Maxim Mikityanskiy since he has authored and done an extensive
amount of work on HTB offload support.

On Thu, 12 Jan, 2023 21:07:38 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 12 Jan 2023 23:01:15 +0530 Hariprasad Kelam wrote:
>> octeontx2 silicon and CN10K transmit interface consists of five
>> transmit levels starting from MDQ, TL4 to TL1. Once packets are
>> submitted to MDQ, hardware picks all active MDQs using strict
>> priority, and MDQs having the same priority level are chosen using
>> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
>> Each level contains an array of queues to support scheduling and
>> shaping.
>> 
>> As HTB supports classful queuing mechanism by supporting rate and
>> ceil and allow the user to control the absolute bandwidth to
>> particular classes of traffic the same can be achieved by
>> configuring shapers and schedulers on different transmit levels.
>> 
>> This series of patches adds support for HTB offload,
>> 
>> Patch1: Allow strict priority parameter in HTB offload mode.
>> 
>> Patch2: defines APIs such that the driver can dynamically initialize/
>>         deinitialize the send queues.
>> 
>> Patch3: Refactors transmit alloc/free calls as preparation for QOS
>>         offload code.
>> 
>> Patch4: Adds devlink support for the user to configure round-robin
>>         priority at TL1
>> 
>> Patch5:  Adds actual HTB offload support.
>
> Rahul, since you're working on fixing the HTB offload warn - 
> would you mind reviewing this series?
>
> https://lore.kernel.org/all/20230112173120.23312-1-hkelam@marvell.com/

I will take a look at the series and respond to the components I can
verify.
