Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109EE51D95C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441809AbiEFNoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441793AbiEFNoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:44:10 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B3A334;
        Fri,  6 May 2022 06:40:18 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id f13so2799220uax.11;
        Fri, 06 May 2022 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=od0zloc/AA4CPbJv6r2zKruCgN8IBIBynulqDfOqRpM=;
        b=ox8SDvd17bKlntYSKmZ665by/msQLYfuXc0rsTuR2LRCs2HvFoAPad2rDwv3I0sjmv
         ie4Fz/4P+BLRp80RS8DxHE9TPSGppl0C+LxWsXaeNOrUAZ3IS/B7XpHa3vrCrLWy4l9t
         caQsAGsRAp/glQ4Oa4HDI2qVTi5DgIzYnE4AuzKDj5cIq5G0zPxD9+7oq+Qyj8hNmkER
         zZVp8287ee1c4a8ezcvgMsdwPFzFTxsIIIv0TIKYeupzcVOq8CsyRRe02InUyMk47qJS
         7FDuFANbpAgvH90hPlyFtBnMRMVmuJbYQTRx2EZcbu5u5uUofy9qKoPxY56yrfyOKP9e
         Y/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=od0zloc/AA4CPbJv6r2zKruCgN8IBIBynulqDfOqRpM=;
        b=ub4IUeEgR5GvOruqTO/gUihynEG7aszDbC8KG8tfgShRqTKpSSDOGT90KGqjKSeZXP
         9LHEwUMe5hushbQoUSx5ggh2W4Ws7bkgBFQkYLvvHrB26xZGnSJ0WxOix3sBdOdhA+cF
         zfLmxAJYmpCbore/L+pip9Sl2NDnqlsqvWQ3hMl+a4VyyYbzS7BTsfpzKfe9ItF1kKco
         Oam//K1fXve/dsDZAOKkj+r5ufbuTzqo+HJVvyjEJqoJ0XB6XVxhlAne3TaPlVjtSJJ6
         LkkqL42qox6ANLXk0F9dPP/2z4AG5y4SwUIpXTFeGBkYJfkJr5XrAm4E+1EzYJ+elfPz
         ek9Q==
X-Gm-Message-State: AOAM530utv6oHpG3ZMdtq5YTyl2PuRUC4Sezz7IQWXGHlBUhxwOiWhrx
        +2gDXLnfPkk/q8h7HOLWsJffb+BU9/eGVYAJ88A=
X-Google-Smtp-Source: ABdhPJyoNeN9aVMXNsxzulsgCIBI1BKIzbRf2uYrTvXqov1EJIXXrT4sFqdIT7cSssZH+PyNRxXl8CQvGYJWcCM4c2g=
X-Received: by 2002:ab0:7290:0:b0:34b:71ac:96c2 with SMTP id
 w16-20020ab07290000000b0034b71ac96c2mr980899uao.102.1651844417591; Fri, 06
 May 2022 06:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com> <20220506011616.1774805-3-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220506011616.1774805-3-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 May 2022 16:40:06 +0300
Message-ID: <CAHNKnsS2p3vFeOiE6L7JHg7LHhWs2-aqrvz_KquHh80P5KEtXw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 02/14] net: skb: introduce skb_data_area_size()
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
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

On Fri, May 6, 2022 at 4:16 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
>
> Helper to calculate the linear data space in the skb.
>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

Please refresh the patch, it does not apply to the current net-next tree.

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
