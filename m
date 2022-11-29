Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7463C521
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiK2Q3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiK2Q3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:29:21 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633325A6EE;
        Tue, 29 Nov 2022 08:29:20 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 62so13480041pgb.13;
        Tue, 29 Nov 2022 08:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=/aHkCAvWSlfVNQy6gn6rO0SIwdJOfVhXGcTEpE1CmRs=;
        b=f4QQZKavw6a3OHJlt3qj7eVnStNlKbdAE5bgKx8kki7yJJeEC6NEWHIJfxZjOlxU6+
         lL66FRtCSrH5xPTcjkTomsb8rBGIgyX5LDyW1vq8LkZDc8XFft58On1XDRb4p711mF8z
         CiUeaLCDMRHebdo+m8bnS4/AlbQdkDJ1u2WDIMhaRo7O0ZSQmTkziBz40REyfuxwsb4N
         j5dlUU12obpEKotOvivhPOYR27g1wXqGaz+kctlpz6/ydR1v099om8YSdUBlX6qgrF85
         3HRmgsX9MjPsDtSrlUOjA7LN+8lHPeYCXB4+uQV2jfXUnHFhOyBJVWtrKUeJ+pJhqJyT
         5m5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/aHkCAvWSlfVNQy6gn6rO0SIwdJOfVhXGcTEpE1CmRs=;
        b=YjlOGfzgC6oOanPBPVetVHKfeyK6IgpEKULY0+EWfWHApyFP1cKmOUygMLTgkaZJ+b
         Y6D3iSLNTXPyulKEfWk3unw+NzLMfkYBba9t+Jw/HG+9fpZWrhK2m8JqJ4yVisOPL0xs
         wPhjK5SyALdGJHQcgSKA3IuikJ8hf1wjeuXo2MeV+FPlVXZplaFha3TT4lBIHSaExTRf
         ZTSpmcnJtf2kDsbErhcbhoNXuNRlLhC1x+jof5jaE1A/LGahDE6A2faEbpVgVr6hkvQc
         Iek3Jd5Uv64iMv8S9qVcpDScwqnPmwkngcVdrGGLG2h6lBZ7w3r93YLuKK/LqwR/xVe1
         TgEg==
X-Gm-Message-State: ANoB5pk5D9Gawd1ctROC+5A7nTLLogyHS7kXtWxnbN46j1fef78S3LFh
        h22dt/yXKmokxp940cUJYDI=
X-Google-Smtp-Source: AA0mqf7Ym5QGYFPcPvY4P2Rl6fUTm6E1F3He27JySEBXcYhPXABl5lmQuOwpp4GZI2P1D3Qb9v7IiQ==
X-Received: by 2002:a63:7987:0:b0:477:bf2e:ec58 with SMTP id u129-20020a637987000000b00477bf2eec58mr26097167pgc.269.1669739359832;
        Tue, 29 Nov 2022 08:29:19 -0800 (PST)
Received: from MBP (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id b28-20020a630c1c000000b0045dc85c4a5fsm8646778pgl.44.2022.11.29.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 08:29:19 -0800 (PST)
References: <20221129162251.90790-1-schspa@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Schspa Shi <schspa@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Wed, 30 Nov 2022 00:26:46 +0800
In-reply-to: <20221129162251.90790-1-schspa@gmail.com>
Message-ID: <m2r0xlu3l9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Schspa Shi <schspa@gmail.com> writes:

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
>
> Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
>
> Signed-off-by: Schspa Shi <schspa@gmail.com>
> ---
>  net/9p/client.c   |  2 +-
>  net/9p/trans_fd.c | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/net/9p/client.c b/net/9p/client.c
> index aaa37b07e30a..963cf91aa0d5 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -440,7 +440,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
>  	smp_wmb();
>  	req->status = status;
>  
> -	wake_up(&req->wq);
> +	wake_up_all(&req->wq);
>  	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc.tag);
>  	p9_req_put(c, req);
>  }
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index eeea0a6a75b6..ee2d6b231af1 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -30,6 +30,7 @@
>  #include <net/9p/transport.h>
>  
>  #include <linux/syscalls.h> /* killme */
> +#include <linux/wait.h>
>  
>  #define P9_PORT 564
>  #define MAX_SOCK_BUF (1024*1024)
> @@ -728,6 +729,17 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
>  		return 0;
>  	}
>  
> +	/* If the request is been sent to the server, we need to wait for the
> +	 * job to finish.
> +	 */
> +	if (req->status == REQ_STATUS_SENT) {
> +		spin_unlock(&m->req_lock);
> +		p9_debug(P9_DEBUG_TRANS, "client %p req %p wait done\n",
> +			 client, req);
> +		wait_event(req->wq, req->status >= REQ_STATUS_RCVD);
> +
> +		return 0;
> +	}
>  	/* we haven't received a response for oldreq,
>  	 * remove it from the list.
>  	 */

Add Christian Schoenebeck for bad mail address typo.

-- 
BRs
Schspa Shi
