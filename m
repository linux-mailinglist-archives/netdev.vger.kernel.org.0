Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD089C9B07
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfJCJty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:54 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:45426 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbfJCJtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:52 -0400
Received: by mail-wr1-f51.google.com with SMTP id r5so2179490wrm.12
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GKER0aCVB7aAXBACEj1WlpKIkKyg0SV7tqW0hXQJYuA=;
        b=euZQFPQ0uXIiU7KNjmzEuBTixQg3ottDX4rt8lqa+y8Cjtps6pCio5bo7VjQ8FuT0x
         99mf6Nnj2d0ldj0d8PhKq8j3UjQJ5en4fIe6i38cy/aHLIp5lk5uzr+oueBnaECrkJ87
         ZuPjjkrk1QRXtHkKV8DnnOUoxJzC4ouqq0XKZ7KZNBfVlTWTKalCfZ/A7CpyeQ47VWHT
         aoz0Jg2/EsX8pBzEOM+q+Nvedz7oMOvmLOYhC6OILTCYVFQm4HtQi3PMnZAOcsJ3/HUD
         W6bjz4MnqTREcCA3YNzTN8kCQU5oYd8hYHLUi0ViNEMZvwKsO58afZCe5/RHYzS4C0oi
         RrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GKER0aCVB7aAXBACEj1WlpKIkKyg0SV7tqW0hXQJYuA=;
        b=Z1I6zN82+wLhYG0Ba/tKkfWbjh/CGouVFGAekTDDYAzfnADfrDgj9rNcACG4Y1/OAI
         YVgLryUhyU7OJ7B4viqpwlQ445rZH88mpbByanH2qjbC5yCBIfiZXIirFbC5oQ/eMBIx
         M42ovoQs/DLMtiBvUrl0YFQW8D29WYNzKs9ziPaSpZ1U5tC/CpUrI216322zOEgW8zkv
         40WkKfaxDSJzLOeWtdVRUEF+9elyV+LsaB5RyuprxU4UKsr9NrIjjWF+W0sodVnAqqTa
         KSlqmeWuXOkRc+4uz2CPaGMk1QrW4LUe0P2MwaAwmvtsoKar/FZZs+KMxx6XiE8ttopC
         JJPw==
X-Gm-Message-State: APjAAAW2TW+SMkjGH24r+mHVI0hd7payqJcrF3SVHmLZePWClYhQIjK6
        HZR2GexWnaBccIy9lWKzyMbOaF8ehkU=
X-Google-Smtp-Source: APXvYqw7+CQFVVz3YCmignxaT8ZuoOmk8b1sOPtAv2Rs+EdAfh9ayvo5Nt1V7C3Ub5fpbRhiXZdsUQ==
X-Received: by 2002:a5d:67c3:: with SMTP id n3mr5896000wrw.294.1570096189456;
        Thu, 03 Oct 2019 02:49:49 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id z1sm4634669wre.40.2019.10.03.02.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 06/15] net: devlink: export devlink net getter
Date:   Thu,  3 Oct 2019 11:49:31 +0200
Message-Id: <20191003094940.9797-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
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

