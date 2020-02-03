Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A8D1506C8
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 14:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgBCNSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 08:18:31 -0500
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:9920
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727429AbgBCNSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 08:18:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwBErCodGjXin8UFqOcHYfzm62Z+eCisJUiYpMPUl9dGRQ5z+DBKZslkqW2pAU/fhqM9wkn7igUeHZwp4lK7CB4D1m4/mCUTAQGuljNrY6xOd0fb+TF1USo0gJW+c4HkbMyFaPDLCss/+XkAJ3v9RUVrIsYupQIRvz9NJ2cVUtYmSV3BHlRWbuYRiV7Eyrc3uzbBGovdDVkDb59CLfDFdHAfMRbXVNtGfxhxO5rufgNFJjJD/Y8yXkIau4qdS60+sLNy0i5LqbPibXOUIUMMM8N7kaD1HiYHyLZPh2GHqjE0yjlIBBXc2GB1LvglTz92PLEA1IoRGIxlDcnmrNosog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUoOuWEFjbKdvPfh3uM4oMkbn2oyS/YWms6nxe2OUV8=;
 b=fk6d4UBeM2NB+/U9QlZLo4W9qQMSwXo2lR+2TCW4KHXHSDcgXZRCODJMYfCU8RBWPNX7konSASwvZT+daav7QN8h0fhh1wY2sTV8RK6YloKg9F5HxhvXdFDrSA1F/zCIzqoCTcLmvfc6NuGLQTK78dsMP2G0EgpYNyyI97vTiDpCkH7Dy9iDzexpgFpBRqqTBoDr7yovz+l3SYKKAKcZRln6YaxTE/lLz2MqvR3Kbxw4WS1l6vwl3PIURdNCY4qMQLR/UhjaEIyrlxbj6dIZMKNsHQmGTein2ZrFa6MUysY/04h2RnloU0tLi7Be0tpgSoZXqjO/HGrNNEm5/ULzNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUoOuWEFjbKdvPfh3uM4oMkbn2oyS/YWms6nxe2OUV8=;
 b=ihIKVH1VubzkSjmUL1xGBcYrKYOxoS9OcH14t71te4c0po7kxJh7c6aOwNMMJWx75A/HEB6jkkY0L+DPkEfLnTrpJ/ZqbB02E+tt9XLn77sTGq0B+i14dp23aUOIS06gVJ7k3MGgYBeUjqhRBCojWomD6zc3MxB0wc0kF6tEZiI=
Received: from BL0PR02CA0131.namprd02.prod.outlook.com (2603:10b6:208:35::36)
 by MWHPR02MB3341.namprd02.prod.outlook.com (2603:10b6:301:6c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.33; Mon, 3 Feb
 2020 13:18:19 +0000
Received: from CY1NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BL0PR02CA0131.outlook.office365.com
 (2603:10b6:208:35::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.33 via Frontend
 Transport; Mon, 3 Feb 2020 13:18:18 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT064.mail.protection.outlook.com (10.152.74.64) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Mon, 3 Feb 2020 13:18:18 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcH-0003Ff-Ua; Mon, 03 Feb 2020 05:18:17 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcC-0002w8-QA; Mon, 03 Feb 2020 05:18:12 -0800
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 013DI6Xt003776;
        Mon, 3 Feb 2020 05:18:06 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybc5-0002t1-OQ; Mon, 03 Feb 2020 05:18:06 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH v2 0/2] TSO bug fixes
Date:   Mon,  3 Feb 2020 18:48:00 +0530
Message-Id: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(396003)(199004)(189003)(9786002)(107886003)(4326008)(81166006)(81156014)(8676002)(8936002)(44832011)(4744005)(36756003)(356004)(6666004)(2906002)(5660300002)(7696005)(478600001)(2616005)(426003)(70586007)(70206006)(186003)(336012)(316002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB3341;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29516843-2501-46d8-f9ed-08d7a8ab88e3
X-MS-TrafficTypeDiagnostic: MWHPR02MB3341:
X-Microsoft-Antispam-PRVS: <MWHPR02MB3341F796997A347C867A2F01C9000@MWHPR02MB3341.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0302D4F392
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgcVO2gJSz2sDf2WMxTOQbNXiducNCOS4R62DDNv1XvoHSsgBg7Gxw8jdlRD+hYtcf0xLNOog5zBDqWbiwFe+0UBFaHQjHfJPqW5cJ6dGvwZIH44rH9Vi88CI1rEGxfXeqVuCAoxbamx4zgQXWSZenpt8SiQxvkOVoyGX/0zapVlkCoFQ/mFbH+GDHNRH0htV23poOgAK23Jz5Ncp3K0pJGK/gNvO0vOWj1DNbcaZHjFAS7S1DkDfm2Zp5NcLvPL3uTWMNoXePE9l80Ue5CxlNZCV4XvfqrwCuOyQjoTV+Y5P7RDP6OW3ObacuPRAskF/rr0z0972I2aeqCKkO8qdlxUKLJ4tmV/am+ewrgaMIa1G4dk2CSIycog+IqHR1DZyoRvuqhww+Q1NJUW22jVP8OUMgWvt3CRcPglF76+vxyNVvgnfMljdq+GCWIg+fAa
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 13:18:18.4089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29516843-2501-46d8-f9ed-08d7a8ab88e3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB3341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An IP errata was recently discovered when testing TSO enabled versions
with perf test tools where a false amba error is reported by the IP.
Some ways to reproduce would be to use iperf or applications with payload
descriptor sizes very close to 16K. Once the error is observed TXERR (or
bit 6 of ISR) will be constantly triggered leading to a series of tx path
error handling and clean up. Workaround the same by limiting this size to
0x3FC0 as recommended by Cadence. There was no performance impact on 1G
system that I tested with.

Note on patch 1: The alignment code may be unused but leaving it there
in case anyone is using UFO.

Added Fixes tag to patch 1.

Harini Katakam (2):
  net: macb: Remove unnecessary alignment check for TSO
  net: macb: Limit maximum GEM TX length in TSO

 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.7.4

