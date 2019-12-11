Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11C11BB64
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbfLKSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:06 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37305 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731264AbfLKSPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:33 -0500
Received: by mail-yb1-f195.google.com with SMTP id x139so9399477ybe.4;
        Wed, 11 Dec 2019 10:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jsmfuvj/jRIcDYES8Oc8uYcAOMzoL2nHcB1C2C+d/QQ=;
        b=fzv2XaxVk0gbz/EmTCRlUrhztpjFTMk41lHSfPzOF8UnOTOsjrj3+6Z2PMP2gkZks8
         kSsW0oc7KK12AndYnRfRQejRZwpzEaxbQPHEZ/JvoqOJYSQgD2gwrF+p2ChoYoHffmDL
         WiEZWOyNhDEqKYfPhIJYHerhv0KyIS0Xlfu1LzB1PJZC1TRBaoPxe1InpB3QHMHzUqXQ
         9dX+F1TTZoXA/1yS34ytgCRa1D7BA2u2gqdkAgiwJ3x3UHIb2XohQD02DqQAQZedHHtd
         f5FTNVDWXYhaiIJmrsgd17QG7qnAnL7JJofW0kVxCWcj4rqPil9Yqw+s5N63mBkYpnOU
         9JxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jsmfuvj/jRIcDYES8Oc8uYcAOMzoL2nHcB1C2C+d/QQ=;
        b=AnKJ/q/j2/H1EswYnLm5kE+GkLd3fcaYsYints2KPZMEaiCiVDZ8EduA2xraOUP7cd
         JKj/ATc6rUrHU+IkfnQr3Kc9v5WLpjfw4W+4jFYh3Cv/mgwGl29Mk2r3iAidMdDbJOax
         cEvqxq1lT/OMU78FjDdP+QNLj998R4hrPWEfkB4Zd1Sameqm/BIu6UxPxgatju7F7WHJ
         +hJFZXjoPbZlrDS3p7NfU0RIPpJPs3qeLGOCpCKv1XJGHT0idsbJC7UrxA6+uSw0ZP4B
         Qcyy4IXUwPzWzgN7aHUnZUW48zVI57drdWL0oiNJEoorx+Hf6g3hXwPSLUdcvzbC4AKx
         D9qw==
X-Gm-Message-State: APjAAAXJwCxbsuikSs5lrQvrgNM7eiHKvCaGxBwTfmWEZ9zGLWwy22Rl
        nIKXD/cprtGKY2/OYElHUu2M+CoZHEpu/A==
X-Google-Smtp-Source: APXvYqyafrghq+IOLe5aUFpMlgZQVWihCWXIStViTcUzM5tny0gClF6EV+rB2AAYUYMpp4H0So5pfA==
X-Received: by 2002:a25:d093:: with SMTP id h141mr890692ybg.233.1576088132033;
        Wed, 11 Dec 2019 10:15:32 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id t3sm1332576ywi.18.2019.12.11.10.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:31 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/23] staging: qlge: Fix CHECK: Prefer using the BIT macro
Date:   Wed, 11 Dec 2019 12:12:47 -0600
Message-Id: <f90d9a2ce4727586c1c1a2a0cb581fc214babc42.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Prefer using the BIT macro

changed (1<<4) to BIT(4) in 2 places in qlge.h

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 010d39b4b30d..de9e836c2788 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1274,7 +1274,7 @@ struct net_req_iocb {
  */
 struct wqicb {
 	__le16 len;
-#define Q_LEN_V		(1 << 4)
+#define Q_LEN_V		BIT(4)
 #define Q_LEN_CPP_CONT	0x0000
 #define Q_LEN_CPP_16	0x0001
 #define Q_LEN_CPP_32	0x0002
@@ -1309,7 +1309,7 @@ struct cqicb {
 #define FLAGS_LI	0x40
 #define FLAGS_LC	0x80
 	__le16 len;
-#define LEN_V		(1 << 4)
+#define LEN_V		BIT(4)
 #define LEN_CPP_CONT	0x0000
 #define LEN_CPP_32	0x0001
 #define LEN_CPP_64	0x0002
-- 
2.20.1

