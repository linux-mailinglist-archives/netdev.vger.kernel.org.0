Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1CD62434A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKJNeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKJNeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:34:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE86B850
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RgsVAepD3nxQVWROE+vTabZLY0EkelIOXRN6DmurrE8=; b=gTHc2y74GhWzebDyuYtsL9zDKH
        q23XnIZSsikB+Hp3XGbuF3sED4xGqBC1oy3TBZv+oYSxoli+No0wo1ilju7jfffTyRT649Zk9x1Ot
        hclpojJs7/71xOGbgg6+c59R01f1I/zCmiO+lSrsS0qNDRs7Szslb5W4pil0V4sJiCOE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7gh-0022EZ-6W; Thu, 10 Nov 2022 14:33:47 +0100
Date:   Thu, 10 Nov 2022 14:33:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <Y2z9u4qCsLmx507g@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-4-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109224752.17664-4-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:47:51PM -0500, David Thompson wrote:
> The BlueField-3 out-of-band Ethernet interface requires
> SerDes configuration. There are two aspects to this:
> 
> Configuration of PLL:
>     1) Initialize UPHY registers to values dependent on p1clk clock
>     2) Load PLL best known values via the gateway register
>     3) Set the fuses to tune up the SerDes voltage
>     4) Lock the PLL
>     5) Get the lanes out of functional reset.
>     6) Configure the UPHY microcontroller via gateway reads/writes
> 
> Configuration of lanes:
>     1) Configure and open TX lanes
>     2) Configure and open RX lanes

I still don't like all these black magic tables in the driver.

But lets see what others say.

    Andrew
