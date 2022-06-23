Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2843558787
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiFWS3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiFWS3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:29:08 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEF080534
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:30:53 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-318889e6a2cso1104357b3.1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOXrqOWcfMdTsdtXrpYVXi48JcFuUmjoexhlnfOOTGg=;
        b=L4dJOWUZH8Ao72MwmMu0hlQebn/kw9JPayp5sizpod+mvJoa+Jk2c12U6dtGJw0ocL
         FY0ahsSAadsHrWKiB46J+rcLToO2J7UvF9dIoPD0dwYD6fCgiC2WdrEctFh7m2vONz1A
         i5kKXCDjiPHGInQZUAkTQeJKWzgc8xBF9HzM08vnWaL+MuxZ5JvD3IF2Be6NowkMVSgg
         S+ucsFZ/JWQdteDBkGi0njXsklqZaAIz/FkVYezBWUTLcJOSi+wYLYWfkqidiVZs/Mft
         8KjS3VdHIM1qyN71zTYrpDaez/WAciLANIBuy1v8KewlMSrgXXmZL/60tdhF7JlBxcPw
         T2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOXrqOWcfMdTsdtXrpYVXi48JcFuUmjoexhlnfOOTGg=;
        b=TePNkqAs0NmnuLN0JV/XnxaKJWpoA7sWlursCAWWI4Ea7WcLpvBOqYo1B4wFrHqJaR
         cwppdhIC6ecUgzJTLl/ZTdr/RWeXLIjd2MUcEgDpnMNPOUmZyOruBoHQuEVXiwFUNvZx
         20wvdyvK90r/n7IXTFK9czrlsUAsLgC3YU5B9/PMEEFPasf13AjxpKBwXEGOk6ocRt0B
         +nrddlPHqyo7rZ7ya1H0ChmspncmGkISUWCvlYZo850YOGAT6r1jMLvHpMvbugU43cbN
         ZZSoCbJxzK/LEgtafKvO0bdOzRX8nyAMxTgMQtpV8KYR42HP8nURdL8UZYVfbnR64Y1k
         f8Vw==
X-Gm-Message-State: AJIora/X5gaH9gyDyPsUS7x7WR5fdAg75VqU86TDrU/sOSAzn8coFWLV
        9vSdi7PcyCTD981n0ufV1GURtwSFldixybjJ2thXNA==
X-Google-Smtp-Source: AGRyM1ul3O6ILFZqI77UreHIjC0wH+ddqVeLDfmwfl1PMnWdistPwRhbAXTfwUjlgyKKpmHDt2j86FuzSHATEelndGs=
X-Received: by 2002:a0d:dfd5:0:b0:317:f0d4:505b with SMTP id
 i204-20020a0ddfd5000000b00317f0d4505bmr11413939ywe.518.1656005452363; Thu, 23
 Jun 2022 10:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com> <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de> <YrSXKkYfr+Hinsuu@smile.fi.intel.com>
In-Reply-To: <YrSXKkYfr+Hinsuu@smile.fi.intel.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 23 Jun 2022 10:30:16 -0700
Message-ID: <CAGETcx8axPpXFv9Cc59nWrgW9_fYqZUYmNPUg83CTHTBZDC-ZA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when fw_devlink.strict=1
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     sascha hauer <sha@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
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

On Thu, Jun 23, 2022 at 9:39 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, Jun 23, 2022 at 12:04:21PM +0200, sascha hauer wrote:
> > On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
>
> ...
>
> > I wonder if it wouldn't be a better approach to just probe all devices
> > and record the device(node) they are waiting on. Then you know that you
> > don't need to probe them again until the device they are waiting for
> > is available.
>
> There may be no device, but resource. And we become again to the something like
> deferred probe ugly hack.
>
> The real solution is to rework device driver model in the kernel that it will
> create a graph of dependencies and then simply follow it. But actually it should
> be more than 1 graph, because there are resources and there are power, clock and
> resets that may be orthogonal to the higher dependencies (like driver X provides
> a resource to driver Y).

We already do this with fw_devlink for DT based systems and we do
effectively just probe the devices in graph order (by deferring any
attempts that happen too early and before it even gets to the driver).
The problem is the knowledge of what's considered an optional vs
mandatory dependency and that's affected by the global state of driver
support in the kernel.

-Saravana
