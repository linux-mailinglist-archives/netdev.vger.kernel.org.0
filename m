Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076FB1A7073
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgDNBMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:12:39 -0400
Received: from mail-eopbgr1410074.outbound.protection.outlook.com ([40.107.141.74]:23308
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728066AbgDNBMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 21:12:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/fthckY2ui0Cgls0+gapmTycvWtZaEWrOvpG9illFUJ1YJEJEr7NkHHyoADWX8NDMCEl+URs/bFUShxHvplgxYSdMG9SjR9ckS6sIsUg8XLbhu6KaBjti7c3dL9hh2GvgsonXDppxbVSA2+CGcjbV+ShVBC3DbPWMwR7btkn7EXwfye0Wp/khgwzDjTUYmJyselS5TqdzVWAqvcrF0gMxcKdtz0PNTYvZQcFRHTP7mmficX7359LhJht89Es1OkrsxdpUHupT3sCHQ0q5w+6LrGzAvwqfMp47YFksOIToMLfZ9l0oHYtojlpOC0asUQxrXaOkFIvdVGMTMuIk/UVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=993ZGaEmrlgQlQKGXREPiIe1qOCimmieYk74kxk8zV8=;
 b=Z1JV2lY/Mz684d08ttxGdfnfeknMABbopcQGud6saQa6cxURv+zR0YQxQkPMDpFL+W26ugQpTu6OhVMDVi6Qn3xRbp6lkMcaGO/LROInvwyq0h2AD/KZPwpjFNvBzoc4kVY0RcZEAoBaj+vF37C3UIpRm5W6UFumhSW2IrwNrah28SukiOe1xH4rnn6j1Yoxx7IlXR3jiGnl9/1LlpdVdNq2BojdpZL++ZlvGadNYrqtk80PU639+zOIfwlVAhDRSOFkzL200PHvccR9hiBesd7P04+jv7fnemeQEcZPKz31kthlJT4YBJTMNC9WXgLofm9+yhE74ibsf9196LtJpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=993ZGaEmrlgQlQKGXREPiIe1qOCimmieYk74kxk8zV8=;
 b=Jw6rvairCpTjfEVASr2aOXAVkoc63bfJI7olxOG+7+iiCf6vhL0BTdYTw4tBUWRDmJtJNaIZeWas90CQwccQh0qbe118eHMn3e/a76bXu/VTnHFwd41vF9DyZkkZmXQoQXC0CCo29IdzzTvZtNUiMQRwvDEOji2FQ9px5BcJAJE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atsushi.nemoto@sord.co.jp; 
Received: from OSBPR01MB2087.jpnprd01.prod.outlook.com (52.134.241.18) by
 OSBPR01MB3560.jpnprd01.prod.outlook.com (20.178.97.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.20; Tue, 14 Apr 2020 01:12:35 +0000
Received: from OSBPR01MB2087.jpnprd01.prod.outlook.com
 ([fe80::71ff:5526:838:a89a]) by OSBPR01MB2087.jpnprd01.prod.outlook.com
 ([fe80::71ff:5526:838:a89a%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 01:12:35 +0000
Date:   Tue, 14 Apr 2020 10:12:34 +0900 (JST)
Message-Id: <20200414.101234.1930009524396577448.atsushi.nemoto@sord.co.jp>
To:     netdev@vger.kernel.org
Cc:     tomonori.sakita@sord.co.jp
Subject: [PATCH] net: stmmac: socfpga: Allow all RGMII modes
From:   Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.7 on Emacs 24.5 / Mule 6.0 (HANACHIRUSATO)
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0065.jpnprd01.prod.outlook.com
 (2603:1096:405:2::29) To OSBPR01MB2087.jpnprd01.prod.outlook.com
 (2603:1096:603:22::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (61.200.21.62) by TYCPR01CA0065.jpnprd01.prod.outlook.com (2603:1096:405:2::29) with Microsoft SMTP Server (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.20.2900.24 via Frontend Transport; Tue, 14 Apr 2020 01:12:34 +0000
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.7 on Emacs 24.5 / Mule 6.0 (HANACHIRUSATO)
X-Originating-IP: [61.200.21.62]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4903a2f5-efb4-45d8-09db-08d7e010ea20
X-MS-TrafficTypeDiagnostic: OSBPR01MB3560:|OSBPR01MB3560:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <OSBPR01MB3560AC27DDCF2E866CE27F84BBDA0@OSBPR01MB3560.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2087.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(346002)(136003)(376002)(39850400004)(366004)(8936002)(81156014)(66556008)(44832011)(66946007)(26005)(16526019)(186003)(86362001)(478600001)(66476007)(2616005)(956004)(103116003)(4326008)(6486002)(5660300002)(36756003)(6496006)(52116002)(6916009)(8676002)(2906002)(4744005)(316002)(107886003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: sord.co.jp does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yEG4yNSjgnoYqxAtp+TPL+7RGXIV1SXGxnyUkAQ/xIddR/mi8EqiD5EM1SgKldKEcmzWmMhJjWDbyfRHbWS6AkSWszszUjOra++DFIcThMUtTc9G+9KNspe5d8JA3+Oji9jlnWk1tQl32Fxkaq/OdJCf+UTG2xOhlVBDrPtz0zuRxQWTlGngTc1RGX1aE65maxpYcFc5a3XjJMxiIcWP8eA6kZfR3QvEMB4I1pRF2+Eqk2akjQCmCRf+Yv4PHrH0RIYqOivYyOLompLCyDAtxRxShQZbEu01ClC0OjrfpcKjezdfsUIXfmChG3Kx3FBatTm0mCwWB4W7AziBEH0NAHMncJ+Smlx0rLO16neu4tSxKpzwvMhPEpuktRs3q0OOxnDdRbchLW9msR4Zk+CdSLKTzouhr/VQ3xbs6JqYwzwe1bqxF/wgsLij9twLsKET
X-MS-Exchange-AntiSpam-MessageData: UoXvD0M1MTGe+oqhX9KRdhyUbjUCG2B/MDhca8b/F5HfNxPO8JoQABGm5DmIGdWpOSLbs8g5KrzYJMofTK+r9TjBE/Jmv5e5NlVT4IU+uac7XR+RYFLIVakgGaAC5GMA4kFyDarcaY/hTwK6w4VfqA==
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 4903a2f5-efb4-45d8-09db-08d7e010ea20
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 01:12:34.9540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkl/rI0ZZgTWNm8pQzfKQdflrRD+g/DCJYt64Orx0qTKSmTVIrLj+aB3VHq2WKxrbh6ykL7JXEFBXuF+nPxQNsNWcdnfL4rkFxAJYynI/m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3560
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow all the RGMII modes to be used.  (Not only "rgmii", "rgmii-id"
but "rgmii-txid", "rgmii-rxid")

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index e0212d2..fa32cd5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -241,6 +241,8 @@ static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 	switch (phymode) {
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		*val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII;
 		break;
 	case PHY_INTERFACE_MODE_MII:
-- 
2.1.4

