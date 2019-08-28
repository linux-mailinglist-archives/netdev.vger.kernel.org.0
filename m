Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C524A0346
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfH1Nbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 09:31:48 -0400
Received: from mail-eopbgr20088.outbound.protection.outlook.com ([40.107.2.88]:63975
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbfH1Nbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 09:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOH+ypsLpwZ6lUE8CKOsNpeKzgh9lIbEO66bJdVnUDd5bRHx9QyIkJ/3bKcjBSoKYKgbE4gSqIprhc5kzwNHGcfF0HxutWmuBKrgh+23n8T75oTZXr6F+0+mv5tVsXLc3mzDAjWLBFu4Fnvnov1HjeCCRoQiamERRm+BIQmDiq/LZkrD5J7TDeMNUB7IfbEhWzIBTb0sjJ0xuUUJZop+fyymZj9Fnqh+B/vAM7vuGPs6R9j/F679Z0mf40VqjtLhBs/I6niiut8wkDMMeb30LCuFSeXrrIg7tZ6SzMsk6jt+EXhdk2usrFlzueeyK8gE88lcC0PyEQid24T1lV1IYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKpbzsPO+WR9BBrPQu60pNonV5EFtMrsTnHgTwg/aDI=;
 b=oP3RenHphUyHsdCs5cQ1L6PF7SgIDCyjKaTuRxjO6ohngopLuLjK82rk/rfLQxDhSrBdRCE4Ui31Eh0aV2Ok0jmeXk/wh0E0M8vqtmWZsdG7cpuI62HTaVVNe00QQq2IKHVcfE/Cwb2pB/aIuRnRs016eaA0ChCR83ouZX0T4S36DAh2K5eHGufMwvU9NOZGiIsxu79wMcnj+0n0Z4Qa2MFyhKAaGemlDSPXc6PnxoHo+m1eBwpxMXONImKMv2sScrCn+0E18phEou9dDEQm2y1I2Zaern/127BV6iaAx0V9c0DQGeSy9IuB8vodGxhzdKvCCvgHKZNJqXdpOxZJOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKpbzsPO+WR9BBrPQu60pNonV5EFtMrsTnHgTwg/aDI=;
 b=Ks+EBwzlUOPxvXr+1Bgj1HpdtCKahB4VSzfdjRCJ2m/LrT7hnFkQMXS6TL5GWS3Q3rBjkfIbBtSyp/UtM5+VHJfLC+M9mH1cgCk8Dt0rG/6mGKAYxCW+HmxX96iumAhbfPSATXDQybaKl5hmfuXskLRfpZBxkbIGiW8guXfxP1U=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.176.215.215) by
 AM0PR04MB5457.eurprd04.prod.outlook.com (20.178.113.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 13:31:44 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::7c59:27fe:bf98:9ca1]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::7c59:27fe:bf98:9ca1%3]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 13:31:44 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
Thread-Topic: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
Thread-Index: AQHVXOHwEnzATQvhVUKWTCVk21Za6KcPoo4AgACY1LCAADkVAIAAF99w
Date:   Wed, 28 Aug 2019 13:31:44 +0000
Message-ID: <AM0PR04MB49941CE95847B94EAB1E2E3694A30@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
 <1566915351-32075-3-git-send-email-ruxandra.radulescu@nxp.com>
 <20190827232132.GD26248@lunn.ch>
 <AM0PR04MB499496AC09FD7BE58AE7B9C394A30@AM0PR04MB4994.eurprd04.prod.outlook.com>
 <20190828115250.GA32178@lunn.ch>
In-Reply-To: <20190828115250.GA32178@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [82.144.34.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 457fc559-2aca-4dec-072d-08d72bbc11a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB5457;
x-ms-traffictypediagnostic: AM0PR04MB5457:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5457068835E5AAB331E8C00194A30@AM0PR04MB5457.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(13464003)(14454004)(476003)(76116006)(229853002)(64756008)(66446008)(11346002)(66556008)(66476007)(66066001)(256004)(14444005)(478600001)(6916009)(33656002)(66946007)(55016002)(966005)(4326008)(186003)(6116002)(3846002)(52536014)(6246003)(486006)(5660300002)(54906003)(26005)(316002)(7696005)(53936002)(71190400001)(71200400001)(2906002)(6436002)(6306002)(7736002)(446003)(81166006)(81156014)(8676002)(86362001)(99286004)(8936002)(6506007)(76176011)(25786009)(9686003)(74316002)(102836004)(305945005)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5457;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hgq4S37xi5QNx4ics8S/uSnuU1OVp1pipWZoHCzYfbee/j9FsvQWFXQz5CpoWNiahAqolfKDBNLdGfvSHFp4f05+lvD58/9nSxKB7yiLtmyqiDIK6GTtZByqPirpHZne6ezfJuEGHLwXs9RXM04J2tEbl5uuYYnvqel20Me2PD/vh0+fxGcLVqTbF4fVdn9kaMeaOGFk97Pd7575LjRBUktqfa7xgfE88kpxLiA62Xoc3VPi0QHX+3LCJ2PFUMrtN4SlmN9HecJ2ht7xV+xEX0tRSnIs3lN9zYnCtGHAMiyEr4B5f6bL/+kGc/HfzTQ37H1Clwv/EW1Qew9drY6TFYeR5Xm+QLKDNxew5PVy7POY7KQ5a/s+wSm5xgyilfVlqAnApJlDemKPERuXL3LSeK9uWcmMin3AEiX+9QC7FnI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457fc559-2aca-4dec-072d-08d72bbc11a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 13:31:44.5850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nP2vzFYiIc8/F48Qk4qlYtkncJ57sMXO6uqSwcs0vfsxu+JbirBIGqXqBPq5ZSjHRV96utcgLDK3mRu1Ij+K9tXcHgGIisLU+eLLOrx1p9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5457
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, August 28, 2019 2:53 PM
> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Ioana Ciornei
> <ioana.ciornei@nxp.com>
> Subject: Re: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
>=20
> > Clearing the ASYM_PAUSE flag only means we tell the firmware we want
> > both Rx and Tx pause to be enabled in the beginning. User can still set
> > an asymmetric config (i.e. only Rx pause or only Tx pause to be enabled=
)
> > if needed.
> >
> > The truth table is like this:
> >
> > PAUSE | ASYM_PAUSE | Rx pause | Tx pause
> > ----------------------------------------
> >   0   |     0      | disabled | disabled
> >   0   |     1      | disabled | enabled
> >   1   |     0      | enabled  | enabled
> >   1   |     1      | enabled  | disabled
>=20
> Hi Ioana
>=20
> Ah, that is not intuitive. Please add a comment, and maybe this table
> to the commit message.

I think firmware tried to mirror the ASM_DIR bit (see
http://www.ieee802.org/3/z/public/presentations/nov1996/asym.pdf),
but I agree it's not really user friendly. Will add comment in v3.

Thanks,
Ioana



