Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A35777E4
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiGQTMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiGQTMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:12:33 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CE613DDB;
        Sun, 17 Jul 2022 12:12:30 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id cw12so7436810qvb.12;
        Sun, 17 Jul 2022 12:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mW1+EyAMCKiVWND42+42FywUIVAUNyDmWXe2Fjk/YhA=;
        b=iEoMvzf/DsgPRvSIoIq86pek58SiTPj4/UgXdtL9BxZzUswZwuh+hzoNUinbhd2YZu
         bY/WL4t82aYDWFK9Ox6zp0IzXbz99+RWH8v2+7XxlVG3DMRVuSMc30313L2Eikd5UMcb
         cmJ0uFr4mZum0r/JZEU5raSMJVXDfc8V4mar/A3r/A/PGb6H4Q2pdMihos7YogzQOSgt
         GyLVUpNiNdWmFIPJSVKXPuOsXjV4z8TLevh1KsgI7A34SHjLIpp50BO/STrX3CLyhy/R
         af8QBInhISO+fuBEguWnfNf++ix+MPXaH6IXbC59u6BQkznRsNTraZZomQJpQTLDUzbe
         TVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mW1+EyAMCKiVWND42+42FywUIVAUNyDmWXe2Fjk/YhA=;
        b=h6k+t0GACko8WshAshnRS6oM9FkjtN0OQQmZT2s1LIRtUOHFWbMW+3xd3FvhHhUL+P
         MxGhrHu2MZt67qAAQTT09lPUlb9fBKr5Wmoi5eaQ3hP0/UQhRuzK5fEvMcHHV7koX37t
         Ka+Lhj/yCkAae0bTTxQpkvKL2bSay7ZWuiqqNkuJc4jRNMjgB0uJC86tY+hJzwYXc9ZD
         sHcv/mq1J/Slpa8adKosuTIWTQIENnA+VpZxDPlVfufViZpaqLLAGAEp+LaUMcUjq/WA
         78klz2kr4/CODrSDR4VrPYtxL4XXIUROGsswf2AbZl3FIfyvVidJoZGb+5A765lCDKQ1
         H9Hw==
X-Gm-Message-State: AJIora8LwrnX9kv3EHVv01x9bhI8MPdD3K2MLjY0qMI7Pb+WJC4QE8o1
        dsdu6uIq77BMcHKop6r4YKgeGMzv3qn0uQ==
X-Google-Smtp-Source: AGRyM1vM6P1O9H3Q6SS0B1l8wQq6XTF0tRHQDtphmg8c4MqOKzsuUoq9dtZ6lMpE8gKRkra1xgubmg==
X-Received: by 2002:ad4:594c:0:b0:473:6b0b:d3a9 with SMTP id eo12-20020ad4594c000000b004736b0bd3a9mr18941441qvb.73.1658085149444;
        Sun, 17 Jul 2022 12:12:29 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:3835:48ec:66bb:33a6])
        by smtp.gmail.com with ESMTPSA id az43-20020a05620a172b00b006a6a7b4e7besm9114915qkb.109.2022.07.17.12.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 12:12:28 -0700 (PDT)
Date:   Sun, 17 Jul 2022 12:12:27 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
Message-ID: <YtRfG5YNtNHZXOUc@pop-os.localdomain>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
 <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
 <87v8s0nf8h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v8s0nf8h.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 12:46:54PM +0200, Toke Høiland-Jørgensen wrote:
> Stanislav Fomichev <sdf@google.com> writes:
> 
> > On Wed, Jul 13, 2022 at 2:52 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > On Wed, Jul 13, 2022 at 4:14 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> >>
> >> >> Packet forwarding is an important use case for XDP, which offers
> >> >> significant performance improvements compared to forwarding using the
> >> >> regular networking stack. However, XDP currently offers no mechanism to
> >> >> delay, queue or schedule packets, which limits the practical uses for
> >> >> XDP-based forwarding to those where the capacity of input and output links
> >> >> always match each other (i.e., no rate transitions or many-to-one
> >> >> forwarding). It also prevents an XDP-based router from doing any kind of
> >> >> traffic shaping or reordering to enforce policy.
> >> >>
> >> >> This series represents a first RFC of our attempt to remedy this lack. The
> >> >> code in these patches is functional, but needs additional testing and
> >> >> polishing before being considered for merging. I'm posting it here as an
> >> >> RFC to get some early feedback on the API and overall design of the
> >> >> feature.
> >> >>
> >> >> DESIGN
> >> >>
> >> >> The design consists of three components: A new map type for storing XDP
> >> >> frames, a new 'dequeue' program type that will run in the TX softirq to
> >> >> provide the stack with packets to transmit, and a set of helpers to dequeue
> >> >> packets from the map, optionally drop them, and to schedule an interface
> >> >> for transmission.
> >> >>
> >> >> The new map type is modelled on the PIFO data structure proposed in the
> >> >> literature[0][1]. It represents a priority queue where packets can be
> >> >> enqueued in any priority, but is always dequeued from the head. From the
> >> >> XDP side, the map is simply used as a target for the bpf_redirect_map()
> >> >> helper, where the target index is the desired priority.
> >> >
> >> > I have the same question I asked on the series from Cong:
> >> > Any considerations for existing carousel/edt-like models?
> >>
> >> Well, the reason for the addition in patch 5 (continuously increasing
> >> priorities) is exactly to be able to implement EDT-like behaviour, where
> >> the priority is used as time units to clock out packets.
> >
> > Ah, ok, I didn't read the patches closely enough. I saw some limits
> > for the ranges and assumed that it wasn't capable of efficiently
> > storing 64-bit timestamps..
> 
> The goal is definitely to support full 64-bit priorities. Right now you
> have to start out at 0 but can go on for a full 64 bits, but that's a
> bit of an API wart that I'd like to get rid of eventually...
> 
> >> > Can we make the map flexible enough to implement different qdisc
> >> > policies?
> >>
> >> That's one of the things we want to be absolutely sure about. We are
> >> starting out with the PIFO map type because the literature makes a good
> >> case that it is flexible enough to implement all conceivable policies.
> >> The goal of the test harness linked as note [4] is to actually examine
> >> this; Frey is our PhD student working on this bit.
> >>
> >> Thus far we haven't hit any limitations on this, but we'll need to add
> >> more policies before we are done with this. Another consideration is
> >> performance, of course, so we're also planning to do a comparison with a
> >> more traditional "bunch of FIFO queues" type data structure for at least
> >> a subset of the algorithms. Kartikeya also had an idea for an
> >> alternative way to implement a priority queue using (semi-)lockless
> >> skiplists, which may turn out to perform better.
> >>
> >> If there's any particular policy/algorithm you'd like to see included in
> >> this evaluation, please do let us know, BTW! :)
> >
> > I honestly am not sure what the bar for accepting this should be. But
> > on the Cong's series I mentioned Martin's CC bpf work as a great
> > example of what we should be trying to do for qdisc-like maps. Having
> > a bpf version of fq/fq_codel/whatever_other_complex_qdisc might be
> > very convincing :-)
> 
> Just doing flow queueing is quite straight forward with PIFOs. We're
> working on fq_codel. Personally I also want to implement something that
> has feature parity with sch_cake (which includes every feature and the
> kitchen sink already) :)

And how exactly would you plan to implement Least Slack Time First with
PIFOs?  See https://www.usenix.org/system/files/nsdi20-paper-sharma.pdf.
Can you be as specific as possible ideally with a pesudo code?

BTW, this is very easy to do with my approach as no FO limitations.

Thanks!
