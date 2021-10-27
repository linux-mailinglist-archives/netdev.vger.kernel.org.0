Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9CF43D05C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhJ0SOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:14:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42006 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbhJ0SOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:14:31 -0400
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635358325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sksxAN/TeLaU/4oBvYXxD0Uum9QmxQgfw3tjQfqAAww=;
        b=NVNF95qfi9cwSLOJq5T63Vx8lvK8Xrjq6MEhjCKKoR7q/1+HzabRIr3eq2Qjt4PBeIP862
        SABS5GyKrrNasMedqPR5qKBCSh+CA1ckP19mU3mnmIqttJq3zNJQcE2Dtln1QTzjkq7NG/
        0xsJ323TYdzQdlj69M5qELvbmRMI53DFWVOWiK/JH0i0QnvzFI+0fP14zVjJOD86kMUwRK
        naWgaMl01yuLOSpZEToGR23kqaFt3fTUNfo/K/jfb5cK9k3RhPFXWzbMlSwCPFiHciZmdj
        u+zlz88Psk1cXPkaVvDPrPEdKDfgcMzQ7gvtECfFvOxFYynGCXVvpIx1SfDNGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635358325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sksxAN/TeLaU/4oBvYXxD0Uum9QmxQgfw3tjQfqAAww=;
        b=FpyaimQqwj4CwNgWft/1d8MwCFZPWE5Exe+LwM6s4E/gJG4dvmq4H/dROtywhFh4j6gSX9
        vMiVZOQnM9YfYWAg==
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Bastian Germann <bage@linutronix.de>
Subject: [PATCH ethtool 1/2] netlink: settings: Correct duplicate condition
Date:   Wed, 27 Oct 2021 20:11:39 +0200
Message-Id: <20211027181140.46971-2-bage@linutronix.de>
In-Reply-To: <20211027181140.46971-1-bage@linutronix.de>
References: <20211027181140.46971-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

tb's fields ETHTOOL_A_LINKINFO_TP_MDIX and ETHTOOL_A_LINKINFO_TP_MDIX_CTRL
are used in this case. The condition is duplicate for the former. Fix that.

Signed-off-by: Bastian Germann <bage@linutronix.de>
---
 netlink/settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 6d10a07..c4f5d61 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -560,7 +560,7 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		print_enum(names_transceiver, ARRAY_SIZE(names_transceiver),
 			   val, "Transceiver");
 	}
-	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX] &&
+	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL] &&
 	    port == PORT_TP) {
 		uint8_t mdix = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX]);
 		uint8_t mdix_ctrl =
-- 
2.30.2

