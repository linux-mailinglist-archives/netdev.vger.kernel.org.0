Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3C1230F4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfLQP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:57:47 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36135 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbfLQP5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:57:46 -0500
Received: by mail-oi1-f196.google.com with SMTP id c16so4972618oic.3;
        Tue, 17 Dec 2019 07:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgsJlsnEOSDd3+anDElz+/MLtJOX8bL3V5H2TOhN4zU=;
        b=ONl1GkVupx/9vxFQ/42Bu9QIieHlkn+bNwJ0gGzbXw/rgAVP7AB4cxjTMcKfWKpXCI
         BElqfDMLtktOIHQnKG+kmP/1OvG+jVmS34f/YTqhFat86sKxgMxV2pk634IVmYx8PNG0
         hYj0HXPwV3UehLmmF1FpUp8ISMoeOlM0vr6vqrZa7Yo+qgjAJeThVYdOhRyGPOyAYacn
         ornVtCCSEPzU2apT8nHRCy9ubbxNKeVUJ5rof9oJrSNkMHOYyj6NLYRytzcv6iJ/RmRQ
         SfXq3OZcsHX+R7kPHxsv3iu0ftQN6qZmf97cohFF75Y69cfdxPSPRBUTEkvtAPK+lD2B
         9iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgsJlsnEOSDd3+anDElz+/MLtJOX8bL3V5H2TOhN4zU=;
        b=HV6EmZYs5FOVmaNW6Au7rDm3tcc0Xd0ZdQDD3cN09YO/TH9Zi4SCe1JxY0AH6hQWnk
         XIwqj3pIRc2USBd02lwwPbT2/1e3r9c1EZouRCN7xW2tIMqDJEncW5gl3tEeVzs+ZfK9
         3Tdndx4CYc4WZNMkYUGdzUwx3ILz1kUsPJEao7PbkfaAwT2U64+0QSaPs8SpIlB7BiAS
         9EbB/Fm9S4vJGrDdo8d89fO7LdR1qA5KenT4G3GeekkHkVRPOBNBUQHAelkgkah+x5XB
         BdPF8p8bhIPHqK9xXxEEX779919BdIBSq0UXzIk5sODmcaUziE/zQo4A6Nr/VjDIYR1r
         FFew==
X-Gm-Message-State: APjAAAX24sFM1qa27iDvf3aI2Msg5SHh1Dq6DRXeyHscRLHB/u+EO8vS
        sn+MwnxxmHKq8B8S6OhV1W7nGdk+Kv5C/canHh8=
X-Google-Smtp-Source: APXvYqy+H4AjSCMbsIFUw3s5H9RuLkB1/H+/canhjchlOwoGIzP563muGoFOj/jvQ21OvmLFhpAB1KMBKCkr3N9gDWM=
X-Received: by 2002:aca:54cc:: with SMTP id i195mr1825342oib.126.1576598265181;
 Tue, 17 Dec 2019 07:57:45 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a6f2030598bbe38c@google.com> <0000000000000e32950599ac5a96@google.com>
 <20191216150017.GA27202@linux.fritz.box> <CAJ8uoz3nCxcmnPonNunYhswskidn=PnN8=4_jXW4B=Xu4k_DoQ@mail.gmail.com>
 <CAJ8uoz312gDBGpqOJiKqrXn456sy6u+Gnvcvv_+0=EimasRoUw@mail.gmail.com> <20191217154031.GI5624@arrakis.emea.arm.com>
In-Reply-To: <20191217154031.GI5624@arrakis.emea.arm.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 17 Dec 2019 16:57:34 +0100
Message-ID: <CAJ8uoz3yDK8sEE05cKA8siBi-Dc0wtbe1-zYgbz_-pd5t69j8w@mail.gmail.com>
Subject: Re: WARNING in wp_page_copy
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        kirill.shutemov@linux.intel.com, justin.he@arm.com,
        linux-mm@kvack.org,
        syzbot <syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        linux-kernel@vger.kernel.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 4:40 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Hi Magnus,
