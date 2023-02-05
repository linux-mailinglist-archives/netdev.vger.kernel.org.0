Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3E668AF30
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 11:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBEKDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 05:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBEKDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 05:03:24 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810C91423B
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 02:03:17 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 872F0C01C; Sun,  5 Feb 2023 11:03:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1675591414; bh=yuBTnTNo7td/toyaaBlUDQQOiPPlqNou5TGqDBMKb+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=29/jIVCauEBrB0tb6xpkmNzJJny71DY41rtC/8LdkF6B9PcX+rehWwA5jIT4ejsUb
         F4e8ALFvzyfB3CQmODGAj4LoKpVWIK6gAXT9Ct706qtWrSdHwiddAP73misew980NL
         +Gwzf1ZJYPD49APNzWrkumagdttw4cYN+YZ9FRwxvSMIdV9Cb7UsHYvyqCQuqjNdiL
         UL9K4BqbRWl1c74IGrehwmn2csrl+1ASEr7QlratXmfEUK4GaajPlJOkC3pr1b8Xkr
         2U6iS5eLU3kRwwoX8WjdVI5/ZZwx561jCcgUX37D8mhfnXcxvqeHRA7n8PIc36UOzj
         qYA+uVzKsjotQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E8FFCC009;
        Sun,  5 Feb 2023 11:03:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1675591413; bh=yuBTnTNo7td/toyaaBlUDQQOiPPlqNou5TGqDBMKb+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OmCoS0p71joRASOzE+UndPQL/rkMGtHSdIxlQ1MylCwEQXfhFYy1pM8EI6JOxWT/7
         FIUVyhztQEfiRy9iDGTjC4fPpZpgFf0A9It/QqiYSIwtNgiaauwsdL3qrYzTJNj37N
         GcGhVafIfIJrI9wuYN/kqbkMn0oSVYfFnh+zRBLiBS/HL1QDH1QfgdpWvuEMJQbH9A
         bvqOJQrZHs2TyFFW5CkbY7OnMgZKAaEuZ3jj4vhDI+Ppmhe+hKBFA60g23+VN9/CNe
         UpvraPNoJcH5g/oygPYZkVKyoOXVqgmB8OOKabz5ptxJKhHvQGZk2HwkXFAtwy3CIO
         N8c7/grF6+c1g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c5d783f4;
        Sun, 5 Feb 2023 10:03:06 +0000 (UTC)
Date:   Sun, 5 Feb 2023 19:02:51 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH v2] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
Message-ID: <Y99+yzngN/8tJKUq@codewreck.org>
References: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

meta-comment: 9p is usually handled separately from netdev, I just saw
this by chance when Simon replied to v1 -- please cc
v9fs-developer@lists.sourceforge.net for v3 if there is one
(well, it's a bit of a weird tree because patches are sometimes taken
through -net...)

Also added Christian (virtio 9p) and Eric (second maintainer) to Tos for
attention.


Jens Axboe wrote on Fri, Feb 03, 2023 at 09:04:28AM -0700:
> signal_pending() really means that an exit to userspace is required to
> clear the condition, as it could be either an actual signal, or it could
> be TWA_SIGNAL based task_work that needs processing. The 9p client
> does a recalc_sigpending() to take care of the former, but that still
> leaves TWA_SIGNAL task_work. The result is that if we do have TWA_SIGNAL
> task_work pending, then we'll sit in a tight loop spinning as
> signal_pending() remains true even after recalc_sigpending().
> 
> Move the signal_pending() logic into a helper that deals with both, and
> return -ERESTARTSYS if the reason for signal_pendding() being true is
> that we have task_work to process.
> Link: https://lore.kernel.org/lkml/Y9TgUupO5C39V%2FDW@xpf.sh.intel.com/
> Reported-and-tested-by: Pengfei Xu <pengfei.xu@intel.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
> v2: don't rely on task_work_run(), rather just punt with -ERESTARTYS at
>     that point. For one, we don't want to export task_work_run(), it's
>     in-kernel only. And secondly, we need to ensure we have a sane state
>     before running task_work. The latter did look fine before, but this
>     should be saner. Tested this also fixes the report as well for me.

Hmm, just bailing out here is a can of worm -- when we get the reply
from server depending on the transport hell might break loose (zc
requests in particular on virtio will probably just access the memory
anyway... fd will consider it got a bogus reply and close the connection
which is a lesser evil but still not appropriatey)

We really need to get rid of that retry loop in the first place, and req
refcounting I added a couple of years ago was a first step towards async
flush which will help with that, but the async flush code had a bug I
never found time to work out so it never made it and we need an
immediate fix.

... Just looking at code out loud, sorry for rambling: actually that
signal handling in virtio is already out of p9_virtio_zc_request() so
the pages are already unpinned by the time we do that flush, and I guess
it's not much worse -- refcounting will make it "mostly work" exactly as
it does now, as in the pages won't be freed until we actually get the
reply, so the pages can get moved underneath virtio which is bad but is
the same as right now, and I guess it's a net improvement?


I agree with your assessment that we can't use task_work_run(), I assume
it's also quite bad to just clear the flag?
I'm not familiar with these task at all, in which case do they happen?
Would you be able to share an easy reproducer so that I/someone can try
on various transports?

If it's "rare enough" I'd say sacrificing the connection might make more
sense than a busy loop, but if it's becoming common I think we'll need
to spend some more time thinking about it...
It might be less effort to dig out my async flush commits if this become
too complicated, but I wish I could say I have time for it...

Thanks!

> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 622ec6a586ee..9caa66cbd5b7 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -652,6 +652,25 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
>  	return ERR_PTR(err);
>  }
>  
> +static int p9_sigpending(int *sigpending)
> +{
> +	*sigpending = 0;
> +
> +	if (!signal_pending(current))
> +		return 0;
> +
> +	/*
> +	 * If we have a TIF_NOTIFY_SIGNAL pending, abort to get it
> +	 * processed.
> +	 */
> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> +		return -ERESTARTSYS;
> +
> +	*sigpending = 1;
> +	clear_thread_flag(TIF_SIGPENDING);
> +	return 0;
> +}
> +
>  /**
>   * p9_client_rpc - issue a request and wait for a response
>   * @c: client session
> @@ -687,12 +706,9 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
>  	req->tc.zc = false;
>  	req->rc.zc = false;
>  
> -	if (signal_pending(current)) {
> -		sigpending = 1;
> -		clear_thread_flag(TIF_SIGPENDING);
> -	} else {
> -		sigpending = 0;
> -	}
> +	err = p9_sigpending(&sigpending);
> +	if (err)
> +		goto reterr;
>  
>  	err = c->trans_mod->request(c, req);
>  	if (err < 0) {
> @@ -789,12 +805,9 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
>  	req->tc.zc = true;
>  	req->rc.zc = true;
>  
> -	if (signal_pending(current)) {
> -		sigpending = 1;
> -		clear_thread_flag(TIF_SIGPENDING);
> -	} else {
> -		sigpending = 0;
> -	}
> +	err = p9_sigpending(&sigpending);
> +	if (err)
> +		goto reterr;
>  
>  	err = c->trans_mod->zc_request(c, req, uidata, uodata,
>  				       inlen, olen, in_hdrlen);
> 
