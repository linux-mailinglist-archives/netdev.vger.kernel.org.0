Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DFD56BF32
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbiGHSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbiGHSNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:13:36 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140094.outbound.protection.outlook.com [40.107.14.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97504DE7;
        Fri,  8 Jul 2022 11:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao9DEvH21KXWIeh8gttzAArcQKF5VYXs0UWlm20wdLk/cDRhnYULRLpQKMTzAZmrkrFsRoxR9ZPfie+Xad9caSQRleJHQ80q3bZ5R5jt07GuwAYBo3Hpf8MPYcnbMQ5gI//2wSKCoRgQJtR1lfkIlHeh6SfATz3q3v1ceD5LDTtKA5OcsRQ4HZ+Qimom53fLb7+tuGPwk0wfCt3hhUz0IMe27PoO7BLgtNJUhdMJxrEhjxJyVFqt/2iMYVNlw2eOD5ucEZm5TBo2y7U1nWXbKRCITEJ1kd6+kO6aZFphXJSLN12vjyKIcEmplDm5o1ExzAqYoMzZBjm6N6hOzDDjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuX1TtoOw/dHIOZW5BiPyJkLxmsSpKq3XoaAeYPAuyw=;
 b=M37k49bUA2SC+dXrh3IfzEB1tg+ZigoWkZALg1ksEga6umqDWSv4uuL9lasmiB1Edkg+9FdS7z5Mb6xz3Ua0TbRDyUM8ZG0yvZxZimCCH7+81LOv5JHz06zfCEXai6U4i9Cnqz+Ju3dKYwTWZdm0lD+rzUeOh87qIEa3svtfk9wyaf67i95SsDVcU4W1Ko+i79CLLOUgPhohe4Igyo6/4Jk5MpvEUBo3eMvQPvWas+k2pMwYHvzN15A8KPE9d8z5jgR76XcQ+UW3ILzX35zuF05wk6DN/sZFOG9ucCXNrpSxeyzNFR35JugTm4hh52rngY4fuQX1XU3viBMDooON7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuX1TtoOw/dHIOZW5BiPyJkLxmsSpKq3XoaAeYPAuyw=;
 b=dc1OGz5kyq2k8j63hArF0np7N7xauWGKGGiMGaQIABcBgnpoORtKw2pHEw/4SWGgfFy3gSY2+knb0lw5oRhs2gimhMC4wuwR5/TgvPct33AKgig5YG5JeIFs9ZdwI5Qf+iQz1XrvMBpYXim87QAAlXa1tbyq9wvKSmQGZmMzsXs=
Received: from DU2PR04CA0356.eurprd04.prod.outlook.com (2603:10a6:10:2b4::14)
 by AM9PR03MB6978.eurprd03.prod.outlook.com (2603:10a6:20b:284::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.19; Fri, 8 Jul
 2022 18:13:32 +0000
Received: from DB8EUR06FT013.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:2b4:cafe::fd) by DU2PR04CA0356.outlook.office365.com
 (2603:10a6:10:2b4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT013.mail.protection.outlook.com (10.233.252.209) with Microsoft
 SMTP Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:31
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id AA02F7C162F;
        Fri,  8 Jul 2022 20:13:31 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 826902E01E2; Fri,  8 Jul 2022 20:13:31 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/6]  More preparation for supporting esd CAN-USB/3
Date:   Fri,  8 Jul 2022 20:12:30 +0200
Message-Id: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 94e9738d-748e-4abe-0fae-08da610d90f8
X-MS-TrafficTypeDiagnostic: AM9PR03MB6978:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7iU0UlIgESaa7zNNRjmLC4mUW3fxCLgYCL7TVzrjLPsg4QwQe5MB7L/msyHfmokr43UalB8SmJj7lvuuI8gUlB2WJhpeNVpPwb2NBjwJgar7v22x73GRi9xPkT65tBPikUT+tHaRE9Z2CrhhGu6er/g6INiEU9VNtrT6a9oGKZNdVLI0Ad02KDoOLsoQpU/K88WGf1pejV5aA5E5FBjwxA/FU44KEZsFtr/jYTurD5P5mu0Ek0oFq8JkhIfJEsBeXZxiYzs0AHt5UgqX0PSBcDe4IoWnUeAR64spfJHsREKuGnA1/Uiu7H/wu/tbGcwyf/Lz6oaeVAlzO6P8kGHTxPCG4gx7D9zqmQ3MSCjJnQij+RI1oq6VPTv42h+P1b3CETyLG76brS3doXFbrQz+3E3Qn9czDu7wneAbk7NNkZADz3BGSor+2cdtnsI95WPivGNku2CEOO9lu95kQL/4/aDxgpqGASwJUslMwrmMbEnNwq51bxnUOBNvHgr3wttAODDFfHgFvF5wCYikw7wpwWoW8K16+jomFYhqVCo3LjRvyr6YBVfCcRacT2fhc8gPCeGt71FtruKxwEgHQKf5WjS63pxtvw7ZlTxmkyMMpw+w7B02JBs9pFqZbGlhvw1V/6VrqPTUPy+Hy5DOlFK7lLyERQy03W0YNE/Pb96C2BpTkmIkpzvGI2jFsQn6mmB8CynFzMQ2/DLKapFge2uPHfMrabABfg3F5i7sJtFtiyZqHxC4uVlYYARmZlz6AXSbh1DMt2IaDUgILmRa7+scOHRqwltSJ0Ib6ft+CFTZxCI=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(39830400003)(396003)(36840700001)(46966006)(316002)(70206006)(110136005)(8936002)(1076003)(4326008)(70586007)(5660300002)(86362001)(42186006)(2616005)(54906003)(81166007)(6266002)(8676002)(26005)(41300700001)(478600001)(2906002)(356005)(83380400001)(336012)(82310400005)(4744005)(47076005)(40480700001)(44832011)(36860700001)(36756003)(186003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:31.9897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e9738d-748e-4abe-0fae-08da610d90f8
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT013.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6978
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hej,

here is a second batch of patches which must also be seen as
preparation for adding support of the newly available esd CAN-USB/3 to
esd_usb.c.

Frank Jungclaus (6):
  can: esd_usb: Allow REC and TEC to return to zero
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (1)
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (2)
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (3)
  can: esd_usb: Improved support for CAN_CTRLMODE_BERR_REPORTING
  can/esd_usb: Improved decoding for ESD_EV_CAN_ERROR_EXT messages

 drivers/net/can/usb/esd_usb.c | 87 +++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 20 deletions(-)


base-commit: 0ebd5529d2ddab76a46681991d350b82c62ef13e
-- 
2.25.1

