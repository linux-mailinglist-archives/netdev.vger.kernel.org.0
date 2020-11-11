Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142782AF6CC
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgKKQo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:44:56 -0500
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:8449
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725979AbgKKQo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:44:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nse68seGlWrom9DHEEnGdyDy0hlY4DBCl2gxjBAXQgbKG/tbsd3nBr0jqnTbmsQo+1aD4foeXU5UxDsn3qqlMqWZONtlokd5sXQ80gw+oKwhrGwT1tqa7BPkVeyeRsAyiDFc2xzukH+DP/Qo7508IeaVkSyI9TpLL5FtKGV9FbgCMQFaOmJ9Xo5i8XfN2EMGGUAcWuJJiHZ/eqzOtK9SDtsLmfxYeiBnnrQF9NH7ZDWdXCRq3nePJjbBqv8rDUQkR7EC4dRwsyQJ3mOuYSU62tYqVtqcIW14JBrg+f7qiinys5OnO5/yDMUNHCZqCCpMEE7vA4O7f6pHkhZr4UMgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHcddte9uUI6HKeLgPGaGys20m/NYsdBT3+S5aj0Yok=;
 b=J85sMvTEc65ZaNHJD11zX3CQJLOvkBEi6w9cu3366SVP2G1ENkMDOQTU93OIGK9POb2b7RrjcsP+XLBETG0CDDbbxdbLp+b/ieFJBhzfgibFoMA2paCwQtRGXoTjpXqsn+F1KCbnjnVUZqYJEIms0JeT74NGoRDJZyOFoMyWiWTBgJAR4QNUCWOVipBjdk/0CQjV2RwKFfdCrEY2meE2BwWZGuI5CBAKI7RVw2abPkjo1nhZd8aNGv86zucSMrFvudqa5mwxWis7oOuWoIM3squAoaI6TE2vnXnvW+iN5DtuFcFWiGbEySB89zNEmhHTTVW1VC8qZ33/QlI9+Zc/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHcddte9uUI6HKeLgPGaGys20m/NYsdBT3+S5aj0Yok=;
 b=klH3AgjAp2Y9gSedqXGlLyQ6GjB9Y0bPw+k41LCcuku7UYVs5MMxfqGxJZ5iD3w/xuRzfuyZixUUeQzmh+q6fCp49+ckmBL11qbzk4GOjHKvBMsQj1/RSrcQWItC9+p/1bLeVBP/aegPCFv21xN3KP8WdOEv3MBjCE14w0lqwkw=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4287.eurprd04.prod.outlook.com (2603:10a6:803:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 11 Nov
 2020 16:44:52 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 16:44:52 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next] net: phy: aquantia: do not return an error on
 clearing pending IRQs
Thread-Topic: [PATCH net-next] net: phy: aquantia: do not return an error on
 clearing pending IRQs
