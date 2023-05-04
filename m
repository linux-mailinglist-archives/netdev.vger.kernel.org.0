Return-Path: <netdev+bounces-300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D0C6F6F49
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC31280D80
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BF679F7;
	Thu,  4 May 2023 15:44:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BD9FC06
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:44:29 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2113.outbound.protection.outlook.com [40.107.105.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02F2199E;
	Thu,  4 May 2023 08:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEzFGJ4o8ZCv7kXwufFOgOHkRYilV0QsYNvlja4iE8ujoxCUSvl+Hw7C4hNCo/3yhdRDH/P+NI7Svg3sOaGETbzgVKZdd5eDIZgfoImh+Adr15yGBGAXoXdhRNTep/nUT8WLLhN/v0mRZUlg/WTqPpOVmaeAfHrNt80uoKvvXcuBrBXehCFcLOluVkeQ8jWDoFB5zAxe257IMRbmVbl9/IROcxHK56sxrd8GCj8bh5rgk8441BBSppme1VP6ew4grr0XxBOWmDM2vNsCuyWVe8ddXD7a0WO2+gdJ4UjMQW4namca+C1qPfqFShn0Bk0jByXMaAsIIofhMCTWLTo3Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMpc29pz1VGr1DR55YEuxV3C3ua0fd3bkSRPuCeoGCQ=;
 b=l4zFxTNwhxAglqXu9N25oAIPAKJCehlXn32K+jlPgXw/yLYvfLxnUJK1Xx/fGcxQgG8l284JUqY13DXlla8zuGV0gfHs/c3ozco1BSLB18AxVcogVJG4ongFrdpjHLuMdQut2RxqMwsb3ZkKjP6lEA+017j85VOntw477OgkVov3+0OIRDrmeMKPI3TVubAMg7tg1hAH9uDkZaF6BcF0CXVuDtKrniNk9KcGxoul5IL0pAWzrwUiH+jNHsPh+/fopEmI657BFDC4DDjnavfcOwac3z7dGJyYDm8ClPwOUscP0Y56YTpmIK3Ivg+hEszLUCwaTxQNcFMzSkCwRiTVbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMpc29pz1VGr1DR55YEuxV3C3ua0fd3bkSRPuCeoGCQ=;
 b=Vs8Zt9r+jAo4cVEacXZPjjHKhTPRlV/FPiXabdQCwhpDczeOGEKgpPH45D5vxQeqtkPrSn9CCFJpECOvkqKLXipHXL2HhO80s10maMc6HvHWkwklXAwJpkmtRjoJCwniKTIXdtSPfRFgDOXlwAxfR6uu94VHHXDlNzfPXmZQsf8=
Received: from DB6PR0301CA0058.eurprd03.prod.outlook.com (2603:10a6:4:54::26)
 by DU2PR03MB7845.eurprd03.prod.outlook.com (2603:10a6:10:2d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 15:44:22 +0000
Received: from DB8EUR06FT052.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:54:cafe::4c) by DB6PR0301CA0058.outlook.office365.com
 (2603:10a6:4:54::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 15:44:22 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT052.mail.protection.outlook.com (10.233.253.226) with Microsoft
 SMTP Server id 15.20.6363.22 via Frontend Transport; Thu, 4 May 2023 15:44:21
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id 955A87C16CA;
	Thu,  4 May 2023 17:44:21 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id 84A2B2E1787; Thu,  4 May 2023 17:44:21 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/2] can: esd_usb: Add support for esd CAN-USB/3 (CAN FD)
Date: Thu,  4 May 2023 17:44:12 +0200
Message-Id: <20230504154414.1864615-1-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: DB8EUR06FT052:EE_|DU2PR03MB7845:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c97ee608-2134-42e8-3762-08db4cb66e31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VsxR2RcIaFNeKAiWiM4v6z+p5wWRUdXkuvQL3UN1U7T1K/1/BULAVT003H++/ncEfIKbfBfQb14cEFhBtovM89AzKxVqnekm9UKRePrK7IX/xvz5DE/Q5OvSJwkm+w0h3iFMbkiQXHSldq/YcAST3rgSoaKFUlbXLnzPkzf6fkFFB4HV8Vm55BZi+20Pf5TPTQfJLiqEiaYlGptR0ALx9zpn4sOcLXthnLRSF+wCFaNXk903thRPb6sKT5Rm5jsC36Jhu3RfrWzqt/eElxNdNiXhp6MW1TmlT64qmMaWnswjnK7JZUcz1Ki6cRXBLX0la2UJ5c1E6iyiZlPfwQwJHMKOfF2AZuWC587dyvVJiLkBbSU35KK/fZBTh+DJpJX9ItIMWMUtqvQ5ZE972XAyIjpI1stam+gsqPAODTDc2dlFpukvgDYdCINBu1IZXAXwRKPDkn9V2A++o7HxISS4sV1SpfQKh7sZWDQBHfAEl4951li94WwIqmmk6bmB+DupTUx05exSDybckXxX5nya3f76+YuzhyAYyaxnD8U8fbo0+7apL/++e0hh6cRTNS4cJO+l7n69nemiC9cWr7ZnCp9abe8qOL1FOzj9+iJKZxEzq4saa/1rXRNWVIShQZwp6Hj49pyQAKTlf9Kw1i9qCHqGbMa89iITnHamUwPYlG4=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(346002)(451199021)(36840700001)(46966006)(2616005)(26005)(44832011)(1076003)(41300700001)(6666004)(40480700001)(83380400001)(36756003)(316002)(47076005)(36860700001)(4326008)(86362001)(70586007)(70206006)(82310400005)(336012)(478600001)(2906002)(4744005)(110136005)(42186006)(356005)(81166007)(6266002)(186003)(5660300002)(54906003)(8936002)(8676002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 15:44:21.8441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c97ee608-2134-42e8-3762-08db4cb66e31
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT052.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR03MB7845
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for the newly available esd CAN-USB/3.

The USB protocol for the CAN-USB/3 is similar to the protocol used for
the CAN-USB/2 and the CAN-USB/Micro, so most of the code can be shared
for all three platforms. Most work simply arises from the fact, that
the CAN-USB/3 is capable of handling CAN FD frames.

The main job is to
* also probe for an esd CAN-USB/3
* extend USB structures for CAN FD data
* allow esd_usb_rx_can_msg() and esd_usb_start_xmit() to handle
  CAN FD frames
* spend structures and functionality for setting a CAN FD
  bittiming

Frank Jungclaus (2):
  can: esd_usb: Apply some small changes before adding esd CAN-USB/3
    support
  can: esd_usb: Add support for esd CAN-USB/3

 drivers/net/can/usb/esd_usb.c | 286 +++++++++++++++++++++++++++++-----
 1 file changed, 251 insertions(+), 35 deletions(-)


base-commit: 14575e3b5f3ece74e9143d7f7f195f3e5ff085f5
-- 
2.25.1


