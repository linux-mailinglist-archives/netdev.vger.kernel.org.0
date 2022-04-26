Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3AE510147
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351863AbiDZPFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348182AbiDZPFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:05:04 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433693AA6D
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:01:54 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id q14so22326088ljc.12
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RGMuIn7SD8CXP5eMT3h3ypgldVxcX7z2OeTfHrGfnDA=;
        b=HHbxKoNJTTropMIUuXF9MXL6Y3LE2ennARuNNRPxBOFx4yT84pM6UWVo3ouLhmcOoU
         LmNCO8LSwSR2uYvtTS2fqpiF/KsRkyfUpw/gBFKEC6h6thLTYtEDb4bnseFvN8ld5fdI
         iGENBQg35C+84oMBoEm9kvlEfMNE9hblwAcdu8AuOAouc1KeFOXTSchEKlzKFveD4JLm
         OtubugF7pg0DXtUZlD8rlNfuof40ACrzVBMNEh3gh4HWgB+yppugo+ngqxBiqVWwCdrT
         RFpumew1orKuGCvu0mTKNQtflgjyrHDQAtofzYqWwGOrY6uNYD2pk1vBQGORTvgnOW8X
         6CGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RGMuIn7SD8CXP5eMT3h3ypgldVxcX7z2OeTfHrGfnDA=;
        b=MYsZQzUyvbXR1y2GaFiqADFWMmF7Wvbhr4z5GIfyQ9NR09UvOoiW2XJD+pch4+lC05
         /SDb72rda0HoRU0bg8Cx01l8hNZZNWWuGImm20J5LvYgNym9NXji6so6lwUCEk+uKGQB
         WqAazXCAgvTddd6djIHIZgeED+XMA/9d5EtZE7riS9XkqkCmduBwDIF7thzcoKmlmBmo
         WUTeVI3Bhq/cG89LX1osyMzt6W6mV42XpguGb4a1ekrjLUgBqDYDXi0yLDk7Pq2eJTP8
         4vaOsVgoBzR/2vQRfl4KMn4XirKtJIN9EYLhcT1SCVQ0SBRihoKmt8lwebLAqscdrDFP
         wimQ==
X-Gm-Message-State: AOAM532EbKpx6dyYWvU5FYfkUwz0jVhG0YNYfLZ6GSa8mQBn7u8ABbwj
        il6h7wDuFPTTc2PGoI0wc/A=
X-Google-Smtp-Source: ABdhPJxyZaAcD2uV7Bx6FulPDA1r1//papXP/xKyULJPGcKGCoZlrY4c3x9uPG7/uMMS5Qi5NwVsIQ==
X-Received: by 2002:a05:651c:1507:b0:24e:e69e:9b6e with SMTP id e7-20020a05651c150700b0024ee69e9b6emr14455797ljf.468.1650985311461;
        Tue, 26 Apr 2022 08:01:51 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id f8-20020ac24988000000b00471fa5fd4ddsm1271174lfl.126.2022.04.26.08.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 08:01:50 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
