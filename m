Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5172AD5B
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 05:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfE0Db3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 23:31:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45095 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfE0Db3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 23:31:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id w34so3609387pga.12
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 20:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLQLjZBBr9E+iC1akbTnKerl26PcXwxOZgkT/wCoTFU=;
        b=FAa2oMy85Mqe8/UhAAmClH3EXW8ObIRSvPXB9ecyRKXHgZeZhJcCWssywvK0LV2uXe
         YlCILHl13WH6DRZb5g1azarSvrMAIeL4gu7oc7gyTtPd53xhVjZL43miIEysNhsajOtO
         RYyUmn2Ehmn6qw7HcYDgwt1L647cq+OrnzaAXUEGHujLojaKh5Z/s7jVK7TYuRkA8EbK
         RCFq8WahWL67Wx3q8pH+k++wSb5rmENhC3l3Y+LN0XDnVFiFLPA1KwpSSTbsRqC12YaY
         ex90jpBZ1v9FBKq4MP+d5XDFKj6YKujlx+VV2gkPa2doa8fRJfN5dUgNFClaAJedbMiw
         k0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLQLjZBBr9E+iC1akbTnKerl26PcXwxOZgkT/wCoTFU=;
        b=sXD6A7d/22Ve8lkHmKvLvLqoJ7JgK0hgXFl7PLPCHi7NCR5llXTs3z9sNJHbWkyth2
         OvP1NPY/i+6ZC1qooTWgi3LduUiizrj2XmDJ0S6svqD1Pn68EVHlrdn1x7QxA0+1lyG3
         rdyJUfWZU8RYhwvtCM/mmuG/e26txQgLVoE7bBcGvmnvLYIL4wzdZBrnYZceyPNSAGpc
         b1A4wk2lAAO0+qjyGQk4LkMjaxFkh5E0vxD33UcdaDSCL8wlPc1N6+yof6x3KsjdMtUF
         BrngRMVpoPiv1cRkVU52GwIPUeITug7xjTBqxDQlxvWPdJC2NNw9l6DHQmkSHUeBERxr
         OTMA==
X-Gm-Message-State: APjAAAWWjNQ3KRS0YSeeHnyZEjJOgrx0MHeTy62cgFQ9vqpj2otMDx4T
        GhsKWJxA4KGkrqpi66uC1pP7Vs+npwU=
X-Google-Smtp-Source: APXvYqxe+rHBwk/gqJlcHnQttjA3T6Puzs6KTxk6/XwpJ/DOp70jS4W8nsOeBzGD0N/VaH9JDnBSyQ==
X-Received: by 2002:a63:4754:: with SMTP id w20mr35507917pgk.31.1558927888697;
        Sun, 26 May 2019 20:31:28 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 140sm15514058pfw.123.2019.05.26.20.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 26 May 2019 20:31:28 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] team: add ethtool get_link_ksettings
Date:   Mon, 27 May 2019 11:31:10 +0800
Message-Id: <20190527033110.9861-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like bond, add ethtool get_link_ksettings to show the total speed.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/team/team.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 2106045b3e16..5e892ee4c006 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2058,9 +2058,34 @@ static void team_ethtool_get_drvinfo(struct net_device *dev,
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

