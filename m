Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371CA4C101A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiBWKSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiBWKR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:17:56 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16F37CDFB;
        Wed, 23 Feb 2022 02:17:28 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e2so20437757ljq.12;
        Wed, 23 Feb 2022 02:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=Z+hbLNvF0Nhve3XBOMxW8KtWdx8aJiHJ43sZ0z9sw1E=;
        b=EquzZhxnieCrk3INNeTDu6kmQ8PDFht+473pRAMO2lVGaI5CtlUgrT19oecm4EbYCw
         hD6M14xHzJXWrndGSkPG4myjk46PwiuoXhCGn8s7I6u/nBqTi7YXbUL+s4VLsKyn6XfO
         m1a6muPJyaMEX4pfdpXdQKf1dd9hLUs7Xs3DHZqrBVjJG9yWu3ZEpGhxlQWbtusDskTG
         g/Cv78MImpgV3i0Br+nrhxXoFWVhYV98vIQ/VJNd17kXrgnupVZhcSJCNj0WYRqveCCB
         JSvyMH/eyilIIJn2yp4wfdhMPnMavV+Peq3Z4de/JtuoNGG2lzZzmOFfQXnLsxAPY5u4
         WPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=Z+hbLNvF0Nhve3XBOMxW8KtWdx8aJiHJ43sZ0z9sw1E=;
        b=jEclS4owtQvsr4w2GlLyprh0BeXw16qig3vHuBdqHzncoz1djWlu0+7L+84P0zIM5e
         zOzXEHaOhk84EJEwd1rOj/NAFtl35/gPG+drMobIEYCjO75WPvCCrSvbU2c5oh2PxtRk
         UVXDyG6kEztY4t9xcqx7dE8+F6YxcsHovLVvxKr5algJxbggeZ/UlmGmAxsklxf1RYJW
         dmXkI88+5Z3CQSrCARnvLh0lyGEpk9C7XBsFeDUYbcXUQm4xHOZwcemNCCS/8iBOaZob
         lhLuVMvsnCHyGcV0/dMUPUmQbO5cpmrrEnZncDqc3NJvOJlwjBrutO/DAxkBXj8bpaXE
         e/nA==
X-Gm-Message-State: AOAM533vgalTsIZCWht2T6pSevpV05/wPW2s6HcT4GJUP9cVsEBo/ie8
        W9MSZocKfME2NP1CUfZ1mus=
X-Google-Smtp-Source: ABdhPJxCjF1OGtpiBw3vg13o77EowmB9BU3Qbo6AYEM19Kfrt9DUszhfgV9BxvJGm5kBwmiinUx70g==
X-Received: by 2002:a2e:819a:0:b0:244:c4cb:5141 with SMTP id e26-20020a2e819a000000b00244c4cb5141mr21329064ljg.477.1645611447205;
        Wed, 23 Feb 2022 02:17:27 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id d5sm1613102lfs.307.2022.02.23.02.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 02:17:26 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v5 3/5] net: dsa: Include BR_PORT_LOCKED in the list of synced brport flags
Date:   Wed, 23 Feb 2022 11:16:48 +0100
Message-Id: <20220223101650.1212814-4-schultz.hans+netdev@gmail.com>
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

Ensures that the DSA switch driver gets notified of changes to the
BR_PORT_LOCKED flag as well, for the case when a DSA port joins or
leaves a LAG that is a bridge port.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..01ed22ed74a1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -176,7 +176,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	int flag, err;
 
@@ -200,7 +200,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 {
 	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	int flag, err;
 
 	for_each_set_bit(flag, &mask, 32) {
-- 
2.30.2

