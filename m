Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63948613BD8
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiJaRBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiJaRBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:01:06 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9BA12AE1
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:01:05 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id h206so6772087iof.10
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f4s15Za+uSzAsQZj249tp1Omo6kgOb9eUJ9XyW/+V5M=;
        b=Z6B2CCbReQPcZ7EHhqOPPBGgei8DH4h+Om9SUrywspyp3OGRODRKV+RZkOzMMR4+dL
         Kau5vcfgz0KIIn8jd6x/ouoKPS8bSSnvdp8jZYVM1RyHfrhSxvs0Noa6JgfytvwL8bdw
         8WK0tNVBXRvbjG+p5n7hrpvHw/nVV2eWS//A29W5s/mwlHS8VjVtAr9XS7iDhat9OUpj
         tuSUt6fQYCqraXj0IG0sKwo0YHxs74Yz6HdHx1rg44cK7jN05snWvQG96MHBdli0Zljq
         hMGS/xa99Z6VJJNrrPEflbBDeZLr4XK/4vJduCgEALDY3aNbVD0KiV+FXIoCzhS4lEkE
         QCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f4s15Za+uSzAsQZj249tp1Omo6kgOb9eUJ9XyW/+V5M=;
        b=7pnk5MmKs/Whs4EOhIX/WPdmkEhozadwqOib3PVLplNJRszYIu02NNk6X0GPBk7faH
         tRHeJqd4OQI9Y/Tjag4qFpOC8+MITV4qT/t73Q8dPgAT0UIFymPqqWY7WXz3JgHGHAnf
         8wxRgV1H1qk0s8u/dOf4CnD401cIU7cF1rz3F8bgychJPnTD4Bwjr5yMMfpAJc65L+2L
         bEcHX1BYjm38Is4BwJ9PwiNlKjDY/JHozU+53P6GYtPLg5AksspG6pWGGfaiAWRnF1mx
         8xvsJGrNtFlxYj62LzDTryd7JP3pcohfn0t4Rw2kpT5kdeDcDlt2k3QLGQpaRdWb/3yd
         AvAw==
X-Gm-Message-State: ACrzQf0a/y14npUUURPgARuAENNJoRP3gcX6066vFJg9p6dWou3BmgoQ
        lBHLQsQXj8Km/zlKFQlUBT6xD75B49Gq4jkPHBKWHg==
X-Google-Smtp-Source: AMsMyM6vdRO6SlbP5LNupqNwI549TZN8WBsEYnuG+JGbew/jeE+vhYJ18bCoPcvbLR3m8hmgi2xQoej0bLa2Cf0bFAg=
X-Received: by 2002:a05:6602:2e84:b0:6bc:e289:8469 with SMTP id
 m4-20020a0566022e8400b006bce2898469mr7354095iow.202.1667235664808; Mon, 31
 Oct 2022 10:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <20221027200019.4106375-6-sdf@google.com>
 <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev> <1885bc0c-1929-53ba-b6f8-ace2393a14df@redhat.com>
 <CAKH8qBt3hNUO0H_C7wYiwBEObGEFPXJCCLfkA=GuGC1CSpn55A@mail.gmail.com> <20221031142032.164247-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221031142032.164247-1-alexandr.lobakin@intel.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 31 Oct 2022 10:00:54 -0700
