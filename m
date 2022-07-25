Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B39C57FBB3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiGYIvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiGYIvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:51:40 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5205514027;
        Mon, 25 Jul 2022 01:51:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id z18so644666edb.10;
        Mon, 25 Jul 2022 01:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7VDIfJeDLEQjiAoLKeDhLnV53pDE54HSkUBU93kqjMs=;
        b=RP/7JHtL4ED/RiMs6sUUdJbaXFTS+nPl6RYIzG6dLkHxDhR0GXLrvXF8MJNQk6+wzL
         pt9KDi2iLDraRGcADN4bcWIo0n4r3CTu/V9aNRBevCzUcV6XHw9V64X/4agMPM9r2Bgg
         ZEI87i7xbFSvMD/aUiOSuN6fXYrpPONE/h4lfKSEr0GVHpVI+dqAlRIOEnykS7KLmvDV
         6n+3mx7UKVRfGn1zQzJGmGp6c50ga0rTMW4H/CwEPX20zszL6xnpyQefemmhQvuvZlTh
         e2Rcgo4ANCr1UYv8V9q3bAVaLHBmPFlIAFSvcYCifRRNhU+kwJsP+io4rEDSn/Amwtg1
         xlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7VDIfJeDLEQjiAoLKeDhLnV53pDE54HSkUBU93kqjMs=;
        b=Tb5Yx15/mAzx3kWje0Ny0LzCdB53zxWG1OkMEm7Fr96wrX7vpPcB41kNyOfVoKuurl
         V+YjGx+nifYJlEdLbNhcroBzTCEBK94DuRYtNOY4nnS82CbfKD0wZ44wnm9pqlXLgsQ/
         i8SCz2stGW3LXd1XR4tw9eeFcbFceNZBRJ5YaaFmpcRTXMQiKisrrfMj5qbxpTvCxbj1
         LLqffVrN4czyBabYDPWqMzmFJfgblu1XzhcdYyrVes/VGB7cc4iucO4+onQFl9mrEg32
         yllVl94wNPHJLvmwTi+iaYt5ZQ9puR6AhOoaAEEK9AKd8GJerjwfCtKL6iCr1hDn4m8t
         QNKg==
X-Gm-Message-State: AJIora9cCjYYvyOp4uGDldYUA68l9FH497NU3KYBdb/hNZb5iHUyb1NV
        aDFm0GjvcrwR8jZI4iZ4BuXsqtfESuWujQ==
X-Google-Smtp-Source: AGRyM1sdDwoqIrKCiJ9CA9hvp2tP3l8yF16RtWH52vlyVDgdhlg61in62cp8scrtgSQUg9qpFbB3XQ==
X-Received: by 2002:a05:6402:371a:b0:43a:ece9:ab8e with SMTP id ek26-20020a056402371a00b0043aece9ab8emr11943370edb.126.1658739097423;
        Mon, 25 Jul 2022 01:51:37 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id o26-20020a170906769a00b0070e238ff66fsm5117576ejm.96.2022.07.25.01.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:51:37 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next] net: netfilter: Remove ifdefs for code shared by BPF and ctnetlink
Date:   Mon, 25 Jul 2022 10:51:30 +0200
Message-Id: <20220725085130.11553-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The current ifdefry for code shared by the BPF and ctnetlink side looks
ugly. As per Pablo's request, simplify this by unconditionally compiling
in the code. This can be revisited when the shared code between the two
grows further.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h | 6 ------
 net/netfilter/nf_conntrack_core.c         | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3cd3a6e631aa..b2b9de70d9f4 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -86,10 +86,6 @@ extern spinlock_t nf_conntrack_expect_lock;

 /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */

-#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
-    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
-    IS_ENABLED(CONFIG_NF_CT_NETLINK))
-
 static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 {
 	if (timeout > INT_MAX)
@@ -101,6 +97,4 @@ int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
 void __nf_ct_change_status(struct nf_conn *ct, unsigned long on, unsigned long off);
 int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status);

-#endif
-
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 66a0aa8dbc3b..afe02772c010 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2787,10 +2787,6 @@ int nf_conntrack_init_net(struct net *net)
 	return ret;
 }

-#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
-    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
-    IS_ENABLED(CONFIG_NF_CT_NETLINK))
-
 /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */

 int __nf_ct_change_timeout(struct nf_conn *ct, u64 timeout)
@@ -2846,5 +2842,3 @@ int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_change_status_common);
-
-#endif
--
2.34.1

