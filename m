Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40391D02F4
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 01:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgELXSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 19:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbgELXSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 19:18:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B90AC061A0C;
        Tue, 12 May 2020 16:18:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f15so6061789plr.3;
        Tue, 12 May 2020 16:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hdPjV6jWUcTC2CiPdplB6/22a1oEBF7iWMP5llDmu/0=;
        b=VIDBf5GfhUoY9PKZXiJXrhdxXQOzSYVHJ6w3DN0+xZfLwFVEOs5nzNTFdpprBESotn
         1s3du8ty9UKVULirUQ2JRv7SNLl1CY9GOzhbxkZ5FYH9QN9dHn2xWf1OCUq8ljNjiQSE
         5c0FZFZAZC+Jd1+hNeQ7QSVrAuzMdU5vHE9T4HpWaybdAZyzlC8wCmCeSNFWo64n0LvA
         sr1hWULJRLkbaypiz0DVnNecFAIiysfsujKrFNj8rB/6cju35uw1o/NL6crD4ew+DAsj
         Nina2/ma9aRwNOvdrPoVvOnsxY5cX7X50yfyv8VTl65s3yTSAdLN6QGFKdnwVu+20Ooh
         FsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hdPjV6jWUcTC2CiPdplB6/22a1oEBF7iWMP5llDmu/0=;
        b=TI9EXBxzoBISIXEndwF5XfldXswbYME9kRLFhzjx2sv8myOfIcpzNwLM2eZ3/O+Q3M
         I6Hwn14JDJQhYIVvFGz30+oLa0zIWt/E6k5L9fOcQuHgmn4Li1h32+kCtJF0ZiqKcIFr
         zwqK4pYvxLVtAEBU3dW0R5Cjf2lbLlLqnCJkgXeSvA1XXbVKa1nNBu3mK9ZQwUK0hY2j
         uE183vNQQ1ItfwJPV8X6bsULczUAc1LirAEqbTGaoWBQ+UmCDJbgQvr+0zjqBByBmDLd
         +YcSpUWjmQTt+SNIYlatYdJRvBLnjTIsTYukgsn3VdIKVUaQH0Ylb4Wi5+xHgHsF7AYL
         6nbQ==
X-Gm-Message-State: AOAM532zixxxoxSVdv/PzZGI4A8FY0zACvHluxxM8fcZc34yhWx2HRTo
        q0z3o45WkMEbH6VkP7/0js8mpwZC
X-Google-Smtp-Source: ABdhPJxlZ1w6+YIZqsYDVLBuny2kPYkkS1/9zjAgY2cAO1a6Ie4x4ICY9AMD0Z2Zi/PSgRoMWbyYgA==
X-Received: by 2002:a17:90a:22d0:: with SMTP id s74mr7776507pjc.28.1589325517448;
        Tue, 12 May 2020 16:18:37 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:68dc])
        by smtp.gmail.com with ESMTPSA id y24sm12730604pfn.211.2020.05.12.16.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 16:18:36 -0700 (PDT)
Date:   Tue, 12 May 2020 16:18:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
Message-ID: <20200512231834.sbyhb3lmelw43z7v@ast-mbp>
References: <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
 <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
 <87o8s9eg5b.fsf@toke.dk>
 <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
 <87h7wlwnyl.fsf@toke.dk>
 <alpine.LRH.2.21.2005121009220.22093@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.21.2005121009220.22093@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 10:53:38AM +0100, Alan Maguire wrote:
> On Tue, 12 May 2020, Toke Høiland-Jørgensen wrote:
> 
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > 
> > >> > Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
> > >> > It just needs to become a linked list.
> > >> > The api extension could be like this:
> > >> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
> > >> > (currently it's just bpf_raw_tp_open(prog_fd))
> > >> > The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
> > >> > to hold the linked_prog and its corresponding btf_id.
> > >> > I'm proposing to extend raw_tp_open with this pair as well to
> > >> > attach existing fentry/fexit/freplace prog to another target.
> > >> > Internally the kernel verify that btf of current linked_prog
> > >> > exactly matches to btf of another requested linked_prog and
> > >> > if they match it will attach the same prog to two target programs (in case of freplace)
> > >> > or two kernel functions (in case of fentry/fexit).
> > >> 
> > >> API-wise this was exactly what I had in mind as well.
> > >
> > > perfect!
> >
> 
> Apologies in advance if I've missed a way to do this, but
> for fentry/fexit, if we could attach the same program to
> multiple kernel functions, it would be great it we could
> programmatically access the BTF func proto id for the
> attached function (prog->aux->attach_btf_id I think?).
> Then perhaps we could support access to that and associated
> ids via a helper, roughly like:
> 
> s32 btf_attach_info(enum btf_info_wanted wanted,
> 		    struct __btf_ptr *ptr,__u64 flags);
> 
> The info_wanted would be BTF_INFO_FUNC_PROTO, BTF_INFO_RET_TYPE,
> BTF_INFO_NARGS, BTF_INFO_ARG1, etc.
> 
> With that and the BTF-based printk support in hand, we could
> potentially use bpf_trace_printk() to print function arguments
> in an attach-point agnostic way.  The BTF printk v2 patchset has
> support for BTF id-based display (it's not currently used in that
> patchset though). We'd have to teach it to print BTF func protos
> but that's not too tricky I think. An ftrace-like program that
> would print out function prototypes for the attached function
> would look something like this:
> 
> 	struct __btf_ptr func = { 0 };
> 	btf_attach_info(BTF_INFO_FUNC_PROTO, &func, 0); 
> 	btf_printk("%pT", &func);

Currently fentry/fexit cannot be attached to multiple kernel funcs
and no one is working on it.
Attaching freplace to multiple bpf progs with the same signature
is a different use case. I've started on it, but priority went down.

In general it's possible to make the same fentry prog run on multiple
kernel funcs, but I don't see a use case yet, since bpf side won't
be able to see any arguments. It will be less useful than kprobe+bpf.
That prog at least has struct pr_regs to examine.
So I'm not sure what you're trying to achieve.
If you just want to print kernel function arguments than invent
a new helper for bpf kprobe progs. Like bpf_printk_current_func(pt_regs);
Since it's all dynamic that helper would need to resolve regs->IP
into string than search vmlinux btf for that function and then
print regs->DI,SI according to btf func proto.
