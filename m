Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD2C574F4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfFZXhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:37:04 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37378 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZXhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:37:04 -0400
Received: by mail-lf1-f66.google.com with SMTP id d11so275193lfb.4;
        Wed, 26 Jun 2019 16:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWeMijdRoJnwgbuUK5eFM3uClFjid/XTZeuE26M5QLw=;
        b=lvu5sM2J7hZtAUwoJbPjFQ1EZb33EYm3kYdwOb7SuPJeX8950m7fk+ZgphMJux6LAG
         PUCO/pJ9kLZ7/WShSqhyeq61lNRru/YTUSeoWAZYNpkOoyjmZBJ9EXC6HhbznUvH4nzA
         yHGfjfZmOAo8ywA5721GLCPMEg/+BzosndbmXsX44LS2gtCcZ+LyJShLp8orxadQlWFM
         Ny/Eu8VGWihQs8RdfCSNuk5fzt96diFcGvr0VTMg5L7yqdz+sWxTL1Yb9ySWCMhuNBgC
         nyMnj6y29/nHcu13VEHvW54QMysqgtaa7LyIv23vES4oDL/87GsnbyDMAuWSSveijfNJ
         nLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWeMijdRoJnwgbuUK5eFM3uClFjid/XTZeuE26M5QLw=;
        b=C29unMA9WjrvnhLVgY9V+XiNCQJg0gdX5Zvg7UBld6LFJRZd4wl92GTOi8FPaMQG81
         fShWZuoE3TQnXT9vP391kZiploHMbq6M+zmqjDboaexcSKaZsAcT8wi3snD93eu9i8RB
         QzOZyMsGUIKLAxCmykwfpPtZS4nYST9q+8ecHREmlnTDWdPK1QCtnEhaD3JW/h7bhlnZ
         2EycrePON2TkydVZyYh7VD0m146xoK5vCDAvJPSswVzb2kCUKNFclf4PNHP6MdlEWFlt
         vAgSM6XRa1K4bPtxOkt8kpGK9A9fjLwJVpLNkt7ZQemUnk3N3ewKhFMVgQTGUrhJcRs3
         rXpw==
X-Gm-Message-State: APjAAAWnjhDO5zuf17bIYJuVBs+r6fuQf0De1HqbVgeuvznrPyjRBRX4
        c4rAuQYfnoXBLkt8vaus6WHyQKog535I6509ReZ/MxZF
X-Google-Smtp-Source: APXvYqyhrx+8+yHjkKDDMrfR6FJ/06ktGd/bOANIs8DsrCWxHaUboMHRhf7BkLfcmvmWTl6eUhoXtHiNBREmgVxKWyU=
X-Received: by 2002:ac2:46f9:: with SMTP id q25mr362437lfo.181.1561592221728;
 Wed, 26 Jun 2019 16:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190627080521.5df8ccfc@canb.auug.org.au> <20190626221347.GA17762@tower.DHCP.thefacebook.com>
In-Reply-To: <20190626221347.GA17762@tower.DHCP.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Jun 2019 16:36:50 -0700
Message-ID: <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
To:     Roman Gushchin <guro@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 3:14 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Jun 27, 2019 at 08:05:21AM +1000, Stephen Rothwell wrote:
> > Hi all,
> >
> > In commit
> >
> >   12771345a467 ("bpf: fix cgroup bpf release synchronization")
> >
> > Fixes tag
> >
> >   Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from
> >
> > has these problem(s):
> >
> >   - Subject has leading but no trailing parentheses
> >   - Subject has leading but no trailing quotes
> >
> > Please don't split Fixes tags across more than one line.
>
> Oops, sorry.
>
> Alexei, can you fix this in place?
> Or should I send an updated version?

I cannot easily do it since -p and --signoff are incompatible flags.
I need to use -p to preserve merge commits,
but I also need to use --signoff to add my sob to all
other commits that were committed by Daniel
after your commit.

Daniel, can you fix Roman's patch instead?
you can do:
git rebase -i -p  12771345a467^
fix Roman's, add you sob only to that one
and re-push the whole thing.
