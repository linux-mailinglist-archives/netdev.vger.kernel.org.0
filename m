Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A676DAB8E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjDGKgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 06:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjDGKgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 06:36:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2133.outbound.protection.outlook.com [40.107.92.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935F793EA
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 03:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZqJRSNa9yL56g/P4LqPdnioVKbEp3v59BOt2FPkkmfZ9CCGpo1TlD6r6Ow4JHXKqsFNHlhVXBI6ZJ2Sw9Vig4MZLD+2Ju4TI4LqO+2VhXI9z5cyeeQo05f2IWi1egMNfk6Yj81qxiiwrO72G58oP3I+wsnw6aL3zg+A91pUvHpiyrTPKs8LXN0bVlRTXbWv8CyqFjVYNgdZeS+UaypRJR/ecI7GEp5bZdpN2WUK1/+Xu9Q+He/zTA3OxNEG2vO6PKv+OmJN7mChR7pj59BohoY6QhNngKeO7y6XMZ3Pwbsv7Vb5K3ag02qPCC3Edh/LJ70fHifBF+F8wKXxbP813A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NETqXargHJvllh6tde12iS5nf9NlQuimwupmJz8fy7c=;
 b=MsuKGRirbuVtFlXjOoMqYtNAQnVVleencmpOqxWBAZboOuEbKHHjcgNDY+Vml8XmkGxfBj5wq74FPooEQa+JbGtmvSiqbarYUdr0JPKmxXwlJHIwqZaA/HDZi9twMp1N+v2CmZan5eAntBPX937w4hOGfa/eKNsDn+/1TGZIdlc2IWihc4+hm6WOZ83sGErDAkzc7w5l1UMTLXhBFyU6Rb17KGMK+e81dHYpZDjDq6Lkr259iDBJGHyJo0XS9N72Z5q87tNMFTV7GVY/eN/3T/Aikn66d285YHfOrClx/M/TUmpJKl8tR3IMVw7sdaI7HglrdCZfLPGAcs5qSUoRUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NETqXargHJvllh6tde12iS5nf9NlQuimwupmJz8fy7c=;
 b=Mf8epp0b6IPlcKZFNnfAWoFML+gkFJTjQV0DRI2Jnl3GccDc0vTKUU19dc5DQxxmoWitF22hu1tWHDGdE4gdjyaAGuv2si8fTPMMxlYtEe+Hg46wPdMF829FcKjHaJ5nAQc2uj/nCUKSWmVLoKf4jD4GCJoMrNBnq9dFBA+Ul2g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3662.namprd13.prod.outlook.com (2603:10b6:208:1e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 10:36:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 10:36:30 +0000
Date:   Fri, 7 Apr 2023 12:36:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Joseph CHAMG <josright123@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        Wells Lu <wellslutw@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: davicom: Make davicom drivers not depends
 on DM9000
Message-ID: <ZC/yJdo163Lc4EBU@corigine.com>
References: <20230407094930.2633137-1-weiyongjun@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407094930.2633137-1-weiyongjun@huaweicloud.com>
X-ClientProxiedBy: AM0PR04CA0133.eurprd04.prod.outlook.com
 (2603:10a6:208:55::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3662:EE_
X-MS-Office365-Filtering-Correlation-Id: 61492e62-5f47-4f58-c130-08db3753f29a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d32zV/qyhjZmNSsaoaWdq8bFN/DyvRE3jh8vy5OUEWBY1nkv7RrHsg8dAJA2BYDDMdNgZcQBsIF+89v/uwsi8UO92SIhR4HSFQAzsbZRwO7Z0y7ZetmsqOmTvSO3a0dT6wvog+4y6wuO0ZV+ZZ4h8oy2sSdq2IuU3jUguQY0zrOXya55gQsiAWPg3D3BzqO8V7ecIQHFQzd8LdQNkXprKaEYc2r2UIYC5rrGEIUOcO8bvf9r+8Vq6ZndNTh4Bt5OSPednd00YTnaUom8v+sAHwAVqzYrIlVJn2JWeh0sNoGCGCqyK1bitsd941sJVdRNmJwrtK3S3iy5eb6rlFI1F9CrxEYKobh0PVAz0OOdqcNYtl6ArXPo7E1SiojMLmKj3fIiaDUM0pzKDhJFHHW5bKGwtBY5EomYJgn7C0MUhjTRun7+wCBcausGJdxy3L7PJN8LbCmXzLg1FCmVDHdI1qDXOMgwP7+Ramku0DsgRy4QfooqWXZ3/6y8VpDKlkWbALCT/r6hU78Qpqb093lgGCXJNjW9VsN1w+ZW79fbGiqDc9JJKU5N68nKLHxtKYZ/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(366004)(376002)(396003)(136003)(451199021)(54906003)(316002)(478600001)(2616005)(36756003)(6666004)(6512007)(6506007)(186003)(38100700002)(86362001)(6486002)(966005)(41300700001)(8936002)(4326008)(6916009)(8676002)(66476007)(66946007)(66556008)(2906002)(44832011)(4744005)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6ZHIfUO13mIJzjpTmCEFE8fwTKlimnOuRKH/vjuDmxG7oHUBNGQbsc2ue+U?=
 =?us-ascii?Q?eIDFeOUksYQaCdjf6sw+egdz+A/rFxO8N+E9zKEWg+m1KuaWZumKNFQXzeS+?=
 =?us-ascii?Q?pyi3xoAATNqNzzt271HdvVEe1FFDwZgmwNw7BzXFu4n2+zRd1rFS4/FCspil?=
 =?us-ascii?Q?KnXC3OVDE9BQ59ZEdqM/4KyWRbnrpM/QYT10uDDIvLL3ADQ+jk6EJhGOzX3K?=
 =?us-ascii?Q?6/ZeOWmxcn6qlXRltAEGr+vXGymmJj4OdgBLyr8oBSpHoNNL6hhYQlksOHaG?=
 =?us-ascii?Q?ALp5Q1dgZwBJ4c7DXBb+MhaQWTGlvLZaKgefVGnVg4KSymV7uORUdj1OPR8q?=
 =?us-ascii?Q?4yeVM+CTbQqG1QvM0pxErOSy09xlNPF2e1BNLE9dtmRuAoHThN8+t2dBAYEh?=
 =?us-ascii?Q?8Cyfkn+BngbDXTAggrRZMZkKMHjHCU+lXkcBtIXW8q8bL/lVsDx/jW3R8mlT?=
 =?us-ascii?Q?aEW3CtjECaRHYbB7S4QyTUDbc92e0XdCe7zkNAK5NpgAVE9F41AFZcR20dDn?=
 =?us-ascii?Q?j+2vYNOR/IbPnO+X/l7brDsRtRlIGOAKrmNG94s6kgjy14jotr7TbeFHaF8O?=
 =?us-ascii?Q?HpqBOPBUQ2W0E32Iwicw8p21qgUnLLzsJYIkwflpgr87ofb7eqOPaVbraMwk?=
 =?us-ascii?Q?BScuqNIUZO3UVwPsTG4PNdfNdb/qB3KjdeE1SRjFQTwgaZSeshDSBPZstRnF?=
 =?us-ascii?Q?oc231cTyny6TM+DYJeXwD6FQurgaJB1juCA2xaAqo9QdIlsXLZltv4qp9FiF?=
 =?us-ascii?Q?iLO1wyITjnjXzJNLdo8XL+vJgjhbFhvKK/Lrmmbas9U+2Q+NvJxEM9/EGNma?=
 =?us-ascii?Q?n8UXQiPRXBHhPAcI/ilT/2q1uzOlExB0yovYPLB3MZrTFeoqvcrAGHLYGwnM?=
 =?us-ascii?Q?Gn5sG5cguckg5M3didO3MUlEm1kMP9FqJ30eM1DCbR1mcxJopc9ExUi+YmMw?=
 =?us-ascii?Q?dmN31A/WPZ1MHDlBUFA526P9ebrENW8QviqEZeDi2e8/N7pPJkHPyQWPU+Wv?=
 =?us-ascii?Q?9CS3VngAUBFZZXZ40zkf1Sie367oueg1bketUDxJdlxErzLUZ8hKBZ8UvpyO?=
 =?us-ascii?Q?QpTZDOnPqL7aTVE9gVNFrN5RW48veyFjSZYqNwlxkAq5VIQUto/8RwoT9Hu6?=
 =?us-ascii?Q?mZqVb4nit/7WjqNv7ZwfnN1wrfX2JuDGyB7PMnr5IJCtAQJlfg99ksPxXN/e?=
 =?us-ascii?Q?vUAzWttJKDoonZaxDWCwdDBfta+EWOQbRPv7bQkATBH3Q0N55kla87sLRyoO?=
 =?us-ascii?Q?YDtPerf8w2h+OLziZPe/Dvor1+Nde/ufxjjj69f/XIbMdM1ozV3LsKIRwcYe?=
 =?us-ascii?Q?J/jphA5ahqHLYwKx5+DNEM5PU8ASNikXIFxmkIB5awAkIwHOscvtdIODiNLR?=
 =?us-ascii?Q?4zCGbJQs6VFMkdj0kf+AsL4hMO8hJe+4gp62rAFCJV21d20IpPt6BtRHCBK7?=
 =?us-ascii?Q?7qWRMWpKLe5DBAfgG3M8bha2Pe0ZbyAcTtDRii7nwOzuaM87b2upaeyJ9Nro?=
 =?us-ascii?Q?ouA2gzLYkCuFO+AlZAkBULEvpeh3PZNzPGSOQBUh0BzC3gCLGgzdd0ljx5kU?=
 =?us-ascii?Q?84cPOTBaUDOxjkoTmlhPgoVa5HR10XuA+pka7EEcTV+3ZDvKXGi07CI1DYCk?=
 =?us-ascii?Q?3tEItm1fb1X7a1ZVKwQBq6FNTqyXS89ROOBAT2TbnC3oJmDEVd1rANAPM89P?=
 =?us-ascii?Q?c5+kzw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61492e62-5f47-4f58-c130-08db3753f29a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 10:36:29.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvfY3/SmPm2hWgZRQ3V2Mjbck/fsRz2AD4U2WxdxRx1qFTe+misUJ9MjknNJGSc+ZPxvQfgrWxUDuW6SZNly27H0ij/dvxUGVPiQm7yxaj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3662
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 09:49:30AM +0000, Wei Yongjun wrote:
> [You don't often get email from weiyongjun@huaweicloud.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> All davicom drivers build need CONFIG_DM9000 is set, but this dependence
> is not correctly since dm9051 can be build as module without dm9000, switch
> to using CONFIG_NET_VENDOR_DAVICOM instead.

Thanks, this seems correct to me.
And I was able to exercise it successfully.

Maybe this is appropriate?

Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")

> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
