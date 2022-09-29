Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0C5EEEFC
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbiI2H3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiI2H3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:09 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EE31332EF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:08 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u10so628280wrq.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9+xMapSF679p96gL9vU+Omt/7DAfC+pmm5Ktf8c3i1k=;
        b=EPGp6HQhy9OU4D9IVmnenHx6Vk66AnfMpxSne2CtFWlNdbPWcVh1O6411StIgl5VCL
         MJgNWq9rxXuyNoKIj7S+fUIQ3YabVJ3eGEDIFAsWsV5XJWneAdwDnhoNIi7QUw2dBnhW
         eeeyYFYiGF3feH62v5d39XTtiDzigiV6PV5TH3QTTktbYCeOrR2/CrrK97qs9I/sDIp0
         +mcNcUsXxQ/pkEeFArDUYwQQfA/4fJrQBzo9S+3AEb45lr0D+lZzbufkDjd/BCsDZXIo
         jxqYpINzdWZ8gyMVJSyiBoCnDChaDzYSP2V4wW+1QNOmxMfB+jlUiOYxIZBW3jVc8K7A
         Kc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9+xMapSF679p96gL9vU+Omt/7DAfC+pmm5Ktf8c3i1k=;
        b=tj7569Apvg1aYmZh5XsCnMz5tPtnQaeTZpr0QjECLhHyCN7ZztQCHGan+R7cUdrYlH
         8jx4QPjV/W4paWXQ7O84pYRNfCG/8NyineBXJXpOFelnGnm1vPWXeiCN9jOaMsbAOhbm
         oA7ngCiqJpjzaqzhN9vR9cxhs3obcpbKEw8x/PNZ6n0ut8uR0CA4NxYS25hHyD2QRpnr
         eMlsgDcgjPl+rsPVOwQBjI/eVqV6W0qEtF0IivBmtnQxuG8iY4GP6mXggV0as8kApx5s
         wWB412F1Vh2vtmAD3xSz3EGQSElDT+Du6O8LKrfbTNfM2/2Yd/6R6N31Auy4WsEi4FB+
         duwQ==
X-Gm-Message-State: ACrzQf18hBlOAQJfmeCrbkpgkKgC0VvZ3jZvTgwsVzzKrt/4J5x3ORil
        x1BSCo99Hn1+xdB6KgmUX71loMkhWkKDBxiT
X-Google-Smtp-Source: AMsMyM6ij420i60SZ+PjXaSLeNkqCbOkjroXUKCCI+i2IA+EHM9Sa+Q6eV1WZPH69WMwp52T/Ihltw==
X-Received: by 2002:a05:6000:1f09:b0:22c:c6d9:5f42 with SMTP id bv9-20020a0560001f0900b0022cc6d95f42mr1155589wrb.84.1664436547147;
        Thu, 29 Sep 2022 00:29:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b0022a297950cesm6093087wrn.23.2022.09.29.00.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:06 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 2/7] net: devlink: introduce a flag to indicate devlink port being registered
Date:   Thu, 29 Sep 2022 09:28:57 +0200
Message-Id: <20220929072902.2986539-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
References: <20220929072902.2986539-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of relying on devlink pointer not being initialized, introduce
an extra flag to indicate if devlink port is registered. This is needed
as later on devlink pointer is going to be initialized even in case
devlink port is not registered yet.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h | 3 ++-
 net/core/devlink.c    | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 264aa98e6da6..bcacd8dab297 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -129,7 +129,8 @@ struct devlink_port {
 	void *type_dev;
 	struct devlink_port_attrs attrs;
 	u8 attrs_set:1,
-	   switch_port:1;
+	   switch_port:1,
+	   registered:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f5bfbdb0301e..17529e6b2bbf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -372,9 +372,9 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 }
 
 #define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
-	WARN_ON_ONCE(!(devlink_port)->devlink)
+	WARN_ON_ONCE(!(devlink_port)->registered)
 #define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
-	WARN_ON_ONCE((devlink_port)->devlink)
+	WARN_ON_ONCE((devlink_port)->registered)
 
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
@@ -9876,6 +9876,7 @@ int devl_port_register(struct devlink *devlink,
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
+	devlink_port->registered = true;
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
@@ -9934,6 +9935,7 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
+	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
 
-- 
2.37.1

