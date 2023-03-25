Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D386C8F7E
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjCYQjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCYQjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:39:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2109.outbound.protection.outlook.com [40.107.6.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBA6D31F
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 09:39:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbWRGefnjON6NQbPMtdo1IU0nNCjtfM+bqjSAgXUy0+fsUa+EoagTvAZ95OUkWTaMB4rutpVi6rUKabnj52pQyxILtvbQusJEL4a+89dH46ywk1TqGJzP3tsWfxdewvwstwvFz3fLbz3HeTWe6Z3l5+07aqkU0kKK9pH8lk6T8L6boL5504fgOtI/seHD0muh2XUYt0m2Ir17Kdb5vnRdRp4YVAGOPZm7+EEs41UEbKi6HKuGQDXiJNGxSM8OgoC52NKzkpzy0UMQemStxZKioqq8gU4g4v+NvqzizdbpGMgeVsyV/Cc4tUbPM6npaTBjgz7kd6Wa+mZqKvqKlAOHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfNJoaXKjDjBktU29reB+KoRjHt1Zj7Vns/tuSSu+Tc=;
 b=e6dYWVkX8pf6vvSKyHYERH1RhCCMKGf337rbtCpQEUEKfFAmRYK1KnhmkUy0KqjCpzEe7L3aq2GtbqTOYkJCFc8BSwcQYGfy8pf2JnN/soelEsRT3oDysAW6kyhVC4DRQsEbUx7X3CxIwLAzkeaXK3DEyNq3kquN158knKEoTTpyiCT9sl0DvbG+edb1JoVtZ7fsPpgIA84pf87KpVb5Qw1VFENxE8a8mHffN/WY5JxvQESqWzkngRXLS3r4ePxp+/BF2iFqke6aBZRGUL0wLSWziMN70RvcEv0wnGYfK1rrICwb8VO6jvT4qzLZhG3O7EzWl9Bt1fSt/Gutsl5yyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfNJoaXKjDjBktU29reB+KoRjHt1Zj7Vns/tuSSu+Tc=;
 b=fC/kYFu85SE1WuTcg+qNb2zWdDQK8RSyRtLTBml0CFbDOdCH/sW398JA5ZuahskliHuK2Pjw5McjbsEp8sErDYtJmRON1SCKuAIbIHioVLThhqxSTp0XsTMPuHEh003ZofhFuHKSs1QRnxnezZ57rRELCcQPnm5ZUK2E0ohF0cU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB9413.eurprd05.prod.outlook.com (2603:10a6:10:363::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 16:39:10 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%7]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 16:39:10 +0000
Date:   Sat, 25 Mar 2023 17:39:03 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com,
        pabeni@redhat.com
Subject: [PATCH v3 0/3] net: mvpp2: rss fixes
Message-ID: <20230325163903.ofefgus43x66as7i@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR0P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::14) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: 15998863-9dab-4cb8-6bea-08db2d4f7593
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Upla/Q2fsra9m5N1AKtSLaJCk1Lq/LsycZD9PwLsi5m2A46MNyo/MPskJjoob345ZXJJFgZ3IKSTmLRrg3hE6x+1WmO7+1oRC5zTa9bhnhfQAmI4ZAZvQ7swYuM3HDcpaxEruEsAJmrneaXfLxi1BViqMISNIWvn3fLiGDRg7BgWlT8bUQx5T7K8Ad0bjo62WVJmvQnT3zEEFMUCbZklvFIDrDH9K9KpGwEq//VRh8XudUxz3MLmh1zzLLl7GYmSYaKkR7D6caNsUSQkxjaLznWp0JkbGjQgLLxUu0UDsFB8nhuuNTtVGa635QUShsFM4bhfOdp0AkmeudKo/IRbi4mzMpZEmpWf/207lPr2ZBzGRF7j/oACvPQO4DIykaU6yAkWRNM7U+hDHdZ3HEkBBDvQJkQa4+K66Og4AEomX9BPaYYP7EErClkpF0+6bggOiKyw2cOAG3Xue0Qb0wOr7HcKvvK4M6mbDVRKISIv1n7OodPojozkWhIyHLSgPsKo9+2Eo48MtKUcpXhKmBtGbJKHY5FKGg4nDBAOL97WRqQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39840400004)(451199021)(6512007)(41300700001)(83380400001)(186003)(86362001)(316002)(478600001)(66946007)(8936002)(8676002)(4326008)(6486002)(38100700002)(66476007)(6916009)(5660300002)(66556008)(1076003)(4744005)(26005)(2906002)(44832011)(6666004)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IvZnyInRgab7qnjcvfW5uw2uQ5pDViVX7ekK2aaAKnoVaLQpm/kwtpoL3swM?=
 =?us-ascii?Q?1qIssl8Mu+m1cJx37OUCD4HIpcQbw8bG2YCLqe5vpsBFJVobS7fz51ECDH47?=
 =?us-ascii?Q?gRqEYjkmRAb5DWu16uPuqvawPksAuKqm0GQzALR0Z06whYfT6nfzvdWmloxY?=
 =?us-ascii?Q?IZcmaCuPfzL/AB1kWmFd/hi+L6jOWE0YM3JsDkVwKfcHlnkGJOhk3yuAYSTB?=
 =?us-ascii?Q?9oMlbJ95mz8I9Ykvqai4ehsQxN/AXsfrq6GkUebgtpmM1UADjh6XAjYfRBlR?=
 =?us-ascii?Q?d1njBQLULOmnhagN6skPWQ8rK2cyLliN9B5ZPREMTV8Tj4dADSvPhx85m81d?=
 =?us-ascii?Q?OIXzbguyqiW2qvGjVoAFB/dFlnq6nMdTOzbh5qKJ1fs0Zk3Yg1HpYYLlGeDM?=
 =?us-ascii?Q?fhw1pFONUCHwZfSrm4lgm/OVDsnRDtCriYgzHFTWyNL+L98XJSKWTJKkxV37?=
 =?us-ascii?Q?i0B1mxfG16kKyJIlf/Ve+exWgXVu5cZplXZQPKwHQq0rwVvcf9lt0GyVjj0F?=
 =?us-ascii?Q?IvWD2BuNyUaNPiiRcclQ1gmzm/3ZUblcPhcicszqeMtwVrVZbBZSD3dfmVjh?=
 =?us-ascii?Q?Q+C2XNqBAWlDsjUCjzyoPfYSqVslDmw40oOi8PvtiWinNSyPNWvexza0dYuo?=
 =?us-ascii?Q?qcs7we3sMURNvasaD0XwDUhefXCLJCvE0xNSYWJ5VQvzgmHpoBRN+Xs6Cq0K?=
 =?us-ascii?Q?H1Ua7gGNtnl0FFqxGV+cmAC7QxWD+7rpQfcAkrthPJ4Kk8RfBX1K9r2x90AB?=
 =?us-ascii?Q?gMavKgM5lJ+i59reMsRA0VBS028Xdo5KJVErga6HYbBJ0W6nw8K+ROYIBPzA?=
 =?us-ascii?Q?50CGq9sbPE6eJBfpgfoRYf1Q0bXxpONNra0ywvtIssGake8Osu//mvhxUxyB?=
 =?us-ascii?Q?pO8gvZXJ9bkJrtAGpc06/VTiRN7Jp2dCn/YYyBb8ns2113441hghGqOn5AXZ?=
 =?us-ascii?Q?Yaw+u6QsUCOVG7HF3O1Ft+alRCJ71NmlU72YXtO+viNtJVxpUuUa8dgaAoGQ?=
 =?us-ascii?Q?C3rtaMrAHgoY8AHDnOeiYhcu5qVDf4bGdhXwQTCz/q+yxbFzJE9nQnFzu5q0?=
 =?us-ascii?Q?1TX2sHB1KsdaLFB0tOEnNSDEi0pCfMv/cue3skdP2qeSvZirzfmkbNPr9RXW?=
 =?us-ascii?Q?iipkE48TO245aC1i5Os8TNYOsFmn+6pfzOpo0a4PTL9Hw79QPe3neLPUvzi6?=
 =?us-ascii?Q?2FA3EZT4wRwAVlxnGDEdoxCRglV8oyfXaEeWehPUrhEYyV6EKxQUWdSB7KbL?=
 =?us-ascii?Q?4TiHkeKSO6KbsNi6A+mEdsG9y+f6A0Lkf9JoywrrlG0b582wBHPt8yW+DgLW?=
 =?us-ascii?Q?/WSV8WuLBLKNeCK6Kpw6zNP5zLZKu/sNQNfWk43Gp5qKl3bt5lfE+UQyF6hz?=
 =?us-ascii?Q?XDDuovhNNt6DR3oWlt93M1JQrX0SgUHgisaODImw3oun4jtas/rJL5kp3bwh?=
 =?us-ascii?Q?9wZnsXpKs+xdg+sUcwY3ndsZHxT1cchVYEcSbwPNGgrvggxu0fZYnGuJV/xf?=
 =?us-ascii?Q?ldeOpwfqSrgCPAiqCPALcRDPoqP9r6haHZqyyO1rssSX7s1mAzDcy+ck0Ri9?=
 =?us-ascii?Q?2nMNzeGetQggrvnaf8o5FvLGoo3FnWrhscUxOKnRMFvBAnsIKGPd6W7e4Foi?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 15998863-9dab-4cb8-6bea-08db2d4f7593
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 16:39:10.2880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e406iYm6oJxt4b9U3cbyqO75tmWiqqhOy5IHVazlg2VCkD6q0iqqZQgCHY0seqM0Bf1/PewIIatfTtVMfUevT4FXXoCay3PujXSHvbFJtEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9413
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes up some rss problems
in the mvpp2 driver.

The classifier is missing some fragmentation flags,
the parser has the QinQ headers switched and
the PPPoE Layer 4 detecion is not working
correctly.

This is leading to no or bad rss for the default
settings.

Change from v2:
	* Add cover letter
	* Formal fixes

Change from v1:
	* Added the fixes tag
	* Drop the MVPP22_CLS_HEK_TAGGED change from the patch

Sven Auhagen (3):
  net: mvpp2: classifier flow fix fragmentation flags
  net: mvpp2: parser fix QinQ
  net: mvpp2: parser fix PPPoE

 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 30 ++++---
 .../net/ethernet/marvell/mvpp2/mvpp2_prs.c    | 86 ++++++++-----------
 2 files changed, 54 insertions(+), 62 deletions(-)

-- 
2.33.1

