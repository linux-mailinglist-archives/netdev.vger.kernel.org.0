Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB9E1EC3B6
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFBUdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:33:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727032AbgFBUdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591129983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1JOIh6x8pU16e+KeIxJ3985QnaxQPsUtC1NFDK742A=;
        b=HzunLj0Tp9Yx/cJ44hXvtK6dah0D9EMpbiOMja8MYx1M94m/oTdpDPYrqlo7kp0O/COEmP
        7C28k1OCcx+FnvqbNXLvOZ5V6Jdyczx/e5JroEcpBFJ7EndzeahLeTxZYNFr65w7no4OMf
        UO5YVLbTxUjTobMNrziH+eeHA2B9fns=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-PiWi3hppP3Cg5lTGwCMpHA-1; Tue, 02 Jun 2020 16:32:59 -0400
X-MC-Unique: PiWi3hppP3Cg5lTGwCMpHA-1
Received: by mail-wr1-f70.google.com with SMTP id h6so27731wrx.4
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l1JOIh6x8pU16e+KeIxJ3985QnaxQPsUtC1NFDK742A=;
        b=KNwCCODeQpFggJbgyKeZZzgdiUkFos7xlajYDFebe0GxJg1IeiaCxSPbJ+A2MtrHbb
         2e72vImWmYBjSOFvITRDvmWfnFPHIwkq6lEwx4X7f/qXSaLs7fyjTiYIC1HEGZckYFdj
         FEnLu4ipAJe5Kn8i6Cjts0ttFAGXxHdghjDC9mXs5inCD9NhN07ExWghxXjwtTRM3JSy
         iEwxNr+2XSK1tnJJ94xXPagmxG3wmAlnI4nOvoUPMMw/MXZTGlepAGAYLg7YPO5FreEJ
         DyKNQGpCsUTPgDRFZjRETxrIlhJF1FL7nDF48Zws7qaHRbjOzEGJBdtqQK2AdBAtB3Vs
         7I+A==
X-Gm-Message-State: AOAM531An2jSaa92Wkp8IwzNXDJl8qeGtGRfh1XLXABlpjvlemt8LfEj
        VWPKbgJH5PRQXEiZgbkLMVviQdq5UuaIl0BqyBDhk/LXp3mduGshrdq1dBQxxrVgdN/v1+C3+rA
        zY1m+ahN5JFytVV7e
X-Received: by 2002:a5d:4009:: with SMTP id n9mr8335980wrp.97.1591129978166;
        Tue, 02 Jun 2020 13:32:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxta+duSnnM6Sw6TP8Il90bmNxS0TxUdVpTMsswgIhh7OWkM/g/xNw1APhqHm+S8wMt2yCXQ==
X-Received: by 2002:a5d:4009:: with SMTP id n9mr8335971wrp.97.1591129977909;
        Tue, 02 Jun 2020 13:32:57 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id s132sm10118wmf.12.2020.06.02.13.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:32:57 -0700 (PDT)
Date:   Tue, 2 Jun 2020 16:32:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jason Wang <jasowang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602162931-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
 <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 10:18:09AM -0700, Linus Torvalds wrote:
> On Tue, Jun 2, 2020 at 9:33 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > >
> > > It's not clear whether we need a new API, I think __uaccess_being() has the
> > > assumption that the address has been validated by access_ok().
> >
> > __uaccess_begin() is a stopgap, not a public API.
> 
> Correct. It's just an x86 implementation detail.
> 
> > The problem is real, but "let's add a public API that would do user_access_begin()
> > with access_ok() already done" is no-go.
> 
> Yeah, it's completely pointless.
> 
> The solution to this is easy: remove the incorrect and useless early
> "access_ok()". Boom, done.

Hmm are you sure we can drop it? access_ok is done in the context
of the process. Access itself in the context of a kernel thread
that borrows the same mm. IIUC if the process can be 32 bit
while the kernel is 64 bit, access_ok in the context of the
kernel thread will not DTRT.


> Then use user_access_begin() and the appropriate unsage_get/put_user()
> sequence, and user_access_end().
> 
> The range test that user-access-begin does is not just part of the
> ABI, it's just required in general. We have almost thirty years of
> history of trying to avoid it, AND IT WAS ALL BOGUS.
> 
> The fact is, the range check is pretty damn cheap, and not doing the
> range check has always been a complete and utter disaster.
> 
> You have exactly two cases:
> 
>  (a) the access_ok() would be right above the code and can't be missed
> 
>  (b) not
> 
> and in (a) the solution is: remove the access_ok() and let
> user_access_begin() do the range check.
> 
> In (b), the solution is literally "DON'T DO THAT!"
> 
> Because EVERY SINGLE TIME people have eventually noticed (possibly
> after code movement) that "oops, we never did the access_ok at all,
> and now we can be fooled into kernel corruption and a security issue".
> 
> And even if that didn't happen, the worry was there.
> 
> End result: use user_access_begin() and stop trying to remove the two
> cycles or whatever of the limit checking cost. The "upside" of
> removing that limit check just isn't. It's a downside.
> 
>                  Linus

That's true. Limit check cost is measureable but very small.
It's the speculation barrier that's costly.

-- 
MST

