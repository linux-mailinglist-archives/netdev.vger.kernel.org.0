Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EDE4BF961
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiBVNaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiBVNaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:30:08 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38401136ED6;
        Tue, 22 Feb 2022 05:29:43 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id m14so24777885lfu.4;
        Tue, 22 Feb 2022 05:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=Z+hbLNvF0Nhve3XBOMxW8KtWdx8aJiHJ43sZ0z9sw1E=;
        b=qO5Sru+DZqGzH4+Za4ahOJYJK/duIXhEZA7V/VVfsVzC5RwvI/uX/oPlWpfAzaWqzV
         107TBki28TfJolkKkSAvh2IFNfqHT6f62lZ5mLMFDNS7EdYGIV9NwM9Kl6a9RNdOP5i+
         nkW26DL79MK2HzK5rsy47tYU7EQg9PhP1SyQYgc+NI92/MlgTF12CK7J5s6f0No+Zmop
         EZ/R9GrW/mbWigROLcu1w3qZBUYAnNWHE88/fvsrV4YZR4UviqsCv10r8EbOKrEyAXBg
         iEV+DlFF7X3WoMjYQTX+pDbeetysz/YOzRmQtJ7JhPY4Jm2SZDPu7RxYZTYvtUgWYyBi
         7kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=Z+hbLNvF0Nhve3XBOMxW8KtWdx8aJiHJ43sZ0z9sw1E=;
        b=MAcVYsT2L3j2FuDo+z+UhgvNLCdTowATEgCmXteuY2D3w4HygLnuQECRRihs5Zy7sV
         cpgF60Dk0vLYmklWA+hWwnuMuPfdJbiJDhUx+QJBPYAT29SLjRNn6RmhV2Z1MtgU9Jyn
         67JcXkRbSv9GGIwz+x6AiIhiENafZI5TQokS+D9HKhpvNcTQS2oFnvvhqM0I5RbQbW6u
         45q5L6BBOmbcbbX3rYdqAsNkrQJ90FGi9TTT4KTKdvmKBGPBpR15oN/mnSgOrkbGr9oZ
         qsa3V/ABZcSRRmjRr8hEdSEyuRbcWnVfhLIJQ7H+0eqbiuvGjUqOzAQp9CminYwiBXBf
         Cj/A==
X-Gm-Message-State: AOAM532q0nLxRAcp+ZBvqcJdINV10ze0u2WSE60h4dgIp+WmM0sV6Xw5
        GZljImM2DwDc2/kteRJzoe4=
X-Google-Smtp-Source: ABdhPJwolKKl+qChVGRAvJCxdChiH+ZkxIpLXFQkRe02q8DltrOGJJiqQzm+Xu0ntqAFve+Idw9aCQ==
X-Received: by 2002:a05:6512:3f08:b0:443:3d74:2461 with SMTP id y8-20020a0565123f0800b004433d742461mr16779614lfa.461.1645536581597;
        Tue, 22 Feb 2022 05:29:41 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id e22sm1703685ljb.17.2022.02.22.05.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 05:29:41 -0800 (PST)
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
Subject: [PATCH net-next v4 3/5] net: dsa: Include BR_PORT_LOCKED in the list of synced brport flags
Date:   Tue, 22 Feb 2022 14:28:16 +0100
Message-Id: <20220222132818.1180786-4-schultz.hans+netdev@gmail.com>
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