In-Reply-To: <20220225092225.594851-8-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com>
Date:   Tue, 26 Apr 2022 17:01:47 +0200
Message-ID: <867d7bga78.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On fre, feb 25, 2022 at 11:22, Vladimir Oltean <vladimir.oltean@nxp.com> wr=
ote:
> For DSA, to encourage drivers to perform FDB isolation simply means to
> track which bridge does each FDB and MDB entry belong to. It then
> becomes the driver responsibility to use something that makes the FDB
> entry from one bridge not match the FDB lookup of ports from other
> bridges.
>
> The top-level functions where the bridge is determined are:
> - dsa_port_fdb_{add,del}
> - dsa_port_host_fdb_{add,del}
> - dsa_port_mdb_{add,del}
> - dsa_port_host_mdb_{add,del}
>
> aka the pre-crosschip-notifier functions.
>
> Changing the API to pass a reference to a bridge is not superfluous, and
> looking at the passed bridge argument is not the same as having the
> driver look at dsa_to_port(ds, port)->bridge from the ->port_fdb_add()
> method.
>
> DSA installs FDB and MDB entries on shared (CPU and DSA) ports as well,
> and those do not have any dp->bridge information to retrieve, because
> they are not in any bridge - they are merely the pipes that serve the
> user ports that are in one or multiple bridges.
>
> The struct dsa_bridge associated with each FDB/MDB entry is encapsulated
> in a larger "struct dsa_db" database. Although only databases associated
> to bridges are notified for now, this API will be the starting point for
> implementing IFF_UNICAST_FLT in DSA. There, the idea is to install FDB
> entries on the CPU port which belong to the corresponding user port's
> port database. These are supposed to match only when the port is
> standalone.
>
> It is better to introduce the API in its expected final form than to
> introduce it for bridges first, then to have to change drivers which may
> have made one or more assumptions.
>
> Drivers can use the provided bridge.num, but they can also use a
> different numbering scheme that is more convenient.
>
> DSA must perform refcounting on the CPU and DSA ports by also taking
> into account the bridge number. So if two bridges request the same local
> address, DSA must notify the driver twice, once for each bridge.
>
> In fact, if the driver supports FDB isolation, DSA must perform
> refcounting per bridge, but if the driver doesn't, DSA must refcount
> host addresses across all bridges, otherwise it would be telling the
> driver to delete an FDB entry for a bridge and the driver would delete
> it for all bridges. So introduce a bool fdb_isolation in drivers which
> would make all bridge databases passed to the cross-chip notifier have
> the same number (0). This makes dsa_mac_addr_find() -> dsa_db_equal()
> say that all bridge databases are the same database - which is
> essentially the legacy behavior.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/b53/b53_common.c       | 12 ++--
>  drivers/net/dsa/b53/b53_priv.h         | 12 ++--
>  drivers/net/dsa/hirschmann/hellcreek.c |  6 +-
>  drivers/net/dsa/lan9303-core.c         | 13 ++--
>  drivers/net/dsa/lantiq_gswip.c         |  6 +-
>  drivers/net/dsa/microchip/ksz9477.c    | 12 ++--
>  drivers/net/dsa/microchip/ksz_common.c |  6 +-
>  drivers/net/dsa/microchip/ksz_common.h |  6 +-
>  drivers/net/dsa/mt7530.c               | 12 ++--
>  drivers/net/dsa/mv88e6xxx/chip.c       | 12 ++--
>  drivers/net/dsa/ocelot/felix.c         | 18 +++--
>  drivers/net/dsa/qca8k.c                | 12 ++--
>  drivers/net/dsa/sja1105/sja1105_main.c | 26 +++++--
>  include/net/dsa.h                      | 42 +++++++++--
>  net/dsa/dsa_priv.h                     |  3 +
>  net/dsa/port.c                         | 75 ++++++++++++++++++-
>  net/dsa/switch.c                       | 99 +++++++++++++++++---------
>  17 files changed, 280 insertions(+), 92 deletions(-)
>
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_c=
ommon.c
> index 83bf30349c26..a8cc6e182c45 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1708,7 +1708,8 @@ static int b53_arl_op(struct b53_device *dev, int o=
p, int port,
>  }
>=20=20
>  int b53_fdb_add(struct dsa_switch *ds, int port,
> -		const unsigned char *addr, u16 vid)
> +		const unsigned char *addr, u16 vid,
> +		struct dsa_db db)
>  {
>  	struct b53_device *priv =3D ds->priv;
>  	int ret;
> @@ -1728,7 +1729,8 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
>  EXPORT_SYMBOL(b53_fdb_add);
>=20=20
>  int b53_fdb_del(struct dsa_switch *ds, int port,
> -		const unsigned char *addr, u16 vid)
> +		const unsigned char *addr, u16 vid,
> +		struct dsa_db db)
>  {
>  	struct b53_device *priv =3D ds->priv;
>  	int ret;
> @@ -1829,7 +1831,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
>  EXPORT_SYMBOL(b53_fdb_dump);
>=20=20
>  int b53_mdb_add(struct dsa_switch *ds, int port,
> -		const struct switchdev_obj_port_mdb *mdb)
> +		const struct switchdev_obj_port_mdb *mdb,
> +		struct dsa_db db)
>  {
>  	struct b53_device *priv =3D ds->priv;
>  	int ret;
> @@ -1849,7 +1852,8 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
>  EXPORT_SYMBOL(b53_mdb_add);
>=20=20
>  int b53_mdb_del(struct dsa_switch *ds, int port,
> -		const struct switchdev_obj_port_mdb *mdb)
> +		const struct switchdev_obj_port_mdb *mdb,
> +		struct dsa_db db)
>  {
>  	struct b53_device *priv =3D ds->priv;
>  	int ret;
> diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_pri=
v.h
> index a6b339fcb17e..d3091f0ad3e6 100644
> --- a/drivers/net/dsa/b53/b53_priv.h
> +++ b/drivers/net/dsa/b53/b53_priv.h
> @@ -359,15 +359,19 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>  int b53_vlan_del(struct dsa_switch *ds, int port,
>  		 const struct switchdev_obj_port_vlan *vlan);
>  int b53_fdb_add(struct dsa_switch *ds, int port,
> -		const unsigned char *addr, u16 vid);
> +		const unsigned char *addr, u16 vid,
> +		struct dsa_db db);
>  int b53_fdb_del(struct dsa_switch *ds, int port,
> -		const unsigned char *addr, u16 vid);
> +		const unsigned char *addr, u16 vid,
> +		struct dsa_db db);
>  int b53_fdb_dump(struct dsa_switch *ds, int port,
>  		 dsa_fdb_dump_cb_t *cb, void *data);
>  int b53_mdb_add(struct dsa_switch *ds, int port,
> -		const struct switchdev_obj_port_mdb *mdb);
> +		const struct switchdev_obj_port_mdb *mdb,
> +		struct dsa_db db);
>  int b53_mdb_del(struct dsa_switch *ds, int port,
> -		const struct switchdev_obj_port_mdb *mdb);
> +		const struct switchdev_obj_port_mdb *mdb,
> +		struct dsa_db db);
>  int b53_mirror_add(struct dsa_switch *ds, int port,
>  		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
>  enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int po=
rt,
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hir=
schmann/hellcreek.c
> index 726f267cb228..cb89be9de43a 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -827,7 +827,8 @@ static int hellcreek_fdb_get(struct hellcreek *hellcr=
eek,
>  }
>=20=20
>  static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
> -			     const unsigned char *addr, u16 vid)
> +			     const unsigned char *addr, u16 vid,
> +			     struct dsa_db db)
>  {
>  	struct hellcreek_fdb_entry entry =3D { 0 };
>  	struct hellcreek *hellcreek =3D ds->priv;
> @@ -872,7 +873,8 @@ static int hellcreek_fdb_add(struct dsa_switch *ds, i=
nt port,
>  }
>=20=20
>  static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
> -			     const unsigned char *addr, u16 vid)
> +			     const unsigned char *addr, u16 vid,
> +			     struct dsa_db db)
>  {
>  	struct hellcreek_fdb_entry entry =3D { 0 };
>  	struct hellcreek *hellcreek =3D ds->priv;
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-cor=
e.c
> index 3969d89fa4db..a21184e7fcb6 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1188,7 +1188,8 @@ static void lan9303_port_fast_age(struct dsa_switch=
 *ds, int port)
>  }
>=20=20
>  static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid)
> +				const unsigned char *addr, u16 vid,
> +				struct dsa_db db)
>  {
>  	struct lan9303 *chip =3D ds->priv;
>=20=20
> @@ -1200,8 +1201,8 @@ static int lan9303_port_fdb_add(struct dsa_switch *=
ds, int port,
>  }
>=20=20
>  static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid)
> -
> +				const unsigned char *addr, u16 vid,
> +				struct dsa_db db)
>  {
>  	struct lan9303 *chip =3D ds->priv;
>=20=20
> @@ -1245,7 +1246,8 @@ static int lan9303_port_mdb_prepare(struct dsa_swit=
ch *ds, int port,
>  }
>=20=20
>  static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
> -				const struct switchdev_obj_port_mdb *mdb)
> +				const struct switchdev_obj_port_mdb *mdb,
> +				struct dsa_db db)
>  {
>  	struct lan9303 *chip =3D ds->priv;
>  	int err;
> @@ -1260,7 +1262,8 @@ static int lan9303_port_mdb_add(struct dsa_switch *=
ds, int port,
>  }
>=20=20
>  static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
> -				const struct switchdev_obj_port_mdb *mdb)
> +				const struct switchdev_obj_port_mdb *mdb,
> +				struct dsa_db db)
>  {
>  	struct lan9303 *chip =3D ds->priv;
>=20=20
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswi=
p.c
> index 8a7a8093a156..3dfb532b7784 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1389,13 +1389,15 @@ static int gswip_port_fdb(struct dsa_switch *ds, =
int port,
>  }
>=20=20
>  static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
> -			      const unsigned char *addr, u16 vid)
> +			      const unsigned char *addr, u16 vid,
> +			      struct dsa_db db)
>  {
>  	return gswip_port_fdb(ds, port, addr, vid, true);
>  }
>=20=20
>  static int gswip_port_fdb_del(struct dsa_switch *ds, int port,
> -			      const unsigned char *addr, u16 vid)
> +			      const unsigned char *addr, u16 vid,
> +			      struct dsa_db db)
>  {
>  	return gswip_port_fdb(ds, port, addr, vid, false);
>  }
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microc=
hip/ksz9477.c
> index 18ffc8ded7ee..94ad6d9504f4 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -640,7 +640,8 @@ static int ksz9477_port_vlan_del(struct dsa_switch *d=
s, int port,
>  }
>=20=20
>  static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid)
> +				const unsigned char *addr, u16 vid,
> +				struct dsa_db db)
>  {
>  	struct ksz_device *dev =3D ds->priv;
>  	u32 alu_table[4];
> @@ -697,7 +698,8 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds=
, int port,
>  }
>=20=20
>  static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid)
> +				const unsigned char *addr, u16 vid,
> +				struct dsa_db db)
>  {
>  	struct ksz_device *dev =3D ds->priv;
>  	u32 alu_table[4];
> @@ -839,7 +841,8 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *d=
s, int port,
>  }
>=20=20
>  static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
> -				const struct switchdev_obj_port_mdb *mdb)
> +				const struct switchdev_obj_port_mdb *mdb,
> +				struct dsa_db db)
>  {
>  	struct ksz_device *dev =3D ds->priv;
>  	u32 static_table[4];
> @@ -914,7 +917,8 @@ static int ksz9477_port_mdb_add(struct dsa_switch *ds=
, int port,
>  }
>=20=20
>  static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
> -				const struct switchdev_obj_port_mdb *mdb)
> +				const struct switchdev_obj_port_mdb *mdb,
> +				struct dsa_db db)
>  {
>  	struct ksz_device *dev =3D ds->priv;
>  	u32 static_table[4];
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/mic=
rochip/ksz_common.c
> index 94e618b8352b..104458ec9cbc 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -276,7 +276,8 @@ int ksz_port_fdb_dump(struct dsa_switch *ds, int port=
, dsa_fdb_dump_cb_t *cb,
>  EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
>=20=20
>  int ksz_port_mdb_add(struct dsa_switch *ds, int port,
> -		     const struct switchdev_obj_port_mdb *mdb)
> +		     const struct switchdev_obj_port_mdb *mdb,
> +		     struct dsa_db db)
>  {
>  	struct ksz_device *dev =3D ds->priv;
>  	struct alu_struct alu;
> @@ -321,7 +322,8 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
>  EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
>=20=20
>  int ksz_port_mdb_del(struct dsa_switch *ds, int port,
> -		     const struct switchdev_obj_port_mdb *mdb)
> +		     const struct switchdev_obj_port_mdb *mdb,
> +		     struct dsa_db db)
>  {
>  	struct ksz_device *dev =3D ds->priv;
>  	struct alu_struct alu;
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/mic=
rochip/ksz_common.h
> index c6fa487fb006..66933445a447 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -166,9 +166,11 @@ void ksz_port_fast_age(struct dsa_switch *ds, int po=
rt);
>  int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t=
 *cb,
>  		      void *data);
>  int ksz_port_mdb_add(struct dsa_switch *ds, int port,
> -		     const struct switchdev_obj_port_mdb *mdb);
> +		     const struct switchdev_obj_port_mdb *mdb,
> +		     struct dsa_db db);
>  int ksz_port_mdb_del(struct dsa_switch *ds, int port,
> -		     const struct switchdev_obj_port_mdb *mdb);
> +		     const struct switchdev_obj_port_mdb *mdb,
> +		     struct dsa_db db);
>  int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *=
phy);
>=20=20
>  /* Common register access functions */
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index f74f25f479ed..abe63ec05066 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1349,7 +1349,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int=
 port,
