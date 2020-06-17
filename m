Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681C01FD4D1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgFQSsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:48:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E9EC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 186so3522547yby.19
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B5oWe0Ns77G/OPPlwElw2YCaG+Rqmsdqc4ZyjsUEZns=;
        b=v7DO6FgX/Fcvqd+SUHtD4C65sbuHPHzJwrMWqEsCYbubEIMSSRtQWjK4oDJbboZF6W
         R6oMfyQykJoKoT99cjj8HmbiGx0qL7IqAY6ZcFXpiUCbvPfr2P280PIfI5rK/Ka36kcS
         kQufNkq0XGZO3N7f1VD07OIMfFHYk4/EZkmPOhugYBrFQFm4gnjiPX8s7BEBsEcAvNsW
         wuKYnc9AJN/wFvVKNIoT2G+LTTldUSaYHn2HtfBbRa9wO005dGJJi3cxhTVWu9eF7Ggc
         1JOav3NGJUcB9sgfQk4+zASBW9SDfdJc9Hra1eEC3a6lukENVaEdnZi4wbexKUY2hv3M
         oiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B5oWe0Ns77G/OPPlwElw2YCaG+Rqmsdqc4ZyjsUEZns=;
        b=DcZmSrLw4dZBtEl41Y3uZsKLwzQxuuQgvcs5hTI4GMyW5KeET+UejxZ2g9vFIhZQ45
         Ks42jTH58Ef9+nUa55T9tLPBKhcbEA0Iv+JZ78Xhc57X21+379Wt8AEmngCIGZ/PW8db
         5Gd0X6XKsTMqGzskT4fs2YOmXxtcNjWFqrK7aYZiq902R6MKqbbVBf3WNwGPdhdD8r4q
         2MKZ4jQ7P9v7ruBiXLIH+srruuL1wXFfwBKwxpAOA8+ARQJtvE9OELZsgfRaJHLoIRqK
         6JKb6NZsnRpUvMY6MfCgPxVZtF7poqlRmsgJVitiD54omEtPVYL96+BG5w1l8KcBhpzf
         rfaA==
X-Gm-Message-State: AOAM530SSBp3B7/3O1lyvc+qwb2GWBFSijvel0J/WBLDPCwjiOfsxlGJ
        tN/O13+Kp3JyXpPYTuNJV8E5j0+9RQ4YAg==
X-Google-Smtp-Source: ABdhPJw6YTsQpOW8PUJ6yfG06/q+nB/kRCJVQl7jzsShLfxvyoQjSdKh0sQ4vVpoCtN7HwEq3uwxxG60LRxDeA==
X-Received: by 2002:a25:ce4b:: with SMTP id x72mr520437ybe.78.1592419711677;
 Wed, 17 Jun 2020 11:48:31 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:48:15 -0700
In-Reply-To: <20200617184819.49986-1-edumazet@google.com>
Message-Id: <20200617184819.49986-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200617184819.49986-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next 1/5] net: tso: double TSO_HEADER_SIZE value
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
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
Note : please wait at least one cycle before backporting to stable versions.

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

