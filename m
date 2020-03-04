Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F60179413
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbgCDPvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:51:15 -0500
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:40318
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgCDPvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 10:51:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmTy0faVQbPQIQ+Uc93GYCrAXMzOxv4z6bFJVSWQ2OTfxPnPTjso6sohUHLilJTUOxjLJIEaepEbReZ2msNKMnIoWl6b4jBVLwUXxL8t10Ltx4JGmgylvR97kHVceXfRZkJT0SPuhb2qjpD/IyJZwAYXDZj/STsjtoTp4kYEyaEW5WdyBMq2VoLm9MHGdGR0xZHGp7L8nWpbkforlKhKpplhRRjNWY4Olvs5CUfHDmeGieG+ZTVIeSpAJDAY2KpMCwoBTw2sPcMR+0+/JGSLcx9UrRRkSFyUmL8hH0mwLMsCyDqVJdeYT52jLrB3ELZTQ9pe7C4K2sQwD6NUgKy0rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBeFW1yG20wPZPdehT1xqOp4uhTWVml3/+s4z/1Y2Vw=;
 b=LtmVF6U22DWplA7sIxjiyQ+eQSGuU0ZoeXGvcDecbP3eIIWj4IYPwLPcx1uEhIMYXgOn/x0GxmwAuGk7x2wiQK6FB4x9ZX5IwuKnSdCAGsJ3n7bBeastJTk3r7x6kVh45qFYT31H7phO62yzCkJluJ20OeGQnrGCxLDlKkLMeGxWNQSHgUtid4ILPS/sReGvtboGPx2ZDTvOx9IOhmQzZ4eUbpWVChucieC4ZgjhdMWd4Ea2iSD1ScZGCXY6JqNjJYSIndB/ICt3SduANp5aGYndhfzk1I/DOac2W0H59p5EomAPvVKIrkCnUI0vtJyF/BVud3itGRs4yQIiSkVWEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBeFW1yG20wPZPdehT1xqOp4uhTWVml3/+s4z/1Y2Vw=;
 b=jVLz4RYpKV3o3PLcWItVizggIbItxgKDCO5tqTo1Nc6I75Gylu/2JgPGlZllgQ9pBfT8oJ9oOcemxJ919LMvQ4c6gIL6aPvyED7ZFar1em8qY5jzHTxE+hjGCWLPVcuys0orNKj2QqydzRYhqTAFfzS+q0bWqNXrbEdng1C+Nbg=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB7001.eurprd04.prod.outlook.com (52.133.243.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Wed, 4 Mar 2020 15:51:09 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 15:51:09 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     David Miller <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 4/4] dpaa_eth: FMan erratum A050385 workaround
Thread-Topic: [PATCH net 4/4] dpaa_eth: FMan erratum A050385 workaround
Thread-Index: AQHV8XQ1jxLNvYe7SU6nAtqZw5H1/Kg3izsAgAEKvhA=
Date:   Wed, 4 Mar 2020 15:51:09 +0000
Message-ID: <DB8PR04MB69853AF43BD3252FF06A57D0ECE50@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1583250939-24645-1-git-send-email-madalin.bucur@oss.nxp.com>
        <1583250939-24645-5-git-send-email-madalin.bucur@oss.nxp.com>
 <20200303.155426.707583465205863443.davem@davemloft.net>
In-Reply-To: <20200303.155426.707583465205863443.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [79.115.171.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cec77265-3846-4e1d-c97e-08d7c053db8b
x-ms-traffictypediagnostic: DB8PR04MB7001:|DB8PR04MB7001:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB700128FBD45DAA4FA30410D6ADE50@DB8PR04MB7001.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(26005)(71200400001)(52536014)(5660300002)(33656002)(8936002)(86362001)(186003)(9686003)(8676002)(81166006)(64756008)(66476007)(66946007)(66556008)(478600001)(7696005)(66446008)(54906003)(76116006)(53546011)(81156014)(6506007)(55016002)(110136005)(4326008)(316002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB7001;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SkW1593UvbzhsADJyvRe9nGdK+zzLcwbHIVY7VDtJ23m3B0nKNWQvHor391I7rjumkDYan583ClQ334NKmZzrCUKSnGK/QL+r4ErJ/tVXDUAmpuZRkhgRvTVQUsTWxz3gcbbenRudWVJvN5Xs65zDhWfPVLOUZ0nBeVG55Nglr44Y8FVYrtSl4weXX7vylBrDe8BB5JM3soGaCMyEDu5XNhechZUMNSU6FzClzpWjkb6JL03PJjORRB+YeL44xPRQlpCZbzMf3sgRtR3bhyzPD4nY6iwngMrODl0wqWri1zI9j5z0e9v51vnpbf8+5bKGTvHqyTjdVrZuGAgIGP3Qp0nvlUh+ykPrjuGUmoDSMhgfUeARrJmvRMFanpPGUaFVam1z5H5cU1tFuAzo7heBIIYuFk+rHORjGYxkKrh6chvG7SdXTxoqnbfHjCft2cI
x-ms-exchange-antispam-messagedata: mRjEFNqjtLAeFJRrhKQqe0EYXPnr0rRUay2TZh2Z36ZC5NMySbvCzae1lBQthlhCKXECFIsPa3WnY7m44BPp8was7XLBgwAYtpXTsAu7zRYupMZ2xs1PUKDKdXiGZ26JuXdGT/pOAfy2l8VDvKd2gA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec77265-3846-4e1d-c97e-08d7c053db8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 15:51:09.3259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5i0m19K3GCmOMmqNbdc3Uha5nv6/Rr5TCX1JfvioJ9grfLYns3AO788kq4qM/Ro+yOwLKm8tJ/9lrIQk3AUUKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, March 4, 2020 1:54 AM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Subject: Re: [PATCH net 4/4] dpaa_eth: FMan erratum A050385 workaround
>=20
> From: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Date: Tue,  3 Mar 2020 17:55:39 +0200
>=20
> > +#define DPAA_FD_DATA_ALIGNMENT  ((fman_has_errata_a050385()) ? \
>=20
> You don't need parenthesis around that fman_has_errata_a050385() call.
>=20
> > +#define dpaa_bp_size(raw_size) ((SKB_WITH_OVERHEAD(raw_size)) & \
>=20
> Similar again for SKB_WITH_OVERHEAD()

I'll send a v2, thanks.
=20
> Also, how often does this errata code trigger on effected platforms and
> what is the performance degradation from that?  I don't see this analysis
> performed anywhere.

To reproduce this issue when the workaround is not applied, one
needs to ensure the FMan DMA transaction queue is already full
when a transaction split occurs so the system must be under high
traffic load (i.e. multiple ports at line rate). After the errata
occurs, the traffic stops. The only SoC impacted by this is the
LS1043A, the other ARM DPAA 1 SoC or the PPC DPAA 1 SoCs do not
have this erratum.

Madalin
