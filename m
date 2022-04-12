Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518964FC944
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiDLAcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241416AbiDLAcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:32:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7000825586
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 17:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bm+IUItO5bfuLl2+06gfMmD7aKqXc2K7mQxSf0tpnNc=; b=bY0wkwTq9R7qqClMxQJkwLw1hy
        jHC1DG453Eq3M7Yop9p/MqQdCM3OHp7yR6j7wcgx4oFVzVaIehFAKL8VOtIyzCdnC2UPStlbrFUqP
        auTYluZN2SgJPx26wr2puGmoYD8QHVfAzwnaIVRRqxTqlrGcgxdXZcGRy1/a51tQPYaQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ne4Pk-00FLeB-Sa; Tue, 12 Apr 2022 02:29:48 +0200
Date:   Tue, 12 Apr 2022 02:29:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Josua Mayer <josua@solid-run.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Message-ID: <YlTH/IsKi/v8UHKv@lunn.ch>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220410104626.11517-2-josua@solid-run.com>
 <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
 <bc0e507b-338b-8a86-1a7b-8055e2cf9a3a@solid-run.com>
 <e0511d39-7915-3ce1-60c7-9d7739f1b253@linaro.org>
 <b519690c-a487-e64c-86e1-bd37e38dc7a7@solid-run.com>
 <20220411130715.516fc5cc@kernel.org>
 <YlSWz+XELKV3LK8s@lunn.ch>
 <20220411143315.6cd5484e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411143315.6cd5484e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 02:33:15PM -0700, Jakub Kicinski wrote:
> On Mon, 11 Apr 2022 22:59:59 +0200 Andrew Lunn wrote:
> > > Noob question - can you explain how this property describes HW?
> > > I thought we had a framework for clock config, and did not require
> > > vendor specific properties of this sort.
> > > 
> > > The recovered vs free running makes the entire thing sound like
> > > a SyncE related knob, irrelevant to normal HW operation.  
> > 
> > It is not necessarily SyncE. Fast Ethernet is based around a 25MHz
> > clock. Something needs to provide that clock. Sometimes the SoC/MAC
> > provides it, and passes it to the PHY. Sometimes the PHY provides it,
> > and passes it to the SoC/MAC.
> > 
> > There are a couple of PHYs which make use of the common clock
> > framework, when the SoC is the clock source. However, i don't think
> > there are any PHYs which provide a clock to the common clock framework
> > when they are the source. We do however have a number of vendor
> > properties to control the PHY clock output, disable the PHY clock
> > output, select the PHY clock output, etc. There is not too much
> > standardisation here, and it is made worse by some PHYs needing a
> > reset once the clock is ticking, some MACs stop the clock when the
> > link is administrative down, some PHYs stop the clock a short time
> > after the link goes down which can be bad for the MAC etc.
> 
> I see. Why would the MAC/SoC care if the clock is recovered or free
> running, tho?

Autoneg determines which link peer will be the master and which will
be the slave. The master provides the clock for the link. So the slave
PHY might want to pass through the recovered clock so it does not need
to deal with drift between the recovered clock and its own clock.

   Andrew
