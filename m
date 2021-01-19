Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA682FB8D8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406028AbhASNtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:11 -0500
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:24965
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391028AbhASKwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 05:52:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BP7V2wD8fvQsiWO8qMdbVau6sAmA/KD0awGh5l1jU4GkUJ2zq5kscu1GJq2LnHnJKAEckoXuYkmKsZI1R4x2YKzdammwHXrbXX+zrZECX7BF+gYSkWfuR3NS3hgvVsdej2DUFIwAI6qfaWzSTaf8R5/sd4dXd2bp4eLVFyDV/OWAWVgPkkBvFgPokGQ/+LiXNjegb6xX+ibtZbfhtjaitix38NPJdSX2IjLuiVPRiqj4VpSitREfDWMadgAVYgmrJV5/Emt3wkV9Dvy8XmBtiCym2PV4coJrjqsxLjx7qg+aLJgprEk8NzaeXswt5L96fgFKMC8PEfecsQILxhy3GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oalw7dDrrDQTN4FuxtUUgN/2ZiHH1PawkpfjHQiIcCU=;
 b=aL78bubPE37OK9hKbAirHZKQy3eAD6iZTmmXA55oK7iGbUN+HRLGhijyID1G9WOf7g2pb3Sr4llVmUIaFfyEU3ndoRg78ssQ/h393rCe+E4vZcHR372y76TWTthZ1q6RYfIfNYB+NNKUXY+8iHHTqwfezzsh5oAKoG04LynCyMVjGh40M2eA4+v5fJJI8dbm6B+riKZfiSb8hT7d6Qrv05esTRQpR9pnfV6FkKMlNc9X3yQAnB3SaBf5lXQbcXdkxRUrVIqMmCdvD5Z4fCJ6vJPEdkRCoe6bKptTNUsv6ccjXehMnoaylXm6Y/MoCrEjOA2EI+wSCobxfXoLt3/IfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oalw7dDrrDQTN4FuxtUUgN/2ZiHH1PawkpfjHQiIcCU=;
 b=FG0r8L+Mhnjk/A9UA08s3z0tdB+fVXt8bmpDvUo86ijFxfOApMVC1GgC9HAJFRQU74gd99kj9C1Z8nJ4EGQ9uXpdhBu/361CXT+ouKFz0lDnduvdJSx9v/WSqBfZ2StZYVf+lJR0eiDw54FyclOT9KFdrdKfTIAmDVn2LFzuLcw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 10:51:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57%5]) with mapi id 15.20.3763.013; Tue, 19 Jan 2021
 10:51:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Bedel, Alban" <alban.bedel@aerq.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Topic: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Index: AQHW7bOA9fYvcfmYzUChcnWV1prsRqotu3KAgAEAXACAAArYgA==
Date:   Tue, 19 Jan 2021 10:51:23 +0000
Message-ID: <20210119105123.b3emeo22ykwyrot7@skbuf>
References: <20210118160317.554018-1-alban.bedel@aerq.com>
 <20210118185501.6wejo4xwb2lidicm@skbuf>
 <2cb97bec861c751530a04a9764b8855c8e8e2e41.camel@aerq.com>
In-Reply-To: <2cb97bec861c751530a04a9764b8855c8e8e2e41.camel@aerq.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: aerq.com; dkim=none (message not signed)
 header.d=none;aerq.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9ba1c36d-67ff-4c5a-80f9-08d8bc682a12
