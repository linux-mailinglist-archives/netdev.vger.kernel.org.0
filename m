Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2E52DB176
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgLOQcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbgLOQcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:32:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A442BC06179C
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:31:26 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kpDES-0003t8-5D; Tue, 15 Dec 2020 17:31:24 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kpDEQ-00036R-Dl; Tue, 15 Dec 2020 17:31:22 +0100
Date:   Tue, 15 Dec 2020 17:31:22 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Tristram.Ha@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        matthias.schiffer@ew.tq-group.com, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 3/6] net: dsa: microchip: ksz8795: move register
 offsets and shifts to separate struct
Message-ID: <20201215163122.GM27410@pengutronix.de>
References: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
 <20201207125627.30843-4-m.grzeschik@pengutronix.de>
 <BYAPR11MB3558976CEC22D7EDB99CB429ECCE0@BYAPR11MB3558.namprd11.prod.outlook.com>
 <20201207214415.GD27410@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0qVF/w3MHQqLSynd"
Content-Disposition: inline
In-Reply-To: <20201207214415.GD27410@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:30:21 up 13 days,  4:57, 64 users,  load average: 0.46, 0.15,
 0.11
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0qVF/w3MHQqLSynd
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Gentle Ping. Did you find time to look into my other patches of the
series. I really would like to send the next version.

Thanks!

On Mon, Dec 07, 2020 at 10:44:15PM +0100, Michael Grzeschik wrote:
>On Mon, Dec 07, 2020 at 08:02:57PM +0000, Tristram.Ha@microchip.com wrote:
>>>In order to get this driver used with other switches the functions need
>>>to use different offsets and register shifts. This patch changes the
>>>direct use of the register defines to register description structures,
>>>which can be set depending on the chips register layout.
>>>
>>>Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>>>
>>>---
>>>v1 -> v4: - extracted this change from bigger previous patch
>>>v4 -> v5: - added missing variables in ksz8_r_vlan_entries
>>>          - moved shifts, masks and registers to arrays indexed by enums
>>>          - using unsigned types where possible
>>>---
>>> drivers/net/dsa/microchip/ksz8.h        |  69 +++++++
>>> drivers/net/dsa/microchip/ksz8795.c     | 261 +++++++++++++++++-------
>>> drivers/net/dsa/microchip/ksz8795_reg.h |  85 --------
>>> 3 files changed, 253 insertions(+), 162 deletions(-)
>>> create mode 100644 drivers/net/dsa/microchip/ksz8.h
>>
>>Sorry for not respond to these patches sooner.
>>
>>There are 3 older KSZ switch families: KSZ8863/73, KSZ8895/64, and KSZ879=
5/94.
>>The newer KSZ8795 is not considered an upgrade for KSZ8895, so some of
>>these switch registers are moved around and some features are dropped.
>>
>>It is best to have one driver to support all 3 switches, but some operati=
ons are
>>Incompatible so it may be better to keep the drivers separate for now.
>>
>>For basic operations those issues may not occur so it seems simple to have
>>one driver handling all 3 switches.  I will come up with a list of those
>>incompatibilities.
>
>Look into the next patch. I handled many special cases for the ksz8863
>in the "net: dsa: microchip: ksz8795: add support for ksz88xx chips".
>These cases, including the VLAN, Tagging ... are handled by checking if
>the feautre IS_88X3 is set. This can be extended to other types as well.
>
>My first version of the patches was an RFC series that was mentioning
>that it is based on your RFC series for the ksz8895.
>
>8863 RFC: https://patchwork.ozlabs.org/project/netdev/cover/20190508211330=
=2E19328-1-m.grzeschik@pengutronix.de/
>
>8895 RFC: https://patchwork.ozlabs.org/patch/822712/
>
>I remember, that I was reading the datasheets of all three chips,
>8895, 8863 and 8795. After the 8795 series was mainline, the
>obvious next step was to get the 8863 into the 8795 code. The result
>is this series.
>
>So the obvious question is, how far does your 8895 series differ
>from the 8863 switches?
>
>>The tail tag format of KSZ8863 is different from KSZ8895 and KSZ8795, but
>>because of the DSA driver implementation that issue never comes up.
>
>Right. In the first four series I kept an extra tail tag patch. But
>after cleaning up I figured that the Implementation matched the
>one for the KSZ9893. Therefor I reused the tag code.
>
>>>-static void ksz8_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
>>>+static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
>>>+                          u8 *member, u8 *valid)
>>> {
>>>-       *fid =3D vlan & VLAN_TABLE_FID;
>>>-       *member =3D (vlan & VLAN_TABLE_MEMBERSHIP) >>
>>>VLAN_TABLE_MEMBERSHIP_S;
>>>-       *valid =3D !!(vlan & VLAN_TABLE_VALID);
>>>+       struct ksz8 *ksz8 =3D dev->priv;
>>>+       const u32 *masks =3D ksz8->masks;
>>>+       const u8 *shifts =3D ksz8->shifts;
>>>+
>>>+       *fid =3D vlan & masks[VLAN_TABLE_FID];
>>>+       *member =3D (vlan & masks[VLAN_TABLE_MEMBERSHIP]) >>
>>>+                       shifts[VLAN_TABLE_MEMBERSHIP_S];
>>>+       *valid =3D !!(vlan & masks[VLAN_TABLE_VALID]);
>>> }
>>>
>>>-static void ksz8_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
>>>+static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8
>>>valid,
>>>+                        u32 *vlan)
>>> {
>>>+       struct ksz8 *ksz8 =3D dev->priv;
>>>+       const u32 *masks =3D ksz8->masks;
>>>+       const u8 *shifts =3D ksz8->shifts;
>>>+
>>>        *vlan =3D fid;
>>>-       *vlan |=3D (u16)member << VLAN_TABLE_MEMBERSHIP_S;
>>>+       *vlan |=3D (u16)member << shifts[VLAN_TABLE_MEMBERSHIP_S];
>>>        if (valid)
>>>-               *vlan |=3D VLAN_TABLE_VALID;
>>>+               *vlan |=3D masks[VLAN_TABLE_VALID];
>>> }
>>>
>>> static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
>>> {
>>>+       struct ksz8 *ksz8 =3D dev->priv;
>>>+       const u8 *shifts =3D ksz8->shifts;
>>>        u64 data;
>>>        int i;
>>>
>>>@@ -418,7 +509,7 @@ static void ksz8_r_vlan_entries(struct ksz_device
>>>*dev, u16 addr)
>>>        addr *=3D dev->phy_port_cnt;
>>>        for (i =3D 0; i < dev->phy_port_cnt; i++) {
>>>                dev->vlan_cache[addr + i].table[0] =3D (u16)data;
>>>-               data >>=3D VLAN_TABLE_S;
>>>+               data >>=3D shifts[VLAN_TABLE];
>>>        }
>>> }
>>>
>>>@@ -454,6 +545,8 @@ static void ksz8_w_vlan_table(struct ksz_device *dev,
>>>u16 vid, u32 vlan)
>>>
>>
>>The VLAN table operation in KSZ8863 is completely different from KSZ8795.
>>
>>>-/**
>>>- * VLAN_TABLE_FID                      00-007F007F-007F007F
>>>- * VLAN_TABLE_MEMBERSHIP               00-0F800F80-0F800F80
>>>- * VLAN_TABLE_VALID                    00-10001000-10001000
>>>- */
>>>-
>>>-#define VLAN_TABLE_FID                 0x007F
>>>-#define VLAN_TABLE_MEMBERSHIP          0x0F80
>>>-#define VLAN_TABLE_VALID               0x1000
>>>-
>>>-#define VLAN_TABLE_MEMBERSHIP_S                7
>>>-#define VLAN_TABLE_S                   16
>>>-
>>
>>In KSZ8795 you can use all 4096 VLAN id.  Each entry in the table contains
>>4 VID.  The FID is actually used for lookup and there is a limit, so you =
need
>>to convert VID to FID when programming the VLAN table.
>>
>>The only effect of using FID is the same MAC address can be used in
>>different VLANs.
>>
>>In KSZ8863 there are only 16 entries in the VLAN table.  Just like static
>>MAC table each entry is programmed using an index.  The entry contains
>>the VID, which does not have any relationship with the index unlike in
>>KSZ8795.
>>
>>The number of FID is also limited to 16.  So the maximum VLAN used is 16.
>>
>>> /**
>>>  * MIB_COUNTER_VALUE                   00-00000000-3FFFFFFF
>>>  * MIB_TOTAL_BYTES                     00-0000000F-FFFFFFFF
>>>@@ -956,9 +874,6 @@
>>>  * MIB_COUNTER_OVERFLOW                        00-00000040-00000000
>>>  */
>>>
>>>-#define MIB_COUNTER_OVERFLOW           BIT(6)
>>>-#define MIB_COUNTER_VALID              BIT(5)
>>>-
>>> #define MIB_COUNTER_VALUE              0x3FFFFFFF
>>
>>The MIB counters are also a little different in KSZ8863 and KSZ8795.
>>KSZ8863 may have smaller total bytes.  In normal operation this issue may
>>not come up.
>
>As mentioned before, these cases are handled differently for both
>types of drivers.
>
>--=20
>Pengutronix e.K.                           |                             |
>Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
>31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
>Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |



