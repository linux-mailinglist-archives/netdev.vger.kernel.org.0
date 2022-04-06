Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE5C4F6D4F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiDFVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbiDFVtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E952E2AEC
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B6EF61BA6
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 21:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CB8C385AF;
        Wed,  6 Apr 2022 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649281079;
        bh=48EL7nJabRw2FzvD14ODYdKtPzE8d0iOQB6PB1Za0BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpzWiGlYZ6CNaFydnAX70iuBtOzU8fvmUoKrXYc88JCS13krXW55Q+u6gKdladw9n
         GwqsJ3l25kGwljKQzfXqYfoyL/w5vQfpI7hXsKZfdvymx/VRJ+kXnqO5MVBWF5846V
         mIASDCfHCx17+yoaOSo9oIkHJvRYuCLsZH4im2Y6DGl2xsn6pVe8nJdEXJZ5LHXhjM
         kmG8OutXWLB/urW29Nt7nd0o4LGiBX1RuzLJj52P4mmfB1TWKCn9v8RoxGqgd+4Ew0
         A7rcbqEaijx4mkcjYwqa5lk0pmPQy+8An3pobL6ea7+zaN6qAkJStQm5NwNki5BOdm
         ULZEYvqqGgBeg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] net: unexport a handful of dev_* functions
Date:   Wed,  6 Apr 2022 14:37:53 -0700
Message-Id: <20220406213754.731066-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220406213754.731066-1-kuba@kernel.org>
References: <20220406213754.731066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a bunch of functions which are only used under
net/core/ yet they get exported. Remove the exports.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d5a362d53b34..8755ad71be6c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8645,7 +8645,6 @@ void dev_set_group(struct net_device *dev, int new_group)
 {
 	dev->group = new_group;
 }
-EXPORT_SYMBOL(dev_set_group);
 
 /**
  *	dev_pre_changeaddr_notify - Call NETDEV_PRE_CHANGEADDR.
@@ -8760,7 +8759,6 @@ int dev_change_carrier(struct net_device *dev, bool new_carrier)
 		return -ENODEV;
 	return ops->ndo_change_carrier(dev, new_carrier);
 }
-EXPORT_SYMBOL(dev_change_carrier);
 
 /**
  *	dev_get_phys_port_id - Get device physical port ID
@@ -8778,7 +8776,6 @@ int dev_get_phys_port_id(struct net_device *dev,
 		return -EOPNOTSUPP;
 	return ops->ndo_get_phys_port_id(dev, ppid);
 }
-EXPORT_SYMBOL(dev_get_phys_port_id);
 
 /**
  *	dev_get_phys_port_name - Get device physical port name
@@ -8801,7 +8798,6 @@ int dev_get_phys_port_name(struct net_device *dev,
 	}
 	return devlink_compat_phys_port_name_get(dev, name, len);
 }
-EXPORT_SYMBOL(dev_get_phys_port_name);
 
 /**
  *	dev_get_port_parent_id - Get the device's port parent identifier
@@ -8883,7 +8879,6 @@ int dev_change_proto_down(struct net_device *dev, bool proto_down)
 	dev->proto_down = proto_down;
 	return 0;
 }
-EXPORT_SYMBOL(dev_change_proto_down);
 
 /**
  *	dev_change_proto_down_reason - proto down reason
@@ -8908,7 +8903,6 @@ void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
 		}
 	}
 }
-EXPORT_SYMBOL(dev_change_proto_down_reason);
 
 struct bpf_xdp_link {
 	struct bpf_link link;
-- 
2.34.1

