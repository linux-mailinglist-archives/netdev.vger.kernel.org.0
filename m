Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA048F086
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbiANThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiANThA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:37:00 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DA0C061574;
        Fri, 14 Jan 2022 11:37:00 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id v1so13547508ioj.10;
        Fri, 14 Jan 2022 11:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25llhbJLunNuI26s0KmzOshu+lNofBiDN1PWcbs+9dA=;
        b=J5Vm9OkWsHN46Kt9QZUyOHKLMhhQiYD0I12Yglq2nS4aDzWG+5Yr7FNSk63XueuS02
         TddU2q4esC+4l4Pfgxi9sK8erPZh02Rqx+lGNwVHcNbS6v8JJ6GpnYC2yBiT1wumQV9W
         7SmWWSOVGXlJa7+b5rwpHd7Ru2n6l6+GwvXt8x4vokIcit3Gl/OZyTsrsdp1Fi07YYjj
         s/xYy9r8U3ZMQFv/gV9n3ossdDAAgWAfTUSHyJE+rQwFAeok3YPOjjuBXGdQJa6o8Lhr
         vZ8EYwzYQf/s7D/B1OpMvUyHnJ+u1KrZOnX/to5JuCH2HgfLB+P4VRcHvucEyAyMOUXt
         2AmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25llhbJLunNuI26s0KmzOshu+lNofBiDN1PWcbs+9dA=;
        b=3NkSCf7cjlTGCGlf2f33A0YRJ3X6TflbjumTS8j1T5bWqShbZE3aU8BlRmHoZNIlVG
         8FWLwTijT9R35EkdXoU4q7BaEohjnuz/GQmRM6WZE4qk4DsCqUZxT0gbxq3MI220hmc6
         zc8JWuzm9eD2yP5T9FB3oQ3exKNeb+siC79Wk9yloaRvxmM+aAAG9jid9jboRRo4EACw
         JJrewj8F7rncXFGXQcQIrsQ1+8GrNNhqlP1te5DgCJdcaakceTHf9Hl+cdiNnOJq44Lb
         R6BhUkf6rJ5LAS8p2Nje1OJ2iFNd2Uk/mZv2RBQqLIIntZmVZYk+x5nF/Fb7NBCniiqE
         xcrg==
X-Gm-Message-State: AOAM532fotSxGu+N5ySHMZfAsl5lDDx5Jwd4LgVVAAU99F0xUjCDAULv
        VUidf1pOqPeSeQ8h33tYrD/n8mgK0rYFz/CboRQ=
X-Google-Smtp-Source: ABdhPJzoUPY39Yz6Jt/ofJASN96l0ANO2WXuPkqCWISA5JyxsuBODmwIOteZwrAFY7iQAn5Y41OxH3AMaeQxYQ+fN3s=
X-Received: by 2002:a02:ca03:: with SMTP id i3mr4627012jak.234.1642189019658;
 Fri, 14 Jan 2022 11:36:59 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk> <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk> <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
 <YeC8sOAeZjpc4j8+@lore-desk> <CAADnVQ+=0k1YBbkMmSKSBtkmiG8VCYZ5oKGjPPr4s9c53QF-mQ@mail.gmail.com>
 <e86ccea8-af77-83bf-e90e-dce88b26f07c@redhat.com> <CAC1LvL3M9OaSanES0uzp=vvgK23qPGRPpcAR6Z_Vqcvma3K5Qg@mail.gmail.com>
In-Reply-To: <CAC1LvL3M9OaSanES0uzp=vvgK23qPGRPpcAR6Z_Vqcvma3K5Qg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 11:36:48 -0800
Message-ID: <CAEf4BzZAMtmqW4sMfhEX8WtAzmQoVQ=WupqeqXa=5KbYXAbQNA@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
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

On Fri, Jan 14, 2022 at 10:55 AM Zvi Effron <zeffron@riotgames.com> wrote:
>
> On Fri, Jan 14, 2022 at 8:50 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> >
> >
> >
> > On 14/01/2022 03.09, Alexei Starovoitov wrote:
> > > On Thu, Jan 13, 2022 at 3:58 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >>>
> > >>> Btw "xdp_cpumap" should be cleaned up.
> > >>> xdp_cpumap is an attach type. It's not prog type.
> > >>> Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?
> > >>
> > >> so for xdp "mb" or xdp "frags" it will be xdp/cpumap.mb (xdp/devmap.mb) or
> > >> xdp/cpumap.frags (xdp/devmap.frags), right?
> > >
> > > xdp.frags/cpumap
> > > xdp.frags/devmap
> > >
> > > The current de-facto standard for SEC("") in libbpf:
> > > prog_type.prog_flags/attach_place
> >
> > Ups, did we make a mistake with SEC("xdp_devmap/")
> >
> > and can we correct without breaking existing programs?
> >
>
> We can (at the very least) add the correct sections, even if we leave the
> current incorrect ones as well. Ideally we'd mark the incorrect ones deprecated
> and either remove them before libbpf 1.0 or as part of 2.0?
>

Correct, those would need to be new aliases. We can also deprecate old
ones, if we have consensus on that. We can teach libbpf to emit
warnings (through logs, of course) for such uses of to-be-removed
sections aliases. We still have probably a few months before the final
1.0 release, should hopefully be plenty of time to people to adapt.

> --Zvi
>
> > > "attach_place" is either function_name for fentry/, tp/, lsm/, etc.
> > > or attach_type/hook/target for cgroup/bind4, cgroup_skb/egress.
> > >
> > > lsm.s/socket_bind -> prog_type = LSM, flags = SLEEPABLE
> > > lsm/socket_bind -> prog_type = LSM, non sleepable.
> > >
> >