>
> Thanks for investigating this. I have more questions below rather than a
> solution.
>
> On Tue, Dec 17, 2019 at 02:27:22PM +0100, Magnus Karlsson wrote:
> > On Mon, Dec 16, 2019 at 4:10 PM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > > On Mon, Dec 16, 2019 at 4:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On Sat, Dec 14, 2019 at 08:20:07AM -0800, syzbot wrote:
> > > > > syzbot has found a reproducer for the following crash on:
> > > > >
> > > > > HEAD commit:    1d1997db Revert "nfp: abm: fix memory leak in nfp_abm_u32_..
> > > > > git tree:       net-next
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1029f851e00000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cef1fd5032faee91
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
> > > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000
> > > > >
> > > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > > Reported-by: syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com
> > > >
> > > > Bjorn / Magnus, given xsk below, PTAL, thanks!
> > >
> > > Thanks. I will take a look at it right away.
> > >
> > > /Magnus
> >
> > After looking through the syzcaller report, I have the following
> > hypothesis that would dearly need some comments from MM-savy people
> > out there. Syzcaller creates, using mmap, a memory area that is
>
> I guess that's not an anonymous mmap() since we don't seem to have a
> struct page for src in cow_user_page() (the WARN_ON_ONCE path). Do you
> have more information on the mmap() call?

I have this from the syzcaller logs:

mmap(&(0x7f0000001000/0x2000)=nil, 0x2000, 0xfffffe, 0x12, r8, 0x0)
getsockopt$XDP_MMAP_OFFSETS(r8, 0x11b, 0x7, &(0x7f0000001300),
&(0x7f0000000100)=0x60)

The full log can be found at:
https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000

Hope this helps.

> > write-only and supplies this to a getsockopt call (in this case
> > XDP_STATISTICS, but probably does not matter really) as the area where
> > it wants the values to be stored. When the getsockopt implementation
> > gets to copy_to_user() to write out the values to user space, it
> > encounters a page fault when accessing this write-only page. When
> > servicing this, it gets to the following piece of code that triggers
> > the warning that syzcaller reports:
> >
> > static inline bool cow_user_page(struct page *dst, struct page *src,
> >                                  struct vm_fault *vmf)
> > {
> > ....
> > snip
> > ....
> >        /*
> >          * This really shouldn't fail, because the page is there
> >          * in the page tables. But it might just be unreadable,
> >          * in which case we just give up and fill the result with
> >          * zeroes.
> >          */
> >         if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
> >                 /*
> >                  * Give a warn in case there can be some obscure
> >                  * use-case
> >                  */
> >                 WARN_ON_ONCE(1);
> >                 clear_page(kaddr);
> >         }
>
> So on x86, a PROT_WRITE-only private page is mapped as non-readable? I
> had the impression that write-only still allows reading by looking at
> the __P010 definition.
>
> Anyway, if it's not an anonymous mmap(), whoever handled the mapping may
> have changed the permissions (e.g. some device).
>
> > So without a warning. My hypothesis is that if we create a page in the
> > same way as syzcaller then any getsockopt that does a copy_to_user()
> > (pretty much all of them I guess) will get this warning.
>
> The copy_to_user() only triggers the do_wp_page() fault handling. If
> this is a CoW page (private read-only presumably, or at least not
> writeable), the kernel tries to copy the original page given to
> getsockopt into a new page and restart the copy_to_user(). Since the
> kernel doesn't have a struct page for this (e.g. PFN mapping), it uses
> __copy_from_user_inatomic() which fails because of the read permission.
>
> > I have not tried this, so I might be wrong. If this is true, then the
> > question is what to do about it. One possible fix would be just to
> > remove the warning to get the same behavior as before. But it was
> > probably put there for a reason.
>
> It was there for some obscure cases, as the comment says ;). If the
> above is a valid scenario that the user can trigger, we should probably
> remove the WARN_ON.
>
> --
> Catalin
>
