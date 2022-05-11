Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB6E52361C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245059AbiEKOsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242886AbiEKOsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:48:10 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2358863BE6
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqePjF486G73TpKOUsZSHIjvgR9bAonTS0XWHNVeWYTO7rz28JhVnrOkgrTlNi8uL0px4FeMSUy7sUVAqpa5Vr72GRl5M8Nxt55mPnYG0wIbrc+KPI8h95xsQsm09BVDQWpaqr2OQeAWvgcDtYJwLEdlIW/aS0ggdBglZDzoYN+l9mdRQKeeTiLsidS7aXk3CnpliXngVhZaaBPzShgJPlNmHp+f6Kk7bkTW9uEiQQTJvuUr24nPAn5lsulc9AJj8avwsMYPQBuit4G89y9polqSFkGZrIhdUkfeFUmU9vVNZ7/SIIy8jS3+/mYA8Z4QGG/StGS4MPVIikWnISP7yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1U5BgxzwVpKszVcZ0zAN9kVH6df+t5PkqK0652aSB0=;
 b=hkiEz/yb8dOZOZw4oNz9xq5sitt+Z0KRSxp16g0E1Qmvv0vz4mIrEBxPfUHO7DAfIbTFV6k59M4ZZVU6z6seMOYTA2SJBXtY+tsUUZcWDAWME45TIiss8wuhXiLH3aPXx+oVfjz5CdT//HAiVx9u+R8LlZXyPqF1QpFW3txggpoCHf/N31T4eonxZzyExmJn0PoLpV4MRhOMYvh4bxnR+udPmpd88DhzjcAWYwYqJh5yE5q/GkWL/0prlsc6tZ+BmF3Gw4cZ9ENb6sqByo2JhHrZ/apuFMkg+UoQg4z24asFi4nSiPKlnB1lLAe7fhKCJAifOpXt6JRMtlZBs/DxTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1U5BgxzwVpKszVcZ0zAN9kVH6df+t5PkqK0652aSB0=;
 b=p7wQ2EDL4HE90VZfbkUAmLlsVnmxbeMOzNm6923c8fWT5i+G7Vmk9mnlHg+jMnrQdqkfBaXW8s7X6/14i1SrIj5VFXeDNKMW+2XS1PVRtthJYGKLBkGKSF+SEvdfIubi8A+w2NbLX47JvFHRilLet3iDdTqL423j6Avy4KvWaSQ=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by VI1PR0402MB3583.eurprd04.prod.outlook.com (2603:10a6:803:e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 14:48:04 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%6]) with mapi id 15.20.5186.021; Wed, 11 May 2022
 14:48:04 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, Josua Mayer <josua@solid-run.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Thread-Topic: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Thread-Index: AQHYY6DnAmQzgFUDN0Gk/Ykea5Hhha0Wf1OAgAFQ/ACAADc2AIABdEsAgABJKAA=
Date:   Wed, 11 May 2022 14:48:04 +0000
Message-ID: <20220511144802.htkzgisedkkcdwhd@skbuf>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
 <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
 <YnpW9nSZ2zMAmmq0@lunn.ch> <YnuPRKRBj/5YbAUQ@shell.armlinux.org.uk>