Message-ID: <CAKH8qBt1qM1n0X5uwxcBph9gLOv3FXR2q11viUoxxn35Z2_=ag@mail.gmail.com>
Subject: Re: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in xskxceiver
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>, brouer@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 7:22 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Stanislav Fomichev <sdf@google.com>
> Date: Fri, 28 Oct 2022 11:46:14 -0700
>
> > On Fri, Oct 28, 2022 at 3:37 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> > >
> > >
> > > On 28/10/2022 08.22, Martin KaFai Lau wrote:
> > > > On 10/27/22 1:00 PM, Stanislav Fomichev wrote:
> > > >> Example on how the metadata is prepared from the BPF context
> > > >> and consumed by AF_XDP:
> > > >>
> > > >> - bpf_xdp_metadata_have_rx_timestamp to test whether it's supported;
> > > >>    if not, I'm assuming verifier will remove this "if (0)" branch
> > > >> - bpf_xdp_metadata_rx_timestamp returns a _copy_ of metadata;
> > > >>    the program has to bpf_xdp_adjust_meta+memcpy it;
> > > >>    maybe returning a pointer is better?
> > > >> - af_xdp consumer grabs it from data-<expected_metadata_offset> and
> > > >>    makes sure timestamp is not empty
> > > >> - when loading the program, we pass BPF_F_XDP_HAS_METADATA+prog_ifindex
> > > >>
> > > >> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > > >> Cc: Jakub Kicinski <kuba@kernel.org>
> > > >> Cc: Willem de Bruijn <willemb@google.com>
> > > >> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > > >> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > > >> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > > >> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > > >> Cc: Maryam Tahhan <mtahhan@redhat.com>
> > > >> Cc: xdp-hints@xdp-project.net
> > > >> Cc: netdev@vger.kernel.org
> > > >> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > >> ---
> > > >>   .../testing/selftests/bpf/progs/xskxceiver.c  | 22 ++++++++++++++++++
> > > >>   tools/testing/selftests/bpf/xskxceiver.c      | 23 ++++++++++++++++++-
> > > >>   2 files changed, 44 insertions(+), 1 deletion(-)
>
> [...]
>
> > > IMHO sizeof() should come from a struct describing data_meta area see:
> > >
> > > https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L62
> >
> > I guess I should've used pointers for the return type instead, something like:
> >
> > extern __u64 *bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;
> >
> > {
> >    ...
> >     __u64 *rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> >     if (rx_timestamp) {
> >         bpf_xdp_adjust_meta(ctx, -(int)sizeof(*rx_timestamp));
> >         __builtin_memcpy(data_meta, rx_timestamp, sizeof(*rx_timestamp));
> >     }
> > }
> >
> > Does that look better?
>
> I guess it will then be resolved to a direct store, right?
> I mean, to smth like
>
>         if (rx_timestamp)
>                 *(u32 *)data_meta = *rx_timestamp;
>
> , where *rx_timestamp points directly to the Rx descriptor?

