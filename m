Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD118541C
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgCNC6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:58:36 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35143 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgCNC6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 22:58:36 -0400
Received: by mail-pj1-f66.google.com with SMTP id mq3so5361294pjb.0;
        Fri, 13 Mar 2020 19:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C+WTMvqduqMwUM/7evX90EKpkeCW6lg89ibYqzEucsg=;
        b=k/sduGOgYo5mqK+Z/L3LmalMc1FcgDC8/e+OaIrIzh6Jleqk3SyP9s65BKizrd1ZkI
         cAjL5R0FYHUqT6v+jN8vFnWpIj0wNP9GqBfxLCo3WeILY5i+RDknGCTiZ7gsqYuQIMvF
         bqQM9h4UqUrWQ/B8mvjsoPFSuWsf80SOw4ZueW3CmQ4sVJwLtpNdZXDOPEP1abJHciuj
         H1hQ8BOO27vK4NNr6ecv+BT5Ke4+YJoK8XFh+z37HtYno456AhV6EiMYFkBx1n0mHa5b
         Gh+pUy3Pk7cyrUNrtCwO283MxKYqw/7lQfQdD5/CIroWIllQrm3W3HpXLq6F/NYKlYdy
         zTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C+WTMvqduqMwUM/7evX90EKpkeCW6lg89ibYqzEucsg=;
        b=Wc6VhK0lXBfz3u7JMLc8TuTWoPwOTp5IjmVUxR0enyCl29MAHyTBd5k57IhcaKJuF8
         RKMZDg7KfTQCyZDuMaEFc8d/Yo+FRTT7/7ndPeismIkUsW/afiCgvG2kPlVBYqR3jWpx
         RRF2byvTo28B6QZLb7VHFrgF7msUm3yu6/gAPRgdsz/tCXc8KgXJIxA1E6xo8rJtvM1P
         rC7mQlVlrM58VcLVeUpFl9M1fcScM+z4lefQ2ZxfeMyH1Kaakwbd4HjBW03hqfHy1Mij
         FnzQa1MvbL4HApuYLqtKs5q1tvhqciVVTscg0hjneFlLJvpce1B+izqzjHAx1rT9Z0v3
         A5tQ==
X-Gm-Message-State: ANhLgQ0e6p772EokAz3jO1A//ROiqTwldmjCPA8uV4hfQ/eV7UmYFE8v
        FLPeK+8GpDMmctZz9ylZe0YnRb97
X-Google-Smtp-Source: ADFU+vuu/9Ns/eDSHRJ3R+7oXxKWLZQEVWbqmZZwx09AdL1D0EtncGN5+DLg2u6LUlmhFf88m6cZ4g==
X-Received: by 2002:a17:90a:232d:: with SMTP id f42mr11862125pje.185.1584154715466;
        Fri, 13 Mar 2020 19:58:35 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1661])
        by smtp.gmail.com with ESMTPSA id e28sm58260770pgn.21.2020.03.13.19.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 19:58:34 -0700 (PDT)
Date:   Fri, 13 Mar 2020 19:58:32 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
Message-ID: <20200314025832.3ffdgkva65dseoec@ast-mbp.dhcp.thefacebook.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
 <20200312175828.xenznhgituyi25kj@ast-mbp>
 <CACAyw98cp2we2w_L=YgEj+BbCqA5_3HvSML1VZzyNeF8mVfEEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw98cp2we2w_L=YgEj+BbCqA5_3HvSML1VZzyNeF8mVfEEQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 10:48:57AM +0000, Lorenz Bauer wrote:
> On Thu, 12 Mar 2020 at 17:58, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > but there it goes through ptrace checks and lsm hoooks, whereas here similar
> > security model cannot be enforced. bpf prog can put any socket into sockmap and
> > from bpf_lookup_elem side there is no way to figure out the owner task of the
> > socket to do ptrace checks. Just doing it all under CAP_NET_ADMIN is not a
> > great security answer.
> 
> Reading between the lines, you're concerned about something like a sock ops
> program "stealing" the socket and putting it in a sockmap, to be retrieved by an
> attacker later on?
> 
> How is that different than BPF_MAP_GET_FD_BY_ID, except that it's CAP_SYS_ADMIN?

It's different because it's crossing domains. FD_BY_ID returns FD for bpf
objects. Whereas here you're proposing bpf lookup to return FD from different
domain. If lookup was returning a socket cookie and separate api on the
networking side would convert cookie into FD I would be fine with that.

> > but bpf side may still need to insert them into old.
> > you gonna solve it with a flag for the prog to stop doing its job?
> > Or the prog will know that it needs to put sockets into second map now?
> > It's really the same problem as with classic so_reuseport
> > which was solved with BPF_MAP_TYPE_REUSEPORT_SOCKARRAY.
> 
> We don't modify the sockmap from eBPF:
>    receive a packet -> lookup sk in sockmap based on packet -> redirect
> 
> Why do you think we'll have to insert sockets from BPF?

sure, but sockmap allows socket insertion. Hence it's part of considerations.

> 
> > I think sockmap needs a redesign. Consider that today all sockets can be in any
> > number of sk_local_storage pseudo maps. They are 'defragmented' and resizable.
> > I think plugging socket redirect to use sk_local_storage-like infra is the
> > answer.
> 
> Maybe Jakub can speak more to this but I don't see how this solves our problem.
> We need a way to get at struct sk * from an eBPF program that runs on
> an skb context,
> to make BPF socket dispatch feasible. How would we use
> sk_local_storage if we don't
> have a sk?

I'm not following. There is skb->sk. Why do you need to lookup sk ? Because
your hook is before demux and skb->sk is not set? Then move your hook to after?

I think we're arguing in circles because in this thread I haven't seen the
explanation of the problem you're trying to solve. We argued about your
proposed solution and got stuck. Can we restart from the beginning with all
details?
