Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E466A6247
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjB1WSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjB1WSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:18:44 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45CC93E1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:18:42 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id a2so1583265plm.4
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677622722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9NdpVFn+rPdnCMfrq/yARBw+QEhzBJVOkM4cUGACPcA=;
        b=EUXFN//U6aBS4KqZG6q3tpmdUwl6MR1N/HK0/s5ww/PFHBAGrLFej74lgsG9nKV3bh
         vzwHtcyj20tchdSYKvFG7i7p2aHp+Z+R5DySOJXVKGF0RuDZkJZXGjqduwWv64Iqlysu
         Kxeu7x7OPZiVf9whnaRHiBYJz/Ki86E7qSLbWBrX+R+B7GUzlItpwcW1rLu9EYBnKOuL
         g+SB62/NWFTwG0fxJuJSQGnW4vfZ501Z+v/Ti1fFyPG+EFHf6/R+GMcVXya4gEV3tbZj
         OVxYBCPfQXPX0wT05l2d95EMrsn3KKUFUDTWfSbjD4V4GrxWNMj+gCY2c1jPVYE/SzHv
         Fgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677622722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9NdpVFn+rPdnCMfrq/yARBw+QEhzBJVOkM4cUGACPcA=;
        b=6mIAwWqk4GVehd5lcbygdsEjivsFOLlpSQaKongtvcLDGCoacmfJnuXI4upSstN/tA
         ihRyU8GXJqzsOTtmHQhFAbGlsvFAVUKQeRRXIF8ux53Dqa3rGoub85DCybFb4IvWbz8a
         LFllo2BFZE3pQ4h1RVBKftlkAoixxmPwccnujh1rTnOx+2LxO4rlJ6zoi5oAN5PO2EPf
         3sZUDW4yi7+gEsc79BsPE13GKGKRCeP4HLEXSHusKIg1gMQlyIu+9RMMiyMpW0fCmgID
         PFOovQ2DVYflqTFHZ+NUPb2Rbc5pMeY8S/QQ+RExKb2RBLh0iFirhcD0/TgnoSMvdS9i
         5PyQ==
X-Gm-Message-State: AO0yUKWOPdAj6Yc1QmPweJXO2+emR/VIXFAquWPBiARrfE8BI23esynj
        PBFItXGQeqBfecnWJb4eU5EilJD2gGik6dpUEgP6AWISrcx9p1lxefA=
X-Google-Smtp-Source: AK7set/ji2FVJAPJ3Y44hofTDY63L+cgXkm+aivp5VSm2X91P9Wdg+vrLtrpNjdRITNCT/QTKosFDLOipWuSLVFRirU=
X-Received: by 2002:a17:903:2489:b0:19b:c212:b2eb with SMTP id
 p9-20020a170903248900b0019bc212b2ebmr1550724plw.10.1677622721875; Tue, 28 Feb
 2023 14:18:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1677526810.git.dxu@dxuuu.xyz> <7145c9891791db1c868a326476fef590f22b352b.1677526810.git.dxu@dxuuu.xyz>
 <Y/5X7BF9CDYZMuMl@google.com> <20230228220007.7qrcazeepnyjoqns@kashmir.localdomain>
In-Reply-To: <20230228220007.7qrcazeepnyjoqns@kashmir.localdomain>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 28 Feb 2023 14:18:30 -0800
Message-ID: <CAKH8qBsFoyhMj6G_Ldp2ZXV980NTQ4VcJb3Y+Uphn0j1L1xe+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/8] bpf, net, frags: Add bpf_ip_check_defrag()
 kfunc
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
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

