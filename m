Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F56100222
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfKRKKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:10:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44913 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfKRKKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:10:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id e6so1441297pgi.11
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 02:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WbnLjmc6Hxd56XRNsfLdxcxIPwkIM2UdpYuPdmugWLs=;
        b=urJO4M42Sev2hw9/hT4RvMDPfFdC0+HJOqcDqXAQI7m5DobLF4XAMoJumLGtJX+dq9
         FMxUOiOItX4DOPYxKICpxq3BL3yNCDOaFgmkwhgruCwsqwm/IzCvxh9syRAgWXzUx07S
         tL11QHyUmmrCeVt/Rw3y+lUTCurYsReqtS0k+hlDNdnYRA+RHCX12waFRF4fO50D41oc
         k7oZaS9ebrFmVdhZ88dL/1iP1N/n8zuzMGZ4ZhC8uGt878NGTxy69PWZyp3fCnC3mb7x
         T2N3wxbxW1OnFJn7Ny9ek1mDTg5HLpKj3zgE9iVRndn/RNtUY7yFRwPqAk9y5IquIj/O
         liIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WbnLjmc6Hxd56XRNsfLdxcxIPwkIM2UdpYuPdmugWLs=;
        b=F1A+gbG/Y1531mICxU17WsHb/y8LXvkdtXKxZNp8lwOzgQUL0ts1ck71fQON8Sk3vQ
         glkdTookcMl2VIQi86eYQzbWThWN4tZLY05jUAMZSF0IqUsZp4k2EeWt85/XEkwDnxqN
         P8qLE4f4d36t++jTicb2UzXBMD54+vr8XfgbZJoieZ9J/LIzazvZs2RrfTfjM7Sktfl8
         omBx4h1NL/ReV1LhDVbotw8yo4Y0mnhi+DtWc/ZV50TjHCUC3bfyLIxv5kog1e/vk/U6
         1Z3gxwYexlotPGuinb97Tb09uGzKSkUeMpIW+a4Dymm8bTolqW7COtBvpLTPQuXG4mC3
         fO3Q==
X-Gm-Message-State: APjAAAUxpv8iNNagdet8oTWyHhqrZ1MzYQBDG/hGxuenWx/rKzT8BjG9
        RMxxshkHkeF2zXQyK/Jvp2p0TC8n
X-Google-Smtp-Source: APXvYqwm6siFwDLw5VCkHSeZZKy4rXcJR7Vav+XzC4iVAOm86HxmCo6MWZZJMfweTwH07X/in24tGg==
X-Received: by 2002:a63:af1a:: with SMTP id w26mr29994299pge.251.1574071820691;
        Mon, 18 Nov 2019 02:10:20 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i26sm14128717pfr.151.2019.11.18.02.10.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 02:10:20 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com
Subject: [PATCH net-next] lwtunnel: change to use nla_put_u8 for LWTUNNEL_IP_OPT_ERSPAN_VER
Date:   Mon, 18 Nov 2019 18:10:12 +0800
Message-Id: <60ad49e50facc0d5d77120350b01e37e37d86c57.1574071812.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LWTUNNEL_IP_OPT_ERSPAN_VER is u8 type, and nla_put_u8 should have
been used instead of nla_put_u32(). This is a copy-paste error.

Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index d4f84bf..11f30b2 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -524,7 +524,7 @@ static int ip_tun_fill_encap_opts_erspan(struct sk_buff *skb,
 		return -ENOMEM;
 
 	md = ip_tunnel_info_opts(tun_info);
-	if (nla_put_u32(skb, LWTUNNEL_IP_OPT_ERSPAN_VER, md->version))
+	if (nla_put_u8(skb, LWTUNNEL_IP_OPT_ERSPAN_VER, md->version))
 		goto err;
 
 	if (md->version == 1 &&
-- 
2.1.0

