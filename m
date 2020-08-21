Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6AA24E239
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgHUUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUUqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:46:42 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF06C061573;
        Fri, 21 Aug 2020 13:46:41 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id x6so1230320qvr.8;
        Fri, 21 Aug 2020 13:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vV+k/s6m2cYK6Or6slJCukufA0yDk9LoBcKYwigdeMU=;
        b=eWAQW/CUxo0/w4j37L4bXhh+dcal225cKSaCUJ+8z2iKsaEckrW3NZ4kbBqeeYbvjb
         DXIZpcxlEOHDN13dGk/PE7JUAHAgr7BpDUsUZZBXa3tP1+BsR6sTsfEsLHnnrG2MbbdI
         vPkRkHwJWALPpPUuhPbYtoKDsJa/z+ve2Xfb1icKmWs93Uh6QV+CiE4mKY6wl9HYCjKY
         M4QP1QxMBkvcyLWae6ZPxEv16TgViYRFqh637gQ74pVFxSaiM0t+0/1nBLEeOC+FmogU
         F/L8LyKRyvo/0QvwbUjfLsJ3SDC3I0+/V96ffrBi6wfnD6WpgziRM76Ir6MJnoZa/dYi
         feyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vV+k/s6m2cYK6Or6slJCukufA0yDk9LoBcKYwigdeMU=;
        b=E3Acfh4VD5/Zafvo1uTMd9vsnRpUt3AA1tTLdRSMapoaZ7qt6dtcvLKhddcVtCiK6S
         iAFWiQC3Dng8Z591SdNML4NLrnATHbk5qxZkk5MPy8f/0UoI6YwXQLbmb9l/juT4PfNE
         leu791R+nHGoSOSHqmWxzEdRDcTzfDv/D7N8vocUuqPk3xi2fvAPBbIHSohoQfwvomT6
         pcNEXQgQeekQIfRr8c1+Nk/MbTfDQG3Q7pAw1RlMq5F4NQ4vjCNDGP8Uwz2xcQ9CXscw
         XWlaPEc5Xj5yf+GYn9U3z0bl9WSR5pZniT48gl0odCA/l74Ax3CBnhkjoqYqLKh/+qF9
         u8IQ==
X-Gm-Message-State: AOAM533EX8y5g53NOk+XbI6rIFqRePv1boZZjjwtxZbM/ZERv4AFCHV9
        dWsDIPM5MOp2V7f9RGitKB8UglhWcHwwjw==
X-Google-Smtp-Source: ABdhPJzo6BAtdzOVMor6tpwE9cFwqAf1ddQAXmbXZKOhZVzQ39UTiWVsq6zF1Xb4QbOCQG1wAy+pNA==
X-Received: by 2002:a05:6214:2a4:: with SMTP id m4mr4201102qvv.120.1598042799369;
        Fri, 21 Aug 2020 13:46:39 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.246])
        by smtp.gmail.com with ESMTPSA id j72sm2562377qke.20.2020.08.21.13.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:46:38 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4EFA5C35FC; Fri, 21 Aug 2020 17:46:36 -0300 (-03)
Date:   Fri, 21 Aug 2020 17:46:36 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Re: Use of genradix in sctp
Message-ID: <20200821204636.GO3399@localhost.localdomain>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
 <20200818213800.GJ906397@localhost.localdomain>
 <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 08:18:50AM +0000, David Laight wrote:
> From:'Marcelo Ricardo Leitner
> > Sent: 18 August 2020 22:38
> > 
> > On Tue, Aug 18, 2020 at 03:38:09PM +0000, David Laight wrote:
> > > A few years ago (for 5.1) the 'arrays' that sctp uses for
> > > info about data streams was changed to use the 'genradix'
> > > functions.
> > >
> > > I'm not sure of the reason for the change, but I don't
> > > thing anyone looked at the performance implications.
> > 
> > I don't have something like a CI for it, but I do run some performance
> > benchmarks every now and then and it didn't trigger anything
> > noticeable in my tests.
> 
> We have some customers who we think are sending 10000+ short
> SCTP data chunks a second.
> They are probably sending SMS messages, so that is 5000+ text
> messages a second!
> It is hard to stop those being sent with more than one
> data chunk in each ethernet frame!

