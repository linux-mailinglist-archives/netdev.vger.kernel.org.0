Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76999422A3F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbhJEOKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236549AbhJEOJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:09:24 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC22C061755
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 07:07:20 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id g41so86587795lfv.1
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 07:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w3X63+lDXYgXRquT+ZxbepYw8iAHpJZRcAhaArsO/Sc=;
        b=QAyPzOJZBZ3/cpLEEz+o3c5ez8sf68V3T/X3d059p3A/kolqa9aqUkrNzZmQJ7PrRq
         lnolV0sHFRvCgH+a6ZT5hiQLIS2qIxCIQrmIf4ooIyprPzDkma0CyqbjcmvP0WmSQu70
         bOHgH4xSSRCKPezL1wtYDHuBMLNVuWnH1TQmrzIkK+fDrf8l+ixI3vVQX2CdsT2E/zxH
         qJDNoxENpSQUtyAabvv0asdg0DRMazHO8KM6K+iG59a8w6Mk0you0ZnuHYynVF1g05KK
         tQ5m2x/sMGr2jbK/muSN5j3wH0gI+suIHPhniSr5AuNOLjz+QIV8StOmvwovUnfR94f3
         +nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w3X63+lDXYgXRquT+ZxbepYw8iAHpJZRcAhaArsO/Sc=;
        b=RQW8lAE3ucbqHeeUA93fpUmAxqWkLAaRfn8gcjmmcSDsvblq6d2SNCBmIsBEzHQ1e0
         Ka+OxJfeqS6meWQEysLFGcmALrqimcREIY5WDQIpxWN3heEckt09GfxLjxHzZVNfMn24
         mz4gVBXvFRsbNspC7nbeKnEv1Jg4h7f2EAasL5lOZy/+FTBDeIxnw9XYWeIvjDPHWV78
         vPf638KpUcmK2j3SKQwj3zSlfp334z2gTmF2beJQhlOn2/SSgsFWX7IRR3yCRH6x1Qjw
         XVz5qhT10mJ0hWHw5dba0f7CztIOj8H7Pg0iPcpc/1Z90F8CxpNA4tDroQ70yHF4EVdJ
         tMrA==
X-Gm-Message-State: AOAM531HXUCJGXyV9t5qRc/gwEHrbCpIgD64PXDvZ5dyZWQ7jUc/5G2a
        +oMox9cPp8Fl8lWm2NTCZNKmmZcrpw3Pp3wHk2Glfg==
X-Google-Smtp-Source: ABdhPJzRMwqEahMi26H3GyCNfkJ56DvkzPjekWpBknhs+3XYtk8JFJU0rf8TW7rjgoiGiffMqYXsJVgx2k+hGeEN+WI=
X-Received: by 2002:a19:f249:: with SMTP id d9mr3719369lfk.229.1633442831834;
 Tue, 05 Oct 2021 07:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-2-linus.walleij@linaro.org> <9c620f87-884f-dd85-3d29-df8861131516@bang-olufsen.dk>
 <CACRpkdZ5O0pf+mZphr5ypDNXtkQwfomwBnUToY2arXvtDHki+g@mail.gmail.com> <d255f7eb-a85d-6fb6-8e86-ccb9669dd339@bang-olufsen.dk>
In-Reply-To: <d255f7eb-a85d-6fb6-8e86-ccb9669dd339@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 5 Oct 2021 16:07:00 +0200
Message-ID: <CACRpkdYaqN8=AcSJMTk_uNfDti_tETQ6LT8=OO74qAHadtRmaA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling learning
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 9:59 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> wr=
ote:
> On 10/4/21 10:57 PM, Linus Walleij wrote:

> > BTW: all the patches i have left are extensions to RTL8366RB
> > specifically so I think it should be fine for you to submit patches
> > for your switch on top of net-next, maybe we can test this
> > on you chip too, I suspect it works the same on all Realtek
> > switches?
>
> Generally speaking I don't think that the patches you have sent for 66RB
> are particularly relevant for the 65MB because the register layout and
> some chip semantics are totally different.

I was mainly thinking about the crazy VLAN set-up that didn't use
port isolation and which is now deleted. But  maybe you were not
using the rtl8366.c file either? Just realtek-smi.c?

> Regarding CPU port learning
> for the RTL8365MB chip: right now I am playing around with the "third
> way" Vladimir suggested, by enabling learning selectively only for
> bridge-layer packets (skb->offload_fwd_mark =3D=3D true). To begin with I=
'm
> not even sure if you have this capability with the RTL8366RB.

This will be interesting to see!

Yours,
Linus Walleij
