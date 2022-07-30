Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53D5585B38
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiG3QD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiG3QDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:03:53 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DFCC32;
        Sat, 30 Jul 2022 09:03:49 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id y11so5609330qvn.3;
        Sat, 30 Jul 2022 09:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=44S36YW/XCMky1KM2xLak/T6CHlN1QC9bWrP+1FyJlw=;
        b=g0Q21UbliVaSVVRMLR3KfiO1ctfkqbex+ADs1SZPfocxQiayXVsduesPlZ4XJEiDIX
         MbPdTPlfkRj/GfrNerNSTILsktSvye1srw6OW48ozmemcia6FSJlgkXOKVrgKLANXPmu
         +FF/9kp/oYfvE7hwMdi6PzVw2QgMACsouWINDbI3zFGjUzpPw/b098zruYu7M0QyxJVR
         wkqAQxQKbgxWILj3gAe+4QNYGSNupa3H3lBxy4TR2c4d7ZMnUOr9D3b+A3G93pV0yHxu
         SjwEyUuZRP1dzX4nkN6wf9HzXqxi3wo2x6YbfP2j6OxJYslXCvJOkk6/wJiWe97PEDUP
         ii0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44S36YW/XCMky1KM2xLak/T6CHlN1QC9bWrP+1FyJlw=;
        b=k44Z+mZ4u9hXSj3NHFUYEaQ7aKTDiaamGgLuixxfhir0mr3dStxvMRdU3a/qKFcOen
         okR1nygYSi+iD6q56Wd2MOJXd0ZxPZE8OnA9Ftsv+a+ZJRV+ma7iaWzqkB3SFRut9FHO
         tKHeqPfAmaJyBCuR3gU/roo8lIxGc5OE1tmjVGabdlA6X0lERaecpquqI9ZCpUjqPXrm
         ltAMFd0BOzVZxicFg2IyI6SEU3WqObWF0GllcrzlsXLKANhiJZ680WF/5Eycnmmru660
         3B9Aid5GRmvhu+z23aWJCUFOlqJdlKUn+JW5vqVzYYE0Ciw8kUhSi0xSDqeh1LqWLnAv
         bD/g==
X-Gm-Message-State: ACgBeo2JZFN5Aa6qMEkaDkK69a/sVPJ4qSeK5UsFz8cJspuluOa8IJQg
        C1WGAMG0BnaGLB89URljQ2A=
X-Google-Smtp-Source: AA6agR72LGiu7HIQOzRisPgkgt460ylBNaCgT7TT8h/4h/r1C95WTkSNIdRTCU8PS2wEFypJCH4CJA==
X-Received: by 2002:a05:6214:d47:b0:474:7f18:4764 with SMTP id 7-20020a0562140d4700b004747f184764mr7535850qvr.15.1659197028459;
        Sat, 30 Jul 2022 09:03:48 -0700 (PDT)
Received: from ada ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id do54-20020a05620a2b3600b006b5e833d996sm4877020qkb.22.2022.07.30.09.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 09:03:47 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     aroulin@nvidia.com
Cc:     sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH net-next 1/3] net: bridge: export br_vlan_upper_change
Date:   Sat, 30 Jul 2022 12:03:30 -0400
Message-Id: <75d00c06deadc0386811874f9e4edbf5381df949.1659195179.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
References: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function contains the logic for correctly setting the bridge
binding behavior of a vlan interface. Therefore, it should be executed
whenever the bridge binding flag of a vlan interface changes via the
vlan_dev_change_flags function in the 8021q module. Currently this
function is private, and it is only executed when a vlan interface is
first created. Export the function so that it can be called from
vlan_dev_change_flags.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Roopa Prabhu <roopa@nvidia.com>
---
 include/linux/if_bridge.h | 9 +++++++++
 net/bridge/br_vlan.c      | 7 ++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index d62ef428e3aa..0d92b0ed0961 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -180,6 +180,9 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
+void br_vlan_upper_change(struct net_device *dev,
+			  struct net_device *upper_dev,
+			  bool linking);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -208,6 +211,12 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 {
 	return 0;
 }
+
+static inline void br_vlan_upper_change(struct net_device *dev,
+					struct net_device *upper_dev,
+					bool linking)
+{
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc991409..6bfc36da5a88 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1653,9 +1653,9 @@ static void br_vlan_set_all_vlan_dev_state(struct net_bridge_port *p)
 	}
 }
 
-static void br_vlan_upper_change(struct net_device *dev,
-				 struct net_device *upper_dev,
-				 bool linking)
+void br_vlan_upper_change(struct net_device *dev,
+			  struct net_device *upper_dev,
+			  bool linking)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
@@ -1670,6 +1670,7 @@ static void br_vlan_upper_change(struct net_device *dev,
 			      br_vlan_has_upper_bind_vlan_dev(dev));
 	}
 }
+EXPORT_SYMBOL_GPL(br_vlan_upper_change);
 
 struct br_vlan_link_state_walk_data {
 	struct net_bridge *br;
-- 
2.25.1

