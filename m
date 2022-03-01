Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D62E4C8445
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 07:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiCAGo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 01:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCAGo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 01:44:27 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5FC70CD6;
        Mon, 28 Feb 2022 22:43:46 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id l9so12254206pls.6;
        Mon, 28 Feb 2022 22:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+owYc1beiZNdVQWI5pfer3AMJMG+Sa0wwOUcL3jCg/M=;
        b=mhNIm7K8HCmmestlFa3eFuBAsCUtvPUG4FIZlkQTSacPCQpagAAGbpAhZM/0yeiXv5
         EFWSoPXHVye+yv0CPoK6KGmkv6kJxr9Cfcy9ZFjI7eIiz8+t+Nc5hN68yZ3yK/NyAvOa
         oxl3XgUyX3PSDqZ/Ma+n0BsEq+G99hVUwCDKTia0IuOnZqIK923uqAnUJj/gdLpizGHl
         +N15qzdLMnQoNn9s8LDDKGfGxN1Twuidp2iSKW8ewXBvD7XAPiWdMNvhdD7dPadMLAFT
         eYEV6H28YBmoJxUfIZQ+F8y8q12MXYDDNZ6FF6SDiRoHKGHUKHWg/gsfbVAhBU313ETp
         sI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+owYc1beiZNdVQWI5pfer3AMJMG+Sa0wwOUcL3jCg/M=;
        b=LRfUjXYAh6QQy68+VA/ks1ZJyqtWWabLuUYqF/9StSxgFi22/0SAZfjCyvIOp2RVH7
         O8TdtR2I2oTo9o0iqul3Q6GzkEVol9anT9vh00+7pRC4mTDxvNEEKgn9ge+bJrkxP2/8
         EzMJBdLtfuHKeaprftOyCRgmQ50PbT4/KG5TGj3rUt5sGuDMfuDr1Asua4L4vOr/C36G
         mU82QT7HUMGfaR7OeWHhVm+eynYgMPdSb0POC6LYKLb9G2bcxQhbdnDdMaN8Qp2gMGBU
         ZthsFRCJu0JMmGFdwFN9Kf+ESKjSaZ+Xe740vNv21Y8tpxXsPrEtE6NemmIrcC65l75m
         7eNA==
X-Gm-Message-State: AOAM533dQuku4wYq9ZV4tPwoSLxQuR/UE3RfGIypkukxArrfY2JY/hTp
        tqVueWVcTgV5pdP+A29gwko5kDNOrqbVOGRW
X-Google-Smtp-Source: ABdhPJzzjKHZ4eMqpTkMRQtO2BodQZzivbsPo3+4bXmKPse4ZCebcpTrEUMZm0j7p2XARGe2hTwy5Q==
X-Received: by 2002:a17:90a:67c3:b0:1bc:9cdf:1ee9 with SMTP id g3-20020a17090a67c300b001bc9cdf1ee9mr20506471pjm.203.1646117026083;
        Mon, 28 Feb 2022 22:43:46 -0800 (PST)
Received: from localhost.localdomain ([157.255.44.217])
        by smtp.gmail.com with ESMTPSA id m14-20020a056a00164e00b004cd92ccbaa3sm15757586pfc.170.2022.02.28.22.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 22:43:45 -0800 (PST)
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
Date:   Tue,  1 Mar 2022 14:43:14 +0800
Message-Id: <20220301064314.2028737-1-baymaxhuang@gmail.com>
X-Mailer: git-send-email 2.27.0
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

