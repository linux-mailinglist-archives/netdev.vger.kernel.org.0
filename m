Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF0B57451F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiGNGem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGNGel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:34:41 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30E59FC9;
        Wed, 13 Jul 2022 23:34:38 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q14so635099iod.3;
        Wed, 13 Jul 2022 23:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HsXLZKgExxaVrrOWzurHY9hJzjTpI3H7ZSv4NVdQcoc=;
        b=Lm8XgDriM149barV1JmRQwqJW4zZ7qA3gaoS272mwExdpi0fn9ahWMG+zNOZfhucFL
         euXbDzD5jEhmpW2jgjU8UUC3HCNLApayRz63AyU4I+AKC6NhTL67j1dJ0VsuITW1iLfc
         BrBt7P2jycJM3HFykiqC7tkziFAltNZsnF/zWiAe5fEHyFsZYqCwsxjLGSLJ349zh1IJ
         NLb2Pz1f6oXgtXmmlFzD4ZATIWvRMIU1qN4Do9fHjobGFXekybaMNbh/1NAkwvyILvBK
         eDdNO7LX+nRvc8PmFNqddGDTl9ZUG/gyWFLVey5cjWpFFQta/isUTWGewLPzYQKj/s4T
         VPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HsXLZKgExxaVrrOWzurHY9hJzjTpI3H7ZSv4NVdQcoc=;
        b=xLAAzV+qTV44cbeRi0Yd1SJP2fWCqe75hgGYV6QyqaLkjorDtGJUQ7Q8LXjl9+7amG
         jFHaYixdPL9vIpkdkFjZ+P52zZPpTcYC73HP4JkLA89hmLvTFwM6XSpsH4H8Rq9VaHjt
         UlgX/JMa9oeES6yF8ATRAzhNc3cODAF97GjNguNl409dpmCUAHcjzhTBBnKz/su5EW3s
         6chLj2N0yOYaajxdzi19QPEhw8Wy7pnyfuL+S3h9sdNWGFbHaniFujXJg7Ay4+er+LKf
         BS4GS7wUOdKmMmgimWaZ+uP3AxtgvzEA0blkrj//kNVufr6Bya0mq/hZAa8dQcQuY4iL
         aHQw==
X-Gm-Message-State: AJIora/XL0HcdNsbdk+1O5jqR2+TMiUt8JT0pwjJK4HXE1CYf/wDKNFC
        xWZ5qin2OrpM3nkPt/wJ1wUNDOA/RAAj1yM2qZ0=
X-Google-Smtp-Source: AGRyM1sD/Hv8Rql5j6NdcaEMvBGTF7EAQAhDOSgUzYsj7J7UElNwm8pHxGs76CI612+D+TIgpPFXbsBzEttfuAhA2Pk=
X-Received: by 2002:a05:6602:2e8d:b0:64f:b683:c70d with SMTP id
 m13-20020a0566022e8d00b0064fb683c70dmr3607754iow.62.1657780478288; Wed, 13
 Jul 2022 23:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
In-Reply-To: <877d4gpto8.fsf@toke.dk>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 14 Jul 2022 08:34:02 +0200
Message-ID: <CAP01T74x8qdCr=NP3fMEYeiiUd-zrM24_shzr2YNm7fWy_f5cQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling capabilities
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 at 23:52, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Packet forwarding is an important use case for XDP, which offers
> >> significant performance improvements compared to forwarding using the
> >> regular networking stack. However, XDP currently offers no mechanism t=
o
> >> delay, queue or schedule packets, which limits the practical uses for
> >> XDP-based forwarding to those where the capacity of input and output l=
inks
> >> always match each other (i.e., no rate transitions or many-to-one
> >> forwarding). It also prevents an XDP-based router from doing any kind =
of
> >> traffic shaping or reordering to enforce policy.
> >>
> >> This series represents a first RFC of our attempt to remedy this lack.=
 The
> >> code in these patches is functional, but needs additional testing and
> >> polishing before being considered for merging. I'm posting it here as =
an
> >> RFC to get some early feedback on the API and overall design of the
> >> feature.
> >>
> >> DESIGN
> >>
> >> The design consists of three components: A new map type for storing XD=
P
> >> frames, a new 'dequeue' program type that will run in the TX softirq t=
o
> >> provide the stack with packets to transmit, and a set of helpers to de=
queue
> >> packets from the map, optionally drop them, and to schedule an interfa=
ce
> >> for transmission.
> >>
> >> The new map type is modelled on the PIFO data structure proposed in th=
e
> >> literature[0][1]. It represents a priority queue where packets can be
> >> enqueued in any priority, but is always dequeued from the head. From t=
he
> >> XDP side, the map is simply used as a target for the bpf_redirect_map(=
)
> >> helper, where the target index is the desired priority.
> >
> > I have the same question I asked on the series from Cong:
> > Any considerations for existing carousel/edt-like models?
>
> Well, the reason for the addition in patch 5 (continuously increasing
> priorities) is exactly to be able to implement EDT-like behaviour, where
> the priority is used as time units to clock out packets.
>
> > Can we make the map flexible enough to implement different qdisc
> > policies?
>
> That's one of the things we want to be absolutely sure about. We are
> starting out with the PIFO map type because the literature makes a good
> case that it is flexible enough to implement all conceivable policies.
> The goal of the test harness linked as note [4] is to actually examine
> this; Frey is our PhD student working on this bit.
>
> Thus far we haven't hit any limitations on this, but we'll need to add
> more policies before we are done with this. Another consideration is
> performance, of course, so we're also planning to do a comparison with a
> more traditional "bunch of FIFO queues" type data structure for at least
> a subset of the algorithms. Kartikeya also had an idea for an
> alternative way to implement a priority queue using (semi-)lockless
> skiplists, which may turn out to perform better.
>

There's also code to go with the idea, just to show it can work :)
https://github.com/kkdwivedi/linux/commits/skiplist
Lookups are fully lockless, updates only contend when the same nodes
are preds,succs. Still needs a lot of testing though. It's meant to be
a generic ordered map, but can be repurposed as a priority queue.
