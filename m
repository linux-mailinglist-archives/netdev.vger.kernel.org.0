Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3A2EA2D2
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAEBOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbhAEBOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 20:14:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D0122573;
        Tue,  5 Jan 2021 01:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609809238;
        bh=MIJ5bUXV/vhVJjVFNACXoyVSMSwRf63nvJViYxFNO2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cOXbfYVTztrw1FXnPP95Z6YhILqIkb1HaUWpwn0bW7oYFeUdyI/BCojF27rUvPi/c
         kootAzesOhHLFiN3VukVpwGuwsL494V5QkjfH+sBRZicAmimgq6282xtGAYlW0zVF2
         2VvLWjwJvMTwBt/bHV70oP03nEBRgJ7kMqfZPYkiRFc5Zm5lwPOUry3NVXyPopVzyU
         CtxfJzsOGadLpXEZ7wLW+YzS2EXh1ytzrzRw2J4mF410WCpKfw73M+Y8+mwnh9aRXD
         sKF8QjMWxcDT430f+6/dyTNgiq6Fm2XiDwqGHESStXdFKn6fkzmRPwfLuJF3fAsyM5
         GvYekRlXXxi3A==
Date:   Mon, 4 Jan 2021 17:13:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH V2 2/2] net: ks8851: Register MDIO bus and the internal
 PHY
Message-ID: <20210104171356.3aaa125d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104123017.261452-2-marex@denx.de>
References: <20210104123017.261452-1-marex@denx.de>
        <20210104123017.261452-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Jan 2021 13:30:17 +0100 Marek Vasut wrote:
> The KS8851 has a reduced internal PHY, which is accessible through its
> registers at offset 0xe4. The PHY is compatible with KS886x PHY present
> in Micrel switches, except the PHY ID Low/High registers are swapped.
> Register MDIO bus so this PHY can be detected and probed by phylib.
>=20
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> To: netdev@vger.kernel.org

Please put this creative To: tag under --- so maintainers don't have to
stip it manually :)

There's a few warnings here:

drivers/net/ethernet/micrel/ks8851_common.c: In function =E2=80=98ks8851_md=
io_read=E2=80=99:
drivers/net/ethernet/micrel/ks8851_common.c:1001:6: warning: unused variabl=
e =E2=80=98ret=E2=80=99 [-Wunused-variable]
 1001 |  int ret;
      |      ^~~

drivers/net/ethernet/micrel/ks8851.h:425: warning: Function parameter or me=
mber 'mii_bus' not described in 'ks8851_net'
