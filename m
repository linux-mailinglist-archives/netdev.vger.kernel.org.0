Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046FF3A5B1A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 01:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhFMXsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 19:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhFMXsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 19:48:21 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EC9C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 16:46:19 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 5so9305056qvf.1
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 16:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yLX/ur54moqzu2PisxABzO9lUlcTtlTTvRud0ukIiTk=;
        b=iJysEGEpYjvUbxf5+O4wQ1DEhhnGeJwGafwWPI9gepZeKQeb7Gn/IENgjQsuPaMrk1
         9IjCl9PwgVeaU15y4JXUGCWcU3ROOoA1O1Ky7x0HFWt1uOtieTa7AKY8GLPtDGj0Tgl2
         G1ur5vWkCdj6WPCe1PYLkXVZHpGk/DuzIZ7YMHox3J0i1yKDHzwgHsT/G0L2A+wBiuCM
         NRB+jWVbH30meokSi6YF0eiV0GhziuNpJdX3tfGvFq4VPkuDy/esPKdv37XONc38GxRK
         pKM4BBOw2p0YAPTH65QJXjI7h/jE8nd/YtIthzvfP3S+fSooCNHfghgeMzGmVhhOvKHA
         2EOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yLX/ur54moqzu2PisxABzO9lUlcTtlTTvRud0ukIiTk=;
        b=Oq9DMabUQYV/OuAfJlD5/KTnQz7agPkcOmMMBZBfTG8otNEQP4zqg3ZzgclZNzo5kt
         0O1h6bMfPzI98xi/Kpw0A+ZAqJ5SLJ5Bt83Cw6QaFJ3unXtet4fbNp1bmLfr7Hiqou1O
         FX7jOOV1M5nkttvol8tH88xFO7if9ZdchZggMgrY30d0vFqf22LNeu/NzHKfU3bvYNFV
         AhdTzKmQ2T2bnLj8QJ0yWgJQ10c2UJCUEXN7mc39DcCD89zAfQNqivbgwapKj0xBfXG2
         t0K1fhwZftMGzqLU07swRHCG5M3P0P0zpdlIS5wdyMoSjzSA00dTbICktXr2swuftrqG
         m+1w==
X-Gm-Message-State: AOAM532ej6PnkqF7LHYiriMHVZcW9wvxbaVOS48wfD2kboqxiy0CdvcN
        vLkPL/nFQVyDe3qFYOaXVafyAjUwweRR5Gbn721hAV6Lc1k=
X-Google-Smtp-Source: ABdhPJwVZOm0oZpxf/OFlCWVmNh53+dZLinoQHcz6FQlzXLDzr1idWR0CVdsHuZH4Is3newhFtg94mhPJrdY7YqInig=
X-Received: by 2002:ad4:5f0e:: with SMTP id fo14mr3043268qvb.16.1623627978540;
 Sun, 13 Jun 2021 16:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-3-mw@semihalf.com>
 <YMZg27EkTuebBXwo@lunn.ch> <CAPv3WKfWqdpntPKknZ+H+sscyH9mursvCUwe8Q1DH-wGpsWknQ@mail.gmail.com>
 <YMZ6E99Q/zuFh4b1@lunn.ch>
In-Reply-To: <YMZ6E99Q/zuFh4b1@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 14 Jun 2021 01:46:06 +0200
Message-ID: <CAPv3WKetRLOkkOz3Cj_D5pf824VGoz+sQ6wNukTS2PKoAcdFyw@mail.gmail.com>
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Jon Masters <jcm@redhat.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Adding ACPI Maintainers>

Hi Andrew,

niedz., 13 cze 2021 o 23:35 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > True. I picked the port type properties that are interpreted by
> > phylink. Basically, I think that everything that's described in:
> > devicetree/bindings/net/ethernet-controller.yaml
> > is valid for the ACPI as well
>
> So you are saying ACPI is just DT stuff into tables? Then why bother
> with ACPI? Just use DT.

Any user is free to use whatever they like, however apparently there
must have been valid reasons, why ARM is choosing ACPI as the
preferred way of describing the hardware over DT. In such
circumstances, we all work to improve adoption and its usability for
existing devices.

Regarding the properties in _DSD package, please refer to
https://www.kernel.org/doc/html/latest/firmware-guide/acpi/DSD-properties-r=
ules.html,
especially to two fragments:
"The _DSD (Device Specific Data) configuration object, introduced in
ACPI 5.1, allows any type of device configuration data to be provided
via the ACPI namespace. In principle, the format of the data may be
arbitrary [...]"
"It often is useful to make _DSD return property sets that follow
Device Tree bindings."
Therefore what I understand is that (within some constraints) simple
reusing existing sets of nodes' properties, should not violate ACPI
spec. In this patchset no new extension/interfaces/method is
introduced.

>
> Right, O.K. Please document anything which phylink already supports:
>
> hylink.c:               ret =3D fwnode_property_read_u32(fixed_node, "spe=
ed", &speed);
> phylink.c:              if (fwnode_property_read_bool(fixed_node, "full-d=
uplex"))
> phylink.c:              if (fwnode_property_read_bool(fixed_node, "pause"=
))
> phylink.c:              if (fwnode_property_read_bool(fixed_node, "asym-p=
ause"))
> phylink.c:              ret =3D fwnode_property_read_u32_array(fwnode, "f=
ixed-link",
> phylink.c:              ret =3D fwnode_property_read_u32_array(fwnode, "f=
ixed-link",
> phylink.c:      if (dn || fwnode_property_present(fwnode, "fixed-link"))
> phylink.c:      if ((fwnode_property_read_string(fwnode, "managed", &mana=
ged) =3D=3D 0 &&
>
> If you are adding new properties, please do that In a separate patch,
> which needs an ACPI maintainer to ACK it before it gets merged.
>

Ok, I can extend the documentation.

Best regards,
Marcin
