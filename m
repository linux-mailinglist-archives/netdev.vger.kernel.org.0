Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBC1732A5
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 09:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgB1IRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 03:17:55 -0500
Received: from mail-eopbgr60111.outbound.protection.outlook.com ([40.107.6.111]:28222
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbgB1IRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 03:17:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCq9dW8QPcjkOdG/3f5wQajC2tw5WRrAdObHCNdYfHgvkSPm2KwcWoGzzg5LuibU6DPLh3LfUu2PjM1gOoU1SoIQY5MLBDk554prCJ61CmdjmIdOyBXDqR06GpUAPsscgvYWh3ntvNrixF+xOVAIsEGEsw8DyOE7ff2jhqPAUIYSEG/UpUaLTaB51nrweG5W3Sccd/5VWrwDBp7xgup1l0mq7XxYaRv0JQ/O/FcFDmJTRi/e9x6kOardA+g/vj5YVbLWC1ah8GUm2gGPS5lV49HOhPbuYGuTZaYNBZT/BPFasWe8DBgDb84Pz8D8Efjz3QEo1WcfvX46fyTgtY8NTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCjibclidZa0F62GTKgIT8JLv/a/nvd7rJkRBbAQs3k=;
 b=RBAJ5+arm3gymnNxI1/YsePQVq9aPdoQoNYKTd50u/pOEwlMgCYHWuT2U5AkYOYKzEMzvbRXBtPQepHLH9M49GJKpDATvA5KS6utrESbi/Pm4f9wDjvMHyoX2K58u+r9gsAwOGlKyDdT4wgKDzFW10uj1m7e1jmQi/3qKNAox51Qxj8e+pvW6ERVmd/MWnnmKK/L58gBeubNCDZ+b2ClyQ8xyxR1/U58jKct9gavOiHQyqzHFkg7BtQtqeeEqz4ckbV7LlW3Ls+l6U+hux+QVnrVbKHCVIzqxbK1xswmrf+jVs0vlNJAnn3AreHV2xyK0Ad5x4Z2YTvyPmjQBStV0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCjibclidZa0F62GTKgIT8JLv/a/nvd7rJkRBbAQs3k=;
 b=pPW0DIY6Z3y58dss9nua2Ogak+NOP6tvIHTiEStSqEtTS7csLS8QSWQubOvi577NKa4wZIV3IEq+5PLwITLh/qxAofP0z07PO4eb8gvFmTWgtg/pWbcu/gndPCMHzKR0Gw8sVCptdjZny86u6oYBMjRQ6CAU+arbBNNDzQHixxA=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0429.EURP190.PROD.OUTLOOK.COM (10.165.197.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Fri, 28 Feb 2020 08:17:50 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 08:17:50 +0000
Received: from plvision.eu (217.20.186.93) by AM5PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:203:69::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16 via Frontend Transport; Fri, 28 Feb 2020 08:17:49 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Topic: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Index: AQHV6/jzY7yqWky1LUqTk1e6REHYB6gwBU4AgABB3oA=
Date:   Fri, 28 Feb 2020 08:17:50 +0000
Message-ID: <20200228081747.GB17929@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <c7229424-5c99-7ea7-da82-ad47a8b7fc28@gmail.com>
In-Reply-To: <c7229424-5c99-7ea7-da82-ad47a8b7fc28@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:203:69::31) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36c08575-c54c-40fe-99a9-08d7bc26b35d
x-ms-traffictypediagnostic: VI1P190MB0429:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB04294CF883FBBCA146094CC895E80@VI1P190MB0429.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(136003)(376002)(346002)(366004)(396003)(199004)(189003)(52116002)(53546011)(2906002)(26005)(6916009)(508600001)(1076003)(8886007)(8676002)(71200400001)(316002)(54906003)(186003)(66946007)(33656002)(44832011)(16526019)(55016002)(107886003)(66476007)(81166006)(8936002)(81156014)(7696005)(5660300002)(86362001)(2616005)(66446008)(66556008)(64756008)(4326008)(36756003)(956004)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0429;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SxyCeluzUAG0ivOrbAuL3swmnjVjNVtUrL9TMCVcN9wbl5vulMibUP5mbTGJ50cRgvbEH6CkUxuDrvR4E12MfqmFU/JsIMO9/0OHL04ILPcIY82Q1jk//9eQKh0teaIW4etDWCdVI6d6TcFKjp5DXxjpSBqwjsRO6563wZwPRgsUeleTiGtMMU8tO3G+R+jvj4KbgsKoEDE+z2bxf0sQ3YV8tZJ1/qVTgsPV+Rasyko4A1yPnfyreSbez7XzzzGjC+RcORr4r4/yiM/WQnR8n7DQGpKVDgTcdBfhdYgyUZe8HzTghy1nz3XVwJ0M2uifrfQweh/Qz+RI4bMVvyu8Go8cL2t2jDMxgsGX6iMw7hQOY64bF0GVz7uDFEn2LPQor8iQVxFYWnW3i42S70IbalsDag+AlSoVhJVwgntI9Fvjh7rcUJSIyWwlPc7q3Fy7
x-ms-exchange-antispam-messagedata: QFgyjT1XqQ75REG6QxHeFSSd6K61fF2c/5NH2hq8lkPa/JUdKpKWNkjruf5UixherKP3y3dt5NukWEweD6AZS/Af41B7kUsbbRqeWe4SkagRo6l5VidxeQP9AzymxOokzLKVhlKzNiJK0eKTi446hg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52473B0367B2C943AB77CAF5352F8AE3@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c08575-c54c-40fe-99a9-08d7bc26b35d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 08:17:50.2008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4f7/iIPAlMJRHEUnRdp5czV2pKv+Zy6nUgosQXMPrBJIiE6nkWGDB79KZEoWnYeB59eOcXgW3rurc9plg/A0KydjyzxsO/WReWTlawRxQ9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0429
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Thu, Feb 27, 2020 at 08:22:02PM -0800, Florian Fainelli wrote:
>=20
>=20
> On 2/25/2020 8:30 AM, Vadym Kochan wrote:
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> >=20
> > This driver implementation includes only L1 & basic L2 support.
> >=20
> > The core Prestera switching logic is implemented in prestera.c, there i=
s
> > an intermediate hw layer between core logic and firmware. It is
> > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > related logic, in future there is a plan to support more devices with
> > different HW related configurations.
> >=20
> > The following Switchdev features are supported:
> >=20
> >     - VLAN-aware bridge offloading
> >     - VLAN-unaware bridge offloading
> >     - FDB offloading (learning, ageing)
> >     - Switchport configuration
> >=20
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> > Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
>=20
> Very little to pick on, the driver is nice and clean, great job!
>=20
> > ---
>=20
> [snip]
>=20
> > +#define PORT_STATS_CACHE_TIMEOUT_MS	(msecs_to_jiffies(1000))
> > +#define PORT_STATS_CNT	(sizeof(struct mvsw_pr_port_stats) / sizeof(u64=
))
>=20
> All entries in mvsw_pr_port_stats are u64 so you can use ARRAY_SIZE() her=
e.
>=20
> [snip]
>=20
> > +
> > +	err =3D register_netdev(net_dev);
> > +	if (err)
> > +		goto err_register_netdev;
> > +
> > +	list_add(&port->list, &sw->port_list);
>=20
> As soon as you publish the network device it can be used by notifiers,
> user-space etc, better do this as the last operation.
>=20
> [snip]
>=20
> > +int mvsw_pr_hw_port_stats_get(const struct mvsw_pr_port *port,
> > +			      struct mvsw_pr_port_stats *stats)
> > +{
> > +	struct mvsw_msg_port_stats_ret resp;
> > +	struct mvsw_msg_port_attr_cmd req =3D {
> > +		.attr =3D MVSW_MSG_PORT_ATTR_STATS,
> > +		.port =3D port->hw_id,
> > +		.dev =3D port->dev_id
> > +	};
> > +	u64 *hw_val =3D resp.stats;
> > +	int err;
> > +
> > +	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> > +			       &req, &resp);
> > +	if (err)
> > +		return err;
> > +
> > +	stats->good_octets_received =3D hw_val[MVSW_PORT_GOOD_OCTETS_RCV_CNT]=
;
>=20
> This seems error prone and not scaling really well, since all stats
> member are u64 and they are ordered in the same way as the response, is
> not a memcpy() sufficient here?
> --=20

The reason for this is that struct mvsw_pr_port_stats and struct
mvsw_msg_port_stats_ret has very different usage context, struct
mvsw_pr_port_stats might have different layout, like additional fields
which is needed for the higher layer, so I think it would be better to
fill it member by member which has related one received from the
firmware. So, what I mean is to avoid mixing data transfer objects with
the generic ones. I am totally agree that memcpy looks more simpler, but
it may bring bugs because the generic stats struct may be differ from the
one which is used for transmission.

> Florian

Regards,
Vadym Kochan
