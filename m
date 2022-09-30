Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39BA5F1416
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiI3Usq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiI3UsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:48:21 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C260F63FE4;
        Fri, 30 Sep 2022 13:48:19 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id m65so6036444vsc.1;
        Fri, 30 Sep 2022 13:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=yuwnQTGE5wlnDoxgDugIzpWfH4VN4qTBEvv2cRmKUZQ=;
        b=J05VDP7U/IeQr2Jwd49cOEc4ys00gaF+weYFKup8w3ePORrCJaWy+25982lhkjpFZT
         UYmWHVrnJHC9lA3pg9GCxXEFrI9TFmlluCv4oePRO227DqoSWxADGb9wfTSJCUM03Lpy
         c8dyCM37fVP41mjX0Q66/IoX1eiN61Or8pnHmeWIaW694XE2AEsktEii8mnRL8vrKc7L
         iHdMtY6/iIApIh1YX3qscTaIrcLTW58JoiNRT7/d3e/gMIE5CFEWLH/WRMog4wy0vpIS
         qvZnrXLJTS3a0uRBsWDRKPMQe3dm71LbgPAQjiW+s+SrSkemqkxnC6ZqlzIYnAlMkbsE
         lRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yuwnQTGE5wlnDoxgDugIzpWfH4VN4qTBEvv2cRmKUZQ=;
        b=TJJ32OAphSSIAjMJS2LukGPz2ykQDuaAgbKq5byXBUnTqKm6t2/AxzcCmHpvZH/Ro8
         vJoQsnrXmKWWPKr84H9UY7MxN8iDLCLyCTTY1w1sqJ1PPGSucMeutpOchat0b234cR9b
         WHDgE2GKv4hM+JDudgzNEkM/vVznUmwh5dQvrxSOBxLQ2eLmf0QmPNy4ap/GHnw9Gprn
         HlCWNuQkpGS7ATJPjAQQ8dyqb/CwoaNHlSgA/Q7FWqA4kfTw+GORpne0lm58pnJ2FXh1
         B5O2enaKsA73NKUaaB93DJQPDp1rBCywwnjNMsWj4lUPSEy296tYQHmNvhvf812x/7Cm
         BQPg==
X-Gm-Message-State: ACrzQf1Op9EJgrLoxkxBNDNGEHlqFXRS6v+k2JIPR9upy7f62qoeXvV5
        Z0EM5n8YUPyMFgxbI57DUYhESBfnhuApufLaInM=
X-Google-Smtp-Source: AMsMyM4uu3nAiRF/NdMKAKSdsaJTQhWYKyWb/zYfUZD+5WSQgSlUXEjwykp6umKbQeil0h+8RLSGk2fGmSmA7J7JDug=
X-Received: by 2002:a67:b848:0:b0:3a5:bdb6:d6a8 with SMTP id
 o8-20020a67b848000000b003a5bdb6d6a8mr4948554vsh.52.1664570898871; Fri, 30 Sep
 2022 13:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220930194923.954551-1-mmyangfl@gmail.com> <YzdRdC1qgZY+8gQk@lunn.ch>
In-Reply-To: <YzdRdC1qgZY+8gQk@lunn.ch>
From:   Yangfl <mmyangfl@gmail.com>
Date:   Sat, 1 Oct 2022 04:47:42 +0800
Message-ID: <CAAXyoMNmf7YMPZYqimxJMo6W=Z-zMXHE9TjnB-SYNnpit8RV4g@mail.gmail.com>
Subject: Re: [PATCH] net: mv643xx_eth: support MII/GMII/RGMII modes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> =E4=BA=8E2022=E5=B9=B410=E6=9C=881=E6=97=A5=E5=
=91=A8=E5=85=AD 04:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Oct 01, 2022 at 03:49:23AM +0800, David Yang wrote:
> > On device reset all ports are automatically set to RGMII mode. MII
> > mode must be explicitly enabled.
> >
> > If SoC has two Ethernet controllers, by setting both of them into MII
> > mode, the first controller enters GMII mode, while the second
> > controller is effectively disabled. This requires configuring (and
> > maybe enabling) the second controller in the device tree, even though
> > it cannot be used.
> >
> > Signed-off-by: David Yang <mmyangfl@gmail.com>
> > ---
> >  drivers/net/ethernet/marvell/mv643xx_eth.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/e=
thernet/marvell/mv643xx_eth.c
> > index b6be0552a..e2216ce5e 100644
> > --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> > +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> > @@ -108,6 +108,7 @@ static char mv643xx_eth_driver_version[] =3D "1.4";
> >  #define TXQ_COMMAND                  0x0048
> >  #define TXQ_FIX_PRIO_CONF            0x004c
> >  #define PORT_SERIAL_CONTROL1         0x004c
> > +#define  RGMII_EN                    0x00000008
> >  #define  CLK125_BYPASS_EN            0x00000010
> >  #define TX_BW_RATE                   0x0050
> >  #define TX_BW_MTU                    0x0058
> > @@ -1245,6 +1246,21 @@ static void mv643xx_eth_adjust_link(struct net_d=
evice *dev)
> >
> >  out_write:
> >       wrlp(mp, PORT_SERIAL_CONTROL, pscr);
> > +
> > +     /* If two Ethernet controllers present in the SoC, MII modes foll=
ow the
> > +      * following matrix:
> > +      *
> > +      * Port0 Mode   Port1 Mode      Port0 RGMII_EN  Port1 RGMII_EN
> > +      * RGMII        RGMII           1               1
> > +      * RGMII        MII/MMII        1               0
> > +      * MII/MMII     RGMII           0               1
> > +      * GMII         N/A             0               0
> > +      *
> > +      * To enable GMII on Port 0, Port 1 must also disable RGMII_EN to=
o.
> > +      */
> > +     if (!phy_interface_is_rgmii(dev->phydev))
> > +             wrlp(mp, PORT_SERIAL_CONTROL1,
> > +                  rdlp(mp, PORT_SERIAL_CONTROL1) & ~RGMII_EN);
>
> I could be reading this wrong, but doesn't this break the third line:
>
> > +      * MII/MMII     RGMII           0               1
>
> Port 1 probes first, phy_interface is rgmii, so nothing happens, port1
> RGMII_EN is left true.
>
> Port 0 then probes, MII/MMII is not RGMII, so port1 RGMII_EN is
> cleared, breaking port1.
>
> I think you need to be more specific with the comparison.
>
>   Andrew

Oh, I see. So you mean "phy-mode" property should belong to
controller, not port? I thought one controller can have at most one
port.
