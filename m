Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB626FE7D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIRNaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRNaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:30:02 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08894C0613CE;
        Fri, 18 Sep 2020 06:30:02 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id n10so4923297qtv.3;
        Fri, 18 Sep 2020 06:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vASDjEll6360SujAnjlOkOkT4JdvbE9lhOhXWeoPleE=;
        b=iaE8JMtgxMFET5j8BgD9mRCKX/eq0V3KVrnKyozizQNZ/SK2gOuiy9LuDCcd5wN9yo
         ZiYisPuSzE/UqpsvLSxzY7O/J0x+MCPvX/9+kLqhkoqljp38LRLoFFnkaax1TtE8bVof
         pVLq0q0gY+yuypZK42If1I+/HfvlPUvypPQYZG/AX/Ko929il5wWQXDijPvUzgWO9YMl
         nzChB4l2bH9/YXxDoN72CKoM9/hIcifgZ7GPxQecPmcKF78/PFbUzl1ib0JM+Mj4zz1T
         c90HOkfg3+k+fuiDt8WMpHvcM8+PCKlVNKFlaCwNMvIhlAOJNpTzAcbqiDjGnaNHyiu7
         H15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vASDjEll6360SujAnjlOkOkT4JdvbE9lhOhXWeoPleE=;
        b=NVMH+zNvBs+eVauhg8f2mONNvFMAs+3Rg43MvRu2VPxCpTytD5NxAeBa6GMubsCCw6
         HPqgDHT3wgnP78ZqyntMaO7AmKPdOivzIFAGL0Xz1CjJQiOGiizC8a7enkTx08qn5tjM
         gndKqIH6ph1//AIBpnQjoUEPH9R2T/4nFrpIcGo7AZHPGx1iS9dMMWudN3R8s7Uuw84W
         CFmwRW9BwslFZw9Eja6ubvZ5bGOMUDOFRlQ35ZjWVR4tZgtlQxYn9J1FK+Gk4Mk1u2st
         dnYkroM4+/iqnS3OJ/gUxCr3hpkABYn8yAdm5pA9ogztXZY3GFBt7Xv2Y8uyuH6j05wN
         jSMQ==
X-Gm-Message-State: AOAM530k3rxTfmHZ3bACOx7Zwf/EpCu3KLk3OkhvVhSuEDTsDMzULHVK
        U/+u98BuOUdZi3Drtwsl6t8=
X-Google-Smtp-Source: ABdhPJwP89l58R0b0P2ljD2Q/hpiLcFOLGbgRZjclDShsIg/UelGnTmLNnAFslgB0yxcJKURjsYOeg==
X-Received: by 2002:ac8:1488:: with SMTP id l8mr33223704qtj.131.1600435801141;
        Fri, 18 Sep 2020 06:30:01 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:eda9:8c35:6fe5:a04c:832])
        by smtp.gmail.com with ESMTPSA id p3sm1996690qkj.113.2020.09.18.06.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 06:30:00 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C354BC1D68; Fri, 18 Sep 2020 10:29:57 -0300 (-03)
Date:   Fri, 18 Sep 2020 10:29:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Henry Ptasinski <hptasinski@google.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] net: sctp: Fix IPv6 ancestor_size calc in
 sctp_copy_descendant
Message-ID: <20200918132957.GB82043@localhost.localdomain>
References: <20200918015610.3596417-1-hptasinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918015610.3596417-1-hptasinski@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 01:56:10AM +0000, Henry Ptasinski wrote:
> When calculating ancestor_size with IPv6 enabled, simply using
> sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
> alignment in the struct sctp6_sock. On x86, there aren't any extra
> bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
> boundary so there were 4 pad bytes that were omitted from the
> ancestor_size calculation.  This would lead to corruption of the
> pd_lobby pointers, causing an oops when trying to free the sctp
> structure on socket close.

Makes sense.

> 
> Signed-off-by: Henry Ptasinski <hptasinski@google.com>

Please add a:
Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")

> ---
>  net/sctp/socket.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 836615f71a7d..a6358c81f087 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9220,12 +9220,14 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
>  static inline void sctp_copy_descendant(struct sock *sk_to,
          ^^^^^^  I'll send a patch to fix/remove this.

>  					const struct sock *sk_from)
>  {
> -	int ancestor_size = sizeof(struct inet_sock) +
> -			    sizeof(struct sctp_sock) -
> -			    offsetof(struct sctp_sock, pd_lobby);
                                                       ^^^^^^^^

Then, as this patch is actually fixing the aforementioned commit,
please also update the comment on sctp_sock definition, as pd_lobby
now is also skipped.

> +	size_t ancestor_size = sizeof(struct inet_sock);
>  
>  	if (sk_from->sk_family == PF_INET6)
> -		ancestor_size += sizeof(struct ipv6_pinfo);
> +		ancestor_size += sizeof(struct sctp6_sock);

As you probably noticed by the build bot email already, there need to
be some protection to building without IPv6 enabled.

To avoid ifdefs here, something similar to how
inet_sk_copy_descendant() is done is probably welcomed, but please
feel free to be creative. :-)

> +	else
> +		ancestor_size += sizeof(struct sctp_sock);
> +
> +	ancestor_size -= offsetof(struct sctp_sock, pd_lobby);
>  
>  	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
>  }
> -- 
> 2.28.0.681.g6f77f65b4e-goog
> 
