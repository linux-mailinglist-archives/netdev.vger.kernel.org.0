Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB5762FF65
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKRVdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKRVdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:33:07 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0E5A3153
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:33:06 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id x18so4373735qki.4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=geoky24w5/KGWKhCFuccd7Gsd2OeCOkIgFwrlUWisHc=;
        b=pkh9DRMARKxHVveuy3uYyLl9VjpmpZeqnDsboz4WkWaxfZXdxhIGfVSE/CPlgeDyz5
         4pVaG1wFEYFSoOc2KYabY/S+9E1y0DKWAPs2KHRe4d73WxkYj6cTrT6ByjX8ctdqpq7h
         DqmAHNwfLwpjYDGU54RCT33FGPRQNRYVD1hfVZ1o3u4Mjn73lXFxsBAwlSLEf014xYQv
         wTQ64VQFDWRUZCPYHOxZiCrgZBYeitTcicR0iEU8HyTuMu9Pap+igPE5zBg9F4XTqPQh
         H9PAQaghecM/UANivCzsl0MVt4GJUJh7ASBGo7zm2p1vS8eLovwUwiSXuAEEbEDCMpuz
         Em8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=geoky24w5/KGWKhCFuccd7Gsd2OeCOkIgFwrlUWisHc=;
        b=6ZUQEk9wKpUB01Fq1ReVoNFm0p77owa1JcpWto2SuJ1Ihemll4JivbJw+8oH5DulUj
         Ks7Bdft53uoZBWe7XyTHFeXflvprn1Hr/OZSP2WgiFC7iLFgOxxxdq8V99mcrziWmJp3
         obz3taupP3cB3JQqnTTKemBCJUpAiZmBsnR+oqMi3OLbTLJrkuD5mvWK3WIBUvakQnFI
         K0Yg4Y9Dp+6mLO35J+Cqqw1lFxs5ia0n79CGazvgNfFjOH8hM3t7UHU/0w3CwWVfmbSI
         PBG/3KHb9Kj78cDpPWVO7pvImUcb03Pu6i145AjwvGmZ4rqpP/D7S0NUuAcRXL2UUOmS
         hkqQ==
X-Gm-Message-State: ANoB5pm+FpG4oX96K8X+vqZF5m4EqWxrZSX/Hm7JqwIC2yekKv1eJSjb
        MzI8ypn1YgKf5yDhcBDxSRfu7psvfAE=
X-Google-Smtp-Source: AA0mqf63J4GjV8qUULnJDGwIBRzMS3qmuhr5s7QIhA1gD94f8FbnBaW82RKTqy2FxiMLovPjh3wnaw==
X-Received: by 2002:a05:620a:3706:b0:6e2:5472:345e with SMTP id de6-20020a05620a370600b006e25472345emr7678637qkb.391.1668807185717;
        Fri, 18 Nov 2022 13:33:05 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id br34-20020a05620a462200b006faa2c0100bsm3136326qkb.110.2022.11.18.13.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:33:05 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] net: sched: allow act_ct to be built without NF_NAT
Date:   Fri, 18 Nov 2022 16:33:03 -0500
Message-Id: <b6386f28d1ba34721795fb776a91cbdabb203447.1668807183.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

In commit f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT"),
it fixed the build failure when NF_NAT is m and NET_ACT_CT is y by
adding depends on NF_NAT for NET_ACT_CT. However, it would also cause
NET_ACT_CT cannot be built without NF_NAT, which is not expected. This
patch fixes it by changing to use "(!NF_NAT || NF_NAT)" as the depend.

Fixes: f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..4662a6ce8a7e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -976,7 +976,7 @@ config NET_ACT_TUNNEL_KEY
 
 config NET_ACT_CT
 	tristate "connection tracking tc action"
-	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
+	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
-- 
2.31.1

