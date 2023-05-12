Return-Path: <netdev+bounces-2282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE3B700FBE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAA63281C24
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D2421071;
	Fri, 12 May 2023 20:23:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA3F2106C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:45 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D257ECC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3062b101ae1so6804683f8f.2
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683923022; x=1686515022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDKxu7Q3BnVyZ56o/a9J4JKFOGYoGaGixVIZp1vuIS4=;
        b=LQ2Gz7RYkZ5dYj/IN8jUZJcUuipI+jiIy8BN50xXxIYdsaP0hY0SVBpA5R8OMXmZa0
         4ySCC5oC+NPwTFSQDb1IyIvgsoJ1z76Klit4oz6LK742Vnm1J8D/1BBQQdzdt0eRitaC
         pMscTQ8as51JxRy9pN0DHumYFpyfrDW2LiOvC9gva9zEaVPi3UC9UVIUdSBoSc0yAFYq
         Z6PzE37wxxfDx86fC7eRTGShF7BSSM1acmg1VKqYm7YU/hVtWthIOIy4bRCzAN7lfqFy
         iGJ2kK4cWX0nPfndKtPj2RqJG8pzjEcNC8+sDbPJSMaKYlaACPOKxvKbExFtcZhh14Fz
         ZvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923022; x=1686515022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDKxu7Q3BnVyZ56o/a9J4JKFOGYoGaGixVIZp1vuIS4=;
        b=a5gezfhq/NT3gDXuGbQYxiagtxAhXGt7nuNFBEuFZyHSLWgrLyLBY5qnPS9KbZMh/p
         PAV4/OsOdQg8bMwT8rmzi3L5TwApdUMO0GxdhDJH6iKFXqR7LpbGf+5ACckECro8aDSL
         QjxJ54VIWU8kd7LClKbOpTxQcMctPNC94AYKGLYs97/eJC7mDc/jb7QILqycpbHw9W/m
         BrH3A9EC4Ec2LhDKR7adk43YP2OGKAXFIGw0N1aAt4N7stSZe8kpFxLdLMGCU83GJaa5
         cdYTo0/7uEn1PuFDb1EmWZWIhsd+umE/sIeN2WYv1e9jI5C6ojYRx9LIIw48K/wmGyIb
         WWuw==
X-Gm-Message-State: AC+VfDz8m+B3PYXic6gv+noAaW386feETUC48Hsyd+V2iDf5SRv0q21K
	J0Mi8KOndAk8fJ1G6hDtv0FdaQ==
X-Google-Smtp-Source: ACHHUZ7hNI1VFax5WAmBbyhkyQ/JW/ECwHYwfan16j+e9IJZKkPnDnHsoKL2lXPDwjufURngofhaWw==
X-Received: by 2002:a5d:440a:0:b0:306:2b5f:8d0a with SMTP id z10-20020a5d440a000000b003062b5f8d0amr17626411wrq.56.1683923022689;
        Fri, 12 May 2023 13:23:42 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:42 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v6 17/21] net/tcp: Add option for TCP-AO to (not) hash header
Date: Fri, 12 May 2023 21:23:07 +0100
Message-Id: <20230512202311.2845526-18-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512202311.2845526-1-dima@arista.com>
References: <20230512202311.2845526-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Provide setsockopt() key flag that makes TCP-AO exclude hashing TCP
header for peers that match the key. This is needed for interraction
with middleboxes that may change TCP options, see RFC5925 (9.2).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/uapi/linux/tcp.h | 5 +++++
 net/ipv4/tcp_ao.c        | 8 +++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index ca7ed18ce67b..3275ade3293a 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -354,6 +354,11 @@ struct tcp_diag_md5sig {
 #define TCP_AO_MAXKEYLEN	80
 
 #define TCP_AO_KEYF_IFINDEX	(1 << 0)	/* L3 ifindex for VRF */
+#define TCP_AO_KEYF_EXCLUDE_OPT	(1 << 1)	/* "Indicates whether TCP
+						 *  options other than TCP-AO
+						 *  are included in the MAC
+						 *  calculation"
+						 */
 
 struct tcp_ao_add { /* setsockopt(TCP_AO_ADD_KEY) */
 	struct __kernel_sockaddr_storage addr;	/* peer's address for the key */
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index fdba3e1c80cc..890f48a97490 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -566,7 +566,8 @@ int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
 		WARN_ON_ONCE(1);
 		goto clear_hash;
 	}
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	ahash_request_set_crypt(hp.req, NULL, tmp_hash, 0);
@@ -609,7 +610,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		goto clear_hash;
 	if (tcp_ao_hash_pseudoheader(family, sk, skb, &hp, skb->len))
 		goto clear_hash;
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
@@ -1339,7 +1341,7 @@ static inline int tcp_ao_verify_ipv6(struct sock *sk, struct tcp_ao_add *cmd,
 }
 #endif
 
-#define TCP_AO_KEYF_ALL		(0)
+#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
-- 
2.40.0


