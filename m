Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17341E92A5
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgE3Qer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:34:47 -0400
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:16224
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728797AbgE3Qer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 12:34:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rse2jaPk55Go1qxEZrrq88ntg3H7KXAY5oQD23oc+Ku5z/zqxqeblb+p0wWJIjcLu5rPoFa4A07bANBOoDtA0N0FeU01H1IE/gVAjxQODuS7EfuuPIHdntUmAgwvEefA8j0QBBX6UR1mYByz9+gzxyluNwLzAnijB6MqqT15Hmyno3vtNm/uFp3WqmQxhwbowJgg0TZEVTMej/h7fpNReRK+W8lS4MCuk/ELyBKZpxvQoqV++6Luvk0eb5BIJV5TvZnxvlRV300g6m9OLfvHZ7whQbY89z8DeCIk2bVn6YsEAyY1VGveZ29g0kHCCJLoQWsZwVRYmTRavc0uz8fvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4PpwPgowBvVYmhgXrJK3MzATSpd8em4+6wRp4Q2Yzo=;
 b=adffbM+ZECngSz17VaKTCQ/VX6rusKhvWtKZs/g1n3xRA4r4ay2/tTiANobOK0R/qrZnyxcVnR5NUFGk4LDdtgT5o39ZxvEmKA93y0Vy55IGhPaUnuSCWgXh1GvhCKyqCvoKGPv4F8D1TOjOHXc2eaujbo7gyvSUWaFTjP5o81mNQIhlGUcqy1fyW433V9tfsyN1bbis3/Swl1ydRRWVRnpllqRJPH5Gby1iP1eX8X3E5q/G08yBvnQPn9JpcbT/333pix7wxER5b+IhS+HF6c1SQj1YoVHaBcAu0/1i/+olEo2L86XJzDOLl6KFzYZr5jXTd4zEVCxu+z1MvFYdCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4PpwPgowBvVYmhgXrJK3MzATSpd8em4+6wRp4Q2Yzo=;
 b=Xg9qyh3bVMzOoA3CKbevjfqO6Y0RmLMIITlsj+oMecfXBB0ehSx0t72gfNCpsEUJLvbzGRR83FWkqqko6wV5cdjKDUjnbwY5k5RrBDNsGbwrI8VH66E6JbXrTIZR79lQ0fkX3GcVWDHOCqu8/jbCiRGqsnrAMFvdbsKwbBGuRwc=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2928.eurprd04.prod.outlook.com
 (2603:10a6:800:b8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 16:34:42 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 16:34:42 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Thread-Topic: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Thread-Index: AQHWNeDcv8exh059skO/bWrzCNqeMqi/kCcAgAAFHJCAAAbLAIAABjnQgAEx2+A=
Date:   Sat, 30 May 2020 16:34:42 +0000
Message-ID: <VI1PR0402MB3871651CF19BD92A69CEF958E08C0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200529174345.27537-1-ioana.ciornei@nxp.com>
        <20200529174345.27537-3-ioana.ciornei@nxp.com>
        <20200529141310.55facd7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <VI1PR0402MB38715651664B9BF2D002DBDDE08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200529145546.0afa3471@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <VI1PR0402MB38715BFD2DAB1A70B1F0F6B8E08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB38715BFD2DAB1A70B1F0F6B8E08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e55ca088-230c-4c76-415b-08d804b75b26
x-ms-traffictypediagnostic: VI1PR0402MB2928:
x-microsoft-antispam-prvs: <VI1PR0402MB292860625219F5F058C79E08E08C0@VI1PR0402MB2928.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UK+PSxTDNuMNbEWNq6MrDPuct101HHpBMH6oinPhUOBeLWSbpBO/s7lhl8KgewMX7qvZbhyN2s6q01AroCol67lCR85bdC8uqzKftVPtU8M9/5iQXsRX3sbnJGYDxaMfpOeXuBDkHppkWsEvn04ke3tok3ECku9BC76CbAyPcbmSlndoN44DFyx+S1vnzaG6fs4ag0p1NT7ncoKndWAWWITAUTTFm+oM31F4fMTkNnVG/s+p9TKmDnKbZrSiCkd/Pi6Cy7j1v/VeyptI6gptuFGrbsdTo+Keg4TyROlYPvmSisyjx3N6Njvt/QnRdb9Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(316002)(5660300002)(2906002)(8676002)(33656002)(55016002)(26005)(44832011)(6506007)(6916009)(52536014)(186003)(478600001)(4326008)(9686003)(71200400001)(66556008)(66946007)(76116006)(66476007)(66446008)(64756008)(86362001)(83380400001)(8936002)(54906003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qhe+mnEIc5mnaGwwdCH6/JZ4HASQJy9Q9Go4cFNdf38dKLM7XzY1ReGpWpdJvakfZomEciC4sXcaG5CaaEbetPUI+Ac7PHnjNjlC7MFTkofsmEHjE22cs2bE86Uc/dpsWEASTmRD2vsy0zc1w7onEW5ZvNk3SOl6oCmltCPpebnGD3FP0hidaTxOHd5+zavA9wg+ouePdA0rLnSFRN81KpuEx5aEgtwkWuu2+AFkMMi8ANnQyNKarxMiO8VLwzqmBhtmjgAsohaDIfC89gsLw55en1ByI25kkwKF+JXquBg/fxFVl4aCnxrfWfzzzYLeqqyg7UnrLd9p5bq9HWIf8nN7e564O4cNKICZy0eUGI2+iogprj+BVCCVlyc93KbIoLXoIFXrCxUOsDa1vK7BpTK/equnMAvmeXT0ww0ajolC9nl6wnkRUsm4tiKUW2buiNxAvX/8VUdGTtHtoai/dwhZ/k37zoaeP1e9akaegDqGCNoqfs/3na8XfsiKFN1o
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55ca088-230c-4c76-415b-08d804b75b26
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 16:34:42.6815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mTLlANzCUN2rA7tT6HBK4kECJHf79vjX9MW8hoq8l6GE148mwB63e/csjR9U6UpHrZguDZK/r5ZMGfu2eriHfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2928
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: RE: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames=
 based
> on VLAN prio
>=20
> > Subject: Re: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress
> > frames based on VLAN prio
> >
> > On Fri, 29 May 2020 21:41:38 +0000 Ioana Ciornei wrote:
> > > > Subject: Re: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress
> > > > frames based on VLAN prio
> > > >
> > > > On Fri, 29 May 2020 20:43:40 +0300 Ioana Ciornei wrote:
> > > > > From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > > > >
> > > > > Configure static ingress classification based on VLAN PCP field.
> > > > > If the DPNI doesn't have enough traffic classes to accommodate
> > > > > all priority levels, the lowest ones end up on TC 0 (default on m=
iss).
> > > > >
> > > > > Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > > ---
> > > > > Changes in v3:
> > > > >  - revert to explicitly cast mask to u16 * to not get into
> > > > >    sparse warnings
> > > >
> > > > Doesn't seem to have worked:
> > > >
> > > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22: warnin=
g:
> > > > incorrect type in assignment (different base types)
> > > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    exp=
ected
> > > > unsigned short [usertype]
> > > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    got
> > restricted
> > > > __be16 [usertype]
> > > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29: warnin=
g:
> > > > incorrect type in assignment (different base types)
> > > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    exp=
ected
> > > > unsigned short [usertype]
> > > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    got
> > restricted
> > > > __be16 [usertype]
> > >
> > > I don't' know what I am missing but I am not seeing these.
> >
> > $ sparse --version
> > 0.6.1
> > $ gcc --version
> > gcc (GCC) 10.0.1 20200504 (prerelease)
> >
> > Build with W=3D1 C=3D1
>=20
> Thanks, after an update of sparse I got these.
>=20
> Fixed locally but I think it's better to wait maybe until my next morning=
 to send a
> new version.. maybe there is any other feedback that's needs to be addres=
sed.
>=20

Sorry to bother you again but what does the 'Awaiting Upstream' state mean?

Ioana
