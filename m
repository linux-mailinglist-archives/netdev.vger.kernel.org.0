Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0615A9FDC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiIAT0R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Sep 2022 15:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiIAT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:26:15 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1692E5EDCB
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 12:25:31 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2043.outbound.protection.outlook.com [104.47.22.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-46-hKZQW-0cNqGE46VUpa8_0A-2; Thu, 01 Sep 2022 21:25:29 +0200
X-MC-Unique: hKZQW-0cNqGE46VUpa8_0A-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0167.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.11; Thu, 1 Sep 2022 19:25:28 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%2]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 19:25:28 +0000
Date:   Thu, 1 Sep 2022 21:25:27 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: possible circular locking in
 kernfs_remove_by_name_ns/devinet_ioctl linux 6.0-rc3
Message-ID: <20220901192527.GA2269019@francesco-nb.int.toradex.com>
References: <20220901122129.GA493609@francesco-nb.int.toradex.com>
In-Reply-To: <20220901122129.GA493609@francesco-nb.int.toradex.com>
X-ClientProxiedBy: MRXP264CA0018.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::30) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a62f178-9284-4b6e-f630-08da8c4fba2e
X-MS-TrafficTypeDiagnostic: GVAP278MB0167:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: DoonaH6d18mTUusXKqaV916e7q6whrj0AwUBiIPfWO1WoqvbvZrgDVVEvsvqF5+V3lMSN1FkTBid+hRRzR8EXLa+aDaWmdV/JC/6jIu1mj8EGb3FwXYQmc1EwcEcflFx5J2xBF8wrLcH78XO3hV7D9g+afdWi3PhbKLz4KRdaS4Yr31MXl+GkzG3q6QX/3cI5h5buReoRQ7zq/YIF4fodOUAm7I99HdJh96fJxcxjQs6oDXwkR7kfOVhAc/0M9D24pzuBPTGEtxiWff81soevXJAiT1yocuMeDb5spSnB0H3MGWeyR2IRZFqVD5jwcUAJAyFbV1dKMgKnnpO160ddH8nStPf6uf28bpa4i+gnymmov9ZdDHo9DFMppkdgG8OPsOjWwAuKtSUZb6qS81H92Oocn2ryiKemjuz8PTC59K/t5J0I8HQIbFC3eBVaeJQEeCcxu6lDn3GnNoqDPEnpqz2cMUN0OYKiLDWEeEYLXKo6GcnGlT/iXDfum4O9o4DnYuEKa9wip7ZLpNj+0Se26ScT+2Q2Wzgh/pFLX4m4XIgc8Ye2Bz09pXXpQGlQseVM5ZHV7JeImvlPWlpCbXriJGgb1gP5kPJYx53R3MMqhLy2WRaBmTNOVJeUwA4o2aZZmEdEaESUnAWJsQaFeDPPy4RV/cAQw+3un5oZrEyE3uJR5bgSdt8g5uZkZ7JD3WWY4nIKjpyGLmyUq5i6HEx1OSHQFY+PgL118HUhH4tz3NgXnHOER00RFZ8cvlsp+gC7+5vXOltYqInx24GBz31jjh+4EcDeJq6l1T6p1+JUSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(376002)(39850400004)(52116002)(44832011)(2906002)(6862004)(8936002)(5660300002)(66946007)(66476007)(4326008)(316002)(6200100001)(33656002)(478600001)(6506007)(966005)(8676002)(41300700001)(6486002)(1076003)(26005)(83380400001)(186003)(66556008)(38100700002)(6512007)(86362001)(38350700002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sEJdF+oUqVMD9+IGRi0Jv0pQXxnIYpvMNqSe18O7NZG+6uMuCLXmtXaPSLpY?=
 =?us-ascii?Q?eyYLFUck7ZUeod9A9Sy/acUScvj4rpcx5/xIUPKDfko+GHAhscVau//xWeJM?=
 =?us-ascii?Q?LUAjpegDUBjboPWGZ/uCvpre2YU/65/dXGNrk/Gi6yN1kt9AQZsnAZZkf08U?=
 =?us-ascii?Q?GsxcYl3E1BSEMU5/ahA1ScHZTVViyOnof9QxXN4g2Z9lSXecphLdvPCVn3x3?=
 =?us-ascii?Q?uyYYtg2b2F3mQQ8MDfKIuX5/CXjj+Jfoz/ytdhMeC0Q85+a5/KumQiNHDCK/?=
 =?us-ascii?Q?FNoFGEcZbgG7+tARMLZdLc7owuP04+sw3ewBP2zR55cisTFK3GCzF4ohRgrS?=
 =?us-ascii?Q?d226dQARe0DkmOfloXMg1NJE2OyvVZs9yYqLRe9Xc7Hz2DYLpz2Cct3OAiQL?=
 =?us-ascii?Q?uZu1Ai25a2fIRLAnnm/XjwZqm3n5JW/q3hGvIa9XkZYc1NzobgMz9Sy2TuG4?=
 =?us-ascii?Q?F3pzppwqodq/2uRUVst89EFFCe4vx5n/k/Yj3ZlmLPc5+EpN4FycU3WYBPfe?=
 =?us-ascii?Q?5cayPx5bxk6hdBkyOr/XB2Q+/GRAiGMYdsDBw6QEwDXQ5boUU/peH40+QyLF?=
 =?us-ascii?Q?vDHxOp2CFvpy2LnoRzRbt7DrPfaYFIkF7fmsMAT3D60kvrJZLVDkVZ1nyEex?=
 =?us-ascii?Q?bPp3LYDHZ41wVymp5Oz03GQ/sviCaeE5niWAVi5xQLRrz4Pl5w8YmBpk1/X/?=
 =?us-ascii?Q?R55ZP6zsp/lYo93tBSHMh3RL0uF/LvyhQjIutxvy7ZbeZ+A0Bkb/kOt6Priw?=
 =?us-ascii?Q?syL85sdIP2xxPvWMyIAvkbOvF1kwMp0pz81Bd1Kcfv8iw09nsFxuODI6JaJc?=
 =?us-ascii?Q?D7N+l+aVIZ0I1yteavfqRUvtJxvPiqT+1iyimBwVt3RSvBwIGWgX2F9oP6LC?=
 =?us-ascii?Q?AsCut9JXnDZ7tg0sXO2I02OyGiCmk78//SsHyTLd/Baj4qIb7JVNLMiZK6Up?=
 =?us-ascii?Q?IuROQfzn8I04jvfsiP5ii5TzmlBSng4biCjzRZysMIJ6vBaHtYLhKj5Gy6o/?=
 =?us-ascii?Q?LRjyBRuRtSLK6+hZdvng2h0jcFkl5QFoJb+BpSlcx1/1wRBCQ8jDUjCNMRFB?=
 =?us-ascii?Q?mosCqOjVRUrF5zUzmrjE7ebPVRhG2ldnkRD1zS8U5EedbDXfREz07iavFOmz?=
 =?us-ascii?Q?FYZbsgNJTmYVo2+g5s70SK6B7QWHzB5wG2sOFPL24pTpj0Hde6MUrwkzanin?=
 =?us-ascii?Q?iQESDGWaD3eyflhUqgi0lLTXeXv7/P0xuJ0z64eWXBpccjiyIu6BbkRsuMrl?=
 =?us-ascii?Q?LxYrMlWNY3fTJYqOM5fzg9AAxq0WGqTBIZLEeKg+ex/13COfJtV1Rsfkl91s?=
 =?us-ascii?Q?2VH5nMqWZyDqOOUT08fU7teDDlopOjQ4mGiLHTnYirOq5VDh1j5YWJPLPXjV?=
 =?us-ascii?Q?FII0qUkcasuTwPyKpaufZSAXxExUKZIImEYfeDiLK97tD55K6CAKPcjBqDgq?=
 =?us-ascii?Q?pViQISqAEQ96qpK6SurOfxjTT2PUvBj4OyIlJg4f62lJS9Euil2+BMz92L5A?=
 =?us-ascii?Q?RMhI8p2RUBAFH49WCP+tLLKfYvihDLaNz9nzXtBtQRmQ6MmAqrTXx7kMtGGJ?=
 =?us-ascii?Q?IzIO2tiOd/M4RE6tEr6MXkuzQ4JqN1NQ8G6XPIxzwDlaG87iCtNXD/tiRps/?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a62f178-9284-4b6e-f630-08da8c4fba2e
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 19:25:28.0916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kd1F7JDNj82/FTNa6NmPEqIaphJsmJtA6YmQJvTaPWRPNDTs+tywdwrBMJVRuNbCSDcYLflSLjJV5fYNUh9Yfkgb4582K042o/RR/ytVfB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0167
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 02:21:29PM +0200, Francesco Dolcini wrote:
> [   21.629186] ======================================================
> [   21.635418] WARNING: possible circular locking dependency detected
> [   21.641646] 6.0.0-rc3 #7 Not tainted
> [   21.645256] ------------------------------------------------------
> [   21.651480] connmand/542 is trying to acquire lock:
> [   21.656399] c2ce1d70 (kn->active#9){++++}-{0:0}, at: kernfs_remove_by_name_ns+0x50/0xa0
> [   21.664516]
>                but task is already holding lock:
> [   21.670394] c17af6e0 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0xc8/0x870
> [   21.677441]
>                which lock already depends on the new lock.
...
> [   21.945318] Chain exists of:
>                  kn->active#9 --> udc_lock --> rtnl_mutex
> 
> [   21.954902]  Possible unsafe locking scenario:
> 
> [   21.960865]        CPU0                    CPU1
> [   21.965430]        ----                    ----
> [   21.969994]   lock(rtnl_mutex);
> [   21.973174]                                lock(udc_lock);
> [   21.978709]                                lock(rtnl_mutex);
> [   21.984419]   lock(kn->active#9);
> [   21.987779]
>                 *** DEADLOCK ***
> 
> [   21.993745] 1 lock held by connmand/542:
> [   21.997704]  #0: c17af6e0 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0xc8/0x870
> [   22.005191]
...
> I have not tried to bisect this yet, just probing if someone has already
> some idea on this.

Commit 2191c00855b0 ("USB: gadget: Fix use-after-free Read in usb_udc_uevent()")
introduced this, see
https://lore.kernel.org/all/20220901192204.GA2268599@francesco-nb.int.toradex.com/

Francesco

