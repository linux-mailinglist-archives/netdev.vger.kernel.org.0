Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D240328EFE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 04:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387921AbfEXCI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 22:08:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45214 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731617AbfEXCI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 22:08:56 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so4299621pfm.12;
        Thu, 23 May 2019 19:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qX6qpOZsXihdwTRBrj5mAunPkMtIF5dGKvhQdTgjz2c=;
        b=UPIiEpM7mXq16QBlzPPNOmoWTK00tzjPjfSzpJlZdA9UuAeK8fJ0FT0iATHSMAPTK1
         bgj+ccIq20X/ymFYzvQqQZ6wdL2HdPjGuFJS904ge37OtZA7ULqztfjprkUZWAVuJ9B3
         QMifWtabkToxgEU31Hg6IVrU+U7o3Ac8y0kMtAyOkp2l72B49AGAq66sFxCFK9L1LbDO
         gq7bh1mhZcU565Ij9H4KbvMiS9uLWg6RUreKnvNMg+wlgRDBaVedSIwm70knEqrsNdHu
         gR7Fi0FJ16vK1meIAW3IMBpWg5Hzf4JX3xC73CXKJ7ilG6l5D9RHViZsYRAR8plr880S
         pvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qX6qpOZsXihdwTRBrj5mAunPkMtIF5dGKvhQdTgjz2c=;
        b=PrexxGnkear+quzmZIfrxUyPMPSj5sAWi+ikEt8pVm2GBON0yJtunTF/PZkg9+o5Ry
         9lcHpoNhLvMjVIVpaooFVJvT5C4rsFbaMs+VOIiXb246b876RkPaQs9tiE6J7FCj1LnY
         7W9IfsbFdGtOtLhLvMkpu3zuvH+3gZBAHtupPSrpglebObMW/fh37VPQGNgs1XBqDTNE
         JyGpCcytlhrnbMAnUjSAQFEVb4Sp+fIljfS9dVwrWgDRl4BpuLua1TtjU1SxxYRcx/w/
         HjpOtYV0ZX1+P0lwvaoxgSKDmeaRe9Hxr/YVhdEp7YW7FUhxdfhovGUtYf8eTMrBzY0f
         HRDQ==
X-Gm-Message-State: APjAAAUq3mImMuf3GuSZYWVV7C+nvYpT1qWYr5W/6kOdYqgY575E8Eio
        843yvRsloy9ibVRssHgT6lw=
X-Google-Smtp-Source: APXvYqzYys6ZpOh9I3WxTzaNNbv9Z/RK6q+WmhALNjXFVKQDbiI+8Ag10LYZ7vrpenpO9sDhwbgM0A==
X-Received: by 2002:a63:5608:: with SMTP id k8mr101840369pgb.393.1558663734442;
        Thu, 23 May 2019 19:08:54 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:d5a9])
        by smtp.gmail.com with ESMTPSA id k22sm752739pfk.54.2019.05.23.19.08.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 19:08:52 -0700 (PDT)
Date:   Thu, 23 May 2019 19:08:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524020849.vxg3hqjtnhnicyzp@ast-mbp.dhcp.thefacebook.com>
References: <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
 <20190523054610.GR2422@oracle.com>
 <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
 <20190523190243.54221053@gandalf.local.home>
 <20190524003148.pk7qbxn7ysievhym@ast-mbp.dhcp.thefacebook.com>
 <20190523215737.6601ab7c@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523215737.6601ab7c@oasis.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 09:57:37PM -0400, Steven Rostedt wrote:
> On Thu, 23 May 2019 17:31:50 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> 
> > > Now from what I'm reading, it seams that the Dtrace layer may be
> > > abstracting out fields from the kernel. This is actually something I
> > > have been thinking about to solve the "tracepoint abi" issue. There's
> > > usually basic ideas that happen. An interrupt goes off, there's a
> > > handler, etc. We could abstract that out that we trace when an
> > > interrupt goes off and the handler happens, and record the vector
> > > number, and/or what device it was for. We have tracepoints in the
> > > kernel that do this, but they do depend a bit on the implementation.
> > > Now, if we could get a layer that abstracts this information away from
> > > the implementation, then I think that's a *good* thing.  
> > 
> > I don't like this deferred irq idea at all.
> 
> What do you mean deferred?

that's how I interpreted your proposal: 
"interrupt goes off and the handler happens, and record the vector number"
It's not a good thing to tell about irq later.
Just like saying lets record perf counter event and report it later.

> > Abstracting details from the users is _never_ a good idea.
> 
> Really? Most everything we do is to abstract details from the user. The
> key is to make the abstraction more meaningful than the raw data.
> 
> > A ton of people use bcc scripts and bpftrace because they want those details.
> > They need to know what kernel is doing to make better decisions.
> > Delaying irq record is the opposite.
> 
> I never said anything about delaying the record. Just getting the
> information that is needed.
> 
> > > 
> > > I wish that was totally true, but tracepoints *can* be an abi. I had
> > > code reverted because powertop required one to be a specific
> > > format. To this day, the wakeup event has a "success" field that
> > > writes in a hardcoded "1", because there's tools that depend on it,
> > > and they only work if there's a success field and the value is 1.  
> > 
> > I really think that you should put powertop nightmares to rest.
> > That was long ago. The kernel is different now.
> 
> Is it?
> 
> > Linus made it clear several times that it is ok to change _all_
> > tracepoints. Period. Some maintainers somehow still don't believe
> > that they can do it.
> 
> From what I remember him saying several times, is that you can change
> all tracepoints, but if it breaks a tool that is useful, then that
> change will get reverted. He will allow you to go and fix that tool and
> bring back the change (which was the solution to powertop).

my interpretation is different.
We changed tracepoints. It broke scripts. People changed scripts.

> 
> > 
> > Some tracepoints are used more than others and more people will
> > complain: "ohh I need to change my script" when that tracepoint
> > changes. But the kernel development is not going to be hampered by a
> > tracepoint. No matter how widespread its usage in scripts.
> 
> That's because we'll treat bpf (and Dtrace) scripts like modules (no
> abi), at least we better. But if there's a tool that doesn't use the
> script and reads the tracepoint directly via perf, then that's a
> different story.

absolutely not.
tracepoint is a tracepoint. It can change regardless of what
and how is using it.

