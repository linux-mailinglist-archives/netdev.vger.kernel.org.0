Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DC62AC926
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgKIXN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKIXN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:13:56 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9510C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 15:13:56 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id w11so5489692pll.8
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oduogtnbw5/TKsSx9Xyi3jGYRSYurv0+Gmjk3ygWYFU=;
        b=r1xQr5Hadf5RzWS4UZmVozXBtgfRjYPEX32af6H+6W+cMbDpl6ceRegQaJg8FepAph
         08fYpfOqHXrxsBkHot2fVmg+h+gRA+j3/MNH6CKaJcOaG10jXYw/QUmK9NZNvI/eAHo5
         lAmkDPWPghTo02WXcXQ3P5DWn7XZ9FtEu6HCJClv3YU3Ik02Ngyd4sDy2IUXmUnu29JN
         CVXV4p6CHosFpPplJkU192tAlD9iJ+VNG9yk7gz8hOgXn5oEkvE7uRpxw4O8DzX58eLv
         RgoaCFZm5V2aelvloJjAgacV0wDGEG/NGDrpaa24e/+zA47V9ui87NaSh+ieaURHnLSm
         O7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oduogtnbw5/TKsSx9Xyi3jGYRSYurv0+Gmjk3ygWYFU=;
        b=AF/dLW/uajhrnndJCJdqEZWnS74i1E62ClVck9HF3i+CLRBzv3YiZTJgTy0e90vbz2
         M7voiSo99JQ2LQ+m/bYJFge9RjkyxUcS6ZalJxEhHHKjkZCEAB3VqzCRP+n3cTNGyqif
         L/M7g0uIL9n2s1IwuC2Vginj2rPR3wUfaGSVPs4jjWhmlqQWSpQ8U7LyApr3jGSaEA5Z
         deRC5Br1FD4Vzh/IazrZB+cJVfpu11uJLzSo93Y8aLcsVJT1xb6uPBOx30fmg1Tm4xHU
         BcvjrJJcQybzDxCdKMFbni4MRU0NA93aG3HprPRz/uAGB5kZa//DC8y/FL4lHDbgj0jl
         El3w==
X-Gm-Message-State: AOAM531au4AWbeYhnj6OwF0wZJXHdPDkdNUnMkZOB880A2JVIqpt1jE2
        4qhb+yBzlPqN46ZLKOCDqDU=
X-Google-Smtp-Source: ABdhPJzzVLq8QaGAeoxW0XKn8ddUsciCYB9t0C1Gn3l0lLJeJxtFYw+OEkyVpSiwpIPniw5PjziDUA==
X-Received: by 2002:a17:902:6b08:b029:d6:c471:8b5b with SMTP id o8-20020a1709026b08b02900d6c4718b5bmr14668910plk.78.1604963636348;
        Mon, 09 Nov 2020 15:13:56 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id w16sm12375365pfn.45.2020.11.09.15.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 15:13:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 1/2] inet: constify inet_sdif() argument
Date:   Mon,  9 Nov 2020 15:13:48 -0800
Message-Id: <20201109231349.20946-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201109231349.20946-1-eric.dumazet@gmail.com>
References: <20201109231349.20946-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

inet_sdif() does not modify the skb.

This will permit propagating the const qualifier in
udp{4|6}_lib_lookup_skb() functions.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
---
 include/net/ip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d6b985d11ccaa75827b3a15ac3f898d7a193242..e20874059f826eb0f9e899aed556bfbc9c9d71e8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -99,7 +99,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 #define PKTINFO_SKB_CB(skb) ((struct in_pktinfo *)((skb)->cb))
 
 /* return enslaved device index if relevant */
-static inline int inet_sdif(struct sk_buff *skb)
+static inline int inet_sdif(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
 	if (skb && ipv4_l3mdev_skb(IPCB(skb)->flags))
-- 
2.29.2.222.g5d2a92d10f8-goog

