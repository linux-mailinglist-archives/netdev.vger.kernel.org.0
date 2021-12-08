Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256AB46DAD1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbhLHSRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:17:08 -0500
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:33924
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231643AbhLHSRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 13:17:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qj0yJO7s/RrQ0aevJvDz94Qpl+yoEpTtXokaTWUABr9+G3oBeYEMt90cfafqJQQSr9Eh0ujbi/VUorVlNibGhrb0odQMIFCU6miFeb91CDILBwyee+/72xiK3cY0D/1u8AS/LOPFIFScVqRaj13590bJYjObhWjqeWxy9weVxMLzT4g6YAqp1cCXP9ZYkNeKOHyidP2/pp3aDAOCDHqm5p6vqzYnUooZJIyTpmnl5wb+VuMuBeBJLGxrljLXuLE/OoqKA9qLdFmUrAxhQ31RxWIhRqv5rMnt7fuyMbqQ+qNhLR9uwz7yZ/sejnNI67B/8TdEwNWPJlxN9wTfTrT8VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8cJ1s451wCYdgjq0481m61AIsp8P7FjK33vt5GTdJ8=;
 b=JOtS0TdyjGGFeb48wYopzqZ1ivT5sVX+YcmakBmHeS5XL11UYz1ikDYIUVo1crXWUeqBQxjTlICKIX74dhZ4WrtxeKFtZlxbY4ik+ApJnWXaVXKveaX+dKvgQurHZ0DuCMH2gHQ5SmR+QHTOH00r+AshejLiBoEG0pfg8o+6xNc/eZmyvr/prczHGT+HiOrycyYu1cEAmaqm4sq0snYObJVhiMk3WB4qMCe5Ma3lXbkm2fAWJ0ZFVRrIEMpWlxXHVNWBk1sNboGTz36Tos9a/O0KeNVBZ4sHE99INxUROJY7SzFvA97/zMDbY9z5/ZrZBwHq/kw2SeUjP+CcYHbKow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8cJ1s451wCYdgjq0481m61AIsp8P7FjK33vt5GTdJ8=;
 b=ZmlLNvE50+lNtLl4fpfqUK/R3Bw61tUzDVMa3OiY/BNAj73TzU9OUE1iE8lyzaOs2W7BxWmp9UQA7xFc663VyzfCz4UTgJi9XolerLAKVH0EAS/Pj7abJPAB9+xvBoNwNceeaX94uMshzudRerMKTTXFq2BWLYjBBWTpxL1iGv4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 18:13:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 18:13:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: felix: Fix memory leak in
 felix_setup_mmio_filtering
Thread-Topic: [PATCH] net: dsa: felix: Fix memory leak in
 felix_setup_mmio_filtering
