Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED2E33F547
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhCQQQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbhCQQQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:16:24 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5DEC06174A;
        Wed, 17 Mar 2021 09:16:23 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id c131so41067674ybf.7;
        Wed, 17 Mar 2021 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pIpmj0iUFUslcZM65CcWWuddq7UeQyGpZ/kaKvhwHeQ=;
        b=gpqDMxpSK8BK9uRYHO1Sn6gNnn+TvoFykR3BvxJt37V6xTNoZDItmkcex5eiLW11AY
         5efknekSUsz5t2Y7pGkMxzSY9OFUWW26kZxovOJ/7ndrWxhstzm1Gz1pPcgCpX3q4i4k
         xhuBkq6tG9WRAuOmYhGyh99wpTZk4K7RuDvj5ADQi3tOLY+vwdpg8nbrU6oasXfkQrxD
         f/HGTgmU7VoYL3HwvfmyiEXxYp1rDMNEct6TEuRAiJmjQmt++Icg3g98hpj2E7jkzo/R
         i6qLf14ewVxQUkQ3YhBMpqk0M3v4Q+/U3XL+F4AxKRF65ggDx6J8Nb61kn2LsCkW1O02
         4NUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pIpmj0iUFUslcZM65CcWWuddq7UeQyGpZ/kaKvhwHeQ=;
        b=THYbJLQuyPpuskkxQNT05E0XtAfwe70BJ5B/PO+FlSfmmhK9fR/vmhVdVLbesHAo36
         knaLwUuJFrCjzha8DQgCfx5LEyUaohyXDKGGITlSE9DA+cADFpsd48lyNBtWSs/bgp3J
         3ItAjm9PcU6TDoldmNz6/I1myUkp76XpZxsVEjkSFZ3YeuwYNqJRo4hJiHN/TAsRlbyI
         VNkQiJL3BPnzBdpkwD6q2xGzbQ2SIvslbTCQOx9W7wxwwuOEDQH7OQTUHXJPWaU3Y48D
         ybqFDco+pPeEhovG8C7IiGGKvhwQFZu2J4Ubmyfv3NvL2RubLxCf9m0bCqEbvmBouUIe
         j3kQ==
X-Gm-Message-State: AOAM531SMevTmf42TRAIm5C7mvedm5K1LDgA3d6J3uqoE6fR+9U8fh9u
        qhxBIdJntK1OdA2jp1MhDzI5Lcvyyxg=
X-Google-Smtp-Source: ABdhPJx3NVYL4eQ0A3J7BdfBAKLuTDC2vodxhHAN7TCA/479BuIIzg98gC8ALCJEsaoPuzlx+BIpOA==
X-Received: by 2002:a9d:68c1:: with SMTP id i1mr3662420oto.169.1615993362373;
        Wed, 17 Mar 2021 08:02:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k9sm8748211ots.24.2021.03.17.08.02.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Mar 2021 08:02:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Mar 2021 08:02:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
Message-ID: <20210317150240.GA159538@roeck-us.net>
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net>
 <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net>
 <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
 <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com>
 <CADxym3bHyaiy=kOhmxYdoMTZ_QaG9-JWqC1j6ucOBOeobVBoPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADxym3bHyaiy=kOhmxYdoMTZ_QaG9-JWqC1j6ucOBOeobVBoPg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 09:53:23PM +0800, Menglong Dong wrote:
> On Wed, Mar 17, 2021 at 5:36 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> ...
> >
> > The problematic code is negation of the flags when it's done in
> > operations like &.
> > It maybe fixed by swapping positions of the arguments, i.e. ~(FOO |
> > BAR) & flags.
> >
> > All this is a beast called "integer promotions" in the C standard.
> >
> > The best is to try to get flags to be unsigned. By how invasive it may be?
> 
> Seems that the inconsistent usages of 'msg_flags' is a lot, for example the
> 'recvmsg()' in 'struct proto' and 'recvmsg()' in 'struct proto_ops':
> 
> int (*recvmsg)(struct sock *sk, struct msghdr *msg,
>         size_t len, int noblock, int flags,
>         int *addr_len);
> 
> This function prototype is used in many places, It's not easy to fix them.

Also, flags is used in several other functions, not just recvmsg.

> This patch is already reverted, and I think maybe
> I can resend it after I fix these 'int' flags.

I would suggest to consult with Dave on that. While much of the conversion
could be handled automatically with coccinelle, it touches a lot of files.
I don't think that is worth the effort (or risk).

Guenter
