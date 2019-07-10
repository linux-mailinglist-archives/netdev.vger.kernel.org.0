Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE264E1D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfGJVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:50:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45038 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbfGJVuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:50:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so3988987wrf.11;
        Wed, 10 Jul 2019 14:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bLuzUxUc0zNtNis3h91JRpefJIR6fwf3Ba4xYSd3aA4=;
        b=OdDgOB6ygEtdXE2MH2aRjxspWRDbEivh8b5kYyeQzmyxmD9ZkRp5GsjSKdHRTAIXyL
         MXJ2FP1DgGWrDgMhnp+OMdR2JQHqEb1DwcRLj3g6LcP7HU8tc+BUlYZucvKY1hWxZCYS
         rZNM4godxBlsCJkt3WkothA6bnd/XMC37FawFR1pfPUcW1K5U231WOi9d0Jln1KJlWJX
         PNPnV43CVp6nOtUzfFDmrrDoJ/udboEeX1cRTEhck8sIll5lNqrJMY8pZeeOmlCJTIfQ
         +ORBxB6mCqo5vBDR6/d8Ipf18WRarpLOoDOqRRIsgPKUDQsUlSqnytR2c+bPJ+ZvdeDh
         gO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bLuzUxUc0zNtNis3h91JRpefJIR6fwf3Ba4xYSd3aA4=;
        b=Pu7A4QN5J2u+ZQYMKpwhcRnOT4yXUFI3h/CJfjBNSSp8N7Nz/l74QHSq1s4y2fWAA8
         gZvP5hQja02Ee5Sx2rQCkDIE70/pq7oTx1gvkNNDuAex3Y8hij3d2n4sR6HeOLQdziGt
         q4R4stwDJuD/DoJeZQPcIRsNRYcf9DnNcMMf70jzP3wx4xpLhxyF3yRhYjZA4x89NI5f
         A8i8btErXlHPkS89/CulF3JztRamWYCekwayNZlD+nhqSO3NVoNqhxl8AtfhydoTNE1b
         UKE+eCw4cowyZJ5bwfHIw/wyOvj1cKSS3gN62Q3A2DfayBidg/NrqzdSmqcEXlf19EBE
         KO2w==
X-Gm-Message-State: APjAAAV+proYxfAMn7APo3ItElgCIMADtRfYeltQiym5mF8J1W0ZYXqu
        9BEwkSxxd4zLdbLt4TeXpcftsUYn/6e8i+EOm+I=
X-Google-Smtp-Source: APXvYqyJcfOKdqnNxQp5JjK89GxcKipPvGPQNaEYDxC+SlkLlaxmwChaULI3VgJahYqzcplyKG9/b4jwcvL3M6rtUpw=
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr34416075wrm.235.1562795418803;
 Wed, 10 Jul 2019 14:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
 <201907101542.x6AFgOO9012232@userv0121.oracle.com> <20190710181227.GA9925@oracle.com>
 <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net> <20190710143048.3923d1d9@lwn.net>
 <1de27d29-65bb-89d3-9fca-7c452cd66934@iogearbox.net> <20190710213637.GB13962@oracle.com>
In-Reply-To: <20190710213637.GB13962@oracle.com>
From:   Brendan Gregg <brendan.d.gregg@gmail.com>
Date:   Wed, 10 Jul 2019 14:49:52 -0700
Message-ID: <CAE40pdeSVN+QhhUeQ4sEbsyzJ+NWkQA5XU5X0FrKAbRMHPzBsw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 2:36 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
>
> On Wed, Jul 10, 2019 at 11:19:43PM +0200, Daniel Borkmann wrote:
> > On 07/10/2019 10:30 PM, Jonathan Corbet wrote:
> > > On Wed, 10 Jul 2019 21:32:25 +0200
> > > Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > >> Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
> > >> seen a strong compelling argument for why this needs to reside in the kernel
> > >> tree given we also have all the other tracing tools and many of which also
> > >> rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
> > >> a few.
> > >
> > > So I'm just watching from the sidelines here, but I do feel the need to
> > > point out that Kris appears to be trying to follow the previous feedback
> > > he got from Alexei, where creating tools/dtrace is exactly what he was
> > > told to do:
> > >
> > >   https://lwn.net/ml/netdev/20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com/
> > >
> > > Now he's being told the exact opposite.  Not the best experience for
> > > somebody who is trying to make the kernel better.
> >
> > Ugh, agree, sorry for the misleading direction. Alexei is currently offgrid
> > this week, he might comment later.
> >
> > It has nothing to do with making the _kernel_ better, it's a /user space/ front
> > end for the existing kernel infrastructure like many of the other tracers out
> > there. Don't get me wrong, adding the missing /kernel parts/ for it is a totally
> > different subject [and _that_ is what is making the kernel better, not the former].
>
> I disagree.  Yes, the current patch obviously isn't making the kernel better
> because it doesn't touch the kernel.  But DTrace as a whole is not just a
> /front end/ to the existing kernel infrastructure, and I did make that point
> at LPC 2018 and in my emails.  Some of its more advanced features will lead
> to contributions to the kernel that (by virtue of being developed as part of
> this DTrace re-implementation) will more often than not be able to benefit
> other tracers as well.  I do think that aspect qualifies as working towards
> making the kenrel better.
>
> > Hypothetical question: does it make the _kernel_ better if we suddenly add a huge
> > and complex project like tools/mysql/ to the kernel tree? Nope.
> >
> > > There are still people interested in DTrace out there.  How would you
> > > recommend that Kris proceed at this point?
> >
> > My recommendation to proceed is to maintain the dtrace user space tooling in
> > its own separate project like the vast majority of all the other tracing projects
> > (see also the other advantages that Steven pointed out from his experience), and
> > extend the kernel bits whenever needed.
>
> I wish that would have been the initial recommendation because it certainly
> would have avoided me going down a path that was going to lead to rejection.
>
> Either way, I do hope that as work progresses and contributions to the kernel
> code are submitted in support of advancing tracing on Linux, those patches
> will receive a fair review and consideration.  I can appreciate that some
> people do not like DTrace or feel that it is not necessary, but personal
> opinions about tools should not be a deciding factor in whether a contribution
> has merit or not.

Hey Kris -- so you're referring to me, and I've used DTrace more than
anyone over the past 15 years, and I don't think anyone has used all
the different Linux tracers more than I have. I think my opinion has a
lot of value.


Brendan
