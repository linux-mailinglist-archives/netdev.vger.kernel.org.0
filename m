Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A369691F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjBNQSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjBNQSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:18:33 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2112.outbound.protection.outlook.com [40.107.22.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45027ED8;
        Tue, 14 Feb 2023 08:18:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqRPgyDGWw1yozyQKoiOcEG+xuuY+rW9ORYC+zhwJ79dEW57t/lmWrU1S+wtrxB2K6UTHUWJ54cKRMnWyT3RHPVr0W8OFamC+mnhtPGrkDswKTFTAN7sU2kEsANDaeidxS7fkL6/6SMwCYUKDenzqkafhTig2mVTcgVfQ8hqZ5UpyH7XW/v2d4krCEQ98XY6s9/e4h+SNxUvtXyHm6pZinJ5aGD7ByXEeIdYzF/Em1fxVOwvgFn41ZcuyPEWvLuSTUpEm4/9u4cwDse7eUq09dA0QU2RuoP4Vl9efmHsw2RQrRpwvqAwrb9X+l+zBFTiKnlj/P8l2TJly1BGjWM5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4kumhiStEu6LLlD0QyS45kJikls69CkihJ3IuvsdLg=;
 b=Ky7zgMSaX1pf5RSfhfSY0GtuicrXbsEwA6ecsi2Iv6E92sK9f35sfXyv5xkmnAqb2sQeS4e2qhEVzGDi3+LH8ywhynEdegtpCWqiIz8LAOhWOZf7qIgGRkD2QJSyebMdGZzYlhKxF8vnlyABI0ZAbQPWh66cxAVMzxNWl85+LwxGiQxiNbdUYlKPZASTKioCFSoNMADcCGUayHecUCMVDQ6EnvF7FDKI0RYaDzrRgy6ZXzLM65Kpc5asWDLFU08hD9x2k7+o3j+GqREZAL9S1flCd/iVzGhtwa9DA3xytJwbfHJqPb+sdLGE+08WsnZpMhfpEKJJnAp0vmahgz5IYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4kumhiStEu6LLlD0QyS45kJikls69CkihJ3IuvsdLg=;
 b=Ks9+aPvjyYQEzidn4vMN52CV13Qdk/CYbMmYPCLq4ODQd2q2RYJMk1XMMb1V/A2H89vIl8n2aMlgCZ3Bc0gFmgThHxddqsBPZC6Fv6nWIKUaG3KSScHBl9wXfFR68DsT0A8pQIxreiLo5H4V14/acQB7N4T9vZrYH6UgcxPeimY=
Received: from ZR2P278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:50::11)
 by AS8PR03MB6807.eurprd03.prod.outlook.com (2603:10a6:20b:23f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 16:18:28 +0000
Received: from VI1EUR06FT067.eop-eur06.prod.protection.outlook.com
 (2603:10a6:910:50:cafe::41) by ZR2P278CA0008.outlook.office365.com
 (2603:10a6:910:50::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 16:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT067.mail.protection.outlook.com (10.13.6.78) with Microsoft SMTP
 Server id 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 16:18:27
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id A5C967C1635;
        Tue, 14 Feb 2023 17:18:27 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 9E49B2E0125; Tue, 14 Feb 2023 17:18:27 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (2)
Date:   Tue, 14 Feb 2023 17:18:24 +0100
Message-Id: <20230214161824.1245097-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
References: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT067:EE_|AS8PR03MB6807:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: e08eed1f-02dd-4116-ee49-08db0ea71b24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZGvQvlToyELUZN+f+yNN9sEvQh5kyiAnZGbo9PtkhUHsL9bON8K+w1EaNDkijTKIV0jqh77TP76iNOEncL/WJtH0v+1ndttUHjbr5V0Z7MK649XRN7gjYIm/nJV2Narav5TVpo1/HOqLAe0nOBaYYghYUd00M+rQWKVgIku/sZgywE/RoOMzKGJaSXXDxc5r+iUhGPObhldgKBElxe7B8mkrW7Tdo/tmsQ8Dv2HxB3MFnRFbHvJ6fw0m/yKlwtq9Ge5iVKeLbZ0SYhOEarpcsFrTQkyfHTbfSxuzgheZVHia0wTyLhRGisbhl+XtrBUF+PWlozj2WLcectretneLnRsEyGK/4VkUJb2AX1HglUSdT/L5JRsV/iLCvs+gJDeK17TeO0FU0WhRUCdmcnfJe6cmqmkfpBQ9HCman35wPU+P6cxX5AtPAPMUqLldF7uvc0xon8cSgpwd5lafyJzoMWvIxeLib/DuJOHp47mfBD0KDer7UuR0nDo0vkBn0ZIhRoL7UfbVjTreaLio/N7j0cci2c7WtgS+fEQQ+ryLOifmBzj3UW2yS3H1DAc8LnDYW+pWmzi9em/dnuNqAl7ZhVhVDGEEz7uggYjkBOr2fCTUiObvWxuUEba8kaYgUNFW3kdmP4spXMh0WOOPQDYVZr8ZU7C7FI4dT3w5Wb4Kb0o=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(376002)(396003)(136003)(451199018)(46966006)(36840700001)(2906002)(70586007)(336012)(42186006)(41300700001)(83380400001)(8936002)(54906003)(8676002)(5660300002)(478600001)(6666004)(4326008)(186003)(26005)(966005)(2616005)(47076005)(110136005)(70206006)(6266002)(356005)(40480700001)(36756003)(316002)(1076003)(86362001)(44832011)(36860700001)(81166007)(82310400005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:18:27.9852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e08eed1f-02dd-4116-ee49-08db0ea71b24
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT067.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6807
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Started a rework initiated by Vincents remarks "You should not report
the greatest of txerr and rxerr but the one which actually increased."
[1] and "As far as I understand, those flags should be set only when
the threshold is reached" [2] .

Therefore make use of can_change_state() to (among others) set the
flags CAN_ERR_CRTL_[RT]X_WARNING and CAN_ERR_CRTL_[RT]X_PASSIVE,
maintain CAN statistic counters for error_warning, error_passive and
bus_off.

Relocate testing alloc_can_err_skb() for NULL to the end of
esd_usb_rx_event(), to have things like can_bus_off(),
can_change_state() working even in out of memory conditions.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
---
 drivers/net/can/usb/esd_usb.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 5e182fadd875..578b25f873e5 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -239,41 +239,42 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
-		if (skb == NULL) {
-			stats->rx_dropped++;
-			return;
-		}
 
 		if (state != priv->old_state) {
+			enum can_state tx_state, rx_state;
+			enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
+
 			priv->old_state = state;
 
 			switch (state & ESD_BUSSTATE_MASK) {
 			case ESD_BUSSTATE_BUSOFF:
-				priv->can.state = CAN_STATE_BUS_OFF;
-				cf->can_id |= CAN_ERR_BUSOFF;
-				priv->can.can_stats.bus_off++;
+				new_state = CAN_STATE_BUS_OFF;
 				can_bus_off(priv->netdev);
 				break;
 			case ESD_BUSSTATE_WARN:
-				priv->can.state = CAN_STATE_ERROR_WARNING;
-				priv->can.can_stats.error_warning++;
+				new_state = CAN_STATE_ERROR_WARNING;
 				break;
 			case ESD_BUSSTATE_ERRPASSIVE:
-				priv->can.state = CAN_STATE_ERROR_PASSIVE;
-				priv->can.can_stats.error_passive++;
+				new_state = CAN_STATE_ERROR_PASSIVE;
 				break;
 			default:
-				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				new_state = CAN_STATE_ERROR_ACTIVE;
 				txerr = 0;
 				rxerr = 0;
 				break;
 			}
-		} else {
+
+			if (new_state != priv->can.state) {
+				tx_state = (txerr >= rxerr) ? new_state : 0;
+				rx_state = (txerr <= rxerr) ? new_state : 0;
+				can_change_state(priv->netdev, cf,
+						 tx_state, rx_state);
+			}
+		} else if (skb) {
 			priv->can.can_stats.bus_error++;
 			stats->rx_errors++;
 
-			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR |
-				      CAN_ERR_CNT;
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 			switch (ecc & SJA1000_ECC_MASK) {
 			case SJA1000_ECC_BIT:
@@ -295,21 +296,20 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			/* Bit stream position in CAN frame as the error was detected */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
-
-			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				cf->data[1] = (txerr > rxerr) ?
-					CAN_ERR_CRTL_TX_PASSIVE :
-					CAN_ERR_CRTL_RX_PASSIVE;
-			}
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
 		}
 
 		priv->bec.txerr = txerr;
 		priv->bec.rxerr = rxerr;
 
-		netif_rx(skb);
+		if (skb) {
+			cf->can_id |= CAN_ERR_CNT;
+			cf->data[6] = txerr;
+			cf->data[7] = rxerr;
+
+			netif_rx(skb);
+		} else {
+			stats->rx_dropped++;
+		}
 	}
 }
 
-- 
2.25.1

