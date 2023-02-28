Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63216A6206
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjB1WAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1WAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:00:15 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D265B8C;
        Tue, 28 Feb 2023 14:00:12 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A149D5C02AC;
        Tue, 28 Feb 2023 17:00:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 28 Feb 2023 17:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677621610; x=1677708010; bh=aNAgHaJy6a
        AUHCk0J9b41K7Ir+UwyzX6a2u2nOJgENc=; b=A5KbX0M4SbSIsq+2A7eW2KKJR9
        dp8sI4U2Nd5aQHyOyOVLKn7Ag19cmwk/6wyS4m4lVLwVVqQJqrblEnvlYVjoeWEw
        Uu06A40aO20Ojo1ds6YNQ/TJ+NIMDSb9ydt1FSuo+I7dKArR4YJunioGGO17L/c3
        dbRoMWWeiGOcYuA8xsFtjmRJAnpbQetVMDuwEX+mSnj6RDPHUt3ZOsbqJLdniD1k
        hlDgiWE6QFp658LddRnYvhd01HYLCxGSKjhjQltKtw9BS4tpd4oM6x66vp7Ra6Tb
        3xffFjcoqX4s40EBPcGDQxEcm3Yfi5N6KDhNAMhdR9esjXwAH6rPgOngB/Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677621610; x=1677708010; bh=aNAgHaJy6aAUHCk0J9b41K7Ir+Uw
        yzX6a2u2nOJgENc=; b=TvyC0F/pyYsT7tnUKG6brxOBFkexCrDv0lgNw8DFDDjU
        zqFGXMhHCxtC6N58KWXDEIOHlxES4tBcZPPMVE0GjE0i4xiiCDJwjRhOucZIkNfx
        GOjvGSc++6ow6BXrrhU2pyev0PdlwzkTGGGC+5uogP7+0HNzROiONhg2WtgF4G0f
        Pngp6+16dJP3EqRDqpkJ0UdpeaC1iurRWUxNBniY0xccIO276jKcmVoFwGcYTYNl
        lKgmun+mdJcAVOJ+tqhKndc78WOZJFB5Xp7GZ2rt2TOunH6EsY4oUL3t6W3PCSEI
        lEC+4Pz+secUnWzqwQZNir9kcXOdDScppj2PyJdQ5A==
X-ME-Sender: <xms:aXn-Y8SPyh8AD8VTg2RKOGK3ZPl-iiRfI2NN4RKLUGwZ8n_hmNRflg>
    <xme:aXn-Y5xqD08YSPNca3mZW-8qCOAiGV3j134UhloWhmMt3K0-51QpEtW4QXU15pZ5x
    g2x_P1bmPQB0z_reg>
X-ME-Received: <xmr:aXn-Y53kiAoizQm8_KSKuVwUUgL_Osd-FDoulTqh2Q1IllPpDLenqLmgALx2AkyMfppbyDzxz_piOSqsXa8omVtc-r7NTpe6ZPDtJig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelfedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpeffhf
    fvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepveduudegiefhtdffhe
    fggfdugeeggeehtefgvefhkeekieelueeijeelkeeivdfgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:aXn-YwDRTaWQjkhZmtkITNafg4S3DOFkgfLevxvdBtVeN_9RzZxplg>
    <xmx:aXn-Y1jBKzQVSE5uSyIC9lqjBW9ukV2M5uZDhgOFOZCBgZxijwdMdg>
    <xmx:aXn-Y8r-XJS8ysPMhQpTGg9GRA9nWP97Rxed1vqeV-oHFNFcAVsnTQ>
    <xmx:ann-Y9jT2PL7mzD6HHfBsQMsfNQrEp2isrCY51EAMDh7NRrwmwe8Mw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Feb 2023 17:00:09 -0500 (EST)
Date:   Tue, 28 Feb 2023 15:00:07 -0700
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/8] bpf, net, frags: Add
 bpf_ip_check_defrag() kfunc
Message-ID: <20230228220007.7qrcazeepnyjoqns@kashmir.localdomain>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <7145c9891791db1c868a326476fef590f22b352b.1677526810.git.dxu@dxuuu.xyz>
 <Y/5X7BF9CDYZMuMl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/5X7BF9CDYZMuMl@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

