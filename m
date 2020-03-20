Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FC018D512
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCTQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:56:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:50503 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727598AbgCTQ4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584723374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWJEiu/Z2FQlJcrWSPoV5kXif2wXXa5HAsBAGFtr6yE=;
        b=XMojtfyCiZ5ka5JPZxMKwNs1jKq8q2Tf4DWUVZeV7AyV8Pq+nSTdT7xo6dEqh9X1naXy2n
        Aj5OxtOGbygmJIc85nLGvTte01eof4tmQaX9ZuWDjBt+rNwAr743did09y9fom5f0B47Uh
        IGEA+TEy4y3srPrmnhX4tQWItHIJYEw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-fXXcRJ3yM5eZx4Id7W3oZw-1; Fri, 20 Mar 2020 12:56:12 -0400
X-MC-Unique: fXXcRJ3yM5eZx4Id7W3oZw-1
Received: by mail-wr1-f71.google.com with SMTP id o9so2906592wrw.14
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uWJEiu/Z2FQlJcrWSPoV5kXif2wXXa5HAsBAGFtr6yE=;
        b=umOTSOb31NVTrNC+DG9VW92KMxo9Ebn1xi+R4uA5f9iDTO++MKhQqAKFJ2YiRrLBGH
         c+q63axD/EibpOS7qRsYguogTvTK4jlkxQImdDMixdkBwQJV0hJOblow+scLZrq/o8Od
         6MVM50Hz0iT09qlX3H9hYXyxbZCNgqedf6VFHL72W1j7v8Y/uJrDaG2qZiiN1TeGsMiR
         8p7RapjRc/sJgkvGwRCPO7dO0SAhHQhxgimwFUHG3Nt2oHu5XXCCU+MCAh6qL/NHPJ/i
         7ZruCf3SNoQr3QdlqvWHPw/zeC+YYgvXlsavnPkIRbeyxPRNQmVyCR0cUIFjz2T4B9cH
         8ETA==
X-Gm-Message-State: ANhLgQ2Zm+CUY81XusNtUROYfmb/6KXjM0VvoZXUy6NZnw7e3cPaYBEC
        gZKFnzc4qSsS5NpZLXCFLcD6wdPJaZCZAq7OG9h4rOdLXWSKGiTWk5ifJgHfceKVq6MuR0L3RMB
        cZLQqOKeWZMjSa3T9
X-Received: by 2002:adf:e611:: with SMTP id p17mr12092548wrm.212.1584723371689;
        Fri, 20 Mar 2020 09:56:11 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt5dnElraEJukrxRAzOrRHyD+59sIcO9ulFVjI/M6bi9ifQambJe+0n3+1b74F6Lzxu/qzP6A==
X-Received: by 2002:adf:e611:: with SMTP id p17mr12092512wrm.212.1584723371442;
        Fri, 20 Mar 2020 09:56:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 9sm8345504wmo.38.2020.03.20.09.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 09:56:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BC07C180371; Fri, 20 Mar 2020 17:56:09 +0100 (CET)
Subject: [PATCH bpf-next v2 2/4] tools: Add EXPECTED_FD-related definitions in
 if_link.h
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 20 Mar 2020 17:56:09 +0100
Message-ID: <158472336968.296548.5222057372093911700.stgit@toke.dk>
In-Reply-To: <158472336748.296548.5028326196275429565.stgit@toke.dk>
References: <158472336748.296548.5028326196275429565.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds the IFLA_XDP_EXPECTED_FD netlink attribute definition and the
XDP_FLAGS_EXPECT_FD flag to if_link.h in tools/include.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/include/uapi/linux/if_link.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 024af2d1d0af..e5eced1c28f4 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -960,11 +960,12 @@ enum {
 #define XDP_FLAGS_SKB_MODE		(1U << 1)
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_EXPECT_FD		(1U << 4)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES)
+					 XDP_FLAGS_MODES | XDP_FLAGS_EXPECT_FD)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
@@ -984,6 +985,7 @@ enum {
 	IFLA_XDP_DRV_PROG_ID,
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
+	IFLA_XDP_EXPECTED_FD,
 	__IFLA_XDP_MAX,
 };
 

