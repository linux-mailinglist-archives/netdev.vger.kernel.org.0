Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879D458BA58
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 11:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbiHGJBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 05:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiHGJB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 05:01:29 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1C6249;
        Sun,  7 Aug 2022 02:01:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p18so6135418plr.8;
        Sun, 07 Aug 2022 02:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v6ZzHsOm8HknBqz/0yRFh9xunm5LSvghYAiCueDTMBk=;
        b=ooPQRoF9ng5zEpMEcbe7XG4XHb9TEytBIYnWqh3RQaHc811Wr2+viUFdxsYqWhOhmX
         eBrT69csEWa6+hOQ7/vHmYH/LwrNesFYJgY89uWozuU5IyNdTaUvKzyVi+jPAEuj5XbU
         Ofcx/jzztHcH4fRUY+ieS1PFWVSVkdETsVBMjcvzl/lyCGbepFt/w19KmOJWgr96nh12
         eMRI6J5EsWfOeiivtv91Ij6PIyqGLBwTOcDNhPB/y7HPqAICnMn66vXgKoeH47omrx5n
         sqAqjbAYQ0QONpm+yBfoM9hY7VQMab3TC2COnDWhcvTr4aN7fnWbxYxxajdMJdNnvZBw
         VPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v6ZzHsOm8HknBqz/0yRFh9xunm5LSvghYAiCueDTMBk=;
        b=dZDdrta2eMBBy02pZ1N7y6AMomSR7RXopmer5GsjD3DqR/pIDcQtAboZxswZsmcc91
         R7nGcHRG0NuZIfbnLgA8zFyh2nrOgkigVHMd5X0wCraf9gFaqXUZPKGoBd8eTwRFF+ad
         d9kKbV56iwRB/H32H1aliye7snr6ijps/MfEgKxCLNlbRU3aIBnvjmnv38L4WAM8K9Os
         rYtBLtnq18+g17xqVPBCarlZFPV4JQBjF2Ej7+mY2kRn/yKUyev0A9xqEjVo1j9vZjUO
         Mvz4PavvUi6XpGm2fs8XtgnwC2FpaUNnkBxHDeFIaxvAsZda0KsyHnDVrgfMO43XDSlM
         9yZA==
X-Gm-Message-State: ACgBeo1bB4fytednpL3qNOIjV2vrGCy38zxrTGpaf6OovYjkGevnuJcE
        vEko9zvdHw5HSITp0vpcfg==
X-Google-Smtp-Source: AA6agR6qBv8q+xOwM71wkTWv1BJGDOrKZPbeuyMbKitLYowaHSrpZoWvEQjjTvQJsXN9+rU8m11dQA==
X-Received: by 2002:a17:903:2444:b0:16d:baf3:ff06 with SMTP id l4-20020a170903244400b0016dbaf3ff06mr13603780pls.148.1659862883285;
        Sun, 07 Aug 2022 02:01:23 -0700 (PDT)
Received: from bytedance.attlocal.net ([139.177.225.235])
        by smtp.gmail.com with ESMTPSA id m186-20020a6326c3000000b0041d59062108sm1220575pgm.9.2022.08.07.02.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 02:01:22 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        George Zhang <georgezhang@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>,
        Andy King <acking@vmware.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net v2 2/2] vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()
Date:   Sun,  7 Aug 2022 02:00:46 -0700
Message-Id: <5cf1337b4f6e82bc0a4eb0bef422a53dcc9d584a.1659862577.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
References: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Imagine two non-blocking vsock_connect() requests on the same socket.
The first request schedules @connect_work, and after it times out,
vsock_connect_timeout() sets *sock* state back to TCP_CLOSE, but keeps
*socket* state as SS_CONNECTING.

Later, the second request returns -EALREADY, meaning the socket "already
has a pending connection in progress", even if the first request has
already timed out.

As suggested by Stefano, fix it by setting *socket* state back to
SS_UNCONNECTED, so that the second request will return -ETIMEDOUT.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
(new patch in v2)

 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index fe14f6cbca22..e857dbf1a32b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1286,6 +1286,7 @@ static void vsock_connect_timeout(struct work_struct *work)
 	if (sk->sk_state == TCP_SYN_SENT &&
 	    (sk->sk_shutdown != SHUTDOWN_MASK)) {
 		sk->sk_state = TCP_CLOSE;
+		sk->sk_socket->state = SS_UNCONNECTED;
 		sk->sk_err = ETIMEDOUT;
 		sk_error_report(sk);
 		vsock_transport_cancel_pkt(vsk);
-- 
2.20.1

