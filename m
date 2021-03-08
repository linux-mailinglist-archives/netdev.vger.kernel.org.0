Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0664331398
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCHQjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCHQjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:39:22 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0C2C06174A;
        Mon,  8 Mar 2021 08:39:22 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id a24so5111441plm.11;
        Mon, 08 Mar 2021 08:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XB+F7uA0KNP+y7mhzqyQJTQNMPmYH3O9SOc1rrsQPnc=;
        b=dHZenSv6k3j3wpDCQnk5ASz0ZJBo5MNQt5dCIUWyt4AflynuJoeLcWO3uNE3JsZReW
         5N9CDr9cJxSRsggqWE1SJCMlBWUdBgO1zX5cQgEXRSiCP06VxpD3rWUtV8TNde24fcfG
         ApAmhnwCmH9JktdnchWAhnTrrKt/V0fHuAOzrhRoOx0iA+dirRRjByj/MJpwkY9pkTCl
         UXqPBAre93JP6gG3Lp39dBqOiS5T8gQdIpBGneYwqzWjXqvdLdx+lhNqacvhj2ZiOWKl
         lACl1TNN1B9n7AwDVZcRVfs8S7KA8EsLfbOhRXXjBzTI+WiIri13hMZxwrkITkPGisyA
         JUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XB+F7uA0KNP+y7mhzqyQJTQNMPmYH3O9SOc1rrsQPnc=;
        b=ZWPGtbOt5Fy8VXJ7q1MOYTFjkiGFy8Tnqg1ocMqV1DMjzg8uRvHKwuoUFL2slgm6Io
         7jHuPkeK9s5U1AXDQn75X6ERf2DTm44wpK76WlsfvFdCgcbeiklveVKEu+QktgQuGrjK
         mcCFJtdELFzWeAVTkJQBy2DoeXVBKuTZPkv0PokBpPEvzyYPM8EhkRPdF/2MVBmdjdP7
         9MSSQQcxtyWT5LnIkgla8UO+eMHYiMcmwo41kynbSLTgaeSv2Avgzhner5HGs/YcX7Fl
         hC+ZFimocAT/NSdOFNxe8TKNiqikLZSVM5/Xqj73cwMSWX19Z4hpvzOVU0g4bQD/FFrS
         lvWw==
X-Gm-Message-State: AOAM533QBnLqpuTvkvf7acSoJjReHkVzMV6Oec0wFxSCWmH4JpZavMhv
        x8+w4F5OjuqB4p4Fng6zdHX8An/Zo/nXB7bRB5Eom/74hmEIn9y2
X-Google-Smtp-Source: ABdhPJwL0Wch/MCgaFA2pHVXY7Wray9aHN2M1G8UX1UsXIi++pmGIpWzcXzB2aZuIsasVQ5+j4vDpONGvk4TdIQi6t0=
X-Received: by 2002:a17:902:c808:b029:e6:4204:f62f with SMTP id
 u8-20020a170902c808b02900e64204f62fmr692632plx.0.1615221561612; Mon, 08 Mar
 2021 08:39:21 -0800 (PST)
MIME-Version: 1.0
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
 <20210218052654.28995-11-calvin.johnson@oss.nxp.com> <CAHp75VdpvTN2R-FTb81GnwvAr_eoprEhsOMx+akukaDNBrptsQ@mail.gmail.com>
 <20210308140936.GA2740@lsv03152.swis.in-blr01.nxp.com> <CAHp75Vc2OtScGFhCL7QiRsakrQAZYE6Wz-0qzmz5uB63cjieQw@mail.gmail.com>
 <20210308162811.GB2740@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210308162811.GB2740@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 8 Mar 2021 18:39:04 +0200
Message-ID: <CAHp75Vf5LfE71w51CyjYHjp6g6vKTjfQU7b3BwK4m1Vrprns+w@mail.gmail.com>
Subject: Re: [net-next PATCH v6 10/15] net: mdio: Add ACPI support code for mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 6:28 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Mon, Mar 08, 2021 at 04:57:35PM +0200, Andy Shevchenko wrote:

....

> I thought of including device.h instead of dev_printk.h because, it is the
> only file that includes dev_printk.h and device.h is widely used. Of course,
> it will mean that dev_printk.h is indirectly called.

The split happened recently, not every developer knows about it and
definitely most of the contributors are too lazy to properly write the
inclusion block in their code.

-- 
With Best Regards,
Andy Shevchenko
