Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAC839F86E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhFHOHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 10:07:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233176AbhFHOHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 10:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=omHxetGSf7WvvYJIz4CtL+xJtQiHSODIemCHft0cr2A=; b=iE
        OybeMN7wY1+wMg1xRqw8c16xMPRhSuDIhcUcDTwMJdmkOASe08GQKjpV+1qKSiyUxhixe74HQ/NWH
        /sTZWkqQZ2IPJUnW/HdNOP3honl1nn/7H4XQOqNIsTpv1YEuLGaQhqdwtTxSWnoSfzZjh2sHqweVt
        Sgnkf6lyJ2kutWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqcLe-008Lsy-Lx; Tue, 08 Jun 2021 16:04:54 +0200
Date:   Tue, 8 Jun 2021 16:04:54 +0200
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
Subject: Re: [PATCH 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YL95BgJTv/jyAYr1@lunn.ch>
References: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YL6zYgGdqxqL9c0j@lunn.ch>
 <6532a195-65db-afb3-37a2-f68bfed9d908@wanyeetech.com>
 <YL9gr2QQ/YEXNUmP@lunn.ch>
 <62ad605f-3689-cab3-e43e-9b6954da8df3@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62ad605f-3689-cab3-e43e-9b6954da8df3@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 09:48:38PM +0800, Zhou Yanjie wrote:
> Hello Andrew,
> 
> On 2021/6/8 下午8:21, Andrew Lunn wrote:
> > Please wrap your text to around 75 characters per line.
> 
> 
> Sure.
> 
> 
> > 
> > I suspect you don't understand RGMII delays. As i said, normally, the
> > MAC does not add delays, the PHY does. Please take a closer look at
> > this.
> 
> 
> According to the description of ethernet-controller.yaml, "rgmii" seems
> 
> to allow MAC to add TX delay (the description in ethernet-controller.yaml
> 
> is "RX and TX delays are added by the MAC when required"), while rgmii-id
> 
> and rgmii-txid do not allow MAC to add delay (the description in
> 
> ethernet-controller.yaml is"RGMII with internal RX and TX delays provided
> 
> by the PHY, the MAC should not add the RX or TX delays in this case" and
> 
> "RGMII with internal TX delay provided by the PHY, the MAC should not add
> 
> an TX delay in this case"), I will add support for the other three RGMII
> modes
> 
> in the next version (I forgot to reply to this in the previous email).

Please follow the code all the way through. What gets passed to
phylink_create() is very important. If you have both the MAC and the
PHY adding delays, bad things will happen.

    Andrew
