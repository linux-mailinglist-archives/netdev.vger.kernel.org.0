Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A165F444DAA
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 04:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhKDDWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 23:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhKDDWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 23:22:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA778C061714;
        Wed,  3 Nov 2021 20:19:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a9so4197584pgg.7;
        Wed, 03 Nov 2021 20:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0jotiKljItHe5KgItLDS/7t02O1VaAIiEGP4SN4vD0A=;
        b=Ae0J45PtFmTsz/n9+bQcdzImbY6wZpCljFrXFrFOz0P0M/D+WEDSX/ETnHcFeu5Gkw
         V1UGUBwmXkeLjdd5cqHHThtCZmLMkn0N9e/TUsHOt/YIC4S3ttTChIt8gpoidCQI4u6x
         sUzMoIE1jN488QIyWNk3766RQkpka4mn8LerIc5wBXEr4TQ3v4PMaa262ytRlxTyd2MV
         BXcWCqhMKlPqZHH7V91Tw4yabcNMe4CDxBLMpRw73fusMtzWi2PWEPM2RfYoIgOHa/+k
         amhUNHeIslQ4oKaSNcA67TXOkXt1TWAcK+qDf1PylilOt4hiu9UoXspUCGuqMwlGyK8m
         Y++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0jotiKljItHe5KgItLDS/7t02O1VaAIiEGP4SN4vD0A=;
        b=wdFbxBXDl6od3XdGiS1VGlV7SeEnccf8WJM6pYb5v/eHTe1wMTdYm2FZ3tIqIrpYZS
         mpXs+Lcw7zDS3mOyBhFnj0S5ubKsR+Z7fxaI0TvqOMjvUaMHYTb6qkZ914T8oHxqCCAs
         +hx6DVkQ+8JjQXWA/Soy0mfOYJ5FamcgrwTzUqMSxw4qayNppHMPeqvFEyEvQlS4B7Vu
         R9etvzgJOa0SV4QHjO77vITu0IvLpdlkKDGpuCg9xbCWH+RvbqJLkiYxpxZirdk0Brny
         xnsKtGZhpXh+7JsPnrFfTQw5voqT6pL0fElIsIV0r8FJAttWarxqvbPReH1CXkzfcdZe
         veig==
X-Gm-Message-State: AOAM533cOWf4ATZPbwoY8HmGuVjlAFazPHGlBsGkrYu6L0x+/6tpKMjK
        PDVxtziJd7NfsqyHeroLPMc=
X-Google-Smtp-Source: ABdhPJwLkxgdPLlD4j/8jjjxbqhFexTDqobdydGwsrnE5lYvvhxVggXJcYALm3you5jh/nImxJX8ZA==
X-Received: by 2002:a62:1b8e:0:b0:44c:9318:f6e1 with SMTP id b136-20020a621b8e000000b0044c9318f6e1mr49400314pfb.84.1635995977415;
        Wed, 03 Nov 2021 20:19:37 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id md6sm2931005pjb.22.2021.11.03.20.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 20:19:37 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ipv6/esp6: Remove structure variables and alignment statements
Date:   Thu,  4 Nov 2021 03:19:31 +0000
Message-Id: <20211104031931.30714-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The definition of this variable is just to find the length of the
structure after aligning the structure. The PTR alignment function
is to optimize the size of the structure. In fact, it doesn't seem
to be of much use, because both members of the structure are of
type u32.
So I think that the definition of the variable and the
corresponding alignment can be deleted, the value of extralen can
be directly passed in the size of the structure.

The clang_analyzer complains as follows:

net/ipv6/esp6.c:117:27 warning:

Value stored to 'extra' during its initialization is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ipv6/esp6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ed2f061..c35c211 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -114,7 +114,6 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 
 static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 {
-	struct esp_output_extra *extra = esp_tmp_extra(tmp);
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
 	u8 *iv;
@@ -122,7 +121,7 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 	struct scatterlist *sg;
 
 	if (x->props.flags & XFRM_STATE_ESN)
-		extralen += sizeof(*extra);
+		extralen += sizeof(struct esp_output_extra);
 
 	iv = esp_tmp_iv(aead, tmp, extralen);
 	req = esp_tmp_req(aead, iv);
-- 
2.15.2


