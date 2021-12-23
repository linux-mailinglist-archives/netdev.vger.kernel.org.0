Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD5047DE3B
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 05:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346306AbhLWE1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 23:27:33 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:53571
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346298AbhLWE1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 23:27:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3/RSCMNmcBf3rZkOQteD1IzKM43OPDYP0KztFQLnhj5+UR9HQ9pdtnZMUDxybKU/k+h5+7xm/1f5sJJNr0qHHtRThvVPZ8r/PHrptEIFtY0yXoZsoYy7RNTY+h1iQVp0fewgqRNyleh8gLezaNcxMF6cBMZnT+PSDRowKh9PjZzQKmcYaHJq5E/Ru9tMJPU/jnds9/froRttHVpmvrOLy211l1zlCc9G8z5hQOhfJx0pdy1medxHiPEkvvvWnVFqJbyihXzu48an5dSYhOHYtnWsMeBqXtZuIZ6oo0LSKIOtKHaMJQqSYnlxxCkLB7LLzC9TM78e9WTmU2Kfow2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP7kJL8f5musNTN+Ac5Uufmc3TG+UxZD6yHd/ou2HOY=;
 b=ogHDb1D4F7J5jdtYpnlDsSevegVg5Vpo8t2eVAtHO8DP1UB2SdKd0v998XbLYdxj2zyHerOzoxfCOhrHdWh5cpoGehTtPtFvpDCh0aWtp2bKaIux5AosyaehwAeEH6ryYxR/dEFwPR7/EeHpRxz/dCgS5PZqivhn6fhv37gAJadhWDKZPcCdPLEiabJz7nOV8ebPfB++15NRZTw/YUpjWGJrYZ0S3i5z3qx5YYacHIm+xiuYEtgk7g8BSoTT7mdjr/guoqAqriGt2LQFyaxkaciX3Hd4aZLVoelJ2kjQJt5z9HGwiAlx3/rriJ5N74Li1DBk4VHZFVyMmicJp1o/dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qP7kJL8f5musNTN+Ac5Uufmc3TG+UxZD6yHd/ou2HOY=;
 b=oE8g3GitWCgJTXl7KoJPg0Uf7JH1tR3P+zRsoca0N6ypmTG8fN1iR0UWiyDZmXDD7W00fqLq0WnNX/+eTlKfme73evzUpO/fXMOfzIivjWg/zykqUOp+7p8sXTfFgwmw3cjq1rFBKw6EZHgW8fKZCrltPRQQqG9AzTlUjdOszbc=
