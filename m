Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01693FF2EB
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346848AbhIBSAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346809AbhIBSAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:00:05 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EFBC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 10:59:07 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r4so5501601ybp.4
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jjW6xdHTM5+s0n5Gr94VMOZzqZcFAl+XMK5rvNwK9j4=;
        b=W9uW0mxtfIcS9be8lr+K8+Nbfvy+mMukhnBRlOizysy/Yd/Vbr6CXq9YHCzyqMQvg/
         kHRRH70A7ymqkX7O9dve9kv6ImHrszcAYR+2A9tjJ6zomtEg2A7WfbIDyHjbyIJSfXnd
         iNYGXe2BKR646sTqU5i58gXNs2GB+macRvilIrW/73gY2dnHfU0F/Aha253ghA5369Kt
         7Y6KbqgkMGOcZ83P2mznnkCgQvxuFPcgd8YXcdfy7CVhyf9nBlJHkg1q5llUPQKyUUxv
         FRVwZSDq28Jj/mOZwYgzsLohmmvpD8rRI0OfjkAbC3dciJj4ljJe392qmeXRdiykmhF6
         gQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jjW6xdHTM5+s0n5Gr94VMOZzqZcFAl+XMK5rvNwK9j4=;
        b=BBIKNdFKq61Pho+Mf2BVSgdsvyreFifX/A9+WPgJk0ozyJOEiZCx729VrKxQLlx7zV
         pnW3ylvU/bpc+6A5cJclsyaFtff1x14qLuZ67yLAfu9+MLzV1mrNM+PEHhg8txC5lpwT
         TNlPKY+lUl07U/Gt621iCrwtyAeqk6Zc1+Mbo3r32vM/PKLZOXFPDZKoXunH+pPZ47qr
         3poR4td4KZdnCqvWjIetmp0zS0H8Gg1qCrqyV4anOZE+4UvvWkn34CED8ME3hHQCBICV
         uDiZpZHyQH0rjSd1MCqN9c0fS2d5Hg28fT8UJC+f1+0SZKfr9khOda+QEoj8EXPNlnwG
         Od2w==
X-Gm-Message-State: AOAM531ptNxC4fL6a1eK1vrr7bfsSzSESyadp1cPBQauVBw/pjE6Tavt
        wDvW3UGyP8zphuQVaKjkczpQMjBPC74B4G8V2ig/Ug==
X-Google-Smtp-Source: ABdhPJywXj+nljc4ROlXKw+RojrvVBHmblH2vd8rtBZiDkasl81c596R2ZD949ecUE3IwC4urBiaxNdrKciMbnr5MAg=
X-Received: by 2002:a25:d213:: with SMTP id j19mr6450877ybg.20.1630605546131;
 Thu, 02 Sep 2021 10:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch> <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch> <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch> <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx-ktuU1RqXwj_qV8tCOLAg3DXU-wCAm6+NukyxRencSjw@mail.gmail.com>
 <20210901084625.sqzh3oacwgdbhc7f@skbuf> <YTEMs1mMIT/Z0c4H@lunn.ch>
In-Reply-To: <YTEMs1mMIT/Z0c4H@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 2 Sep 2021 10:58:29 -0700
Message-ID: <CAGETcx9gTEr6O2u0VwAgowaMynx=bGQpttw6dRHsud-kM0QmKg@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:41 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> >   How would this be avoided? Or are you thinking of some kind of two-level
> >   component driver system:
> >   - the DSA switch is a component master, with components being its
> >     sub-devices such as internal PHYs etc
> >   - the DSA switch is also a component of the DSA switch tree
>
> I think you might be missing a level. Think about the automotive
> reference design system you posted the DT for a couple of days
> ago. Don't you have cascaded switches, which are not members of the
> same DSA tree. You might need a component for that whole group of
> switches, above what you suggest here.
>
> Can you nest components? How deep can you nest them?

As far as I know you can nest components.

Also, technically you can make your own lightweight component model
like behaviour using stateful device links or fwnode links (probably
just a simple for loop). Just create a new "dsa_switch_tree" device
and create device links between that and whatever other devices that
need to probe first. And then you'll just have a common
"dsa_switch_tree" driver that probes these types of devices.

I'm waiting for [1] to land before I jump in and clean up the
component model to be more flexible and cleaner by using device links.
The current implementation does a lot of stuff that device links will
take care of for free.

[1] - https://lore.kernel.org/lkml/CAGETcx-mRrqC_sGiBk+wx8RtwjJjXf0KJo+ejU6SweEBiATaLw@mail.gmail.com/

-Saravana
