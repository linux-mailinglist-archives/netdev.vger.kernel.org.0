Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86911D4002
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgENVaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgENVaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:30:23 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037A0C061A0C;
        Thu, 14 May 2020 14:30:23 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c24so183424qtw.7;
        Thu, 14 May 2020 14:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H4UMCL/ZAQEjtLZr/jtJEQIWjvOQQgI/OlCTFL0azkY=;
        b=q7z8au5xr8hsQX69vRuEXAMDkkNPxlnTr7m4vcn5WYTht5tdWDUYw39pkVuaXiv1r3
         6zw8O5c86FbPpKfQMEvta2ifR+oTOY1AodXxQegWjmKZg+G1UWV4Gnrls0J5qxgEguKE
         jutNz8dPBcXt84NS1yn0wUMdyfuisl7WUjm9KuTXgCN5fTB6sqa9X+2rHQK3U4IgCOUM
         6GffH+jwQqCGOmW8lBGbzDpENZjpHwAP3CWVrYHJowRsuhxp53BBA3vWcCSxEGtNTyiQ
         UugnAHR1PZNsZ6OHKibrkg/d/sSKVvwQqGm/O+gBSztDiM3tVf2dGtp2YmetTov8l6U3
         Zu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4UMCL/ZAQEjtLZr/jtJEQIWjvOQQgI/OlCTFL0azkY=;
        b=aBtB3VZ5lJHFzWqpfF4YSwJTsQWZQd6IgyTkuJFnBhOByKX4IZOiUpzxOF0XqV7kTU
         JWoj5nyxPYGGo6q1fX19TCK1GM+63n9QPsiUtFbxtWbpzfX83atgmZLq7LtjMhZ+WlaS
         mosgxeUZvW790H0DgJTsZDqITtu3cH9HfuTyKS2poNDNiqJ2aII8QUMTrrMr5obRJd8Z
         zCbr4+Bd8r/ZArXWf+lBKTlIuM4AoUG4YN/gdYnmgTHLgAjcEYR/Bo8jOh4QkpDqCanc
         SPujg34K7v0WAmGp5nrYAFAX1lDpglCZhyHJC8HEQA6w2OYjUBxyNcsjyrZxuAGhlilR
         T01Q==
X-Gm-Message-State: AOAM531d79svjbxLYHEc+scp01b/HKOordRicpzPcC3BIGGcsFMW1tjs
        OM60cloEferklbGXAskHfm358TT4+FS3LBHvFptu8w==
X-Google-Smtp-Source: ABdhPJyyJ68qez6ciKxn/OsZ/uuQarVTts7dyLwnaTSqPq1qqKbWfFAN+g5c5dTigaYkwYKYlPLJ8RJNHGDP1hKt75A=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr218068qtk.59.1589491822211;
 Thu, 14 May 2020 14:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87h7wixndi.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87h7wixndi.fsf@nanos.tec.linutronix.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 14:30:11 -0700
Message-ID: <CAEf4Bzbj-WvRkoGxkSFtK5_1JfQxthoFid398C97RM0ppBb0dA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        linux-arch@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 1:39 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Wed, 13 May 2020 12:25:27 -0700 Andrii Nakryiko wrote:
> >> One interesting implementation bit, that significantly simplifies (and thus
> >> speeds up as well) implementation of both producers and consumers is how data
> >> area is mapped twice contiguously back-to-back in the virtual memory. This
> >> allows to not take any special measures for samples that have to wrap around
> >> at the end of the circular buffer data area, because the next page after the
> >> last data page would be first data page again, and thus the sample will still
> >> appear completely contiguous in virtual memory. See comment and a simple ASCII
> >> diagram showing this visually in bpf_ringbuf_area_alloc().
> >
> > Out of curiosity - is this 100% okay to do in the kernel and user space
> > these days? Is this bit part of the uAPI in case we need to back out of
> > it?
> >
> > In the olden days virtually mapped/tagged caches could get confused
> > seeing the same physical memory have two active virtual mappings, or
> > at least that's what I've been told in school :)
>
> Yes, caching the same thing twice causes coherency problems.
>
> VIVT can be found in ARMv5, MIPS, NDS32 and Unicore32.
>
> > Checking with Paul - he says that could have been the case for Itanium
> > and PA-RISC CPUs.
>
> Itanium: PIPT L1/L2.
> PA-RISC: VIPT L1 and PIPT L2
>
> Thanks,
>

Jakub, thanks for bringing this up.

Thomas, Paul, what kind of problems are we talking about here? What
are the possible problems in practice?

So just for the context, all the metadata (record header) that is
written/read under lock and with smp_store_release/smp_load_acquire is
written through the one set of page mappings (the first one). Only
some of sample payload might go into the second set of mapped pages.
Does this mean that user-space might read some old payloads in such
case?

I could work-around that in user-space, by mmaping twice the same
range, one after the other (second mmap would use MAP_FIXED flag, of
course). So that's not a big deal.

But on the kernel side it's crucial property, because it allows BPF
programs to work with data with the assumption that all data is
linearly mapped. If we can't do that, reserve() API is impossible to
implement. So in that case, I'd rather enable BPF ring buffer only on
platforms that won't have these problems, instead of removing
reserve/commit API altogether.

Well, another way is to just "discard" remaining space at the end, if
it's not sufficient for entire record. That's doable, there will
always be at least 8 bytes available for record header, so not a
problem in that regard. But I would appreciate if you can help me
understand full implications of caching physical memory twice.

Also just for my education, with VIVT caches, if user-space
application mmap()'s same region of memory twice (without MAP_FIXED),
wouldn't that cause similar problems? Can't this happen today with
mmap() API? Why is that not a problem?


>         tglx
