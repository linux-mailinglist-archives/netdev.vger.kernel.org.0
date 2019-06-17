Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F8E477B2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfFQBdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:33:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34270 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFQBdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 21:33:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so4735080pfc.1
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 18:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SJXRVjjq04y3EgDt1waIag/MD9emkmPsTPeOWo4dcAY=;
        b=fUKkEd7LK1qEC80S0130iDIn5lpqB42ZJuTpXl+1c/JZs+8Q/21+lYO9nTbM81JY9w
         j6NKYAVNE0S6rsNkmwlRxFynUnrAJqOgtAb1zygKPctW9ke7iFv2q/w/m2VNg6WzD19I
         H+00I57O4qr1Ex/Es2KOK1qJvCMNxFeOaPi4Vf9QgoWalJm+mh0hz0BTcOEl2/yFq43x
         6ATvagD/2eBW+3kqCoHCkAH6E5ItT17cVa+cw1OkMd1SALiA7oDlxlsJDnXwA0SNMa1t
         c9nVED1HZern/i49Wlmm/6TiLS9IflaAqjo0BOR0pAFF0ZLqGROlnyMtX/bNeUSoC0wf
         ILAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SJXRVjjq04y3EgDt1waIag/MD9emkmPsTPeOWo4dcAY=;
        b=sXA3x3l/h27dDGCzfbrQJ5PQP0pVk8xItZo9LZClPZHYOgdH7475zdwsJBgb+qnbl1
         euXtjg9OeFqis0+BimMEbPtn+LaNIkO9LZ3Bf7VTpcz52xrtvdcB2P91GVhuluJbveTj
         33IgojtDxYiAeBeMG3AGC3vEzZTXwNoqM2JaCuM0uMBMi0VHkJo+hVCv6vINYDqVVgI9
         ZwYQ5P9OJtXE231FsXqCU19uVK96SyXoYhZz9RW8gTH7/2wjCOZyTi5nq2fJ92z5VEi/
         kJqXXgvcXUj1o9l2r9VBQZ9annQEsKjhkSjSFB4H2IWLcKb5T65QJXO7JFaBlX67Iv2Q
         j87A==
X-Gm-Message-State: APjAAAW3lKTw4focN0ZUkU0EPBe2Q2acZPXBDy0saIAYq6q57PN+ajq4
        MaB5QoX10hlPjfWl6Esap5UZ1K5oxxMjCw==
X-Google-Smtp-Source: APXvYqxB6LdMZ5DfoEfbI+CZEENaGzia2PDWYRdwmAu0SxIR22uQNZoDK9LwA3YkirviJC0msPvmkA==
X-Received: by 2002:aa7:9212:: with SMTP id 18mr72387980pfo.120.1560735217483;
        Sun, 16 Jun 2019 18:33:37 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y185sm9838306pfy.110.2019.06.16.18.33.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 18:33:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] team: add ethtool get_link_ksettings
Date:   Mon, 17 Jun 2019 09:32:55 +0800
Message-Id: <20190617013255.27324-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190527033110.9861-1-liuhangbin@gmail.com>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like bond, add ethtool get_link_ksettings to show the total speed.

v2: no update, just repost.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/team/team.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b48006e7fa2f..f3422f85f604 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2054,9 +2054,34 @@ static void team_ethtool_get_drvinfo(struct net_device *dev,
 	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
 }
 
+static int team_ethtool_get_link_ksettings(struct net_device *dev,
+					   struct ethtool_link_ksettings *cmd)
+{
+	struct team *team= netdev_priv(dev);
+	unsigned long speed = 0;
+	struct team_port *port;
+
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+	cmd->base.port = PORT_OTHER;
+
+	list_for_each_entry(port, &team->port_list, list) {
+		if (team_port_txable(port)) {
+			if (port->state.speed != SPEED_UNKNOWN)
+				speed += port->state.speed;
+			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
+			    port->state.duplex != DUPLEX_UNKNOWN)
+				cmd->base.duplex = port->state.duplex;
+		}
+	}
+	cmd->base.speed = speed ? : SPEED_UNKNOWN;
+
+	return 0;
+}
+
 static const struct ethtool_ops team_ethtool_ops = {
 	.get_drvinfo		= team_ethtool_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= team_ethtool_get_link_ksettings,
 };
 
 /***********************
-- 
2.19.2

