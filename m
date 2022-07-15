Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DBB575901
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiGOBMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiGOBMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:12:35 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974C760681;
        Thu, 14 Jul 2022 18:12:34 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 84so2267978pgb.6;
        Thu, 14 Jul 2022 18:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TWkJZ24BxD67ugEMGoCDD9fIs/hjH+O1sJuLjif95F8=;
        b=X6NjaJAJyW1EQW/j3xbuVt0N7S3t6+Q4GiP4JCAtx/BoK+wHqcbc+jWMtb+TxvfDtX
         qhNHvZ65voBvqyHGfG5cSFlYSnZ0nojXvH9rfEostb+kHgNGHdC1j/4ti0w5ONN0qLik
         8VlZ1JpQ04H+84aCtg5oVFP/9q3XxPpy5dFAtDRu7xyn/dcZyMXx9ZgpfLBt3SK65mif
         ss1qbULGrTAoDar/5B1/iZvY4K08ixViPZsY5M5Xkp5wgp/cZf9X+g82K05KDvkRvwBO
         SfpMlU2q/IlfrWcuO3wJV9VEP3BsZ+hxGh8IucaE6I5xt3X5s2gNgu6nnbATSj/Vkmnp
         jgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TWkJZ24BxD67ugEMGoCDD9fIs/hjH+O1sJuLjif95F8=;
        b=SEGt9fjPOZRZn8FrCWiYX1303Zz4rqo5jg1nn3KJksekGLLUVo6IyngwUaCPXIZShd
         fuXFFvVr1rTtQk4EHebozLzSsNN0hMJ+/jY1O7XN7w2HC9DrqzSWoX6FfqKGY1vd8cUq
         TrBQSFK7tJoVMaeKzkmEsjSFVysiCO7eVs+jlrTtfT4OPL71QB130iCwmZKJhpmf50PD
         e//djPEjjU4kBHptH5nGxZDgfGQHUhscETkKJ0bngaAu9YG0vTi2phXEMCfk7n0o0QDI
         iRcEaBi2Sq4A1Lo+V6IDBjIzLqNSbHipPgKNU3ct4ok6H/FSEvX2I23a/AJpGLovX9fm
         RXTA==
X-Gm-Message-State: AJIora9az24VLBFdsxqNNhZscNINJ7Qce9lPPkUnfiSXUPNWwtbb0w6v
        JleTLEG1wRKQjffvtBlT2fw=
X-Google-Smtp-Source: AGRyM1u3HZTDDNCcHBIHHJeZBOeZ5/Gr7Wx7bdZmwpFwAfF6pIbgQwKxh0Zc4uo4PndWVqvXFHIaSQ==
X-Received: by 2002:a63:ea58:0:b0:40d:fb08:5796 with SMTP id l24-20020a63ea58000000b0040dfb085796mr9881324pgk.320.1657847553980;
        Thu, 14 Jul 2022 18:12:33 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:500::1:697a])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902c2d200b0015e8d4eb1dbsm2118739pla.37.2022.07.14.18.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 18:12:32 -0700 (PDT)
Date:   Thu, 14 Jul 2022 18:12:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
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
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
Message-ID: <20220715011228.tujkugafv6eixbyz@MacBook-Pro-3.local>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 12:46:54PM +0200, Toke Høiland-Jørgensen wrote:
> >
> > Maybe a related question here: with the way you do
> > BPF_MAP_TYPE_PIFO_GENERIC vs BPF_MAP_TYPE_PIFO_XDP, how hard it would
> > be have support for storing xdp_frames/skb in any map? Let's say we
> > have generic BPF_MAP_TYPE_RBTREE, where the key is
> > priority/timestamp/whatever, can we, based on the value's btf_id,
> > figure out the rest? (that the value is kernel structure and needs
> > special care and more constraints - can't be looked up from user space
> > and so on)
> >
> > Seems like we really need to have two special cases: where we transfer
> > ownership of xdp_frame/skb to/from the map, any other big
> > complications?
> >
> > That way we can maybe untangle the series a bit: we can talk about
> > efficient data structures for storing frames/skbs independently of
> > some generic support for storing them in the maps. Any major
> > complications with that approach?
> 
> I've had discussions with Kartikeya on this already (based on his 'kptr
> in map' work). That may well end up being feasible, which would be
> fantastic. The reason we didn't use it for this series is that there's
> still some work to do on the generic verifier/infrastructure support
> side of this (the PIFO map is the oldest part of this series), and I
> didn't want to hold up the rest of the queueing work until that landed.

Certainly makes sense for RFC to be sent out earlier,
but Stan's point stands. We have to avoid type-specific maps when
generic will do. kptr infra is getting close to be that answer.

> >> Maybe I'm missing something, though; could you elaborate on how you'd
> >> use kfuncs instead?
> >
> > I was thinking about the approach in general. In networking bpf, we've
> > been adding new program types, new contexts and new explicit hooks.
> > This all requires a ton of boiler plate (converting from uapi ctx to
> > the kernel, exposing hook points, etc, etc). And looking at Benjamin's
> > HID series, it's so much more elegant: there is no uapi, just kernel
> > function that allows it to be overridden and a bunch of kfuncs
> > exposed. No uapi, no helpers, no fake contexts.
> >
> > For networking and xdp the ship might have sailed, but I was wondering
> > whether we should be still stuck in that 'old' boilerplate world or we
> > have a chance to use new nice shiny things :-)
> >
> > (but it might be all moot if we'd like to have stable upis?)
> 
> Right, I see what you mean. My immediate feeling is that having an
> explicit stable UAPI for XDP has served us well. We do all kinds of
> rewrite tricks behind the scenes (things like switching between xdp_buff
> and xdp_frame, bulking, direct packet access, reading ifindexes by
> pointer walking txq->dev, etc) which are important ways to improve
> performance without exposing too many nitty-gritty details into the API.
> 
> There's also consistency to consider: I think the addition of queueing
> should work as a natural extension of the existing programming model for
> XDP. So I feel like this is more a case of "if we were starting from
> scratch today we might do things differently (like the HID series), but
> when extending things let's keep it consistent"?

"consistent" makes sense when new feature follows established path.
The programmable packet scheduling in TX is just as revolutionary as
XDP in RX was years ago :)
This feature can be done similar to hid-bpf without cast-in-stone uapi
and hooks. Such patches would be much easier to land and iterate on top.
The amount of bike shedding will be 10 times less.
No need for new program type, no new hooks, no new FDs and attach uapi-s.
Even libbpf won't need any changes.
Add few kfuncs and __weak noinline "hooks" in TX path.
Only new map type would be necessary.
If it can be made with kptr then it will be the only uapi exposure that
will be heavily scrutinized.

It doesn't mean that it will stay unstable-api forever. Once it demonstrates
that it is on par with fq/fq_codel/cake feature-wise we can bake it into uapi.
