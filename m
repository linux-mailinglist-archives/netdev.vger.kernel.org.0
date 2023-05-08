Return-Path: <netdev+bounces-920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D486FB612
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67BE428106C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AE5610C;
	Mon,  8 May 2023 17:46:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9921217D1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:46:36 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41013ABD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:46:34 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f193ca059bso30849375e9.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 10:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wetterwald-eu.20221208.gappssmtp.com; s=20221208; t=1683567993; x=1686159993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rLV84bHjE1EEB97rJAyI0QjNGBwYHzVjRowlOVBrcHY=;
        b=MUR/UmbZLtPB/Sgv3NHevLSME1L5i0tWGbmVCCySY7YtpZgijdKcX/RHm+ilfl4rQm
         AMpDgBMa4p/ShY2vBU5r1sH648F3UrPH7FyJtj6lJ0Hf6SrG2ve2Fx9zFEuZwyCrYkhH
         g5NkqnXuXG/Qc7unCSGudnJyJ2zjeqBNu19X4xspFiILdrH2mmpl+rXAbZrkZWh9xlgS
         rhsRblRTB6BXIFWEwhsA1ONTd687d3z5l+QzRlk6bn3npTd0XDBlrqTGTnHOMyqyS3OE
         NyTX9RHW4JuwuRTBWIltAESsVehL2I5RZ2Of4GOYYsRLv/Go8BwAmHpJm/XJdUTDwjRi
         1nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683567993; x=1686159993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLV84bHjE1EEB97rJAyI0QjNGBwYHzVjRowlOVBrcHY=;
        b=cDw7IOM3gOcARIm9noLdQYSr9JWylS1z1oJhgZLJsLBPMARd9jxoiPfgArfn8yEAb7
         KL9wd/7jrkGIcM0yFNlqOQem/xSVlUIBDRqBvL0mbnbVntwRvxZgHd1+sepcpKjqj1Yn
         BJbRJnZw5IauL7YqFL+clXt+3bUQ3C7oVIWQFLk0CuUyF48lAU+lSaYmLVMbL/G5uirX
         5MxZbfaFJF2NXPrmmJG51ozWXeZ+y1VYZwBBDhFF3a8Kvqui6bAj5JHHJNER1J5PDUKt
         uSaWTCRSEMDucEhblWwm/9fpv/rr5c2nC07fCnaT3GfqiYKJm7U6ZWkdhFNGS7GVZmfd
         9ZQQ==
X-Gm-Message-State: AC+VfDySeW/vUDeTPIvwpa8Yt7suFzKZYckG7fz8vNpKvyuMUnT9cnpR
	YCpvzcRlUQHPFItCEbh+QixZMebzGtQLyab4h+zRgUnM
X-Google-Smtp-Source: ACHHUZ6Nb7Pg2NC5mvZ88Gvn7+TgT7TbZOK/1vqCqGsPEYzf+yMMzpT1IL7AzCMw1pwNJHsLyqLiWA==
X-Received: by 2002:a7b:c38e:0:b0:3f0:310c:e3cf with SMTP id s14-20020a7bc38e000000b003f0310ce3cfmr8056689wmj.37.1683567993192;
        Mon, 08 May 2023 10:46:33 -0700 (PDT)
Received: from Halley.. ([2a01:e0a:432:9c10:3e58:c2ff:fe72:d814])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c290600b003f18992079dsm17410025wmd.42.2023.05.08.10.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 10:46:32 -0700 (PDT)
From: Martin Wetterwald <martin@wetterwald.eu>
To: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	dsahern@kernel.org
Cc: netdev@vger.kernel.org,
	Martin Wetterwald <martin@wetterwald.eu>
Subject: [PATCH net-next v3] net: ipconfig: Allow DNS to be overwritten by DHCPACK
Date: Mon,  8 May 2023 19:44:47 +0200
Message-Id: <20230508174446.55948-1-martin@wetterwald.eu>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some DHCP server implementations only send the important requested DHCP
options in the final BOOTP reply (DHCPACK).
One example is systemd-networkd.
However, RFC2131, in section 4.3.1 states:

> The server MUST return to the client:
> [...]
> o Parameters requested by the client, according to the following
>   rules:
>
>      -- IF the server has been explicitly configured with a default
>         value for the parameter, the server MUST include that value
>         in an appropriate option in the 'option' field, ELSE

I've reported the issue here:
https://github.com/systemd/systemd/issues/27471

Linux PNP DHCP client implementation only takes into account the DNS
servers received in the first BOOTP reply (DHCPOFFER).
This usually isn't an issue as servers are required to put the same
values in the DHCPOFFER and DHCPACK.
However, RFC2131, in section 4.3.2 states:

> Any configuration parameters in the DHCPACK message SHOULD NOT
> conflict with those in the earlier DHCPOFFER message to which the
> client is responding.  The client SHOULD use the parameters in the
> DHCPACK message for configuration.

When making Linux PNP DHCP client (cmdline ip=dhcp) interact with
systemd-networkd DHCP server, an interesting "protocol misunderstanding"
happens:
Because DNS servers were only specified in the DHCPACK and not in the
DHCPOFFER, Linux will not catch the correct DNS servers: in the first
BOOTP reply (DHCPOFFER), it sees that there is no DNS, and sets as
fallback the IP of the DHCP server itself. When the second BOOTP reply
comes (DHCPACK), it's already too late: the kernel will not overwrite
the fallback setting it has set previously.

This patch makes the kernel overwrite its DNS fallback by DNS servers
specified in the DHCPACK if any.

Signed-off-by: Martin Wetterwald <martin@wetterwald.eu>
---
v3:
  - Submit patch to net-next instead of net
  - Indicate target tree in subject
  - Repair corrupted patch
  - Move ic_nameservers_fallback outside of the #ifdef
v2:
  - Only overwrite DNS servers if it was the fallback DNS.

 net/ipv4/ipconfig.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index e90bc0aa85c7..202fa1943ccd 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -173,6 +173,9 @@ static int ic_proto_have_if __initdata;
 /* MTU for boot device */
 static int ic_dev_mtu __initdata;
 
+/* DHCPACK can overwrite DNS if fallback was set upon first BOOTP reply */
+static int ic_nameservers_fallback __initdata;
+
 #ifdef IPCONFIG_DYNAMIC
 static DEFINE_SPINLOCK(ic_recv_lock);
 static volatile int ic_got_reply __initdata;    /* Proto(s) that replied */
@@ -938,7 +941,8 @@ static void __init ic_do_bootp_ext(u8 *ext)
 		if (servers > CONF_NAMESERVERS_MAX)
 			servers = CONF_NAMESERVERS_MAX;
 		for (i = 0; i < servers; i++) {
-			if (ic_nameservers[i] == NONE)
+			if (ic_nameservers[i] == NONE ||
+			    ic_nameservers_fallback)
 				memcpy(&ic_nameservers[i], ext+1+4*i, 4);
 		}
 		break;
@@ -1158,8 +1162,10 @@ static int __init ic_bootp_recv(struct sk_buff *skb, struct net_device *dev, str
 	ic_addrservaddr = b->iph.saddr;
 	if (ic_gateway == NONE && b->relay_ip)
 		ic_gateway = b->relay_ip;
-	if (ic_nameservers[0] == NONE)
+	if (ic_nameservers[0] == NONE) {
 		ic_nameservers[0] = ic_servaddr;
+		ic_nameservers_fallback = 1;
+	}
 	ic_got_reply = IC_BOOTP;
 
 drop_unlock:
-- 
2.40.1


