Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC844C1011
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiBWKR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbiBWKRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:17:53 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88458B6E3;
        Wed, 23 Feb 2022 02:17:25 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id e5so30109331lfr.9;
        Wed, 23 Feb 2022 02:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=EwW1ad9aaDxzLEmHNXCm17nZVCt4Pcys+G0syr6CYU4=;
        b=jUiiuGYArmzRZQS3Y4XwRUrxAylVnKXbhlDvgmK5j4rEj3BPOn/kbijHKxC8iG/uV6
         vr5lYaimp0a2+TRviGmqzurM7LFfRTv0s6htX0kNJzNbcP2n7jA9BOyzBDy7pBEAliqR
         YNu706cfj6V6i0xsR+hL+nhuV0Kf6O22r20lDjppmVdu1L5xvdHBbzx1yiMXgl3wmFNm
         ioK23b38vbXcCkLWcwfcsvJGO9//yjEkw5au5fzgMtlt8/YjmDtXytC5e9aFamneDLxA
         OPN8bF+rtabSGIUHYzS/AqYauq8UnNhL+nN0T6v84vFjhm6OivSPMKoOBlnFUF0360jv
         hrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=EwW1ad9aaDxzLEmHNXCm17nZVCt4Pcys+G0syr6CYU4=;
        b=440ir/quFYZyt15wfbIlXFwlQkQ9NIsCImhTTG5edpYfa+l4jR4Dk0UQjOqn6Z/z4w
         PDnwSyeEyMsJoTkIa/bXxh1Adpv2bu+PtdoQq9PfzjO1CbK+T7/Hs7FIPB90JhDHK7S7
         pOcO223kHvF8xAk6z05AhoV4GqxE27f6t++xV2O65UiX4+Vj/dxCPtfxqnOcH9NJ1nw2
         G04kyXb6v1gWVHOGVa917K5WZ7lnk0tSR2chbOgJ0KH9XNZXq1+ce6hEOaiz773F+Hlf
         NWiEHIEdXNoNXz03EAieQ3PTxs+wfb3wbTqtzCJyqBIMVUGY09Ub1pxCxPpjMOOcu49v
         ir6A==
X-Gm-Message-State: AOAM532K15C02cabat/R3w+aB3r0QRMmaF0gHa8wClGQqoF1F9niY4G+
        HoC/1YQevs2fmsTzhEuuxbc=
X-Google-Smtp-Source: ABdhPJzaupvlwXtXqw0xVsZYl8+D4TG0XQAcXBJlL9VMI5sb6HAslbzowG4xVttrjHRpZ3on1TdiAw==
X-Received: by 2002:a05:6512:1281:b0:439:f0fd:c96c with SMTP id u1-20020a056512128100b00439f0fdc96cmr19857951lfs.102.1645611444290;
        Wed, 23 Feb 2022 02:17:24 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id d5sm1613102lfs.307.2022.02.23.02.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 02:17:23 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v5 2/5] net: bridge: Add support for offloading of locked port flag
Date:   Wed, 23 Feb 2022 11:16:47 +0100
Message-Id: <20220223101650.1212814-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
References: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various switchcores support setting ports in locked mode, so that
clients behind locked ports cannot send traffic through the port
unless a fdb entry is added with the clients MAC address.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f8fbaaa7c501..bf549fc22556 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -72,7 +72,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 /* Flags that can be offloaded to hardware */
 #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-- 
2.30.2

