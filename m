Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF3B6E320D
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjDOPLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 11:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOPLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 11:11:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A004040E3;
        Sat, 15 Apr 2023 08:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mUMMz3rp8IEVQrSOEiMiWpUL7z/Jd7A2vWVf0hs3jCo=; b=fofooCe7PUUw7wkQbYe2RAlV4j
        f//ZgC4sG6CrnXOq6eEsH8xQrQONX4e551ZcuwEURniC4B/WAufNpJ4Gml/yzzzPquiohxtR+D/Wu
        ArZClq7n8WP4acV13nlchZaOgtr2zk6NcgDmWRI1afvXBmq+NIHdjXaEr//F6I+AnuCE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pnhYO-00AN4Z-FP; Sat, 15 Apr 2023 17:11:04 +0200
Date:   Sat, 15 Apr 2023 17:11:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     'Wolfram Sang' <wsa@kernel.org>,
        'Jarkko Nikula' <jarkko.nikula@linux.intel.com>,
        netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master
 driver
Message-ID: <438840fa-6e8b-44c5-8b90-be521c72b77a@lunn.ch>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-3-jiawenwu@trustnetic.com>
 <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com>
 <09dc3146-a1c6-e1a3-c8bd-e9fe547f9b99@linux.intel.com>
 <ZDgtryRooJdVHCzH@sai>
 <01ec01d96ec0$f2e10670$d8a31350$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ec01d96ec0$f2e10670$d8a31350$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't quite understand how to get the clock rate. I tried to add a software
> node of clock with property ("clock-frequency", 100000) and referenced by
> I2C node. But it didn't work.

I've not spent the time to fully understand the code, so i could be
very wrong....

From what you said above, you clock is fixed? So maybe you can do
something like:

mfld_get_clk_rate_khz()

https://elixir.bootlin.com/linux/latest/source/drivers/i2c/busses/i2c-designware-pcidrv.c#L97

How are you instantiating the driver? Can you add to
i2_designware_pci_ids[]?

    Andrew