On Tue, Feb 28, 2023 at 2:00 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Hi Stanislav,
>
> On Tue, Feb 28, 2023 at 11:37:16AM -0800, Stanislav Fomichev wrote:
> > On 02/27, Daniel Xu wrote:
> > > This kfunc is used to defragment IPv4 packets. The idea is that if you
> > > see a fragmented packet, you call this kfunc. If the kfunc returns 0,
> > > then the skb has been updated to contain the entire reassembled packet.
> >
> > > If the kfunc returns an error (most likely -EINPROGRESS), then it means
> > > the skb is part of a yet-incomplete original packet. A reasonable
> > > response to -EINPROGRESS is to drop the packet, as the ip defrag
> > > infrastructure is already hanging onto the frag for future reassembly.
> >
> > > Care has been taken to ensure the prog skb remains valid no matter what
> > > the underlying ip_check_defrag() call does. This is in contrast to
> > > ip_defrag(), which may consume the skb if the skb is part of a
> > > yet-incomplete original packet.
> >
> > > So far this kfunc is only callable from TC clsact progs.
> >
> > > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > > ---
> > >   include/net/ip.h           | 11 +++++
> > >   net/ipv4/Makefile          |  1 +
> > >   net/ipv4/ip_fragment.c     |  2 +
> > >   net/ipv4/ip_fragment_bpf.c | 98 ++++++++++++++++++++++++++++++++++++++
> > >   4 files changed, 112 insertions(+)
> > >   create mode 100644 net/ipv4/ip_fragment_bpf.c
> >
> > > diff --git a/include/net/ip.h b/include/net/ip.h
> > > index c3fffaa92d6e..f3796b1b5cac 100644
> > > --- a/include/net/ip.h
> > > +++ b/include/net/ip.h
> > > @@ -680,6 +680,7 @@ enum ip_defrag_users {
> > >     IP_DEFRAG_VS_FWD,
> > >     IP_DEFRAG_AF_PACKET,
> > >     IP_DEFRAG_MACVLAN,
> > > +   IP_DEFRAG_BPF,
> > >   };
> >
> > >   /* Return true if the value of 'user' is between 'lower_bond'
> > > @@ -693,6 +694,16 @@ static inline bool ip_defrag_user_in_between(u32
> > > user,
> > >   }
> >
> > >   int ip_defrag(struct net *net, struct sk_buff *skb, u32 user);
> > > +
> > > +#ifdef CONFIG_DEBUG_INFO_BTF
> > > +int register_ip_frag_bpf(void);
> > > +#else
> > > +static inline int register_ip_frag_bpf(void)
> > > +{
> > > +   return 0;
> > > +}
> > > +#endif
> > > +
> > >   #ifdef CONFIG_INET
> > >   struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb,
> > > u32 user);
> > >   #else
> > > diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
> > > index 880277c9fd07..950efb166d37 100644
> > > --- a/net/ipv4/Makefile
> > > +++ b/net/ipv4/Makefile
> > > @@ -65,6 +65,7 @@ obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
> > >   obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
> > >   obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
> > >   obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
> > > +obj-$(CONFIG_DEBUG_INFO_BTF) += ip_fragment_bpf.o
> >
> > >   obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
> > >                   xfrm4_output.o xfrm4_protocol.o
> > > diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
> > > index 959d2c4260ea..e3fda5203f09 100644
> > > --- a/net/ipv4/ip_fragment.c
> > > +++ b/net/ipv4/ip_fragment.c
> > > @@ -759,5 +759,7 @@ void __init ipfrag_init(void)
> > >     if (inet_frags_init(&ip4_frags))
> > >             panic("IP: failed to allocate ip4_frags cache\n");
> > >     ip4_frags_ctl_register();
> > > +   if (register_ip_frag_bpf())
> > > +           panic("IP: bpf: failed to register ip_frag_bpf\n");
> > >     register_pernet_subsys(&ip4_frags_ops);
> > >   }
> > > diff --git a/net/ipv4/ip_fragment_bpf.c b/net/ipv4/ip_fragment_bpf.c
> > > new file mode 100644
> > > index 000000000000..a9e5908ed216
> > > --- /dev/null
> > > +++ b/net/ipv4/ip_fragment_bpf.c
> > > @@ -0,0 +1,98 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Unstable ipv4 fragmentation helpers for TC-BPF hook
> > > + *
> > > + * These are called from SCHED_CLS BPF programs. Note that it is
> > > allowed to
> > > + * break compatibility for these functions since the interface they are
> > > exposed
> > > + * through to BPF programs is explicitly unstable.
> > > + */
> > > +
> > > +#include <linux/bpf.h>
> > > +#include <linux/btf_ids.h>
> > > +#include <linux/ip.h>
> > > +#include <linux/filter.h>
> > > +#include <linux/netdevice.h>
> > > +#include <net/ip.h>
> > > +#include <net/sock.h>
> > > +
> > > +__diag_push();
> > > +__diag_ignore_all("-Wmissing-prototypes",
> > > +             "Global functions as their definitions will be in ip_fragment BTF");
> > > +
> > > +/* bpf_ip_check_defrag - Defragment an ipv4 packet
> > > + *
> > > + * This helper takes an skb as input. If this skb successfully
> > > reassembles
> > > + * the original packet, the skb is updated to contain the original,
> > > reassembled
> > > + * packet.
> > > + *
> > > + * Otherwise (on error or incomplete reassembly), the input skb remains
> > > + * unmodified.
> > > + *
> > > + * Parameters:
> > > + * @ctx            - Pointer to program context (skb)
> > > + * @netns  - Child network namespace id. If value is a negative signed
> > > + *           32-bit integer, the netns of the device in the skb is used.
> > > + *
> > > + * Return:
> > > + * 0 on successfully reassembly or non-fragmented packet. Negative
> > > value on
> > > + * error or incomplete reassembly.
> > > + */
> > > +int bpf_ip_check_defrag(struct __sk_buff *ctx, u64 netns)
> >
> > Needs a __bpf_kfunc tag as well?
>
> Ack.
>
> > > +{
> > > +   struct sk_buff *skb = (struct sk_buff *)ctx;
> > > +   struct sk_buff *skb_cpy, *skb_out;
> > > +   struct net *caller_net;
> > > +   struct net *net;
> > > +   int mac_len;
> > > +   void *mac;
> > > +
> >
> > [..]
> >
> > > +   if (unlikely(!((s32)netns < 0 || netns <= S32_MAX)))
> > > +           return -EINVAL;
> >
> > Can you explain what it does? Is it checking for -1 explicitly? Not sure
> > it works :-/
> >
> > Maybe we can spell out the cases explicitly?
> > if (unlikely(
> >            ((s32)netns < 0 && netns != S32_MAX) || /* -1 */
> >            netns > U32_MAX /* higher 4 bytes */
> >           )
> >       return -EINVAL;
> >
>
> I copied this from net/core/filter.c:__bpf_skc_lookup:
>
>         if (unlikely(flags || !((s32)netns_id < 0 || netns_id <= S32_MAX)))
>                 goto out;
>
> The semantics are a bit odd, but I thought it'd be good to maintain
> consistency. I believe the code correctly checks what the docs describe:
>
>         @netns  - Child network namespace id. If value is a negative signed
>                   32-bit integer, the netns of the device in the skb is used.
>
> I can pull out the logic into a helper for v3.
>
> [...]

Ah, so this comes from commit f71c6143c203 ("bpf: Support sk lookup in
netns with id 0") which explicitly treats everything <0 as
current_netns, makes sense.
In this case agreed, let's keep for consistency. Up to you on whether
to pull it out in the helper or keep as is.

>
>
> Thanks,
> Daniel
