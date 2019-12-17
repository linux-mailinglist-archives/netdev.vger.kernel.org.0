Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A88C1222A2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfLQDZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:25:27 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:36833
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfLQDZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 22:25:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChjGrm5B6qXd6a3qW0IWuJLTP1r+pHCK0yblhcOHmKTo/93lURAB/ItQTss4UabzJGNOtPXtyx9Kml1UkjPYvqo0VdOPcfXrQ5LMWGAY65MZSXo9LTeMTxEUmX9i6B8QGrvEdDolqHD/q/QGLS9u+OYiDPG+o0xiZXrr4R1pA4qebTyjs5Nca1wiwQKHw/5Cm1yl0HCMe0C1rkLhuEGeXogna6ZAj+J8zoyUgbCJBJoeLQN0pjK7qMS7ZxVaa+MCM8u2sFrQKevQXal1oxPyOxcZYTkCz0aCfTG1CkjrXwEUMuj4afM3EwqmfcSTu66Yfi9C5rmBmai6zO1QDwmIoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeUs2TGkw9ACil5zKgMZHW266dWyfMni68uSRfILTgc=;
 b=i1MaFrGVYTF7dV36LhPQeRrq1TBD/WtM9N5aJtBWREeCB+Fwz1gxtAlyHEaF//3cT/7QcxpLa9CorfaJIrDbjT95uApIhnmnhz89n+GY+bbjN8t8g83SJk22snluVN2cr6DxN2jv/YAHFYw6ZqGoyLJLOXSfwjVtPxQSp7mrOEFIkU3S8ANrgYYFlZvEqPzIIlBhrAJMJGfXYUtJue4K+ytnXDy5RVKIvDFtJr/uw80GETlmPHn3aqmyZhVaStCVSia1VPEGBdmb8OmYLcgiw+OltM5KY16vjUd21XVFwqLY42xNdp0CQ/1xBk4HqxP6xIXlGKC7fqc0OObjgBJzSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeUs2TGkw9ACil5zKgMZHW266dWyfMni68uSRfILTgc=;
 b=BlcXQcHU2IxuWUqMTztZNjGmk0VD4gABWOSi/SCBoYtxKV2NIeLmnH22n1z7YXpsplZt9SoOfSwRnAgnQ43XXfWPicP8Wru13AgwqTRh37SfuOzBgTQ11zSqCTnEV8UyFnVHVgORUFnBPLkh5ee8mrg/IZffkvWUOhfTVyw0KKc=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2415.eurprd04.prod.outlook.com (10.169.134.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 03:25:23 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b9ca:8e9c:39e6:8d5f]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b9ca:8e9c:39e6:8d5f%7]) with mapi id 15.20.2559.012; Tue, 17 Dec 2019
 03:25:23 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Topic: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Index: AQHVtCYMQFVIeYxyLkSR+ox4Z08Prqe9mZ1ggAANmgCAAANlIA==
Date:   Tue, 17 Dec 2019 03:25:23 +0000
Message-ID: <VI1PR0401MB223794F3A1B1D4ED622A3419F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <1576510350-28660-1-git-send-email-ioana.ciornei@nxp.com>
        <VI1PR0401MB22378203BDAE222A6FDCCD09F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20191216.191204.2265139317972153148.davem@davemloft.net>
In-Reply-To: <20191216.191204.2265139317972153148.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 91ad5c9f-6c5c-433e-cf60-08d782a0c097
x-ms-traffictypediagnostic: VI1PR0401MB2415:|VI1PR0401MB2415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2415DC1D4066767B14C22053F8500@VI1PR0401MB2415.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(199004)(189003)(13464003)(4744005)(66556008)(86362001)(316002)(478600001)(64756008)(66946007)(66446008)(5660300002)(52536014)(6506007)(76116006)(2906002)(26005)(6916009)(186003)(81166006)(8676002)(33656002)(7696005)(8936002)(81156014)(53546011)(4326008)(71200400001)(9686003)(66476007)(54906003)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2415;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZfne8HzmIxlwc/daxy/UUb7DCfBMHT4NbymLP7paGsHoEG4OGnED0RMUQplfoK01WKpqwRyBwym02LEC3ntc8V73rTCU+zm50L9Nrr7C82izZy6pr7ONc3M96t5SpQO1iOLXNgisVFy+6eFZ/Op+g0Wa2gteAzOYx80hZkt+5/Qp37MlwrpU3qxjG2iOoriSOsMFCgWJgEaQSpLgkxktY1AIG18i8JzzWztxTiiMQDHxCl1qsUpU6/SKOUADTmNiLY1Vw9Gs1JosVDaImfXWjVb1zknoNnUALg3GHXFcp26uITsevLSCWSC5A5PTLTKgk/tuWL37qmf6a0UOu2U3k/eow+IMbKr+qpvnrMX/vq+QCMU6DR/9fQJernSHlTdYklsGQHLlzQYJhgZcY9QcoHw0hDQQJwnDGM4yZ1/4Fi+QsvqQRbN6URTIuI2cYEQkIPZbbAciZCD8IntsIGtzVnC8i17O6614yI96A5NZmbY8dCa4LNVNeoCsR+vcMER
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ad5c9f-6c5c-433e-cf60-08d782a0c097
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 03:25:23.1998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lPecIjzAX6WFHbkmD/Uas5dsHn0UDy7v3kjm91GCqyXqNJMH6Bei8cdhQkQf/VPdLJs9W5rVaf8kBAP5jSlg6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2415
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Tuesday, December 17, 2019 11:12 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq I=
RQ
>=20
> From: "Y.b. Lu" <yangbo.lu@nxp.com>
> Date: Tue, 17 Dec 2019 02:24:13 +0000
>=20
> >> -----Original Message-----
> >> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> >> Sent: Monday, December 16, 2019 11:33 PM
> >> To: davem@davemloft.net; netdev@vger.kernel.org
> >> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>
> >> Subject: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IR=
Q
> >
> > [Y.b. Lu] Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
>=20
> Please start your tags on the first column of the line, do not
> add these "[Y.b. Lu] " prefixes as it can confuse automated tools
> that look for the tags.

[Y.b. Lu] Sorry, David. I will remember that :)

Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>

