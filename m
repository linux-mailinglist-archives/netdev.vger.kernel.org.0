Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C24365305
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhDTHQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230375AbhDTHP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A8460FF1;
        Tue, 20 Apr 2021 07:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618902926;
        bh=fvjxsgoBx7JGOSJaXoytegpfNSuCdjkRujjIoQ/GmLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Au/EvSiy2VjwAs3jsJtgXlE2wnUl8vpgPUa8PDRRCTQnOLdPW9G1tL5z+IpLyZ8K8
         zUzRxogqhqX0TUXtc0aftJJuhSb3Xkgn3kfhnKpT48B9A6nSs6cD3BRE+p4ChwY5Yb
         3ja2PiFu25Lk0YfsNPUtYoBIIvh8si+nYUv06puk=
Date:   Tue, 20 Apr 2021 09:15:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YH5/i7OvsjSmqADv@kroah.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407001658.2208535-1-pakki001@umn.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:16:56PM -0500, Aditya Pakki wrote:
> In gss_pipe_destroy_msg(), in case of error in msg, gss_release_msg
> deletes gss_msg. The patch adds a check to avoid a potential double
> free.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  net/sunrpc/auth_gss/auth_gss.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index 5f42aa5fc612..eb52eebb3923 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -848,7 +848,8 @@ gss_pipe_destroy_msg(struct rpc_pipe_msg *msg)
>  			warn_gssd();
>  		gss_release_msg(gss_msg);
>  	}
> -	gss_release_msg(gss_msg);
> +	if (gss_msg)
> +		gss_release_msg(gss_msg);a

If you look at the code, this is impossible to have happen.

Please stop submitting known-invalid patches.  Your professor is playing
around with the review process in order to achieve a paper in some
strange and bizarre way.

This is not ok, it is wasting our time, and we will have to report this,
AGAIN, to your university...

greg k-h
