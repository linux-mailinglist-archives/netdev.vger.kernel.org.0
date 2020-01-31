Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE8614EBF0
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgAaLsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:48:17 -0500
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:43206
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728451AbgAaLsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:48:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrRtxGVZVawUbRfesaOVPuZ222P2sct4xc2fTmBjWUaiW6eF1jcd6C6BIdRmA1wNcx54rjfiPv7QqqJwaG8+Ba8oAd0vxIfAjw3Wn9gammVnw3+H+VUdk9HBFZ1Am/T4n7Nu7eXn7G8eZWXydnsaCOhmODMN8JZVCA0iDP7k8xKas99/T+ppCKGYYRYEuR53qIeOKgQbn70jNnYP6bWFflD5XXfld8WNzU8jMm8XKkrqcZXivVJjVk4TgcD7UTLetEXS431R5OOpWcofHlhaP2hUCv8Paxl08IziFLF5kMZvbF97Qv0YBYWjy4eibKxsJbYideKAEHNClCxw/dKf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2xrN4uE6dmkEFp3QyWtvgwsddGdWcnSuq6P7Wxey6M=;
 b=RNMOha9vRjUlSopigcBSBBSrhvLasO92umKgos1tYl1nDOeKWV+0QRk65AfC+eQoRzHsp01VGeCT3wmHeQmmOZ9ImL5xAsqPl33YjotKlANI6indZG2WieV3kxPyASniQu1fvgmIwIVVmOszATzIdXN8CJoj7Si1OQS795ss/uas6BZl0k63JbIcG7YqghZZ2sSj2hx8Q06lrr4bQynoIoQySQrGftOt2VGc6BLoiG7Y4PIf8DoGMhpBWidwiShIXNaMB9o3QA3CLCc2cd8+74YaZ+E/FhgFFOS9WhSk9tlum0RUqlBeWk6Dx0RZ0oyAQ5xOkjtq+zSwoWQYGQmydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2xrN4uE6dmkEFp3QyWtvgwsddGdWcnSuq6P7Wxey6M=;
 b=eM3hgSIRz0f567XEAGvThLwt+han/KBKOvVVcpYraJCvixKCAVQvZA50ggFR0daf+AYGGfj0TYtRawXavhG5+2UCxWkR/bK9zHOeh/a2GDOJhNr7SI56gQHPLIEzGKWJMnFVFOEI/xujshr9roCXedAgD4MZvsrtIfNBS1n4jS0=
Received: from DM6PR02CA0052.namprd02.prod.outlook.com (2603:10b6:5:177::29)
 by BN6PR02MB2305.namprd02.prod.outlook.com (2603:10b6:404:2b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.24; Fri, 31 Jan
 2020 11:48:12 +0000
Received: from CY1NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by DM6PR02CA0052.outlook.office365.com
 (2603:10b6:5:177::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.23 via Frontend
 Transport; Fri, 31 Jan 2020 11:48:12 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT057.mail.protection.outlook.com (10.152.75.110) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 11:48:12 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmS-0006bM-0O; Fri, 31 Jan 2020 03:48:12 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmM-0004pl-S0; Fri, 31 Jan 2020 03:48:06 -0800
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VBm5bW012164;
        Fri, 31 Jan 2020 03:48:05 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmL-0004ok-C2; Fri, 31 Jan 2020 03:48:05 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 83FDEFF8A7; Fri, 31 Jan 2020 17:18:04 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v3 -next 0/4] net: emaclite: support arm64 platform
Date:   Fri, 31 Jan 2020 17:17:46 +0530
Message-Id: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--0.125-7.0-31-1
X-imss-scan-details: No--0.125-7.0-31-1;No--0.125-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(428003)(249900001)(199004)(189003)(498600001)(5660300002)(4744005)(42186006)(107886003)(6266002)(36756003)(316002)(6666004)(42882007)(81166006)(81156014)(4326008)(82310400001)(450100002)(356004)(336012)(2616005)(70206006)(26005)(70586007)(2906002)(8676002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2305;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 644481d5-5ba2-4ca5-28dd-08d7a6437364
X-MS-TrafficTypeDiagnostic: BN6PR02MB2305:
X-Microsoft-Antispam-PRVS: <BN6PR02MB23051CB33626B4B68DA354B0D5070@BN6PR02MB2305.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjuE7RJni+d/Ae9LQPU3Ub1WJKE0DHtpJ1d2lj6GV+QG+oH/vb8dOHdszlyj9IfuJm7G4DHMSbWXL3dm+DAFVClfIXXxoHDxIZMEXlIlTCpS4MiRBo6MlPeAJUkVrda65VkRTJvdQqoGd3CihjIQFbHFqkMJn8YQ7+81TdNHt1Ew+rvolJ5Ve+Ab9U/wyPM9DCVd0RfqTxNimpT2l+6neJHLIPIl13qmtBbuS1qUHI6bVuCppH1Mq1mfmLxVwFofLS2KI6pRmHPaARFzJ2ERTUOhfqxjzMe8LDcU6u/zIEhJTnvDulMSN+t/duRKie33wgBKysZEk7Up1+pTzmNcolIwNmClyi+EZgOM6hBDq34p4rzNyVSx1sxdadkPyvr5UPvznTIZDZAYNiFxUSpsXTVVYZVZrcvrze9RoARpcj4Uj37dIQybusJzY2Qlv3jF
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 11:48:12.4677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 644481d5-5ba2-4ca5-28dd-08d7a6437364
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2305
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes the checkpatch warning reported in xilinx emaclite
driver. It also remove obsolete arch dependency in kconfig to support
aarch64 platform and fixes related gcc and sparse warnings.

Changes for v3:
- Fix sparse warnings reported by lkp@intel.com in=20
  [PATCH net-next v2 2/3] net: emaclite: In kconfig
  remove arch dependencyarch dependency patch.

Changes for v2:
- Modified description of reset_lock spinlock variable.


Michal Simek (1):
  net: emaclite: Fix arm64 compilation warnings

Radhey Shyam Pandey (3):
  net: emaclite: Fix coding style
  net: emaclite: In kconfig remove arch dependency
  net: emaclite: Fix restricted cast warning of sparse

 drivers/net/ethernet/xilinx/Kconfig           |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 52 +++++++++++++--------=
------
 2 files changed, 25 insertions(+), 29 deletions(-)

--=20
2.7.4