>=20=20
>  static int
>  mt7530_port_fdb_add(struct dsa_switch *ds, int port,
> -		    const unsigned char *addr, u16 vid)
> +		    const unsigned char *addr, u16 vid,
> +		    struct dsa_db db)
>  {
>  	struct mt7530_priv *priv =3D ds->priv;
>  	int ret;
> @@ -1365,7 +1366,8 @@ mt7530_port_fdb_add(struct dsa_switch *ds, int port,
>=20=20
>  static int
>  mt7530_port_fdb_del(struct dsa_switch *ds, int port,
> -		    const unsigned char *addr, u16 vid)
> +		    const unsigned char *addr, u16 vid,
> +		    struct dsa_db db)
>  {
>  	struct mt7530_priv *priv =3D ds->priv;
>  	int ret;
> @@ -1416,7 +1418,8 @@ mt7530_port_fdb_dump(struct dsa_switch *ds, int por=
t,
>=20=20
>  static int
>  mt7530_port_mdb_add(struct dsa_switch *ds, int port,
> -		    const struct switchdev_obj_port_mdb *mdb)
> +		    const struct switchdev_obj_port_mdb *mdb,
> +		    struct dsa_db db)
>  {
>  	struct mt7530_priv *priv =3D ds->priv;
>  	const u8 *addr =3D mdb->addr;
> @@ -1442,7 +1445,8 @@ mt7530_port_mdb_add(struct dsa_switch *ds, int port,
>=20=20
>  static int
>  mt7530_port_mdb_del(struct dsa_switch *ds, int port,
> -		    const struct switchdev_obj_port_mdb *mdb)
> +		    const struct switchdev_obj_port_mdb *mdb,
> +		    struct dsa_db db)
>  {
>  	struct mt7530_priv *priv =3D ds->priv;
>  	const u8 *addr =3D mdb->addr;
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index 1b9a20bf1bd6..d79c65bb227e 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2456,7 +2456,8 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switc=
h *ds, int port,
>  }
>=20=20
>  static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
> -				  const unsigned char *addr, u16 vid)
> +				  const unsigned char *addr, u16 vid,
> +				  struct dsa_db db)
>  {
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
>  	int err;
> @@ -2470,7 +2471,8 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch=
 *ds, int port,
>  }
>=20=20
>  static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
> -				  const unsigned char *addr, u16 vid)
> +				  const unsigned char *addr, u16 vid,
> +				  struct dsa_db db)
>  {
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
>  	int err;
> @@ -6002,7 +6004,8 @@ static int mv88e6xxx_change_tag_protocol(struct dsa=
_switch *ds, int port,
>  }
>=20=20
>  static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
> -				  const struct switchdev_obj_port_mdb *mdb)
> +				  const struct switchdev_obj_port_mdb *mdb,
> +				  struct dsa_db db)
>  {
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
>  	int err;
> @@ -6016,7 +6019,8 @@ static int mv88e6xxx_port_mdb_add(struct dsa_switch=
 *ds, int port,
>  }
>=20=20
>  static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
> -				  const struct switchdev_obj_port_mdb *mdb)
> +				  const struct switchdev_obj_port_mdb *mdb,
> +				  struct dsa_db db)
>  {
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
>  	int err;
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index 04f5da33b944..d92feee97c63 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -592,7 +592,8 @@ static int felix_fdb_dump(struct dsa_switch *ds, int =
port,
>  }
>=20=20
>  static int felix_fdb_add(struct dsa_switch *ds, int port,
> -			 const unsigned char *addr, u16 vid)
> +			 const unsigned char *addr, u16 vid,
> +			 struct dsa_db db)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>=20=20
> @@ -600,7 +601,8 @@ static int felix_fdb_add(struct dsa_switch *ds, int p=
ort,
>  }
>=20=20
>  static int felix_fdb_del(struct dsa_switch *ds, int port,
> -			 const unsigned char *addr, u16 vid)
> +			 const unsigned char *addr, u16 vid,
> +			 struct dsa_db db)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>=20=20
> @@ -608,7 +610,8 @@ static int felix_fdb_del(struct dsa_switch *ds, int p=
ort,
>  }
>=20=20
>  static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
> -			     const unsigned char *addr, u16 vid)
> +			     const unsigned char *addr, u16 vid,
> +			     struct dsa_db db)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>=20=20
> @@ -616,7 +619,8 @@ static int felix_lag_fdb_add(struct dsa_switch *ds, s=
truct dsa_lag lag,
>  }
>=20=20
>  static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
> -			     const unsigned char *addr, u16 vid)
> +			     const unsigned char *addr, u16 vid,
> +			     struct dsa_db db)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>=20=20
> @@ -624,7 +628,8 @@ static int felix_lag_fdb_del(struct dsa_switch *ds, s=
truct dsa_lag lag,
>  }
>=20=20
>  static int felix_mdb_add(struct dsa_switch *ds, int port,
> -			 const struct switchdev_obj_port_mdb *mdb)
> +			 const struct switchdev_obj_port_mdb *mdb,
> +			 struct dsa_db db)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>=20=20
> @@ -632,7 +637,8 @@ static int felix_mdb_add(struct dsa_switch *ds, int p=
ort,
>  }
>=20=20
>  static int felix_mdb_del(struct dsa_switch *ds, int port,
> -			 const struct switchdev_obj_port_mdb *mdb)
> +			 const struct switchdev_obj_port_mdb *mdb,
> +			 struct dsa_db db)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>=20=20
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 6844106975a9..7189fd8120d7 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -2397,7 +2397,8 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, cons=
t u8 *addr,
>=20=20
>  static int
>  qca8k_port_fdb_add(struct dsa_switch *ds, int port,
> -		   const unsigned char *addr, u16 vid)
> +		   const unsigned char *addr, u16 vid,
> +		   struct dsa_db db)
>  {
>  	struct qca8k_priv *priv =3D (struct qca8k_priv *)ds->priv;
>  	u16 port_mask =3D BIT(port);
> @@ -2407,7 +2408,8 @@ qca8k_port_fdb_add(struct dsa_switch *ds, int port,
>=20=20
>  static int
>  qca8k_port_fdb_del(struct dsa_switch *ds, int port,
> -		   const unsigned char *addr, u16 vid)
> +		   const unsigned char *addr, u16 vid,
> +		   struct dsa_db db)
>  {
>  	struct qca8k_priv *priv =3D (struct qca8k_priv *)ds->priv;
>  	u16 port_mask =3D BIT(port);
> @@ -2444,7 +2446,8 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
>=20=20
>  static int
>  qca8k_port_mdb_add(struct dsa_switch *ds, int port,
> -		   const struct switchdev_obj_port_mdb *mdb)
> +		   const struct switchdev_obj_port_mdb *mdb,
> +		   struct dsa_db db)
>  {
>  	struct qca8k_priv *priv =3D ds->priv;
>  	const u8 *addr =3D mdb->addr;
> @@ -2455,7 +2458,8 @@ qca8k_port_mdb_add(struct dsa_switch *ds, int port,
>=20=20
>  static int
>  qca8k_port_mdb_del(struct dsa_switch *ds, int port,
> -		   const struct switchdev_obj_port_mdb *mdb)
> +		   const struct switchdev_obj_port_mdb *mdb,
> +		   struct dsa_db db)
>  {
>  	struct qca8k_priv *priv =3D ds->priv;
>  	const u8 *addr =3D mdb->addr;
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja=
1105/sja1105_main.c
> index dd89b077aae6..91b0e636d194 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1819,7 +1819,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int =
port,
>  }
>=20=20
>  static int sja1105_fdb_add(struct dsa_switch *ds, int port,
> -			   const unsigned char *addr, u16 vid)
> +			   const unsigned char *addr, u16 vid,
> +			   struct dsa_db db)
>  {
>  	struct sja1105_private *priv =3D ds->priv;
>=20=20
> @@ -1827,7 +1828,8 @@ static int sja1105_fdb_add(struct dsa_switch *ds, i=
nt port,
>  }
>=20=20
>  static int sja1105_fdb_del(struct dsa_switch *ds, int port,
> -			   const unsigned char *addr, u16 vid)
> +			   const unsigned char *addr, u16 vid,
> +			   struct dsa_db db)
>  {
>  	struct sja1105_private *priv =3D ds->priv;
>=20=20
> @@ -1885,7 +1887,15 @@ static int sja1105_fdb_dump(struct dsa_switch *ds,=
 int port,
>=20=20
>  static void sja1105_fast_age(struct dsa_switch *ds, int port)
>  {
> +	struct dsa_port *dp =3D dsa_to_port(ds, port);
>  	struct sja1105_private *priv =3D ds->priv;
> +	struct dsa_db db =3D {
> +		.type =3D DSA_DB_BRIDGE,
> +		.bridge =3D {
> +			.dev =3D dsa_port_bridge_dev_get(dp),
> +			.num =3D dsa_port_bridge_num_get(dp),
> +		},
> +	};
>  	int i;
>=20=20
>  	for (i =3D 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
> @@ -1913,7 +1923,7 @@ static void sja1105_fast_age(struct dsa_switch *ds,=
 int port)
>=20=20
>  		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
>=20=20
> -		rc =3D sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid);
> +		rc =3D sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
>  		if (rc) {
>  			dev_err(ds->dev,
>  				"Failed to delete FDB entry %pM vid %lld: %pe\n",
> @@ -1924,15 +1934,17 @@ static void sja1105_fast_age(struct dsa_switch *d=
s, int port)
>  }
>=20=20
>  static int sja1105_mdb_add(struct dsa_switch *ds, int port,
> -			   const struct switchdev_obj_port_mdb *mdb)
> +			   const struct switchdev_obj_port_mdb *mdb,
> +			   struct dsa_db db)
>  {
> -	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
> +	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
>  }
>=20=20
>  static int sja1105_mdb_del(struct dsa_switch *ds, int port,
> -			   const struct switchdev_obj_port_mdb *mdb)
> +			   const struct switchdev_obj_port_mdb *mdb,
> +			   struct dsa_db db)
>  {
> -	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid);
> +	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, db);
>  }
>=20=20
>  /* Common function for unicast and broadcast flood configuration.
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 01faba89c987..87c5f18eb381 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -341,11 +341,28 @@ struct dsa_link {
>  	struct list_head list;
>  };
>=20=20
> +enum dsa_db_type {
> +	DSA_DB_PORT,
> +	DSA_DB_LAG,
> +	DSA_DB_BRIDGE,
> +};
> +
> +struct dsa_db {
> +	enum dsa_db_type type;
> +
> +	union {
> +		const struct dsa_port *dp;
> +		struct dsa_lag lag;
> +		struct dsa_bridge bridge;
> +	};
> +};
> +
>  struct dsa_mac_addr {
>  	unsigned char addr[ETH_ALEN];
>  	u16 vid;
>  	refcount_t refcount;
>  	struct list_head list;
> +	struct dsa_db db;
>  };
>=20=20
>  struct dsa_vlan {
> @@ -409,6 +426,13 @@ struct dsa_switch {
>  	 */
>  	u32			mtu_enforcement_ingress:1;
>=20=20
> +	/* Drivers that isolate the FDBs of multiple bridges must set this
> +	 * to true to receive the bridge as an argument in .port_fdb_{add,del}
> +	 * and .port_mdb_{add,del}. Otherwise, the bridge.num will always be
> +	 * passed as zero.
> +	 */
> +	u32			fdb_isolation:1;
> +
>  	/* Listener for switch fabric events */
>  	struct notifier_block	nb;
>=20=20
> @@ -941,23 +965,29 @@ struct dsa_switch_ops {
>  	 * Forwarding database
>  	 */
>  	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid);
> +				const unsigned char *addr, u16 vid,
> +				struct dsa_db db);

