Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1161506C6
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 14:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgBCNSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 08:18:21 -0500
Received: from mail-mw2nam12on2069.outbound.protection.outlook.com ([40.107.244.69]:6272
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727427AbgBCNSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 08:18:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBZb1WYboyOTTCd4HWi7Xo2q8ag8RUX5eXLHBDRw5D0vjDKiwFZF+rxbk3eGHPRrQ8G67jmSvcS0CBRGTTWjX/Imo5wcpn0AfPzSgnVfRlKQ1i0SdIOlwDrWfqvF2AyGXLb+FM51DVBR3gr7GNNGBcth9XAczDvBQdvNn3vt989eT8+H3sJ07rNkrgeQs7VRyHrwTTAA3qgxKiGb3hRNqQf81/cO4tJ3FIJ0qnXToL9RgYZ1ju4RNM+3olsElwovvavtf0WPOzcKvUQzMhIh/d9iE3RtlYz0YNCfwhZgcKCwg9KqAU6W+YiTxUfm9/hVNvM9aouxFfjbBALiLZnn3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDemxcZHOJOz+vjA6VMVlH6ZW9U2oJaP76Z4u47iTGI=;
 b=dTaLjngae3WVpVomkPJYI3ntvdOBinjBh/30DfQ4WJg+PKfJJeKdHywycnTWAaZXWXWZN+HplOaAwxOfW5Sn7kn0k7EmGrWTi3hDh5uv7hdJdiXGlajqVKWC2T0Woxun9DpMCwWefjKAahpA40wE2o6R6v6JNdSSeK3rPjHg9cTOwrbH9ufU8MkNzDqbHHMe+whyRfxJQrG7VM3sJCBS/YiynskKypMxlvUfmIrTqDemrQGQcmmhgdAdhlf2QeMghaQsyj7PeOzFIU4lk95slXPaK1HhK/WzAK0dkQ2VgZR3t3dGvdGbtkTzYJuw+MKwUiezcENY+fvX+Vgwhb1kCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDemxcZHOJOz+vjA6VMVlH6ZW9U2oJaP76Z4u47iTGI=;
 b=WbIqUpHa2qlcjoqvqTW3yy+iDq1J3y1gN+lRy/8icxKmy2pl56iYDWVFAEuY8mLqkoyBPwRJNc2Z7k5gHcBJv1FHFXbguNRpNLkV/41o6Jt1SywORwLkiQovSiQEejatGQdAqPQvEE7I/35KB06mrBKbzWIJMS36zqz0mEei3ac=
Received: from BL0PR02CA0077.namprd02.prod.outlook.com (2603:10b6:208:51::18)
 by CH2PR02MB7029.namprd02.prod.outlook.com (2603:10b6:610:85::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.33; Mon, 3 Feb
 2020 13:18:19 +0000
Received: from CY1NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by BL0PR02CA0077.outlook.office365.com
 (2603:10b6:208:51::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend
 Transport; Mon, 3 Feb 2020 13:18:18 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT038.mail.protection.outlook.com (10.152.74.217) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Mon, 3 Feb 2020 13:18:18 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcI-0003Fh-2c; Mon, 03 Feb 2020 05:18:18 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcC-0002w8-Uc; Mon, 03 Feb 2020 05:18:12 -0800
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 013DI9Ht003784;
        Mon, 3 Feb 2020 05:18:09 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybc8-0002t1-Im; Mon, 03 Feb 2020 05:18:09 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH v2 1/2] net: macb: Remove unnecessary alignment check for TSO
Date:   Mon,  3 Feb 2020 18:48:01 +0530
Message-Id: <1580735882-7429-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
References: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(2616005)(336012)(2906002)(426003)(26005)(186003)(6666004)(356004)(4744005)(70206006)(70586007)(5660300002)(36756003)(7696005)(316002)(8676002)(81156014)(8936002)(81166006)(9786002)(107886003)(4326008)(478600001)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB7029;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8785c000-acb3-4885-21ea-08d7a8ab88ef
X-MS-TrafficTypeDiagnostic: CH2PR02MB7029:
X-Microsoft-Antispam-PRVS: <CH2PR02MB70293536C971B5B7BEC662CCC9000@CH2PR02MB7029.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0302D4F392
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhUvKUQSimajCHHKkJUbP9jgXxlhnk5aPQUIi3FbkzBvIUSKUjDqjurB5540w884jNv4jkVMK3BvFF2AAv1IsS/dpY68QNMPcwCFZ0zgdfmkIMycuVqJJ8xIA/hIwvWQfTs0TqZjFo+m8qtz4tuRnFnhN1jYqUfm/yAfuFee1QTLSTmjMV+Rrbc6M1jkO1Sscrx1LSKXMh1h/M1/kg4OT1QIlzd70pMrajMfEVUeKuDwyIsBQST+yIPPHxrWZWtxcZYUts1LMbxH7ovQj5RMd4kaASc4Fxkn//DCtIswmnr5wxslhLSDUzW/MGbHh1GJS+8idjYq520Z5UqvJUzOFPldxCxPkUGq7j+25wgs+fMhvU68khhWN8DW7SLEcxpzImCLO0JDdUBBMPaBpgf/QxECbLQR6BawuvFn1ltEcmEg2mRz9lllPAQjkZbJbTOG
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 13:18:18.5170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8785c000-acb3-4885-21ea-08d7a8ab88ef
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IP TSO implementation does NOT require the length to be a
multiple of 8. That is only a requirement for UFO as per IP
documentation.

Fixes: 1629dd4f763c ("cadence: Add LSO support.")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
v2:
Added Fixes tag

 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7a2fe63..2e418b8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1792,7 +1792,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	/* Validate LSO compatibility */
 
 	/* there is only one buffer */
-	if (!skb_is_nonlinear(skb))
+	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
 		return features;
 
 	/* length of header */
-- 
2.7.4

