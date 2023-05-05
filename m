Return-Path: <netdev+bounces-635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC9C6F8AE2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 425EF1C218CB
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02BAD302;
	Fri,  5 May 2023 21:26:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BF3C12D
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:26:50 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-18.smtpout.orange.fr [80.12.242.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABED55BA5
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 14:26:40 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id v2wmpgtTUjS6ev2wmpHBJS; Fri, 05 May 2023 23:26:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1683321998;
	bh=E2v+yIcHWIZqIecJEid9w22BOXg0tscR0zgy0Dp1DYA=;
	h=From:To:Cc:Subject:Date;
	b=LeMZR1zPtPMdM61turqmYF1aIOD9UBzNZ2wATj6ZBtx1ZbUJEqpyugjFah6wVA8rI
	 iLf0xbXuhrZTroKF/NrQ09nT/Xj8CFidKYwR9HoJokXzFiIBwdQaOs0S3UUJwEjgJd
	 vCwh6FZdlao7Grr44RazyzIPSMQOOnqOw8THagp9bcxwwZ7c/kPxQ8FlrE4z1J7t9S
	 NfmmqZhjxdfY661SdJnt4hqidfdHfreKlZujo40oZsr63t7T8RkUjxSzppWOUV7M0L
	 Ey6xyFGZm0Ofdjb2JCkbtKCRBfwvk8SJXh+1Quw8DokmM7YPDG9ALVGXfDcctDYDXS
	 mr7mZhvgQGpTw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 05 May 2023 23:26:38 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH v2 net-next] netfilter: nft_set_pipapo: Use struct_size()
Date: Fri,  5 May 2023 23:26:34 +0200
Message-Id: <687973f7f0f77a456ee2ebabd75cec61cba2eb98.1683321933.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use struct_size() instead of hand writing it.
This is less verbose and more informative.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
It will also help scripts when __counted_by macro will be added.
See [1].

[1]: https://lore.kernel.org/all/6453f739.170a0220.62695.7785@mx.google.com/


v2: Fix another occurrence
---
 net/netfilter/nft_set_pipapo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 06d46d182634..34c684e121d3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1274,8 +1274,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	struct nft_pipapo_match *new;
 	int i;
 
-	new = kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
-		      GFP_KERNEL);
+	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
@@ -2059,8 +2058,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
-	m = kmalloc(sizeof(*priv->match) + sizeof(*f) * field_count,
-		    GFP_KERNEL);
+	m = kmalloc(struct_size(m, f, field_count), GFP_KERNEL);
 	if (!m)
 		return -ENOMEM;
 
-- 
2.34.1


