Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771D43B68E8
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhF1TQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbhF1TQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:16:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740BBC061766;
        Mon, 28 Jun 2021 12:13:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso727304pjb.4;
        Mon, 28 Jun 2021 12:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PhjEy6KDHjr+YzGN1lUcO12o90YJy/EHuMByPs3R67g=;
        b=Gss8Bn9T6H2IKvKK9PdOONXrJdeGbOZssuiwtlESdXy6z26YCl5ZlN30LFhEYc9Ss9
         IaS/4KZCIQUQ74+CoqgonCr3w96LJeoM68t7KwuGEoAn/ECf6Q4tKkYTJ2jg1nKuVGBg
         WJsTeGwPW/cL+a5reLibD3SHUSFe7LYvcVzBBasOlSUGsqr3UIpt8UQCmDyxhsK+7tlK
         LAR1VEE5cE0F/PAVIJJB3LK6dDMfa8KJVtrSNqnspG1CjLsgTJW7gyz6W5lyq061+WZh
         9Ud3U3gkU11WBWggMjwMk0RoPyY+BUrcR+OmhkSCILs+SrcH/K6QqJeCZRxPRjIyuYAR
         9UrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PhjEy6KDHjr+YzGN1lUcO12o90YJy/EHuMByPs3R67g=;
        b=kJ2DMY1ZilgqVlkCuI9okJqYBVP9uVlY73/lJgseR0QmTFIKazKkVnOpsruwh6NRka
         Luvc1RPzIx1jM4iVKBwJrMgVioJxk51oSleCLgR22XE+LZisu4mncOOpzxjqDon+8erm
         +3jORW3JCpb92WtKSNk3e9WU/AFjDXc77tDgZY+TjxvkuN+rGRYtyZho2QGh7M7qKAvz
         6wbZBMCZQFszKpWK2r5rDOZBiK61kbsF8pdmfykOVBzXQYY+nxaDhc5d+RIrOgscVx5G
         5aPs9WbUoF9uQ9IzG+Tt3g/GJ8FNoxHkf0W8KGxO5qClF3LOWhn3LMmTLVjp8wkFqNxQ
         jvcQ==
X-Gm-Message-State: AOAM533GOv00yaRw0L2LnTyt3mwnMgTyRuIVtB3zf6Sf4lh4e9H5oFL1
        Lhutqs20Z4DWAUEg8DDpMoiIdUyezy9s7Q==
X-Google-Smtp-Source: ABdhPJykCrtS7wuH+PMY4pPqB9bpNVaiRMPTXUysPz10+lPgiim5a6+4TYWEEC4a6vvVaduYBdTWDQ==
X-Received: by 2002:a17:90b:384f:: with SMTP id nl15mr17935988pjb.88.1624907635931;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.71])
        by smtp.gmail.com with ESMTPSA id y66sm16091305pgb.4.2021.06.28.12.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 2A513C0789; Mon, 28 Jun 2021 16:13:52 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 1/4] sctp: validate from_addr_param return
Date:   Mon, 28 Jun 2021 16:13:41 -0300
Message-Id: <a8a08b7fbb0bf76377e26584682c12dd82202d2e.1624904195.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624904195.git.marcelo.leitner@gmail.com>
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilja reported that, simply putting it, nothing was validating that
from_addr_param functions were operating on initialized memory. That is,
the parameter itself was being validated by sctp_walk_params, but it
doesn't check for types and their specific sizes and it could be a 0-length
one, causing from_addr_param to potentially work over the next parameter or
even uninitialized memory.

The fix here is to, in all calls to from_addr_param, check if enough space
is there for the wanted IP address type.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/structs.h |  2 +-
 net/sctp/bind_addr.c       | 19 +++++++++++--------
 net/sctp/input.c           |  6 ++++--
 net/sctp/ipv6.c            |  7 ++++++-
 net/sctp/protocol.c        |  7 ++++++-
 net/sctp/sm_make_chunk.c   | 29 ++++++++++++++++-------------
 6 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 1aa585216f34b5fb8ed875cece1a8c22e43690d3..d49593c72a555600c06ad7159934fb17226cc452 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -461,7 +461,7 @@ struct sctp_af {
 					 int saddr);
 	void		(*from_sk)	(union sctp_addr *,
 					 struct sock *sk);
