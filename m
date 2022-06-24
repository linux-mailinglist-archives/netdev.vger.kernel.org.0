Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B013155A190
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiFXTFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 15:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiFXTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 15:05:38 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20138.outbound.protection.outlook.com [40.107.2.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEE281C7A;
        Fri, 24 Jun 2022 12:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGSumI8PyCe7ss6TuahILqtzA0zn/H8Z5bw00VeT2OjlIwDyG9knVpaK8G6aYnf3UQ05TR8+jeAm2cdF0jF7OOH7kAwc9GtzsFNHWbI0wSyTUU/SWYh7/6v59XzsMag5n0PwogCRgWVSZR0M+DkZqUaRt19W+l8OqvFsU8WgpzQlAOpB9ltYPdV36q0K0gAD1Ln/qF5+GWBIsXHcihlQOgV/VoWpdknuaEyoD7/lTt85QxYxs2KKUTTbzSqsivA0zyKuA/cbSG3Gy97CjDRdhKHKQDIbGw74zNtC8vYkf7Ga7cgQuaqeUWnFp0omHysmoImZIxkXBf9ly31VclvHTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wn0+UcFCexNtpgUPK7QV6ZlkBP9gXVkYLtqjo9kZjt0=;
 b=f4rsLGjJg6DlSziYcjz1izTCWkXvxQf2thSbtC5+DpHzYRR4QZLIVKRQrpk4zjXSC9c1vLetb/cTNMq3vjuWPrbGERvula8FLMApwsBaxd2X/H5zBz4IjWC5546w0uJl+ivPGU6gyiax41eEyByIu0nLbrlIG59VMy3QxLvp2O4j3egT4LViLbdoz+wz93A1+zb2Riw8HkK/EaKpNXUuXd0u0UkTjQru+RFoLciGDubU/v4GXf4Vq9S6yEhdia+JUx3BnavJK7yk35+zqMb92t8pTvNeUmDpMOxkg7V8SqPhkaIBB1biAVzVphULnsmpSPJTN8uHG/SsMFs80p/u1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wn0+UcFCexNtpgUPK7QV6ZlkBP9gXVkYLtqjo9kZjt0=;
 b=OsjYB6D8bJcTnnerIgmopi2BnOxUBvo3qh+YFQP/YibUxK4jzlRByJk02VI+25D7ja5w2anqUjAUrHrfJLNLPw8WD4QtHzccOhvd4xcZe7AZFozVOO3ovEZcXUfFa6idiMICGzFI5G3E6bmhcdR+ROpaNBCMRyGoT31adgkolHo=
Received: from DB9PR05CA0015.eurprd05.prod.outlook.com (2603:10a6:10:1da::20)
 by VI1PR03MB5072.eurprd03.prod.outlook.com (2603:10a6:803:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 19:05:32 +0000
Received: from DB8EUR06FT066.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:1da:cafe::93) by DB9PR05CA0015.outlook.office365.com
 (2603:10a6:10:1da::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Fri, 24 Jun 2022 19:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT066.mail.protection.outlook.com (10.233.253.220) with Microsoft
 SMTP Server id 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022
 19:05:32 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 0254D7C16C5;
        Fri, 24 Jun 2022 21:05:32 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id D72C42E4AF0; Fri, 24 Jun 2022 21:05:31 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/5] Some preparation for supporting esd CAN-USB/3
Date:   Fri, 24 Jun 2022 21:05:13 +0200
Message-Id: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ade73429-9bb4-47ca-ad83-08da56148306
X-MS-TrafficTypeDiagnostic: VI1PR03MB5072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZP5fsJp3nTRhPcxj6fYZHY1+YzKOxD0aFlCh4mGldSaCN7oLrNwGRSa5C60ArGzQtHoLOEt3m3RJPOY2CBZ1kBWUaM/0UeZrhkazYT4BqS+W1hF8sXRxR6goDjF1wDUmys0zPCWIcE6Fxjlq/QLD/oGQZU1hUeIi3uPKo8aLcyrLDyX4zsEieqa8CQh888k7z5PesYYW9iqnIWjevoQLMom4jfjm08u5eNpl3YcNV4l9cHFX6BrvnDnh7aoJS7BaZ0hjQCjSyNohe1sqyJgUwdBj7JSXhzroJhQAGgCsw9KXisQf0HPqh61upA6+icsevepDxmRPOefe8DDeCgVsne+F+59Go4LiauNnT1VRVT2btcBuU7JPjsA3YYuzrM1YJMLnZ/q4dNhS5NVcSGLXHCVg/CWXVxXQA73pJCm04cKMaEAPIB5bpT8UakDWZVU7ce3ZwoIJ8qHPjGovaUFQSSqehkBpdMDrCUt81HDBPPR6v0I9j9bjTxGFzl4Yn7VtAsFAqpWDjP294sfB4x7VE5SuDJaCAlCAHSVlvMsNt7uY2Wdju6d52ibhmkR03EX/w/acITl7K5L0UVgTmj8sbDHSOxzHtzrhYBlXM0HMHyodT65QfvEeEeBaEipJ/jWF26f0KsJvFSObAYwcL6OfAdFT93VZ7dESSCBiAOs4rGeyXpP1grqnx3DdKuuA4amMxrN3NMOMVRZYKE0KsygEcF/KW7NECPfq2/dnxHUnTIozg2VsfO2ko4ZCqw7ZJazBYvmRub2Mxqs4EERa9DqLSg==
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39830400003)(376002)(136003)(36840700001)(46966006)(40480700001)(186003)(82310400005)(81166007)(42186006)(2906002)(478600001)(36756003)(316002)(44832011)(70586007)(110136005)(5660300002)(70206006)(47076005)(336012)(1076003)(8936002)(54906003)(41300700001)(26005)(86362001)(8676002)(83380400001)(36860700001)(6666004)(356005)(6266002)(4326008)(2616005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 19:05:32.2840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ade73429-9bb4-47ca-ad83-08da56148306
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT066.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB5072
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc, hi Vincent,

I hope you forgive me for starting a new thread and not continuing
on "[PATCH 0/1] can/esd_usb2: Added support for esd CAN-USB/3"
from Mon, 20 Jun 2022 22:26:02 +0200.

All following 5 patches must be seen as preparation for adding support
of the newly available esd CAN-USB/3 to esd_usb2.c.

After having gained some confidence and experience on sending patches
to linux-can@vger.kernel.org, I'll again submit the code changes
for CAN-USB/3 support as step #2.

Frank Jungclaus (5):
  can/esd_usb2: Rename esd_usb2.c to esd_usb.c
  can/esd_usb: Add an entry to the MAINTAINERS file
  can/esd_usb: Rename all terms USB2 to USB
  can/esd_usb: Fixed some checkpatch.pl warnings
  can/esd_usb: Update to copyright, M_AUTHOR and M_DESCRIPTION

 MAINTAINERS                                   |   7 +
 drivers/net/can/usb/Kconfig                   |  15 +-
 drivers/net/can/usb/Makefile                  |   2 +-
 drivers/net/can/usb/{esd_usb2.c => esd_usb.c} | 250 +++++++++---------
 4 files changed, 140 insertions(+), 134 deletions(-)
 rename drivers/net/can/usb/{esd_usb2.c => esd_usb.c} (81%)


base-commit: 6914df1891c27f83e538dab3f5aadd2842e89a7f
-- 
2.25.1

