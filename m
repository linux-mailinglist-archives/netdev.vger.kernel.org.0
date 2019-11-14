Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494BFFCB84
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKNRKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:10:24 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46687 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfKNRKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 12:10:24 -0500
Received: by mail-qt1-f194.google.com with SMTP id r20so7517003qtp.13;
        Thu, 14 Nov 2019 09:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hXsovt/+oVzYhy5yR+2IkWFi/pL7lXhsTNS0COVVYGA=;
        b=fiNvbPubHYbK7sKeYRSX4634vRo4+gRYo+yrlUc9ZXM2RRj/LQqZb8djpLStKALMih
         jCyz0W0NpHczqSvdbq42hwHGTvjFQ/4+jk7vIpk21Rq1xGw9asTLmXPwiAu4jMdBAdA4
         eMkyJ0Fy10+B/WZaYbUwNumHAlwFsFWgphbXcpyzndw4Mpwnf9nPX1IqyYbySK9TLiJJ
         ZZW1OL8VkbLTUHglpdhbfjBpc4HRyQ7eK0VgOn9WpPMascB9+gE/17qf+PgcCPYEt1hp
         RsH3uJE0FJ/2/k9DOadYrfP/u9wqQ8dypa2StWbXIMMFOiZNgDv/bUsKs4i4pjH3K7xy
         XFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hXsovt/+oVzYhy5yR+2IkWFi/pL7lXhsTNS0COVVYGA=;
        b=Gv7at5yLK+vD1mrikPCdIp2IdanF65iDLpgdMgPXM0g3JmiPhO/p8IXFTDoQXk0q+o
         lW9HN3nGcv4omTG0tOp6ENHP8CdMoiMEVu1FKqXqXV+k+N/swfSUQmE7IZN42dBEZWVE
         k+jPz8IlXz8KpJZQN+6N+rK0/OWZyplTipFjhwQgCj7EH33WI15PXtnp1vJWQTJ6E3nH
         KPp/3oPuM8JkLScI5GAzoJK+Zga6Kcjcu9/Dd6DXjIqurXL9uERiAlGif5pnCSXKK0Lj
         Md5DdMqCSqC8hhKhsBR93jzC3yU2xf1jSK4SwzC9mdF0dYCLlX9zovCHkL9L0/dVLoYi
         Poow==
X-Gm-Message-State: APjAAAWI8khZkc1+difptHxn57ERw+heNuwzO7IvLvOpeL0i4tIERB5k
        iEA2+Qp2HjI132hgvvwLVkZpvehsB+kjWi3//6s=
X-Google-Smtp-Source: APXvYqyVmZp0LiGgW6UpImGbpYtjfxZf/IQFSI6kpYrUt0vENrK8mPXpfgUgtc2MSUjsLPCDp4GHbJZqtzri3ejxWjA=
X-Received: by 2002:ac8:6f4e:: with SMTP id n14mr9100011qtv.309.1573751421543;
 Thu, 14 Nov 2019 09:10:21 -0800 (PST)
MIME-Version: 1.0
References: <87h840oese.fsf@toke.dk> <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com>
 <87wocqrz2v.fsf@toke.dk> <20191027.121727.1776345635168200501.davem@davemloft.net>
 <09817958-e331-63e9-efbf-05341623a006@gmail.com> <CALDO+SaxbNpON+=3zA4r4k6BE7UhbGU1WovW8Owyi8-9J_Wbkw@mail.gmail.com>
 <53538a02-e6d3-5443-8251-bef381c691a0@gmail.com>
In-Reply-To: <53538a02-e6d3-5443-8251-bef381c691a0@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 14 Nov 2019 09:09:42 -0800
Message-ID: <CALDO+SbqcoiwJn3jskpPTjdJyK5932r0cEzs=1R6p=CWgERLuw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        pravin shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 2:06 AM Toshiaki Makita
<toshiaki.makita1@gmail.com> wrote:
>
> On 2019/11/13 2:50, William Tu wrote:
> > On Wed, Oct 30, 2019 at 5:32 PM Toshiaki Makita
> > <toshiaki.makita1@gmail.com> wrote:
> >>
> >> On 2019/10/28 4:17, David Miller wrote:
> >>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> Date: Sun, 27 Oct 2019 16:24:24 +0100
> >>>
> >>>> The results in the paper also shows somewhat disappointing performan=
ce
> >>>> for the eBPF implementation, but that is not too surprising given th=
at
> >>>> it's implemented as a TC eBPF hook, not an XDP program. I seem to re=
call
> >>>> that this was also one of the things puzzling to me back when this w=
as
> >>>> presented...
> >>>
> >>> Also, no attempt was made to dyanamically optimize the data structure=
s
> >>> and code generated in response to features actually used.
> >>>
> >>> That's the big error.
> >>>
> >>> The full OVS key is huge, OVS is really quite a monster.
> >>>
> >>> But people don't use the entire key, nor do they use the totality of
> >>> the data paths.
> >>>
> >>> So just doing a 1-to-1 translation of the OVS datapath into BPF makes
> >>> absolutely no sense whatsoever and it is guaranteed to have worse
> >>> performance.
> >
> > 1-to-1 translation has nothing to do with performance.
>
> I think at least key size matters.
> One big part of hot spots in xdp_flow bpf program is hash table lookup.
> Especially hash calculation by jhash and key comparison are heavy.
> The computational cost heavily depends on key size.
>
> If umh can determine some keys won't be used in some way (not sure if it'=
s
> practical though), umh can load an XDP program which uses less sized
> key. Also it can remove unnecessary key parser routines.
> If it's possible, the performance will increase.
>
Yes, that's a good point.
In other meeting people also gave me this suggestions.

Basically it's "on-demand flow key parsing using eBPF"
The key parsing consists of multiple eBPF programs, and
based on the existing rules, load the program and parse minimum
necessary fields required by existing rules. This will definitely
have better performance.

I didn't try it at all because most of our use cases use overlay
tunnel and connection tracking.  There is little chance of rules
using only L2 or L3 fields. Another way is to do flow key compression
something like miniflow in OVS userspace datapath.

Regards,
William
