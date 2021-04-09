Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262893591DF
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 04:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhDICLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 22:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDICLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 22:11:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1830C061760;
        Thu,  8 Apr 2021 19:11:33 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g35so2716633pgg.9;
        Thu, 08 Apr 2021 19:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M7qe7FCfvCPMcZYFuYoHbQMK4LgMH3etO2XanLRa5d8=;
        b=SMX25MvqeE7Yr+RC/3xbxG29X1+VoXiVeju+8aEqyi2AMuaIQz3PA6malICPUm2W6K
         Xx9Zviitp8INcWLAaHbNGCQKSur+ychxer6ldAg7zpv+GG8qK03DM8IjOJrR7UcisoM/
         Rc8fyi++Y8gc2NjcQ5VlhLYosDCSAA2Rioprjm1qbMr1awBydTn2QOQkuOJX5Cn6MUya
         TzUqOJz6SrFC1av8846816iEPRsG9jVC4tHiTwZWO00ajRvOPD7YdsQ3QgrOW1FwKqKo
         NjBRyXr82DUTbpmHHZQik0Xewa4dkWZ/7SINLgdjkw9dym5ZDDmkPUC7XhqjbEM96oeW
         uLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M7qe7FCfvCPMcZYFuYoHbQMK4LgMH3etO2XanLRa5d8=;
        b=KgYsXHo/UHxNgrPDNJZ+s9U3eLkHOviAHZvrC3pU0bYDddyNBcLnjoWpjt0zK0W6Fj
         O24Kk3cenT9PRIXPSnHLpDZkhlGdKsu5rVGIXfCnMti0wRg/+wNLQVI8gVnjQLrkG9pz
         fKEJ7CTt1KAZj90RUDt1oAOFle/6jh9aLxi5olX1LnEkjm9lmruvT6ZaxFWnxXe2ubmg
         LZT664yo0QBCBP2snrRgdUmz0JhFg3lRWLEtyhSgmK1eAB2wlBO25gAiUpG0pQMDfra3
         Kw/iuOjbXAx/Y0X1UuJPqt96XN9Jzs+JkvtoqgDyPuIomfsTOsHghmA8FGupKifz1AK/
         a1+Q==
X-Gm-Message-State: AOAM531iNQgPfkRSwdPVreoVCIGK4RVOrO6E/0QngKBufJ/Z9adnRYt0
        m60u9UDKFFiLE6RCk7zHhSY=
X-Google-Smtp-Source: ABdhPJzzLDrJpyYDbLxTHzfPk8XomptqJPd8Rs79sUl9ODW5od30XDpJe8Bw/cJvHUDKfzjnKkNh4w==
X-Received: by 2002:a63:5a50:: with SMTP id k16mr10599264pgm.185.1617934293086;
        Thu, 08 Apr 2021 19:11:33 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p2sm563309pgm.24.2021.04.08.19.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 19:11:32 -0700 (PDT)
Date:   Fri, 9 Apr 2021 10:11:21 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210409021121.GK2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain>
 <20210408010640.GH2900@Leo-laptop-t470s>
 <20210408115808.GJ2900@Leo-laptop-t470s>
 <YG8dJpEEWP3PxUIm@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG8dJpEEWP3PxUIm@sol.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 08:11:34AM -0700, Eric Biggers wrote:
> On Thu, Apr 08, 2021 at 07:58:08PM +0800, Hangbin Liu wrote:
> > On Thu, Apr 08, 2021 at 09:06:52AM +0800, Hangbin Liu wrote:
> > > > Also, couldn't you just consider WireGuard to be outside your FIPS module
> > > > boundary, which would remove it from the scope of the certification?
> > > > 
> > > > And how do you handle all the other places in the kernel that use ChaCha20 and
> > > > SipHash?  For example, drivers/char/random.c?
> > > 
> > > Good question, I will check it and reply to you later.
> > 
> > I just read the code. The drivers/char/random.c do has some fips specific
> > parts(seems not related to crypto). After commit e192be9d9a30 ("random: replace
> > non-blocking pool with a Chacha20-based CRNG") we moved part of chacha code to
> > lib/chacha20.c and make that code out of control.
> > 
> So you are saying that you removed drivers/char/random.c and lib/chacha20.c from
> your FIPS module boundary?  Why not do the same for WireGuard?

No, I mean this looks like a bug (using not allowed crypto in FIPS mode) and
we should fix it.

Thanks
Hangbin
