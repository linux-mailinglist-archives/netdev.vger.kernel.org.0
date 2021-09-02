Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF61B3FF178
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346359AbhIBQda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:33:30 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:49872
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242481AbhIBQd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:33:27 -0400
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4D79C40190
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630600348;
        bh=/hLx8OjGF7PEGI02/R3mR8wXhwB9eNDnHTpaX6K6wTc=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=fhgro4QwCmCZMpJJGWXDKowQ0ucTiHqc/4qSpFo9i1rp5iYkO7PP0p0sMG49/GGGN
         nmzkIoScZ4/4UcVwKutQ2XrxpoE/3rS6SlO3fDk6eep0wlbjp0o+2CzP75ZawHEFzt
         5Lv8VNVMIGU0gSzWjoBVXeXynb2kvgPW9Jpv4VM+83LJtI/TOWtKgRWUC90L9rqMS3
         vwGWiunCwsyvsyhCf/P6vNdnUvjDbw4W0yNSXqhgevXp8Qtjapt6En3hVcaXCVgN+o
         d2SI5IIc1EvvXTVHlZyq3Mom65WPTq0vYs7NYq66mJSlq0tEKEGLJBo/MkCn84voGm
         w7A+nwydpu4vw==
Received: by mail-pj1-f71.google.com with SMTP id g14-20020a17090a300e00b00186081195c2so1419841pjb.2
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 09:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/hLx8OjGF7PEGI02/R3mR8wXhwB9eNDnHTpaX6K6wTc=;
        b=oNfmyXfWlY+K/W06xjBvBo4w7aRg5ty2l5+eQHKnwmgtxX2yF8G4W8PpcuSC+obHap
         DRzD0jqkd+HH5ZAedTxnZd4rwSfiOGo+oBMbHfkj1Rla7MFT2v3flVU10uWwPTiR3+IE
         LENejQOOimJqblM4exeTeVvAiq07+d45DNv+DYcRMJCmB/4d8wP78J9lz+8dVYydZ5ls
         in5wSShrtKtnoOPq/EpBWV3g+CisXX8BQ5hMpJwOuj8RXH8yKwxExd9nDHbkXSTUQnxL
         4UpDUiRmLeBVCD1VvwF6Op3jE2GrKL6u7qI6nA/fewrCRqW7U2+cdOX3oBRyNQwX1ILM
         nJMA==
X-Gm-Message-State: AOAM53292oSaq18nZ07yIE/ssuTQaQlSa392TIRcNG24jSmHb3Bdl+Lv
        zPJ6tnPptpfw1y28PtzoLRM631jy2CdzltXnEhwrmUoVRsyqmDGRy3h4oVV4lah3oZaTqgendHx
        hGsPbnF9g9enzY9PeQFMJLVFmOYZQ1ucKVQ==
X-Received: by 2002:a17:90a:f695:: with SMTP id cl21mr4752925pjb.220.1630600345759;
        Thu, 02 Sep 2021 09:32:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyN80o0NBi1VWRJJZUNrilZKuC03IOPbxn8+HvnOuK8x2e1T86Kw82Sq+tssmcBqXwYh3HBw==
X-Received: by 2002:a17:90a:f695:: with SMTP id cl21mr4752910pjb.220.1630600345553;
        Thu, 02 Sep 2021 09:32:25 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id l12sm2698919pji.36.2021.09.02.09.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:32:25 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     netdev@vger.kernel.org
Cc:     tim.gardner@canonical.com, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] ipv4: Fix NULL deference in fnhe_remove_oldest()
Date:   Thu,  2 Sep 2021 10:32:05 -0600
Message-Id: <20210902163205.17164-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains that linux-next commit 67d6d681e15b5 ("ipv4: make
exception cache less predictible") neglected to check for NULL before
dereferencing 'oldest'. It appears to be possible to fall through the for
loop without ever setting 'oldest'.

Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/ipv4/route.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d6899ab5fb39..e85026591a09 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -603,9 +603,11 @@ static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 			oldest_p = fnhe_p;
 		}
 	}
-	fnhe_flush_routes(oldest);
-	*oldest_p = oldest->fnhe_next;
-	kfree_rcu(oldest, rcu);
+	if (oldest) {
+		fnhe_flush_routes(oldest);
+		*oldest_p = oldest->fnhe_next;
+		kfree_rcu(oldest, rcu);
+	}
 }
 
 static u32 fnhe_hashfun(__be32 daddr)
-- 
2.33.0

