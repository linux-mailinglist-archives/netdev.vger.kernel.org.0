Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D545643A8
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 05:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiGCDPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 23:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGCDPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 23:15:00 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081749FC9;
        Sat,  2 Jul 2022 20:15:00 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6327A3200911;
        Sat,  2 Jul 2022 23:14:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 02 Jul 2022 23:14:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1656818097; x=1656904497; bh=x4WmoTt24e
        WzRTJZhIalJOXB7pNwqPYQ1FuSYn8+d9A=; b=bAwRgReFe7CbA2xFUNt0WHDFIo
        RD2r3TjrEX/BqQlKWw3DivtRSoQA2n894kRaiFtMIshuV/2oTm33EPDGjKIWEHQu
        OAm1zzpnL+ZmkvrpS6l0eFfcJIBs7jwmmA9hf0EWsDTmnaE7nalElBLMiR9qtHBv
        OhheINrFlHACMKEYxGXyFENJeDjx0Z7zqaLIZTNu4/SlKgDvSfCmGUMPCp2uH4LX
        Bg7XpaCQJYmzFrF4eWJRbophog+WMvJdNZ0y1nk+uioz9xb4pTRhKAMt74luxZYs
        0x/xzsBKT14WPoEoO4HVsU3n/MJ3DcAmevMmSdJysq3f5QgfhO6gbzcoJcDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656818097; x=1656904497; bh=x4WmoTt24eWzRTJZhIalJOXB7pNw
        qPYQ1FuSYn8+d9A=; b=DxxqsIdcYFR6din0XJSoCh4JegE1uD3zK7zuNiewzjEG
        CBnChItw8ZKYJzyK0LpRR2LSPSQhRNscgVFz/3mR5wOxmTXJGbO76OUcbOFx8pjn
        F88mHuJ8xGbHW57t8JPVWC27ShTd2fL6B/IgkupJQDNm7jtWvHTynyWrNSfFEbyu
        a3htzRFQrXaIwXzAMqZfUyztY+k8zYTI58akxaclUagULRZDAWhnb3QSAZj8rASO
        go9nxdStAQANEXD5Hl9W+PrIpEs5v1YqLfKW/zfy+SkkUj5kyROfhqUoIkMED8cg
        4zxDkjcoWDhJLFOmJVcz+PK0btVjchswvHR/jOLWhg==
X-ME-Sender: <xms:sQnBYj1U7VyKEH8tYRBRBPXPfy-ZWdT--hCPkee-4dUJliYkKzV8fg>
    <xme:sQnBYiHI7aAIdfR1rdPfBatwr2pFX7q97LeEYB6UB7MDqJ_VjnnTwjR2etOn1JA8_
    k0OK6aQ6JiGEPRBZg>
X-ME-Received: <xmr:sQnBYj402DpUW6ni_-x4dBT0Gyy-3qZsqrlZG0g9lIpFPiB3XO-CnP25a7FCcmAg_E8awVl5RTbJQW125tLXuEgi39aiicbj8T0-mm-txOwvMvDONq2SMImsKmqx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:sQnBYo1eCX9k6Va6UjE-3_CO98UMBBf-lIZ81Xp09xNsXQ02xoZZZA>
    <xmx:sQnBYmG0Ly529BiMCbeWXizdjCbLPBf4x0q5afculk20bc2VUIy5QQ>
    <xmx:sQnBYp-PsW6LxkD1ewEp9FaFwLVZu0_SDnR8Ep0xlTvK2BIL9fZYcg>
    <xmx:sQnBYh_I1nAT8j_EP8J1ZKzQhiFMVG6hzBKxK0F5NRImC73K1D_HCg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Jul 2022 23:14:57 -0400 (EDT)
Date:   Sat, 2 Jul 2022 20:14:56 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v9 bpf-next 9/9] bpf, x86_64: use
 bpf_jit_binary_pack_alloc
Message-ID: <20220703031456.rsj4ruqmcr34mnsd@alap3.anarazel.de>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-10-song@kernel.org>
 <20220703030210.pmjft7qc2eajzi6c@alap3.anarazel.de>
 <CAADnVQJmHTTri-s7dvFbLCXKZsZXopnVNFCpkmeHPYg2h6LkZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJmHTTri-s7dvFbLCXKZsZXopnVNFCpkmeHPYg2h6LkZg@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-07-02 20:03:56 -0700, Alexei Starovoitov wrote:
> On Sat, Jul 2, 2022 at 8:02 PM Andres Freund <andres@anarazel.de> wrote:
> > On 2022-02-04 10:57:42 -0800, Song Liu wrote:
> > > From: Song Liu <songliubraving@fb.com>
> > >
> > > Use bpf_jit_binary_pack_alloc in x86_64 jit. The jit engine first writes
> > > the program to the rw buffer. When the jit is done, the program is copied
> > > to the final location with bpf_jit_binary_pack_finalize.
> > >
> > > Note that we need to do bpf_tail_call_direct_fixup after finalize.
> > > Therefore, the text_live = false logic in __bpf_arch_text_poke is no
> > > longer needed.
> >
> > I think this broke bpf_jit_enable = 2.
> 
> Good. We need to remove that knob.
> It's been wrong for a long time.

Fine with me - I've never used it before trying to verify I am not breaking
tools/bpf/bpf_jit_disasm...

And yea, it does look like it bpf_jit_dump() was called too early before that
commit as well, just not as consequentially so.

Greetings,

Andres Freund
