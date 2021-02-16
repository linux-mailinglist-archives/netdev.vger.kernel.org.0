Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E831C601
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 05:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhBPEbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 23:31:22 -0500
Received: from m12-16.163.com ([220.181.12.16]:45325 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhBPEbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 23:31:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=hboCNnAqFehWE69dM1
        PgkN2wYQNA1HFncAXe/EplEqA=; b=iV3Fb/BsDarUdAE2B5f16hf6gTSOAzpPGJ
        hkXFnHgga4ZMusUHHO5avxfPw/2KdX1T2goBpvBa4HYeVpg+FR/ZIbILP+7CorEI
        VI6ysFBeBkgrLXilS3HbC2UtK3xUGY/fMS1uStiExbw6uDyHR08Ak+CHkG3/vk9n
        hroNTsINw=
Received: from localhost.localdomain (unknown [125.70.193.99])
        by smtp12 (Coremail) with SMTP id EMCowACHIUkjSitgp1XkcA--.19808S2;
        Tue, 16 Feb 2021 12:29:27 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     pizza@shaftnet.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Lin <chen.lin5@zte.com.cn>
Subject: [PATCH] cw1200: Remove unused function pointer typedef wsm_*
Date:   Tue, 16 Feb 2021 12:30:33 +0800
Message-Id: <1613449833-4910-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: EMCowACHIUkjSitgp1XkcA--.19808S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw15GryxWr1ruw4DtF4UCFg_yoW8Cw15pF
        Z8Gay7KrWruFn0934UJr4Fv39xtanag3WDCrWDCw1S9rn7twn5GryUtw13JryYyayfWFya
        yrn0yrWxAr1jkrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jfL05UUUUU=
X-Originating-IP: [125.70.193.99]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBzgc7nlQHLpPThQAAsU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Lin <chen.lin5@zte.com.cn>

Remove the 'wsm_*' typedef as it is not used.

Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
---
 drivers/net/wireless/st/cw1200/wsm.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/wsm.h b/drivers/net/wireless/st/cw1200/wsm.h
index 1ffa479..89fdc91 100644
--- a/drivers/net/wireless/st/cw1200/wsm.h
+++ b/drivers/net/wireless/st/cw1200/wsm.h
@@ -785,8 +785,6 @@ struct wsm_tx_confirm {
 };
 
 /* 3.15 */
-typedef void (*wsm_tx_confirm_cb) (struct cw1200_common *priv,
-				   struct wsm_tx_confirm *arg);
 
 /* Note that ideology of wsm_tx struct is different against the rest of
  * WSM API. wsm_hdr is /not/ a caller-adapted struct to be used as an input
@@ -862,9 +860,6 @@ struct wsm_rx {
 /* = sizeof(generic hi hdr) + sizeof(wsm hdr) */
 #define WSM_RX_EXTRA_HEADROOM (16)
 
-typedef void (*wsm_rx_cb) (struct cw1200_common *priv, struct wsm_rx *arg,
-			   struct sk_buff **skb_p);
-
 /* 3.17 */
 struct wsm_event {
 	/* WSM_STATUS_... */
@@ -1180,8 +1175,6 @@ struct wsm_switch_channel {
 int wsm_switch_channel(struct cw1200_common *priv,
 		       const struct wsm_switch_channel *arg);
 
-typedef void (*wsm_channel_switch_cb) (struct cw1200_common *priv);
-
 #define WSM_START_REQ_ID 0x0017
 #define WSM_START_RESP_ID 0x0417
 
@@ -1240,8 +1233,6 @@ int wsm_beacon_transmit(struct cw1200_common *priv,
 
 int wsm_stop_find(struct cw1200_common *priv);
 
-typedef void (*wsm_find_complete_cb) (struct cw1200_common *priv, u32 status);
-
 struct wsm_suspend_resume {
 	/* See 3.52 */
 	/* Link ID */
@@ -1256,9 +1247,6 @@ struct wsm_suspend_resume {
 	/* [out] */ int queue;
 };
 
-typedef void (*wsm_suspend_resume_cb) (struct cw1200_common *priv,
-				       struct wsm_suspend_resume *arg);
-
 /* 3.54 Update-IE request. */
 struct wsm_update_ie {
 	/* WSM_UPDATE_IE_... */
-- 
1.7.9.5


