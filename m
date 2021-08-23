Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05723F5199
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhHWT7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:59:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhHWT7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GpyOlPjzkVman/xz6U9nRO0hrxXvVycp3ftxTY9a7NE=; b=KA2u/854Aag+RH3uz7vKq/MMSv
        rhyn0HsPvD6jQ6R5qbpNU6feqBmdpCE/utd3Fc7QUNTfasXY0+S7AlD/IIekWVdh6W5e78QKCcXs5
        Xu26CuvkmjF6Wgw5ClUibFJqPzx+oZfVEMPYP1AFibW7pdv9ehRX/7KantFyCCRIJBlQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mIG5E-003Vi4-U5; Mon, 23 Aug 2021 21:58:12 +0200
Date:   Mon, 23 Aug 2021 21:58:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for
 "phy-handle" property
Message-ID: <YSP91FfbzUHKiv+L@lunn.ch>
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com>
 <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
 <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> PHY seems to be one of those cases where it's okay to have the
> compatible property but also okay to not have it.

Correct. They are like PCI or USB devices. You can ask it, what are
you? There are two registers in standard locations which give you a
vendor and product ID. We use that to find the correct driver.

You only need a compatible when things are not so simple.

1) The IDs are wrong. Some silicon vendors do stupid things

2) Chicken/egg problems, you cannot read the ID registers until you
   load the driver and some resource is enabled.

3) It is a C45 devices, e.g. part of clause 45 of 802.3, which
   requires a different protocol to be talked over the bus. So the
   compatible string tells you to talk C45 to get the IDs.

4) It is not a PHY, but some sort of other MDIO device, and hence
   there are no ID registers.

Andrew
