Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF676A44D4
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjB0Oku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjB0Oku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:40:50 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34D520564
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 06:40:48 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 54B97240003;
        Mon, 27 Feb 2023 14:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677508847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:in-reply-to;
        bh=Pw7fRpmGbqPXeKE6xKCSencNTawjDYDKm/L3pxtxJWc=;
        b=VtjhT6qx7j+7EBb0yBi8TtR3D8QKabA9fQuFdB+BVtBKxvA2IW2wG38PmE5oImRgL6m/SR
        kdEvUDuyX/GzuhDsrcrv0zZxgUhul6cPYJH0l6wa9rdbhGh9Xd4Kz/+zQMH/Mm5sEt4MN3
        rvahui3leNXmSF9SRMr89JBxzGsTuVVq0t7F/rYMgVnVi4q/PQwq7ZwZIVGrd+esvMb3JI
        m+0OLQq+meh0TTgL6+BldUNiGAes+BBWsnXRYtECwgT59unUWeWkkeMax7aJFtePflgcii
        BtS5ExnqdQuSGwY6byimDyVxwuR6jl2gzYlWCkR6xpK9R1ZdZlENot/6+syaOA==
Date:   Mon, 27 Feb 2023 15:40:37 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
In-Reply-To: <20200730124730.GY1605@shell.armlinux.org.uk>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
In-Reply-To: <20200730124730.GY1605@shell.armlinux.org.uk>
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

Hello RMK,

> Hence why I'm at the point of giving up; I don't see that PTP will be
> of very limited benefit on my network with all these issues, and in
> any case, NTP has been "good enough" for the last 20+ years.  Given
> that only a limited number of machines will be able to implement PTP
> support anyway, NTP will have to run along side it.

I see this patch has been abandoned.
I am testing it with a ZynqMP board (macb ethernet) and it seems to more or
less work. It got tx timestamp timeout at initialization but after some tim=
es
(~20 seconds) ptp4l manages to set it working. Also the IEEE 802.3
network PTP mode is not working, it constantly throw rx timestamp overrun
errors.
I will aim at fixing these issues and adding support to interrupts. It woul=
d be
good to have it accepted mainline. What do you think is missing for that? I=
 see
you faced issues with few Armada SOM and IP_MULTICAST, is it still the case?

I am new to the PTP and Ethernet APIs I will try to not speak nonsense but
please correct me if I do.


K=C3=B6ry
