Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B423A499F
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 15:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfIANzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 09:55:33 -0400
Received: from mail-eopbgr780059.outbound.protection.outlook.com ([40.107.78.59]:55456
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728978AbfIANzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 09:55:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff6MekOaEN4J0ycNiAi6lPqpP21qDM3H+p9R4+xQSwNLvFYUuP6Mbco8fHUDIdsb2nBsWJLqVx5C8GY6QMgg9wQ4Y4vcwYsOrRBorXwRpY9nmkBLZXzxXk9c6tvqHPhSeVfW+0mMJuc/aSjRdsyUdvBNjQSg2L/a44SLR5/QuBL2UlmRSyWp1FQI/Vt9vc+SlAR8FeQEkn3zPVxg/8YOUKx8p/j2ioHde88ytSEqWv9lHI3A9RTGK7vFReiThoJpyhbCX7UIoDAMcB2T/Fqt/Q/FST5MgBwvQsU2aMJWjtgMjP7lOaaSwRNrIPVZZ/x1mqjffuRMRjtnnMUWUk0Ldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7yxwVP/AVkIX/8WRJlsX+U5eAJv6HlOvT6Hi8YIGeE=;
 b=SWNYolaMK6uSGTlBDizyRSBTLGJFNwlaGXoGJlKTUwGn6+vJmlcsKAeqRlHFdnX/ex89vE4u0H4aVwCU6YVOw/6LgzCQAbULK85DI9kuQBdTaru1HKtwv1qZihZi8xXwfQmABBEJAWmjgOaKYSrzN+K6rtQL/Ju2e7yRHpd+ViVNznqyNCiF13Gwb4qXd+qlj2VwPGVSXsa3qzxXDjC4uXKkZMhDwv0T8r9+6+qdapcKkVtJzri4ssfqw4ME/C1dBWqr73ORqbNHi1j0wmv8m5fR4vI/3tGs2u6Rq5kV2ng2Ja6zO0ZheTtZY9EZpwTf2f/btAejNAYuLHpPOBwDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7yxwVP/AVkIX/8WRJlsX+U5eAJv6HlOvT6Hi8YIGeE=;
 b=mhxe97xva7DC3v8cXW/WR2SxgepHazwDw+8hWs20iIfEDfAGIxGi4QEzf7V0OAIspW16/CNFcB4TgO6xv9aXyFHNY3BfUQ2qc+McbfswYFU9MBZ91VMt/yt9NAQ+f+SrXL3p/f6gtweYBxa+Zc3Rj0HnERyAg3orrvnPLdfCWfg=
Received: from BN6PR02CA0094.namprd02.prod.outlook.com (10.161.158.35) by
 SN6PR02MB5342.namprd02.prod.outlook.com (52.135.104.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Sun, 1 Sep 2019 13:55:26 +0000
Received: from BL2NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BN6PR02CA0094.outlook.office365.com
 (2603:10b6:405:60::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21 via Frontend
 Transport; Sun, 1 Sep 2019 13:55:26 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT017.mail.protection.outlook.com (10.152.77.174) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Sun, 1 Sep 2019 13:55:26 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QKD-0003IU-Mi; Sun, 01 Sep 2019 06:55:25 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QK8-0002cJ-JH; Sun, 01 Sep 2019 06:55:20 -0700
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x81DtBOv010528;
        Sun, 1 Sep 2019 06:55:11 -0700
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1i4QJz-0002an-Ek; Sun, 01 Sep 2019 06:55:11 -0700
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id BD9678035F; Sun,  1 Sep 2019 19:25:10 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V2 0/4] Add Xilinx's ZynqMP AES driver support
Date:   Sun,  1 Sep 2019 19:24:54 +0530
Message-Id: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(346002)(376002)(396003)(2980300002)(189003)(199004)(4326008)(26005)(6266002)(47776003)(478600001)(336012)(107886003)(2616005)(2906002)(51416003)(476003)(305945005)(426003)(52956003)(36386004)(186003)(8676002)(48376002)(103686004)(316002)(81156014)(16586007)(42186006)(50466002)(70206006)(36756003)(54906003)(44832011)(106002)(5660300002)(50226002)(6666004)(356004)(8936002)(70586007)(81166006)(126002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB5342;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0e83762-9a62-495b-6d0c-08d72ee40ac5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:SN6PR02MB5342;
X-MS-TrafficTypeDiagnostic: SN6PR02MB5342:
X-Microsoft-Antispam-PRVS: <SN6PR02MB534229D264DB086F71B82C24AFBF0@SN6PR02MB5342.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0147E151B5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /OcqxX6/QFtxAMYuot8kLDiqTJWgTQkVT10JyZ8ZE9oIxtJ04SpVvRrpKnx61HoWMIxz8DWmZBHv3iV+PscvabSWk8SYLenKM631XK8nuAIXyjS3HR5o4v5r4xUiqXYAMGjuH0MSTI9KS71bypvGX/V3fmAgHE7z/GemAzyxff8/Lbxi4dABhTQQpMR2daR2nwKFh72xLX4XzZBYeAk57/UeMamJJgrKWrfLuid36S4Y4C2YLJCL642KnHOlBjykd57JAJ2dkAYjFv/lUOIBhnbrTaJvGdx9brZC/oLcg3HhrukA6gvMpvFUUc7wmZpJuLIC5QaPqE7IYxm9nNv+VtTtuWm0pueK+1LuZufLZTW0LeqMb8JagVie706m9X53MzNEEREaA60iJod9y+BZBfu+Jxp0RyL9WOvG+3FMWJE=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2019 13:55:26.2611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e83762-9a62-495b-6d0c-08d72ee40ac5
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5342
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP AES driver
- Adds device tree node for ZynqMP AES driver
- Adds communication layer support for aes in zynqmp.c
- Adds Xilinx ZynqMP driver for AES Algorithm

V2 Changes :
- Converted RFC PATCH to PATCH
- Removed ALG_SET_KEY_TYPE that was added to support keytype
  attribute. Taken using setkey interface.
- Removed deprecated BLKCIPHER in Kconfig
- Erased Key/IV from the buffer.
- Renamed zynqmp-aes driver to zynqmp-aes-gcm.
- Addressed few other review comments

Kalyani Akula (4):
  dt-bindings: crypto: Add bindings for ZynqMP AES driver
  ARM64: zynqmp: Add Xilinix AES node.
  firmware: xilinx: Add ZynqMP aes API for AES functionality
  crypto: Add Xilinx AES driver

 .../devicetree/bindings/crypto/xlnx,zynqmp-aes.txt |  12 +
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/zynqmp-aes-gcm.c                    | 297 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  23 ++
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 7 files changed, 350 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
 create mode 100644 drivers/crypto/zynqmp-aes-gcm.c

-- 
1.8.3.1

