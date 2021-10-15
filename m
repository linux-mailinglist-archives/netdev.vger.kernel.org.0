Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847D542FC99
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbhJOT5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242867AbhJOT5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E64A61181;
        Fri, 15 Oct 2021 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634327729;
        bh=uKWdkwX9NSpxgNBJUsKI6brrTvS5lkZVCUyevjasO24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VUWIy5Fv534KjAIcIc4BeurLiZrgBQGhUIc+tNGNCGwSSgMTryAKKzaXG6Lf2ExLQ
         nUimrhT6T448pHEv+OJK9rN58B+fiLxSjN3MzyZ9Yz7L2UtkR8rALhcyiJPXmkCSS5
         Uknr+liDuXPKBoe3nffM4bIgNKhRsIUBz7jlrnQHlt14Z80MLNJ34Q3HOuRK3VwL9p
         SnyTZSH2BwiYCo1PIAmZ6HQKmoZDkH7PDBBI5AuNc3myDD1xs2JQXpMlmwr86dTYsH
         3LcO6QOJVjPiCky1F71vuAB04UiePhkedgbqJ/+JrMFIKC2LGv9Hz4X0yb6CtBPose
         e/biAPjuXycog==
Date:   Fri, 15 Oct 2021 12:55:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add
 {rx,tx}-internal-delay-ps
Message-ID: <20211015125527.28445238@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1634221864.138006.3295871.nullmailer@robh.at.kernel.org>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
        <20211013222313.3767605-6-vladimir.oltean@nxp.com>
        <1634221864.138006.3295871.nullmailer@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 09:31:04 -0500 Rob Herring wrote:
> On Thu, 14 Oct 2021 01:23:12 +0300, Vladimir Oltean wrote:
> > Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explicit
> > MAC-level RGMII delays. These properties must be per port and must be
> > present only for a phy-mode that represents RGMII.
> > 
> > We tell dsa.yaml that these port properties might be present, we also
> > define their valid values for SJA1105. We create a common definition for
> > the RX and TX valid range, since it's quite a mouthful.
> > 
> > We also modify the example to include the explicit RGMII delay properties.
> > On the fixed-link ports (in the example, port 4), having these explicit
> > delays is actually mandatory, since with the new behavior, the driver
> > shouts that it is interpreting what delays to apply based on phy-mode.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):

FWIW I dropped the set from pw based on Rob's report, I see a mention
of possible issues with fsl-lx2160a-bluebox3.dts, but it's not clear
to me which DT is disagreeing with the schema.. or is the schema itself
not 100?
