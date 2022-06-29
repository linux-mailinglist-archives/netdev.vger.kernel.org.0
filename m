Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03887560A3D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 21:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiF2TYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 15:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiF2TYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 15:24:16 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97C4340ED
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:24:15 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id y10-20020a9d634a000000b006167f7ce0c5so12949615otk.0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSOlrv1rPTeZjGb/Mbo0vBlb0WQ3QZQ/E2flsfQdF0U=;
        b=YlmiP8jeFBSeHj+I6ouuPe7oVJrnRCjq76M92ui2B6YwAB7OcUjxgB8a7RdVIQE7bA
         /K8wuh9kqG9kuhmpIxgmf/Gl1N7WmrUWoSEztcL7awGRiRIGqAJ6pk4K27Il94PviMYj
         Gf5EBv9DGbMb6T5xHwQ7K7ZDW4S9veUOeKOMGhXpj8ezyYwIQQpzmG9bD7qGVD/EyG/J
         l1nXunj+oghUPow1ADV86t4mNRCSKAwb0ePoyA0yTEAbXM7ZSY4h5o71fpLrTlQ+RYU9
         9y05kQpPBda5rBmGC3sdw6gaEsKkRuPpbC0glXy2EINqSxb6TIMv6bC1BDVRHDrAEZpd
         TxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSOlrv1rPTeZjGb/Mbo0vBlb0WQ3QZQ/E2flsfQdF0U=;
        b=3mNO302Nmazwy6WOa1eZMuijmfpdVulXMLnigRyezoHG/CD1pkn7RtFNtxRoZOBPMm
         XzbjgLl25P/jwbecwao0dPwDs/cozVpq2+Jo99Z8PxV9DlwXeNhCWdbBUOAwXC6sjhaz
         hW9n8+jnXqZpETjpnOt0cAg5XqW/fIuQRNpa1USN+YsUoxJtjjWpkLfGNELQVT8dXViA
         71ZVtD7jDtMDtacsGSG43mROPxYWV6zyGJOELp8Qv5y+x3K0V6bEwd2CHYGLgVgL1pRH
         Jq+m5f0iBHX1EQ88WLJrDIqEjfX7c606H7M7cJTx55gj9W/g+AqdGYfDKRkQigA44Rrv
         TUyw==
X-Gm-Message-State: AJIora90+hPv59F185lGs5P9VIztGkq7ThADproUp+Lo833XDjiD3uBZ
        ggNWoPDuy2OkS5cfgQuE5Dt4xVlZD/aeh9MZw8I=
X-Google-Smtp-Source: AGRyM1t4VXnXn8+Loc5ODJnUdTydrfli0STSQdWPpmsCAuf+A10LSMxmSbypmIxm3SS5MvgJQizLNsqzw9uQ73ChQNM=
X-Received: by 2002:a9d:674e:0:b0:614:da04:4b12 with SMTP id
 w14-20020a9d674e000000b00614da044b12mr2197363otm.170.1656530655056; Wed, 29
 Jun 2022 12:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220628165024.25718-1-moises.veleta@linux.intel.com>
In-Reply-To: <20220628165024.25718-1-moises.veleta@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 29 Jun 2022 22:24:04 +0300
Message-ID: <CAHNKnsTUbdhZ9uUJnF535WajPm6k7R2nECaJZrKjFJCUuHmHEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
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

On Tue, Jun 28, 2022 at 7:51 PM Moises Veleta
<moises.veleta@linux.intel.com> wrote:
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> port which requires such channel.
>
> GNSS AT control port allows Modem Manager to control GPS for:
> - Start/Stop GNSS sessions,
> - Configuration commands to support Assisted GNSS positioning
> - Crash & reboot (notifications when resetting device (AP) & host)
> - Settings to Enable/Disable GNSS solution
> - Geofencing

I am still in doubt, should we export the pure GNSS port via the wwan
subsystem. Personally, I like Loic's suggestion to export this port
via the gnss subsystem. This way, the modem interface will be
consistent with the kernel device model. What drawbacks do you see in
this approach?

--
Sergey
