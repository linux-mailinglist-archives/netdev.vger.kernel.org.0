Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB99456B462
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 10:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbiGHIYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 04:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237421AbiGHIYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 04:24:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38D98149A
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:24:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk26so14434330wrb.11
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 01:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mIwFg075RvwVYz9+/Y+xL9IEwu5sJHlYJ/YyVZSg0lY=;
        b=Hb9QsIsy3zrdkNF7D7KWN7V9xWmBnlnqukEu8VQO760EvPnCTgR7YaaANXCVvHFhG8
         azGVU8v/yUeYegEIgmmaKflxUqaohJdfHBD0rtW/STrfWOLiHNQTL2u3xQe8ziPn37Tp
         KperCCH8+Rsgixu8wrN/mbJVA3rhSsKGl2aOlADbg6XXnewNcscnnFvz+pqLe4iqnJHA
         zq3s15m3tNnJHcbuScXgMIPMUNpfZjSdtaTKbGQrtAGToOwTcSyiz9akBnE8KKn7Cahy
         sS9hB+7l1qMZEn7F61+CTCeYnNdL/RgeTOMXypf4x/Gnu8ySOpRtLqY0aWNZCHpwATqH
         tn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mIwFg075RvwVYz9+/Y+xL9IEwu5sJHlYJ/YyVZSg0lY=;
        b=Qr1xuSLyz+a/z24TsRF64zQ4omPoiitNPJuVm0lGniP6NUYE8Kywaur1z5zyeA/YCA
         T4XJSwKIQRB8nDl44VBaT2eC5gsS996jOLGf8jzohmhpGd7MWV9jW1SmPsxmnruD07ZP
         nIIpeKREQq0FWkgW6aY5KNoZEMKyhbJddQMi0IlXt2XHv1Drq6cmYLEwKd2/g8mP18yT
         C4qIyMkpaxRMe3yuuPFfT6HoGjBQ5jomUGXIxqnE91n7LTUDbqWw4hHBp8bYvLHzXJgc
         dhwwtNcwyr6/7D49W8XkxzVOx5dGKrCx7LaT/xPFLeWdctnGeK0MTBTgsovfF1uZQxsq
         f/iw==
X-Gm-Message-State: AJIora+Qh7a/OYjGz2Ha+rMHYYMXPvQ84DADb8GIlbVobcSXQuLLHcB2
        CcWI7cwrU0tcZRNnqxn/xPsCwQ==
X-Google-Smtp-Source: AGRyM1viKjtVrmUoxTanFr1pV6d7LMrE7leuT0XIliXYQcDoe0Ro78y5UhOmXgHGos2nagi880AGAA==
X-Received: by 2002:a5d:588d:0:b0:21d:865c:54e9 with SMTP id n13-20020a5d588d000000b0021d865c54e9mr2109574wrf.3.1657268687247;
        Fri, 08 Jul 2022 01:24:47 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id h15-20020a1ccc0f000000b0039749b01ea7sm1670902wmb.32.2022.07.08.01.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 01:24:46 -0700 (PDT)
Date:   Fri, 8 Jul 2022 09:24:22 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: Re: [PATCH bpf-next v6 4/4] bpf, arm64: bpf trampoline for arm64
Message-ID: <YsfptiexC0wFABFL@myrica>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <20220625161255.547944-5-xukuohai@huawei.com>
 <YscL4t1pYHYApIiK@larix>
 <a24109d5-b79a-99de-0fd5-66b0ec34e5ed@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24109d5-b79a-99de-0fd5-66b0ec34e5ed@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 12:35:33PM +0800, Xu Kuohai wrote:
> >> +
> >> +	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
> >> +	if (!p->jited)
> >> +		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
> >> +
> >> +	emit_call((const u64)p->bpf_func, ctx);
> >> +
> >> +	/* store return value */
> >> +	if (save_ret)
> >> +		emit(A64_STR64I(r0, A64_SP, retval_off), ctx);
> > 
> > Here too I think it should be x0. I'm guessing r0 may work for jitted
> > functions but not interpreted ones
> > 
> 
> Yes, r0 is only correct for jitted code, will fix it to:
> 
> if (save_ret)
>         emit(A64_STR64I(p->jited ? r0 : A64_R(0), A64_SP, retval_off),
>              ctx);

I don't think we need this test because x0 should be correct in all cases.
x7 happens to equal x0 when jitted due to the way build_epilogue() builds
the function at the moment, but we shouldn't rely on that.


> >> +	if (flags & BPF_TRAMP_F_CALL_ORIG) {
> >> +		restore_args(ctx, args_off, nargs);
> >> +		/* call original func */
> >> +		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
> >> +		emit(A64_BLR(A64_R(10)), ctx);
> > 
> > I don't think we can do this when BTI is enabled because we're not jumping
> > to a BTI instruction. We could introduce one in a patched BPF function
> > (there currently is one if CONFIG_ARM64_PTR_AUTH_KERNEL), but probably not
> > in a kernel function.
> > 
> > We could fo like FUNCTION_GRAPH_TRACER does and return to the patched
> > function after modifying its LR. Not sure whether that works with pointer
> > auth though.
> > 
> 
> Yes, the blr instruction should be replaced with ret instruction, thanks!
> 
> The layout for bpf prog and regular kernel function is as follows, with
> bti always coming first and paciasp immediately after patchsite, so the
> ret instruction should work in all cases.
> 
> bpf prog or kernel function:
>         bti c // if BTI
>         mov x9, lr
>         bl <trampoline>    ------> trampoline:
>                                            ...
>                                            mov lr, <return_entry>
>                                            mov x10, <ORIG_CALL_entry>
> ORIG_CALL_entry:           <-------        ret x10
>                                    return_entry:
>                                            ...
>         paciasp // if PA
>         ...

Actually I just noticed that CONFIG_ARM64_BTI_KERNEL depends on
CONFIG_ARM64_PTR_AUTH_KERNEL, so we should be able to rely on there always
being a PACIASP at ORIG_CALL_entry, and since it's a landing pad for BLR
we don't need to make this a RET

 92e2294d870b ("arm64: bti: Support building kernel C code using BTI")

Thanks,
Jean

