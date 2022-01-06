Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60497485D14
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbiAFAXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343703AbiAFAXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:23:17 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36AFC034003;
        Wed,  5 Jan 2022 16:23:16 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id c126-20020a1c9a84000000b00346f9ebee43so278649wme.4;
        Wed, 05 Jan 2022 16:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LtbJ7TD9znxzhf98x0PHy/SqzW7ZVDB+4Aleb2LR+tc=;
        b=hm8//BPPbFhrIDzJYowb5oFbAdkOAQqY0Drc1KsxzS8Vuca6ZQ4YoCiHHlOXdoi/PY
         CXAuEcjbHoYriLebucFP1lHBz/nldh8amCJIAO+4iZYBkS9CKyopNWWovCj/L2sZTqxZ
         V/O+WtrL/K+4A6QvMZEscSkTY+NnZUSptQqk/hGPJ8fc1zbSsJve8zEWFNYeXVVjKHcy
         10tyeKZbgazhtRf8/x46KcJM4Ww3tVliwKGm1bVwvXDQY/CGxV2iA7hvxbjmo/7wJxeI
         mh7mpSD85dHYkCp73haOpCzQhOHPF8oVzZ0ZNUWpSRz8x4qe0yzyYoHRVbJRUcvrpFrI
         r1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LtbJ7TD9znxzhf98x0PHy/SqzW7ZVDB+4Aleb2LR+tc=;
        b=I5sFcQUAs/FAP5d4NidRH119G9ncVC1yllj1EC66NJRIGI5ikID40NVgPbi8XtToP6
         ByuX1T2z2Qi9Xz3ZpQ3VPfw1ZLlZDhKSN11khHaAbzlE8/b/9XjzVqzoYhmRQzVTiBrk
         EU8l5MPPi+y7lI21H7CeyFkRCtFyWquLrwbxkaHriX6PdhlCKFWK4pxOboB13lFXR0V0
         PldhombY39HVGyB/9/c8xjB7H2K1tnExZWxq+Z9WppeIxVVJuOgbRmj6JbJONDxDqFSL
         OZ+fy1pbVzW5JXeN8dSp0e2zfNTzJNOAab6tL+GqGY5k99k8Pa+pnPUYTKUfp7eaNC07
         zG4w==
X-Gm-Message-State: AOAM531/Z3HlV0fq24TNpxVQ2CnXvlU9Eafkrru2z/HbxAg0d66pcEfS
        pJIUh7GyjiLwIS3WeA1f76rQFQrtCOflXsPjzPek4q99udA=
X-Google-Smtp-Source: ABdhPJxwVU92PbeiEsPXmYrPJ+CTjuJsI2k8EV3VJh4/qbdXFirVB51FerExeLPe1Oj+yyb9zEpWh8SsJv9A1SN2BzM=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr4906259wmh.185.1641428595576;
 Wed, 05 Jan 2022 16:23:15 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-18-miquel.raynal@bootlin.com> <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
 <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
 <CAB_54W6ikdGe=ZYqOsMgBdb9KBtfAphkBeu4LLp6S4R47ZDHgA@mail.gmail.com> <20220105094849.0c7e9b65@xps13>
In-Reply-To: <20220105094849.0c7e9b65@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 5 Jan 2022 19:23:04 -0500
Message-ID: <CAB_54W4Z1KgT+Cx0SXptvkwYK76wDOFTueFUFF4e7G_ABP7kkA@mail.gmail.com>
Subject: Re: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     David Girault <David.Girault@qorvo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Frederic Blain <Frederic.Blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 5 Jan 2022 at 03:48, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Thu, 30 Dec 2021 14:48:41 -0500:
>
> > Hi,
> >
> > On Thu, 30 Dec 2021 at 12:00, David Girault <David.Girault@qorvo.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > At Qorvo, we have developped a SoftMAC driver for our DW3000 chip that will benefit such API.
> > >
> > Do you want to bring this driver upstream as well? Currently those
> > callbacks will be introduced but no user is there.
>
> I think so far the upstream fate of the DW3000 driver has not been ruled
> out so let's assume it won't be upstreamed (at least not fully), that's
> also why we decided to begin with the hwsim driver.
>

ok.

> However, when designing this series, it appeared quite clear that any
> hardMAC driver would need this type of interface. The content of the
> interface, I agree, could be further discussed and even edited, but the
> main idea of giving the information to the phy driver about what is
> happening regarding eg. scan operations or beacon frames, might make
> sense regardless of the current users, no?
>

A HardMAC driver does not use this driver interface... but there
exists a SoftMAC driver for a HardMAC transceiver. This driver
currently works because we use dataframes only... It will not support
scanning currently and somehow we should make iit not available for
drivers like that and for drivers which don't set symbol duration.
They need to be fixed.

> This being said, if other people decide to upstream a hardMAC driver
> and need these hooks to behave a little bit differently, it's their
> right to tweak them and that would also be part of the game.
>
> Although we might not need these hooks in a near future at all if we
> move to the filtering modes, because the promiscuous call with the
> specific level might indicate to the device how it should configure
> itself already.
>

My concern is that somebody else might want to remove those callbacks
because they are not used.

- Alex
