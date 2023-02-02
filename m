Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7568852B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjBBROb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjBBRO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:14:29 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FBF6468A;
        Thu,  2 Feb 2023 09:14:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed8DB6v4G5ujMQvv7l67pISFom2p/OO8Lj5HSqvQsBAUiKXS6J/vGoLEs/7GhozdRqZlD5hp1bpOr30c/O4FszX6BmBH6mQy8nYLZprswdo+9kFddqiSvFGMYzSSTqGigh6dwTNuOAKECUtYdkJItDTa+0rIrf+EbHVDOPgSQIGISlDlW1wEIB+fG2sHryLu6c/sSFu9MYW59eOFLrNHbf1nA/w/qAhjCGxS3nPYd+Hf58nZD5aR3VPALsZQSr6eTHvpxztN/h8+6VXN8d/ksTw76dhgWLE9ImNd6tqgklSjA/RvvFUJfcR4HvTJCIREk8Z+AwktSvPnfV4cvt/57A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stMbsez07qgp/9a30UlDiCnuNeUYHq4H7AQPEZkk4pU=;
 b=BGwiy2cW0/OMWMCyg5JleLltLeeo+/nJ9mcXXbUV81GpbjLTgDaFiyVFhMjDBDxAVIciQAtiZh8iVUS8KwY2z2ndo2iw+ZAl7+4iGKR7xgrKLXjVVFPiU+HZDsuAYYExOjKYfM8fYD2XeNWDCZRA+FzDfmiPx2FCeyaous+Dpk8wU2tO3+Cm83xXcPVXg9L7+zAFjnE0dPLfObBzO57TuLc3vOnEX12IAIcXjHJ3aY7N4xaio5ZPbeYq+AgsJggeP+vjTf7V/JfrlnVfCvTcovfidrBep2ty/Hyxcg0bHBwQFY+9hGM7LoWPRhXrzhcINn3DGg1kuYp9g+jjI1JWmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stMbsez07qgp/9a30UlDiCnuNeUYHq4H7AQPEZkk4pU=;
 b=JlNx04Y1n9y6K/AGj6Kz4TTilzOsb7hjGjkIxbtShRFFOf6uON/VyssRCuRy1a8oG89QtpXD3rUOOfvuaDAUmC7si73yphWBzR+WiTk1c3hfE0cBpsXU3TmojVsQ/K4p2MMvKbcX1gzK67cRLroEupetEzkHbdv+ibQiTMdLga5jkAkE/pdprRvthd7gcq5pJrrckxFv87TRnY1jibeXvPPOANdk46Q0pk7j4cfU7h4BmFuhGYoVZA8jC2gfNhh+Lq76t8CTWzG9QLsO6aY/oa94Cvz97htbXyIY4O242TFelOucuSGf9nf7HhY2icTAlEZ1PYVPplUgfhbsVQNhOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB8615.namprd12.prod.outlook.com (2603:10b6:a03:484::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 17:14:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 17:14:26 +0000
Date:   Thu, 2 Feb 2023 13:14:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9vvcSHlR5PW7j6D@nvidia.com>
References: <20230126230815.224239-1-saeed@kernel.org>
 <Y9tqQ0RgUtDhiVsH@unreal>
 <20230202091312.578aeb03@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202091312.578aeb03@kernel.org>
X-ClientProxiedBy: BL1P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB8615:EE_
X-MS-Office365-Filtering-Correlation-Id: 199aba9f-0a87-45bc-0fea-08db0540eff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZJupZdyG4j/7tZm3UrrProMtq7ARYsmeVJUcVeernQhH4X3RHmCxXENhA8aTVXb/KP7HG6U3d4BLUVhqIC96kwS9D5kWH9nfvWW4/k/i9jgG6ndOOljpNNSczLh4W7TTVJqy2kkfXWleVKt6lxevF3l2w2+GIHkv4U0dWsNlq8oG2MemEtJq4YfHUBib+tGscUZXm4Tyty8Ya00tWIUWraRHierrPXVHG389DPJYopRJRL4fxtt2VYUaYE55RizsiIxdunNVjezHjm6rSsMxXDVWSr6IPgRo7+eo4WckL0DRpF6nkDXANi6MP3dDAjUc9N9jmhLT8MPoZKb/HoQi27VWbpD8X29i0UW5jFI9fy3j0zDVY3QCrEsgmZu3w3xuGMG0I3ARD63G+rHueY2IGV8gwaK1y5KcxqH0exUmU7lFYZqjMQ06jRBYRD9Pe4XspvXli/cmwkt6PqWGNm9LfpHGrRGTsDs2h93AAKtVY0nJu+CLLO64D7wZIlIrNN/3LNpAOYueS1mknO/UF0Z4Mrl0GnUS89gt2UonldRl9Zso3y2sYFbdNZXlltg7vEcJTqMfLHZGIalciW7s+LE4TcNlIRIMtOiCs/lpe8E4H6Q8pke83pDyeY7OwIyMRcTXgIn068TJViWzUGJekGfOjnL6zyqIhhbepwmcOaoOvBGdFH+QPQ541WGSHae9z/sB1Lt+Ei3+bdAuhnjj9i/8L/slLQvaWv56ZLZBr5IKUE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199018)(36756003)(38100700002)(66946007)(4326008)(66476007)(8676002)(6916009)(54906003)(316002)(6506007)(26005)(186003)(6512007)(4744005)(478600001)(966005)(6486002)(5660300002)(66556008)(41300700001)(2616005)(86362001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PxSwhdujx/5W5cczCIrBeRJQVgPSkOEL4fvAK5U+ZiLjaa9Y9TPC8jgG8Sbq?=
 =?us-ascii?Q?5k7P30ZSa3mf0vghVk/J2dr4Hgk6tspL+OOFP2jfvOWz7FwG1d0EDH2yBNa/?=
 =?us-ascii?Q?JHF1SVT9FPOwM3A6b2JT1ilY0c8ywVwJ/tVrLizp6XHK+4OGyj5omz5XorKs?=
 =?us-ascii?Q?ApaBZ8lV9WwlRhaXwulAiAURHqEsgj/oKDm8eP+HZRzyaOqFWfkOpo3gxNC1?=
 =?us-ascii?Q?Z1e4ikB8QyAxYaOlbjOS7te72h4MzHC3L7kTL/mbL0Siv93DSTxKTdePb7jO?=
 =?us-ascii?Q?ytvOgHuCPRlZ814q7Je9PbK8FIPIX7/v8jkXOXVvUBFhKSRWxDnBlAt6UWt9?=
 =?us-ascii?Q?GcKynfFGGEW0lvXJew1kTvyC5U2Gpar1gl2MFT8T5hQMJdf4gOytql/1MdLu?=
 =?us-ascii?Q?+KOVkd0ksVr8RElQUtuSARO4gMdXmyvJk39cKK/kduuuq+Sy6okEgaMJiLrm?=
 =?us-ascii?Q?vYaq1g71inDK/gul0Oh8oTMKyBj+pJbqWHuBELY3UwpqesLABItqcsueO0it?=
 =?us-ascii?Q?9Nt7j93itC5wb7typC/okB+N1r/yVd6ss5mVuxGSDVsZOE7EuzAT3Ewl/rpV?=
 =?us-ascii?Q?MoyxxRdffgUYXQ/ZUbInFoepsC+/ZkK32hTaqhJUepDxzKPyYkhIX20zjVsC?=
 =?us-ascii?Q?HKtbVUMaHT4fk+XkSO1e7yald2aa3TzyfQoR8/8TPTJnCAeAU+ysFYCptZRI?=
 =?us-ascii?Q?sCNq/vuLctmQMmfBSwNsNudIldlTRWUrl3HTKc9GH8csuyg59AHvcLVsMwlf?=
 =?us-ascii?Q?Tbl1YZHRT6lIw3cDPfXVjIMZdl3CGwfod3xa5+wOU+C/ynRZFXOMBMcQVLZr?=
 =?us-ascii?Q?ff92w9KaVbOEuq8X9xI6DjYfYIlvKtAuZ45nOBtofdoDP4zqaxWYI1ijTRAk?=
 =?us-ascii?Q?aKVYFUpctqlJquf4gpjmBT1x5tK82ygA0yCDUhj8iipoUdhqqLDazc1EfM2s?=
 =?us-ascii?Q?zxw6zan/KJdP0mKg3DfIRtmw/5o8TVJFAG11tvD5Qd6vAk0hh1Sry5m4LcRd?=
 =?us-ascii?Q?lVwcvE7VWaWdP9u+R1k0h8eAaRH8wHzgeBIlaXoa1I5cog84tmfWap9oc2EO?=
 =?us-ascii?Q?MkLOnSoEaof9HS4mm9PuD70YLWp13IirZnMHzYjgvBSfL+9IZ8mypO/bbDY6?=
 =?us-ascii?Q?GPa+XtaltndeWbeGKLzcVWtcAoNVkx1s5mLDsQUErOm6/IafbqDCXdrGn/V8?=
 =?us-ascii?Q?QeYkL8pXRPiObbnUhxuDn4fdjdK6pbckzY/H3on3lgU6xvOkByW0tM1irHZQ?=
 =?us-ascii?Q?Xokp4XoDc9t5/owhm78//tgiKQGzgZBab4fNxKtqCyBcvGYlV92PYEqWatHa?=
 =?us-ascii?Q?wuZlD2RUvBujzC4ePFz172cuLKCd3HncjDMUmishvlsjWUOzJbSVxv8WHizO?=
 =?us-ascii?Q?6ZODrj5pgzP3lO/F8yZ8qwOB/p3DCpI+ZTWjlZUpLWcbrTKV77PoRkrRJj3o?=
 =?us-ascii?Q?bS2N4pzO+B4xriHQ0ZpYh2Hxcu3PEsQ1+4PxCzpCHW4rBLgaxNPd1cJG5wMS?=
 =?us-ascii?Q?XZxZr5NZlksgdxxKoa4oXpER/o/stWHxjT87YHmmRX7FeVmMVX/w7LZYTrSW?=
 =?us-ascii?Q?t94x/cGr/RCALZtU5tQ0KaDBENtUYY8nHSP9f8Su?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199aba9f-0a87-45bc-0fea-08db0540eff1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 17:14:26.6061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMCTfdqUdU5NJ4HYRYXTv9nP9zJQuu9AU7BDvoDqaXROxr879qW82esH3IOwCyw7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8615
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:13:12AM -0800, Jakub Kicinski wrote:
> On Thu, 2 Feb 2023 09:46:11 +0200 Leon Romanovsky wrote:
> > I don't see it in net-next yet, can you please pull it?
> > 
> > There are outstanding RDMA patches which depend on this shared branch.
> > https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org
> 
> FWIW I'm not nacking this but I'm not putting my name on the merge,
> either. You need to convince one of the other netdev maintainers to
> pull.

What is the issue with this PR?

It looks all driver internal to me?

Jason
