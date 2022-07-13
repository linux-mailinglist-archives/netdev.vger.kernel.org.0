Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91747573DDE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbiGMUj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiGMUj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:39:26 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EE364C1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:39:26 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-f2a4c51c45so15497047fac.9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b3aG3FuBur3Zrd07tpa+4Y4TcALLUezUUHHYwj1nM1w=;
        b=Lm4T1uNkdIhPBP97AnS+9ntR89XUGLiCxsnCHgWe/47AZU6teu/CNkBp4i+XyKyxAR
         ebw4g2pBPObuwVepkEwhwvzAXDc0kQZJEh4UrLqWu1hVosN0NFIQRW92QWgraoHYgzxd
         kU2ytwSpeejgX/M7npXWPCdxsZy7TpgpA6bovA9Ums2NuZ4gS8JhTboD1pCPjuHg/7pA
         Ox8m9YqEOpuDRIQ05XZl7FMXeC1StjtYSnOK8Wxq59c8UVP4INRyBasrd3R3tyCzXbHT
         aDBVImqbzz8sQ8y9uK+siHh9gktN4651DxDKiZAq+LBQngEkzobImAU1aAWL3dFlscyv
         sT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b3aG3FuBur3Zrd07tpa+4Y4TcALLUezUUHHYwj1nM1w=;
        b=xtVcjcYW94ovbujx/YxuhbdCBa57vrLNsofvDFJUYy1GKSw/k2Z3WOVg7zXPZR08OG
         +JNZ1GyS2gVCVolzKLq82scoHU696JQkChcF6G23WlW7/bM811Xl9/NxUDNugZeI1lbj
         gPTh+LfokotXJZgjcgkgh6IVsE1E8dH71LJYe+FcLAdCi9R9zrN5P5PTuwW5pJBqSgdY
         aJzUv0G/cz51ctCEJPO9qcZC05ihVazRRKHaE3NQXr0KjII7zGJhycGREGLvU29/+sC9
         B0vJz0zU7B2Jc4oU0c33wTazGbVJo6nyq2vlAOCUuLNR62mpfJVyQ2XdkJzZ8V6LATDn
         RRyg==
X-Gm-Message-State: AJIora/DcRtksYFUgr9MyQ/kdchN1VohSU9i8ZSQRjbXiLG4E7Cr9QLx
        USSC3leihIQfrJ5zfZbrj+Dx1YKFBoR51vQCeuc=
X-Google-Smtp-Source: AGRyM1s7b4QPy6sRFzKraGqcWDRJPEYdSsc2GOjvew977Y+GHvBRmRnUl2aAlBXK4otHhcaSIMg9mDQlB7iyeP31sQw=
X-Received: by 2002:a05:6870:c093:b0:10c:4f6f:d0ab with SMTP id
 c19-20020a056870c09300b0010c4f6fd0abmr5623232oad.194.1657744765459; Wed, 13
 Jul 2022 13:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220713170653.11328-1-moises.veleta@linux.intel.com>
In-Reply-To: <20220713170653.11328-1-moises.veleta@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 13 Jul 2022 23:39:12 +0300
Message-ID: <CAHNKnsTq+-_sgPsuqG1ohqVVwJfU-Gq_QJ7kQO8gwyLbQHKwiA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/1] net: wwan: t7xx: Add AP CLDMA
To:     Moises Veleta <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        ram.mohan.reddy.boggala@intel.com,
        "Veleta, Moises" <moises.veleta@intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
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

Hello Moises,

On Wed, Jul 13, 2022 at 8:07 PM Moises Veleta
<moises.veleta@linux.intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA.

What is the purpose of adding the driver interface to the hardware
function without a user counterpart?

-- 
Sergey
