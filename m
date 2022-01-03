Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D7E483537
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 17:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiACQ5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 11:57:50 -0500
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:11097
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229972AbiACQ5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 11:57:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYiEqD4U03t6TvrR8pn8UoAsBlX/RB7ZRT5WbN4XsbyXQh8KRpk7KuWwGlCjFuaThtkL3dd2eWn0EXKRDXA+izGrlzkGyj0HYsRXn9Dun/z9MwYDwsjRy1jbLX9YzwcyiTB8p2aj2vtD/FPKDr7pBfv9T1QbCtOUYM1DHf4oY3Kx+EbOT5IRIlKjmJFX/iBiLSiHCBOEcj8O96mBKa/fYBnGE5sXdAT2+s02uBZLbuJblE9WdSE8aO9+McAzpcBAH37y7EdIT3uMzSjoSLgHz/gCbQWzitjk8HD3e3ko6QY7wOUZRCITnwLIs3Oh4n4b92djD3eqNaP5CNT6EEya1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zH2ZliqXhQRdV+OYpAus0mkVYvVd04j9e7RwRw5Zw9c=;
 b=byCvbvHAr4bKpuP9jWARYkuQ6ywKA4R24UhsG5KG1Iivcea7KTwxocXrkCjB9rADIcMrvtJeKVVKU5N+PYhfV1xj0QcPHRzLUEBHND60KSLPMSsM7aMdA/U7jvzWZFyngDc5TLez2tLW+whl7hNIXtiyg4Wkp1ttluqWy77sGkfF1KB8cdQocqBLfz4Hq1uaTQQVi5GAE3sSg0kd+JgOO/olvK1rMJ6YVolGgj+wqJIfRoQq/vjIRqcbDGhJetyVB26Fliv81b9z7gWnuZ7Smsg2zNoxm1s5iXzxfnV+b94N64pYT3V+wjQgz+LqYlG6mSwYcyIV0GQVYGAeJVyufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zH2ZliqXhQRdV+OYpAus0mkVYvVd04j9e7RwRw5Zw9c=;
 b=cmgqh2QlVhQOTtky2UUAkzBXI4R3KdEoW0V+SLNxBoBPS3GAi1DdiCqlTsp4gDeTP6KavEZZyp72REKn7mP+QbyX9dpxlNBjsaWSuCX+0nne/BY13AGol6l21c+5aGcN1NPju+eQR4jzXUj7YlDeEp4KmcTfEd2vWesKk+/LsAY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6701.eurprd04.prod.outlook.com (2603:10a6:803:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 16:57:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 16:57:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next 3/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Topic: [PATCH net-next 3/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Index: AQHYAKMIHZYff/CKbEOFLJOI5RqZu6xRXzmAgAAbxwCAAAnJAA==
Date:   Mon, 3 Jan 2022 16:57:46 +0000
Message-ID: <20220103165746.vb5t2krevu5nnqtx@skbuf>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
 <20220103131039.3473876-4-horatiu.vultur@microchip.com>
 <20220103144319.w65nc3c4ru24zzh7@skbuf>
 <20220103162244.wjbn5rezn54jvuwj@soft-dev3-1.localhost>
In-Reply-To: <20220103162244.wjbn5rezn54jvuwj@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f0104e2-676f-43db-23c5-08d9ceda2b1c
x-ms-traffictypediagnostic: VE1PR04MB6701:EE_
x-microsoft-antispam-prvs: <VE1PR04MB6701C7FB04865327A04B3E24E0499@VE1PR04MB6701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O5WEJycNq6r8s8h4CBuRiNHkDBTnEQfC3LLrvCvj9Jow615Ankix2wxWYYo2iwvWOhi1yY0m7+sx1H6sBihzIzpHL+OV5i3D96T6ApyV6WezA0ewiYoilWtcEZ2HTcIc3SITz4PqfzMo8usetDOrlqjeMfAyojkWDTWX7BkJOepsqHvQm/IBM16nQXhq85DAt7v91q52eTiq6CiVl5cQTrWpZY8LqlC7UxPU/4x1c0cXvfw0AU9+P7Wr1ennYQE8QHANcyyiUNfA3hNjYqehk3RsFt63+NUYbTmneYgEofhxO6+9rQ8HQO02T/Px5ppykv557oCWtv7l7ckO2JWybScuN8iHIu3HtKzH/z+/mNYLoBUIwc73AOQFAqtuzhfRFhctocD1uX/FpI5M9ukNs2CpZr/qpgx1m8gPun2Vt2fROcwKrY1/mmfoYHfwoiwkj7KAMTAXROPt6gpOAH/hOUFp8OMDtGBrB7XtxO2KHzQnxTnhDfn5lKzeSxKmhcBvORgzKdBIbVQfxYWE2zuk99FbJnN03LD1FEmzsdrdA2HZoOuM7QV+SE+2oBPinNEhM6HGyWNrtS0Pzb6+f8quW3cWdff2Er9Elifk8GHy+3GYe5be4LzmdxNolHsACmow9s4hpKzvMuF17hZIUTHhG0Xf6E9f+R/1TIXl2DGz6V6r8LoWL9ZsIF5o5+/Pnw1lWlK96yN1VqTWwKE2yGF2QA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8936002)(6916009)(8676002)(6486002)(38070700005)(33716001)(2906002)(83380400001)(508600001)(76116006)(5660300002)(66946007)(91956017)(66556008)(6506007)(1076003)(66476007)(64756008)(66446008)(54906003)(9686003)(122000001)(26005)(38100700002)(186003)(6512007)(86362001)(44832011)(316002)(4326008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZMELIodrID4ycyRKkxx/FBMMSzPqgb2MrW7CG9l9hu5PEz9jVcEnkJb8nfVo?=
 =?us-ascii?Q?P8Y8gTqQbFXrJOUGMyVP8w3eG0W1Z9hYi/2Y772ARVXRH6Hd5HUa0kMIetWV?=
 =?us-ascii?Q?EkDVukhAxMIhk0OHg0K3HnxTSMFjA19xl5kqYbxc5sJoRUKG5PTSMO4zQ68t?=
 =?us-ascii?Q?nFrN6IKgi7zDdwrHKB4mVB1yLVUEPB2gM9JxeJGLEL48OZ+oUqCfq70bwV9E?=
 =?us-ascii?Q?AwGnBmj349SIW3JO5ubrdglIWAbF6TUFM88TwfDWaDY/PLH3hO5QANx/OPvh?=
 =?us-ascii?Q?5MGtc1Oh8A+nYZ8vp9yCN4jQ3JfXZAn0T6119TX/d4ge8D6p9aT9U1KwQYtU?=
 =?us-ascii?Q?sWezs1X75fnNoN+uUbd1oMpXlV9gLbuzEGXkXnQmr4iTAdTuuD93Rzr/ZOIi?=
 =?us-ascii?Q?Qn+jA3FgRqEUJlwWWFscVPtexYOfkOmFFRLSfjEOmBuSPSrf3aG4vU32H447?=
 =?us-ascii?Q?bRRYo1I0djBwH6f8wqj1rj09Le7W23u8fai0MlVnAq5cjEeqF17MJ3OFRcpv?=
 =?us-ascii?Q?Zl1FLQPE1U/opTa+3WJfMrjdHAPTM+CLW5olJ7TyRhn/UvnO4WAShznDzULQ?=
 =?us-ascii?Q?me+xox71HK319WKYs85D5IC70SEUZIaf/1jOFpwQowTpyWF9tqGrcffzL7WE?=
 =?us-ascii?Q?xfnAvmwy9rWun4oneVag121PY3oyNRuEXrrvbmWidAndo101VMuL02CFb4Uo?=
 =?us-ascii?Q?z90xcGWlpNmjmtlnggaG5yOKoLObrYn9x5DHU87m9bfY/idvqz7/ipNlE8lz?=
 =?us-ascii?Q?YNyRp0v+wXXcE6xa4bFS3+PGQk+Pi6rowfkq7xUnZiRegGstxlZVThiLMxf6?=
 =?us-ascii?Q?GzuhYbtRc5l0M8nWLzYIFcNEpqw8g0R9a84pYguLI/QsIBdSV6UsnliMSPBC?=
 =?us-ascii?Q?x3IycrDQrUBhGTSsiaqADBnJ9TXCIukQkq1BSM493pDj2NTqa9sV6UAUc9jO?=
 =?us-ascii?Q?F6UOnMrZUNogNVPO/avROhViGEroc2p6zU4RSNC0L9Qr7JMv1++3kInIJD2r?=
 =?us-ascii?Q?LSzectibsC4K1G2lgj9yVyWuQtuno/CfbVAEWzWSFz/pTskIuP520esBe29Z?=
 =?us-ascii?Q?/d4dVBWhPW586g3FDpmnoMH73MJFO7dLO8adAChbW1czlSzus4XItRC1WNXA?=
 =?us-ascii?Q?+8LNPTtEzCOgh3LmxzkoUSvrpfOFncUntGa7z8sO5Ht/ePOhu7VuxQMHo/TJ?=
 =?us-ascii?Q?19P6n8uexN0m0wZwjEeSkcbvZlMjOAcD/r5FwR0ohrG3+hOVnL1pBevGFUkr?=
 =?us-ascii?Q?6HARYpNS0iendStU9DP0QTLdOBWnY4M1I6vBri+9P6TeV80+ujb4LRqsWbKY?=
 =?us-ascii?Q?ijnEQTEhwM/r6FizEMMFJWEhagAaOL1hRfOIDuZz6PoO80/6G0fUo25P5giL?=
 =?us-ascii?Q?OejX6QNA2lkaGkc6Mixz96fUckhu6pCP4p+rwehLJfI+7Szu1iLOinkDOUo8?=
 =?us-ascii?Q?aMBCYLJhQEooAWDPuMcNtJXRbgmGi3mWN3wqntuWMBVhVWUiVH1fMf4DsMkA?=
 =?us-ascii?Q?ms3GDzVuknI1IftqWX0GKTLARwOzIEEFa6r98T1e7n/lGlEl5dCBWhutIdGC?=
 =?us-ascii?Q?CYsOVBacW7WYjZY+KrxxcZxFUnWJxYSPHuA0VdGiraz+7ri420CSWQL4AnGL?=
 =?us-ascii?Q?yVbWP58v+n8xGTAcRpvUIJI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C225388CFE30B94B8E003A9047770E48@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0104e2-676f-43db-23c5-08d9ceda2b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 16:57:46.9999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e3wUSlbAV1bWtX8YnDi2voJTekZf5ZUKbdwyBiAjmLgMEiKcxOkczr8iZHfLRlvhhI269ZK5JiOqp1Rc+wHb+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 05:22:44PM +0100, Horatiu Vultur wrote:
> > > +static int lan966x_mdb_ip_del(struct lan966x_port *port,
> > > +                           const struct switchdev_obj_port_mdb *mdb,
> > > +                           enum macaccess_entry_type type)
> > > +{
> > > +     bool cpu_port =3D netif_is_bridge_master(mdb->obj.orig_dev);
> > > +     struct lan966x *lan966x =3D port->lan966x;
> > > +     struct lan966x_mdb_entry *mdb_entry;
> > > +     unsigned char mac[ETH_ALEN];
> > > +
> > > +     mdb_entry =3D lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vi=
d);
> > > +     if (!mdb_entry) {
> > > +             /* If the CPU originted this and the entry was not foun=
d, it is
> >
> > s/originted/originated/
> >
> > > +              * because already another port has removed the entry
> > > +              */
> > > +             if (cpu_port)
> > > +                     return 0;
> >
> > Could you explain again why this is normal? If another port has removed
> > the entry, how is the address copied to the CPU any longer?
>
> The cpu_port is set only when the entry is deleted by the bridge. So then
> all the ports under the bridge will be notified about this. So when the f=
irst
> port is notified it would delete the entry and then when the second port =
is
> notified, it would try to delete the entry which is already deleted by
> the first port. That is the reason why it returns 0 and not an error.


> > The HOST_MDB switchdev events are replicated per the number of ports in
> > the bridge.
>
> Correct.
>
> > So I would expect that you keep refcounts on them, otherwise
> > the first deletion of such an element would trigger the removal of the
> > entry from hardware even though it's still in use.
>
> Sorry, I am not sure I am following, by whom is it still in use?
>
> I was trying the following commands:
>
> ip link set dev eth0 master br0
> ip link set dev eth1 master br0
> bridge mdb add dev br0 port br0 grp 225.1.2.3
>
> Then both ports eth0 and eth1 will get a notification about this. And
> they will add an entry in the MAC table for this.
> Then when the following command is run:
>
> bridge mdb del dev br0 port br0 grp 225.1.2.3
>
> Then again both ports will get a notification about this and eth0 will
> delete the entry from the MAC table. So why is this not correct? Then
> will be eth1 who will get the notification and try to delete the entry
> which is already deleted.

root@debian:~# ip link set swp0 up
[   42.938394] fsl_enetc 0000:00:00.2 eno2: configuring for fixed/internal =
link mode
[   42.949675] fsl_enetc 0000:00:00.2 eno2: Link is Up - 2.5Gbps/Full - flo=
w control rx/tx
[   42.959044] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii =
link mode
root@debian:~# ip link set swp1 up
[   44.440675] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii =
link mode
root@debian:~# ip link set swp2 up
[   45.788811] mscc_felix 0000:00:00.5 swp2: configuring for inband/qsgmii =
link mode
root@debian:~# ip link set swp3 up
[   47.784439] mscc_felix 0000:00:00.5 swp3: configuring for inband/qsgmii =
link mode
[   51.887374] mscc_felix 0000:00:00.5 swp3: Link is Up - 1Gbps/Full - flow=
 control rx/tx
[   51.895491] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[  100.303070] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow=
 control off
[  100.311016] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
root@debian:~# ip link add br0 type bridge
root@debian:~# ip link set swp0 master br0
[  115.436652] br0: port 1(swp0) entered blocking state
[  115.441736] br0: port 1(swp0) entered disabled state
[  115.447618] device swp0 entered promiscuous mode
root@debian:~# ip link set swp1 master br0
[  117.760700] br0: port 2(swp1) entered blocking state
[  117.765797] br0: port 2(swp1) entered disabled state
[  117.771335] device swp1 entered promiscuous mode
root@debian:~# ip link set swp2 master br0
[  119.612665] br0: port 3(swp2) entered blocking state
[  119.617750] br0: port 3(swp2) entered disabled state
[  119.623304] device swp2 entered promiscuous mode
root@debian:~# ip link set swp3 master br0
[  121.388388] br0: port 4(swp3) entered blocking state
[  121.393416] br0: port 4(swp3) entered disabled state
[  121.399292] device swp3 entered promiscuous mode
root@debian:~# [  148.905819] mscc_felix 0000:00:00.5: dsa_port_host_mdb_ad=
d: port 0 addr 33:33:ff:9e:9e:96 vid 0
[  148.914819] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 1 addr =
33:33:ff:9e:9e:96 vid 0
[  148.923723] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 2 addr =
33:33:ff:9e:9e:96 vid 0
[  148.932606] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 3 addr =
33:33:ff:9e:9e:96 vid 0
[  148.941426] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 0 addr =
33:33:00:00:00:6a vid 0
[  148.950351] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 1 addr =
33:33:00:00:00:6a vid 0
[  148.959164] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 2 addr =
33:33:00:00:00:6a vid 0
[  148.967967] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 3 addr =
33:33:00:00:00:6a vid 0
[  150.649744] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 0 addr =
33:33:00:00:00:fb vid 0
[  150.658674] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 1 addr =
33:33:00:00:00:fb vid 0
[  150.667538] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 2 addr =
33:33:00:00:00:fb vid 0
[  150.676389] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 3 addr =
33:33:00:00:00:fb vid 0
root@debian:~# ip link set br0 up
[  148.868268] br0: port 4(swp3) entered blocking state
[  148.873283] br0: port 4(swp3) entered forwarding state
[  148.878530] br0: port 1(swp0) entered blocking state
[  148.883546] br0: port 1(swp0) entered forwarding state
[  148.889443] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[  148.905819] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 0 addr =
33:33:ff:9e:9e:96 vid 0
[  148.914819] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 1 addr =
33:33:ff:9e:9e:96 vid 0
[  148.923723] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 2 addr =
33:33:ff:9e:9e:96 vid 0
[  148.932606] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 3 addr =
33:33:ff:9e:9e:96 vid 0
[  148.941426] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 0 addr =
33:33:00:00:00:6a vid 0
[  148.950351] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 1 addr =
33:33:00:00:00:6a vid 0
[  148.959164] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 2 addr =
33:33:00:00:00:6a vid 0
[  148.967967] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 3 addr =
33:33:00:00:00:6a vid 0
[  150.649744] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 0 addr =
33:33:00:00:00:fb vid 0
[  150.658674] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 1 addr =
33:33:00:00:00:fb vid 0
[  150.667538] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 2 addr =
33:33:00:00:00:fb vid 0
[  150.676389] mscc_felix 0000:00:00.5: dsa_port_host_mdb_add: port 3 addr =
33:33:00:00:00:fb vid 0
root@debian:~# ip link set swp3 nomaster
[  160.416054] device swp3 left promiscuous mode
[  160.420745] br0: port 4(swp3) entered disabled state
[  160.445427] mscc_felix 0000:00:00.5: dsa_port_host_mdb_del: port 3 addr =
33:33:00:00:00:fb vid 0
[  160.454201] mscc_felix 0000:00:00.5: dsa_port_host_mdb_del: port 3 addr =
33:33:00:00:00:6a vid 0
[  160.464843] mscc_felix 0000:00:00.5: dsa_port_host_mdb_del: port 3 addr =
33:33:ff:9e:9e:96 vid 0

Hope it's a bit clearer now. swp0, swp1 and swp2 are still under br0.=
