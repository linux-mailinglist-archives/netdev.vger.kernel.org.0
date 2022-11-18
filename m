Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E71562F20B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbiKRKBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiKRKBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:01:15 -0500
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C3D253;
        Fri, 18 Nov 2022 02:01:14 -0800 (PST)
Received: by mail-qv1-f48.google.com with SMTP id s18so1422875qvo.9;
        Fri, 18 Nov 2022 02:01:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFI3H26vo2cZg8aWYAjdqaK8P08XjL77KUv5MuUYzpk=;
        b=F9Hv0aMfrabW8Xlh77qVh+yYq6Kex38dclDDsRrDphriedVImZBS3WjeIp2ABdNxKm
         luxV5vRNS97z5K2CRWhfF0iq+iMxZhI4XV5W82cfqK2Xo9Yxc230titM4UBHRl8SZWnK
         ID515gKx3citymFgIas1i2/u/agbk7qVzguGCJUIdf31H5sLRQ2IsYf0HLi0ntR4QNBk
         vHBrjoN3vIwV8mmpFM0xxoaHrerNm47BMf0wJuHE3rhm6+PHBje/fPMOwn9IpwofQ18y
         9vAVJg+Qi91bRQY4oNd351R7sBZjS4UDWZdvMfq0M1gfMdb59CmBPf0mjlrM1vGkjEmP
         V0MA==
X-Gm-Message-State: ANoB5pkOy790VEOUetkiemLckFARCCJszGlS5X2V/6S3YEmRurEfremT
        K/vTh9KQp6ptpwQp9rk+SI/Iux6glwJNqg==
X-Google-Smtp-Source: AA0mqf466BQgKrgKGjb6a+KY19VAfAYaQzemvmCuJXhuIGLFP/WP1Kg378VHKF2wKgxnEmITvfWPzA==
X-Received: by 2002:a05:6214:acc:b0:4bc:49c:992b with SMTP id g12-20020a0562140acc00b004bc049c992bmr5858945qvi.61.1668765673413;
        Fri, 18 Nov 2022 02:01:13 -0800 (PST)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id cp9-20020a05622a420900b003a527d29a41sm1747279qtb.75.2022.11.18.02.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 02:01:12 -0800 (PST)
Received: by mail-yb1-f178.google.com with SMTP id 7so5042421ybp.13;
        Fri, 18 Nov 2022 02:01:12 -0800 (PST)
X-Received: by 2002:a5b:24b:0:b0:6ca:3b11:8d76 with SMTP id
 g11-20020a5b024b000000b006ca3b118d76mr5843448ybp.202.1668765672134; Fri, 18
 Nov 2022 02:01:12 -0800 (PST)
MIME-Version: 1.0
References: <20221118063240.52164-1-yuehaibing@huawei.com>
In-Reply-To: <20221118063240.52164-1-yuehaibing@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Nov 2022 11:01:01 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXbpi_1fw-vUnuFBGS91iq4P1EB2mLg_2UMDJnNRYCr7Q@mail.gmail.com>
Message-ID: <CAMuHMdXbpi_1fw-vUnuFBGS91iq4P1EB2mLg_2UMDJnNRYCr7Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: renesas: rswitch: Fix signedness
 bug in rswitch_etha_wait_link_verification()
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        yoshihiro.shimoda.uh@renesas.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yue,

On Fri, Nov 18, 2022 at 7:36 AM YueHaibing <yuehaibing@huawei.com> wrote:
> rswitch_reg_wait() may return negative value, which converts to true later.
> However rswitch_etha_hw_init() only check it less than zero.
>
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks for your patch!

A similar patch was already applied as
https://git.kernel.org/netdev/net-next/c/b4b221bd79a1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
