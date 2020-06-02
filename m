Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E5C1EC0D4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgFBRSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:18:30 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42879C05BD1E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 10:18:29 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z18so13495924lji.12
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 10:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SNRBsgEhndaWfJkwxqUhFkYrHA7Z2jK8v+SKAjBpMrw=;
        b=cHeKntEgM3HiICfht/pnCtDkCgAraRt+vGaiFUa0rbQQRGNJUmWfN31GQWT3/8Ltqs
         xGyw9NW6GGE0qRN1zYrj5A1Lp+0See6177U9da0iJoS/+M/e7Y5lNanIyNFQmxAWsbyv
         Eqfz4HZv3uqTzo08M9Ioc36wztuAz4V5eRnsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SNRBsgEhndaWfJkwxqUhFkYrHA7Z2jK8v+SKAjBpMrw=;
        b=Wl4D3mWvyOc3VP4HBW3GhaGOECFrQQz/CDXRWq6w/TRdVLscCokpd1o7CRe4SbGWNu
         GedcgHpyOG+u3s6DV5JpV1HDROyYAxWH9rrWaSweD2FGYgAgk6Y4e5IjBHjZDvL1mJEh
         +VRH17N2k0Rqi47f/Z9JG23XCP+8aBksmxgLw0E/yIqCQ2WXtGl05ArfszXhqNh+wiaP
         ZUkSnqWt9XCUgT3WIh/nVN907SZJNiDOFNVvCbfkNzOlYRhUXGRHcgrNZuZ7r1KaqnzY
         tONCsye9wqtkYK8geOSwL0WJIwfk8RqIRQ342pkobtCByzqEuZJ+cIJme3hJm+5SQ2ma
         TGxw==
X-Gm-Message-State: AOAM531Sj5bjB8gGmTvCsMaslrgDgjmziHMqaceaZ8roFT/Ctbn8QsmX
        0uy4OKQZ2+XfVfL4YNbSgOvv7Jl+i3k=
X-Google-Smtp-Source: ABdhPJyV9EMKJs7+VtVQZzX1DCH2zxLJYF9SFGtcM0tZwDj+VR6zh8BU34OtNVoDm6QJ+Um4RnXYOA==
X-Received: by 2002:a05:651c:82:: with SMTP id 2mr63881ljq.341.1591118307200;
        Tue, 02 Jun 2020 10:18:27 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id 205sm833109lfe.73.2020.06.02.10.18.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 10:18:26 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id e125so6668211lfd.1
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 10:18:25 -0700 (PDT)
X-Received: by 2002:ac2:504e:: with SMTP id a14mr235578lfm.30.1591118305358;
 Tue, 02 Jun 2020 10:18:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200602084257.134555-1-mst@redhat.com> <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
In-Reply-To: <20200602163306.GM23230@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Jun 2020 10:18:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
Message-ID: <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 9:33 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> >
> > It's not clear whether we need a new API, I think __uaccess_being() has the
> > assumption that the address has been validated by access_ok().
>
> __uaccess_begin() is a stopgap, not a public API.

Correct. It's just an x86 implementation detail.

> The problem is real, but "let's add a public API that would do user_access_begin()
> with access_ok() already done" is no-go.

Yeah, it's completely pointless.

The solution to this is easy: remove the incorrect and useless early
"access_ok()". Boom, done.

Then use user_access_begin() and the appropriate unsage_get/put_user()
sequence, and user_access_end().

The range test that user-access-begin does is not just part of the
ABI, it's just required in general. We have almost thirty years of
history of trying to avoid it, AND IT WAS ALL BOGUS.

The fact is, the range check is pretty damn cheap, and not doing the
range check has always been a complete and utter disaster.

You have exactly two cases:

 (a) the access_ok() would be right above the code and can't be missed

 (b) not

and in (a) the solution is: remove the access_ok() and let
user_access_begin() do the range check.

In (b), the solution is literally "DON'T DO THAT!"

Because EVERY SINGLE TIME people have eventually noticed (possibly
after code movement) that "oops, we never did the access_ok at all,
and now we can be fooled into kernel corruption and a security issue".

And even if that didn't happen, the worry was there.

End result: use user_access_begin() and stop trying to remove the two
cycles or whatever of the limit checking cost. The "upside" of
removing that limit check just isn't. It's a downside.

                 Linus
