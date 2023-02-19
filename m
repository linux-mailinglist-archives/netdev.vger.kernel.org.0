Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D328369C2B9
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 22:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjBSVdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 16:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjBSVdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 16:33:14 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8A4BB97
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 13:33:11 -0800 (PST)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 45FC93F582
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 21:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676842390;
        bh=8R8frgxkiDD95gIO0fe6fOdEBdEu/5r0X1kDOciAmuU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ON/mdzt8yHRRSijWHQWcmxSfQaok9cKnC2sKpZ9bsBzJkOxD1p9mNvd8ubIMDIGXN
         5vMpR4rmeh4fbND9FCnj/llk6Vekf/Py6CdQsEJZk+5L5y1O8FTdWp578E0zkgWAqS
         nLB9dY0a1T8cysPiZhkLfmGOoINo/89DkHojuEP06cVYfyAhrwO1IhGY8j5dxjvFBk
         dMPZWn2srHsvqxXZ+uIIuXXmqrlEI1xxtfUP9LUyFxGVzZIETitPC87/SrnAQgG2AT
         2fFNPfC3BYuVOrc3PFDXmKLiZeBUBrViWeTY0uktaiwDVBm2LPOS9KLzP9IJgBeKhh
         Lm7x4jXLogx6Q==
Received: by mail-lj1-f200.google.com with SMTP id o4-20020a2ebd84000000b00279958f353fso379048ljq.1
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 13:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8R8frgxkiDD95gIO0fe6fOdEBdEu/5r0X1kDOciAmuU=;
        b=RR9spBzXekCuGY73WT/deXZQqstuOy+jOJUdwRDsMa5btelkTqw3uAMbLynNJAvZ8o
         1+T8yeUWFfaByXBYIWyMsBKJK06jtwLdF2LNQC0WqKBsGRBeHTN5bcb1iKJdAKN5Hxkj
         hn3/OksxmWZJ1bvakdjU4MPTJ7K1lBP1LWngU2cGLclabILVwDXUJsgn+8t0kRLmr3lj
         B/jkiZPu2Y17OZEXgXuRBed5z50XL8TLkiBQbnK71tum9D2tw9Xly+5WJ70w4j0iwVNE
         GLvcZIVrR9MIN5di1+aOarCPMRpiEdI52gGhy8pYQR2UOzwgtQQFDzrpkbWqk3wmfmUj
         hWvQ==
X-Gm-Message-State: AO0yUKWONXbjDGMmG/Cl+Y1QJ/tzbbBJOMFRzS24G6kJrSegFkoHh9pr
        Ap/Uki5iYHE1qIexJhgoZ0kHzESMQQ/S7bDLvNM7XEn07CZ6F3uzky8geGcxEDcAWvzi9h/43SF
        EOLT3x2UBDsCH033vkb9el+5yxNAZRemZ8/NNUYeL+3fYx68wBQ==
X-Received: by 2002:ac2:43dc:0:b0:4db:1aa4:fe08 with SMTP id u28-20020ac243dc000000b004db1aa4fe08mr25252lfl.1.1676842389564;
        Sun, 19 Feb 2023 13:33:09 -0800 (PST)
X-Google-Smtp-Source: AK7set/jqCxE7vysa+nLkM379Amt8o48UAX1vdCWM3PBOuY188t0gNT9otYGX3LH6uHIPrqc4/KhbzdCFeHafmAK5zQ=
X-Received: by 2002:ac2:43dc:0:b0:4db:1aa4:fe08 with SMTP id
 u28-20020ac243dc000000b004db1aa4fe08mr25246lfl.1.1676842389272; Sun, 19 Feb
 2023 13:33:09 -0800 (PST)
MIME-Version: 1.0
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-5-cristian.ciocaltea@collabora.com> <Y+567t+kDjZI+fbo@spud>
In-Reply-To: <Y+567t+kDjZI+fbo@spud>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Sun, 19 Feb 2023 22:32:52 +0100
Message-ID: <CAJM55Z_poY3dVu9fQ1W1VQw3V=8VdVKc1+qUcdHduM1aAveJUQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] soc: sifive: ccache: Add non-coherent DMA handling
To:     Conor Dooley <conor@kernel.org>
Cc:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        daire.mcnamara@microchip.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Feb 2023 at 19:51, Conor Dooley <conor@kernel.org> wrote:
>
> Emil,
>
> +CC Daire
>
> On Sat, Feb 11, 2023 at 05:18:13AM +0200, Cristian Ciocaltea wrote:
> > From: Emil Renner Berthing <kernel@esmil.dk>
> >
> > Add functions to flush the caches and handle non-coherent DMA.
> >
> > Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> > [replace <asm/cacheflush.h> with <linux/cacheflush.h>]
> > Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> > ---
>
> > +void *sifive_ccache_set_uncached(void *addr, size_t size)
> > +{
> > +     phys_addr_t phys_addr = __pa(addr) + uncached_offset;
> > +     void *mem_base;
> > +
> > +     mem_base = memremap(phys_addr, size, MEMREMAP_WT);
> > +     if (!mem_base) {
> > +             pr_err("%s memremap failed for addr %p\n", __func__, addr);
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> > +     return mem_base;
> > +}
>
> The rest of this I either get b/c we did it, or will become moot so I
> amn't worried about it, but can you please explain this, in particular
> the memremap that you're doing here?

No, I can't really. As we talked about it's also based on a prototype
by Atish. I'm sure you know that the general idea is that we want to
return a pointer that accesses the same physical memory, but through
the uncached alias. I can't tell you exactly why it's done this way
though, sorry.

/Emil

> Cheers,
> Conor.
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
