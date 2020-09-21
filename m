Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A1B2731A6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgIUSMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:12:21 -0400
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:47019
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727360AbgIUSMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 14:12:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSETDQ3Sb12B96irfyOhzNliQUjeIcWULYcPwCpo1WOhLaiNvmya//q97VPMu83D5Jf+u6b9Bk5t859wXsNMEaCmH0keilp+UM6CXlkCL+40uRVDPQ/zVw0FnIY0OucgPn/Y+iIIYD+i1PH6tkvQy/0cCl3mK6Cwez8jW4VmzpDGnhBu/XQNIvxY5PIgVcpeqnubKBzq5Ri7oLOMUPm0Z8EZwN8r0H+/+K6nyOnJkun4rTeMsAxE06eMuuGcN8ZNxfMT8+Y1Td2rFKWYI5mvNuPDwm1q1mW7CzmEoALzlp+q6CaVly3LOds0j/7yLeusLoE57XYzegcWkhTqrcg4uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+jKZTuo6n8K5SEEqQPTEhSgXyKbpPCAZw9YJSobnkY=;
 b=L2IHYFWZ0Oa8Hs/WpfO4qiydaTr6fdFbof6DGUYqUZnfyE6RVW2jDK7jcVSiELC6H02F/GnqawyXqsLxmfr0XV4Ebj/gz/ZVMLc2X3Y/i6UK/43Py5eWhhFvveePvKGAPvQ18XY70Yx8xSy1LaISFwamtotRT+PNeatLhBtNYQB2fL6gWX6iGEe/mOetGO7PV08ph22C/SueAmTGYEs5obtIUVD+a6XP8gRznHw50iG45NxITkYpJbO9Bg6UfEy+KKYBH3OC7rls9WW8A6QdyMlLclY2wTtL7QYxmwxilWZAoq6kQjAjMl7Vz6GcCIDt4JrZlCF+rH9ZbnHkNevtyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+jKZTuo6n8K5SEEqQPTEhSgXyKbpPCAZw9YJSobnkY=;
 b=rl8fWuzp9PkLL4zS3mzyvrZEBThi0aCQpaAfGxzusU/m1e4USMkkpT95zsEt2BAUzV+Deqab+aYPvz8976IzlRfMGMUexUIklt6QgwAhV/jt4WG+fHhzJub03/1Dk1L87VTALL1JJawcrF5f/h7a9avCA4jo4k71QUYHOZhIJrY=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 18:12:19 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 18:12:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Thread-Topic: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Thread-Index: AQHWkDQ9QATQ1ChqX0Swkc7eW6HAIqlzVGAAgAAQswA=
Date:   Mon, 21 Sep 2020 18:12:18 +0000
Message-ID: <20200921181218.7jui54ca3lywj4c2@skbuf>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
 <20200921171232.GF3717417@lunn.ch>
In-Reply-To: <20200921171232.GF3717417@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5922a382-f67a-439e-b612-08d85e59e0d4
x-ms-traffictypediagnostic: VI1PR04MB6944:
x-microsoft-antispam-prvs: <VI1PR04MB69441886DF26F126F391576CE03A0@VI1PR04MB6944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: klzDwqeD3d0rW6O2X0h3Zva7unLD50bofE7yceIaSyFX6UPjU4fWYteuIdTQRfA8h+l0kiGCS0RyBBrCTUji1uwwGYYyYlA+ikjhqYGmAHM/dqfkpisigLH/PdfB1Rv5dHq/U2S/jHaLi2Qflm+9vFfgqK6/aXPInSThHqzGG/AeeenEtDVUxpzN50pbhmkCT/uLuurWATXCZ2K/QKlRKLNrbpy+Z8xq46ZC8Nku7Dh25obwV0qFwCBFraWHguLnySFeopb+ktqsrHptaCNu2idZxfSw+gPXAUVu1GEaW0Vxyt7KJfdaX4xOphv8KqNcITAnHWkPv7GBrSFkg8ohxWiUkHiXRMD6PzXwEq/8F3T6WJo231lZCJSgYlcrDdPjS7+XSjhhLZojCYfSXI1siQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(8676002)(54906003)(478600001)(66476007)(66556008)(64756008)(76116006)(6916009)(966005)(316002)(86362001)(66446008)(6506007)(2906002)(66946007)(4744005)(71200400001)(186003)(9686003)(6512007)(33716001)(6486002)(5660300002)(1076003)(44832011)(8936002)(4326008)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: p9IEM6Fq9JIyjMDQWVU/jwypJXQzaTqbFE0bCAdFlLrcqpxmY/IfZ7+vmj2HkkC1eXKNO+adIyP+bV/Oo9WMslLviHYVQZY26nPUQGCM24ObxH+DMZCy4ikyn/+mjzRFYJ448hCbVVmEcCpyez7kb8IhjX1zaXnjQThqpz9eptJ2kvHxaLb1OOlfvUyOYiKhFuKOLpgP801eDQKW7kRxYokYV+Zmt1mtOb5whvygpIzZ0zhFiLzLzsIBI+U+OqgkcsLMnH6IOHVZ06nua3WXm+E2yOkQuaq7bqb4mb1s0WyDZeTmiy6jWbHQBLBqHZtXHMkBmKkfL2obx4n6dfe2iBvtyKaCQyq617ssePfrJD0ecQeG2agbn/5Ei+SadfdnSWtJ2WYMmWQqpqSatEwwvsXZ24GsRi8NPdLnjxTn7JPb4MnVWYdxvjk5MkkpGMhRGLn0SKovhkcBfsALuHHrJW671F4r+6ZbO5/GAynRvNQM/3Bf67U6i4Lzm+f86sIRHI3OQni6oWJL8UYv2Z25v5N1ZMhd7E8K/yJlMlKDFXfSAnSzGmJWgHyhtzgcIBGRSRQRAifTinlaukrMXI93Hxx8zcfYYt8FS3fFztevmkViEgbBeecbr3ZZewq+GqV1fwwQctxDPU53rTv24XtwuA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EEDEC942AA752740ABB8C6D955FC4CC5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5922a382-f67a-439e-b612-08d85e59e0d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 18:12:18.8942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dtUus7S6Zq9YNX2NK4ZwV+bMnniV4PNFbhvgoI2xOaL6geTvo/Dd5K+N3hBn4ZLHF9GMwVpxfTAALJkyngJBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:12:32PM +0200, Andrew Lunn wrote:
> On Mon, Sep 21, 2020 at 07:27:39PM +0300, Vladimir Oltean wrote:
> > This series exposes the SJA1105 static config as a devlink region. This
> > can be used for debugging, for example with the sja1105_dump user space
> > program that I have derived from Andrew Lunn's mv88e6xxx_dump:
> >
> > https://github.com/vladimiroltean/mv88e6xxx_dump/tree/sja1105
>
> Maybe i should rename the project dsa_dump?

I was unsure if you want to maintain that as a larger project.=
