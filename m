Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593A16B5937
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 08:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCKHKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 02:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjCKHKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 02:10:17 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0710.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::710])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D995126997
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 23:10:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpbHIQVNQY2BArf7bOAjPtxAaYB75cgo3+0QgbXxP+3Lwgssxfi2vr3vTyCJFrxVjH+bXLbbZf4q+OMrWaj7GjW8SZogNzX61oqHuLqn8nceANoCnId0ESrzdZ5latzhFcGJEZqXLV+ITeRpNlrDtgURVyfqPXcx1/fja6YfPIDRUO6yBEo0jwlT8x/peMt58NvI1RNoEUZ1DwSOPTvVqqSWIaH2NyTq1r0qKJQw6/3OIXPeKA3Ocuc05fe9CK7VNVFHdOJmU1qLA0K/HmOlavonze132K3EQZeqMsgkjUrCQ0rgWPvZMNmnq2nIkEvmzCVsUXIvnrRIqN+rfQheYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ewla3xlPz3IkHQ96Ou/bjxzxEGpyn5gfUT7Y/2nerTs=;
 b=d6x9lwBcMHHS3ckY7hV6VV1g22BpY3unICIIHgMEF4m26Fk8GP/Cm6UA2wpMFdym6ssoZH4K98zzBTLEWCqp9ESRl4hGKy55H+a7rd3wAmpdmNVIoH3vBWk8yTjlK1tr5lwJ/yVpmfVKWH+DAgOCexniuxVeYsqcKBUCSinrD0g+ODz5TpIaoV+BfHaFNzvpVWtge6MX6GSncOTokh5XDi9r8TM9wa84GHaTUe4xGMfVaSIOGgcAfJZ42mRYWKQvdN4zrwjGFRHz/5P2EU+K2YT2Mux68DTjAeTIBBRVdtVyCqTQ4wn5DiHO7AGF4hWwgVRFItrb5348Er4mES186A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ewla3xlPz3IkHQ96Ou/bjxzxEGpyn5gfUT7Y/2nerTs=;
 b=KnoxBCbUgaX48AQ0E6ICkIn9ftM3tXtAifLwIkPE0Q81WkTmte9QbDT+lYPhlugR6/+knA6Npamy6S4V4vpE7QMqpUrbW1YzdUnhKLlFBDLBDtBayPFB7NtMd8SF0BdaEl6TlW/z0kd82ha0lFFCO4pkWMeCRIcCNrOrmFOu9Xg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by PAXPR05MB9410.eurprd05.prod.outlook.com (2603:10a6:102:2c1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sat, 11 Mar
 2023 07:10:09 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.022; Sat, 11 Mar 2023
 07:10:09 +0000
Date:   Sat, 11 Mar 2023 08:10:05 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: [PATCH 2/3] net: mvpp2: parser fix QinQ
Message-ID: <20230311071005.enqji2btj35ewx53@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR0P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::9) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|PAXPR05MB9410:EE_
X-MS-Office365-Filtering-Correlation-Id: 6553ed84-26b3-4ed1-627e-08db21ffa678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+j6+0lyK33lTW0el/LmzH9IS0vDu4mkdLhM14Ayfb/lAtwVrH6iQ0BZ3OUyYC34N+cDXZhjb8qhy4XBVPHBdutNHcY4dW6vTZz9o+5WYrSGF90oWq5BHIN+BdL9uZPWph2R7oUgXSIwII9KVzxduXwecmYeW4dYEplHJHOvnKUpg/S+UcMSkAfvHJrgUSXeJOT8fZaM8ckHhti00ONN20Edx7sz3I+MZAPz8InWcu0K/15j+Lu89xTmFYlbatzP0j9W9V2+b3IwcZ289ULML+C3Xx8MIvRRNF8WFcHRkVev6d6MK6MRIw3OcjVlcdIhnxVtbWk5bOWFF1zpj+D0YzUT5i0dztx4F7kOe771vug8zvNyLJItHerWwQUzJLmqDRwm/TRtZZSklG/pVtfjqd89OZFkzglOQHYOWL9A4pxzBvQYHzP/+L3rwAx77nUCT7uInqBYMnRlUFaqNFOI6I2kZs6jFb66VNR5Lk1YmsbyFKp21slB64351suun59YI7kc41ShJTNQ8WPGL5hDufWyzbc9gg75HKkdbP/74fF+4XSMK6+L7jS0i+IUZ79fQfpOOBFaqf8AeNL7VCb+QGAQFJH4nv4JMm7f5RK+9h2bOojs/D/QBBqWXfLmIvLmcCh9/WXbkxYcGgsLhWkBqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39840400004)(136003)(376002)(346002)(451199018)(86362001)(38100700002)(2906002)(41300700001)(4744005)(8936002)(5660300002)(6512007)(6506007)(1076003)(9686003)(186003)(26005)(83380400001)(6666004)(316002)(66946007)(66556008)(66476007)(8676002)(6916009)(6486002)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eB8fG0jxKkoWk7WXMdjCFulIpY8CVutJauTLTwQ8FJARr3X3B7G+BW+a0UPm?=
 =?us-ascii?Q?+6bYlkR2DC4KhtZ2A3lu0593wZsGOwlpNFQjR5KyZP6TnyXvMuqJfhhOMQCp?=
 =?us-ascii?Q?Fws9RV6XP5gbtwL0RvY8HzjpGe8YvtE/Pyio8TRmvOxH4tqbUMAtL2D0G1dP?=
 =?us-ascii?Q?o17JTI8flJDY13tZw8m0vw316uxFkhdgK91H8GG2VzvpvZniihcULy+jrhrU?=
 =?us-ascii?Q?kHcGz407EFzqXmZ2qvgjk/LQuH/BRf1EbUKDLC8a/R63NQNb1nt+iLP/7rUa?=
 =?us-ascii?Q?Zdnj35EGpDjbtgKVYDsMfo/6i3OwH4cqs4ZR0jkXn3DrtCASg5xvb0k6FXga?=
 =?us-ascii?Q?ojLlPBRt6GckvmItfoIUUvp8C2Xndu8W3HL4A8IJSFEkTszFAYGScSA3M+Fj?=
 =?us-ascii?Q?ofwCsHUP80x6zgGYdNaVRnxjSyMuOUGbY/A4xOUcNPFk8gVEMrgVl5aY0QZg?=
 =?us-ascii?Q?tKrMW7i9uouU9wIoQryAHepK+xzPytgWUmuwex7EC7D2HaMIjFaB74zZnAqu?=
 =?us-ascii?Q?HxORn9NGRZfkij3lOeMAofdIf3Rp7ml15dy8GjpoSXsQ477FDA7aJEEHaDBu?=
 =?us-ascii?Q?o+EYay0er/HAXH0eOGP9d41Y00ZpIT4yJtnOXpi+hnbQuuZ9iNJvOC98bHfL?=
 =?us-ascii?Q?WkP98vyQ1HBE3kJi6jGV19rAozZaPvNcZvQa67TCAzQ2ExsC+gPD51QO9o3s?=
 =?us-ascii?Q?Fk5W2iXx89cRY+LsDIBC/3g+TqFK7vony2E6TzUJNireGP3ig/Y3I6Q+riy1?=
 =?us-ascii?Q?LldQqe74sA5/Ffq5yITwJRJwudVnFPb46lHNMerxFXZdJJ2JEu21IYA9LnO+?=
 =?us-ascii?Q?XIJE7dQGGoH5MmUKMSNsTZGjNG/GhJtqOU3vE/ifI+qrR1xpQZrTvfZ+tfaU?=
 =?us-ascii?Q?QxH/LccZcxoeoM5+SYjLrGoUV8cs8j+g7AS8qUtenNIG5fAOgzaoyhFX3FDW?=
 =?us-ascii?Q?pshWLIFGfZNBmIUQBpNhEYij/D/vJdjh0QPFg9/yLnSTpePOh7LkJ2kBcw6Q?=
 =?us-ascii?Q?OSCKppPCEsR/DCte1oiLUE0Pi1dbkp/soyoiqTJNEFxuNugUkgIQB9q/5AtW?=
 =?us-ascii?Q?S6rRRW3nlzkwlZuIWJr/gRMI+93bSbn5+bdI2h8ACwaLPoNXsO5bfgk/9nyP?=
 =?us-ascii?Q?IFYaiMMc09twyU/7ORZBP/vFHzSNG1N+ssulpQM/ZtDyVn8Pm7CpQDkj0jLH?=
 =?us-ascii?Q?Kpcf7H8VA0QNiyMY+S6t5k1aCo45/uTT3ny6h6BpisdcQzM0QKbt2YUo8V3t?=
 =?us-ascii?Q?lcrJetb+ePTPjbauMjehw/C3BOcnyYJWY2WXtHi/UZrKre785rtLDRcBePsa?=
 =?us-ascii?Q?xtomm8nPPBHimpi//S5m26M1y13ZcChJHEHGdEog0zfSd30UOqUIm/Xlpbk3?=
 =?us-ascii?Q?k/GsqdQB4ME/lIYhjkOGDdCQJDXTPcC5qjI3qz6Ipibug1Awrf3AfcF40H8R?=
 =?us-ascii?Q?EsPCIii6r9cPCjiBwF1fq9XhxZsZzQaulHoHTSnje/KOgZmOQY0XAtYCX02Z?=
 =?us-ascii?Q?KuSq2VAC0jHIcPMz/iof2tXooQFI+sNI15JWJf1ysSMJXArAdW2WDZPXwsYd?=
 =?us-ascii?Q?KNBEAaee9x2qNFo18oF2xRXGSv6LTJbvvRN4Kj3JADnIu1MbyKjo+am/Ag5x?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 6553ed84-26b3-4ed1-627e-08db21ffa678
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 07:10:09.7591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrcwXfqyyfYRxDkegtOUSEoYhJkwOIrABGNDi1yU0WRfo+XF+tTDFasd7XF1BUpNBE4b5fScg639nnAghNx6bykC3yN6DSUhc4eZzg6Es9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB9410
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvpp2 parser entry for QinQ has the inner and outer VLAN
in the wrong order.
Fix the problem by swapping them.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 75ba57bd1d46..ed8be396428b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1539,8 +1539,8 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (!priv->prs_double_vlans)
 		return -ENOMEM;
 
-	/* Double VLAN: 0x8100, 0x88A8 */
-	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021Q, ETH_P_8021AD,
+	/* Double VLAN: 0x88A8, 0x8100 */
+	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021AD, ETH_P_8021Q,
 					MVPP2_PRS_PORT_MASK);
 	if (err)
 		return err;
-- 
2.33.1

