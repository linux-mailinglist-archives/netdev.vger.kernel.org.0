Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2410416F9BA
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgBZIjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:39:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36330 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBZIje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:39:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so2025725wma.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8nVtU03geS64c6/P1IkRrFy9adLtKUAjGMeuUPNWeyk=;
        b=j61ywaT285WSwG5gzkxzs+l+mbRR3cWKP54v/2DjevEXEeKhPJVPqFwzedFiIsgVOg
         k/OEDFP/6fVnB9GyOozyYZOI/W8r0lA4g3yaT5FbD+h3+knJkh3V+jBg6l8Y+4enEE3M
         YaU6B3lk2gaRk8OSWhspDjgKdxNekHSZnsF+6Xke28kQKmDw11JFgJEyCEkJY9A8rp/j
         thHsHaeAbCNEe+jezbjHMrOrA4Pkeq8fhMnRYcfAJyYndIbgMHC1ikvOjZKSc+qvDobd
         mYn2D2fq3MMgAfSd5CZsEiUovZlAgqb/Ko/675XYnvCMDv5y4sxvGOWbMCxKXaQuPmnG
         JJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8nVtU03geS64c6/P1IkRrFy9adLtKUAjGMeuUPNWeyk=;
        b=fMqXBmX5K48cy+FurU/Lkm4E3F3xEsYB+w9SqqRpR/A2PoR7q+DidQxtufcAFWqPe5
         sbPmBljMjBi1YvjPL+uqqkQmbTtqujv0e1nicqk/ATV20P4I29hU6FYygh2ZPJNJVQbv
         Ie58rzCJdoOmTA4h1VR0lAfM9sPjeZZqRRlnhHE3ucz3MIl2s70gfcDoMaeNc2vy7Y6S
         e2k5UE7GMwTgyFtHeWnSP0Nejob1rPch6LPFvgLkjZ1J3CcBwYuguI7EZ+g5JQvep49s
         D1ApvzHbB3WmoFKQPE6UzGICcoDTmWqeFs6fqpLruB89+6niGMYJQMrpT+U37n3JdUZ0
         eJ+w==
X-Gm-Message-State: APjAAAX2esCd2rDcuafH3ZZlboHOn+ZJCUNSBL1oVkk06QCDqv6j9yYK
        QnUjObV3A65jSG0w4PudPYy8zMxP4bc=
X-Google-Smtp-Source: APXvYqyTTKRDnL/Dr386+Uqv9IV/lbqU+VqvrJLMqQg5YlKB34sZdWQK7RkqlqGwwCHZ2kmdKgHzjQ==
X-Received: by 2002:a1c:f615:: with SMTP id w21mr3284264wmc.152.1582706366496;
        Wed, 26 Feb 2020 00:39:26 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id t1sm1965206wma.43.2020.02.26.00.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:39:26 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 4/4] mlxsw: spectrum: Add mlxsw_sp_span_ops.buffsize_get for Spectrum-3
Date:   Wed, 26 Feb 2020 09:39:20 +0100
Message-Id: <20200226083920.16232-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200226083920.16232-1-jiri@resnulli.us>
References: <20200226083920.16232-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The buffer factor on Spectrum-3 is larger than on Spectrum-2. Add a new
callback and use it for mlxsw_sp->span_ops on Spectrum-3.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 17190ff55555..673fa2fd995c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4875,16 +4875,35 @@ static const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
 };
 
 #define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
+#define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
+
+static u32 __mlxsw_sp_span_buffsize_get(int mtu, u32 speed, u32 buffer_factor)
+{
+	return 3 * mtu + buffer_factor * speed / 1000;
+}
 
 static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
 {
-	return 3 * mtu + MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR * speed / 1000;
+	int factor = MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
 }
 
 static const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
 	.buffsize_get = mlxsw_sp2_span_buffsize_get,
 };
 
+static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
+}
+
+static const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
+	.buffsize_get = mlxsw_sp3_span_buffsize_get,
+};
+
 u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed)
 {
 	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
@@ -5163,7 +5182,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
-	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
+	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
-- 
2.21.1

