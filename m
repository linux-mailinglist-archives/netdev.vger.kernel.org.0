Return-Path: <netdev+bounces-8227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AF3723292
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 571DF281430
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BE927711;
	Mon,  5 Jun 2023 21:55:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBDE209BD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:55:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29492FA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686002135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8/mCPKtf0jOT7rHIDbUUG1aVWTYvUVhyYNkkZEgUIc=;
	b=Dy+HFSWHNPESngm8h0dJAJcYN2Hfsz3X6P6VgJufJ/NMtUIpjjRaIvV7tMqxMI8W3bvJjq
	2/RCgtyQqZ5IwEvb/slqwko6+vgifNtNeD5KNOnFDkeKCyJaf5qsdz4R5s97SU89G06oyS
	86GQb40/eFJRfmfgzSRE8bbIpBDl/lM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-tGhHioSyO9-hxCjq4_Y4-A-1; Mon, 05 Jun 2023 17:55:34 -0400
X-MC-Unique: tGhHioSyO9-hxCjq4_Y4-A-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f7e4dc0fe5so9175555e9.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 14:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686002133; x=1688594133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8/mCPKtf0jOT7rHIDbUUG1aVWTYvUVhyYNkkZEgUIc=;
        b=JBSlwj4iKA7F2CnSfnE2+jclhSYiNmT+yH/Q4euVkQa9djTIS+1OjgizuABAqum3A0
         0yAQ3wDDMS0SqCV1+52eUjcpCwLALNTK+KxhO70+yov+/bIMaPaZ8Uf2hX/uYmWdRi5D
         OwM8R5XQmSf2cfrfK/fBz1MhETMsG3cxIkHqK49FrEOBNorjSugdJpPk8V/o9ibwLG2w
         mp02bktjcYqMdvTDyk3UbJosZ12o5Xk1T/eTSZxuSWO0ry2DZHyqRHf86AtZ3Bdn87WG
         JBp4em/sAicZUc24fp7VlV74VVwYr1neEWwBcqdKqDf+XtEhwHy3ScLoSPRAhohOm7Qf
         fz6A==
X-Gm-Message-State: AC+VfDxx1yvctw/wRtJupxYmQDYVadjwN02VUle5dPluhDyrEw1D3iKO
	tnhQ/5khs0S58tZbv9CpRIj1S66heNPAW8cJmZ+dwBjjxICHyVOD/p8dPQ0cIwzgHx+BsQZ8Xh3
	X+kzgDdBEaqRjbJEk
X-Received: by 2002:a5d:4b86:0:b0:30a:e8de:f820 with SMTP id b6-20020a5d4b86000000b0030ae8def820mr223146wrt.30.1686002132997;
        Mon, 05 Jun 2023 14:55:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5rnAdwo6u5M+p/dlX+zFvM0rtWREwll5aQIfadE3wvfvTxrIWY60I1f5U8hB2BS62W7BjCzw==
X-Received: by 2002:a5d:4b86:0:b0:30a:e8de:f820 with SMTP id b6-20020a5d4b86000000b0030ae8def820mr223138wrt.30.1686002132805;
        Mon, 05 Jun 2023 14:55:32 -0700 (PDT)
Received: from debian (2a01cb058d652b00e108d67e5e2d3758.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:e108:d67e:5e2d:3758])
        by smtp.gmail.com with ESMTPSA id d17-20020a056000115100b0030af15d7e41sm10896945wrx.4.2023.06.05.14.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 14:55:32 -0700 (PDT)
Date: Mon, 5 Jun 2023 23:55:30 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 2/2] tcp: Set route scope properly in
 cookie_v4_check().
Message-ID: <045a05d5134c2443600589377a9c37b40581595c.1685999117.git.gnault@redhat.com>
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

RT_CONN_FLAGS(sk) overloads flowi4_tos with the RTO_ONLINK bit when
sk has the SOCK_LOCALROUTE flag set. This allows
ip_route_output_key_hash() to eventually adjust flowi4_scope.

Instead of relying on special handling of the RTO_ONLINK bit, we can
just set the route scope correctly. This will eventually allow to avoid
special interpretation of tos variables and to convert ->flowi4_tos to
dscp_t.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/syncookies.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 26fb97d1d4d9..dc478a0574cb 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -418,8 +418,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	 * no easy way to do this.
 	 */
 	flowi4_init_output(&fl4, ireq->ir_iif, ireq->ir_mark,
-			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE, IPPROTO_TCP,
-			   inet_sk_flowi_flags(sk),
+			   ip_sock_rt_tos(sk), ip_sock_rt_scope(sk),
+			   IPPROTO_TCP, inet_sk_flowi_flags(sk),
 			   opt->srr ? opt->faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, th->source, th->dest, sk->sk_uid);
 	security_req_classify_flow(req, flowi4_to_flowi_common(&fl4));
-- 
2.39.2


