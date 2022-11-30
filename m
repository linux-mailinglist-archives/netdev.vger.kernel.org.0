Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396A263D6C6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiK3Nbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiK3NbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:31:21 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEF07E41E;
        Wed, 30 Nov 2022 05:30:55 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 9FA19C021; Wed, 30 Nov 2022 14:31:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669815062; bh=McQl9/8275k81zXr6HppS79olAPA/nA6rhvjCNribMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NveRl3148pWe7mbHIOQoj3IN9jJwgLDOz9jiPm1Eunl+47q7614C2lPICHFYRPmi5
         ChCNeWdCCJun/4tCnyO59YYsVpY0GhO2a/GZ88yIqmwat5o/nwc/wYPYp+ckeu00mh
         scTtL/CxOs+htISs8jg112bLskNs9vZEv9wPD6smWG7nAA/0Yb9SJkuuPQWZVFLs47
         RbBSKIsPUErFXe4OETKjmsHd7MNYRfjfqLMqSXSb6qPz4YVTdHp1pp0y72Gcjti1Yx
         bNgWUtdaN6JR5GgIBZFiNuwehzdeVCda5siKpv5LheFg+d74pZ8ySxnsiYER7PB8BI
         IpYg3ynyfvbZg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id A7341C009;
        Wed, 30 Nov 2022 14:30:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669815061; bh=McQl9/8275k81zXr6HppS79olAPA/nA6rhvjCNribMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0bwbthGDZ21rFnSYBzRhdxE9Od9C9dWe9ifrRzYQ9foOdrxseiZ5pEMBZoEyf1Sb
         7ViyIpPUTknGD1v6XD0ahsRtSMqmowLcwsxZOASTVDweRGSsHIpXh90tSjrznGeKZO
         QtPBVnEqg4t72fR1W5mAETIHPazpcoIF+v0UatsL58L6Bu374P8oaZOZAelMNE6sbY
         BNWRdWxf9OIbkGdskyJoZVEfss30rRkRSFboe7F0AZXxInT7H96nFBvg6HiJMvXYpd
         /PhoF1oSczAWnmiBX2Ir4WDUXzx+4DSNMEqtj/AxgtFtnYFdDJ2Xe13O7oZFmKYGhB
         z2zICBb1NCC6A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 17d0e89d;
        Wed, 30 Nov 2022 13:30:46 +0000 (UTC)
Date:   Wed, 30 Nov 2022 22:30:31 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] 9p/fd: set req refcount to zero to avoid
 uninitialized usage
Message-ID: <Y4da9/BHrEqgwq4q@codewreck.org>
References: <20221130130830.97199-1-schspa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221130130830.97199-1-schspa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schspa Shi wrote on Wed, Nov 30, 2022 at 09:08:31PM +0800:
> When the transport layer of fs cancels the request, it is deleted from the
> client side. But the server can send a response with the freed tag.
> 
> When the new request allocated, we add it to idr, and use the id form idr
> as tag, which will have the same tag with high probability. Then initialize
> the refcount after adding it to idr.

ultimately this bug has nothing to do with tag reuse -- we don't
actually need flush at all to trigger it.

- thread1 starts new request; idr initialized with tag X
- thread2 receives something for tag X, increments refcount before
refcount init
- thread1 resets refcount to two incorrectly

This could happen on any new message where the server voluntarily sends
a reply with tag X before the request has been sent; in a cyclic model
as suggested in the other thread it would be easy to guess just last+1
for an hypothetical attacker.

This scenario with flush is just how syzbot happened to trigger it, but
I think it's just superfluous to this commit message.

A few more nitpicks on wording below; happy to adjust things myself as I
apply patches but might as well comment first...

> If the p9_read_work got a response before the refcount initiated. It will
> use a uninitialized req, which will result in a bad request data struct.
> 
> There is the logs from syzbot.

English: Here is ...

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
> complicated than this one, but this patch seems can fix it.

English: seems to fix it?
(thanks for checking!)

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
>                             /* req->[refcount/tag] == uninitilzed */

typo: uninitialized

>                             m->rreq = p9_tag_lookup(m->client, m->rc.tag);

it's not obvious for someone reading this not familiar with 9p that
lookup will increment refcount

> 
>         refcount_set(&req->refcount, 2);
>                             << do response/error >>
>                             p9_req_put(m->client, m->rreq);
>                             /* req->refcount == 1 */
> 
>     /* req->refcount == 1 */
>     << got a bad refcount >>

it's not obvious from this going back to thread 1 with a refcount of 1
would be a bad refcount, either.
One possible scenario would be:

				/* increments uninitalized refcount */
                                req = p9_tag_lookup(tag)
    refcount_set(req->refcount, 2)
				/* cb drops one ref */
				p9_client_cb(req)
				/* reader thread drops its ref:
				   request is incorrectly freed */
				p9_req_put(req)
    /* use after free and ref underflow */
    p9_req_put(req)



> To fix it, we can initize the refcount to zero before add to idr.
> 
> Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
> 

There should be no empty line between the tags; tags are part of the
"trailer" and some tools handle it as such (like git interpret-trailers),
which would ignore that Reported-by as it is not part of the last block
of text.

> Signed-off-by: Schspa Shi <schspa@gmail.com>
> ---
>  net/9p/client.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index aaa37b07e30a..a72cb597a8ab 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -297,6 +297,10 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
>  	p9pdu_reset(&req->rc);
>  	req->t_err = 0;
>  	req->status = REQ_STATUS_ALLOC;
> +	/* p9_tag_lookup relies on this refcount to be zero to avoid
> +	 * getting a freed request.

A freed request would have 0 by definition, if it isn't zero then this
is a newly allocated uninit request, so this comment is incorrect.

How about:
	/* refcount needs to be set to 0 before inserting into the idr
	 * so p9_tag_lookup does not accept a request that is not fully
	 * initialized. refcount_set to 2 below will mark request live.
	 */

> +	 */
> +	refcount_set(&req->refcount, 0);
>  	init_waitqueue_head(&req->wq);
>  	INIT_LIST_HEAD(&req->req_list);
>  
