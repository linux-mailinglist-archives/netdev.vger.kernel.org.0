Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D218D296
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCTPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:13:01 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:43403 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgCTPM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:12:58 -0400
Received: by mail-oi1-f174.google.com with SMTP id p125so6790631oif.10
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lakkRVPgutY0AF3sqGIgV2JNUBsA85UrHquoYSV0MIA=;
        b=ON1x6OxRLLz4qWPJjXk9OK7G03nXX+FSp9wf3XXWabnll2HLXRRpytcat9E9QLEz/9
         2/qHEh9ubJRn15oBgAaccouwdo7N+C3eO4Hmfc+0lIZ/RqUZNpsYRQgB+Z9nJ4+QCjzj
         LWDIb3nWzdttR4Q/pO81nz1JuRN7Kp/OAWFIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lakkRVPgutY0AF3sqGIgV2JNUBsA85UrHquoYSV0MIA=;
        b=uXixHHEbt0jGH4jdsuKTemRCJ6WXPo0u0vGHfuYbeTMI/QBkAie6jVU5QAHt0dB85b
         wM9Emgp7Ix2R278AZZocqPd0FMiEu0KNkTM5cGjJsTxAU9TcKcGdg18VDNhKHtPT7/y9
         IvjtR+GlsmfkQcnq2QdMM8pjUAza7pOrHgOEmo//XnK718TG1QEaKrpCW2T4MI5xA8VM
         GIR3aeIpaOWo3hSEGF0MHfYVBzpv3emV46gIWQ/KWoddlQfZ+hZ4CBpbWQloqsjna/9x
         KB97rxDrlpVaHLU8dXM4MUXGnBzlPLxu6u5u5GOVscn+JZLz0uWT2X5xiB8p9Tp36BOW
         Id/A==
X-Gm-Message-State: ANhLgQ0IkmeJGWFfy6ZzdGajTB3zJwvgGybR5b1+I07YjnMxxS2zW1HY
        kt51hYHOD/9ftGnjCtuV5Sq0jYpWbj+ds9Mbh5feQA==
X-Google-Smtp-Source: ADFU+vu1MxXZ2KwiLfOP51fB7zuMESQ1qEuVah2RXWu6rGBuvlwcqMwZsdrduC2xfy0rKb97jKCqHLA3UiCv2q08oKg=
X-Received: by 2002:aca:b60a:: with SMTP id g10mr6673637oif.102.1584717177616;
 Fri, 20 Mar 2020 08:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
 <20200312175828.xenznhgituyi25kj@ast-mbp> <CACAyw98cp2we2w_L=YgEj+BbCqA5_3HvSML1VZzyNeF8mVfEEQ@mail.gmail.com>
 <20200314025832.3ffdgkva65dseoec@ast-mbp.dhcp.thefacebook.com>
 <CACAyw99HC70=wYBzZAiQVyUi56y_0x-6saGkp_KHBpjQuva1KA@mail.gmail.com> <5e711f6ed4f6c_278b2b1b264c65b4bd@john-XPS-13-9370.notmuch>
