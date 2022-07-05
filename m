Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE25673B8
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiGEQBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiGEQA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4D11839A;
        Tue,  5 Jul 2022 09:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC96761B68;
        Tue,  5 Jul 2022 16:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776F6C341C7;
        Tue,  5 Jul 2022 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657036856;
        bh=YNoy2tz1hW0bUHeiRLsEX677IMFG+Q+xyAdLl28Mtqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UGU6JIiEjRMRtof4/IjlS1ygWl+HXu2eAqiQGE7kkekGmdUD6sJWgbpch74gE4T7u
         zqBWuZfI0n2u0AZeapu/OGLKpgAUFTZpyPhtKLHlv+Y4DUUz3dnKWNJlHH4RU59oaw
         9N0+tLrXdbfGGrbuDj5VWj5N+ZzEQKOzvgOc/2MU554TZuVQ8Oom1sMa0zQcfHFQ14
         98aUZQPw/TESnFu1HDny23iWt+fRy82vVXcZOKLac55O9YZH7Zel5DVa1MOPsj97gO
         9VQbpfGYhyo+9WTzKsZsyFlUOBPUMl2xHthsFmRzu1Bhj3wZ3odx5xIVxXrdc0/0Nv
         8kIkbVIZB4EtQ==
Date:   Tue, 5 Jul 2022 17:00:46 +0100
From:   Will Deacon <will@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        jean-philippe.brucker@arm.com
Cc:     Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
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
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
Message-ID: <20220705160045.GA1240@willie-the-truck>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Thu, Jun 30, 2022 at 11:12:54PM +0200, Daniel Borkmann wrote:
> On 6/25/22 6:12 PM, Xu Kuohai wrote:
> > This patchset introduces bpf trampoline on arm64. A bpf trampoline converts
> > native calling convention to bpf calling convention and is used to implement
> > various bpf features, such as fentry, fexit, fmod_ret and struct_ops.
> > 
> > The trampoline introduced does essentially the same thing as the bpf
> > trampoline does on x86.
> > 
> > Tested on raspberry pi 4b and qemu:
> > 
> >   #18 /1     bpf_tcp_ca/dctcp:OK
> >   #18 /2     bpf_tcp_ca/cubic:OK
> >   #18 /3     bpf_tcp_ca/invalid_license:OK
> >   #18 /4     bpf_tcp_ca/dctcp_fallback:OK
> >   #18 /5     bpf_tcp_ca/rel_setsockopt:OK
> >   #18        bpf_tcp_ca:OK
> >   #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
> >   #51 /2     dummy_st_ops/dummy_init_ret_value:OK
> >   #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
> >   #51 /4     dummy_st_ops/dummy_multiple_args:OK
> >   #51        dummy_st_ops:OK
> >   #57 /1     fexit_bpf2bpf/target_no_callees:OK
> >   #57 /2     fexit_bpf2bpf/target_yes_callees:OK
> >   #57 /3     fexit_bpf2bpf/func_replace:OK
> >   #57 /4     fexit_bpf2bpf/func_replace_verify:OK
> >   #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
> >   #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
> >   #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
> >   #57 /8     fexit_bpf2bpf/func_replace_multi:OK
> >   #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
> >   #57        fexit_bpf2bpf:OK
> >   #237       xdp_bpf2bpf:OK
> > 
> > v6:
> > - Since Mark is refactoring arm64 ftrace to support long jump and reduce the
> >    ftrace trampoline overhead, it's not clear how we'll attach bpf trampoline
> >    to regular kernel functions, so remove ftrace related patches for now.
> > - Add long jump support for attaching bpf trampoline to bpf prog, since bpf
> >    trampoline and bpf prog are allocated via vmalloc, there is chance the
> >    distance exceeds the max branch range.
> > - Collect ACK/Review-by, not sure if the ACK and Review-bys for bpf_arch_text_poke()
> >    should be kept, since the changes to it is not trivial
> > - Update some commit messages and comments
> 
> Given you've been taking a look and had objections in v5, would be great if you
> can find some cycles for this v6.

Mark's out at the moment, so I wouldn't hold this series up pending his ack.
However, I agree that it would be good if _somebody_ from the Arm side can
give it the once over, so I've added Jean-Philippe to cc in case he has time
for a quick review. KP said he would also have a look, as he is interested
in this series landing.

Failing that, I'll try to look this week, but I'm off next week and I don't
want this to miss the merge window on my account.

Cheers,

Will
