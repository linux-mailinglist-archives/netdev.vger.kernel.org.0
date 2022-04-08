Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0924F8FDB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiDHHxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiDHHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:53:16 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2128.outbound.protection.outlook.com [40.107.24.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2781F42D9;
        Fri,  8 Apr 2022 00:51:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMp8OyRmRGNG7enQaB7/7x4TgP85FqI+N7BdGiH6qCh6IBXBKQz+RlYLY0wrC/H5xp45u2N3EwjsXwKpaynYFwm4lsX0hTXtedmr85P+Ah9bpBQKRluMZ+hmgesH+Oigdd/eACDYuzgIUX2o7SEHcFmJrycZRfCTyEWjrldDNzGfYdIr21FnWvjUtrLYfUtjAOhSX+l9M10OLcavGLgc/BE9BlB6MPRMpOQ9e6phkTk89NpvlPWxBUC9agOYXw9HzHyY7HJzefrvmdoQDXe2o9okL+igffeUU9OiFRH57odZwyJzfxG0DMKRrJoPyLMyYg7zrhUtNE+MBmzyPFKp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKXRH8rOVFwlNIkLFMsE7MbPvvHUeWBKZ/VCp+LW2B0=;
 b=eLiS8wd3C4qYH5p+2hFimdMgQ8ZVagqHywtsspugp6isdhKBbeUcnmDVe4w6PzOk18XBt1dkp1Z/7HhGk0wCFrUe4JpsZkMeB0lUEOnitOVTdSdpfzGJo+g5XeJtJURliscZNXnu+aihdXCYCD2Hj7PKjWQdkyNlVps+YxaXJyMlr3OWr2INJVjBJjap4mKHtjiziIoGxlIjbO2xBZ7sdyo+iSQBIxxN4hu0DtSzWv9P6KYt9Fqg/Y1q8ZIyBuLFIMczaf4spZZ32KSe/XVaVqTdujSjMXS7iGUxzb5VAIE9XkuFRKu4YHouxWvQsfgqWRrtkAuOgCfpSCV1zYfAvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKXRH8rOVFwlNIkLFMsE7MbPvvHUeWBKZ/VCp+LW2B0=;
 b=lhX3GGoW3lM48sGR/8rWJuIxyxarAMobZaUyaIV5EGaAoHJSL2+BkUMW79bWVJVc3ztGo7AhfiJZSWIYZGtOM8GVDAjte8RbrfCytDFRwomssrOQK6xkr0ktaIMYGqdYHZMVUGmCXMqb0zObuwbQnVqnegDtk0Sy/mjetkka890=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:57::6) by
 ZRAP278MB0562.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 07:51:11 +0000
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165]) by GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 07:51:11 +0000
From:   Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
To:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
Subject: [PATCH 0/2] mwifiex: Select firmware based on strapping
Date:   Fri,  8 Apr 2022 09:50:58 +0200
Message-Id: <20220408075100.10458-1-andrejs.cainikovs@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:57::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c55cf88-7553-42cb-b5f7-08da19348c56
X-MS-TrafficTypeDiagnostic: ZRAP278MB0562:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0562FD50775630489E8872E8E2E99@ZRAP278MB0562.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9qcFtTmBNP/ci+06FBjCui6xKIGBDUE0nToZWF6iuJHkbt5ZWd3tDAjersGD+4xFsLcjnHiIhb3qb8gk+bfU4zSG1r5Ts906Ufvr0i6ifNq70coSdWc5EneNpTDifQ3+pLIcbYpEwK5ZnTfwTJ2E2msEnIuLYpE5TklaO2zvvWaCvCTU0az5p4LDD1aW8CIiCUtJTZx9g42UHZahDuDgE99UMBCW80T/pZupjUGUs8AHRcfOXwh4oPdITc1xRmvQw1pDoPB5sKYKuhq6iEVWooGxPfcg2XLAFHv/VSudaRFj8xybqYHkqoLQdzmGN1zdLQTPdhimP4AMk3908kfRI6mM/4gcjGOhdOjxWNpCeNLhxAGkBMfERFUYpDsRwLca6OtW5Z3CDqD04ujIcQOXDPHRlBnspPGPinsGBo5lUAwgYKV+us3GywCnP64ACS0DjzgsJ9/yIw76yG6zN95EArEd2oGebFp7xx6z+VGZqBbPXAgaIqTtPzGDJQDkE1LxrMx1wYPKVK5sX/JKYw9Nq2porEUV7Q/Zh7rTG2mKIUrhVn8zqdqpgrgAwPnHcttSjjliv2Vmpg17JV75T/rlSYj9ElSGRjhsRVp+nf8Rmh7MT8aGJb4b5AP6Rw6cfhlPYHxSm65MU2UVZQ2iKI1GJ5DlJ6a2ktVbAHh6xt/AGcVxO+wwfCICKOTT/l84RDqY8eQxvskj/pfVaPkH182Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(136003)(376002)(39850400004)(346002)(366004)(54906003)(6666004)(316002)(66556008)(6506007)(66946007)(66476007)(52116002)(110136005)(5660300002)(1076003)(186003)(508600001)(4326008)(6512007)(26005)(2906002)(2616005)(36756003)(8936002)(83380400001)(6486002)(7416002)(4744005)(86362001)(8676002)(44832011)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QhNbq78IDDQOZbEtO7c/XoNTHCcHYhvy6GNIBPiAWsbf0WpvxXXR6FCzwvxF?=
 =?us-ascii?Q?8E5cRCknVuLbsiC0cDxqLWCHHG0p3ikrapxCcuZ4Db4ti61pHo21qKu0Pc64?=
 =?us-ascii?Q?tGheZl9hDFx94KnnNPfcyJhSJS5Rg502GgADiSyBw/yuHApXcOqI07YRLuND?=
 =?us-ascii?Q?DH4t6ZDUKlhNhCyWh4pGC9bZHooqS5bCtVvYlbLXC9UWOQQdRQbKYjEATKyh?=
 =?us-ascii?Q?TfTgmSRLntldieKTsFIt8SLytCpRNZ8XO3hoviLG+wUpehRYWtjW/4jtNTGj?=
 =?us-ascii?Q?5LCLMia8VqqmWZIqbncaYVUzDFfCaMTg0KWX0HtHynY3sEwQrtrLBtXD3Hj8?=
 =?us-ascii?Q?usEJbJaGQat9da1ypvgGIq7UQjZSXXqR1llVEF2EZm/GWH2eOA8361/U1khx?=
 =?us-ascii?Q?nrsyHx0pOnISx3cr0DYBZc3zwFfEgDaDfMQsrVkSs6DVnF4GMD7O4woyWnlz?=
 =?us-ascii?Q?xAYsq3hADO4HEvqHDxaqH9UvBQRoYvqrPThDIlQgA1X4g4uQJJ9N9zpuREt3?=
 =?us-ascii?Q?qQkzTXvfe8VaUpMOkPeasx7ofhcjc0SC5ak0ZmazJJk6+qwCj98cmjI2VQ5S?=
 =?us-ascii?Q?s7zyPtPamr8z8uMxItZSVxU1QNwoKxMMy008q+qKA1qdykRowf/e+Zogr3Zh?=
 =?us-ascii?Q?BV8tC3F7BdCYP+sFxPurgvymZUNKd2Z79q+1ZeSy2/M6MtxO0rWMJwMyuKlO?=
 =?us-ascii?Q?qY/iQm3m0A/jaTrdGm5Ein24u1iHHaVHvHyrxG0gtarnuPAgeNBczHsRFKSj?=
 =?us-ascii?Q?27UhlGCrXaDOz8Sd818cnH8h1WYAysdIsekvSJDA/L7Szdo4+JMnQc+qlb3z?=
 =?us-ascii?Q?mW/XpsUUAorLEE/dAd6pClZ340WG+orgJYVlsm3ICV3RVBCGEeJDdM0P4rw+?=
 =?us-ascii?Q?mO9bjj8jgiAbYf49r1saogvvyrOdQKKbPNk1B9/cwVqDnOj9okrzAKzksXqq?=
 =?us-ascii?Q?HxbvMAcuGbfQ4TgioqBiRRhJ+aCCnV45WPu1joNyfaswkdHnqsq2+T4GAZWr?=
 =?us-ascii?Q?R5wReyKSS1AHIyk5oeKnrWzwfl7rrvWyLXWhwaFTCsaYpYUNJLtEW2mFQfmG?=
 =?us-ascii?Q?UdBFnk7yjAp5Tds2XQN8cmABBZ8fDkH4dy+YXgKYjPfwCAK3c7LMN44uNTqV?=
 =?us-ascii?Q?j4hC4+PVsUsHlaoh/kh1oizpWa3Iwv7c40x151v5Pr4jYf4OuNkciUULHHxb?=
 =?us-ascii?Q?KuE88IET3KzAiwBiYY0zbsbVkJBlPIUeMyQPM3M6sm2F7JrY3N6BeqdYHsSt?=
 =?us-ascii?Q?CZ68OOZaFHtVSfb6vKo0WL5kIEYDFqCG3/fxHDXaEkqw9qYZULIfuDCkRJDp?=
 =?us-ascii?Q?bPMLQzPbTEHm1s80GoQ+TcfrzYnuFfFpbuchTdTpvAOeClUKxvBlBuedvQeE?=
 =?us-ascii?Q?NthTJPtNiTqfFGwrIYKXZRpOs0vqbOn6RfWJomVk5zAPP+0zyDbUKlMoct3S?=
 =?us-ascii?Q?uuusOBjS2m69neBp6cPWbYqDQNJz4BoSxRU94ENeFnA+M80cKpVp2jtVIyy1?=
 =?us-ascii?Q?FDv4LLAJI63BadSksB9ZbZPwtJ9VJ1SK6gd8lyVSa2TY+7W0/912VelC1Avc?=
 =?us-ascii?Q?AKasn7LiTbMVCOTCjhMo59aC7bXVqSAU4Z3WofHX+YVAPbeOihjp8PR8FFnj?=
 =?us-ascii?Q?hoDRQ1IdNTU7U7S3RjrJAvxvCCYVsLYiF6Q+qzTrE+MyKr+5lr3SKaYrQPcy?=
 =?us-ascii?Q?C2h///GyW95YmZdr4vUwTKl5U5JE2/lX2iY6BeG8BN887Pey54b2j5dJ8fYG?=
 =?us-ascii?Q?YZYwou1fa0QcMUY9sENb3xgcLXEiqDY=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c55cf88-7553-42cb-b5f7-08da19348c56
X-MS-Exchange-CrossTenant-AuthSource: GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 07:51:11.0926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 545QCZL/IurrAN0E/B4hQN6HSQhDzletkrHYh3+V55xoDDx30IB5UiLLr4jSHDTwHUp6NmGZlNKmYT/FnBwtGQbiyPIV50so1fUUqdPPXUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0562
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a way to automatically select appropriate
firmware depending of the host connection method.

Andrejs Cainikovs (2):
  mwifiex: Select firmware based on strapping
  mwifiex: Add SD8997 SDIO-UART firmware

 drivers/net/wireless/marvell/mwifiex/sdio.c | 20 +++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.h |  6 ++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

-- 
2.25.1

