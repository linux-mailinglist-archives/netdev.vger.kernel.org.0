Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023A62E1FBB
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 18:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgLWRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 12:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgLWRIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 12:08:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 933182229C;
        Wed, 23 Dec 2020 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608743250;
        bh=Tul9GE02D4kuMrXf8XkIEh/AjbOZAulo27rJPi4l0pI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qSNp5/hyMYbmggWwtV0ksWzRu5UyjSAn6Amx3xwfbuiJjtoZuwPXAT5zOKaSXfMJQ
         qlrqDtIpFK7FgTbWqTryBMexZ9B+uIJCHPYHOpcce2kVF1HXqyb6RR9xs3Ok5eqjbT
         mLHpDO/cQHg8kkNYQ/PyKQMMdbCJhirvpPMr5hX9VMEPgxJzdIl6xn0nbjztwLcJSo
         iOrIQIKoyyJcOdLCxHi0ogT0sVBRH5vsET9sCCOtXVfRzDquIK987fXcdW0zinKX/o
         46pcNrW2nVX7b6Uuk+u4ARDPKpStgsYOmw+kE0GAUNGQoLP89Zc3foeKy+i0MvjLjH
         AbNQkbpbHa3Aw==
Date:   Wed, 23 Dec 2020 09:07:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 3/4] net: phy: Add Qualcomm QCA807x driver
Message-ID: <20201223090728.38fa059d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222222637.3204929-4-robert.marko@sartura.hr>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
        <20201222222637.3204929-4-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 23:26:36 +0100 Robert Marko wrote:
> This adds driver for the Qualcomm QCA8072 and QCA8075 PHY-s.
>=20
> They are 2 or 5 port IEEE 802.3 clause 22 compliant
> 10BASE-Te, 100BASE-TX and 1000BASE-T PHY-s.
>=20
> They feature 2 SerDes, one for PSGMII or QSGMII connection with MAC,
> while second one is SGMII for connection to MAC or fiber.
>=20
> Both models have a combo port that supports 1000BASE-X and 100BASE-FX
> fiber.
>=20
> Each PHY inside of QCA807x series has 2 digitally controlled output only
> pins that natively drive LED-s.
> But some vendors used these to driver generic LED-s controlled by
> user space, so lets enable registering each PHY as GPIO controller and
> add driver for it.
>=20
> This also adds the ability to specify DT properties so that 1000 Base-T
> LED will also be lit up for 100 and 10 Base connections.
>=20
> This is usually done by U-boot, but boards running mainline U-boot are
> not configuring this yet.
>=20
> These PHY-s are commonly used in Qualcomm IPQ40xx, IPQ60xx and IPQ807x
> boards.
>=20
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>

You need to rebase this on a more current tree:

../drivers/net/phy/qca807x.c:770:4: error: =E2=80=98struct phy_driver=E2=80=
=99 has no member named =E2=80=98ack_interrupt=E2=80=99; did you mean =E2=
=80=98handle_interrupt=E2=80=99?
  770 |   .ack_interrupt =3D qca807x_ack_intr,
      |    ^~~~~~~~~~~~~
      |    handle_interrupt
../drivers/net/phy/qca807x.c:770:20: error: initialization of =E2=80=98irqr=
eturn_t (*)(struct phy_device *)=E2=80=99 {aka =E2=80=98enum irqreturn (*)(=
struct phy_device *)=E2=80=99} from incompatible pointer type =E2=80=98int =
(*)(struct phy_device *)=E2=80=99 [-Werror=3Dincompatible-pointer-types]
  770 |   .ack_interrupt =3D qca807x_ack_intr,
      |                    ^~~~~~~~~~~~~~~~
