Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9251A22EAC1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgG0LGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:06:46 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:9800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728583AbgG0LGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:06:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6qDymxKAGTu8KOj8CXbTjtLSxd0rxaitUvATQUfcR5GZKee3/pmufoVosxD567CjuN3laaL8nijU7rKGGHPA60cycouo02IxXTrJWZV/kl23bF4l4bsumezN39t+KCRSVnK4bSNiXLKyCRXfzGcR51rTZdhzaIerMP04CkNj7GdXkRsGCnXNlraA1yaCwEUxTsNeUUVKjDh2KrYx1zUBGYnZ68Ry5aAB64n93O/QrZDgjBBV/LnBpPVTGizrsFcKoMceIbBmexs3UleWzoKec3q/NBPfC+YqTeos0umlWlAQgdasEn1xEabe16Lh1aQqVta2miAiC6BwESfVyExog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFeqm4bYLMU95TL2/TTqThAxEbOs/xP4agF/hKNP++M=;
 b=FCAZbVDfW9QLWgTkc1LkWItdByFybUiMXLTh3fwGHsdH9M8rUznCbSV5vqRdvik+cqY6UwXf7E7gMU8JsicEUsMTIeHFSyLXoYTa7Rn8f3QN8Hloiqdp1hTUEPyX41AMHUIV6zD/bWCuH6RnlQKwBfGieLVl+A1N1iO5LIyOqh7c+CsPDOm7YDaAaIDhPD9s5DicQyLKqMV2Cxp+H3XVQFCKaEbKPiZdRIA1uFNXqIffGOX9qtQaO+m5ishcrMeTS5glHLTvqUu4eZhYj+DO0uS5GJeSll7UEfxA263ROyqn8Vv0ObFhRfiCpbpPnho/jLymVJuSKynIst7tAhKJ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFeqm4bYLMU95TL2/TTqThAxEbOs/xP4agF/hKNP++M=;
 b=CCCmRXH8DmOeblSsnlJbMD1lbdjkiEvsXL2i4AlnLMHpXeJZLYtyGih/ZHqs/od/Oc964rGbwF00jzHkaPfAlnCz6KcUYAdAuGXLRXyeqiPsFFxGFiTfbNc8XxdFGZyT4Z9+1/S+fUNQXHyAXZip+5Ymjy3AoKtpu3y7I8Ly49c=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4198.namprd03.prod.outlook.com (2603:10b6:a03:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Mon, 27 Jul
 2020 11:06:41 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:06:41 +0000
Date:   Mon, 27 Jul 2020 19:02:48 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] net: stmmac: only call pmt() during suspend/resume if
 HW enables PMT
Message-ID: <20200727190248.63068c12@xhacker.debian>
In-Reply-To: <20200727190045.36f247cc@xhacker.debian>
References: <20200727190045.36f247cc@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR01CA0012.jpnprd01.prod.outlook.com
 (2603:1096:404:a::24) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR01CA0012.jpnprd01.prod.outlook.com (2603:1096:404:a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:06:39 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49b8f3e9-2dc4-46e9-3d4a-08d8321d2421
X-MS-TrafficTypeDiagnostic: BYAPR03MB4198:
X-Microsoft-Antispam-PRVS: <BYAPR03MB41988FBCC52FAC6DD4F163ECED720@BYAPR03MB4198.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0OA4/rd7xSs/4CQaLepE/dvxWjGIXu+u2DaX4rnEnCaB/8WpXz72yLmBUcDfVZyA1t5pX93Fv0qMoOUO0TWBVvv0BYO37dQVhOV8GSyET4z9DiK32oVTLW59a5+VGez4v+fB4/MrbZEKiWUdD1ijJx4GmTO4dr7Ofzu+U3Z4WdZfodXS3keP6jhecKGNzLhyoZqE6mJ0P0fRY5wweLO48KmFk6fWiUcR4jfh8n7r2YFP1Rhzq2oVbzHCzyM0Wke7EtHFTwGiYhOUzeyN5KHX//fLWwo3ZhMVAryUTOiIks13VcMlXrhbyH2x/4IZjmW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(66946007)(66476007)(66556008)(5660300002)(6506007)(55016002)(86362001)(52116002)(9686003)(8676002)(478600001)(110136005)(7696005)(316002)(1076003)(4326008)(16526019)(8936002)(26005)(956004)(83380400001)(2906002)(6666004)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8OcaQjD2Cmfp/AdjX0fDyXI+VA5t4VfJ++ZVMisDsU0cWhQk0kj2MqrWH0vJW4jRN00OluADfmib+nfbbfROd6saFJFqP9BQi96YF/x5Sxfa9lqrjncMA8eSHb2X1pD2K92kJD3jgxKVnfCSEb6HGnQnj5zE40AuUT9DSDBsX66B1iVXTL3LqFc5hcGqHzHovZum52nuEOYZWyZMvw0lnJYhLpOSzIoi14Dz9S0IfjQxDdLbKSLjXAZ8sox1Q+145ElTAIiTbvaR1hHIFc4NjYxirVnTbSVR1DVeG+VBa/FM02730d3LzYJDiL5k+X4ernuSwYUxMND0LyTQ+RIm9pJjny/6Jo7MWqgROguMqMDs+fKi/32HEYzOB7AU1Ia94Su4yduXCh4RUwkZOdK15dsamZxjs8GH2pvsCITk/SksG9GMkqa4igTwn2NXKSSAagzLDPcNP9sG227lTwjYrt4BtlGqUNN8VkDmrfROIFc=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b8f3e9-2dc4-46e9-3d4a-08d8321d2421
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:06:41.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgtiGPSQ9036ByWYmggAPIXjKYsTH0GehSvaJqpHAYQZDfQ5LDxivITppB7QtE19oz1XTgVXjwtuTp/EmD9ihg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to prepare WOL support with phy. Compared with WOL
implementation which relies on the MAC's PMT features, in phy
supported WOL case, device_may_wakeup() may also be true, but we
should not call mac's pmt() function if HW doesn't enable PMT.

And during resume, we should call phylink_start() if PMT is disabled.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73677c3b33b6..358fd3bf9ef5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5085,7 +5085,7 @@ int stmmac_suspend(struct device *dev)
 		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
 
 	/* Enable Power down mode by programming the PMT regs */
-	if (device_may_wakeup(priv->device)) {
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
@@ -5157,7 +5157,7 @@ int stmmac_resume(struct device *dev)
 	 * this bit because it can generate problems while resuming
 	 * from another devices (e.g. serial console).
 	 */
-	if (device_may_wakeup(priv->device)) {
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
 		mutex_lock(&priv->lock);
 		stmmac_pmt(priv, priv->hw, 0);
 		mutex_unlock(&priv->lock);
@@ -5200,7 +5200,7 @@ int stmmac_resume(struct device *dev)
 
 	mutex_unlock(&priv->lock);
 
-	if (!device_may_wakeup(priv->device)) {
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
 		rtnl_lock();
 		phylink_start(priv->phylink);
 		rtnl_unlock();
-- 
2.28.0.rc0

