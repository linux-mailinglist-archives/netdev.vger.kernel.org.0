Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845D42C7B0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfE1NVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:21:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfE1NVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 09:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i64Om2On/mcQqa9gv4z3sNNCwUNyxOxPBgNZDeZjrQ4=; b=cyLB29TQrG52ZqHClndRqRwFLn
        DkHF/7a4+xplVQLF2Duzdxu3QSkC+Hhu8DhS1rm3coOrrqpFLTFnXO/ZYU06g23bipKEnA+M7J0Jb
        nTWDgpWEutt/tpzRVExcmwz/uTHV1ajk0va0g1N37magTw673EH3RzUeL6n17+CKfTDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVc2q-0006HA-Rh; Tue, 28 May 2019 15:21:36 +0200
Date:   Tue, 28 May 2019 15:21:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH 4/8] ARM/net: ixp4xx: Pass ethernet physical base as
 resource
Message-ID: <20190528132136.GC18059@lunn.ch>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-5-linus.walleij@linaro.org>
 <20190524200012.GP21208@lunn.ch>
 <da114d45-5649-b525-039a-470f45d50386@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da114d45-5649-b525-039a-470f45d50386@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>  /* Built-in 10/100 Ethernet MAC interfaces */
> >>+static struct resource fsg_eth_npeb_resources[] = {
> >>+	{
> >>+		.start		= IXP4XX_EthB_BASE_PHYS,
> >>+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
> >
> >Hi Linus
> >
> >It is a long time since i did resources. But i was always told to use
> >the SZ_ macros, so SZ_4K. I also think 0xfff is wrong, it should be
> >0x1000.
> 
>    No, 0x0fff is correct there, 0x1000 is not...

Yes, the DEFINE_RES_* macros make this clear. The code should be
changed to use them, and then SZ_ macros can be used, since
DEFINE_RES_NAMED() does a - 1.

	Andrew
