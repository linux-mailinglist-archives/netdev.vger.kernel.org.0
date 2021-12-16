Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037F94771FB
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhLPMkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhLPMkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:40:08 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A71C061574;
        Thu, 16 Dec 2021 04:40:08 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id a14so47011003uak.0;
        Thu, 16 Dec 2021 04:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9LY0dxvSwFaCXK5+F3DtxBhs3+f8dYEuoAu1fa5cGgw=;
        b=bbSCTzKBHJ20vjO+luIqPO5W99jkWqEGCnGPRI3jzrmtb8+SHeCdP8KPecgTKfb7JN
         nlgIEY53uMUR+PzJd1avLO4uGwANcoN2TT277gC43UAaqcyWt0kvd3VJ4Ly7ctICmPjT
         y2i3E/nJDEUePfonweAokT8Vb1AzAr2u8AjgZuB/k5KH37xbGC649vdImKktOG+oa/WC
         3ywKIE9IWmvzqivFI6mqE9xszdyLsS9B7mBXIvxeTILy0u7jrjtWaaoCwBJUKX038lwg
         koyP/cvumxZ7eENIEUY3j5Cg3pxsDypxfFKQfJw3USOb1sfvcdzq/NfDfjE4hAXJLQN4
         ZXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9LY0dxvSwFaCXK5+F3DtxBhs3+f8dYEuoAu1fa5cGgw=;
        b=vv+Eyg4R/kPIjKSs+yy0ygr7QMXLbB0yqaiNmwCBbiRJ6nILMTjc9fOT5qnw5hEo4d
         WgZCzczAYtCwVxoO0Ly0d6Ht6yw0RSWxAxaGE4vQcdNBeXek7xP+/f5NBOTwkmfYTTU7
         ND/k3MrGQVxgG9ZHLMWyVV4awj/RV0XoLc3cl6Zq9Uf7wyChEL8DcS4bFCCgbak8I8Da
         qvCNZq5XrxxxB+PAwtaGzUFZSXDyT2fY7R++lOg/Q+R4pMGGaI9MzyiFpk9YR5WefPDu
         BS/hRbP//xL2vKGGTHgUSr5P7Rdsz/0EzsdG0h600i7IbTagp4KQNOHUMTMAItfs7Diw
         KHAw==
X-Gm-Message-State: AOAM5310nCo/kOLdL2mXGnXQzLKE6Jwn0Nmgni0Avr1Df7lx7JMNjBRN
        Gm619vDlRalGm+MnlMJ7+2EviJhOsGV3JnCNkms=
X-Google-Smtp-Source: ABdhPJxIyv3/JcMZJjOESMA1zP7RxGySnR3a5ZAOAMrFT8+JrZBQV41RRRgcOd53pP+KBoyZ7JRQriSxrxRb7HZBxyg=
X-Received: by 2002:ab0:ef:: with SMTP id 102mr613103uaj.46.1639658407217;
 Thu, 16 Dec 2021 04:40:07 -0800 (PST)
MIME-Version: 1.0
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
 <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com>
 <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
 <CAHNKnsQ6qLcUTiTiPEAp+rmoVtrGOjoY98nQFsrwSWUu-v7wYQ@mail.gmail.com>
 <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
 <CAHNKnsTWkiaKPmOghn_ztLDOcTbci8w4wkWhQ_EZPMNu0dRy3Q@mail.gmail.com> <0e7b0e3d5796bb13d5243df34163849f32e8dfb3.camel@mediatek.com>
In-Reply-To: <0e7b0e3d5796bb13d5243df34163849f32e8dfb3.camel@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 16 Dec 2021 15:39:55 +0300
Message-ID: <CAHNKnsTMCbjS_vRZ=-sbtu6fxeDFph=r9kVuqnOVm7Y4RRJHag@mail.gmail.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network Device
To:     Xiayu Zhang <xiayu.zhang@mediatek.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?Wmhhb3BpbmcgU2h1ICjoiJLlj6zlubMp?= 
        <Zhaoping.Shu@mediatek.com>,
        =?UTF-8?B?SFcgSGUgKOS9leS8nyk=?= <HW.He@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 3:13 PM Xiayu Zhang <xiayu.zhang@mediatek.com> wrote:
> Hi Sergey and Loic,
>
> Really thank you for these information.
>
> It seems that I need to submit another patch for discussion.
>
> At the meantime, I have some questions below and hope you could do me a
> favor.
>
> On Wed, 2021-12-15 at 22:16 +0800, Sergey Ryazanov wrote:
>
> > There are two things that trigger the discussion:
> > 1) absence of users of the new API;
>
> Can I choose WWAN device simulator (wwan_hwsim.c) as the in-tree user
> for these new APIs? And, Can I submit new APIs and changes for the user
> driver in a single patch?

This is not a good idea. Simulator is intended to test the API that is
used by other drivers for real hardware. But not for experiments with
an otherwise "userless" API.

If you need to configure the number of queues for an already in-tree
driver, then just submit a patch for it. If you plan to submit a new
driver and you need an infrastructure for it, then include patches
with a new API into a series with the driver.

>> 2) an attempt to silently correct a user choice instead of explicit
>> rejection of a wrong value.
>
> I will try to follow this:
>    a. If user doesn't specify a number, use WWAN driver's default
>    number.
>    b. If user specifies an improper value, reject it explicitly.

Yep, this would be a good solution at the moment.

-- 
Sergey
