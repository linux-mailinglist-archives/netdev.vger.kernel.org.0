Return-Path: <netdev+bounces-253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D19F66F6672
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04A1E1C20FBC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C564A2A;
	Thu,  4 May 2023 08:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F22108
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:00:22 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679182728
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 01:00:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so14474724a12.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 01:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wetterwald-eu.20221208.gappssmtp.com; s=20221208; t=1683187216; x=1685779216;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D/DjbZvCvofx+Tj+rLu8xubteNfMiQhOc00PCHdavuQ=;
        b=HhckALLG2sNTpMXbgVdoUEEbC37wsx8yFCgo8A4N26tD8yqnp/IcfCpJkS0EYXdN2c
         KP6rCr06jkCg1EhdX/oc1u0eUFswa9gFIMskGiQ2uwux6g7dPq2z8Eamy76C/zol0DlQ
         Axlj9QYyFm06ibM9ZS2+Q3FBTomHvY5ORXbVWyMwsAJvKXNW1pe3ER8wnKFc4G2Gps7D
         9z7Ito2tAfnJx+FhHosSjT5JdvJzg1C1Ivuovvi5Z43Rn8TQyJvwYaFa+RMGkeYo13zK
         HWfL1Je5cjgenTT2X0gQk2ApdmnW15X9B7kFktLWAZp7K1ZZoCzUzwkJCLmDImSevBOg
         AGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683187216; x=1685779216;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D/DjbZvCvofx+Tj+rLu8xubteNfMiQhOc00PCHdavuQ=;
        b=XLqb3R89pdAKr6w0wFhtjKKgWgSbIX7vmx+MVFYZZUcYzJwDtPtU0ui3ACtjOSN49f
         n87AGPn6tcDl1OQRqI/cFsZG6Hwhxx8egy2Jf07yUgsedpsgUuNzIQbYJUMsHtlLTGp6
         ggX7P1hOOBR+bVEOG/I/tMCvauNmJjaYpPP1JFwwEtuXp/7uHwV4rjZbcNZ0gEaUOXhc
         Y21PgDezU7ElH0AjxEFs74XBo1tT37oyD+mwwDsE9va+BWPtcJQcMyQqkF6UU8SMU9qx
         M5jLKyD0pE5XJKNixEEk8KPULuvnAb4Tt8L3zEJlrVACsbUvBkQ1x664ZuZyp4Aro6aC
         tAlg==
X-Gm-Message-State: AC+VfDyXJGKnw+Qhhf8iHKWx3D4Gp/yBfa39jolvChUEqrZrV3YfEAYk
	URBx27WpEyJDOTwOBpN4/IGtCkYkgOeqbM67CY2bXQ==
X-Google-Smtp-Source: ACHHUZ4alPbKmCmqk6Lpl1JEvX8t6ilAV08qMfCljgdTdr4QswmON1TfYxPtihfgVwxrirPldzTk2j1f5QGQre5+Btc=
X-Received: by 2002:a17:906:9b8b:b0:953:483e:93f8 with SMTP id
 dd11-20020a1709069b8b00b00953483e93f8mr4098119ejc.16.1683187215795; Thu, 04
 May 2023 01:00:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
 <20230503195112.23adbe7b@kernel.org>
In-Reply-To: <20230503195112.23adbe7b@kernel.org>
From: Martin Wetterwald <martin@wetterwald.eu>
Date: Thu, 4 May 2023 10:00:04 +0200
Message-ID: <CAFERDQ3hgA490w2zWmiDQu-HfA-DLWWkL4s8z4iZAPwPZvw=LA@mail.gmail.com>
Subject: [PATCH v2] net: ipconfig: Allow DNS to be overwritten by DHCPACK
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

This patch makes the kernel overwrite its fallback DNS by DNS servers
specified in the DHCPACK if any.
---
v2:
  - Only overwrite DNS servers if it was the fallback DNS.

 net/ipv4/ipconfig.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index e90bc0aa85c7..aa90273073c1 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -179,6 +179,9 @@ static volatile int ic_got_reply __initdata;    /*
Proto(s) that replied */
 #endif
 #ifdef IPCONFIG_DHCP
 static int ic_dhcp_msgtype __initdata;    /* DHCP msg type received */
+
+/* DHCPACK can overwrite DNS if fallback was set upon first BOOTP reply */
+static int ic_nameservers_fallback __initdata;
 #endif


@@ -938,7 +941,12 @@ static void __init ic_do_bootp_ext(u8 *ext)
         if (servers > CONF_NAMESERVERS_MAX)
             servers = CONF_NAMESERVERS_MAX;
         for (i = 0; i < servers; i++) {
+#ifdef IPCONFIG_DHCP
+            if (ic_nameservers[i] == NONE ||
+                ic_nameservers_fallback)
+#else
             if (ic_nameservers[i] == NONE)
+#endif
                 memcpy(&ic_nameservers[i], ext+1+4*i, 4);
         }
         break;
@@ -1158,8 +1166,12 @@ static int __init ic_bootp_recv(struct sk_buff
*skb, struct net_device *dev, str
     ic_addrservaddr = b->iph.saddr;
     if (ic_gateway == NONE && b->relay_ip)
         ic_gateway = b->relay_ip;
-    if (ic_nameservers[0] == NONE)
+    if (ic_nameservers[0] == NONE) {
         ic_nameservers[0] = ic_servaddr;
+#ifdef IPCONFIG_DHCP
+        ic_nameservers_fallback = 1;
+#endif
+    }
     ic_got_reply = IC_BOOTP;

 drop_unlock:
-- 
2.40.1

