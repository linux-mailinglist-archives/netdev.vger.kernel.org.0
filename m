Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B3A56B3D8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiGHHwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237441AbiGHHww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:52:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FDB7E005
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:52:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m16so10432182edb.11
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+1kh73qPqurRHWbKKVu98io15cDFmP3DMcz791PA0E=;
        b=KOzTf8nNUAUzZJoSoolgB6oQILTw+TbMmyQrPqiRoDrUTZMqfyh0zPJMH+NSpbf0iB
         9DVSjVLezslY6vMSbYLMKoUnmK19Ynm2Yc4iRys8PuCZ6mVY0aO0xmpF2qrNlz2pshuq
         qvmHx2aJ1P1seEs4TvIrdOdJLh8K6jkFV6ZqGaUzEvBaDQ2ZZmOqgOCFEneDxVmTWkZs
         3iSHvXjUT2QZ8SyxvDDsaD5goyEmPz3LAgPNuhj1mbfT0WP989eq0pTGba+sKRMXCprY
         R5EJkBu7pFmY5TCF5RqS26xwBZmmHPZSnwaDYdTTSpDUO0c6DZL2NdM0u0hy3+/0mLS4
         KX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+1kh73qPqurRHWbKKVu98io15cDFmP3DMcz791PA0E=;
        b=WGePhX540ZkBuvgQWrAL24UndeTUL9X8jE0O50kdcOtRdVW2ZR8OsQIM2e/8qVWf01
         O2VGPF9ByzlJZlIoYu3nGDAhK8doBWKC7Ck2lbad4dTp22mG1bIhOmkVYXGZ7C6GGb4z
         IURuKYd6raXISzwVTfKsAM46QddzqMAutGBycMt3rZwjUxNMjSU39bsNjDR6JAq3jsll
         N76V7nGJ37/h1b6589nTs8GfuI3GOtdY3ffmO2DG8tdlCAp/vfxnk4S8ccPG6H4Otd1S
         KE6XD8SKFvxnzYnuUNHJ9ZW215tbHw6TjdclGXD+OtighvElvqKrrblQO3UZJJLL4TVc
         bjQA==
X-Gm-Message-State: AJIora/UVu0jUZBVm5Ax2lnPdO+dcVgF0oibYQ0KE5lIFT1EToR3XXKH
        Pc2wEbqVUgxKTkZnORO7v2o9oXued8GidKGAk4U=
X-Google-Smtp-Source: AGRyM1su8O148XlZzq4edLobi/dwtC/Y0esD15jS8OiRRpyihsyI/tU8ywXaBTPfisFc/L7wGVND6w==
X-Received: by 2002:aa7:db09:0:b0:43a:7353:94a6 with SMTP id t9-20020aa7db09000000b0043a735394a6mr2994029eds.191.1657266768771;
        Fri, 08 Jul 2022 00:52:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bg6-20020a170906a04600b00722e31fcf42sm19933531ejb.184.2022.07.08.00.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 00:52:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3 3/3] net: devlink: move unlocked function prototypes alongside the locked ones
Date:   Fri,  8 Jul 2022 09:52:47 +0200
Message-Id: <20220708075247.2192245-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220708074808.2191479-1-jiri@resnulli.us>
References: <20220708074808.2191479-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Maintain the same order as it is in devlink.c for function prototypes.
The most of the locked variants would very likely soon be removed
and the unlocked version would be the only one.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b8f54a8e9c82..edbfe6daa3b5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1520,15 +1520,6 @@ void devl_unlock(struct devlink *devlink);
 void devl_assert_locked(struct devlink *devlink);
 bool devl_lock_is_held(struct devlink *devlink);
 
-int devl_port_register(struct devlink *devlink,
-		       struct devlink_port *devlink_port,
-		       unsigned int port_index);
-void devl_port_unregister(struct devlink_port *devlink_port);
-
-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
-void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
-void devl_rate_nodes_destroy(struct devlink *devlink);
-
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
@@ -1550,9 +1541,13 @@ void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+int devl_port_register(struct devlink *devlink,
+		       struct devlink_port *devlink_port,
+		       unsigned int port_index);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
+void devl_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
@@ -1568,8 +1563,11 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
+int devl_rate_leaf_create(struct devlink_port *port, void *priv);
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
+void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
+void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
-- 
2.35.3

