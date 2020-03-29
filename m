Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670CE196ACD
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 05:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgC2DR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 23:17:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35856 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgC2DR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 23:17:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id i7so11749980edq.3
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 20:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73jM7UJ1SiInp3qgWBqwVopBoGUW8da3yGoLPO2s510=;
        b=hUOW7wlGLFSvtHFZFzYEk7uCZM0H4qRyVG1Nq3cJ6E529xu/itB2Sw5XZwbQ+u0atq
         IyUnfYEn/D0SlrwCk47/eOrsUScgL3N5AGSU1dSkADlcDK/uKgu0oxbrZ7a+4AuMZ3/i
         u+eRvLFW/3YH6/NomvPTj4lTDuRjf4b8+lzYhV5sdgOcQV5z633Ayp/5ldFb0ouvIGof
         /UFc5isFg/YJtxKJ3Lma2Q7GC1+Cogl7V2tEkB04nQPioaCwIH+ECkq5ZE4XVZ6Ih5Vv
         wIA1iofcg4YPsZ2gIQ5fdRfyxTKX/BpU+PLevB4xhg1RS674R3j7mNprN6l2A7i+2HnX
         C7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73jM7UJ1SiInp3qgWBqwVopBoGUW8da3yGoLPO2s510=;
        b=b9Jh9/VRfSpfffxPBul875UWnnG4AopHP4Jx5ZSf5MIuOgjl52gz30t1oEdkQMX/Tg
         /zC3vdMiqgoDOLb+h0GeZVHu1gT+7KI47/mCygstYdKKJ8CWRCR/PDYqg5k88+/g/HTg
         YFNBAQya3TKRcpyt32O7OMxpVFZEs8teQSgbIUaHy6OeyP70Xf48hcCAxriNZfaaa2uQ
         /8OFOcaVhiP7anWYdv3WIglHT5SaWISB1grJhbhdE18sb2STg4U64q28P2enwU/3l4e+
         N+WRlxiSxTn134+/L5DEFSts9ulLcfcNl7uX+zcQuPyvGfzxmbxrAfLAC8Ba4jeKqPV/
         t20g==
X-Gm-Message-State: ANhLgQ2l7f1MZvitI8c6fZxOI+H4thVYJ8+jr/VlfXWsQDzorP+x1+is
        O61g66nLCXdlDGRwX96BFRifAjrARJJiwoNlz++C
X-Google-Smtp-Source: ADFU+vv/MFU+PUL6L3fWaCWJ+SsYWlwfM5jrj3x9inQIKOJr3keTEJ5GXU9ljVx28Cw+08JkBWPGuLw/MRT/qz+R/UQ=
X-Received: by 2002:aa7:d2cb:: with SMTP id k11mr6032886edr.128.1585451846873;
 Sat, 28 Mar 2020 20:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca> <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
 <20200313192306.wxey3wn2h4htpccm@madcap2.tricolour.ca> <CAHC9VhQKOpVWxDg-tWuCWV22QRu8P_NpFKme==0Ot1RQKa_DWA@mail.gmail.com>
 <20200318214154.ycxy5dl4pxno6fvi@madcap2.tricolour.ca> <CAHC9VhSuMnd3-ci2Bx-xJ0yscQ=X8ZqFAcNPKpbh_ZWN3FJcuQ@mail.gmail.com>
 <20200319214759.qgxt2sfkmd6srdol@madcap2.tricolour.ca> <CAHC9VhTp25OAaTO5UMft0OzUZ=oQpZFjebkjjQP0-NrPp0bNAg@mail.gmail.com>
 <20200325122903.obkpyog7fjabzrpf@madcap2.tricolour.ca>
