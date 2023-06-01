Return-Path: <netdev+bounces-7162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF3B71EF33
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85CC828186E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B774F182B2;
	Thu,  1 Jun 2023 16:37:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D313AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:37:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1790D184
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685637473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=dRovf0TkfwZJtEX8LS1CrpRlVRui8vInd6qNhP+IgAU=;
	b=CyTu3MZrrPxN7wa8b+j375KEHR/pq/hoD1QlRkNpttH+v0rInQ9/HC8w1754ETjBRtX9Sz
	RlRaJuRczeOfmGOQGp67SxIBgp1obWjz+UlA056L3nblT5/Ks4q0BHLEhr7Bm36z8i1NoE
	FVnf3q2s280sqTeqiurNTvy/+Ga5naw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-dXQW2w02MPe4HVhCWTJXxA-1; Thu, 01 Jun 2023 12:37:51 -0400
X-MC-Unique: dXQW2w02MPe4HVhCWTJXxA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30634323dfeso637955f8f.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 09:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685637470; x=1688229470;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dRovf0TkfwZJtEX8LS1CrpRlVRui8vInd6qNhP+IgAU=;
        b=NbAH/RqHnprewKok6J4QsrAScXPr9WC9hQy+XoIdN3pUcSilrebih8o3JmkZVfTfR4
         n19Iwt7SyNynwcY8Fs3gzGySIT8vte64lu6M059kAD0w/asYvYaVUUw2ziWARdMtHJb6
         Iy8b2l4nzRXB5TgUJHJ/YrzOAUhycl2OleFOWhYD2cTDcQONm45OXx+qub2k0RUPilk/
         OZaa5y1On1iCrTF29TfBfnu7Cp5MASFce5Voo6Yg15Om2FO9rxiKHtoW7xV49XpzPBIK
         Fh7AwUmFnMPS1Bu6vWQYfcRwie7JknqLvKFCBqWM8PD+RidS3pxhXUa/RWaSrdlylfD0
         j4FA==
X-Gm-Message-State: AC+VfDy0mZCYsx/sFLkSF+GosO4O+yH4b8fAI8Quxx+am7qDlfyvPwkH
	OyTgUZckEKaunb0lg9fX7AhwrE/aYG6P13YGspb0wgS0acgurZ59O9DWwSaFtFiQUYqaYqWxlZF
	Fjsa/tVVyGNFpD4Cb
X-Received: by 2002:adf:fdc8:0:b0:309:491b:39cc with SMTP id i8-20020adffdc8000000b00309491b39ccmr2434126wrs.3.1685637470085;
        Thu, 01 Jun 2023 09:37:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6JVA6VBrHcu7cvcqoCX6KNzAEDFjHTUEK5n3WMHdpDFWf5hbeKmeVD4ZD8rlugE3eyWAldUw==
X-Received: by 2002:adf:fdc8:0:b0:309:491b:39cc with SMTP id i8-20020adffdc8000000b00309491b39ccmr2434110wrs.3.1685637469752;
        Thu, 01 Jun 2023 09:37:49 -0700 (PDT)
Received: from debian (2a01cb058918ce0082e9cbca34104a7c.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:82e9:cbca:3410:4a7c])
        by smtp.gmail.com with ESMTPSA id y20-20020a05600c365400b003f60fb2addbsm2824436wmq.44.2023.06.01.09.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 09:37:49 -0700 (PDT)
Date: Thu, 1 Jun 2023 18:37:46 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net-next] ipv4: Drop tos parameter from flowi4_update_output()
Message-ID: <f9e28cf551d9efb9278ac80d34d458295d8c845a.1685637136.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Callers of flowi4_update_output() never try to update ->flowi4_tos:

  * ip_route_connect() updates ->flowi4_tos with its own current
    value.

  * ip_route_newports() has two users: tcp_v4_connect() and
    dccp_v4_connect. Both initialise fl4 with ip_route_connect(), which
    in turn sets ->flowi4_tos with RT_TOS(inet_sk(sk)->tos) and
    ->flowi4_scope based on SOCK_LOCALROUTE.

    Then ip_route_newports() updates ->flowi4_tos with
    RT_CONN_FLAGS(sk), which is the same as RT_TOS(inet_sk(sk)->tos),
    unless SOCK_LOCALROUTE is set on the socket. In that case, the
    lowest order bit is set to 1, to eventually inform
    ip_route_output_key_hash() to restrict the scope to RT_SCOPE_LINK.
    This is equivalent to properly setting ->flowi4_scope as
    ip_route_connect() did.

  * ip_vs_xmit.c initialises ->flowi4_tos with memset(0), then calls
    flowi4_update_output() with tos=0.

  * sctp_v4_get_dst() uses the same RT_CONN_FLAGS_TOS() when
    initialising ->flowi4_tos and when calling flowi4_update_output().

