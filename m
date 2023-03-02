Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A5B6A87CF
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCBRXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjCBRXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:23:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545F01C7DD
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 09:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D60706160D
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 17:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD0C433A0;
        Thu,  2 Mar 2023 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677777802;
        bh=QlUaI9YM2OKoLqI5rk+BPrX+1XMc8It7bT4E9dfu2FA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r5RA0F8l+kjTseXyormEX4PoTnyY+ocn+H+97+bx09/yw4L+TiC42tyrqlZBLP8Qx
         ObdF9gAQtUszItUafKybe2UN6ckUU55HiaJw0U7llsCII2e3RNePwRnKBQtrlWkoud
         yV+SN8ERjjI13V3RJPhsPZW1+ehAzvfQEPwP2Zt3gS+y7W+BZ6Um8R0hC7vysrFXr+
         w3+QvG6h1uutUOlNSPBvPM0LSuBAVdd6LDPzI9/ROd8M3pnXn5b1EknZkSAIuEgf07
         RGFWrii/xxg6jPpmv0wKLIpfzCpYh7l19k5dzN8DcZ8vzDeZbSw7xeTNthdrvtIseY
         fYhjTlmGIm/7w==
Date:   Thu, 2 Mar 2023 09:23:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230302092320.6ee8eb6d@kernel.org>
In-Reply-To: <20230302180616.7bcfc1ef@kmaincent-XPS-13-7390>
References: <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
        <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
        <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
        <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
        <20230228142648.408f26c4@kernel.org>
        <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
        <20230228145911.2df60a9f@kernel.org>
        <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
        <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
        <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
        <20230302084932.4e242f71@kernel.org>
        <20230302180616.7bcfc1ef@kmaincent-XPS-13-7390>
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

On Thu, 2 Mar 2023 18:06:16 +0100 K=C3=B6ry Maincent wrote:
> I have measured it with the Marvell PHY and MACB MAC but it is the contra=
ry on
> my side:
> https://lkml.kernel.org/netdev/20230302113752.057a3213@kmaincent-XPS-13-7=
390/
> Also PHY default seems more logical as it is nearer to the physical link,=
 but
> still I am interesting by the answer as I am not a PTP expert. Is really =
PTP
> MAC often more precise than PTP PHY?

Do you happen to have a datasheet for MACB? The time stamping
capability is suspiciously saved in a variable called hw_dma_cap
which may indicate it's a DMA time stamp not a true PTP stamp.

Quite a few NICs/MACs support DMA time stamps because it's far=20
easier to take the stamp where the descriptor writing logic is
(DMA block) than take it at the end of the MAC and haul it all=20
the way thru the pipeline back to the DMA block.
