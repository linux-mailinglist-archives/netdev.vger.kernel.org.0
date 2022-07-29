Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0733584E74
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiG2KAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiG2KAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:00:06 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A50F3CBC4;
        Fri, 29 Jul 2022 03:00:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p5so5175283edi.12;
        Fri, 29 Jul 2022 03:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=F8cMzvkhyXMKKrJL4HV7iWQsiCgB3iVXXWwPTPW7oIU=;
        b=AgNSahQ21UQuNFBOAO5lkmuNaIWFqTOn8yPy9G6JAr2B3bsHWHmYOAH9WWpGmh7f7J
         wOXFIcECW85zg79JjH3eZJn2jgKtRChA6ph9tTzKFDDYYO6GmESmQYv7bIB/z1x4zln3
         Hc8ODB8HZiiGLcUix9BP9NRERrcwVAB3jChkc0jDC7k8terC76IJd7/YrSRyMOa/DE8e
         w9i5IRuHeoANK+6TMALLyox6ZS7SAD4qolb2Xt0F6rM9vHw2em34jGlKIu85Lhy8FESt
         V9nPZvZofM3ftmG4v38M+/EHtS+Q7dbowfi+H12X9c2jV50zpjdifHUpvGA3SxbSnbzu
         P3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=F8cMzvkhyXMKKrJL4HV7iWQsiCgB3iVXXWwPTPW7oIU=;
        b=XaUeKFJBrwPHM8zispYrIKi/Sp2A89FwCzp1bMJQpVp4yNiBvYamk/Bkj52XrHI0jP
         ae7wL5B6CtjVvJo1Xq+otLeFq78fs80cCVLeTcT10p2JJjyHevP9r8ckesAweGLT50Ny
         dNEb58bkFNyZy59wjdyXSyWoGQwb5hgRvrJ5PhrnBPs1MeIOpE/AT+LO8TmirBAqCh3y
         g2PQ7fKzdB6XWPefqMLKVDMbaENHcC1DDRW2HzggWLdkfW5w3163S/2f6GbR193xzUmi
         TaT9ruhSdP7RAWhmj+qI1MjOL4lHL/H1E9hXsBaCHxO86Gs4AMYpKqXyf3hcYj6ODwI0
         u+0g==
X-Gm-Message-State: AJIora/RFTaeKguXGF/pWmdYRYHDptjp5U6PRy6jI95VS3DHwluB2y11
        kxwNh6bEmefiD/fPsxIf7UklzgaMO4hrVeZSsZY=
X-Google-Smtp-Source: AGRyM1tzQ0rc7C26HZnE/M+YU4aI0xsjQDwS92N1L5ZCjqCDLmO279LxoDRplaJuYPaAN99qtPUJAiqoUAGTWSRixeY=
X-Received: by 2002:a05:6402:501d:b0:437:e000:a898 with SMTP id
 p29-20020a056402501d00b00437e000a898mr2800261eda.265.1659088802585; Fri, 29
 Jul 2022 03:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-7-mw@semihalf.com> <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf> <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <20220727211112.kcpbxbql3tw5q5sx@skbuf> <CAPv3WKcc2i6HsraP3OSrFY0YiBOAHwBPxJUErg_0p7mpGjn3Ug@mail.gmail.com>
 <20220728195607.co75o3k2ggjlszlw@skbuf> <YuLvFQiZP6qmWcME@lunn.ch>
 <CAPv3WKeD_ZXeH-Y_YP91Ba6nZagzBVPoWbmFE8WtRw-NYxdEaA@mail.gmail.com> <YuMLwlqfhQoaNh6K@lunn.ch>
In-Reply-To: <YuMLwlqfhQoaNh6K@lunn.ch>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 29 Jul 2022 11:59:22 +0200
Message-ID: <CAHp75VeV-pFJzam_42c1w7eESWhwnxsJ4eHX5wzwLCHjKC2neQ@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 12:29 AM Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Jul 28, 2022 at 11:23:31PM +0200, Marcin Wojtas wrote:

...

> ACPI and DT are different things, so i don't see why they need to
> share code.

Yes and no.

ACPI _DSD extension allows us to share a lot of code when it comes to
specific device properties (that are not standardized anyhow by ACPI
specification, and for the record many of them even may not, but some
are, like MIPI camera). Maybe you want to have something like a
property standard for DSA that can be published as MIPI or so and then
that part of the code of course may very well be shared. Discussed
MDIOSerialBus() resource type is pure ACPI thingy if going to be
standardized and indeed, that part can't be shared.

Entire exercise with fwnodes allows to make drivers (most of or most
of the parts of) to be shared between different resource providers.
And this is a cool part about it.

-- 
With Best Regards,
Andy Shevchenko
