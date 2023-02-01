Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923B9687143
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjBAWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBAWyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:54:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F9B65EFC;
        Wed,  1 Feb 2023 14:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mVUi9b3avKXCGkK7PJdGHQrWxThubRuQlGj56CQ3xTs=; b=phPs7X3hpkW4twrII4KP+oIuET
        4nkK2sS9ogAQ42Cv1E2uaa9OELjfE0Ew6d7R9PCAUZPfGFHTyWCc77NEmNYHXcnYh3+w7r8yx+H4u
        s71F26uf904LTKwha30xsCWc1QdFugAfeUOppDJ9Ju7JDLhUo30bvn7K7rlmoY4boy6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNLzO-003qJ4-Ao; Wed, 01 Feb 2023 23:54:02 +0100
Date:   Wed, 1 Feb 2023 23:54:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: fec: do not double-parse
 'phy-reset-active-high' property
Message-ID: <Y9rtil2/y3ykeQoF@lunn.ch>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
 <20230201215320.528319-2-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201215320.528319-2-dmitry.torokhov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 01:53:20PM -0800, Dmitry Torokhov wrote:
> Conversion to gpiod API done in commit 468ba54bd616 ("fec: convert
> to gpio descriptor") clashed with gpiolib applying the same quirk to the
> reset GPIO polarity (introduced in commit b02c85c9458c). This results in
> the reset line being left active/device being left in reset state when
> reset line is "active low".
> 
> Remove handling of 'phy-reset-active-high' property from the driver and
> rely on gpiolib to apply needed adjustments to avoid ending up with the
> double inversion/flipped logic.

I searched the in tree DT files from 4.7 to 6.0. None use
phy-reset-active-high. I'm don't think it has ever had an in tree
user.

This property was marked deprecated Jul 18 2019. So i suggest we
completely drop it.

	   Andrew
