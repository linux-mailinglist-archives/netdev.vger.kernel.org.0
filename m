Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197F64BBC94
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiBRPxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:53:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiBRPxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:53:16 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCA62B319A;
        Fri, 18 Feb 2022 07:52:58 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id i11so6294968lfu.3;
        Fri, 18 Feb 2022 07:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=C074Ts6t1RuR/7tYyDWuvKC2BHBuBtLTBdnTVQAyV3k=;
        b=iwfCoLafgG9YVKvV7zo8I8SL8yF6TiOcM8BFJrMe1xkCw4BADvUTqPrpxBwb/uipbS
         o6MKYERLMZeEr1Q2SvSAg4Wcv0g/ma3fWCOa9IS/Be+/8LzmTrfFnv9hFVMkZB/DxHGT
         hRXi7MSSw14vn241aMy0fXph+8OwcZygLZ6WTabZWP4THo1j83Pj/Hpzai6goXcwe15u
         I1hl2KQNdzbFrfQgjZpGtWw7p4RwIPKyirv1BCmSsisKbh1Zu+8cQN5IT57459jAzh6u
         1/osLqneFyc3ffWmmJKZmdnoOaguwG7Ad44FGamwS2PP9DHtHsFW55YAeGQ/Xb5fxSnj
         7OcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=C074Ts6t1RuR/7tYyDWuvKC2BHBuBtLTBdnTVQAyV3k=;
        b=1RpYkhpMmULR494SwkS3JBbzo0ZDc/nyQ7wfZxA/5YMt6Vp+NU/5RLf5WtAs2/AKwf
         sazlmIE6PNS5Uw8iSRdrK7K9DQUQ/xSRx/+iC551EwcZK/QWywvy4KQYhZBXyYaVDUhB
         c3FmXZv6UR1O4MktcL44FzWmeGrLDfMPIML3dsi6pYqFKl+giaG2aImXlFS17h3iiua+
         +x2KZn2jSDs8wBOWuxe8fO3rRyIIELR4kn11xGJTJK9uFSfEyDEm1IyiOCBaQhLMinc7
         7DTW8a2liXx2me8iIWYHMi0UwqR32QAJrl5ADuv/wJ0/5l9H1tI0VXeGEzcomIB0Xo9E
         N/ew==
X-Gm-Message-State: AOAM532ocPcCTP/kQnR9oN/5DJ6Ojrx1zR4a4CK0DLK6DC/6fLtK9edI
        oAV5yy1UNrChT32jxX2QrcWmOjTlG50ogegRLak=
X-Google-Smtp-Source: ABdhPJz4M8NgeOX3Pm7KGmB8ZCsSG+kHcEQK+VJJrpAaHwURKRhLlaxHlzEd735Go8HQL30Eq6v/Lw==
X-Received: by 2002:a19:f009:0:b0:443:b0ee:8599 with SMTP id p9-20020a19f009000000b00443b0ee8599mr3589761lfc.34.1645199576681;
        Fri, 18 Feb 2022 07:52:56 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id v11sm295453lfr.3.2022.02.18.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:52:56 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Subject: [PATCH net-next v3 2/5] net: bridge: Add support for offloading of locked port flag
Date:   Fri, 18 Feb 2022 16:51:45 +0100
Message-Id: <20220218155148.2329797-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
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

