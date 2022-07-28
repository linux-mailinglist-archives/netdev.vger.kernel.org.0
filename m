Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA9B5845F4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiG1Sjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiG1Sja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:39:30 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A475D6E891;
        Thu, 28 Jul 2022 11:39:29 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id b67so2421657vsc.1;
        Thu, 28 Jul 2022 11:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fz0oK/sN+pADIj/VwoAHbt78SykQERFDb/zndg/n+o4=;
        b=PeR4v5FPPNZF2D9vedblyx4eKNARkMi4ujjFHfuLxJb/FnPdFaeKolrNgkgnb2UCo5
         XnchN+59ZDj3IMQc9l33LlEni3ecBzFgvitykuXcCAFgzA2UxhUDBxQNP/MV3Ochhnq1
         iacsoI653CprFyWvbrgQc385KXTJu18+RkDLAPp9MetIjEvUPajAYALWekEsKh7gyxl1
         qITNz+azSvawoHqa3EtrjPjwoJ8DxaQ4uje07c5Gu+Dm6Get7SZQG2WpEMZKlPRLyrg6
         FlMgHUJYPii7CaIMNP8GUxvtnjhWcJ6zwv9ZMNgbGpz/viUEZ9yrF7U4gJBfv51ug7s6
         5Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fz0oK/sN+pADIj/VwoAHbt78SykQERFDb/zndg/n+o4=;
        b=r1ZQgugmPZJpSoZ2ipCUWGw0XxgOVI/jB2jNNCf+1XigqRiEqC4V+V0liIMA1vCBZN
         CdRTIq46FdsVB2y/q1lznwsrsZqUB4B0PA1HXHkQafobxeRHzHdTxUxw1w87v5TWEguv
         vn5zw+oqz6OSY/O5Gn2BjApHxbeB+O2S64ivm2AN7JPAofzDHnpRA4GpAP7xniL1ShVh
         IiTE+CKYB4zJzQVSGAHcQTEjcf4r39cvPXI0EpYXIf2vLv55kip7asJTUPwpzBz50D/C
         XtHT2mPRJYtjeSCE+X1s+KsNr+oxHtk0rxmNImhdFOKKbEEOQYPDg/msV7TrUfVmdFLb
         BGog==
X-Gm-Message-State: AJIora+nA4Nc0EnHobeJ7QycxHp6hV8WU+pe9yy4OjDIH8TSPtJ5WGZn
        qka+RqBQxQ3YBHXB5I4KGUirrlld3xrBCIBakMU=
X-Google-Smtp-Source: AGRyM1timhPpruesbtrMQ8SdjHcmWAC5Ft3HORMPnH54f/WLe2VxnEiZP3MLhQbBUZQ5MItaMFgtQhXjhCIE1DS4U3Q=
X-Received: by 2002:a67:1a06:0:b0:358:418f:b8a1 with SMTP id
 a6-20020a671a06000000b00358418fb8a1mr37360vsa.56.1659033568631; Thu, 28 Jul
 2022 11:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220727153232.13359-1-matwey@sai.msu.ru> <5f0b98a5-1929-a78e-4d44-0bb2aec18b5a@redhat.com>
In-Reply-To: <5f0b98a5-1929-a78e-4d44-0bb2aec18b5a@redhat.com>
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date:   Thu, 28 Jul 2022 21:39:17 +0300
Message-ID: <CAJs94EYdNVROqDw=ZpzBTGeNRQzzCN9QQNkicv6LapJGDmb=Dg@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: pmc_atom: Add DMI quirk for Lex 3I380A/CW boards
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        carlo@endlessm.com, davem@davemloft.net, hkallweit1@gmail.com,
        js@sig21.net, linux-clk@vger.kernel.org,
        linux-wireless@vger.kernel.org, mturquette@baylibre.com,
        netdev@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        sboyd@kernel.org, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        paul.gortmaker@windriver.com, stable@vger.kernel.org
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