Received: from AM6PR04MB5782.eurprd04.prod.outlook.com (2603:10a6:20b:aa::17)
 by AM6PR0402MB3733.eurprd04.prod.outlook.com (2603:10a6:209:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Thu, 23 Dec
 2021 04:27:29 +0000
Received: from AM6PR04MB5782.eurprd04.prod.outlook.com
 ([fe80::b4f8:a657:de20:c04b]) by AM6PR04MB5782.eurprd04.prod.outlook.com
 ([fe80::b4f8:a657:de20:c04b%3]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:27:29 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Marouen Ghodhbane <marouen.ghodhbane@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: dsa: tag_ocelot: use traffic
 class to map priority on injected header
Thread-Topic: [EXT] Re: [PATCH net-next] net: dsa: tag_ocelot: use traffic
 class to map priority on injected header
Thread-Index: AQHX9lieJJXBj9Ptw0OYJnrgFnlWoqw/GG+AgABhZpA=
Date:   Thu, 23 Dec 2021 04:27:29 +0000
Message-ID: <AM6PR04MB5782E1EDD9F0FAF06E7D691AF07E9@AM6PR04MB5782.eurprd04.prod.outlook.com>
References: <20211221110209.31309-1-xiaoliang.yang_1@nxp.com>
 <20211222142337.0325219b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222142337.0325219b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ada0cfd-b6bf-48fd-500d-08d9c5cc87e3
x-ms-traffictypediagnostic: AM6PR0402MB3733:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3733B27C5C2E94D26A0F2F56F07E9@AM6PR0402MB3733.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J/ZhazIqzeoYLoo1ySpouSyGxWVCJcfFTi3yglxYbj1tsFnCh/4nzH53xHTMfRilOXnScXz7CptdhMUf5UEnafz7yX1+Y/8snjTnKamm9EFTP+ePZatfmWmt+bvdQJHnyFAfvtxiCl+/y8M21zsDKfCm1ESfC+rfnIt9cZ31rv36xrrGDViTPNpRvIdBpFqpHzAFHpue8Ff6q9WVMqILTucMcTulMwMTzeTeVI+25I2Y2wpP6bG99TJMDAwg4cS6n2x1fNQ6soobvw+g6fUOMWnFPYfUaorocPyWoOMQ6dqsWGrnMwHgqaZEyrvS3OetDaXmjIhsvGyMeTJ0ErRvz65JR2RsWrr7wbpTCykJ0Bo2c5P04WeuNpR5YM6+Y7WWQIjiwXMIrN5L2hNgpF3fIk5agO6r6m8CynboOtw0wZfN4B09idXt/nTnFfpD1/shbzZhrwu3KzagDTy9ZIUBj5ZCIwVAbs0nPuUBIZrnw39gLbIWuFfKNurSF8ogm0kA/a4deljvYDYDAPlzaNhTduuAq9N2on8eS3OVFh6Xg21BfjESQ1+kfmayu03TEDv7ZsswLfIaFEs+P9Q42dfI4iO/A9alnn2QJ0DUJtX9pA1nydsPFDTfR0nC6TH2t/OHXn9DcC+kb6j4LDj02jvKSpZaKzgDpxgx38im3mX8mAd8aBBkl6R0JGiAlg8HF2OGhGxUCgC1nnMQ4nausGySsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5782.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(33656002)(66946007)(6506007)(66446008)(38100700002)(55016003)(52536014)(66556008)(4744005)(8676002)(64756008)(2906002)(316002)(86362001)(4326008)(7696005)(26005)(76116006)(508600001)(8936002)(9686003)(122000001)(71200400001)(5660300002)(38070700005)(6916009)(54906003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ns2JyTatHyiTGMwPjTm2AzBbVrauqZ8B3ja756Oo3V3+V678XPOAvAKQRpEj?=
 =?us-ascii?Q?Uo/p4iuh8DjgUEi8CjUFooOGuIOPGssGf8Xvww3ZCY4auBA5KN9WzI4JsOVB?=
 =?us-ascii?Q?bIAzY6BNGSJiORzBSj1juISuwW+g4bk3qFvaf2v7PzY2o3vvlKmX6i5rMfn9?=
 =?us-ascii?Q?qWg2jwv5IoxXKYKEA37cmhAsRAm3gViKvi7bw02zl9Z0cTKJJ/ZgT2PbnwwZ?=
 =?us-ascii?Q?r+x7S/Qs6exwCBPUYvXJAYRq2smlDyNtk1HfgFEQWBJA87xtcZLg4fh849SS?=
 =?us-ascii?Q?Rgm0j9KLrhfVOxLCtfC4QbwnrtXnouNctNdX636g3XlB5ggfPpaLe4SSc460?=
 =?us-ascii?Q?595G0fyd/rs44Tn9vdyFjlqPeUeUmmYq5g6p938WT42ehhxe6YW48dpOBGpj?=
 =?us-ascii?Q?uHuMlm+4PUKCfIm7ifDlqnCcxccw18FM8eBQXXKbIinfDgwhFeTtEy/Z90VY?=
 =?us-ascii?Q?gomtzjx3x9hhUf98LPPanLeub/kKxqnnhjs+j0BYYTl+onlSZB6sBSgXJ0We?=
 =?us-ascii?Q?I0RUtilWdU8wad6o1nskGTs4quPQjSL7bpFD87sNk0gTWULy+XWcO1MPMciS?=
 =?us-ascii?Q?p8/2ZmCjaeYXi4mxSmUSnteDffqMNaaL8YseP4D9DesEEYJcZwNZMP8tugEq?=
 =?us-ascii?Q?3g2IyP1OWoTL/5b2823V5Q6/JNirD/d94VOjoFxZzkjpVgj3OJAOQ5eOlaI/?=
 =?us-ascii?Q?h7AIEGdqQepAj7xbdy94JKqDylLkRon1AqK/mkUIWB5/QA4aZcgJCYJleI+b?=
 =?us-ascii?Q?RZGY7VmYf0hxqAvcu0WnJfcoY87hYzXbKoZ196WeIHJ/OH8G3NaFXKfBdbav?=
 =?us-ascii?Q?DedChrm4TzcdipYGblENbtpZxOlcMH4I9p6e3wERyWn7RFbFp1FVm7gzP4Fu?=
 =?us-ascii?Q?0hzq7RSZ39YG3N8y7dVcy9N9Ny7nhKh2BiNKnlSYi7vNgaxZcVEnxFtQeNih?=
 =?us-ascii?Q?kmGF2KQLLryTaMuNFla/onaBc4cAaDFVf1RJbYQNGMxFiy5hY0aUo+7+wQ1l?=
 =?us-ascii?Q?JvnC4w9jvZdl4Lcn0/GlxPh7fknLAocEDCwOoAgEHalLuCeeGYuzO9vHP2kp?=
 =?us-ascii?Q?m1GrfA8ftTo/mlNYIf7yFAHOSMxEXMWNu3nqLBMWQjyeSywba2EEEa2rceFZ?=
 =?us-ascii?Q?FrZOmLQRAnbHB+xcgDJyPk3+u/ZV5Tfn80Ur/dM3R62LYg26ubgOM2Jl4uSX?=
 =?us-ascii?Q?LnvMLKvgKvM2uA3yIy+Iz85QRg7iDj+lHlsE+y0vFlfNzVWhphFVPhBgMKCs?=
 =?us-ascii?Q?Gg8zPK+IwjC8eh5R7ihlryJwlwEs98kGA/tur8ohLBP5ehBWpG68q+JcKJCL?=
 =?us-ascii?Q?iSupRsDsYYzawM9NRlsuEu3dTvDizK5z5dxZ41dI5yh3u2h8W0/ej7FvckSz?=
 =?us-ascii?Q?Sg71M5tDHHVNgV0zC55J77QChWrzMoD3OBoVhxsUcAx7dJkJo1Nmh4rigK9G?=
 =?us-ascii?Q?iLKh2PGqz7uADObdInMmCDq1qz1TeEMu38iziDx7XiqJG07XqsJWx+DpIZtf?=
 =?us-ascii?Q?jTrVn4+R11jD019nicSlrVOel+ye/9yqEPyAO7ygo7Zb8S8Tnso8emQ0zndX?=
 =?us-ascii?Q?TcK8hYDUPJpRLAhAihj2gVi14FuKEpuam0BekOaAv86mAg1gmGEKttbJeddV?=
 =?us-ascii?Q?y1EwwgYbUA+TUen5cknb029mKPJ1d0m7sm7TT8krSZOKMfYH+t0DldnwRa0B?=
 =?us-ascii?Q?GfnnZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5782.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ada0cfd-b6bf-48fd-500d-08d9c5cc87e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2021 04:27:29.2707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PzQMfc6Lnva8v16G2HT52KEzVE031jCAXePi3R/qcG9nzwFxV4bHhaU2sxY6NJaMKlh/qLTvIwYqTvbHyKHyCoB70vUN+ODXjzfPcril5Yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3733
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 23 Dec 2021 06:24 Jakub Kicinski wrote:
> > For Ocelot switches, the CPU injected frames have an injection header
> > where it can specify the QoS class of the packet and the DSA tag, now
> > it uses the SKB priority to set that. If a traffic class to priority
> > mapping is configured on the netdevice (with mqprio for example ...),
> > it won't be considered for CPU injected headers. This patch make the
> > QoS class aligned to the priority to traffic class mapping if it exists=
.
> >
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > Signed-off-by: Marouen Ghodhbane <marouen.ghodhbane@nxp.com>
>=20
> Is this a fix? Looks like one.
Yes, It can be seen as a fix, I will add fix tag and resend to net, thanks.

