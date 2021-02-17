Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DADD31D783
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhBQKZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:25:40 -0500
Received: from mail-eopbgr50044.outbound.protection.outlook.com ([40.107.5.44]:17466
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232271AbhBQKZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:25:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcz0XFFFpWilZEUlAGyN7Wxi2Mft7Z+IaM+P8ACaxfGG80LAq1Q61ZzlzCytDB+AH2m/USyaWDJxprhkY3xSc3I83t88B3lpBgLpvFnYBLydhUATfOHF84AuZBeMpv9GDGgsYYhIHb6qJZOlNbj2qfy32vNtF9/GYkP8NP12F8HKy+cpxUiAZiZ8/gIm0UtPHin2E/f/WYxfC4lmJKVOuAJwdvbofmuNEiD4pnznd0lW86f2lopmZ93Z5BlHHNOMwmAjgMh9jcnEo9RQIEChFw+8oF2KHNskArl0LetoPkpDKWxAN7Ir31/o5EcF/ZeVPsU+pLzJLWm4M+YRXjJ+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06lku1VLDwnTxzqqiCIOKPjsSlw8LNx4PZpLXgBnDNA=;
 b=So6NoJZ7n9y3JpHW23wRE9eZ6x8dE1uhvQlvhPvnkGCYCqDbzAS0wupJNBrEzJ+vfsv00rb0wJDfLawOvudAtZtqrEKOx+JbAUoL2fKse//R+U4l8kSG1y1GbUWCVkuyDjn2BNOic6esrd3Zx0kXr3LU+ZXJ/DHWIdLcuMD+FHYK0rdH735PJHoJR1den0wYet9oBz5Ceyup4CtnzEdsTtxiA7ZuWJGsXBh3hicqDjwEvIB4dUu+cs1y+qBX4rXqNix7u+r/ajFW8pMvWY88ZVpMw2Wfm5V8zt+VhGWXQAMnbDZ1inWzyvQR77wULW9j3kvZsF3TlEHpNSfDJrEq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06lku1VLDwnTxzqqiCIOKPjsSlw8LNx4PZpLXgBnDNA=;
 b=b8VrmMZyN3Ug5QiORMn/5PjAVWorevHWZITfTlWhbtzdxA4F/bwlDn0eOFzX0TwCzLmwdU4Cx+DDyRHQhaeOnZPSHj9T0LT/MZsk7jUIJxymghfKb0CtgZLj9X+jSpH/AFS6rP43amU2rWJQy+J6HSsFrHAUYKG7NVPYCmGKuew=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3840.eurprd04.prod.outlook.com (2603:10a6:803:22::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 10:24:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 10:24:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 8/8] net: dsa: felix: Add support for MRP
Thread-Topic: [PATCH net-next v4 8/8] net: dsa: felix: Add support for MRP
Thread-Index: AQHXBKz5ZzKIO5ZEJEypEz7YovKTZ6pcJOIA
Date:   Wed, 17 Feb 2021 10:24:49 +0000
Message-ID: <20210217102448.oea5dwl2qnhybir3@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-9-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-9-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d8a6b937-2861-46ae-e039-08d8d32e4175
x-ms-traffictypediagnostic: VI1PR0402MB3840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3840CD79568E4695AAFFF4EAE0869@VI1PR0402MB3840.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1mHc+V+WzPlTxNnOCag7wl7crjSpLgYHQfn5vEykJ4a9ssS18jAmEJP3/X9MkA5UnbNppTyNXwj2qDy7zlAy6w5TpsfINGxyWO5KMnT3xKkfnx8ptZeS95C/TNSZF3uKcz+sv6m1MfRO9IX6T6nIaWM5FBbVvvGb++tMKk/cc37m21BrFgBg5ev6pJzynFk5TfuIGiCcjDWrBvzbZZEKU0PQ7kU8bpBQAJo8hdleeZ+Kbwt47IhaP+K2VK4HSfgRaKqgeNvoPl0VYfrF7YakiE14+siMSzasKVJT1tKxI+ak8D5zBbrmvBKku0BHjz9RbGKWsqNzLvXO2Kz9T+Pyl72MyoiDuIO/e1FIl9bjIfsn2yd5S4vukK1P4wNB2cKJiKWjwxgZ3OjcDGb/9vkTrP3KH/L6YhJW/d9p/FnKjtkNMub/IcKzaOcNIq1wp/oQZacyrxSw4nYWVOUTzBH4oCBf2Dr3KoW6oImZe/awwdVEh+hHNV+CAAueT3i0/YYZbd5gzGJgT8WE1N5iU4Psw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(76116006)(91956017)(66946007)(8936002)(66446008)(2906002)(33716001)(66556008)(5660300002)(71200400001)(54906003)(1076003)(44832011)(64756008)(8676002)(4326008)(6486002)(316002)(6512007)(9686003)(86362001)(6506007)(26005)(478600001)(7416002)(83380400001)(186003)(66476007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DX/foU/DoNGl+3QIhh7Q9q/VLs/atON3Is1Rf5ZevQrgbgj4cX0RRm35D8Hs?=
 =?us-ascii?Q?KeBV9z3zOCA1O/bHPtKJD/fV83NfU7wR0bCk9g3u10jctYKmz4qJqSPJbbKO?=
 =?us-ascii?Q?DLE0klQCqqqEaUGn+KwZRGo/j6kSilxYrQ2dZAqdsqmqIL6Htypia2aqRbEE?=
 =?us-ascii?Q?2GKCQcitxfrA+GRCZPud9+SMQDH4d39hLP+3W8uHPrkHzYp7qLDlV0YWowJc?=
 =?us-ascii?Q?G9jVTp4noxxNMwX7++p93B4PDIwIz9HrkRH0ODt/KWOec5sXqjC5M/HwM0Cs?=
 =?us-ascii?Q?yQjkIuFVG2YjuKEsLOH7CfiL5WF/MtAHXlFHl2UvdFpCIHKVFC3ph+w2uSiI?=
 =?us-ascii?Q?eLyuHFfkbBYLmKVMISx4JQBfzmelfE28y0BWHCwBWrEK8uY2XzSaFvl2jfif?=
 =?us-ascii?Q?a8/EVY0bb3ApT87Cw1a6ekRvKHj/c/ut9T287Q2jOFF1R9Q+0ZYbhN1OcaxR?=
 =?us-ascii?Q?Ag/oKH4VVjziC5LAFd3g/eJP91FLto2CugmUdmYs8N8G+HyAJBMFjMO+hjIH?=
 =?us-ascii?Q?QiOOaf25o9R1zi0KwRJlygMzzxTC2kk7+q3NU0NRUjSgxrkTVjEkEwjsuX6j?=
 =?us-ascii?Q?zlXrhgaFPnn2mvvAfIgXtfvwoFRITu+wK0cXZV+flPR0/fgIVyFkxQjAKfPf?=
 =?us-ascii?Q?CVfTmm3pKcv3WyIKxLW1cVewXftZyZtlcFC7Hi3a+BpT+3y2PmtNLtkqOFfU?=
 =?us-ascii?Q?s1zPeB2LFb+ZGMAVa3hIYvmjh8KwVJC0fQXzbJpNQuxACy7CjsTZSYagXbSk?=
 =?us-ascii?Q?6WC2fPidFP8ZY4L8V803I6r03zJ1my4Lg8AWIckj0lCXAxt4dSv27BoULqkr?=
 =?us-ascii?Q?uZ0s5VKUCfLHseirV6iigcIzDmj10kqqxNIDNCrk8UoWeMoie6i8SGCkGMUy?=
 =?us-ascii?Q?WGLMlrpTNCB3GGwEaZNY1rLPWCWIl4iajTehkED882j3vclIP08gDv/36g2O?=
 =?us-ascii?Q?t/AadSWYhyyAyUGqmUEMLRJduaQrMc9iIiZpt6uesV+v9BC4NN2XFWOOhvg6?=
 =?us-ascii?Q?4BiL63Rmj+bGqVQ8YPgZHBNzfwzzw47Cto4UZdpd+nVDAmamVBBkvwVEfSU6?=
 =?us-ascii?Q?9SBZNS79pgWvLDYdxbp+HqVmW3MHBXCWjR+z2PvMa5AQwEP64AZZpeosqttk?=
 =?us-ascii?Q?zTS3t86/k86WXmKoB0+iZvLzFbKZZvhY+/hpz0HL+UXNMfIURqCAzIvi6Vz7?=
 =?us-ascii?Q?xiomBp8fdtdZZCcNZzPNKouAEi5ijBe0gj4nyWY/m7aKcM9nGyOfooKqPmUF?=
 =?us-ascii?Q?lyScf0F5KMnw7Y7eXIBhXTLiPuin9pDm9KdbD0YhmERTRzchZ+96lTrEXYH+?=
 =?us-ascii?Q?JkosDwv7mmVgmmfyBh5YWkIG?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A48D8AA98F35B34D9F68B6F85E2DB033@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a6b937-2861-46ae-e039-08d8d32e4175
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 10:24:49.2566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ryQPKuXWOhJM/mHlmc28amIHHmm0AOPdGeYTdE6nDE3tRPzGcE8kV2of0daEp+vgFVhOjGx79Mb23yEOUSkrsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:42:05PM +0100, Horatiu Vultur wrote:
> @@ -112,6 +113,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb=
,
>  	ocelot_xfh_get_qos_class(extraction, &qos_class);
>  	ocelot_xfh_get_tag_type(extraction, &tag_type);
>  	ocelot_xfh_get_vlan_tci(extraction, &vlan_tci);
> +	ocelot_xfh_get_cpuq(extraction, &cpuq);
> =20
>  	skb->dev =3D dsa_master_find_slave(netdev, 0, src_port);
>  	if (!skb->dev)
> @@ -126,6 +128,12 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *sk=
b,
>  	skb->offload_fwd_mark =3D 1;
>  	skb->priority =3D qos_class;
> =20
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	if (eth_hdr(skb)->h_proto =3D=3D cpu_to_be16(ETH_P_MRP) &&
> +	    cpuq & BIT(OCELOT_MRP_CPUQ))

Checking the EtherType seems redundant, since those are the only frames
trapped to the MRP CPU queue.

Also, the cpuq variable is potentially unused when CONFIG_BRIDGE_MRP is
unset. I'm concerned that static analysis people may come in and try to
fix it up with even more ifdeffery, which is definitely not what I would
like to go for.

How about just the following, which is not conditionally compiled:
	if (!(cpuq & BIT(OCELOT_MRP_CPUQ)))
		skb->offload_fwd_mark =3D 1;

> +		skb->offload_fwd_mark =3D 0;
> +#endif
> +
>  	/* Ocelot switches copy frames unmodified to the CPU. However, it is
>  	 * possible for the user to request a VLAN modification through
>  	 * VCAP_IS1_ACT_VID_REPLACE_ENA. In this case, what will happen is that
> --=20
> 2.27.0
> =
