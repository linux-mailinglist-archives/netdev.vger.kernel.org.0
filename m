Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B6C2709EE
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgISCFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISCFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 22:05:53 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A469FC0613CE;
        Fri, 18 Sep 2020 19:05:53 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f142so8520035qke.13;
        Fri, 18 Sep 2020 19:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eVR3VuNNBUjQaTbx6p6TQvN7yVIjqmwDAT7834tFyAc=;
        b=AgGBFQPF9PGFEk+iFpfltq3KQewAVJUMg+qXgAxIPs17KMrq1kGnVSIk7WXkzMcnH7
         /HLsYplNWBTxEwwY092W3srpuJhHMtD36jV8iA70/WWWTE+3pWIQ2kUO1uVAgx2lfmxQ
         5MRz9lHRZFgFS62D1z5rVx8t2FV2+7oYetRcQYvKVc+KZJSevvq4g+P6gfMjEao4wL1J
         SIaNnzf+8exJQBRAWgJXnNWHkAqRlKVwbOxvPnCh7DuiEZUkqGR/l6z79iWJ9D9fiV8y
         Q3FLbPOCMp0drsI+NsF3YRgYWqAw1jYyMVlUFbnCZY13VELuUbZEJzXnAuilJMf2Smni
         ovwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eVR3VuNNBUjQaTbx6p6TQvN7yVIjqmwDAT7834tFyAc=;
        b=gKhNNWA83uLoluKg4mMG1d5Ar5NNGAr8VzRESju9w+vvpUWilc4MXUEbdqgGaH3GFS
         jeBa0c/kb3Q76BU7vm/V7CsQxCxponXK306xc7XsZbM9QxTRsLsBmQQZmx5v7h1iL+mZ
         oKvZM2ij95m+SCGMuok29uuJVRorppNHy2t1EgId1Dj/W77pgWAkkZBk5FyEpsV/k9Yh
         HZhWiCtrW5siWG6XkaoG80c4+/3EppkS2owc1s3ZSUWJOVZnoShCXu30fkvEIAGtNemk
         QeuTFgHBBcz+cxVW83LuDeJfWCpaPnd+QwiynVcKZbmLoT8WeqaZb/MJo7KjzqYLkNQd
         g7xw==
X-Gm-Message-State: AOAM533bNaPP48mVnfRIgfHyFNCUKbSY6opzEQAe/wCAm4659G580PCw
        dy6XCRoGVkwPGTjWkDzC7p2lrGOqpCMXiA==
X-Google-Smtp-Source: ABdhPJwIbnVBsSNNpDqlEs/qQdRKPbXZclLk8rfL/Z0hQ0qK5Bn7xAExc6IHJjifeQ6mHPQWc/7NiA==
X-Received: by 2002:a05:620a:2082:: with SMTP id e2mr34512118qka.421.1600481152689;
        Fri, 18 Sep 2020 19:05:52 -0700 (PDT)
Received: from localhost.localdomain ([177.220.174.145])
        by smtp.gmail.com with ESMTPSA id 7sm3381782qkh.60.2020.09.18.19.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 19:05:52 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 95013C189C; Fri, 18 Sep 2020 23:05:49 -0300 (-03)
Date:   Fri, 18 Sep 2020 23:05:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Henry Ptasinski <hptasinski@google.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH v2] net: sctp: Fix IPv6 ancestor_size calc in
 sctp_copy_descendant
Message-ID: <20200919020549.GA70998@localhost.localdomain>
References: <20200918132957.GB82043@localhost.localdomain>
 <20200919001211.355148-1-hptasinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919001211.355148-1-hptasinski@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 12:12:11AM +0000, Henry Ptasinski wrote:
> When calculating ancestor_size with IPv6 enabled, simply using
> sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
> alignment in the struct sctp6_sock. On x86, there aren't any extra
> bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
> boundary so there were 4 pad bytes that were omitted from the
> ancestor_size calculation.  This would lead to corruption of the
> pd_lobby pointers, causing an oops when trying to free the sctp
> structure on socket close.
> 
> Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")
> Signed-off-by: Henry Ptasinski <hptasinski@google.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

...
>  {
> -	int ancestor_size = sizeof(struct inet_sock) +
> -			    sizeof(struct sctp_sock) -
> -			    offsetof(struct sctp_sock, pd_lobby);
> -
> -	if (sk_from->sk_family == PF_INET6)
> -		ancestor_size += sizeof(struct ipv6_pinfo);
> +	size_t ancestor_size = sizeof(struct inet_sock);
>  
> +	ancestor_size += sk_from->sk_prot->obj_size;

Heh, of course. Nice one.

> +	ancestor_size -= offsetof(struct sctp_sock, pd_lobby);
>  	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
>  }
>  
> -- 
> 2.28.0.681.g6f77f65b4e-goog
> 
