Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10768689BE2
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjBCOec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjBCOeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:34:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BE61968A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:34:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po89mEu5Rx+LTHtCulVBGnOw5CmNZI93FY0XMR0nw1rNj5KaygXAfESClLLNqU2bbSIZpMyV1/wTtKCnOdaf37iGMK8bGwiqXVgHGzC0zZU7OlXm/uBf9Osq7caUBMU6gJjTJPNvLz3BrfR9QmUb1uYxWcx42DPuXT//bM3pAJi2ijRSHFOusnoOvffEy83/jv5Q8JhxdT7pUbeyOhdcRzkFXsHLMtfenVfZDHz+f2pSuyrgqv/U5EF6ks8nhKPR1N0TTw3kCI845UgY4pTNLPTpdTC4cJxzgRBZM4BMHa4jE20AQ6Szxfnp3WgcKFJca1VIYi0SHuilOvysKY12+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbfEZu8stpX5mmDIFuW2jTgha/R+jsfUVQQ9ad5ZsSI=;
 b=BbcdGAw1WwND92qoB8/3wyiK19ySluaRct37E7taxgrUMkZNmN2F0a9Xb9/7P1udpE1XZsoaUwrUiqiKG1JHrDCDgeCqIGTcD2f3ZAVaPgaSZoEtBW/sohKJYGDlkJe6P8RA6KG3kJyiLfZlTZdm1vaA5ulNq5R3CY3nIVRD0qGeb8Cjhh1N0JoGudDaNwxl49GokhE3JCuMa9zCZ7vVs8/+wDw9oBI0vh6Xe6DA3ER86PLSP/owsAhzCJakfML+5x1th+lqyMQgG3Iuo8mMpmBfRi5VvKj4BduOz/QrJiSzZ+mFrxCDx4FMw97cje5WtUQR3MwobJrEbJwDADoSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbfEZu8stpX5mmDIFuW2jTgha/R+jsfUVQQ9ad5ZsSI=;
 b=BxQ9vO8EIefXk2OTIExgZf6ifoe49k1pRIN1rt0gFtMasY2qlSNn1psZp20Pq32Cys/QHH18mOyV808ceaGdzZ/oN+VXisPIJWtjYPHL2A0WExFLsg1Ef6H5Wy4C51i5rA4vWh0G+NdbUL1YgjZtvIpgJF+iW6hE2nr7uhOpTl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4654.namprd13.prod.outlook.com (2603:10b6:5:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 14:34:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 14:34:20 +0000
Date:   Fri, 3 Feb 2023 15:34:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next 1/9] net/sched: optimize action stats api calls
Message-ID: <Y90bZu6a5xeaTmVq@corigine.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-2-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201161039.20714-2-ozsh@nvidia.com>
X-ClientProxiedBy: AS4P190CA0030.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 052708f6-66e3-4898-2eeb-08db05f3bccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vh+pnoQ+T12CvAcABjULSnllWCW0abFV/IbzNOCZO5IoFsuJ6L9Bee+/XV1vZKqxSIZSKrDK14760bUWCAMGevu14yHht35ScSYAPfdnn7v6n9oZh03ElPjtA1elWdKizs5pGv3GL0SWnOYADrOUnVprt9P+MM/hg4RXYvyR7Q+N+96XXiYudiFJqlLcCL1Kvm+YZ9OTeGcF3pSfGccp80bRtrOgnsF2SAbazChbXD6lXQw7NnfHLPA87VtnTCiAD9D1IhZ0f8bgyQc2Dmxs6ylQPbXyb46igc+PFGq9GhfbPy66062XprFWTS2IpgThtYG75/pIYiH8xbLa+j8506zWYWxgmykQfgr1TaV5VpUOQOG1Mexu+W8YtE2WPJPGz/wo2AV4cg8eZcpEIioyjCizisV+JOf3vQABstQCJGjn58xB11uir1/djzl2Lw7KYDqNhtGimcXc+0ceePgwP/aYHCZscvk2ol9GfMfd4dBGhE8EkCAKeNuD1AI1H2gGhzloEGFCKuvXe1h1ccv4xZoq/qB6m6Z3TLdbU1PF+Tt2ZgoqPV8nLsc8BevbkYP3zWm71Kc5/n5fWlwehWbom/IOqPdoXu2f7LU9iaehvQlM4LmO9jJk+Rt9rgByzWWZRxZtzy+7TxBTyDC1fZENfMuquBF93bdT0865p/AqMfk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39840400004)(366004)(136003)(396003)(451199018)(36756003)(38100700002)(86362001)(316002)(6916009)(4326008)(66946007)(66556008)(66476007)(8676002)(6486002)(54906003)(2906002)(478600001)(8936002)(41300700001)(44832011)(4744005)(5660300002)(83380400001)(6506007)(6512007)(186003)(6666004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nveWbD1kYyjUI9fk738jJ2r/hR8+AvObEL4EYwol1ofJaDuQkSEX8QXJGnwT?=
 =?us-ascii?Q?c9Rhlck5HZG0QiVyYzbBmdXhpUwIndZrvyaL2ELwGyzZ67CH8ou4ZnVzdFIS?=
 =?us-ascii?Q?+8edZOofagC01k+uGyQQUuli7RJ/oOSIvc0DJTh0EeVFznTiPKquT98iZMt/?=
 =?us-ascii?Q?JuJDJABAXePvrQSOD/Bm6h0NxJlQPP4G3C7msl5s8JOOaWD/YzAzTD+gGzz/?=
 =?us-ascii?Q?ePZTNzbuabKbY1ilzzrIauvHyVnkbMB44I1DMcZZTRKV5CgOOYarvWdh0fX2?=
 =?us-ascii?Q?4GaTQWz6QYKfUKz6CXr9Ersy9KcoztVeN1s5+maDZosiTdzbhE5tY1DLAo0h?=
 =?us-ascii?Q?BombS+76fX0iZQstZFbTxodK587BsYApomx0PIMIcdxU+cy6ng7YvH7FDot5?=
 =?us-ascii?Q?iTaBgO8WQkGejJkiVU1bvtAIw2kKSZd6VTxfg2bP5OjA/ix22X7ms34Ti/2A?=
 =?us-ascii?Q?y/8xOcloIPe9YfjrgH87A658aST2FiBzcyBzl3qwhAxc/UoA6F4nl3F6+nqi?=
 =?us-ascii?Q?1O1rUmboepLr5XAJYh66y9YDRJwN6z5f0kaNhqPAbQmId4VieKggghrEp0VV?=
 =?us-ascii?Q?CiRNwUJJLPxF0ln4rFwVZ1fwZzth1yDBQxq+6qhS5aDmbHI+gD+fMBH3N5Ni?=
 =?us-ascii?Q?ifumbQNncTPqR7QrlGiYkrNvBTvgFImXMdmH12M9btY9Q6JQP0/gAUa2K4Nb?=
 =?us-ascii?Q?09/guYWenppTrRn+t6G0wWYNq8KJGKqwX4NdaIRrwTRDA8K8+YN2N0rxlXYn?=
 =?us-ascii?Q?rb6hvuXTfz5uZHS2wuvkR9e8SbWtUgS5Dg6hN1YX1soK4fVOvCKOXhJtot7K?=
 =?us-ascii?Q?0tpdFIK+QBWzxxTIBqm6zN1Ef+GlbUDkRjIlc+i4Vq+sr8b32Yrwyh+p+KB8?=
 =?us-ascii?Q?qN7ic/XPQ6EM7jgkBeN6L27L0AT9loO5x6PMOuqT+12yJO5QXIQ1qFspZKbD?=
 =?us-ascii?Q?8+Ekp8aCVL7eubIpXYSftCkjlpVbzNDFE4c8PNhHzXs1Ac3GgOgDwfa7Pw9A?=
 =?us-ascii?Q?BJ+csLrK9h8/q9d6Hpj3hZwDA/zZ11aJL+nZ9rXg06pViLPT4f+E2of46rEb?=
 =?us-ascii?Q?o0t1YEFrrHVPVbH3IO/rsLxdkc3caqxHcE3s2/NW5aRLNLvFZU5bFdHTNzM/?=
 =?us-ascii?Q?Zx3WDe7kNIho4tEueQrCvjYdI5cJkYnxcuK4irqS2XKqcWo0ziFX7krN5L8W?=
 =?us-ascii?Q?3BddvK3nqaaZfVRbdsslnJTP2FbHCQ4eHFuxrHhvvM7GxdfaDVx8gHe8Fn0I?=
 =?us-ascii?Q?vCJYu9+7suUERi8A+OcpHxRJvePCxg9Zr9iw4VitoSIXrwbkzWRBdNvP+rwr?=
 =?us-ascii?Q?2Qx129bQsoPIc+90ubpx0aqtoP+rTvd4ANl4gEB0ftLZV07BDtocytqO/V0m?=
 =?us-ascii?Q?XK45FQqLX58SwA2XkSs801QC3Nduklm7pRjnRaVOrzSLqSUM6q2z7PM2AV0z?=
 =?us-ascii?Q?EvpIQdcCpxWXmafy61RP6NIu4x6D4SpOahIcFlnPDvCZrDaKh8ZSjoXiCYpt?=
 =?us-ascii?Q?rjf3oKoyo/e+iGCbQt2/sw1Pdt4DXWQzUFi11uVLE30pFY4RZ3S2atwPlZLp?=
 =?us-ascii?Q?qesIkO9KRwcb7MtAnIj7l6K3LhNGPT/U+Cgl6sIt4DYmQjgRrFo0QX38IRoW?=
 =?us-ascii?Q?ijKxBhUyqv8NvyAyHeJb+Hn1kPUg/cViO8xIo79uNGDIPmuFDbJ01XDJo7z3?=
 =?us-ascii?Q?Y8XDdg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052708f6-66e3-4898-2eeb-08db05f3bccd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:34:20.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDOuSTamqmAPEQmfbPghGPDpuwxJbxyRX2OSVlY8at2xwnqR53jzcqpG+EwIJ2dgpmdYuA28nxcUL5YeHtOUoTRJL4cuuYKfYr/LqatZBI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4654
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:10:30PM +0200, Oz Shlomo wrote:
> Currently the hw action stats update is called from tcf_exts_hw_stats_update,
> when a tc filter is dumped, and from tcf_action_copy_stats, when a hw
> action is dumped.
> However, the tcf_action_copy_stats is also called from tcf_action_dump.
> As such, the hw action stats update cb is called 3 times for every
> tc flower filter dump.
> 
> Move the tc action hw stats update from tcf_action_copy_stats to
> tcf_dump_walker to update the hw action stats when tc action is dumped.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
