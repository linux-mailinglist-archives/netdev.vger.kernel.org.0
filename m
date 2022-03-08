Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638444D0E44
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 04:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbiCHDWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 22:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiCHDWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 22:22:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89DF22511
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 19:21:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z16so16191474pfh.3
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 19:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z8KQ0trJ2nL2n7GZvke9YIwg/FxCqEjqhIni6kQIDYI=;
        b=kTd/+yn56cdC1TeBDyEn7pI+7d5Sl2qx8WC61OjKK+pg/D4TsnKlndsG02+WcWsgKd
         6D7J6whxlVFPMkSBbopcWGH3ZlIA1aejtUUMz90AFwu1jV54pR7H/RqCpYHimLtU6GaE
         PPol90AYqswheWvI4EcvCZbYEz/NUNnS6s402jnTeuoLQ0vtN8sGoYuNg/79a+8tTvro
         Mcix8WxX140yh45lbjZdWnWaJCDWv+O1DeAAlHXwsDdl110YmofbTjhcYynJYX/6eVq3
         Svff9Ht63/VnRJ9nTkd5LlfK6m0RO2NbWDh0QjENo+NUS3aj8/9EnRPgTCZAGv5qUg/U
         YQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z8KQ0trJ2nL2n7GZvke9YIwg/FxCqEjqhIni6kQIDYI=;
        b=lolW3VIoXWzR66jPtw5/RplPwmh2MgMFR35Ao+zIDqBS83X2KuGOfhM6DBZNcXvALN
         rxBsCwKxS/pAl//aWVI9VpykrwDOggXO01xi8qAIQUvqPyPjnH/XyP/nXPG8FNU/yeu2
         9zjcRDAMcUZuxixIE2QEx2bz/VX6/3lr3CbhXczxIN2UZrhCWVNEKc39OnHDEQ5x9ydy
         UKaKkDZXmiYX0ay/fQPXQvRcPNc+/2xEjnGetcBfkqX3bdUlr/3UdN90/hkMxJufBv8n
         8opfAlZZCeZatRuwzWJM/g3jbf6XJ8F3mTlR3ToNbLJBYEcZnobzbHb0qxws4YTbQCjw
         rEjw==
X-Gm-Message-State: AOAM530bka8MR/cP76nEWqX6oebXPq8x7WeGq6o02qgY4JMbgmw2KFc2
        6RQ5/RgQLTfr4OBWkJXWGFQYdvkA5h4=
X-Google-Smtp-Source: ABdhPJzJO7Oupc9vMeJuD6G52tnvTHYHuRC3rBAuF62pv6b2uLOa/uj6aH6h5o1sMGnkgdI2eD602Q==
X-Received: by 2002:a65:4845:0:b0:325:c147:146d with SMTP id i5-20020a654845000000b00325c147146dmr12623332pgs.140.1646709696375;
        Mon, 07 Mar 2022 19:21:36 -0800 (PST)
Received: from ELIJAHBAI-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id a133-20020a621a8b000000b004f6a79008ddsm15231573pfa.45.2022.03.07.19.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 19:21:36 -0800 (PST)
From:   Haimin Zhang <tcs.kernel@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>
Subject: [PATCH v2] af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
Date:   Tue,  8 Mar 2022 11:20:28 +0800
Message-Id: <20220308032028.48779-1-tcs.kernel@gmail.com>
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
to initialize the buffer of supp_skb to fix a kernel-info-leak issue.
1) Function pfkey_register calls compose_sadb_supported to request 
a sk_buff. 2) compose_sadb_supported calls alloc_sbk to allocate
a sk_buff, but it doesn't zero it. 3) If auth_len is greater 0, then
compose_sadb_supported treats the memory as a struct sadb_supported and
begins to initialize. But it just initializes the field sadb_supported_len
and field sadb_supported_exttype without field sadb_supported_reserved.

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

