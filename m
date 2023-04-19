Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6C6E7E0B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbjDSPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbjDSPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:16 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423EE7680;
        Wed, 19 Apr 2023 08:18:47 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id br19so4791598qtb.7;
        Wed, 19 Apr 2023 08:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917396; x=1684509396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACNg3in/pkKi1xmc2bSu1ksz6xcHFFBw+fJlM+8OI8c=;
        b=RcdPPF7WcBxXdQyvMqfgA/fR3Id/960Gk7WqicmjOiufhpVKMkwokykAuPfvbM575y
         pMJSk2nqm4fTPI1xZ+f6cbaKedBUvohN6SmAA8llG95tAsoxm+XTja8KOqRk0hAZawKu
         XSLMkhtqmNWi8DXb+ogUeAjNTGnB92ABOXOVOQoVaewsYcEr2hQmUru/SkknKNfY2mRo
         tZqNB9kqlcUP/Kq/LOgoKW1GT/qjhnwAM7S59Au34Ms9BHByTo4Nfj3zVnajXHtyGKJL
         lG3nyEKFW0NpnaNsMSJHNQfiIbbXv836OaFsCxRuYEjU7c6sRqzFBJDUBTZaQ0KIOi9v
         Qwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917396; x=1684509396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ACNg3in/pkKi1xmc2bSu1ksz6xcHFFBw+fJlM+8OI8c=;
        b=D/X+RzdITuUQUhPOJTbXCiZE2xUOx8PXipRQJhTXro7/vE8yI06tvxJVK5THAVELSp
         coTvlhz4wk9+WBv/+APyJTawhSZlWJ8Pcv/f6MclY6h8VWSNj7fAuS/vD6AoIERZxn77
         Qd6khnbDT3C4Kt2PKHHkHJhyIpE7mVMyY4b7QntIq8UA9ogeqb1lBV5YH+0+o4dc5pZv
         ofzo2WkEtnPi6+l041ch9XTNAWEL+mzViWtbkCih3DxYuZRGqopPgN58wlwqEi2WeFwy
         2FiwXqOuPgTVsSeJcld0WHyyM9SYB05/CqUWfYs4xWTEJAji3dKW/cN+AQCMrapG1xjB
         f5jQ==
X-Gm-Message-State: AAQBX9cc61aAyDRkjNGsLIzbwLU9cRpClBIl9hyHY7Loy5uWS8rfgX4i
        lPdKjqotcn7tFz+7GenaQBw4vaUiBt/Rug==
X-Google-Smtp-Source: AKy350b5U8WZ5bNppfqC4HBS7bS2ykF9e3PkxbLDDcARqk7upBy7g9FibDJerofsAtyEA3UD0kAVhg==
X-Received: by 2002:ac8:5a54:0:b0:3e2:4280:bc56 with SMTP id o20-20020ac85a54000000b003e24280bc56mr6403405qta.41.1681917395847;
        Wed, 19 Apr 2023 08:16:35 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:35 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 1/6] sctp: delete the nested flexible array params
Date:   Wed, 19 Apr 2023 11:16:28 -0400
Message-Id: <93430583976e882b25a186ab940ba03a06014097.1681917361.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1681917361.git.lucien.xin@gmail.com>
References: <cover.1681917361.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch deletes the flexible-array params[] from the structure
sctp_inithdr, sctp_addiphdr and sctp_reconf_chunk to avoid some
sparse warnings:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  net/sctp/input.c: note: in included file (through include/net/sctp/structs.h, include/net/sctp/sctp.h):
  ./include/linux/sctp.h:278:29: warning: nested flexible array
  ./include/linux/sctp.h:675:30: warning: nested flexible array

