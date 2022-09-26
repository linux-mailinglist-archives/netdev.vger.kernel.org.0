Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA23F5E9AD2
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 09:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbiIZHps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 03:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiIZHoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 03:44:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2109.outbound.protection.outlook.com [40.107.220.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A44E0B2
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 00:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOnAtc5QYbypb8vNzxJkjA9yxdAiGSJdDnAo5azW+fqanaS1PZqvmVhOso79owIJEJ/06hXUEMujxoRYHgkgFe2X0fCJjPv2Mt399ZWn4ntfsq2ezfiqeQ3+ZMnRwwllTofiJO+Iplib2fO25bhk1r4F7QSixoyMvYlkxivW1rD/g58L2WSINsnRQOyHPkRM0Ct8oqoBIxCSRn9pM8W0xjxKX+4I4ys4kmkGn1MdpSrfZZjYJ/Ycf3hraiiohQauBgJt9766jXE+84I7JRsyNwZQHQ8u4UE64cYEqsuWdxk9OXO0yQ2vlx9OW69OxHA9W+yQei0/arfdO4D0HyZySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1vOyLWxM7yAE8s5atenDXsffR0sfRQSqPyAEtOBHnc=;
 b=j4YKyNk1oKn2Jt/JYWBx6e5ut9/5hupkfaDWAyryUhHcr8zPNnfEvVUAWbqF5wBRBwJ5qCpRymkPdmWFcukEzAdCc3K+pIcxGO7VG9bMHqzOni8KJqO/CclYjbdE+43Z/gRqFOb440M4UfwEt7SQcZdkpaDfvfQrYqY90hg+I8ttJ1UGsqoe321fUnAf7spwZDyHcKscj/RSN8LOwLHzBkJi/XFccj/CugcWHh9wH56aGn0ibE8p4u5WDafj6OaS7tuVUq6Qzb3qGk+5KP3VwdeXNrQk0TJOW9KQoK3euOR9R3Zh/u+ANKW7tQwzt2pYtbZrgI6zfdHduWp2jopIYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1vOyLWxM7yAE8s5atenDXsffR0sfRQSqPyAEtOBHnc=;
 b=GCB0pIkefzfLaV7NJ/S89KMSmTFCK7YQmx3sUbStxlAk6EUuelSHp4RRKELVAfkY9/RFtLCBv5ekhvzD3YGt9eWS/zT+tLGyRQLF82sXpz9zYPUCbSjz9GrA77POo/h63jKDBL7+3xrRjYx01CkbvD3MAEaq9K8vizmxReJ7t70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4713.namprd13.prod.outlook.com (2603:10b6:610:c6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Mon, 26 Sep
 2022 07:44:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Mon, 26 Sep 2022
 07:44:39 +0000
Date:   Mon, 26 Sep 2022 09:44:33 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, skhan@linuxfoundation.org
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
Message-ID: <YzFYYXcZaoPXcLz/@corigine.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923160937.1912-1-claudiajkang@gmail.com>
X-ClientProxiedBy: AS4P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4713:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fd15187-a2c3-4d0f-bd2b-08da9f92f7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSm+pwaFY1IJ4cvCgnjuCP44b8rF8T9SOu/N8Ubk6WSAU3K+bRp+Z9HXnt13GKnnIcl1M0EaU93viNpUo/YZ03pboMEgWbURd6aSOWJML59CG2w3Ipc40YImoSYiltSm6WNsu2ydv2jZhOdXIFW5y7w60W+BEQpttQsfb8QNiRPMu4SVOu6l8JI4ExypGJ21tkSqMymkHD3KKt2En8NoFbPhy/783v5J+kJDQOZhgrDccxjLt5245/aJXkV642WzjdWXcPr1yPo2nz9fG6/2n2X7lTX0iidQjpDiEQGgCO3eH5Si6JFOkbu5/l3NVxRrJ3hYFhaQovJzexm8S8OK1L91f5l4L3wGay4mr9F3XWqjBID9aJ1XN96LdZ9L1GiMlq06EnV0vgufph1W6RrCByLKen1W2GLkInyfkVrkuq5fIiod7SoOkMxrQ1sOipTr6ZUHN0+R2UDGU+QU3SyhbQV/7kmadxEQoOc9YKwi+zf/DZorNuPpC9WSuYmLlrl5nXBhepzfu++ImRa17yDonwNYpootE4BWWwWmQPwUn2s/GhpMGMQhKk26Ydmv78iaRV2QGGUdl6x4zNPA82KEwotokQOtAUhZOICbCW57P0FWca78BI2qFVg70poLgTuIJo3qMJ739ltltRpuoWTt883LGaCthGLFYPYmY8capGbXOl1lGeDkwDnaJ5PJxCcJ453SJx6s+3muZS86iZoriQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(396003)(366004)(376002)(346002)(451199015)(2906002)(2616005)(186003)(316002)(41300700001)(6666004)(6486002)(478600001)(36756003)(6512007)(66946007)(66556008)(44832011)(4326008)(66476007)(8676002)(5660300002)(86362001)(6916009)(966005)(8936002)(6506007)(52116002)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y1AfD/Lwhe6xG31St/MMWF931qg6HzUtz7jkB4CrLYiqb9UqZJUsGMGl1kpb?=
 =?us-ascii?Q?4Ax7GkUwi3BLY4+M1qpxZtUvKR7Hh3ufN5PiYgHnGNOAliKrvRMlDqOuC3ef?=
 =?us-ascii?Q?OUj6B+N8oX2d/83h/O045yvznq6RwwXhy3kPNrqgG2t2CestkzNN+i2k8api?=
 =?us-ascii?Q?zZZN+2CiFXG9s33hMEfNJAwHbxJ1dnW6uwgRpkVdb4e1XI8aEbZT1rJzK0YC?=
 =?us-ascii?Q?fhKYWflVzGSrezoEuNdjaE+GT+mbRuLFioWRuwjBbSic7BC3nIL7yVDHTq4l?=
 =?us-ascii?Q?navr0UNv7sUiMCIblRkhrBnqij3qbcCKXHrvBYEOkujz5gRC0/DsKpjvICa+?=
 =?us-ascii?Q?M6Oh3VBnZ57IxduF3Erdpgo8UYORc7V9xnh8S+KvJLqQYeqzsjJJWj2HEvqF?=
 =?us-ascii?Q?bFUKh3ZxvkHjwOYdyRI+motZdcm3ZkyEzt/OKlbv2EIDBIX0NbLPnEhKFaaA?=
 =?us-ascii?Q?auBI5khJqHGEbDLVuYmCikUdsyTSS+pzMREQcpVdTxUbYcN0gKuudPAEfR2z?=
 =?us-ascii?Q?Iy/KNZV6fqjYh/OAQxVH/VGAJCHCW1ji0crDGU3iYLCC+/nLazJbdi9UGGaL?=
 =?us-ascii?Q?pDx1QrzQN7vQPc4bWurGTlMOwTVnlJ4j1ac4WnTDXRzToKlyBLPlvbaRmz+d?=
 =?us-ascii?Q?9kAUPUfbSNmBijHOgwcLCbS9NdWv0ewSQjEt/sz2byFBRQz6oGVOUORoPLNe?=
 =?us-ascii?Q?+VErSEGB/riSGhQrLmCrVrqTGEXjf1zojs54mY/9ZC17pGR1DCC+KkcukYC6?=
 =?us-ascii?Q?T8GDzFafCUDGBjeZXqPj9SXTw+HPsgLB+KX1l+Duvgbe/bDM9+gVh2zSUlKw?=
 =?us-ascii?Q?ZWvcoGySMOB5OHXwPQ/RvXZh/9iGvoSEs+Vmltjg2p3F2KDWAV9p1AdnOabr?=
 =?us-ascii?Q?j8sgBmDNKXsqbUqgLguTMoA95hZoNLuoXd/PFOHVW/Mo5XNor1AAeMTwt0iJ?=
 =?us-ascii?Q?hM/BnWQSfFYux7xmsOxP/qbc+WCPMmgFY5OlBKdTvk+TXd+Mm2e/HOK48GVl?=
 =?us-ascii?Q?7fTI3gyRomm6Ebjc0MM/n/srhZDm6lS+tn2QQvg/qfP+PoNk79iozMLou6Wm?=
 =?us-ascii?Q?XsH2zaaD68PzMCG2smvYb0dPb/+AMH9sTnILGutjS59peckPkGvMSygrYgiV?=
 =?us-ascii?Q?j3HrkgMYFepZg/mLH5cd6Oe0exEUrmN1tvh4jfqxq29jfOz8QWCCcVEgu0sk?=
 =?us-ascii?Q?mthAxCQv8mvSmNkpY5Jg7yB4kIzN+xKQ1r7wdb5JUc0Pw3HUlBGv6hLENDER?=
 =?us-ascii?Q?GwGNWHy2o2UEsaFq7jKohOhJQrzgHZeqvHsen8jmyQIdAB40wM3r7NMyl7io?=
 =?us-ascii?Q?LsBSw+z3GIhtXAKQONlfIOn4dddcUgTToC6aGSC33qbUzvgBHshQtRcI6Dfq?=
 =?us-ascii?Q?DnzgTTx/DfrjLo5XuRw7eW1194TvjIN0kKzVD/jhYGFbFmsmFRmk1ESWgT1s?=
 =?us-ascii?Q?dguH4AT3AsmG8KiRDHg+/leUDwikZAnXWmPHMFC2OaCIu3tlg2RkwIgq73lk?=
 =?us-ascii?Q?Ztv4oFQbO7KD6tebDwz3tUjuKpDetmYhGr0bMx/VZHXsouio9mUSxf1GfuXd?=
 =?us-ascii?Q?gxpMZvVu7ZTAYDH4vcoYgiM6hNC7H5TloenL68QU4/IEoBWxtKbSvXgEwHXV?=
 =?us-ascii?Q?iYuckarXGJmx2exadluOvJYGH/xAUcT6qKDEKhKmA4+vYGiowqXFgeQPDxtZ?=
 =?us-ascii?Q?7LDjOw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd15187-a2c3-4d0f-bd2b-08da9f92f7bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 07:44:39.8200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9LKJYnPOXD3xMxwfphgYcfhRB3rLSUaNX9uAP2Mlg1T+4IXe0CgHVKjv3kbLozupuGA6+ssdPQImUE3VZbA4L67DexnNiEwE1IQ2WzxOV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4713
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 01:09:35AM +0900, Juhee Kang wrote:
> [You don't often get email from claudiajkang@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> The open code is defined as a helper function(netdev_unregistering)
> on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
> Thus, netdev_unregistering() replaces the open code. This patch doesn't
> change logic.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/core/dev.c       | 9 ++++-----
>  net/core/net-sysfs.c | 2 +-
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d66c73c1c734..f3f9394f0b5a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
>         if (txq < 1 || txq > dev->num_tx_queues)
>                 return -EINVAL;
> 
> -       if (dev->reg_state == NETREG_REGISTERED ||
> -           dev->reg_state == NETREG_UNREGISTERING) {
> +       if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
>                 ASSERT_RTNL();
> 
>                 rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,

Is there any value in adding a netdev_registered() helper?

...
