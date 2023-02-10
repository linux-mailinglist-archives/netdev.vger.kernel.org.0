Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CFE6925B6
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjBJSrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjBJSrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:47:23 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9D51555C
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:13 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id bz17-20020a05622a1e9100b003b9c1013018so3595958qtb.18
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676054832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J95RRPC1UMypjBanuvLI2QNtK8Epu3Wc6+p+wpC6jGI=;
        b=krj3/UEJv1G0UpOhlENZQkfBYn9siS1h7/nrnmhvvOD/7v6tt/0OAVlH6+60vYp4UA
         f2wpAywtPc3uS8tG5rnFsAVsWjbH8ZRuuAXggYPmVBsv5p2Lncqa2zu0BvKSf33QdtA3
         6z9JxwsHT0vmMb3NeuJphtMm/XsNLSjN3AVVKceptRHbFleupekH/PHZ4//65eHYZCEq
         Wqh6qqxhcO/+HAxL1FKKN+9e1wfi87b51YDN8GMjCJb7rYzVZ1K+2zwoIAbMInR1FmGd
         B6deYUNlVETSXndLMT7gGP9U3zh2mHGmHebEFhQB9Dwrz0MrU3jAD5Eo/JYWoz+06QY7
         O4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676054832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J95RRPC1UMypjBanuvLI2QNtK8Epu3Wc6+p+wpC6jGI=;
        b=H8HrADf7rBvckPcWuXZ1K8UTlU7xsy+qdHYclhCM2TgYPyXiCV9doX2jsKrefT+knG
         dNSro6ddCgFzLksdpvGDSqLcJsODKYDlfF2Q7Akta1C+41YDgCc6RRcc86MUdH6NQRyH
         h/NsKJYgUkLzO3mkeyVKYyHMCQl1tsjQ8YVFWm1VCElPGMw6eWdw4iwC4hMkU+GzR53k
         xSVw9l5dQqFqAjnvbRAgSbfQ7O9a4L4NmOy/Kcpgyd2pZNMwutyo/NwdoqA4f74qO8ah
         oKI6MvebTHbkenl3/bq/DGwMM6uriqhrtjUGPN/CzQy5oq6mGLUVlve+PbKQNHT7IvXw
         o7aQ==
X-Gm-Message-State: AO0yUKXMZjnclgwjAqUoM/+MHHG2ny/PQRY+fKBilIe9ua7xkGwnFaRH
        nShgwiEop8mPlsw/1/tJqbNHUoFaj/qJcA==
X-Google-Smtp-Source: AK7set99lyjvgf9RjhSM8mNvZmJ4/QEpGHdrEC7hPErXvSN6vh9+LoQf5qazOD79ypDNf5MTlMBbywWALvBYwA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0c:f4d2:0:b0:4c7:3b1c:8708 with SMTP id
 o18-20020a0cf4d2000000b004c73b1c8708mr1177091qvm.9.1676054832306; Fri, 10 Feb
 2023 10:47:12 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:47:05 +0000
In-Reply-To: <20230210184708.2172562-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230210184708.2172562-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210184708.2172562-2-edumazet@google.com>
Subject: [PATCH net-next 1/4] net: dropreason: add SKB_DROP_REASON_IPV6_BAD_EXTHDR
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This drop reason can be used whenever an IPv6 packet
has a malformed extension header.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 94bc3d5d880305a8c968a1801dabef83d995c567..6c41e535175cfba44f1f948305c5a1ebc5be9a18 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -72,6 +72,7 @@
 	FN(FRAG_REASM_TIMEOUT)		\
 	FN(FRAG_TOO_FAR)		\
 	FN(TCP_MINTTL)			\
+	FN(IPV6_BAD_EXTHDR)		\
 	FNe(MAX)
 
 /**
@@ -318,6 +319,8 @@ enum skb_drop_reason {
 	 * the threshold (IP_MINTTL or IPV6_MINHOPCOUNT).
 	 */
 	SKB_DROP_REASON_TCP_MINTTL,
+	/** @SKB_DROP_REASON_IPV6_BAD_EXTHDR: Bad IPv6 extension header. */
+	SKB_DROP_REASON_IPV6_BAD_EXTHDR,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
-- 
2.39.1.581.gbfd45094c4-goog

