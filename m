Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E977B285DAA
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgJGKzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:55:36 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:58023
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgJGKzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:55:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZnSKdvoNo7st54u37ISxJPnBFdQMM4VMqz5cDwZ6cyCpZj+3lJs5i1HSsUg9OAvjPERvFDfFrbEGNasDXeS5EXRAbn5R4XzCNwp+sY8OUJi/9iXNnZwao40MwLoKjvtr0oYR23eEpQGOROOKybnUFILK2/Ts/L1/KC/xzhDGWBNaWGSpQb8D+wbSkQwtGlvlXOA7a32/PoM7xBXjGSN8R5XWduYw7+a1ntKm5TA75k4mX8fzBI2yf2FNO1oY31PBkqvUQXQnKvaL3sg8uW3XVjQhI2beMrYeDp6heqvjZ5vDSUE8O3Bt3l+NQz2fwUUXNDTiB+V8ATo47Tm1T4e6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC7m3NUlpzEyGKj4U8p7CGpDLXXJC3SX62ikMSGiLC8=;
 b=F0QCVS1nT7W9TQ1u7bdYzuZQVSfREV/51qgCAI0KluLiAX//H5+/VFoSywLBNZ5XqDv9m5+Ygc3WnGuIWJ6eVTdIaZ6JRfxlV+yV+b0xXy2dhywzu2xfdlcagxiEqbxKRKrQDnhvcbZzkHaYUQvcc5EG8aD4tQfmy0KYsV30r2+Hb6KZepEswRftEEh3zsKQocFjM09YyUtcqXUfODiNRYb9LpKn+ICwbFBaNWiqRcZ+lrthhyRsJcdQPvVNrILMKHvG7F684E5B3QtB+w/9WW9AiioeO2k8zblZFKFKrbI2tggzc4AZght8yUMLdfGdvYZ9ZUNIaXkxT1ggybtulQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC7m3NUlpzEyGKj4U8p7CGpDLXXJC3SX62ikMSGiLC8=;
 b=lmU6g/C9Pwewq1O92fTJR+hRSboGjYCtD3ZuBrNnQ0dhU1k3vEbAojvSie+SdhUBc+5lCyOOhjBfJs/BrRAQCIdxVYGFQwk1MegbR45U7QWDwTc9/djhcO3A8lhf2ETWYSvv3DJECb6jkqZQA0945uYg20132JDH+L+o5z/qGu4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3472.eurprd04.prod.outlook.com
 (2603:10a6:803:a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 7 Oct
 2020 10:55:31 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:55:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 1/4] enetc: Clean up MAC and link
 configuration
Thread-Topic: [PATCH net-next v2 1/4] enetc: Clean up MAC and link
 configuration
Thread-Index: AQHWnI8HTi+3KiBvLkik+nn+0/gnvqmL96AA
Date:   Wed, 7 Oct 2020 10:55:31 +0000
Message-ID: <20201007105530.b4kdnhgzrnpfdoa2@skbuf>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
 <20201007094823.6960-2-claudiu.manoil@nxp.com>
In-Reply-To: <20201007094823.6960-2-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66bb4499-c48c-4683-9203-08d86aaf82b6
x-ms-traffictypediagnostic: VI1PR0402MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34723384971AC7684E739B53E00A0@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i0jfhETSJzpLJzUhfdbE0h6h1OBHo0NeMdW87Csn2mKt8Ucx5g5UUeVXOANib+k7b5EvratZWSbS6Je/iKsefnfDAk0KoTtgF+e9Puqn5TyhyYBZ3MWStnlyt3tbZ3Wpr7k6xk4dfHQSG/1Yg2JDayR8s9VMI3akHtTm+pIFk9ClENVEnwBx4h/tfcQa0e5HOeX76j9MZG109pDKFaYtZRdt4WJD859DXZYsLx+kkn4TXIS5w6RoVMamRUYrJ7zJoA2cvuewnYc3QyYiwwfCwYT3zkcjZwkZxm/P9m5FklYIQA2HTRetal9v1QvGJqDU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(396003)(136003)(346002)(376002)(8936002)(8676002)(186003)(64756008)(5660300002)(26005)(66946007)(66556008)(71200400001)(91956017)(76116006)(66446008)(66476007)(33716001)(44832011)(6506007)(316002)(4744005)(9686003)(6512007)(478600001)(6636002)(2906002)(86362001)(1076003)(6486002)(54906003)(4326008)(6862004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rMvro1v2V3tJAbSlZbprSpmsDfo2ZnLrawVuEmhOpXNrMMwvH0IyuHV7n9/6idwewc/GYdIOSZ1b0Rctd2wDJj5CCrqsdWK4BaDKrkDa+5B4DaQIgaR/PCwkTT+tq7D/kcTksFcb7iUjkqM/jkvyQBJDXEqImxTANrDHWcXOTEuUQlHZ4II5mMxvGgnkNJx/24s+5rJNMXnwjBFg5KthHBUAL6akh/IVZwszSqRnV5TeZdhoff8CXFtHMkLfzpVQE2fzv3+ChnfcMdqHF7Fv51wELwJf5hiZsmJcxw2bvjyia810dqWIthlITetMleJ3b24Afy3eijei6CXoJuoykCVtvamFyuA1MDk/USnXG9L/H8FBV4kD/dGRDCF8bCMtskTqVch8xDHSn0Q3CFRIJice0Uyqa714+troSOCqsDaOy5VcrZfa1FzaYUfGShDMjLMoZp7Y0LpNLv2zSV+HaqS59CogmFMJMvqKguOLZephO+ZltT+SjnSRuAeBC1YWQELxqoCusd0rpU603SPFcUZSEKAVBgsbmMFN9WIF4nqBB7OS3QKcX2darqCqkFladbaxr0QiymZi8OVAJz4yYNlfhU5wrtneO/ApB42juPT3gb+eOQMEzBC06qFlII+mHvEiuKCmpc/FSUXBOunnMw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <644E905300CB4340A83D7AF3C4743982@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bb4499-c48c-4683-9203-08d86aaf82b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 10:55:31.6100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhJbzkf0dj/tv1+xaF8Iq7TLQ+TQIwdUiYk0EddMHY3uYXZyN/tOflmCanm27xFuiJ5hhqGII9xOVmiV4bvr8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:48:20PM +0300, Claudiu Manoil wrote:
> Decouple level MAC configuration based on phy interface type
> from general port configuration.
> Group together MAC and link configuration code.
> Decouple external mdio bus creation from interface type
> parsing.  No longer return an (unhandled) error code when
> phy_node not found, use phy_node to indicate whether the
> port has a phy or not.  No longer fall-through when serdes
> configuration fails for the link modes that require
> internal link configuration.
>=20
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
