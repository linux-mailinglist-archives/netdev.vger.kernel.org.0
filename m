Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E552718A5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 01:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgITXpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 19:45:44 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:41931
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgITXpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 19:45:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr+3oYVyAuotxbmB/NJ872YWpsHubPyT3d3rbC/ORamMzXOhxzVbH1jj7I2MA0A/nthIwPxQwcRQlKJqo7Zz5Z199D9cuEYS4xN7kLL4cq+CWWe8HI+lOICjxctGVFaHP1J36JUE0pH9dlaw9KWCWTCkGO8Fs7bLy5WSt8a/0FNTsuVXKd/3xj8OOI9ZH/rThZk5+ZwKJqi/ONrH1U/LQBrGQ+LyONQybwdqeeLzYyhEE+y9MSgXY2AEtfUTCMdG2iGrmw/8YHzlFbnpZ99ITnu8idEQXhPgQUO60/QeBYA/dOSpWuyo3nTTEqhlktHIKZurnZyW9s3r/lQvD6Rikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJdpuNbNKbObZs6irb2bmpsxRylUp0WX7Ep016YR5WY=;
 b=I/ZA/moGCG4ItASXbaxM0S4OqJj5sNtpHA4M7RIIRNx6HvUDhb9NcYX0M31r5Vu0F2+OhG30k6grk5a35Oqrl3fGNreJskYCFy8Vx7SbGnNWNvPmrTj+fGQYkNj2dduGFKWBn4OUIEcbjcfxH93xSLftHsQAYRrwPTnAKl9YZ+kGdh8FL51xKx/TvkyiQBktTDQL+6vfITZi3fI80UriKdqT/pS75zF84QDGjxmwgfv+frumKG56cW5fxZcBfXfYZIrX4pQXl++lDQeCcIKJQP8Usu68ouqPtJbgzGrvi6CMTW0W+Jy8OimIgLzUlwPlq+aTe41SM4IKAR2cu9W6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJdpuNbNKbObZs6irb2bmpsxRylUp0WX7Ep016YR5WY=;
 b=BwLcQZW19vRpNuFId/Hu58cTYmxE9N3vz+sxcaYbdYccQ+RfLJBloLcebnfsUO8HN5Q1gjU6AGu5Q8RLMm/0lNDFkfe9DPRBHLPn9F+67oQLiHK7oGkI6NYkj5gSB01cdq/l2eqpQTQTT4qZazcfMPynsQbXT7z9f40LMmOguKE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3838.eurprd04.prod.outlook.com (2603:10a6:803:20::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Sun, 20 Sep
 2020 23:45:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 23:45:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Thread-Topic: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Thread-Index: AQHWjpNTDn/QEBX8Hk+qVrvSi0xeHqlyMyOA
Date:   Sun, 20 Sep 2020 23:45:39 +0000
Message-ID: <20200920234539.ayzonwdptqp27zgl@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-2-andrew@lunn.ch>
In-Reply-To: <20200919144332.3665538-2-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f279df9e-b26d-4c1a-bf3b-08d85dbf47ab
x-ms-traffictypediagnostic: VI1PR0402MB3838:
x-microsoft-antispam-prvs: <VI1PR0402MB38385B4356C00747960B39B7E03D0@VI1PR0402MB3838.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZQCuClKLLHvEXGe/nZSwXvZ9T8BZcSRIqAc2E/NhCaVpNX92U1IDpn8Eb7oKUM4E75MTMVDrJ1W1pLQIbb1fSgAgEHRBiCGG7oXJxGPyAWuB9Tj/reh+MKaS3fNIS4NoFiaKRgCTjrI0pbZ+KApMHleBDZzNi3rCjBM/I/DXLVN4+KmqR14B40WrrnMnA3gR1qDv6zT9FW5y0Mq4FXa9v30le/ESnsbLvH0RkjnLYYgxXlNVmocoRt9/8pzlgPgx2YXbHl8BczNp5LY6pXuj86134Lm55/6Kf7JDpXhGKMu6uLp+BF5bUx3/Tj+i2qgRtGVZNUJRS+jlAeeUdjF0Gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(136003)(346002)(376002)(39860400002)(396003)(83380400001)(66446008)(6512007)(71200400001)(8936002)(86362001)(66946007)(76116006)(64756008)(9686003)(66476007)(66556008)(4326008)(5660300002)(8676002)(2906002)(6506007)(6486002)(44832011)(186003)(26005)(33716001)(1076003)(478600001)(54906003)(316002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9Bqd2ECI/Bw3AG95JzSouJN1b3bin0K/Hl2RKMVyxXWmXa41dXt1TNiG8Dhkg1vxCHyPiU+/l5Fgn2nvsu/Hxn8y26dCC6Kmjro/IeG7kaGBBY4udgk8DT+8n+2r4BUVF8EAlyag8v95FleiVqwkJUb5Adk7G8mcXcRAEoaxooOMgnqk6nNTOkjCJMsAvxwQKJNoVFLL+BTskJwA5LbcProPwVsxufl+4F11dMgfOew6uwebx3cQnfYocRNPvOgNO0zM93rbfEJNzmZc97Neafe/uMwfLHh/eOFK0gw5pQszDAliMMzlv9RDRHhsI7qSGKnmmp/eU/8RGkDzL3/9U0W4WGqht3w+XqVoj8ioQYJrdullf9cc2/BNLNKWo3gExiW1UnhySJc4JHyxvqX44ogD02j+O7dAOgB+vmnv/DOndMvCa64UyI2isF38b+VZ0sxbXv5j9/qbJmmtspsPbFeubzJ4WdYVN50R2meWQuTM97SnQ/mKQ/MZ4/sdMTl9AbTmhGbDbU5SX/8DJfMbl1+gGkYJom3alooJh+hb13VpazUBq7Opityw2oN6dN0A0oLBBo2KeiOeFq5f3Zq+zQbK+em49vMjV3FyejkqiiW68U/DyakogrG/wxjwp9OzQwExMJA7uPHC6lbV1NBLmQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4DC1E43A659104D81A65395C8107783@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f279df9e-b26d-4c1a-bf3b-08d85dbf47ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2020 23:45:39.5219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpdA9rAiVr0ZgPSkMcMIltl0Te3eWNNzEkhxzA6hOFFrWoaWwfOh2Ltp7mShuVUx/hYENo6IBz7kO0xO0aqSvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 04:43:29PM +0200, Andrew Lunn wrote:
> Allow regions to be registered to a devlink port. The same netlink API
> is used, but the port index is provided to indicate when a region is a
> port region as opposed to a device region.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/devlink.h |  27 +++++
>  net/core/devlink.c    | 251 +++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 252 insertions(+), 26 deletions(-)
>=20
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 045468390480..66469cdcdc1e 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4198,16 +4225,30 @@ static int devlink_nl_cmd_region_get_doit(struct =
sk_buff *skb,
>  					  struct genl_info *info)
>  {
>  	struct devlink *devlink =3D info->user_ptr[0];
> +	struct devlink_port *port =3D NULL;
>  	struct devlink_region *region;
>  	const char *region_name;
>  	struct sk_buff *msg;
> +	unsigned int index;
>  	int err;
> =20
>  	if (!info->attrs[DEVLINK_ATTR_REGION_NAME])
>  		return -EINVAL;
> =20
> +	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
> +		index =3D nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
> +
> +		port =3D devlink_port_get_by_index(devlink, index);
> +		if (!port)
> +			return -ENODEV;
> +	}
> +
>  	region_name =3D nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
> -	region =3D devlink_region_get_by_name(devlink, region_name);
> +	if (port)
> +		region =3D devlink_port_region_get_by_name(port, region_name);
> +	else
> +		region =3D devlink_region_get_by_name(devlink, region_name);
> +

This looks like a simple enough solution, but am I right that old
kernels, which ignore this new DEVLINK_ATTR_PORT_INDEX netlink
attribute, will consequently interpret any devlink command for a port as
being for a global region? Sure, in the end, that kernel will probably
fail anyway, due to the region name mismatch. And at the moment there
isn't any driver that registers a global and a port region with the same
name. But when that will happen, the user space tools of the future will
trigger incorrect behavior into the kernel of today, instead of it
reporting an unsupported operation as it should. Or am I
misunderstanding?

>  	if (!region)
>  		return -EINVAL;
> =20

Thanks,
-Vladimir=
