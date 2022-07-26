Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59479580B44
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiGZGTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiGZGSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:18:02 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E7F28E2E;
        Mon, 25 Jul 2022 23:16:09 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z18so4177452edb.10;
        Mon, 25 Jul 2022 23:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e7myX/ND+nnIiOt3LqG3ckuwVwkBkqrIptHUR/Mrndk=;
        b=aoUFkzSP9HiIWB67aQOoXj1Rc4axgzCSfputg/q3IJ1fCaTEbGsdSEHOI5OQw7x1hE
         Ymbl1qZ3WYtrJxKp4A4PVE6J3snFIb4u75Y92r8qCNjMr9kgJni2+D0TamDLQxvmlpUM
         02qJs4u0S9OunmfbB0PejlUxIES3gFE/ER4vDRAZBkzsV8iYa334ezXiSnVNIFLOWGk6
         Kx1tF1TymeITuGlqQiVdrva0aRZ12JL9H5cMX7Hdnr4RAKBUs4Ivt2SgH7SokaP0H3aB
         Mi7fvRtGwpok9ZHLQtOR6EZ3oCLdTOH4lYfTZAdRKfwKP86PAdTQ3qZr5Q+gb1qPH5kN
         gMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e7myX/ND+nnIiOt3LqG3ckuwVwkBkqrIptHUR/Mrndk=;
        b=yPfcbYKGJvqnRVN4Ew5Glj7PUVqT9RklYfa6cPtImiYxrqbdoahLaaaMHxr/zWsuyT
         ix+wHsGpCpYFPpDwlBVqGs4XpMUEAd9gJWn9aHFSngQk39Wk6/uIgZxaZ/fCaken5iuZ
         hQ1UWhA3B4Lq2D0ScEgctvBTI186xgaOqTfbBscALU8+SDR33TdJnecZu8xox7TyhSPa
         ewAGJYlgWboUokJvCM785BVcsgZIj8sOzQSBtbdqlF2lI0xB82C6f32PzOv6JK2dJHze
         mT6hcFk9q7EZcubml2ScKqcTA0fmzSrqpJ/qBzyVYjMrEy6E3NyuL+hIA9BZwpmnhc2v
         Z3XQ==
X-Gm-Message-State: AJIora8uHwbke4Sh8dWPbpYYYRLAxY4FaejgWLI51zPpA8EOqVSuwdjn
        q2Id9WAZAVarMRbU1df/OMg=
X-Google-Smtp-Source: AGRyM1sOrSpjLQhgvLHw8PGaap7ngpZhAQekO8o3CGoodB+MTsxHdRrzASJ+zzDiNZAOnXXFxMyzqg==
X-Received: by 2002:aa7:d994:0:b0:43b:d187:69fd with SMTP id u20-20020aa7d994000000b0043bd18769fdmr16629603eds.201.1658816168761;
        Mon, 25 Jul 2022 23:16:08 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:08 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 16/26] tcp: authopt: Add NOSEND/NORECV flags
Date:   Tue, 26 Jul 2022 09:15:18 +0300
Message-Id: <42a151fcdbae9ccbcfe5916324d40c904f98d9b2.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flags to allow marking individual keys and invalid for send or recv.
Making keys assymetric this way is not mentioned in RFC5925 but RFC8177
requires that keys inside a keychain have independent "accept" and
"send" lifetimes.

Flag names are negative so that the default behavior is for keys to be
valid for both send and recv.

Setting both NOSEND and NORECV for a certain peer address can be used on
a listen socket can be used to mean "TCP-AO is required from this peer
but no keys are currently valid".

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/uapi/linux/tcp.h | 4 ++++
 net/ipv4/tcp_authopt.c   | 9 ++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index a7f5f918ed5a..ed27feb93b0e 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -401,16 +401,20 @@ struct tcp_authopt {
  *
  * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
  * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
+ * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
+ * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
 	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
+	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
+	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index bb26fb1c8af2..0ead961fcfe0 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -374,10 +374,12 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (send_id >= 0 && key->send_id != send_id)
 			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
 		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
 			if (l3index < 0)
@@ -623,11 +625,13 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
-	TCP_AUTHOPT_KEY_IFINDEX)
+	TCP_AUTHOPT_KEY_IFINDEX | \
+	TCP_AUTHOPT_KEY_NOSEND | \
+	TCP_AUTHOPT_KEY_NORECV)
 
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
@@ -1534,10 +1538,13 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 
 			if (l3index != key->l3index)
 				continue;
 		}
 		*anykey = true;
+		// If only keys with norecv flag are present still consider that
+		if (key->flags & TCP_AUTHOPT_KEY_NORECV)
+			continue;
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
 		if (better_key_match(result, key))
 			result = key;
 		else if (result)
-- 
2.25.1

