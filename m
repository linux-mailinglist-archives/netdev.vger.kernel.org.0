Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B93413ED3
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 03:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhIVBCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 21:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhIVBCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 21:02:33 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6E1C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 18:01:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t4so3700067qkb.9
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 18:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2tzoNjgBHHVVO82xDeud4XNE313zYxYkqzxc5/NZ08A=;
        b=GGlDWC0II2CLW7KwN7qe9pvg/MIQUgcJy/JGJ9kxJCBAUvijhRdOhhHOGA+kup9px+
         qAogffQY4KGcU9sBWz0CbucL69NEN/RunSCzX1GkrxkdpNRjnpnR6QHTH3DaQkqQV8P1
         xMrc5wA9n/s7NWLxjWZ2u45FgRGkKDZvYjTinKj4JMVyzlIDyZhrBstuUsYW46FwdKFA
         DWYay8U3ZkffzSmhKwFNZX6vcoJ73Vyoe2l+BpccKiQfV4P+wk48MyPmCREDqEPvTPoc
         8hnaVD4Hv7EdtjCH6LCxwH180X4eUhlg4DRRsZdJKK8txL8c8kWvg1+EI6ABqnpUXVhr
         Jg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2tzoNjgBHHVVO82xDeud4XNE313zYxYkqzxc5/NZ08A=;
        b=VD69B3eAqZMFXW933aLlglOXgNPeiRcLyhzMMt9zmXYxO2fd5fOGkMk/Bs4D/E6KuT
         AHSfwfU/u6wZLkZbW7ZK9hybHWxjGyD1kAvC6qUgn0aUV8VQzsRT+iNDaDaUEnGBCM/V
         pS76E0qSB4SPv69m7GuQiQ3csfIeMJ+x6GT9xYXvlZY7J4z9ZtAj3IutV4WFwmnQiVl0
         gplk7QC88y4M6e9XCDdvgDpDfA1iGgKHYCgMoy+HrUjfW0EgNAYzp8LLQda5+AzExAfP
         nSZAQJeJZO28/bONonh0wPrHTEDAZVJQoD5s5Kpz5jeFlXnwHrmfoqhaG7y6+bAsELQv
         0z2g==
X-Gm-Message-State: AOAM533vMFhCVa07fqpninJ8Y4o0cP45AwQ7a5nJsaVD1VF4r/YzzOLr
        XZcdA71cs637OqeGTZ+q4tyjnXJ3tpcZaeHV8XanQw==
X-Google-Smtp-Source: ABdhPJwFpus2NfxEVSKg2x7IV+xzPb+fbtcnBYodXLvkDbaDUMFmm0/qPQBnMspUGNvlOl5b8upBbujF82BPPlxlRp8=
X-Received: by 2002:a25:e750:: with SMTP id e77mr13431650ybh.23.1632272462992;
 Tue, 21 Sep 2021 18:01:02 -0700 (PDT)
MIME-Version: 1.0
References: <YUoFFXtWFAhLvIoH@kroah.com> <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch> <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch> <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
 <YUpIgTqyrDRXMUyC@lunn.ch> <CAGETcx_50KQuj0L+MCcf2Se8kpFfZwJBKP0juh_T7w+ZCs2p+g@mail.gmail.com>
 <YUpW9LIcrcok8rBa@lunn.ch> <CAGETcx_CNyKU-tXT+1_089MpVHQaBoNiZs6K__MrRXzWSi6P8g@mail.gmail.com>
 <YUp8vu1zUzBTz6WP@lunn.ch>
In-Reply-To: <YUp8vu1zUzBTz6WP@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 21 Sep 2021 18:00:26 -0700
Message-ID: <CAGETcx9YPZ3nSF7ghjiaALa_DMJXqkR45-VL5SA+xT_jd7V+zQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 5:45 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Wait, what's the difference between a real fix vs a long term fix? To
> > me those are the same.
>
> Maybe the long term fix is you follow the phandle to the actual
> resources, see it is present, and allow the probe? That brings you in
> line with how things actually work with devices probing against
> resources.
>
> I don't know how much work that is, since there is no uniform API to
> follow a phandle to a resource. I think each phandle type has its own
> helper. For an interrupt phandle you need to use of_irq_get(), for a
> gpio phandle maybe of_get_named_gpio_flags(), for a reset phandle
> __of_reset_control_get(), etc.

That goes back to Rafael's reply (and I agree):

"Also if the probe has already started, it may still return
-EPROBE_DEFER at any time in theory, so as a rule the dependency is
actually known to be satisfied when the probe has successfully
completed."

So waiting for the probe to finish is the right behavior/intentional
for fw_devlink.

> Because this does not sounds too simple, maybe you can find something
> simpler which is a real fix for now, good enough that it will get
> merged, and then you can implement this phandle following for the long
> term fix?

The simpler fix is really just this patch. I'm hoping Greg/Rafael see
my point about doing the exception this way prevents things from
getting worse will we address existing cases that need the flag.

The long/proper fix is to the DSA framework. I have some ideas that I
think will work but I've had time to get to (but on the top of my
upstream work list). We can judge that after I send out the patches :)

-Saravana
