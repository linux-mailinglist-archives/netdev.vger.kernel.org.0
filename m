Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B0755E3DC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345994AbiF1Mze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiF1Mz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:55:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCC22F3A5
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656420927; x=1687956927;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ZaFf5IIMef2wcDhY7OREZzrcJSL2sDkfnKsb/X1mrU4=;
  b=alzx1B1u/dtKt7HTowYCARih2zqTe/4xOU4ogIQ/OfjWkg7ZheEAV57n
   XRnYtYtOAMsCGldPJUoNC8osFy/rqzK7LhIrYhgPrm8MnGl7VWHpuflPb
   8B8tOuQXOWT65+SPT2arwIGfihdKNtevxcB+R+fZ9plsHAiLMstLr9hbg
   jYsVgkPuR/KBlySMNu7wwPACmHEHgtFABecD5yMFZcvXyPEpu6HixEd9Z
   s7U6LzWt8cm4znWEGy69Po3MN0Of9qhqaNMxvZ/uaOvMRSCKzkfTvl9wJ
   CcW14yr8bZxujsQztIMjYSik6zknIYnio+/NXcNcBvAycLHNoXZl9VoUf
   g==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="162392254"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 05:55:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 05:55:25 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 05:55:23 -0700
Message-ID: <195d9aeee538692a3a630bfe7ce5c040396c507b.camel@microchip.com>
Subject: Re: [PATCH net-next] net: sparx5: mdb add/del handle non-sparx5
 devices
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Date:   Tue, 28 Jun 2022 14:55:22 +0200
In-Reply-To: <20220628075546.3560083-1-casper.casan@gmail.com>
References: <20220628075546.3560083-1-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casper,

On Tue, 2022-06-28 at 09:55 +0200, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> When adding/deleting mdb entries on other net_devices, eg., tap
> interfaces, it should not crash.
>=20
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
> =C2=A0drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 6 ++++++
> =C2=A01 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> index 40ef9fad3a77..ec07f7d0528c 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> @@ -397,6 +397,9 @@ static int sparx5_handle_port_mdb_add(struct net_devi=
ce *dev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool is_host;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int res, err;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sparx5_netdevice_check(dev))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return -EOPNOTSUPP;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_host =3D netif_is_bridge_ma=
ster(v->obj.orig_dev);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* When VLAN unaware the vlan =
value is not parsed and we receive vid 0.
> @@ -480,6 +483,9 @@ static int sparx5_handle_port_mdb_del(struct net_devi=
ce *dev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 mact_entry, res, pgid_entr=
y[3], misc_cfg;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool host_ena;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sparx5_netdevice_check(dev))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return -EOPNOTSUPP;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!br_vlan_enabled(spx5->hw_=
bridge_dev))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 vid =3D 1;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> --
> 2.30.2
>=20

Indeed!

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

--=20
Best Regards
Steen

-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
steen.hegelund@microchip.com

