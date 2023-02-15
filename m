Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE7169838F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBOSgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjBOSfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:35:50 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCF63E09C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:22 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bk16so20093749wrb.11
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/EabCUhoiLUi7Ie+3BWi6GbQs9F1PDAGXW1eduw+s4=;
        b=bCdbPSwgztK9Ost3LLH6wgbJEBxHn4MfIxvC7+fwWjwbIhqcxWxmKAKtgtsSrMPQi5
         v1fQ6tlYYjwEjD3GYUN4crLNRny231Og2Nf0YkYUnh1zERZZ4wA5pFrpmIFM5Mb1iJHo
         IkvSujdWtXzmnsxq6zaNaZ3cr6nFWDnWUG6xXiEzsNM1ZP5r371kle8ArMx99yM6SO87
         ldGS4YtmAKgHGTsZOlGEnDieRpOCR2RTSF2x4+3R30Kk1Mf3H/LyOvMjYGRak84Mh7sa
         +1AlG1SS0Jd5l5ktWOlxQEtTvwMuSP/Y3ibQ97kK1Ax+LN72/FRQT5/PrcIRXXbWoT67
         FjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/EabCUhoiLUi7Ie+3BWi6GbQs9F1PDAGXW1eduw+s4=;
        b=gRncM97wqushXtPforK/Z2gNIwxAI9eqr3rvDgjwB2ztJAD2Y4n+adJgZZ2lwmNo3w
         gyH2hAoSUQTwCPusbbTQOHIxNF7h7BUwSgnADiNsqSRGBv/AKMhLXF1GqjULajlvkq95
         DoNb42GxijB/1LjUVQiNszEf6CmToAuVCPxtbAgw3Gj0nS4VKZAU6YkCffq6sgPHFcwD
         f6F4N6qJiSnPKseAaSGT2sGGUcfYSDLJEeRWlOIXTZWooTvIlwieUpeHAGxFPzsvFHIF
         S2++/ytn1vovU9gijwdvGslgxehZmyX1AJEktfR6XbP+qc9WpKwt9RkWalARn/rD7Pu9
         5Gjg==
X-Gm-Message-State: AO0yUKXhX657eI2vsUdWIchZ1unFZP8Uxshc+jF79RadMK3h/0PyqKLL
        oMfMazal1ia4RDLoA4db/tdMQA==
X-Google-Smtp-Source: AK7set/y459HtAjc/HoitRB5KuaGjWyrvm2kWgPXTFvRTHGxZYbl2I7bch0bNHX21GubrmTq8w+V8A==
X-Received: by 2002:a05:6000:3c7:b0:2c5:4c07:9593 with SMTP id b7-20020a05600003c700b002c54c079593mr245099wrg.16.1676486054397;
        Wed, 15 Feb 2023 10:34:14 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:13 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v4 17/21] net/tcp: Add option for TCP-AO to (not) hash header
Date:   Wed, 15 Feb 2023 18:33:31 +0000
Message-Id: <20230215183335.800122-18-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 6c8b4dcc51ee..323ee886634f 100644
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
 
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 07935e8a1066..d335023a1619 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -589,7 +589,8 @@ int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
 		WARN_ON_ONCE(1);
 		goto clear_hash;
 	}
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	ahash_request_set_crypt(hp.req, NULL, ao_hash, 0);
@@ -631,7 +632,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		goto clear_hash;
 	if (tcp_ao_hash_pseudoheader(family, sk, skb, &hp, skb->len))
 		goto clear_hash;
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	if (tcp_ao_hash_skb_data(&hp, skb, th->doff << 2))
@@ -1498,7 +1500,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 }
 #endif
 
-#define TCP_AO_KEYF_ALL		(0)
+#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-- 
2.39.1

