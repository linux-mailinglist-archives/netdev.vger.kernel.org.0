Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA384CCFFE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 09:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbiCDIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 03:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiCDIf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 03:35:26 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FF8158E95
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 00:34:38 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o23so6906710pgk.13
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 00:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BKi1nqCy2fkxvqwYgg+I8fOgGO+Apt9NmabGt/p5Z5g=;
        b=IuNjwUhRZt18+l33HqJit7CwZXtk1WiubnXvzI/+Fdk073ls5dBH0AFwoeNukJ0sPx
         kDCR+Dp7h3ijMuI80RW1EyxZC0cSBh4nq4XLq6zAMZBAFvGqYMSKfBrutxDVD1RH8i4i
         civm3Qzj099bsdCH5RGEgGPtPEk5cfqCayrQuqFUgy1kVOBJjdH+R8mEoaxhlfofi89D
         sDCDfkNHql+9TDE66ptYyc9/VE+Y3ZHm6/K2Nyax4ZZr9QGlNlJ/zYbv4YAzNCbKAyDg
         4d/Fn2O0lUtml+yEodLbL8FLM6aC+K0fQx8SBQ4uXdpJPmNlls7xpN68wJZkxP7puPcF
         Jahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BKi1nqCy2fkxvqwYgg+I8fOgGO+Apt9NmabGt/p5Z5g=;
        b=orb1UQq7KgCQRQtTvsIhKxkNx+9T4qYRwbD1LX9uJ4MKrIF22OCo1Z2h3TzrQO03/N
         arDLvi8MszwaGs4X+bULU17aMuDZGabBoOklxs0v8qtJ6WAje1IrBBXxphqBP5Evi69L
         zeu1HXVAktieA34ihBVWoqNo9z3rXWUpVH0Ka/v24vQqn6fCoFynat1FnURDmhcVLFbU
         k4NHE2NN6ywqRYWa4BI9AXepWk1vmExxn/phx0oOPdJJSnXWrCmZPGyGttsBudfBAvN8
         c/P/+dcIdAyfFlYdCy1dih2X94P3db3HgoJOhhdmhLU51zZ53gFfKQMZCMVkvFcEaSn6
         KzpA==
X-Gm-Message-State: AOAM532oNJzDmQiwO/qLB+iFNHFxBinbJEA9WrRLjdeT2r/daaTQD/NZ
        ZtfhoAxtam4TZRvb5r0ksvU=
X-Google-Smtp-Source: ABdhPJzEO3mKwqAvBHyVl+XY04vu8OGMU7TFNbNNS2a5OSTzQpW+XuB4zpddLjsnhJ9TdlxqbErhlQ==
X-Received: by 2002:a63:4814:0:b0:36d:87fb:f1ed with SMTP id v20-20020a634814000000b0036d87fbf1edmr33511850pga.594.1646382877998;
        Fri, 04 Mar 2022 00:34:37 -0800 (PST)
Received: from ELIJAHBAI-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090a170200b001bf2d530d64sm702611pjd.2.2022.03.04.00.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 00:34:37 -0800 (PST)
From:   Haimin Zhang <tcs.kernel@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>
Subject: [PATCH] af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
Date:   Fri,  4 Mar 2022 16:33:27 +0800
Message-Id: <20220304083327.13514-1-tcs.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
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

From: Haimin Zhang <tcs_kernel@tencent.com>

Add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
to initialize the buffer of supp_skb.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
---
This can cause a kernel-info-leak problem.
1. Function pfkey_register calls compose_sadb_supported to request a sk_buff.
2. compose_sadb_supported calls alloc_sbk to allocate a sk_buff, but it doesn't zero it.
3. If auth_len is greater 0, then compose_sadb_supported treats the memory as a struct sadb_supported and begins to initialize.
 But it just initializes the field sadb_supported_len and field sadb_supported_exttype without field sadb_supported_reserved.
```
 slab_post_alloc_hook build/../mm/slab.h:737 [inline]
 slab_alloc_node build/../mm/slub.c:3247 [inline]
 __kmalloc_node_track_caller+0x8da/0x11d0 build/../mm/slub.c:4975
 kmalloc_reserve build/../net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 build/../net/core/skbuff.c:426
 alloc_skb build/../include/linux/skbuff.h:1158 [inline]
 compose_sadb_supported build/../net/key/af_key.c:1631 [inline]
 pfkey_register+0x3c6/0xdb0 build/../net/key/af_key.c:1702
 pfkey_process build/../net/key/af_key.c:2837 [inline]
 pfkey_sendmsg+0x16bb/0x1c60 build/../net/key/af_key.c:3676
 sock_sendmsg_nosec build/../net/socket.c:705 [inline]
 sock_sendmsg build/../net/socket.c:725 [inline]
 ____sys_sendmsg+0xe11/0x12c0 build/../net/socket.c:2413
 ___sys_sendmsg+0x4a7/0x530 build/../net/socket.c:2467
 __sys_sendmsg build/../net/socket.c:2496 [inline]
 __do_sys_sendmsg build/../net/socket.c:2505 [inline]
 __se_sys_sendmsg build/../net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0x3ef/0x570 build/../net/socket.c:2503
 do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 ```

4. When this message was received, pfkey_recvmsg calls skb_copy_datagram_msg to copy the data to a userspace buffer.
```
instrument_copy_to_user build/../include/linux/instrumented.h:121 [inline]
 copyout build/../lib/iov_iter.c:154 [inline]
 _copy_to_iter+0x65d/0x2510 build/../lib/iov_iter.c:668
 copy_to_iter build/../include/linux/uio.h:162 [inline]
 simple_copy_to_iter+0xf3/0x140 build/../net/core/datagram.c:519
 __skb_datagram_iter+0x2d5/0x11b0 build/../net/core/datagram.c:425
 skb_copy_datagram_iter+0xdc/0x270 build/../net/core/datagram.c:533
 skb_copy_datagram_msg build/../include/linux/skbuff.h:3696 [inline]
 pfkey_recvmsg+0x43e/0xb50 build/../net/key/af_key.c:3710
 ____sys_recvmsg+0x590/0xb00
 ___sys_recvmsg+0x37a/0xb70 build/../net/socket.c:2674
 do_recvmmsg+0x6b3/0x11a0 build/../net/socket.c:2768
 __sys_recvmmsg build/../net/socket.c:2847 [inline]
 __do_sys_recvmmsg build/../net/socket.c:2870 [inline]
 __se_sys_recvmmsg build/../net/socket.c:2863 [inline]
 __x64_sys_recvmmsg+0x2af/0x500 build/../net/socket.c:2863
 do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
```

5. The following is debug information:
Bytes 20-23 of 176 are uninitialized
Memory access of size 176 starts at ffff88815e686000
Data copied to user address 0000000020000300

 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index de24a7d474df..cf5433a2e31a 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1699,7 +1699,7 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 
 	xfrm_probe_algs();
 
-	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL);
+	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
-- 
2.32.0 (Apple Git-132)

