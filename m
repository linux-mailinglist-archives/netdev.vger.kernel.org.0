Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF4D69AC2B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjBQNKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBQNKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:10:38 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FB167443;
        Fri, 17 Feb 2023 05:10:34 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f22so928181lja.6;
        Fri, 17 Feb 2023 05:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J0dw7whMOJQJOi9uWyg8pekWteeUM3FSvncYli56xrM=;
        b=ZJP/Vc4DNhnP7vNZoltPzVJg+xHUrwAuUU/yEcRVXm4oBmREPC3XmKBf8vBUb83fzm
         AWhyiJU8x+YO+Bw2oDnuvHmcAWeMxRzztwdjkxXvLt4kRF2yk2zP5X60V9te/W3N8Pl/
         FMRmsZ2euvbs4W9naCuwZvjOBVNOZuQzUEHbpP+5pQWeloi6Tpm9AeqvTDdsUaKeUl3f
         /qO5/0s/pHAncoJI9BZARP+cBcYYlhpoQbL3WCmxgWHY6OrS2nLA0mhJjwcgigDRqQdQ
         qpakRx68sP8LFlAhJFEGwkdUDDEOB6eqaLe15jtD7aoj9/STJdpKUxxhW1Ifp+cQrLX2
         XOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0dw7whMOJQJOi9uWyg8pekWteeUM3FSvncYli56xrM=;
        b=viZiRjvTMzs9QlR7TSPyZeC7fwd/pp2N+fxwXagy4AIXUj8MCfVkRo/yt9C4ZHQk8v
         0OwsbY0CaY1ooN/t1+NeB9gjBPho9Mcjynb9zO9XgXGeVaAvMmOGdbmzAyNaybDw9gCE
         Jsr0det7IanXCs6BMilDK7AIlxhgq0ib3xbQSfrJeYK4rzH95Uao7i0DwaaJtvjKFr84
         tyxrU5qFOqavWUtUsF8dC9/ZAud333kukJIrADMhYSQ0qWkSLKwyMe5k+PclsAnuWUZ9
         iSio46gmOZxbUnvA1G1Yg1nGgj9Er7NdcYDgx1BUVA5GBwPWTQVtJdxLZqHSOH/xu/iz
         /OyA==
X-Gm-Message-State: AO0yUKWFbpv4KDxb3T9BJt0woa19+pG+n08GSFdUQbyrOlaRLRPAqQ9v
        5DMVEaNrSK4kc7R1d7/wsKk=
X-Google-Smtp-Source: AK7set/ZVly470zOS4LxdWVFdfFfIUitrEAJ/UGeJ7KfuS0LytT5d9gw7f+6nPKAG9YYlGZPMWjbFQ==
X-Received: by 2002:a2e:9a97:0:b0:290:5582:8c10 with SMTP id p23-20020a2e9a97000000b0029055828c10mr3083759lji.49.1676639433034;
        Fri, 17 Feb 2023 05:10:33 -0800 (PST)
Received: from alsp.securitycode.ru ([2a02:2168:8bff:fb00:c81a:1ac1:84a6:458f])
        by smtp.googlemail.com with ESMTPSA id o13-20020a2e944d000000b0028b92cd1fd8sm572381ljh.109.2023.02.17.05.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 05:10:32 -0800 (PST)
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
Date:   Fri, 17 Feb 2023 16:10:28 +0300
Message-Id: <20230217131028.12634-1-alsp705@gmail.com>
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

