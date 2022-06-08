Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAA1543FCB
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 01:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiFHXPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 19:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiFHXPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 19:15:46 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F09A25EB5
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 16:15:43 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-31336535373so73952827b3.2
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 16:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5dm3ORkewVvScpNnTHAWD0lWUpKHv8ZP9Eg12POa/hY=;
        b=s8ajev8ylc24lWL+uVn0aQqBmKLBXSt4qhwBZySWYs06ap1dTsQm6yNKQo5ZZk1Ttw
         CogFfnoV9WalwlDwJZQwIzhS53XYG0TnpLr6RaCiWz52oS8Ya2rxty3/51rSjmJayx7c
         EWdKZF1ai138Psl2FvsA3fb81ZOFaNvnMqn373Non4bghec4LDcPh888h9mpuh/1unnN
         f9dX3yfRPbSr2zW6HLeQ/tEvTedV0nhIrv0QdBSD7AwR10AtUBj/yefZJX+LJ+vEpqtI
         mz7ygzZjwLzaYvbU7IBn1tdY8nY9jEOw6ZGRU2lMtt4y+nfEmnlgAfeCbdWY91a6rwLO
         KGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5dm3ORkewVvScpNnTHAWD0lWUpKHv8ZP9Eg12POa/hY=;
        b=uwQKTQvB4gQFsJ64QOclk3k/tcvN1LdIdkwrNCrzpP0u+TwBDfXYRndcMzxJ2pDcUE
         2hCK2+grFpnbwSb/lRbYI5DaX7vmnzS4HWpljj0r9aIgHjqkzivI5xHI7M/D7iOcfy4U
         PPkjpOF247FX6G0B91LQtDZiU0l/rmA0kk7H+qN4luDOWKJ31K/v8DZ90i1R0Ji+orgG
         2NdAJf5ez1haaDtreQbIKY4FXmZqviIdbcdbjlMX8XQI/l1ZoWZfRCjKYb6G0tfopCcx
         yxSY918VTHGuNyzQav9aLq9hJNUU/F/yI8KyLahHGnbYGMHiPrhKSAmnqo2lIkxBDW5c
         HjFA==
X-Gm-Message-State: AOAM530Gp2tc4DTfO/fvAijn2UrcbWLUS+IL4ul5P8fImv5mZ2RpJPAy
        TvWEE/6a2z+gx9Vxelx4sXFMQwfti3IOG6G4Y5Vgag==
X-Google-Smtp-Source: ABdhPJydbDnoddm1zrWGAsHzuwqdddTQzuodu0O1Gb1JEUm33YqJ1CQ0JnoMmfFGzaJs2LsBc2KxBacSkdprXywkGyo=
X-Received: by 2002:a81:1a4c:0:b0:30c:8363:e170 with SMTP id
 a73-20020a811a4c000000b0030c8363e170mr38925926ywa.455.1654730143827; Wed, 08
 Jun 2022 16:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
 <CAGETcx9f0UBhpp6dM+KJwtYpLx19wwsq6_ygi3En7FrXobOSpA@mail.gmail.com>
 <CAGETcx8VM+xOCe7HEx9FUU-1B9nrX8Q=tE=NjTyb9uX2_8RXLQ@mail.gmail.com>
 <CAMuHMdXzu8Vp=a7fyjOB=xt04aee=vWXV=TcRZeeKUGYFFZ1CA@mail.gmail.com>
 <CAGETcx_Nqo4ju7cWwO3dP3YM2wpCb0jx23OHOReexOjpT5pATA@mail.gmail.com>
 <CAMuHMdXQCwMQj_ZiOBAzusdCxd8w6NbTqD_7nzykhVs+UWx8Gw@mail.gmail.com>
 <CAGETcx8UO=4mk31tU4QaWU3RaNM_myA9woe0idBp6p7+X5AEgg@mail.gmail.com> <20220608154908.4ddb9795@kernel.org>
In-Reply-To: <20220608154908.4ddb9795@kernel.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 8 Jun 2022 16:15:07 -0700
Message-ID: <CAGETcx_ZPB2ce-7Zf-bVy4hHe8Nvk62_7HVeO1dhQvg1iuHQDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] deferred_probe_timeout logic clean up
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 3:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 8 Jun 2022 14:07:44 -0700 Saravana Kannan wrote:
> > David/Jakub,
> >
> > Do the IP4 autoconfig changes look reasonable to you?
>
> I'm no expert in this area, I'd trust the opinion of the embedded folks
> (adding Florian as well) more than myself.

Thanks.

> It's unclear to me why we'd
> wait_for_init_devices_probe() after the first failed iteration,

wait_for_init_devices_probe() relaxes ordering rules for all devices
and it's not something we want to do unless we really need it. That's
why we are doing that only if we can't find any network device in the
first iteration.

> sleep,
> and then allow 11 more iterations with wait_for_device_probe().
> Let me also add Thomas since he wrote e2ffe3ff6f5e ("net: ipconfig:
> Wait for deferred device probes").

Even without this change, I'm not sure the wait_for_device_probe()
needs to be within the loop. It's probably sufficient to just do it
once in the beginning, but it's already there and I'm not sure if I'm
missing some scenarios, so I left that part as is.

-Saravana