-	void		(*from_addr_param) (union sctp_addr *,
+	bool		(*from_addr_param) (union sctp_addr *,
 					    union sctp_addr_param *,
 					    __be16 port, int iif);
 	int		(*to_addr_param) (const union sctp_addr *,
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 53e5ed79f63f34f6d237b5d0683925fe9c49f4a9..59e653b528b1faec6c6fcf73f0dd42633880e08d 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -270,22 +270,19 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 		rawaddr = (union sctp_addr_param *)raw_addr_list;
 
 		af = sctp_get_af_specific(param_type2af(param->type));
-		if (unlikely(!af)) {
+		if (unlikely(!af) ||
+		    !af->from_addr_param(&addr, rawaddr, htons(port), 0)) {
 			retval = -EINVAL;
-			sctp_bind_addr_clean(bp);
-			break;
+			goto out_err;
 		}
 
-		af->from_addr_param(&addr, rawaddr, htons(port), 0);
 		if (sctp_bind_addr_state(bp, &addr) != -1)
 			goto next;
 		retval = sctp_add_bind_addr(bp, &addr, sizeof(addr),
 					    SCTP_ADDR_SRC, gfp);
-		if (retval) {
+		if (retval)
 			/* Can't finish building the list, clean up. */
-			sctp_bind_addr_clean(bp);
-			break;
-		}
+			goto out_err;
 
 next:
 		len = ntohs(param->length);
@@ -294,6 +291,12 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 	}
 
 	return retval;
+
+out_err:
+	if (retval)
+		sctp_bind_addr_clean(bp);
+
+	return retval;
 }
 
 /********************************************************************
diff --git a/net/sctp/input.c b/net/sctp/input.c
index d508f6f3dd08a33419c010d7944f9f70cacdd700..8924e2e142c8234dac233e56e923110e266c9834 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1131,7 +1131,8 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 		if (!af)
 			continue;
 
-		af->from_addr_param(paddr, params.addr, sh->source, 0);
+		if (!af->from_addr_param(paddr, params.addr, sh->source, 0))
+			continue;
 
 		asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
 		if (asoc)
@@ -1174,7 +1175,8 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	if (unlikely(!af))
 		return NULL;
 
-	af->from_addr_param(&paddr, param, peer_port, 0);
+	if (af->from_addr_param(&paddr, param, peer_port, 0))
+		return NULL;
 
 	return __sctp_lookup_association(net, laddr, &paddr, transportp);
 }
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index bd08807c9e44758b56cdf1cad94dda7184e14fb5..5c6f5ced9cfa631ba73c203478a28c07a27498d0 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -551,15 +551,20 @@ static void sctp_v6_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 }
 
 /* Initialize a sctp_addr from an address parameter. */
-static void sctp_v6_from_addr_param(union sctp_addr *addr,
+static bool sctp_v6_from_addr_param(union sctp_addr *addr,
 				    union sctp_addr_param *param,
 				    __be16 port, int iif)
 {
+	if (ntohs(param->v6.param_hdr.length) < sizeof(struct sctp_ipv6addr_param))
+		return false;
+
 	addr->v6.sin6_family = AF_INET6;
 	addr->v6.sin6_port = port;
 	addr->v6.sin6_flowinfo = 0; /* BUG */
 	addr->v6.sin6_addr = param->v6.addr;
 	addr->v6.sin6_scope_id = iif;
+
+	return true;
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6f2bbfeec3a4c7e8386f70a470e83063204dc50e..25192b378e2ece85a0d5fe1a13b713fd5b331ca7 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -254,14 +254,19 @@ static void sctp_v4_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 }
 
 /* Initialize a sctp_addr from an address parameter. */
-static void sctp_v4_from_addr_param(union sctp_addr *addr,
+static bool sctp_v4_from_addr_param(union sctp_addr *addr,
 				    union sctp_addr_param *param,
 				    __be16 port, int iif)
 {
+	if (ntohs(param->v4.param_hdr.length) < sizeof(struct sctp_ipv4addr_param))
+		return false;
+
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = port;
 	addr->v4.sin_addr.s_addr = param->v4.addr.s_addr;
 	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
+
+	return true;
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 5b44d228b6cacc720300d9f5951115a95a828163..f33a870b483da7123e2ddb4473b6200a1aca5ade 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2346,11 +2346,13 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 
 	/* Process the initialization parameters.  */
 	sctp_walk_params(param, peer_init, init_hdr.params) {
-		if (!src_match && (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
-		    param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
+		if (!src_match &&
+		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
+		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
-			af->from_addr_param(&addr, param.addr,
-					    chunk->sctp_hdr->source, 0);
+			if (!af->from_addr_param(&addr, param.addr,
+						 chunk->sctp_hdr->source, 0))
+				continue;
 			if (sctp_cmp_addr_exact(sctp_source(chunk), &addr))
 				src_match = 1;
 		}
@@ -2531,7 +2533,8 @@ static int sctp_process_param(struct sctp_association *asoc,
 			break;
 do_addr_param:
 		af = sctp_get_af_specific(param_type2af(param.p->type));
-		af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0);
+		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
+			break;
 		scope = sctp_scope(peer_addr);
 		if (sctp_in_scope(net, &addr, scope))
 			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))
@@ -2632,15 +2635,13 @@ static int sctp_process_param(struct sctp_association *asoc,
 		addr_param = param.v + sizeof(struct sctp_addip_param);
 
 		af = sctp_get_af_specific(param_type2af(addr_param->p.type));
-		if (af == NULL)
+		if (!af)
 			break;
 
-		af->from_addr_param(&addr, addr_param,
-				    htons(asoc->peer.port), 0);
+		if (!af->from_addr_param(&addr, addr_param,
+					 htons(asoc->peer.port), 0))
+			break;
 
-		/* if the address is invalid, we can't process it.
-		 * XXX: see spec for what to do.
-		 */
 		if (!af->addr_valid(&addr, NULL, NULL))
 			break;
 
@@ -3054,7 +3055,8 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	if (unlikely(!af))
 		return SCTP_ERROR_DNS_FAILED;
 
-	af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0);
+	if (!af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0))
+		return SCTP_ERROR_DNS_FAILED;
 
 	/* ADDIP 4.2.1  This parameter MUST NOT contain a broadcast
 	 * or multicast address.
@@ -3331,7 +3333,8 @@ static void sctp_asconf_param_success(struct sctp_association *asoc,
 
 	/* We have checked the packet before, so we do not check again.	*/
 	af = sctp_get_af_specific(param_type2af(addr_param->p.type));
-	af->from_addr_param(&addr, addr_param, htons(bp->port), 0);
+	if (!af->from_addr_param(&addr, addr_param, htons(bp->port), 0))
+		return;
 
 	switch (asconf_param->param_hdr.type) {
 	case SCTP_PARAM_ADD_IP:
-- 
2.31.1