This warning is reported if a structure having a flexible array
member is included by other structures.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     |  6 +++---
 include/net/sctp/sctp.h  |  8 ++++----
 net/sctp/input.c         |  2 +-
 net/sctp/sm_make_chunk.c | 18 +++++++++---------
 net/sctp/sm_statefuns.c  |  2 +-
 net/sctp/stream.c        |  2 +-
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 358dc08e0831..0ff36a2737a3 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -270,7 +270,7 @@ struct sctp_inithdr {
 	__be16 num_outbound_streams;
 	__be16 num_inbound_streams;
 	__be32 initial_tsn;
-	__u8  params[];
+	/* __u8  params[]; */
 };
 
 struct sctp_init_chunk {
@@ -667,7 +667,7 @@ struct sctp_addip_param {
 
 struct sctp_addiphdr {
 	__be32	serial;
-	__u8	params[];
+	/* __u8	params[]; */
 };
 
 struct sctp_addip_chunk {
@@ -742,7 +742,7 @@ struct sctp_infox {
 
 struct sctp_reconf_chunk {
 	struct sctp_chunkhdr chunk_hdr;
-	__u8 params[];
+	/* __u8 params[]; */
 };
 
 struct sctp_strreset_outreq {
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index c335dd01a597..74fae532b944 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -425,11 +425,11 @@ static inline bool sctp_chunk_pending(const struct sctp_chunk *chunk)
  * the chunk length to indicate when to stop.  Make sure
  * there is room for a param header too.
  */
-#define sctp_walk_params(pos, chunk, member)\
-_sctp_walk_params((pos), (chunk), ntohs((chunk)->chunk_hdr.length), member)
+#define sctp_walk_params(pos, chunk)\
+_sctp_walk_params((pos), (chunk), ntohs((chunk)->chunk_hdr.length))
 
-#define _sctp_walk_params(pos, chunk, end, member)\
-for (pos.v = chunk->member;\
+#define _sctp_walk_params(pos, chunk, end)\
+for (pos.v = (u8 *)(chunk + 1);\
      (pos.v + offsetof(struct sctp_paramhdr, length) + sizeof(pos.p->length) <=\
       (void *)chunk + end) &&\
      pos.v <= (void *)chunk + end - ntohs(pos.p->length) &&\
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 127bf28a6033..2613c4d74b16 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1150,7 +1150,7 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 	init = (struct sctp_init_chunk *)skb->data;
 
 	/* Walk the parameters looking for embedded addresses. */
-	sctp_walk_params(params, init, init_hdr.params) {
+	sctp_walk_params(params, init) {
 
 		/* Note: Ignoring hostname addresses. */
 		af = sctp_get_af_specific(param_type2af(params.p->type));
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c8f4ec5d5f98..4dbbbc2a7742 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2306,7 +2306,7 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 	    ntohl(peer_init->init_hdr.a_rwnd) < SCTP_DEFAULT_MINWINDOW)
 		return sctp_process_inv_mandatory(asoc, chunk, errp);
 
-	sctp_walk_params(param, peer_init, init_hdr.params) {
+	sctp_walk_params(param, peer_init) {
 		if (param.p->type == SCTP_PARAM_STATE_COOKIE)
 			has_cookie = true;
 	}
@@ -2329,7 +2329,7 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 						  chunk, errp);
 
 	/* Verify all the variable length parameters */
-	sctp_walk_params(param, peer_init, init_hdr.params) {
+	sctp_walk_params(param, peer_init) {
 		result = sctp_verify_param(net, ep, asoc, param, cid,
 					   chunk, errp);
 		switch (result) {
@@ -2381,7 +2381,7 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 		src_match = 1;
 
 	/* Process the initialization parameters.  */
-	sctp_walk_params(param, peer_init, init_hdr.params) {
+	sctp_walk_params(param, peer_init) {
 		if (!src_match &&
 		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
@@ -3202,7 +3202,7 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 	union sctp_params param;
 
 	addip = (struct sctp_addip_chunk *)chunk->chunk_hdr;
-	sctp_walk_params(param, addip, addip_hdr.params) {
+	sctp_walk_params(param, addip) {
 		size_t length = ntohs(param.p->length);
 
 		*errp = param.p;
@@ -3215,14 +3215,14 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 			/* ensure there is only one addr param and it's in the
 			 * beginning of addip_hdr params, or we reject it.
 			 */
-			if (param.v != addip->addip_hdr.params)
+			if (param.v != (addip + 1))
 				return false;
 			addr_param_seen = true;
 			break;
 		case SCTP_PARAM_IPV6_ADDRESS:
 			if (length != sizeof(struct sctp_ipv6addr_param))
 				return false;
-			if (param.v != addip->addip_hdr.params)
+			if (param.v != (addip + 1))
 				return false;
 			addr_param_seen = true;
 			break;
@@ -3302,7 +3302,7 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 		goto done;
 
 	/* Process the TLVs contained within the ASCONF chunk. */
-	sctp_walk_params(param, addip, addip_hdr.params) {
+	sctp_walk_params(param, addip) {
 		/* Skip preceeding address parameters. */
 		if (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		    param.p->type == SCTP_PARAM_IPV6_ADDRESS)
@@ -3636,7 +3636,7 @@ static struct sctp_chunk *sctp_make_reconf(const struct sctp_association *asoc,
 		return NULL;
 
 	reconf = (struct sctp_reconf_chunk *)retval->chunk_hdr;
-	retval->param_hdr.v = reconf->params;
+	retval->param_hdr.v = (u8 *)(reconf + 1);
 
 	return retval;
 }
@@ -3878,7 +3878,7 @@ bool sctp_verify_reconf(const struct sctp_association *asoc,
 	__u16 cnt = 0;
 
 	hdr = (struct sctp_reconf_chunk *)chunk->chunk_hdr;
-	sctp_walk_params(param, hdr, params) {
+	sctp_walk_params(param, hdr) {
 		__u16 length = ntohs(param.p->length);
 
 		*errp = param.p;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index ce5426171206..39d416e7f795 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4142,7 +4142,7 @@ enum sctp_disposition sctp_sf_do_reconf(struct net *net,
 						  (void *)err_param, commands);
 
 	hdr = (struct sctp_reconf_chunk *)chunk->chunk_hdr;
-	sctp_walk_params(param, hdr, params) {
+	sctp_walk_params(param, hdr) {
 		struct sctp_chunk *reply = NULL;
 		struct sctp_ulpevent *ev = NULL;
 
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ee6514af830f..c241cc552e8d 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -491,7 +491,7 @@ static struct sctp_paramhdr *sctp_chunk_lookup_strreset_param(
 		return NULL;
 
 	hdr = (struct sctp_reconf_chunk *)chunk->chunk_hdr;
-	sctp_walk_params(param, hdr, params) {
+	sctp_walk_params(param, hdr) {
 		/* sctp_strreset_tsnreq is actually the basic structure
 		 * of all stream reconf params, so it's safe to use it
 		 * to access request_seq.
-- 
2.39.1