In-Reply-To: <20200325122903.obkpyog7fjabzrpf@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 28 Mar 2020 23:17:15 -0400
Message-ID: <CAHC9VhTuYYqAtoNAKLX3qja6DnqEbFuHchi9ESwbcb5WC_Mvtw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 8:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-20 17:56, Paul Moore wrote:
> > On Thu, Mar 19, 2020 at 5:48 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-18 17:47, Paul Moore wrote:
> > > > On Wed, Mar 18, 2020 at 5:42 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-03-18 17:01, Paul Moore wrote:
> > > > > > On Fri, Mar 13, 2020 at 3:23 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > On 2020-03-13 12:42, Paul Moore wrote:
> > > > > >
> > > > > > ...
> > > > > >
> > > > > > > > The thread has had a lot of starts/stops, so I may be repeating a
> > > > > > > > previous suggestion, but one idea would be to still emit a "death
> > > > > > > > record" when the final task in the audit container ID does die, but
> > > > > > > > block the particular audit container ID from reuse until it the
> > > > > > > > SIGNAL2 info has been reported.  This gives us the timely ACID death
> > > > > > > > notification while still preventing confusion and ambiguity caused by
> > > > > > > > potentially reusing the ACID before the SIGNAL2 record has been sent;
> > > > > > > > there is a small nit about the ACID being present in the SIGNAL2
> > > > > > > > *after* its death, but I think that can be easily explained and
> > > > > > > > understood by admins.
> > > > > > >
> > > > > > > Thinking quickly about possible technical solutions to this, maybe it
> > > > > > > makes sense to have two counters on a contobj so that we know when the
> > > > > > > last process in that container exits and can issue the death
> > > > > > > certificate, but we still block reuse of it until all further references
> > > > > > > to it have been resolved.  This will likely also make it possible to
> > > > > > > report the full contid chain in SIGNAL2 records.  This will eliminate
> > > > > > > some of the issues we are discussing with regards to passing a contobj
> > > > > > > vs a contid to the audit_log_contid function, but won't eliminate them
> > > > > > > all because there are still some contids that won't have an object
> > > > > > > associated with them to make it impossible to look them up in the
> > > > > > > contobj lists.
> > > > > >
> > > > > > I'm not sure you need a full second counter, I imagine a simple flag
> > > > > > would be okay.  I think you just something to indicate that this ACID
> > > > > > object is marked as "dead" but it still being held for sanity reasons
> > > > > > and should not be reused.
> > > > >
> > > > > Ok, I see your point.  This refcount can be changed to a flag easily
> > > > > enough without change to the api if we can be sure that more than one
> > > > > signal can't be delivered to the audit daemon *and* collected by sig2.
> > > > > I'll have a more careful look at the audit daemon code to see if I can
> > > > > determine this.
> > > >
> > > > Maybe I'm not understanding your concern, but this isn't really
> > > > different than any of the other things we track for the auditd signal
> > > > sender, right?  If we are worried about multiple signals being sent
> > > > then it applies to everything, not just the audit container ID.
> > >
> > > Yes, you are right.  In all other cases the information is simply
> > > overwritten.  In the case of the audit container identifier any
> > > previous value is put before a new one is referenced, so only the last
> > > signal is kept.  So, we only need a flag.  Does a flag implemented with
> > > a rcu-protected refcount sound reasonable to you?
> >
> > Well, if I recall correctly you still need to fix the locking in this
> > patchset so until we see what that looks like it is hard to say for
> > certain.  Just make sure that the flag is somehow protected from
> > races; it is probably a lot like the "valid" flags you sometimes see
> > with RCU protected lists.
>
> This is like looking for a needle in a haystack.  Can you point me to
> some code that does "valid" flags with RCU protected lists.

Sigh.  Come on Richard, you've been playing in the kernel for some
time now.  I can't think of one off the top of my head as I write
this, but there are several resources that deal with RCU protected
lists in the kernel, Google is your friend and Documentation/RCU is
your friend.

Spending time to learn how RCU works and how to use it properly is not
time wasted.  It's a tricky thing to get right (I have to refresh my
memory on some of the more subtle details each time I write/review RCU
code), but it's very cool when done correctly.

-- 
paul moore
www.paul-moore.com
