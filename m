Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3B64E06
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfGJVfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:35:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33774 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJVfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:35:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so5540686wme.0;
        Wed, 10 Jul 2019 14:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFt+cuvDVhvBVqTLWGoedPkcFkamyQULj+E9pxwktXA=;
        b=t6ZrgbKf29meYrzHac+kqDzn8o7Q/MRK7kaFXlO/BSnG3CJ98MKguWFCDCTg/XwI4J
         CN3utJM3+xsoNXieHfDAT9oyxxkJ+bAWBbwjX7swkjojlDNt/TpfoJEPXadOj5Vx86o9
         gBBgQ1thX45wTvoqT18mgHvS5PgUhFx1uid7mBt33CZNa2oLmrR8r3OIiuCFxYZN4L1l
         PGfkrEV0bkm3C1fnViDo9ghi9GGw2BL7ud5BozVwtfas9SDWoKhgMRNBgjJ/koR3o4Pr
         Cmsdfldoi7ZBBtk0yvXeFfd4N20FPnc9tO0YXakGpGbs2FzBCAf7HH2+H2zaW+uN8eSl
         MzVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFt+cuvDVhvBVqTLWGoedPkcFkamyQULj+E9pxwktXA=;
        b=pUxvaOeEjteMnjEo0vVf425f49Rc9bJJmHdrkNgPZrqvu8V6FmxbM60gc9O0D68no8
         twMI9UZyVOWJMP8pjLzxvQR84KyCb5N5r5OmM9Y689Ns8PB80Pa41CmPWn/DFYdLqaZi
         OT1pc6GqaoDhu/qHeQ9wfVDrPVqbKjImTbE9wgePI06nOt18ZW4jXMmsm1XX+HCI/oeu
         zHkL7WK5nMqr+QO1i+zos1K69r3oJDF/oGi4w9pujwK0QaL2Pwfw1KiJWys+qBkLT4i1
         DQPElvrvyfsYpSjef8sSu+6g768XgB2m1qacjfiysoDwXSSD/HGRwvmSzVhCY3sPBQ0b
         hP+w==
X-Gm-Message-State: APjAAAXaPAEPPZPvNZfF7eMqrEqIo06/GAKxpep7n/NhEdMxwfmdwJAq
        NiXqCP31+kKg6SpVeClxxbr2w4UITGlMu7NkDck=
X-Google-Smtp-Source: APXvYqwy0RiVYU+hCpVmTQy1EMPmqR3GfMNY2w/aC9TQeTRivm8QT323uZy0+C1tCmJeK1lPz3MopDdA5dafQht5Cvw=
X-Received: by 2002:a1c:7d08:: with SMTP id y8mr14574wmc.50.1562794527682;
 Wed, 10 Jul 2019 14:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
 <201907101542.x6AFgOO9012232@userv0121.oracle.com> <20190710181227.GA9925@oracle.com>
 <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net> <20190710143048.3923d1d9@lwn.net>
In-Reply-To: <20190710143048.3923d1d9@lwn.net>
From:   Brendan Gregg <brendan.d.gregg@gmail.com>
Date:   Wed, 10 Jul 2019 14:35:01 -0700
Message-ID: <CAE40pddGhVe=rcEqQUN_=UhRHodfgaRXuLfUqiV6xVkEx_m-yg@mail.gmail.com>
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>,
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

On Wed, Jul 10, 2019 at 1:30 PM Jonathan Corbet <corbet@lwn.net> wrote:
>
> On Wed, 10 Jul 2019 21:32:25 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> > Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
> > seen a strong compelling argument for why this needs to reside in the kernel
> > tree given we also have all the other tracing tools and many of which also
> > rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
> > a few.
>
> So I'm just watching from the sidelines here, but I do feel the need to
> point out that Kris appears to be trying to follow the previous feedback
> he got from Alexei, where creating tools/dtrace is exactly what he was
> told to do:
>
>   https://lwn.net/ml/netdev/20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com/

From what I saw, the discussion was about kernel and user bits, where
the user bit was a "little tool is currently hardcoded to process a
single test case". I missed it first time around, but was going to
make the case that such tests belong in tools/testing/selftests/bpf
rather than tools/dtrace, since we have other similar test cases to
ensure bits of BPF work.

This patchset pivoted from a single test case to the entire DTrace
front end. If this was Kris's intent all along, it wasn't clear to me
(and maybe Alexei either) until now.

>
> Now he's being told the exact opposite.  Not the best experience for
> somebody who is trying to make the kernel better.
>
> There are still people interested in DTrace out there.

Yes, they can:

apt-get install bpftrace (or snap, yum, whatever)

and start solving production problems today, like we are.

> How would you
> recommend that Kris proceed at this point?

You may not be asking me, but I don't think it's best for Linux to
split our tracing expertise among 13 different tracers (SystemTap,
LTTng, ftrace, perf, dtrace4linux, OEL DTrace, ktap, sysdig, Intel
PIN, bcc, shark, ply, and bpftrace). bpftrace is already far ahead and
in use in production, and Kris is just starting building a new one. I
actually think we need to consolidate our expertise on fewer tracers,
which includes asking developers to jump the fence and work on other
projects (like I did myself). But I also recognize's Kris's need to
support legacy users, so I'll stop short of saying that it shouldn't
exist at all.

Brendan
