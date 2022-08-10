Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3226B58EB9F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiHJMAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiHJMAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:00:33 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8C438C
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:00:32 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1168e046c85so7702183fac.13
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UgcWN4Q61abHY5IcIHG4/knh5H3ZbN4qTX7UIuKnyuY=;
        b=ZVCTIhuNeqFrJqEpZf0Y0HyxIAviSOcPy2pdqq1hsUpbzzeXA2bVOLeBHf70rQsNqW
         kXdNfK8mPBbxjGso3AOcsrCirsTDF2Afr8naZCj6+H8N/BxCGNDoR+JYo4ERiUNAzBcs
         UrAWwj/WUaNg8GQcvRT/tJI67zXbKGKu2oPAXPb9/NFepcj83Ldz1Zapr2cdlTQZmrEz
         5En8d1bu0de+Lla+IFqMScAExkexkwoj5lrD3m3/LvY1FOBapZNaOE6hrTm4KbPVwADT
         F6IiAUgQvwRbSICEnseUzQnB2ltk5fZ2HlMGtI/3D5nQi+GVllWNd8JCA9Og/ZxuvT5h
         kRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UgcWN4Q61abHY5IcIHG4/knh5H3ZbN4qTX7UIuKnyuY=;
        b=g+OJF6vJ17mPGpnQqtuoVoCQRu/lakXHDtYedTPBhSxeswDyhL5w+MU9oCPFONkSSr
         0xXLHRFlqIbPWbl0IdbOugONNerrxmL5dGyRRfcuCsXmtgBzxhFkLZeiqnAnNKBvQ1re
         o6FK6x+wY321CvoMPC3GtwAS0PTLwC0fUn92yGHcZl71xuQHife0qRwYZufTohiEfPoe
         FOChOUVjm8ihXRol3iItX6ns3PhVWewXLj4coN3VB+HdwPES0+lb/SiKsbrvgXo8/a64
         lg6SQWn4L/3Kjr+hZf8MkjSA+jDjmlUBNqsvt3dftaeiN6R8bzVt3YjNxu6RkLbbhkRB
         +H4w==
X-Gm-Message-State: ACgBeo0VjGi/GeXJ/Dz9tQQkcPNgk+yCkm04zOP6fdsctXdIU5qmtWmw
        yHGrD+PUxjCpt3+pdn7MnepI+nu51f76crH8P91bFuMbQdkPguzl
X-Google-Smtp-Source: AA6agR5pPHBfMX8QKUfRNZYDoJ17XGiNmwhhDnaJfbGjWECvmmkFRXhWFeoKc6dIRNU4t8Sj42WYN8gaqkXhLezQIKY=
X-Received: by 2002:a05:6870:210b:b0:101:cb62:8ccc with SMTP id
 f11-20020a056870210b00b00101cb628cccmr1335185oae.26.1660132831591; Wed, 10
 Aug 2022 05:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220810082745.1466895-1-saproj@gmail.com> <20220810100818.greurtz6csgnfggv@skbuf>
In-Reply-To: <20220810100818.greurtz6csgnfggv@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 10 Aug 2022 15:00:20 +0300
Message-ID: <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
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

On Wed, 10 Aug 2022 at 13:08, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Sergei,
>
> On Wed, Aug 10, 2022 at 11:27:45AM +0300, Sergei Antonov wrote:
> > This driver sets the MaxFrameSize bit to 1 during setup,
> > see GLOBAL_CONTROL_MAX_FRAME_1536 in mv88e6060_setup_global().
> > Thus MTU is always 1536.
> > Introduce mv88e6060_port_max_mtu() to report it back to system.
> >
> > Signed-off-by: Sergei Antonov <saproj@gmail.com>
> > CC: Vladimir Oltean <olteanv@gmail.com>
> > CC: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  drivers/net/dsa/mv88e6060.c | 7 ++++++-
> >  drivers/net/dsa/mv88e6060.h | 1 +
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
> > index a4c6eb9a52d0..c53734379b96 100644
> > --- a/drivers/net/dsa/mv88e6060.c
> > +++ b/drivers/net/dsa/mv88e6060.c
> > @@ -160,7 +160,6 @@ static int mv88e6060_setup_addr(struct mv88e6060_priv *priv)
> >       u16 val;
> >
> >       eth_random_addr(addr);
> > -
>
> Extraneous change.

Thanks! My fault.

> >       val = addr[0] << 8 | addr[1];
> >
> >       /* The multicast bit is always transmitted as a zero, so the switch uses
> > @@ -212,6 +211,11 @@ static int mv88e6060_setup(struct dsa_switch *ds)
> >       return 0;
> >  }
> >
> > +static int mv88e6060_port_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +     return MV88E6060_MAX_MTU;
> > +}
>
> Does this solve any problem? It's ok for the hardware MTU to be higher
> than advertised. The problem is when the hardware doesn't accept what
> the stack thinks it should.

I need some time to reconstruct the problem. IIRC there was an attempt
to set MTU 1504 (1500 + a switch overhead), but can not reproduce it
at the moment.

> > +
> >  static int mv88e6060_port_to_phy_addr(int port)
> >  {
> >       if (port >= 0 && port < MV88E6060_PORTS)
> > @@ -247,6 +251,7 @@ mv88e6060_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
> >  static const struct dsa_switch_ops mv88e6060_switch_ops = {
> >       .get_tag_protocol = mv88e6060_get_tag_protocol,
> >       .setup          = mv88e6060_setup,
> > +     .port_max_mtu   = mv88e6060_port_max_mtu,
> >       .phy_read       = mv88e6060_phy_read,
> >       .phy_write      = mv88e6060_phy_write,
> >  };
> > diff --git a/drivers/net/dsa/mv88e6060.h b/drivers/net/dsa/mv88e6060.h
> > index 6c13c2421b64..382fe462fb2d 100644
> > --- a/drivers/net/dsa/mv88e6060.h
> > +++ b/drivers/net/dsa/mv88e6060.h
> > @@ -11,6 +11,7 @@
> >  #define __MV88E6060_H
> >
> >  #define MV88E6060_PORTS      6
> > +#define MV88E6060_MAX_MTU    1536
> >
> >  #define REG_PORT(p)          (0x8 + (p))
> >  #define PORT_STATUS          0x00
> > --
> > 2.32.0
> >
>
> You're the first person to submit a patch on mv88e6060 that I see.
> Is there a board with this switch available somewhere? Does the driver
> still work?

Very nice to get your feedback. Because, yes, I am working with a
device which has mv88e6060, it is called MOXA NPort 6610.

The driver works now. There was one problem which I had to workaround.
Inside my device only ports 2 and 5 are used, so I initially wrote in
.dts:
        switch@0 {
                compatible = "marvell,mv88e6060";
                reg = <16>;

                ports {
                        #address-cells = <1>;
                        #size-cells = <0>;

                        port@2 {
                                reg = <2>;
                                label = "lan2";
                        };

                        port@5 {
                                reg = <5>;
                                label = "cpu";
                                ethernet = <&mac1>;
                        };
                };
        };
and the driver crashed in mv88e6060_setup_port() on a null pointer.
Two workarounds are possible:
1. Describe ports 0, 1, 3, 4 in .dts too.
2. Insert this code at the beginning of mv88e6060_setup_port():
if(!dsa_is_cpu_port(priv->ds, p) && !dsa_to_port(priv->ds, p)->cpu_dp)
    return 0;
'cpu_dp' was the null pointer the driver crashed at.

One more observation. Generating and setting a random MAC in
mv88e6060_setup_addr() is not necessary - the switch works without it
(at least in my case).
