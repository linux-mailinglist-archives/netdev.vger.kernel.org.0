Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0149D6A59DB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 14:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjB1NQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 08:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1NQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 08:16:36 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85782D15D
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 05:16:34 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AB37A60011;
        Tue, 28 Feb 2023 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677590193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHGNm+6dpxRt4D5yxnt/79E8gl0WLbnmUF0ncEejdoM=;
        b=VgYFZfNhhlEK1Y+pOlxUNXMVq2jleszIGORIUpX1Ijyqstj/J+Lo+azxrRLmHRhVmweUOn
        jCs6jlgHAud4pgX+vM1cljFnZFQyUh2uthIVLY1ycV/anRDtwd505e6AZ0d7a4NHvft6K7
        FlSHvxiFRUAjLpdNruTLkI/dgZz4ZmbFFXspEC1q3QyN/vkVvp/3wCAWuxEFY3rQCnuRVs
        DVPZQD5E3E2+4R5DFvnFNnvUBz4cjR9SvNXUiszLe9djYu/bjx+uwbuzZyZZm9sH3ZErDv
        ADZqzgZv3nFElFloO+EZTI8VwG5raLhpn3iriHOI/Yi2OJpp3/j0DZ/bv0tATQ==
Date:   Tue, 28 Feb 2023 14:16:30 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
In-Reply-To: <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
        <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
        <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
        <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
        <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
        <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 12:07:09 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> So yes, it's a nice idea to support multiple hardware timestamps, but
> I think that's an entirely separate problem to solving the current
> issue, which is a blocking issue to adding support for PTP on some
> platforms.

Alright, Richard can I continue your work on it and send new revisions of y=
our
patch series or do you prefer to continue on your own?
Also your series rise the question of which timestamping should be the defa=
ult,
MAC or PHY, without breaking any past or future compatibilities.
There is question of using Kconfig or devicetree but each of them seems to =
have
drawbacks:
https://lore.kernel.org/netdev/ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc/=20

Do you or Russell have any new thought about it?

Regards,
K=C3=B6ry
