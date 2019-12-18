Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DDC124AE4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfLRPLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:11:32 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40653 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfLRPLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:11:25 -0500
Received: by mail-lj1-f196.google.com with SMTP id u1so2534784ljk.7
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 07:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0o452dtZDcKvnVAQ8Kj3Gm0Xbx2pj/IYUiQTJzQO9gE=;
        b=Fkg0mQdKOLV1WZE8Z1XxbvNcqJdb67rz/Q/NjePD7qIU9ny1yPyJKOOfsOOA4OEkL5
         u+WyT9wy7radyNji9r6O0NL01H1e+aRCp58B6flFwf4fmwkGrGcLEA71Xm7XdDJu9GCh
         NowL3CKkqunsqL0t1gWO2GDCHsWK7l81/dWd7viQeajhILnoEgRkGoTYqA+M8YJN+p0m
         /aiV9wMWADePF00JXxJUjmUrnTyi/mWhUAvDUJCJypvfxj0NKsQhgC5Ui4jhFwGIUnd8
         yZmidC4lSdm9/1PCTq2HFveGp/PVULv2K8U0MH2xtFCdG4H6z4GEhB12BFgYynk34v3W
         79nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0o452dtZDcKvnVAQ8Kj3Gm0Xbx2pj/IYUiQTJzQO9gE=;
        b=erbW6/6fBhLXD4SeJ7Zw/5q3dITla3iIlG0ZPbNNq2o6VYRJQf6vAhSbFPcHO/fOX0
         8DzyfH3VqI6YC4Hmb9RcRzg004Mz6ZuPR8lMS/PCUoLlRLRaNBOVBmPP6Nqv+jN0D/jP
         KxkJSC48iDCeujuRSUZG8cuwD4BuWaF0nYijj0JwcqClNGBp8y2o5QXiqgmgHOgljj07
         MSz+Tm0xRgC4Zczzph6vFK5nanDi41kE5USZIxQ+Nc83Q4YHPhOogcPyZQAOvB8JR31m
         3QFOUgeDmVFdsotljjJFeYc+MVLW9XX9x6ZdbzdwtQFutCGxuvl7K/YvGSezbLLO2hhU
         faUQ==
X-Gm-Message-State: APjAAAUKRnWx/PD1QOGJThDISbPd+gaJ+x0XQ/qhGO/827MgYTMnZJJB
        L3MDSWxMNpf4F124KFdY6v1vHw==
X-Google-Smtp-Source: APXvYqwoxIn9nfRFjJUPqQwR+khLXfWKms5b5AuArgOziPlcTFDSZdYBhtuiosiiZzJKNtWPyEXDzg==
X-Received: by 2002:a2e:58c:: with SMTP id 134mr2221234ljf.12.1576681882374;
        Wed, 18 Dec 2019 07:11:22 -0800 (PST)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id i4sm1736919lji.0.2019.12.18.07.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 07:11:20 -0800 (PST)
Received: by box.localdomain (Postfix, from userid 1000)
        id 934571012CF; Wed, 18 Dec 2019 18:11:21 +0300 (+03)
Date:   Wed, 18 Dec 2019 18:11:21 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kirill.shutemov@linux.intel.com, justin.he@arm.com,
        linux-mm@kvack.org,
        syzbot <syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
Subject: Re: WARNING in wp_page_copy
Message-ID: <20191218151121.nllpaaq4v5yictib@box>
References: <000000000000a6f2030598bbe38c@google.com>
 <0000000000000e32950599ac5a96@google.com>
 <20191216150017.GA27202@linux.fritz.box>
 <CAJ8uoz3nCxcmnPonNunYhswskidn=PnN8=4_jXW4B=Xu4k_DoQ@mail.gmail.com>
 <CAJ8uoz312gDBGpqOJiKqrXn456sy6u+Gnvcvv_+0=EimasRoUw@mail.gmail.com>
 <20191217154031.GI5624@arrakis.emea.arm.com>
 <CAJ8uoz3yDK8sEE05cKA8siBi-Dc0wtbe1-zYgbz_-pd5t69j8w@mail.gmail.com>
 <20191217223808.GA14982@mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217223808.GA14982@mbp>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:38:09PM +0000, Catalin Marinas wrote:
> On Tue, Dec 17, 2019 at 04:57:34PM +0100, Magnus Karlsson wrote:
> > On Tue, Dec 17, 2019 at 4:40 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Tue, Dec 17, 2019 at 02:27:22PM +0100, Magnus Karlsson wrote:
> > > > On Mon, Dec 16, 2019 at 4:10 PM Magnus Karlsson
> > > > <magnus.karlsson@gmail.com> wrote:
> > > > > On Mon, Dec 16, 2019 at 4:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > > On Sat, Dec 14, 2019 at 08:20:07AM -0800, syzbot wrote:
> > > > > > > syzbot has found a reproducer for the following crash on:
> > > > > > >
> > > > > > > HEAD commit:    1d1997db Revert "nfp: abm: fix memory leak in nfp_abm_u32_..
> > > > > > > git tree:       net-next
> > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1029f851e00000
> > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cef1fd5032faee91
> > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
> > > > > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000
> > > > > > >
> > > > > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > > > > Reported-by: syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com
> > > > > >
> > > > > > Bjorn / Magnus, given xsk below, PTAL, thanks!
> > > > >
> > > > > Thanks. I will take a look at it right away.
> > > > >
> > > > > /Magnus
> > > >
> > > > After looking through the syzcaller report, I have the following
> > > > hypothesis that would dearly need some comments from MM-savy people
> > > > out there. Syzcaller creates, using mmap, a memory area that is
> > >
> > > I guess that's not an anonymous mmap() since we don't seem to have a
> > > struct page for src in cow_user_page() (the WARN_ON_ONCE path). Do you
> > > have more information on the mmap() call?
> > 
> > I have this from the syzcaller logs:
> > 
> > mmap(&(0x7f0000001000/0x2000)=nil, 0x2000, 0xfffffe, 0x12, r8, 0x0)
> > getsockopt$XDP_MMAP_OFFSETS(r8, 0x11b, 0x7, &(0x7f0000001300),
> > &(0x7f0000000100)=0x60)
> > 
> > The full log can be found at:
> > https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000
> 
> Thanks. Prior to mmap, we have:
> 
> r8 = socket$xdp(0x2c, 0x3, 0x0)
> 
> So basically we have an mmap() on a socket descriptor with a subsequent
> copy_to_user() writing this range. We do we even end up doing CoW on
> such mapping?

It's a non-readable private mapping of a socket. Any write to it would
cause CoW.

BTW, how useful memory mapped sockets are? I don't know much about
networking, but it looks like a rarely used feature that substantially
increase attack surface. CAP_NET_RAW is easy to come by nowadays with
user-ns.

Few years back I was able to modify zero page via memory mapped socket...

> Maybe the socket code should also implement the .fault()
> file op. It needs more digging.

Caller definitely does a weird thing here that doesn't suppose to produce
a meaningful result. I think we can keep the warning for now just to make
sure we don't have any more-or-less legitimate obscure use-case.

But ultimately this WARN_ON_ONCE() has to be upgraded to SIGSEGV or
SIGBUS. Pretending that we do anything meaningful here by clearing the
page unlikely does anything useful to a user.

-- 
 Kirill A. Shutemov
