Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703821E4BFB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbgE0RfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387837AbgE0RfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 13:35:17 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC6820707;
        Wed, 27 May 2020 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590600916;
        bh=R4uYeYb/qGMRhcWjqOb/3pZMJwyktp8m5KLtFgAnSqI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uVYNj7lZ4xzTSRh+Pg/jNOxxHCwnMGR7S+2bTJsGtFiSO45ERABAF0AfTz6sBajsK
         0qjzyb34sjtSAxqZfCFNlmq8UpBvZtffOgE6+k/ReIePkfy3iGtwFWWrFDon8YZ2Xu
         eUyKd3q9+VRT1jSrPxCuWF7+NtoYBOxrYhtrj8ds=
Date:   Wed, 27 May 2020 10:35:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net
Subject: Re: [PATCH net-next 5/8] net: phy: mscc: 1588 block initialization
Message-ID: <20200527103513.05ee36e9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527164158.313025-6-antoine.tenart@bootlin.com>
References: <20200527164158.313025-1-antoine.tenart@bootlin.com>
        <20200527164158.313025-6-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 18:41:55 +0200 Antoine Tenart wrote:
> From: Quentin Schulz <quentin.schulz@bootlin.com>
>=20
> This patch adds the first parts of the 1588 support in the MSCC PHY,
> with registers definition and the 1588 block initialization.
>=20
> Those PHYs are distributed in hardware packages containing multiple
> times the PHY. The VSC8584 for example is composed of 4 PHYs. With
> hardware packages, parts of the logic is usually common and one of the
> PHY has to be used for some parts of the initialization. Following this
> logic, the 1588 blocks of those PHYs are shared between two PHYs and
> accessing the registers has to be done using the "base" PHY of the
> group. This is handled thanks to helpers in the PTP code (and locks).
> We also need the MDIO bus lock while performing a single read or write
> to the 1588 registers as the read/write are composed of multiple MDIO
> transactions (and we don't want other threads updating the page).
>=20
> Co-developed-by: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

This doesn't build on my system :S

In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
../include/linux/unaligned/be_byteshift.h:41:19: error: redefinition of =C3=
=A2=E2=82=AC=CB=9Cget_unaligned_be16=C3=A2=E2=82=AC=E2=84=A2
   41 | static inline u16 get_unaligned_be16(const void *p)
      |                   ^~~~~~~~~~~~~~~~~~
In file included from ../arch/x86/include/asm/unaligned.h:9,
                 from ../include/linux/etherdevice.h:24,
                 from ../include/linux/if_vlan.h:11,
                 from ../include/linux/filter.h:22,
                 from ../include/net/sock.h:59,
                 from ../include/net/inet_sock.h:22,
                 from ../include/linux/udp.h:16,
                 from ../drivers/net/phy/mscc/mscc_ptp.c:17:
../include/linux/unaligned/access_ok.h:23:28: note: previous definition of =
=C3=A2=E2=82=AC=CB=9Cget_unaligned_be16=C3=A2=E2=82=AC=E2=84=A2 was here
   23 | static __always_inline u16 get_unaligned_be16(const void *p)
      |                            ^~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
../include/linux/unaligned/be_byteshift.h:46:19: error: redefinition of =C3=
=A2=E2=82=AC=CB=9Cget_unaligned_be32=C3=A2=E2=82=AC=E2=84=A2
   46 | static inline u32 get_unaligned_be32(const void *p)
      |                   ^~~~~~~~~~~~~~~~~~
In file included from ../arch/x86/include/asm/unaligned.h:9,
                 from ../include/linux/etherdevice.h:24,
                 from ../include/linux/if_vlan.h:11,
                 from ../include/linux/filter.h:22,
                 from ../include/net/sock.h:59,
                 from ../include/net/inet_sock.h:22,
                 from ../include/linux/udp.h:16,
                 from ../drivers/net/phy/mscc/mscc_ptp.c:17:
../include/linux/unaligned/access_ok.h:28:28: note: previous definition of =
=C3=A2=E2=82=AC=CB=9Cget_unaligned_be32=C3=A2=E2=82=AC=E2=84=A2 was here
   28 | static __always_inline u32 get_unaligned_be32(const void *p)
      |                            ^~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
../include/linux/unaligned/be_byteshift.h:51:19: error: redefinition of =C3=
=A2=E2=82=AC=CB=9Cget_unaligned_be64=C3=A2=E2=82=AC=E2=84=A2
   51 | static inline u64 get_unaligned_be64(const void *p)
      |                   ^~~~~~~~~~~~~~~~~~
In file included from ../arch/x86/include/asm/unaligned.h:9,
                 from ../include/linux/etherdevice.h:24,
                 from ../include/linux/if_vlan.h:11,
                 from ../include/linux/filter.h:22,
                 from ../include/net/sock.h:59,
                 from ../include/net/inet_sock.h:22,
                 from ../include/linux/udp.h:16,
                 from ../drivers/net/phy/mscc/mscc_ptp.c:17:
../include/linux/unaligned/access_ok.h:33:28: note: previous definition of =
=C3=A2=E2=82=AC=CB=9Cget_unaligned_be64=C3=A2=E2=82=AC=E2=84=A2 was here
   33 | static __always_inline u64 get_unaligned_be64(const void *p)
      |                            ^~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
../include/linux/unaligned/be_byteshift.h:56:20: error: redefinition of =C3=
=A2=E2=82=AC=CB=9Cput_unaligned_be16=C3=A2=E2=82=AC=E2=84=A2
   56 | static inline void put_unaligned_be16(u16 val, void *p)
      |                    ^~~~~~~~~~~~~~~~~~
In file included from ../arch/x86/include/asm/unaligned.h:9,
                 from ../include/linux/etherdevice.h:24,
                 from ../include/linux/if_vlan.h:11,
                 from ../include/linux/filter.h:22,
                 from ../include/net/sock.h:59,
                 from ../include/net/inet_sock.h:22,
                 from ../include/linux/udp.h:16,
                 from ../drivers/net/phy/mscc/mscc_ptp.c:17:
../include/linux/unaligned/access_ok.h:53:29: note: previous definition of =
=C3=A2=E2=82=AC=CB=9Cput_unaligned_be16=C3=A2=E2=82=AC=E2=84=A2 was here
   53 | static __always_inline void put_unaligned_be16(u16 val, void *p)
      |                             ^~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
../include/linux/unaligned/be_byteshift.h:61:20: error: redefinition of =C3=
=A2=E2=82=AC=CB=9Cput_unaligned_be32=C3=A2=E2=82=AC=E2=84=A2
   61 | static inline void put_unaligned_be32(u32 val, void *p)
      |                    ^~~~~~~~~~~~~~~~~~
In file included from ../arch/x86/include/asm/unaligned.h:9,
                 from ../include/linux/etherdevice.h:24,
                 from ../include/linux/if_vlan.h:11,
                 from ../include/linux/filter.h:22,
                 from ../include/net/sock.h:59,
                 from ../include/net/inet_sock.h:22,
                 from ../include/linux/udp.h:16,
                 from ../drivers/net/phy/mscc/mscc_ptp.c:17:
../include/linux/unaligned/access_ok.h:58:29: note: previous definition of =
=C3=A2=E2=82=AC=CB=9Cput_unaligned_be32=C3=A2=E2=82=AC=E2=84=A2 was here
   58 | static __always_inline void put_unaligned_be32(u32 val, void *p)
      |                             ^~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/phy/mscc/mscc_ptp.c:18:
../include/linux/unaligned/be_byteshift.h:66:20: error: redefinition of =C3=
=A2=E2=82=AC=CB=9Cput_unaligned_be64=C3=A2=E2=82=AC=E2=84=A2
   66 | static inline void put_unaligned_be64(u64 val, void *p)
      |                    ^~~~~~~~~~~~~~~~~~
In file included from ../arch/x86/include/asm/unaligned.h:9,
                 from ../include/linux/etherdevice.h:24,
                 from ../include/linux/if_vlan.h:11,
                 from ../include/linux/filter.h:22,
                 from ../include/net/sock.h:59,
                 from ../include/net/inet_sock.h:22,
                 from ../include/linux/udp.h:16,
                 from ../drivers/net/phy/mscc/mscc_ptp.c:17:
../include/linux/unaligned/access_ok.h:63:29: note: previous definition of =
=C3=A2=E2=82=AC=CB=9Cput_unaligned_be64=C3=A2=E2=82=AC=E2=84=A2 was here
   63 | static __always_inline void put_unaligned_be64(u64 val, void *p)
      |                             ^~~~~~~~~~~~~~~~~~
../drivers/net/phy/mscc/mscc_ptp.c:658:12: warning: =C3=A2=E2=82=AC=CB=9Cvs=
c85xx_ts_engine_init=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunused=
-function]
  658 | static int vsc85xx_ts_engine_init(struct phy_device *phydev, bool o=
ne_step)
      |            ^~~~~~~~~~~~~~~~~~~~~~
make[5]: *** [drivers/net/phy/mscc/mscc_ptp.o] Error 1
make[4]: *** [drivers/net/phy/mscc] Error 2
make[3]: *** [drivers/net/phy] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2
