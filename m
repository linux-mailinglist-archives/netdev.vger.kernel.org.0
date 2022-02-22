Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3824BF3BA
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiBVIef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiBVIee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:34:34 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831DC11861D;
        Tue, 22 Feb 2022 00:34:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id i11so33367244eda.9;
        Tue, 22 Feb 2022 00:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hYbx+gdquJpIZCDFWgwiF4xRFSxpas93/Jikv460mKM=;
        b=Pt/XAPq6qzHk+wKbePJHCOC9i+hjBUaBhB1iekoGU6gFncZFOWKHeiKjGXch3J9p36
         p9Y8y+ZiFByNt3pUIH7JXfYlGYvAOrxbI3Icbj93/pJwSt/di9u6eXlmGq0c60RtstHQ
         dZfgcZNZO3VqPecaVqmM11Yq2KXhSr0yfEmfh0JZ/grsnt3mTqEx0gBKD+GaKj3i6MSa
         hG7K+/IYfzKDIc3yNsiCbPs/sEEgNWq7GpTa9VWYoUZbwIWYA7TNVjIEGe3rR8FSnacH
         0mtU9Sckpy0lAgIK5hINEvV7LjkiWNDaBvspOmdS2SliQ6E49SUskUytRLkX3CBCcULc
         IYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hYbx+gdquJpIZCDFWgwiF4xRFSxpas93/Jikv460mKM=;
        b=bJbTwWXxRrozY6kjZfgy4WRjSs2QoC7CSGVRbTc92GwSLd9BJviNNYs+jZc5MdZEu+
         739UD+hQu8aGct4uVqkgcIOw5tHZqj88tLuP4mCwgbYkHRSeqge2AtAG3ItgqSlAzsbO
         csgnqCZ+BL+udLRk+rhCCjTy4WqSh3kfB3IyktfSJ+uVxCvyahxDYTPSrmzdVlsoiMbW
         62nXlaAN/MmLVFCSUOtjHOiJ+rYpcqzJssk9VBJ2uh+wlzAFMFMfdfHwbxf25p/L9GbV
         RVetCJ08SlAckvibnhDM4l+/+N/RvnSYrACFvPlv22MKc1fqtHGOO6Kz2DagUASLDWIn
         reBQ==
X-Gm-Message-State: AOAM531Bd9QWNlGC1ivp13iM715ps3WS7XVf8S17cohp5wgf191bOaIp
        5ttErYIcaNO4I2TvM0hHD5fyK8Ls52GmD9CtEiE=
X-Google-Smtp-Source: ABdhPJw7nQb/of5N3dJaJiBbGCi6mzlWkLmNzq2AC+PT3ndg7W30Pm7djZfunvkjFDWOlbuegqsmLwRygCkvaSCh4Uw=
X-Received: by 2002:a05:6402:2553:b0:412:8684:bd34 with SMTP id
 l19-20020a056402255300b004128684bd34mr25590743edb.436.1645518848047; Tue, 22
 Feb 2022 00:34:08 -0800 (PST)
MIME-Version: 1.0
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-3-clement.leger@bootlin.com> <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
 <20220222091902.198ce809@fixe.home>
In-Reply-To: <20220222091902.198ce809@fixe.home>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 22 Feb 2022 09:33:32 +0100
Message-ID: <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 9:24 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@boot=
lin.com> wrote:
> Le Mon, 21 Feb 2022 19:46:12 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :
> > On Mon, Feb 21, 2022 at 05:26:44PM +0100, Cl=C3=A9ment L=C3=A9ger wrote=
:

...

> > It's OF-centric API, why it has fwnode prefix? Can it leave in drivers/=
of instead?
>
> The idea is to allow device with a software_node description to match
> with the content of the of_match_table. Without this, we would need a
> new type of match table that would probably duplicates part of the
> of_match_table to be able to match software_node against a driver.
> I did not found an other way to do it without modifying drivers
> individually to support software_nodes.

software nodes should not be used as a replacement of the real
firmware nodes. The idea behind is to fill the gaps in the cases when
firmware doesn't provide enough information to the OS. I think Heikki
can confirm or correct me.

If you want to use the device on an ACPI based platform, you need to
describe it in ACPI as much as possible. The rest we may discuss.

--=20
With Best Regards,
Andy Shevchenko
