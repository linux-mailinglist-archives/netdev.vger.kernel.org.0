Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF426471091
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhLKCHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345757AbhLKCGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:20 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC48C0617A2;
        Fri, 10 Dec 2021 18:02:33 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y13so34776693edd.13;
        Fri, 10 Dec 2021 18:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jpcobtTbBZ1w887AMWL3/EJGu3y4OL0zdgkB+Vu4530=;
        b=GVLidNvstcOFcXce1MeoCrlsHcR30MahiQS0EDAtDs3XpSPZOUWN/17qHPCX54MpCh
         glJ7FROHD5OEHIvu6BOrQQk9VHQ8IdcSrDaJG2MkP6BGHxq1HapqgBvALi3K9y06m0lh
         gFuhvhEJDXvtvYEe9ky/zSQ20mVx+MHTcqAFzUr5ROgfWGIw0XDSRZisok443NijBfDE
         J1CCtRUUoyVhFEbjYIepjy7rFgxbpwP7YutUnyyQ7ipybLsj0rnHqf+F9xLCxDhvtQMw
         AUiw2loa8Tp3WNYf8ID90XttreOyBLf8yCxLIpnEbf+wpZKg/uQu3fbjE4u42HX4M+co
         brXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jpcobtTbBZ1w887AMWL3/EJGu3y4OL0zdgkB+Vu4530=;
        b=1iKZtUzO9656R+3U37T6eOsGBig3MYe8uBFHi9l3NS1k4fgfNzgdb2wmNrYozvn7dX
         vaZt66UT4dE4xYVKxr4OjOVuCKqM4GFBaaqOKljl5p8BPt9unDCmJNz+T00AZg7PgunJ
         txgW8UePPKmYS1zQO15DQvLqDaoBiXWh02KTXf1gnxDSt3R6QHSRuFDhBFcg06vMySPN
         +Z3n23JGYW4VKr4TSzUS1GFCqQ/NdoTj+ga0LFKAA/q14DyfMhpoFE4skpTW8KiDL+R4
         KbBYyD5zKql/A9n8bsJ6jD0jcMZJiEMm2ZTjpCzESepns7b12nKTHCzkhtVWZEkDI477
         300g==
X-Gm-Message-State: AOAM5337MPVKaQJ0JFPiB0XWVepRzZOlS0swaoi5K8tXUq9hk3GbjdPD
        9Eu/7UflGi7YhdHMJLlSUn0=
X-Google-Smtp-Source: ABdhPJx4rvGrwOx7ayqzXup2KfFTclQPuHSJ8dd9TxM3d5P/QnJK2VNsLITyuFIxjcy0CANWpe0m5Q==
X-Received: by 2002:a17:907:9707:: with SMTP id jg7mr27089113ejc.533.1639188151714;
        Fri, 10 Dec 2021 18:02:31 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:31 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 10/14] net: dsa: qca8k: add tracking state of master port
Date:   Sat, 11 Dec 2021 03:01:45 +0100
Message-Id: <20211211020155.10114-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO/MIB Ethernet require the master port and the tagger availabale to
correctly work. Use the new api master_state_change to track when master
is operational or not and set a bool in qca8k_priv.
This bool will later be used by mdio read/write and mib request to
correctly use the working function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 13 +++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 039694518788..905fae26e05b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2383,6 +2383,18 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
 
+static void
+qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
+		    bool operational)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	if (operational)
+		priv->master_oper = true;
+	else
+		priv->master_oper = false;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2418,6 +2430,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
+	.master_state_change	= qca8k_master_change,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ab4a417b25a9..fb98536bf3e8 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -342,6 +342,7 @@ struct qca8k_priv {
 	u8 mirror_rx;
 	u8 mirror_tx;
 	u8 lag_hash_mode;
+	bool master_oper; /* Track if mdio/mib Ethernet is available */
 	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
-- 
2.32.0

