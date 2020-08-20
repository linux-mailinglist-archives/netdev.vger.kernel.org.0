Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C524C7A6
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgHTWQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgHTWQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:16:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBD8C061385;
        Thu, 20 Aug 2020 15:16:41 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 128so23915pgd.5;
        Thu, 20 Aug 2020 15:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cVsitnGPC4Tz8Cr+9wLXyFVvIv494GvoZr7z9xZeImY=;
        b=HPbmHOq8JYjpqQdXLkYriZY04fz7KqDLqWIH7zqk+cRwWhi0G+uR42T20N8PPaBimI
         9F0jBlhnCYhmVGOYGgvJqezBnnJCDJLN2iMYlWCDMChekCjTUNmi4W2rDKiuAzEuveXp
         rB7/+U7wmxC6CszlOVhmIIFLf/G+dECOlqzTAFfw7BeFh1vqlG8dQvowaXwzOtkg85zs
         zb1ufYE0GDWeMmWYz26caQPs+H4EZnxSpLFIu6BIkGy5RK4y9f1U26uDxp9dpIRklWZf
         7Cr/sgE+V/wzsyrxm+L0VUhBivv7xke7HpJQ6Jaa5nucsCGw7GlfgaEIspb84D8VVi4i
         MySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cVsitnGPC4Tz8Cr+9wLXyFVvIv494GvoZr7z9xZeImY=;
        b=dbFbDEVdCsLFJqhgS4QuAqhJZc5YLQtsqt0P1cLsG0KwBPD+1xtYtGh144FYWQGjHI
         5a1oIbW4kaaNmPz3uQAj0xaFBkRGnjOCBpFybYiYZ90Jx/3OyksoiuerfWggW/UjBL6u
         r0Ud/dGtXTiZO7jgtjmXhgkrBBh6a0mFkhL91mh/qjl+DFUFj9fGjL7kFj6ADkIYK/8z
         6XtlG28CaM7t3GhWob068/akxZ4LhyZm5KyiIvw/5K/lW+fAdjfdwTtorJKKiYQTEKOX
         6NzDzaCgKMvnc+rV59Epi9VjJ/MJsN+lGL7Z02HK5aVh0OTBxco8EfFoCA/VNfv+Z9Ap
         U3oA==
X-Gm-Message-State: AOAM532vM/3rMMpndwztWxMaZi1mMR86YdPn3g7pRYVZxdmQ+TonNRvK
        VFTNEGi9dtqnl9hETdKc9CA=
X-Google-Smtp-Source: ABdhPJyaCjfhk6Iw8AEi4PQv4jVqTCIX0LoOjErGjMWsgQgUitUqmPt+DuvkwTpRgavM+58k7qW+DQ==
X-Received: by 2002:a63:d410:: with SMTP id a16mr133799pgh.133.1597961801197;
        Thu, 20 Aug 2020 15:16:41 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8791])
        by smtp.gmail.com with ESMTPSA id i7sm28674pgh.58.2020.08.20.15.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 15:16:40 -0700 (PDT)
Date:   Thu, 20 Aug 2020 15:16:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: make BTF show support generic,
 apply to seq files/bpf_trace_printk
Message-ID: <20200820221636.zkvxx64n3ij72ud5@ast-mbp.dhcp.thefacebook.com>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
 <1596724945-22859-3-git-send-email-alan.maguire@oracle.com>
 <20200813014616.6enltdpq6hzlri6r@ast-mbp.dhcp.thefacebook.com>
 <alpine.LRH.2.21.2008141344560.6816@localhost>
 <20200814170120.q5gcmlapm7aldmzg@ast-mbp.dhcp.thefacebook.com>
 <alpine.LRH.2.21.2008180945380.3461@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2008180945380.3461@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 10:12:05AM +0100, Alan Maguire wrote:
> 
> Fair enough. I'm thinking a helper like
> 
> long bpf_btf_snprintf(char *str, u32 str_size, struct btf_ptr *ptr,
> 		      u32 ptr_size, u64 flags);
> 
> Then the user can choose perf event or ringbuf interfaces
> to share the results with userspace.

makes sense.

> 
> > If the user happen to use bpf_trace_printk("%s", buf);
> > after that to print that string buffer to trace_pipe that's user's choice.
> > I can see such use case when program author wants to debug
> > their bpf program. That's fine. But for kernel debugging, on demand and
> > "always on" logging and tracing the documentation should point
> > to sustainable interfaces that don't interfere with each other,
> > can be run in parallel by multiple users, etc.
> > 
> 
> The problem with bpf_trace_printk() under this approach is
> that the string size for %s arguments is very limited;
> bpf_trace_printk() restricts these to 64 bytes in size.
> Looks like bpf_seq_printf() restricts a %s string to 128
> bytes also.  We could add an additional helper for the 
> bpf_seq case which calls bpf_seq_printf() for each component
> in the object, i.e.
> 
> long bpf_seq_btf_printf(struct seq_file *m, struct btf_ptr *ptr,
> 			u32 ptr_size, u64 flags);

yeah. this one is needed as well.
Please double check that it works out of bpf iterator too.
Especially the case when output is not power of 2.
bpf_iter.c keeps page sized buffer and will restart
iteration on overflow.
Could you please modify progs/bpf_iter_task.c to do
bpf_seq_btf_printf(seq, {task, }, 0);
and check that the output doesn't contain repeated/garbled lines.

Also I'm not sure why you see 64 limit of bpf_trace_printk as a blocker.
We could do:
if (in_nmi())
  use 64 byte on stack
else
  spin_lock_irqsave and use 1k static buffer.
and/or we can introduce bpf_trace_puts(const char *buf, u32 size_of_buf);
with
        .arg1_type      = ARG_PTR_TO_MEM,
        .arg2_type      = ARG_CONST_SIZE,
add null termination check and call trace_bpf_trace_printk() on that
buffer. That will avoid a bunch of copies.
But that still doesn't make bpf_trace_puts() a good interface for
dumping stuff to user space. It's still debug only feature.
