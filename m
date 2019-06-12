Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CF84274F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439349AbfFLNQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:16:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437430AbfFLNQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 09:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZldakM9EWSeIneK5Mkn/ppneVbLd1+j1SRpOUGdQOH8=; b=XnSXT6Ubg98Jo9eUBlSoAHDTar
        I+dFWF4SzY6g56RnubYm7lqGcoF/KQaycNSGFSezHp8qmEK99EtMDvOwnB/EeN4RhZV8fJpO/P9hi
        nw/h94rALJhTVODhD2uYKiFowY2VDxH7uoObey9egacHOAacrZQGB6CNpOFr01kki8dE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb37P-0004Ju-2w; Wed, 12 Jun 2019 15:16:47 +0200
Date:   Wed, 12 Jun 2019 15:16:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: net: dsa: fix warning same module names
Message-ID: <20190612131647.GD23615@lunn.ch>
References: <20190612081147.1372-1-anders.roxell@linaro.org>
 <CACRpkdbhRAdybqKdMgyM9Jy=eSJaRHjTpuOZO=KBgeaCbcP88Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbhRAdybqKdMgyM9Jy=eSJaRHjTpuOZO=KBgeaCbcP88Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 02:36:44PM +0200, Linus Walleij wrote:
> On Wed, Jun 12, 2019 at 10:11 AM Anders Roxell <anders.roxell@linaro.org> wrote:
> 
> > When building with CONFIG_NET_DSA_REALTEK_SMI and CONFIG_REALTEK_PHY
> > enabled as loadable modules, we see the following warning:
> >
> > warning: same module names found:
> >   drivers/net/phy/realtek.ko
> >   drivers/net/dsa/realtek.ko
> >
> > Rework so the driver name is rtl8366 instead of realtek.
> >
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> 
> Sorry for giving bad advice here on IRC... my wrong.
> 
> > -obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek.o
> > -realtek-objs                   := realtek-smi.o rtl8366.o rtl8366rb.o
> > +obj-$(CONFIG_NET_DSA_REALTEK_SMI) += rtl8366.o
> > +rtl8366-objs                   := realtek-smi.o rtl8366-common.o rtl8366rb.o
> 
> What is common for this family is not the name rtl8366
> (there is for example rtl8369 in this family, we just haven't
> added it yet) but the common technical item is SMI.

Hi Linus

I was not sure about this. I thought SMI was the bus used to
communicate with the switch. It just seemed odd to call a switch
family after the bus.

Anyway, if you are happy with the name realtek-smi: 

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
