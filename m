Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B2A3A2B37
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFJMRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:17:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhFJMRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 08:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xEv51sL5EtFzsgzhQPHw+OPzs2HAlZHNonW9nRpKG/U=; b=R/0HmcqT+8j+7PIsTRgOII6VSu
        zz/HCyX4LK9B0VENcHvghbxfRlYqWEJnFqy2mvGX2Rj/VN1xCuy6X2xhmbznaPz0FGkl+Bheyd2ZY
        0/QGwDu46fFKrzbDaxbCgeZuCEbxjSK7i30WGX3nm4j9mW7cuKJvb2Wp4+clHhP8Bv+0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrJaY-008eiZ-NU; Thu, 10 Jun 2021 14:15:10 +0200
Date:   Thu, 10 Jun 2021 14:15:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhou Yanjie <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YMICTvjyEAgPMH9u@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YMGEutCet7fP1NZ9@lunn.ch>
 <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The manual does not tell how much ps a unit is.
> 
> I am confirming with Ingenic, but there is no reply
> 
> at the moment. Can we follow Rockchip's approach?
> 
> According to the description in "rockchip-dwmac.yaml"
> 
> and the related code in "dwmac-rk.c", it seems that their
> 
> delay parameter seems to be the value used by the hardware
> 
> directly instead of ps.

We are much more strict about this now than before. You have to use
standard units and convert to hardware values. It also makes it a lot
easier for DT writers, if they have an idea what the units mean.

Having the MAC add small delays is something you can add later,
without breaking backwards compatibility. So if you cannot determine
what the units are now, just submit the glue driver without support
for this feature. If anybody really needs it, they can do the needed
research, maybe do some measurements, and then add the code.

    Andrew
