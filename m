Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100A4573E7C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiGMVEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237347AbiGMVEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:04:08 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F028240BF
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:04:08 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id t26-20020a9d775a000000b006168f7563daso9251167otl.2
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yX5Yv+ZJvITbUaxdrodvlW3voIlgvLGyakpBIdnpjZg=;
        b=lCtmt3fDv2Q26/kbNcFC4JDvJLqvO94VL09nGVg7yiCMsgEA0v2xHeIOzYOZZCqrvs
         jGN+NVTg0PFFkgh/u3aUP0TCC5Zlrzc1xzk6e9/CCP425Z6bLv1QGG9lu3Mz9WxGkJRP
         9QOdrYWPjQCzH/stCVc7ncDEkaP5J6BhFlYUYY7utj/NJbSnhQI/uFTpYdOmZ/7nmOK3
         0OmilvL7OxHgrXKMDmrIpwffbMCz+oE11MfGXk2Wk2g28a1Draci7r1i+TqGSw8BNq4V
         7Z9yTUbmaEfQkaus4ddcM6K+u1vFyH92zpMfedlCZajjt/nbJ/k20p7r/SOXkKumQ1/d
         0leA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yX5Yv+ZJvITbUaxdrodvlW3voIlgvLGyakpBIdnpjZg=;
        b=SPynfw83Ka59qD0y9F9EPPYkSijx9EjUtb0CkzoVCuDwrMZhixispyXAEzCXEI5Aai
         XV9MnKa0K/Qjhu3/9iGu67dtoC3It4jP6RS/5zLhQsJtFtNc/ZVAb3lkATLyFs9xpPJG
         4P9pl1sEF3j32bACwctOARnPhm7FArh3h17f2nLoEAtXyLR2/iUSK0joqGbrs7ctHc3H
         RVFNUxOR32b63XP6v2p0Lf64Jh1yy6YnS8/eGqkhBdQnqr0neZBIb4ebPpD32GUTAkKq
         GbrFJeIIGJ5xVWL3g/2D8YTIMEFvH2rOctTZ3LyYsvyUmK6hyrv0paAL2TJ2XCOA/v8E
         JZjA==
X-Gm-Message-State: AJIora87g1bdUHDHjStQCz2gW7HcssiHNYKwRSxZygTe/tuKgz4fvRHa
        j8SCyyRziVZou25ReySf+kKUwqTgv5P10Ysswkk=
X-Google-Smtp-Source: AGRyM1sk9kTfVn9A4SC6KLVfQORmbrYIJGRs7wKw60dgSQsKE//t33nTtPGHlj31SymxE2X514qkKOtGGi1TGgy3+7Y=
X-Received: by 2002:a9d:337:0:b0:61c:576b:dc08 with SMTP id
 52-20020a9d0337000000b0061c576bdc08mr2168335otv.170.1657746247384; Wed, 13
 Jul 2022 14:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220713170653.11328-1-moises.veleta@linux.intel.com>
 <CAHNKnsTq+-_sgPsuqG1ohqVVwJfU-Gq_QJ7kQO8gwyLbQHKwiA@mail.gmail.com> <06e9db15-f5a2-c4ca-8750-c1909fdaf0a9@linux.intel.com>
In-Reply-To: <06e9db15-f5a2-c4ca-8750-c1909fdaf0a9@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 14 Jul 2022 00:03:54 +0300
Message-ID: <CAHNKnsQ-WG7_-Z6zxbe193D-kXzN1SbC76r3eQmo5oAhCNqr0w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/1] net: wwan: t7xx: Add AP CLDMA
To:     "moises.veleta" <moises.veleta@linux.intel.com>
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

On Wed, Jul 13, 2022 at 11:53 PM moises.veleta
<moises.veleta@linux.intel.com> wrote:
>
> Hi Sergey
>
> On 7/13/22 13:39, Sergey Ryazanov wrote:
>> Hello Moises,
>>
>> On Wed, Jul 13, 2022 at 8:07 PM Moises Veleta
>> <moises.veleta@linux.intel.com> wrote:
>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>
>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>> communicate with AP and Modem processors respectively. So far only
>>> MD-CLDMA was being used, this patch enables AP-CLDMA.
>> What is the purpose of adding the driver interface to the hardware
>> function without a user counterpart?
>>
> We have follow-on features/submissiona that are dependent on this AP
> control port: PCIe rescan,  FW flashing via devlink, & Coredump log
> collection. They will be submitted for review upon completion by
> different individuals. This foreruns their efforts.

Thanks for the explanation. Is it possible to send these parts as a
single series? If not all at once, then at least AP-CLDMA + FW
flashing or AP-CLDMA + logs collection or some other provider + user
composition. What do you think?

-- 
Sergey
