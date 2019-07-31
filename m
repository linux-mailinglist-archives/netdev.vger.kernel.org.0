Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874D87BB93
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfGaIZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:25:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39246 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbfGaIZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:25:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so48614442wmc.4;
        Wed, 31 Jul 2019 01:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ZfG99jt/t5V7wl0F2Ht1lawW89yEpPaThmMRQPolQU=;
        b=sTT0o/juQxuXPrxRAqmBOKAOyVCdNwOzqlg3KxbcUVCHZKzRXSebC5RF+bWOpQmZrD
         49V6d46RtblwK0CmpZQkypel9/Y9bfjU31oKzXUuev8eBggTfpj9X7cww4gp28G40q18
         GpSePeqF+41m/8rBkAHOCzKHC/ssW7iP/kXMMU3XPNmWpP46QMYhdlTKba0G2uCWVjxh
         Wmor7w3zx1iwoLn3MBRQ6abKicSZqHFaAaEMz7N2fftqqu6IsthfWGTgRMQKPsvsStsK
         tT14oTuIUN2XK0nXCu/pWrcG1qMcmEjaPM4dBOYQayHiZ8629eu9Lx/zCNqvUV6SdapX
         MtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ZfG99jt/t5V7wl0F2Ht1lawW89yEpPaThmMRQPolQU=;
        b=UEVdGXqAV9O5V4tLPRwf7o5n5yAVS5tGv7VGPXkyosXpRIdyp5Zb8GjnBOPKOPSAzE
         CDPDcfPrsEKAXZNum/B+XWOHKvtr9/seciYfAeX2Q1yRCqrWrqj6tKSEz7PRtlxmPXhU
         JHTR2JcfkLXn8poicAZx48UZY+Gan+/MHV8SqIAcT0mRQn2vWk0Qdb8AXlXUaTDsZRF7
         WupHFJwVdmWZE0VBDw7H7axzczZg4KDd/xWmBr1Zc62oWfT7mBYn6rJJUSx+GMoQlSql
         HMc92ObAX166uQq4/qwWLyOEOHaTp3kXuxI/dbcv9dbWnDrHwGprE4MoGVGbv0xglO9M
         NQgg==
X-Gm-Message-State: APjAAAVB9gIi68yaNNWCo3mxs5bdckUdOJR1Ha9Nyj/IWwwpeCLlEfLy
        E+xPXGHSaJKJNi654Db246FrriosPa0=
X-Google-Smtp-Source: APXvYqzd75gENVvvZ7QVZWbZTGevpgDT7dqnW9/ngKFsea0wMH4doB9TP6gfwoTUfd1hcSm9KpCHlA==
X-Received: by 2002:a1c:44d7:: with SMTP id r206mr112593482wma.164.1564561547891;
        Wed, 31 Jul 2019 01:25:47 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c78sm93223959wmd.16.2019.07.31.01.25.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 01:25:47 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 4/6] net: dsa: mv88e6xxx: setup message port is not supported in the 6250 familiy
Date:   Wed, 31 Jul 2019 10:23:49 +0200
Message-Id: <20190731082351.3157-5-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731082351.3157-1-h.feurstein@gmail.com>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV88E6250 family doesn't support the MV88E6XXX_PORT_CTL1_MESSAGE_PORT
bit.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 34 +++++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9fdcc21f0858..75cfa1f2060b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2252,9 +2252,11 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
-	err = mv88e6xxx_setup_message_port(chip, port);
-	if (err)
-		return err;
+	if (chip->info->ops->port_setup_message_port) {
+		err = chip->info->ops->port_setup_message_port(chip, port);
+		if (err)
+			return err;
+	}
 
 	/* Port based VLAN map: give each port the same default address
 	 * database, and allow bidirectional communication between the
@@ -2805,6 +2807,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -2839,6 +2842,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_link_state = mv88e6185_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -2875,6 +2879,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -2909,6 +2914,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -2946,6 +2952,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.port_set_pause = mv88e6185_port_set_pause,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -2990,6 +2997,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3030,6 +3038,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3063,6 +3072,7 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3104,6 +3114,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3145,6 +3156,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3187,6 +3199,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3228,6 +3241,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3266,6 +3280,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.port_set_pause = mv88e6185_port_set_pause,
 	.port_link_state = mv88e6185_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3308,6 +3323,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3353,6 +3369,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3398,6 +3415,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3445,6 +3463,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3530,6 +3549,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3577,6 +3597,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3620,6 +3641,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3663,6 +3685,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3706,6 +3729,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3745,6 +3769,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3788,6 +3813,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
@@ -3840,6 +3866,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
@@ -3889,6 +3916,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 359d258d7151..e7b88e9643b9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -395,6 +395,7 @@ struct mv88e6xxx_ops {
 				u8 out);
 	int (*port_disable_learn_limit)(struct mv88e6xxx_chip *chip, int port);
 	int (*port_disable_pri_override)(struct mv88e6xxx_chip *chip, int port);
+	int (*port_setup_message_port)(struct mv88e6xxx_chip *chip, int port);
 
 	/* CMODE control what PHY mode the MAC will use, eg. SGMII, RGMII, etc.
 	 * Some chips allow this to be configured on specific ports.
-- 
2.22.0

