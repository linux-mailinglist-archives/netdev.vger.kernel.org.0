Return-Path: <netdev+bounces-3970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D818709DAC
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD3701C20AE6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF91125D9;
	Fri, 19 May 2023 17:16:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB431097B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:16:12 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FDDA0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:16:11 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75939de402dso188911285a.1
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684516570; x=1687108570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w2Nc6yy1Hj+6/ZeMmr6pcVZ4I78d2OLN8lpcraLIX0Q=;
        b=M0gEQYCCKUMb+R9IxL0cwRmmyf6mh7Ffid4rBPY+hCkKTVsAnPQOHK2EUw3K1JX6IU
         mpQwv8ZtiKpiOL66+gXvrbVXhElqpCOMLKMlr/RncqYa52a1pelZfnSVnzG2ZRfjGNzt
         eZ5f+zu6mfUXWf80tXkNkelKQON+wVBJD9mvp0KAhoqL5yaC7sfgTVau/JgKmpVdWfqC
         d3PivBnEg51avBANunMnYJqJdw+rYXN6fSIhlNhq7TxR/kJbzNj68bVwfCbAT90RyKGv
         AKhSQv77DJ4x+vBTreWw8NslBBOFDiWMz0jdfG4ZsPuUOzQxUsblx2S0uhuLTGP/6ySO
         i8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684516570; x=1687108570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w2Nc6yy1Hj+6/ZeMmr6pcVZ4I78d2OLN8lpcraLIX0Q=;
        b=FqcHLm1Mm6oWa5MHVX1uxcYp+d3dTEBX4B6FZWyT40FFjC0d6YKWGsaTdKWsqEJ9il
         d5WzSNWQgabScAZMVfcIwuAjrZPYtk/m+MttCskZ1xdRNkQ9C6ZcpZa+RBspqUynVO/j
         1GuPzNHuteefuRujOE9YCmW264yosO/VyDQ1gxEcX/4nGzxA1fEKdGs8ZI0ecTstfec3
         UbG7/wqwIKzmBL34Gx1rKYI3iQWPYlzAB8Y6yn+o3csBCFVMh2sfzOpR3e7DRaTpPmCC
         Br4GiZvfSClLsJhjz0yhJFMGsNAVYn4h/fMLct/CRdR84LtGPqy2Z6jG2o00OONTFW+j
         Figg==
X-Gm-Message-State: AC+VfDwJuroSkCJpqbDJjctflh7sDLY55TJySKLz8Yec/tHnG17DdDvy
	50+x+p9ndjIl3XdocLFGRAiBGS9D/ctnEA==
X-Google-Smtp-Source: ACHHUZ5Eo+Uy2P5QIF15GLKqNlaLEWY+lLp+ymhQkLhWz2wviPAeuv5wTqAvhEiDn0FdkB2m7EBfgg==
X-Received: by 2002:ac8:5991:0:b0:3f5:65e:f42f with SMTP id e17-20020ac85991000000b003f5065ef42fmr5054565qte.1.1684516570154;
        Fri, 19 May 2023 10:16:10 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s25-20020a05620a031900b00759495bb52fsm1244432qkm.39.2023.05.19.10.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 10:16:09 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net] rtnetlink: not allow dev gro_max_size to exceed GRO_MAX_SIZE
Date: Fri, 19 May 2023 13:16:08 -0400
Message-Id: <25a7b1b138e5ad3c926afce8cd4e08d8b7ef3af6.1684516568.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In commit 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536"),
it limited GRO_MAX_SIZE to (8 * 65535) to avoid overflows, but also
deleted the check of GRO_MAX_SIZE when setting the dev gro_max_size.

Currently, dev gro_max_size can be set up to U32_MAX (0xFFFFFFFF),
and GRO_MAX_SIZE is not even used anywhere.

This patch brings back the GRO_MAX_SIZE check when setting dev
gro_max_size/gro_ipv4_max_size by users.

Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/rtnetlink.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 653901a1bf75..59b24b184cb0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2886,6 +2886,11 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GRO_MAX_SIZE]) {
 		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_MAX_SIZE]);
 
+		if (gro_max_size > GRO_MAX_SIZE) {
+			err = -EINVAL;
+			goto errout;
+		}
+
 		if (dev->gro_max_size ^ gro_max_size) {
 			netif_set_gro_max_size(dev, gro_max_size);
 			status |= DO_SETLINK_MODIFIED;
@@ -2909,6 +2914,11 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GRO_IPV4_MAX_SIZE]) {
 		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]);
 
+		if (gro_max_size > GRO_MAX_SIZE) {
+			err = -EINVAL;
+			goto errout;
+		}
+
 		if (dev->gro_ipv4_max_size ^ gro_max_size) {
 			netif_set_gro_ipv4_max_size(dev, gro_max_size);
 			status |= DO_SETLINK_MODIFIED;
-- 
2.39.1


