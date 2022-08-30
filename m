Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593425A70DF
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 00:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiH3WeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 18:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiH3WeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 18:34:20 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE86765BD
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 15:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ile3aviR0WBb3Qk9uXNyjwdRGmg/vae9T8RnBd6gQ3gglkNFTU11QQvD1+FZUgGcPXMOOvHFwHdJoONWaIWtHZq3uDO4yu5objC+QJRy+gwJfvuLmnQ8fAT12g/HtSZ74/nDFQEB00jIqRgTQIonj8aKYgF9gD2zefPLlRLPt+ynVMHIuzRS2UMiuUHFZyGIJ6EJCjAAriwyAL/4zBMIqVEpaaSAb1cEVmYSjMB0N8L5lb2r+Pjk9/0QdGS/FDTW2tX48yI8ltoc++0Jd4aRRWwTHdnlTQTXPeFxS01a6TDq6NCKde+OGXn2erGHDsdcq0/2w+gLY8xWnqzHOsjxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5Gdzxz/7Tu3B9sVmbzPQqgTFc5NimJfjx3QRJU5ZG4=;
 b=R4MM83HgpIyvwPp6pPvqRqDQh6P1WeqKC+aNC1d/rRAKBhgsjxambwGLpTU7Q+1lTbfYi3Kq7ZMJfTjOzrRvWtVV42s+NH7Fg4IpskPp8STYn8/WCK8Yh6fpdO+YkaC5TGwtcTiyo26mMqz0C2EZhOjDmQqXUqXCGb7+ZSa0m8tMnSLK5swmryoe8zHIPzS23syfY0Tt07Flo8tlTeqfWr4Mp+WA8l/5vrt5o5j4r0/CX30BhmpnSnqgzO0VCOOm+LCKzwNDKbQk890hK+oOxRyWTwEfsNyInQ2Hkf2j5RWNyk856ILH9AQBPviRsw68tIleKYUOiDlvcDuRB8txuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5Gdzxz/7Tu3B9sVmbzPQqgTFc5NimJfjx3QRJU5ZG4=;
 b=FVMgOUEYdMIbBoIhCy9/6t3z9VnmCc5Mo9R+qR55+Ei2sC5ZsSMrFuA9Zj7zhER5JkGBysh6EZhKZJhFrkm4/hbPdQSjppEh0+5kSfLIrYWoTi6WbwnwYu9Sn/3ytQ2HzA0NE+QOkWoVuFuqOXcsIBhHtFJ1oDbkc6v183lcOayA2+APaKwON/s7hVFwHz5mB0lQp20G1cswNu0KuvMPGNoTyjgCXZjeNN7cZvHIIIu4i+YE/hNbb2XQVbJhwIgRM5SmFM1tRMQQsyQiKK6xqDscHUgcpwJQF5HXlT/Z/RVTwa15QmESsPLt8fzGyvG0e/JO86VnZ58MVqVdSiDKWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5314.namprd12.prod.outlook.com (2603:10b6:610:d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 22:34:15 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 22:34:15 +0000
Date:   Tue, 30 Aug 2022 19:34:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yw6QZr9QUwPX+aFY@nvidia.com>
References: <cover.1661260787.git.leonro@nvidia.com>
 <20220825143610.4f13f730@kernel.org>
 <YwhnsWtzwC/wLq1i@unreal>
 <20220826164522.33bfe68c@kernel.org>
 <Yw5KtJ+vOoi+qSM6@nvidia.com>
 <20220830115627.27099213@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830115627.27099213@kernel.org>
X-ClientProxiedBy: MN2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:236::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b33e6386-9984-482d-020d-08da8ad7c4de
X-MS-TrafficTypeDiagnostic: CH0PR12MB5314:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDX6JFTXzrzknUKQV2miQ7qxUQO5QsYRcUjyJJhy3Uom+OEIKxg0R7FdHJm5V5vJs6wje3/aVW6Nc/lRfRD0MwA460aDLFaoiJbI5q2tmqBdxC3wR3kiBwBIGmeittMDlJoxOm0jilyV54RyBcJRBdLU28urRO15BTTOkQhOWFHPlzmOUFRcJgRlUzURPy52VRaFwSkMEqEp9jmvInPu5bUOcf0ORd0AThH7+W+Q0UxS81q4LDx7RDqtTqviC9o25VBxY+Jq5FX8Z5O07zfZqtwKeQurPCnn9vaz6U1g/y0NY/fnDeDjHKIFLDB2b+bEEPi3G6fktO2uCDsTQoxDdX3xSIERswxKunGU62VIG0B7TMheMXbk3pEW+pAVg5D/k0y1fh6TJyoh4TTirDumymgOLZWKm2h1mQbqw8hnhgIPBM6LBQGNLBlri0Hd6cR9YOyzvaz3eXU56CoLFgsZs84o5aGqnrK0UzzzA3Y6Eo10dlZ2pWSUyDC7wD46gZ1Gh3hkikLa4ceP7bm0sj1POKeuyT31Bv9Qig6xpXJcDgP50xJ3Jz/9ivMnC+Ay2/rmvCsVu7TjTvPw4w4NvWB21Pq1P7uhI38Rk8rw8o4oCV421OZKeKRN/1AXyt1ckSyQo5F78Q6E4SPKGgndj/Vg3oqshwr3Mf6lU/qwNmPwuHjYANLlWr1Zxj7TLrqUuzNt0TLD4iknoNQ9X7DM2OjOuNeW22YB96AxamJZmItlUAFa4mGjXEJ/1m7+jLPfa6Gn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(6916009)(316002)(54906003)(86362001)(4326008)(6486002)(66556008)(8676002)(66946007)(66476007)(8936002)(478600001)(5660300002)(36756003)(41300700001)(107886003)(2616005)(26005)(6506007)(2906002)(38100700002)(83380400001)(186003)(6512007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aPNOVzNPS4yM5IMVny+FvWMdsY0ejU5cqzWCZhIMSkLHM1D1A4M6fU07+zR4?=
 =?us-ascii?Q?ebbF0l05LjSxjntUV9lm+m+jVPYZuLWNOlVjV8rDr6HKxE/445Bp+Jqfx1Qj?=
 =?us-ascii?Q?k8pFY1QLd3qROWBIqO+mtN5THGgfr8NolN3B41P6qGjWahuDTsoOJ5DyViPy?=
 =?us-ascii?Q?gUFyK2PlYX+CSq8VubROj9ZoOn3adZy0s+x6f2GZrTLP2uCFCsQAR6oP8sCF?=
 =?us-ascii?Q?2kuZkZE4/LEUZPi3cFNh0c6zuQ5KM0S8GmDjGzEd5RCxQ3NucbJE6zcCDdys?=
 =?us-ascii?Q?FqNofWs/Y/8z/DrzKLlCIn4X45PvXFVdNhN08fLVm8qYLuWxSbGs7YilVL5K?=
 =?us-ascii?Q?sajgpz7mXsAVAe0WXX6nxgTrw3ovJr1QMXW9eID3bgFSlW80xTq6irfmSmw4?=
 =?us-ascii?Q?NdCKLtiSb9F+EupxXWIpZyxyYMsU3lp66aL8g1k5zXH+ZyEcEOrVrO9MqGG0?=
 =?us-ascii?Q?eLQMbjOfeujHenaorJGvj7aOUHacsNVpTuNI4b1d8QLcIQq4URSBfQtDIlNS?=
 =?us-ascii?Q?ML8mIHJlf5guedXfFU4ttZIADn6dhH+TgARt7Lyzy++u3jM/q82zsqb8rUGL?=
 =?us-ascii?Q?pYP5u2yJP+sX5jlBGPc7BRcVjHOS71BkN27MXPsFYVb2YZ48m4x6Gdci0rhO?=
 =?us-ascii?Q?5F9JbHFFgkQQwifSSGm2W517Wiy1BQTnJKXcBcvk+lKvQwLef9Qx42kGY+mK?=
 =?us-ascii?Q?lo8vhjHmvc0/cJEbzHIgdr83XTj5w1+y8oBVCtzYvTgzZNFhZ8xcdtaSDlcF?=
 =?us-ascii?Q?vGe260XGAkc65wtNk6MQuWnJ5UBoFoGbMx/b8iis2IkmCGSt8CWvmdBU5awR?=
 =?us-ascii?Q?ChePLfTCDpLeycN117EXXk7jSC4DTsCQ6lkjN6X5zHeSgHiQFWyxgbR/Ivrm?=
 =?us-ascii?Q?BduCdmBoM/dMfTMK9Hfz51+yMtMPUWz92vXA2Ulzr6XmXvJs9Sx/E02XJUxQ?=
 =?us-ascii?Q?zdDlCBDY+vml4Zi7roSYs2BsNdas/nOT8ehWVdlC0Zy6q5y2rd9IChlV9KaN?=
 =?us-ascii?Q?R0z32uDUe7+hUZOyt5MIasyEL3+GydIXYdH56rZziuLM8rTxDe7VFkrB2RbL?=
 =?us-ascii?Q?Jd4wybta6ub/7oj+7QiONC0y7gGZMZKADD65djqgsMYngFYb+R/h/kg1y47w?=
 =?us-ascii?Q?+fh1jxm6Tja/nhLibSkmMlYFLL0+d8No8QlkhC6Z/vW3dIYZBkLnrpg+fQzr?=
 =?us-ascii?Q?FwxKrSDZq7dq0tBddxSJJ1LzxRX5RhCQ+49xH/TzaIFc5zystgZAvMK5M0yz?=
 =?us-ascii?Q?btpdm9WtsHqxPIos++El/0Dr+qmZwhuL0JR+1trNKymJCBnMxGK218w5EB7R?=
 =?us-ascii?Q?fORAZGhd2wZrL814bpw6fdihfOxqkxY/WneGb/zxfRsGafjroERrbV4hahsZ?=
 =?us-ascii?Q?a2C5nbJuGlKFSZSI0relrlvw77FDlIoiJYeUwTO6Pmu2dI9WkWQ8ad9NRJzi?=
 =?us-ascii?Q?Il2j1xpjuv+Ks2WsBkg/ncccgXN9qSs6Uy1yGqwZBuSV1fBspGv3hoisNAQg?=
 =?us-ascii?Q?xgRL7q9Sf0RuL2zKM0lHLfa6odqw34zKsuAw3AhHzMDP2zSoJI2Y7mJ8+sAJ?=
 =?us-ascii?Q?FGc5irGyKrNuJQttPh949nOcVVMI3+5BQEdJL8VA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33e6386-9984-482d-020d-08da8ad7c4de
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 22:34:15.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VG70c7iUqxqN8aE8bPP64j0tQ2drQew0ki3u+xISi/XOJr3cU5Y1XZ6RG7EPimA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5314
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 11:56:27AM -0700, Jakub Kicinski wrote:
> On Tue, 30 Aug 2022 14:36:52 -0300 Jason Gunthorpe wrote:
> > I was meaning rather generically handling the packets in the
> > hypervisor side without involving the CPU. 
> > 
> > We have customers deploying many different models for this in their
> > hypervisor, including a significant deployment using a model like the
> > above. 
> > 
> > It achieves a kind of connectivity to a VM with 0 hypervisor CPU
> > involvement with the vlan push/pop done in HW.
> 
> I don't see how that necessitates the full IPsec offload.

I think it would help if Leon showed the xfrm commands in his
configuration snippet and explained the traffic flow that is achieved
by it.

He has a configuration that is as I described, 0 hypervisor CPU
involvement, IPSEC, and VMs.

> Sorry, perhaps I assumed we were on the same page too hastily.

Well, I think we all agree that if a hypervisor environment is
controlling the IPSEC then we'd like a path similar to others where
the hypervisor doesn't process the packets in the CPU - it just flows
in the HW right out of the VM.

It seems obvious, but this means that the hypervisor controls HW that
does the crypto, the anti-replay, the counting and limiting
"autonomously" from the hypervisor CPU. (the so-called "full offload")

> I was referring to a model where the TC rules redirect to a IPsec
> tunnel which is then routed to the uplink. All offloaded. Like
> we do today for VxLAN encap/decap.

I think there are several models with TC that can do this. It is
probably worth talking about exactly which models should and need to
have it.

eg what exactly do you mean when you say "TC rules redirect to a IPsec
tunnel" ? How does a TC rule redirect to an xfrm?

Jason
