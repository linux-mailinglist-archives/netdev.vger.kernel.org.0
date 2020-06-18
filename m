Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58851FE9A7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFRDxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD34C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y3so5175844ybf.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xtNpgjeC+vuPrrXlD/xInlHQ99Epa7kISaCzCK7ILus=;
        b=BBFLyWTjA4UcGIF898fs50OEhUdx4Do1SaRE8fqUboZU6qAcy3mANiZaVCr6bB62DV
         Un2LiawTzhyMzM3neKp0pog2p/79TQzniwzmOpELH7BlXybsH1m6lIDJGHjsvcv3AzqL
         FHUWuH0HhWdvMutw+jom/BzGqaSZcdKz5gKR3veOM/j2+PPyt43KZAGRgZ+OqVS/L8u1
         6D96RqAO2rMzj608bSYIqFWcZ74D/NFIQChm7DyrkEXwJdzzSauPjhQds6guG5jUU5tI
         Zm5QpM9pgZteeurpdBJl1cOKuTKZzPTsL8cYHoBrjsP7p4frUljhIX6Upa0TYFMAUe7T
         FFHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xtNpgjeC+vuPrrXlD/xInlHQ99Epa7kISaCzCK7ILus=;
        b=NTbJlBishA2KBFCdK08jfgAWITHYZh+wu5mMMEQ9VcNT9LbuHBW9KJmzE64xFaFvOs
         wW33ZgeNW9ic6M64NGldhNlNnCyB+oEnPwJPCBDsxDThN8o33YCXv8iHH6JIjeEKlgwH
         WiHHJv92O8JaH0TQrsnrNDKirtQVYE7kPQc9bOfqpdgknID0vrrBQq/GEJLEik9/WDD1
         iUb0rgrS+yHH99JP9DlH7kXxcaR+IdmGSYg8gp/kSLqH7Xy50SPJe+8d7FYT+0Ssj8D3
         IuEIJvFQ45qyBazIiKWIGHFF3YxZ/CqQag16qNPwJOnP380za3Y4hsN5IRAccvyeLY34
         qnDA==
X-Gm-Message-State: AOAM533jkV40gqr4v8nJc3LXzgQNCT8uzTnFWrMJyxMVpCkU+9Wzfo+a
        /GVTzhAiG+hB4DhYcKRqtursJoiHzsiSOw==
X-Google-Smtp-Source: ABdhPJwWbmFGS5wJS5J3YIIPG+kKNnnq6a5pTytkMBZlJfyu7wNuiRENh+hiB41HymeVT9Q2ffpmSuEWxvaI2g==
X-Received: by 2002:a05:6902:4a2:: with SMTP id r2mr3578167ybs.176.1592452414477;
 Wed, 17 Jun 2020 20:53:34 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:22 -0700
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
Message-Id: <20200618035326.39686-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 2/6] net: tso: double TSO_HEADER_SIZE value
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transport header size could be 60 bytes, and network header
size can also be 60 bytes. Add the Ethernet header and we
are above 128 bytes.

Since drivers using net/core/tso.c usually allocates
one DMA coherent piece of memory per TX queue, this patch
might cause issues if a driver was using too many slots.

For 1024 slots, we would need 256 KB of physically
contiguous memory instead of 128 KB.

Alternative fix would be to add checks in the fast path,
but this involves more work in all drivers using net/core/tso.c.

Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/net/tso.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tso.h b/include/net/tso.h
index 7e166a5703497fadf4662acc474f827b2754da78..c33dd00c161f7a6aa65f586b0ceede46af2e8730 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -4,7 +4,7 @@
 
 #include <net/ip.h>
 
-#define TSO_HEADER_SIZE		128
+#define TSO_HEADER_SIZE		256
 
 struct tso_t {
 	int next_frag_idx;
-- 
2.27.0.290.gba653c62da-goog