Right. I should've used that form from the beginning, that memcpy is
confusing :-(

> >
> > > >> +        if (ret != 0)
> > > >> +            return XDP_DROP;
> > > >> +
> > > >> +        data = (void *)(long)ctx->data;
> > > >> +        data_meta = (void *)(long)ctx->data_meta;
> > > >> +
> > > >> +        if (data_meta + sizeof(__u32) > data)
> > > >> +            return XDP_DROP;
> > > >> +
> > > >> +        rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> > > >> +        __builtin_memcpy(data_meta, &rx_timestamp, sizeof(__u32));
> > >
> > > So, this approach first stores hints on some other memory location, and
> > > then need to copy over information into data_meta area. That isn't good
> > > from a performance perspective.
> > >
> > > My idea is to store it in the final data_meta destination immediately.
> >
> > This approach doesn't have to store the hints in the other memory
> > location. xdp_buff->priv can point to the real hw descriptor and the
> > kfunc can have a bytecode that extracts the data from the hw
> > descriptors. For this particular RFC, we can think that 'skb' is that
> > hw descriptor for veth driver.
>
> I really do think intermediate stores can be avoided with this
> approach.
> Oh, and BTW, if we plan to use a particular Hint in the BPF program
> only, there's no need to place it in the metadata area at all, is
> there? You only want to get it in your code, so just retrieve it to
> the stack and that's it. data_meta is only for cases when you want
> hints to appear in AF_XDP.

Correct.

> > > Do notice that in my approach, the existing ethtool config setting and
> > > socket options (for timestamps) still apply.  Thus, each individual
> > > hardware hint are already configurable. Thus we already have a config
> > > interface. I do acknowledge, that in-case a feature is disabled it still
> > > takes up space in data_meta areas, but importantly it is NOT stored into
> > > the area (for performance reasons).
> >
> > That should be the case with this rfc as well, isn't it? Worst case
> > scenario, that kfunc bytecode can explicitly check ethtool options and
> > return false if it's disabled?
>
> (to Jesper)
>
> Once again, Ethtool idea doesn't work. Let's say you have roughly
> 50% of frames to be consumed by XDP, other 50% go to skb path and
> the stack. In skb, I want as many HW data as possible: checksums,
> hash and so on. Let's say in XDP prog I want only timestamp. What's
> then? Disable everything but stamp and kill skb path? Enable
> everything and kill XDP path?
> Stanislav's approach allows you to request only fields you need from
> the BPF prog directly, I don't see any reasons for adding one more
> layer "oh no I won't give you checksum because it's disabled via
> Ethtool".
> Maybe I get something wrong, pls explain then :P

Agree, good point.

> > > >> +    }
> > > >
> > > > Thanks for the patches.  I took a quick look at patch 1 and 2 but
> > > > haven't had a chance to look at the implementation details (eg.
> > > > KF_UNROLL...etc), yet.
> > > >
> > >
> > > Yes, thanks for the patches, even-though I don't agree with the
> > > approach, at-least until my concerns/use-case can be resolved.
> > > IMHO the best way to convince people is through code. So, thank you for
> > > the effort.  Hopefully we can use some of these ideas and I can also
> > > change/adjust my XDP-hints ideas to incorporate some of this :-)
> >
> > Thank you for the feedback as well, appreciate it!
> > Definitely, looking forward to a v2 from you with some more clarity on
> > how those btf ids are handled by the bpf/af_xdp side!
> >
> > > > Overall (with the example here) looks promising.  There is a lot of
> > > > flexibility on whether the xdp prog needs any hint at all, which hint it
> > > > needs, and how to store it.
> > > >
> > >
> > > I do see the advantage that XDP prog only populates metadata it needs.
> > > But how can we use/access this in __xdp_build_skb_from_frame() ?
> >
> > I don't think __xdp_build_skb_from_frame is automagically solved by
> > either proposal?
>
> It's solved in my approach[0], so that __xdp_build_skb_from_frame()
> are automatically get skb fields populated with the metadata if
> available. But I always use a fixed generic structure, which can't
> compete with your series in terms of flexibility (but solves stuff
> like inter-vendor redirects and so on).
> So in general I feel like there should be 2 options for metadata for
> users:
>
> 1) I use one particular vendor and I always compile AF_XDP programs
>    from fresh source code. I need to read/write only fields I want
>    to. I'd go with kfunc or kptr here (but I don't think BPF progs
>    should parse descriptor formats on their own, so your unroll NDO
>    approach looks optimal for me for that case);
> 2) I use multiple vendors, pre-compiled AF_XDP programs or just old
>    source code, I use veth and/or cpumap. So it's sorta
>    back-forward-left-right-compatibility path. So here we could just
>    use a fixed structure.

For (2) I really like Toke's suggestion about some extra helper that
prepares the metadata that the kernel path will later on be able to
understand.
The only downside I see is that it has to be called explicitly, but if
we assume that libxdp can also abstract this detail, doesn't sound
like a huge issue to me?

> > For this proposal, there has to be some expected kernel metadata
> > format that bpf programs will prepare and the kernel will understand?
> > Think of it like xdp_hints_common from your proposal; the program will
> > have to put together xdp_hints_skb into xdp metadata with the parts
> > that can be populated into skb by the kernel.
> >
> > For your btf ids proposal, it seems there has to be some extra kernel
> > code to parse all possible driver btf_if formats and copy the
> > metadata?
>
> That's why I define a "generic" struct, so that its consumers
> wouldn't have to if-else through a dozen of possible IDs :P
>
> [...]
>
> Great stuff from my PoV, I'd probably like to have some helpers for
> writing this new NDO, so that small vendors wouldn't be afraid of
> implementing it as Jakub mentioned. But still sorta optimal and
> elegant for me, I'm not sure I want to post a "demo version" of my
> series anymore :D
> I feel like this way + one more "everything-compat-fixed" couple
> would satisfy most of potential users.

Awesome, thanks for the review and the feedback!
