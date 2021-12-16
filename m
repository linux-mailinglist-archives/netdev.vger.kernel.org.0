Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730FC477A34
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhLPROw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbhLPROw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 12:14:52 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0229DC06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 09:14:52 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t26so9109248wrb.4
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 09:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uRjKljc4yegWQqkyxyBTI2kdTqp33hVgEMBiYfg4ycs=;
        b=FtSpZqr3rOHmoBKZ4ZfkLwOaza92prXpwUv+tFaqSiZ4sEDE9mn8TfkXoonODUlMzn
         i9cVgLcwRI79RJw7w3EmJ+WDYYGMHu2PjZq8UHyDFVtRthlGYuWWa4+l5+wAeAN2ZLNK
         b+C3HarIuF6L/vpLkoAbpOqfeeczy01X5glxcZohQ6BNZJ4SV3LJ+D8GvLe7k1+OCjHA
         Aq6wksyDY0eYc2I0Wrxqs+52yXkbLmbWV2hC8ZYZT30tpVWVJzH3zPZnF3Vvm9qKTEel
         9cZh/CGF8pvLXsApDQ56r5mYsgnMvAq05Oq8IXjkV5dwnXI0jqlZzcT/xdYCquGLS0Ov
         HxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uRjKljc4yegWQqkyxyBTI2kdTqp33hVgEMBiYfg4ycs=;
        b=V5ywbDDd4yUjPx2ZNQpqJLcKe5s0Wi0Q36RjfFOVIraprAguv/aQ38+nqakC0SpIfR
         OAkkBcRN8U0NHwtK8zi23mloKRnv/oaoVXjAaFiCib+W8NrqQisTJ1EvLMRE8ujcXH1/
         dQFclX1GwK51lQFNVAve75V7hoNSsg1Xzo/2o/0emLDyBei1OhBCzn9SEnozuUjvKWZV
         JCffoJWgM7M+XZXW6cWw3g2tMSjxh7N+mN5vFqUBBmLJ/y5LdSxYHAKqw83wXzQoeVaF
         C8DDRwIqIsyr8m24rOos1WzFdW4XEWq5Il2xdm7/g5TmA1/LqI2BuFegbhZP2rqXT9GO
         NHFQ==
X-Gm-Message-State: AOAM531SZW+67pf2NlQh7FenJdj8sgw7yPfDHlCLRNfwVdk1x9QcGxzk
        foo6E5y2ODesT8fi2oSxsNiS6w==
X-Google-Smtp-Source: ABdhPJz/qjRnGER3BMfsfcmhXY5XY5zjqFD9zwyEULhTIE6CMZcXzUI1L45GjBzAPwU6YIM725tNug==
X-Received: by 2002:adf:dd8d:: with SMTP id x13mr1280778wrl.401.1639674890505;
        Thu, 16 Dec 2021 09:14:50 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id e12sm6821826wrq.20.2021.12.16.09.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 09:14:50 -0800 (PST)
Date:   Thu, 16 Dec 2021 17:14:39 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
Message-ID: <Ybtz/0gflbkG5Q/0@google.com>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org>
 <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com>
 <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
 <Ybtzr5ZmD/IKjycz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ybtzr5ZmD/IKjycz@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021, Lee Jones wrote:

> On Thu, 16 Dec 2021, Xin Long wrote:
> 
> > On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Thu, 16 Dec 2021, Xin Long wrote:
> > >
> > > > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > >
> > > > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > > > The cause of the resultant dump_stack() reported below is a
> > > > > > dereference of a freed pointer to 'struct sctp_endpoint' in
> > > > > > sctp_sock_dump().
> > > > > >
> > > > > > This race condition occurs when a transport is cached into its
> > > > > > associated hash table followed by an endpoint/sock migration to a new
> > > > > > association in sctp_assoc_migrate() prior to their subsequent use in
> > > > > > sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> > > > > > table calling into sctp_sock_dump() where the dereference occurs.
> > >
> > > > in sctp_sock_dump():
> > > >         struct sock *sk = ep->base.sk;
> > > >         ... <--[1]
> > > >         lock_sock(sk);
> > > >
> > > > Do you mean in [1], the sk is peeled off and gets freed elsewhere?
> > >
> > > 'ep' and 'sk' are both switched out for new ones in sctp_sock_migrate().
> > >
> > > > if that's true, it's still late to do sock_hold(sk) in your this patch.
> > >
> > > No, that's not right.
> > >
> > > The schedule happens *inside* the lock_sock() call.
> > Sorry, I don't follow this.
> > We can't expect when the schedule happens, why do you think this
> > can never be scheduled before the lock_sock() call?
> 
> True, but I've had this running for hours and it hasn't reproduced.
> 
> Without this patch, I can reproduce this in around 2 seconds.
> 
> The C-repro for this is pretty intense!
> 
> If you want to be *sure* that a schedule will never happen, we can
> take a reference directly with:
> 
>      ep = sctp_endpoint_hold(tsp->asoc->ep);
>      sk = sock_hold(ep->base.sk);
> 
> Which was my original plan before I soak tested this submitted patch
> for hours without any sign of reproducing the issue.
> 
> > If the sock is peeled off or is being freed, we shouldn't dump this sock,
> > and it's better to skip it.
> 
> I guess we can do that too.
> 
> Are you suggesting sctp_sock_migrate() as the call site?

Also, when are you planning on testing the flag?

Won't that suffer with the same issue(s)?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
