Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D30556E8F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359677AbiFVWef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 18:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359655AbiFVWec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 18:34:32 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4CB3FDAA
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:34:27 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i15so27836195ybp.1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKylA8pYtIvxwg5/dZiB/uZdIVVN/P980vi4sBmsa8g=;
        b=J4pi/aKDOGnb+AER5hiC/Ur9ZSPqxLhl9mnB71A7+WIlfY2oiT/T5y5JfIyXfOCApX
         pLilMQlV84wpeyWcdPvtM97nw68tnuZyysLqMtJ7DRRJ6ajeonNGzDXJprWOIg8xBf0y
         NTH6Wl1a1nlYUaFdI4qtAMzn8cW7xPEjL5f7QJ94kT2HJ1ci6OAaAPqD1UX+0NL/zHh7
         304JDEDsF/c/vE8OS7ScZ5S8psqurQ00bjxfdujGxOif8q+MEh1dX6y/brQOOJs5BypF
         iAv8odstd+qJJe5X1KPMo+1qvBAD62prH31qb5OR0/0XW3vKz526q1m+3AN2s9rHhIps
         PBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKylA8pYtIvxwg5/dZiB/uZdIVVN/P980vi4sBmsa8g=;
        b=aoQPhfCywIvNwGXdIQQ2j+sFaF1EGz/HvN2RJOcmAAr3bwc5CI2ygODhmtjuocMhf+
         3L6Fs9ufDPnUYZBLcSt6tU4bVQu1EqwegzgkMNerHqhbXyEgsHQW3K7qlHwyQLBeSFTJ
         wF8sixjBcaAWEWeOh20//4F4mRkjEHKVv4P5C5pAwnjO8vCxxrwo84xbeJqjmbna7cq7
         wb1/Uv4mR2RGk2SBXcxpOCCPTt0A7t9EVT/BU4cxIeeJXUVF0332m32Hxv4WhY0ZY7O+
         bbClE04JtYeyEsiV3aeydd33zWZQyT9fPHhYhYYsMg7s7cVs4OV3FK0AedfGEpT9aubM
         KNfg==
X-Gm-Message-State: AJIora8elJVcOweTd7/ru4u3a3Kd1u+V3d5RZfVfb9dJnYYzugR9STVE
        sk4Aw5w2r4WDPV6lpJitFiDbmt32MjCga2WbHclqKA==
X-Google-Smtp-Source: AGRyM1vtP8cTHTShZ6uWcl+OVMszNehOV5bCtDdbKW/msmtH+Wdf1HHxNjR1QJIjKUG41gGaaaYuCgB7moTXz8XY7EE=
X-Received: by 2002:a25:d112:0:b0:669:17:8d98 with SMTP id i18-20020a25d112000000b0066900178d98mr6124766ybg.447.1655937266678;
 Wed, 22 Jun 2022 15:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220622215912.550419-1-saravanak@google.com> <DU0PR04MB941733BFD323D3542B7F75A888B29@DU0PR04MB9417.eurprd04.prod.outlook.com>
In-Reply-To: <DU0PR04MB941733BFD323D3542B7F75A888B29@DU0PR04MB9417.eurprd04.prod.outlook.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 22 Jun 2022 15:33:50 -0700
Message-ID: <CAGETcx-h4iDx+WG+HnN0_ej0qtLOp66oOXvkppm060TRCG3_Jg@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Fix console probe delay due to fw_devlink
To:     Peng Fan <peng.fan@nxp.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, Sascha Hauer <sha@pengutronix.de>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 3:32 PM Peng Fan <peng.fan@nxp.com> wrote:
>
> > Subject: [PATCH v1 0/2] Fix console probe delay due to fw_devlink
> >
> > fw_devlink.strict=1 has been enabled by default. This was delaying the probe
> > of console devices. This series fixes that.
> >
> > Sasha/Peng,
> >
> > Can you test this please?
>
> Thanks, just give a test on i.MX8MP-EVK, works well now.
>
> Tested-by: Peng Fan <peng.fan@nxp.com> #i.MX8MP-EVK

Lol, that was quick! Thanks!

-Saravana

>
> Thanks,
> Peng.
>
> >
> > -Saravana
> >
> > Cc: Sascha Hauer <sha@pengutronix.de>
> > Cc: Peng Fan <peng.fan@nxp.com>
> > Cc: Kevin Hilman <khilman@kernel.org>
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: kernel-team@android.com
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-pm@vger.kernel.org
> > Cc: iommu@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-gpio@vger.kernel.org
> > Cc: kernel@pengutronix.de
> >
> > Saravana Kannan (2):
> >   driver core: fw_devlink: Allow firmware to mark devices as best effort
> >   of: base: Avoid console probe delay when fw_devlink.strict=1
> >
> >  drivers/base/core.c    | 3 ++-
> >  drivers/of/base.c      | 2 ++
> >  include/linux/fwnode.h | 4 ++++
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> >
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
>
