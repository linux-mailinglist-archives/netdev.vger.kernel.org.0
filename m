Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B71563944
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 20:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiGASlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 14:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGASlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 14:41:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31584275E8
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 11:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656700866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ny0Y+wantRT9K6KKNonJCT2118CDVSktd2PAk/r/oxY=;
        b=PrDU+mLooszVk1gsU67A3jl5FcLC3KPuISmXGQWy6+MFmvZB26wnFFDOfKBu9Vx5VyWqgM
        17hs9Q3YpSz4ZQmA7q29Ob99W5Se1BM6hf45denQgfIcnxutfKl9+EDQhjirY8NT3+m3K+
        yN5mI0H2oxE9XmTTH0BisO8jVxRIeZ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-91-gHsaVMkiRpev6G4KiFA-1; Fri, 01 Jul 2022 14:41:05 -0400
X-MC-Unique: 91-gHsaVMkiRpev6G4KiFA-1
Received: by mail-wm1-f71.google.com with SMTP id c185-20020a1c35c2000000b0039db3e56c39so3390341wma.5
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 11:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ny0Y+wantRT9K6KKNonJCT2118CDVSktd2PAk/r/oxY=;
        b=swdRPzZemFa1a+AUgPgeQqfMMMWttZcy7RTmU+kVBFEefyeOK1wk+CRE64fFqeNNb4
         Ym1oFNf6MHGgfPXHFjCSo5S8UuD9gkBP/LVrjGK110j7lxkXEXptz3J6Y+5oTWURb2CX
         PsgG9NVT3DIL2N7R3IqAWPfOKzo/yRTAlb3ZILvaJt2b+ihNV8Awlzi7ToniFowo9CQo
         pwjWh0dfZ7h2Aq1yo+2Bq9UWJnTq5PVS66qg4uzXdy1izUCCO8bNoSJzv+4eFdB4+LjQ
         fmHEXR/xDWUT1ypxOyWteDs0HOwn3dk9CbP8WeumQCf6vWY/nkUab42Z11t18b90kcZg
         v31Q==
X-Gm-Message-State: AJIora9BIWm3ayyh2j2Nn8c/1vuWtQq+4Ui7zauytktaMcqLm8MoeqXB
        CsrcoQ5WjAiGu3DKb5G4O0oWDrmxBVi90TDTnDN5Q1Ipf3UKGtAUrK3IUBtGte/W3nQbO9GT894
        VclxnLtW+4pg/y1pK
X-Received: by 2002:a5d:584d:0:b0:21b:a3a2:d67c with SMTP id i13-20020a5d584d000000b0021ba3a2d67cmr14261052wrf.149.1656700863782;
        Fri, 01 Jul 2022 11:41:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfUxz8KWIKkRtUVWlhIWneYKTe2Baex8e5CL7AFbX/PVA6Oj/m9SEWl23ZLYUOa3lMKN3RVw==
X-Received: by 2002:a5d:584d:0:b0:21b:a3a2:d67c with SMTP id i13-20020a5d584d000000b0021ba3a2d67cmr14261040wrf.149.1656700863553;
        Fri, 01 Jul 2022 11:41:03 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id u3-20020a05600c210300b003a044fe7fe7sm11026001wml.9.2022.07.01.11.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 11:41:03 -0700 (PDT)
Date:   Fri, 1 Jul 2022 20:41:00 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steve French <sfrench@samba.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Scott Mayhew <smayhew@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC net] Should sk_page_frag() also look at the current GFP context?
Message-ID: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm investigating a kernel oops that looks similar to
20eb4f29b602 ("net: fix sk_page_frag() recursion from memory reclaim")
and dacb5d8875cc ("tcp: fix page frag corruption on page fault").

This time the problem happens on an NFS client, while the previous bzs
respectively used NBD and CIFS. While NBD and CIFS clear __GFP_FS in
their socket's ->sk_allocation field (using GFP_NOIO or GFP_NOFS), NFS
leaves sk_allocation to its default value since commit a1231fda7e94
("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs").

To recap the original problems, in commit 20eb4f29b602 and dacb5d8875cc,
memory reclaim happened while executing tcp_sendmsg_locked(). The code
path entered tcp_sendmsg_locked() recursively as pages to be reclaimed
were backed by files on the network. The problem was that both the
outer and the inner tcp_sendmsg_locked() calls used current->task_frag,
thus leaving it in an inconsistent state. The fix was to use the
socket's ->sk_frag instead for the file system socket, so that the
inner and outer calls wouln't step on each other's toes.

But now that NFS doesn't modify ->sk_allocation anymore, sk_page_frag()
sees sunrpc sockets as plain TCP ones and returns ->task_frag in the
inner tcp_sendmsg_locked() call.

Also it looks like the trend is to avoid GFS_NOFS and GFP_NOIO and use
memalloc_no{fs,io}_save() instead. So maybe other network file systems
will also stop setting ->sk_allocation in the future and we should
teach sk_page_frag() to look at the current GFP flags. Or should we
stick to ->sk_allocation and make NFS drop __GFP_FS again?

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/sock.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 72ca97ccb460..b934c9851058 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -46,6 +46,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>	/* struct sk_buff */
 #include <linux/mm.h>
+#include <linux/sched/mm.h>
 #include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -2503,14 +2504,17 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * socket operations and end up recursing into sk_page_frag()
  * while it's already in use: explicitly avoid task page_frag
  * usage if the caller is potentially doing any of them.
- * This assumes that page fault handlers use the GFP_NOFS flags.
+ * This assumes that page fault handlers use the GFP_NOFS flags
+ * or run under memalloc_nofs_save() protection.
  *
  * Return: a per task page_frag if context allows that,
  * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+	gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);
+
+	if ((gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
 	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
 		return &current->task_frag;
 
-- 
2.21.3

