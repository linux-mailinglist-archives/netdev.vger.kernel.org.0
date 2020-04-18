Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E641AF226
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgDRQFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgDRQFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 12:05:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406E4C061A0C;
        Sat, 18 Apr 2020 09:05:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u65so2679012pfb.4;
        Sat, 18 Apr 2020 09:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zQbxuYl7fJ5XgX5X7WJEBt7YB36RJC8DjH9MPhzDKf4=;
        b=f/A5Ngw4MFJUz9/XhyRBsIuI4zQoGO+id+QicmyY9RVQgc/SZjNiYCccv0eA+ErUcq
         EGJhurO61J0L1afHN/k8xB8VJJ6xtTPqhdzbyemqz03O/xf8V3Yxx1kU1JKCAGVjVOdM
         jWKoUPHtw2LtjOXt7DS60LiVvZiBBdBcjemjLLjlNkepcU0GrcLfnsp54/9LHzKYdRtb
         BS/8WcsLEop10Ds3ownBk1F+sZaDmeW2AFP764HhYuA52qa31JPXX96ID6srZFQNNiSC
         Tj3kfuhjZFIT8otn78mf12DAxSxXQOQmEnOYfz6H+4H8p6ksvjDIdYFKwx781/kKv3Sd
         uCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zQbxuYl7fJ5XgX5X7WJEBt7YB36RJC8DjH9MPhzDKf4=;
        b=G3fB589gKaDRPsZnO6xOCTTmJQLbJig0v4BG24oC0qYEGBYVD0fX1sasdLbgreYBhX
         2gU1wTfTyyqOx/IHiRqDBSXaKZDED432D3xYZ9j7egTAu1RMf3gruPxCRrM4LP/zAkkL
         Z/QIdYyrPcA54CjaV52ZQvu67aiV4MGcbZ+pE9tO3Cw0Eui4xW1aQJ8QNWT+EBtIzN6B
         dTLOzTP0uKbduiNpIsSp1ljoDa+8YTHEceXisva8mslDSc10YIF22LwbQxCTvTJRnUi3
         rLMTqgC368GizCRrOJUwo3w3y21SiIYf/+W/fQAd9rq5xC4KKSqJPOurLL7fPkdnHari
         hh9Q==
X-Gm-Message-State: AGi0PuZRdFcXW7Z7PGmJ1SLzVLSAJraSOwnXF+jM0QSuyimWwr2cqrHu
        Mn/MRmKIGu9f3GwvY9Onskg=
X-Google-Smtp-Source: APiQypLeiu7Gz9muc9e3XcwuWz5gH4N8+OXU4bhXe2B7sUGygjW1pcIFZKY52dsurQeO5CnY6cg7VQ==
X-Received: by 2002:a62:19d5:: with SMTP id 204mr8805423pfz.75.1587225939559;
        Sat, 18 Apr 2020 09:05:39 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7a4])
        by smtp.gmail.com with ESMTPSA id l37sm4860358pje.12.2020.04.18.09.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 09:05:38 -0700 (PDT)
Date:   Sat, 18 Apr 2020 09:05:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
Message-ID: <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire wrote:
> The printk family of functions support printing specific pointer types
> using %p format specifiers (MAC addresses, IP addresses, etc).  For
> full details see Documentation/core-api/printk-formats.rst.
> 
> This RFC patchset proposes introducing a "print typed pointer" format
> specifier "%pT<type>"; the type specified is then looked up in the BPF
> Type Format (BTF) information provided for vmlinux to support display.

This is great idea! Love it.

> The above potential use cases hint at a potential reply to
> a reasonable objection that such typed display should be
> solved by tracing programs, where the in kernel tracing records
> data and the userspace program prints it out.  While this
> is certainly the recommended approach for most cases, I
> believe having an in-kernel mechanism would be valuable
> also.

yep. This is useful for general purpose printk.
The only piece that must be highlighted in the printk documentation
that unlike the rest of BPF there are zero safety guarantees here.
The programmer can pass wrong pointer to printk() and the kernel _will_ crash.

>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> 
>   pr_info("%pTN<struct sk_buff>", skb);

why follow "TN" convention?
I think "%p<struct sk_buff>" is much more obvious, unambiguous, and
equally easy to parse.

> ...gives us:
> 
> {{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,

This is unreadable.
I like the choice of C style output, but please format it similar to drgn. Like:
*(struct task_struct *)0xffff889ff8a08000 = {
	.thread_info = (struct thread_info){
		.flags = (unsigned long)0,
		.status = (u32)0,
	},
	.state = (volatile long)1,
	.stack = (void *)0xffffc9000c4dc000,
	.usage = (refcount_t){
		.refs = (atomic_t){
			.counter = (int)2,
		},
	},
	.flags = (unsigned int)4194560,
	.ptrace = (unsigned int)0,

I like Arnaldo's idea as well, but I prefer zeros to be dropped by default.
Just like %d doesn't print leading zeros by default.
"%p0<struct sk_buff>" would print them.

> The patches are marked RFC for several reasons
> 
> - There's already an RFC patchset in flight dealing with BTF dumping;
> 
> https://www.spinics.net/lists/netdev/msg644412.html
> 
>   The reason I'm posting this is the approach is a bit different 
>   and there may be ways of synthesizing the approaches.

I see no overlap between patch sets whatsoever.
Why do you think there is?

> - The mechanism of vmlinux BTF initialization is not fit for purpose
>   in a printk() setting as I understand it (it uses mutex locking
>   to prevent multiple initializations of the BTF info).  A simple
>   approach to support printk might be to simply initialize the
>   BTF vmlinux case early in boot; it only needs to happen once.
>   Any suggestions here would be great.
> - BTF-based rendering is more complex than other printk() format
>   specifier-driven methods; that said, because of its generality it
>   does provide significant value I think
> - More tests are needed.

yep. Please make sure to add one to selftest/bpf as well.
bpf maintainers don't run printk tests as part of workflow, so
future BTF changes will surely break it if there are no selftests/bpf.

Patch 2 isn't quite correct. Early parse of vmlinux BTF does not compute
resolved_ids to save kernel memory. The trade off is execution time vs kernel
memory. I believe that saving memory is more important here, since execution is
not in critical path. There is __get_type_size(). It should be used in later
patches instead of btf_type_id_size() that relies on pre-computed
resolved_sizes and resolved_ids.
