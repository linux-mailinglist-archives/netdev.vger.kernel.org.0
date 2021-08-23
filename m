Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C0A3F504D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhHWSXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhHWSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 14:23:51 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD0EC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 11:23:08 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id j13so14715139ybj.9
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 11:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rukoF0zTAyPgRjsb/qETsAXh6HDn8z2HPuAWUcpMQpw=;
        b=mrRHQszk4xM/P0iqPOgIvzHk9Gi79/0pgATlZnfPGDvzxyVjOuDAzTGWx2032SoaZN
         h0ILJaEukh+Jswu65Fn+bOFsV40J9CeZkSjhLr/C96wRAK+7XGkP7ULhInEZcHuj4/q7
         AQM0+2tatgJ0VZu2EuQR5AcGZn3CIrLSMRq+0Ja4L+8azEnIHTXDNn0kQIWOqJDqQiLI
         QH66OIKdJicFgCoGAWLnzR6JXD6qMjQLOvG/YjctJOrPpywQqldUASRaXoTC8SQsrqpe
         0XkMnm7ujPcD7C0mEu35y2JkjBqw5Pc/Xejsaw6mK6iXWiplXQLe7OSUZqgE/gD+HL7E
         2mAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rukoF0zTAyPgRjsb/qETsAXh6HDn8z2HPuAWUcpMQpw=;
        b=hgsTOeOfIZBCVNI24DWShk3n2XwLuixOI4BQxoeWml7sMZAeXxjtXZMO4Xj6Dqisqs
         2FnPzixLhf3RFUqdiHepzrWKNouXYJ53/gK43IumOL6B4NuIaphBmeolLc/Ehibb8JYX
         GYQxEINrQ9BQiJTPSryNC/BDB+wKc4WwUa+9Y/G1F/BXV8FGmX79HY/iuDdTz68+7Qof
         EjUeVFjN0YFLvo72Nq1tFiWZR75ZxyqQeqkfKiYj3Nktp8NOD9MdyCH0LUmYobcTK6+N
         RuAwlttllGNh0VkVE17OX/B2scX678BUEoa+SFghrIHIjBkvAfJlFFjSCMu29ycyF1CN
         l6pg==
X-Gm-Message-State: AOAM530SIPRT96Dx6K0OuVa8jm+qikyIaTf2M57WRx70CQVuHm5sOxtU
        F8XE4cjFVQPsaabMkH7WvXOzOlGZxZsx9VxtrQhHkg==
X-Google-Smtp-Source: ABdhPJz/GExcyseR2MWqjTeotuxEd+SktGcaeLmh0s2UAgoTjDdqIDVWpDLD4AKnPaMocG9V7d1xGoW8yzA5XBnFcjg=
X-Received: by 2002:a25:c64f:: with SMTP id k76mr45962791ybf.412.1629742987747;
 Mon, 23 Aug 2021 11:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com> <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
In-Reply-To: <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 23 Aug 2021 11:22:31 -0700
Message-ID: <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for "phy-handle" property
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 5:08 AM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi,
>
> On 18.08.2021 04:17, Saravana Kannan wrote:
> > Allows tracking dependencies between Ethernet PHYs and their consumers.
> >
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>
> This patch landed recently in linux-next as commit cf4b94c8530d ("of:
> property: fw_devlink: Add support for "phy-handle" property"). It breaks
> ethernet operation on my Amlogic-based ARM64 boards: Odroid C4
> (arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts) and N2
> (meson-g12b-odroid-n2.dts) as well as Khadas VIM3/VIM3l
> (meson-g12b-a311d-khadas-vim3.dts and meson-sm1-khadas-vim3l.dts).
>
> In case of OdroidC4 I see the following entries in the
> /sys/kernel/debug/devices_deferred:
>
> ff64c000.mdio-multiplexer
> ff3f0000.ethernet
>
> Let me know if there is anything I can check to help debugging this issue.

I'm fairly certain you are hitting this issue because the PHY device
doesn't have a compatible property. And so the device link dependency
is propagated up to the mdio bus. But busses as suppliers aren't good
because busses never "probe".

PHY seems to be one of those cases where it's okay to have the
compatible property but also okay to not have it. You can confirm my
theory by checking for the list of suppliers under
ff64c000.mdio-multiplexer. You'd see mdio@0 (ext_mdio) and if you look
at the "status" file under the folder it should be "dormant". If you
add a compatible property that fits the formats a PHY node can have,
that should also fix your issue (not the solution though).

I'll send out a fix this week (once you confirm my analysis). Thanks
for reporting it.

-Saravana

>
> > ---
> > v1 -> v2:
> > - Fixed patch to address my misunderstanding of how PHYs get
> >    initialized.
> >
> >   drivers/of/property.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > index 931340329414..0c0dc2e369c0 100644
> > --- a/drivers/of/property.c
> > +++ b/drivers/of/property.c
> > @@ -1291,6 +1291,7 @@ DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
> >   DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
> >   DEFINE_SIMPLE_PROP(leds, "leds", NULL)
> >   DEFINE_SIMPLE_PROP(backlight, "backlight", NULL)
> > +DEFINE_SIMPLE_PROP(phy_handle, "phy-handle", NULL)
> >   DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
> >   DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> >
> > @@ -1379,6 +1380,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
> >       { .parse_prop = parse_resets, },
> >       { .parse_prop = parse_leds, },
> >       { .parse_prop = parse_backlight, },
> > +     { .parse_prop = parse_phy_handle, },
> >       { .parse_prop = parse_gpio_compat, },
> >       { .parse_prop = parse_interrupts, },
> >       { .parse_prop = parse_regulators, },
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
