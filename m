Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD924CB4EE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 03:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiCCCZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 21:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiCCCZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 21:25:53 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E272B197;
        Wed,  2 Mar 2022 18:25:09 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z2so3237605plg.8;
        Wed, 02 Mar 2022 18:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+owYc1beiZNdVQWI5pfer3AMJMG+Sa0wwOUcL3jCg/M=;
        b=N/ogtJZFKTRwAFlfhS0OuPvfRc3Mc2rkVgfcoUi3PHPuoQhst7CUfVAi1rLMJRPfDh
         96ZAyKA0/PRpcSC+A/L0WsJS+9B4PMY9RlMTC/lR6byI+mc/U5FU6uP+jzWmjq5XdkH2
         RJ96SYYuRYHp7ODGFJygl+vsFusH/OxSGBtC91Acn8g9oBIfLFFl5dcVgqsoTHmyEBXU
         b2kOfJoBtlz2KDk8oxiM+W5DcU+99501t2Rzp39KYEoOgmF32rFvyefNyLdMZx2v/niZ
         GXFAudoxSQO4KEvagjnsRSiyniFMk3cEptyjnwSOyzOf+whsnt5H9oFqUzLLQqpCusky
         I50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+owYc1beiZNdVQWI5pfer3AMJMG+Sa0wwOUcL3jCg/M=;
        b=ls0b83qUXC3xJ2HZfRv32kpMEvjXS+v3Debw5y+qJJAoA9VdEbU5HQQdNTtV9vyCr3
         qoI2nV93snilIuNGMlYmvUsfnQb/tYR6ousJ+Sat9U2f2Vwurc0MF0Lw+KMAy7Mr7enM
         bwgW0bFrFBom13/+CvXeutsH7/k5nksIeWDdhrFSEKqJ+azagyvhUZCq1iSZuPxDUcdo
         JR/7JaylR4IMI2d51ORLSLMSGYT4aL92pR6wU65AF/JlTFR3Qh+smQbvJTzCnDWve7Qh
         ytcVUfHAIokfujeSlrfGCMt3OK99xeIZucBsi312BnG8IgaqOOdquy979EFVMi8S4ieq
         +o1w==
X-Gm-Message-State: AOAM530PNtWwwnB/+39GrQp8GzkXkxVdPAfoQFgZdY3yOvmSCwXEmwz0
        /4eLkCuCOLcOfnoD1P5NjKneEmNOVNKDBloG
X-Google-Smtp-Source: ABdhPJwNk7hy6g36u2v2wPwp/L7scAUbPYKRT4PM+N0nuOLZg5Ue5d7LQjdVp7ZLYxBbSMx6+xBXBQ==
X-Received: by 2002:a17:902:7802:b0:150:baa:bc1a with SMTP id p2-20020a170902780200b001500baabc1amr33493067pll.110.1646274308811;
        Wed, 02 Mar 2022 18:25:08 -0800 (PST)
Received: from localhost.localdomain ([157.255.44.218])
        by smtp.gmail.com with ESMTPSA id s9-20020a056a00194900b004e1583f88a2sm490687pfk.0.2022.03.02.18.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 18:25:08 -0800 (PST)
From:   Harold Huang <baymaxhuang@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jasowang@redhat.com, edumazet@google.com,
        Harold Huang <baymaxhuang@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VIRTIO HOST (VHOST)),
        virtualization@lists.linux-foundation.org (open list:VIRTIO HOST
        (VHOST)), bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Subject: [PATCH net-next] tuntap: add sanity checks about msg_controllen in sendmsg
Date:   Thu,  3 Mar 2022 10:24:40 +0800
Message-Id: <20220303022441.383865-1-baymaxhuang@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220301064314.2028737-1-baymaxhuang@gmail.com>
References: <20220301064314.2028737-1-baymaxhuang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In patch [1], tun_msg_ctl was added to allow pass batched xdp buffers to
tun_sendmsg. Although we donot use msg_controllen in this path, we should
check msg_controllen to make sure the caller pass a valid msg_ctl.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe8dd45bb7556246c6b76277b1ba4296c91c2505

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
---
 drivers/net/tap.c   | 3 ++-
 drivers/net/tun.c   | 3 ++-
 drivers/vhost/net.c | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..ba2ef5437e16 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1198,7 +1198,8 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 	struct xdp_buff *xdp;
 	int i;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
+	    ctl && ctl->type == TUN_MSG_PTR) {
 		for (i = 0; i < ctl->num; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
 			tap_get_user_xdp(q, xdp);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 969ea69fd29d..2a0d8a5d7aec 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2501,7 +2501,8 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (!tun)
 		return -EBADFD;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
+	    ctl && ctl->type == TUN_MSG_PTR) {
 		struct tun_page tpage;
 		int n = ctl->num;
 		int flush = 0, queued = 0;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..792ab5f23647 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -473,6 +473,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 		goto signal_used;
 
 	msghdr->msg_control = &ctl;
+	msghdr->msg_controllen = sizeof(ctl);
 	err = sock->ops->sendmsg(sock, msghdr, 0);
 	if (unlikely(err < 0)) {
 		vq_err(&nvq->vq, "Fail to batch sending packets\n");
-- 
2.27.0

