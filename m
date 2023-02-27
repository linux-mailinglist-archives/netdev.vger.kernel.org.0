Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A26A4A4D
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjB0StX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjB0StW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:49:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FA421A1D;
        Mon, 27 Feb 2023 10:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CA2E60EF8;
        Mon, 27 Feb 2023 18:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02C9C4339C;
        Mon, 27 Feb 2023 18:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677523760;
        bh=eJ8MvIHkEpCJVPtYBOWxQns0jpeoupbRfcPhZeOjCEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pkN5HEDL1t8XoUycV0JdtD7MDdEm+8RjOWzwxuHlu/44qNKOyqdnQOrP7NMJf8pZV
         hjVejLNF7YfqsRNfeom0U4EyhU5W40bjQz3GjjGJK/KtHEJ4hX9pG1hHFlX2C4ih4Y
         /L0FMn3Yh0ebQFesLQKMClBZ7vuHrITKe7jxA+ar4I+SjdUle7Vh5pgb8c+ZLQQWyJ
         Lw+wfDIK+8u+tQj9xV053s9uKtYzRtQWf6yW3H/gfEuxFs6wJVHLhQ7PDTvUBIish4
         xE4qPM7+UGffHIiXJcJHRwdnEGj8oTecLw8XBhmQkBUGs24DqQnwWLg4VXWAzd3+7c
         9aa2tkfdfTTBA==
Date:   Mon, 27 Feb 2023 10:49:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v8 5/9] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <20230227104918.6ceccf90@kernel.org>
In-Reply-To: <Y/yqwifeQBC3sSaD@sirena.org.uk>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
        <20230211074113.2782508-6-o.rempel@pengutronix.de>
        <Y/ufuLJdMcxc6f47@sirena.org.uk>
        <20230227055241.GC8437@pengutronix.de>
        <Y/yqwifeQBC3sSaD@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 13:06:10 +0000 Mark Brown wrote:
> They seem to work, thanks!  I had found and tried the second patch but
> it doesn't apply without the first series.  Will those patches be going
> to Linus for -rc1?  It's pretty disruptive to a bunch of the test
> infrastructure to not be able to NFS boot.

Should be in Linus's tree later today =F0=9F=A4=9E=EF=B8=8F