In-Reply-To: <YnuPRKRBj/5YbAUQ@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 012b4c60-bf29-4b98-a70a-08da335d4113
x-ms-traffictypediagnostic: VI1PR0402MB3583:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB3583B3E9122AAD84AA9751B8E0C89@VI1PR0402MB3583.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: piJ2UlPMi2pArw3GE7Cx+57YU3M3HVEZsEBpPpvDZ+CcsIeF0YvDrxFC1Jop3exh8h54KPKJw1d6zM3Xbs9YE88xJzaiAnYw8ipVttr4e0mQSu5pmlMw79tfihGUGdwgrALC989u2JS5JbTnfcscTr0kcr9fOtZM5Unoiik/uHXx7+pCDvVjT3pw6PGwnNjnPVU6Z/D4t0FSbYJah3dplf71N7Xsy54F4epPHlF/zNw+0y3Yl14PAvsuiG7JNNBLLC6QNnYVfKDHh+qEKh+F6zyYRcopo/UTDNiBKX1cNUOJVn34ncwpYwKIAzuv51p7DOueAAHlFOUcfXwRfiS8/gNeno5blZD0XMOr5kZGK4g2rYu5crjdm0rSoHCrpR3RGKp681LmK5Zs4YGxS597bGVOb7x8J7+vqfUm/stgkfu4ti18jQRzcjaWpEcnHBi9xGL7ErZoAYGrHCl7/lODivkmDZBVwMFCuMkozpbqF+dPnWjSSZvz98+pHpMA6el5zplau8xB7KZzIYlmBF31uy8OHC0GcOp5v2dn2N6oBFjKvajEeLNT9JJppf0Un3Lb4AGUHR2gEvD2OJMCbiJpS2E+sZRNx2w1QGL8IJPNXbwMXbmPDGWZLyOUsUDUN8qlf35LeA23DWwjqFMRbJDK7UDWsEdKb8NUDqZT/zqMidjwh6PSxJ32aEV37B3GYdWkSEtCeK9Lk1vDIoODAdsSBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6486002)(6916009)(1076003)(8936002)(508600001)(54906003)(5660300002)(316002)(186003)(33716001)(44832011)(71200400001)(6512007)(9686003)(91956017)(26005)(4326008)(122000001)(83380400001)(3716004)(6506007)(38070700005)(38100700002)(86362001)(76116006)(66476007)(66946007)(64756008)(66446008)(66556008)(2906002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PU76qCpsfPRKSOVdbDkSQ8io2P8BoiN70sPmiQ/qimwTrg1kSzpsJs5verhM?=
 =?us-ascii?Q?hLm9jqxFu/1eBMc5bbQtR+5ULWBI3STkuzjEfeBKEOI7aeH9edumyLlcO0hi?=
 =?us-ascii?Q?qOmJ2dXtQjXXanfrBin6/r8LdLwefugx/8Zl9mPAYbW+X4rpQRpmNr0RwuMo?=
 =?us-ascii?Q?BgjvM5oaz5Sn/AYqxxXzI5gDnl2T2KI9eYgYPVzEz7Fl/Cc+Q9qbhat6wgj2?=
 =?us-ascii?Q?6htw5KR6mTcwcN3QVLvTRgX4BLyQobd7RhWQGALKQxBxIBPIpc9SVaQpBc1V?=
 =?us-ascii?Q?wspWBKb9dOVziHMq1UvPHIbNwi7M84ZcKEsrrteyhsxSfUebmSMdaBF7WjQS?=
 =?us-ascii?Q?r//Svdjvzxm3kjwwFQUHtHeE38Jw9V0ZEBTtKVTv0XDXkXi+X6AAYwj4MwPw?=
 =?us-ascii?Q?uKZ/F/wsDPhBQVpgPVuGANkPbjRNOwgzuEmUiIWl2fWEsPDCWdLjkAznyz7I?=
 =?us-ascii?Q?prdD82jytiMBbzplMpumLYlozhvNIHvKX8GZZHqDleukLIQPEeRrJOMClcgJ?=
 =?us-ascii?Q?MxbFgYL3wYmndljxEp/u4hXtQj6Ne9P6X6CP6pTgSKaFLO0iWdkgL7Vq0OMj?=
 =?us-ascii?Q?J3B7kNcwwqTkkQMLIVqX0AxmcVDVDocHEcADsc+AHNtnSi4oj4NYc8sypYgy?=
 =?us-ascii?Q?WRNZIZw4LPupzC9gpJiYOR+D/P6cvm5KKeHsXQ0gZlG15U33lwo6lQVzbNnt?=
 =?us-ascii?Q?jP2oXS8Mz+45BK9fOwkeq5blxlOXsg3INpTJbVbEL7m49kPeWXLxuwiVMdyV?=
 =?us-ascii?Q?68bItLU1sW1U3ojp3jTaqJZ8NjsBt/3eGxhQhv67O3yzUIuFpEL2M2VQU2PH?=
 =?us-ascii?Q?iIT7uOk0PTVx8MUZiiEy7Yh8iPlQEng+vp0FmMuObTuNGXddBIeSelWF/2m3?=
 =?us-ascii?Q?OQiVs9PrckKy4ymPtVQy3Sd34u84G0cUFRGYtV3INOpgXSbbw0v0rBoK9WWU?=
 =?us-ascii?Q?VHd6ZBeoQjMV83QZ92ZP4hUVF8xYZN6xD3RzdbnuDeS/0xbE/mYiw+8J5gXy?=
 =?us-ascii?Q?B9ZsMzNKJ0is5cKGLsPKzeDWF6hkTiY9OPiHdKL2jTeoAT9gC3Mt7QF7N6kM?=
 =?us-ascii?Q?9C1aJiI2KCcmaLVSUadf1ZXweVp7VzusJ2YoWGw+Cr8DK88WOMsJ64MpnFiC?=
 =?us-ascii?Q?So8GBJbHbmP1r8HzZmHtNK2AHG7AdRujbcka1G1C+dG5QlLKUT0mkPxJQVLk?=
 =?us-ascii?Q?WVOWUXPRrHG4OML2sIWVzQQ1w+yMH+awNK5bZCucwCqxuzQ9jJaCYNL7bbGj?=
 =?us-ascii?Q?NXOVvvNRiUGZSWW9aFQN8y7jofq21WeG6uQiXnzO2NrdOZaO3dokWC2czlFA?=
 =?us-ascii?Q?ec+8wUwbTqyqkJINDrLoIea3EqnymvZ3lA+4u3joZxdFePzU/YKfhKmqp/GR?=
 =?us-ascii?Q?DemF99MPQxCI41j8CT8RtaVaNQaJnVVvI+4evnUDeh4Ih9KXSXQDW32+ypD0?=
 =?us-ascii?Q?1WOvhUMKxDI4f9SVSd9LMHly9keCh8fSc0nespn7qXHf5MiVGhIew7S2RZXk?=
 =?us-ascii?Q?a9ylc5n8x5uMMdzjj6SWpFsoeuLPlFuDGYA65bF4avinPqebQJcq+LUoMXfK?=
 =?us-ascii?Q?9utl33994sSH89W5pjg69zvzT86xQeRb9g8h+xSfz+3Whoyfe7uZkSsUKcG3?=
 =?us-ascii?Q?7x6fJ7RMXZ0L+atrqmnpbQrjZNoJJMoE0ZE5sxXCd2lhFFNsd3lMNRTBqumv?=
 =?us-ascii?Q?eNO8sgx+MnKW6X9+7BSnljnUyrzLsjgN32dDZQnxBU/CcAMYR6gV7VZepMLC?=
 =?us-ascii?Q?hPQQLtheAiv2ZB1NePKIeEPQGl85qVA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94598193CA7698488D90D75CA430FFBD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012b4c60-bf29-4b98-a70a-08da335d4113
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 14:48:04.2972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U0YzRAHkQZMAD7ygrWq+B+FwXPq9iT9P+xSN4qxCV9tVvVTwuYHRTCSVb3D2bzbJTAodMbRj+u7yd0iby/4Rog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 11:26:12AM +0100, Russell King (Oracle) wrote:
> On Tue, May 10, 2022 at 02:13:42PM +0200, Andrew Lunn wrote:
> > > > As far as i'm aware, the in kernel code always has a netdev for eac=
h
> > > > MAC. Are you talking about the vendor stack?
> > > The coprocessor can be configured both at boot-time and runtime.
> > > During runtime there is a vendor tool "restool" which can create and =
destroy
> > > network interfaces, which the dpaa2 driver knows to discover and bind=
 to.
> >=20
> > There should not be any need to use a vendor tool for mainline. In
> > fact, that is strongly discouraged, since it leads to fragmentation,
> > each device doing its own thing, the user needing to read each vendors
> > user manual, rather than it just being a standard Unix box with
> > interfaces.
>=20
> You're missing the bigger picture.
>=20
> There are two ways to setup the networking on LX2160A - one is via
> DT-like files that are processed by the network firmware, which tells
> it what you want to do with each individual network connection.
>=20
> Then there is a userspace tool that talks to the LX2160A network
> firmware and requests it to configure the network layer - e.g. create
> a network interface to connect to a network connection, or whatever.

Yes, that is correct.
Beside that, the userspace tool is not mandatory by any means. You can
do the necessary setup at boot time.

>=20
> I believe that when using DPDK, one does not want the network
> connections to be associated with Linux network interfaces - but
> don't quote me on that.

Hmm, not exactly true.

Yes, when using DPDK there won't be a typical network interface exported
by the dpaa2-eth driver present upstream. But there is a downstream only
driver will which take care of the phy, pcs, MAC part with phylink's
help so that DPDK can only concentrate on the fast path.

We did this so that we can leverage the phylink integration with DPDK
also, but we are not pushing it to upstream since it's not really clean
to have a netdev just for configuration purposes.

Ioana=
