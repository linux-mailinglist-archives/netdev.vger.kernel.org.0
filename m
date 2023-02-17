Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05269AC3E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBQNRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBQNRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:17:08 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC2153ED1;
        Fri, 17 Feb 2023 05:17:02 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id t8so1302842lft.11;
        Fri, 17 Feb 2023 05:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MVXpSvxD8IQLLcvTNwyEk6nPjo5geqGNCFp6pQeswJ4=;
        b=EWCj+D/JciN173neJ/bAWbb8Wsq/dKdqGJ7JlzysVjI7T6XYobU3X+botTB7SN8ZzP
         i/wd1GhONcUrM6D3vvxK7vCWfOBD4a1yloUyKQrd3AOIz5lYxRd+Zud+Mj2NNrQBAJ2U
         q7qaxB0QZRe6W56+l8Z4YpXs1796EiobAWPam60eKGpRAtSFvsXr93htNbVRwCwkIlC3
         5pxwiY3IXTZPozDxqXEkfCTiDdzEOCxjsPjek3YDsAQcPy68bvD6S16GG1a1pHk//d/1
         fPwp8SF9gcgqwAxhurtTdOpyEnpeTuyy+FnAl+x+wBlzyUqOChVXctZd48wBI1YcegxT
         qrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MVXpSvxD8IQLLcvTNwyEk6nPjo5geqGNCFp6pQeswJ4=;
        b=nGDAlQZTTn6xvMcLZq3aIeG3/de1+sTR8WThJaTN4I/tBtmUn2jDqVCoLlfNMmNplh
         Ag+8djlSRYihTnym8dqcq8SXxKNDX0ciAcfHqKyV2x0XraxpujO4UjKDpw1+3JvHZjkQ
         UMUOSYZi5RgJYRnaoq8lWPBYwDvFlOznXjfabqvq+dl1n1iroxqBtJn6bwvQCw/ipSvL
         zxPbJXU2yY71XXb/rCLA2/LGN+INXnW2xULepIJC2m/qkdw0sGpjiE9IIV0eC80O6p3Q
         EoRn0Su3LrwOKl8iiD0Ov/dnZeqj7htrhET1dDogBY+tfoCxDNNd2RU7YtqLowqweuJO
         hmMw==
X-Gm-Message-State: AO0yUKVx3r6LOTb9Cx0HoVIOP/czZKkhaUtkMaTql2BtYsztVEf2YJft
        d6zpwGx/tUFJ/bLQCtwkLuLBZxfTyqxOuMYs
X-Google-Smtp-Source: AK7set//GZM99vxZgMQht3iXKY7qkiQhLZZSsdCP1ku2eKzAzSUDtfL8xIoEVoSpSeYEdhPIkHWJsQ==
X-Received: by 2002:ac2:4ac1:0:b0:4d9:8773:7d6f with SMTP id m1-20020ac24ac1000000b004d987737d6fmr2820673lfp.19.1676639820640;
        Fri, 17 Feb 2023 05:17:00 -0800 (PST)
Received: from alsp.securitycode.ru ([2a02:2168:8bff:fb00:c81a:1ac1:84a6:458f])
        by smtp.googlemail.com with ESMTPSA id b4-20020a056512024400b004cb43eb09dfsm684285lfo.123.2023.02.17.05.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 05:17:00 -0800 (PST)
From:   Alexander Sapozhnikov <alsp705@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Alexander Sapozhnikov <alsp705@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] net-bridge: fix unsafe dereference of potential null ptr in __vlan_del() 
Date:   Fri, 17 Feb 2023 16:16:57 +0300
Message-Id: <20230217131657.12649-1-alsp705@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After having been compared to NULL value at br_vlan.c:399,
pointer 'p' is passed as 1st parameter in call to function
'nbp_vlan_set_vlan_dev_state' at br_vlan.c:420, 
where it is dereferenced at br_vlan.c:1722.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexander Sapozhnikov <alsp705@gmail.com>
---
 net/bridge/br_vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index bc75fa1e4666..87091e270adf 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -417,7 +417,8 @@ static int __vlan_del(struct net_bridge_vlan *v)
 		rhashtable_remove_fast(&vg->vlan_hash, &v->vnode,
 				       br_vlan_rht_params);
 		__vlan_del_list(v);
-		nbp_vlan_set_vlan_dev_state(p, v->vid);
+		if (p)
+			nbp_vlan_set_vlan_dev_state(p, v->vid);
 		br_multicast_toggle_one_vlan(v, false);
 		br_multicast_port_ctx_deinit(&v->port_mcast_ctx);
 		call_rcu(&v->rcu, nbp_vlan_rcu_free);
-- 
2.34.1

