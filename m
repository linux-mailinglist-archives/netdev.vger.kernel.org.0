Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15813A4130
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhFKLYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:24:22 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:36385 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhFKLYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:24:20 -0400
Received: by mail-pg1-f172.google.com with SMTP id 27so2204162pgy.3;
        Fri, 11 Jun 2021 04:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FodfrTReLfYqXpPW4ser5dvPXRsRi7JBcumQmAiu440=;
        b=JUe+i1ceTGgyIbJTuXjjpw517J6SO1aslFOvGpJJl3XZQ+nHYglKdRSrViSL1d5z0S
         s9MKpOivSpcr5NqwURdIdhwZY9LkifU/tNSnYTc//IidKp4HW6HSDhe/22+H8IvR8cXn
         uiV15s+CPWLar1tiKr3uju4SRFD22oHqanCbVelNoMjS5nPPygoB1RfvaeFUarP9j/gz
         33weRduesVldYNoYQuwH7dFWjkgMcJa9jcZ/d2ZTFHcmjxZmV3T6uBSENRfhWELeJk6b
         IUC1EhMTcV4ux8DQZvl6li95TvbSihG6ruO14G3AiH+F+QYD2IAj5/wdMRqTnMKvKimV
         RkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FodfrTReLfYqXpPW4ser5dvPXRsRi7JBcumQmAiu440=;
        b=UEcDS0tfAjoeVgttQ0X55GArPBr4vRcJykqQLo+Ll7YjfNZR+NyMGG9xu1ltmJ62kN
         JuNKtXQWmSSWdV/vImIY2rfaHs6X2Bmp/or8S+UAgiLVCjbPE+/OcduiLatIHrHGY2Tg
         c39DCfH0pxJ8xSNct52/HePHXQc3Zz5J+Gt437B5DlbQuEWgRny30IjS5SQuH2WECWuR
         BsAPnJUHLt7i7WAd6Gax/2e3vDtVyB4d71hJknVpdgMi6SuRskwGH3nrpFxfFjLApiWi
         ClZrv71qVlskOXKVkuQyU2NQqTnRJc1XE1XrCZZxAic9JvvctxDhJDHy9TZ5xHyCDlbv
         86zQ==
X-Gm-Message-State: AOAM531cQEeuItxMCrLA8vVDU99MREgfyad3GKBhg+qLZjjGhfwl67FN
        4XThZ/nfxVktgvlr39YjuPrDONtMUCdSxi9Aeto=
X-Google-Smtp-Source: ABdhPJyFUIflNwxdK/RMN6foD2ei8C1GZpfb7m9sYaupbEySMmuH6cy++r2H96e5rX2rM3xDWUh4NX4ds9+UubmkTsI=
X-Received: by 2002:a05:6a00:a1e:b029:2e2:89d8:5c87 with SMTP id
 p30-20020a056a000a1eb02902e289d85c87mr7917887pfh.73.1623410467613; Fri, 11
 Jun 2021 04:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210611105401.270673-1-ciorneiioana@gmail.com> <20210611105401.270673-3-ciorneiioana@gmail.com>
In-Reply-To: <20210611105401.270673-3-ciorneiioana@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Jun 2021 14:20:51 +0300
Message-ID: <CAHp75Ve1URDqjZUevbTxH1zDekvwDoSKw5B787ahR1BJ+0ij+Q@mail.gmail.com>
Subject: Re: [PATCH net-next v9 02/15] net: phy: Introduce fwnode_mdio_find_device()
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 1:54 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Define fwnode_mdio_find_device() to get a pointer to the
> mdio_device from fwnode passed to the function.

> Refactor of_mdio_find_device() to use fwnode_mdio_find_device().

That's what I meant. Is this series converting two users to use
fwnode_mdio_find_device()? If not, it should do this and kill
of_mdio_find_device() completely.

-- 
With Best Regards,
Andy Shevchenko