On Tue, Feb 28, 2023 at 11:37:16AM -0800, Stanislav Fomichev wrote:
> On 02/27, Daniel Xu wrote:
> > This kfunc is used to defragment IPv4 packets. The idea is that if you
> > see a fragmented packet, you call this kfunc. If the kfunc returns 0,
> > then the skb has been updated to contain the entire reassembled packet.
> 
> > If the kfunc returns an error (most likely -EINPROGRESS), then it means
> > the skb is part of a yet-incomplete original packet. A reasonable
> > response to -EINPROGRESS is to drop the packet, as the ip defrag
> > infrastructure is already hanging onto the frag for future reassembly.
> 
> > Care has been taken to ensure the prog skb remains valid no matter what
> > the underlying ip_check_defrag() call does. This is in contrast to
> > ip_defrag(), which may consume the skb if the skb is part of a
> > yet-incomplete original packet.
> 
> > So far this kfunc is only callable from TC clsact progs.
> 
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > ---
> >   include/net/ip.h           | 11 +++++
> >   net/ipv4/Makefile          |  1 +
> >   net/ipv4/ip_fragment.c     |  2 +
> >   net/ipv4/ip_fragment_bpf.c | 98 ++++++++++++++++++++++++++++++++++++++
> >   4 files changed, 112 insertions(+)
> >   create mode 100644 net/ipv4/ip_fragment_bpf.c
> 
> > diff --git a/include/net/ip.h b/include/net/ip.h
> > index c3fffaa92d6e..f3796b1b5cac 100644
> > --- a/include/net/ip.h
> > +++ b/include/net/ip.h
> > @@ -680,6 +680,7 @@ enum ip_defrag_users {
> >   	IP_DEFRAG_VS_FWD,
> >   	IP_DEFRAG_AF_PACKET,
> >   	IP_DEFRAG_MACVLAN,
> > +	IP_DEFRAG_BPF,
> >   };
> 
> >   /* Return true if the value of 'user' is between 'lower_bond'
> > @@ -693,6 +694,16 @@ static inline bool ip_defrag_user_in_between(u32
> > user,
> >   }
> 
> >   int ip_defrag(struct net *net, struct sk_buff *skb, u32 user);
> > +
> > +#ifdef CONFIG_DEBUG_INFO_BTF
> > +int register_ip_frag_bpf(void);
> > +#else
> > +static inline int register_ip_frag_bpf(void)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >   #ifdef CONFIG_INET
> >   struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb,
> > u32 user);
> >   #else
> > diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
> > index 880277c9fd07..950efb166d37 100644
> > --- a/net/ipv4/Makefile
> > +++ b/net/ipv4/Makefile
> > @@ -65,6 +65,7 @@ obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
> >   obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
> >   obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
> >   obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
> > +obj-$(CONFIG_DEBUG_INFO_BTF) += ip_fragment_bpf.o
> 
> >   obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
> >   		      xfrm4_output.o xfrm4_protocol.o
> > diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
> > index 959d2c4260ea..e3fda5203f09 100644
> > --- a/net/ipv4/ip_fragment.c
> > +++ b/net/ipv4/ip_fragment.c
> > @@ -759,5 +759,7 @@ void __init ipfrag_init(void)
> >   	if (inet_frags_init(&ip4_frags))
> >   		panic("IP: failed to allocate ip4_frags cache\n");
> >   	ip4_frags_ctl_register();
> > +	if (register_ip_frag_bpf())
> > +		panic("IP: bpf: failed to register ip_frag_bpf\n");
> >   	register_pernet_subsys(&ip4_frags_ops);
> >   }
> > diff --git a/net/ipv4/ip_fragment_bpf.c b/net/ipv4/ip_fragment_bpf.c
> > new file mode 100644
> > index 000000000000..a9e5908ed216
> > --- /dev/null
> > +++ b/net/ipv4/ip_fragment_bpf.c
> > @@ -0,0 +1,98 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Unstable ipv4 fragmentation helpers for TC-BPF hook
> > + *
> > + * These are called from SCHED_CLS BPF programs. Note that it is
> > allowed to
> > + * break compatibility for these functions since the interface they are
> > exposed
> > + * through to BPF programs is explicitly unstable.
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/ip.h>
> > +#include <linux/filter.h>
> > +#include <linux/netdevice.h>
> > +#include <net/ip.h>
> > +#include <net/sock.h>
> > +
> > +__diag_push();
> > +__diag_ignore_all("-Wmissing-prototypes",
> > +		  "Global functions as their definitions will be in ip_fragment BTF");
> > +
> > +/* bpf_ip_check_defrag - Defragment an ipv4 packet
> > + *
> > + * This helper takes an skb as input. If this skb successfully
> > reassembles
> > + * the original packet, the skb is updated to contain the original,
> > reassembled
> > + * packet.
> > + *
> > + * Otherwise (on error or incomplete reassembly), the input skb remains
> > + * unmodified.
> > + *
> > + * Parameters:
> > + * @ctx		- Pointer to program context (skb)
> > + * @netns	- Child network namespace id. If value is a negative signed
> > + *		  32-bit integer, the netns of the device in the skb is used.
> > + *
> > + * Return:
> > + * 0 on successfully reassembly or non-fragmented packet. Negative
> > value on
> > + * error or incomplete reassembly.
> > + */
> > +int bpf_ip_check_defrag(struct __sk_buff *ctx, u64 netns)
> 
> Needs a __bpf_kfunc tag as well?

Ack.

> > +{
> > +	struct sk_buff *skb = (struct sk_buff *)ctx;
> > +	struct sk_buff *skb_cpy, *skb_out;
> > +	struct net *caller_net;
> > +	struct net *net;
> > +	int mac_len;
> > +	void *mac;
> > +
> 
> [..]
> 
> > +	if (unlikely(!((s32)netns < 0 || netns <= S32_MAX)))
> > +		return -EINVAL;
> 
> Can you explain what it does? Is it checking for -1 explicitly? Not sure
> it works :-/
> 
> Maybe we can spell out the cases explicitly?
> if (unlikely(
> 	     ((s32)netns < 0 && netns != S32_MAX) || /* -1 */
> 	     netns > U32_MAX /* higher 4 bytes */
> 	    )
> 	return -EINVAL;
> 

I copied this from net/core/filter.c:__bpf_skc_lookup:

	if (unlikely(flags || !((s32)netns_id < 0 || netns_id <= S32_MAX)))
		goto out;

The semantics are a bit odd, but I thought it'd be good to maintain
consistency. I believe the code correctly checks what the docs describe:

        @netns	- Child network namespace id. If value is a negative signed
                  32-bit integer, the netns of the device in the skb is used.

I can pull out the logic into a helper for v3.

[...]


Thanks,
Daniel
