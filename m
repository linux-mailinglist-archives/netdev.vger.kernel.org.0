Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C2ECA60
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfKAVln convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 Nov 2019 17:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfKAVlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:41:42 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB4F84DB1F
        for <netdev@vger.kernel.org>; Fri,  1 Nov 2019 21:41:41 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id d5so2030993ljj.2
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 14:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fjcnPmrQoA0PCrDaD/leSIuSuHVONcL18GmYVzheyO8=;
        b=DnLqIAfvzmU/8SMJ+F60bDrkoBTciJ6MF0BAs0PM+SwPilMpeXTtQyb9TfrAkMpVMo
         SzUoZdE81lvWv86XY+IyUmBuW0wg2VVf/jQgW2OUENxZfh9gxvu1lXss9loQMZMte9LM
         gL79/GiT2IxFJudp/8WHYeUK9QS1g6Lt4sP3XgaNC7nKGJ/I/ydzftvyxuM7nLgF0223
         T/iUJSAgOa9/jeCJIKzluyhLokZw+Upjtqy+1npJSbZ+q6hnsfgrgXwmoeCriG5l2GL5
         mbfFuM26SAmnrTCaQxrHHHwhbRSUpoRnGOwIJBZmspmmm8citqvPZHQQ2wXsmOkZCIIa
         GhgA==
X-Gm-Message-State: APjAAAV5OL5Js/Vv37vpb114oQxR0zvZ7mVLk1DtprtZ309Ja8K6vGuH
        FtyYxdpliygIKXgn8pMehZHj71LpF5scLq59mGAqu3IhAHXkr6uIX0WepR3dDHnN+ufFw+18pQK
        Fn7sfyc0/12VmroDo
X-Received: by 2002:a19:8196:: with SMTP id c144mr8321983lfd.129.1572644497839;
        Fri, 01 Nov 2019 14:41:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyNr7cebB4cE4Ajj3mY+WhWx7IhirEPQE1ymGG/2jXclx6VS4tBzt/IEOi4pxX5u6iAdx7WOA==
X-Received: by 2002:a19:8196:: with SMTP id c144mr8321975lfd.129.1572644497609;
        Fri, 01 Nov 2019 14:41:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id z17sm2336835ljm.16.2019.11.01.14.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 14:41:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A27D41818B5; Fri,  1 Nov 2019 22:41:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@intel.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
In-Reply-To: <CAADnVQJJcx8NszLBMSN0wiR43UEgGki38u0etnWvpMVG=8+ngg@mail.gmail.com>
References: <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com> <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com> <87d0ednf0t.fsf@toke.dk> <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com> <20191031174208.GC2794@krava> <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com> <20191031191815.GD2794@krava> <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com> <20191101072707.GE2794@krava> <CAADnVQJnTuADcPizsD+hFx4Rvot0nqiX83M+ku4Nu_qLh2_vyg@mail.gmail.com> <87bltvmlsr.fsf@toke.dk> <CAADnVQJJcx8NszLBMSN0wiR43UEgGki38u0etnWvpMVG=8+ngg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 01 Nov 2019 22:41:35 +0100
Message-ID: <878sozmfzk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Nov 1, 2019 at 12:36 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Fri, Nov 1, 2019 at 12:27 AM Jiri Olsa <jolsa@redhat.com> wrote:
>> >>
>> >> On Thu, Oct 31, 2019 at 01:39:12PM -0700, Alexei Starovoitov wrote:
>> >> > On Thu, Oct 31, 2019 at 12:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
>> >> > > >
>> >> > > > yes. older vmlinux and newer installed libbpf.so
>> >> > > > or any version of libbpf.a that is statically linked into apps
>> >> > > > is something that libbpf code has to support.
>> >> > > > The server can be rebooted into older than libbpf kernel and
>> >> > > > into newer than libbpf kernel. libbpf has to recognize all these
>> >> > > > combinations and work appropriately.
>> >> > > > That's what backward and forward compatibility is.
>> >> > > > That's what makes libbpf so difficult to test, develop and code review.
>> >> > > > What that particular server has in /usr/include is irrelevant.
>> >> > >
>> >> > > sure, anyway we can't compile following:
>> >> > >
>> >> > >         tredaell@aldebaran ~ $ echo "#include <bpf/xsk.h>" | gcc -x c -
>> >> > >         In file included from <stdin>:1:
>> >> > >         /usr/include/bpf/xsk.h: In function ‘xsk_ring_prod__needs_wakeup’:
>> >> > >         /usr/include/bpf/xsk.h:82:21: error: ‘XDP_RING_NEED_WAKEUP’ undeclared (first use in this function)
>> >> > >            82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
>> >> > >         ...
>> >> > >
>> >> > >         XDP_RING_NEED_WAKEUP is defined in kernel v5.4-rc1 (77cd0d7b3f257fd0e3096b4fdcff1a7d38e99e10).
>> >> > >         XSK_UNALIGNED_BUF_ADDR_MASK and XSK_UNALIGNED_BUF_OFFSET_SHIFT are defined in kernel v5.4-rc1 (c05cd3645814724bdeb32a2b4d953b12bdea5f8c).
>> >> > >
>> >> > > with:
>> >> > >   kernel-headers-5.3.6-300.fc31.x86_64
>> >> > >   libbpf-0.0.5-1.fc31.x86_64
>> >> > >
>> >> > > if you're saying this is not supported, I guess we could be postponing
>> >> > > libbpf rpm releases until we have the related fedora kernel released
>> >> >
>> >> > why? github/libbpf is the source of truth for building packages
>> >> > and afaik it builds fine.
>> >>
>> >> because we will get issues like above if there's no kernel
>> >> avilable that we could compile libbpf against
>> >
>> > what is the issue again?
>> > bpf-next builds fine. github/libbpf builds fine.
>> > If distro is doing something else it's distro's mistake.
>>
>> With that you're saying that distros should always keep their kernel
>> headers and libbpf version in sync. Which is fine in itself; they can
>> certainly do that.
>
> No. I'm not suggesting that.
> distro is free to package whatever /usr/include headers.
> kernel version is often != /usr/include headers

I did say kernel *headers*. By which I mean the files in /usr/include.
E.g., on my machine:

$ pacman -Qo /usr/include/linux/if_xdp.h                                                                /usr/include/linux/if_xdp.h is owned by linux-api-headers 5.3.1-1


>> The only concern with this is that without a flow of bugfixes into the
>> 'bpf' tree (and stable), users may end up with buggy versions of libbpf.
>> Which is in no one's interest. So how do we avoid that?
>
> As I explained earlier. There is no 'bpf' tree for libbpf. It always
> moves forward.

Yes, you did. And I was just pointing out that this means that there
will be no bug fixes in older versions. So the only way to update is to
move to an entirely new version of libbpf, including updating all the
headers in /usr/include. And when that is not feasible, then the only
choice left is to ship a buggy libbpf... Unless you have a third option
I'm missing?

-Toke
