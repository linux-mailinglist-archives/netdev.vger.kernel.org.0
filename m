Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BC3130BDF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgAFBqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:46:08 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43656 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgAFBqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:46:06 -0500
Received: by mail-lf1-f67.google.com with SMTP id 9so35347448lfq.10
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBUgTPb89F+0Xgjc2bYmszGmbAUBQT8GVtHX+HgXxYg=;
        b=Zi/zZ1RSWPDHW4MGNn3zhptY3SIZyBaTIhgbYtlcFoQ6b/+Exu36QqDt6QJAAlMtuL
         PAw3PvWZoNzskddA90QLwJ05LAHuaNQzyblxjhIFvpT0TmD0Y6qoiuCEmWgWn0h8ZUze
         6KmJzd9EHjT9gpgID/Lx/7UyU0V05RhqRIe9hYb2PLybZg9xsYlJARgvdsSFyGxl2Ur4
         tLCy8Vz2LlHSBPwpewDcdNI8BI9mVMfmzUgZ9wgMLszh2OVtOFxTrXoODyd5aRNQ76nN
         npunbSuUqTckNmxVRLW33zzoyI2T667Drsw/qY8jeY46d5II/DLhai8YrAAPV2vhvoR3
         4pcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBUgTPb89F+0Xgjc2bYmszGmbAUBQT8GVtHX+HgXxYg=;
        b=B0kpGxgKJkCLJsZQkVPv9vhAeQaS05yt5r4PsdWP2SUDqKyjiGIJo2Hv+8ZlwLLS8C
         DodahCH2PnM3+kyVB01d8sOo1uq1Ta5vkFM62Tbft6LhOzV72RggnDeuXZONXdiZu0vs
         gkDXjsT/tZB3eVIdke4YKAqLhhnB0ze7k4D29Jin1RoQHE15NVm88Fho9Z4pInCRnzIb
         jFtI651880TNeIpYVXOVP9s4coCpa5uk8BRpRgR5vZ9TlfBQoUW86LtOhMnxlQDb6XCx
         KSfo0oC+PNd4nlfIF9l+qhf5NazxVHXAAt512ZngkWsEewEDLG0o27YoKemdLJ0aquIs
         jatQ==
X-Gm-Message-State: APjAAAXfWsnhr5icMKTCObNF95FsVI5VEkStCs3QPvH6GjixZJX2kRY1
        SBqFNwZdAfopduLd5a6TqlvgIyg9XBGeCDLSq/NgCA==
X-Google-Smtp-Source: APXvYqyYC/pOkPUPX49HfCOe8pIi/7RiUp78ieHupatukpmA4+EBSle3tUienxjhbZjK1FVDssCxXscRiMC1SmeP4z0=
X-Received: by 2002:ac2:55a8:: with SMTP id y8mr54853667lfg.117.1578275164250;
 Sun, 05 Jan 2020 17:46:04 -0800 (PST)
MIME-Version: 1.0
References: <20200102233445.12764-1-f.fainelli@gmail.com>
In-Reply-To: <20200102233445.12764-1-f.fainelli@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Jan 2020 02:45:52 +0100
Message-ID: <CACRpkdZdgExGX33=CKhZe3EwLV_PoJ=BSkH91DGAK_JQF4tJKA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: vsc73xx: Remove dependency on CONFIG_OF
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_Dembicki?= <paweldembicki@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 12:34 AM Florian Fainelli <f.fainelli@gmail.com> wrote:

> There is no build time dependency on CONFIG_OF, but we do need to make
> sure we gate the initialization of the gpio_chip::of_node member with a
> proper check on CONFIG_OF_GPIO. This enables the driver to build on
> platforms that do not have CONFIG_OF enabled.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

It's nice if some non-DT users need to use this driver, like
some board file. Thanks!

Yours,
Linus Walleij
