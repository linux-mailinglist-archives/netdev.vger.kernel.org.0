Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010018D897
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfHNQ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:58:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39807 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfHNQ6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:58:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so21659983wra.6;
        Wed, 14 Aug 2019 09:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uMo+P0KZM2egL/LGoSsPpOMP32NasvU+xJ/Ms0bauJU=;
        b=pcczEiMYrynw454fsutGrSy2jvAne2yK5XfdfVtCUtZutyT2BZa447bEoLq4ShC9E5
         dYLYtjmJSzSB5puRBFx33qbe/5b+BbgeBS+NhsuqdjwbKbo0dIVpJO8WfsVk7B8b/1Pn
         2USNqz6kfkw3hFaNZuByTSg5IVedcGxUSNELoIiNQl3j8odW6E/Y1XfPEhtqV0Z0rXSK
         m5+sL5pNokcTI9YFzt+wdOMN4rrNPavW5LGN8uXlgKHrLuvoPJ2+U/9EPKCrP0cSKQ4Y
         K75Vum8fNJdX2nyUGrTsojq9hVZB0SU4w49BZe1Rdx3shNquZs+jYwvfUaicxB+8Riv4
         W9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uMo+P0KZM2egL/LGoSsPpOMP32NasvU+xJ/Ms0bauJU=;
        b=AhODqpTDxJWEApxaK9ADEfRztqQTE3Z7ErF998cZn6iMgtn9j6Bqa9F+JHlw1O2HzH
         90ypM7x5EYZmPyxAMI+k/ydNfyb/axyKkbpeYnILiLR+MBjXBIHZrcmMALpaO2M7qmLV
         fgLxufivYLvgbfJNr2rXk2RxD2SaroRO6lzpToqhv1XRhYeZWyZDaMe/X/oYQgZnVg3Q
         Pi6O8idOg/DEyknXfjlw2DQrdy/rQkSESB7skdovjixdrthYB+l1VQYURVuIDYKomWKT
         UZ8gd0kev4edV72iDUava2M+EmdwIqnkPqYY7m87R6PWVkBwczs5yEpkNHkJf0LafTQh
         DSEA==
X-Gm-Message-State: APjAAAXrAL56Gamz4hAoi23wbNTnNMKINr9g6ueUJQaZD+/OUFhAxq0B
        9Gyymn0h7CnX2aKX+mt2dik=
X-Google-Smtp-Source: APXvYqxnX8CX/gnf086yLPjIcV4cmRsYgIggWs2IzqxLcAsdnnicLgd4impOxxIxX6VObIPKga7LfA==
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr776013wrn.54.1565801912364;
        Wed, 14 Aug 2019 09:58:32 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id g12sm532151wrv.9.2019.08.14.09.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 09:58:31 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] netfilter: nft_bitwise: Adjust parentheses to fix memcmp size argument
Date:   Wed, 14 Aug 2019 09:58:09 -0700
Message-Id: <20190814165809.46421-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0.rc2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns:

net/netfilter/nft_bitwise.c:138:50: error: size argument in 'memcmp'
call is a comparison [-Werror,-Wmemsize-comparison]
        if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
                                      ~~~~~~~~~~~~~~~~~~^~
net/netfilter/nft_bitwise.c:138:6: note: did you mean to compare the
result of 'memcmp' instead?
        if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
            ^
                                                       )
net/netfilter/nft_bitwise.c:138:32: note: explicitly cast the argument
to size_t to silence this warning
        if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
                                      ^
                                      (size_t)(
1 error generated.

Adjust the parentheses so that the result of the sizeof is used for the
size argument in memcmp, rather than the result of the comparison (which
would always be true because sizeof is a non-zero number).

Fixes: bd8699e9e292 ("netfilter: nft_bitwise: add offload support")
Link: https://github.com/ClangBuiltLinux/linux/issues/638
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/netfilter/nft_bitwise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 1f04ed5c518c..974300178fa9 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -135,8 +135,8 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 
-	if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
-	    priv->sreg != priv->dreg))
+	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
+	    priv->sreg != priv->dreg)
 		return -EOPNOTSUPP;
 
 	memcpy(&ctx->regs[priv->dreg].mask, &priv->mask, sizeof(priv->mask));
-- 
2.23.0.rc2

