Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2A1D4186
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 01:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgENXGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 19:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728386AbgENXGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 19:06:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B05CC061A0C;
        Thu, 14 May 2020 16:06:35 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so373865qts.9;
        Thu, 14 May 2020 16:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GfWzlFsuAoUDmdua/9uNW6OpJdltnvCGSH8AunyR6Aw=;
        b=dmHN/+qed5ck2ukkXg9tSwKuGSueTRQ7MyAf9K22IGxsHiAion1j6GJvRTVVEorB8S
         MLoKu+d2yfbCGMPAvCodrteG3tGfI4ItYnb5XmWTEBgY7lHK59yyx9OoMbIPjAViV/L3
         Tf023jZee/oTBzXiYBZ7hwcdUAJf4ooM2hozL9ZyaizYzQNPudOlC50+HqCLIrXnscyy
         Cc3BlDrjgyv3B8HqVQR44DeZ9xxR5KAiyUfsgdUxl0pD7k0wuFGdSkL+ZVbjkmboSHtF
         nRTx25zrGP1owLbLwzPOa4zFLvMsroc21ZpWrH1Y3mX7RlK17t4qBm1E1eZ4xY3gPV2j
         wrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfWzlFsuAoUDmdua/9uNW6OpJdltnvCGSH8AunyR6Aw=;
        b=ULMtu/DH3wU8UbZyXi0IZoetXE+TMYNT69B/YPQl2P6lbkMDmHPNvMkpbokbbQHpGR
         DwlXRPUNPSYCkPU8B8b2UM8zsG9FVkPyF8NlkWmiQ6Dh6EuuWpr5ftrDEWUOFVkH99uM
         n6yIgLy+32vvCofYW0qPEt/5df8IhHWXHtpKWnpPA83SPAOBu8W2NoS/+z+bFeKxEYdb
         GSBrIAzM2jP1JD//Yf/BbX9g34sA2dzHfVX2sCuQ46D02uYBEIGYALQq886IuGap8AHh
         yjdIkiamEeCTXF0D7GpbZ6JArWJOXUXoJiTpPzW4Pq5uHAKhQOy09aadHFB22L4Rd3qS
         rYGg==
X-Gm-Message-State: AOAM5312fEIjZDj8MTCUlNk8+2R3KLrfwCYxjiHRMThu+2VykfYUOYLu
        5CthfH2d/1mbRGtOOsYKCrVvX0mUpR+D+PKqLAc=
X-Google-Smtp-Source: ABdhPJxap0Mg4yJ1qtZcnaDhQEIudfGg97y5b6RxA41JA8Q/RM+whiJBkVDsozZeZuovG4h9zY4U1FffOrriKMDojjE=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr575276qtc.93.1589497594152;
 Thu, 14 May 2020 16:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87h7wixndi.fsf@nanos.tec.linutronix.de> <CAEf4Bzbj-WvRkoGxkSFtK5_1JfQxthoFid398C97RM0ppBb0dA@mail.gmail.com>
 <20200514225646.4kgc7lrsviusujg2@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200514225646.4kgc7lrsviusujg2@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 16:06:23 -0700
Message-ID: <CAEf4Bza2eD4de6m2e_vmbB9pDsCYr+jsWfMe+u2wWrfRaxXZdw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, linux-arch@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
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

On Thu, May 14, 2020 at 3:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 14, 2020 at 02:30:11PM -0700, Andrii Nakryiko wrote:
> > On Thu, May 14, 2020 at 1:39 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > >
> > > Jakub Kicinski <kuba@kernel.org> writes:
> > >
> > > > On Wed, 13 May 2020 12:25:27 -0700 Andrii Nakryiko wrote:
> > > >> One interesting implementation bit, that significantly simplifies (and thus
> > > >> speeds up as well) implementation of both producers and consumers is how data
> > > >> area is mapped twice contiguously back-to-back in the virtual memory. This
> > > >> allows to not take any special measures for samples that have to wrap around
> > > >> at the end of the circular buffer data area, because the next page after the
> > > >> last data page would be first data page again, and thus the sample will still
> > > >> appear completely contiguous in virtual memory. See comment and a simple ASCII
> > > >> diagram showing this visually in bpf_ringbuf_area_alloc().
> > > >
> > > > Out of curiosity - is this 100% okay to do in the kernel and user space
> > > > these days? Is this bit part of the uAPI in case we need to back out of
> > > > it?
> > > >
> > > > In the olden days virtually mapped/tagged caches could get confused
> > > > seeing the same physical memory have two active virtual mappings, or
> > > > at least that's what I've been told in school :)
> > >
> > > Yes, caching the same thing twice causes coherency problems.
> > >
> > > VIVT can be found in ARMv5, MIPS, NDS32 and Unicore32.
> > >
> > > > Checking with Paul - he says that could have been the case for Itanium
> > > > and PA-RISC CPUs.
> > >
> > > Itanium: PIPT L1/L2.
> > > PA-RISC: VIPT L1 and PIPT L2
> > >
> > > Thanks,
> > >
> >
> > Jakub, thanks for bringing this up.
> >
> > Thomas, Paul, what kind of problems are we talking about here? What
> > are the possible problems in practice?
>
> VIVT cpus will have issues with coherency protocol between cpus.
> I don't think it applies to this case.
> Here all cpus we have the same phys page seen in two virtual pages.
> That mapping is the same across all cpus.
> But any given range of virtual addresses in these two pages will
> be accessed by only one cpu at a time.
> At least that's my understanding of Andrii's algorithm.
> We probably need to white board the overlapping case a bit more.
> Worst case I think it's fine to disallow this new ring buffer
> on such architectures. The usability from bpf program side
> is too great to give up.

From what Paul described, I think this will work in any case. Each
byte of reserved/committed record is going to be both written and
consumed using exactly the same virtual mapping and only that one.
E.g., in case of samples starting at the end of ringbuf and ending at
the beginning. Header and first part will be read using first set of
mapped pages, while second part will be written and read using second
set of pages (never first set of pages). So it seems like everything
should be fine even on VIVT architectures?

More visually, copying diagram from the code:

------------------------------------------------------
| meta pages |     mapping 1     |     mapping 2     |
------------------------------------------------------
|            | 1 2 3 4 5 6 7 8 9 | 1 2 3 4 5 6 7 8 9 |
------------------------------------------------------
|            | TA             DA | TA             DA |
------------------------------------------------------
                              ^^^^^^^

DA is always written/read using "mapping 1", while TA is always
written/read through mapping 2. Never DA is accessed through "mapping
2", nor TA is accessed through "mapping 1".
