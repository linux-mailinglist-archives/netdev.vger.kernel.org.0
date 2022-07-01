Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80455630D7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGAJ7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiGAJ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:59:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A6A71BF0
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:59:30 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z41so2315715ede.1
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+1kh73qPqurRHWbKKVu98io15cDFmP3DMcz791PA0E=;
        b=Ryg3tgAz/ahlFAs9KZLOS8XntIJ+n/+9KF3A06wNpc6y0rv/sOHDKLjkJkpsojsjZ7
         /x/hBxt4kCl+Pilsa08PQVm5OCrNWu0W5+PXljDV8u2ZuKPSuiaIpRHmNw4KVv89BlZ8
         F26e71M71IPCMkg/vug5dsYWkX4aq/k7TKYKrBXqFsEkmSyHHYJ4Egj2VEQeAyQ6VGGZ
         rIVhFKpwXRaVj436+6xj7l3nEu9q29E6fDlIM6H7qeo85Un388b+aUj5svOoqM8Dx/5q
         yBA37DUxEpnT14+Q4lPdvk99a5LZ6O4Duee92QiGFn70ANE1TenU3lj8na5nwO1YcJzH
         NHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+1kh73qPqurRHWbKKVu98io15cDFmP3DMcz791PA0E=;
        b=nSLd+2C1u35dDt0t4PPqvHR3BlgWlcPO6rVxkXehVtnO2aParA70wQZml+MqND6x05
         FPXBScEdia5D79aWm5m5d7Xa4MfGZD2lf5vKpQQtggac87UGAQzBZlOKtEQqsCnhNNy1
         x+i93wO24fa/sN90oYGij2UsMFwAuIG7fxeKGxxzK5blW47L1UDM2H/efun2gCxtXA5y
         8C7upNSYnhy/3x6I6t5to+JDM0WNFkfHMiBaT72tPlQcVE24kxSnRe6kkmeJ60uRs7KJ
         vM/Gf/aR1XycZJZ3Q0CCneLThjGKa1SXeNxgTH38Q8EXxdVCSNHe37stEDH20P1C9wqU
         U2wA==
X-Gm-Message-State: AJIora+mnCaugrGiWibsYEZq/CWAvOWdSdzB3erkgiuH54a8ZZl80sot
        AFNM6AWx+JovCZBPnchv0ugFCZE9jN0gDVds
X-Google-Smtp-Source: AGRyM1sJRyHj0PnGvINLmLdGK9nek+s+GWq8lVRu23rj3zw7g7NxoT/3+CugAQFkySn6UeMpYQIcnw==
X-Received: by 2002:a05:6402:3551:b0:435:a397:4e9b with SMTP id f17-20020a056402355100b00435a3974e9bmr18269941edd.175.1656669569030;
        Fri, 01 Jul 2022 02:59:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c1-20020a056402158100b004357dca07cdsm14880143edv.88.2022.07.01.02.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 02:59:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 1/3] net: devlink: move unlocked function prototypes alongside the locked ones
Date:   Fri,  1 Jul 2022 11:59:24 +0200
Message-Id: <20220701095926.1191660-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701095926.1191660-1-jiri@resnulli.us>
References: <20220701095926.1191660-1-jiri@resnulli.us>
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

