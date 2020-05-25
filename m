Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7951E1188
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404092AbgEYPUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:20:14 -0400
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:53851
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404085AbgEYPUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:20:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBm/0B7aq4zDnsRhhke/aLcB21UBd2qNgGxKn9uInq0ktGMWrPIzulSWYt3hRZSk4SDQ6CjWR0p+uRfI8p7cg3l4LTSvG5qbFIGuNUETm+Zs2GlXsnIcDvsPO2pD2vyLMr9g7pGJNeWf2Qtt/QjJweRW/klTVbjMooYRhJnoHopeBNXCk3XJdIBqEmo24gtkAeaLPt+HcCLWLuHgfeM3ZZMbf2NfnEtLs4rodzxXreBMKo1Lz1vxvlsa+AevprtL7RaMkfwDG4KNBQRhxtEz9C8H4o50E17jaE+I8ZYF7BWDjfpGKlqcho8Vv5k9ocF5uVQtOL8CxLPqcgdHcpsh7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWqUtO5QlQR8tEaRwxAFrk79aoPpFwRnRrN6/jO4N2c=;
 b=V1Iet1pi8CA3oErae0LoKYrPcO8Z6SzeQG7FBqessiRVACnQAqBA5BooULaNnKjsmqzwVHmRZgDzILq2ITdLyBjHctHKpwf6SkoTfHSwYizeFsLHvgt2vgVg17r5k4e4nym9NXqjY6HOo2FsnJSXI4j4QjMVaCMl717+iajGnzzL2SqPHz/sz70btEDHOaXc/22UiYmCNLgnwRa71P5revM9SQ+8/1zEYVY0r+iw8D94EEgn+aLDLHfYHUUaAjvC9l5cKAq+iYF9bEUOt54YBZmf0bHO5SouL9HWF7nNmWNYdbJ384F+ruZHV0GCEzhkYhkiJ1LpBVvfBCwjnhRnUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWqUtO5QlQR8tEaRwxAFrk79aoPpFwRnRrN6/jO4N2c=;
 b=EM8/rcYUrvnp7UtXoolVBcxSUsscAJHKSQMSHC4GiioXlH3PZ44YV+zoObLKsc/mwoBAq4A5vMHKfCWogdv9zqRuY1DmnzvKT6YNisiG/B7Mis13QqIJPECy2NhNz53rwYtomXVRmWke4ipBWDoUikv5EKD97J9uGI6UVLMyq48=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB6711.eurprd04.prod.outlook.com (2603:10a6:20b:f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Mon, 25 May
 2020 15:20:09 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::8576:ca02:4334:31a3]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::8576:ca02:4334:31a3%5]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 15:20:09 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] dpaa_eth: fix usage as DSA master, try 3
