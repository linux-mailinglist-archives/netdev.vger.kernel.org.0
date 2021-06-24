Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3B73B257F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFXDby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhFXDby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:31:54 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16407C061756
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 20:29:35 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id t4-20020a9d66c40000b029045e885b18deso4168380otm.6
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 20:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iJCurAd0QJM4SEDLicA9j39/tcXrqbQx+mlduxNSE1w=;
        b=UKRxu4BDkFMUGtXNlol5Gks5gwGhfNb6hRp1rMHlcWYJLIBnlfOC38YXHJLEDgs9sD
         aJyMYxFHuWmeRB6ueLLEAsmPBeinKTC600Q7cgxPPIPkibJULj6ZgNuEA6JcqODQ8lhZ
         vaBwgrIEZ3DXSMcGgHd+koyzJTCFfwN2O+zqBzrT8tZRZF9p3tS3zkTfTWnO8LbJlOKs
         cR8FFf23iv21AbtXEda53YmAu9J4+SyBCXvwTr7WSoJlMPSUpSLcXSZ8oCNZQLuNC6k6
         LNkhJbIBFZWe2c/Wlh9pjOkF1i8qtpHCkk+NsOMDDimHgb/DLcga7rHJ04uCNKUXcKpN
         cloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iJCurAd0QJM4SEDLicA9j39/tcXrqbQx+mlduxNSE1w=;
        b=IC3iUlAcSP4vAOx9h8CNrO8e60SKlgXJamKa6P7tl6hskPawPpltaU/ho8qs7YjfiF
         Uu2/2UdDLJk5M4aJNeLb+eEbHBQo+1ituRzc7QxDXf4t7HTY9qmixJMTen/GzwryxDQ4
         yf/XRzCMEV5dIsKQgI8ZE08FjI4tq04Z/OtJDPp7a6kDnOTwByQoh/oK30B19edXDGUS
         1D5jhmwsZl/nwiGk0RivzMeFnMHiWN/vRPx4uSUgR+npVCrbV1KQ8Q9A9SeAqRRCfREu
         slxq7AlexHyNTXyV6r13grcyvxySvSNxNdys/AJk5QDJtueIpyVBqrOb2GKM4nN8xzGd
         S0XA==
X-Gm-Message-State: AOAM530NqFlZvnWKC1E17e131ixf8tFoitjINF4GCGGJGP/ydICz/0Qd
        O89BOMO+baCoW+JYEghXw9ygva/urE4TaAuGD5dssg==
X-Google-Smtp-Source: ABdhPJzIuSEJSh/lDfYU329TQt3RF57KMLdWVSszJiamILZvYDCk7a4eksA3MIADIAYSva2Z0Kigo42/4xJs9Eom+LI=
X-Received: by 2002:a9d:6f93:: with SMTP id h19mr2750323otq.100.1624505374421;
 Wed, 23 Jun 2021 20:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210623032802.3377-1-jhp@endlessos.org> <162448140362.19131.3107197931445260654.git-patchwork-notify@kernel.org>
 <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com> <CAPpJ_edpVxbnPBGTrkvB8EY5mt_sgPmoMv7rBdUKUHZJnjhHNg@mail.gmail.com>
 <20eeedec-4ec2-7aae-2e80-09b784e1693b@gmail.com>
In-Reply-To: <20eeedec-4ec2-7aae-2e80-09b784e1693b@gmail.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Thu, 24 Jun 2021 11:28:51 +0800
Message-ID: <CAPpJ_edSg54W-eo2jqMszPP-QntPJ=ahyeQE5DOofd-XFFjFwA@mail.gmail.com>
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

Ok, thanks!

Florian Fainelli <f.fainelli@gmail.com> =E6=96=BC 2021=E5=B9=B46=E6=9C=8824=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8A=E5=8D=8811:27=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
>
>
> On 6/23/2021 7:47 PM, Jian-Hong Pan wrote:
> > Florian Fainelli <f.fainelli@gmail.com> =E6=96=BC 2021=E5=B9=B46=E6=9C=
=8824=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8A=E5=8D=885:19=E5=AF=AB=E9=81=93=
=EF=BC=9A
> >>
> >> On 6/23/21 1:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> >>> Hello:
> >>>
> >>> This patch was applied to netdev/net.git (refs/heads/master):
> >>>
> >>> On Wed, 23 Jun 2021 11:28:03 +0800 you wrote:
> >>>> The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too l=
ate.
> >>>> So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This lead=
s
> >>>> GENET fail to attach the PHY as following log:
> >>>>
> >>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> >>>> ...
> >>>> could not attach to PHY
> >>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> >>>> uart-pl011 fe201000.serial: no DMA platform data
> >>>> libphy: bcmgenet MII bus: probed
> >>>> ...
> >>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> >>>>
> >>>> [...]
> >>>
> >>> Here is the summary with links:
> >>>    - [v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
> >>>      https://git.kernel.org/netdev/net/c/b2ac9800cfe0
> >
> > This bot is interesting!!!  Good feature! :)
> >
> >> There was feedback given that could have deserved a v3, if nothing els=
e
> >> to fix the typo in the subject, I suppose that would do though.
> >
> > I can prepare the v3 patch with Florian's suggestion!
>
> Too late, once it's merged only fixups can be accepted, and that does
> not include commit messages, it's alright.
> --
> Florian
