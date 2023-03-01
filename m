Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431476A6679
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 04:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjCADbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 22:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCADbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 22:31:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B776537F06;
        Tue, 28 Feb 2023 19:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E755DCE0303;
        Wed,  1 Mar 2023 03:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E513C433EF;
        Wed,  1 Mar 2023 03:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677641467;
        bh=fW3904PJgw3j+HsO1R2YW+QmoNEMyPXHUuIAL0h85RA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U6nTkoJZ7g+fJoTbuaza1hac+RZrtDY12hBGhhv7Zg9yJdeBJPhi7xaIwrUKtj1ZJ
         SRJzlixfHjKzNIGvN7GZB3sxM8RwtDWn3AFCs7dmr5PNbohXl6KvUobXgYFua+NmfD
         6+ABVzTWN+VItSJesb1bt+TYxRjujagjjxYNkqdVrq7wki9HGb4AeXB3UXtWAua7hD
         nUhqK69P+o1nbDOhRRJUM/eTT/gEP+4l22AHu5fcSxlhR9WneqCboOZ3qHbj6/ykCc
         hkJJgaG6yCkPspzqm1F+Cf0c1i5ZX7lzexjVdLP5kW3FmGkGPmWC4Z/jSBdi1I8hnG
         Ik/rL5xWQ0EVw==
Date:   Tue, 28 Feb 2023 19:31:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ken Sloat <ken.s@variscite.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Message-ID: <20230228193105.0f378a9d@kernel.org>
In-Reply-To: <Y/4ba4s37NayCIwW@lunn.ch>
References: <20230228144056.2246114-1-ken.s@variscite.com>
        <Y/4VV6MwM9xA/3KD@lunn.ch>
        <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
        <Y/4ba4s37NayCIwW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 16:19:07 +0100 Andrew Lunn wrote:
> The Marvell PHYs also support a fast link down mode, so i think using
> fast link down everywhere, in the code and the commit message would be
> good. How about adin_fast_down_disable().

Noob question - does this "break the IEEE standard" from the MAC<>PHY
perspective or the media perspective? I'm guessing it's the former
and the setting will depend on the MAC, given configuration via the DT?
