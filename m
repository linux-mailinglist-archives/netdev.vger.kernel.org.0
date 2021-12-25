Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFFB47F39A
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 16:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhLYPQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 10:16:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhLYPQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Dec 2021 10:16:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1V61VPt57awWKS3Oz2V8gKxYnEMgb/khzTfF8nc3rl0=; b=sXM30RHmUnvzhG5O8a/+RR2Pzw
        9aRlsagZElcOkTJXfrzVBEIUVCqZoIrXdxdTaNYTg/qFD7eJuWIWDZFhYndxZh+CSyQVcZzAcS4C0
        CAdyB/VWViQJD18FGcJz0BaPm1Jl6JQur51iAjYM7rR6WhbtdLzzR41az/5Y/4eL5nSY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n18mA-00HTB4-1p; Sat, 25 Dec 2021 16:16:02 +0100
Date:   Sat, 25 Dec 2021 16:16:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] net: pxa168_eth: Use platform_get_irq() to get the
 interrupt
Message-ID: <Ycc1squoiTh0iyM/@lunn.ch>
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211224192626.15843-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAHp75VcurBNEcMFnAHTg8PTbJOhO7QA4iv1t4W=siC=D-AkHAw@mail.gmail.com>
 <CA+V-a8tuD-WKyRL_kwitqOyxJDMu1J14AtZ12LbSF9+8mj+=FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8tuD-WKyRL_kwitqOyxJDMu1J14AtZ12LbSF9+8mj+=FQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +               goto err_netdev;
> >> +       BUG_ON(dev->irq < 0);
> >
> >
> > ??? What is this and how it supposed to work?
> >
> .. should have been BUG_ON(dev->irq < 0);

Is this fatal to the machine as a whole, now way to recover, all that
can be done is to limit the damage while it explodes?

If not, please use WARN_ON(), not BUG_ON(). There is an email from
Linus about this, not using BUG_ON() in general.

   Andrew
