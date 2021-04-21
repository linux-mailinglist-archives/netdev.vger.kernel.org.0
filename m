Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEF036755E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 00:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343596AbhDUWxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 18:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbhDUWxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 18:53:18 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B57C06138A;
        Wed, 21 Apr 2021 15:52:44 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 5-20020a9d09050000b029029432d8d8c5so14469683otp.11;
        Wed, 21 Apr 2021 15:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+Q3lYO1hTpL3JeJVnFbKHYgLVKq2KQUZWjQJJYj9jJM=;
        b=U60eCJYI6LzX7UlSt8krSU6ggge2RW0Q4fVjfJuBK6S5Ik1hpq9BFAmYk7W6JNVtUm
         iUd65hB/5tMXH+wNIfDyyBFqaRsmjOLLY+VpchG585B6IKObrYTa8+9rR1u1tD1jip2T
         +rcunfytTqNtKPKCvOOwfNB40UGUr8E2PA88BjbavfU1b07G06x3wca9rRsA9gycR9WK
         od0XtgycC2g1bzlAer5pE4DsiYa7pNrunhodWR8VBXC5tgxGs74uNPyreqBeZdTFvcSo
         kt4KnyGvqY3N3Ml6WWFDZj8X/taYOgFc/STmk1HpE99fS7UQzNDW2oUjXdmmdwe+MAQU
         B11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+Q3lYO1hTpL3JeJVnFbKHYgLVKq2KQUZWjQJJYj9jJM=;
        b=PTZ77RRAOccVSOHAGqJmsqhbqcr/qPI1dwtnhUHmA9h3iEI/GGEcbpdjGXrs3JVwpe
         CFoelUhWHtjPqMyFQUncbRjkoOTnTPUzSRPgMbIqsKmi24yOo5xJh9tqJY2uatxIfdnb
         8+nAW0jrLRXnPMuyRvhJy3YX2Ga0nNK6FQUnULqfH9+DwOVDAMyvo2WGSm1epf4E6O9j
         3bPitjTROS/IssCwtiFdVa+hFRnCLs0zam05+XItnjXXUY6D075pPFipawWOS0c95HMX
         JJTZG3x14xgR6uLiA0vgEf3sg5k7OrE3+0L2eQVaFH+5hQi2mFRrm0W6KFRMZHCjpqqE
         y0/w==
X-Gm-Message-State: AOAM530YcwjKMbQ50uDFs4ZcLexgkhnN1sPYbfwUyaYYMPx65Cxbi2Xc
        sw5JFBhyLE6OYwon3rM+vfw=
X-Google-Smtp-Source: ABdhPJwozywGSqQF3xMLdEXGk1/u2t5WGdubCmaImSDPIJQ/cPLAZTkZQ25/VuvtQm4+NZul5sPALA==
X-Received: by 2002:a05:6830:1584:: with SMTP id i4mr371717otr.129.1619045564152;
        Wed, 21 Apr 2021 15:52:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k8sm179101oig.6.2021.04.21.15.52.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Apr 2021 15:52:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 21 Apr 2021 15:52:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <20210421225240.GA117423@roeck-us.net>
References: <20210407001658.2208535-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407001658.2208535-1-pakki001@umn.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
> +		gss_release_msg(gss_msg);

I know I am adding to the noise here, but it has to be said:
gss_msg is assigned with
	struct gss_upcall_msg *gss_msg = container_of(msg, struct gss_upcall_msg, msg);
and thus never NULL.

Guenter

>  }
>  
>  static void gss_pipe_dentry_destroy(struct dentry *dir,
> -- 
> 2.25.1
> 
