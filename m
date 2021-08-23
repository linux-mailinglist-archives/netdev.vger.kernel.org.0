Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4240D3F526B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhHWUto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 16:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbhHWUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 16:49:42 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19C8C061757
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 13:48:59 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id z5so36684115ybj.2
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 13:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4QWnKvyWpOH8RqtwiwvK1dM7ed/hnT2KBqNw0j6U7A=;
        b=WbLChwgFihPdWlSC5y/qfShp0sIMtUsZdd/qhdA8yq+uKZnAylNBckILex07AGi/wm
         rgZ5uYq0OPLEDOjJjQNpJ+Ju8diDdxaDfCQwrnIx6lNmgzG/K2/mjgJLi6O9hgP9CCSf
         dAr8SWboRRD53wvgWYtAkjNiKwtx3QVlmKpOmrZzZczCSdPUvwPvbZTPXzhzLvAdAErk
         L9Q1MmJtxS/hNGKqRBqgzPLO1pCbAe5NUB7lFPq7KGs+5AAx41fIbogLHTls71Tlvoad
         RCv0gxozyF+yls+T9/8vUIxB2JtDhqhZt2c8n/mXIiynaLbj1SkY6RzF6Plg37vpje3f
         AtGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4QWnKvyWpOH8RqtwiwvK1dM7ed/hnT2KBqNw0j6U7A=;
        b=H6FtjqB79r+aChmxtDeMgr7esbIGTi33ZLE5/gLCt8nEof0iHK8RsOovAJG1694WU0
         Yx8m36hCQY9uF9VBpxORar56Ipm6sUiMk2yVQTnV4UkODfO7z0dq7HmcAm1+7mx6S0xe
         W1lLYHL6Xs/C40GdjozGy5UIkbNFOOa2pjdvO5Ro76K6DQlLAZosF67zUAoRugotQX7I
         vE1XG/govY+v5uZYIT7OtfRLdy4FfKF9U0Djal0SkULoJfHfNLjB3BqTLeYtk1lSxmlo
         9bPHwbNQEQPd4Ajd1UgupR8Oap8vF1bqxKhP77hFBe3XufzdocMG/1bAH0mK3TCbF4aO
         rqng==
X-Gm-Message-State: AOAM53015zdQDesIJWcxsuu7I1AshRwgZg/Xs4qXlx+M1naFN3cdJ1gU
        Vjo60/0TOMhbmrJnlXyp2QC5K4nW7VxZaSKyzoT4Zw==
X-Google-Smtp-Source: ABdhPJwU4w+ipd7j7HdZ0lrNLOvWfCuRfa/YomiIcCCPAc8CHcQ0D0Ea8O7+8nRuOQnuqDlL/BU0zgvC8Y9HniorxT0=
X-Received: by 2002:a25:8445:: with SMTP id r5mr47936513ybm.20.1629751738986;
 Mon, 23 Aug 2021 13:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com> <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
 <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com> <YSP91FfbzUHKiv+L@lunn.ch>
In-Reply-To: <YSP91FfbzUHKiv+L@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 23 Aug 2021 13:48:23 -0700
Message-ID: <CAGETcx8j+bOPL_-qFzHHJkX41Ljzq8HBkbBqtd4E0-2u6a3_Hg@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for "phy-handle" property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 12:58 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > PHY seems to be one of those cases where it's okay to have the
> > compatible property but also okay to not have it.
>
> Correct. They are like PCI or USB devices. You can ask it, what are
> you? There are two registers in standard locations which give you a
> vendor and product ID. We use that to find the correct driver.

For all the cases of PHYs that currently don't need any compatible
string, requiring a compatible string of type "ethernet-phy-standard"
would have been nice. That would have made PHYs consistent with the
general DT norm of "you need a compatible string to be matched with
the device". Anyway, it's too late to do that now. So I'll have to
deal with this some other way (I have a bunch of ideas, so it's not
the end of the world).

> You only need a compatible when things are not so simple.
>
> 1) The IDs are wrong. Some silicon vendors do stupid things
>
> 2) Chicken/egg problems, you cannot read the ID registers until you
>    load the driver and some resource is enabled.
>
> 3) It is a C45 devices, e.g. part of clause 45 of 802.3, which
>    requires a different protocol to be talked over the bus. So the
>    compatible string tells you to talk C45 to get the IDs.
>
> 4) It is not a PHY, but some sort of other MDIO device, and hence
>    there are no ID registers.

Yeah, I was digging through of_mdiobus_child_is_phy() when I was doing
the mdio-mux fixes and noticed this. But I missed/forgot the mdiobus
doesn't probe part when I sent out the phy-handle patch.

-Saravana
