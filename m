Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FB748875B
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 03:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiAICYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 21:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiAICYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 21:24:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B5CC06173F;
        Sat,  8 Jan 2022 18:24:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso10627610pjo.5;
        Sat, 08 Jan 2022 18:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XTPe+ZTg13rRAodjoKXWvvU0kZo4zErR94BHGnRJizA=;
        b=SUHvyciban7PhjrJedEf6ESoB3BuXOjDDRpKImGcu1X+kdOL3BjkZkMRAd7Fra/SKp
         SBuV5jmQ1pX8QDAXLEUNCxYEonp6HC/Gv/05QGFzPdyyLqK2HkSOCrbAZFtaPHXi8KAR
         PBYZrv0iqAC5JozPwdUrY0fObU16It2QyCvyz9BtjF0n8rbGkAyZofb5eOK7ti3iZiwm
         iBka8EcDQ8JJaag0zz32M5uJEmR20HjqhxCmDhAR/tG8PeSAlh/NywJKvCmyprqD4VAl
         qeHyFwrDuUuKUdYrjXe1iqkqbg4Bmqivhs+38m8mV8+LfuWoJTaCecul/0Xh7cuXpH2V
         Csow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XTPe+ZTg13rRAodjoKXWvvU0kZo4zErR94BHGnRJizA=;
        b=kIo1QcfCdacq2nRHwTxpZqa5thFhes3AX8LH180l7+OXFBYFHu+D66H8+6vG6onx3F
         iCzaMj0KiIidSXv5H0wRzKMrB7ZdmGM2UMtGc1j1BkZrxQN//FRbBYr+Kwpqn75e3E4J
         78IOxPixfHtiL6AAuy6foFBCxx8TgMAIvcAa6Pv7uHZNL/wGKEMiDu2DMSDtBeUicUa5
         kEXQFZy1qFA75ecWf/LC93fyG70lM1Lon9U6lvQLxYuFg/TeJopDdFU1r+SMZRV4WquJ
         g6lLCOSLiEpBvD/FgXYhsAZHyhTPBfoqGwhi8Aaj/T0dGoBPb0XF+KvhMNR+Y4a2JNVQ
         gUcw==
X-Gm-Message-State: AOAM531a8pOHQ8LSlgJHyoQZ3aDr/B7CdrkdA3Eg7Hv8ndY8qwXe12HF
        B43YA7Im5AHCGP5J53sb8e8=
X-Google-Smtp-Source: ABdhPJyYiO3EHNsIKP1lSCoH4P/BgdR+7U9o6h0XAqI847WXY1XBq+o+6v7PL1yoYzeEBu9l0tySAA==
X-Received: by 2002:a17:90a:db87:: with SMTP id h7mr3319450pjv.97.1641695091462;
        Sat, 08 Jan 2022 18:24:51 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:33b1])
        by smtp.gmail.com with ESMTPSA id lk10sm3424546pjb.20.2022.01.08.18.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 18:24:51 -0800 (PST)
Date:   Sat, 8 Jan 2022 18:24:48 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 1/3] bpf: Add "live packet" mode for XDP in
 bpf_prog_run()
Message-ID: <20220109022448.bxgatdsx3obvipbu@ast-mbp.dhcp.thefacebook.com>
References: <20220107215438.321922-1-toke@redhat.com>
 <20220107215438.321922-2-toke@redhat.com>
 <CAADnVQ+uftgnRQa5nvG4FTJga_=_FMAGxuiPB3O=AFKfEdOg=A@mail.gmail.com>
 <87pmp28iwe.fsf@toke.dk>
 <CAADnVQLWjbm03-3NHYyEx98tWRN68LSaOd3R9fjJoHY5cYoEJg@mail.gmail.com>
 <87mtk67zfm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mtk67zfm.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 08, 2022 at 09:19:41PM +0100, Toke Høiland-Jørgensen wrote:
> 
> Sure, totally fine with documenting it. Just seems to me the most
> obvious place to put this is in a new
> Documentation/bpf/prog_test_run.rst file with a short introduction about
> the general BPF_PROG_RUN mechanism, and then a subsection dedicated to
> this facility.

sgtm

> > I guess it's ok-ish to get stuck with 128.
> > It will be uapi that we cannot change though.
> > Are you comfortable with that?
> 
> UAPI in what sense? I'm thinking of documenting it like:
> 
> "The packet data being supplied as data_in to BPF_PROG_RUN will be used
>  for the initial run of the XDP program. However, when running the
>  program multiple times (with repeat > 1), only the packet *bounds*
>  (i.e., the data, data_end and data_meta pointers) will be reset on each
>  invocation, the packet data itself won't be rewritten. The pages
>  backing the packets are recycled, but the order depends on the path the
>  packet takes through the kernel, making it hard to predict when a
>  particular modified page makes it back to the XDP program. In practice,
>  this means that if the XDP program modifies the packet payload before
>  sending out the packet, it has to be prepared to deal with subsequent
>  invocations seeing either the initial data or the already-modified
>  packet, in arbitrary order."
> 
> I don't think this makes any promises about any particular size of the
> page pool, so how does it constitute UAPI?

Could you explain out-of-order scanario again?
It's possible only if xdp_redirect is done into different netdevs.
Then they can xmit at different times and cycle pages back into
the loop in different order. But TX or REDIRECT into the same netdev
will keep the pages in the same order. So the program can rely on that.

> >
> > reinit doesn't feel necessary.
> > How one would use this interface to send N different packets?
> > The api provides an interface for only one.
> 
> By having the XDP program react appropriately. E.g., here is the XDP
> program used by the trafficgen tool to cycle through UDP ports when
> sending out the packets - it just reads the current value and updates
> based on that, so it doesn't matter if it sees the initial page or one
> it already modified:

Sure. I think there is an untapped potential here.
With this live packet prog_run anyone can buy 10G or 100G nic equipped
server and for free transform it into $300k+ IXIA beating machine.
It could be a game changer. pktgen doesn't come close.
I'm thinking about generating and consuming test TCP traffic.
TCP blaster would xmit 1M TCP connections through this live prog_run
into eth0 and consume the traffic returning from "server under test"
via a different XDP program attached to eth0.
The prog_run's xdp prog would need to send SYN, increment sequence number,
and keep sane data in the packets. It could be HTTP request, for example.

To achive this IXIA beating setup the TCP blaster would need a full
understanding of what page pool is doing with the packets.
Just saying "in arbitrary order" is a non starter. It diminishes
this live prog_run into pktgen equivalent which is still useful,
but lots of potential is lost.

> Another question seeing as the merge window is imminent: How do you feel
> about merging this before the merge window? I can resubmit before it
> opens with the updated selftest and documentation, and we can deal with
> any tweaks during the -rcs; or would you rather postpone the whole
> thing until the next cycle?

It's already too late for this merge window, but bpf-next is always open.
Just like it was open for the last year. So please resubmit as soon as
the tests are green and this discussion is over.
