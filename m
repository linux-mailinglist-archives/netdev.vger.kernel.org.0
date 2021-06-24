Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AEB3B252D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFXCuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFXCuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:50:04 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120A4C061756
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:47:45 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u11so5732481oiv.1
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ow+yi5ZT4+yhby+GfBBf3KrG2XouQKIkkAjk0AAheOk=;
        b=ERhH0v4+YARWdY1hSLOzrpBxXnOZquCYKZV829XwaZCJG7FmtMSA9CgsGdiKP5NLpz
         kde2UBWZhwqpPxeZ7cF1Ps4nwJSbHavwA4YTfcAGJh/o+z0A9rgfcL/b7WGuCeq5BeF/
         GxFEa3TcXgyh57b0Q00joCSmDMcLGFyVPrfxXKLOIUYjpiKHnTefOkVicP/wtX1a2fdm
         x3a/42pUjc+ArBaq1s7CtGbJ32/AvCJhqNVOz/NCKNnO4gIQwquu2ItsobkwXE6605mm
         0NJqZEoK/M4iLO3owkVZ/VmSxZ1M1BG2X4y0J09edxmZAB1yWCZsq2YP23ACK0OoFP3x
         xRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ow+yi5ZT4+yhby+GfBBf3KrG2XouQKIkkAjk0AAheOk=;
        b=LLMW8XV5X48NeVQnToWYJK7jr9JXrvjZ6zeacyG3H854Dos0jn7TXtW6K0ejtuPE5p
         1u38fLSgiJ+dyF5VMxCs95V+JOc/dpcbSXVkfJzKzPe1CTuSgsqEfV/ClqloWIWijRwM
         SO0+0Bekw8N1ZcqZtqYrpjSypHUp/zM81RerYDl7coQBmrNLAxfYQZqm1sfnmSeoZshS
         XP+D3TysOG/Yim5Sfy3BdBSlgGSMVRDzR3VZjd79pcIdoFW2m1SREan4nsGHc9kkiMNI
         xAP0xQfvEJ0QIw6NYryaw9nH7uhKpgC8k5klXGwCZhjwToqCXI4Oq2xYCxHoqmT/pxe5
         fM8Q==
X-Gm-Message-State: AOAM533WrisecO/W43r8C3hMpIzfyFqfTOFUUWrGsrYxOB9eYygyGu2m
        lzIyesulABRB4w+osq1w4UWLO0LjQGi2FXnJyQfYGA==
X-Google-Smtp-Source: ABdhPJxy3AvyfNYma/ANcy5DB8Nub4RuI1ghqApM551Ru7K3xbbRRdfNEcgSl3EQPg84rM15ftGKISjNniVIPiOSAVg=
X-Received: by 2002:a05:6808:251:: with SMTP id m17mr2289913oie.77.1624502864138;
 Wed, 23 Jun 2021 19:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210623032802.3377-1-jhp@endlessos.org> <162448140362.19131.3107197931445260654.git-patchwork-notify@kernel.org>
 <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com>
In-Reply-To: <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Thu, 24 Jun 2021 10:47:01 +0800
Message-ID: <CAPpJ_edpVxbnPBGTrkvB8EY5mt_sgPmoMv7rBdUKUHZJnjhHNg@mail.gmail.com>
Subject: Re: [PATCH v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        bcm-kernel-feedback-list@broadcom.com,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux@endlessos.org, linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Fainelli <f.fainelli@gmail.com> =E6=96=BC 2021=E5=B9=B46=E6=9C=8824=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8A=E5=8D=885:19=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On 6/23/21 1:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This patch was applied to netdev/net.git (refs/heads/master):
> >
> > On Wed, 23 Jun 2021 11:28:03 +0800 you wrote:
> >> The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too lat=
e.
> >> So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
> >> GENET fail to attach the PHY as following log:
> >>
> >> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> >> ...
> >> could not attach to PHY
> >> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> >> uart-pl011 fe201000.serial: no DMA platform data
> >> libphy: bcmgenet MII bus: probed
> >> ...
> >> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> >>
> >> [...]
> >
> > Here is the summary with links:
> >   - [v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
> >     https://git.kernel.org/netdev/net/c/b2ac9800cfe0

This bot is interesting!!!  Good feature! :)

> There was feedback given that could have deserved a v3, if nothing else
> to fix the typo in the subject, I suppose that would do though.

I can prepare the v3 patch with Florian's suggestion!

Jian-Hong Pan
