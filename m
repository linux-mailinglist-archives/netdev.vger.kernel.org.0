Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8911913A8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgCXOv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:51:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33044 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgCXOv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:51:57 -0400
Received: by mail-ed1-f66.google.com with SMTP id z65so21036889ede.0
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 07:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BitOKWYAB15K8l6XPKgTKsrQsxhragpTR3WjMqDcOeU=;
        b=irDlWpE/xlxWdTrSaM21n2l4DGYlYcK2KDcIHkiYyUbvQ+aW7TM9/4Xe7MxmjTvuG6
         qX32UFZDi3XcUvG+zuwLaSnEqCZ2PB2GohgRF9PhXf9Xw12VyaamwHrA8caSQBttyVSn
         qWyKL97YgMhHMRTlO295R1DvpjhyuzLzb3dlNq+oqvd9YSTXXOmHXtoQbRbwHq79Qxq1
         U/HkuKKEUTyV5zETjGBzhOEBCcma+VB+8CssNpAcDd5aVBb7uu0VODhm8G/W0aeRcXyb
         sR+w8lONDrW6Fe9aB2KGmVc1fKGQx3dioa67his7cIPooB9gEimK/ftEplyB/OTncgHL
         4Zcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BitOKWYAB15K8l6XPKgTKsrQsxhragpTR3WjMqDcOeU=;
        b=t700YFRb1hq8GkpNJ9aXrCC2e5UX2ffVnDjaMyPIo7BjWwnrjWi39zjZA+qfuomZUw
         rbRDk1ayCjx2UiK+VirjSBftdET88fra9w1hz99cighfaQFUp+Xps7rJbjA5E68mZElI
         XfrE5ni778NHbsTTVd5LFF0V3m65B5tzfXGccdoLsZn6fwkDUDM+fyhtvZyomhgwtPNt
         5c1eMVn9nbbqlEFHFBle4sZKtcLXQHCqw8Fg1mTCjQFPyJulfQY2NDCDkCpoVKFwLBre
         I+EUCS3EEtWyzeyg1EiDds26/rdHcE+uNm47O9ROiFhMNUFD1INBwz6UGjdh6cRL9QFO
         limw==
X-Gm-Message-State: ANhLgQ3lA4Nw/dxz56VAZ1Xlj7OOU7bQrZt+ODY0aVvSbNW9HuiGPL2Q
        uxRD/ow6ltD0sXDi2UoNL1z6lEb0y8GnfKN4A6bICZim6DI=
X-Google-Smtp-Source: ADFU+vt9hTFGrJY0EyUsPLXRceqpL0FjHWlC8Z4McQSRgEXhQkBfaMhJ0tdCPutHZZ4KShySYsGpKbCHkF5IODO8XcI=
X-Received: by 2002:a17:906:fc18:: with SMTP id ov24mr2482453ejb.189.1585061515911;
 Tue, 24 Mar 2020 07:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200324141358.4341-1-olteanv@gmail.com> <20200324141829.GB14512@lunn.ch>
 <158506137648.157373.6196697912192436523@kwain>
In-Reply-To: <158506137648.157373.6196697912192436523@kwain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 24 Mar 2020 16:51:44 +0200
Message-ID: <CA+h21hqw3in1aX9hWOSYqn+qOAbUo4YBtx-djvvVLmQeBCNw=A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: mscc: consolidate a common RGMII delay implementation
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 at 16:49, Antoine Tenart <antoine.tenart@bootlin.com> w=
rote:
>
> Hi Vladimir,
>
> Quoting Andrew Lunn (2020-03-24 15:18:29)
> > On Tue, Mar 24, 2020 at 04:13:58PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > It looks like the VSC8584 PHY driver is rolling its own RGMII delay
> > > configuration code, despite the fact that the logic is mostly the sam=
e.
> > >
> > > In fact only the register layout and position for the RGMII controls =
has
> > > changed. So we need to adapt and parameterize the PHY-dependent bit
> > > fields when calling the new generic function.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
>
> Thanks!
> Antoine
>
> --
> Antoine T=C3=A9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks for testing, Antoine!
