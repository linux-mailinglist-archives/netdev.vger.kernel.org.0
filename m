Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0509A1B5B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfH2N0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:26:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfH2N0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UTDvZ2Lzi29K8AW5de07/8rgh6jmhbyZB+/k1sHFNh0=; b=BdWiBLYhoPJ8E/2KnS1JNO3IZB
        VeaYh4dwDR81JwLVv57FC2kJVWtJc7TFDGRS8Q9ZftlVB/tAxOJEDmrsPETF8C4Qo81JygYozy0fX
        rk5HhhRwcjvIMWQFomX7CcGSngZCwcqQonBb0qydxX9CEETn8wX47AumTmhyw8FOp7Y0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i3KRH-0002Ja-QQ; Thu, 29 Aug 2019 15:26:11 +0200
Date:   Thu, 29 Aug 2019 15:26:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829132611.GC6998@lunn.ch>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829095100.GH2312@nanopsycho>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> NACK
> 
> This is invalid usecase for switchdev infra. Switchdev is there for
> bridge offload purposes only.

Hi Jiri

I would argue this is for bridge offload. In another email, you say
promisc is promisc. Does that mean the Mellonox hardware forwards
every frame ingressing a port to the CPU by default as soon as it is
enslaved to a bridge and promisc mode turned on? Or course not. At the
moment, every switchdev driver wrongly implement promisc mode.

This patchset is about correctly implementing promisc mode, so that
applications can use it as expected. And that means configuring the
hardware bridge to also forward a copy of frames to the CPU.

I see trap as a different use case. tcpdump/pcap is not going to use
traps.

	Andrew
