Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369D6188DA1
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgCQTFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:05:30 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36617 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQTFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:05:30 -0400
Received: by mail-pj1-f66.google.com with SMTP id nu11so162433pjb.1;
        Tue, 17 Mar 2020 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mR70FuQlYB9p0LGu/+wJW26xgkL11ZAV5W8jEU2CIck=;
        b=dEsWQ4reg80pUPoczuuccHPEI6VeK552NiUAgat4jNqF54saxhDsbujzaoEkqRx8Ug
         osdjFBxpzApzsd1Kuv3nxf3fym7Io4/wOVH602BsJoLuZk/Kr7qo1v9GT4vP2uMkpSLS
         iEw2QB9D/AJbTa6cE1+2Q978Xba0EmGNzgsw8Q2muCSWdcc5hHG6fEvmq6COZfI2OXpE
         AJoUJWuxHBhWbFfVnCLkpVWMbm0v748km7EwVS5RAw9fPvuQ23KcmySSejgyAntpptVF
         UYqvMEFqY5XnpeGXeFtN0OZpW1see0STeohv1A6/6/a5FW8sdE20HKm3t1t4C+wuMg4Q
         8HaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mR70FuQlYB9p0LGu/+wJW26xgkL11ZAV5W8jEU2CIck=;
        b=akhDqEXGmc5blDl3EzMiB+p/uUtVbIXnAXMGFFuB3WoFHb+3y3iU39n6hX4KulQmqp
         bstcK9G3jAjOnrTpfSUOOvQFj0E6zvO/muj8vOKCu0ypqqxDgOs0LXAU8jN6Q5J+9AmW
         SsuR0IsulNvR5zgUHYRPMzmNZ69IBiFfEglaWthfxXc2BqsK6+7ayPD1y5uzh6Dpa3Fr
         5ZYK1YLd+rV7iN7cywsvQ3biuqSNiXrGNxYp8AcdVS4Fq6bh87MuGTRJsJ++aTabF4dY
         i5Ke6V5DRllo30P1MMUJnUx3NDbP/4CUyQxdIb5nbjI8mvIbpr3HPzPrStDPPgPdRtVI
         wUvw==
X-Gm-Message-State: ANhLgQ1F+HKZp7MkaPtYsKe/Wphv3fTczZ1zKr7aVsScnNx2egau8kf4
        BUIYLsYoY6AnroLfT4SmXD8=
X-Google-Smtp-Source: ADFU+vuUGu7kLGg2YJEbi1tQMiQzQcyNio8K2B/8GOcQDUEpUv6R5hRSPLhshrOve0IcfgI4+Ygm6g==
X-Received: by 2002:a17:902:bd83:: with SMTP id q3mr93083pls.289.1584471928275;
        Tue, 17 Mar 2020 12:05:28 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e14sm3886907pfn.196.2020.03.17.12.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:05:27 -0700 (PDT)
Date:   Tue, 17 Mar 2020 12:05:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <5e711f6ed4f6c_278b2b1b264c65b4bd@john-XPS-13-9370.notmuch>
In-Reply-To: <CACAyw99HC70=wYBzZAiQVyUi56y_0x-6saGkp_KHBpjQuva1KA@mail.gmail.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
 <20200312175828.xenznhgituyi25kj@ast-mbp>
 <CACAyw98cp2we2w_L=YgEj+BbCqA5_3HvSML1VZzyNeF8mVfEEQ@mail.gmail.com>
 <20200314025832.3ffdgkva65dseoec@ast-mbp.dhcp.thefacebook.com>
 <CACAyw99HC70=wYBzZAiQVyUi56y_0x-6saGkp_KHBpjQuva1KA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> On Sat, 14 Mar 2020 at 02:58, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > I'm not following. There is skb->sk. Why do you need to lookup sk ? Because
> > your hook is before demux and skb->sk is not set? Then move your hook to after?
> >
> > I think we're arguing in circles because in this thread I haven't seen the
> > explanation of the problem you're trying to solve. We argued about your
> > proposed solution and got stuck. Can we restart from the beginning with all
> > details?
> 
> Yes, that's a good idea. I mentioned this in passing in my cover
> letter, but should
> have provided more context.
> 
> Jakub is working on a patch series to add a BPF hook to socket dispatch [1] aka
> the inet_lookup function. The core idea is to control skb->sk via a BPF program.
> Hence, we can't use skb->sk.
> 
> Introducing this hook poses another problem: we need to get the struct sk from
> somewhere. The canonical way in BPF is to use the lookup_sk helpers. Of course
> that doesn't work, since our hook would invoke itself. So we need a
> data structure
> that can hold sockets, to be used by programs attached on the new hook.
> 
> Jakub's RFC patch set used REUSEPORT_SOCKARRAY for this. During LPC '19
> we got feedback that sockmap is probably the better choice. As a
> result, Jakub started
> working on extending sockmap TCP support and after a while I joined to add UDP.
> 
> Now, we are looking at what our control plane could look like. Based
> on the inet-tool
> work that Marek Majkowski has done [2], we currently have the following set up:
> 
> * An LPM map that goes from IP prefix and port to an index in a sockmap

As an aside we could do a LPM version of sockmap to avoid the extra lookup,
but thats just an optimization for later.

> * A sockmap that holds sockets
> * A BPF program that performs the business logic
> 
> inet-tool is used to update the two maps to add and remove mappings on the fly.
> Essentially, services donate their sockets either via fork+exec or SCM_RIGHTS on
> a Unix socket.

This looks a lot like one of the LBs we prototyped early on.

> 
> Once we have inserted a socket in the sockmap, it's not possible to
> retrieve it again.
> This makes it impossible to change the position of a socket in the
> map, to resize the
> map, etc. with our current design.

Is it fair to say then that you don't actually need/care about the fd it
just happens to be something stable you could grab relatively easy from
the sockmap side and push back at a sockmap?

> 
> One way to work around this is to add a persistent component to our
> control plane:
> a process can hold on to the sockets and re-build the map when necessary. The
> downsides are that upgrading the service is non-trivial (since we need
> to pass the
> socket fds) and that a failure of this service is catastrophic. Once
> it happens, we
> probably have to reboot the machine to get it into a workable state again.

Agreed this is not a good place to be in. We use the kernel maps for
persistence in many cases today, such as updates or when the application
crashes we have the nice property that the datapath keeps working without
interruption. 

> 
> We'd like to avoid a persistent service if we can. By allowing to look
> up fds from the
> sockmap, we could make this part of our control plane more robust.
> 
> 1: https://www.youtube.com/watch?v=qRDoUpqvYjY
> 2: https://github.com/majek/inet-tool
> 
> I hope this explanation helps, sorry for not being more thorough in the original
> cover letter!

Helps a lot for me at least.

So instead of fd how about,

  sock_map_lookup returns bpf_sock
  sock_map_update can consume an fd or a bpf_sock

Userland can do a dump of the sock_map then get a set of bpf_socks and
push them into another map via updates. Nothing too special compared
to other maps. In cilium for example I could plug this into our normal
flows and we would get rid of the current corner case where upgrades
and crashes lose sockmap state.

The update hooks in sock_map already know how to deal with socks so
the trick would be to do the lookup from bpf_sock to a real sock. For
that I think we can just use sk_lookup(). Maybe bpf_sock needs to
additionally include the cookie? Including the cookie in bpf_sock
seems generally useful as well. I would probably use it outside
of sock_map for example.

Thoughts? I think it helps with Alexei's concern around passing fds. 

> 
> Lorenz
> 
> -- 
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> 
> www.cloudflare.com


