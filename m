Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FABD33EF6C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhCQLV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhCQLVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:21:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450D5C06174A;
        Wed, 17 Mar 2021 04:21:44 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo1058853wmq.4;
        Wed, 17 Mar 2021 04:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A4RSUNn47cQJvhtlF1zsYGP+exS0+A4natS/qw0bQ90=;
        b=jBe6IpuONBdWqy78f09ex94AKPsB3bVwBSXyz7W58Qq4Bx8b2IqExrIrF7TVk5cBRy
         laWUOgK+rO0NpdeezmgwzOT52Gs3FVrnI/eHZ6KKnRhvSsydIfj1k6yofvybdXwVGwVu
         nWE9BM9HRJXw1AhdCqcxDuWe0qKikTHvRbNQ3ul8uyihXTtWBLP38FxUCluM5n0+cEuB
         KQ6tUvZnAQrGCuqud8zB/6rv7BiEpjbSULvh9Kl/ViLmm3A7swsAI5oDGjd6SpxOcNLM
         LgtaZjk6t7YNXKZciPZxFxM3MAyqMJqMESmyERRk+9cMIXZG/MLVov8LnkQcGIh6S6s+
         kAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A4RSUNn47cQJvhtlF1zsYGP+exS0+A4natS/qw0bQ90=;
        b=Kf4nkIhoS3HpiJogiHt5FISGYf+0Xg2Vz4SC2Lhlfg2YnzIyUnP//LiRj6pqtOsCYX
         6uVTcYztebYAWRrpq12144dGAjoGo/QMOBwM0qU/kVclABYeysnfe44+D8XmsGrftm8e
         iUwvl5a1FHGnYWGy9DBfJdjRr999pCDjf0A8DMa0bPA/csrlJgHzu/7qJ/mOt2b8GRs0
         p3Bl1N2pQ/hgSBFywY5hJLb1WuU/VVfbw6RGaQvIj3luPmTwimCnMCFugkD7/OD8qiIa
         JiubSinzIxboPt6UHGTXYwk6ZYO1atrws89zP0/nIbq31KGddv555IGMMAW8iYKPh2M+
         +i5Q==
X-Gm-Message-State: AOAM532AH/kRDQql9FUshlmwF1UZzFltzOy5EVXA6XKkoidV5stqyN0n
        g/Siy7haMx3UinGRnosXyUcGokn2XS+p9BxfCGU=
X-Google-Smtp-Source: ABdhPJzFzwHRFWloIx9dUYpABboO7+gsxGhvuHCOCiX900C5C1SWuNwW6QgYfCnHdYZZaNWgmuWN0OTvGPxV9tJkwI0=
X-Received: by 2002:a1c:a958:: with SMTP id s85mr3163722wme.138.1615980102695;
 Wed, 17 Mar 2021 04:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210315142736.7232-1-noltari@gmail.com> <20210315142736.7232-2-noltari@gmail.com>
 <20210315212822.dibkci35efm5kgpy@skbuf> <CDD9C1C6-AC7D-41C8-B2AF-6E84794F8C6B@gmail.com>
