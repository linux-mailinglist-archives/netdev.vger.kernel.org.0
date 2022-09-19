Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B1D5BD52A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiISTZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiISTY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:24:59 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAC23DBF0;
        Mon, 19 Sep 2022 12:24:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id cc5so698996wrb.6;
        Mon, 19 Sep 2022 12:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=HljAIKGtMQmfvAqznIx3yiXSbVfexClUKVuIvpvyrF8=;
        b=NdjSmvmQzcplTGPjAEx+szn88cq+bNkW8nnAeZYHBbgD8xBqF0K5xKIIZa1jWGzNQI
         xdhT+hejxrFCi/g1RpVGWs+OyxiNpM+qu4mohac3DtjeK8/V8gqKUXBqhaBiwluNLIfm
         K4WocriVsITER/qX8AtUokGDftvs0MkmEUJWXAcMhHOuqPRS16/jc0wNbvDG4TDtHs3C
         XUir/A+aQI0aqWkbSyeNWzMfhWS0c++XDvduR6Ikp7OjN4IyVtspMOzPoEpkksXMq761
         wNmtdtABFzutMNcxf2K7zUm8yuQ02Q89zK8YZta4nbAxAvK8lL+QH33kiRU04zkQddhT
         uLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HljAIKGtMQmfvAqznIx3yiXSbVfexClUKVuIvpvyrF8=;
        b=Kizv+JHUkgs5oVqOVGiuYqJHADkBodIt0YtPOd/gM5YZDDgdkQvVt7cjCUElR//dR/
         f4qMnGFneCDF5MMj8thMlneEEVI87PKnE9Gdh/YuAmNRpof1QAXPGOeQb9D8CnU276sh
         3sRHfPvmMUURpAeYjgekfJvrPeYT/Su8nlME9m+H0K/A3quHUM+CiKJTJkWDiLKXZa15
         ycnMUwHyWEbmAPE6asHO0BHTvB/8dJ4nl57pLTZOpU2tZMGVP1LfxXCjcjbA7HyYX48P
         WiORzIZlEtI/Rppb4vnDAj9XDauJOwqFKjyvmBUqyKXAn1knAcH3vZ+a6E7/scqjY6Lp
         by2A==
X-Gm-Message-State: ACrzQf3tprXli17YVV6Khif46cTy86a/rOnDOfY+8V6smAeOoMpCyrFs
        Mo8e54D8vQMmXfxlh0Q0pV0p1iPnGhs=
X-Google-Smtp-Source: AMsMyM68DAEz1yCZXsAtQba6B2YakppXofRc8UMUP6D8Ka0X/PvqeseuArKrhtvrTGA/sC5yBAnvuA==
X-Received: by 2002:a05:6000:1e01:b0:22b:cee:e927 with SMTP id bj1-20020a0560001e0100b0022b0ceee927mr1668039wrb.133.1663615496713;
        Mon, 19 Sep 2022 12:24:56 -0700 (PDT)
Received: from ipe420-102 ([2a00:1398:4:ac00:ec4:7aff:fe32:721b])
        by smtp.gmail.com with ESMTPSA id m2-20020a7bce02000000b003b483000583sm14060955wmc.48.2022.09.19.12.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 12:24:55 -0700 (PDT)
Date:   Mon, 19 Sep 2022 19:24:54 +0000
From:   Jalal Mostafa <jalal.a.mostapha@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, jalal.a.mostapha@gmail.com,
        jalal.mostafa@kit.edu
Subject: [PATCH bpf] xsk: inherit need_wakeup flag for shared sockets
Message-ID: <YyjCBjJch24OT+Ia@ipe420-102>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
flag and of different queue ids and/or devices. They should inherit
the flag from the first socket buffer pool since no flags can be
specified once `XDP_SHARED_UMEM` is specified. The issue is fixed
by creating a new function `xp_create_and_assign_umem_shared` to
create xsk_buff_pool for xsks with the shared umem flag set.

Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
---
 include/net/xsk_buff_pool.h |  2 ++
 net/xdp/xsk.c               |  3 +--
 net/xdp/xsk_buff_pool.c     | 15 +++++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 647722e847b4..917cfef9d355 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -93,6 +93,8 @@ struct xsk_buff_pool {
 /* AF_XDP core. */
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
+struct xsk_buff_pool *xp_create_and_assign_umem_shared(struct xdp_sock *xs,
+						       struct xdp_sock *umem_xs);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5b4ce6ba1bc7..a415db88e8e5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -946,8 +946,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			/* Share the umem with another socket on another qid
 			 * and/or device.
 			 */
-			xs->pool = xp_create_and_assign_umem(xs,
-							     umem_xs->umem);
+			xs->pool = xp_create_and_assign_umem_shared(xs, umem_xs);
 			if (!xs->pool) {
 				err = -ENOMEM;
 				sockfd_put(sock);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index a71a8c6edf55..7d5b0bd8d953 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -112,6 +112,21 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	return NULL;
 }
 
+struct xsk_buff_pool *xp_create_and_assign_umem_shared(struct xdp_sock *xs,
+						       struct xdp_sock *umem_xs)
+{
+	struct xdp_umem *umem = umem_xs->umem;
+	struct xsk_buff_pool *pool = xp_create_and_assign_umem(xs, umem);
+
+	if (!pool)
+		goto out;
+
+	pool->uses_need_wakeup = umem_xs->pool->uses_need_wakeup;
+
+out:
+	return pool;
+}
+
 void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 {
 	u32 i;
-- 
2.34.1

