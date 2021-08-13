Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61C53EB663
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240683AbhHMN5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 09:57:24 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:5026
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233514AbhHMN5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 09:57:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgmNhTHWewpZZd42EuoL0ANuEeAvkMtJPK2rHtfuLGI3EVL4Hw/jkoT78sGGOSMxizuEptjzMSt4oE3LLiw5Y+dW+qoo2Db227ECf3gb5dt2dHUZoxACnBfv3beo4pL2OJcGw38KVmJVGp0tMHS09F7mcx9f9+CZX/rx7A/5MtLtdP9CiYsYF39Z/Sy0BiXWbAG0K/Mw22ILleBgDwcmqFaCctnRc8uMCeHlhUuqWf4884vCDd0Qcic34oSl5PRD1qkJrMrhDIAzlF7J3sRUWDVX5UeAM1PZmiNBXfOayKZH4XPhfhD2FsxsBOOIORm8VarBA548I/8ePw56eNC7Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HUr7HD0oYmj6Y5dQhqn5/TGSHDuBs4x4hGHYeuS2ZA=;
 b=BrmFe2NTed0298dEz2XANr+Wdqdql74x3eeurKt0ZOtrex0l6FBxHZ/qqzPYZyMiycKnRY1u3Ut4eMbSTCJdACzO5Ip3RIGUdAwayyIUppnN3d416HrZQdUauQnFo0vHywbY6P40G2UNLRt9GFM+RxIEKzwYYnSMVC891j2qkPnAmttBNZbsVRsI6ExqQGYIQShB/0KZoPp2tQr+vhrpO+OeaoYzoIea9qPZIvoY6grOWFLMo+/3f4F9s2NcJueOViJ2hz6kGhJZSFJxx/zfIRmH18MTgrutF/LXGnyl+uAnmIlvZJnglUS+aP/+alEbIxfFEnXhFP99epOMRj4jXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HUr7HD0oYmj6Y5dQhqn5/TGSHDuBs4x4hGHYeuS2ZA=;
 b=IfBmIwNOSLOoANobchbySwfTYLwMNHB8lNmk3HgTgBF7GA+Ui3/trVaU2dkO09m/fWdcXbTSHV9JxYxnuIeyDXsP8fMQpWAxJbycHTOCZP+D8dk4BSztsbYa0X093dhPUtUh+m3KFcJfsxxh/x1YB0Ol/OkpprGJzv2VMLWNqks=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VE1PR04MB7213.eurprd04.prod.outlook.com (2603:10a6:800:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 13:56:53 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23%3]) with mapi id 15.20.4415.017; Fri, 13 Aug 2021
 13:56:53 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Hongjun Chen <hongjun.chen@nxp.com>, Po Liu <po.liu@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Topic: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Index: AQHXj+75u2Pfw5dj90eW5XnXIP17J6txaSUAgAAItjA=
