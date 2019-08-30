Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39871A3227
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfH3IXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:23:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54676 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfH3IXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 04:23:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id k2so4904690wmj.4
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 01:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0thh2/ytCGftHj0Ajq0hOO8S7HbmzQEM+tQysbdjYtQ=;
        b=srJNt5laakXooT2JaDTNgO17HeWqOa/UEG2LqyIs4AUlVrQdjcN5b13VQJatJ/5z7l
         yIFmZO29dIoDhxpMJB8rmWxj6MprapdhvoZ7PtGM71jccb5ZaTqLzmgdakE9A7ij1G+F
         naU04LD2D1rSf/vnZx0Das1LsrZtJTwQWv3zEte6TA/B0ailvgY54WWy3w510mp7sjog
         aygQvaJkR1rYcRcp06eQRcdQ4fNRxJXT6VmZD3Xb1m7G8uHNM0C2IpuPcbf5UT0QH7w5
         Iam3xA+VE7HeriU1DI5e4nbo2BTOKDVWdSRZhKeVV7e8grxNZmVR912n3tuIPJ1w8R4y
         jEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0thh2/ytCGftHj0Ajq0hOO8S7HbmzQEM+tQysbdjYtQ=;
        b=MWI7tLJITay4B5xdklb5wo5JWKcWpr1KsYz6tH1y+Q99+qXsSDHenRaS8q9THrtOkP
         iwEiTy9CwJlQOYz4FQNjgHbuR/s86wr3qVWd5Hx7D/WD6/gN9mLIFA86gzgbfT2F5PZF
         PoHmz8huNJp68PDcB8x3MQHZNvxzHzl8fjqpME+q499sNZ4cenU1eA8IVzOJl3XlHaB0
         4fNGme1Dhx8Asqdaz23GAutsmUK/OdI9K7EPjwXusVRkoiqPcZHs9+FtTL14wtw0e/+J
         Ca2NdYKfk8FZawzT3qGK4y02UUsBE/Ght7VmRShwwq90ISCndJMiohz5HD3gFcg8H5Dc
         R+eg==
X-Gm-Message-State: APjAAAVOa45rVhcSeg3iaQ5AIMwEqVuOEIGSC0dGaHr0zmyHETLlwLvB
        +TGNo4PpHkzW4eJWwDVjAk7Wk8GLfYc=
X-Google-Smtp-Source: APXvYqxbojxnHFAJTc7HWCAIyugi0kK8YEllWYNDgptddxBguyn24IZrl9S88ngxBSZnjN1y+WoVYg==
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr15576417wmc.87.1567153401307;
        Fri, 30 Aug 2019 01:23:21 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id u128sm1731635wmg.34.2019.08.30.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 01:23:21 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com
Subject: [patch net-next] mlx5: Add missing init_net check in FIB notifier
Date:   Fri, 30 Aug 2019 10:23:20 +0200
Message-Id: <20190830082320.8819-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Take only FIB events that are happening in init_net into account. No other
namespaces are supported.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index e69766393990..5d20d615663e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -248,6 +248,9 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	struct net_device *fib_dev;
 	struct fib_info *fi;
 
+	if (!net_eq(info->net, &init_net))
+		return NOTIFY_DONE;
+
 	if (info->family != AF_INET)
 		return NOTIFY_DONE;
 
-- 
2.21.0