Thread-Index: AQHWtq+R5WUuz+tPA0yyw9BuN2g6DanDJY1g
Date:   Wed, 11 Nov 2020 16:44:52 +0000
Message-ID: <VI1PR04MB58073C9127310383E4888CF2F2E80@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20201109154601.3812574-1-ciorneiioana@gmail.com>
In-Reply-To: <20201109154601.3812574-1-ciorneiioana@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 505d5f7c-cf8d-44a2-d05a-08d886611c91
x-ms-traffictypediagnostic: VI1PR04MB4287:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4287FED5B64C209B01C271A1F2E80@VI1PR04MB4287.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fDhf2fmVOCdKJ88SoZPnUy4NTprWwfR0PIaDuBD0hAGNDknrhdOOAksCnICZ0rF6gRkd4nh0tXZMKieFW2DxaxT0I1TEAzcLI1DX45DMqRjbT+fYGZTOyf8+MghxuGSM1ppZoHyqLaSVK8TwmCQCJOacEgDTIBIbu9n1nKQXF9la3w+6umsZCnlLlo/qmKJo6OrX8hyrYbsQVaQ2lxLfRWAjY2ECMwK+6exU1wjfzA7RsLZxnVUn6AyIzlv0AAF6WXah70nib0UgC2ELN/tcbZMkyaRqaHshaA/LG6cy/5t+bZ9d8Eg2r1gIbmBWyN1Az56YHz+QLo8+H9ctYLdVVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(26005)(8936002)(33656002)(66946007)(53546011)(76116006)(66476007)(66556008)(64756008)(66446008)(5660300002)(186003)(6506007)(4326008)(52536014)(110136005)(478600001)(7696005)(86362001)(4744005)(71200400001)(8676002)(9686003)(55016002)(316002)(2906002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 64l7RPZrt3LTZRzPwL4VhYBs7tLW0hnKrekI/7VkHMPMOt9VN9O5HwvO+KUD9PmsZvfwRbErxVNJ9O16p8qbQxBiqdWXvLdX4P0u735CI17BDcoEA6H9ueuvBVzgEJWvJGctjZgHf3fJr5VPmwJQ8BQzTXD45yLGHbxvT83N/ulBNqCV7FW0t0J2TPYJvBYKVeSnghSoHsteQIZ26eiBFjQ6HlPHBTyWlub+93rBI9Fs+KPQkReWeXlQ3TFx0Da7LHCAijvdjbTUa7OsNVbHT0Y6eI5exOKlJxLCzjsQjQdh9wZZ12a3O3+TM9Vemoh78RmMH1i0VGlntODtujFcMqX2IqZe5FHtT0ADAtk4xugGeMgBTkf1QjE2H1+acnO8Z8501fmj2z4EVvBSxckFAOlkT/5fqCRaNc9h4IYetOhP9GwLX7RGRUgazMZ1j5EiIfR9O6k3RirwvgjVpI58tB0d5VFQxMH4qJws+DBvryRgGAd7lMqXuy8N/wAO3HqnWklRNAJZmuIqwls86JAw3/8//mHV1Ik20jNLLb1WZA8+5B+wNoXPnLzifyk6t8P5RELOjs82S6s4BawCKnEC1a0VnzJiowtZNqOhyGYgl/qWO+ZFRl2uU+ZIQ+H4PsPMcX2m4QNXiL3s4QeGA8tu2MvX5uVPksZG2JihfdXN5KoqSyrDv6eq33+M8HrD1QSQys8qK6ITLL1rYsdW1s0aI42VwHYQTETxFsi73vFCS2j9O03ypc+AMXfJIe7EfyzOKNVvEvJMj/ZjWG3Z/tc4H069QGe6sj/b8qMtUDe5A672Abt0HyAYnWicGxk2aXjeht+FIjMx1XtFVUGAA8lIenJejdOL5ZEcM7d7I1Tak5VhS5b6tlt72Qxai4qjdDWtSj20ZOju6YnHmDagwi5xXA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505d5f7c-cf8d-44a2-d05a-08d886611c91
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 16:44:52.1533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NB3Kxy8m+l0JtKOMO8yeWd+ZXWOUf2gW7e9yVsyXUSxeONqqVNP24kSP5xoNRzsZ5KxrN030PhFy0CzHEa6MEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4287
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ioana Ciornei <ciorneiioana@gmail.com>
> Sent: Monday, November 9, 2020 17:46
> To: kuba@kernel.org; netdev@vger.kernel.org
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Subject: [PATCH net-next] net: phy: aquantia: do not return an error on
> clearing pending IRQs
>=20
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> The referenced commit added in .config_intr() the part of code which upon
> configuration of the IRQ state it also clears up any pending IRQ. If
> there were actually pending IRQs, a read on the IRQ status register will
> return something non zero. This should not result in the callback
> returning an error.
>=20
> Fix this by returning an error only when the result of the
> phy_read_mmd() is negative.
>=20
> Fixes: e11ef96d44f1 ("net: phy: aquantia: remove the use of
> .ack_interrupt()")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

I ran into this issue recently. Thanks for the fix.

Tested-by: Camelia Groza <camelia.groza@nxp.com>