Date:   Fri, 13 Aug 2021 13:56:53 +0000
Message-ID: <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
In-Reply-To: <YRZvItRlSpF2Xf+S@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e36a14c8-88b4-4a21-6953-08d95e6234fc
x-ms-traffictypediagnostic: VE1PR04MB7213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB72139801B02A148A286CBCB1E1FA9@VE1PR04MB7213.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1WE5/x9+nPT6n52NhvfYcZe0veJcFeSbIs75xT3zWqvuhF7c7ACvLdx9FvCsixZsaL/+HJLGoe5PaGDvaQNLVH9K1jRceZO/ezI+qWhCrKaicMTPpFiQrf9lfuAY/LCGU6nnzgwkiNwnqhCybTXI6wO4FcIZOfYnsM+G8UeAy6xDpS2o+pzdnGFjEcIMefpUNMkbt0uVjFMtVnkZwWUetW7b0SLP/fy+N+id8r2iPF7JJVbBSigkS/IIVrWEOoiIVJYKqN33kjIy11FRHxzyL24c2kfzW4OMkv4s44yCkbo8po3jUwqX0Q9LPZaFbuUVFa3jbMrsDkJS04Sj99EYEYsiOYVmOGft3GmvpNXZ0TlE7Gif6IFqM99New8YjWl5eaimmgY4P42eXeoIqWxlzyPYxWK1TEoN3MR7Y/nr3XjByCBPUNeca1e47OGE6YZ4VcxPnh8+/+NerqEiVnKEwHLyr57bQEX0Ij90bMUAW3HrYb33BSos4kMNpm2hzsrhaMLDdaIMFXVaZ+hgzxVZbH65cBvZcfePymyL3lZwVbR+Rnflidb7wLMSVA79XcOaBYRZQSfKH6A7SjNgLvwCJXWcQJEG/8RDDeutdl3OLz6Xtvs3oBQchGjuLmDSyhjpPTC5Bj0lFtYj/VbgfnNLw+JJCUMo5mE8UVoh+LONk8C0HGomo1vAGHyQQhDkVbDDig6/LgkMpISawbasO0ORBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(71200400001)(5660300002)(4326008)(316002)(26005)(66556008)(66476007)(86362001)(55016002)(66946007)(8936002)(122000001)(64756008)(66446008)(2906002)(38100700002)(478600001)(8676002)(38070700005)(6916009)(7416002)(186003)(44832011)(54906003)(9686003)(6506007)(76116006)(7696005)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A6qSiSxRcXqVPA+clWCa+RWd0xjzOHi91UWlouqe6nIzkutQIDH/YrH6nAJf?=
 =?us-ascii?Q?euNXk6u2XqjPzrJspVAkZJ8cHB8eHhe2tqgZbRU8PS5ZxvHzYHBq1dZ/GQce?=
 =?us-ascii?Q?OLFPuT9j/0Y/3RNdw1ffS1KXdkaBGu0jH4lHKIntg/swz6ZVAR6sV4BAX3Py?=
 =?us-ascii?Q?UsTZgXivbITP9xjbpi4+Xi0W1MMJxHUt5BnN4ea2OxgHqX8Qd4qf0J3dt7w4?=
 =?us-ascii?Q?WX1X1xoNelfx2lIfkENJ//XepMOvX09S1Y8GU8CY1PVunZYseWESNh3FyCok?=
 =?us-ascii?Q?uXX0Py4I+VpRIC8QMKsgiGSeCR/xy/VRY/3V5kR3nfv0PNMpStskSfpfAXHb?=
 =?us-ascii?Q?YXLjvAqW+P76lyPo6GMyUoT+NFUuub6F4PnV8zlm0+OQGhTM07zozKyFQ1re?=
 =?us-ascii?Q?oSHLHuHLcPoo8GgC+ugQqaONzK+mDNhKH9uQ/OwscZlOK/2edCcsSZXFweGJ?=
 =?us-ascii?Q?GTIea9DGUwndfS0Bl2iIZ6KI87Y/dF/PXrYSrJ3H7xzSG/DGszSKKNf+VOJ+?=
 =?us-ascii?Q?HqfV8vnnT9K4h397MdE94PyqWAznSbrq4YbxBBPk75fyJkk9TZL6R/YXH8P1?=
 =?us-ascii?Q?FblzQ+fu+ukBocMy0vJw/ZM40HUzqPcM0vwKYjsge41ZDMQgTJFcHnUUa67A?=
 =?us-ascii?Q?PBfc51/rUwO1F3ve/lCTf+ilLKz7o7AU7b4lwWISbrbNhwc13msd6+vAVI36?=
 =?us-ascii?Q?HcVJAAT7TsG3bKlfbj8N0i3Y0pDi3CKIHqlWtiTznlSt/h1MyUoxMIjvp6p6?=
 =?us-ascii?Q?wsdOAjCYfQHQBTyMBO9I5/AT1exv4aZnjx22PTUwt2auxQbojdpElv2eQqiK?=
 =?us-ascii?Q?oP011RIQHYQcbtp4gT55gwHxGowT7lETpgPWwI7jOU1U6Kljp8XEQb0pa9RL?=
 =?us-ascii?Q?ECi0SDhCnIDTsXa1dGNw109l+uq0YyAfDV6w7Kkr9C2KeQLQV9igH1Av6hIe?=
 =?us-ascii?Q?4H0OlttPhv568fxm5e7iCMueLLCIZ4b8DsVgMebjH7lWqOWL6oE76tos0QdB?=
 =?us-ascii?Q?Switrb8amTjbjBYznLgDUubNFklBaeBlBOAX0GccpZMnd9+55p5F8vQpgZWb?=
 =?us-ascii?Q?Sc1ZSJNRvOgVuqcg4kF+BILJgK4kIPtZuK2FlJH0UJiQK+I1npKFm17aBuXi?=
 =?us-ascii?Q?XQ1v/L2O8YitTnsBXXS6bNqnDp4KQ96X+9R7iiDW7N6dRfi9w+kw2RSgP43o?=
 =?us-ascii?Q?E7HOihJNsMJhYAzBfgBcgCKZjYBdzT41NsaWK8X5ggtE8D5PhC1OaC/usgtV?=
 =?us-ascii?Q?h466PZN3n3TV/LV3bXRQ0l2qIP0fkuzodDmebt/ZhZJGlAIIn0YIgb7oGG8V?=
 =?us-ascii?Q?AT0I/b8HfRnMKNt4E/lyMp0c?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36a14c8-88b4-4a21-6953-08d95e6234fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 13:56:53.6080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNExaafcsnvxeG0D1u6LXRNJDICqKgpb0Vs27MJXXqzDZwmfPhTSmoGHV7R2Ek+W3maqVbsJQgQheg164lDNYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7213
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Fri, Aug 13, 2021 at 11:01:55AM +0800, hongbo.wang@nxp.com wrote:
> > From: hongbo wang <hongbo.wang@nxp.com>
> >
> > some use cases want to use swp4-eno2 link as ordinary data path, so we
> > can enable swp5 as dsa master, the data from kernel can be transmitted
> > to eno3, then send to swp5 via internal link, switch will forward it
> > to swp0-3.
> >
> > the data to kernel will come from swp0-3, and received by kernel via
> > swp5-eno3 link.
>=20
> > new file mode 100644
> > index 000000000000..a88396c137a1
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb-dsa-swp5-eno3.dts
> > @@ -0,0 +1,27 @@
> > +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> > +/*
> > + * Device Tree file for NXP LS1028A RDB with dsa master swp5-eno3.
> > + *
> > + * Copyright 2018-2021 NXP
> > + *
> > + * Hongbo Wang <hongbo.wang@nxp.com>
> > + *
> > + */
> > +
> > +/dts-v1/;
> > +#include "fsl-ls1028a-rdb.dts"
>=20
> You will end up with two DT blobs with the same top level compatible. Thi=
s is
> going to cause confusion. I suggest you add an additional top level compa=
tible
> to make it clear this differs from the compatible =3D "fsl,ls1028a-rdb",
> "fsl,ls1028a" blob.
>=20
>    Andrew

hi Andrew,=20

  thanks for comments.

  this "fsl-ls1028a-rdb-dsa-swp5-eno3.dts" is also for fsl-ls1028a-rdb plat=
form,
the only difference with "fsl-ls1028a-rdb.dts" is that it use swp5 as dsa m=
aster, not swp4,
and it's based on "fsl-ls1028a-rdb.dts", so I choose this manner,
if "fsl-ls1028a-rdb.dts" has some modification for new version, this file d=
on't need be changed.

thanks,
hongbo

