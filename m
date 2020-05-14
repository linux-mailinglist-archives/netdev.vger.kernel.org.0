Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F281D415D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgENW4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728928AbgENW4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:56:50 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568A1C061A0C;
        Thu, 14 May 2020 15:56:50 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s20so134154plp.6;
        Thu, 14 May 2020 15:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XiaBpfOmFfQ/vjrDyHboqqRHAjdZE5Nrpi+CJVxtMDs=;
        b=abUr4j4YWSOoo0jyLnRCCWOIXriRBnlKIzGmuB/uPEbF52IZnuSl5PJw4AyRFXRapo
         lzPdoImomqnGsE7Zym7zXqvo4Tw/lFrLgxMkE/25SL9UhgZYuUIHRJDIM7tm39yel0qv
         CD+E5PcsajVHWOOekjpigLvKCKJerWVKmh68dlWKDusVO/l+J8lZhpVgVaQWw7VexkwB
         qh3ylM/iNvMqgj5rH+F1VESsn7eXO7vRyIeePOijMcfRNhxsyzk8ck2PUw3UXpaJK4G7
         fXZ4Eb69M788Ei1iptBeIhOWlFs2seETlLnK1zeQHPfRqOVbq9chxUJzgoTph6r3XnX0
         xltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XiaBpfOmFfQ/vjrDyHboqqRHAjdZE5Nrpi+CJVxtMDs=;
        b=L2Dhpl9DcXXSaV0Vcyq8irA58sGyr3MFr+ScpcgnTQ6WieQbJADCBUUIKFzIeUKah0
         b5C0DOg9hTxmYstwL/UsByJ371gYg09eg7IEwoXfhZ6EzTNzHCN4yyFM73/ggVW/0YNf
         Gm+tkVNhzis4+1W8/+O2bsNPotjYuHnBgEH7u8Dc8UwV1mYuloXuGyrTq3lFocfhp5xz
         SblUfvBlLoiI+QOmpKxxouv+GO0KgG59qDrDgRmDPGi1E7tVfHZGTWvEiWa7a81RusrJ
         x9tYwX7Q5FdGlo1wG5CTg1NzB1AnIjyHGsHpFAT1haYhSNECHf5kLJ7Zx1FvYnzF9SEI
         +eqQ==
X-Gm-Message-State: AOAM531aZrJOeJAhREIL4faZPwu6jbGCE8j6GO0Tx5bo+Qsn0PNZhqjb
        YfZPIZijphpxMmqDiyaOUFaIWiWi
X-Google-Smtp-Source: ABdhPJzhHnrzXKwcFtyxyZezTmLTXPm9RVKQ1TE2OAxWdHQXhCfPGSZUWEgAn/mVjquWJ3NNLwNBBg==
X-Received: by 2002:a17:90a:4d07:: with SMTP id c7mr325622pjg.70.1589497009830;
        Thu, 14 May 2020 15:56:49 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f480])
        by smtp.gmail.com with ESMTPSA id i10sm219698pfa.166.2020.05.14.15.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 15:56:49 -0700 (PDT)
Date:   Thu, 14 May 2020 15:56:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, linux-arch@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
Message-ID: <20200514225646.4kgc7lrsviusujg2@ast-mbp.dhcp.thefacebook.com>
References: <20200513192532.4058934-1-andriin@fb.com>
 <20200513192532.4058934-2-andriin@fb.com>
 <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87h7wixndi.fsf@nanos.tec.linutronix.de>
 <CAEf4Bzbj-WvRkoGxkSFtK5_1JfQxthoFid398C97RM0ppBb0dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbj-WvRkoGxkSFtK5_1JfQxthoFid398C97RM0ppBb0dA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:30:11PM -0700, Andrii Nakryiko wrote:
> On Thu, May 14, 2020 at 1:39 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Jakub Kicinski <kuba@kernel.org> writes:
> >
> > > On Wed, 13 May 2020 12:25:27 -0700 Andrii Nakryiko wrote:
> > >> One interesting implementation bit, that significantly simplifies (and thus
> > >> speeds up as well) implementation of both producers and consumers is how data
> > >> area is mapped twice contiguously back-to-back in the virtual memory. This
> > >> allows to not take any special measures for samples that have to wrap around
> > >> at the end of the circular buffer data area, because the next page after the
> > >> last data page would be first data page again, and thus the sample will still
> > >> appear completely contiguous in virtual memory. See comment and a simple ASCII
> > >> diagram showing this visually in bpf_ringbuf_area_alloc().
> > >
> > > Out of curiosity - is this 100% okay to do in the kernel and user space
> > > these days? Is this bit part of the uAPI in case we need to back out of
> > > it?
> > >
> > > In the olden days virtually mapped/tagged caches could get confused
> > > seeing the same physical memory have two active virtual mappings, or
> > > at least that's what I've been told in school :)
> >
> > Yes, caching the same thing twice causes coherency problems.
> >
> > VIVT can be found in ARMv5, MIPS, NDS32 and Unicore32.
> >
> > > Checking with Paul - he says that could have been the case for Itanium
> > > and PA-RISC CPUs.
> >
> > Itanium: PIPT L1/L2.
> > PA-RISC: VIPT L1 and PIPT L2
> >
> > Thanks,
> >
> 
> Jakub, thanks for bringing this up.
> 
> Thomas, Paul, what kind of problems are we talking about here? What
> are the possible problems in practice?

VIVT cpus will have issues with coherency protocol between cpus.
I don't think it applies to this case.
Here all cpus we have the same phys page seen in two virtual pages.
That mapping is the same across all cpus.
But any given range of virtual addresses in these two pages will
be accessed by only one cpu at a time.
At least that's my understanding of Andrii's algorithm.
We probably need to white board the overlapping case a bit more.
Worst case I think it's fine to disallow this new ring buffer
on such architectures. The usability from bpf program side
is too great to give up.
