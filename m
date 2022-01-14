Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D53948F033
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiANSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 13:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbiANSzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 13:55:39 -0500
Received: from mail-vk1-xa61.google.com (mail-vk1-xa61.google.com [IPv6:2607:f8b0:4864:20::a61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFE6C061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 10:55:39 -0800 (PST)
Received: by mail-vk1-xa61.google.com with SMTP id h16so6397965vkp.5
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 10:55:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=Hy5aZ4Roey3EFS/MVuvVyRUa8ToAzix3WO2/RHWO60I=;
        b=UcApN0XDhOiStEavKj/sQpiA28Tj09GDpRBqMrjjPuJfzNQsDNgZK+5O8UdY617Zua
         z4XcOhXnr/uzRKsziDfn5xCTLzXBB/ZZWeFu71PRX+7Eonrjy3gxYbG2JaUBQlQa8/Bw
         njdRcM9qyK6E4lvpyI6sRX4NLe2S5cKomImXMIbwD/ZRdkBvB9sqiAN+954gxY5Yu9B0
         sbToVk2MbMfwLvF76i6L18oG+XW3QO8UxD6y1qMXVYkyfQO0eV+ZkKCdOgoAkwLVRG+2
         W5ESbzk3/4m98EvvpMjj2tJWwBHnONlYAPUq54JMS6PerdUfwRk1k7FDHFO5QvMPzOHP
         7tlw==
X-Gm-Message-State: AOAM532OMrMtO4s6UTLE7H5mLrEcFwOI5NGV2AbLLtoqBsUAqgQMUGyJ
        M/FyFqdbf9NNGcsRZfbB/4xBLgLzGBWJmSkvhdkbGmGaRke91A==
X-Google-Smtp-Source: ABdhPJxQkDlJx/bJN+y2A8p73DnAIcvFR61yELm/mXFtFUKl03+KYMRvJ3yUPOKajy7Ea0TYYTcrdXaIiyuu
X-Received: by 2002:a05:6122:914:: with SMTP id j20mr5152228vka.20.1642186538265;
        Fri, 14 Jan 2022 10:55:38 -0800 (PST)
Received: from netskope.com ([163.116.128.203])
        by smtp-relay.gmail.com with ESMTPS id g189sm1721512vkb.2.2022.01.14.10.55.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 10:55:38 -0800 (PST)
X-Relaying-Domain: riotgames.com
Received: by mail-pg1-f200.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso2357142pgv.14
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 10:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hy5aZ4Roey3EFS/MVuvVyRUa8ToAzix3WO2/RHWO60I=;
        b=YwWkfmnbohf8+9NcQ8MXUDzEzi1jb/TVO/GiB3NRMq+k2WWwXsHRzOBnrzTR/5nK5m
         qtRwrrByNyDa0X9hePyHkSdgLIALPbKCFv/BZwKNbGx0cCVusuCoO8J3RCgVRPU7AdMW
         HPWz9T0KpoAKL9MyULbPJsRIVd65/2w58R6yU=
X-Received: by 2002:aa7:9510:0:b0:4bd:ce79:d158 with SMTP id b16-20020aa79510000000b004bdce79d158mr10108456pfp.24.1642186536550;
        Fri, 14 Jan 2022 10:55:36 -0800 (PST)
X-Received: by 2002:aa7:9510:0:b0:4bd:ce79:d158 with SMTP id
 b16-20020aa79510000000b004bdce79d158mr10108421pfp.24.1642186536257; Fri, 14
 Jan 2022 10:55:36 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk> <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk> <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
 <YeC8sOAeZjpc4j8+@lore-desk> <CAADnVQ+=0k1YBbkMmSKSBtkmiG8VCYZ5oKGjPPr4s9c53QF-mQ@mail.gmail.com>
 <e86ccea8-af77-83bf-e90e-dce88b26f07c@redhat.com>
In-Reply-To: <e86ccea8-af77-83bf-e90e-dce88b26f07c@redhat.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Fri, 14 Jan 2022 10:55:24 -0800
Message-ID: <CAC1LvL3M9OaSanES0uzp=vvgK23qPGRPpcAR6Z_Vqcvma3K5Qg@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
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
x-netskope-inspected: true
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 8:50 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 14/01/2022 03.09, Alexei Starovoitov wrote:
> > On Thu, Jan 13, 2022 at 3:58 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >>>
> >>> Btw "xdp_cpumap" should be cleaned up.
> >>> xdp_cpumap is an attach type. It's not prog type.
> >>> Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?
> >>
> >> so for xdp "mb" or xdp "frags" it will be xdp/cpumap.mb (xdp/devmap.mb) or
> >> xdp/cpumap.frags (xdp/devmap.frags), right?
> >
> > xdp.frags/cpumap
> > xdp.frags/devmap
> >
> > The current de-facto standard for SEC("") in libbpf:
> > prog_type.prog_flags/attach_place
>
> Ups, did we make a mistake with SEC("xdp_devmap/")
>
> and can we correct without breaking existing programs?
>

We can (at the very least) add the correct sections, even if we leave the
current incorrect ones as well. Ideally we'd mark the incorrect ones deprecated
and either remove them before libbpf 1.0 or as part of 2.0?

--Zvi

> > "attach_place" is either function_name for fentry/, tp/, lsm/, etc.
> > or attach_type/hook/target for cgroup/bind4, cgroup_skb/egress.
> >
> > lsm.s/socket_bind -> prog_type = LSM, flags = SLEEPABLE
> > lsm/socket_bind -> prog_type = LSM, non sleepable.
> >
>
