Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9879B3BE9EA
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhGGOnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhGGOnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:43:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22C8C061574;
        Wed,  7 Jul 2021 07:40:42 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m1so3682281edq.8;
        Wed, 07 Jul 2021 07:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2CqXQM4gK444x34KMmDOwqUZN/xDTBR0VqnRVpkPO0=;
        b=XWdYbNKa6wcp5TETHzpwDaXE6CBaqBwLmdGEA6K7bI7eStoK0t+oQAJa5qOboKQwd6
         xT9GfLtI2jj0KIDHvHRIl0XnVr96o8GCLml2NVK3lQmdzhScDtnqSBX7RH/Jb1XRJwtx
         iiUy1uvDpPV3zHZ+kpo2K8a89+Q+A8+kpPJkt10MMoZrPXmfK/+FgLu+VqHQ3Dv5DKe1
         H7Z9p7k2iNKawP8OZgbWCttIV0TNUe+pPpJp4SyPMUpWG1qFE8Le5W4iYXLzaCSGeU5f
         X86lYZags+HMbJ71Hu+nPwiq6EtZYvEiMoNaaq3W1BjEyG4gQnS4eiCUTyRwMjMfBLkI
         KReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2CqXQM4gK444x34KMmDOwqUZN/xDTBR0VqnRVpkPO0=;
        b=U3ea0APZr2jt7zpS81hVMm6lCpNuh6YlRnIYRjzJlx+vd56JcXRc3v218838Cr1T28
         C39IxApmw34KcU2YuSHCuJLQpktsWyXQyHUsd3UTN5tohgQYxGjhO/25nNenOSrYpUAb
         fOk+FhkGxWIPaPMn8nFQQkdDETvCDtipaHkNp/IegvMOUHA7yzTwEc/dwbpIlALpxask
         CIpcnWR7hp9cLZjSoCUO8ffsd9pAX1ErH9zm9oSE4eu4qQsvK0TXrUlSnJ1RZmFd01Yx
         8uOZ4AQK3o/ARdVxWWCtnX4ChERXf9NzmoTvvC+4d3bXV+IcD2EwZ2knrb6irLdemOvI
         tZSA==
X-Gm-Message-State: AOAM530DbF0GWqnVEHHDBT4EHsJmX9qLAhW0KXOTWbbFsmj+vKbTuDXB
        iWtTein2U6emRXmB89X+FsRZ6e8d6wWTns+aN8Q=
X-Google-Smtp-Source: ABdhPJya4vHn6Vby5kux1Kp4QHZtTQbPAtTIwrhYUQy8ZY+zTmse5qCs5FDjWMUy5RvuZa9sIRaZYP5C69gDJPwhJQE=
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr30815805edd.174.1625668841333;
 Wed, 07 Jul 2021 07:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210705131321.217111-1-mudongliangabcd@gmail.com> <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
In-Reply-To: <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 7 Jul 2021 22:40:15 +0800
Message-ID: <CAD-N9QWykP2CBq1bPvz=HQRdeaR+Mg06hezrgOm4g3N1J_jT1g@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 9:44 PM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Mon, 5 Jul 2021 at 09:13, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
> > MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
> > must be present to fix GPF.
> >
> > Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
>
> Acked-by: Alexander Aring <aahringo@redhat.com>
>
> Thanks, but there are more places than this one. Can you send patches
> for them as well? Thanks! :)

Sure. I will double-check those places and send patches to fix them.

>
> - Alex
