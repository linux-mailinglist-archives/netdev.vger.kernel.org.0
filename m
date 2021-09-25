Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B451F417F04
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 03:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345973AbhIYBHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 21:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhIYBHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 21:07:23 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47351C061571;
        Fri, 24 Sep 2021 18:05:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id bx4so42823530edb.4;
        Fri, 24 Sep 2021 18:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHrNUxSVHPFay18ykXVu5QYZYlU999IyVEIEXaMIIuk=;
        b=iTkDYHU1Pdjpw/CJx2+QNmwdCbhonPJpUXIUqnXR9yIkvOjnnex0e5mlt0mtDcju8j
         oQP4Ji6Gw1OwxXk2i9wlN7vaZ8T0NWTk2rZUTm5wKp1put7D8ZXHQwdOifFffsRFQ56j
         8VJYvaIhp3XTyzRUBemWf4JSftl1t4MCRYE8wHfpOyJkR3YifdXXmYM4F6mNeJ126DWI
         CnVhjFAKlE4w66VjnKBwDdczmy+KS3pUku7T0l3t+wTa2ebQQX34YSk/VvTtEMC7OWAU
         8nPGPI53thP01tGuUwYZGghvfpWvY5NPiytf0akiS/3hUr8EeZpaTCUZIzI+3YC/vi/L
         TMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHrNUxSVHPFay18ykXVu5QYZYlU999IyVEIEXaMIIuk=;
        b=0/NVQ0oQ0ubfD7F9SsbBibtxDxB4DNFfvwlg9oPXNud8drWMeZDeQZ7TuFmH62bc2N
         r//V0HOitjnco3O7ZQ9gxVVyFGfX/6TiMoyCKmnQNk/caSYFCNk6qWZR+Q4ESpup0iNz
         56idqRyTsoYNmFwKM071Mn5XmMTtrcmqc21nwo/HBWGJKHThOcnjFTG3yJ0z2YJ93fML
         +nQF1WgaK2KqOc/bo15GYDR/BQKCEwcKFvLCdXgBIjRDgFitJvQ2qfuNm2oJmCEAIIdg
         2WJ5Mu9rNdyGCvlCcIsl43XfF225L4bfvmFAieJXcWPfMpKANZ8h3MkKNx5jDnoBnkF6
         Pa+Q==
X-Gm-Message-State: AOAM5312xY0opHMFUGLPkkOMcZqoNzDW1zOCL0BW1eoomJftXb5bJG2b
        g1NbOsPrsTCJJ4miE+gBcuiEF9zEafA7d994NBA=
X-Google-Smtp-Source: ABdhPJxLSJQPETEhpVEg1BU+2BRSL97NdO0tOSj6i2gjP9uqxWyT7cdSbLHXanc2dvA0Ird037wFcY/UjHbhbbLpx7Y=
X-Received: by 2002:aa7:db17:: with SMTP id t23mr8756289eds.387.1632531947552;
 Fri, 24 Sep 2021 18:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <1632519891-26510-4-git-send-email-justinpopo6@gmail.com> <20210924170505.6e62e32f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210924170505.6e62e32f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Justin Chen <justinpopo6@gmail.com>
Date:   Fri, 24 Sep 2021 18:05:36 -0700
Message-ID: <CAJx26kUsAU+Ux3BFfHJFnZqTwCjvp0T698XcDTQQO9gVZZ5C_A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0 Ethernet controller
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 5:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 24 Sep 2021 14:44:49 -0700 Justin Chen wrote:
> > Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> > introduced with 72165. This controller features two distinct Ethernet
> > ports that can be independently operated.
> >
> > This patch supports:
> >
> > - Wake-on-LAN using magic packets
> > - basic ethtool operations (link, counters, message level)
> > - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)
> >
> > Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>
> Please clean up checkpatch --strict and make W=1 C=1 build
> of the new driver.

Apologies, Will fix checkpatch errors in v2
