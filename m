Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3B31AEBB
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 03:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBNCTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 21:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhBNCTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 21:19:35 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC5DC061574;
        Sat, 13 Feb 2021 18:18:55 -0800 (PST)
Received: from [IPv6:2a02:810c:c200:2e91:dcab:323e:12bc:b21a] (unknown [IPv6:2a02:810c:c200:2e91:dcab:323e:12bc:b21a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7F23623E55;
        Sun, 14 Feb 2021 03:18:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613269133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jYade44Er++PL8gJFEA789aohz4aKYKKdcGATKb1jqc=;
        b=sd4oshakWlybWIb09uSI+tH8voecDPEVPFkyzqqMP26ZF3dTPGwwHll5XvpkQ3AiH56+ql
        QpqUh8NGcYR/QcJ665k2hmk4YihEqABtxlJAL5OHAeSdEAd2IqCwNTzFSewmgE7ZX2hXTQ
        QLMLrunvdFpcWGNNc1qjPiVFGxTEzYg=
Date:   Sun, 14 Feb 2021 03:18:49 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20210214015733.tfodqglq4djj2h44@skbuf>
References: <20210214010405.32019-1-michael@walle.cc> <20210214010405.32019-3-michael@walle.cc> <20210214015733.tfodqglq4djj2h44@skbuf>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next 2/2] net: phy: at803x: use proper locking in at803x_aneg_done()
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Michael Walle <michael@walle.cc>
Message-ID: <4ABD9AA0-94A3-4417-B6B2-996D193FB670@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 14=2E Februar 2021 02:57:33 MEZ schrieb Vladimir Oltean <olteanv@gmail=
=2Ecom>:
>Hi Michael,
>
>On Sun, Feb 14, 2021 at 02:04:05AM +0100, Michael Walle wrote:
>> at803x_aneg_done() checks if auto-negotiation is completed on the
>SGMII
>> side=2E This doesn't take the mdio bus lock and the page switching is
>> open-coded=2E Now that we have proper page support, just use
>> phy_read_paged()=2E Also use phydev->interface to check if we have an
>> SGMII link instead of reading the mode register and be a bit more
>> precise on the warning message=2E
>>
>> Signed-off-by: Michael Walle <michael@walle=2Ecc>
>> ---
>
>How did you test this patch?

I'm afraid it's just compile time tested=2E

-michael=20
