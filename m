Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7415F4A3AC5
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 23:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiA3WoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 17:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiA3WoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 17:44:13 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D8CC061714;
        Sun, 30 Jan 2022 14:44:13 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c192so8938436wma.4;
        Sun, 30 Jan 2022 14:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHc8NLN3sQxn1fc1CRrB+PP5SmjSJqCvIJwFqRlprAU=;
        b=Ky96IH+Gp2o2rsAOAQrDenlj7zQfEvCZjxSRSIecl0TgRG6fGIL4bATaPJOPl/lArZ
         4KLi4Ur4IRLJvk2erhoW6R0L4ZCpWeo2hC5D15nEZG100DrhdQSoD2TW6q1WEUy5rUj8
         0ZXpmUf0Z3eB7IIOHaj8uPgQ2tjXm/riSQFvX0OSqObKDvjWOBC0jl8rJU3OX0MSa4WV
         VVg0NXmERa92NWlcS4qKr6swQ2JKADlJxmBJjO3zzQbucBvRTmrlndd3ah9a6AE2+2Od
         Y+hoSYWXzfwGn0Q+6f/S70M1znoWDwuQ5uTPndFa5DePgctDcBl+7/Sf0JBnDEaeNOvX
         q4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHc8NLN3sQxn1fc1CRrB+PP5SmjSJqCvIJwFqRlprAU=;
        b=2al8eFRD0ugeMnm2IbFpNovfAvUvLIcQQmjBUAqPL5BebeMfhD2598NX+Ius3rGBJr
         n+TiTdwSbZBC5evDpSVf/4JY6ppdtiHOWmM8h64VKIprvbwNeHkeN/na/PfxR9cVJaNR
         A1R1GAByXSX6/iN/C/qJyAWmP99TC9rRi0O1pBQXwADfJmcHuFCoj3t3HhF6R5Ct5Nko
         ryIsVkjD/WMCHYdlVcw4AwXLH+6H+GYEsiWMMQrbnT6K1kA7M2G2RVykKSqvdSdtFo6i
         XB6XpDUchlWtjSf/V23Mkla/aFM2pdibtQHRpmd3/ug454t4UM3w0iKN/CPvhZacym5m
         /o1g==
X-Gm-Message-State: AOAM532EJV+GylXPZeivf5Q8GW7UbweOVY14D3vnJDQEWDMJh52vn/+W
        4lOCotwKEtAmWa27qu7JtIE=
X-Google-Smtp-Source: ABdhPJyDsialffTft+TXEZaBWa7hxUp3o/10YNMp5A1jlF6BgnZRvnuqI7R/DOGu6e+IKOWV8xe5xw==
X-Received: by 2002:a05:600c:4f87:: with SMTP id n7mr24979573wmq.133.1643582651901;
        Sun, 30 Jan 2022 14:44:11 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id c14sm11018219wri.56.2022.01.30.14.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 14:44:11 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SUNRPC: remove redundant pointer plainhdr
Date:   Sun, 30 Jan 2022 22:44:10 +0000
Message-Id: <20220130224410.7269-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer plainhdr is being assigned a value that is never read, the
pointer is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/sunrpc/auth_gss/gss_krb5_wrap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index e95c009bb869..5f96e75f9eec 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -409,7 +409,7 @@ static u32
 gss_wrap_kerberos_v2(struct krb5_ctx *kctx, u32 offset,
 		     struct xdr_buf *buf, struct page **pages)
 {
-	u8		*ptr, *plainhdr;
+	u8		*ptr;
 	time64_t	now;
 	u8		flags = 0x00;
 	__be16		*be16ptr;
@@ -426,7 +426,7 @@ gss_wrap_kerberos_v2(struct krb5_ctx *kctx, u32 offset,
 		return GSS_S_FAILURE;
 
 	/* construct gss token header */
-	ptr = plainhdr = buf->head[0].iov_base + offset;
+	ptr = buf->head[0].iov_base + offset;
 	*ptr++ = (unsigned char) ((KG2_TOK_WRAP>>8) & 0xff);
 	*ptr++ = (unsigned char) (KG2_TOK_WRAP & 0xff);
 
-- 
2.34.1

