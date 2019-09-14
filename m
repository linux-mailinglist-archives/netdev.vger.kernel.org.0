Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1540B2A27
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfINGqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36644 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfINGqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so34025936wrd.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GKER0aCVB7aAXBACEj1WlpKIkKyg0SV7tqW0hXQJYuA=;
        b=kYCTeiCWs3H8P9NgSDfqDXiHWoJSzHboXIJzcbPuXq4r/1m3e+mMDgdehs8kWtClwK
         N/JpmQysnS3QqfiYFKVtGNVrcY2j9Q4BgJR4ptp3dMw9z65/rFhZn5asFDkqgftNyLTA
         PLD1I73sAL/flyrapLTSH7XRvkNFaNUls0otGpcISNO0LNC3UMAG7kvcZFvNDEqQ2S1T
         Ej/Hy39MsTRLAXF2YQuc785bCyZIRa7stmbzqqHhfMHjRm+cibiNSbFbjvT6sccGhyK1
         r3ZnMsr2fC7haw73EvnQqOyBQvW0zAp+j7bchSwK2kBkg0trCfV93z9Hws0DQH1u0jsU
         jETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GKER0aCVB7aAXBACEj1WlpKIkKyg0SV7tqW0hXQJYuA=;
        b=oB+l6WhpMOGU8ZmRKZTNJkIBTBe/OVx4VNFPhIKL//Q++o9hZ8f57AxinNZ8ivPxuj
         O8jTYbDs2sH/pblqcHWqm+3a9tZu0KM4bKJLMG6Cn/fPmrq6kOkvWhIzSRKd4BeD+UTd
         wjRJp7OUvFkGHkfBHhI+KNg6Af8rjQdMBUZY4gUs0wEJbuWT6FrskMyDFqUP2IiyZvvw
         pHfWcX01TIjeWip9LHyrj+fL0bLd6avRUFlxM7BUgs5iYJirCwH/vhw7nci0XWtTCXEG
         /HyrgcDjePZSgWZ9CxcGejG4XGGHpbQmKqjXiAExwAGGwdSOFeWX7G44POK2OgfIL05U
         JLxQ==
X-Gm-Message-State: APjAAAWu5E2PD0sxKalgBS/ZqDP09qdloFHENH/ntRXz17e2H52vxugm
        Z2wHoUPZHUlw26wlmvYc4VVagBJwk+8=
X-Google-Smtp-Source: APXvYqxNBrCWCcY4eAnqzGYP1rAyH/zBC33vGugeMtm6gu8PsT5IA7KRb9fppDhSy7srqGTunHkAYA==
X-Received: by 2002:a05:6000:1002:: with SMTP id a2mr36020183wrx.272.1568443575983;
        Fri, 13 Sep 2019 23:46:15 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a205sm9318320wmd.44.2019.09.13.23.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 06/15] net: devlink: export devlink net getter
Date:   Sat, 14 Sep 2019 08:45:59 +0200
Message-Id: <20190914064608.26799-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow drivers to get net struct for devlink instance.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h | 1 +
 net/core/devlink.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 23e4b65ec9df..5ac2be0f0857 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -771,6 +771,7 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
 
 struct ib_device;
 
+struct net *devlink_net(const struct devlink *devlink);
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e48680efe54a..362cbbcca225 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -95,10 +95,11 @@ static LIST_HEAD(devlink_list);
  */
 static DEFINE_MUTEX(devlink_mutex);
 
-static struct net *devlink_net(const struct devlink *devlink)
+struct net *devlink_net(const struct devlink *devlink)
 {
 	return read_pnet(&devlink->_net);
 }
+EXPORT_SYMBOL_GPL(devlink_net);
 
 static void devlink_net_set(struct devlink *devlink, struct net *net)
 {
-- 
2.21.0

