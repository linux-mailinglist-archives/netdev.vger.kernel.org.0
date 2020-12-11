Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EAD2D7597
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405943AbgLKM2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405459AbgLKM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:40 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F30C0617A7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:22 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id o17so10148984lfg.4
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PbSueUnmqhD9bJH82MdqcmqtkSwcE+aeOWzZReRpbhw=;
        b=Ezct7sHK9j1kNVsP1b2bcKRz9dqSCFuYt5hutZKRrPN+3Iq6T1gbAWTAfgIArcgKgQ
         mb15ctVg37GxQHH8qRliE0PkpHDOsWX6+2hOrGw2gWuxBcMy/w8PkENeWFahl8h12N3t
         praGQBzSYHWyS7JNICqwZaKbUEZXFwFgIFy9+mMUE0u8wLNmKquR5m/SrD8nKuYsjq58
         dfKNwqmBZSGzPxbydfj8pzX2mLz4uE649MSd+OiKJnWVF3ruFVi5+0BUj9qZU9orReuV
         WHavquuzW10SICqZp/CxaL4dcoSgFC6chkrro6baxXTEwU5R+yyMCiqY5HQQ5LTMopx9
         4BqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PbSueUnmqhD9bJH82MdqcmqtkSwcE+aeOWzZReRpbhw=;
        b=lqtwH00+weLgGRsQv1qgHi3KPz7YOU8qDsL29ZwXOme/mOKIL+mKpkyfjNhIV734TU
         EU+QHt4lp/jEyeZSwO+KxUYJO0JF+MJtdBrEpDSr55yrWf6kzw5UHfkClB9taB8csaEZ
         p8Bz4ODqS3nhmHqQzT9vc5ErYGmG0HxJc2st8R39qCRTPCn19N2RdRxr3q993egD2J4k
         12qIA/B8qxBf98SY4/jPi/tpHuo9ORdsLQoHPQh2B6vqUxtKwa0fCggcSWE9z/g4uPMi
         svXLlmPivTy+2rMfeJnF5EzZh8u3uA9kEoykn0/Bbu1t2lOkaRMyebzQ1hwENF7+4n3M
         j+gw==
X-Gm-Message-State: AOAM533m7KImBn15hfUGH7CQ4jf9AxDgsvSzgsCfI+DPZF8XH1qfjV7e
        7Ll2ay0tLxLiNpTfvJC416DU8R+/YhLn/A==
X-Google-Smtp-Source: ABdhPJxakI8eRH6zTwGComOJmjWPs0oIa44vGQGXtnszh4RO+AdvYPYQ40d0/mlQ7Q4+ydBrotoHDA==
X-Received: by 2002:a19:7b02:: with SMTP id w2mr2838775lfc.37.1607689580543;
        Fri, 11 Dec 2020 04:26:20 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:20 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 07/12] gtp: use ephemeral source port
Date:   Fri, 11 Dec 2020 13:26:07 +0100
Message-Id: <20201211122612.869225-8-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All GTP traffic is currently sent from the same source port.  This makes
everything look like one big flow which is difficult to balance across
network resources.

From 3GPP TS 29.281:
"...the UDP Source Port or the Flow Label field... should be set dynamically
by the sending GTP-U entity to help balancing the load in the transport
network."

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4a3a52970856..236ebbcb37bf 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -477,7 +477,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 	__be32 saddr;
 	struct iphdr *iph;
 	int headroom;
-	__be16 port;
+	__be16 sport, port;
 	int r;
 
 	/* Read the IP destination address and resolve the PDP context.
@@ -527,6 +527,10 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 		return -EMSGSIZE;
 	}
 
+	sport = udp_flow_src_port(sock_net(pctx->sk), skb,
+			0, USHRT_MAX,
+			true);
+
 	/* Ensure there is sufficient headroom. */
 	r = skb_cow_head(skb, headroom);
 	if (unlikely(r))
@@ -545,7 +549,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 			    iph->tos,
 			    ip4_dst_hoplimit(&rt->dst),
 			    0,
-			    port, port,
+			    sport, port,
 			    !net_eq(sock_net(pctx->sk),
 				    dev_net(pctx->dev)),
 			    false);
-- 
2.27.0

