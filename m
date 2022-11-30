Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE7B63D648
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiK3NJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiK3NJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:09:20 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23556C709;
        Wed, 30 Nov 2022 05:09:18 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id q1so15968437pgl.11;
        Wed, 30 Nov 2022 05:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h6U6pKxwnhQVoSAmRgs97bjo6brEZhCoz3DBdXGke2Q=;
        b=KmxDmulFwNTac6Q+zCbGcDrpFOdQrVDF8PNUNp+WReBqzsGE1xVM9k5ojobtdP00tO
         KnOSxiePV1PqkXSfHda2d9VJQrj+psLYTcMvGIjhs4xLm9J2MksN6/B0j7sPGTO9MYBj
         8kf/JUN19+BQA7EB/P0v4cEtzp4eBJNekp418K1wWp9DCQkrXDaMp3f526s3JC0Q8/YO
         eph9WwVU3dD0NUMd8gC5CrMkgAOLvX+uasbw9N3Wm+IQbCtH5nsLPg1isgf4XMSJI2fK
         hOTwqGDFOQgvL7PiVRabtxPVg+xM9oQVe1JNSSQ4bT/hShfTye/B48FSkCJioSm7Xuib
         QVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6U6pKxwnhQVoSAmRgs97bjo6brEZhCoz3DBdXGke2Q=;
        b=1B0wcpO7CktBfGUI/2LKmYgoMeKlQXeuZ9N2ldw8mYb4eJC6n47fiz7W7abcu/6rjw
         /VMHC6JF6g7wH0tDGiUTYDSyaxfGrH80SMxUSlIUBK9F3Z/akXnuG3E7tO3cy/o6FiV7
         GaFb0/Ycb7I/Akr6QY4G6qVLKCwTpV2A7Qjs1elLqXnhxUV2RwHO4ah/ogSSmCZ1Bhos
         PwFPWvJ7za2sJzKZllyZALilyzcGFSeNYfT69SL1mgCs4r4xLb9kHcnt2/a7UQgiiA22
         blp9njdbZ2mzrkSqlIqCZXZ7DuVoirXpRumYzeky6HXixmfkFL4t9libBzrQGmnpVYu4
         pJxw==
X-Gm-Message-State: ANoB5pkngEPFnviPeV1ei7xKRua7OdkqPGzIyzI9HmNkn5JgXS59gs/s
        P5rxAT44qEqn8A7bcmR6KdE=
X-Google-Smtp-Source: AA0mqf7jil2oLqYE/pjfkA2t4sBYT+buNYBPj+vXowPApj2brdy8weMJGlARFcMZbKJeDEfjT22AHw==
X-Received: by 2002:a65:6c11:0:b0:477:2bc0:f1b with SMTP id y17-20020a656c11000000b004772bc00f1bmr35640254pgu.566.1669813758143;
        Wed, 30 Nov 2022 05:09:18 -0800 (PST)
Received: from MBP.lan (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id w81-20020a627b54000000b0057255b7c8easm1372539pfc.33.2022.11.30.05.09.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Nov 2022 05:09:17 -0800 (PST)
From:   Schspa Shi <schspa@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: [PATCH v2] 9p/fd: set req refcount to zero to avoid uninitialized usage
Date:   Wed, 30 Nov 2022 21:08:31 +0800
Message-Id: <20221130130830.97199-1-schspa@gmail.com>
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

When the transport layer of fs cancels the request, it is deleted from the
client side. But the server can send a response with the freed tag.

When the new request allocated, we add it to idr, and use the id form idr
as tag, which will have the same tag with high probability. Then initialize
the refcount after adding it to idr.

If the p9_read_work got a response before the refcount initiated. It will
use a uninitialized req, which will result in a bad request data struct.

There is the logs from syzbot.

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
complicated than this one, but this patch seems can fix it.

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
                            /* req->[refcount/tag] == uninitilzed */
                            m->rreq = p9_tag_lookup(m->client, m->rc.tag);

        refcount_set(&req->refcount, 2);
                            << do response/error >>
                            p9_req_put(m->client, m->rreq);
                            /* req->refcount == 1 */

    /* req->refcount == 1 */
    << got a bad refcount >>

To fix it, we can initize the refcount to zero before add to idr.

Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com

Signed-off-by: Schspa Shi <schspa@gmail.com>
---
 net/9p/client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index aaa37b07e30a..a72cb597a8ab 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -297,6 +297,10 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
 	p9pdu_reset(&req->rc);
 	req->t_err = 0;
 	req->status = REQ_STATUS_ALLOC;
+	/* p9_tag_lookup relies on this refcount to be zero to avoid
+	 * getting a freed request.
+	 */
+	refcount_set(&req->refcount, 0);
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
 
-- 
2.37.3

