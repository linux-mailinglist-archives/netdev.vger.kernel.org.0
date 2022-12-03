Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAB641447
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiLCF2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLCF2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:28:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E382ED7C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 21:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED55060244
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 05:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145CAC433D6;
        Sat,  3 Dec 2022 05:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670045300;
        bh=xw3slfv2qUji52K9ulT7Br7krSnnmwd+fUNIGmjMFJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wpqyx41nl3LIR5Qg4ZW04ZW5DzFX3OoyPgVDpAqYveXzxPHLlQx30ztQMQPuOb5h6
         JDyRz7T4dS4fpK2wEJDvBk3szUeQ33VZef3FC3c7sE11cpnyyyFEMigCAaWOg5gFR0
         jTOtgClH1FffwsGELQfmuHlZ1uz3BdZ2b4z3SzEhct1ldi/xiWcPX/yTePxlHoGXPb
         qE4GsTxZ1Zm1iJgSNpY3oFqh0OVYCSdvgOlLjHK1kRHfa4Q+LHEp+tUkhkQ33Me9kW
         pO43UgAJIpigbTQSXVn5wU/OYJoknMFfQGUSntRORbd0u7IlbRLB+zaZSym5SVaQIU
         58YqzZtlTxbMA==
Date:   Fri, 2 Dec 2022 21:28:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: sfp: clean up i2c-bus property parsing
Message-ID: <20221202212819.6e601b99@kernel.org>
In-Reply-To: <E1p13A4-0096Qh-TW@rmk-PC.armlinux.org.uk>
References: <E1p13A4-0096Qh-TW@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Dec 2022 10:20:52 +0000 Russell King (Oracle) wrote:
> We currently have some complicated code in sfp_probe() which gets the
> I2C bus depending on whether the sfp node is DT or ACPI, and we use
> completely separate lookup functions.
> 
> This could do with being in a separate function to make the code more
> readable, so move it to a new function, sfp_i2c_get(). We can also use
> fwnode_find_reference() to lookup the I2C bus fwnode before then
> decending into fwnode-type specific parsing.
> 
> A future cleanup would be to move the fwnode-type specific parsing into
> the i2c layer, which is where it really should be.

drivers/net/phy/sfp.c:2660:36: error: use of undeclared identifier 'args'
                acpi_handle = ACPI_HANDLE_FWNODE(args.fwnode);
                                                 ^
