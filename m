Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA8C5643A0
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 05:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiGCDCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 23:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGCDCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 23:02:18 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E257658F;
        Sat,  2 Jul 2022 20:02:16 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 08D7C320024A;
        Sat,  2 Jul 2022 23:02:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 02 Jul 2022 23:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1656817332; x=1656903732; bh=7AKJuzsinJ
        qtMyImb2EF1FXvx4qWYBiZUiMMR+YJV5w=; b=MKvjDYTy8LvWquKxl2eb7Jwv0M
        hlEXviOSScMt+MAlo5Sx+TaerCZjQ0HYx3UsY9U7lLDaT5sOjjDfskfYICvcxxGY
        62TlAC1M718uniJNwC4Q/rd/VxDfF3XlyMTGY+LCrqn7ryzoo8gFKcJ5r4Ise5CT
        sETRIjJ0FbfWMixyRHr89m/bJ5pE99T4k0iMM+JEnvHSlbU5L5MXh1khsyIkORpY
        gBIzcdqxUjJ0L62fjh7tMUkcJmzOpxqs3g8X2krkq4i1vc6l3AUSjacobUSEYWoN
        d5da0FAUdRaoddwjFlxXu6jUPggCbZTvrLfExvQ0pdzh2WstkuhaZut5ZB9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656817332; x=1656903732; bh=7AKJuzsinJqtMyImb2EF1FXvx4qW
        YBiZUiMMR+YJV5w=; b=LgqCI7fBBaCKDWxrnPNfy1zNXSEjFxxXS9tqQuOdI+is
        DGkrIurcfzRsRohYbn/yHG7cpO1kLW6NQadFBPmYF6rlkfX6FJJB63yp8gk1KjFa
        7f+sQAxUw9qSXCxlNPNJB7ktqzUNFslOZ7ayn5YuXRW2F2hs5bn7YhfKkudsXxRf
        sTbKbRKChyg3jmQFbHVmcDcsD1zZH1qN4xJUmuhp+DBSs37Az53EPUHJoHJ7Po/h
        kNJa5o+jvq8Nz1Urq647aHHnlsTlNhQyEVKlVQkQ3lVtrmZYyo8+XXrRwN99zDpo
        ZbrbllrqFFOcauw38CJYxrlvt7jgCnizVnE76IKBjQ==
X-ME-Sender: <xms:swbBYjJ0Fw6w6_AAyRQEUSALrHVHuko54OLgr5V1Mq82da4YE-JmBw>
    <xme:swbBYnKBb9QwXxql10xkBht9RIDoly2wk7IUTGQ2AoRrgN-nTOktBnY4bQ8CGrBqR
    CrhBaiVy7HSARWieg>
X-ME-Received: <xmr:swbBYrvhPsrJZFmq_u1O0fHD-ApqEwIAMVQCtrHdSMwvoM3xCuSACX7RT8Fnh-kK-TaEcuCgWPsVMlx2-NiRpSnCm_rvdt43wOvptYFRffhCsQzf526T-T--i0ZZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehiedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:swbBYsaK2yLHO8XqG8L9_3bwQnoTu0n9xhCzpjTyu02o5gXvtXTFAw>
    <xmx:swbBYqa-8_T1-5FuaMmf7mB14H7u8IvDkmB2uEsiR41fEh13F6VG3w>
    <xmx:swbBYgDt_36TZ7coT0OA9hUoqwGVz9JpljrSINHHZ19hMq733Zfr6Q>
    <xmx:tAbBYnRG_0xcwjVqBsDDjPDTBXBjzNyMzdZLGpEnAKMoA-xj-aBjxw>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Jul 2022 23:02:11 -0400 (EDT)
Date:   Sat, 2 Jul 2022 20:02:10 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, peterz@infradead.org,
        x86@kernel.org, iii@linux.ibm.com, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v9 bpf-next 9/9] bpf, x86_64: use
 bpf_jit_binary_pack_alloc
Message-ID: <20220703030210.pmjft7qc2eajzi6c@alap3.anarazel.de>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-10-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204185742.271030-10-song@kernel.org>
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

On 2022-02-04 10:57:42 -0800, Song Liu wrote:
> From: Song Liu <songliubraving@fb.com>
> 
> Use bpf_jit_binary_pack_alloc in x86_64 jit. The jit engine first writes
> the program to the rw buffer. When the jit is done, the program is copied
> to the final location with bpf_jit_binary_pack_finalize.
> 
> Note that we need to do bpf_tail_call_direct_fixup after finalize.
> Therefore, the text_live = false logic in __bpf_arch_text_poke is no
> longer needed.

I think this broke bpf_jit_enable = 2. I just tried to use that, to verify I
didn't break tools/bpf/bpf_jit_disasm, and I just see output like

Jul 02 18:34:40 awork3 kernel: flen=142 proglen=735 pass=5 image=00000000d076e0db from=sshd pid=440127
Jul 02 18:34:40 awork3 kernel: JIT code: 00000000: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
Jul 02 18:34:40 awork3 kernel: JIT code: 00000010: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
Jul 02 18:34:40 awork3 kernel: JIT code: 00000020: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
Jul 02 18:34:40 awork3 kernel: JIT code: 00000030: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
...

while bpftool keeps showing reasonable content. The 'cc' content only started
with a later commit, but I think this is the commit that broke bpf_jit_enable
== 2.

At the time bpf_jit_dump() is called bpf_jit_binary_pack_alloc() pointed image to
ro_header->image, but that's not yet written to, because
bpf_jit_binary_pack_finalize() hasn't been called.

Greetings,

Andres Freund
