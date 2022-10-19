Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D796039FF
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiJSGq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJSGq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:46:26 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748A06E8BE;
        Tue, 18 Oct 2022 23:46:25 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id g11so11136345qts.1;
        Tue, 18 Oct 2022 23:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Yc/gLv7VbOxzOOe3FhYvFca+lsfjiloEeWONHysiSM=;
        b=sW1rdrLXpKq4ktS6lQm7jowd8sbv0jZd6wtOWCpVw1DcB54soZDxzkQJ52SURhoTtQ
         MdJAEgnPjaOMYlQUlBSpyXFZVAxpTb5ePzVIhSxJsCEgNnql1VLb99BfuFktLU+NgUdt
         0XVnZBlIf4MjMXt2dspJLAZAMSeKhssgTUPLP0HbG1mQTqkCpsqvoVDwVKrydIFITDEr
         WW2z+4f1HzatMavR4xdl/Osa54yp5oeUhb6ikRlgv3RVxCB5TVo5s6sRErQyTGrW2Kke
         Le7e6UqqGD40wJVImdifWES8FkMRMXdg5SGPuw4DlMi/IcXTGis82TjePDmqdWT9M3Yh
         axuQ==
X-Gm-Message-State: ACrzQf1v0KAIXbRncpuZD38Q9m7MkaVE/7o0tYUM6wxhJG3fXmeL9hbl
        oPhQKkBU0hP4XLlVfOQ9qBMinegTFObFRS+d
X-Google-Smtp-Source: AMsMyM4sFN/c5xk4crwFE7dx9WRdHD125FRExDC/A3KDWxCf6nPfD3xldHVtajNK6X/33GpJrRSeHQ==
X-Received: by 2002:ac8:5850:0:b0:39a:8ebf:5474 with SMTP id h16-20020ac85850000000b0039a8ebf5474mr5268626qth.466.1666161984386;
        Tue, 18 Oct 2022 23:46:24 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id q28-20020a05620a2a5c00b006eed14045f4sm4535987qkp.48.2022.10.18.23.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 23:46:24 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id 63so19693882ybq.4;
        Tue, 18 Oct 2022 23:46:23 -0700 (PDT)
X-Received: by 2002:a25:cd01:0:b0:6c2:6f0d:f4ce with SMTP id
 d1-20020a25cd01000000b006c26f0df4cemr5188600ybf.365.1666161983732; Tue, 18
 Oct 2022 23:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch> <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
 <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com> <Y08dECNbfMc3VUcG@lunn.ch>
 <595b7903-610f-b76a-5230-f2d8ad5400b4@seco.com> <AM0PR04MB39729CFDBB20C133C269275AEC2B9@AM0PR04MB3972.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB39729CFDBB20C133C269275AEC2B9@AM0PR04MB3972.eurprd04.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 19 Oct 2022 08:46:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUZKQFWV8QAKmwxuhWz0ZbFmcsUuf4OUzS_C31maP5+Yg@mail.gmail.com>
Message-ID: <CAMuHMdUZKQFWV8QAKmwxuhWz0ZbFmcsUuf4OUzS_C31maP5+Yg@mail.gmail.com>
Subject: Re: [PATCH net] net: fman: Use physical address for userspace interfaces
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>, Andrew Davis <afd@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Wed, Oct 19, 2022 at 7:20 AM Madalin Bucur <madalin.bucur@nxp.com> wrote:
> > -----Original Message-----
> > From: Sean Anderson <sean.anderson@seco.com>
> > Sent: 19 October 2022 00:47
> > To: Andrew Lunn <andrew@lunn.ch>; Andrew Davis <afd@ti.com>
> > Cc: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Madalin Bucur <madalin.bucur@nxp.com>;
> > Jakub Kicinski <kuba@kernel.org>; Eric Dumazet <edumazet@google.com>;
> > Paolo Abeni <pabeni@redhat.com>; Camelia Alexandra Groza
> > <camelia.groza@nxp.com>; Geert Uytterhoeven <geert@linux-m68k.org>
> > Subject: Re: [PATCH net] net: fman: Use physical address for userspace
> > interfaces
> >
> >
> >
> > On 10/18/22 5:39 PM, Andrew Lunn wrote:
> > > On Tue, Oct 18, 2022 at 01:33:55PM -0500, Andrew Davis wrote:
> > >> On 10/18/22 12:37 PM, Sean Anderson wrote:
> > >> > Hi Andrew,
> > >> >
> > >> > On 10/18/22 1:22 PM, Andrew Lunn wrote:
> > >> > > On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
> > >> > > > For whatever reason, the address of the MAC is exposed to
> > userspace in
> > >> > > > several places. We need to use the physical address for this
> > purpose to
> > >> > > > avoid leaking information about the kernel's memory layout, and
> > to keep
> > >> > > > backwards compatibility.
> > >> > >
> > >> > > How does this keep backwards compatibility? Whatever is in user
> > space
> > >> > > using this virtual address expects a virtual address. If it now
> > gets a
> > >> > > physical address it will probably do the wrong thing. Unless there
> > is
> > >> > > a one to one mapping, and you are exposing virtual addresses
> > anyway.
> > >> > >
> > >> > > If you are going to break backwards compatibility Maybe it would
> > be
> > >> > > better to return 0xdeadbeef? Or 0?
> > >> > >
> > >> > >         Andrew
> > >> > >
> > >> >
> > >> > The fixed commit was added in v6.1-rc1 and switched from physical to
> > >> > virtual. So this is effectively a partial revert to the previous
> > >> > behavior (but keeping the other changes). See [1] for discussion.
> > >
> > > Please don't assume a reviewer has seen the previous
> > > discussion. Include the background in the commit message to help such
> > > reviewers.

> > >> I see it asked in that thread, but not answered. Why are you exposing
> > >> "physical" addresses to userspace? There should be no reason for that.
> > >
> > > I don't see anything about needing physical or virtual address in the
> > > discussion, or i've missed it.
> >
> > Well, Madalin originally added this, so perhaps she has some insight.
> >
> > I have no idea why we set the IFMAP stuff, since that seems like it's for
> > PCMCIA. Not sure about sysfs either.
> >
> > > If nobody knows why it is needed, either use an obfusticated value, or
> > > remove it all together. If somebody/something does need it, they will
> > > report the regression.
> >
> > I'd rather apply this (or v2 of this) and then remove the "feature" in
> > follow-up.
> >
> > --Sean
>
>
> root@localhost:~# grep 1ae /etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules
> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae0000", NAME="fm1-mac1"
> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae2000", NAME="fm1-mac2"
> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae4000", NAME="fm1-mac3"
> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae6000", NAME="fm1-mac4"
> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae8000", NAME="fm1-mac5"
> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1aea000", NAME="fm1-mac6"

So you rely on the physical address.
It's a pity this uses a custom sysfs file.
Can't you obtain this information some other way?
Anyway, as this is in use, it became part of the ABI.

> root@localhost:~# grep 1ae  /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@*/net/fm1-mac*/device_addr
> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@2/net/fm1-mac3/device_addr:1ae4000
> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@3/net/fm1-mac4/device_addr:1ae6000
> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@4/net/fm1-mac5/device_addr:1ae8000
> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@5/net/fm1-mac6/device_addr:1aea000


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
