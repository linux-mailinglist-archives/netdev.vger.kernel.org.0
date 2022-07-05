Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167ED567697
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiGESe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiGESez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B781B788
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 11:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79DC7B818D4
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 18:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D15C385A9
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657046091;
        bh=6Q6L7ItvRpcjFL8OKolK1uJc+Q7Yy1msl+1o6EkRB/8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mktxa6x986AkFC5I8f5PhofPbCHGkpgol52ImALmNNGYZqrRiDT4+Dk++pSjhtX11
         dJFVLFkkNSS76Ub1X14ZvCN7j5YlCxo4AEHf3WeVZo/FOJpDOiJP50EUXNDpYv70KS
         mEHoma4CI4WFlRS1xXbWLWLgh1UKJO8SGKkX/rFYsb66BuMmCW7DFifhhZWcSb2Cjn
         4VqxBDw44B3XqlDVorPkenPW55R1Xe2pkZ3Ys3gxVv3dl8u4vs3kdI0w9++gzyxFE5
         JLm8ogFyFTDcO+PzS6EiX5gRhfK5XcfL8BICHIqnKIzzltyJ9MRXRh2ytkcqImiB4g
         2ORoqyww/qDXA==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-31c89111f23so67616107b3.0
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 11:34:51 -0700 (PDT)
X-Gm-Message-State: AJIora8c9Zzzya9Q8IOGUDpRmQjxi6qlngvmWUTgYAFb7vyhFLj1y08o
        n/QGmeiJ4FcYDnF5ofiTQ0c5Mk7G6xTq30B4W02+pQ==
X-Google-Smtp-Source: AGRyM1smTdgkTIMoo8AgGK7QmKUaOKBEwIlG7ss1lMXSwBklEboyMmlSfQ0DqJyXk9F7WTuJiJpXJ4rynBZA5kZqd8I=
X-Received: by 2002:a81:3d1:0:b0:31c:9b70:ba8a with SMTP id
 200-20020a8103d1000000b0031c9b70ba8amr12627600ywd.204.1657046090114; Tue, 05
 Jul 2022 11:34:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220625161255.547944-1-xukuohai@huawei.com> <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
 <20220705160045.GA1240@willie-the-truck>
In-Reply-To: <20220705160045.GA1240@willie-the-truck>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 5 Jul 2022 20:34:39 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4e6qrB+HV7Nj=S-zCsPZjcxwMFCBMSnrYbdkLaD04Hqg@mail.gmail.com>
Message-ID: <CACYkzJ4e6qrB+HV7Nj=S-zCsPZjcxwMFCBMSnrYbdkLaD04Hqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
To:     Will Deacon <will@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        jean-philippe.brucker@arm.com, Xu Kuohai <xukuohai@huawei.com>,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 5, 2022 at 6:00 PM Will Deacon <will@kernel.org> wrote:
>
> Hi Daniel,
>
> On Thu, Jun 30, 2022 at 11:12:54PM +0200, Daniel Borkmann wrote:
> > On 6/25/22 6:12 PM, Xu Kuohai wrote:
> > > This patchset introduces bpf trampoline on arm64. A bpf trampoline converts
> > > native calling convention to bpf calling convention and is used to implement
> > > various bpf features, such as fentry, fexit, fmod_ret and struct_ops.
> > >
> > > The trampoline introduced does essentially the same thing as the bpf
> > > trampoline does on x86.
> > >
> > > Tested on raspberry pi 4b and qemu:
> > >
> > >   #18 /1     bpf_tcp_ca/dctcp:OK
> > >   #18 /2     bpf_tcp_ca/cubic:OK
> > >   #18 /3     bpf_tcp_ca/invalid_license:OK
> > >   #18 /4     bpf_tcp_ca/dctcp_fallback:OK
> > >   #18 /5     bpf_tcp_ca/rel_setsockopt:OK
> > >   #18        bpf_tcp_ca:OK
> > >   #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
> > >   #51 /2     dummy_st_ops/dummy_init_ret_value:OK
> > >   #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
> > >   #51 /4     dummy_st_ops/dummy_multiple_args:OK
> > >   #51        dummy_st_ops:OK
> > >   #57 /1     fexit_bpf2bpf/target_no_callees:OK
> > >   #57 /2     fexit_bpf2bpf/target_yes_callees:OK
> > >   #57 /3     fexit_bpf2bpf/func_replace:OK
> > >   #57 /4     fexit_bpf2bpf/func_replace_verify:OK
> > >   #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
> > >   #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
> > >   #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
> > >   #57 /8     fexit_bpf2bpf/func_replace_multi:OK
> > >   #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
> > >   #57        fexit_bpf2bpf:OK
> > >   #237       xdp_bpf2bpf:OK
> > >
> > > v6:
> > > - Since Mark is refactoring arm64 ftrace to support long jump and reduce the
> > >    ftrace trampoline overhead, it's not clear how we'll attach bpf trampoline
> > >    to regular kernel functions, so remove ftrace related patches for now.
> > > - Add long jump support for attaching bpf trampoline to bpf prog, since bpf
> > >    trampoline and bpf prog are allocated via vmalloc, there is chance the
> > >    distance exceeds the max branch range.
> > > - Collect ACK/Review-by, not sure if the ACK and Review-bys for bpf_arch_text_poke()
> > >    should be kept, since the changes to it is not trivial

+1 I need to give it another pass.

> > > - Update some commit messages and comments
> >
> > Given you've been taking a look and had objections in v5, would be great if you
> > can find some cycles for this v6.
>
> Mark's out at the moment, so I wouldn't hold this series up pending his ack.
> However, I agree that it would be good if _somebody_ from the Arm side can
> give it the once over, so I've added Jean-Philippe to cc in case he has time

Makes sense,  Jean-Philippe had worked on BPF trampolines for ARM.

> for a quick review. KP said he would also have a look, as he is interested

Thank you so much Will, I will give this another pass before the end
of the week.

> in this series landing.
>
> Failing that, I'll try to look this week, but I'm off next week and I don't
> want this to miss the merge window on my account.

Thanks for being considerate. Much appreciated.

- KP

>
> Cheers,
>
> Will
