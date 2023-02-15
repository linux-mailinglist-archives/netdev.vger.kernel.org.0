Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63B8697A90
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 12:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjBOLVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 06:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjBOLVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 06:21:23 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D3235268
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:21:21 -0800 (PST)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 389E53F719
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676460077;
        bh=hwzNkkVHAMig3SgTdNBISffkqWyB+YZfYs1moUFjJBQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=A+IZ+CWRwgyejGne7EI3/hIFUYzJnGJjgGeZJ9ut6aoRpODPYfE9TeYN/Z9v84yMa
         ekKvc2YKG58K1qoA5dJbWCO/qk8O2s52Wesldwfd/SDMQXgdsaOgV3CTo04/Cx6aQ2
         ubDImuiPnqdIcDseDrs8tNUABxahqPqVJfkjEX+u1AAIuB+fpKFpH3q7CufXWYZpZ7
         6b/yvxDZevEhJmpbMhV/y2BhJ6l/f/hyEmWwRQ8I/s8/TXjxqIsM8y10y1zek1vS76
         BiFU1K4tv0OL6HVCRBbvx7xWwAZ1eUqAmITLWLN1IRotyoXvTDfiJdNhW3zLB/Y9Yu
         lHYamaQpw+81Q==
Received: by mail-qk1-f199.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso11307212qko.11
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:21:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwzNkkVHAMig3SgTdNBISffkqWyB+YZfYs1moUFjJBQ=;
        b=ryNLUv1HaYCT7fEtIbOo73wZW7cVNFAmlWrc32Fb9Gf7QA7NPiw8M8snbfwKUEU6jd
         WEmigfqrV5ii+RswbpJiJgJN/+vk+7h5OqLkaZEHKHLE9Amo6/oJr6Mtt2TVa++XN1Ed
         AqmZo2DrEZvxC02lKTZnLRSPW9+dwZEPK4XE9gbJYLYZ8ootM2R8yPSBL1OyLBHujGcK
         BClAqTQZ+kD5ycKDQLuLVJ1ui/XcyKfroWalVxPK16N5qUB3nnLzLpG09lBM94irKtwn
         bJnFMY/9pwLuquncFUSLLQx+Ze0WjB4wUAkk2JJGhRyUNkbqEXkp2q8Z2yxV464pQ1q8
         Op5A==
X-Gm-Message-State: AO0yUKXCY0JSeC+rY/i5yd4FY8k6zoyy3F7O3l8FkGxfHD7MJix+fjfm
        CjEzdbtLR8rpo2hlN1KJp02vz32r9OTzk1BT4J+11pkKURR/5VXKyhuD/CPfK/vS6tOtROmAfXB
        deQ1cOIfQksQVpPA8H4v/e35aK86rI4UR1Ipyc6SHBiMTlXWYDQ==
X-Received: by 2002:a05:622a:164f:b0:3bc:e3a8:d1d6 with SMTP id y15-20020a05622a164f00b003bce3a8d1d6mr195946qtj.229.1676460075471;
        Wed, 15 Feb 2023 03:21:15 -0800 (PST)
X-Google-Smtp-Source: AK7set9/NeWH75yJcn/t46NzwvdAG3kpXtrEWKot0xC2tKbCmHsBGrLAxxXzoc7xjxLRcnJ3CgUfTfDnKiYp8juZgUM=
X-Received: by 2002:a05:622a:164f:b0:3bc:e3a8:d1d6 with SMTP id
 y15-20020a05622a164f00b003bce3a8d1d6mr195937qtj.229.1676460075213; Wed, 15
 Feb 2023 03:21:15 -0800 (PST)
MIME-Version: 1.0
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
 <Y+e+N/aiqCctIp6e@lunn.ch> <d1769dac-9e80-2f0d-6a5c-386ef70e1547@collabora.com>
In-Reply-To: <d1769dac-9e80-2f0d-6a5c-386ef70e1547@collabora.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Wed, 15 Feb 2023 12:20:58 +0100
Message-ID: <CAJM55Z8Uq2ZU3KvJZKDLZUJDLEyvHjCRJKcYn5CAOR0c2rhT7Q@mail.gmail.com>
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
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
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023 at 01:09, Cristian Ciocaltea
<cristian.ciocaltea@collabora.com> wrote:
>
> On 2/11/23 18:11, Andrew Lunn wrote:
> >> +
> >> +#define JH7100_SYSMAIN_REGISTER28 0x70
> >> +/* The value below is not a typo, just really bad naming by StarFive =
=C2=AF\_(=E3=83=84)_/=C2=AF */
> >> +#define JH7100_SYSMAIN_REGISTER49 0xc8
> >
> > Seems like the comment should be one line earlier?

Well yes, the very generic register names are also bad, but this
comment refers to the fact that it kind of makes sense that register
28 has the offset
  28 * 4 bytes pr. register =3D 0x70
..but then register 49 is oddly out of place at offset 0xc8 instead of
  49 * 4 bytes pr. register =3D 0xc4

> > There is value in basing the names on the datasheet, but you could
> > append something meaningful on the end:
> >
> > #define JH7100_SYSMAIN_REGISTER49_DLYCHAIN 0xc8
>
> Unfortunately the JH7100 datasheet I have access to doesn't provide any
> information regarding the SYSCTRL-MAINSYS related registers. Maybe Emil
> could provide some details here?

This is reverse engineered from the auto generated headers in their u-boot:
https://github.com/starfive-tech/u-boot/blob/JH7100_VisionFive_devel/arch/r=
iscv/include/asm/arch-jh7100/syscon_sysmain_ctrl_macro.h

Christian, I'm happy that you're working on this, but mess like this
and waiting for the non-coherent dma to be sorted is why I didn't send
it upstream yet.

> >> +    if (!of_property_read_u32(np, "starfive,gtxclk-dlychain", &gtxclk=
_dlychain)) {
> >> +            ret =3D regmap_write(sysmain, JH7100_SYSMAIN_REGISTER49, =
gtxclk_dlychain);
> >> +            if (ret)
> >> +                    return dev_err_probe(dev, ret, "error selecting g=
txclk delay chain\n");
> >> +    }
> >
> > You should probably document that if starfive,gtxclk-dlychain is not
> > found in the DT blob, the value for the delay chain is undefined.  It
> > would actually be better to define it, set it to 0 for example. That
> > way, you know you don't have any dependency on the bootloader for
> > example.
>
> Sure, I will set it to 0.
>
> >
> >       Andrew
>
> Thanks for reviewing,
> Cristian
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
