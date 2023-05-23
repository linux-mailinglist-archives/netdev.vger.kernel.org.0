Return-Path: <netdev+bounces-4778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E50370E2C4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09A5A2813EB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133C621070;
	Tue, 23 May 2023 17:31:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B1A21062
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:31:51 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20717.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::717])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0A710EB;
	Tue, 23 May 2023 10:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c16pDIdoBZd1stR5bqZkg8gT8SQzy5MRm6uWQq50xMR7sJnFUBuUA7wXa4XyzjOeqcYRHCqJR5QdRf6cFzfmtiGgxJq4cC8bALmBkMcf8GpxWFcDK2+glaj045gYhZX54DKaHSDjIHi1USXTKbhY9/xJpWuh/2PVGkQh4SMtfTdt2+PxdecbKjkMpY5cFFkhjhmhp3CIwTqNGiGf5eUMM/c8c+/oSHXKNaalUCeR6F9KJuc3zUj1K3Jnl3V1TZymOBIXXI83a+y2Bb0tSNRqxVMCNi1qVqjdnB5V7cyMFG/ddhxCfhw3P/Thb+rjBiKphqTGfecV92rRsOwJJHh+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBLW0nsxXd+sZFfRIZukOl99JhCfMrGl5dI/ulyDdUU=;
 b=fWvml+s9fvORsxvixtY+CpMh4OM1KAfZKyz4Ifq3ibvwJdsbUEMB3HphmHTPc1jVCclrxtTN4WktoBv1GJDxKR/0d/6qE6s7XwX9RPnrmFCv5qQXdusQs6VTF/HwEmb8mljqEqKJVoG+AfLf2vAdgM27JZya0iJY4wX+MYEb369LKz7s3Fj8H4dtM8ge0L0+QuY1rl4Ngl8TxqnZT66altcgGnbWCidIABQB3LUytSttfxhEa6mX0SdRv2JRWE5KQmvn90iNTf0dmzGY91VjQyXfZrhkPahLErT3cbRm/KCO4v9v7b1tPPf7331PxVpGQ5ibepQGcVUF2L1sqiafgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBLW0nsxXd+sZFfRIZukOl99JhCfMrGl5dI/ulyDdUU=;
 b=hG2mHr6opGpUSSA4++ZHPxjuJEqAwvCnJpM8MCKqUUWluPuVIxN33CgM5yAicZxo4egKNr6Z/dbZemSwRbZ+e5jDPBqX6DaHGKsy/868k7ioRl2k+MKXYWlPvPG2DD+6ehBet0gdK4tGjSXe3WXwf9TJU273rIYouehGuN39BPY=
Received: from AM5PR0201CA0005.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::15) by AS8PR03MB7349.eurprd03.prod.outlook.com
 (2603:10a6:20b:2b6::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 17:31:07 +0000
Received: from VI1EUR06FT059.eop-eur06.prod.protection.outlook.com
 (2603:10a6:203:3d:cafe::d9) by AM5PR0201CA0005.outlook.office365.com
 (2603:10a6:203:3d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 17:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT059.mail.protection.outlook.com (10.13.6.222) with Microsoft SMTP
 Server id 15.20.6433.15 via Frontend Transport; Tue, 23 May 2023 17:31:07
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id 0222A7C16D7;
	Tue, 23 May 2023 19:31:07 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id E64B02E1804; Tue, 23 May 2023 19:31:06 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/2] can: esd_usb: More preparation before supporting esd CAN-USB/3 (addendum)
Date: Tue, 23 May 2023 19:31:03 +0200
Message-Id: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT059:EE_|AS8PR03MB7349:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 818374a7-75bf-4a55-cdcd-08db5bb37dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6Oz9W0ybPQcFp7xLP9gVgTwr4GlXorTQYekJIF4Wjqa82pFyWccTko9exOrLw3jG7i9twWXdKPsq5p0KBL+5QSX6H1QdG/0mHbcuFlTIfuEXJJ1RgWik2YeiZTlXhADt0XI8j4yN9/hsSdUJdwBbxjbIp4SPYX753H/hBBSuKAp+aEgLerzqbYYyUVTv4nKc/YrjeYVXPXn7IKdwvjLS1oFaJ3felUwt6plb2MR4/9TdevhZvRi3vjSxWYsR40d+WDmFFz55zIYqnx+EohXPqY+ROyiC9riwTys5cLfqxOXQztgcoo0trfHbTyx96tKrvlse6ylXQU/9ZJwEopVWcANTk0Ad5e/nSMjpE0G0zYWoSpp9V+1EZ7aDQ4vHVYbG6ujXEfx3+7nRE8FwShMIYn0RMbIYGENwpXgPt/ic4jY2r3v2PvxZhKfgSbu1wf6UtKcT2nzULY591UOTZJQrKeZ/s7JTbvoLcLF206rO/+Xzl6qp8aU12vsiczS0ckZHQ+CgpFvcFjq89ZOwbZa2D3eDzinC9btXQxZkmx6ko2Krcq8aIT1Qe5F1uA7GypoGDM+d13wc1j3DBaeBUKRwNlFWLOSejwB1PTJNwGPcbcMufpKuyup3XxMTao+E/JHI76tozME7AXZA/THPAdWXBK8UlqKnN/JJh7E9QQskdjfSxXUuQiYz4pcVTyIu7Ksj
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39840400004)(451199021)(46966006)(36840700001)(1076003)(26005)(186003)(6266002)(2616005)(336012)(966005)(47076005)(83380400001)(36756003)(36860700001)(82310400005)(2906002)(4744005)(6666004)(5660300002)(316002)(42186006)(44832011)(54906003)(40480700001)(110136005)(478600001)(70206006)(86362001)(4326008)(70586007)(356005)(8936002)(41300700001)(8676002)(81166007);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 17:31:07.2195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 818374a7-75bf-4a55-cdcd-08db5bb37dee
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT059.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7349
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While trying to again merge my code changes for CAN-USB/3, I came
across some more places where it could make sense to change them
analogous to the previous clean-up patch series [1].

[1] [PATCH v2 0/6] can: esd_usb: More preparation before supporting esd CAN-USB/3
Link: https://lore.kernel.org/all/20230519195600.420644-1-frank.jungclaus@esd.eu/

Frank Jungclaus (2):
  can: esd_usb: Make use of kernel macros BIT() and GENMASK()
  can: esd_usb: Use consistent prefix ESD_USB_ for macros

 drivers/net/can/usb/esd_usb.c | 41 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 21 deletions(-)


base-commit: ef43ce2c3a1879b3d2f021124c199817d64966d2
-- 
2.25.1


