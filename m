Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C6529C9A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243385AbiEQIfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243343AbiEQIff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:35:35 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC7B43AC8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:35:34 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id i186so17972421vsc.9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vO8gifHuloe7lJGXEtrCYpKhGsvH63IsqaMqGEsfSis=;
        b=iUzsNHhmBC8tGwlMq8gfD5j17Ig1xyn+Re4eT+zV0BksBMSkBTAHvC/Lkjxp2Tlr4j
         t0rWXtmz1orCuyC2N4QsNvci3tgGOhDh59jqPF/xU4ey53XHXtRx9sMUfzHHS18xGjhO
         iQhj3Sq39XoL59T5ZW0pzrpx0MBS07GCPwxwzQ3awTl/3p/cjPyQ+TfAIwdvI5vAN+xf
         A66ZO4g+hY7WihpuV9LUogZh5Zcz3g8RM2iv4HeOMbG2RlZFZ9kqbvnd6gmUdpGMxSnX
         DftYQLPmIyDBxDvAKT69iUV4skqWFGYsTmunUgSC8KFeQlPUKomkPNLrB4+/095IYH+U
         xTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vO8gifHuloe7lJGXEtrCYpKhGsvH63IsqaMqGEsfSis=;
        b=sClrb12rcIMBGBkVupK89xaeD+BOrP7+sd+/XK4OtTv5iKUUjxg/3r7LdIBislM2OE
         +yaX/7XbQygqEbxtwzdt/fdmBPrxYRjqxhAqQ6za7a2sfpf3qXl6Ykf6RRfVfgerYDwf
         PtP6yR14eVhMpPKP9WJPwnyPU+W3EM9/sN2AfxgSHJiIPqkfIwydA19gHbeCCFW5xMz8
         Y0Xl4eKf8nS6g7nVXS9339Xy9x+M7HziFt2DvxejM1Yv/KabmWKurXr83JHp9423L1FR
         Yn7VV4aFwyuT1vPVzoGDl1vCwWL69Cr3+O6A92wR2bmSMYsdltSOviEq+Va9Kg5Ctqel
         y/yQ==
X-Gm-Message-State: AOAM532B5rtGGeSClqD9KysZiEWCPJFZjPPgSGOgRvIpWKIno7bjmS1+
        2wDBgEr5CVWKkHV7oL9SSbfcXJwhVdeZ03ju0yc=
X-Google-Smtp-Source: ABdhPJxQCV5e2IPz1NdoQP/72fGEwe94DnDEYiZbNicISBZkJ1S+z4NKdoTs1hoPoTAxlSkzB0d+4VB/uF9SeLTSsbY=
X-Received: by 2002:a67:dd96:0:b0:32d:33db:cefc with SMTP id
 i22-20020a67dd96000000b0032d33dbcefcmr8600280vsk.61.1652776533678; Tue, 17
 May 2022 01:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 17 May 2022 11:35:23 +0300
Message-ID: <CAHNKnsSyH4YWBpd7bioY5BzbdG7U7F7m31RxtbxULpp52hkVuQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
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

On Tue, May 17, 2022 at 9:30 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>
> Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
> remove the spin_lock from t7xx_cldma_clear_rxq().
>
> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
