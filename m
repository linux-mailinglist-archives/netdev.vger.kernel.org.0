Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD07381B04
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhEOUkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:40:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231463AbhEOUkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 16:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621111136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RjAWv7j/zHfhk0YuuOMHIejR7YmGA5R8BOsaPxYr0kQ=;
        b=iC4MK9UWM+xdb0TPBGyvYy/9wSSexD1CNPRg5/tRO9tya6zISQNMZiC99pz7HKOSE/mvSe
        sxJtBNzlSH+y9Dps9vel3HW+fIL9GV1qGHtv/bWO4FcU+5Zw3A08CvQcGS78HO0JwfBS5s
        e3CLl8Vlz+eJRRraNt2Oxw/J9MgITJY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-VwWmsgAwNKCWy3wsaEgLOg-1; Sat, 15 May 2021 16:38:54 -0400
X-MC-Unique: VwWmsgAwNKCWy3wsaEgLOg-1
Received: by mail-qv1-f69.google.com with SMTP id q15-20020a0cf5cf0000b02901ecb7d57bccso1945916qvm.17
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 13:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RjAWv7j/zHfhk0YuuOMHIejR7YmGA5R8BOsaPxYr0kQ=;
        b=rgKYpXizLQAlwL/gJKxzQKTc8Cz6HRl1goDY1OlSk5d7QZcHgrECzc2jo7uOAYITfP
         nTpX6AhlP8V7XukNJElG7ceuZ2Hh6pENrSnpdCpAB2KKbcKUUq6kCSNPMr92O5SJlHh1
         nVgmMNtKWcTUiIYeHeJT5j2wEQatcgxeN8nHrdJ54SpsWTQvfPzWYyHvHWDLZPHJ0yVJ
         mQDoh6PjlSs/QlYr8VTLQ5vT6FzVkG0JgBMQod9MAfGLq5lIM3Jpgkb9l8XVgaTW0trR
         rkhQerNsOc6IUiKB6TKzpnE0u2FS9XTUu5r3iemabs8uy4m3rIAmnPg2RTMhmJ/z66xw
         B8Hw==
X-Gm-Message-State: AOAM531PPHWZ+G+50xRudpazVjY6FCi5Ppn2Cmz6ODqeF92RRr0dXNst
        HDvxwcPJl7YXTb4gqeoFnspTksCe9UWYi43/ca2ZDJQd0FVvu+BNLaH+Gn20qLyVrx7I3mGwCCr
        zXl4aT3Cz/c+muk0K
X-Received: by 2002:a37:ac7:: with SMTP id 190mr48255955qkk.452.1621111134136;
        Sat, 15 May 2021 13:38:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDfCuUeK5i/u8HhHnT8Ny2Fxo8BN52QD/hnQkLJapiZWuY6Bw27qHDHt1LbNXH7Dm/5CMhFg==
X-Received: by 2002:a37:ac7:: with SMTP id 190mr48255944qkk.452.1621111133948;
        Sat, 15 May 2021 13:38:53 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id u27sm7379685qku.33.2021.05.15.13.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 13:38:53 -0700 (PDT)
From:   trix@redhat.com
To:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: bridge: fix signature of stub br_multicast_is_router
Date:   Sat, 15 May 2021 13:38:49 -0700
Message-Id: <20210515203849.1756371-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Building with CONFIG_IPV6 off causes this build error

br_input.c:135:8: error: too many arguments to function
  ‘br_multicast_is_router’
        br_multicast_is_router(br, skb)) {
        ^~~~~~~~~~~~~~~~~~~~~~
In file included from net/bridge/br_input.c:23:
net/bridge/br_private.h:1059:20: note: declared here
 static inline bool br_multicast_is_router(struct net_bridge *br)
                    ^~~~~~~~~~~~~~~~~~~~~~

Comparing the stub with the real function shows the stub needs
another parameter.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/bridge/br_private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f9a381fcff094..9fd54626ca809 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1056,7 +1056,7 @@ static inline void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 {
 }
 
-static inline bool br_multicast_is_router(struct net_bridge *br)
+static inline bool br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
 {
 	return false;
 }
-- 
2.26.3

