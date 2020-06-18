Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48D61FF7FA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbgFRPtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgFRPtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:49:41 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED185206FA;
        Thu, 18 Jun 2020 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495381;
        bh=hFKgQ5zIlUVwUCd4vemsKp/qhEI0+cfFJWwn9Vu0YNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kgm5SWFi48YXkeSnjiXt2jLyDZu2R3Dhkcwbl0HLsPDJG7FkplrXQnNmwHfBVZBZ7
         pZl9QGptPbOZOFg4Bjal7xKEjpYM7tYqSNQ/wppWB16NUPRK5EqSxiMHWeyzbpWoaA
         W4bTIuAmk46yzxz7RnhiUBXvGbVQ6e008hQrNEck=
Date:   Thu, 18 Jun 2020 08:49:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     davem@davemloft.net, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: Re: [PATCH v5 3/3] net: phy: mscc: handle the clkout control on
 some phy variants
Message-ID: <20200618084939.3f07f13e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618121139.1703762-4-heiko@sntech.de>
References: <20200618121139.1703762-1-heiko@sntech.de>
        <20200618121139.1703762-4-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 14:11:39 +0200 Heiko Stuebner wrote:
> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
>=20
> At least VSC8530/8531/8540/8541 contain a clock output that can emit
> a predefined rate of 25, 50 or 125MHz.
>=20
> This may then feed back into the network interface as source clock.
> So expose a clock-provider from the phy using the common clock framework
> to allow setting the rate.
>=20
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

Doesn't build with allmodconfig:

../drivers/net/phy/mscc/mscc_macsec.c:391:42: warning: cast from restricted=
 sci_t
../drivers/net/phy/mscc/mscc_macsec.c:393:42: warning: restricted sci_t deg=
rades to integer
../drivers/net/phy/mscc/mscc_macsec.c:400:42: warning: restricted __be16 de=
grades to integer
../drivers/net/phy/mscc/mscc_macsec.c:606:34: warning: cast from restricted=
 sci_t
../drivers/net/phy/mscc/mscc_macsec.c:608:34: warning: restricted sci_t deg=
rades to integer
../drivers/net/phy/mscc/mscc_macsec.c:391:42: warning: cast from restricted=
 sci_t
../drivers/net/phy/mscc/mscc_macsec.c:393:42: warning: restricted sci_t deg=
rades to integer
../drivers/net/phy/mscc/mscc_macsec.c:400:42: warning: restricted __be16 de=
grades to integer
../drivers/net/phy/mscc/mscc_macsec.c:606:34: warning: cast from restricted=
 sci_t
../drivers/net/phy/mscc/mscc_macsec.c:608:34: warning: restricted sci_t deg=
rades to integer
In file included from ../drivers/net/phy/mscc/mscc_macsec.c:17:
../drivers/net/phy/mscc/mscc.h:371:16: error: field =C3=A2=E2=82=AC=CB=9Ccl=
kout_hw=C3=A2=E2=82=AC=E2=84=A2 has incomplete type
  371 |  struct clk_hw clkout_hw;
      |                ^~~~~~~~~
make[5]: *** [drivers/net/phy/mscc/mscc_macsec.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/net/phy/mscc] Error 2
make[3]: *** [drivers/net/phy] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
