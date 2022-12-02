Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433B26408D3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiLBO5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiLBO5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:57:38 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA865E2FE0;
        Fri,  2 Dec 2022 06:57:30 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D554BC022; Fri,  2 Dec 2022 15:57:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669993057; bh=Y3uCyu9VbobJOLb5bg2S4QnzxL/lvHbfdA0L+IHesDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=bKexPzcAkwuHO3UyGyYVEs2AiHJzTvYQcT53TXWB4efz4Lida+bMsi0rv/MoInWFT
         1HRW/5l9hzS6MOAGa+kvh+c4gQeYXfWK+HJ5bLcNR+IC5GH92qUxN/9MFgFFRfoAca
         7QRBU691Kq0kNi8qgXJSNrPaLEhvfRY+mAyz77tWgDNrOn66nl7mLXkpxD1mcwYQM8
         ZO7znXG9+bgJ+1NAuTPJZcQJfwO6WuiZWUePYIJy1SykOZwOUaXnII7CFHmtwT0vWu
         WkiB4eSeHbB3e7/GcMAF70eEekwqHX56nXydBXPdK8qgcy7aM7sH6Afk4T/jcEFztt
         QxsADHsH/TS0w==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0669FC009;
        Fri,  2 Dec 2022 15:57:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669993056; bh=Y3uCyu9VbobJOLb5bg2S4QnzxL/lvHbfdA0L+IHesDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ZyelE6CvfHFzERG+lJE9Wsi2BF1WxMQ8j3iiztQPGvdqrE9Mu4llP6SLZlCUe7GSK
         sgp6/9sDJusoYqM2vf6QtkJdowPbBmZAbXg5+cGXClMXLeeTPJJYqhltO05POeoV5S
         RE753b2HJ66P1gX+XqXC9B94pnCGXC4zgpGLj1UjBtSPmDlBvinY874J4Yxsd3ngNr
         cFgQv5/RM8VhbQ95qJedEXED+cX8oMcrIyk54cRcSZJSupoaOMgt5Fbqe7xhPbV7Oo
         Pyqz46PDzstaexC1mTqWsWcHZ616yo2+2Vx2PGAxyAFEI76ePE6GT8d6lgqLP2Ljoa
         xcfROEf/peAVw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b911dc5e;
        Fri, 2 Dec 2022 14:57:20 +0000 (UTC)
Date:   Fri, 2 Dec 2022 23:57:05 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] 9p/fd: set req refcount to zero to avoid
 uninitialized usage
Message-ID: <Y4oSQU4taHVQ0n2j@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4759293.MmlG3nAkEO@silver>
 <20221201033310.18589-1-schspa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schspa Shi wrote on Thu, Dec 01, 2022 at 11:33:10AM +0800:
> When the new request allocated, the refcount will be zero if it is resued
> one. But if the request is newly allocated from slab, it is not fully
> initialized before add it to idr.
> 
> If the p9_read_work got a response before the refcount initiated. It will
> use a uninitialized req, which will result in a bad request data struct.
> 
> Here is the logs from syzbot.
> 
> Corrupted memory at 0xffff88807eade00b [ 0xff 0x07 0x00 0x00 0x00 0x00
> 0x00 0x00 . . . . . . . . ] (in kfence-#110):
>  p9_fcall_fini net/9p/client.c:248 [inline]
>  p9_req_put net/9p/client.c:396 [inline]
>  p9_req_put+0x208/0x250 net/9p/client.c:390
>  p9_client_walk+0x247/0x540 net/9p/client.c:1165
>  clone_fid fs/9p/fid.h:21 [inline]
>  v9fs_fid_xattr_set+0xe4/0x2b0 fs/9p/xattr.c:118
>  v9fs_xattr_set fs/9p/xattr.c:100 [inline]
>  v9fs_xattr_handler_set+0x6f/0x120 fs/9p/xattr.c:159
>  __vfs_setxattr+0x119/0x180 fs/xattr.c:182
>  __vfs_setxattr_noperm+0x129/0x5f0 fs/xattr.c:216
>  __vfs_setxattr_locked+0x1d3/0x260 fs/xattr.c:277
>  vfs_setxattr+0x143/0x340 fs/xattr.c:309
>  setxattr+0x146/0x160 fs/xattr.c:617
>  path_setxattr+0x197/0x1c0 fs/xattr.c:636
>  __do_sys_setxattr fs/xattr.c:652 [inline]
>  __se_sys_setxattr fs/xattr.c:648 [inline]
>  __ia32_sys_setxattr+0xc0/0x160 fs/xattr.c:648
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> 
> Below is a similar scenario, the scenario in the syzbot log looks more
> complicated than this one, but this patch can fix it.
> 
>      T21124                   p9_read_work
> ======================== second trans =================================
> p9_client_walk
>   p9_client_rpc
>     p9_client_prepare_req
>       p9_tag_alloc
>         req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
>         tag = idr_alloc
>         << preempted >>
>         req->tc.tag = tag;
>                             /* req->[refcount/tag] == uninitialized */
>                             m->rreq = p9_tag_lookup(m->client, m->rc.tag);
>                               /* increments uninitalized refcount */
> 
>         refcount_set(&req->refcount, 2);
>                             /* cb drops one ref */
>                             p9_client_cb(req)
>                             /* reader thread drops its ref:
>                                request is incorrectly freed */
>                             p9_req_put(req)
>     /* use after free and ref underflow */
>     p9_req_put(req)
> 
> To fix it, we can initize the refcount to zero before add to idr.

(fixed initialize typo here)

> Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
> Signed-off-by: Schspa Shi <schspa@gmail.com>
> 
> --
> 
> Changelog:
> v1 -> v2:
>         - Set refcount to fix the problem.
> v2 -> v3:
>         - Comment messages improve as asmadeus suggested.

Just a note: when applying a patch with git am, this goes into the
commit message -- please include the changelog below the git's three
dashes instead (anything between the three dashes and the 'diff --git'
below:
> ---
>  net/9p/client.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c


Christian Schoenebeck wrote on Fri, Dec 02, 2022 at 12:48:39PM +0100:
> > +	/* refcount needs to be set to 0 before inserting into the idr
> > +	 * so p9_tag_lookup does not accept a request that is not fully
> > +	 * initialized. refcount_set to 2 below will mark request live.
> > +	 */
> > +	refcount_set(&req->refcount, 0);
> 
> I would s/live/ready for being used/, but comment should be clear enough
> anyway.

I blame golfing to fit into three lines, sorry!
Since it was my suggestion, I've taken the liberty to change 'live' to
'ready' as an half step; I think it's clearer than live and probably
understandable enough.

I've pushed this to my next branch and will submit to Linus for the
merge window in a couple of weeks, no point in rushing this to stable
unless it gets snatched through the net tree first...

-- 
Dominique
