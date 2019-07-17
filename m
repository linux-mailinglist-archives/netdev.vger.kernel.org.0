Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037666BCB5
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 15:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfGQNBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 09:01:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44249 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfGQNBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 09:01:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so10798535pfe.11
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 06:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/2kZjQOSWU81kHquRCCTS3R2h91VV4bpIT1uTfaQV5o=;
        b=af1ZzoQSHrqVDDWQrA4VASz5++0JDUGwmcQd31ADjyOhdWK/pICy2eNdyY7iNr5pqV
         NaPEcXn/twlQE6dChS+rDBe/c9Qno+5OAYnYvg80MvabLRJQ6EOwm2cMF7rJS05j9kSd
         oZwEH7sW7elIJT6hLNlXxYjzbIuI+PrKdwaWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/2kZjQOSWU81kHquRCCTS3R2h91VV4bpIT1uTfaQV5o=;
        b=oAx7ejwXuTIRQ/KyWTDFY7DpZjcQE+GfkJsw0uQmBDb4X1q/6Yqv5l8TwAkD6iK3ik
         EucpLhZE0F9FuKFLF0iDOS2ATRpwiewFky/K9r57+bVSLNIWROEITeAgXT1vad2e1VbE
         n4u+5PZfU+Ztzk2WznR0quwyMoW8VVgEgDAYEWepO3MoVhID/x3YuwbBPHyoH1FURyu3
         fudsDI3GYZSia1Gz1+XAMbU1eC8Emw5BUvAo+bbn7+sSJfd7Omt17UFDL991fEDiojHT
         9bVJgWDblOQ4axc3+6aY+0+aC3naRQ8bF76lI+kMX4w77LLrD1PEIiL/aEpvSqT+Zj3A
         Ticw==
X-Gm-Message-State: APjAAAVNuizqMYtD6oZmMHOEbyaRDpfkFGBWSABOAql+c4nc2xuu3f6u
        Kn6X75KipopyYwC79uTKz28=
X-Google-Smtp-Source: APXvYqwtWhnOZOF45C6Cr5hs9BpPPXwsXrITYeTQ/PuXCt4p+AvM15okMMCqiFsrp/ZD/fCo3ObANA==
X-Received: by 2002:a17:90a:8984:: with SMTP id v4mr43650667pjn.133.1563368481782;
        Wed, 17 Jul 2019 06:01:21 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l189sm28147054pfl.7.2019.07.17.06.01.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 06:01:20 -0700 (PDT)
Date:   Wed, 17 Jul 2019 09:01:19 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190717130119.GA138030@google.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
 <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com>
 <20190716235500.GA199237@google.com>
 <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 06:24:07PM -0700, Alexei Starovoitov wrote:
[snip]
> > > > > I don't see why a new bpf node for a trace event is a bad idea, really.
> > > > 
> > > > See the patches for kprobe/uprobe FD-based api and the reasons behind it.
> > > > tldr: text is racy, doesn't scale, poor security, etc.
> > > 
> > > Is it possible to use perf without CAP_SYS_ADMIN and control security at the
> > > per-event level? We are selective about who can access which event, using
> > > selinux. That's how our ftrace-based tracers work. Its fine grained per-event
> > > control. That's where I was going with the tracefs approach since we get that
> > > granularity using the file system.
> 
> android's choice of selinux is not a factor in deciding kernel apis.
> It's completely separate discusion wether disallowing particular tracepoints
> for given user make sense at all.
> Just because you can hack it in via selinux blocking particular
> /sys/debug/tracing/ directory and convince yourself that it's somehow
> makes android more secure. It doesn't mean that all new api should fit
> into this model.

Its not like a hack, it is just control of which tracefs node can be
accessed and which cannot be since the tracing can run on production systems
out in the field and there are several concerns to address like security,
privacy etc. It is not just for debugging usecases. We do collect traces out
in the field where these issues are real and cannot be ignored.

SELinux model is deny everything, and then selectively grant access to what
is needed. The VFS and security LSM hooks provide this control quite well. I am
not sure if such control is possible through perf hence I asked the question.

> I think allowing one tracepoint and disallowing another is pointless
> from security point of view. Tracing bpf program can do bpf_probe_read
> of anything.

I think the assumption here is the user controls the program instructions at
runtime, but that's not the case. The BPF program we are loading is not
dynamically generated, it is built at build time and it is loaded from a
secure verified partition, so even though it can do bpf_probe_read, it is
still not something that the user can change. And, we are planning to make it
even more secure by making it kernel verify the program at load time as well
(you were on some discussions about that a few months ago).

thanks,

 - Joel