In-Reply-To: <CDD9C1C6-AC7D-41C8-B2AF-6E84794F8C6B@gmail.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Wed, 17 Mar 2021 12:21:41 +0100
Message-ID: <CAOiHx==n9BkwO210r9Pqndwg4PjDSTnUXrdR034BNP2tgObFvQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_brcm: add support for legacy tags
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 at 10:16, =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gma=
il.com> wrote:
>
> Hi Vladimir,
>
> > El 15 mar 2021, a las 22:28, Vladimir Oltean <olteanv@gmail.com> escrib=
i=C3=B3:
> >
> > On Mon, Mar 15, 2021 at 03:27:35PM +0100, =C3=81lvaro Fern=C3=A1ndez Ro=
jas wrote:
> >> Add support for legacy Broadcom tags, which are similar to DSA_TAG_PRO=
TO_BRCM.
> >> These tags are used on BCM5325, BCM5365 and BCM63xx switches.
> >>
> >> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> >> ---
> >> include/net/dsa.h  |  2 +
> >> net/dsa/Kconfig    |  7 ++++
> >> net/dsa/tag_brcm.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++
> >> 3 files changed, 105 insertions(+)
> >>
> >> diff --git a/include/net/dsa.h b/include/net/dsa.h
> >> index 83a933e563fe..dac303edd33d 100644
> >> --- a/include/net/dsa.h
> >> +++ b/include/net/dsa.h
> >> @@ -49,10 +49,12 @@ struct phylink_link_state;
> >> #define DSA_TAG_PROTO_XRS700X_VALUE          19
> >> #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE     20
> >> #define DSA_TAG_PROTO_SEVILLE_VALUE          21
> >> +#define DSA_TAG_PROTO_BRCM_LEGACY_VALUE             22
> >>
> >> enum dsa_tag_protocol {
> >>      DSA_TAG_PROTO_NONE              =3D DSA_TAG_PROTO_NONE_VALUE,
> >>      DSA_TAG_PROTO_BRCM              =3D DSA_TAG_PROTO_BRCM_VALUE,
> >> +    DSA_TAG_PROTO_BRCM_LEGACY       =3D DSA_TAG_PROTO_BRCM_LEGACY_VAL=
UE,
> >
> > Is there no better qualifier for this tagging protocol name than "legac=
y"?
>
> It=E2=80=99s always referred to as =E2=80=9Clegacy=E2=80=9D, so that=E2=
=80=99s what I used.
> Maybe @Florian can suggest a better name for this...

Broadcom refers to both as "the BRCM tag" or "the Broadcom Management
Header/Tag" in documentation with no versioning at all.

Codewise, the brcm963xx code names the old one BRCM_TAG and the newer
one BRCM_TAG_TYPE2. Not really better IMHO.

Maybe BRCM_OLD? less characters than Legacy, and doesn't need to be abbrevi=
ated.

To make matters worse, there seem to exist different versions of the
tag variants where some opcodes mean different things, e.g. BCM5325
might set the opcode to 1 for Multicast frames.

I would probably suggest enabling it only for switch models we
verified to be working with it.

On a different side node, should the dsa_tag_protocol be ordered
numerically, i.e. should DSA_TAG_PROTO_BRCM_PREPEND be the last one
since it is the highest with 22?

> >
> >>      DSA_TAG_PROTO_BRCM_PREPEND      =3D DSA_TAG_PROTO_BRCM_PREPEND_VA=
LUE,
> >>      DSA_TAG_PROTO_DSA               =3D DSA_TAG_PROTO_DSA_VALUE,
> >>      DSA_TAG_PROTO_EDSA              =3D DSA_TAG_PROTO_EDSA_VALUE,
> >> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> >> index 58b8fc82cd3c..aaf8a452fd5b 100644
> >> --- a/net/dsa/Kconfig
> >> +++ b/net/dsa/Kconfig
> >> @@ -48,6 +48,13 @@ config NET_DSA_TAG_BRCM
> >>        Say Y if you want to enable support for tagging frames for the
> >>        Broadcom switches which place the tag after the MAC source addr=
ess.
> >>
> >> +config NET_DSA_TAG_BRCM_LEGACY
> >> +    tristate "Tag driver for Broadcom legacy switches using in-frame =
headers"
> >
> > Aren't all headers in-frame?
>
> I copied that from NET_DSA_TAG_BRCM:
> https://github.com/torvalds/linux/blob/1df27313f50a57497c1faeb6a6ae4ca939=
c85a7d/net/dsa/Kconfig#L45
>
> Do you want me to change it to "Tag driver for Broadcom legacy switches=
=E2=80=9D or  =E2=80=9CLegacy tag driver for Broadcom switches"?

This means that the tag is inserted after the SRC/DST mac addresses,
in contrast to BRCM_PREPEND that gets prepended to the full frame.

> >> +    select NET_DSA_TAG_BRCM_COMMON
> >> +    help
> >> +      Say Y if you want to enable support for tagging frames for the
> >> +      Broadcom legacy switches which place the tag after the MAC sour=
ce
> >> +      address.
> >>
> >> config NET_DSA_TAG_BRCM_PREPEND
> >>      tristate "Tag driver for Broadcom switches using prepended header=
s"
> >> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> >> index e2577a7dcbca..9dbff771c9b3 100644
> >> --- a/net/dsa/tag_brcm.c
> >> +++ b/net/dsa/tag_brcm.c
> >> @@ -9,9 +9,23 @@
> >> #include <linux/etherdevice.h>
> >> #include <linux/list.h>
> >> #include <linux/slab.h>
> >> +#include <linux/types.h>
> >>
> >> #include "dsa_priv.h"
> >>
> >> +struct bcm_legacy_tag {
> >> +    uint16_t type;
> >> +#define BRCM_LEG_TYPE       0x8874
> >> +
> >> +    uint32_t tag;
> >> +#define BRCM_LEG_TAG_PORT_ID        (0xf)
> >> +#define BRCM_LEG_TAG_MULTICAST      (1 << 29)
> >> +#define BRCM_LEG_TAG_EGRESS (2 << 29)
> >> +#define BRCM_LEG_TAG_INGRESS        (3 << 29)
> >> +} __attribute__((packed));
> >> +
> >> +#define BRCM_LEG_TAG_LEN    sizeof(struct bcm_legacy_tag)
> >> +
> >
> > As Florian pointed out, tagging protocol parsing should be
> > endian-independent, and mapping a struct over the frame header is prett=
y
> > much not that.
>
> Ok, I will change that in v2.
>
> >
> >> /* This tag length is 4 bytes, older ones were 6 bytes, we do not
> >>  * handle them

You might want to update this comment, since you now handle them ;-)

Best Regards
Jonas