=D1=87=D1=82, 28 =D0=B8=D1=8E=D0=BB. 2022 =D0=B3. =D0=B2 21:33, Hans de Goe=
de <hdegoede@redhat.com>:
>
> Hi,
>
> On 7/27/22 17:32, Matwey V. Kornilov wrote:
> > Lex 3I380A/CW (Atom E3845) motherboards are equipped with dual Intel I2=
11
> > based 1Gbps copper ethernet:
> >
> >      http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf
> >
> > This patch is to fix the issue with broken "LAN2" port. Before the
> > patch, only one ethernet port is initialized:
> >
> >      igb 0000:01:00.0: added PHC on eth0
> >      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
> >      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
> >      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
> >      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queu=
e(s)
> >      igb: probe of 0000:02:00.0 failed with error -2
> >
> > With this patch, both ethernet ports are available:
> >
> >      igb 0000:01:00.0: added PHC on eth0
> >      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
> >      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
> >      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
> >      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queu=
e(s)
> >      igb 0000:02:00.0: added PHC on eth1
> >      igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
> >      igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
> >      igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
> >      igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queu=
e(s)
> >
> > The issue was observed at 3I380A board with BIOS version "A4 01/15/2016=
"
> > and 3I380CW board with BIOS version "A3 09/29/2014".
> >
> > Reference: https://lore.kernel.org/netdev/08c744e6-385b-8fcf-ecdf-1292b=
5869f94@redhat.com/
> > Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL"=
)
> > Cc: <stable@vger.kernel.org> # v4.19+
> > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
>
>
> Thank you for the patch.
>
> The last week I have received 2 different patches adding
> a total of 3 new "Lex BayTrail" entries to critclk_systems[]
> on top of the existing 2.
>
> Looking at: https://www.lex.com.tw/products/embedded-ipc-board/
> we can see that Lex BayTrail makes many embedded boards with
> multiple ethernet boards and none of their products are battery
> powered so we don't need to worry (too much) about power consumption
> when suspended.
>
> So instead of adding 3 new entries I've written a patch to
> simply disable the turning off of the clocks on all
> systems which have "Lex BayTrail" as their DMI sys_vendor:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x8=
6.git/commit/?h=3Dreview-hans&id=3Dc9d959fc32a5f9312282817052d8986614f2dc08
>
> I've added a Reported-by tag to give you credit for the work
> you have done on this.
>
> I will send this alternative fix to Linus as part of
> the other pdx86 patches for 5.21.

Thank you. Will your fix also appear in stable/lts kernels?

>
> Regards,
>
> Hans
>
>
>
>
> > ---
> >  drivers/platform/x86/pmc_atom.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc=
_atom.c
> > index b8b1ed1406de..5dc82667907b 100644
> > --- a/drivers/platform/x86/pmc_atom.c
> > +++ b/drivers/platform/x86/pmc_atom.c
> > @@ -388,6 +388,24 @@ static const struct dmi_system_id critclk_systems[=
] =3D {
> >                       DMI_MATCH(DMI_PRODUCT_NAME, "CEC10 Family"),
> >               },
> >       },
> > +     {
> > +             /* pmc_plt_clk* - are used for ethernet controllers */
> > +             .ident =3D "Lex 3I380A",
> > +             .callback =3D dmi_callback,
> > +             .matches =3D {
> > +                     DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
> > +                     DMI_MATCH(DMI_PRODUCT_NAME, "3I380A"),
> > +             },
> > +     },
> > +     {
> > +             /* pmc_plt_clk* - are used for ethernet controllers */
> > +             .ident =3D "Lex 3I380CW",
> > +             .callback =3D dmi_callback,
> > +             .matches =3D {
> > +                     DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
> > +                     DMI_MATCH(DMI_PRODUCT_NAME, "3I380CW"),
> > +             },
> > +     },
> >       {
> >               /* pmc_plt_clk0 - 3 are used for the 4 ethernet controlle=
rs */
> >               .ident =3D "Lex 3I380D",
>


--=20
With best regards,
Matwey V. Kornilov
