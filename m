Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F399463916C
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiKYWaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiKYWai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C55D5800D
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:30 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n20so13160424ejh.0
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Cb2y/UtN3+Ws3JUnmppragcoaJ4ENOeTCAI1eAVlFM=;
        b=01N2xfDvgcjSbGMjylrmgTjJ9Bc13QikP569jRTFgVhoc0H6iuPm/1R0hjQQHj83rq
         1ttFxwNLBg8Bw886+QyslUvLZmXpq0mfr63ty1INQU77HyPsQxMMU4w8W2FJOvpgLnkD
         Ak4AWRy7qbeU99I3JOSRpJ1gJWy1uizWVoco8DYHdN5zS/lS4saQeNHutAu/F47VYlzs
         +8uUIFuko+RZA0EWgTq9f9RFh+67jtKVpWLZtj+oHiOYTK+vknsSmYJnlLfXYDGxNuUV
         nTr/o2kJZ3OS9xuwh0XlyZPoBE1d5ZfbjHgtVtyFqQbfpntAWIxTL6TbNQtrvzb22sGi
         Oxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Cb2y/UtN3+Ws3JUnmppragcoaJ4ENOeTCAI1eAVlFM=;
        b=QKJStzTONOyCG/HlbW6wqh0uiaEbH1+dfIpPPqrL9EZo8HcQecdYzdFBEopCMOnJio
         kAnQQ78cBx4WTwE6MgtbJwjUsqMeEa7pNDgxH66KfviJxyYdO5WnNVnRi+vO8/qu4gsN
         qpYPMVSLdnmuWzq/K62mDRd29iR4axHj+kXI7IKdhS3n1bknb5Cj1EuuugrRHFnGn8IT
         GcLLtWwu5bRfmXeSbQoGMLfWBSFobF3gkHtbsuLgltWnQbPdrEcdw3bAcKwxlx2q6E4/
         oDVQhSoApsJ2O6TuXEmBglNfrNcNjaUPlppT7Ud1iZk+s0xz56Q/4GtDQJkTpvot+qnQ
         oARw==
X-Gm-Message-State: ANoB5pm3cEw1gh5Yi+L1mMpbNF9JrSb9OM8xn0fmvuIWN1j5mCaIDZA6
        psjpsQ3VVrYf7lbN8j4/ZHlQdA==
X-Google-Smtp-Source: AA0mqf6xxK8WYM+lNhjpWP9rJ2n8b/ziVH3Ex8BQy4Meg4InWA43gG5qkbTGVS5xV+gneGzekuux/g==
X-Received: by 2002:a17:907:7796:b0:7b6:6086:75bc with SMTP id ky22-20020a170907779600b007b6608675bcmr23083760ejc.181.1669415428977;
        Fri, 25 Nov 2022 14:30:28 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:28 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] mptcp: add TCP_FASTOPEN sock option
Date:   Fri, 25 Nov 2022 23:29:52 +0100
Message-Id: <20221125222958.958636-7-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2069; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=3lYgndFAWxyUdVThAOH1DTU2iT5OHzt+/flIs4qdSmA=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHPHz7z7nQQ/ZU7tkAMYEJqt9sIdN822xr0gpN1
 21RZWhCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FBzwAKCRD2t4JPQmmgc0MmEA
 CPNfsIncIXq8fq2Gcg3wKHNfyVoZVZ6L/UTzsRsHUbaGrGp8amjthHO0ps6pAeK3a63cQmJZmI5i4z
 fPWVZvjt3sMd5Kuef01BgG7k/Ey4y0Rq0/2RewMYtsVmVDC8TxQFNt28Lbb2mVYlF5nHLOlgE6tXuR
 4Opi8wfxggdLOO7+epC1gttpqqkX+td76vBL/ltaB3UO7PnJuwfIuwVUFn1IuHpj1H3Y21kCMQoTay
 LKBwRdScBYqBwLQk5B/9cyNwB5GvlaqXkR3dI7kMHuUy8l1md6ekv3m0829EQbp+vsPuLc7h9tj/bo
 MY8PkUimbNGfovbxjZrSXTpsI0xzIiCAD+p5t8Fyr3T3hCGDux/7qzuWrfoZWmKlg7O9Wf2hlFZK+y
 sv+veiRWLnNUHLwM6mQBFi48oqOl0msDj8o7RQAfNcN7jwmDAL8wYUR20wHzspcb+9E+mmqoVwp6QW
 h0ENTBEDuoXkDaAvPKrUHwvdLuYm5Mj/WmFw71SY5s3xFyR1tevNVQjHu/GwOx9xsZsSm2YSvlAZuI
 1z3DVR+gd7hdQfAVDV1tepjtlUCd3YkkWwlx64oYRJmDcKI+WAxc16zQijOACIm98c15NTFXJ0dVlV
 njTk1sIkK3F/6pg6HJcIT2LcXE7BbFfYSa6i14O2SxPFe6i0ZlQeg2CWXeTw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>

The TCP_FASTOPEN socket option is one way for the application to tell
the kernel TFO support has to be enabled for the listener socket.

The only thing to do here with MPTCP is to relay the request to the
first subflow like it is already done for the other TCP_FASTOPEN* socket
options.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/sockopt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index f62f6483ef77..c1bca711c35c 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -559,6 +559,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_NOTSENT_LOWAT:
 		case TCP_TX_DELAY:
 		case TCP_INQ:
+		case TCP_FASTOPEN:
 		case TCP_FASTOPEN_CONNECT:
 		case TCP_FASTOPEN_NO_COOKIE:
 			return true;
@@ -569,7 +570,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		/* TCP_REPAIR, TCP_REPAIR_QUEUE, TCP_QUEUE_SEQ, TCP_REPAIR_OPTIONS,
 		 * TCP_REPAIR_WINDOW are not supported, better avoid this mess
 		 */
-		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN are not supported because
+		/* TCP_FASTOPEN_KEY is not supported because
 		 * fastopen for the listener side is currently unsupported
 		 */
 	}
@@ -801,6 +802,7 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 		/* See tcp.c: TCP_DEFER_ACCEPT does not fail */
 		mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname, optval, optlen);
 		return 0;
+	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
@@ -1166,6 +1168,7 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_INFO:
 	case TCP_CC_INFO:
 	case TCP_DEFER_ACCEPT:
+	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
-- 
2.37.2