--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--0qVF/w3MHQqLSynd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl/Y5NcACgkQC+njFXoe
LGQtNA/6AqunOFE8IWkRdivOz5HcptM0nf402roZCyj0Bpmvxf2cqlg0650AEewu
SbiNu/04wVAEHsL2W6tyB5o2a25GMrPdgd7TateZDun6NvP5wMikVfItKsTFFf4r
R86VtrpNuKWS/sKE7YVzRDp04mRV4LJFRfLxVCDzdZKQMl1VMTB1P1MSvFHbwOd4
3pw4nrXo5bKQzE0DojZndXzY4LcM7fhQoG8wDONKG0bGb/x/gG8Wkg8vlEMAQ8Il
yDsfndYFM9brMgIYJg3KW8EiWw8bCUFEWOb0Vv8klGmiUdUSV/+FSdMYpXrpa4UU
LbaPf75bwv7bWxObzPimbjsmHMA17uyf0RMH+0QBti0gSZyqxu3RfhWD3vQm/fgp
V9JbS8Vn3GDWor4ldLqIF+uAlGqU5IOLerj0FjA/LooN3A4TMo5QgzWwA5k4W6+n
9q++5v+cUEWBgGZbTTNvOMeMcahsw6Ro9JkzgKu3WtS1TD+5rCQFt9Mu/gaS+jM7
EjepmNNAqBV5kw+oH/5Ctou+6waPs8CZkqXTdXUsHKDO9ZqDv7+AfSMkN40ExbGB
g0P5B7o71CJlrRzMsjgHNdxcITd9LuoU2F1c4Vxl0fgX+pROIy09A8dcy/w9rHJD
9srXtahEEwUI0fCOVKxUMj4ee2F/0Du3fbzgLwIAT7I/xDhZ0yQ=
=mmNO
-----END PGP SIGNATURE-----

--0qVF/w3MHQqLSynd--
