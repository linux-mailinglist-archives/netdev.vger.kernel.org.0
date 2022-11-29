Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCEE63CB1B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 23:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbiK2Wik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 17:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbiK2Wie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 17:38:34 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A67F303EF;
        Tue, 29 Nov 2022 14:38:32 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 43729C009; Tue, 29 Nov 2022 23:38:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669761519; bh=smCY981fzC9mZh3eGXAC3uy7nL+6sisKTqlh2Hjzenk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NUbKTNPnHK6tuuncFbF/XE8RjNTxugpELitcB2dWP/xV+80Om6B/65tFtkyOE7u/6
         OMoqAdmfOT2CQOQQWKuwaACVp+VnCzZbjqo0aNM91bIVBNcuwiY+AUpwh4ihRSx5cl
         iy6P2GcCVgYIQmAQhX+GxGiExdaDD8FLgRHPJeHb734LqxiTQ90l4j4giD6sk2AyqS
         jEtpMb3LIZPfxNXmsbU79OQ2mTYii5ADJ98qDMnDPfSUtMJjAJ5Mu0u0kTv3YIO0DO
         7MxIy0tuZQO56bag0lP6H9tY2Jvafo/sxNlHqmsqhWfUu12hYnTaIiWPII4hrJbblB
         0RiF9Q9xUdvBw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 5C02AC009;
        Tue, 29 Nov 2022 23:38:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669761517; bh=smCY981fzC9mZh3eGXAC3uy7nL+6sisKTqlh2Hjzenk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6y1a2ztn0ZfYgUgUhnaPxMyQ4t+6WLvNiP12gfRIcnLekJ1foIMsNs33nDA6tk/u
         vSJ/ANhh7xYim9/WGJXKIkWCeG5QGQLGXkCHITcthUgOFI/dncLQsxpiBSKPMxm82+
         r53aS5ryiXr40YUAH8nQn86eG8RGcsUcUaoRHkyylhPGhhuQ3oCA2OigGhaFdhD3w/
         wsaI+53uvgy4xp1HH2oJpVio/b2KhEQnVe065T/IAG6iYv4aFNko18JQivt2VXeMsj
         N8hHq0ifjh9u4ZjxfDvs4/AdZcwPfvrh2udRXnW1n/rU44yoTc4M1h75kLUUcSkdxT
         B50011CaxcV2w==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c0600905;
        Tue, 29 Nov 2022 22:38:21 +0000 (UTC)
Date:   Wed, 30 Nov 2022 07:38:06 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.co,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Message-ID: <Y4aJzjlkkt5VKy0G@codewreck.org>
References: <20221129162251.90790-1-schspa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221129162251.90790-1-schspa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schspa Shi wrote on Wed, Nov 30, 2022 at 12:22:51AM +0800:
> The transport layer of fs does not fully support the cancel request.
> When the request is in the REQ_STATUS_SENT state, p9_fd_cancelled
> will forcibly delete the request, and at this time p9_[read/write]_work
> may continue to use the request. Therefore, it causes UAF .
> 
> There is the logs from syzbot.
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
> complicated than this one, but the root cause seems to be the same.
> 
>      T21124               p9_write_work        p9 read_work
> ======================== first trans =================================
> p9_client_walk
>   p9_client_rpc
>     p9_client_prepare_req
>     /* req->refcount == 2 */
>     c->trans_mod->request(c, req);
>       p9_fd_request
>         req move to unsent_req_list
>                             req->status = REQ_STATUS_SENT;
>                             req move to req_list
>                             << send to server >>
>     wait_event_killable
>     << get kill signal >>
>     if (c->trans_mod->cancel(c, req))
>        p9_client_flush(c, req);
>          /* send flush request */
>          req = p9_client_rpc(c, P9_TFLUSH, "w", oldtag);
> 		 if (c->trans_mod->cancelled)
>             c->trans_mod->cancelled(c, oldreq);
>               /* old req was deleted from req_list */
>               /* req->refcount == 1 */
>   p9_req_put
>     /* req->refcount == 0 */
>     << preempted >>
>                                        << get response, UAF here >>
>                                        m->rreq = p9_tag_lookup(m->client, m->rc.tag);
>                                          /* req->refcount == 1 */
>                                        << do response >>
>                                        p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
>                                          /* req->refcount == 0 */
>                                          p9_fcall_fini
>                                          /* request have been freed */
>     p9_fcall_fini
>      /* double free */
>                                        p9_req_put(m->client, m->rreq);
>                                          /* req->refcount == 1 */
> 
> To fix it, we can wait the request with status REQ_STATUS_SENT returned.

Christian replied on this (we cannot wait) but I agree with him -- the
scenario you describe is proteced by p9_tag_lookup checking for refcount
with refcount_inc_not_zero (p9_req_try_get).

The normal scenarii for flush are as follow:
 - cancel before request is sent: no flush, just free
 - flush is ignored and reply comes first: we get reply from original
request then reply from flush
 - flush is handled and reply never comes: we only get reply from flush

Protocol-wise, we can safely reuse the tag after the flush reply got
received; and as far as I can follow the code we only ever free the tag
(last p9_call_fini) after flush has returned so the entry should be
protected.

If we receive a response on the given tag between cancelled and the main
thread going out the request has been marked as FLSHD and should be
ignored. . . here is one p9_req_put in p9_read_work() in this case but
it corresponds to the ref obtained by p9_tag_lookup() so it should be
valid.


I'm happy to believe we have a race somewhere (even if no sane server
would produce it), but right now I don't see it looking at the code.. :/

-- 
Dominique
