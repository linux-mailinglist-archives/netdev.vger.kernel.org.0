Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667FC193036
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgCYSUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgCYSUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 14:20:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6C0206F8;
        Wed, 25 Mar 2020 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585160408;
        bh=pWgYRSYQ5w/V0SM1meK9ne/iVV7Avdzu0ZFBDe52esE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvW8XtqV8GwZnFVreeOktNbqa05xcCtlIYiFIm67kl7PuXNS3ET+D3/KYgpDmTOyb
         c0tUkMgwdBkDVWn+dc2lzKaV216j8EIwGmNqDh6/4oDVztj/3NTx5/wXVxVG1f5nAC
         Vw2bOW63XijO4QkPx0tt5WKSHvp1oLngXF4s/LK8=
Date:   Wed, 25 Mar 2020 11:20:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200325112005.205d985a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325180638.el22n4ms6aau42r4@ast-mbp>
References: <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
        <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
        <87h7ye3mf3.fsf@toke.dk>
        <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
        <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
        <20200325013631.vuncsvkivexdb3fr@ast-mbp>
        <20200324191554.46a7e0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200325180638.el22n4ms6aau42r4@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 11:06:38 -0700 Alexei Starovoitov wrote:
> On Tue, Mar 24, 2020 at 07:15:54PM -0700, Jakub Kicinski wrote:
> > It is the way to configure XDP today, so it's only natural to
> > scrutinize the attempts to replace it.   
> 
> No one is replacing it.

You're blocking extensions to the existing API, that means that part 
of the API is frozen and is being replaced.

> > Also I personally don't think you'd see this much push back trying to
> > add bpf_link-based stuff to cls_bpf, that's an add-on. XDP is
> > integrated very fundamentally with the networking stack at this point.
> >   
> > > Details are important and every case is different. So imo:
> > > converting ethtool to netlink - great stuff.
> > > converting netdev irq/queue management to netlink - great stuff too.
> > > adding more netlink api for xdp - really bad idea.  
> > 
> > Why is it a bad idea?  
> 
> I explained in three other emails. tldr: lack of ownership.

Those came later, I think, thanks.

Fine, maybe one day someone will find the extension you're proposing
useful. To me that's not a justification to freeze the existing API
(you said "adding more netlink api for xdp - really bad idea").

Besides, if you look at Toke's libxdp work (which exists), what's the
ownership of the attached program? Whichever application touched it
last?

The whole auto-detachment thing may work nicely in cls_bpf and
sub-programs attached to the root XDP program, but it's a bit hard 
to imagine how its useful for the singleton root XDP program.

> > There are plenty things which will only be available over netlink.
> > Configuring the interface so installing the XDP program is possible
> > (disabling features, configuring queues etc.). Chances are user gets
> > the ifindex of the interface to attach to over netlink in the first
> > place. The queue configuration (which you agree belongs in netlink)
> > will definitely get more complex to allow REDIRECTs to work more
> > smoothly. AF_XDP needs all sort of netlink stuff.  
> 
> sure. that has nothing to do with ownership of attachment.

AFAICT the allure to John is the uniform API, and no need for netlink.
I was explaining how that's a bad goal to have.

> > Netlink gives us the notification mechanism which is how we solve
> > coordination across daemons (something that BPF subsystem is only 
> > now trying to solve).  
> 
> I don't care about notifications on attachment and no one is trying to
> solve that as far as I can see. It's not a problem to solve in the first place.

Well, it's the existing solution to the "ownership" problem.
I think most people simply didn't know about it.
