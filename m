Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADF34CA9F8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbiCBQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241440AbiCBQSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:18:18 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB5A11A2F;
        Wed,  2 Mar 2022 08:17:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4so2202499pjh.2;
        Wed, 02 Mar 2022 08:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oub+iKZ2LUr5ud/wkqRk/erUc2bROrYBkUR2gSNDvSg=;
        b=kWE9GGx2pWlySjXXKxGqXf6V09YM09ZAe1iw+vzNuuAOTkK636oYfutUZDyw+C/Vus
         eUyk4tY6kEpKze+1MNE42hvv3b9DYuzwXlkonrX8/oZD33keIdusLhKyxkFfpXojRMzq
         XbhmiO6Oc00raQHEdukkFFrMqY1PMayvI1jL9uuNlD7xmCz8mRmR4DhUvOKTCqPrtqNz
         KO3hrrsrh1OLkZKkP5Jzd3Kup2VupX6tSGZkJZKqH5S+AjO5NDP+wXsFQQeVPJ3pLkfm
         FLS2YTLGzwWy+oSPyw6+yv/CBDlg9eqKNOQAuQF+d+Nq3nl25KcLZfg6DZYUTdnWgGPW
         +goQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oub+iKZ2LUr5ud/wkqRk/erUc2bROrYBkUR2gSNDvSg=;
        b=NEgXB4GaTdPvGf6yaZVQPullYb/syWOYbxOSj9T9AtZHe3ApChaZwh1RwlMOEtApSO
         cyC+h2EUmMGISFKWu3JQF2twoQnyUXPXkm/ijmYMP+nOb7fSkyhs5CseYPpnSJgeuuWr
         hFXs73UmEOBdkkONpuUiUFoQNlBD6SB9Da2tYfJI7q3Sq2qOBTBWkL9+OCi2s019tRua
         cvR3nNypZQIP3n/3X6lOVEi1IJpjlNeiz4jY96uim/xEYxI6DThju/qUJLLkPgbYQbei
         +okZx4HMEA71OrmcfktudpB+KyEVSxzeeG3qOE2Baq3TQHqjK1L2kAN8Qt1QbioceC4p
         i36A==
X-Gm-Message-State: AOAM532HMxjCt4T4WmaZnr1vatAcYjhqdKeyYz3ap4iTYdOX5z2BsYkq
        D75ZKNQii+eqNoVYxFN/SPA=
X-Google-Smtp-Source: ABdhPJyEOlKJIvzdVTV4NumljRsK8W9uPFhd9lAOmPgyLipbBG1nnsvCbz/Wsr//WUpb7I8NQAh9rg==
X-Received: by 2002:a17:90b:1104:b0:1b8:b90b:22c7 with SMTP id gi4-20020a17090b110400b001b8b90b22c7mr547182pjb.45.1646237854560;
        Wed, 02 Mar 2022 08:17:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7e41:847f:4bb0:a922])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b004f1063290basm21771704pfu.15.2022.03.02.08.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:17:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 2/2] tcp: make tcp_read_sock() more robust
Date:   Wed,  2 Mar 2022 08:17:23 -0800
Message-Id: <20220302161723.3910001-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
In-Reply-To: <20220302161723.3910001-1-eric.dumazet@gmail.com>
References: <20220302161723.3910001-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

If recv_actor() returns an incorrect value, tcp_read_sock()
might loop forever.

Instead, issue a one time warning and make sure to make progress.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/ipv4/tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 02cb275e5487d98b3e124ee102163aac47b2ad6d..28ff2a820f7c935234e5ab7ecd4ed95fb7c5712a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1684,11 +1684,13 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				if (!copied)
 					copied = used;
 				break;
-			} else if (used <= len) {
-				seq += used;
-				copied += used;
-				offset += used;
 			}
+			if (WARN_ON_ONCE(used > len))
+				used = len;
+			seq += used;
+			copied += used;
+			offset += used;
+
 			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
-- 
2.35.1.574.g5d30c73bfb-goog

