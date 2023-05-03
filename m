Return-Path: <netdev+bounces-135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B5C6F5593
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 692EE1C20E67
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71A1D2F1;
	Wed,  3 May 2023 10:07:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F8ED2E7
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:07:13 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1094C00
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:07:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bc1612940so7746691a12.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 03:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wetterwald-eu.20221208.gappssmtp.com; s=20221208; t=1683108424; x=1685700424;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FvY1iB10ETyrHnUXN8mM6pYNstiGe/MefiCTLkYgMZg=;
        b=be0uvJtLz+kXBpzX9ERHNgOWRWhn6LxTweqnEhS7oHCJZuJgzN8n0Fw7/QmsbUHotU
         NrHL1mtY0RbR28wtC2eLnCz9IMCdfZURcK7mzBc7CsZa+noscbP78o7VATOAhQcZy3Zn
         39WH0EP1Ib+NIxkF5YxbIdNdWTCEtB9bu8ipE3B3IHCq1UBp2wCYiXkVj1rg9Trg1hRR
         +z5cd+dYaMw9A0GeqoqCetljsRKI/4yCRUr8e5aUanDPI1Z9ul7a76NG6FCybMUXYMUb
         8tpiXblXBKC/FKkhNR6zg8TacFmu3b51AMYKp0TwobKbA/pi89LRLZOn4m3jHTkXcVYQ
         Xpaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683108424; x=1685700424;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FvY1iB10ETyrHnUXN8mM6pYNstiGe/MefiCTLkYgMZg=;
        b=Zccg5i+bIe7l0p3WNY5ymx0bLi6ioacUYFIFVD5O36zlfNtz+ELBIGmgzay36M/NjU
         KIrNtlMG+OGzsy3wmmqZJsKEx0aeFxq0UHY41Nnt/0Tilbh3b0Ai727q+x07c16t1EE2
         hCvZhFzlN8RphCP5FLYxRXowBfItvCiUizrF6Z7c4ksOHGs3cHSx74DL2z2wyB1iQzU3
         M8r1kDxvsBRaaAB05miPF+fz5Z68MEvjBW4gXqgkRRpX381Bj8LCJpDhbrEdepZXJSAe
         RwuQjF8gkNQVrvgGuU0XKfDkbVgBqXI9Eq/z3qrNjI2QPpuzJ5p91JIVK3t5qQOAVqtU
         +tog==
X-Gm-Message-State: AC+VfDwU55DmUnI8gVpyOwV+s/wFve5mIGNB+Xzw3I6i1aErtD2JERIj
	UxKr+pkVDRCcQQQolk0i6+8Kvpbw1SQ5kxH17zP0278KPSm7m53ZVpKlvA==
X-Google-Smtp-Source: ACHHUZ53C99XGb5yRJQMa3Wz+tDLOKvfEypmnIort4wbPgk5Z80A2zgxcRXxmUuS769t9zCh9azECM0510eunqtC1Qw=
X-Received: by 2002:a17:907:86a8:b0:94f:6627:22b5 with SMTP id
 qa40-20020a17090786a800b0094f662722b5mr2794647ejc.47.1683108424657; Wed, 03
 May 2023 03:07:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Martin Wetterwald <martin@wetterwald.eu>
Date: Wed, 3 May 2023 12:06:53 +0200
Message-ID: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
Subject: [PATCH] net: ipconfig: Allow DNS to be overwritten by DHCPACK
To: davem@davemloft.net, dsahern@kernel.org
Cc: netdev@vger.kernel.org
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

> Once the network address and lease have been determined, the server
> constructs a DHCPOFFER message with the offered configuration
> parameters.
> [...]
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

This patch makes the kernel care more about the latest BOOTP reply
received for DNS servers selection. A subsequent BOOTP reply wins (in
the case of DHCP, this makes DHCPACK win over DHCPOFFER).

Signed-off-by: Martin Wetterwald <martin@wetterwald.eu>
---
 net/ipv4/ipconfig.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index e90bc0aa85c7..c125095453da 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -937,9 +937,11 @@ static void __init ic_do_bootp_ext(u8 *ext)
         servers= *ext/4;
         if (servers > CONF_NAMESERVERS_MAX)
             servers = CONF_NAMESERVERS_MAX;
-        for (i = 0; i < servers; i++) {
-            if (ic_nameservers[i] == NONE)
+        for (i = 0; i < CONF_NAMESERVERS_MAX; i++) {
+            if (i < servers)
                 memcpy(&ic_nameservers[i], ext+1+4*i, 4);
+            else
+                ic_nameservers[i] = NONE;
         }
         break;
     case 12:    /* Host name */
-- 
2.40.1

