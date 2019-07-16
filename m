Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9FB76B215
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389169AbfGPWqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:46:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41316 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389084AbfGPWqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:46:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so10813179pls.8
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 15:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZSafqs3dk1A2a56ZSTzxAgkROhKDh2sVg3+f4ANr2sM=;
        b=ZI1yhSOdixGSXYRM8nMQJMpxZPSxUBBqzzBaw5lkJo+7fde9KlpWC1LQ+fhLtq7daw
         HbJErpZtJFQJXqsBg50w3Vo2QMjtDAoaDiO2ph/vkhiE0yfB7y9COm360VK5tiWw4+8b
         0JhZeVsAGRo4FXaSTlItAM+r4mOxe19m1R3iY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZSafqs3dk1A2a56ZSTzxAgkROhKDh2sVg3+f4ANr2sM=;
        b=f9JG9xXZjOiJF3J7G7IP1wquRtOGwEIb981pzT0xonnHqmRmqTIcAoSn92Uq5LwqcU
         eiQafIMcxA40cXdg4Uf6HhdJaYPu2oZn9uO6RA4s//LwoDrQ3xBHvTW05UXYZutKhV0R
         I/+kA2wZtv1Inu/tpuVcbziJR9qKHIgowpJD/wnN5+O+wFtxfHPLr1xLB4rxRsafq64L
         c3LXK0nOQm69gyOecW29GVE+ANnrbY+eB3ibeFFrQUW8LQQOzi7MR5llnVW/FxasuFm+
         W3nE6CWHCUbzjrAXMKgcLInq4OQvalSM8afH8z6F5wNPRwC/1g36qWsxDwGoDgr9avm1
         RP1w==
X-Gm-Message-State: APjAAAXTPpqqab0vWT+/lMZcO3QbTygHCtOl+FhHldKgf8ivWw8s/Lq3
        UlhXSprMxenIe5Po5g12P4Y=
X-Google-Smtp-Source: APXvYqxij2sUThKpOtvWAWoIKdsG3JOc5TE+Ahn71mXU5vgaa8CsZm7ykBAnbyP8GihU+4dX5jCRMA==
X-Received: by 2002:a17:902:a409:: with SMTP id p9mr39200676plq.218.1563317169245;
        Tue, 16 Jul 2019 15:46:09 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id bo20sm16582204pjb.23.2019.07.16.15.46.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 15:46:08 -0700 (PDT)
Date:   Tue, 16 Jul 2019 18:46:06 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org,
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
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190716224606.GD172157@google.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
 <20190716183117.77b3ed49@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716183117.77b3ed49@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 06:31:17PM -0400, Steven Rostedt wrote:
> On Tue, 16 Jul 2019 17:30:50 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > I don't see why a new bpf node for a trace event is a bad idea, really.
> > tracefs is how we deal with trace events on Android. We do it in production
> > systems. This is a natural extension to that and fits with the security model
> > well.
> 
> What I would like to see is a way to have BPF inject data into the
> ftrace ring buffer directly. There's a bpf_trace_printk() that I find a
> bit of a hack (especially since it hooks into trace_printk() which is
> only for debugging purposes). Have a dedicated bpf ftrace ring
> buffer event that can be triggered is what I am looking for. Then comes
> the issue of what ring buffer to place it in, as ftrace can have
> multiple ring buffer instances. But these instances are defined by the
> tracefs instances directory. Having a way to associate a bpf program to
> a specific event in a specific tracefs directory could allow for ways to
> trigger writing into the correct ftrace buffer.

But his problem is with doing the association of a BPF program with tracefs
itself. How would you attach a BPF program with tracefs without doing a text
based approach? His problem is with the text based approach per his last
email.

> But looking over the patches, I see what Alexei means that there's no
> overlap with ftrace and these patches except for the tracefs directory
> itself (which is part of the ftrace infrastructure). And the trace
> events are technically part of the ftrace infrastructure too. I see the
> tracefs interface being used, but I don't see how the bpf programs
> being added affect the ftrace ring buffer or other parts of ftrace. And
> I'm guessing that's what is confusing Alexei.

In a follow-up patch which I am still writing, I am using the trace ring
buffer as temporary storage since I am formatting the trace event into it.
This patch you are replying to is just for raw tracepoint and yes, I agree
this one does not use the ring buffer, but a future addition to it does. So
I don't think the association of this patch series with ftrace is going to be
an issue IMO.

thanks,

 - Joel


