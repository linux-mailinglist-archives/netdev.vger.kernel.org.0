Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F8023A00F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHCHIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:08:44 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:25506
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgHCHIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:08:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7ba+hc/hPKOXTg5YtH9gr4M7NWOsB7qQZT9TQYpz1APn9XR4xr6QOML2RtsQugVjXu4Tk6rdbp5d6n7MV6T9oNN0tin5L3dcRM1PSWxDuxiNjoYHCvC9GqSlULRal3NGctAzbnCam1mmgaUPzHc8X+MAfBpVy/NNhUbSaQ55IXBzxCzo7DCE44n5Hw6j1tiss1DIVxCcCO0Jv9NL+A/XEXiwtOKXZ8o51CR8dWIENmrlSz9mYYBLZMSD7PgZ7kHpxSUet9B156FwPclSOpEPzWgQlTjvTzskvTHxSKLHCAY+IeG4cW2SAqvjfOk4a6ptzRJGvlxltsnFj//f2w7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FKqNu/Ojl5Pg1nVU7wPMXNjc2QV8IFxQ/zjRMykop4=;
 b=Vm/VyddnVFKgCVoA79dsKFZx1TrjIWcKCcdyOY1wUl1O+ZxNOtkdBr1ZiTMOHA36fsjm1dDaWbBbuADPNWyBskuMggPUrfAligA7FAcaO9tg+h3keDxXXAVXyGPkyu5lLYKjfp/VqLXBKedYyCPkRfbnnBrunwnVQi3FvF+OZnlZInfBvn+IOqm/mNA0l32VkrBzD4keVrVAItTPrKE/o1TCv6GkTbe/VOm1td1+d1AOsHOoUmvXHTKeyu6Hw6jz7WkWxATn2IiAcT99M8vojfUMiMD4trBpS3GzIEjVAx1U4x3qX+Dq9kGOS5G3QmztQono7xeF1fcsUr38JjSBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FKqNu/Ojl5Pg1nVU7wPMXNjc2QV8IFxQ/zjRMykop4=;
 b=kwxcYa7gNSuSIkxHl2tKvjI9yXAZI3iBGlEdzrgzMESNT+wuJXya4M9Ov4HFkkmvGBoApYs7x3keRNEcGFyO4IbnLzFpuwBrotHd9JU0dewWO/0hV3UQnHCxXS2BtgeaHo1Hk6BBU2oiC+7WgxDaHWkGdSujfEH+NvNXSYcLPAE=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB4356.eurprd04.prod.outlook.com (2603:10a6:208:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 07:08:04 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:08:04 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v3 3/5] fsl/fman: fix unreachable code
Date:   Mon,  3 Aug 2020 10:07:32 +0300
Message-Id: <1596438454-4895-4-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
References: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 07:08:03 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ed018de-12da-4cde-7828-08d8377bf70e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB43567AA24B53BB9527E62FFAFB4D0@AM0PR04MB4356.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7Esdnz835KVerT3GzroYzeu+nvKqyOR/08jyk2zazF/Q4UhzEOUGLgBMfOmVLP1zQ6BXPSnBRuf2k873fdtf21y0eIUeMJyVMGgwsXGw+XEuGCixvwKdUo9vNHmgXbqXP/M/0RvqCDdx70qiSBNJNo2ryh9XECqDy80KM3IyN+cq4LBtQn1mvysApZn1+usxVXD25Eyu/M+j3iNj96qXO9HEFF+3wRFS4G6VGSywHG9vY6vq22HsdBW8jCEL3umcUZyKwzTtHAMeZZAdmyTxv4jr4DnHOOzFOylfd94pVhdB5eBcuZmAj3+3632AMmFlKe+siq9rbc58rafYxjURA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(956004)(6506007)(52116002)(83380400001)(6512007)(2616005)(316002)(36756003)(66946007)(2906002)(86362001)(6666004)(478600001)(66476007)(66556008)(3450700001)(6486002)(26005)(4326008)(4744005)(8936002)(5660300002)(186003)(44832011)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QmMatqxVXOM6NQSdSza24PXmiIILafEtuIUVyv3ja7gFgVYQsoub2nNgIUAJL0ceW8JA0K+QBxjjdbqbgJ+h3xjKDXxbhA+I6LmYvCjUiHFiAIb+OMWKe58R3z05f/vO53ciDTIPE2eP/EASlkBxKZKXNv0okP9e30zMepKJ1BnfIe4loO8C9dp4pmjIh8ANsDeOGhBmLDFgf8GIUDbe6lXvL0puHtDS65mJROHh+amur5c9Rxd0YC9Bzzv+CkPEHSIBwD8498cRCts1r1TM6HztnHID0kgvoFq5CD4IU9pUwB03/TWPlO98K90O3PanG04I0vw8ZUMgeCXYEqi3jqnX2I7pcuvyWQ/BHXrE/1aNd+DZcDvRnl45NcZn63RLovL7ZrJPBEAJhtTIY9U5JZysZuSFya8Eo0lATY54BVsorss2dI5m8d84phnGYYMBNSyIv3ztW/X4Tzb5sEpwVhwzzfHTMENd+GNtTnVmzOjDeHi9Wv1vfzyOa9tAj/UvsNtc2RmL4YBAqSY7RRP0gY2NZXaI9ViaEaG6T3jj9oM7y/bTlSJMiLfG5iQ3Lnq9v4EYlLAB7xzyGXBxGJrApXslT7rgaXzcSHxP75Q9+EzTVqH8MM3MQkTpLFrkr747hNS+MjutA70t9TzfgVUaNg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed018de-12da-4cde-7828-08d8377bf70e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:08:03.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVz6tZyNovxtqFNeZU39GOIoRN53d8JLdhBE+oPMgp2lK30YrkeLo4W2tav0BS9nHdW/7p2xjuDDK90GSHnQHjIeyhf9+GwVj93OcpcFdQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter 'priority' is incorrectly forced to zero which ultimately
induces logically dead code in the subsequent lines.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index a5500ed..bb02b37 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -852,7 +852,6 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~CMD_CFG_PFC_MODE;
-	priority = 0;
 
 	iowrite32be(tmp, &regs->command_config);
 
-- 
1.9.1

