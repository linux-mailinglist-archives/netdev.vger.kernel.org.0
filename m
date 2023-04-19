Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035BC6E7E0F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjDSPTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbjDSPTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:19 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F5E4489;
        Wed, 19 Apr 2023 08:18:51 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id m21so22345430qtg.0;
        Wed, 19 Apr 2023 08:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917418; x=1684509418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7bp3sdV7JAVhgQxmlbWl+vFysG/hec405GOyDsGjbQ=;
        b=GASRW55qbaZfVVXFxmYE/PT1hCZcxw73Ojq8A36359ZQ4rRajuaZeYHu7raJbibRoA
         E4B12PbOYxofoOqxjhErMCkTFSOjGJ+nMioXUo7Jr6C1EwZqXVoRSs4lJCMuuDHJv9Sy
         iJ3owTtV8Q57NNcoN0dAWxBTxlFtcMhnbea8LaJzu/S81+CLd/x1vYstgVeEfzpnreBv
         EwRW37ATYQHe7me/7+0EhqH6XiE3ZK0m9vf0LDRrNZUh1FEov+jjBA5jbw8mRsbhOO5o
         2z4LleyztkYxjfBQZcUefgKAW+4RgKrQ7JN1945Bastl/Zkh+UNOwOBoct5yyJ/Nrfhw
         52ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917418; x=1684509418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7bp3sdV7JAVhgQxmlbWl+vFysG/hec405GOyDsGjbQ=;
        b=bWpvUWL1kOcQoe4TXcqYtWvhB7Y1rsaTlofFYuIucbv3ZFVUtCzfNjWuDSmD/dZT2p
         SwY0Otc2YGDf8T6Vsg5i2cWeWMCGJ2FnkYY214d9kPIFO7Ue5Y0tXVlpkEoVBnHzVCsd
         J4n8PS+Usf+0P/xAsnHkNZM2X+UeIazQHKaHDxWLDC+LwSWpA6AExfB9seCji2rKj56S
         xABfQLEJsXgy/aN4EKhZCwrHonnaarcgbEOX3ReeAL6SMpQwLwfwUypJOco3sN+G+/sB
         ESr9pt9IA0w6Fi2vpxMz3UweuwSaw9wa+qJkineCU4xYjNwtccDdDltMwrVSIR1clM3J
         OJcg==
X-Gm-Message-State: AAQBX9fkHiNDsHAQzfXgv+RSAZ/trHf/ipXyeCvz0qca5NeRGY/LhQKI
        3kO0aBwuk0mH51fLTcIHguc6o4IUSYQuTA==
X-Google-Smtp-Source: AKy350aNKbpQ3sm5HcgzzeebHTIke4J+3KlEeOBXva/H3Us3/bbnOg8wbqmXCAfaBr24nDM5GntZ9w==
X-Received: by 2002:a25:5945:0:b0:b8e:e032:b654 with SMTP id n66-20020a255945000000b00b8ee032b654mr22860086ybb.56.1681917399416;
        Wed, 19 Apr 2023 08:16:39 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 5/6] sctp: delete the nested flexible array hmac
Date:   Wed, 19 Apr 2023 11:16:32 -0400
Message-Id: <98dc440abe4cb430e3fa65385c1418572b151774.1681917361.git.lucien.xin@gmail.com>
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

This patch deletes the flexible-array hmac[] from the structure
sctp_authhdr to avoid some sparse warnings:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  net/sctp/auth.c: note: in included file (through include/net/sctp/structs.h, include/net/sctp/sctp.h):
  ./include/linux/sctp.h:735:29: warning: nested flexible array

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h    | 2 +-
 net/sctp/auth.c         | 2 +-
 net/sctp/sm_statefuns.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 01a0eb7e9fa1..d182e8c41985 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -727,7 +727,7 @@ struct sctp_addip_chunk {
 struct sctp_authhdr {
 	__be16 shkey_id;
 	__be16 hmac_id;
-	__u8   hmac[];
+	/* __u8   hmac[]; */
 };
 
 struct sctp_auth_chunk {
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 34964145514e..c58fffc86a0c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -738,7 +738,7 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 
 	tfm = asoc->ep->auth_hmacs[hmac_id];
 
-	digest = auth->auth_hdr.hmac;
+	digest = (u8 *)(&auth->auth_hdr + 1);
 	if (crypto_shash_setkey(tfm, &asoc_key->data[0], asoc_key->len))
 		goto free;
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7b8eb735fa88..97f1155a2045 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4391,7 +4391,7 @@ static enum sctp_ierror sctp_sf_authenticate(
 	 *  3. Compute the new digest
 	 *  4. Compare saved and new digests.
 	 */
-	digest = auth_hdr->hmac;
+	digest = (u8 *)(auth_hdr + 1);
 	skb_pull(chunk->skb, sig_len);
 
 	save_digest = kmemdup(digest, sig_len, GFP_ATOMIC);
-- 
2.39.1

