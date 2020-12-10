Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B3D2D5D51
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 15:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbgLJOPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387865AbgLJOPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:15:10 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC10C0613D6;
        Thu, 10 Dec 2020 06:14:30 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c12so4174472pfo.10;
        Thu, 10 Dec 2020 06:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=utkMYoYvuRBOSIRlR5sdFRBXiLKx3YQ78N2p3n8VR0g=;
        b=oSgw2doP5ezYbWSUBM//tuFmtDNlxGa4WraoGNsoaqTHZcqQnk7XCjTDPP2BrDatAr
         ab1gxNeJbQDEwXK63hMFS94d1YXRxRNfTZ2+DYkB0qy2mXA1qba/m2R8Az3YDvQKVto4
         o3R72tb7u3z0r3bwZITkWSy8Q1G3j30zTimrcSGHgoeebYtst1xjghLo7przTr3iuNzz
         7DSAH2m8Gfw/ssB2wO4X0PBTXBOj5Q5qB4ARxxyFWHGtl/Kglyh2A6jQYdLAb6Np4bkW
         SrBzTD4C7SE1qam6dz1d+PI3kw/8FWM5UVohpbcT12l91o/dmVKFSVBWPgu4pIww4pxf
         oD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=utkMYoYvuRBOSIRlR5sdFRBXiLKx3YQ78N2p3n8VR0g=;
        b=Jqi/y4dQ3iGfHGJBdEOLkkx2Mbxj0qYG8Cg3Kt7O1PQIG1QOP0mc9hqJqJmUoS2AWa
         TLW/Pt/rJo40snLjePO3I9VWo8Qv3JN/3nwOpNrgFo4mmDObyjIqLFq6yMEziP2TYCoe
         HlgM/tnPrXMKnpI06Fo0V1wK4p2FJNnIC1ddcMwJlmtMNyc9RVL1z1T5aiG+Y08DXu3B
         6c598QBoc3LZLQss6DapLKbYI+0FTKMrQ9qgOJaa6t+4ctG/IaMNymxHzllONGkXTlFN
         A+f/5b1LZs8OYdmX7yw9ONsQzQnvcIBe3OPWTh5yVHJVEU3BbEW0/5kwxl6/HfjkIGeL
         YbKQ==
X-Gm-Message-State: AOAM531j8UyRG1EkHVo4OlYHDb+yaFAsNZ4MCBgqG+6L0Ch2AdBxhZXF
        Wtn+9mgd1K1sMDBMWC4GzFgo0e+U+nThh/swXws=
X-Google-Smtp-Source: ABdhPJwpOKGEkBmzqiZ+xs5j8cbNTVNpz/q10l+ER6H65/hTzywjfD7lj5MPPJUCMpq0SpUqCiNOWUA5wEg0gPotJhE=
X-Received: by 2002:a62:2683:0:b029:19a:9594:1abe with SMTP id
 m125-20020a6226830000b029019a95941abemr6989185pfm.19.1607609669881; Thu, 10
 Dec 2020 06:14:29 -0800 (PST)
MIME-Version: 1.0
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com> <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon> <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com> <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
 <20201209095454.GA36812@ranger.igk.intel.com> <20201209125223.49096d50@carbon>
 <6913010d-2fd6-6713-94e9-8f5b8ad4b708@gmail.com> <20201210143211.2490f7f4@carbon>
