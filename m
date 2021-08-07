Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCB13E3665
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 19:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhHGRBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 13:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhHGRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 13:00:56 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AF4C06179A;
        Sat,  7 Aug 2021 10:00:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hw6so20995653ejc.10;
        Sat, 07 Aug 2021 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1EJJUbdL6WaXY+N4elk2flfwKD7mCnq0x6VxUqgRTp8=;
        b=jFX7EI4aY19oVK3JUJCL4yCqND4HZKXiB3gsEKwUH2+xaqX5kYPNmZIy1FJ+/HVRed
         MUhNhu4Gebrf7FATjAAHDgOC10/1oT9bVMXBn1vnwmeQl0zIgAv+e1I5+NmucXlM10VS
         7pSyuA6gWOSEpWgLsUyZYokWf5d1hMdcgVXa27bY9tfpQtdrYWq/e8BU0cejKzIWwvL/
         UKBvTwHDsmGixiPZqcOzMlbeXiB8Lw7lthT4uJxEq7WeBdSfnoCBOMjxQ7ejQ1jbZGmS
         bY9e5q5u0yv+wozyNqaetxzc9DcPHc1CgCcQLF+PeY26LQgTy1lWKwHneGgAelSYaXS8
         9hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1EJJUbdL6WaXY+N4elk2flfwKD7mCnq0x6VxUqgRTp8=;
        b=UAcfu1uaFiFFZEqS0Eox4rpnUPnEckC/2ooviHLfOy75cfSqsJHNRuq5eQp3/3ZKuB
         SEcJa75tLsLLr37Mold+E6sQSAGT3ZF8UiipGcwk8ox/BcdArnlVWYs22iPELrAu9DHv
         38PtAJ25w7SbVWzZmHVyaeIjzmmqAn7ifHUO1hjZQoX6Dhdb5oQUmGOzWtQZ/Oby87HW
         0tbMM4PNx5c7LU7u0Fx+i54w0IEaOI4xF1LSZ3yo4Y+p1gqRnlxX6c0bFJYSwTNrqu85
         hduWcUvpIZtEcS5Qd0cnQYOIviYrlnegEp63DLk9JmiJtnDxm4i2JUh8r70qNe3z0cz7
         1kEA==
X-Gm-Message-State: AOAM533tpP6GGcJCNFmud6amOhm5+QKW4jufyzql1zSR/vS3LDP5pRrR
        D5xAW7M0hL5iNfnu4yWR+Zw=
X-Google-Smtp-Source: ABdhPJzM3ueNnAscJQGbz7Ma0xs1PETVVbDvqaeKzPUHCGpaKiBTbbiGyjcmljh/0sC1WplrGfFklw==
X-Received: by 2002:a17:907:a075:: with SMTP id ia21mr14985012ejc.147.1628355613332;
        Sat, 07 Aug 2021 10:00:13 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id u4sm3962185eje.81.2021.08.07.10.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 10:00:12 -0700 (PDT)
Date:   Sat, 7 Aug 2021 20:00:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210807170009.q2gjoraaheps2tub@skbuf>
References: <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
 <YQ6pc6EZRLftmRh3@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQ6pc6EZRLftmRh3@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 05:40:35PM +0200, Andrew Lunn wrote:
> I suspect it is a 50/50 roll of a dice what rx and tx actually
> mean. Is it from the perspective of the MAC or the PHY? Luckily,
> rgmii-rxid and rgmii-txid don't appear in DT very often.

I checked an NXP board schematic which has both, and:

When you connect a MAC to a PHY using RGMII, the RXD[3:0] pins of the
MAC connect to the RXD[3:0] pins of the PHY, and the TXD[3:0] goes to
TXD[3:0]. So it is neither the perspective of the MAC nor of the PHY.

When you connect a MAC to a MAC using RGMII, the RXD[3:0] of one MAC
goes to the TXD[3:0] of the other, and vice versa.

Nonetheless, a phy-mode of "rgmii-rxid" always means to the local MAC
that "the RX delays have been dealt with" - either by PCB traces, or a
remote MAC applying TX delay, or the PHY applying RX delay.
