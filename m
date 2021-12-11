Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF174715B0
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhLKTai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhLKTah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:30:37 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09068C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:30:37 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id t11so11613988qtw.3
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ym7Hmxs8bQvOILbWqOr3GfdzEeej8L4ZIingTpygvXs=;
        b=hugcjm8L0mxnaVeyr18x6TGeyRXBnETUjxmDN81MI/iRPCTVtxBu4WUPFW2J7G1esh
         +9qWF7cJqVtWWX+TwVdo/8dTjeUaMkvyjUoKRvbZxz2ZlLoKoD/WUn2TLWw+F2x6ENpP
         oECH2BXzgbFvf/L86N/mQJki0jCaqCsx0d/ey5JnrhDVaCHpqtoCLCiF3qXmrraqvpY/
         QAGTtJKDWubqAQy99REDv7vreKs8TSshZT5vxihibhFoQ9ODaQr6epTSV3kofySLvyFR
         3Yjd8G8dNAgOPsJ4qdnOwr87fa869nEdK8KtNJjy1NSBzdR14VQ24vc9CeQAPjpWqcyQ
         GZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ym7Hmxs8bQvOILbWqOr3GfdzEeej8L4ZIingTpygvXs=;
        b=Mw4M413hYtWFwcPY2opBDNvDEvfJKsk3Er1PsdBB7auSSfHNtCJnACvWuA/E8NGEPT
         3O3WcfTgpcZeT4s0yqtY0j/4XLDV7Qdl+Nj41bny1qiKdXzKbcdvD0dTSE47A/cn6tz9
         hweuKmej9n69f4o8PGICLh7VOMbT0naTOMnO3Vx21wWQ125mX703ZTiK8FxeyFlym4Bu
         JoLNoe0dqY7baaOUFfdCrvJJ/WtOR0gj4IE/eXmNGXcED9NaZmtEjpaHDsIeI+ZreelJ
         bPOLcd5ZhvqpJnNtgXFQFGSpMegvJlVAigsFkFZFhe1YyuOrkoPt7uTP0YvDawBWIcVF
         NyRA==
X-Gm-Message-State: AOAM533jp1PrPXu6bQcZcMeZYtcN6E3SCbP9ZOUwBbD/3ABajUVxiknU
        Z5Iq5JffH3k1il4EEAx2KwWmLp7zfw4=
X-Google-Smtp-Source: ABdhPJwFzL1EknyK7DoM/6FPGeQ3Z1kzf0oi57HCeqdJwq/Nab9mv3npjU/Ww70yi8Z3pgyGbt8sGA==
X-Received: by 2002:ac8:5914:: with SMTP id 20mr35432787qty.409.1639251036081;
        Sat, 11 Dec 2021 11:30:36 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id w8sm5182287qtc.36.2021.12.11.11.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:30:35 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: toeplitz: fix udp option
Date:   Sat, 11 Dec 2021 14:30:31 -0500
Message-Id: <20211211193031.2178614-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Tiny fix. Option -u ("use udp") does not take an argument.

It can cause the next argument to silently be ignored.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/toeplitz.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index 710ac956bdb3..c5489341cfb8 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -498,7 +498,7 @@ static void parse_opts(int argc, char **argv)
 	bool have_toeplitz = false;
 	int index, c;
 
-	while ((c = getopt_long(argc, argv, "46C:d:i:k:r:stT:u:v", long_options, &index)) != -1) {
+	while ((c = getopt_long(argc, argv, "46C:d:i:k:r:stT:uv", long_options, &index)) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = AF_INET;
-- 
2.34.1.173.g76aa8bc2d0-goog

