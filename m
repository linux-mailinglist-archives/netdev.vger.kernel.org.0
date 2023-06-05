Return-Path: <netdev+bounces-7968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C518172242B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C9651C20B27
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D7E168BE;
	Mon,  5 Jun 2023 11:07:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644F154BC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:07:01 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2F7B8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:06:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb05f0e6ef9so7148110276.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 04:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685963219; x=1688555219;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ch+XOQXfdP0F3mzuphnmwBDduzdWIKIlebmk5wJi8Cs=;
        b=WKBGskZrhZGqa/3jHPupX1jvfSUStUAJK2diql3P4aT9LRee8Gsziacg5RCvhqJSn3
         zztO+4bhoQ1xNFvkNQKzlw1eyCjf68lggpn5yiURg/I5dvpt45s9WrhYGqoXm6fQL0yT
         sE9JZHQxwRBDMxqcBsQ2llTNLF8LcQ9QR7cj5Xz2bgRIiPkftDA8/uS8tcMdP0apaoI9
         FEPSnvVt3tlAcwlYg/SlNDzjbDhZwQ5wj4AGdmHxcbgPT1fj+C64jdy1hqf7cmV7gR+Q
         Nmo9i6PA1Yo6+xiDGWbPnOyHxU0ohsBPGhdDgotdvlQyRCyrGUTIf6Jy8QBJdHTtyfkc
         mH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685963219; x=1688555219;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ch+XOQXfdP0F3mzuphnmwBDduzdWIKIlebmk5wJi8Cs=;
        b=PxOBD0fWVb+csZ9fUA5amRFo9j4BbYYfjq6cexVDILOHXdxYwWXLByIFtk6/jCh0hR
         oFg9tTEWQRNgl14D+d+pRsiXSJ0vffn1DQ+JDdCBg37JtZydqT1XhTIJh077oK7xnCxD
         H2UfqaNb/Us3lAdcOsHgXcve781Uc9w9kzFwa2BX0OxygWht/1EiGkGccCAqLyPQO18k
         NV5j892ESe3a7xuKMEaHou8rFoXlHChHi6Hz8HLJyYhEgh5ILiKez3VXTUvKHxEC4cP7
         f2M9dvS2fuVajBLZQnmlAecxAhTknMFjupoKrbnbzCblX6TCXA0OaUtxAjR5FVoPGLTU
         RnOw==
X-Gm-Message-State: AC+VfDzyrBfUwYZlTr6wo3h6euUmOe5YabwGsDIGJ36pWhlhhNEjk3wv
	np9kfN9vL1ry2sPtAGQbJauwxG3V
X-Google-Smtp-Source: ACHHUZ4EOOWUdaK3xy2xK2LY58d9Fp9jnXUlX+eNBrhXbA6zqHqdyTtBYFSyDnNYNToZV2+pqiDwfeXs
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:e3e5:f2e0:6e3:c38b])
 (user=maze job=sendgmr) by 2002:a05:6902:1149:b0:ba8:95dd:3ccb with SMTP id
 p9-20020a056902114900b00ba895dd3ccbmr6418451ybu.5.1685963219024; Mon, 05 Jun
 2023 04:06:59 -0700 (PDT)
Date: Mon,  5 Jun 2023 04:06:54 -0700
In-Reply-To: <20221026083203.2214468-1-zenczykowski@gmail.com>
Message-Id: <20230605110654.809655-1-maze@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6 dualstack sockets
From: "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To: "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>
Cc: Linux Network Development Mailing List <netdev@vger.kernel.org>, 
	"=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Jakub Kicinski <kuba@kernel.org>, 
	Benedict Wong <benedictwong@google.com>, Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
such a socket would use the newly added xfrm6_udp_encap_rcv()
which only handles IPv6 packets.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Benedict Wong <benedictwong@google.com>
Cc: Yan Yan <evitayan@google.com>
Fixes: 0146dca70b87 ('xfrm: add support for UDPv6 encapsulation of ESP')
Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 net/ipv4/xfrm4_input.c | 1 +
 net/ipv6/xfrm6_input.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index ad2afeef4f10..eac206a290d0 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -164,6 +164,7 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff=
 *skb)
 	kfree_skb(skb);
 	return 0;
 }
+EXPORT_SYMBOL(xfrm4_udp_encap_rcv);
=20
 int xfrm4_rcv(struct sk_buff *skb)
 {
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 04cbeefd8982..4907ab241d6b 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -86,6 +86,9 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *=
skb)
 	__be32 *udpdata32;
 	__u16 encap_type =3D up->encap_type;
=20
+	if (skb->protocol =3D=3D htons(ETH_P_IP))
+		return xfrm4_udp_encap_rcv(sk, skb);
+
 	/* if this is not encapsulated socket, then just return now */
 	if (!encap_type)
 		return 1;
--=20
2.41.0.rc0.172.g3f132b7071-goog


