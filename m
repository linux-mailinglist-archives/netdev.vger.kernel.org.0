Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4F569E98
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiGGJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiGGJdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:33:46 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2134.outbound.protection.outlook.com [40.107.212.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5F633E14
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 02:33:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ze2hO2Y3H5G/7uCRVvYzExn6fCLIGkAh0bW9sGzqfB+BSczlrj8dWk9kN9b43RO5XLg+ftLNrP6Y2fNCHY1yj9oIlIUZD1GvaEOif/cCUBc+hyPFM/HzsLS2xSULmMevF6NshbQODaw/VBAdw4Eps/ffOmW0x7rDO5UalHU/FrHNeAEdP343lbs3HXQ4sghJSr2ZUJvfBjomKJkktwVOxmaGntuFRnEGP1yi/qekHhPdizSw1+0BIDC3IOUN3j7Sy8P0jWvkyzvdBSod869SDmp7JKfkc1J6g768jsvZF0Wkk5Wy9XJLCB8mD0VwVTjSE6fpFRvuhnBuSV0SHa0Jug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5EnswxNU7UL24rSGyltTZZ0/Gf3ukz/ELLLud+GFUg=;
 b=ij2QWWrbtrl+RrSfSfsvPD7AK2XCFNQ5oyL0WbjHbSAHILoUd8CUxZYHUi6j1/NCt2dA/LnMz2w4sP/hM6wY6wCMBbcW0meR3roGAnvN/zdDRjDDuztoNsSvlWtOmAHDbsabXSYfcfvbWsWtlee/+gq+/JN9vpH37bpQkxhGig6X7nLdUr7xfegb0j8pgbswcwd6ohYWnTEZVrHQ7SkI1qElv0GY3zKp4G+u9PZO6Pu/qympuQO98HSGjoRExxqSYn8xHFaAxSs2dWVEPyctsxFOT1aQrQWTTvvJreA/lX4kup/y+TqiXTH8R/jOHFKm1/9nMkW3/W0e5xuKDXmvJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5EnswxNU7UL24rSGyltTZZ0/Gf3ukz/ELLLud+GFUg=;
 b=Ty8m7jMoL4jRbffPOCNKham94VuHok5IQpSHyR9Fmuh/Hz3ZHqrvflShF47Nzfz9XZs3zIZ2h9UAo8PpyFZjunLALBm2YC4OV4EYDDePhdAjIWm0D5r8tdMdHM4Doir/5yZKmbt0ADO9YUIZmigmRSf8l6xm0go4EhTitLN50aQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4943.namprd13.prod.outlook.com (2603:10b6:806:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.6; Thu, 7 Jul
 2022 09:33:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 09:33:42 +0000
Date:   Thu, 7 Jul 2022 10:33:32 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, rajur@chelsio.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, jianbol@nvidia.com, idosch@nvidia.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, maord@nvidia.com, oss-drivers@corigine.com
Subject: Re: [PATCH net 0/2] Fix police 'continue' action offload
Message-ID: <YsaobEAamlg9dZfw@corigine.com>
References: <20220704204405.2563457-1-vladbu@nvidia.com>
 <87wncqa77w.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wncqa77w.fsf@nvidia.com>
X-ClientProxiedBy: LO4P123CA0250.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8900b2f7-7b61-4854-905a-08da5ffbc7b3
X-MS-TrafficTypeDiagnostic: SA1PR13MB4943:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiL+WS5OZQlx3wpDupiBPgpbyDtyUmfKDofAchciC8G2zlUGdH+Yccn5cRaXyaYmO6Rzx3kcF0ciXev3FTBhQAebOyPYY2GhS0Z8OO1aELH7wK6IGCmpWwgcWM6WR8QXZLdEA0Z4SekNiCiP+LP3uKU4+DNTlPXosowAKitmRne9zZ+bsIsNyG6fmJ2xAAPyBvdi+JxdtV6T5LvTpUsdfTq0vFA+b9/NiyvKlJyD3qNzxC90O7Rol64cQP5nrATkAB4oCM57yRpXyVaoszqxDoOOkFHZdS2qlbYG+5qmKE8xNE9d7yZAN/aQ3mK7/BSMU1NL9aPaYvCPcwPDkinzo3bNlqsuxlovMb4GoOcp0IDViY/jv08dwxxoB7R3DRuSxBouPLu9AxmqRaVfcXERF4ush41/RoFhVe55CuyIKx9rHv96VVT+iSIbR35Nh2mqHv3oaeAL5X4HlvMZtozyFRaQ94Y03d8bSS4sY1v396BNUjoRNR6kChsN47m3yKEmy1YjEjX+EVW1TYlXExTf9nW+SKf3r9wKxRj4wX8QcYHkOMCmKB4aZglApC8cJSw9NCZgVxUQJrZfqmJriy3sNH8WV5byXbxzVaAf5OLGYc/sDL+lRKR7tJz/BbBZIk9WpgVu9SnZc1qNaI4dTxJBdLr4n1QNgCCavKBGQXpt1HDIUKblR/9FU3KPo4tF61n9RIcFFlfDvHqf2Guw/em7MYtl7+Xw+Kmh2XUcMfohDyQdbg09SZxh/OjLtv7a6kcTnjQAuR5954xD3VtcNh+6vqS94raVjRoZbQnJTYj2o2fuQMBGWW5szbqoyTMp++wNYZ3prlC01ZVKgPsfkDfL3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(2906002)(38100700002)(478600001)(36756003)(6486002)(966005)(66556008)(8676002)(4326008)(66946007)(66476007)(38350700002)(86362001)(52116002)(107886003)(7416002)(6512007)(5660300002)(186003)(6666004)(6506007)(41300700001)(83380400001)(2616005)(6916009)(26005)(44832011)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ms0MOZKJvzGGSjoiMbw3+ajOG3tnskYHAyMqnQ+vBb+TbfwmNZzz2JX5drEV?=
 =?us-ascii?Q?rhR3ZSAntV0k32bdlU086xJXNl3+2t0CMKKcsqRE/zp+1I6Hqcp9eeyRLoxF?=
 =?us-ascii?Q?6hU7VStH68FtQkQUTYqHmBw4gHV1P68qTnJj8SyZa3vavw2gVAXkh70EfXZE?=
 =?us-ascii?Q?YWYm4XtS2MDfOu3nCCUqNq8NtNUntIWMrU9TsNKqwnKhXxD3TlxX8TFyRE5N?=
 =?us-ascii?Q?HVlEvnejMq/ARKuhix4OaZ99Hfc/o+8lftzFlXAiLXkHK/scDYCsm4N/B44F?=
 =?us-ascii?Q?9UXW6GbyJsWAlbMx5SbbaYh4JcBQuymBrut+Z6lssXUSxukZ6NZXGsx00VFG?=
 =?us-ascii?Q?lY8yd1jwZXTwBoQaF5t03V6Pyieep7/9dTs4a5qHT8vzQFBKYU/pPxkEm2T3?=
 =?us-ascii?Q?RuGwTBEei8RX7hVcoY2/97CeUEr1Z/ewGFJWCucuIzGYQRXTN8pzM4gSQRtq?=
 =?us-ascii?Q?JKQG0+wPlYgMs948vaF0E1q2xqlIhGaCJfS6zfy2rpEsFT0NOi0j2TptRdka?=
 =?us-ascii?Q?XeD9dYIqvWVOF50W/yigrdENWn9ow+1GUz+Q5CT3z45lZhivKbGKyql1e126?=
 =?us-ascii?Q?QQbT/BTxcc+zRqyYcnBnOtqK8A9dl1k/aLNoyE8thdVuDhk7jRrA0j+0irZD?=
 =?us-ascii?Q?pcARnYkWs48mbHby34Y5bLPoaOyfGXHb6SvS6cOMD4EvA7lhelkKH8XZu690?=
 =?us-ascii?Q?jGdxmCDYJ8BPnN4aHhFa8lYpuVMl6x/3p3hUp5Vu/3H1isDa3xA+mv6+dIdp?=
 =?us-ascii?Q?0vGTSOECjtXZI9SmjKAWTyzZqRlIdqDGQHzd5buGDgcp2Epbdh2pfpeqnG7W?=
 =?us-ascii?Q?JjgBJ5Vhc4DI0AWT+C5W4eDVjRguU6aJtnm/zVkaJwWaqU7dcYTJn9q+nU+8?=
 =?us-ascii?Q?OnxcOTbG3K1It9Eyae6R3sglf+3/VLe7OmkT86wg/91+ktGFMPT6XFp7FI0u?=
 =?us-ascii?Q?EuZOoJhzICUneriTjRY9u2QWqfXQ9NwWfCiWSdcnK+FSH5vMyaBhlrVCZUVC?=
 =?us-ascii?Q?e5m3XhzsRF97RkeV4QD2E4U178yAVsKPXxezv4ufACTMPy3U1Qlns3N6qigj?=
 =?us-ascii?Q?INQMHXaJ1W7Y694+03r28RD1Kc6CNPgP+A+P4yEyRGAHiYM1kI95QDrXkJwz?=
 =?us-ascii?Q?8X1VZRv719w1KhUCmK56sHPEJ3ZczUAjpNCu26wr47pNUzuOqj7ZxIxKDdni?=
 =?us-ascii?Q?jCGNLInZiSky6Zs1XmLXNpf1LtbXIIPnhFaGCm90Y5bKLGFDSvvzM976DlGX?=
 =?us-ascii?Q?0BwftnKg5QGDpSSfJW0S+YA/lmefiUyZtMU6H4lE38Jfsd7qe//Xqf3WIs6T?=
 =?us-ascii?Q?9xGOAOlMP903KsCSx/8L8m5UvfedF0j5kssGc2crodkiWtEt2FJn37ekaAVt?=
 =?us-ascii?Q?pJLFzgLJN+32oVq0P6bo3hxkTlvH4sGMJTDMmwcVPCFsPv8amNhDhqmmGQq7?=
 =?us-ascii?Q?/DGPd4Erud3/TRdxY6QR8nAMdRL7HZoZWwJ39tCTxdtv4MoE29MKuHj72Qba?=
 =?us-ascii?Q?+4OGP2XolcyCKMELEicDiJYgG3QYz0ZgpcE2o0dlvKWdtd86IRIqqFAI16sk?=
 =?us-ascii?Q?8fYw+XMXU8XBWldRJhNlJn/YFvxFtvuISxkPvM/SZC0Wibtfrj7CCMOcioSO?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8900b2f7-7b61-4854-905a-08da5ffbc7b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 09:33:42.1491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h34nIFCkiOWo3wEFHsZhPtAnoRpwFmG0m0zrpEXjWb/y9eIU3CA9bt5TjmSmBCXNwpj2ZdiDz57PKzzXhIdhxIWkP7IIOIUnyhparp/a9hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4943
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ oss-drivers@corigine.com

On Wed, Jul 06, 2022 at 12:57:48PM +0300, Vlad Buslov wrote:
> On Mon 04 Jul 2022 at 22:44, Vlad Buslov <vladbu@nvidia.com> wrote:
> > TC act_police with 'continue' action had been supported by mlx5 matchall
> > classifier offload implementation for some time. However, 'continue' was
> > assumed implicitly and recently got broken in multiple places. Fix it in
> > both TC hardware offload validation code and mlx5 driver.
> >
> > Vlad Buslov (2):
> >   net/sched: act_police: allow 'continue' action offload
> >   net/mlx5e: Fix matchall police parameters validation
> >
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
> >  include/net/flow_offload.h                      |  1 +
> >  net/sched/act_police.c                          |  2 +-
> >  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> Adding maintainers of other drivers that might have been impacted by the
> validation change. If your driver supports 'continue' police action
> offload with matchall classifier, then you may want to also relax the
> validation restrictions in similar manner as I do in patch 2 for mlx5,
> as I also submitted OvS fix to restore matchall police notexceed action
> type to 'continue' here:
> https://mail.openvswitch.org/pipermail/ovs-dev/2022-July/395561.html

Thanks Vlad,

I've looked through the nfp driver and it appears that
nfp_policer_validate() rejects policer offload if the
conform/exceed action (act_id) is not FLOW_ACTION_DROP.

So I think it will not be affected by any new valid values for act_id.
And thus this patchset, which adds FLOW_ACTION_CONTINUE as a valid
value for act_id should not affect the nfp driver.

For patch 1/2:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

