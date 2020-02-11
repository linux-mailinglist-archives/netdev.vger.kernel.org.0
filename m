Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7B159C2A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgBKW0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:26:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbgBKW0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FTbc6NWScTx2sMAyMo0DXlq+GgMPVN13Zi2VFXkQ5NQ=; b=osmpEyybgIujO885bvEjDsmCfE
        rKPM5qtQkwuJ5S+jzyGh+X20JBzUCJpD4L5chAuCV6Iq3sfnOmZxf4P6XDBSfCY7Y5FK938LtFVLV
        4dZYvibf2P2pNxgItfmFVMP53Y0y3/4hNROve54Z1zPdzOG60mvjXVFxbyni7oVcZ7pg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j1dxq-0003J4-92; Tue, 11 Feb 2020 23:25:06 +0100
Date:   Tue, 11 Feb 2020 23:25:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: [PATCH 03/14] net: davicom: dm9000: allow to pass MAC address
 through mac_addr module parameter
Message-ID: <20200211222506.GP19213@lunn.ch>
References: <cover.1581457290.git.hns@goldelico.com>
 <4e11dd4183da55012198824ca7b8933b1eb57e4a.1581457290.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e11dd4183da55012198824ca7b8933b1eb57e4a.1581457290.git.hns@goldelico.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 10:41:20PM +0100, H. Nikolaus Schaller wrote:
> This is needed to give the MIPS Ingenic CI20 board a stable MAC address
> which can be optionally provided by vendor U-Boot.
> 
> For get_mac_addr() we use an adapted copy of from ksz884x.c which
> has very similar functionality.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

Hi Nikolaus

Please split these patches by subsystem. So this one patch needs to go
via netdev.

> +static char *mac_addr = ":";
> +module_param(mac_addr, charp, 0);
> +MODULE_PARM_DESC(mac_addr, "MAC address");

Module parameters are not liked.

Can it be passed via device tree? The driver already has code to get
it out of the device tree.

   Andrew
