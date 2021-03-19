Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C36341D8D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCSM5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhCSM5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 08:57:23 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543ADC0613D7
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:57:23 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso5214421wmi.0
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XpPGUE6BByswa3Ep4l8WzlVumVFkgxbvdRbN1GhWJbU=;
        b=eQ2OMBnwvXNj4Zdcbf4Hf8XhhOBTeJwVU8tZfivPCrGq/tqqyHwo+0+7sVu6f/FsOF
         2OxuJiRcYb+ik93a+6pEZWp7tjd8+5ZGYphQIC53Le4n8JIjcX44lFddF1HSGvwZed2B
         Kdty/Fkttsnba/u2wxbAW5PS5T45tIkJ0NOMrBS5T1OqETZjK5ywTXFrxyTHOnG0UEDs
         YwqAQK/gQEYhzSjBYukkAxpoaF+2mwqUDnY9us+Z2wK1PX5EK6/psOtGTwp+gwxvvLao
         0b4J3h/UircWR7ovcTz20HRQhi0PF74RiV9kaVNlVJ+dVdgg+O5M2++cy91mMuVOguqX
         kI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XpPGUE6BByswa3Ep4l8WzlVumVFkgxbvdRbN1GhWJbU=;
        b=WBumIVKf+FUCnDZAKpI70JTtfitXh8aA3Q9Qzay7viEMzpBNk8Sh0Zg7wWYfj8peBE
         j+KNDY5xJvLqnbZWYQXd8VzC8p8JL1xqo7lyTKMMSY3xHaUs1YirMVpzLbwu/LmDdBbh
         pDJCCz0KSer4U5acwfCmk93YyL0UuCnft+oKYiUhDZz1joof+OkkkgAht48/VbYXh2Re
         hW7U+0Bs0mrjurXGV8YPdypatXTmBZ/5usX7Y0fVYcZzXv9dg0a8VABhZ0bLHUMRCTDR
         KGs0VCgt2UtrGrtsdXoyUlW5FZKHA38ck4OMdOiuRqW3JMQqSr79QwDu7wKLRMaKfxfn
         lxMg==
X-Gm-Message-State: AOAM531Apf6eLeJQkJPRr5COQwBeFMRWoKrsfu5qGQMhEVq43Xdmu9dr
        p/DD1B9V5YZ216P/26LrfFKLDEVJQQzErg==
X-Google-Smtp-Source: ABdhPJwFVAyOf6DKJnWgPfK9dHaCFpWzGKth3FaOBlGYV9sO/L5kI4EXuCeCC1XVjuYkH/4Z1drgHQ==
X-Received: by 2002:a1c:448a:: with SMTP id r132mr3621997wma.157.1616158641830;
        Fri, 19 Mar 2021 05:57:21 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id s84sm6605286wme.11.2021.03.19.05.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 05:57:21 -0700 (PDT)
Date:   Fri, 19 Mar 2021 12:57:16 +0000
From:   David Brazdil <dbrazdil@google.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alistair Delva <adelva@google.com>
Subject: Re: [PATCH] selinux: vsock: Set SID for socket returned by accept()
Message-ID: <YFSfrIZAz6zHENT7@google.com>
References: <20210317154448.1034471-1-dbrazdil@google.com>
 <CAHC9VhT_+i9V9N7NAdCCUgO5xBZpffvVPeh=jK8weZr3WzZ4Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT_+i9V9N7NAdCCUgO5xBZpffvVPeh=jK8weZr3WzZ4Bw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

I'll post a v2 shortly but will address your comments here.

> >  include/linux/lsm_hooks.h     |  7 +++++++
> >  include/linux/security.h      |  5 +++++
> >  net/vmw_vsock/af_vsock.c      |  1 +
> >  security/security.c           |  5 +++++
> >  security/selinux/hooks.c      | 10 ++++++++++
> >  6 files changed, 29 insertions(+)
> 
> Additional comments below, but I think it would be a good idea for you
> to test your patches on a more traditional Linux distribution as well
> as Android.
> 

No problem, I was going to add a test case into selinux-testsuite
anyway. Done now (link in v2) and tested on Fedora 33 with v5.12-rc3.

> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 5546710d8ac1..a9bf3b90cb2f 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -755,6 +755,7 @@ static struct sock *__vsock_create(struct net *net,
> >                 vsk->buffer_size = psk->buffer_size;
> >                 vsk->buffer_min_size = psk->buffer_min_size;
> >                 vsk->buffer_max_size = psk->buffer_max_size;
> > +               security_vsock_sk_clone(parent, sk);
> 
> Did you try calling the existing security_sk_clone() hook here?  I
> would be curious to hear why it doesn't work in this case.
> 
> Feel free to educate me on AF_VSOCK, it's entirely possible I'm
> misunderstanding something here :)
> 

No, you're completely right. security_sk_clone does what's needed here.
Adding a new hook was me trying to mimic other socket families going via
selinux_conn_sid. Happy to reuse the existing hook - makes this a nice
oneliner. :)

Please note that I'm marking v2 with 'Fixes' for backporting. This does
feel to me like a bug, an integration that was never considered. Please
shout if you disagree.

-David
