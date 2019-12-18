Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E603A124A8A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfLRPAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:00:42 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46237 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfLRPAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:00:42 -0500
Received: by mail-ot1-f65.google.com with SMTP id c22so2810243otj.13;
        Wed, 18 Dec 2019 07:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HtxhUMN0ZQ8RDApQN2b90A3AKYwJoeoLbjxI6U7n3LM=;
        b=S26wzDsgIT6If/pLHMjQbFvuoL8a2c+7whRkzzuaMT7O1Bg4Ozb7T6HcT1TFUt9xOK
         yrVPq74llOs6bHAh55cfM0DXnYcCbVUfNVpErX7BtxJFZOj5JCisXQ3NpWJZsLgvtIyY
         WJT2vNl3xdtofo//eMp5HapB8dhChUD+QYxT89/MPg7bjZuqEB9H6MPH98koS1Q8koy3
         L2usl2AgD/GTOOwyxWbRPILq36fasCSdSY+sEP0mLOlB5NwCyD3DEth0A9b1dlCFwxdc
         48q8q5uzf4yyD21h1dCJkfnKhDOVuuC5rRAn2vI+GEgApcrXBrQtCDd2MA3+cl4pQPNq
         jqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HtxhUMN0ZQ8RDApQN2b90A3AKYwJoeoLbjxI6U7n3LM=;
        b=Qh50vR1/G4VUY3trTbnqiKKfz8zDMSlBkzDf/OC+x9bJjP+hrGAkLneLqn1WE3JP7C
         3P4uykX4gxi/qPH5SJo2lJsBolVz3XCQgyDl8DYHTZFiwbsGi0HEqYldc8+YwKAszll/
         tJW3YlGWy5ucIulu+n2hncb/1UXFhLmsi74b+DL2bf3QwDFsDxWA/xaQoZ2Fg5/97Sap
         HxqpcugcZI9ACxUP/yD83I5A8/TF5TDZX3bG1VFEq8RbYK7dr7fYbU0fvxxA1NHiT1rb
         Gw+TthKEODc88IrutYPe6fSxpvyEIXVIeb8q5bTOUU0frPR3qL4he3l3xBOhyDZ7lSky
         WB9g==
X-Gm-Message-State: APjAAAXeDWHQ/D9uZmg+6RJ97Nwxfvmn6Jvbq51XxEuJo/848oYUOEqI
        PPOs3FE10sH3SHC9CwWeVwfE6mrd4zA4BOG203U=
X-Google-Smtp-Source: APXvYqzdY8+v0Ziio2jx9QkXTvj2SCIvGetVam7OHR7M+H/DPPu/O5WKDGQr2Gpc/zwOq2jDj/5+svUpvzcY1ctI8TE=
X-Received: by 2002:a05:6830:2141:: with SMTP id r1mr2946729otd.39.1576681241302;
 Wed, 18 Dec 2019 07:00:41 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a6f2030598bbe38c@google.com> <0000000000000e32950599ac5a96@google.com>
 <20191216150017.GA27202@linux.fritz.box> <CAJ8uoz3nCxcmnPonNunYhswskidn=PnN8=4_jXW4B=Xu4k_DoQ@mail.gmail.com>
 <CAJ8uoz312gDBGpqOJiKqrXn456sy6u+Gnvcvv_+0=EimasRoUw@mail.gmail.com>
 <20191217154031.GI5624@arrakis.emea.arm.com> <CAJ8uoz3yDK8sEE05cKA8siBi-Dc0wtbe1-zYgbz_-pd5t69j8w@mail.gmail.com>
 <20191217223808.GA14982@mbp>
In-Reply-To: <20191217223808.GA14982@mbp>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 18 Dec 2019 16:00:30 +0100
Message-ID: <CAJ8uoz358oXf7HGjOdVLO6vXLJqKN8LNV=d1HRQ=ZA=jTtOV2A@mail.gmail.com>
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

On Tue, Dec 17, 2019 at 11:38 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
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
> such mapping? Maybe the socket code should also implement the .fault()
> file op. It needs more digging.

I am trying to reproduce it with syzkaller, but so far no luck on my
machine. Will keep you posted.

/Magnus

> --
> Catalin