x-ms-traffictypediagnostic: VI1PR04MB7119:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB711972AC80EC3D1D536CBEE9E0A30@VI1PR04MB7119.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cm8Qq8KzV6dZSAM6pptYMMs3tFNWz9sFmKgxpgFcVYfQi8hT1HHpfc8xKNipJPm8I0qkbrilKTo58r2RCNPiyhQKeA9XpT506o2sU3l2Q3HwFVbE6k+Lmv0QHXq1ei3KM7xINvDdjLmG0mhqO+KtKpfeE/VLy+wO+T1ckpqxGOYyau6bNC4q/B0vRM3aYhMm2C5g4tOZEWJfEUu+hRliv9y1d7a2nj1jMNuW3FpZlsZ03GkY+sSWJIq+KdM/yZIzqI3pygiPnPNdPU1/G0MyWIDeqZb1han3/hZ5putDpXc1EAbMiF5f9XdMBZJKMvJT35T32mLKHOqBNfqlxy9/LDp5d5ME5F2WvzF8ciY5QQvnla1sWqUIuKw/W8efy+f5EaxQ7Xo/1XFTllUZpjkTNa44LtBeA+8hHngsbtVbZCbM6xffJjsmrvBMusSrT+hsGtteExNwHUNlHzhcBOi9Kn6jNCc39MCyhTEDGf40Rth3gvZEDXMN6r45V4oal+eFaI49IiaJ6+7Dmfqtj/kST7LcUhAvToJ9MT11w+2RbQg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(396003)(136003)(346002)(366004)(39850400004)(966005)(186003)(6486002)(8676002)(9686003)(2906002)(6512007)(86362001)(44832011)(26005)(6916009)(316002)(4326008)(66446008)(66556008)(54906003)(5660300002)(71200400001)(64756008)(33716001)(1076003)(4744005)(8936002)(66946007)(6506007)(66476007)(478600001)(76116006)(473944003)(414714003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?86slCKqcxrKIsvcie38Z+xAU/e4SVAW3r7XeDvuWV6nTDNgjGN6zvEbUNKZt?=
 =?us-ascii?Q?5xNje3cVknDaWVHvmtSVcrjwIWvJ37fiqLGyDiXllTfprJloGcVKpNQOMjfA?=
 =?us-ascii?Q?cphZqpRnVr470/wtEt/EW27eqiyZctr7gt6w9bZEBxDgfA6xAbF/Kf2noP2d?=
 =?us-ascii?Q?sYD7wTq9insG8WmR9cAScYuVjzzAqzF1aYX+qV8V+O4Zji79G6/Spbt6Y682?=
 =?us-ascii?Q?NoV4AAWgCWhOwbihbEJznvbACMyAPTv1tctkXmEcpRoEj3wQWvwJ7znXrc3w?=
 =?us-ascii?Q?+a9t1MbEBxSkx1VgL6duDwiE+SgB4mpu8WE7TTexuLvKn38mnvBcCIUst3ne?=
 =?us-ascii?Q?nmu0SsnZycEQQekGkvGzHc9TNDYTnfm77/WMZmvNR2y17VK4G2CNY++jG5TI?=
 =?us-ascii?Q?4dNMUH+kAa7gorEVklfKwqxiWAGK2kgGQHdOJ8UVETGiy/30WrdFEtR9BCDJ?=
 =?us-ascii?Q?CSBmzWOTRTawgukQjjTFNnJ2/4iW+Ps7T+ZT8wlZzwgkJAwpDjGbVZ4xR39J?=
 =?us-ascii?Q?0wBS8K8h3skWl04jE+xYJd8jGvdgX19Q8fJLOwLaNGCR9REC+4dWca8NRLCv?=
 =?us-ascii?Q?D/3/9lPpaIbryjZpzGBzDPZlMMwhJ42D28rZ37DpGTs7L3ZDvMv7XK6jhtCc?=
 =?us-ascii?Q?SqcrtIqmI523CP8fDaMbvqc/VG6diEOCl0vvL5kCgdDlvwx2J8iyN0Qz5o7S?=
 =?us-ascii?Q?KotGkw8SYckjuoO5eGn90HhOqmlps6+D34Yd8SUDQUOS9H6FzO+xP2Qtd99q?=
 =?us-ascii?Q?LFBAIjQH5BSFLwIlMGkhgPNXwDSHbqR96MsHNPXsx51CVtHynmiCPWKF/TZo?=
 =?us-ascii?Q?I2VLTVUydIg+R/zf4KMZ33os+WYb7xDuDNjjhJRG8EXatbjpT6PkDmdjkyxe?=
 =?us-ascii?Q?u51achGuEnVZGpKuU/dQrmJ/awqLwmDrzPATl99Z6Wm/xry3A7rob+XfqXqj?=
 =?us-ascii?Q?l6epQBLDw5HnmKr7lTWhMS3HVHjnsghkAfv4ssl9GoWTW5kxBzPZ1DLOQxDM?=
 =?us-ascii?Q?xC79?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1E26FB724BF984DACFEA15965D8B1E0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba1c36d-67ff-4c5a-80f9-08d8bc682a12
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 10:51:24.0382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CRsB+S9XGdHDSD8xb+ZQXfnfxg69Os9vhb60NQ4eZUea1DquXKMAhc72mwmB6pJoWMvTKI9BLgYZUa/H33S4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 10:12:34AM +0000, Bedel, Alban wrote:
> My board use felix and I build without CONFIG_MSCC_OCELOT_SWITCH so I
> missed these, my bad.

Ah, ok, this makes sense. It happens to me too to forget to build with
CONFIG_MSCC_OCELOT_SWITCH enabled, more often than I'd like to admit.

> I must say that this condescending tone is a real turn off.

English is not my first language, it probably sounds harsher than it is
when translated ;)

So could you please resend a patch which:
- has a Fixes: tag with 12 characters in the sha1sum
- compiles with CONFIG_MSCC_OCELOT_SWITCH
- has a --subject-prefix of "PATCH v2 net"
- can be cherry-picked on linux-5.10.y and linux-5.9.y from
  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/,
  but also to the net tree, which is where the patch will first be
  applied:
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git=
