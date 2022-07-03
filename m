Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3595643A4
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 05:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiGCDEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 23:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGCDEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 23:04:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7D49599;
        Sat,  2 Jul 2022 20:04:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fi2so10879550ejb.9;
        Sat, 02 Jul 2022 20:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ns53/YL8l/fiYmgUBv8sx+DAyGGm9X+r51r4aHComts=;
        b=pT/9bZT4uRO7OLdbAX7dH0qxRUGFlFgvdHE4US05TWYm4623YrTcAmMIyuComRzYAa
         yVoACIqvzhAlynuJAw19xXnxLStR6cJCTiWULPVcdM3PjmsO+RycCviXRI+/BiVqrEA8
         ld41RkLE1N38H62ToFQYR0dilXbDqw3lvq+5DENT4LHK+aQ4o6SWaUeKtpWyA0y4VZll
         xXAFDETn+0Mz56wVuKqHxobi9Qf3X/z5tHRHRJv+cZkYmEmv+hXucEvzJvJlgLk7kGDH
         Cs5/8LrniplaXyF9CMgh2Ft+DG0yTVYMQo6NhEHrQIfyC73pNAsAuSrw02T2yPvEl5ae
         qvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ns53/YL8l/fiYmgUBv8sx+DAyGGm9X+r51r4aHComts=;
        b=Re2o0lyttqhssH+23OqAWhm2NynIeea+gEqFJ45vJ6dwsMltIeg3Ox7nV89DVEyjPm
         lOTzDMTt4hCwE1r+BWenZb4GfArD0MBMjBpapUhWcOw5pFp5O4iSUFxOSn7ncZf6aSQl
         kQutomQ5nah6P/TVPBp/lB7NwdLZwNAxmhohU745d2DQ3xj58HkIx3cDV17tLoxBrQSV
         rMy9mvw2g3Kikm4hgAXpYh2DD3R9J34tjJj8TjOw0iB/50X4RFFcgQqO0LBHlIEs9tyL
         4V0VcEVXBODanKu8roOcpvmUZj4tIbOyDh3ro9ODN2tgSdYyqwjgQuz1RCe7beJTxUvA
         01fw==
X-Gm-Message-State: AJIora8Tcgh23RcicFTnMUPJaC6gaXV2liKqoao4bm3mQTOr58u2bnkk
        x1E93N9xWXG8gb6ZTqxcASf/DF+QjC59jOldu84=
X-Google-Smtp-Source: AGRyM1s3wI54CAtvICl7k6tq3tQ6y30dybpMhB92pm6Yog84sS80A+Zr/ODlr4uI3hXjjYg2FXWd+LhDL6k8zCTHjYM=
X-Received: by 2002:a17:906:9b86:b0:6fe:d37f:b29d with SMTP id
 dd6-20020a1709069b8600b006fed37fb29dmr21797701ejc.327.1656817447578; Sat, 02
 Jul 2022 20:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220204185742.271030-1-song@kernel.org> <20220204185742.271030-10-song@kernel.org>
 <20220703030210.pmjft7qc2eajzi6c@alap3.anarazel.de>
In-Reply-To: <20220703030210.pmjft7qc2eajzi6c@alap3.anarazel.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 2 Jul 2022 20:03:56 -0700
Message-ID: <CAADnVQJmHTTri-s7dvFbLCXKZsZXopnVNFCpkmeHPYg2h6LkZg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 9/9] bpf, x86_64: use bpf_jit_binary_pack_alloc
To:     Andres Freund <andres@anarazel.de>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 2, 2022 at 8:02 PM Andres Freund <andres@anarazel.de> wrote:
>
> Hi,
>
> On 2022-02-04 10:57:42 -0800, Song Liu wrote:
> > From: Song Liu <songliubraving@fb.com>
> >
> > Use bpf_jit_binary_pack_alloc in x86_64 jit. The jit engine first writes
> > the program to the rw buffer. When the jit is done, the program is copied
> > to the final location with bpf_jit_binary_pack_finalize.
> >
> > Note that we need to do bpf_tail_call_direct_fixup after finalize.
> > Therefore, the text_live = false logic in __bpf_arch_text_poke is no
> > longer needed.
>
> I think this broke bpf_jit_enable = 2.

Good. We need to remove that knob.
It's been wrong for a long time.
