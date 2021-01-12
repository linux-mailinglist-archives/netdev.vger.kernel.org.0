Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870F92F34E1
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405087AbhALP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392118AbhALP4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:56:55 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFF4C0617A3;
        Tue, 12 Jan 2021 07:56:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v3so1594503plz.13;
        Tue, 12 Jan 2021 07:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=leu+iGWuFuIFoxOjAi3J0tECQ+RVSdVbKU6UoDrVBEE=;
        b=kYg7ZEU5pZ8VZO2VglKcrqKeDz9dQQ7Olt0L/H6Ipz5VuI4W3LZ4y7tob4242FOCUq
         xqW41+VCdiO8U3SC0OCTYgYJB0pvFgCjy+c0zxe7hX6BVS7WZp25zChg8Cf3dFnnj0Nj
         HD8LiGdT2I/obZug9n5emjHW4fPqEO7sMArxLlfpQE7/x8qnjWQ9K2dDGgm5AWlE3na1
         HXdhvGXo03uGwPVDOKZDuO6j/DP1Q984t5TPoGZhhbuBKukw9Wvg/gVwAVqX5okRbBoo
         RrzHBVYe2BEIvU3uBBH/c+RKFBhm5hwVOrnTqoMkpn2TS8p+uuMcLhmcTlqxpySVxH5y
         +5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=leu+iGWuFuIFoxOjAi3J0tECQ+RVSdVbKU6UoDrVBEE=;
        b=Ic+WlDsBX2cmNyfuReo4xpJp4iNx73pCJTa4Kd7jxYf/kYYt8Btqd3loN93DRdlWds
         S60qpxwOfjKil3xd/rhJHaCDNnN0VGbF0ckp8rQWMgqX/CrZRA+isH/O0x5IB7viAQ64
         0JJTAWAWsZFdVh9kY4znpPBn7DGMFUbm/81waOWjxq0px170RsOZ/SxTn8rkdZNOJcXf
         d8x3LcfJ9pPpFed3owOAHsYsp0Y8/JUywopNYENRQTlCiUPiyWQuiCsyW2OlU0YzJs56
         X/Gp4ZAR4ZlGjZmRQJV0xT30Gr02bU+jdHmqrYJtkq/TnGcvKLAlONytL5oLkV31rV/F
         XXdQ==
X-Gm-Message-State: AOAM5338AMUV9g0DKNPzenq3es1K0vOHZ/hWbNIVIf1w4Jpczv+W4i7M
        +b5oGDHtOHx6v38I8UadKfOzBVV4frLJjWrK0kI=
X-Google-Smtp-Source: ABdhPJwDCERUgiqjqQjEwIe7miZDoAg0tvPatjrtE4R6uWtEgl+YrARvybZDy65egAgjMsYQB805yHLfdtLHfbnUlFo=
X-Received: by 2002:a17:902:c244:b029:da:e63c:cede with SMTP id
 4-20020a170902c244b02900dae63ccedemr82422plg.0.1610466973007; Tue, 12 Jan
 2021 07:56:13 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com> <20210112134054.342-15-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210112134054.342-15-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jan 2021 17:57:01 +0200
Message-ID: <CAHp75VdAB=k10oLHbYEekbQAhOqnoVWHxN-gNW7zcayZxv0M7Q@mail.gmail.com>
Subject: Re: [net-next PATCH v3 14/15] net: phylink: Refactor phylink_of_phy_connect()
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:43 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Same Q as per previous patch. If it's indeed a bug in the existing
code, should be fixed in a separate patch

-- 
With Best Regards,
Andy Shevchenko
