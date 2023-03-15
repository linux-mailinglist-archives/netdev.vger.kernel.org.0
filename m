Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28F86BADAB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjCOK3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjCOK3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:29:50 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20703.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::703])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B25066D2A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:29:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uon0/bTb2BrRWs7bw4e93Df0oY2SlkWHj4YGlcj1NTEv8z6x43fOUjllSaZd9zq1gWLz8Yz7jxojZBiMNK/wC8t7bjPrR56I+b61hcZa97DFstpMQIV08n8nYlegDikmcZqqXM8RclOSY/i0TT+SkWCbloOkRdAgOSYRoTiYXCqJgElaK7C3DxNTM6gjP9JWRtXcbJpFgB584ZsOpLMFJAvKo3JSb259MJQry2e3+yjwxxnr8DYXXd7KQxpAJ0igf/guo7g5SxTtGVoOm0RN0IYoZI6yo9bQiotxNScD6CGfhizcVdmgbCX+O4fKIjDE72wLHYiDK6XlT8Qv1TU1lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hfAl2+GTjlBbONzs4wruvqVdS8jyamY2th6+eCXzG8=;
 b=HBPTg5xQXZHGh63C5XzrRDjfafqwhM8QAGIZqaDfhdzXf1FssCuy7rvLZCeYiuu7h+4nB2EmXsNzq/VH1BZF/KtdUISBuibsuvKIRKLo8PiGWMvaOqzcddwqMuOMn7Uh4qPGrnFca/0VfnMoZNTDCSuoRkU4r7QWkx1up8+yl11tuZhehZ4bO25lsH0LD+j5Ih5Ke3mJmbLFU1W3s4e9t/VDCTmPXw1a22kc7Ox49Sv0yDC6b/bK9b264QPD0PdkvSrnu6q1fdDE/e1vXINZFW3Um3oZdw2x4cQHMwuTO4hplQ8LCiJsGjEAmFbms8T4HZFrG+n87bWXNut3CqQiXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hfAl2+GTjlBbONzs4wruvqVdS8jyamY2th6+eCXzG8=;
 b=K2Jf7URqqz08ivIIgihKitaHozN9fm9MHKinzujpkuVugIbVFCwAZDZbr5YYWxd8KlbY9UBwWMPqTUblFhCFQcoiJstjJd08S80sv9Mkn8rf3sXAmys8MSFS318ViUDNlQs514vAFneQvlR1azaDTVfQYgtKgusssLYJ8UjMdjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DU0PR05MB10311.eurprd05.prod.outlook.com (2603:10a6:10:441::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 10:29:41 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 10:29:41 +0000
Date:   Wed, 15 Mar 2023 11:29:38 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230315102938.wxuvtvgmklkflbay@SvensMacbookPro.hq.voleatech.com>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
 <20230315083148.7c05b980@pc-7.home>
 <20230315075330.zklzcdt3sukc5jy2@SvensMacbookPro.hq.voleatech.com>
 <20230315111950.04deda46@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315111950.04deda46@pc-7.home>
X-ClientProxiedBy: FR2P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::14) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DU0PR05MB10311:EE_
X-MS-Office365-Filtering-Correlation-Id: fb56483c-cabd-4601-38da-08db25402ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+PX40hq8VGWn9opeD/HQCkG7iZYMr+d0+4j3R+hn5p7dXO4rxQ7TS8dJ+9pFGrY8+N+HeObj29xKhQNQgrVniFuu3LgFvxTmuLKux8NWc04PbprwYOwCW4Oxm5qiDzpjctYXWFvoEfxggvZ4XTnUn7FTwTYBfnXBeOgW38XjiC6cwdX+7ztufK5g6bFnOoa7xGBoD4sgH8lUhtuR75HEpSGhPZg57EkTzmBUTWMQZ90SbD6STnG3Doth4VxI8EYS5MZ7CcXnqNKtRZRB7ZZeaMPKXyuE2M8SN+pTBXCB6WKsFFcWnv/1sXm0jPL1efXfaWmpciNmoZa+leEZWkTFPStzVUvJtzHFF0CC67k700jOQgevjZ2puLYjvtEOZgEGJl8Q9CiE96gf3nqP3YG710jVg1JrPYb/32rzypjSvCZ6en/FOTbOn9SV68zBoYLt19QqDZ7HcdchedrtVPGS7Bil7gYtcDyJdThIY4jlCjAnOGswh/uN7L7tbLikMtaCqXDyCJIGoVXO9gUypnnwRaqoSTebpWI6R8cmwKoQdUDKzoiQuyVuOCKTot7fKb8dvVhP5SV4QsqjgP7UxPmTKYtD40/FpzmDvCFSJt70JhR7VrVOWxTxcn0ILQEPCb7H0IHR82+L9JVr+SZ/GOzhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39840400004)(396003)(136003)(451199018)(3716004)(5660300002)(44832011)(2906002)(38100700002)(558084003)(86362001)(6666004)(9686003)(1076003)(26005)(6512007)(186003)(478600001)(6506007)(316002)(41300700001)(8936002)(6486002)(6916009)(66946007)(66556008)(66476007)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PiEx2IOE8HzwV3kTG0VILtmVzqNo3quEGdVk7R3ydCBEBhgmNavGJZDaXcJG?=
 =?us-ascii?Q?aA0t/u7JmGxddCDx/g0L9BCq8gKeMeS2yIYI89xgfMceaoLUEB2N8ytKVCf6?=
 =?us-ascii?Q?q+xjrTxcPr9z15gvMOsobAe+m1WR9Mf0vc12N2siFn3ojYMza8PtiPPh5bJ8?=
 =?us-ascii?Q?Vl4RSuQjfpfF5luz9i9pdFD/K8MDr4P64B/5YXGJxjVhslhRiBtSG2DDOknz?=
 =?us-ascii?Q?vciFwniVrwUrZ4ukRX9hLkN7oylOnl/t2SihvzHWzquzLTBfe+/xsYiVYlS0?=
 =?us-ascii?Q?4xwWayGUJEcJt+DcEwxi5UyOe/ROoCatcD8qc93KMhE48CrcAO2k7GCDI9ig?=
 =?us-ascii?Q?utqpplbTMjenU9xkEbr+iTHWNnFqS9r6eFmbZUsi9TYvmYkPHmaQAap1fix1?=
 =?us-ascii?Q?/KcvrbUyZYemM+a6nD8OeJ36Jcg2LzDoqsepRzRDJdbES7NgS9LQCUMunTdM?=
 =?us-ascii?Q?zvQX3eZYLjEXhk7nMBsUcMs/J59jYQU7dzbRVaeIayQ/DbK6EMQQu1RTJjMw?=
 =?us-ascii?Q?z2wMVK8ufuehW27smfE5HEYivPJiwf7ZU6B4UfzcQABhcO9FKYMCkes0zZ+f?=
 =?us-ascii?Q?O1YD3Pn8tPEPRoB4pWyqKdrGMrzL1r/V3889Dkw/EAgnvTf2ZEJ59w7kW/f5?=
 =?us-ascii?Q?Vs0GVO4XsPF+0MEY4dmYNg0/5P/RWCQGbgh87CC9nQFhQsSLRu5DhSostL8O?=
 =?us-ascii?Q?qUk40ACTKGwGBxDPizx1whF7aJXiVT/o81DOOSaGY/xF/SwHt7DbEL52AO3M?=
 =?us-ascii?Q?22aIy7ZaRemZMjJCoa1fxRoJ4/LdWXbd13cahOaaJ7pYpOSQH+NfDgLKbKV+?=
 =?us-ascii?Q?/nbnXQw346EFBxcAnrrpqDkggpzuVBa4E/Efp+0l3lsxjE0f+tTyVEeWrzfI?=
 =?us-ascii?Q?g0uvxTk9MsOFdo+ggsNimVMnJAo4vFDHI+/R94AE8bhWlGoxzr5fc4aq0XG4?=
 =?us-ascii?Q?YDhZTYyvRTAJPOA1iRguzdounQiMWuvwPFa9TJ4GqS53r7wnAWgSa1saVHl7?=
 =?us-ascii?Q?nfi2EyljodG2C+sbUNT3SwQgphCjfHN02Q5GK0j75GLQurOpbuq4jEcUZ0yM?=
 =?us-ascii?Q?zjn87lLJ9mpK/MNPPBelVfuLeaOtzaRiMv7FYjmcwOihtQQkH4nLFeHAzEgO?=
 =?us-ascii?Q?+odockQsVX+dg/mQevUKMgR21MTIwsVtgLXZEI4VstkGMeIiMddtzEP1uprl?=
 =?us-ascii?Q?b8+mZ7trBQO8h39i0ynNQBwhR3H2tFx8zlGGD4TFg9dMrb+9NmwiFmUaWjNK?=
 =?us-ascii?Q?qs8JHja8egzFl8jFuhJl3JYA1ovcz9H0tMiaRpoOhhhfl7wM4GMXo2rg27/I?=
 =?us-ascii?Q?f3cFgtxX5s+UecV2l1RN0aUIVFmVqqadhRPVV/KwBHfdylLCySFUwL/w7qEJ?=
 =?us-ascii?Q?Y9+fIx5M/Q1AvF0VaFv78795zafn3oinmzKDWqRbFLwT3fhgTN1XHH7TZ82+?=
 =?us-ascii?Q?hy0j1LoclHPx5tt29y7N3XJK/nPZMi+EWe7K5AbcQTYEaQZZ0coKlzHKHwW4?=
 =?us-ascii?Q?nk5+xV7bLgQq0lSZr+4RodxPRpyy9MVuK1yNRO/7/z0tlpvA8ih434/VEITe?=
 =?us-ascii?Q?SGibbt5krcvWJHWEuZrhCQcfNi3Uff3NYb63yrZwV1W983xplAx26mp3YbgG?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: fb56483c-cabd-4601-38da-08db25402ff0
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 10:29:41.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbMvyxLH1YD9Sv1sU/tIhltnf06kZ3z3Z2UIuo6i2zTSdotMrHCthnstR/N2h2ES9Z2TkMJW7qleVUCz56fkPkMp85Ns5MAah7Yoz7dGgPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR05MB10311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:19:50AM +0100, Maxime Chevallier wrote:
