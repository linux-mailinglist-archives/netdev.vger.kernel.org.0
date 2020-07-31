Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7261233F5C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbgGaGqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:46:51 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:50639
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731351AbgGaGqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:46:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R64CUl9wP654sRa4BjdjCtJBN8ALuHVHuADAut6o64Z+gJ/99kzMTN7PTC/UzNx4XlWCtdG3Yrhm+WItaxeIHfxf2hJobQ6qY8HCcXjej+KLAoTT3zpdiFmdRAkh0X/sg7BC4fdHrwQs/Gu6Sdg8ZYkkHZyB84VquAmqpB17+AavE6I/BBczlGBGNEsfOnNzc8Kj+GrlbPmUo7820LG8hnQ8yy362JEinEB5RFN3l+3KWEE4aCFCmiY9daFmpPTWam3tBUD1nl3qaIM84Frf2qJIfVWI9Em/eA5ZreHKxR8vyjDl8Lq1jyjAQCMT+8bacQudyA4vaus0L0ug8Y2siA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQbuh5rvwvjMKfKl/N7cIOxCV3ixDbO9CNF7kPiW4dc=;
 b=dzwFUzz0+GPxQcmaeI5W1mfd7B8IAn/XiM1+0gjV4ivx/mMbbEwBrQRGZJmxcKHuFQ4KaGCyl+VEwBm39sNuyDjDSu5W+7Py5khWAsIS2YACBJMsbwvrEG139VpDuumy0nKqXTsncY+cUtKCJUeFQOJTzCDz6gxRddZgcS6fa4DLDziRqAUAIdSDFxFrG6bmlTQRoP1wyIqckAJh11FtDpOyvsYUX0xIijS05FuxlTIFF2J8z2snqFpztrpiVz7Vjn16s8jSiviWtad2dg8YEqRulp8uRn1GS8kglMZrY4IFFIRBQTs4/Tq2Iz2QNZaCd8u9qDINdnCnZedVTa2XyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQbuh5rvwvjMKfKl/N7cIOxCV3ixDbO9CNF7kPiW4dc=;
 b=mPrB9xv3JqftE7BY8N415GGTFxzy07g8AjDXyNFqtXCKXDsMuJb58RysiYkguZs+gMSabWR1dGHAiiQFn2dm+hgCwqrHG52HHJlLeyqTsJndkxh2n7lY6G1/GWDM8iRPivslTMSxhxvwH6NQqK/ewWOqYuP4K7qW87074cFU05Q=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR0402MB3527.eurprd04.prod.outlook.com (2603:10a6:209:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 06:46:46 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 06:46:46 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net 0/5] DPAA FMan driver fixes
Date:   Fri, 31 Jul 2020 09:46:04 +0300
Message-Id: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 06:46:46 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2571aea9-a033-4b3a-8413-08d8351d7e83
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB35275BAE8085CE33661CE010FB4E0@AM6PR0402MB3527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBaPLXWykEsnmHsaa7slI5otSyemvQHCsoharpCZRck9wmLBX1uFtwUd9CmmSKNaXh1umGVnpMUWvqibxNbLLQuW7o7LmShHuDm8YU+HWmmiUg/F3ug+yrbf1hfY+GfAvZahdhHT5dF7j16mmk9Mt4yu1YV2BvF2EXsqXqXhsEhwUqGaO9vLufkWnMFOMqnyDcn4zibRvMLeKt1mIp9sNLKVe7HSC2F2NFtdeqYZKS4zxQTDrtnF6W8vlUYkJqb22C49XKhSKxUkyOk6nqga9Wonw1OVyIySZW3EyNH2TAF3NTRpYN7F+VrNCfW2d56L4do+g5xyg3Q4q8QQXH+hOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(83380400001)(36756003)(44832011)(66946007)(5660300002)(2906002)(66476007)(6506007)(66556008)(8676002)(6486002)(26005)(6666004)(2616005)(956004)(8936002)(4744005)(4326008)(3450700001)(16526019)(6512007)(86362001)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EYlAnNk9OxeQcXpaDYmOqKRKFJI+C/jZ3Apdu++vLJAg+ZdWe/AR4phRoEjU/gZhThDVqAGtdVPqLkoDXoS1bdGrwj7J2hniV+YrciRDc6XyyYMGcqdE0tXhcVMdD0gWXfmOFqgcxxb+GqfNils+9jYAatTvkezACBMekyJgmE0w75pJFCzkDfqCrT0ZsrB9zwIf3MJq17bQKxmnG7NyLntBctA7E7jk0eCqs3++vaN1WLKvbShL21q6jtjcANNC4o3YBF712au4TG8ZAqwO55B4IJKx9wMJ1vucN5fKyiUMT1QH6ncE7hjO+XJxklTmwdFF9QmC2ddPvX5Hde1WvOiCGeQRZ3ZaRABmnpaYeJjpmXK6de5AbLm3iCDwhBOxUxNxawIBGhfPkGHtDmA9yXzW9IktWEPejDQZhaXoTkR7hAOZWY7WRaY2x+C1+W21eoUxsbz445Air6xCNrgDZiJpQ0S0NmRr1DbJkbcLFf0=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2571aea9-a033-4b3a-8413-08d8351d7e83
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 06:46:46.7386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLr5QOwR0cgAjyb35OrGSYbsgUuwKSL7Ql6duUttZ5IU8JReVvP79t+k19IdIwdmBtQnIkbI8vFmtLfJx0ZcBS9Vt2o9Vod+GfhY8NooFOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are several fixes for the DPAA FMan driver.

Florinel Iordache (5):
  fsl/fman: use 32-bit unsigned integer
  fsl/fman: fix dereference null return value
  fsl/fman: fix unreachable code
  fsl/fman: check dereferencing null pointer
  fsl/fman: fix eth hash table allocation

 drivers/net/ethernet/freescale/fman/fman.c       | 3 +--
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_port.c  | 9 ++++++++-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 6 files changed, 14 insertions(+), 8 deletions(-)

-- 
1.9.1

