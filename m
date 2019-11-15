Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A24FE679
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKOUjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:39:18 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36971 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOUjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:39:18 -0500
Received: by mail-ed1-f67.google.com with SMTP id k14so8482356eds.4
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 12:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3SLe+WMg8dXpRCyxQcXsOPYu7LkJHkn9ZcqcSQYbo0w=;
        b=qpWmi2ILr53a+wGjprSAGcbkTL8XbZI+PcRPdTKJNaHtyERIOfcLcJHL2Zf8iMkH44
         BdD3iLPqmFiMs/y6YqfH3MCXv3pWTydmjudaqrEK8HqNvv0DYM9R+3Tcnu/dFZJq0DNH
         DajcYrSQAkoIH5gO+3pnzzy6wuEpaW6gWSeRa7GMzY+qGeKa/7ccsd06PpvqkXiQR7xs
         eQ+0FqG+COroYweLvrR9dKRpvnT6fwFtBNReozZ5yQ7fF4QQ4P5p/fcjCCWwznUvvKs3
         8SmjrTDD4jCbiKvVIBYL3m4J38w+RsyzGlrnr/IdZ6NPtkfMqb7JHIspCPIL82qvYTP/
         Fb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3SLe+WMg8dXpRCyxQcXsOPYu7LkJHkn9ZcqcSQYbo0w=;
        b=sJKxp4D86X2FL0PDFQ0oQEbHcQeBcplW56wY8kdvtlpM982ihSWF+bXlscchxeT/pe
         PgGhKDcZfVk603meCZW8PULYwUMY/aofB/V47DIleybMWS4ha7YGgZEvcx5ny+ZjeuGi
         kirDPtmf6JHO1Kd4acRkVZHx07GuiNkXHVxz/4S2qlS2hq0PSo5o68ZTMVGMN8puZ5ad
         ywKl1AQVr92bAT3d9/xfYqfT4OIJQkKuT6B/XKfbEUxyRlV3AwFhm/zW0d6/qDy302L2
         jeLIoBGMtVaD92uh9sE4G0yv6vq5DXd6h94nBGnE9sIsMq4gLr4WbkvZ8jJQpIpRUoHn
         LWOQ==
X-Gm-Message-State: APjAAAXFYD0tjej2w2S0+KlZuFj+IotCUS0hwqGjTpeK+Z2jRbVWuOac
        Stn9NSLud93khKsgQN1RSKgit3E1SOd6djKu7SY=
X-Google-Smtp-Source: APXvYqyuyCe1kAZ0jc+N3kmHQ4CEjmPK1eUAuG2ymDtmyw/uI4dq46LoUMW/vLRGCjQDQScy2esck65g/Q2WyCgBiM8=
X-Received: by 2002:a17:906:1d19:: with SMTP id n25mr3509347ejh.151.1573850355506;
 Fri, 15 Nov 2019 12:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20191114150330.25856-1-olteanv@gmail.com> <20191115.123231.2135613715202333585.davem@davemloft.net>
In-Reply-To: <20191115.123231.2135613715202333585.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 15 Nov 2019 22:39:04 +0200
Message-ID: <CA+h21hovUw1VfJMtWr5r8NqucejYYNJ1W91MwocKs-fKOsE0PQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 00/11] DSA driver for Vitesse Felix switch
To:     David Miller <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 at 22:32, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Thu, 14 Nov 2019 17:03:19 +0200
>
> > This series builds upon the previous "Accomodate DSA front-end into
> > Ocelot" topic and does the following:
> >
> > - Reworks the Ocelot (VSC7514) driver to support one more switching core
> >   (VSC9959), used in NPI mode. Some code which was thought to be
> >   SoC-specific (ocelot_board.c) wasn't, and vice versa, so it is being
> >   accordingly moved.
> > - Exports ocelot driver structures and functions to include/soc/mscc.
> > - Adds a DSA ocelot front-end for VSC9959, which is a PCI device and
> >   uses the exported ocelot functionality for hardware configuration.
> > - Adds a tagger driver for the Vitesse injection/extraction DSA headers.
> >   This is known to be compatible with at least Ocelot and Felix.
>
> Series applied, thank you.

Thank you!

-Vladimir
