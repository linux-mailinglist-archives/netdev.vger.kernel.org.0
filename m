Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727836E4A16
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjDQNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjDQNik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:38:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2097.outbound.protection.outlook.com [40.107.237.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BAE7EE1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqnGTZYKWJiG/APg56k6cVi4INOnmpHxC1ec6q7kWX/Tww0P3xq7PTy4VfJMmZk0rB9JbL+Xjx+BIbCXSNlgM4EunxLYyrmNxrSyfEGmSRzqy90Jj6Ofa5itDEJGzGSGbUHkVSjFoEL4Cw+/XJ3AMpzeTlgEXPo7opUu2YZO/oRdk8as/i2WFLfzxcpZ36ML8isBeU3pZ8YcIBBykK9mbKo3ZEuAkNIgNR+tgybSVtBrz/3JFT9eyDphD7/pLQ9KbNnpYYC/SuuIdW6b0BJR6u+n82vB6PcYrUBsFPQZA4ti7ZzjpV6aIhfXRcTNAHTFFoMw3JiHjAdPqmUPQRzO0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7O/km2vh3r9bB5rreVipSugruO5G6kfKlf+5s6r2BLo=;
 b=XG1UaRvirK6UEbjU8/HoRGrs6FRXX+EEfwGNE0Y8K1Hdmoc8kkEBoiYeRhOhRYFJZG3UHLImvsgiNt6uQyap22G1el0ELNcBwXYN1nyZqz9qsaGjrCpIJcUCK6++tNr9wMMGr4pnulb1/B42qOnaZbXb1kkEWR1eQcR3RvoNUv593F0Dmd/bRlG6XyMnlCOE4CsL9W3YMdosuZos21+utI/qczsNHWrJaV6bfSqWlVV9Nrct8sb7NOvyeCaHBhzaV7yarwiDjL6PIozvLURO7WG/hoPwXXX7xibBT2KuEFjxkNJklDmvb4QjPjGoFkeGMI3DNeVkzKDF6k1XioG6qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7O/km2vh3r9bB5rreVipSugruO5G6kfKlf+5s6r2BLo=;
 b=Axmj+iESUjfm/0S1A7/onkUsiFktoEfTiTKHhzY1FsK0QIVdYtfpCl9BssdI+UKUNBh9EJQ0hDO6EPuTgY2f492d8I/4U0DY1d/eyh517JGA8hZkbqs3MU9gtvR4ziD/q3qz3paUcTLNwXKwr4lqb+O81LC5flPBZhwITkm4rGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5444.namprd13.prod.outlook.com (2603:10b6:806:233::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 13:38:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:38:27 +0000
Date:   Mon, 17 Apr 2023 15:38:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec
 packet offload
Message-ID: <ZD1LzTfcr6vIVZCW@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <20230416210519.1c91c559@kernel.org>
 <ZD1FM0g+KWo5GtlA@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1FM0g+KWo5GtlA@corigine.com>
X-ClientProxiedBy: AM0PR06CA0103.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: 1320d5cb-41c5-433b-b41c-08db3f49062f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ppa2lC6dWqh1s4XcGtZXE7f//BzrustUa4jlE4hSdX38JcQ+VFVXHdKKhwgI/NJ/kRWk6E3zaqfghhj2v1UyVeLUCQQlSV43129U+ImVunSoZgJ8HZPTrExEZl77JxBrBc5wQDNSDEo3KWGXLZMYpIHhimn3C0Jwt421tB8GJGttIA7yDi6Qd5pPOi9VVqUOwTAsDhBTJPhfVb1EyLT8ZSos9Ge1eCZuAVAPtzQAHZKe81z3L6NFjUFs2SJBVtP6Gk7cSta3Uj6CJQmoqIbwXMzjiOftPl7T02aVcPbaJ57TSj76isNf4i8I3mGXi+JaW5DslIBdYbh96Vacl9dqbndebhjJICllu1BuBaJW2xggDvelU1eW0l0wy9oYBK00QZsdPFQIofYYRTytbxiNRdlkYdJDf9uQpc3E5AXIS6DwyTIemSiphtqC6xMM6OtOnF23fDzTkpl37NsfvE8n9QhX/+Qwai+DPwPMV/6R1HiSq4pcQ90xVwXa2hfK9sFvALfLIuXh0ntgwy4XD1lGWXz9iuNa798EtGihfNhxmP4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39840400004)(451199021)(6512007)(6506007)(186003)(8676002)(2616005)(8936002)(83380400001)(478600001)(316002)(54906003)(44832011)(7416002)(41300700001)(36756003)(5660300002)(4326008)(6916009)(66946007)(66476007)(966005)(66556008)(6666004)(6486002)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c0AIIaNUzC6NElDlOm/wfyG2Oz6rRfxEFa6Hcc4EHEdW0X/+SqXSk9n7Xfk0?=
 =?us-ascii?Q?mGghc0S2nN1tSjCuKLUgQZzfMjm9eUzsdxvd9Yw47dV6FIr7E///F0qZR/w6?=
 =?us-ascii?Q?OqLhtaiUbjh6JHIaQ2sYb/hmg8sXgfwuin/y6FrAtkzXBZXA9pfHR0dslVHs?=
 =?us-ascii?Q?PoV1WA6cCBDFf5Ci6WAhK5+vL8/EmTkRG2uR8q6UcG0muCR0BQ7r2reNiv1Y?=
 =?us-ascii?Q?Qo1FkA9f+Kma1vXEmrAR73m6Qpy1RqFzb/2R62vPZh8wmU4YzR+Zay8mist8?=
 =?us-ascii?Q?sefANtPs2IZEaEGJtiC7o+E3PJjyZ6OO4h8La/9Iqd+paFVrwiZUBLaRg+2/?=
 =?us-ascii?Q?2kpM9fKcd7QkeEFaGFv1hbEKcWYdSkVs2bqrXXxJzZS/bUQcCKZ2eL8rRpKM?=
 =?us-ascii?Q?XBXn2uq5voqenh82nNpNPkGTYdIco2+hlNOLrlD8QENz4rfUGK8jg+nuxpd4?=
 =?us-ascii?Q?4mNO8ghJUlqGaFqaWgMmnzNxy8oCilj+bYFsM9iElF8gxCgIRhTuxYLvSooE?=
 =?us-ascii?Q?6CWBVSnKZTbQKv4KGpL8JAQt4Grv5dyKHKD5m0FYdOi8VhLFvzUmn1cFEG+P?=
 =?us-ascii?Q?4Vy/KOxvnWEDKqzG3FJ+BA4uVR7N/J7TVr8MePAeICtI9q66Q/iyTxmVcmG7?=
 =?us-ascii?Q?Lp865BWZSZPuKggiUF02xvuExS5UghWo55tenQHt7Vcv07S/RUQZ33xxI2Eg?=
 =?us-ascii?Q?3gm2LgxbZrCoCOZBQI2IbKlftNXm/y/AbBUnXw7rHlkC3c34EekYx5ymIKbg?=
 =?us-ascii?Q?gYz64HD0CaEct0LL8csiqmmOwopxKSMqyJW1SAq2/Rlgesq6/xLZS6ygfxPr?=
 =?us-ascii?Q?tN48IB3XKuVY+jGRwsr16cB82ZBRdb85eWQzV32DllP5Vfoez0DklPOoLhsn?=
 =?us-ascii?Q?2Az+iILtggEjgoSlFoefl2CPmC4CeI2AywZVzApwZZjAMceGFtTNxHg9GtG7?=
 =?us-ascii?Q?r1TrEqjzohEWWahLrXEfCeGgHhw6AyHq7d8isNKHdZto5CTyjv5iYha4tNvW?=
 =?us-ascii?Q?QVzVHNnc6kj3TjPHIxC849Z8JYsIEmpQr6NINg1HNMmapJbcl3LlMJzU17e0?=
 =?us-ascii?Q?0/CtC1OixUDPjUwNAYG0vLvKrkoUyHtX+sYcUT4dgW52/byjs7q1s8JmowKj?=
 =?us-ascii?Q?ECxj7jAV9W1g/MZfFIepHTxwumidRYpw4S+KhNEQIh10kESZRulRQlAxJfCl?=
 =?us-ascii?Q?kkOEr+sSHt40gWproKgfbvVipLCaWX5LhBa+luf3y7CM8i74mN9Xr7PAZHeV?=
 =?us-ascii?Q?FbPWjAAC0AA+Zc+TA17XxNZjp2mDYa6rNlx9YFW3jYHwRKl6MJn6BAc3Te06?=
 =?us-ascii?Q?zoVdvctTa4DJzQkbGeZ3nC7QBMFcLgcOGVPHxAOUikx/O9y9/N94XhAUeJG9?=
 =?us-ascii?Q?WzndACz5/pSWN3TfpSttY9BuhM5LURdmAo15A2CyBJIpshvem0DjwPLoh9Md?=
 =?us-ascii?Q?byoyK+/SEOdouXqEh8x0qvaMpOm0Qhv5NK283o3Xv91Tsmgl6gT8WyQQ2+KR?=
 =?us-ascii?Q?lDeWtEsOoLFpEhPVoEiUmg8FzkxqHJ20Q3miAvhNYFyKj2EqbLDT4gIKvF28?=
 =?us-ascii?Q?shOK25Uc757rxxH/7q2F91iKSemhJ76Gyc5X2lLwOfjL1IcELMYhzM2w//6W?=
 =?us-ascii?Q?W/BBJbxBmTpRCE6BMNvfS1lHehf8CZPsW9V/Pa2rUl+mLszMjAI3N+p20Y/o?=
 =?us-ascii?Q?tMtuaQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1320d5cb-41c5-433b-b41c-08db3f49062f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:38:27.3214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMpQOAxFFdpOEnbr8uBCp6FxnO7GQ3SYtfVkWh+I3JYmi+Qfy4M9S0ifWWbCcI/S92lAWaHGn6tPDhnVZ1wKaEA8nMhFw4uoICkRDqaoqhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5444
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 03:10:33PM +0200, Simon Horman wrote:
> On Sun, Apr 16, 2023 at 09:05:19PM -0700, Jakub Kicinski wrote:
> > On Thu, 13 Apr 2023 15:29:18 +0300 Leon Romanovsky wrote:
> > > Changelog:
> > > v1:
> > >  * Added Simon's ROB tags
> > >  * Changed some hard coded values to be defines
> > >  * Dropped custom MAC header struct in favor of struct ethhdr
> > >  * Fixed missing returned error
> > >  * Changed "void *" casting to "struct ethhdr *" casting
> > > v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com
> > > 
> > > ---------------------------------------------------------------------
> > > Hi,
> > > 
> > > This series extends mlx5 to support tunnel mode in its IPsec packet
> > > offload implementation.
> > 
> > Hi Simon,
> > 
> > would you be able to take a look in the new few days?
> > I think you have the rare combination of TC and ipsec
> > expertise :)
> 
> Hi Jakub,
> 
> certainly, will do.

Hi Jakub,

sorry for the delay in getting to this patch - I was on a short break.
I had already looked over v0 prior to my break.
And, after reviewing v1, I am happy with this series.
