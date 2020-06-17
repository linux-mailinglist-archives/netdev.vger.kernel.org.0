Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575B61FD4D3
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgFQSsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:48:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2586FC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y3so3685454ybf.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VgRBmqSpZUmw/Y+F25i5VBo6acfGPVSFkB5uHKaRqOI=;
        b=Hpb7Z3TedBCfm1+MdAbuLSws+hyxTqxWnmRKheLtl0wv+IuBHinyJRyL0N4YCwoyeX
         zI4x8TIKZ//0raBsbUeZ0FoxesnmAlg0IawmDj0RQAGt4SyA6uR4jw7HkTdArGqU9i2H
         hviqXorvhH2T3CzdkMkJdVI/OVVHFvJGYcaIasMRbZlPj28bx67FhKdtZmPE/tAC3Sak
         JFeZ/5Z2mQdDAdXAJeZMENKNWl9u2heq9bzWbUQNFIlUFJBj8DowfIv838MO4GtZLB5r
         H727eMUg0xIj59pSIRPoNe262UyJKxvkqvJopRgXW72c8dkgmO6cLjxYLSvuwlNFLggL
         7b8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VgRBmqSpZUmw/Y+F25i5VBo6acfGPVSFkB5uHKaRqOI=;
        b=BRla7iXPeOK8cFpcf7s1cph65JT/DuCfVHZbOLzu5rGtBIx3phMT7K3AEQnAUYkJqS
         yZFqcBi7P/m0GZHNWVwfBD/q19cJh28EKhMmyhA+bMvCmVnM5cwYIszVTL/OTPNzv5Wv
         HPfpxOlOT57SSDQTpqpY2KkutVds4jBc1+1+OiNQHieJaf+XxG0ZKIGuvPE9if9vZ6Rq
         5qpReHX71ceHFleqZPbf1YY8qtjPfQVW/yu/+PwXGWKVy680hSNoww+acVzBO99yxOs4
         U4X40tVNvcAKycNTS79q8gSJIo5kXIjsPNQX85Niifw3HyBTEdbZ6SnjFcAmmIQvvd01
         wYyA==
X-Gm-Message-State: AOAM532iU1DHwgGKb/K194nD/OcBmpi6elnGn8Nl9wI7m/UibfmIzjuP
        HLbrzEZzWXTa6yZVa7GMHHQMvv0vlMkkcw==
X-Google-Smtp-Source: ABdhPJzEYr6sOivKh/Svw/RCjlQZkkw39QfW4QEoZcavvGzD83IsgOaY3Vh1dlOZpGpX1NIz/v17aWrGSCnHbg==
X-Received: by 2002:a25:544:: with SMTP id 65mr404512ybf.309.1592419716403;
 Wed, 17 Jun 2020 11:48:36 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:48:17 -0700
In-Reply-To: <20200617184819.49986-1-edumazet@google.com>
Message-Id: <20200617184819.49986-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200617184819.49986-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next 3/5] net: tso: constify tso_count_descs() and friends
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

skb argument of tso_count_descs(), tso_build_hdr() and tso_build_data() can be const.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tso.h | 6 +++---
 net/core/tso.c    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/tso.h b/include/net/tso.h
index d9b0a14b2a57b388ae4518fc63497ffd600b8887..32d9272ade6af0e3dd1272ecafa948f1535ea61f 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -15,10 +15,10 @@ struct tso_t {
 	u32	tcp_seq;
 };
 
-int tso_count_descs(struct sk_buff *skb);
-void tso_build_hdr(struct sk_buff *skb, char *hdr, struct tso_t *tso,
+int tso_count_descs(const struct sk_buff *skb);
+void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last);
-void tso_build_data(struct sk_buff *skb, struct tso_t *tso, int size);
+void tso_build_data(const struct sk_buff *skb, struct tso_t *tso, int size);
 void tso_start(struct sk_buff *skb, struct tso_t *tso);
 
 #endif	/* _TSO_H */
diff --git a/net/core/tso.c b/net/core/tso.c
index d4d5c077ad7293aa71c3a64f67629e1079060227..56487e3bb26dc01b65f73f96fd0157bec73ea0d0 100644
--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -6,14 +6,14 @@
 #include <asm/unaligned.h>
 
 /* Calculate expected number of TX descriptors */
-int tso_count_descs(struct sk_buff *skb)
+int tso_count_descs(const struct sk_buff *skb)
 {
 	/* The Marvell Way */
 	return skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags;
 }
 EXPORT_SYMBOL(tso_count_descs);
 
-void tso_build_hdr(struct sk_buff *skb, char *hdr, struct tso_t *tso,
+void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last)
 {
 	struct tcphdr *tcph;
@@ -44,7 +44,7 @@ void tso_build_hdr(struct sk_buff *skb, char *hdr, struct tso_t *tso,
 }
 EXPORT_SYMBOL(tso_build_hdr);
 
-void tso_build_data(struct sk_buff *skb, struct tso_t *tso, int size)
+void tso_build_data(const struct sk_buff *skb, struct tso_t *tso, int size)
 {
 	tso->tcp_seq += size;
 	tso->size -= size;
-- 
2.27.0.290.gba653c62da-goog