In-Reply-To: <20201210143211.2490f7f4@carbon>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 10 Dec 2020 15:14:18 +0100
Message-ID: <CAJ8uoz25rtO63-4nOSV-yr8bORNbNSquiBBWiEouLs-ZUv2o=A@mail.gmail.com>
Subject: Re: [Intel-wired-lan] Explaining XDP redirect bulk size design (Was:
 [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set)
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Frey Alfredsson <freysteinn@freysteinn.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Marek Majtyka <marekx.majtyka@intel.com>,
        Marek Majtyka <alardam@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 2:32 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 9 Dec 2020 08:44:33 -0700
> David Ahern <dsahern@gmail.com> wrote:
>
> > On 12/9/20 4:52 AM, Jesper Dangaard Brouer wrote:
> > > But I have redesigned the ndo_xdp_xmit call to take a bulk of packets
> > > (up-to 16) so it should not be a problem to solve this by sharing
> > > TX-queue and talking a lock per 16 packets.  I still recommend that,
> > > for fallback case,  you allocated a number a TX-queue and distribute
> > > this across CPUs to avoid hitting a congested lock (above measurement=
s
> > > are the optimal non-congested atomic lock operation)
> >
> > I have been meaning to ask you why 16 for the XDP batching? If the
> > netdev budget is 64, why not something higher like 32 or 64?
>
> Thanks you for asking as there are multiple good reasons and
> consideration for this 16 batch size.  Notice cpumap have batch size 8,
> which is also an explicit choice.  And AF_XDP went in the wrong
> direction IMHO and I think have 256.  I designed this to be a choice in
> the map code, for the level of bulking it needs/wants.

FYI, as far as I know, there is nothing in AF_XDP that says bulking
should be 256. There is a 256 number in the i40e driver that states
the maximum number of packets to be sent within one napi_poll loop.
But this is just a maximum number and only for that driver. (In case
you wonder, that number was inherited from the original skb Tx
implementation in the driver.) The actual batch size is controlled by
the application. If it puts 1 packet in the Tx ring and calls send(),
the batch size will be 1. If it puts 128 packets in the Tx ring and
calls send(), you get a batch size of 128, and so on. It is flexible,
so you can trade-off latency with throughput in the way the
application desires. Rx batch size has also become flexible now with
the introduction of Bj=C3=B6rn's prefer_busy_poll patch set [1].

[1] https://lore.kernel.org/netdev/20201130185205.196029-1-bjorn.topel@gmai=
l.com/

> The low level explanation is that these 8 and 16 batch sizes are
> optimized towards cache sizes and Intel's Line-Fill-Buffer (prefetcher
> with 10 elements).  I'm betting on that memory backing these 8 or 16
> packets have higher chance to remain/being in cache, and I can prefetch
> them without evicting them from cache again.  In some cases the pointer
> to these packets are queued into a ptr_ring, and it is more optimal to
> write cacheline sizes 1 (8 pointers) or 2 (16 pointers) into the ptr_ring=
.
>
> The general explanation is my goal to do bulking without adding latency.
> This is explicitly stated in my presentation[1] as of Feb 2016, slide 20.
> Sure, you/we can likely make the micro-benchmarks look better by using
> 64 batch size, but that will introduce added latency and likely shoot
> our-selves in the foot for real workloads.  With experience from
> bufferbloat and real networks, we know that massive TX bulking have bad
> effects.  Still XDP-redirect does massive bulking (NIC flush is after
> full 64 budget) and we don't have pushback or a queue mechanism (so I
> know we are already shooting ourselves in the foot) ...  Fortunately we
> now have a PhD student working on queuing for XDP.
>
> It is also important to understand that this is an adaptive bulking
> scheme, which comes from NAPI.  We don't wait for packets arriving
> shortly, we pickup what NIC have available, but by only taking 8 or 16
> packets (instead of emptying the entire RX-queue), and then spending
> some time to send them along, I'm hoping that NIC could have gotten
> some more frame.  For cpumap and veth (in-some-cases) they can start to
> consume packets from these batches, but NIC drivers gets XDP_XMIT_FLUSH
> signal at NAPI-end (xdp_do_flush). Still design allows NIC drivers to
> update their internal queue state (and BQL), and if it gets close to
> full they can choose to flush/doorbell the NIC earlier.  When doing
> queuing for XDP we need to expose these NIC queue states, and having 4
> calls with 16 packets (64 budget) also gives us more chances to get NIC
> queue state info which the NIC already touch.
>
>
> [1] https://people.netfilter.org/hawk/presentations/devconf2016/net_stack=
_challenges_100G_Feb2016.pdf
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