Thanks for this info.

> 
> > Yet, can it be improved? Certainly. Patches welcomed. :-)
> 
> I'll apply some of my copious free time to it...
> Actually some simple changes would help:
> 
> 1) Change SCTP_SO()->x to so=SCTP_SO(); so->x in places
>    where there are multiple references to the same stream.

Agree. This is an easy change, mostly just mechanical.

> 
> 2) Optimise the genradix lookup for the case where there
>    is a single page - it can be completely inlined.

And/or our struct sizes.

__idx_to_offset() will basically do:
        if (!is_power_of_2(obj_size)) {
                return (idx / objs_per_page) * PAGE_SIZE +
                        (idx % objs_per_page) * obj_size;
        } else {
                return idx * obj_size;

if we can get it to his the else block, it saves some CPU cycles already (at
the expense of memory).

> 
> 3) Defer the allocation until the stream is used.
>    for outbound streams this could remove the extra buffer.

This can be tricky. What should happen if it gets a packet on a stream
that it couldn't allocate, and then another on a stream that was
already allocated? Just a drop, it will retransmit and recover, and
then again.. While, OTOH, if the application requested such amount of
streams, it is likely going to use it. If not, that's an application
bug.

...
> > > For example look at the object code for sctp_stream_clear()
> > > (__genradix_ptr() is in lib/generic-radix-tree.c).
> > 
> > sctp_stream_clear() is rarely called.
> > 
> > Caller graph:
> > sctp_stream_clear
> >   sctp_assoc_update
> >     SCTP_CMD_UPDATE_ASSOC
> >       sctp_sf_do_dupcook_b
> >       sctp_sf_do_dupcook_a
> > 
> > So, well, I'm not worried about it.
> 
> I wasn't considering the loop.
> It was just a place where the object code can be looked at.
> 
> But there are quite a few places where the same stream
> is looked for lots of times in succession.
> Even saving the pointer is probably noticeable.

Yes.

> 
> > Specs say 64k streams, so we should support that and preferrably
> > without major regressions. Traversing 64k elements each time to find
> > an entry is very not performant.
> > 
> > For a more standard use case, with something like you were saying, 17
> > streams, genradix here doesn't use too much memory. I'm afraid a
> > couple of integer calculations to get an offset is minimal overhead if
> > compared to the rest of the code.
> 
> It is probably nearer 40 including a function call - which
> is likely to cause register spills.
> 
> > For example, the stream scheduler
> > operations, accessed via struct sctp_sched_ops (due to retpoline), is
> > probably more interesting fixing than genradix effects here.
> 
> Hmmm... the most scheduling M3UA/M2PA (etc) want is (probably)
> to send stream 0 first.
> But even the use of stream 0 (for non-data messages) is a
> misunderstanding (of my understanding) of what SCTP streams are.
> IIRC there is only one flow control window.

Only one window, yes, but now we have a more fine grained control on
how it is used:

> I thought that tx data just got added to a single tx queue,
> and the multiple streams just allowed some messages to passed
> on to the receiving application while waiting for retransmissions
> (head of line blocking).

That was before stream schedulers.
https://developers.redhat.com/blog/2018/01/03/sctp-stream-schedulers/
https://tools.ietf.org/html/rfc8260

> 
> OTOH M2PA seems to wand stream 0 to have the semantics of
> ISO transport 'expedited data' - which can be sent even when
> the main flow is blocked because it has its own credit (of 1).

That is now doable with the stream schedulers.

But note that even if you don't enable it, you're paying a price
already due to function pointers on struct sctp_sched_ops, which are
used even if you use the standard scheduler (FCFS, First Come First
Served).  In there, it should start using the indirect call wrappers,
such as INDIRECT_CALL_3. After all, they are always compiled in,
anyway.
