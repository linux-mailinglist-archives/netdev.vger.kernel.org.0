Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E1F6A63C2
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjB1XRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjB1XRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:17:22 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF2D199EA;
        Tue, 28 Feb 2023 15:17:20 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DF4C5C00E3;
        Tue, 28 Feb 2023 18:17:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 28 Feb 2023 18:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1677626238; x=
        1677712638; bh=4KxBwKlTQZ05BLQjRzeOs8wp458o4ENpyLmhm8kBBF8=; b=q
        It9z9OGTfT94KurTW4r2++HlnWTc8ppcw1U+1ih0whaZl6edWoV9KPzg8INNTYn6
        FBYu4PTKD683Q6ECPPajA6YKA49dl8IZjs3RcyDO8EicxiOFx+vRbBnArog7rHW0
        Lb0t6H0CFTiu0DEsVHD7eYNI0+8JZEwo3surYKWn6IWamPJzlDUZAiIuRhIwIq36
        TB0xh+ohbtrljb+cyOmxY2onCtN8WPjEirsLA80yWPPMN3L5vuzYw1ruX8wpb8lN
        +drsO4OmCHM+KzxZYtfoS3YCxFoRiYoMlPGwm8kH7H0LlhlaWr1hq1MIgp9jFmVE
        PhNyOzuT8X8oGbmuQna+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1677626238; x=
        1677712638; bh=4KxBwKlTQZ05BLQjRzeOs8wp458o4ENpyLmhm8kBBF8=; b=c
        HAVbbPs9z2GHoY4/QDROnKFhCYOJs2wzYftlUdsHeEk/ev3022oV0jNHeTFZKmb5
        1smXhbHJk9VnsiIzmQEGL4mAan2x1NGdnoprT2i7/b7K2uGz0mqXQ7eTF+B+1OgU
        7rRUiZ4Zs5fcKf2vVce+mcntH8eJsENYS4z5qise3UMJWotY9tlYh6RI8THR9KeQ
        3S0trnYqxEtTA+/SM9L5tdUq2ExTGEbIg5fq4bNz9VhTdkcn3+kyoCP4YSVlMLTk
        lKs9QRF/rTxS2hlBun27pHmCDQyOhRIGXfjCeSJNB6V0nsv68SeEcBx5ZbIRZO6m
        u50EOp8uvlYjPdHhonMDA==
X-ME-Sender: <xms:fov-Y1eZpVuDQqsZ_pjMAWdBtHUI_O1njFoxzzdrvYuwkiPAsEWbaA>
    <xme:fov-YzOQcOMwCfmpwQ3dB9tGAcwPPHqgc2no9BcB01X0Gsi0x3KNULFRAM1_3eDap
    8wsiY04osQ5VhqV2w>
X-ME-Received: <xmr:fov-Y-iP3xjX-FWkmLiHGa1T2kVLs5AH_mI7_1h3HpeGncCB_VdrSwLtGvTPgwpKAwdUAjI2zxhEmiji6kGvbBoC9Mco1RSh-VfckH3vUXI6Noiyd3sxiYhh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelgedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlvdefmdenucfjughrpeffhffvvefukfhfgggtugfgjgesthekredt
    tddtjeenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpefgteejiedthfdvvedujeetudeugeetieejfeegvefhjeeg
    keevheehvefgiefhgeenucffohhmrghinhepkhgvrhhnvghlnhgvfigsihgvshdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihu
    segugihuuhhurdighiii
X-ME-Proxy: <xmx:fov-Y-8hPpH8zQx9qO2xtThrBhTnf5ybansu7bER3xcs1JSxwv46ZQ>
    <xmx:fov-YxvxiHD-6hHwC72z_fN5-Qq9xHtseKAhmUuyHc-yKLlKD5v5WQ>
    <xmx:fov-Y9GGtyJE5r_k47X3ZLtk7i_LhiPd9IRpexT5FbhsaS7Z3TQ9Yw>
    <xmx:fov-Y7J6eXorEBy_ZCD_RAMed2tx2XpIbu6JS_moLO6iA4622CNM7w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Feb 2023 18:17:17 -0500 (EST)
Date:   Tue, 28 Feb 2023 16:17:16 -0700
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets
 in BPF
