Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0417126FAAA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIRKe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgIRKe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600425266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nkMlmtD8uTyDJMt02ssxr1Uf6VzDRnVAhWgrVKIjiUg=;
        b=FO2kHQg54kajUqjySJPa4xnN1ijtXP2fWkanm2Tn09+ns/UIuV+VrdnKw35J6aZbIMmEyz
        rXemy5EW+68vIny6KVStPDYSu2yteHEHu9/YPSXif2zlix+RAJVTzLo+uiGhE8bsiDE1mR
        foACQvaprdC9renIAZs+snPTLho42XM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-695Dl2v7Px2lvZHR0X8F1w-1; Fri, 18 Sep 2020 06:34:25 -0400
X-MC-Unique: 695Dl2v7Px2lvZHR0X8F1w-1
Received: by mail-ej1-f72.google.com with SMTP id f17so2024729ejq.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nkMlmtD8uTyDJMt02ssxr1Uf6VzDRnVAhWgrVKIjiUg=;
        b=mN6Si69Que9ZDLF3VqnJ7pFvZnX8LwhH1K96SwpDgj+6OUoV5SHWjkWSoFJAyo29uk
         /cEuG0nZ10PFcwOIuK7Y0UPJWIXFJKneaMmHxT/AaXC2XvfEfR5HIJFCN+7lvMuFD/9p
         g8iBBXnZ62iOt9PWN2cEvaoHk/asWQbyhzbGo2dr4ftbdNL79KqX77p17D7jl/v6nVI4
         Psx9T3uaVqyX/k7RutK/Yu1y1dI/sYl2LYAUCWz7x+U3BYfsv0E/AOYj5gCkN7A4T0qy
         kXrY+EXTshuvYdT1/TfxOJfjJGFwPc6ZtFldldKnZ7Amfi1glElm9AjJdoM+NEbvoBaT
         HNBg==
X-Gm-Message-State: AOAM530P6Tqwt2ppZlbASbZisQfXHX9/j89sOKA9l9J+LZbvVxPJoBsP
        JA0WPtwo9kOFFCDzGDX2g1+Or4QdLkAQm7WXOevtotdGElNC8RQ6DwVToGgckMHJqjzsP46uOdF
        wFTQ8Bmmf/c1QGwix
X-Received: by 2002:a50:e685:: with SMTP id z5mr29254467edm.259.1600425255561;
        Fri, 18 Sep 2020 03:34:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+nFdzy9eE1Pro6YK7eE6i0OeESEtdaL4r2RpncAY9krOEf87Oz1PoihnQ6mpz7pKTrZq/rg==
X-Received: by 2002:a50:e685:: with SMTP id z5mr29253984edm.259.1600425249241;
        Fri, 18 Sep 2020 03:34:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f13sm1840116edn.73.2020.09.18.03.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:34:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D102183A90; Fri, 18 Sep 2020 12:34:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>, brouer@redhat.com
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
In-Reply-To: <20200918120016.7007f437@carbon>
References: <20200917143846.37ce43a0@carbon>
 <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Sep 2020 12:34:08 +0200
Message-ID: <87ft7ffk67.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 17 Sep 2020 12:11:33 -0700
> Saeed Mahameed <saeed@kernel.org> wrote:
>
>> On Thu, 2020-09-17 at 05:54 -0700, Maciej =C5=BBenczykowski wrote:
>> > On Thu, Sep 17, 2020 at 5:39 AM Jesper Dangaard Brouer
>> > <brouer@redhat.com> wrote:=20=20
>> > >=20
>> > > As you likely know[1] I'm looking into moving the MTU check (for
>> > > TC-BPF) in __bpf_skb_max_len() when e.g. called by
>> > > bpf_skb_adjust_room(), because when redirecting packets to
>> > > another netdev it is not correct to limit the MTU based on the
>> > > incoming netdev.
>> > >=20
>> > > I was looking at doing the MTU check in bpf_redirect() helper,
>> > > because at this point we know the redirect to netdev, and
>> > > returning an indication/error that MTU was exceed, would allow
>> > > the BPF-prog logic to react, e.g. sending ICMP (instead of packet
>> > > getting silently dropped).=20
>> > > BUT this is not possible because bpf_redirect(index, flags) helper
>> > > don't provide the packet context-object (so I cannot lookup the
>> > > packet length).
>> > >=20
>> > > Seeking input:
>> > >=20
>> > > Should/can we change the bpf_redirect API or create a new helper
>> > > with packet-context?
>> > >=20
>> > >  Note: We have the same need for the packet context for XDP when
>> > >  redirecting the new multi-buffer packets, as not all destination
>> > >  netdev will support these new multi-buffer packets.
>> > >=20
>> > > I can of-cause do the MTU checks on kernel-side in
>> > > skb_do_redirect, but then how do people debug this? as packet
>> > > will basically be silently dropped.
>> > >=20
>> > >=20
>> > >=20
>> > > (Looking at how does BPF-prog logic handle MTU today)
>> > >=20
>> > > How do bpf_skb_adjust_room() report that the MTU was exceeded?
>> > > Unfortunately it uses a common return code -ENOTSUPP which used
>> > > for multiple cases (include MTU exceeded). Thus, the BPF-prog
>> > > logic cannot use this reliably to know if this is a MTU exceeded
>> > > event. (Looked BPF-prog code and they all simply exit with
>> > > TC_ACT_SHOT for all error codes, cloudflare have the most
>> > > advanced handling with metrics->errors_total_encap_adjust_failed++).
>> > >=20
>> > >=20
>> > > [1]=20
>> > > https://lore.kernel.org/bpf/159921182827.1260200.9699352760916903781=
.stgit@firesoul/
>> > > --
>> > > Best regards,
>> > >   Jesper Dangaard Brouer
>> > >   MSc.CS, Principal Kernel Engineer at Red Hat
>> > >   LinkedIn: http://www.linkedin.com/in/brouer
>> > >=20=20=20
>> >=20
>> > (a) the current state of the world seems very hard to use correctly,
>> > so adding new apis, or even changing existing ones seems ok to me.
>> > especially if this just means changing what error code they return
>> >=20
>> > (b) another complexity with bpf_redirect() is you can call it, it
>> > can succeed, but then you can not return TC_ACT_REDIRECT from the
>> > bpf program, which effectively makes the earlier *successful*
>> > bpf_redirect() call an utter no-op.
>> >=20
>> > (bpf_redirect() just determines what a future return TC_ACT_REDIRECT
>> > will do)
>> >=20
>> > so if you bpf_redirect to interface with larger mtu, then increase
>> > packet size,=20=20
>>=20
>> why would you redirect then touch the packet afterwards ?=20
>> if you have a bad program, then it is a user issue.
>>=20
>> > then return TC_ACT_OK, then you potentially end up with excessively
>> > large packet egressing through original interface (with small mtu).
>> >=20
>
> This is a good point.  As bpf_skb_adjust_room() can just be run after
> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> doesn't make much sense.  As clever/bad BPF program can then avoid the
> MTU check anyhow.  This basically means that we have to do the MTU
> check (again) on kernel side anyhow to catch such clever/bad BPF
> programs.  (And I don't like wasting cycles on doing the same check two
> times).
>
> If we do the MTU check on the kernel side, then there are no feedback
> to the program, and how are end-users going to debug this?

The same way any other MTU-related error is seen? Isn't there a counter
or something? Presumably (since this is in the skb path) it would also
be caught by drop_monitor?

-Toke

