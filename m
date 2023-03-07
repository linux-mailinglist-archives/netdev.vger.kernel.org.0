Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53796AD451
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 02:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCGB4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 20:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCGB4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 20:56:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D04B4392E;
        Mon,  6 Mar 2023 17:56:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so15111908pjb.1;
        Mon, 06 Mar 2023 17:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678154198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nzo/UKrDg68SSlPoKhUPm6gAiurUzxTEKzLrV5f+/WI=;
        b=KyRVWbYNUG479AwJ9Yeb60Hbl5tQ4IwkvYqmongkJx9o83QWlzimUq27qLojsX9wgC
         w3JO55BhwYDocYgGlgIUjthKbhJ8hptnTv/S3T7Oo/vHctmwO9+K3ZmlGIpQUrJoUOl6
         SNvYeFyaEttzMGEbfWa3RX/LVZ4qPqThnXfx/7L6oNeUXHeu/X46KX/xVj5xFjO0aXiQ
         s5dufWgrF5Z7FZsg+ZqOBvtQQw6sknYFzAeBtM2ZiEePNNegdkH1QL6ebfmuKzgLv1eQ
         Haa4O6sLBhELTBvhlnKvNCSLh3VspGcE316vrx2826PZ8enq0t7C8Ja7b3CUxYFG7mOE
         rTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678154198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nzo/UKrDg68SSlPoKhUPm6gAiurUzxTEKzLrV5f+/WI=;
        b=vwXOsHr96yRuWgsDzd4ApmAb6w5vqA50iH2namrxBSGRgmrV4xBpZD+OYMN7iEKcWT
         16p8pWjW09vkYWET7QOoP97JRLOqlbUr0NKD2xCd5eohzDrnTD807vEltDJDF3qVMrku
         JIYzRZHxGa7CBQtB/zUCgRG1wY4kX6mJMFZBugoq28ILai64yslBxnc9IMUCS+XvaCYu
         9+1q+n4/Y0ETKTSMhJmgu4XA3DaMSboecEOQpUxCyRXNjeVI1QheEYG5my7ZqVURa0uS
         BIUri/CVqrO50HqBnAJ+hATm9rqxyuLYEPa+suT2NduQn5lSwg3qC3GHFLDnqXAiCm1i
         XtTg==
X-Gm-Message-State: AO0yUKUKW4walyJbRRJFfDzoMFRzZBLIoXM7W/ChpArw0K3fMi+5te0n
        NzKMsqejOTnEBFgmm12Oiu0=
X-Google-Smtp-Source: AK7set9o4+61KviBTKqqtQOIP6plj3L7fBGPXGNOQrTDrgRMVIcRXHEzLp6ip403Ej0sbR/l6mip6A==
X-Received: by 2002:a17:90b:3812:b0:23a:4875:6e1a with SMTP id mq18-20020a17090b381200b0023a48756e1amr14105428pjb.25.1678154197717;
        Mon, 06 Mar 2023 17:56:37 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b0019a593e45f1sm7240315plz.261.2023.03.06.17.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 17:56:37 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     simon.horman@corigine.com, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v3 net-next] udp: introduce __sk_mem_schedule() usage
Date:   Tue,  7 Mar 2023 09:56:20 +0800
Message-Id: <20230307015620.18301-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Keep the accounting schema consistent across different protocols
with __sk_mem_schedule(). Besides, it adjusts a little bit on how
to calculate forward allocated memory compared to before. After
applied this patch, we could avoid receive path scheduling extra
amount of memory.

Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxing@gmail.com/
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v3:
1) get rid of inline suggested by Simon Horman

v2:
1) change the title and body message
2) use __sk_mem_schedule() instead suggested by Paolo Abeni
---
 net/ipv4/udp.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..60473781933c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1531,10 +1531,23 @@ static void busylock_release(spinlock_t *busy)
 		spin_unlock(busy);
 }
 
+static int udp_rmem_schedule(struct sock *sk, int size)
+{
+	int delta;
+
+	delta = size - sk->sk_forward_alloc;
+	if (delta > 0 && !__sk_mem_schedule(sk, delta, SK_MEM_RECV))
+		return -ENOBUFS;
+
+	sk->sk_forward_alloc -= size;
+
+	return 0;
+}
+
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff_head *list = &sk->sk_receive_queue;
-	int rmem, delta, amt, err = -ENOMEM;
+	int rmem, err = -ENOMEM;
 	spinlock_t *busy = NULL;
 	int size;
 
@@ -1567,20 +1580,12 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 		goto uncharge_drop;
 
 	spin_lock(&list->lock);
-	if (size >= sk->sk_forward_alloc) {
-		amt = sk_mem_pages(size);
-		delta = amt << PAGE_SHIFT;
-		if (!__sk_mem_raise_allocated(sk, delta, amt, SK_MEM_RECV)) {
-			err = -ENOBUFS;
-			spin_unlock(&list->lock);
-			goto uncharge_drop;
-		}
-
-		sk->sk_forward_alloc += delta;
+	err = udp_rmem_schedule(sk, size);
+	if (err) {
+		spin_unlock(&list->lock);
+		goto uncharge_drop;
 	}
 
-	sk->sk_forward_alloc -= size;
-
 	/* no need to setup a destructor, we will explicitly release the
 	 * forward allocated memory on dequeue
 	 */
-- 
2.37.3

