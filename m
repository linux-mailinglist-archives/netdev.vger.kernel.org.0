Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF02DCEA9
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgLQJpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 04:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbgLQJpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 04:45:32 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E4DC061285;
        Thu, 17 Dec 2020 01:44:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v3so14828866plz.13;
        Thu, 17 Dec 2020 01:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/biV0j4oPyBDlCc0KD7PgZ5xhcMTjG11uj+u1mWK9zQ=;
        b=lqpUUnmDzJZ6oVXsh/B9dcOr/1+RqrbuxyF3agHwYTZrWF0e7PbmpGhqbHgD51iulM
         H3OP1/+4scC0XufolApvlZDNK3mn5Dv4HlmEa7QO9ng33e7pCN+WmOa0psYkvKdYdyNO
         HMMjCo/0xmELTrG94ggPeFS9k/c0M7won4f5Hq0co5tSc1G5drkluKc2Ez0FdfDsG4rn
         +bgMBeOuLJBRbo80rLe0pKPYc6rzL8NegOxdJxBztWpIG1mFe+nCvolDXOI3E5hGatya
         4O8fqYUidRKMgM8Ncsst8FF2gfJHzgXqw60rX4MKAs3lKaxfyu9VsQnJpCpQQWCiSN+l
         wsbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/biV0j4oPyBDlCc0KD7PgZ5xhcMTjG11uj+u1mWK9zQ=;
        b=rnqhTeaxCcQkl7Jm1gvnzV/ybiPNQPt/1isT7I0TGSWU3IN542QWFXhk6SfgBS0d2q
         YHN+y4UdLIr2cyLyzyk6H11nBm4Qx/xoBmjL8kOc2uM2Zc2CKXYfr+K7PFpXeSsbzXqf
         LD+tMyOkO6yRTVa10t0h7b7tKCUFFKzRYdYnbW+5P3qVQpGeZdp2zBWqO+A7mrs4Bmto
         hhP6HhZQLqTY7fh0A/hp88BPudZmCcjebjBajE8l4rahiYWq5UCLJAIFKPLMmpcZXO0b
         lKs1CiGdA4QlL7OKUQoQZeSTRakQiAqvBfjX/abwj3yT6EVxzqVN770BWya7gsQw17Iy
         5Deg==
X-Gm-Message-State: AOAM530dBlTyyuetJh9BwSgnjJkNSddSv0l7eUMEWPHcHOwKgmyGNeHO
        J0idd/21Xy/S8h99syKudmBbLZPsj9iAD5SEh5g=
X-Google-Smtp-Source: ABdhPJy/HJsE2ZeepcRvJ0wKWfdVq2vODHsuQUBdazmRA3zZn6ZJf/EzyRhUYUyYz+uWOeBHY5Ic61x7rqKaZefJwsQ=
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr7201456pjt.228.1608198291744;
 Thu, 17 Dec 2020 01:44:51 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-5-calvin.johnson@oss.nxp.com> <CAHp75VcHrBtAY3KDugBYEo9=YuDwbh+QLdOU8yiKb2VyaU2x9A@mail.gmail.com>
 <20201217082804.GB19657@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20201217082804.GB19657@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 17 Dec 2020 11:44:35 +0200
Message-ID: <CAHp75Vd=BFrZRUoBCa9xfFSZVM+_-GReHppcpy4AvxEPsHQOpg@mail.gmail.com>
Subject: Re: [net-next PATCH v2 04/14] net: phy: Introduce fwnode_get_phy_id()
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 10:28 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Tue, Dec 15, 2020 at 07:28:10PM +0200, Andy Shevchenko wrote:
> > On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

> > > +       if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {

> >        *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);

> > And perhaps GENMASK() ?
>
> Sure. Will rewrite accordingly.

Reading this again I'm now not sure these masks are needed at all.

-- 
With Best Regards,
Andy Shevchenko
