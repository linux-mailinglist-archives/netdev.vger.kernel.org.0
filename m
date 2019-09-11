Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93EAFEEE
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfIKOj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:39:29 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40022 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfIKOj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:39:28 -0400
Received: by mail-qk1-f194.google.com with SMTP id y144so12962517qkb.7;
        Wed, 11 Sep 2019 07:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TwN6OrjdKt+44ku7KhvZUr2O4KlJSVZ8kmhB6V+j7N8=;
        b=t12WokXoJJ4K4NUUnEOf7/c8b7WRfEQ6bn7vsO5yCVsQ9XAK4VVGkp9+O8v1rgippv
         3E0ddwd9nqFUG00UzxFS30O6gPjS9LBm10a+Zm8ipspUkj7Oc5oFkw2uOfPp24PR7tuF
         oOQY2CtT5G7ia1Sm/h4yz1/MZPIGGeHe6ArOVTBZryVmnIuUpLD7szxh+2ec/T4e3Mw1
         OoujYt5HBky2ouplU++zanDJ6CrUhhX3FY30dAT9fysCmK0kFyQLucIUvxqCtf0rZ9Hp
         PXtaD8GdMfehs9dCLuz7cfVqU/wqp/xdGjB+L9hPmo58yIpvgobuCwLCTTLpG7ZmcGEt
         hBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TwN6OrjdKt+44ku7KhvZUr2O4KlJSVZ8kmhB6V+j7N8=;
        b=oD9UVBQNGsBRuWh9nxOOdsuudHkFIsqtdKbU7s9JpL5Ll/o9+KqoQsWtf+ZbzXIcRs
         YYmGWNq+95dg1k3neJ0ALN5lcxhlPLiU2sMz8+PAyFgJ8KzpT0avvKyIYAyY2YIvo9iR
         mrKz6L5ID4n4sGfwvVu5M0BY4zCtgANTyb0xrlsvyMCnhhMFCA97RQ3OXjx92z5oymbP
         0DUu5FZ+Lmps1TOPM53uN/HAkIgKD8ipIiQPF88FGKdFKHV0/dMBMgruhdwW1fUVvj6W
         ogq95YBJxJujRK41eIXx87r0/qo5bDnfA7qNFK21HL3IS0bRTOYlGiVWXnqs0nwf02G+
         hM7w==
X-Gm-Message-State: APjAAAW3fmiq3RiMiomH/47BGWQQU7JNPPjytvW81UUz+tAbWtYzQZSc
        49CpNh3UfRr6ELLEKmOKYRg=
X-Google-Smtp-Source: APXvYqzDyV+SgjNA5WEUzBQAIMOWaP+tdcQzaGUX0YOJ8JPSKoUht7TpayG/vdBITmUBUICF0Fd/pA==
X-Received: by 2002:ae9:e00a:: with SMTP id m10mr37294490qkk.167.1568212766886;
        Wed, 11 Sep 2019 07:39:26 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.89])
        by smtp.gmail.com with ESMTPSA id d45sm12194380qtc.70.2019.09.11.07.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 07:39:25 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 75378C4A64; Wed, 11 Sep 2019 11:39:23 -0300 (-03)
Date:   Wed, 11 Sep 2019 11:39:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     maowenan <maowenan@huawei.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call
 sctp_get_port_local
Message-ID: <20190911143923.GE3499@localhost.localdomain>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
 <20190910185710.GF15977@kadam>
 <20190910192207.GE20699@kadam>
 <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
 <20190911083038.GF20699@kadam>
 <20190911143008.GD3499@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911143008.GD3499@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 11:30:08AM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Sep 11, 2019 at 11:30:38AM +0300, Dan Carpenter wrote:
> > On Wed, Sep 11, 2019 at 09:30:47AM +0800, maowenan wrote:
> > > 
> > > 
> > > On 2019/9/11 3:22, Dan Carpenter wrote:
> > > > On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
> > > >> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> > > >>> There are more parentheses in if clause when call sctp_get_port_local
> > > >>> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> > > >>> do cleanup.
> > > >>>
> > > >>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> > > >>> ---
> > > >>>  net/sctp/socket.c | 3 +--
> > > >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> > > >>>
> > > >>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > >>> index 9d1f83b10c0a..766b68b55ebe 100644
> > > >>> --- a/net/sctp/socket.c
> > > >>> +++ b/net/sctp/socket.c
> > > >>> @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> > > >>>  	 * detection.
> > > >>>  	 */
> > > >>>  	addr->v4.sin_port = htons(snum);
> > > >>> -	if ((ret = sctp_get_port_local(sk, addr))) {
> > > >>> +	if (sctp_get_port_local(sk, addr))
> > > >>>  		return -EADDRINUSE;
> > > >>
> > > >> sctp_get_port_local() returns a long which is either 0,1 or a pointer
> > > >> casted to long.  It's not documented what it means and neither of the
> > > >> callers use the return since commit 62208f12451f ("net: sctp: simplify
> > > >> sctp_get_port").
> > > > 
> > > > Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
> > > > socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
> > > > because before the code assumed that a pointer casted to an int was the
> > > > same as a pointer casted to a long.
> > > 
> > > commit 4e54064e0a13 treated non-zero return value as unexpected, so the current
> > > cleanup is ok?
> > 
> > Yeah.  It's fine, I was just confused why we weren't preserving the
> > error code and then I saw that we didn't return errors at all and got
> > confused.
> 
> But please lets seize the moment and do the change Dean suggested.

*Dan*, sorry.

> This was the last place saving this return value somewhere. It makes
> sense to cleanup sctp_get_port_local() now and remove that masked
> pointer return.
> 
> Then you may also cleanup:
> socket.c:       return !!sctp_get_port_local(sk, &addr);
> as it will be a direct map.
> 
>   Marcelo
> 
