Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6E58CD52
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbiHHSGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbiHHSF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:05:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53A26342;
        Mon,  8 Aug 2022 11:05:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g12so8762615pfb.3;
        Mon, 08 Aug 2022 11:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cF1SSSwKFr1VcpBG7Q2WYW8HQ9jeON5GyJmGTjVfNCo=;
        b=VxiE/hFMzs9RdTHQIFbkw4Sn2Ll7tKYZiVxZZivsELO5RV+uHDOp42U0nOIZZC074R
         gief1ImXb+lX4zLXS6WUDmcIbGYaVygiR7t4Zmc0FumYoiKCj1DbD3V52Mqgq0Oh+zZD
         k2kzzogEbFN4ROEO7+x1hK9jub9rt3Ngf2tQBl9fXsjCn3PoDl3iFBePGPpkBzu64wgB
         V/izeFqILoqUCtMR1zQae5BGebPtOA8dETf8hW8lL5ilu1ap5f9Y8PiR/r9kicwJyqzQ
         EmA7qZfCghpMRTic4RGgFvuMwvnwPBlwRRFAFgQDrww52WFXFRRnu36BzHU5xgLynst0
         5sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cF1SSSwKFr1VcpBG7Q2WYW8HQ9jeON5GyJmGTjVfNCo=;
        b=tlUS7S0Sl/OWwhjb1b1Fu6+dAtMqmYr0WKMXKDNGRS3dGrDTTV8FGqto6UTAqY7ELA
         i6EfhT0ReW9hkFKUhTq9T+yB5Fln5IeUFaNKx3z8QTg0HtOt9G55rpy+Onl7B9brgNrY
         kmNZryGHk4MAf/GgZXXveF4MlYTwNdaYkeyOUr9rKnUdKEsveWVTEkAmDEtoGowh4kfo
         ObrP9pS857z5rgtg3r+7HFT9zt4AbTGG11xTZhc30gYNkxjK+tuuqJoT2WqCO14KPITH
         pdaQDZGNuJWLYCg9kOkVf+LbONqy+/0Hv/oVaqmjd8NFsiMva5Gj4dwLSyRStNkKeoQN
         CjpQ==
X-Gm-Message-State: ACgBeo2kqun8jLCR0LKPA17QW4B7ubLDQQ4VqOaGYAI2/+HWOxvl7Kn2
        a6W1dcceZuChHXR1f6qqHQ==
X-Google-Smtp-Source: AA6agR6XkAVkJW2j0KSnDQJ3TtFi+kfyPTVwCul6A7a50/20bB4d0tDJhth2w03BDiVKloH5qyKdpQ==
X-Received: by 2002:a63:ed15:0:b0:41d:9e79:88eb with SMTP id d21-20020a63ed15000000b0041d9e7988ebmr2547790pgi.131.1659981957106;
        Mon, 08 Aug 2022 11:05:57 -0700 (PDT)
Received: from bytedance.bytedance.net ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id g4-20020a632004000000b004114cc062f0sm6428162pgg.65.2022.08.08.11.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 11:05:56 -0700 (PDT)
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
Subject: [PATCH net v3 2/2] vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()
Date:   Mon,  8 Aug 2022 11:05:25 -0700
Message-Id: <3ae47cb75cebf7c2cc027356edbc6882d89b11f8.1659981325.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <fd0dc1aa3a78df22d64de59333e1d47ee60ed3e8.1659981325.git.peilin.ye@bytedance.com>
References: <fd0dc1aa3a78df22d64de59333e1d47ee60ed3e8.1659981325.git.peilin.ye@bytedance.com>
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
has a pending connection in progress", even though the first request has
already timed out.

As suggested by Stefano, fix it by setting *socket* state back to
SS_UNCONNECTED, so that the second request will return -ETIMEDOUT.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v2:
  - s/even if/even though/

(new patch in v2)

 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4d68681f5abe..b4ee163154a6 100644
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

