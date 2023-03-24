Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693736C7C25
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 11:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjCXKCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 06:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjCXKCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 06:02:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0B323A75
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 03:02:42 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k37so1539815lfv.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 03:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fr24.com; s=google; t=1679652161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hqniG2RTuzYc41TgGVo3CFmOEDPj8x/ry7qdxr2ig3U=;
        b=WdI66PJPmXPEQ9JwFdMZEGzbWsV7VQNXtqHY0IP5KW3ugIT1HddLLFCZGJiW+0fXBb
         acjfwE58oDPoFP7rSLsBqLYWet8dEnJR4hojFRxQSooIUzKmz4r5C9IPF2+YdVyfqzas
         6q99o1Fh4jZ8c0agitV0Og+EynCvHsrEpn0Gh5nMyQUIsFkNumPNWlNkYWL4nit46dJa
         RKpVlISZwv1/YbooAg7Rfz8nR8W7MyR46ZDSvEL6PtuKDXtHvjKDJ6ErB9Rvdee/gqET
         GfS6FtV8SXIGlSKQ+0c0q4BVxM3LttghMmcZXwRrCNeg8juuGHOZFIVzxAl8ZKVCOL//
         SdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679652161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hqniG2RTuzYc41TgGVo3CFmOEDPj8x/ry7qdxr2ig3U=;
        b=14s452/nnzsCWOZALTsHBh+tR33lV1u5lveVUEMQLko4HJQj0LkKn3QZvU0tiOG05x
         1f5ie5ua1lKiE/EtrCADWKIarJPOqdDc5tgccFp/UD6AOHGpNLIpX1Z9wrY1TAH1StcZ
         WxVfcFUwfZJfgK9rvL+9fJHK1JYxvw4bWj2+G+MngDz7Fp1nhDfeS/O5r5m/i0r8Ft6s
         gLL0Ea+v1p98Wapnk2j2oRxwY49btzFDKpuCDFrQJ4I0PepI8RZLbRBZmUH5FpmIzQfp
         vKLKCtXveNhr9LYy+kJm83qo+qGEfbzJoIAoyyk7ZXoQn9Z5oOnFbbWDEkbcz48K62M4
         g0VA==
X-Gm-Message-State: AAQBX9eNv4fsAreTZZ/yNFA8sWmlc1p/pL6vIXUT/sy+pyp7d0QugV5t
        7rtvJz7OxuP/Wm+qoATHdnePyg==
X-Google-Smtp-Source: AKy350afxW/MzPpBo1E2U1b5voWjHTIIgFJ0cAMVXcl7lU1aJbGr3gBYCSMuQrZgHHbXj2qJBotQ7w==
X-Received: by 2002:a19:ae02:0:b0:4ea:129c:528 with SMTP id f2-20020a19ae02000000b004ea129c0528mr653408lfc.56.1679652161179;
        Fri, 24 Mar 2023 03:02:41 -0700 (PDT)
Received: from localhost.localdomain (bl20-118-143.dsl.telepac.pt. [2.81.118.143])
        by smtp.googlemail.com with ESMTPSA id q23-20020a19a417000000b004d865c781eesm3282268lfc.24.2023.03.24.03.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 03:02:40 -0700 (PDT)
From:   =?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunog@fr24.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunog@fr24.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next V4] xsk: allow remap of fill and/or completion rings
Date:   Fri, 24 Mar 2023 10:02:22 +0000
Message-Id: <20230324100222.13434-1-nunog@fr24.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remap of fill and completion rings was frowned upon as they
control the usage of UMEM which does not support concurrent use.
At the same time this would disallow the remap of these rings
into another process.

A possible use case is that the user wants to transfer the socket/
UMEM ownership to another process (via SYS_pidfd_getfd) and so
would need to also remap these rings.

This will have no impact on current usages and just relaxes the
remap limitation.

Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
---
V3 -> V4: Remove undesired format changes
V2 -> V3: Call READ_ONCE for each variable and not for the ternary operator
V1 -> V2: Format and comment changes

 net/xdp/xsk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2ac58b282b5eb..cc1e7f15fa731 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1301,9 +1301,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long size = vma->vm_end - vma->vm_start;
 	struct xdp_sock *xs = xdp_sk(sock->sk);
+	int state = READ_ONCE(xs->state);
 	struct xsk_queue *q = NULL;

-	if (READ_ONCE(xs->state) != XSK_READY)
+	if (state != XSK_READY && state != XSK_BOUND)
 		return -EBUSY;

 	if (offset == XDP_PGOFF_RX_RING) {
@@ -1314,9 +1315,11 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 		/* Matches the smp_wmb() in XDP_UMEM_REG */
 		smp_rmb();
 		if (offset == XDP_UMEM_PGOFF_FILL_RING)
-			q = READ_ONCE(xs->fq_tmp);
+			q = state == XSK_READY ? READ_ONCE(xs->fq_tmp) :
+						 READ_ONCE(xs->pool->fq);
 		else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
-			q = READ_ONCE(xs->cq_tmp);
+			q = state == XSK_READY ? READ_ONCE(xs->cq_tmp) :
+						 READ_ONCE(xs->pool->cq);
 	}

 	if (!q)
--
2.40.0

