Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA16D53A8
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjDCVhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjDCVgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:36:04 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4004C4EDA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so18909993wms.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQA9a3ZeayisGBzT8fhn5X49xOz5ia7I/tP/67NAQZc=;
        b=WSzUbnasHaUCCyvcJgAXMRCqnSDtsi/u+Di2nN3K7GLHE+EbMsHbGfc8vTn4pKaqQL
         maMag0CeHrobXwaE2DEBV7+FAhSa9lhdlwtCuhqb4hBSPZ6IbyHwbtV6H2Ccb5Mpcbwr
         FLuFoAMxXLMVZQ0Y97P5XbGN1znIAbAhM4oeNku4jj0BehFLzsfjZOUzZe6u+Ov+Dr4o
         kqm12ywJU56MCYYIq5//Ltcz14jB+gpzXtbBFeirFdSseHxb844VqUs1Vmd7NLA8Vbgb
         DX5pTV0E9wZ/igBv03dOdmI+9zaSwK4m184PsA1KTsh3AArBaaTMzvpdCpEGQ6Gfo1cS
         YLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kQA9a3ZeayisGBzT8fhn5X49xOz5ia7I/tP/67NAQZc=;
        b=vvWTeNAo5QpYWyKDGdudUZTsZenrWz9c9J0/PPlivXnwqM+eKEH9zi4P75NHRqKDE9
         L1jvejPQqAek2wTWj5WHV/ysXghy0ZcQSHolRuYEOie1Y2js0bRUxVZFrxd4jx9Z5//6
         vaYIepkMI5+0vxZ/EpweT1Z2S00foGYSKojjKGXLLyi7QYYQrcLb0NIiLkoEUlGwc2L8
         EdtIbtCzmEXt4BBwESwrojT1As8XcSGjTtzXxiB7uq1AaKavW/gvaN6pjqqEFSR3fLZN
         l5zCDZ6UgbrlvGXB7dH6Z2LwPQRgwa3mYIP8R+39+Ci2VawwVnY6PbXZJLzLTyd2w8yk
         B80Q==
X-Gm-Message-State: AAQBX9dxI3ztCxpEWCgS4SlkmeXvqDoHJLvx60jpRynIYQmgpj1RUXSV
        oRx3yy/QxQOla4IlRSle+qnUpQ==
X-Google-Smtp-Source: AKy350YhZuijBfglMLhmUHOv2g+m3gTyW/rbvka8jpMmD+4fP/N/357Z1rl1mgmUWn8j1pfNu6SnJA==
X-Received: by 2002:a05:600c:2259:b0:3ed:b4e8:630f with SMTP id a25-20020a05600c225900b003edb4e8630fmr555639wmm.10.1680557690749;
        Mon, 03 Apr 2023 14:34:50 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:50 -0700 (PDT)
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
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v5 17/21] net/tcp: Add option for TCP-AO to (not) hash header
Date:   Mon,  3 Apr 2023 22:34:16 +0100
Message-Id: <20230403213420.1576559-18-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 32c4cf2efb8f..0550bc0fe09d 100644
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
@@ -1345,7 +1347,7 @@ static inline int tcp_ao_verify_ipv6(struct sock *sk, struct tcp_ao_add *cmd,
 }
 #endif
 
-#define TCP_AO_KEYF_ALL		(0)
+#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
-- 
2.40.0