In the end, ->flowi4_tos never changes. So let's just drop the tos
parameter. This will simplify the conversion of ->flowi4_tos from __u8
to dscp_t.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
Looks like oif could be removed too.
---
 include/net/flow.h              | 3 +--
 include/net/route.h             | 6 ++----
 net/netfilter/ipvs/ip_vs_xmit.c | 4 ++--
 net/sctp/protocol.c             | 4 +---
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index bb8651a6eaa7..7f0adda3bf2f 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -116,11 +116,10 @@ static inline void flowi4_init_output(struct flowi4 *fl4, int oif,
 }
 
 /* Reset some input parameters after previous lookup */
-static inline void flowi4_update_output(struct flowi4 *fl4, int oif, __u8 tos,
+static inline void flowi4_update_output(struct flowi4 *fl4, int oif,
 					__be32 daddr, __be32 saddr)
 {
 	fl4->flowi4_oif = oif;
-	fl4->flowi4_tos = tos;
 	fl4->daddr = daddr;
 	fl4->saddr = saddr;
 }
diff --git a/include/net/route.h b/include/net/route.h
index bcc367cf3aa2..5a5c726472bd 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -321,8 +321,7 @@ static inline struct rtable *ip_route_connect(struct flowi4 *fl4, __be32 dst,
 		if (IS_ERR(rt))
 			return rt;
 		ip_rt_put(rt);
-		flowi4_update_output(fl4, oif, fl4->flowi4_tos, fl4->daddr,
-				     fl4->saddr);
+		flowi4_update_output(fl4, oif, fl4->daddr, fl4->saddr);
 	}
 	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 	return ip_route_output_flow(net, fl4, sk);
@@ -337,8 +336,7 @@ static inline struct rtable *ip_route_newports(struct flowi4 *fl4, struct rtable
 		fl4->fl4_dport = dport;
 		fl4->fl4_sport = sport;
 		ip_rt_put(rt);
-		flowi4_update_output(fl4, sk->sk_bound_dev_if,
-				     RT_CONN_FLAGS(sk), fl4->daddr,
+		flowi4_update_output(fl4, sk->sk_bound_dev_if, fl4->daddr,
 				     fl4->saddr);
 		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 		return ip_route_output_flow(sock_net(sk), fl4, sk);
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index feb1d7fcb09f..c7652da78c88 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -139,7 +139,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 		if (PTR_ERR(rt) == -EINVAL && *saddr &&
 		    rt_mode & IP_VS_RT_MODE_CONNECT && !loop) {
 			*saddr = 0;
-			flowi4_update_output(&fl4, 0, 0, daddr, 0);
+			flowi4_update_output(&fl4, 0, daddr, 0);
 			goto retry;
 		}
 		IP_VS_DBG_RL("ip_route_output error, dest: %pI4\n", &daddr);
@@ -147,7 +147,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 	} else if (!*saddr && rt_mode & IP_VS_RT_MODE_CONNECT && fl4.saddr) {
 		ip_rt_put(rt);
 		*saddr = fl4.saddr;
-		flowi4_update_output(&fl4, 0, 0, daddr, fl4.saddr);
+		flowi4_update_output(&fl4, 0, daddr, fl4.saddr);
 		loop = true;
 		goto retry;
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c365df24ad33..664d1f2e9121 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -500,9 +500,7 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 			continue;
 
 		fl4->fl4_sport = laddr->a.v4.sin_port;
-		flowi4_update_output(fl4,
-				     asoc->base.sk->sk_bound_dev_if,
-				     RT_CONN_FLAGS_TOS(asoc->base.sk, tos),
+		flowi4_update_output(fl4, asoc->base.sk->sk_bound_dev_if,
 				     daddr->v4.sin_addr.s_addr,
 				     laddr->a.v4.sin_addr.s_addr);
 
-- 
2.39.2


