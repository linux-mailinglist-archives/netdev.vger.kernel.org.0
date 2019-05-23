Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E562128C2A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbfEWVNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:13:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42621 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfEWVNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:13:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id 33so804707pgv.9;
        Thu, 23 May 2019 14:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K2Z73ozoP4xYlRdxuI3HEY6SJZRGV7xEroO9zwT3AeM=;
        b=JYVPyhPzum1KLZ27PNzqDRdL2C+6/4HNIeaTIpx19GqiC8GbUdgcfrz4eGT5aoU/Oh
         KxK88BMjZouqYQUXtR9PSifl5tFXz4TKvdewyH0WP+gHzrxtKk6iTPoJQE08ZDg15zFk
         m57LCydYZuYuBYIWz663WhFXz+ESBL0yhgiEIdrl10q0BUDb/ntQI6AWaLIm5hbhLn6V
         SEsKM2YkAn+nPQfUCSARSrMhNqX/k+xL/YlVdduD0wVYcsQESfwdoDIcch6TJeIdJ8UT
         e+cwCVEBvpJIeVdrUgKL6ullZ5iMKzMqqHytEv2SV5jOFDUC/FKs/Kq7lgf8U/DrCjLV
         D+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K2Z73ozoP4xYlRdxuI3HEY6SJZRGV7xEroO9zwT3AeM=;
        b=Jq5584RXXoStvN4UXOitVoXgLs1qc0iiNn+eIM22UgaVBTmpB/YnMi9kG0G3oCD13D
         8KeHCwpDg+dDMSlv/A5OU1OaHajeocLSaBBU+YRYsso3qM2W2oPQeKJZOESVgbmN1zVX
         /LFaRHXw88xc8iv1BLcGBTpx5FDq8gFb2ksdyTeAfPi0Wyz4CTI8/R9rO9/TzR73mVGY
         L3pySeNFh7LGx7PK6IlV7ZgVsAzW3k7BEJd6FPx/JS0OnoNX91/tyTMxaQ5CpfMu6xiQ
         /j67QisT9Jw++h6tqC8N4MlmWMTMiXxGFsWkwinT3rLzVm6i1HeRTOrZnZrBrwHq/ciz
         xRaw==
X-Gm-Message-State: APjAAAUYvzu44igwnLoo7uZkfek8M/wmyhIEryEkEAfkF6P9KmsKMYZh
        K28nuZluOZLn10BeR/eE1n4=
X-Google-Smtp-Source: APXvYqwq0Hf30NTU6STZxcvyVRdNPiG0zQBEJaQMoLHFsbcI1qRpiYL+p0hc0Vq/opKBMGXumybJMg==
X-Received: by 2002:a63:1d1d:: with SMTP id d29mr101307855pgd.63.1558646014571;
        Thu, 23 May 2019 14:13:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:d5a9])
        by smtp.gmail.com with ESMTPSA id n35sm262768pjc.3.2019.05.23.14.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:13:33 -0700 (PDT)
Date:   Thu, 23 May 2019 14:13:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
 <20190523054610.GR2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523054610.GR2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:46:10AM -0400, Kris Van Hees wrote:
> 
> I think there is a difference between a solution and a good solution.  Adding
> a lot of knowledge in the userspace component about how things are imeplemented
> at the kernel level makes for a more fragile infrastructure and involves
> breaking down well established boundaries in DTrace that are part of the design
> specifically to ensure that userspace doesn't need to depend on such intimate
> knowledge.

argh. see more below. This is fundamental disagreement.

> > > Another advantage of being able to operate on a more abstract probe concept
> > > that is not tied to a specific probe type is that the userspace component does
> > > not need to know about the implementation details of the specific probes.
> > 
> > If that is indeed the case that dtrace is broken _by design_
> > and nothing on the kernel side can fix it.
> > 
> > bpf prog attached to NMI is running in NMI.
> > That is very different execution context vs kprobe.
> > kprobe execution context is also different from syscall.
> > 
> > The user writing the script has to be aware in what context
> > that script will be executing.
> 
> The design behind DTrace definitely recognizes that different types of probes
> operate in different ways and have different data associated with them.  That
> is why probes (in legacy DTrace) are managed by providers, one for each type
> of probe.  The providers handle the specifics of a probe type, and provide a
> generic probe API to the processing component of DTrace:
> 
>     SDT probes -----> SDT provider -------+
>                                           |
>     FBT probes -----> FBT provider -------+--> DTrace engine
>                                           |
>     syscall probes -> systrace provider --+
> 
> This means that the DTrace processing component can be implemented based on a
> generic probe concept, and the providers will take care of the specifics.  In
> that sense, it is similar to so many other parts of the kernel where a generic
> API is exposed so that higher level components don't need to know implementation
> details.
> 
> In DTrace, people write scripts based on UAPI-style interfaces and they don't
> have to concern themselves with e.g. knowing how to get the value of the 3rd
> argument that was passed by the firing probe.  All they need to know is that
> the probe will have a 3rd argument, and that the 3rd argument to *any* probe
> can be accessed as 'arg2' (or args[2] for typed arguments, if the provider is
> capable of providing that).  Different probes have different ways of passing
> arguments, and only the provider code for each probe type needs to know how
> to retrieve the argument values.
> 
> Does this help bring clarity to the reasons why an abstract (generic) probe
> concept is part of DTrace's design?

It actually sounds worse than I thought.
If dtrace script reads some kernel field it's considered to be uapi?! ouch.
It means dtrace development philosophy is incompatible with the linux kernel.
There is no way kernel is going to bend itself to make dtrace scripts
runnable if that means that all dtrace accessible fields become uapi.

In stark contrast to dtrace all of bpf tracing scripts (bcc scripts
and bpftrace scripts) are written for specific kernel with intimate
knowledge of kernel details. They do break all the time when kernel changes.
kprobe and tracepoints are NOT uapi. All of them can change.
tracepoints are a bit more stable than kprobes, but they are not uapi.