In-Reply-To: <5e711f6ed4f6c_278b2b1b264c65b4bd@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 20 Mar 2020 15:12:44 +0000
Message-ID: <CACAyw9_J2Nc74hA6tQrWrvQ1Q61994YRaQUPu_2=rKYr9LUFYQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 at 19:05, John Fastabend <john.fastabend@gmail.com> wrote:
>
> Lorenz Bauer wrote:
> > On Sat, 14 Mar 2020 at 02:58, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > I'm not following. There is skb->sk. Why do you need to lookup sk ? Because
> > > your hook is before demux and skb->sk is not set? Then move your hook to after?
> > >
> > > I think we're arguing in circles because in this thread I haven't seen the
> > > explanation of the problem you're trying to solve. We argued about your
> > > proposed solution and got stuck. Can we restart from the beginning with all
> > > details?
> >
> > Yes, that's a good idea. I mentioned this in passing in my cover
> > letter, but should
> > have provided more context.
> >
> > Jakub is working on a patch series to add a BPF hook to socket dispatch [1] aka
> > the inet_lookup function. The core idea is to control skb->sk via a BPF program.
> > Hence, we can't use skb->sk.
> >
> > Introducing this hook poses another problem: we need to get the struct sk from
> > somewhere. The canonical way in BPF is to use the lookup_sk helpers. Of course
> > that doesn't work, since our hook would invoke itself. So we need a
> > data structure
> > that can hold sockets, to be used by programs attached on the new hook.
> >
> > Jakub's RFC patch set used REUSEPORT_SOCKARRAY for this. During LPC '19
> > we got feedback that sockmap is probably the better choice. As a
> > result, Jakub started
> > working on extending sockmap TCP support and after a while I joined to add UDP.
> >
> > Now, we are looking at what our control plane could look like. Based
> > on the inet-tool
> > work that Marek Majkowski has done [2], we currently have the following set up:
> >
> > * An LPM map that goes from IP prefix and port to an index in a sockmap
>
> As an aside we could do a LPM version of sockmap to avoid the extra lookup,
> but thats just an optimization for later.
>
> > * A sockmap that holds sockets
> > * A BPF program that performs the business logic
> >
> > inet-tool is used to update the two maps to add and remove mappings on the fly.
> > Essentially, services donate their sockets either via fork+exec or SCM_RIGHTS on
> > a Unix socket.
>
> This looks a lot like one of the LBs we prototyped early on.
>
> >
> > Once we have inserted a socket in the sockmap, it's not possible to
> > retrieve it again.
> > This makes it impossible to change the position of a socket in the
> > map, to resize the
> > map, etc. with our current design.
>
> Is it fair to say then that you don't actually need/care about the fd it
> just happens to be something stable you could grab relatively easy from
> the sockmap side and push back at a sockmap?

I think that falls a bit short. I'd like to have an fd because it is the
user space representation of a socket. I can do useful things like get
the address
family, etc. from it. I can use this to provide meaningful semantics
to users: you can't redirect UDP traffic into a SOCK_STREAM, etc.

So, we'd definitely have to add some sort of getsockopt wrapper for this
bpf sock, which sounds kind of complex?

>
> >
> > One way to work around this is to add a persistent component to our
> > control plane:
> > a process can hold on to the sockets and re-build the map when necessary. The
> > downsides are that upgrading the service is non-trivial (since we need
> > to pass the
> > socket fds) and that a failure of this service is catastrophic. Once
> > it happens, we
> > probably have to reboot the machine to get it into a workable state again.
>
> Agreed this is not a good place to be in. We use the kernel maps for
> persistence in many cases today, such as updates or when the application
> crashes we have the nice property that the datapath keeps working without
> interruption.
>
> >
> > We'd like to avoid a persistent service if we can. By allowing to look
> > up fds from the
> > sockmap, we could make this part of our control plane more robust.
> >
> > 1: https://www.youtube.com/watch?v=qRDoUpqvYjY
> > 2: https://github.com/majek/inet-tool
> >
> > I hope this explanation helps, sorry for not being more thorough in the original
> > cover letter!
>
> Helps a lot for me at least.
>
> So instead of fd how about,
>
>   sock_map_lookup returns bpf_sock
>   sock_map_update can consume an fd or a bpf_sock
>
> Userland can do a dump of the sock_map then get a set of bpf_socks and
> push them into another map via updates. Nothing too special compared
> to other maps. In cilium for example I could plug this into our normal
> flows and we would get rid of the current corner case where upgrades
> and crashes lose sockmap state.

I thought that bpf_sock is just used to document the BPF UAPI? How
would you turn this into a refcountable thing?

>
> The update hooks in sock_map already know how to deal with socks so
> the trick would be to do the lookup from bpf_sock to a real sock. For
> that I think we can just use sk_lookup(). Maybe bpf_sock needs to
> additionally include the cookie? Including the cookie in bpf_sock
> seems generally useful as well. I would probably use it outside
> of sock_map for example.
>
> Thoughts? I think it helps with Alexei's concern around passing fds.

I like that it's a tangible way forward, but I'm worried that adding a
new "thing"
that's kind of like a socket (but not really) is going to be quite complex.

Another way around this might be to add a way to go from socket cookie to
socket, and not touch sockmap. I suspect that is an even steeper hill to climb,
especially if it means adding a new syscall.

Thank you for your thoughts, I'll need to go and ruminate on this some more.
Specifically I'll flesh out the control plane some more, which should help me
get a more focused understanding of what I need.




>
> >
> > Lorenz
> >
> > --
> > Lorenz Bauer  |  Systems Engineer
> > 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> >
> > www.cloudflare.com
>
>


--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
