Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD55A6C72C3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 23:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjCWWKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 18:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWWKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 18:10:39 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0094412041;
        Thu, 23 Mar 2023 15:10:37 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i6so106988ybu.8;
        Thu, 23 Mar 2023 15:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679609437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8vsavJG+RgT33uxtPx++LM7UEDwAqJfHwUrJvTUunU=;
        b=Lf5glpliCsP/lPr3ZBLTXC6ACDbupl9UEtUD81Yn4oPMj7MENFeUB/Dz1sn9DYws29
         7GdPhhNTIoVm2MO1hC7nxpl+zpjaKM67Jc0QG6UiR08PO0f8tGYENjgfxw99og9qP3v4
         PhBjtpHduoARGAgryfISb3FqVVpIkUyONP0oureTChrwkcSrXM7MRwZCNAQW6cwYO5cL
         ay6ozddS6oFCGGbJGbA6xLn3cKMHrrjEZ3AKJmNC+iQyIZmAIYipIXbhTaQuXT71bOAQ
         Gj+Q3NPTyw+3iQUBM51UqRxZYIU87ZxiKUfsRwewfIFFwI9k8QoipseNDTYzqv0g5Oww
         FJuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A8vsavJG+RgT33uxtPx++LM7UEDwAqJfHwUrJvTUunU=;
        b=whI4paSyVAxjMX7LZ+ScTVMLQK75PhjmzmWVjz0MOCrSrBklpWDuVqytmoX1MIL673
         drl8nkBCZJG9zmm6JimV9/8C7DMLuv3rswBCj80LZx2VynfeLjm9IUJI1tzlQ9e/UBK2
         OW5/BwxY4FzrJstqcRPm0d7sSIKPSSscVbLAA2zvHOhDI2gYTXLKodl/vD59rjiyCp1r
         ClLT12D8kd+hXiyAU8fkNnhjc4nVPWUAqw5op3HipDpR2XYL7Ku4f+wM940XRuN+2vmR
         JID710BrBgqb3BDMDUNVBnNIYs5Hjw2Q/orfqWhpjWURi0NWQp5sVPrkOsvxJKs34ZT2
         m5Kw==
X-Gm-Message-State: AAQBX9dUOjFUx3PM/cYmyBW77xb3eheQko1nUsyXNjgjGGlSTXjuSDj+
        omsHEjiGW4uVDJ6U6kvDJPAjWkNMV6gw1V/2YlQ=
X-Google-Smtp-Source: AKy350Zvsz/raC6rGX30uPPovUGqtcV3BwPNh/o+fYpVlZMOg4svVVjaHfPQKU9BP38rTPWqCQK9Q63h46FQ4uoisi4=
X-Received: by 2002:a05:6902:1201:b0:b6c:4d60:1bd6 with SMTP id
 s1-20020a056902120100b00b6c4d601bd6mr74622ybu.9.1679609437086; Thu, 23 Mar
 2023 15:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230323121804.2249605-1-noltari@gmail.com> <AM0PR02MB552462D79D12B21CAC00A465BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
In-Reply-To: <AM0PR02MB552462D79D12B21CAC00A465BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Thu, 23 Mar 2023 23:10:26 +0100
Message-ID: <CAKR-sGePQFH0dc583S6dec1oJ_0vtBr-5mTAXrR_Dh=CWfECeA@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: dsa: b53: mdio: add support for BCM53134
To:     Paul Geurts <paul.geurts@prodrive-technologies.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El jue, 23 mar 2023 a las 20:58, Paul Geurts
(<paul.geurts@prodrive-technologies.com>) escribi=C3=B3:
>
> > -----Original Message-----
> > From: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > Sent: donderdag 23 maart 2023 13:18
> > To: Paul Geurts <paul.geurts@prodrive-technologies.com>;
> > f.fainelli@gmail.com; jonas.gorski@gmail.com; andrew@lunn.ch;
> > olteanv@gmail.com; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; robh+dt@kernel.org;
> > krzysztof.kozlowski+dt@linaro.org; netdev@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > Subject: [PATCH 0/2] net: dsa: b53: mdio: add support for BCM53134
> >
> > This is based on the initial work from Paul Geurts that was sent to the
> > incorrect linux development lists and recipients.
> > I've modified it by removing BCM53134_DEVICE_ID from is531x5() and
> > therefore adding is53134() where needed.
> > I also added a separate RGMII handling block for is53134() since accord=
ing to
> > Paul, BCM53134 doesn't support RGMII_CTRL_TIMING_SEL as opposed to
> > is531x5().
> >
> > Paul Geurts (1):
> >   net: dsa: b53: mdio: add support for BCM53134
> >
> > =C3=81lvaro Fern=C3=A1ndez Rojas (1):
> >   dt-bindings: net: dsa: b53: add BCM53134 support
> >
> >  .../devicetree/bindings/net/dsa/brcm,b53.yaml |  1 +
> >  drivers/net/dsa/b53/b53_common.c              | 53 ++++++++++++++++++-
> >  drivers/net/dsa/b53/b53_mdio.c                |  5 +-
> >  drivers/net/dsa/b53/b53_priv.h                |  9 +++-
> >  4 files changed, 65 insertions(+), 3 deletions(-)
> >
> > --
> > 2.30.2
>
> Thank you for resending my patches! I didn't get to it yet. Any particula=
r reason you didn't include the optional GPIO patch I had in my set?

I'm using it for a Sercomm H500-s which doesn't seem to need it.
However, I've just realized that it's documented here as GPIO 18:
https://openwrt.org/toh/sercomm/h500-s#other
Anyway, I think that the GPIO patch can be added later...

> ---
> Paul

--
=C3=81lvaro
