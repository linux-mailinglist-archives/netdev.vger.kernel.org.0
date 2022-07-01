Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC255631EB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiGAKwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiGAKwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:52:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05107D1C2;
        Fri,  1 Jul 2022 03:51:59 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o4so2655376wrh.3;
        Fri, 01 Jul 2022 03:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oyc/+3fJaJYytyUhCXFNiLRQsFA3SKTfZsuSpfHSjfk=;
        b=UPtMHhi38U0/t5d9VeVWXw3Io8R9s/W3Z+gbgw3uqRDHfFJyER3XwNewCH7fx6tnfU
         6FtpREpQbHWHbbSSGaguF0ja8XHaKsi3W/0zTJcoj2URVrJ+6RPuwprENVG+zw+vvght
         ViMEwfm1+iyQ97ybW5I6vmshwPvKtCIFF17J578SP1uOAuzTk0C7Ac0+k47zb6paL8yI
         XI9wSrIr4EF73RzeTGxjOxHYtBgzhQjcgC5WOhD+Q8Q/Lx1AKmh6GKCEcJWSulicbgCC
         zGGYVDPl+QENDSzbLqOMQfNL0wFBREzNi1wEM5x9HtumdzB1CUb6iEOz5iKYsITY5OGf
         iOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oyc/+3fJaJYytyUhCXFNiLRQsFA3SKTfZsuSpfHSjfk=;
        b=yLbUyW1xkPWJ86jEQEsM30ufAIc9ic7w48esjarFdTZjc5AlgSkfvdQupb0CGODWEA
         ckIGB0JKHVjcTSyLs/mG/tsBx5/ksCuhabiQNIAvXLbKGddmD7Ep7G88kjOkvrAU1SKa
         uK/irh0B66edTz/VyY7MgAOpdNZGMkrsMWU42gPN5UgXp8/6o0fhbnlsThz8InHgvbkF
         zyGteJFkGOZDNshl029jC04CnWlPL/H3qi0fKgI5O94wUqsJDaS5efI4CkZt7CpEMTYH
         dadCx/9RJhE+13jDd+ovh3wtstZCA5a1NV7OY6mWCd+oD+jXSxl4dvViPimFnsH40z6E
         SnkA==
X-Gm-Message-State: AJIora8jYIrxpzCT/pXD0S+QIFyHvteMl1g0kJVwXw7CDdAYdcCmEbfS
        j00FZ+O/ChfcVIAytMTT8IYU7P8QuinUrQ==
X-Google-Smtp-Source: AGRyM1vJCec/8d+FAbjdDBBogA7EWffnj+go1kT2RROiZ2Wtkxj2zHc0G1hR3iDrC2zy6QAFcQgvWQ==
X-Received: by 2002:a05:6000:1449:b0:21b:b171:5eb8 with SMTP id v9-20020a056000144900b0021bb1715eb8mr13325469wrx.634.1656672718089;
        Fri, 01 Jul 2022 03:51:58 -0700 (PDT)
Received: from localhost.localdomain (host-79-53-109-127.retail.telecomitalia.it. [79.53.109.127])
        by smtp.gmail.com with ESMTPSA id 18-20020a05600c269200b003a03a8475bfsm5777498wmt.16.2022.07.01.03.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:51:56 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wei Wang <weiwan@google.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [RFC PATCH] net: core: Replace kmap() with kmap_local_page()
Date:   Fri,  1 Jul 2022 12:51:52 +0200
Message-Id: <20220701105152.6920-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.36.1
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

The use of kmap() is being deprecated in favor of kmap_local_page().

With kmap_local_page(), the mappings are per thread, CPU local and not
globally visible. Taking page faults is allowed. Furthermore, the mappings
can be acquired from any context (including interrupts).

Therefore, use kmap_local_page() in sock.c and datagram.c because these
mappings are per thread, CPU local, and not globally visible.

Actually this is an RFC because I'm not 100% sure that the mappings in
sock.c are not handed over to other contexts. Unfortunately I know very
little about this code. The fact that "page" is kmapped and then kunmapped
before exiting sock_send_page*() is not a guarantee of thread locality.
That "kernel_sendmsg*()" is a bit "suspicious".

Can anyone please confirm whether or not "kaddr" is handed over to other
contexts while the call sites might sleep between kmap() / kunmap()?

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 net/core/datagram.c | 4 ++--
 net/core/sock.c     | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 50f4faeea76c..3a8fa210e1a1 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -438,14 +438,14 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 		end = start + skb_frag_size(frag);
 		if ((copy = end - offset) > 0) {
 			struct page *page = skb_frag_page(frag);
-			u8 *vaddr = kmap(page);
+			u8 *vaddr = kmap_local_page(page);
 
 			if (copy > len)
 				copy = len;
 			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
 					vaddr + skb_frag_off(frag) + offset - start,
 					copy, data, to);
-			kunmap(page);
+			kunmap_local(vaddr);
 			offset += n;
 			if (n != copy)
 				goto short_copy;
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ff40dd0a7a6..12dd6ced62cf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3155,11 +3155,11 @@ ssize_t sock_no_sendpage(struct socket *sock, struct page *page, int offset, siz
 	ssize_t res;
 	struct msghdr msg = {.msg_flags = flags};
 	struct kvec iov;
-	char *kaddr = kmap(page);
+	char *kaddr = kmap_local_page(page);
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
 	res = kernel_sendmsg(sock, &msg, &iov, 1, size);
-	kunmap(page);
+	kunmap_local(kaddr);
 	return res;
 }
 EXPORT_SYMBOL(sock_no_sendpage);
@@ -3170,12 +3170,12 @@ ssize_t sock_no_sendpage_locked(struct sock *sk, struct page *page,
 	ssize_t res;
 	struct msghdr msg = {.msg_flags = flags};
 	struct kvec iov;
-	char *kaddr = kmap(page);
+	char *kaddr = kmap_local_page(page);
 
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
 	res = kernel_sendmsg_locked(sk, &msg, &iov, 1, size);
-	kunmap(page);
+	kunmap_local(kaddr);
 	return res;
 }
 EXPORT_SYMBOL(sock_no_sendpage_locked);
-- 
2.36.1

