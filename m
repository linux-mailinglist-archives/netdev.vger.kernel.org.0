Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B5335E2E2
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbhDMP36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbhDMP3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:29:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3732C061756;
        Tue, 13 Apr 2021 08:29:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso10860102pji.3;
        Tue, 13 Apr 2021 08:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Tzst4teGsUoIZnd0R8IxVImn0/EL/BJJDcQq4MQFjo4=;
        b=S3zmzlLlDts+/gEFYumbHLX8X8Rqk/4FnMtLjuXf4L718dbKhoPzjH8zhXtIOQkflS
         Y8edxv/En47poNL0GJVtLjpfb7dQP2kJKH4wKemMoEA1ARslDPSaooNJRFal0iE2UuGV
         NemLLy+CofV/dML0jLBe6e6XFpkFzko+n4gK8X9kAhEMm9jXapQyHRIv0aS0DEz+7JuX
         FqkiwdFOcHfwwCqCRbq0JeBiC6ilqfXJNdv99SI0mXpaqUq9Ms+t+DW84pCrednE5fpK
         mADBd+KVY8nBuBWQpZ5e+OVT6RIBnEVokaYZnDrRQHNSY2LGN8vTqgqsJL9zYS4g6o/E
         M0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Tzst4teGsUoIZnd0R8IxVImn0/EL/BJJDcQq4MQFjo4=;
        b=s+urnDC+xRl1uiAOoeKV/bSyUUAoSQ5OC0CqxlZuUN3QCxkq6vzMZuAGaw6l/JUh0c
         Z5PE3WH0KjJWhaa3s63I/fzQizDXFunb8x7RRrELiTlnoozRA7aRxgOzuzbSoDzfW3rQ
         vDblGdIDcoyQhxsdovnON+MOdR6Hf+Y1aNs3UyDyxwF0Vbh1Y5pqvYhtv/cSLyfBnqSK
         2IMTScPs530wg6VVlgdWq4GHhIoM8FJ68rjzaPL+yQETCb96srlmpxHjj4ar2WcFyCjz
         FCtopAhfttm24o3hBQf+VFu9ATRCllgbi3bMyT3npIacnQK4ut3spA1jmfWlg+4AoSEJ
         rGjw==
X-Gm-Message-State: AOAM531G2kgy5v1YCkJ3sETHKTx1GQS+i98hAzMIpGZUoVaB/vcoLD1y
        ++NBz6NAVtIcGiHPo0e1qzc=
X-Google-Smtp-Source: ABdhPJwYeKgUkvJZKeaa5VJTZBxqfvRjLXKooh+l9jFPdIugJz+CK1Rw/1dRmLCAvQuTmAGRkjejTg==
X-Received: by 2002:a17:90b:1bce:: with SMTP id oa14mr587690pjb.9.1618327771605;
        Tue, 13 Apr 2021 08:29:31 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g4sm14852078pgu.46.2021.04.13.08.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 08:29:30 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Ungerer <gerg@kernel.org>
Subject: Re: [RFC v4 net-next 2/4] net: dsa: mt7530: add interrupt support
Date:   Tue, 13 Apr 2021 23:29:20 +0800
Message-Id: <20210413152920.2190769-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YHWUK+tG3v9ZU/DT@lunn.ch>
References: <20210412034237.2473017-1-dqfext@gmail.com> <20210412034237.2473017-3-dqfext@gmail.com> <87fszvoqvb.wl-maz@kernel.org> <20210412152210.929733-1-dqfext@gmail.com> <YHTgu1+6GZFdFgWJ@lunn.ch> <8735vuobfo.wl-maz@kernel.org> <YHWUK+tG3v9ZU/DT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 02:52:59PM +0200, Andrew Lunn wrote:
> > I guess this is depends whether the most usual case is to have all
> > these interrupts being actively in use or not. Most interrupts only
> > use a limited portion of their interrupt space at any given time.
> > Allocating all interrupts and creating mappings upfront is a waste of
> > memory.
> > 
> > If the use case here is that all these interrupts will be wired and
> > used in most cases, then upfront allocation is probably not a problem.
> 
> Hi Marc
> 
> The interrupts are generally used. Since this is an Ethernet switch,
> generally the port is administratively up, even if there is no cable
> plugged in. Once/if a cable is plugged in and there is a link peer,
> the PHY will interrupt to indicate this.
> 
> The only real case i can think of when the interrupts are not used is
> when the switch has more ports than connected to the front panel. This
> can happen in industrial settings, but not SOHO. Those ports which
> don't go anywhere are never configured up and so the interrupt is
> never used.

Hi Andrew

This is what the extra check (BIT(p) & ds->phys_mii_mask) avoids.

Currently the mv88e6xxx driver does not have this check, and creates
15 PHY IRQ mappings on my 88E6176 unconditionally, leaving a gap in
/proc/interrupts:

...
 57:          0          0  mv88e6xxx-g1   3 Edge      mv88e6xxx-f1072004.mdio-mii:00-g1-atu-prob
 59:          0          0  mv88e6xxx-g1   5 Edge      mv88e6xxx-f1072004.mdio-mii:00-g1-vtu-prob
 61:          8          5  mv88e6xxx-g1   7 Edge      mv88e6xxx-f1072004.mdio-mii:00-g2
 63:          8          4  mv88e6xxx-g2   0 Edge      mv88e6xxx-1:00
 64:          0          0  mv88e6xxx-g2   1 Edge      mv88e6xxx-1:01
 65:          0          0  mv88e6xxx-g2   2 Edge      mv88e6xxx-1:02
 66:          0          0  mv88e6xxx-g2   3 Edge      mv88e6xxx-1:03
 67:          0          2  mv88e6xxx-g2   4 Edge      mv88e6xxx-1:04
// IRQ 68~77 are created but not used
 78:          0          0  mv88e6xxx-g2  15 Edge      mv88e6xxx-f1072004.mdio-mii:00-watchdog
...

You may as well add irq_set_nested_thread(irq, true) to irq_domain_map
so all IRQs share a single thread.

> 
>       Andrew
