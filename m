Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A06624294
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiKJMwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKJMwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:52:06 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F2D6DCCE
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:52:04 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E4BB8C009; Thu, 10 Nov 2022 13:52:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668084725; bh=uE7Ck4EtYBz/wcXrSLHMyRkTqmg+wCFbqyStElQkJpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DOBidv1zZjavZ1xKt/CqcraiR/oFwo4hY5x8bCXq1CYnjL695unPSsvabIF491znP
         /uS6noFHqfTs5oyESAgQ6fF4/ukY5k8WfB2r0NCiUwvmqiL7oKJ2auEJrjIDDU4NdZ
         h5/tyLSBSsao4Gh0pKw0s0E2yl479QMsHjWqo4atHhaYqsEND9LoXG49f7oDUBjwQi
         Apd11Ex+NdNxC9KXPSEGy7LuVUKdTQI4urHQs5LB3dztIym9/NSFg5QT3ukv742V27
         K6/UsSM8JoJwaItBxnTahYBVMg2bUeZtkkcKW7KOz2lp2IDnPXfDOc69vgRzqXzaQc
         LmjltUUQM7m6A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 57AFDC009;
        Thu, 10 Nov 2022 13:52:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668084724; bh=uE7Ck4EtYBz/wcXrSLHMyRkTqmg+wCFbqyStElQkJpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iij8LtkZUcZ4zL35dEe3fl1s5cnDEkkSGg0U1oTfEuizmq8QWcj+w5pyXchNi3ZdZ
         xNxCtTriu8go6xqmeQICH9/fL3eYzZBtT5RBzZi9Gb+ULne6RleotS+Sfao2B4YdjA
         L+32mToJPJEtL9KWD9PL+HVcdUhOGcKp/FPb3SlYtVousP0+oAfgMz+bP0BmLkCawm
         69xXnxt1LSUZJdl7TwZGXdsfbR3jJPYdV0dwV75vIm4GjAocHTlVBqr1EA9zrBkIPE
         HTj8nktxsnUV7gSvAlg5FrdW6BHndJ2SIMHESfkvOighn5AnLrfL+9sY1DOpA6yviE
         9JTBEfskUhl0g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id aa0808b5;
        Thu, 10 Nov 2022 12:51:54 +0000 (UTC)
Date:   Thu, 10 Nov 2022 21:51:39 +0900
From:   asmadeus@codewreck.org
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] net/9p: fix issue of list_del corruption in
 p9_fd_cancel()
Message-ID: <Y2zz24jRIo9DdWw7@codewreck.org>
References: <20221110122606.383352-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221110122606.383352-1-shaozhengchao@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao wrote on Thu, Nov 10, 2022 at 08:26:06PM +0800:
> Syz reported the following issue:
> kernel BUG at lib/list_debug.c:53!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> RIP: 0010:__list_del_entry_valid.cold+0x5c/0x72
> Call Trace:
> <TASK>
> p9_fd_cancel+0xb1/0x270
> p9_client_rpc+0x8ea/0xba0
> p9_client_create+0x9c0/0xed0
> v9fs_session_init+0x1e0/0x1620
> v9fs_mount+0xba/0xb80
> legacy_get_tree+0x103/0x200
> vfs_get_tree+0x89/0x2d0
> path_mount+0x4c0/0x1ac0
> __x64_sys_mount+0x33b/0x430
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> </TASK>
> 
> The process is as follows:
> Thread A:                       Thread B:
> p9_poll_workfn()                p9_client_create()
> ...                                 ...
>     p9_conn_cancel()                p9_fd_cancel()
>         list_del()                      ...
>         ...                             list_del()  //list_del
>                                                       corruption
> There is no lock protection when deleting list in p9_conn_cancel(). After
> deleting list in Thread A, thread B will delete the same list again. It
> will cause issue of list_del corruption.

Thanks!

I'd add a couple of lines here describing the actual fix.
Something like this?
---
Setting req->status to REQ_STATUS_ERROR under lock prevents other
cleanup paths from trying to manipulate req_list.
The other thread can safely check req->status because it still holds a
reference to req at this point.
---

With that out of the way, it's a good idea; I didn't remember that
p9_fd_cancel (and cancelled) check for req status before acting on it.
This really feels like whack-a-mole, but I'd say this is one step
better.

Please tell me if you want to send a v2 with your words, or I'll just
pick this up with my suggestion and submit to Linus in a week-ish after
testing. No point in waiting a full cycle for this.


> Fixes: 52f1c45dde91 ("9p: trans_fd/p9_conn_cancel: drop client lock earlier")
> Reported-by: syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: set req status when removing list

(I don't recall seeing a v1?)

> ---
>  net/9p/trans_fd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index 56a186768750..bd28e63d7666 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -202,9 +202,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
>  
>  	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
>  		list_move(&req->req_list, &cancel_list);
> +		req->status = REQ_STATUS_ERROR;
>  	}
>  	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
>  		list_move(&req->req_list, &cancel_list);
> +		req->status = REQ_STATUS_ERROR;
>  	}
>  
>  	spin_unlock(&m->req_lock);

--
Dominique
