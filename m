Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1964363ACCF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiK1Pnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiK1Pne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:43:34 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370D31DA4E
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:43:33 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n21so26827476ejb.9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/8IHKCk+zYHnC/CiuG7M+HRlHow+nOmS5vrwm/o5FA=;
        b=L9WNJP5LJHYF18H4DLeWGK5GpKgB9HyjoFnJUOhvucW72h3rwGYO0PEFfdTN1YTj8k
         LGBrxNBv3hdE9Qa1WdyWSJqlaAnnCU1Pk99Lhde1Y3DIa+tgztWjdUxpiepP5sH8PJ+P
         iixwhnEIla9Fd4tir+FU4HIvMncXshBMn7XJ4AnYPeBlUVIOwW0j0ZbkOltM3VrL62Xq
         0MXE+AYd9ZQbM23u9gA2G6Gtn+3MZzdL+mBqtSPn7uyeTuf+ze+71xoo2MfpBExBxtFF
         4/Ip8KonrPpVqd6OLJvAolr1Dy+FyGka2hQHufxu2W47rlTzsirq1HHze6US+ljfOZN1
         LBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/8IHKCk+zYHnC/CiuG7M+HRlHow+nOmS5vrwm/o5FA=;
        b=v+EyhXM+rm1GVlQWck1yU/dT5QaUv+Dj3V1xyZfLC5Yzc3SXqt9tpvpCl8XebZzk5Z
         hTZt6j8W80vMCuImgdMZcWd7RFN7SWltcACldnvY50KwzwCb9L6bzux7N6KknGuNCTXG
         hs8hmPr1ZkPmC3kvrK/tc/Fjzv0NQYLoVhUrDKrfzl+e0dQKHVGNOPsxPAKk+KT2MjYV
         tx/Guk5s7w7qt0lFdQrNJ67pX2XyBCc0RFWuiE9bw2O46r394B7v53Wd2ArERAfoC56f
         4RW4DT9nRbMg6+xGqwe38miDTPx4wczLl42d7Pex/TZR6EtXwuuPz447DkP59kFXWSEK
         eo1g==
X-Gm-Message-State: ANoB5pnv9LnoQIDXxLCXoAAT9onDw3GdnQo99JEcPfA5HpQ9nfAa7T6f
        WsslAuN8jvT8wzej8+yG6FSoVg==
X-Google-Smtp-Source: AA0mqf4zdMxabC4z75IUBpSayldvbtp6dIPECPxzJje8Er4BmPUwQVk9nxah3pnDMDG2oiihl+U/3Q==
X-Received: by 2002:a17:906:cd10:b0:7bc:571f:88be with SMTP id oz16-20020a170906cd1000b007bc571f88bemr3376230ejb.502.1669650211621;
        Mon, 28 Nov 2022 07:43:31 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n6-20020aa7db46000000b0046aa2a36954sm4854179edt.97.2022.11.28.07.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 07:43:31 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     Menglong Dong <imagedong@tencent.com>,
        Biao Jiang <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] mptcp: don't orphan ssk in mptcp_close()
Date:   Mon, 28 Nov 2022 16:42:37 +0100
Message-Id: <20221128154239.1999234-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221128154239.1999234-1-matthieu.baerts@tessares.net>
References: <20221128154239.1999234-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2032; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=JwFWq/JYJtFBTzm2gO+Ux4zYNsCZ00QrIWIAjG1IQbg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjhNboj5VtEkoyxoheiF6ow2EM+fzZRpG19HOXr1go
 owcnACaJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4TW6AAKCRD2t4JPQmmgcy/gEA
 Cpe+2PIrgV1hHxwtFNpQta9QT4g3jbV/udX1SeqxzmI/3RZefsITJ3BL8uw8lxc4XNwNdTGbZwfsBe
 h2V30S5/cKm9gXqt9GjITpUFDCizvhbiWFuHpXbFrcXWPDV1T3/8v323gM8/seYKlQmf21/GiZ9VFa
 Z7cIzZLY/Kc++8QKt8okqiOuB/Sco3DfbP/G68dQsIMzdncFbfZbhr9kuWnQyf9hdyTCF1g/Bo4k0T
 Kvi4d/xWeuDVvfbwDvWoqj/TuaFebhOVsRX4d/2FLpWlAVrJJ+e4h+eKSlH+QgZ8aI3VrSeha1j+tB
 cenmoMhckkBT5+ApTpzsL39NW7zl7nRJbbS4689ngEPbmUeVjPgxJ6QtcShPJzvdYHzkQaQmXy9oLY
 BXGi89xpI+p01YvSoF4JkgT7vL/4Dy7WR+3qLMhc4uXdhawRbugU9lhZuEr6afMnPFi0gZ2rFJuIPB
 GW0Pz6EssT/nodfR/Fr0hNtgqVAmQopn0EdW0CTydHkcLAkc3iC879hMEljeArtyMy2je3Kn+/q0u5
 9Lc8uHafbNEPmgnkN36zsjGzVkwH+Z6kKKvdldn0qWLSnUupCFFwDQrIFrm++yiYUF9YQ+pA8pMsQP
 peZuQz3Yz4mWNozOAuh1qRE4si1PQYMOSHHIcnZ6ZqfjUNcCXfYunlTapXaQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

All of the subflows of a msk will be orphaned in mptcp_close(), which
means the subflows are in DEAD state. After then, DATA_FIN will be sent,
and the other side will response with a DATA_ACK for this DATA_FIN.

However, if the other side still has pending data, the data that received
on these subflows will not be passed to the msk, as they are DEAD and
subflow_data_ready() will not be called in tcp_data_ready(). Therefore,
these data can't be acked, and they will be retransmitted again and again,
until timeout.

Fix this by setting ssk->sk_socket and ssk->sk_wq to 'NULL', instead of
orphaning the subflows in __mptcp_close(), as Paolo suggested.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Reviewed-by: Biao Jiang <benbjiang@tencent.com>
Reviewed-by: Mengen Sun <mengensun@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b6dc6e260334..1dbc62537259 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2354,12 +2354,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		goto out;
 	}
 
-	/* if we are invoked by the msk cleanup code, the subflow is
-	 * already orphaned
-	 */
-	if (ssk->sk_socket)
-		sock_orphan(ssk);
-
+	sock_orphan(ssk);
 	subflow->disposable = 1;
 
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
@@ -2940,7 +2935,11 @@ bool __mptcp_close(struct sock *sk, long timeout)
 		if (ssk == msk->first)
 			subflow->fail_tout = 0;
 
-		sock_orphan(ssk);
+		/* detach from the parent socket, but allow data_ready to
+		 * push incoming data into the mptcp stack, to properly ack it
+		 */
+		ssk->sk_socket = NULL;
+		ssk->sk_wq = NULL;
 		unlock_sock_fast(ssk, slow);
 	}
 	sock_orphan(sk);
-- 
2.37.2

