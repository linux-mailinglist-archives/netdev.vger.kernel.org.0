Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB6243735D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 09:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhJVIAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 04:00:16 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:27014 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhJVIAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 04:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634889478; x=1666425478;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tdPdMXT5NI9kQCZLp2Ql9uP6lZACsG/bkmj55NJvKW4=;
  b=INlnzkMv+VZhCwn7piK1ge28acEFfMzkflPcUlwdEE8Xn38vY6vCxF/F
   UMN5+/U3BoXYPo4BqGDNyHYTEJyf3H/4gEEU1Xw2XywYhH2KTwmrh+quU
   gAWHSb4d19aD0GvAnJOGWBq+/TAOJphYN/QgVqJIkQMt0SQvWXndAC1PD
   MMZOttNVE3Z1coen43y8F7kTlGcaV8q30ZEJxbjmrtKdwkDMCLbIIstKX
   paEpuRlNjJWXjgs+/8HOdwSLNnyZjP4X0YWy8vNmg5YJGcSXxuk24FHSs
   IKYO+PVSH7Zwsp4Gdfuv4u6ZY6szWozoUyJDzIQG6L9CkF9S+M/DlPsxQ
   g==;
X-IronPort-AV: E=Sophos;i="5.87,172,1631570400"; 
   d="scan'208";a="20184798"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 22 Oct 2021 09:57:57 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 22 Oct 2021 09:57:57 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 22 Oct 2021 09:57:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634889477; x=1666425477;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tdPdMXT5NI9kQCZLp2Ql9uP6lZACsG/bkmj55NJvKW4=;
  b=i6W/kdtk6giP9ry+WTZw1yXlvurTjWCVEXvxUJBTvBdu+AVc0uGm0giT
   dv4Du9DaanZIECqN08O9yYr4ZWhPlxg0EBCQ7weNOfrgi2Clxxn6NelD1
   ps7vnSu3cQhjW06RIcFSBPz6Gl6uqXCvCXZPhGD78eRuhhQbIECDNVm83
   Tf/Big1x1arCTt5/ZiAgillNQfj5PwB5kBCaJnSRpvJ0zqr1yfakZElQZ
   LtEwt+jfTCtdL0LlsI5IbXoVMxL9a1jx1jPHr25Oi4qJD4LiSusgItRYR
   q62FIQcUMJ9/ZbN28BFCyMpRYQff7uePI+1VSJjICSuUmyrQyYr7wXHsS
   g==;
X-IronPort-AV: E=Sophos;i="5.87,172,1631570400"; 
   d="scan'208";a="20184797"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 22 Oct 2021 09:57:57 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id DB892280065;
        Fri, 22 Oct 2021 09:57:56 +0200 (CEST)
Message-ID: <7a478c1f25d2ea96ff09cee77d648e9c63b97dcf.camel@ew.tq-group.com>
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is
 not available
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 22 Oct 2021 09:57:54 +0200
In-Reply-To: <YXFh/nLTqvCsLAXj@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
         <YW7SWKiUy8LfvSkl@lunn.ch>
         <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
         <YXBk8gwuCqrxDbVY@lunn.ch>
         <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
         <YXFh/nLTqvCsLAXj@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-21 at 14:50 +0200, Andrew Lunn wrote:
> > I would love to do this, but driver-api/driver-model/driver.rst
> > contains the following warning:
> > 
> >       -EPROBE_DEFER must not be returned if probe() has already created
> >       child devices, even if those child devices are removed again
> >       in a cleanup path. If -EPROBE_DEFER is returned after a child
> >       device has been registered, it may result in an infinite loop of
> >       .probe() calls to the same driver.
> > 
> > My understanding of this is that there is simply no way to return
> > -EPROBE_DEFER after fec_enet_mii_init(pdev).
> 
> It might say that, but lots of network drivers actually do this. I've
> not seen an endless loop.
> 
>     Andrew


Hmm, lots of network drivers? I tried to find an example, but all
drivers that generate -EPROBE_DEFER for missing PHYs at all don't have
an internal MDIO bus and thus avoid the circular dependency.

Matthias

