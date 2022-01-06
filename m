Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE219486171
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiAFI3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:29:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236562AbiAFI3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641457747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQC5BMXb3FUA0pAf7I+eZdd/zk8xeROhiXpc2k+6AtY=;
        b=BUiM93ylCC9Gatx6rtQYrhaGN7Ofb2Jyfatn8c2UXcwIHTJQWGQFt1DO77pI8YMZRIm6iQ
        EIfgZj65QO4NzT0t4a9iH2Apkz0CmPNvwUhRUGTNe8z3i+HX9DgFzXY4WUDl7uBar6K6vf
        fdDieCjrbJFDEhFYtZ8LI20zgyFSTTg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-VxNY522BOJCjf0MpcGybdg-1; Thu, 06 Jan 2022 03:29:06 -0500
X-MC-Unique: VxNY522BOJCjf0MpcGybdg-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a056402358a00b003f88b132849so1449879edc.0
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 00:29:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NQC5BMXb3FUA0pAf7I+eZdd/zk8xeROhiXpc2k+6AtY=;
        b=SIW5HvvGuiFNxkCdEkqfj2Uny4+m3M3vBZMacuLZkIXSmCwvBYOQcV+pBqvIx+38/b
         LmUiasQTLm7fOq/iAnWRtvDiDIN0Z+zIasee0KIOW1R9DJCCsjom+D8MRMNRGS9lJZOX
         8Z/G0HdDQYbxgO//eXXea/YtdS/j9UjWm7Jr4wmYqokBw/hcQVONRA4zm1CDSLQuVhDX
         Bqyi1IvAZeAYoFmdtqiotdoXxnXc7OxZR/eXr8Z7LAhbHX3eaUBrUynVAVQNq2T+tazr
         58SMtFskl5DHchMDZLX+yxqZX/9RyBrX7OUtO0YbmhlepxV43QNCEQhKupCa/nCjbA3y
         KmiA==
X-Gm-Message-State: AOAM531xW4Y1Fq0eWDN5wG9ZMGMBQNBGZxZgd4DmMY1e6TVIwEHePL5v
        4kxs9h/VrXMJXi+B0DjEoufGwJD2M0UiJUggZkmR0mlBejfj7SBIjaf57WmIGo1e4rk50qdQhLq
        arB0K7XWF6GeRdC0F
X-Received: by 2002:a17:906:375b:: with SMTP id e27mr201638ejc.148.1641457745129;
        Thu, 06 Jan 2022 00:29:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNlSOMnYiiXSAh7YLcDBrtYRzSS2zc+Wc7pv8jFJRHr30nvdmNczWB9oJHtZprTWisVPT4bQ==
X-Received: by 2002:a17:906:375b:: with SMTP id e27mr201627ejc.148.1641457744947;
        Thu, 06 Jan 2022 00:29:04 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id 18sm317383ejw.187.2022.01.06.00.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 00:29:04 -0800 (PST)
Date:   Thu, 6 Jan 2022 09:29:02 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-ID: <YdaoTuWjEeT33Zzm@krava>
References: <20220104080943.113249-1-jolsa@kernel.org>
 <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 12:24:35AM +0900, Masami Hiramatsu wrote:
> On Tue,  4 Jan 2022 09:09:30 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > hi,
> > adding support to attach multiple kprobes within single syscall
> > and speed up attachment of many kprobes.
> > 
> > The previous attempt [1] wasn't fast enough, so coming with new
> > approach that adds new kprobe interface.
> 
> Yes, since register_kprobes() just registers multiple kprobes on
> array. This is designed for dozens of kprobes.
> 
> > The attachment speed of of this approach (tested in bpftrace)
> > is now comparable to ftrace tracer attachment speed.. fast ;-)
> 
> Yes, because that if ftrace, not kprobes.
> 
> > The limit of this approach is forced by using ftrace as attach
> > layer, so it allows only kprobes on function's entry (plus
> > return probes).
> 
> Note that you also need to multiply the number of instances.
> 
> > 
> > This patchset contains:
> >   - kprobes support to register multiple kprobes with current
> >     kprobe API (patches 1 - 8)
> >   - bpf support ot create new kprobe link allowing to attach
> >     multiple addresses (patches 9 - 14)
> > 
> > We don't need to care about multiple probes on same functions
> > because it's taken care on the ftrace_ops layer.
> 
> Hmm, I think there may be a time to split the "kprobe as an 
> interface for the software breakpoint" and "kprobe as a wrapper
> interface for the callbacks of various instrumentations", like
> 'raw_kprobe'(or kswbp) and 'kprobes'.
> And this may be called as 'fprobe' as ftrace_ops wrapper.
> (But if the bpf is enough flexible, this kind of intermediate layer
>  may not be needed, it can use ftrace_ops directly, eventually)
> 
> Jiri, have you already considered to use ftrace_ops from the
> bpf directly? Are there any issues?
> (bpf depends on 'kprobe' widely?)

at the moment there's not ftrace public interface for the return
probe merged in, so to get the kretprobe working I had to use
kprobe interface

but.. there are patches Steven shared some time ago, that do that
and make graph_ops available as kernel interface

I recall we considered graph_ops interface before as common attach
layer for trampolines, which was bad, but it might actually make
sense for kprobes

I'll need to check it in more details but I think both graph_ops and
kprobe do about similar thing wrt hooking return probe, so it should
be comparable.. and they are already doing the same for the entry hook,
because kprobe is mostly using ftrace for that

we would not need to introduce new program type - kprobe programs
should be able to run from ftrace callbacks just fine

so we would have:
  - kprobe type programs attaching to:
  - new BPF_LINK_TYPE_FPROBE link using the graph_ops as attachment layer

jirka