Hi! Wouldn't it be better to have a struct that has all the functions
parameters in one instead of adding further parameters to these
functions?

I am asking because I am also needing to add a parameter to
port_fdb_add(), and it would be more future oriented to have a single
function parameter as a struct, so that it is easier to add parameters
to these functions without hav=C3=ADng to change the prototype of the
function every time.

>  	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
> -				const unsigned char *addr, u16 vid);
> +				const unsigned char *addr, u16 vid,
> +				struct dsa_db db);
>  	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
>  				 dsa_fdb_dump_cb_t *cb, void *data);
>  	int	(*lag_fdb_add)(struct dsa_switch *ds, struct dsa_lag lag,
> -			       const unsigned char *addr, u16 vid);
> +			       const unsigned char *addr, u16 vid,
> +			       struct dsa_db db);
>  	int	(*lag_fdb_del)(struct dsa_switch *ds, struct dsa_lag lag,
> -			       const unsigned char *addr, u16 vid);
> +			       const unsigned char *addr, u16 vid,
> +			       struct dsa_db db);
>=20=20
>  	/*
>  	 * Multicast database
>  	 */
>  	int	(*port_mdb_add)(struct dsa_switch *ds, int port,
> -				const struct switchdev_obj_port_mdb *mdb);
> +				const struct switchdev_obj_port_mdb *mdb,
> +				struct dsa_db db);
>  	int	(*port_mdb_del)(struct dsa_switch *ds, int port,
> -				const struct switchdev_obj_port_mdb *mdb);
> +				const struct switchdev_obj_port_mdb *mdb,
> +				struct dsa_db db);
>  	/*
>  	 * RXNFC
>  	 */
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 7a1c98581f53..27575fc3883e 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -67,6 +67,7 @@ struct dsa_notifier_fdb_info {
>  	int port;
>  	const unsigned char *addr;
>  	u16 vid;
> +	struct dsa_db db;
>  };
>=20=20
>  /* DSA_NOTIFIER_LAG_FDB_* */
> @@ -74,6 +75,7 @@ struct dsa_notifier_lag_fdb_info {
>  	struct dsa_lag *lag;
>  	const unsigned char *addr;
>  	u16 vid;
> +	struct dsa_db db;
>  };
>=20=20
>  /* DSA_NOTIFIER_MDB_* */
> @@ -81,6 +83,7 @@ struct dsa_notifier_mdb_info {
>  	const struct switchdev_obj_port_mdb *mdb;
>  	int sw_index;
>  	int port;
> +	struct dsa_db db;
>  };
>=20=20
>  /* DSA_NOTIFIER_LAG_* */
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index adab159c8c21..7af44a28f032 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -798,8 +798,19 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsi=
gned char *addr,
>  		.port =3D dp->index,
>  		.addr =3D addr,
>  		.vid =3D vid,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>=20=20
> +	/* Refcounting takes bridge.num as a key, and should be global for all
> +	 * bridges in the absence of FDB isolation, and per bridge otherwise.
> +	 * Force the bridge.num to zero here in the absence of FDB isolation.
> +	 */
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_ADD, &info);
>  }
>=20=20
> @@ -811,9 +822,15 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsi=
gned char *addr,
>  		.port =3D dp->index,
>  		.addr =3D addr,
>  		.vid =3D vid,
> -
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
>  }
>=20=20
> @@ -825,6 +842,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const=
 unsigned char *addr,