Message-ID: <20230228231716.a5uwc4tdo3kjlkg7@aviatrix-fedora.tail1b9c7.ts.net>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain>
 <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Mon, Feb 27, 2023 at 08:56:38PM -0800, Alexei Starovoitov wrote:
> On Mon, Feb 27, 2023 at 5:57 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > Hi Alexei,
> >
> > On Mon, Feb 27, 2023 at 03:03:38PM -0800, Alexei Starovoitov wrote:
> > > On Mon, Feb 27, 2023 at 12:51:02PM -0700, Daniel Xu wrote:
> > > > === Context ===
> > > >
> > > > In the context of a middlebox, fragmented packets are tricky to handle.
> > > > The full 5-tuple of a packet is often only available in the first
> > > > fragment which makes enforcing consistent policy difficult. There are
> > > > really only two stateless options, neither of which are very nice:
> > > >
> > > > 1. Enforce policy on first fragment and accept all subsequent fragments.
> > > >    This works but may let in certain attacks or allow data exfiltration.
> > > >
> > > > 2. Enforce policy on first fragment and drop all subsequent fragments.
> > > >    This does not really work b/c some protocols may rely on
> > > >    fragmentation. For example, DNS may rely on oversized UDP packets for
> > > >    large responses.
> > > >
> > > > So stateful tracking is the only sane option. RFC 8900 [0] calls this
> > > > out as well in section 6.3:
> > > >
> > > >     Middleboxes [...] should process IP fragments in a manner that is
> > > >     consistent with [RFC0791] and [RFC8200]. In many cases, middleboxes
> > > >     must maintain state in order to achieve this goal.
> > > >
> > > > === BPF related bits ===
> > > >
> > > > However, when policy is enforced through BPF, the prog is run before the
> > > > kernel reassembles fragmented packets. This leaves BPF developers in a
> > > > awkward place: implement reassembly (possibly poorly) or use a stateless
> > > > method as described above.
> > > >
> > > > Fortunately, the kernel has robust support for fragmented IP packets.
> > > > This patchset wraps the existing defragmentation facilities in kfuncs so
> > > > that BPF progs running on middleboxes can reassemble fragmented packets
> > > > before applying policy.
> > > >
> > > > === Patchset details ===
> > > >
> > > > This patchset is (hopefully) relatively straightforward from BPF perspective.
> > > > One thing I'd like to call out is the skb_copy()ing of the prog skb. I
> > > > did this to maintain the invariant that the ctx remains valid after prog
> > > > has run. This is relevant b/c ip_defrag() and ip_check_defrag() may
> > > > consume the skb if the skb is a fragment.
> > >
> > > Instead of doing all that with extra skb copy can you hook bpf prog after
> > > the networking stack already handled ip defrag?
> > > What kind of middle box are you doing? Why does it have to run at TC layer?
> >
> > Unless I'm missing something, the only other relevant hooks would be
> > socket hooks, right?
> >
> > Unfortunately I don't think my use case can do that. We are running the
> > kernel as a router, so no sockets are involved.
> 
> Are you using bpf_fib_lookup and populating kernel routing
> table and doing everything on your own including neigh ?

We're currently not doing any routing things in BPF yet. All the routing
manipulation has been done in iptables / netfilter so far. I'm not super
familiar with routing stuff but from what I understand there is some
relatively complicated stuff going on with BGP and ipsec tunnels at the
moment. Not sure if that answers your question.

> Have you considered to skb redirect to another netdev that does ip defrag?
> Like macvlan does it under some conditions. This can be generalized.

I had not considered that yet. Are you suggesting adding a new
passthrough netdev thing that'll defrags? I looked at the macvlan driver
and it looks like it defrags to handle some multicast corner case.

> Recently Florian proposed to allow calling bpf progs from all existing
> netfilter hooks.
> You can pretend to local deliver and hook in NF_INET_LOCAL_IN ?

Does that work for forwarding cases? I'm reading through [0] and it
seems to suggest that it'll only defrag for locally destined packets:

    If the destination IP address is matches with
    local NIC's IP address, the dst_input() function will brings the packets
    into the ip_local_deliver(), which will defrag the packet and pass it
    to the NF_IP_LOCAL_IN hook

Faking local delivery seems kinda ugly -- maybe I don't know any clean
ways.

[...]

[0]: https://kernelnewbies.org/Networking?action=AttachFile&do=get&target=hacking_the_wholism_of_linux_net.txt


Thanks,
Daniel
