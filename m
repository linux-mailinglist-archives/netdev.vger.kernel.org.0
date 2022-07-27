Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AD3583150
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbiG0R4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbiG0R4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:56:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAFF9C279;
        Wed, 27 Jul 2022 10:01:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z22so22234564edd.6;
        Wed, 27 Jul 2022 10:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E87C+NlfCXvLpu0xuiimJX9d0y6Hhjgvfv+tefp2zBQ=;
        b=Cd4p940ZUF4xOgn2nYp6lHdne9lyf/AsO7bXQVzkOE/6TE/wm7RrHRkhYxn+adrUBm
         4kbvTIyTbwGLOZlMH0u1haSU8NLMrl4atnJe0uwWG3v58TBYpENxIp7JTdMAf6tlGZcd
         Y+/oKGiUcdcrPacY9Bt3mLErgIhKg38I4f3pIcIMCnNLd06qihxaO6rk0oTJ5rb/TxHU
         bnQt9ym4lP3lSBUV482yuecSHJxJJUwuAu4rw5cnKFuyO5cEsPaLb6NsWEmhMy6u+hAL
         dUtzr+yjWVgXmLCgZJ4wgxUXAv13Mnhwmn040Thkz6BjP4GcEITwTYfY1eIJWdHqvrn5
         9BaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E87C+NlfCXvLpu0xuiimJX9d0y6Hhjgvfv+tefp2zBQ=;
        b=LCIlCISNk7SU2k9TKyS5ov3QMrAFHYh/TkGKXBcO8LvxSrfssA9FZq3YOFRNCje049
         NAM2sHbWMHeedGwXABxplP3JD6K6+21jeXJ6NNjH7NqEwYHl/xCj4JKFrmhMYAGhH2un
         3EtdmsXIW1XdN9nkWRcTatd4gRWQuONrsSboOXDd+gLT/9usK0G8zYWqKv0UaXUnOUbS
         Vmp/Yhjz29mt6+ZniRKjkJt7mSWPe4FESFYtJpjKZBv9vPG2VyFedVgdC9oMZZlr1JMz
         r+/CsDy7tOdlwIQ8VLA0fBpv9EZhjYJZd8DKjoaBQN14GbxnfF6FZHAOp6cXztWH/q74
         oLOA==
X-Gm-Message-State: AJIora9r1E3/Oj8oX8p6/SxGlC3Sx7ef3T2Y6+mywDHdjfBBhwBYZLOA
        5B2x/jYrPCLxSi3m4V7OdseILCtaAQ6CSI238zY=
X-Google-Smtp-Source: AGRyM1t8/S9koTsfhnO7lR7P6+hZGiz8DclxfuSxow2UeYoZzjdOI0eIy57iEtDcw1iZGBwwH6kxynA9aXl8g8eJ814=
X-Received: by 2002:a05:6402:40c3:b0:43b:d65a:cbf7 with SMTP id
 z3-20020a05640240c300b0043bd65acbf7mr24290878edb.380.1658941258507; Wed, 27
 Jul 2022 10:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-1-mw@semihalf.com> <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf> <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
In-Reply-To: <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 27 Jul 2022 19:00:21 +0200
Message-ID: <CAHp75Vfn+tfuzxU31kVxp3sMAoT=ve3tcfDv84Omm-1tqvW3+w@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
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

On Wed, Jul 27, 2022 at 5:24 PM Marcin Wojtas <mw@semihalf.com> wrote:
> =C5=9Br., 27 lip 2022 o 16:31 Vladimir Oltean <olteanv@gmail.com> napisa=
=C5=82(a):
> > On Wed, Jul 27, 2022 at 08:43:19AM +0200, Marcin Wojtas wrote:

...

> > > +     dev =3D class_find_device(&net_class, NULL, fwnode, fwnode_find=
_parent_dev_match);
> >
> > This needs to maintain compatibility with DSA masters that have
> > dev->of_node but don't have dev->fwnode populated.
>
> Do you mean a situation analogous to what I addressed in:
> [net-next: PATCH v3 4/8] net: mvpp2: initialize port fwnode pointer
> ?
>
> I found indeed a couple of drivers that may require a similar change
> (e.g. dpaa2).
>
> IMO we have 2 options:
> - update these drivers

Not Vladimir here, but my 2cents that update is best and elegant, it
can be done even before this series.

--=20
With Best Regards,
Andy Shevchenko
