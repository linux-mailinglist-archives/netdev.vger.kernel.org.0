Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B8963E85B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiLADdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLADda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:33:30 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A8E9134D;
        Wed, 30 Nov 2022 19:33:29 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r7so652746pfl.11;
        Wed, 30 Nov 2022 19:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9A6IXbc5qL2YaA9Z5Jlm1Xw7WJGjlGvWyIB5OHQsAis=;
        b=YIECMwftpYRiyM1xMWlkbV/0XnyVqrVgBfkT5g1BeEZlHp8wN9/9HGSzQLE9FuJ+cZ
         ItBVplaAUKprUcagA+AcN0wciBHfQk1CI4pBt6YLXN4LpwNxhhlyMm3i9yl3uLuvcmCN
         oaYhWXwnsW+jUZljq8jck4Pf2dXbuiLlQFmlHWwls9pOMS06jFib71hWCe6EfeX1v/DW
         FU2ekH3KVmQyfXu+YYib15vS0stKUJ4Fode/ka8bi200oJLPH0OACQMfWc+lfMsOK/7N
         v3J1x/75CgucbTv8JDPKk+dCioYmF8E6SPPEYoL+5MLF7Ao9sr/CcSRIqD1zPpQ36GBI
         TGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9A6IXbc5qL2YaA9Z5Jlm1Xw7WJGjlGvWyIB5OHQsAis=;
        b=Ty1xu9IWaB07uFBYzdCpE77E4pLe1bfyeJbk7SL6ujgFdKytva4HnWO0km15dW9zYW
         5L8tbLLI4JnRYmRvYzYBCIObFr3sTysdaKCiouCcSvZPGFlSTJYgx0ELmAhYLtX8CX7L
         yO+b/3j6g/DA3oBPbcrHR2Sz8+YEFH1OJ36xLYORRPTUV3URLTHuuegmzVMhvftOkNhq
         H7Pd1Tf0ZOgDgWz38MKTS+S67MuOEXxrJ8mdvSVi0k2t+IPqd6vaXPL0uyNN1QP2Yb+G
         Riw1sgGmNmMI0Ol1VstWGITgW3GGs0wX97ihAkjIK3WhOQvZcswd71yzB0PHsRpJwkoU
         4ZnA==
X-Gm-Message-State: ANoB5plzs1iRCgV+vEqZhmiisU6LfMWHyd1L7fzqgvTkvUmXWjOsu/sf
        yVVbicSj6yfu2hDWhlFD0FY=
X-Google-Smtp-Source: AA0mqf4nZdsomMfIQEh7EGH92ODcn4wu9r0Fvi783ledPNVijBn3X5dzfMhdPiv18Im2BFYYXif1ww==
X-Received: by 2002:a62:6d46:0:b0:563:54fd:3638 with SMTP id i67-20020a626d46000000b0056354fd3638mr66244570pfc.44.1669865608982;
        Wed, 30 Nov 2022 19:33:28 -0800 (PST)
Received: from MBP.lan (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902714400b0017f756563bcsm2279577plm.47.2022.11.30.19.33.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Nov 2022 19:33:28 -0800 (PST)
From:   Schspa Shi <schspa@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: [PATCH v3] 9p/fd: set req refcount to zero to avoid uninitialized usage
Date:   Thu,  1 Dec 2022 11:33:10 +0800
Message-Id: <20221201033310.18589-1-schspa@gmail.com>
X-Mailer: git-send-email 2.37.3
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

When the new request allocated, the refcount will be zero if it is resued
one. But if the request is newly allocated from slab, it is not fully
initialized before add it to idr.

If the p9_read_work got a response before the refcount initiated. It will
use a uninitialized req, which will result in a bad request data struct.

Here is the logs from syzbot.

Corrupted memory at 0xffff88807eade00b [ 0xff 0x07 0x00 0x00 0x00 0x00
0x00 0x00 . . . . . . . . ] (in kfence-#110):
 p9_fcall_fini net/9p/client.c:248 [inline]
 p9_req_put net/9p/client.c:396 [inline]
 p9_req_put+0x208/0x250 net/9p/client.c:390
 p9_client_walk+0x247/0x540 net/9p/client.c:1165
 clone_fid fs/9p/fid.h:21 [inline]
 v9fs_fid_xattr_set+0xe4/0x2b0 fs/9p/xattr.c:118
 v9fs_xattr_set fs/9p/xattr.c:100 [inline]
 v9fs_xattr_handler_set+0x6f/0x120 fs/9p/xattr.c:159
 __vfs_setxattr+0x119/0x180 fs/xattr.c:182
 __vfs_setxattr_noperm+0x129/0x5f0 fs/xattr.c:216
 __vfs_setxattr_locked+0x1d3/0x260 fs/xattr.c:277
 vfs_setxattr+0x143/0x340 fs/xattr.c:309
 setxattr+0x146/0x160 fs/xattr.c:617
 path_setxattr+0x197/0x1c0 fs/xattr.c:636
 __do_sys_setxattr fs/xattr.c:652 [inline]
 __se_sys_setxattr fs/xattr.c:648 [inline]
 __ia32_sys_setxattr+0xc0/0x160 fs/xattr.c:648
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

Below is a similar scenario, the scenario in the syzbot log looks more
complicated than this one, but this patch can fix it.

     T21124                   p9_read_work
======================== second trans =================================
p9_client_walk
  p9_client_rpc
    p9_client_prepare_req
      p9_tag_alloc
        req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
        tag = idr_alloc
        << preempted >>
        req->tc.tag = tag;
                            /* req->[refcount/tag] == uninitialized */
                            m->rreq = p9_tag_lookup(m->client, m->rc.tag);
                              /* increments uninitalized refcount */

        refcount_set(&req->refcount, 2);
                            /* cb drops one ref */
                            p9_client_cb(req)
                            /* reader thread drops its ref:
                               request is incorrectly freed */
                            p9_req_put(req)
    /* use after free and ref underflow */
    p9_req_put(req)

To fix it, we can initize the refcount to zero before add to idr.

Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Signed-off-by: Schspa Shi <schspa@gmail.com>

--

Changelog:
v1 -> v2:
        - Set refcount to fix the problem.
v2 -> v3:
        - Comment messages improve as asmadeus suggested.
---
 net/9p/client.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index aaa37b07e30a..ec74cd29d3bc 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -297,6 +297,11 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
 	p9pdu_reset(&req->rc);
 	req->t_err = 0;
 	req->status = REQ_STATUS_ALLOC;
+	/* refcount needs to be set to 0 before inserting into the idr
+	 * so p9_tag_lookup does not accept a request that is not fully
+	 * initialized. refcount_set to 2 below will mark request live.
+	 */
+	refcount_set(&req->refcount, 0);
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
 
-- 
2.37.3