>  		.port =3D dp->index,
>  		.addr =3D addr,
>  		.vid =3D vid,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>  	struct dsa_port *cpu_dp =3D dp->cpu_dp;
>  	int err;
> @@ -839,6 +860,9 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const =
unsigned char *addr,
>  			return err;
>  	}
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
>  }
>=20=20
> @@ -850,6 +874,10 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const=
 unsigned char *addr,
>  		.port =3D dp->index,
>  		.addr =3D addr,
>  		.vid =3D vid,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>  	struct dsa_port *cpu_dp =3D dp->cpu_dp;
>  	int err;
> @@ -860,6 +888,9 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const =
unsigned char *addr,
>  			return err;
>  	}
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
>  }
>=20=20
> @@ -870,8 +901,15 @@ int dsa_port_lag_fdb_add(struct dsa_port *dp, const =
unsigned char *addr,
>  		.lag =3D dp->lag,
>  		.addr =3D addr,
>  		.vid =3D vid,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
>  }
>=20=20
> @@ -882,8 +920,15 @@ int dsa_port_lag_fdb_del(struct dsa_port *dp, const =
unsigned char *addr,
>  		.lag =3D dp->lag,
>  		.addr =3D addr,
>  		.vid =3D vid,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
>  }
>=20=20
> @@ -905,8 +950,15 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
>  		.sw_index =3D dp->ds->index,
>  		.port =3D dp->index,
>  		.mdb =3D mdb,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
>  }
>=20=20
> @@ -917,8 +969,15 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
>  		.sw_index =3D dp->ds->index,
>  		.port =3D dp->index,
>  		.mdb =3D mdb,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
>  }
>=20=20
> @@ -929,6 +988,10 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
>  		.sw_index =3D dp->ds->index,
>  		.port =3D dp->index,
>  		.mdb =3D mdb,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>  	struct dsa_port *cpu_dp =3D dp->cpu_dp;
>  	int err;
> @@ -937,6 +1000,9 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
>  	if (err)
>  		return err;
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
>  }
>=20=20
> @@ -947,6 +1013,10 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
>  		.sw_index =3D dp->ds->index,
>  		.port =3D dp->index,
>  		.mdb =3D mdb,
> +		.db =3D {
> +			.type =3D DSA_DB_BRIDGE,
> +			.bridge =3D *dp->bridge,
> +		},
>  	};
>  	struct dsa_port *cpu_dp =3D dp->cpu_dp;
>  	int err;
> @@ -955,6 +1025,9 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
>  	if (err)
>  		return err;
>=20=20
> +	if (!dp->ds->fdb_isolation)
> +		info.db.bridge.num =3D 0;
> +
>  	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
>  }
>=20=20
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index eb38beb10147..1d3c161e3131 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -210,21 +210,41 @@ static bool dsa_port_host_address_match(struct dsa_=
port *dp,
>  	return false;
>  }
>=20=20
> +static bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
> +{
> +	if (a->type !=3D b->type)
> +		return false;
> +
> +	switch (a->type) {
> +	case DSA_DB_PORT:
> +		return a->dp =3D=3D b->dp;
> +	case DSA_DB_LAG:
> +		return a->lag.dev =3D=3D b->lag.dev;
> +	case DSA_DB_BRIDGE:
> +		return a->bridge.num =3D=3D b->bridge.num;
> +	default:
> +		WARN_ON(1);
> +		return false;
> +	}
> +}
> +
>  static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_lis=
t,
> -					      const unsigned char *addr,
> -					      u16 vid)
> +					      const unsigned char *addr, u16 vid,
> +					      struct dsa_db db)
>  {
>  	struct dsa_mac_addr *a;
>=20=20
>  	list_for_each_entry(a, addr_list, list)
> -		if (ether_addr_equal(a->addr, addr) && a->vid =3D=3D vid)
> +		if (ether_addr_equal(a->addr, addr) && a->vid =3D=3D vid &&
> +		    dsa_db_equal(&a->db, &db))
>  			return a;
>=20=20
>  	return NULL;
>  }
>=20=20
>  static int dsa_port_do_mdb_add(struct dsa_port *dp,
> -			       const struct switchdev_obj_port_mdb *mdb)
> +			       const struct switchdev_obj_port_mdb *mdb,
> +			       struct dsa_db db)
>  {
>  	struct dsa_switch *ds =3D dp->ds;
>  	struct dsa_mac_addr *a;
> @@ -233,11 +253,11 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
>=20=20
>  	/* No need to bother with refcounting for user ports */
>  	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
> -		return ds->ops->port_mdb_add(ds, port, mdb);
> +		return ds->ops->port_mdb_add(ds, port, mdb, db);
>=20=20
>  	mutex_lock(&dp->addr_lists_lock);
>=20=20
> -	a =3D dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
> +	a =3D dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, db);
>  	if (a) {
>  		refcount_inc(&a->refcount);
>  		goto out;
> @@ -249,7 +269,7 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
>  		goto out;
>  	}
>=20=20
> -	err =3D ds->ops->port_mdb_add(ds, port, mdb);
> +	err =3D ds->ops->port_mdb_add(ds, port, mdb, db);
>  	if (err) {
>  		kfree(a);
>  		goto out;
> @@ -257,6 +277,7 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
>=20=20
>  	ether_addr_copy(a->addr, mdb->addr);
>  	a->vid =3D mdb->vid;
> +	a->db =3D db;
>  	refcount_set(&a->refcount, 1);
>  	list_add_tail(&a->list, &dp->mdbs);
>=20=20
> @@ -267,7 +288,8 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
>  }
>=20=20
>  static int dsa_port_do_mdb_del(struct dsa_port *dp,
> -			       const struct switchdev_obj_port_mdb *mdb)
> +			       const struct switchdev_obj_port_mdb *mdb,
> +			       struct dsa_db db)
>  {
>  	struct dsa_switch *ds =3D dp->ds;
>  	struct dsa_mac_addr *a;
> @@ -276,11 +298,11 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
>=20=20
>  	/* No need to bother with refcounting for user ports */
>  	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
> -		return ds->ops->port_mdb_del(ds, port, mdb);
> +		return ds->ops->port_mdb_del(ds, port, mdb, db);
>=20=20
>  	mutex_lock(&dp->addr_lists_lock);
>=20=20
> -	a =3D dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
> +	a =3D dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, db);
>  	if (!a) {
>  		err =3D -ENOENT;
>  		goto out;
> @@ -289,7 +311,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
>  	if (!refcount_dec_and_test(&a->refcount))
>  		goto out;
>=20=20
> -	err =3D ds->ops->port_mdb_del(ds, port, mdb);
> +	err =3D ds->ops->port_mdb_del(ds, port, mdb, db);
>  	if (err) {
>  		refcount_set(&a->refcount, 1);
>  		goto out;
> @@ -305,7 +327,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
>  }
>=20=20
>  static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char =
*addr,
> -			       u16 vid)
> +			       u16 vid, struct dsa_db db)
>  {
>  	struct dsa_switch *ds =3D dp->ds;
>  	struct dsa_mac_addr *a;
> @@ -314,11 +336,11 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp,=
 const unsigned char *addr,
>=20=20
>  	/* No need to bother with refcounting for user ports */
>  	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
> -		return ds->ops->port_fdb_add(ds, port, addr, vid);
> +		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
>=20=20
>  	mutex_lock(&dp->addr_lists_lock);
>=20=20
> -	a =3D dsa_mac_addr_find(&dp->fdbs, addr, vid);
> +	a =3D dsa_mac_addr_find(&dp->fdbs, addr, vid, db);
>  	if (a) {
>  		refcount_inc(&a->refcount);
>  		goto out;
> @@ -330,7 +352,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, c=
onst unsigned char *addr,
>  		goto out;
>  	}
>=20=20
> -	err =3D ds->ops->port_fdb_add(ds, port, addr, vid);
> +	err =3D ds->ops->port_fdb_add(ds, port, addr, vid, db);
>  	if (err) {
>  		kfree(a);
>  		goto out;
> @@ -338,6 +360,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, c=
onst unsigned char *addr,
>=20=20
>  	ether_addr_copy(a->addr, addr);
>  	a->vid =3D vid;
> +	a->db =3D db;
>  	refcount_set(&a->refcount, 1);
>  	list_add_tail(&a->list, &dp->fdbs);
>=20=20
> @@ -348,7 +371,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, c=
onst unsigned char *addr,
>  }
>=20=20
>  static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char =
*addr,
> -			       u16 vid)
> +			       u16 vid, struct dsa_db db)
>  {
>  	struct dsa_switch *ds =3D dp->ds;
>  	struct dsa_mac_addr *a;
> @@ -357,11 +380,11 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp,=
 const unsigned char *addr,
>=20=20
>  	/* No need to bother with refcounting for user ports */
>  	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
> -		return ds->ops->port_fdb_del(ds, port, addr, vid);
> +		return ds->ops->port_fdb_del(ds, port, addr, vid, db);
>=20=20
>  	mutex_lock(&dp->addr_lists_lock);
>=20=20
> -	a =3D dsa_mac_addr_find(&dp->fdbs, addr, vid);
> +	a =3D dsa_mac_addr_find(&dp->fdbs, addr, vid, db);
>  	if (!a) {
>  		err =3D -ENOENT;
>  		goto out;
> @@ -370,7 +393,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, c=
onst unsigned char *addr,
>  	if (!refcount_dec_and_test(&a->refcount))
>  		goto out;
>=20=20
> -	err =3D ds->ops->port_fdb_del(ds, port, addr, vid);
> +	err =3D ds->ops->port_fdb_del(ds, port, addr, vid, db);
>  	if (err) {
>  		refcount_set(&a->refcount, 1);
>  		goto out;
> @@ -386,14 +409,15 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp,=
 const unsigned char *addr,
>  }
>=20=20
>  static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_l=
ag *lag,
> -				     const unsigned char *addr, u16 vid)
> +				     const unsigned char *addr, u16 vid,
> +				     struct dsa_db db)
>  {
>  	struct dsa_mac_addr *a;
>  	int err =3D 0;
>=20=20
>  	mutex_lock(&lag->fdb_lock);
>=20=20
> -	a =3D dsa_mac_addr_find(&lag->fdbs, addr, vid);
> +	a =3D dsa_mac_addr_find(&lag->fdbs, addr, vid, db);
>  	if (a) {
>  		refcount_inc(&a->refcount);
>  		goto out;
> @@ -405,7 +429,7 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switc=
h *ds, struct dsa_lag *lag,
>  		goto out;
>  	}
>=20=20
> -	err =3D ds->ops->lag_fdb_add(ds, *lag, addr, vid);
> +	err =3D ds->ops->lag_fdb_add(ds, *lag, addr, vid, db);
>  	if (err) {
>  		kfree(a);
>  		goto out;
> @@ -423,14 +447,15 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_swi=
tch *ds, struct dsa_lag *lag,
>  }
>=20=20
>  static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_l=
ag *lag,
> -				     const unsigned char *addr, u16 vid)
> +				     const unsigned char *addr, u16 vid,
> +				     struct dsa_db db)
>  {
>  	struct dsa_mac_addr *a;
>  	int err =3D 0;
>=20=20
>  	mutex_lock(&lag->fdb_lock);
>=20=20
> -	a =3D dsa_mac_addr_find(&lag->fdbs, addr, vid);
> +	a =3D dsa_mac_addr_find(&lag->fdbs, addr, vid, db);
>  	if (!a) {
>  		err =3D -ENOENT;
>  		goto out;
> @@ -439,7 +464,7 @@ static int dsa_switch_do_lag_fdb_del(struct dsa_switc=
h *ds, struct dsa_lag *lag,
>  	if (!refcount_dec_and_test(&a->refcount))
>  		goto out;
>=20=20
> -	err =3D ds->ops->lag_fdb_del(ds, *lag, addr, vid);
> +	err =3D ds->ops->lag_fdb_del(ds, *lag, addr, vid, db);
>  	if (err) {
>  		refcount_set(&a->refcount, 1);
>  		goto out;
> @@ -466,7 +491,8 @@ static int dsa_switch_host_fdb_add(struct dsa_switch =
*ds,
>  	dsa_switch_for_each_port(dp, ds) {
>  		if (dsa_port_host_address_match(dp, info->sw_index,
>  						info->port)) {
> -			err =3D dsa_port_do_fdb_add(dp, info->addr, info->vid);
> +			err =3D dsa_port_do_fdb_add(dp, info->addr, info->vid,
> +						  info->db);
>  			if (err)
>  				break;
>  		}
> @@ -487,7 +513,8 @@ static int dsa_switch_host_fdb_del(struct dsa_switch =
*ds,
>  	dsa_switch_for_each_port(dp, ds) {
>  		if (dsa_port_host_address_match(dp, info->sw_index,
>  						info->port)) {
> -			err =3D dsa_port_do_fdb_del(dp, info->addr, info->vid);
> +			err =3D dsa_port_do_fdb_del(dp, info->addr, info->vid,
> +						  info->db);
>  			if (err)
>  				break;
>  		}
> @@ -505,7 +532,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
>  	if (!ds->ops->port_fdb_add)
>  		return -EOPNOTSUPP;
>=20=20
> -	return dsa_port_do_fdb_add(dp, info->addr, info->vid);
> +	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
>  }
>=20=20
>  static int dsa_switch_fdb_del(struct dsa_switch *ds,
> @@ -517,7 +544,7 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
>  	if (!ds->ops->port_fdb_del)
>  		return -EOPNOTSUPP;
>=20=20
> -	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
> +	return dsa_port_do_fdb_del(dp, info->addr, info->vid, info->db);
>  }
>=20=20
>  static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
> @@ -532,7 +559,8 @@ static int dsa_switch_lag_fdb_add(struct dsa_switch *=
ds,
>  	dsa_switch_for_each_port(dp, ds)
>  		if (dsa_port_offloads_lag(dp, info->lag))
>  			return dsa_switch_do_lag_fdb_add(ds, info->lag,
> -							 info->addr, info->vid);
> +							 info->addr, info->vid,
> +							 info->db);
>=20=20
>  	return 0;
>  }
> @@ -549,7 +577,8 @@ static int dsa_switch_lag_fdb_del(struct dsa_switch *=
ds,
>  	dsa_switch_for_each_port(dp, ds)
>  		if (dsa_port_offloads_lag(dp, info->lag))
>  			return dsa_switch_do_lag_fdb_del(ds, info->lag,
> -							 info->addr, info->vid);
> +							 info->addr, info->vid,
> +							 info->db);
>=20=20
>  	return 0;
>  }
> @@ -604,7 +633,7 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
>  	if (!ds->ops->port_mdb_add)
>  		return -EOPNOTSUPP;
>=20=20
> -	return dsa_port_do_mdb_add(dp, info->mdb);
> +	return dsa_port_do_mdb_add(dp, info->mdb, info->db);
>  }
>=20=20
>  static int dsa_switch_mdb_del(struct dsa_switch *ds,
> @@ -616,7 +645,7 @@ static int dsa_switch_mdb_del(struct dsa_switch *ds,
>  	if (!ds->ops->port_mdb_del)
>  		return -EOPNOTSUPP;
>=20=20
> -	return dsa_port_do_mdb_del(dp, info->mdb);
> +	return dsa_port_do_mdb_del(dp, info->mdb, info->db);
>  }
>=20=20
>  static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
> @@ -631,7 +660,7 @@ static int dsa_switch_host_mdb_add(struct dsa_switch =
*ds,
>  	dsa_switch_for_each_port(dp, ds) {
>  		if (dsa_port_host_address_match(dp, info->sw_index,
>  						info->port)) {
> -			err =3D dsa_port_do_mdb_add(dp, info->mdb);
> +			err =3D dsa_port_do_mdb_add(dp, info->mdb, info->db);
>  			if (err)
>  				break;
>  		}
> @@ -652,7 +681,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch =
*ds,
>  	dsa_switch_for_each_port(dp, ds) {
>  		if (dsa_port_host_address_match(dp, info->sw_index,
>  						info->port)) {
> -			err =3D dsa_port_do_mdb_del(dp, info->mdb);
> +			err =3D dsa_port_do_mdb_del(dp, info->mdb, info->db);
>  			if (err)
>  				break;
>  		}
> --=20
> 2.25.1
