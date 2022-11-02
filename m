Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A066166D4
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiKBQCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiKBQCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:18 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A022BB09
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:17 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso1592446wma.1
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X1MyJqO1mdXn8/laNFPE2bRj0/yLyArfqMTcNfqAWXY=;
        b=5ZSd+8BZbC24G3hbjqtLLcA9qcMb2v+6qeZbrlQUpJeEz1lGdpVdvaX6LEV02EzS7t
         9OEPRh50svPbCNop7fylt9dJB5OxIHTvPK+ABvyF2BAAsKd0So4MuwzUm9k/1/HJORDU
         v9JDjG22glSbM0HQ9ixLj18TjKSNR43hrE8nyJt9lRiqh6ByDINsj5+nEmYTVPn3Qhxr
         63r+5scySM14zvSedDCBdNMewOQDoiucPwnJOJzfOXShsYW8vgxBmM4XsE/KZ3p7ksT4
         /CL57UjU02qvgYQC7/PXLgBrXVcxT1AsnehtxQEuKghi1/fn2lU8ohZsbJqYWVHmK18z
         +99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1MyJqO1mdXn8/laNFPE2bRj0/yLyArfqMTcNfqAWXY=;
        b=f2YrmgQMH2W6ReBrtJEIEIOkpKYNkpyxaxDRJ7fiQ1Un1dDgeKWqfx0/V3sVHj2/8X
         3ORWe3KQ+pnhi5uL1PgulcMVcm8PRyfBdi3tlEnlTMQqXCaOb6QdAR/zhW9wdNlIVDS/
         2mJ9lHzwKuBxZ4CYPHhrQT6W02jzXjHQ3KMlNc8yG+YENjR8V5InZ325YgwWYkA1Fkn5
         ZzIYTOGwoJWuW+6OOQ3J5J14YefFgbCWo3CVqoyV9tnroMbJYd8dL2FsJZ9X9OJakrKm
         VSf7bFqc0TQ5opKvlIRqLwskg/td7mdiU2YLSkgTHFcJV3hE1tfwIUfoCCi+35Ydf/zN
         pRuw==
X-Gm-Message-State: ACrzQf2UYDq51aOMX96KuxdgzQI5p6XBd/MWgjYkwrdjlJBwViNA8vb0
        Go6HcgXbQFlVJsQ7uZuUBksfI/hROw/ZTFHzZr8=
X-Google-Smtp-Source: AMsMyM5Diub71WltbaxQ+S2Rmu9qh1NqQ5bqtg0jFl0Na2uJtVi083hRmXXE/6FmM+HBpN5HvsJvVA==
X-Received: by 2002:a05:600c:1d1c:b0:3cf:846c:5092 with SMTP id l28-20020a05600c1d1c00b003cf846c5092mr3693954wms.160.1667404935880;
        Wed, 02 Nov 2022 09:02:15 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g19-20020a05600c4ed300b003c6f426467fsm2743204wmq.40.2022.11.02.09.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 02/13] net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
Date:   Wed,  2 Nov 2022 17:02:00 +0100
Message-Id: <20221102160211.662752-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_warn_schedule() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 868d04c2164f..3ba3435e2cd5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10000,7 +10000,11 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
 
-	devlink_port_type_warn_cancel(devlink_port);
+	if (type == DEVLINK_PORT_TYPE_NOTSET)
+		devlink_port_type_warn_schedule(devlink_port);
+	else
+		devlink_port_type_warn_cancel(devlink_port);
+
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
 	switch (type) {
@@ -10095,7 +10099,6 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
-	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.37.3

