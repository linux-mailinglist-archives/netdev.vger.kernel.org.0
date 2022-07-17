Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D05777BD
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiGQSRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 14:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGQSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 14:17:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34E13F74;
        Sun, 17 Jul 2022 11:17:31 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id m16so3101128qka.12;
        Sun, 17 Jul 2022 11:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uE4EUaolmFYSr5DdIJbQZyuSH4p9+RzSttNR94oKglY=;
        b=OT7dPGXdqGYRrdEqWSLsv9AlzMljV9JDkmXxM0Sgve4tue4W88MHHiz73ELtTrY0Ll
         gFn09nNHKD/cPE5CCcWPyNdvWeY2qTrnbB5i6vLwj07bgtTuAlHSw7riCdeUj7PVeS7J
         CBnjVT//0wrTaxQZ7akgdKpBrXDgwST8x9VvJtIVI15z/V0OhZyXtdvyvxofl0AXC70D
         Kx8stdweDYZeZbRTsDbgMReW8aRfywyCO+H6v6eRWEZc9WrdxZFTvBk1k7EdHZWkSeK0
         +TB4jvWw0WJydmI1zZwNsd4h8IWyAE/yBTnfeEkC+EpG3rA1wr3zVUxhNNYhSg2WZNau
         8x2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uE4EUaolmFYSr5DdIJbQZyuSH4p9+RzSttNR94oKglY=;
        b=5n4UyI+tt/1dTmn2PMs8Rhu/8uUWbT0sDETX0mpc3quiKRXezMn/Bj5IK5d75u9RDj
         JpbiN1KOwqSlDUIXXWdOUt7TD4acv1NuectzXEd69OzXKy+Kh/GfQR5KKDjSeH8mGiV2
         rXQnwSiVdNVtYCDHDklBwgwlwfP3qqY8Il9dbDUtVvhACkugg5q3LRCupXqoDMOdVDxF
         tuQFnP9C1cpdTn9BwDOw03bdTugAZwl8HwKecWCSujUqJB6/HVU9BINpgtHytGjnsuu+
         /HrCd/yurDIKOl+vvJpuRKDfli3TrlGyAueSuCXKKVra9Sk19DwfMiC2ZKaXlvE6ogN3
         VLRg==
X-Gm-Message-State: AJIora+K7LfnjrvzsHI7YiqKtRBqSziL1UeevG2BKcdB0Vd6P1rgISvW
        0IH2r2DQ47UXzI9vB+y/MVM=
X-Google-Smtp-Source: AGRyM1uWvp3mciWKlbMIb9AwEOZ9UYguZXJF02XpISgeVw5te0ip7+s3K+LzdiVaORL/8t+frunlxQ==
X-Received: by 2002:a37:92c7:0:b0:6b4:8116:ccfb with SMTP id u190-20020a3792c7000000b006b48116ccfbmr15450514qkd.781.1658081850669;
        Sun, 17 Jul 2022 11:17:30 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:db10:283b:b16c:9691])
        by smtp.gmail.com with ESMTPSA id bb31-20020a05622a1b1f00b0031ef21aec36sm321290qtb.32.2022.07.17.11.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 11:17:30 -0700 (PDT)
Date:   Sun, 17 Jul 2022 11:17:29 -0700
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
Message-ID: <YtRSOaCtujBfzHUS@pop-os.localdomain>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877d4gpto8.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 11:52:07PM +0200, Toke Høiland-Jørgensen wrote:
> Stanislav Fomichev <sdf@google.com> writes:
> 
> > On Wed, Jul 13, 2022 at 4:14 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>
> >> Packet forwarding is an important use case for XDP, which offers
> >> significant performance improvements compared to forwarding using the
> >> regular networking stack. However, XDP currently offers no mechanism to
> >> delay, queue or schedule packets, which limits the practical uses for
> >> XDP-based forwarding to those where the capacity of input and output links
> >> always match each other (i.e., no rate transitions or many-to-one
> >> forwarding). It also prevents an XDP-based router from doing any kind of
> >> traffic shaping or reordering to enforce policy.
> >>
> >> This series represents a first RFC of our attempt to remedy this lack. The
> >> code in these patches is functional, but needs additional testing and
> >> polishing before being considered for merging. I'm posting it here as an
> >> RFC to get some early feedback on the API and overall design of the
> >> feature.
> >>
> >> DESIGN
> >>
> >> The design consists of three components: A new map type for storing XDP
> >> frames, a new 'dequeue' program type that will run in the TX softirq to
> >> provide the stack with packets to transmit, and a set of helpers to dequeue
> >> packets from the map, optionally drop them, and to schedule an interface
> >> for transmission.
> >>
> >> The new map type is modelled on the PIFO data structure proposed in the
> >> literature[0][1]. It represents a priority queue where packets can be
> >> enqueued in any priority, but is always dequeued from the head. From the
> >> XDP side, the map is simply used as a target for the bpf_redirect_map()
> >> helper, where the target index is the desired priority.
> >
> > I have the same question I asked on the series from Cong:
> > Any considerations for existing carousel/edt-like models?
> 
> Well, the reason for the addition in patch 5 (continuously increasing
> priorities) is exactly to be able to implement EDT-like behaviour, where
> the priority is used as time units to clock out packets.

Are you sure? I seriouly doubt your patch can do this at all...

Since your patch relies on bpf_map_push_elem(), which has no room for
'key' hence you reuse 'flags' but you also reserve 4 bits there... How
could tstamp be packed with 4 reserved bits??

To answer Stanislav's question, this is how my code could handle EDT:

// BPF_CALL_3(bpf_skb_map_push, struct bpf_map *, map, struct sk_buff *, skb, u64, key)
skb->tstamp = XXX;
bpf_skb_map_push(map, skb, skb->tstamp);

(Please refer another reply from me for how to get the min when poping,
which is essentially just a popular interview coding problem.)

Actually, if we look into the in-kernel EDT implementation (net/sched/sch_etf.c),
it is also based on rbtree rather than PIFO. ;-)

Thanks.
