Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139766BAC0F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCOJYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjCOJXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:23:53 -0400
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2075.outbound.protection.outlook.com [40.107.103.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AA41E5D2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:23:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJW+vVV6b7eHphylTvgLxppxuQWj9c1WQY2VXgEaJY6zfLXDh2JUgR/mzKNnHUK8DikdGl8ippHRZo4cvFHWeTrT2oHJXeyIUcNkMhSOGkmHf1pnyQelbYtw1RHVj/ZIq+aY/z5CfEncoSFOZulGcsGdJh9OgN9MFHCPSbZvGTBo7KNdWPV17LMMCmKaqYStI9s1vQkNTV+i49l33K+OZmunzAYuFLtcS4mXxQLlsjLkwTBJyMoc0BE1NblL70AJKLobi576dTy/8U8P8l5B1KT3fYSD6ffd9btY2oQMBuXy5EweYFPTEmYJvFTrzZ8kpeIgLFt576yN38fw2erHWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twkbecMfdksjjCrm3cG5EkexFk0QDC2BJ+Yzjub7zqE=;
 b=bJpBvHdgbcJIvsYrSv8QLGol+uFRD523+X4JmB4ZW9saXc+yjjpaG/lte53Wil5ZohJUueNZ4AedrnxjzSdhAqwiMlZCvHaixwubk5i+/CsDchjUcveBhi8k2Xu0biHJo21Zbv7U0d+XAwXX6t8PebUKBHYG7NJ9E0Q647r5Gc+BRayB7qiaKrj5f1QVzxXbX1gs/OSxfH2/DwTTtWoTmYrWPyoo/RAOv5fQbtNCZI+jGByf4zuuOEoAMvqdnaeCbPED3EyYeTvcJ3RzF36rrv/b1rKEjl+a7tYoFG87wfLy9Yu+4eOnMOHFt/Ty633KJHbI9rRMltDhnIm11AezRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twkbecMfdksjjCrm3cG5EkexFk0QDC2BJ+Yzjub7zqE=;
 b=DcYoY9dSkHFoAN5kMedIUZaRi/wbIpBG3au2Gjk9l25y1BRxWH6RaH5cT1ZKnjnWXCJ6N1S8qAZO1FDtulMxQ1/4RN4lFMbcOEPLoV7uutZ68P+qL5ytrFTaRAhMqZZrMsb7lP1O7eONWn727k3pJq+VzV+JnHyb5LdHVlwZ7F0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB8000.eurprd04.prod.outlook.com (2603:10a6:102:c1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:23:44 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:23:44 +0000
Date:   Wed, 15 Mar 2023 11:23:40 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168) (resend)
Message-ID: <20230315092340.oyclibi37q3fpsjq@skbuf>
References: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
 <20230313223049.sjlxagsmbpjwwyqj@skbuf>
 <5b77c287-aad3-3bdb-8d7f-56d91ba1c282@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b77c287-aad3-3bdb-8d7f-56d91ba1c282@gmail.com>
X-ClientProxiedBy: BEXP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::14)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c325544-5b7e-46cd-1f51-08db2536f938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1hvlLF+waivMBYVVlJ5WyKhokHOahZnYojAkAsLvg0xGJdexOZKbOiBqJkY5hbrSks+di0iwEN1Zyrj3pois1ExmMzeou/ghEL1gVmxHcSrIqIs3Ax0/VJ6zGAqGMTW+0/SWqeKwZqDFxKrmHTxQ9OqVHMpPpoJF5xQb1VevS5VuIqOlDiLIP3ZlQDduOPQxp9m4xVHJ1LS0WYj7TBN6vpoh4qaeV2vW52yR9Zu3c/V8Dh8ZMowCVipU1/kJyDAV+TZ9CYBQVHO/HHer+XJ1kuVLGFs8fmWbyofJw2ZITJi9PRrP75tgqlBcVzVuvdPsLdyeU1PxKOPpkTt4tfjsuncJKXoMkaykhT6L4oNY08Tpyy3eVXPsOdTcgutQ1iFdRgNO/imnoRo9kxGDAD7d/7nl6jzohp68S8tzglCLkkUj5QiKHGrcrZ7+RpZuwTr9Yy2VshtTBo/0IS8WoVLpZVLyf3lNa7iixBSmTGLka2I8xpBOB7VyTQQo2q4Vp2NP+pEEWiindvCAqJPrn65AFKWYaxBEKbNuZAg5IQSwk2xMww1pkU+1xRUvrWLnZsbLNHtvYSceiGuklyXEt5+VYpJ6QJhWs1en5OO2wGwB22LTvGBKlwt4chMI3RZssFoS00N+kDK6jO5iNFRDAyNVzhxKWFsJjH2gSkIX3a9uBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199018)(478600001)(966005)(6486002)(26005)(186003)(6666004)(1076003)(316002)(6506007)(6512007)(54906003)(9686003)(41300700001)(38100700002)(5660300002)(86362001)(8936002)(44832011)(83380400001)(2906002)(33716001)(66476007)(66556008)(66946007)(4326008)(8676002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g4ivj5VOyI5rCf44H1G3+TW9/sFpUa5Ae/jmKHD47S5lWW8hfK4va5w0087q?=
 =?us-ascii?Q?3osgBoeKndDaaQ24RszHQ8pLwzOMcSXu4nBIe1oInvepp0cO9pVcqAiTAEWO?=
 =?us-ascii?Q?ZpiOD/WN/qAQgeV5sK0WCEIZ6c2UnmBOxPMu/r2M4FZ5PV0DiiUu6Z7xRsl0?=
 =?us-ascii?Q?9aWCWckNZTuyDAAKFOHjNarALNOKQusojlh54FwfaO/UBmAbaXH/ERIt6U3N?=
 =?us-ascii?Q?/T/U/mZ7vLwnAu32A7wngGuDQymuVGSo6QXS+MAmcTEsr7g220pAaDSD/5DW?=
 =?us-ascii?Q?HXZb+ixanSnXd6coAJ8ArYEq88KDegX8mlX/UzyLx5Y1P95C6hA0r+Y42Z98?=
 =?us-ascii?Q?ojkQl011odUb2xaekDRYqSV1OnPZ3MMf7+FZXFQLZ47uaPop4Rc2Hu5VEbh4?=
 =?us-ascii?Q?2JZWm2vKGldw4u/QfK8r29Mug2ig5Kiu40nSIAa5jO7EpIkDT2lK3vAHygsM?=
 =?us-ascii?Q?p6EIpguwAqqSxe1VrnOahA2K922vxiFtXBeMUZ4iyKqE7MQqSvnH0dkSPs7B?=
 =?us-ascii?Q?L/YTBx3rh+Blg/nn61tYKnk23yB6713xQAljn1KDTZYAmFOFV1QMXBIBBs/s?=
 =?us-ascii?Q?pxNeIPY1MmeEYy8TTML+V8G6HxKbRZEd2Uxj+zJh3rWth2ISBUAgni93+V1w?=
 =?us-ascii?Q?lUEw39CHNLPjrbgl3qPr4Rd3FiPqi3NNzKqV619L7jmGYxV2zCtXbGBQUlHo?=
 =?us-ascii?Q?WwZLYdXX9jvlWo8zUUosrUf+T0givtS13kPpSvHroxVpC9JzllcnNKLEW76M?=
 =?us-ascii?Q?BZneMYh8SABg6qkN8qF5YOlx1W9M0UaGAaWFGrIMyp3C8U/8u6qqS8Xdgyvx?=
 =?us-ascii?Q?yHXUjwYMQAxBONKfqW11lje2yLi2baCYjN5XgUqTas69PDfvu1aYbens4vHb?=
 =?us-ascii?Q?0CWxRHYHgO0Z+6ZuZFChbcnrcD5Xe3hCvxYD9gMqOWP8Z0zBnhzs+g5YRc84?=
 =?us-ascii?Q?m8u+TyFNsC+3+2wOVs+mnCsaGqonoIX7yIgV5hW/knHBtQsIDonwj3s1jkt0?=
 =?us-ascii?Q?JzWg+oSHe4xwW9dtr32S2ne/yeAFHj3zZFdP5DrA+woIBIYxQioKKJx56mAw?=
 =?us-ascii?Q?SSg2ne79U69D9xT6n1llTIEzLwx5rHeaqJbZGWJ05PWx/Sj5r/1FZc+/8bX/?=
 =?us-ascii?Q?nSl006Ao+kw3EQWQ8X/FL3amJa3Ebc5NLtrMow5owejicTyXjKCcvBNIvpfD?=
 =?us-ascii?Q?rHvwIQ25ReTK3/dweMUiJWileELbHgwTYGkL6we0ASeTn8b+3w9GFRtzj+Lt?=
 =?us-ascii?Q?45KG77EL2rsutr1haKKw+xsFoBIOkfFDSKl02gOXDVpJL0cWwfB56mFHi/JC?=
 =?us-ascii?Q?bwz37bs65TOPILSKw5V8wddYbyt0bPA/pc91+Ay5x/ZpIYo6Xfm9+HfIct/I?=
 =?us-ascii?Q?BiFJ/OPjFvlbXugisei2DGvvqZnZGPR9BUU3BVHe3QlcPvqcAMNLo90RjtYj?=
 =?us-ascii?Q?QM687vY3uxz6Cfam6paUm50WSpXhJdN52bolLGbsOv0XXAIxvdCnbgU031sQ?=
 =?us-ascii?Q?GVaN7CrwZ9uqn+2cNcBESydSlTco5y1rFkQGhFUIMaOMwmbGOXxmnqAxPcJ1?=
 =?us-ascii?Q?Eq1q2Ne6ngmcgMTlL06YeiMk2RtrwIEyKByKvoea/oKraF3pHfwzOOegpMZ3?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c325544-5b7e-46cd-1f51-08db2536f938
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:23:44.4598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5tdtdpwLXZaISFcSUq7sokSzjHebdKv6Gfa4bCa1YNt6VOfqOMwKtll//Y2sMwg+8SBWBNioA5Gfi140cP20Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:35:25PM -0400, Etienne Champetier wrote:
> OpenWrt doesn't support Turris Mox, but here is what is built for Omnia as
> far as I understand
> 
> - Linux 5.15.98: https://github.com/openwrt/openwrt/blob/0aedf916df364771be47ffda8ff3465250ecee77/include/kernel-5.15
> 
> - some generic patches (backport-5.15 / pending-5.15 / hack-5.15): https://github.com/openwrt/openwrt/tree/0aedf916df364771be47ffda8ff3465250ecee77/target/linux/generic
> 
> - some arch specific patches: https://github.com/openwrt/openwrt/tree/0aedf916df364771be47ffda8ff3465250ecee77/target/linux/mvebu/patches-5.15
> 
> (not 100% sure in what order they are applied)
> 
> - config is generated by taking config-5.15 in generic, mvebu and
> mvebu/cortexa9 and somehow merging them
> 
> The wifi code (mac80211 / ath10k) uses kernel backports, so it's actually
> 6.1-rc8 based https://github.com/openwrt/openwrt/blob/0aedf916df364771be47ffda8ff3465250ecee77/package/kernel/mac80211/Makefile

Yo, that's quite the patch count.

Would you mind putting for me all the patches that apply for your Omnia
build to a git branch that you share here? It's impossible to find the
needle in the haystack like this.
