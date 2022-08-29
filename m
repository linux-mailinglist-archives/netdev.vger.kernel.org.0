Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A748C5A4AFB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiH2ME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH2MEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:04:32 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD9A9C21C;
        Mon, 29 Aug 2022 04:49:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n17so9849145wrm.4;
        Mon, 29 Aug 2022 04:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=WSe10S+UrlTuQKvK/O7PfNOC5iT/6H3QC5eaRG38WEw=;
        b=LAxp47JBaTGyv93BoVrRKUlb1IN6IC4DAWm6nF1Cfo9jbYyQ1Cf2YaB8Cl/cLuH3A1
         wcqeSxxKzq1suPI7vl3hwv9XXQaeLW+j7EJ/bganLFBmHqmazeGdSBrwmAhQn6R23zSN
         pQI5/eKRW0R4W5zjlSUKGvDZJkj2LIEnLSlOdFh5N/P+lNOMkjHY+5RuuYPAwLGplp0C
         eDwpLobySDdr2Pl3zCiqyitlLzJPOHi0YSjpX6M54N/StmqXZxRWzTqKhe/8ICDtEx0P
         Lx+72juIHuaSbu00WA/BCx+IebL3+HdDG3QONd+UIQEZQmGG4qqY+QKofi+31Wjy/5MB
         zjcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=WSe10S+UrlTuQKvK/O7PfNOC5iT/6H3QC5eaRG38WEw=;
        b=yZGv3O0xuLFo7KvPpk8PQIcfdsX6gblpw6TZb/Tt71fMOGpkc6HnHxLhYMTMszrE/s
         Nlnmyj2Fsnn20UV8XARXJNAdVwhBKxMTtZ834LxB6tdkKEV+NtgGiL9l3AEINvgwpnN4
         VlfvRrho13YGxmKKc1OZ1bUIZ8gLvy/7fCFjH16FzijuyYpUdfNoI9SLE+4L+IVaHOrE
         b/vpplluY2ZvjBULlq55xSJTorYJMY8e1L5+iVkw5U2n12/LlOhnu/RiCYgRTPoGCpuU
         IivhcSTzOdBUwC91Kswrf6UtFlUydh39ICx1DRKf7hKhrIVnx3sW2/aujxFshVdiR+u7
         cj+A==
X-Gm-Message-State: ACgBeo1OmJeRQDxTy7QjA60BEOqnerpbSAceLV04fuHTuxrFJ5W0aCdf
        VkuKggLxUAo66jpGapzmE1Q=
X-Google-Smtp-Source: AA6agR6kfgXYwZGeBJpTHShgVFVG4lxwfk9krywGZYd0suW6qyKg1rpeZ4+h2TiYTq/A8FltRxBBvA==
X-Received: by 2002:a05:6000:4005:b0:225:8b27:e6d5 with SMTP id cy5-20020a056000400500b002258b27e6d5mr6066243wrb.603.1661773679149;
        Mon, 29 Aug 2022 04:47:59 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm7047402wrb.109.2022.08.29.04.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:47:58 -0700 (PDT)
Date:   Mon, 29 Aug 2022 13:46:08 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        stefan@datenfreihafen.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, kafai@fb.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 2/4] net-next: ip6: fetch inetpeer in ip6frag_init
Message-ID: <20220829114600.GA2374@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obtain the IPv6 peer in ip6frag_init, to allow for peer memory tracking
in the IPv6 fragment reassembly logic.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/ipv6_frag.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 5052c66e22d2..62760cd3bdd1 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -6,6 +6,7 @@
 #include <net/addrconf.h>
 #include <net/ipv6.h>
 #include <net/inet_frag.h>
+#include <net/inetpeer.h>
 
 enum ip6_defrag_Richard Goberts {
 	IP6_DEFRAG_LOCAL_DELIVER,
@@ -33,9 +34,11 @@ static inline void ip6frag_init(struct inet_frag_queue *q, const void *a)
 {
 	struct frag_queue *fq = container_of(q, struct frag_queue, q);
 	const struct frag_v6_compare_key *key = a;
+	const struct net *net = q->fqdir->net;
 
 	q->key.v6 = *key;
 	fq->ecn = 0;
+	q->peer = inet_getpeer_v6(net->ipv6.peers, &key->saddr, 1);
 }
 
 static inline u32 ip6frag_key_hashfn(const void *data, u32 len, u32 seed)
-- 
2.36.1

