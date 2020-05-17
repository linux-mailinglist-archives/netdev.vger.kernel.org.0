Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C6B1D6C47
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgEQT0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:26:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgEQT0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nOykvvL9rF7kGCcAgVB4XTRQeBFNz9yBOx0MAIbGe2s=; b=HP4eMrwzO4l45QN/5bKJpbpnsn
        vhqzkXwjiKGBJ/873dAJ/Q4ynzmbXbqMfCGg7B2TCoI+1jx+bg4i51SLCGRYbF5QBWexBC3j6488f
        e08o7qAmTcu0a0mrvC5sVEKIv9xnBHlJWDYXJvgFul6ORrsgkLuoSN+QJIKTATIL+DMk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaOvc-002YY4-Ue; Sun, 17 May 2020 21:26:28 +0200
Date:   Sun, 17 May 2020 21:26:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        lukas@wunner.de, ynezz@true.cz, yuehaibing@huawei.com
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200517192628.GF606317@lunn.ch>
References: <20200517003354.233373-1-marex@denx.de>
 <20200516.190225.342589110126932388.davem@davemloft.net>
 <a68af5dd-d12c-f645-f89f-3967cc64e8df@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a68af5dd-d12c-f645-f89f-3967cc64e8df@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So I was already led into reworking the entire series to do this
> inlining once, after V1. It then turned out it's a horrible mess to get
> everything to compile as modules and built-in and then also only the
> parallel/SPI as a module and then the other way around.

Maybe consider some trade offs. Have both sets of accessors in the
core, and then thin wrappers around it to probe on each bus type. You
bloat the core, but avoid the indirection. You can also have the core
as a standalone module, which exports symbols for the wrappers to
use. It does take some Kconfig work to get built in vs modules
correct, but there are people who can help. It is also not considered
a regression if you reduce the options in terms of module vs built in.

   Andrew
