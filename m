Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C153B1E8326
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgE2QHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2QG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:06:59 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F94C03E969;
        Fri, 29 May 2020 09:06:59 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n141so2685432qke.2;
        Fri, 29 May 2020 09:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2QkBQ1hsW65ifs+T38dQCXySbtszUd8Dh1ih5qIb6ac=;
        b=bxj9ZN1HcOCP6sltQ7S8XSau8mdagaprLbERl96zHDDXcYVD9iMUrHjldPjTzJOlhA
         RRnVvuZtp309QRcnWQFx3y+wHHslWBAIEVSvp/qwyUgpRbnDaWpRUzDIT0n4bx/iEPxt
         Zx589SWGzTS2fNsyfvphf0IxRCJvpaEDbsnSrhqu6aJcgS9nTj5lYGgzb50GJK9yECiS
         1SzWuhYSZXeoYfzw53kDrnjgfLO3sxjfB9B/K8nP3gjAE28ZelhdFh71/JwrTtUUANWn
         4eOhU+hifZj+1N+tjI3/cIBgfSfOY/DgCzoqg0H2VPp1x0wyxOKRI0BGeKQKlkGh7bHO
         CuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2QkBQ1hsW65ifs+T38dQCXySbtszUd8Dh1ih5qIb6ac=;
        b=h+xhuVf/kGh5gQXavtrc/zXjpw98pSjWRwyz7nd8s6Ff4v8vmX3iEan6lB30bASvJC
         zG2SraO/qLKyzGLzWKaUurqg+R0Y7co+ilM6d/mPHDfTjP89Oc5H8O63weRn+dhhbvx0
         Dueav9lczCcpCCIrBI2zPe81vLnhEkKmO8nchq7ictCEMwEo6dP4+hoU2YiOUt9hvbsj
         7qhMffE1u5OFLWNh3IJ0C9bGMHbSLQng/BJehmurVVGTIaDzpOcv28cBQkaha73vImpe
         637As8iG+kJaElgYiOLlHl+p+yczkCi3ZGzYfwuD07673gz+3g6v0jbSmzvKR/n/nNRJ
         XLOg==
X-Gm-Message-State: AOAM53297C7Z1TsXpEVpq3oHwmtfHlIeAVS4iJr3o9YxhDBLuq2ywraV
        v3wzO7vMIfSUtuhL7BA7b1E=
X-Google-Smtp-Source: ABdhPJwMyl4MP7h2HUGz7QIi8xuwkpyEvWtq9gcbO4jTClNrEKWMsNO9bid5iODsnfpoxy8FDRo4NQ==
X-Received: by 2002:ae9:e10f:: with SMTP id g15mr8822930qkm.285.1590768418954;
        Fri, 29 May 2020 09:06:58 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:516d:2604:bfa5:7157:afa1])
        by smtp.gmail.com with ESMTPSA id j90sm8034447qte.33.2020.05.29.09.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:06:58 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C434AC1B84; Fri, 29 May 2020 13:06:55 -0300 (-03)
Date:   Fri, 29 May 2020 13:06:55 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Laight <David.Laight@aculab.com>,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net: add a new bind_add method
Message-ID: <20200529160655.GJ2491@localhost.localdomain>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529120943.101454-4-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:42PM +0200, Christoph Hellwig wrote:
> The SCTP protocol allows to bind multiple address to a socket.  That
> feature is currently only exposed as a socket option.  Add a bind_add
> method struct proto that allows to bind additional addresses, and
> switch the dlm code to use the method instead of going through the
> socket option from kernel space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Even though checkpatch complained about bad alignment here:
> +static int sctp_bind_add(struct sock *sk, struct sockaddr *addrs,
> +		int addrlen)
