Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B515552E0C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348472AbiFUJP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346120AbiFUJPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:15:25 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C57712610
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:15:24 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j21so8182918lfe.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iBZb8QF8anbqYzHGcPDDrRLJY5xZsGwi7V0oDGBrKac=;
        b=AQc7158zy5Ml9gDb+tE/k8bTnCfcB3WvyB862bgHd72Vg8hhgqJMbRrVW97nyoyZJB
         Irp9HZrE24jjCKypfsOdQToRJH27bRZ4lrX48bWo93HfxWJkE17DFNq9d4w7pm3geUVU
         44qYPnPz74iw0Fx/olfjhbE5pCrYf6tT311huGdtCX9KeZpQg7bQq45KLStWv6wCZJ7j
         hckpI/lRVWMJp0w9Eal6XZINA7zbSBfbde67P4xSiPf3G8ARhkITEn39KzCEhiJbOCBT
         b83krTDDF8YfTVAa4gNCCZ1PvPTzXqq67V5XdiSelWRK0MY03e1+hfo2EPNTw/Ci7qBR
         7jsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iBZb8QF8anbqYzHGcPDDrRLJY5xZsGwi7V0oDGBrKac=;
        b=SuGgRenhnO0D7qopLwBBPAo/UDndkM4mmCBy2lw3xcBcUXLuT7vd2dlAgPDPBiAEtX
         J/ODnkqLGNBGmspQXpaURoBwhfVWwM726lGVgK+99CcwHTEsKsfLGhrOBNMvxumoBWfk
         ZyY4VCBGinFHXOaLcl1HNaiVAHdpZA2rH6KAxmnSTdGX4hbv9oHnG+CpJ7zeMsfNY7C0
         775XGuPVfOfdAiQx1S1lnmE+iheHY2+CRtm7I4dyK0Gu+qJAvQRNhqX3OIWYiJkXSBT2
         1QoPLD+HHdKdLl76X0uZTdyiFflEM+i5zrnc/Lsbr3G8sukHICNSDiBQnQ7qQtcEpUqW
         0Isw==
X-Gm-Message-State: AJIora8VSnZ5+ZQsXOegGmFpb2G+Tt3PeLZeYsOXfhC1/m14EKif8PYH
        dkxHtvRHWcev2UeoDJ/kwaPpLW8FrCLaRXQA/gvTGw==
X-Google-Smtp-Source: AGRyM1uW8d7u8cI7kXh+CMZlVyClyT59mSUoZvq0jSTf6qOyFJEip/9qYb6o+e+gCLI+yZIYr5R/SN3olWCh1e7tyUw=
X-Received: by 2002:a05:6512:22d3:b0:47d:a6e4:4232 with SMTP id
 g19-20020a05651222d300b0047da6e44232mr16064548lfu.671.1655802921771; Tue, 21
 Jun 2022 02:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-12-mw@semihalf.com>
 <YrC2oV1FiRKwir6u@smile.fi.intel.com>
In-Reply-To: <YrC2oV1FiRKwir6u@smile.fi.intel.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 11:15:12 +0200
Message-ID: <CAPv3WKdYUZZAsF-7SzXfevexN8qzGJ0jqWRGM+522PHb0scQJg@mail.gmail.com>
Subject: Re: [net-next: PATCH 11/12] net: dsa: mv88e6xxx: switch to
 device_/fwnode_ APIs
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 20 cze 2022 o 20:04 Andy Shevchenko
<andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
>
> On Mon, Jun 20, 2022 at 05:02:24PM +0200, Marcin Wojtas wrote:
> > In order to support both ACPI and DT, modify the generic
> > DSA code to use device_/fwnode_ equivalent routines.
> > No functional change is introduced by this patch.
>
> ...
>
> > @@ -6962,16 +6963,16 @@ static int mv88e6xxx_probe(struct mdio_device *=
mdiodev)
> >       struct dsa_mv88e6xxx_pdata *pdata =3D mdiodev->dev.platform_data;
> >       const struct mv88e6xxx_info *compat_info =3D NULL;
> >       struct device *dev =3D &mdiodev->dev;
> > -     struct device_node *np =3D dev->of_node;
> > +     struct fwnode_handle *fwnode =3D dev->fwnode;
>
> Forgot to mention: dev_fwnode() or respective device_property_ API, pleas=
e.
>

I'll update changes to use the device_property_ API.

Thanks,
Marcin