Thread-Index: AQHX7F4qnyegL3pl/ECfN7gf9i1i1awo5eCA
Date:   Wed, 8 Dec 2021 18:13:32 +0000
Message-ID: <20211208181331.ptgtxg77yiz2zgb5@skbuf>
References: <20211208180509.32587-1-jose.exposito89@gmail.com>
In-Reply-To: <20211208180509.32587-1-jose.exposito89@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91cee374-0377-43bc-e682-08d9ba7671b5
x-ms-traffictypediagnostic: VI1PR04MB4224:EE_
x-microsoft-antispam-prvs: <VI1PR04MB4224DCC6D1AB231F01F0DCB1E06F9@VI1PR04MB4224.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vDvkKCjJ0tybEV2W9f9b28vS8egaMv+yGP7NgyX2bf9hS49DBA1af2iayUT4hTjlGwmfoFsKKrQRL9bdktjPhZ9Plo7nl4dSSB98DBRx6XrwnN4sI2XDZ+jESe1EiWLZd3TFYahIJsQgIcaXNx1mTmbJ+NZTufIU5Y3bkCE7MEr//I8LZ2NupGU9FaWgKDnPu15gDEDjx+tXk0q3wrvDmd2xN+jN62aZ330GX8xVT8gn/ivCMLGwAwBAwF0AppUoPTFptQEDrGVh339sJ1idMH38vt3Kooww1MbzlJt56SVE///P0L658Mkm/UIlw65RC+DinYWI0bfGz7Zel8lJ/MfFZQpznl9OZp044taLPks40S0bMc2TPrr+3Arn0bQ0BKO4eaguw2RLk4i4NFrhliXGWHgTBi4zOR7HcoSZSwZybgEdiKTfPUe+nN5yCB4d10HZz+TLJhjVo27Y6gTjnyuZY6kAATiHQU3Av6EhDZKBqLtJNSzx2anuL4/qvte00kaqdALHCmTPASIANMx60nUp7oReyrge22wZdB5GPe8qeXkEIOLNGfPlVx0MHqjec1xr49xAhr8bcnCWFrqT8Xez5dk5ciW18sHzegL96CVC9wbNSh13VUL38U19wjSpVhiaynPshsqvmq4AvXCmqagkgHxOlIqjiLx9jo7kmG1zFjHAPU+xcABiYfo470VwzzV41l8Xr6WRYrz1ZTo/UEa7bnZUFvniHhxG1N+nAqrBuj72/1VRT5hhLHF9JaRcl2PZF60A4bm7XIjDO/EbREmPzMPHBdC2QeyYFPHFOyU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(54906003)(316002)(76116006)(38070700005)(44832011)(508600001)(83380400001)(91956017)(7416002)(122000001)(38100700002)(66946007)(66574015)(66476007)(186003)(6916009)(5660300002)(66556008)(6506007)(4326008)(33716001)(66446008)(9686003)(6486002)(64756008)(71200400001)(86362001)(8676002)(8936002)(2906002)(1076003)(966005)(6512007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?aXIhUDh6KrwksJ/+53jFnYerL/KReHqYGU79SWZmQRMBbBFbpewmV6zWvN?=
 =?iso-8859-1?Q?Nt6jEU+3Loxan1a70dk2/2YBSMvhkPZ8X9FIgjpfwC0cZsUR0hSTf8fsDX?=
 =?iso-8859-1?Q?gsa5+CiGtskj8w3wNUtkYxZFwq084kRxOJhiH+lMd4auHQaq+MqSasU6n3?=
 =?iso-8859-1?Q?YOqRJfPTw/iPCxUyUSR8sFAb4zGIfVShoV6oRYSFh8l4toshe82dIJw2hw?=
 =?iso-8859-1?Q?xN7EsmYL77fGLkfO4DZWTV8MBTIHPmV75mP3sFO89jjV2qCjWJuRQSJc+b?=
 =?iso-8859-1?Q?UXv443KRkmiFqKEanqIY9m4wXxwR6DwRKxkVbUpwOGZf44PNVl3gYQO9Wh?=
 =?iso-8859-1?Q?NJZM0ETCj5B/aK3wHv9Lo469GNnuuWWhO3pimRf495K48dsmu8BXVOUmv7?=
 =?iso-8859-1?Q?SJnSgCbqE+jeSG7MVrNzHevp2BrQVZhYRtfpb7tT/7f556XoH1Zn3iv2IT?=
 =?iso-8859-1?Q?a50iPcTOhPXJvJWh0PfR/upFwRofETlnDnfE80fkT9tfdA4EZQyVmoV2tK?=
 =?iso-8859-1?Q?6+2u5uO2YTQiVQYEBAwoxgj54rxkWtsLabwgHmps2Ro0Kop7tyS7fJ0TOr?=
 =?iso-8859-1?Q?K7E0dHBaySK/hzfH5ZXemKWPmggywJU+TX8ZCCm2K2yjgLYPHhmfX7z+xV?=
 =?iso-8859-1?Q?MI3R/0JL1souSVRJjshw8yID37f4Cr5pfLB0By0MFOho2tbRlr2vesPF1j?=
 =?iso-8859-1?Q?Q0Vzbw1f8zrmTSlL7Pnu9XhD9082UNAw9z4JlK4MVrKlvDC+a/FYtBQTdf?=
 =?iso-8859-1?Q?zCoPacNY0lAbTs+kcungluL7aybxIMvn1igg4oG6k36OU9V+a6pO/bUlYy?=
 =?iso-8859-1?Q?kTeAAFWN9NbJqhghuL83wzmKHhJLF6FMRhGIqKvIKoNlbdfhfbhJOpSRNI?=
 =?iso-8859-1?Q?TThZaOVUpcx9nZoF9cnC6KO2TatNuAdgFqxjH1c5qPXJxe0lsJToPSOhxh?=
 =?iso-8859-1?Q?Z2FOvQdaWq/3N77ZuTYJr6A2OOfOiNNA/fIZGWZ8ZYG0mWbhZpsrFjs0gv?=
 =?iso-8859-1?Q?jmuYTFCUM+nGPKAjmTT4tMXja3v1DZOwUHZlnQSFrwnzYsFPekAsPo2n0/?=
 =?iso-8859-1?Q?08Mc66Pxir8+M7qIH0OmckS9zkUAZnY37v12iZ1F0FUByghFbwSyCuA9GA?=
 =?iso-8859-1?Q?X4xX582eMah1FCECjSBG/5yztLlHWc5E5nAjUPAjybahyK3bhMSvs6jbMZ?=
 =?iso-8859-1?Q?yDG2d3Cv0Rh9zD6+KBZ09S7mP+h/ENWsisftiT2SWqbWlIO4iLtItV2EIL?=
 =?iso-8859-1?Q?vsGeQV5IDuE+Qdf6fp+GMC6UrrvVo4RKRMjM+pcdNkYxeDgEs+9kbcD+wz?=
 =?iso-8859-1?Q?KJFUSnlSs2cjkBM+QS6uKUz4shMMqFalvjER1TzpUrQ4KYMCuILu4N6Hzz?=
 =?iso-8859-1?Q?sPen5fwYxkAvZALCXSHYnY9WQX577xzOxrHAefqrHKY4aghBHfyZZ3Jk0+?=
 =?iso-8859-1?Q?AOMte6VvxvdhlmtBYw5xU0cEmp7u0Ht7XOTpzQM9SpBaAwgfvE38OEWgxF?=
 =?iso-8859-1?Q?8PMEyp9viSBeg2NxfBOnm3/dgpIefdJvkf6g2G08Ge8uWYVOOYnGa09wqr?=
 =?iso-8859-1?Q?Xvr89qJKg77TQRjtBZjBm35Ku39InS5yr56dbGTLclyiJRDUUrBkUq+Yry?=
 =?iso-8859-1?Q?DiaF0SBS5k+G9dNB0dSArsh8Sl59SS4p+pGMXgEJfAgb1rEDoirHoqz6J2?=
 =?iso-8859-1?Q?nJMpnFc+0wMKXHUMo0M=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5497136E15ABA4419CCA8F8D0A85ACCD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cee374-0377-43bc-e682-08d9ba7671b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 18:13:32.5039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0hMOBGU+zoyVns1YjF5MlsPeypfi14Y4fWXJ5SRgYgs4hVBFwQ9iYSsjFzJz40HVBoI9dGhnyaVMGZvJKDEkRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 07:05:09PM +0100, Jos=E9 Exp=F3sito wrote:
