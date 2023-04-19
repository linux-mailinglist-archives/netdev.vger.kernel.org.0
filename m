Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7B6E7E04
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjDSPTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjDSPTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:03 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3A89037;
        Wed, 19 Apr 2023 08:18:27 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u37so8474763qtc.10;
        Wed, 19 Apr 2023 08:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917398; x=1684509398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UL/KNEeyR1A4RYYeedrgo97igGODZqnW3SkGYg2Vrwo=;
        b=ddxGwC30RarItFP+nn0S7+8+u7X6Q/1ku1eFQbWZp7vNiMDKNOf83tL0qFd8h3eKL3
         BANYoCsd7l/ozK60P/bMFpQWJ2SE/w0KI6Zx181ieX2aQl0GSyzEYRDJ31pZmO+ESm+Y
         vexZPPoPqwA8UdHN+tNlsQeGA83ifvvdyUvkJJ/4aA4esv+aa6dgAHP6OhYym7OCiHWM
         dRIscN/MATMIOexK2VTZ51C4zA/ZV0PooKWufJPbF2Tll9ZG7Ra1BijaAJqO54MHPFfy
         b5VGla+qs++qun3PJTfla6x9YKZEy7BaGtJ2OoniHBEELuFQoyUGKwYyAKvVX9DcSwuT
         ab1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917398; x=1684509398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UL/KNEeyR1A4RYYeedrgo97igGODZqnW3SkGYg2Vrwo=;
        b=KI/3NBXX583eMLX7cU6PRE+Jq2bW8i7Y7ud1U0GBvl5gqof5lTmQ7qRKA90psXfXi7
         Oe/Ut+taqG/fip/7e1hD/T1KYZOrEWPdJIcQpR3/o/+ZH3YGYj7YTQbThAM5EamOs+YL
         7nIHOi/yNlDadVhJO7KdEONiJCkrxgCW1PqXzrPZhIg7f7XRqJstXEJQOmePMAgcpYKg
         u/HNY0q49eEujMCe78eWmhgpz3ALd8zuJ8r9rRtH1BL99W6Lz6R6t+dBKsdvzRqh4knB
         ve6QPuyHnuXZyCsAe2gR8YMgNm9D19CwlUChw+qacILS4cM0b3dMxyT6usJsuT5+Uue1
         s+Iw==
X-Gm-Message-State: AAQBX9fWrI0laaPWwfbTIA7HdxqfFHrFe60uns2TxkjjShhB/QPt//BC
        TJ40RozdXigGbnFXHQfhuoxdSb+M0Nir/Q==
X-Google-Smtp-Source: AKy350YCtoqxK16MjwkwxtPD7y3QFYbtjeTNKy3J7CC+CGc6w+Xb2GqZfhKt7I61iimOpWO/lYa6kQ==
X-Received: by 2002:ac8:5816:0:b0:3d7:b045:d38 with SMTP id g22-20020ac85816000000b003d7b0450d38mr7617158qtg.35.1681917398404;
        Wed, 19 Apr 2023 08:16:38 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 4/6] sctp: delete the nested flexible array peer_init
Date:   Wed, 19 Apr 2023 11:16:31 -0400
Message-Id: <d5aadadbbe09aa79161b43c08ab5d7b4f29a907f.1681917361.git.lucien.xin@gmail.com>
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

This patch deletes the flexible-array peer_init[] from the structure
sctp_cookie to avoid some sparse warnings:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  net/sctp/sm_make_chunk.c: note: in included file (through include/net/sctp/sctp.h):
  ./include/net/sctp/structs.h:1588:28: warning: nested flexible array
  ./include/net/sctp/structs.h:343:28: warning: nested flexible array

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 2 +-
 net/sctp/associola.c       | 5 +++--
 net/sctp/sm_make_chunk.c   | 4 ++--
 net/sctp/sm_statefuns.c    | 8 +++-----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 070c9458fff4..5c72d1864dd6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -332,7 +332,7 @@ struct sctp_cookie {
 	 * the association TCB is re-constructed from the cookie.
 	 */
 	__u32 raw_addr_list_len;
-	struct sctp_init_chunk peer_init[];
+	/* struct sctp_init_chunk peer_init[]; */
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 63ba5551c13f..796529167e8d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1597,9 +1597,10 @@ int sctp_assoc_set_bind_addr_from_cookie(struct sctp_association *asoc,
 					 struct sctp_cookie *cookie,
 					 gfp_t gfp)
 {
-	int var_size2 = ntohs(cookie->peer_init->chunk_hdr.length);
+	struct sctp_init_chunk *peer_init = (struct sctp_init_chunk *)(cookie + 1);
+	int var_size2 = ntohs(peer_init->chunk_hdr.length);
 	int var_size3 = cookie->raw_addr_list_len;
-	__u8 *raw = (__u8 *)cookie->peer_init + var_size2;
+	__u8 *raw = (__u8 *)peer_init + var_size2;
 
 	return sctp_raw_to_bind_addrs(&asoc->base.bind_addr, raw, var_size3,
 				      asoc->ep->base.bind_addr.port, gfp);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 4dbbbc2a7742..08527d882e56 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1707,11 +1707,11 @@ static struct sctp_cookie_param *sctp_pack_cookie(
 					 ktime_get_real());
 
 	/* Copy the peer's init packet.  */
-	memcpy(&cookie->c.peer_init[0], init_chunk->chunk_hdr,
+	memcpy(cookie + 1, init_chunk->chunk_hdr,
 	       ntohs(init_chunk->chunk_hdr->length));
 
 	/* Copy the raw local address list of the association. */
-	memcpy((__u8 *)&cookie->c.peer_init[0] +
+	memcpy((__u8 *)(cookie + 1) +
 	       ntohs(init_chunk->chunk_hdr->length), raw_addrs, addrs_len);
 
 	if (sctp_sk(ep->base.sk)->hmac) {
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8d0cfd689b20..7b8eb735fa88 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -794,8 +794,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	/* This is a brand-new association, so these are not yet side
 	 * effects--it is safe to run them here.
 	 */
-	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
-
+	peer_init = (struct sctp_init_chunk *)(chunk->subh.cookie_hdr + 1);
 	if (!sctp_process_init(new_asoc, chunk,
 			       &chunk->subh.cookie_hdr->c.peer_addr,
 			       peer_init, GFP_ATOMIC))
@@ -1869,8 +1868,7 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 	/* new_asoc is a brand-new association, so these are not yet
 	 * side effects--it is safe to run them here.
 	 */
-	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
-
+	peer_init = (struct sctp_init_chunk *)(chunk->subh.cookie_hdr + 1);
 	if (!sctp_process_init(new_asoc, chunk, sctp_source(chunk), peer_init,
 			       GFP_ATOMIC))
 		goto nomem;
@@ -1990,7 +1988,7 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
 	/* new_asoc is a brand-new association, so these are not yet
 	 * side effects--it is safe to run them here.
 	 */
-	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
+	peer_init = (struct sctp_init_chunk *)(chunk->subh.cookie_hdr + 1);
 	if (!sctp_process_init(new_asoc, chunk, sctp_source(chunk), peer_init,
 			       GFP_ATOMIC))
 		goto nomem;
-- 
2.39.1

