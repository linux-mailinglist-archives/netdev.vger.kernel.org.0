Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75984196AC1
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 05:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgC2DLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 23:11:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43854 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgC2DLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 23:11:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id bd14so16644601edb.10
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 20:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCNJAUmnzDN9FZcZL525t31JITbaUoqdlbI+Ngrcb2Q=;
        b=m1tGNjwy+SOvZqLF6fO17u3ClF2d67j8aXHoHY1dw1Akc1hbsGxDZMYPC2VBMObQfV
         ova0wmjBzwcmQkBSnqv1BIYenDPMnjgFm5l+U579QF6Ziw8gRaW1IHMK5R1Rkqof/jk0
         k02MdWhDxlczwjxkzuy/MjRfDqDVz1w8DE1pf8DCkRBRStH3S/Cj8rVhzHPa6zewSMbN
         41OZmsDyXigpVVvfjIF7+bCqUWin8T2D0rE08sf8lEvHTDizePb4Hxf11vCqV7lbLwlN
         nyaZ+aCdVU80g51lvj3HKJl/l7o6U5YZsi89i6/CssH3Nr+hTKMar4D17vXJEeLcmBTm
         ScOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCNJAUmnzDN9FZcZL525t31JITbaUoqdlbI+Ngrcb2Q=;
        b=aRNSzn/qbkBudBRuscEv11tQPhRA4LzemB0jTg1B/4Zf1xS7Z2D+OYPgsHtK9WgNfV
         lBqWUox7srcd3FhEsY2rBmUuVlr4VMIK+Q5tjhErPByzSQ7zWH5YJcIjKIrmU/Z1HhUM
         UirqxZ+SdbXqGOZeM6dt+2ResSjpNgG0HKAVBlQPwHxjCmJ3Wh6Tdacx0MrVdUezeX/L
         Sf8Am1HwSZtT+orlRY1Adb2BlGweKNHR8X5BVkfoXxprp5CmYiBC9DciFkN+SuFNJyUy
         ZK7Q33dsq6wjrPAH66Y9UOORjy2iU5X4IIp2BZ01m1Gj9BuLqQKWFLHpapk7hJTZjiW6
         e80A==
X-Gm-Message-State: ANhLgQ10ilunUBQNMmw0KyAT7q8uC3XJbtNnaVZRvySR6fDm27uGg1MU
        X/BQiP15dThnwzR1ERe5rlzGnxCVIKsbfbveBI1Y
X-Google-Smtp-Source: ADFU+vsO3z8fR85BdzrdW8wO5Ic5j66UK7NtBXWnojiKMj/pMltL8hW55ibXGgej7CzgWStIAOOuND+xZVVbglX1ybU=
X-Received: by 2002:a17:906:1993:: with SMTP id g19mr5774145ejd.70.1585451512568;
 Sat, 28 Mar 2020 20:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200312193037.2tb5f53yeisfq4ta@madcap2.tricolour.ca>
 <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
 <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca> <CAHC9VhR2zCCE5bjH75rSwfLC7TJGFj4RBnrtcOoUiqVp9q5TaA@mail.gmail.com>
 <20200318212630.mw2geg4ykhnbtr3k@madcap2.tricolour.ca> <CAHC9VhRYvGAru3aOMwWKCCWDktS+2pGr+=vV4SjHW_0yewD98A@mail.gmail.com>
 <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca> <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
 <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca> <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
 <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca>
In-Reply-To: <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 28 Mar 2020 23:11:41 -0400
Message-ID: <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-23 20:16, Paul Moore wrote:
> > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-18 18:06, Paul Moore wrote:
> >
> > ...
> >
> > > > I hope we can do better than string manipulations in the kernel.  I'd
> > > > much rather defer generating the ACID list (if possible), than
> > > > generating a list only to keep copying and editing it as the record is
> > > > sent.
> > >
> > > At the moment we are stuck with a string-only format.
> >
> > Yes, we are.  That is another topic, and another set of changes I've
> > been deferring so as to not disrupt the audit container ID work.
> >
> > I was thinking of what we do inside the kernel between when the record
> > triggering event happens and when we actually emit the record to
> > userspace.  Perhaps we collect the ACID information while the event is
> > occurring, but we defer generating the record until later when we have
> > a better understanding of what should be included in the ACID list.
> > It is somewhat similar (but obviously different) to what we do for
> > PATH records (we collect the pathname info when the path is being
> > resolved).
>
> Ok, now I understand your concern.
>
> In the case of NETFILTER_PKT records, the CONTAINER_ID record is the
> only other possible record and they are generated at the same time with
> a local context.
>
> In the case of any event involving a syscall, that CONTAINER_ID record
> is generated at the time of the rest of the event record generation at
> syscall exit.
>
> The others are only generated when needed, such as the sig2 reply.
>
> We generally just store the contobj pointer until we actually generate
> the CONTAINER_ID (or CONTAINER_OP) record.

Perhaps I'm remembering your latest spin of these patches incorrectly,
but there is still a big gap between when the record is generated and
when it is sent up to the audit daemon.  Most importantly in that gap
is the whole big queue/multicast/unicast mess.

You don't need to show me code, but I would like to see some sort of
plan for dealing with multiple nested audit daemons.  Basically I just
want to make sure we aren't painting ourselves into a corner with this
approach; and if for some horrible reason we are, I at least want us
to be aware of what we are getting ourselves into.

-- 
paul moore
www.paul-moore.com
