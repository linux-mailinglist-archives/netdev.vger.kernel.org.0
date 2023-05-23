Return-Path: <netdev+bounces-4620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13FF70D977
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCCBF1C20D35
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4600D1E51E;
	Tue, 23 May 2023 09:47:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0FF1DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:47:19 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA57109
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2b42a8f9so4052114b3a.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684835237; x=1687427237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JbrrHsu8KzXBp8abtNpZsLO9DbdsQWsXzCPkkoYMdc=;
        b=LeHmRtCQCbob1Ad8YEm2YLv5mAvn+aMuWIv78A1fohJzHjOiXc2rnwxby8WYnL/ewR
         MM/7pB74gbS7eWJdjpORMMbyBiKMsXNEt5il7o9ta5Xb8AQNhVbeCV53MtlCKD+g508Q
         blH+tGTg7Ad8TJmgxxgRqvyA+gGdI+HlgAxQPcczFNCWeQ9K2YrePJc4cC9xs85ovsqf
         KpGnxmHPLuTkrbE7lo+EzKQQENuGbRlZiS2MY4/iSmoOG0eV0ubhmDgjaQQ/+E313Fq0
         xqIhDGAC3+YdMS3ra3frtU5ICniR63D2pB6KBB73hMsEgnpaEENCB6/OsfpVmRS6qRJc
         NL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684835237; x=1687427237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JbrrHsu8KzXBp8abtNpZsLO9DbdsQWsXzCPkkoYMdc=;
        b=YOhIb9svO/WRuRutIMu1/nuIy6H/wz2Un6QoUc8bHXwqPYqhcHmjWPMmA9xYVo/56T
         nOBquISl5Y6ZPO+ligsdN/aS5bCBgcRoAEHXovMRxKyLKEvdFoATBszNavvU/50yksIm
         lLd+BjM6CXfA2/rN5YGQJoh2UhqbG6b0gziIqxNs1Lje9faMZ6lv/Bl86Iz90PDtTZJk
         Or3Y563sS/fNXxfBCzbmlaLlF0epYMfrfis4xxKZ9CUR/khAifQbYeBkYEwxasnDqymK
         DvhqQ/YQUs3WVIWbD+F+zBtmvR3+RSQOcmYTiHi1jbNJOi5A0mMB/h48NAfZg6+6dh6u
         Nofg==
X-Gm-Message-State: AC+VfDzr0fbaCFTztFecb2IfP1ZvRDp97A0xwUOHvloJg7VC/rl1KPTz
	OWzPMPLMS8z7UpLVDUphjyMzE9e179tpIBv4Z0w=
X-Google-Smtp-Source: ACHHUZ4S1nlt676DSbN0WKhez6GOfAS9tr9gLhf6vmcHbhMyBBQJuTFycQSDrPFN6/5nIhSjkHTd8w==
X-Received: by 2002:a05:6a20:3d0c:b0:106:8b:99d2 with SMTP id y12-20020a056a203d0c00b00106008b99d2mr16375595pzi.51.1684835236832;
        Tue, 23 May 2023 02:47:16 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79116000000b0063b898b3502sm5457216pfh.153.2023.05.23.02.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:47:16 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v3 2/5] sock: Always take memcg pressure into consideration
Date: Tue, 23 May 2023 17:46:49 +0800
Message-Id: <20230523094652.49411-3-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230523094652.49411-1-wuyun.abel@bytedance.com>
References: <20230523094652.49411-1-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The sk_under_memory_pressure() is called to check whether there is
memory pressure related to this socket. But now it ignores the net-
memcg's pressure if the proto of the socket doesn't care about the
global pressure, which may put burden on its memcg compaction or
reclaim path (also remember that socket memory is un-reclaimable).

So always check the memcg's vm status to alleviate memstalls when
it's in pressure.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 641c9373b44b..b0e5533e5909 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
-	if (!sk->sk_prot->memory_pressure)
-		return false;
-
 	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return !!*sk->sk_prot->memory_pressure;
+	return sk->sk_prot->memory_pressure &&
+		*sk->sk_prot->memory_pressure;
 }
 
 static inline long
-- 
2.37.3