Thread-Topic: [PATCH] dpaa_eth: fix usage as DSA master, try 3
Thread-Index: AQHWMhGAr8g0ISdHBkaEMbU2v9u7Zqi45hqQ
Date:   Mon, 25 May 2020 15:20:09 +0000
Message-ID: <AM6PR04MB39762C1D25DF9A1788C39DC5ECB30@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20200524212251.3311546-1-olteanv@gmail.com>
In-Reply-To: <20200524212251.3311546-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [188.25.48.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea9a635e-0dda-4c18-0872-08d800bf1d09
x-ms-traffictypediagnostic: AM6PR04MB6711:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB6711E872AE46B39E477C8378ADB30@AM6PR04MB6711.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VtVWyA5YaHXkCn7fD9AZ7Iz2X3inHNgt6jCq7EJKARLpCVgtTVOJvdYwvUfEzWI/3oXvoc2qFT6O35YHMTR2VGO46NvPD0cOK2+ITq7Se2RPD/LoKrP2JXwlL/91jvxhNlYrRAlvexlyESxSGhW/Fn+YDD4ssjAYIkUqU+T2JUB1ZegmkAQtitFwoTk2F/puXjmEc7pXoTuJD9YQ49qTBgGl+OmD8fK9aKhz8Yve3cCslfK24QpmLCK1vMsRYjf9y+WGpaLOhh4+c1LKINoY4vsYck8KlUsD3Uc3/VxtyWpOSibHmVsnhaPdRCeqMPO5403Pb6RCBSpwffWISQPcvIY0GAC14o72z8XfM1F+nRSLZT3oF5/2NkGK2asxLPQdbVneGzkKQXbjJzKQpxe1oA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(2906002)(76116006)(66556008)(64756008)(66476007)(66446008)(66946007)(478600001)(966005)(55016002)(9686003)(52536014)(86362001)(4326008)(33656002)(110136005)(71200400001)(7696005)(316002)(54906003)(6506007)(53546011)(186003)(26005)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: p2IgEsO/Es6TmvgHV2B1vun7fOkFgDBnhzM7td4nm31N7GtrYG3TLj0jojLIikFRMqLoEHavtV+yYyost5hQvu1r2K9rnKWkJI8cTFIFzozORjbNhmQqiy2zAvvpBw4dPwsOQr5Dtnr4iBQgUaKzszIQuOIe4S9niunsxVRxjDx4WUMni+ZUugqxFG9BVSK0itXIubDYhrihW68oPPtHCpc0avobwdvfZELJ7BWnmsHgohf5IrhemyIhRPMZoeeU4BGhVQ9vVn8ael47trv5mfTTyNXZLR27gl1HiMjT7Zb382WZZyXIjAbZrFm/dpkO8z9Xbg8/sSrfPPwDaChtakn/0SjMxaNlXCQGrBeRMdgGqZ5FisLz0Z6Nfk7drWcerXLujhOZz1iU3NWB7RV5WJ4qgHXd5wjRPPzpquOCNLPfHP/bL5YeKqtl4ms0C/sVps4m+KUURur8waNak3fUvXDOLINiZ1KPu6aTDfcV3ls=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9a635e-0dda-4c18-0872-08d800bf1d09
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 15:20:09.7540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aawPvaiX+wdqSfDabZwuKlC441+kNh/Ti6D+UUZy3o8BgR4ZDWEUuS4OxY9k+TyNdAk6WXLNxXETcwLSyp50ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6711
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Monday, May 25, 2020 12:23 AM
> To: davem@davemloft.net
> Cc: andrew@lunn.ch; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; netdev@vger.kernel.org
> Subject: [PATCH] dpaa_eth: fix usage as DSA master, try 3
>=20
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> The dpaa-eth driver probes on compatible string for the MAC node, and
> the fman/mac.c driver allocates a dpaa-ethernet platform device that
> triggers the probing of the dpaa-eth net device driver.
>=20
> All of this is fine, but the problem is that the struct device of the
> dpaa_eth net_device is 2 parents away from the MAC which can be
> referenced via of_node. So of_find_net_device_by_node can't find it, and
> DSA switches won't be able to probe on top of FMan ports.
>=20
> It would be a bit silly to modify a core function
> (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> just for one driver. We're just 1 step away from implementing full
> recursion.

Changing a netdevice parent to satisfy this DSA assumption can be regarded =
as
being just as silly. How about changing the DSA assumption, not the generic
of_find_net_device_by_node API?

ACPI support is in the making for these platforms, is DSA going to work
with that?

> Actually there have already been at least 2 previous attempts to make
> this work:
> - Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> - One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
>   https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-
> git-send-email-madalin.bucur@nxp.com/
>   (I couldn't really figure out which one was supposed to solve the
>   problem and how).

The prior changes were made without access to a DSA setup. Has this patch b=
een
tested working on such a setup?

> Point being, it looks like this is still pretty much a problem today.
> On T1040, the /sys/class/net/eth0 symlink currently points to
>=20
> ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dp=
a
> a-ethernet.0/net/eth0
>=20
> which pretty much illustrates the problem. The closest of_node we've got
> is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
> which is what we'd like to be able to reference from DSA as host port.
>=20
> For of_find_net_device_by_node to find the eth0 port, we would need the
> parent of the eth0 net_device to not be the "dpaa-ethernet" platform
> device, but to point 1 level higher, aka the "fsl,fman-memac" node
> directly. The new sysfs path would look like this:
>=20
> ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/ne=
t
> /eth0
>=20
> And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
> net_device. The new parent has an of_node associated with it, and
> of_dev_node_match already checks for the of_node of the device or of its
> parent.
>=20
> Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> Fixes: c6e26ea8c893 ("dpaa_eth: change device used")

If this is picked up in stable trees, we may need to make sure some other
changes are there to keep things working, i.e. this one may matter:

commit 060ad66f97954fa93ad495542c8a4f1b6c45aa34
Author: Madalin Bucur <madalin.bucur@nxp.com>
Date:   Wed Oct 23 12:08:44 2019 +0300

    dpaa_eth: change DMA device

    The DPAA Ethernet driver is using the FMan MAC as the device for DMA
    mapping. This is not actually correct, as the real DMA device is the
    FMan port (the FMan Rx port for reception and the FMan Tx port for
    transmission). Changing the device used for DMA mapping to the Fman
    Rx and Tx port devices.

On each target code base one needs to review the impact.
Speaking of impact, does this change keep the existing udev rules functiona=
l?

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 2cd1f8efdfa3..6bfa7575af94 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2914,7 +2914,7 @@ static int dpaa_eth_probe(struct platform_device
> *pdev)
>  	}
>=20
>  	/* Do this here, so we can be verbose early */
> -	SET_NETDEV_DEV(net_dev, dev);
> +	SET_NETDEV_DEV(net_dev, dev->parent);
>  	dev_set_drvdata(dev, net_dev);
>=20
>  	priv =3D netdev_priv(net_dev);
> --
> 2.25.1

