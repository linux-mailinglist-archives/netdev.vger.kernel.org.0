Return-Path: <netdev+bounces-8226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5AC723291
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4774281464
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738A52771E;
	Mon,  5 Jun 2023 21:55:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AD0209BD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:55:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B31EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686002130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JfW3u2f0/QmjhXipNOQ3+EF3poWGoa+++VQRJAqz7+U=;
	b=CawoAXANt0tq9dps5GwRZutIM2OY7lhVwi1Vtf/J3Qh+K4c6uLSPriCoxzOSL+bFjEa+xd
	0WgIXamIJDmuMGCpzPn+ux+DsHurZSgkPjwXIslpmGVAlZ3Kb4O3a/ozwpjTWaDMvYA7Nu
	3/jRGhPuFOuWzCETOxZ1J7OAZuoaPOE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-281PXgzNPT2H2HdVjYVELA-1; Mon, 05 Jun 2023 17:55:28 -0400
X-MC-Unique: 281PXgzNPT2H2HdVjYVELA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f5fa06debcso31511135e9.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 14:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686002127; x=1688594127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfW3u2f0/QmjhXipNOQ3+EF3poWGoa+++VQRJAqz7+U=;
        b=ZdKS+ZgzxlTe5bplav0NRxvw4UYjoo1CkDW3Xr1U6uHVLys4zsgyXrQhSycQLQGZPV
         2KO+2QJx+G4XvNZDVGz0vQlOfCZ3hvuQeAu9TvxL3vwrxTq9JYDiN9hkS/fluUUS9T56
         Rr/nwiT8ft1qo0Gawwvg1H/A46YWJWoO/6UnQWHMlro5/1tZ0ZuuACc/7p9erkgAvlWW
         tH+/feMP78uRvmsbD3a0SOq1eV20HNzX1RLkcf0tSt1X3AtiL7R4tz+HZb+oeU/U8mCQ
         +YYGonRuzfj09Q1vMQLz4Y/CNwmf0yZs/XQj9LjBeancslPuYiicfAB/uGnIavap/TIF
         gsew==
X-Gm-Message-State: AC+VfDzkLdf7Gtiz+1zQ2uHuT8Ia/K3eHv2O8la9+iZCRrY9CJG4BDHu
	+x+i9XgTTzdJh+Omi2RkNjc8PVN7j2bO0kjA6F9fTMrF52rtYf2JIg47PlUp2/Mv4wax9gb8+0W
	J9qTWYwYXETFKDfi3MUfcPco3
X-Received: by 2002:a05:600c:2158:b0:3f6:89a:94c8 with SMTP id v24-20020a05600c215800b003f6089a94c8mr320280wml.24.1686002127612;
        Mon, 05 Jun 2023 14:55:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5fJvcWMyujpuWlVu+irJK2MgG4ighOty2Olg/toUqMfdR+ZYAHWqZzzNjAWTb3ei6Ft1Aceg==
X-Received: by 2002:a05:600c:2158:b0:3f6:89a:94c8 with SMTP id v24-20020a05600c215800b003f6089a94c8mr320271wml.24.1686002127401;
        Mon, 05 Jun 2023 14:55:27 -0700 (PDT)
Received: from debian (2a01cb058d652b00e108d67e5e2d3758.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:e108:d67e:5e2d:3758])
        by smtp.gmail.com with ESMTPSA id k23-20020a05600c0b5700b003f72a7918e7sm9775409wmr.45.2023.06.05.14.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 14:55:27 -0700 (PDT)
Date: Mon, 5 Jun 2023 23:55:25 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 1/2] ipv4: Set correct scope in inet_csk_route_*().
Message-ID: <08fb058e8cf99ab1f9178caac52e665f94fcba3c.1685999117.git.gnault@redhat.com>
References: <cover.1685999117.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1685999117.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RT_CONN_FLAGS(sk) overloads the tos parameter with the RTO_ONLINK bit
when sk has the SOCK_LOCALROUTE flag set. This is only useful for
ip_route_output_key_hash() to eventually adjust the route scope.

Let's drop RTO_ONLINK and set the correct scope directly to avoid this
special case in the future and to allow converting ->flowi4_tos to
dscp_t.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/inet_connection_sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1386787eaf1a..15424dec4584 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -792,7 +792,7 @@ struct dst_entry *inet_csk_route_req(const struct sock *sk,
 	opt = rcu_dereference(ireq->ireq_opt);
 
 	flowi4_init_output(fl4, ireq->ir_iif, ireq->ir_mark,
-			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE,
+			   ip_sock_rt_tos(sk), ip_sock_rt_scope(sk),
 			   sk->sk_protocol, inet_sk_flowi_flags(sk),
 			   (opt && opt->opt.srr) ? opt->opt.faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, ireq->ir_rmt_port,
@@ -830,7 +830,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
 	fl4 = &newinet->cork.fl.u.ip4;
 
 	flowi4_init_output(fl4, ireq->ir_iif, ireq->ir_mark,
-			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE,
+			   ip_sock_rt_tos(sk), ip_sock_rt_scope(sk),
 			   sk->sk_protocol, inet_sk_flowi_flags(sk),
 			   (opt && opt->opt.srr) ? opt->opt.faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, ireq->ir_rmt_port,
-- 
2.39.2


