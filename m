Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4C1FE9AA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgFRDxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACD1C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w9so5173320ybt.2
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VgRBmqSpZUmw/Y+F25i5VBo6acfGPVSFkB5uHKaRqOI=;
        b=e/dpoS2b5lnQMdEIUGieLZW4VQGn0P7uytJjTMjzZ5vb3tFQ4L2+CfwG9WzySlNWn2
         p6L7yBJyJuSzpctFJD9cFrLrstuQ1K+I4RtIIV2GSUZVXroe4hfRSNBdiG49ZG02Zucy
         /7gJXMATx45zn6FTc8cZMzXoz8VjXufmSr9m9xAg8KhwiXlqjCtgGjcLKagg6IpCKPjr
         szsP6LpMeGzMFreUYALKll8CsnXeB7DTwVRi+ap+sxW2Md0iW/4Zv2Bd0lo15wIrzGgn
         o//f+vdvJYJAoiewKgxecmVEGRc/5CAioJI9n54kHp8i4Ilx58wQZqoN/NHdPuvaT0CD
         LnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VgRBmqSpZUmw/Y+F25i5VBo6acfGPVSFkB5uHKaRqOI=;
        b=VvM7uInmGqJcbIEI+aguOzltUeYC0eHn5eM+nywbW7GvPUa43ogwDn2UVTDV3Rlnxz
         3iFgtCdC5RyAkX1Mva9wAhWNbbc6+iGOG0UcLMuIiBiX7J7MxYEDru+f99rjiAwl8dtl
         kc+ryljIaTV9LERKnQumnml2EKaNYsazufG1221IRwc5gJwcqG5veU3GspqgX5yElfL7
         SdxzBLhWez+Ud27/4d9b9atYOYqhKZjtzG9eH0/MMflQNbojnacOjGWYKRZwe0WfgAi9
         cqVT3J0xD7v/omqdY1u5qDeuicKlMekEw23nKGDbiyBoLss/7HvxLEOPu/sYm8/Q1N9y
         N9+Q==
X-Gm-Message-State: AOAM532nIyuSyNEgh8zqIcLPVN/LtctpltisrNJ5rrUD2Xj8Uqv1l5fo
        8XiJQIl2xpUu+kkJsyZmDpVvACEytM5Tog==
X-Google-Smtp-Source: ABdhPJzLDA9vf7TbB49WDycvN88UpbLSbeAr5//POvSTO8C38T2ZoPTYQi7yOJlUo5Evqp+Jq4q07kj8TNLVMQ==
X-Received: by 2002:a25:504d:: with SMTP id e74mr3166020ybb.47.1592452419283;
 Wed, 17 Jun 2020 20:53:39 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:24 -0700
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
Message-Id: <20200618035326.39686-5-edumazet@google.com>
Mime-Version: 1.0
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 4/6] net: tso: constify tso_count_descs() and friends
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

