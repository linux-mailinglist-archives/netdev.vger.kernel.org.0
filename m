Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E5E122E2D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfLQOKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:10:33 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:41832 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726164AbfLQOKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:10:33 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2DB43C00A9;
        Tue, 17 Dec 2019 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576591832; bh=LBZeXNiQjocW7iFX0oDk37SVBCy0Mantzjy5fIt4JG4=;
        h=From:To:Cc:Subject:Date:From;
        b=KaLpnFqWeyGAZpy2utSMp3HriO9uxXUysfANlj9TvnGu29imarA1j+eVJ2YBQf5fu
         ZWWK7QC15WmpJt/zoe77OYerYcKwjd/kTJQCL5yb68oSG60U8NjYOHyvtyhZz9PPZk
         nFIl6l2a0ULaI9U/8BzAnajWoe57JhGChAtdsrfSpTftY7WY2zYvWJiep0Fw3ppgG3
         693ZWUN/g9tWzUTfDR/UXSpQgfvDpPnEVKL+KtGLBhr8Itqc5z8hnJHm/SaElugXdX
         kEbLMGMf2TfKN6CDpjXH0E1YI++A2NFTh0QITWntN0WTI9RvzkAlbtw4MLwrEkQNNE
         UV0FU/wi364HQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A9710A0075;
        Tue, 17 Dec 2019 14:10:30 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next] taprio: Add support for the SetAndHold and SetAndRelease commands
Date:   Tue, 17 Dec 2019 15:10:24 +0100
Message-Id: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although this is already in kernel, currently the tool does not support
them. We need these commands for full TSN features which are currently
supported in Synopsys IPs such as QoS and XGMAC3.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
---
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tc/q_taprio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index b9954436b0f9..62ff860e80ae 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -99,6 +99,10 @@ static const char *entry_cmd_to_str(__u8 cmd)
 	switch (cmd) {
 	case TC_TAPRIO_CMD_SET_GATES:
 		return "S";
+	case TC_TAPRIO_CMD_SET_AND_HOLD:
+		return "H";
+	case TC_TAPRIO_CMD_SET_AND_RELEASE:
+		return "R";
 	default:
 		return "Invalid";
 	}
@@ -108,6 +112,10 @@ static int str_to_entry_cmd(const char *str)
 {
 	if (strcmp(str, "S") == 0)
 		return TC_TAPRIO_CMD_SET_GATES;
+	if (strcmp(str, "H") == 0)
+		return TC_TAPRIO_CMD_SET_AND_HOLD;
+	if (strcmp(str, "R") == 0)
+		return TC_TAPRIO_CMD_SET_AND_RELEASE;
 
 	return -1;
 }
-- 
2.7.4

