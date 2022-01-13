Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B46A48DECD
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiAMUT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbiAMUTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:19:52 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA11C061748;
        Thu, 13 Jan 2022 12:19:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id f13so1042566plg.0;
        Thu, 13 Jan 2022 12:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pHkRFIiwA7uEjU6r+wnrVKLGAAQ9fxjBVmZFMhuJ4uY=;
        b=qP0DuXHflMeNPkXynYP1er06i06qwTHQbJxyfJyO+uICm3+RS3m4pVS/6Lf1Emd7Xr
         UnTFEFJ5acyvJWNlC9L6M2IIv3Ty7fTR/UcSagaBtTOfAirbmO0mARv3PpJm3fG0OyMr
         qSrYiy1bgSlOIghoNOtVxcjKNKq9oGuG8kr8qwz3iASnQb6CyeBwbJhARxaUc0xG0w3h
         9HF+N0Sf8rhoOKx1sJIV8zRaP9HyO37ZOpXJrjn+o5GkbaX7tPB5tO72W/uqStmrW6ET
         p18nGzRCAQUTu0TJ3BHCYTg90aNIfN8QdpqByEwxBWSo6ixi9KBebYIT4Lk1jC6WWjhC
         9puQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pHkRFIiwA7uEjU6r+wnrVKLGAAQ9fxjBVmZFMhuJ4uY=;
        b=zI6mN9xclpN6w3fqROxWQxv2NcCX/GmkytGAwp2i3jXZRyUmj1CKd1q8oQX/pYShgX
         zmQuOK/qDtbKl3OuHbs8XtYcmiUjKmy72LgQYQ3icY47OZ3+rtKnCa6YqtAM0idph/qE
         FqulpROUeZ0ML9fCL3jUKOvqjcLTT1ILO0rhz7hPNxrUQhisX9S+srqeIRnaX5Vei6sX
         IPqXk/Sp8X6NBKxvXgc2vPe4RUK75/dALKRvvcjCp3hsKPOA7HApV9Vu2t3M/8tdzKto
         DF2zvkkRA+C+22xJIarl4wcIRW1l8rWLp9EpwrIXMAHJRSRNHYa87KH+9CnXq++L13IV
         u+7g==
X-Gm-Message-State: AOAM5311wC400IQ3HX5F6Z6dX4NsxekNglXO/IuSkAIpfBdmpxFHHDW0
        wN7Fr1AxxJQgEnPYZIPZl6fEZA/S6A7TpIwYqlU=
X-Google-Smtp-Source: ABdhPJxSuHBviSFnAkPQKIGJqMnpquJaEhp2xaLow1AfGPrHUmUrH3qGwSzU40lBEt4i/D4lysnKpMN4SmdfBEn/yXw=
X-Received: by 2002:a17:90b:3a82:: with SMTP id om2mr6999793pjb.138.1642105191665;
 Thu, 13 Jan 2022 12:19:51 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk> <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk> <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk>
In-Reply-To: <Yd/9SPHAPH3CpSnN@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Jan 2022 12:19:40 -0800
Message-ID: <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 2:22 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > >
> > > > I would prefer to keep the "_mb" postfix, but naming is hard and I am
> > > > polarized :)
> > >
> > > I would lean towards keeping _mb as well, but if it does have to be
> > > changed why not _mbuf? At least that's not quite as verbose :)
> >
> > I dislike the "mb" abbreviation as I forget it stands for multi-buffer.
> > I like the "mbuf" suggestion, even-though it conflicts with (Free)BSD mbufs
> > (which is their SKB).
>
> If we all agree, I can go over the series and substitute mb postfix with mbuf.
> Any objections?

mbuf has too much bsd taste.

How about ".frags" instead?
Then xdp_buff_is_mb() will be xdp_buff_has_frags().

I agree that it's not obvious what "mb" suffix stands for,
but I don't buy at all that it can be confused with "megabyte".
It's the context that matters.
In "100mb" it's obvious that "mb" is likely "megabyte",
but in "xdp.mb" it's certainly not "xdp megabyte".
Such a sentence has no meaning.
Imagine we used that suffix for "tc"...
it would be "tc.mb"... "Traffic Control Megabyte" ??

Anyway "xdp.frags" ?

Btw "xdp_cpumap" should be cleaned up.
xdp_cpumap is an attach type. It's not prog type.
Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?

In patch 22 there is a comment:
/* try to attach BPF_XDP_DEVMAP multi-buff program"

It creates further confusion. There is no XDP_DEVMAP program type.
It should probably read
"Attach BPF_XDP program with frags to devmap"

Patch 21 still has "CHECK". Pls replace it with ASSERT.
