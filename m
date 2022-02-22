Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59EB4BF95E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiBVNaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiBVNaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:30:03 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C426E15D3B8;
        Tue, 22 Feb 2022 05:29:36 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id v22so17637895ljh.7;
        Tue, 22 Feb 2022 05:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=EwW1ad9aaDxzLEmHNXCm17nZVCt4Pcys+G0syr6CYU4=;
        b=pZe7+VYM2Ch4tnW0vNrVk4kIXpos0UkPqBnqRz0liSSCmjg5WR46ijNkTFp1HCgHFG
         G7xtFljcmI1+/ai2y4SDM+SuB0bYJ6ujqEiFCprXncNFqQuO3QTWAYzw1L2HjZjT4H3N
         v/0RVdM4I4DpTyyct5KApt+YAfxnXRgaxNJUJAMngBXVw0Ri55ZE9X1fL2nhUd6LZcrn
         skDkxgDKgNOhZFP6P6RWDaFGYspOza6cihrkcaaDHNr72RtORhJmLoMNX/dxH0eZmcRY
         MNvzvYmKHTdpW8/Glo8PDfXtx+xP4+15Juf+9hRUfW87XIYD64cyFvB8sH6Ie98g2nc5
         gR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=EwW1ad9aaDxzLEmHNXCm17nZVCt4Pcys+G0syr6CYU4=;
        b=bftf3bZUv7exZUErG+O9ivP51fuo+zaRG4OZ8Yr5Koo/gKCOPOQCIuYjXWoDRtVMeA
         a1KLdTHxDA+W69FOEwbouCRDYOcJchjlV1McC0hZVAKNdiMMmEahyX6Gep0ld4sWOs4Z
         eFqOLLIszjP7e8z5qR2vYGB/ayswaANPWU20c+dPKahyvdF9+O8J6gJTarIqzwtc/UhT
         oGA8kavvB1N5T7culGT3IJDfY0W8YTH4BvQw7XAyWXvdXS4DVwukLQUVQpwp0FYSYBGX
         Av2QRAmKwkGWD2u8lkpqlkFe09iqqFti+i9YaXkJAU7aOGqksWjzJQPehsZqwkyihN1g
         MTUg==
X-Gm-Message-State: AOAM530+7N4iblDikUGjppB3DU4iV0DBVNsXIs/UogwqwJ/piTXPszfl
        OfIPW/4dVwM23o/8b+jox9c=
X-Google-Smtp-Source: ABdhPJzHDYyISKgjREvcwBLgHfMKpwDFHOum7zloAcofWXBg+CYq18JOmAuV0xwIBhhLStIP1a2GLQ==
X-Received: by 2002:a2e:8752:0:b0:23e:d951:4184 with SMTP id q18-20020a2e8752000000b0023ed9514184mr18296155ljj.410.1645536575198;
        Tue, 22 Feb 2022 05:29:35 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id e22sm1703685ljb.17.2022.02.22.05.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 05:29:34 -0800 (PST)
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
Subject: [PATCH net-next v4 2/5] net: bridge: Add support for offloading of locked port flag
Date:   Tue, 22 Feb 2022 14:28:15 +0100
Message-Id: <20220222132818.1180786-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
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

