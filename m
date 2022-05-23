Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919B1530739
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 03:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344741AbiEWBmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 21:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiEWBmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 21:42:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DCC1F60B
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95CDE60F90
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CC1C3411F
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653270125;
        bh=L1rWichVspWPMp1YW4Y6OtO8akQ8Yw1ttG9zNJ5MEfY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e7Jg4x7j6d5762KIShgTeQ9GZsR5hgrxt5neCELacXz4M5Z1gyZ09NbZ6WrMm95Ll
         SOs3FR/CShuAugXTtL85ipFHcZk8v/COxVuvq4UzOcmdC7kXfYdDkqhntPc21EoI3n
         FP+rJa/IvSiPuEAoEZ+OeXv3En0AHqfJMA7ZbprDh4KvHmbX0yDGoR4zb2G5+N+k3T
         Z9c7Pz0oweBX5nf6HcXI3zp4B+gOrXq1Exa4UbsQMxuzbkE8BQPNy4PVycTFA35nQ9
         35WAupqkdKqwAN3dFe0z0L+CGFn8TX8cf6vxRdwZTH2DCJKuDXoAf17kTziaO56dxT
         DiVlOOoGCDKHA==
Received: by mail-lj1-f172.google.com with SMTP id i23so15534114ljb.4
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:42:04 -0700 (PDT)
X-Gm-Message-State: AOAM530Wfjpv0WGaRTXeiZ8B9/wx9yUlmkQUcXiZWD7JL/ym7ZPeZM0Y
        FCOrwkMEwIZt8m/gdUvQKXWH4x+TI2Z6YTcrETyGIA==
X-Google-Smtp-Source: ABdhPJxW/B7l0ZYMbp3xOewxlp/RE5dcd/Q8Gp+bsMNbcyF3sbnRvjECqGoH3Y8c9sdW4EECkINOGJX02UIXbe/qdII=
X-Received: by 2002:a05:651c:10a8:b0:253:c8a7:3afd with SMTP id
 k8-20020a05651c10a800b00253c8a73afdmr11948558ljn.431.1653270122939; Sun, 22
 May 2022 18:42:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220518131638.3401509-1-xukuohai@huawei.com> <20220518131638.3401509-5-xukuohai@huawei.com>
In-Reply-To: <20220518131638.3401509-5-xukuohai@huawei.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 23 May 2022 03:41:52 +0200
X-Gmail-Original-Message-ID: <CACYkzJ7PAcNBHSL87tUPo6Dc+ykG7uEQ_nhCVpWvj-3KqLL-Wg@mail.gmail.com>
Message-ID: <CACYkzJ7PAcNBHSL87tUPo6Dc+ykG7uEQ_nhCVpWvj-3KqLL-Wg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/6] bpf, arm64: Impelment bpf_arch_text_poke()
 for arm64
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 3:54 PM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
> it to replace nop with jump, or replace jump with nop.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

Reviewed-by: KP Singh <kpsingh@kernel.org>
