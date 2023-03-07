Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB4F6AF632
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjCGT4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjCGTzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:55:54 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C4656525;
        Tue,  7 Mar 2023 11:48:06 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 0D1C43200AA7;
        Tue,  7 Mar 2023 14:48:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 07 Mar 2023 14:48:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1678218484; x=1678304884; bh=i2XAzD+F4/rjBbe17O/XOpaCPV7I5BfH1Rg
        lNA7lUi0=; b=Lo9Iu5zqQqfT+CrUx2U9KYmBN53OFppA0fHYIv4c4NUG+VJIWHY
        Z2Lu+rat5ugeSyi8xih5NzAOWeoN7jDaELUQX3qbztx9BMvrZbHuhG3ILGpilbfr
        uS5gAD74/ZFpfrIxDfE69ztQ9w/bL4s2podjo7XccSIHPB7DwT3cBvihMBPwabtN
        6QGksZnbWtHq4QcnA+91wn4FJ5Xye3L/rsr5+WKE+e5aK7JPsJWjlfZB6ZSckOho
        3nOtYv8keAAOX2xu2+vizQpbrfEth3/i5f0WZ7nvxPB87/JIBohZG1k5rkFAnwa2
        G2K/1Op1/wYpJG0gIGVr0HoE/cZni2SKj7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1678218484; x=1678304884; bh=i2XAzD+F4/rjBbe17O/XOpaCPV7I5BfH1Rg
        lNA7lUi0=; b=ehYxmA7iows/9kAaBcYRKzjJ70llC8MXYDIk3Q7EFV2F8k1t6Tt
        yUsxY6vuDgnMSPZRxoRmA4CSBqbF4KqzRlILWmaF1k3KA1gG5v6B5+DD0dLDLJxK
        k3duU/N/K+Sb09c3WE+p3pVzMYK8TPzoL5f3AFS5V2RMOIXDfDwmmyY0XTNh/7Vi
        AVJQQUI48iOk0C68uejz8g2WeKCdI0OMAxSb1nTXx963V/Ec6ymzAMhPZiVygRzh
        8oMVVQpK5txcV1SYlrGRgNLpV/HHdIj0quDUy0zRXo9cEr5ISNgKbg2SPUt5CqVE
        2OEsCS7uUo2Dg8WDAGkY+5fKwhjmL2wvLWA==
X-ME-Sender: <xms:85QHZFSfG05a9c4zR34InWpCmeUE6cLoSEQ_10XdnGITc984F_huUg>
    <xme:85QHZOxqThSjpl1CjMu8iBRSHmuHGHG29_gChVXj5Lq9k8Wpbe15uh_6pjXNPx4zb
    KCDI_HKb5ldFqo43g>
X-ME-Received: <xmr:85QHZK3mY0oDbR5TVdTM3qp385Z9X8n2MkHtNUDiHmrVgy3Lt8F2m6KnVn0kl1Evf8Udg7YOA0hLCgdbM-9yDm3No-ReNKYao1dGTIE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddutddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdejtddmnecujfgurhepfffhvfevuffkfhggtggugfgjsehtkeer
    tddttdejnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhesugiguhhuuhdrgiihii
    eqnecuggftrfgrthhtvghrnheptdeugfelvdelffegleduleffudfhgfdvfeduiefhgfdu
    uddukeeggfelheeiueffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:85QHZNARKGAj8iiGyDSChYDz4pNoZUa2jPqDOJIoVPKreATWVPsVwg>
    <xmx:85QHZOg5FPk7jYZyAxiff0TOGTQPbwO_-qWx2V81HkX6Pi8mbVEbRQ>
    <xmx:85QHZBq0aUwBOYjL27j5-BwC6TFXC1hP_YwMPmUShIPZoUc19UFXXQ>
    <xmx:9JQHZHXUPUmaAijkzlMvw47fCAdPWmNxUS6G0FxEywTIOROshz2zZQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Mar 2023 14:48:02 -0500 (EST)
Date:   Tue, 7 Mar 2023 12:48:01 -0700
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets
 in BPF
Message-ID: <20230307194801.mopwvidrkrybm7h5@kashmir.localdomain>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain>
 <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
 <20230228231716.a5uwc4tdo3kjlkg7@aviatrix-fedora.tail1b9c7.ts.net>
 <CAADnVQKK+a_0effQW5qBSq1AXoQOJg5-79q3d1NWJ2Vv8SHvOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKK+a_0effQW5qBSq1AXoQOJg5-79q3d1NWJ2Vv8SHvOw@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

(cc netfilter maintainers)

On Mon, Mar 06, 2023 at 08:17:20PM -0800, Alexei Starovoitov wrote:
> On Tue, Feb 28, 2023 at 3:17 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > > Have you considered to skb redirect to another netdev that does ip defrag?
> > > Like macvlan does it under some conditions. This can be generalized.
> >
> > I had not considered that yet. Are you suggesting adding a new
> > passthrough netdev thing that'll defrags? I looked at the macvlan driver
> > and it looks like it defrags to handle some multicast corner case.
> 
> Something like that. A netdev that bpf prog can redirect too.
> It will consume ip frags and eventually will produce reassembled skb.
> 
> The kernel ip_defrag logic has timeouts, counters, rhashtable
> with thresholds, etc. All of them are per netns.
> Just another ip_defrag_user will still share rhashtable
> with its limits. The kernel can even do icmp_send().
> ip_defrag is not a kfunc. It's a big block with plenty of kernel
> wide side effects.
> I really don't think we can alloc_skb, copy_skb, and ip_defrag it.
> It messes with the stack too much.
> It's also not clear to me when skb is reassembled and how bpf sees it.
> "redirect into reassembling netdev" and attaching bpf prog to consume
> that skb is much cleaner imo.
> May be there are other ways to use ip_defrag, but certainly not like
> synchronous api helper.

I was giving the virtual netdev idea some thought this morning and I
thought I'd give the netfilter approach a deeper look.

From my reading (I'll run some tests later) it looks like netfilter
will defrag all ipv4/ipv6 packets in any netns with conntrack enabled.
It appears to do so in NF_INET_PRE_ROUTING.

Unfortunately that does run after tc hooks. But fortunately with the
new BPF netfilter hooks I think we can make defrag work outside of BPF
kfuncs like you want. And the NF_IP_FORWARD hook works well for my
router use case.

One thing we would need though are (probably kfunc) wrappers around
nf_defrag_ipv4_enable() and nf_defrag_ipv6_enable() to ensure BPF progs
are not transitively depending on defrag support from other netfilter
modules.

The exact mechanism would probably need some thinking, as the above
functions kinda rely on module_init() and module_exit() semantics. We
cannot make the prog bump the refcnt every time it runs -- it would
overflow.  And it would be nice to automatically free the refcnt when
prog is unloaded. 

Once the netfilter prog type series lands I can get that discussion
started. Unless Daniel feels strongly that we should continue with
the approach in this patchset, I am leaning towards dropping in favor
of netfilter approach.

Thanks,
Daniel
