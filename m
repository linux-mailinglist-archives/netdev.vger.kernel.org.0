Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A85897DA
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfHLH3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:29:34 -0400
Received: from mail-eopbgr700042.outbound.protection.outlook.com ([40.107.70.42]:19297
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbfHLH3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 03:29:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9YmZwUSi2+B08oPkJuyCSrlma5ABiFRxgXFJ93m0c18fgapqMoUjmPSlxo83kq10dc/oaz9UUVCKZoyxJqqM35T1JavzOm4g3i+5NI5L2M8F/Y5H9n31Va06mEzdohwggPIMo+VmxOJVBX3JfW0+zKBTtS73zCUyAh2+RzzELdMmMNaLwqdFphDS8gDt7p5KSBhgWqRbXA78SwXuLiHiSqjHPrzn4rVWvxFgmtrtLIF4rju35en6sHyiDoDmrggHtsPG7Nf3PUK+4Z7sjntjRkAq7KiBmqf96twlrJ73k+n5O82Og7DiCwovMGr6JFBTiplajwXhfbTpApYRUiybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8aKgSiYW3EFieVi3U16SD+TF8QQc/icXf/BNagDnRc=;
 b=Lav8nWQm7423OteX5uACBTxnWz6cTWFARhyA4qnqaNvhyUTcP3i0wmocCgXyWxm0rBc6rw+CzpXUJyXLjVL5g7ql5L8zJLUx4SncwfF0TuH77DaEo92mKnwJF7FLCHgf/Y1s8dV8yp/A5dcI7IqJHsCihJSaQLh7bJHixk7gqOPu8zY0Cy46QFf02E8Gi+rNpE9Ztg5YzdR2uzQAqTwesuiNxhjWE2hsoJ8hcVJVkwQtEI8qKLbi7cWFT2gai5O6WGQ0VAejNfKTJERNz+LWPJvJYjYFZWD4qxB+EDpV/y6uC+lSJF5FRvxg+dEgUEjw2WzBcHqIaBGg7UajXoXFbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8aKgSiYW3EFieVi3U16SD+TF8QQc/icXf/BNagDnRc=;
 b=nZ1zx6LHZH+KoSPkOEk4Du1/QLL5I8IdbC8xgLMWMYo4sPs56aToChHcu0+V7xo6aPHJpama1o5wfGUAh3lEjdDuXrR9uajuKWzwER2RfwCMBrS5gpmaecJwQk9SNgi97NGEL6f/KG/uU0ApXbHFL/pD9xvMQgJNEEo3wQICJLY=
Received: from BN6PR02CA0029.namprd02.prod.outlook.com (2603:10b6:404:5f::15)
 by DM6PR02MB4825.namprd02.prod.outlook.com (2603:10b6:5:10::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16; Mon, 12 Aug
 2019 07:28:51 +0000
Received: from SN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by BN6PR02CA0029.outlook.office365.com
 (2603:10b6:404:5f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 07:28:50 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT036.mail.protection.outlook.com (10.152.72.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 07:28:50 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:47617 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4l7-00072L-Rm; Mon, 12 Aug 2019 00:28:49 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4l2-0000dz-OW; Mon, 12 Aug 2019 00:28:44 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7C7ShEB021521;
        Mon, 12 Aug 2019 00:28:43 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4l0-0000d9-RZ; Mon, 12 Aug 2019 00:28:43 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>
Subject: [PATCH 1/5] can: xilinx_can: defer the probe if clock is not found
Date:   Mon, 12 Aug 2019 12:58:30 +0530
Message-Id: <1565594914-18999-2-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(136003)(2980300002)(189003)(199004)(486006)(446003)(2616005)(63266004)(14444005)(336012)(70586007)(47776003)(316002)(476003)(106002)(51416003)(50226002)(426003)(36386004)(7696005)(9786002)(11346002)(70206006)(36756003)(50466002)(4326008)(6666004)(305945005)(186003)(356004)(48376002)(5660300002)(8936002)(81156014)(16586007)(76176011)(6636002)(81166006)(126002)(107886003)(478600001)(8676002)(2906002)(26005)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB4825;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a44a75b-03d5-4861-b272-08d71ef6b8a6
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR02MB4825;
X-MS-TrafficTypeDiagnostic: DM6PR02MB4825:
X-Microsoft-Antispam-PRVS: <DM6PR02MB4825DD9719B76398D878E867DCD30@DM6PR02MB4825.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Se716XDVyWFgNMYCUY89d/28A8BdfceQvmoOPieudO4pGGInDN10AiPh/FFgruKrpTA5JuEuMaA237NoV9I8mmg9q3IhHoVzsFMqopx69qN9TID3IVtcTcESnufDUNdrOTjOr2JRQwW2aV+P9I3zQ2vkSmZHadBB3NRy1sxp3H5HrG5TQ5HBF1lTClQLBrxiMqj445HbpMu6zr5U2m1qejkzKJhMLwwsnEUBS5EE17kB7YkMOlBPKepUJozZjOK4eX8yHLAX1BriYTdlPOPOK1cYkoimvPJzaC+SXaMkcxLVcY/w0p3MF6/xueFA6RHj/X8WKZe4Nh3wdqntQvWOj+l3ZZLGYdlbobBi9KWibwc006WxkvQPHQkajQUjpfCqbK2OHJmLjm33+tif7SH9InkC1u2kcBGtTq7yxYuXH3s=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 07:28:50.2062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a44a75b-03d5-4861-b272-08d71ef6b8a6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4825
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>

It's not always the case that clock is already available when can
driver get probed at the first time, e.g. the clock is provided by
clock wizard which may be probed after can driver. So let's defer
the probe when devm_clk_get() call fails and give it chance to
try later.

Signed-off-by: Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index bd95cfa..ac175ab 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1791,7 +1791,8 @@ static int xcan_probe(struct platform_device *pdev)
 	/* Getting the CAN can_clk info */
 	priv->can_clk = devm_clk_get(&pdev->dev, "can_clk");
 	if (IS_ERR(priv->can_clk)) {
-		dev_err(&pdev->dev, "Device clock not found.\n");
+		if (PTR_ERR(priv->can_clk) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Device clock not found.\n");
 		ret = PTR_ERR(priv->can_clk);
 		goto err_free;
 	}
-- 
2.7.4