> Addresses-Coverity-ID: 1492897 ("Resource leak")
> Addresses-Coverity-ID: 1492899 ("Resource leak")
> Signed-off-by: Jos=E9 Exp=F3sito <jose.exposito89@gmail.com>
> ---

Impossible memory leak, I might add, because DSA will error out much
soon if there isn't any CPU port defined:
https://elixir.bootlin.com/linux/v5.15.7/source/net/dsa/dsa2.c#L374
I don't think I should have added the "if (cpu < 0)" check at all, but
then it would have raised other flags, about BIT(negative number) or
things like that. I don't know what's the best way to deal with this?

Anyway, in case we find no better alternative:

Fixes: 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during init =
and teardown")
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/ocelot/felix.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index 327cc4654806..f1a05e7dc818 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -290,8 +290,11 @@ static int felix_setup_mmio_filtering(struct felix *=
felix)
>  		}
>  	}
> =20
> -	if (cpu < 0)
> +	if (cpu < 0) {
> +		kfree(tagging_rule);
> +		kfree(redirect_rule);
>  		return -EINVAL;
> +	}
> =20
>  	tagging_rule->key_type =3D OCELOT_VCAP_KEY_ETYPE;
>  	*(__be16 *)tagging_rule->key.etype.etype.value =3D htons(ETH_P_1588);
> --=20
> 2.25.1
>=
