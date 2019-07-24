Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7173059
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfGXN5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:57:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36364 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbfGXN5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:57:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so22061777plt.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 06:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GWkx98bFDu9RaP8hXcQFr0cSnvxus1MNG1rYGNPKfj4=;
        b=f1iUHU7mfd95p5DaM48MTArJN0KA8hNbkOFJVlgyUnrb/78qa+cD2lYXF1taZ5A3w+
         jTBsKU8XtNlJ0FA5qQnn2rYXSjxYAxTNu4B3JBDIY2q4soRuoJlSDmldDOn7kUhg7EWV
         UejidEDKpkWkdO2YN/gAnVxUE9sPMOTwqkTck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GWkx98bFDu9RaP8hXcQFr0cSnvxus1MNG1rYGNPKfj4=;
        b=dU91I1dKDFyYwsoBIRs7ZWslGEZbW5shETRKMFIzjBLKq0epAbfp8kNZkKvC6tWiNu
         2YBSmKGZ8c+jAUkxKZxjjAM7/FbL140MF9JMp0o+XHGf7pXGAgXdCFR/FaeCRmFRwtty
         FM2bS7aYTxJFP8TZ9mLuOvrp0sK34ct5q5oGEHAONSzp/n8oxNZtZSFV646ILpnUU+4l
         RA/hqUPI67c60n0XYTSOqpemepgfClCiGmChlwBqhWG5IUI7H7HngOxdA2Z7f2K+EU7o
         YjpauinYRcpwtVUpn1xEdhexTu3KPePLWfCyOwF96MUD9WTbgjbDm+grapsBzZy/3CwB
         mG9A==
X-Gm-Message-State: APjAAAXp82oN8XxOZ7We9tjykGOsMguHDWRUKqJwD50+uWtbcw+KsEs2
        IbI6VWcDuVRo1OUvCOUbDAQ=
X-Google-Smtp-Source: APXvYqw2WoPLa2BcLQKDe4FWqERz0Muga9t0KUBGeFNngqIvIyv/zLAljwsauZ98iAIOeica29bXcQ==
X-Received: by 2002:a17:902:2aea:: with SMTP id j97mr73752045plb.153.1563976637094;
        Wed, 24 Jul 2019 06:57:17 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id k6sm56084171pfi.12.2019.07.24.06.57.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 06:57:15 -0700 (PDT)
Date:   Wed, 24 Jul 2019 09:57:14 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, kernel-team@android.com
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190724135714.GA9945@google.com>
References: <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
 <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com>
 <20190716235500.GA199237@google.com>
 <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
 <20190717130119.GA138030@google.com>
 <CAADnVQJY_=yeY0C3k1ZKpRFu5oNbB4zhQf5tQnLr=Mi8i6cgeQ@mail.gmail.com>
 <20190718025143.GB153617@google.com>
 <20190723221108.gamojemj5lorol7k@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723221108.gamojemj5lorol7k@ast-mbp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 03:11:10PM -0700, Alexei Starovoitov wrote:
> > > > > I think allowing one tracepoint and disallowing another is pointless
> > > > > from security point of view. Tracing bpf program can do bpf_probe_read
> > > > > of anything.
> > > >
> > > > I think the assumption here is the user controls the program instructions at
> > > > runtime, but that's not the case. The BPF program we are loading is not
> > > > dynamically generated, it is built at build time and it is loaded from a
> > > > secure verified partition, so even though it can do bpf_probe_read, it is
> > > > still not something that the user can change.
> > > 
> > > so you're saying that by having a set of signed bpf programs which
> > > instructions are known to be non-malicious and allowed set of tracepoints
> > > to attach via selinux whitelist, such setup will be safe?
> > > Have you considered how mix and match will behave?
> > 
> > Do you mean the effect of mixing tracepoints and programs? I have not
> > considered this. I am Ok with further enforcing of this (only certain
> > tracepoints can be attached to certain programs) if needed. What do
> > you think? We could have a new bpf(2) syscall attribute specify which
> > tracepoint is expected, or similar.
> > 
> > I wanted to walk you through our 2 usecases we are working on:
> 
> thanks for sharing the use case details. Appreciate it.

No problem and thanks for your thoughts.

> > 1. timeinstate: By hooking 2 programs onto sched_switch and cpu_frequency
> > tracepoints, we are able to collect CPU power per-UID (specific app). Connor
> > O'Brien is working on that.
> > 
> > 2. inode to file path mapping: By hooking onto VFS tracepoints we are adding to
> > the android kernels, we can collect data when the kernel resolves a file path
> > to a inode/device number. A BPF map stores the inode/dev number (key) and the
> > path (value). We have usecases where we need a high speed lookup of this
> > without having to scan all the files in the filesystem.
> 
> Can you share the link to vfs tracepoints you're adding?
> Sounds like you're not going to attempt to upstream them knowing
> Al's stance towards them?
> May be there is a way we can do the feature you need, but w/o tracepoints?

Yes, given Al's stance I understand the patch is not upstreamable. The patch
is here:
For tracepoint:
https://android.googlesource.com/kernel/common/+/27d3bfe20558d279041af403a887e7bdbdcc6f24%5E%21/
For bpf program:
https://android.googlesource.com/platform/system/bpfprogs/+/908f6cd718fab0de7a944f84628c56f292efeb17%5E%21/

I intended to submit the tracepoint only for the Android kernels, however if
there is an upstream solution to this then that's even better since upstream can
benefit. Were you thinking of a BPF helper function to get this data?

> 
> > For the first usecase, the BPF program will be loaded and attached to the
> > scheduler and cpufreq tracepoints at boot time and will stay attached
> > forever.  This is why I was saying having a daemon to stay alive all the time
> > is pointless. However, if since you are completely against using tracefs
> > which it sounds like, then we can do a daemon that is always alive.
> 
> As I said earlier this use case can be solved by pinning raw_tp object
> into bpffs. Such patches are welcomed.

Ok will think more about it.

> > For the second usecase, the program attach is needed on-demand unlike the
> > first usecase, and then after the usecase completes, it is detached to avoid
> > overhead.
> > 
> > For the second usecase, privacy is important and we want the data to not be
> > available to any process. So we want to make sure only selected processes can
> > attach to that tracepoint. This is the reason why I was doing working on
> > these patches which use the tracefs as well, since we get that level of
> > control.
> 
> It's hard to recommend anything w/o seeing the actual tracepoints you're adding
> to vfs and type of data bpf program extracts from there.
> Sounds like it's some sort of cache of inode->file name ?

Yes, that's what it is.

> If so, why is it privacy related?

The reasoning is the file paths could reveal user activity (such as an app
that opens a document) and Android has requirements to control/restrict that.

thanks,

 - Joel

