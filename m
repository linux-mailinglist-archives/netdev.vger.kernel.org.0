Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982AA29A39F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 05:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505405AbgJ0EaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 00:30:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33927 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444598AbgJ0EaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 00:30:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id o129so182503pfb.1;
        Mon, 26 Oct 2020 21:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EvxluNYScqE9/+oNpimTLZ/MpaH9PmvWUZKFcfNbe9w=;
        b=eg06qM1loGza6vY7nRp0z7TUUiVYvjMRW/Vnr0JOIKrCF/MCSSbaFsQ4jhm9+Ov4Bt
         zb/gz29Etk7mERr2UgirYbMPi+Sv9qDISaTLD+s2FnaQd3KyAS0cN2ZViOVzBFFnHqXH
         vbqDldI2g3OJNYFQ90A2n8w7envMcS8herRPB9UwWI3zJr3pa+Owo4btMwH0+RnR3+2C
         p0T6o1JmBEIhq51Q7XEIezVieTKY2aBJP16b+9c/usDfroiHfo+GHXfcEoRiuNT5vmBx
         A7cIqLlgz43cxfV74bAmt0Arv1BUGogeUkybojd99AQMTuz+gvgPCC3e3F3x5WJSa8J+
         6WAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EvxluNYScqE9/+oNpimTLZ/MpaH9PmvWUZKFcfNbe9w=;
        b=gUIZAOuquxanU/OWFR688uaQE2+ERiJWPjnykRFDR80T9k2bqnLvtul6hzLz/5Bz1u
         xR+EkfRMANiOhpNhdsyqt2JmLcElER7qNZML858xnQj/8R/Qrt+xbgdW2mReJxrg4s8A
         tEWiq/C4+WDP7sDNXjWA3oJIq3nNe8upz774vk8CKx8iDDvz1PYkBtQk/kp0w7viM2Vi
         SRnUVM4as4lrLWBeyT4ZjJm7IAahH66PDrISr7omyfbi5J3HUVdmxr8ZSUA54Dbuv7gc
         Ip/mYsn4/5vSc/LUk/+nXYNieorkZRoePFU3Y7ffPmbYXKnGdEr8jkA4qgYOlBSeBKgC
         CDYg==
X-Gm-Message-State: AOAM532uVdaYjEIkiH+dQmRudGWj9ccmdhjregFztv5rTGPX7ZeNlxLS
        Lv2PdSUDSJyAjSGPXbRNSSY=
X-Google-Smtp-Source: ABdhPJyoLi8xWvgUHzfW1mpR0/pR9kM8v65Q7bgu94YbETTydWKda4uy3DFjX8BrzmvhlErSD2foow==
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id w4-20020a6230040000b029015647d14072mr580435pfw.63.1603773017827;
        Mon, 26 Oct 2020 21:30:17 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:6966])
        by smtp.gmail.com with ESMTPSA id h2sm324403pjv.15.2020.10.26.21.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 21:30:16 -0700 (PDT)
Date:   Mon, 26 Oct 2020 21:30:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
 <20201022141154.GB2332608@krava>
 <20201022104205.728dd135@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022104205.728dd135@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:42:05AM -0400, Steven Rostedt wrote:
> On Thu, 22 Oct 2020 16:11:54 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > I understand direct calls as a way that bpf trampolines and ftrace can
> > co-exist together - ebpf trampolines need that functionality of accessing
> > parameters of a function as if it was called directly and at the same
> > point we need to be able attach to any function and to as many functions
> > as we want in a fast way
> 
> I was sold that bpf needed a quick and fast way to get the arguments of a
> function, as the only way to do that with ftrace is to save all registers,
> which, I was told was too much overhead, as if you only care about
> arguments, there's much less that is needed to save.
> 
> Direct calls wasn't added so that bpf and ftrace could co-exist, it was
> that for certain cases, bpf wanted a faster way to access arguments,
> because it still worked with ftrace, but the saving of regs was too
> strenuous.

Direct calls in ftrace were done so that ftrace and trampoline can co-exist.
There is no other use for it.

Jiri,
could you please redo your benchmarking hardcoding ftrace_managed=false ?
If going through register_ftrace_direct() is indeed so much slower
than arch_text_poke() then something gotta give.
Either register_ftrace_direct() has to become faster or users
have to give up on co-existing of bpf and ftrace.
So far not a single user cared about using trampoline and ftrace together.
So the latter is certainly an option.

Regardless, the patch 7 (rbtree of kallsyms) is probably good on its own.
Can you benchmark it independently and maybe resubmit if it's useful
without other patches?
