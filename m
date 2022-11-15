Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1DC629DC6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiKOPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiKOPk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:40:26 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ADF2A246;
        Tue, 15 Nov 2022 07:40:24 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id cg5so8906111qtb.12;
        Tue, 15 Nov 2022 07:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gLjbw+zl+ADaxdr0303nF/223fOw/FnvNvlrJe5WEnE=;
        b=LXOoUnTKRYRAK9k/nkPcn8grs630vkcuRFi1YWmEGHt0HcHK36blCnc7VGRpH8BmBJ
         6ZQDwcYjupNKwgTfB/eZmcdj5PZop4fehx7q2Z9YiMICH5t0v4PmZ2TDA/bsH5W712GJ
         Mp894CRI+qp+n7aDDGnlMcqQ3OLo8nSq/YnnRgDEd/+xfZI2zU0n87u3m9CKkNJs+npQ
         BRdoTLnx7W7uoaFIP5CndZu7rx+PNDw9U2zSRhvpkbxVGAQPPqEStzsmbJAGkJS7isQp
         95qCKXKeVWgqmNcuV8UZ6F/o/yWRmNojwxgDflBiPIKVDDNf+9E1m/+JMfb815a6r/ac
         gmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gLjbw+zl+ADaxdr0303nF/223fOw/FnvNvlrJe5WEnE=;
        b=UiZ0DZhCrEYjJYSZ13fDZKv3QEXRm/NBv1oMG0S7PRRMsIs6o+ziTnsGWvqFBiJi9L
         1MCqH4xhZua3438SuI5BbYEGIIp3GWqn94omGJz5sYJXnMBf/xJolmvXYmv0ogmVBFw2
         YN7vEOXfVFSbDSxzEHUhG3sLN65qa3mGFgvJHAlGQHpunNt2orYAxhhq2PGfd+QX50nE
         JgEAQZ16W38EUOyBk9euX6B494fLn/wyuUQclS9fQ3AAC6o997h53izR0HQpxP7sYrtp
         ARAUohJW7IQes3PgDj4nuGrSf37Mj+WJWRKVPjhZCrJXc6COPp4UtmwpR8IDbr2rDqvE
         L1xw==
X-Gm-Message-State: ANoB5plR7sR552MV3ewGIYnLvfLW0uYuWVskGEKvDyoaXlQfDMXQ9Y6D
        z4iOg+XcQnDLeJGsRKVocRJ1d/Bh2pmahg==
X-Google-Smtp-Source: AA0mqf5HhkXPob2Rj3Pd7ZO1KG/GwGbPkqTE41eTDRL+PapHkg71PhoWsSJ3Op38E19CAt3mqgvQtA==
X-Received: by 2002:a05:622a:1e11:b0:3a5:b4ab:cb80 with SMTP id br17-20020a05622a1e1100b003a5b4abcb80mr16752698qtb.59.1668526823479;
        Tue, 15 Nov 2022 07:40:23 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v14-20020a05620a440e00b006fba0a389a4sm937978qkp.88.2022.11.15.07.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:40:23 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next] sctp: move SCTP_PAD4 and SCTP_TRUNC4 to linux/sctp.h
Date:   Tue, 15 Nov 2022 10:40:21 -0500
Message-Id: <ef6468a687f36da06f575c2131cd4612f6b7be88.1668526821.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Move these two macros from net/sctp/sctp.h to linux/sctp.h, so that
it will be enough to include only linux/sctp.h in nft_exthdr.c and
xt_sctp.c. It should not include "net/sctp/sctp.h" if a module does
not have a dependence on SCTP module.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h       | 5 +++++
 include/net/sctp/sctp.h    | 5 -----
 net/netfilter/nft_exthdr.c | 1 -
 net/netfilter/xt_sctp.c    | 1 -
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index a86e852507b3..358dc08e0831 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -820,4 +820,9 @@ struct sctp_new_encap_port_hdr {
 	__be16 new_port;
 };
 
+/* Round an int up to the next multiple of 4.  */
+#define SCTP_PAD4(s) (((s)+3)&~3)
+/* Truncate to the previous multiple of 4.  */
+#define SCTP_TRUNC4(s) ((s)&~3)
+
 #endif /* __LINUX_SCTP_H__ */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 4d36846e8845..bfa1b89782e2 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -67,11 +67,6 @@
 #define SCTP_PROTOSW_FLAG INET_PROTOSW_PERMANENT
 #endif
 
-/* Round an int up to the next multiple of 4.  */
-#define SCTP_PAD4(s) (((s)+3)&~3)
-/* Truncate to the previous multiple of 4.  */
-#define SCTP_TRUNC4(s) ((s)&~3)
-
 /*
  * Function declarations.
  */
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a67ea9c3ae57..d956c034ed8d 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -13,7 +13,6 @@
 #include <linux/sctp.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
-#include <net/sctp/sctp.h>
 #include <net/tcp.h>
 
 struct nft_exthdr {
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 680015ba7cb6..e8961094a282 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -4,7 +4,6 @@
 #include <linux/skbuff.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
-#include <net/sctp/sctp.h>
 #include <linux/sctp.h>
 
 #include <linux/netfilter/x_tables.h>
-- 
2.31.1

