Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71486514B4
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 22:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiLSVUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 16:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiLSVUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 16:20:53 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2119.outbound.protection.outlook.com [40.107.14.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DB164D1;
        Mon, 19 Dec 2022 13:20:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jV3/coCk8JwcoHscKj/3BMjqqoSIjPvR1saDwH6rd8t8dKX3/sjbRq0rjkgFWOmrwZX00o5dDF7EybrlSe++fCO3NkFEvY5E4d/7xfgXep+dSHlmVT9mYWwPwSnVou9yT4e1YrkU1NQGFZmapyeJGyEtiz1L4/iUj2LTmBfdkVnaWEkMpk5y+Gxqoj0LqOvyJ2KN0bx258Scj9GXDqkzlq395wBuvlGst6n8nTvZ5nuMDdTPQL6RXkvwL2uLWiDUYnd3e9CEdn8DRj2cY5l6kcaKvHXYL+K0cEC614a6g14v7qYyzyz70eOtSKAmD/PSIiyf/8CiOTtRJSQDK2p8ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfD56FZY0Mr4vfWZEBePcqybIvztVygR6kCha9lq+1Q=;
 b=SAZ0PAdyZfHkXtUJfqDr59rTR0vj3x3lbEKh5ll8MmThjTSLDlqOF7UvVQ6HlYYBsnBss2lVSiMiUOPEn21Hky8KOfWpf4cB6y4UR/XxYwpR+0FEPsCBUNUtJ0k8OWL/Z9wK2hdLCvUx6L+fJKAO8Er8VDaaQZKSMckPlxSRfcGZptkIgIy9SJ7LkE/Bco4br59jQGOeBOOVSpvwVYWRaZmY0IBc5+KVcnhvG8PPHqrQMjm6fpYk+xEkeOCxBaJwoubDkSh0ieXaqBOJr3j6eg5ilj+3sKa3Vzx1/iNFdV6uxbPqmqcr4B7azo0ymuUBEkizZbwyo4VzGTYig4Zcgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfD56FZY0Mr4vfWZEBePcqybIvztVygR6kCha9lq+1Q=;
 b=WCQ3k8UsZr2fGNPYlWflftmVKNok4ADdjlTU/cQOqHo0UAIVi+I9SDUmpj60X/R6txikxbSeZQiWxbtkL+MUo4UPtyd29Iz/+aMsSkSCyd+rl5+bkJm9SAnjzbDFBs+aGfMI3Z88HS+b1dI0VOdc2UD3JANMjJ72tQNijUA0NVU=
Received: from AM6PR02CA0018.eurprd02.prod.outlook.com (2603:10a6:20b:6e::31)
 by DU0PR03MB9849.eurprd03.prod.outlook.com (2603:10a6:10:44a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 21:20:46 +0000
Received: from VI1EUR06FT053.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:6e:cafe::bf) by AM6PR02CA0018.outlook.office365.com
 (2603:10a6:20b:6e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.20 via Frontend
 Transport; Mon, 19 Dec 2022 21:20:46 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT053.mail.protection.outlook.com (10.13.6.63) with Microsoft SMTP
 Server id 15.20.5924.16 via Frontend Transport; Mon, 19 Dec 2022 21:20:45
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 16C167C16C8;
        Mon, 19 Dec 2022 22:20:45 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 068352E1DC1; Mon, 19 Dec 2022 22:20:45 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/3] can: esd_usb: Some more preparation for supporting esd CAN-USB/3
Date:   Mon, 19 Dec 2022 22:20:11 +0100
Message-Id: <20221219212013.1294820-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT053:EE_|DU0PR03MB9849:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c367d913-b41a-4ab0-1496-08dae206e498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/3+LNBeMyUz2PaJbNdpQp1xyQuQXPEBmvkRox+DRicoLfUyp7c1fbQpxh6DTnJcE/fAQrX08HjpYW1XZVHzPHplWjdLPTp8m1HPsu5NuIl82Z2mEhLE6bj3dYIuqTSyUV1kdCFU0q+OjrxZYIaBnEFuvK80bFi2eHaGpeneUIoJPIdryzcNNmsU5h0G5f+x8qW47g1cF6gBwRd6QD2ChMprqPAfTg2DK3vrW8VBYShoJBdqJNFChK/xKKZVcWYaX0jq+r7D6F0YgGCRWNvjKUZaMqIi2uQg7DmuYdk2S0yTnBEnAkv35h47CHlWx6mJAgZutQYNQmqex2Qv5UMkoT1EKmbQQBfDygwA+Ers0IShRa6bo5x1+zAyGFkeCHhlKEJWoNEfdowmdKmUCj1UW+gDGEW5z5VOzvZi9D6WDC4vNjJctPChelCtw4wWvxYz0j0XRSYj/ZKwzeJFJYVAv+blGi/l2ngxNSCTfu/tjOzM8uCU9bi+1ElRXhbrdD6eY5B9DFcTAUfYLS12UBv5LUX30RcrJfFZIfvfAstSG+a/608CCIJ+2zRYRlf2KvxyCRNdwxEHBxv5MzXUdIhKV7hripZ/aHoezNp33lF0g+vnWLeuNsSEnMVx8pRPcbKsZ1RdbG6wSYgoK5uQP2KsW42eHdB5fU/UkQW3ygtHBcE=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230022)(4636009)(376002)(39840400004)(396003)(346002)(136003)(451199015)(36840700001)(46966006)(6666004)(8936002)(47076005)(40480700001)(4744005)(5660300002)(83380400001)(186003)(6266002)(41300700001)(44832011)(26005)(2906002)(336012)(42186006)(316002)(36860700001)(478600001)(54906003)(36756003)(86362001)(356005)(1076003)(2616005)(70206006)(70586007)(82310400005)(81166007)(110136005)(4326008)(8676002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 21:20:45.8418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c367d913-b41a-4ab0-1496-08dae206e498
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT053.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another small batch of patches to be seen as preparation for adding
support of the newly available esd CAN-USB/3 to esd_usb.c.

Due to some unresolved questions adding support for
CAN_CTRLMODE_BERR_REPORTING has been postponed to one of the future
patches.

Frank Jungclaus (3):
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (1)
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (2)
  can: esd_usb: Improved decoding for ESD_EV_CAN_ERROR_EXT messages

 drivers/net/can/usb/esd_usb.c | 36 +++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)


base-commit: 47bf2b2393ea1aacdefbe4e9d643599e057bb3a2
-- 
2.25.1

