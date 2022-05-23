Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22080531F1B
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiEWXIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEWXIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:08:41 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150042.outbound.protection.outlook.com [40.107.15.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25354703D7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFP3sdJ9wFgVgmfIMlRbzucM9iHzXAy09bKbiL/Y48/5Ld8xtGBumtD9ELWJxFPqnH5zt+oIp7QHivhsyG/SG9WX0GNPUNCTzBjdfh03mG0M2zTSj/oRDd58OqiD+CqjAWO5mpxzyWMHSBdoV5wao8fuQbt9runxgaEvCl6uKWDfe3kzRxdBnyiKjVauA5ghS/51W22lYIkSOq9n+U/wmrRk2F27KOxhssJGXn+Gq2EG2AhjpTDZ0b4EyzcK5zZeNxoWLT4+yi7wlngitb0QFidXxn0HRfRm8um9KYiu2voa62+66BzRWZlvLix0ivdeEtyFXZXhmZc37uXtKYG9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vwn443+ov/IuAhsSBfelmeQx8yHtChaXBxceVrLch2U=;
 b=f7Dde9B0wuBrz00z9rAfyNsxLqCsS2yEp4EkaxdYc8g+qewsG6bKreb8k0vzCg2rt2ntdTdoC0qlmQYtwy9Qn4bgQTJf/bmv5mtSW3gMAEVq4i3IeDbmxCpdtE5SkPRsR2qZItm1ZLidPWbkm7iADWTTkFxoENIl+N1urU7J2GXra8iPGKcYuf+NDlvq9jCt53u4EHb60ILqdRHd5w2kRfVHBzpEWeUQEEgKe00aTHcOlVEhNBaNhPcNJcjpF/kp328aCZpKcNaw4OZog5/f73BxpFHm7qqUn7IIQIcNNOMWOyXZ4GTgLgtgrmDrRBfDYJOmPxOVH6wVBAjDXR0coA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwn443+ov/IuAhsSBfelmeQx8yHtChaXBxceVrLch2U=;
 b=VgRd17amIeq35DDYJC/BmYevgW9o/dGRhc612Hi4b3yx6zeBOfoVuprGZZId2yXdFp49Y3Wspu5+J2Mbzg9zmC9RigkkaYN6oBLp0OAKP1x585CRpgHOGK2R9OsCQcVYW6pssclgHOwkWhQh3UngSs4MTMdrsxhQSu6l4NC/AzY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6832.eurprd04.prod.outlook.com (2603:10a6:803:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Mon, 23 May
 2022 23:08:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 23:08:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next 10/12] net: dsa: allow the DSA master to be
 seen and changed through rtnetlink
Thread-Topic: [RFC PATCH net-next 10/12] net: dsa: allow the DSA master to be
 seen and changed through rtnetlink
Thread-Index: AQHYbpHt18I0+hrVP0WibLGY8Ze5Fa0szF2AgABKjAA=
Date:   Mon, 23 May 2022 23:08:35 +0000
Message-ID: <20220523230834.4jv2kyg6eqx5rmi3@skbuf>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-11-olteanv@gmail.com>
 <d5d485e3-bddf-f052-2f46-f306f53f3d34@gmail.com>
In-Reply-To: <d5d485e3-bddf-f052-2f46-f306f53f3d34@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd30639f-753e-4798-6245-08da3d112a17
x-ms-traffictypediagnostic: VI1PR04MB6832:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6832FCBBCD9CA3720945810DE0D49@VI1PR04MB6832.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45EtzwBmZP18I56hhzScUIYkidydkpAfED9S1Z2R8hVvCD5qn7Jl0K62IGFq/3uoDxLlxpCn7ctr9oJL5KcLBSlkIzTRAOpSV5Jx9dgRwn58HqDxTDgbQNRWgTZK6U+wkCKf092ruqumy1tbbFLbgp9AV19BOJUwm+hM4GyR8x8oh+Th7X7Q9GfNDCTBnaf4IiMf+i9fOwC+Iw55t9LUgeNUKdwXD065vvqzfnha4j6rAu8GaciDv0P3teVc82qNhn3WePq8TF2zp7xIn087fVaIC63HjUs0P3SrjFQdFr+0tckYHM1C4ycpFk+FyE4HROU0NYd1X1jmgfmQdFcBQCsgzlv62LA4emvf2+3QH69OSuVafcT41h7nMP2TvlD84LYs6vHC8CCJwhyaP1m7ztcAOE4k4j072OMK6kUHJFupldp2n1mr0vUknXhE+pGgSSDhuVD9CEjqiNTTeda1qGBB4JAnQ+0Pk7a4ociSGPfGqcT+iaYWMGtdicj7GwJjNBtHmS4a3fDHZc7tqwHv4lhXe0T+VmhYNuSnszmq0Tudv9n2omG9NEuKeNbLWI24iPBkXCp42TAdL6nbstYT/TlCYktevrt8ss/QyJOsOnu73JiCgTliwd/2fVhARWfmjm5YOxLDZFuQw4USFKqhTXZh0St07sslXcjcTxx61GR9Z/nOSelAJxgV9suaWt7qwZoCPYLIuiOgQzJ7pZuw7jTRSgStPgbq4/+MG8nvVnARnh7m6Adu3CXA/CJE+7tFQ4ymYV+WqbdDagy8B4QphKYrJ/7avbHi+I7XGK4k7Mw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(7416002)(122000001)(5660300002)(86362001)(966005)(44832011)(508600001)(66556008)(38070700005)(4326008)(8936002)(8676002)(2906002)(66946007)(64756008)(66446008)(66476007)(38100700002)(33716001)(91956017)(76116006)(316002)(26005)(9686003)(6512007)(6506007)(54906003)(6916009)(71200400001)(6486002)(83380400001)(186003)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?EYwVM45JbgtnVniqmn5rLGLf+TSjME4pjg3YhJ3sscwTSLo85ULdyRrM?=
 =?Windows-1252?Q?yGKk2nBoAjqv+pS25+SFq6ems9G90VQPluj/l50udFn15KvbRTKdmNgc?=
 =?Windows-1252?Q?jIFLPtobFtkig6AwhA1Ygr7Fim5UvRsTr/trArDaOgbTlAYLgcQmG4nx?=
 =?Windows-1252?Q?viKbbxg2t36D5JG2jQR33ISxm2vvr9fntBkEhtI6phS57h/EXMSALxr8?=
 =?Windows-1252?Q?4NjGAVGrMko1jh3Vk83OvitT0OhSP3CcQgRW8L4udlXlSmu2S9ksGP4L?=
 =?Windows-1252?Q?7k/AW4Kj8n53Y3+Op+vmpjtrkZ3aM7i5UdMjnbWTF5nYtzro38qtBkUY?=
 =?Windows-1252?Q?PUIA5Ayle/roibQ43TtYXA1C1yIMxyTbvLD1rqv9J5+EvwQvUdpvPBIC?=
 =?Windows-1252?Q?zkEvST05wy6LSJw6kzFXj9At77qsqMpzp2W0gFtmE0dWMTXAqkzNj0n5?=
 =?Windows-1252?Q?HoCGfXUAxX/zAZRVpbNIlKh3aZm+Zw5QJZ1k+a/8HKWA6M/Mkgj3RyLw?=
 =?Windows-1252?Q?TcfplgqwWZd4cs250Vd2GiUXsTv9/Na85pz3ygfD2J6yLsluVAkMByjT?=
 =?Windows-1252?Q?sQt8g3Q7zTaGNGFfi86bt6EiU7oGqicQogR8St4MehnhUIUhIh68Zk7u?=
 =?Windows-1252?Q?ybbqX4lJsccuKod6Feg0G7txtk69G8g1yqOwokjiGoWm79hQQob4D464?=
 =?Windows-1252?Q?EfK2u5jzAUlIHf1Wtt3CMp6dsrlmxYD/2h+g20WDmgDWDaoFIZHHREY8?=
 =?Windows-1252?Q?bVTiyPOw3MrLJ0coYLIbCw+8gyJiynEYmOYrnd1pe3zyMixUlN03zZr1?=
 =?Windows-1252?Q?ylF4+TQOJB6GNTon0n6RKKytKCQOewUaFydlEQuaoMTsuIXZeJ80SSLO?=
 =?Windows-1252?Q?kyrD4T200Ie8032w2ZulbuqwTt53FIHqYWhzdELos8GXbl/QGv6xGnOi?=
 =?Windows-1252?Q?9lhoC2iy9IhuzdHQErgVlapgYsRYsd7W3ODhLxLNYrZtyy3EP/Lb4FjY?=
 =?Windows-1252?Q?Z+1M2zFmsu8IvgjujwiPOac6vTErVTULr5a00jZFUKI2vMMKSphNcVUE?=
 =?Windows-1252?Q?EVTnMorXFpKQ6MBriyqOCQjJ1j83mqeH5P0kNiYIwz4ubPMru0xy/Ed9?=
 =?Windows-1252?Q?CBBfpJH0nUC+DJMwqcZSsalRCnQR9D6KrWTulPHMmRAKigESyOhVMHYD?=
 =?Windows-1252?Q?e0mvm10+UYSNUssn3hxDdQy+A9Y87L812mt5rhRiMq3458gyNrJIMtnm?=
 =?Windows-1252?Q?auVvG9mAy8V6NArKZoMD24nxbilyZFVTtJs58iEJfrPeVAThp6ycJ+TS?=
 =?Windows-1252?Q?BJdQr11kLWhW/2QHL2VO23u2bW/bG2dHXmj+ZYHIYfjwcdQziLYFmd9T?=
 =?Windows-1252?Q?prUqIOB4j6g2azjmU3Qa8czejrfxUIq4gVZE/BrNYJeotwVA5srr5u5C?=
 =?Windows-1252?Q?a7v5NKLeAkm9th67cPRTr2+ivMuehQP2/pwm9KNK7ebCZ1d/Z/aU3AC0?=
 =?Windows-1252?Q?BtnMqcFeU+xICeDNwzqiL7AdgtFbwzuIth6BjoFaHcNTJkN2vyewVDnW?=
 =?Windows-1252?Q?aZPqetJsevHDi7V0Ly+Ivr6dqJjF5g/wAHqYLMzKUvKkVLyAtaXTm4Tq?=
 =?Windows-1252?Q?aoTzn6LjK2N1PzqR98EQTvS+40o4Me0qbOm2DB8R/Vrr4XEz3NyRimZt?=
 =?Windows-1252?Q?TVaxFsaCx4jK7/oziuR++/Ga3SkCJf6wwPjEdohvp5DZ/U672bMDA1zn?=
 =?Windows-1252?Q?7R4G69XHgHZPuqgRya/lo4MgaiCPmMHxjn3PAbIO+hD9Uzm4iArtiHyF?=
 =?Windows-1252?Q?+1RL0aw3VdZXWxGPMhb9/86IZ45oBu1lFwMEv4yHZ0iH1+9+itK3tq2A?=
 =?Windows-1252?Q?rVqUUmb3U2KL5kxTsHRsfTm64bqe2jXC8x0=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9EA686D335A10343A4BBA347A6A65512@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd30639f-753e-4798-6245-08da3d112a17
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 23:08:35.6104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 54f6qqa584iA7glEXTtRcUttztbm6QlnxLLaa3qJzhJm0JFYuGpBshUWUkv1sE5zzA5D36xf6gbglaiV/aSSBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6832
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 11:41:45AM -0700, Florian Fainelli wrote:
> > +static int dsa_changelink(struct net_device *dev, struct nlattr *tb[],
> > +			  struct nlattr *data[],
> > +			  struct netlink_ext_ack *extack)
> > +{
> > +	int err;
> > +
> > +	if (!data)
> > +		return 0;
> > +
> > +	if (data[IFLA_DSA_MASTER]) {
>=20
> We could add a comment to explain that IFLA_LINK is "reserved" for standa=
rd
> usage of associating the DSA device with a different upper type, like VLA=
N,
> bridge master etc.

TBH I don't have a very strong opinion here. IFLA_LINK does not mean the
same thing for all virtual netdevices, it means one thing for vlan/macvlan
where it describes an upper/lower relationship and another for veth
where it describes the pair, and yet another for DSA where it describes
the host port.

What seems to be universally loved about IFLA_LINK is that the notation
"eth0@eth1" used by iproute2 is cute, it lets loose users' imagination.

I did ask here whether it would be good to introduce a more specific
attribute, no response though.
https://lore.kernel.org/netdev/20210411170939.cxmva5vdcpqu4bmi@skbuf/

If the IFLA_LINK meaning is namespaced per netdev kind, I suppose we
could reuse that just fine to change the DSA master. In any case I
wouldn't want to make the debate of the century out of this.

> > +		u32 ifindex =3D nla_get_u32(data[IFLA_DSA_MASTER]);
> > +		struct net_device *master;
> > +
> > +		master =3D __dev_get_by_index(dev_net(dev), ifindex);
> > +		if (!master)
> > +			return -EINVAL;
> > +
> > +		err =3D dsa_slave_change_master(dev, master, extack);
> > +		if (err)
> > +			return err;
> > +	}
>=20
> I would be tempted to reduce the indentation here because we are almost
> guaranteed to add code in that conditional section?

The idea was to avoid code movement if we ever add other netlink
attributes other than IFLA_DSA_MASTER. But not sure whether to optimize
for that.

> [snip]
>=20
> > +static int dsa_port_assign_master(struct dsa_port *dp,
> > +				  struct net_device *master,
> > +				  struct netlink_ext_ack *extack,
> > +				  bool fail_on_err)
> > +{
> > +	struct dsa_switch *ds =3D dp->ds;
> > +	int port =3D dp->index, err;
> > +
> > +	err =3D ds->ops->port_change_master(ds, port, master, extack);
> > +	if (err && !fail_on_err)
> > +		dev_err(ds->dev, "port %d failed to assign master %s: %pe\n",
> > +			port, master->name, ERR_PTR(err));
>=20
> Should not that go over extack instead?

Here we print if "fail_on_err" was false. We avoid failing on errors
when we are in an error rollback code path. This is also the reason why
I did not set extack, presumably because it may have been set before by
ds->ops->port_change_master. Printing to the console shows all errors
along the path, setting the extack shows only the first, or last, error.

> > +
> > +	if (err && fail_on_err)
> > +		return err;
> > +
> > +	dp->cpu_dp =3D master->dsa_ptr;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Change the dp->cpu_dp affinity for a user port. Note that both cros=
s-chip
> > + * notifiers and drivers have implicit assumptions about user-to-CPU-p=
ort
> > + * mappings, so we unfortunately cannot delay the deletion of the obje=
cts
> > + * (switchdev, standalone addresses, standalone VLANs) on the old CPU =
port
> > + * until the new CPU port has been set up. So we need to completely te=
ar down
> > + * the old CPU port before changing it, and restore it on errors durin=
g the
> > + * bringup of the new one.
> > + */
> > +int dsa_port_change_master(struct dsa_port *dp, struct net_device *mas=
ter,
> > +			   struct netlink_ext_ack *extack)
> > +{
> > +	struct net_device *bridge_dev =3D dsa_port_bridge_dev_get(dp);
> > +	struct net_device *old_master =3D dsa_port_to_master(dp);
> > +	struct net_device *dev =3D dp->slave;
> > +	struct dsa_switch *ds =3D dp->ds;
> > +	int port =3D dp->index;
> > +	bool vlan_filtering;
> > +	int err, tmp;
> > +
> > +	/* Bridges may hold host FDB, MDB and VLAN objects. These need to be
> > +	 * migrated, so dynamically unoffload and later reoffload the bridge
> > +	 * port.
> > +	 */
> > +	if (bridge_dev) {
> > +		dsa_port_pre_bridge_leave(dp, bridge_dev);
> > +		dsa_port_bridge_leave(dp, bridge_dev);
> > +	}
> > +
> > +	/* The port might still be VLAN filtering even if it's no longer
> > +	 * under a bridge, either due to ds->vlan_filtering_is_global or
> > +	 * ds->needs_standalone_vlan_filtering. In turn this means VLANs
> > +	 * on the CPU port.
> > +	 */
> > +	vlan_filtering =3D dsa_port_is_vlan_filtering(dp);
> > +	if (vlan_filtering) {
> > +		err =3D dsa_slave_manage_vlan_filtering(dev, false);
> > +		if (err) {
> > +			dev_err(ds->dev,
> > +				"port %d failed to remove standalone VLANs: %pe\n",
> > +				port, ERR_PTR(err));
>=20
> Likewise, should not that be via extack? And likewise for pretty much any
> message down below.

Here we could populate the extack.

> [snip]
>=20
> > +	if (!ds->ops->port_change_master)
> > +		return -EOPNOTSUPP;
>=20
> This could be provided over extactk since it is not even supposed to be
> happening.

What do you mean it's not supposed to be happening? This is the only
place where we have a NULL check for ds->ops->port_change_master.
I didn't add an extack here because I didn't think there's much to say
beside the usual strerror(EOPNOTSUPP) =3D "Operation not supported".
I may add an extack saying "Driver does not support changing DSA master"
or some sort of message like that.=
