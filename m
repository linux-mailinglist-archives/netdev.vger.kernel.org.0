Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CEE433A9D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJSPhk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Oct 2021 11:37:40 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:50899 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhJSPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:37:38 -0400
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 4EE0E240010;
        Tue, 19 Oct 2021 15:35:21 +0000 (UTC)
Date:   Tue, 19 Oct 2021 17:35:20 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
Message-ID: <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
In-Reply-To: <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
        <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Geert,

Thanks for the review.

On Tue, 19 Oct 2021 17:13:52 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > The ravb MAC is adding RX delay if RGMII_RXID is selected and TX delay
> > if RGMII_TXID but that behavior is wrong.
> > Indeed according to the ethernet.txt documentation the ravb configuration  
> 
> Do you mean ethernet-controller.yaml?

Doh, yes, I paste the commit log from the older Kernel git and forget to
change that.

> 
> > should be inverted:
> >   * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
> >      should not add an RX delay in this case)
> >   * "rgmii-txid" (RGMII with internal TX delay provided by the PHY, the MAC
> >      should not add an TX delay in this case)
> >
> > This patch inverts the behavior, i.e adds TX delay when RGMII_RXID is
> > selected and RX delay when RGMII_TXID is selected.
> >
> > Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>  
> 
> Does this fix an actual problem for you?

In fact, this fix a problem for an older 4.14 Kernel on my current project.
I wanted to push my fix in the mainline kernel also, but as you say below, now
this code is legacy.
Does it matter to fix legacy code?

> Note that in accordance with the comment above, the code section
> below is only present to support old DTBs.  Contemporary DTBs rely
> on the now mandatory "rx-internal-delay-ps" and "tx-internal-delay-ps"
> properties instead.
> Hence changing this code has no effect on DTS files as supplied with
> the kernel, but may have ill effects on DTB files in the field, which
> rely on the current behavior.

When people update the kernel version don't they update also the devicetree?

Regards,
Köry
