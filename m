Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EDF2DF52E
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 12:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgLTLO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 06:14:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20860 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727113AbgLTLO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 06:14:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BKBAVpT005614;
        Sun, 20 Dec 2020 03:11:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=SuY0wyrB4++bY2Wa6bim6xAu22PfO4UJyVdL1wv8oMo=;
 b=QTvaGlhaHlxnrK+8XwRDZ+U4nvH7AMMIXC2qzkzdLP9CWzgPqdloYBzrdAM0KKyKSkSh
 wUnsWHg+Yp+QaR0OyRps7vIRp78fxvwS3vGzzPsGdpMuz3YaratPda5l7irIbn7xNa+Z
 cR4ztZLbWm9o56USSHqWjLjuqRw8CBttPuxw1PIf8QYVVgTWDDt8Drqj5dNj588m6ZCs
 AFn5ZL7ULolXqTQq/HeaMVpZneJlb2f3DoFWus9TgRggpS+ttNiDtOHYknlSF5RhbfPN
 ztd8c3IRXHgePZWiJv3KlpqSM4vTQz3vkyphY1AZa8ybQI2iisGvakineuGYt2TnAsae AQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35hfru1wmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Dec 2020 03:11:38 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Dec
 2020 03:11:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 20 Dec 2020 03:11:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvOzzHW7CnOuQAF7yEe6ONrnJH21ZUNNv3B1gMpKf/g4PsA2IVhwMFtNvK35F8vblgwInBRo3a2u/sNvphD20l3PHgroi8WRP6tKOhtAt74GQx2Vy0Y05blXxcv8x2QZ8c95McZcDCdXhxS/wRnBOvyfTXgBUehpKnNR0EimodsYQq/Gg2z0lcv4R8tZLRK4FrLlA3iyT/Lpbs3iOIt7/0T04lNMIkYA1RQXiSiaIEz6GaxZBWWyiRtC1VIU/4mt5dIpihuDRTJtcwaeDaEirauGyaJv2zViMc/2ADeVuzC+NPMNfH3/DfJQsXhclp9sNsZm2ogY87Pm3mrQ+g6zvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuY0wyrB4++bY2Wa6bim6xAu22PfO4UJyVdL1wv8oMo=;
 b=BazBaAxSn12jdkB/3jJIKCTQqUtuaAiGAMaZqbTjc4oEhXt/O/5AiG+xGI8VXVljhQCSSrmGGIvPptw2mHwrIa5t/0YjED6JMRPSWYi2nqkXKpk84c15py5OvTLOIuNNwDjPJBGtmXYKdSl24DFQoVDDSfNITw3dVFS/3le7hzmsOQkPo5dvWhKNc9Yy4t7LPghPPOGkKGimP6TOr8REVZQz6eLA4x3QIDRdtBupPQ0lwxJZ6n5QAOvlfEKlaIoDkH6TT093aKn2OIqLjqUHsgzEcIZuiiST/MgiFlGZ8diDRNppkgE3VdcC/rTDbnVPlKYCvXw52TdHkRQT9HasGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuY0wyrB4++bY2Wa6bim6xAu22PfO4UJyVdL1wv8oMo=;
 b=ESP1QmgAoZxFFk2gD2rJkoZQMpcDuqcVx/HxL+LGD2aEdu1vsrbO/ibksKapBXh+dll8arOp0YqjPBXW/PKsDo8HHZhQ0oXwoM1SC4MDNjf/z6qeKMuP0uNAjlwLjfcz03slBD81YnWWr1mNtEXMP9YE46jjmwOredNchlEV+0E=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR1801MB1950.namprd18.prod.outlook.com (2603:10b6:301:69::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Sun, 20 Dec
 2020 11:11:35 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3676.031; Sun, 20 Dec 2020
 11:11:35 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        Liron Himi <lironh@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse
 flow
Thread-Topic: [EXT] Re: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse
 flow
Thread-Index: AQHW1I7bWzRLWj25WE2No6/WVppXYKn+uXeAgAEdkvA=
Date:   Sun, 20 Dec 2020 11:11:35 +0000
Message-ID: <CO6PR18MB3873C6157D3F89092964B14FB0C10@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608221278-15043-1-git-send-email-stefanc@marvell.com>
 <20201219100345.22d86122@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201219100345.22d86122@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7be7b3e-aef8-473a-742e-08d8a4d803a4
x-ms-traffictypediagnostic: MWHPR1801MB1950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB1950F77B5E0743B040713535B0C10@MWHPR1801MB1950.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sU99iVqExizpL6cQM3YPczXcXozaJRj/aB2hOZB3ositexD/h/lNp+NvNbAJrxkWEXxxqZ6EV+z3BWHrG0hOucW6VohHnSgsvf5gijjjz4iEaV/gDfGB798xVP4WuKq1idjJgfoo19AZkNhNhkVk7iHdATbr+vhdHQwq9P18FhZ/OPHIG4429+pSM94krpxsxFQVFJDk5aPrgc7vJthGzTk3SC/B6LsVhBMdLsRHcC8+lXY2qcHnY5MnMqtmXBFjJsSXG/K3Mpg8UZs/Ff2s3bxGEQmARo42MJ3qs+UOl/NPKA+KSiU3Jf+ZelEyxSuRTUxdIFXaVEBqJdGsXNL3hCdF+dGRYixMb7x47C2gY3xbgvYbAxTxDsWcVxXu+Tb5vR52n8liLNZu5+HFrrr2Y+TLE4c0Q9nZnNPkDpLvxoNxMU0ORR79pBX0IzDRTJfyEkl4HARSgbnWfjMvdunWLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39850400004)(136003)(346002)(5660300002)(966005)(86362001)(8676002)(478600001)(6916009)(7696005)(6506007)(8936002)(66446008)(83380400001)(316002)(9686003)(55016002)(71200400001)(54906003)(66556008)(66476007)(107886003)(2906002)(64756008)(52536014)(33656002)(4326008)(66946007)(26005)(76116006)(186003)(19627235002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6z4iLgz0GZlPcIEGOKbnvbaWvKALVzXRs2N9lGqHFNHVn1E2WN/Xa/SIHOg0?=
 =?us-ascii?Q?VajuF/BrCF/dMEHK5QuqD8CgR//Gl6dE6fdDheU6FfIasdU49P9O5E8Pe+a4?=
 =?us-ascii?Q?LXQ0k1XakRj0jdWLEJai7HUAd8LSAVf/6S0uIJ5vtV7WvZXa5hHdRwjY/H9O?=
 =?us-ascii?Q?qYE1g7YpdAObdzIh+Ovl+8u9Jfcjl/0cAPAC5WtWSFRQTOJeFIXEqhoG/k3d?=
 =?us-ascii?Q?EtP7XfX8xjcyon2xrkKZYvGibrx+1GZAST/aEwRmnVCUwcArxpct6ist3GpB?=
 =?us-ascii?Q?Aiq1xHEhXoW6DihNX7zXeuiDgxz/X3aqqOyNVc18fduPbajsdd+1rETWzx9A?=
 =?us-ascii?Q?PJtPwnV9Z4vfgC1z4hb5WH1KcY9cpkBhLntkidqGdMl79ea0IXa6zbcJDDpd?=
 =?us-ascii?Q?EqCJfTE3Zahn7uMKOhCJKoWfjWOizD95r6WF+j1rPT+3TjpLhN5FJ0QCQeaR?=
 =?us-ascii?Q?7/GG6opTSsb7YF0sCPoIU2lSldPsQpK7UCSKrW3DnhDkSAzLznouD2/IMcnY?=
 =?us-ascii?Q?SAwAdOxJlIoYyDSxP4bdp1oXEIdG6PLTphWNTBAgjEz9CCCRLqBlFbMMNWMJ?=
 =?us-ascii?Q?4cwgR5tf/N1YaaF+G4FSOhguj2yhG/NHq9T7H31zz2u1JlivCPBgaWZnXa+0?=
 =?us-ascii?Q?zjhGjjTDSUq2DqI1bfmYjBLdHDKhaNwbjrQSeZchrU9YLPCIDczRJnG9WJzI?=
 =?us-ascii?Q?tJooRHy/u0H6/6k2w47yc6vOASl2BRyRKCJGAmgg+PNpPtKCjeXqNeP0scF3?=
 =?us-ascii?Q?zud5X5SnN0aszofWF4n8Tcn6m6/V8WHhLA9+TDTAMSnUy9a2yWbzGt8GJ0Wz?=
 =?us-ascii?Q?eamBdqIm/UxcwWpik+ov5QTEDHpoZnnRTCdFBBX3j1zBSpql7g2aHwOOS3eh?=
 =?us-ascii?Q?XxakUuL3tZ59EmFBX6I0rv6Dz44iH8yawi19tu228JaB5PkgMnTndj0O/2RY?=
 =?us-ascii?Q?ELHiFEnSW1TrFOajotwij+8uoGWvrWW2BDm11T/EOCk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7be7b3e-aef8-473a-742e-08d8a4d803a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2020 11:11:35.3178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+OI9GpjLh6x8TJPUvY4j3yZZNToGcnoGyC2VIP1oU9xSSh3vvvcHB0ej0QsvsNMB+KQZd7uUA+w0YVQf9ZSZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1950
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-20_03:2020-12-19,2020-12-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> ----------------------------------------------------------------------
> On Thu, 17 Dec 2020 18:07:58 +0200 stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > Patch didn't fix any issue, just improve parse flow and align ipv4
> > parse flow with ipv6 parse flow.
> >
> > Currently ipv4 kenguru parser first check IP protocol(TCP/UDP) and
> > then destination IP address.
> > Patch introduce reverse ipv4 parse, first destination IP address
> > parsed and only then IP protocol.
> > This would allow extend capability for packet L4 parsing and align
> > ipv4 parsing flow with ipv6.
> >
> > Suggested-by: Liron Himi <lironh@marvell.com>
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
>=20
> This one will need to wait until after the merge window
>=20
> --
>=20
> # Form letter - net-next is closed
>=20
> We have already sent the networking pull request for 5.11 and therefore n=
et-
> next is closed for new drivers, features, code refactoring and optimizati=
ons.
> We are currently accepting bug fixes only.
>=20
> Please repost when net-next reopens after 5.11-rc1 is cut.

OK, Thanks.

> Look out for the announcement on the mailing list or check:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__vger.kernel.org_-
> 7Edavem_net-
> 2Dnext.html&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DDDQ3dKwkTIxKAl
> 6_Bs7GMx4zhJArrXKN2mDMOXGh7lg&m=3D2CcDqbEJMvxpx15rGBe2og6oh1eZ
> hVee8xvK-mjfd0E&s=3Dr1d6bSIPQmjwJqe-
> mkU_s5wyqHOU82D18G6SkVuUg5A&e=3D
>=20
> RFC patches sent for review only are obviously welcome at any time.

If I post RFC patches for review only, should I add some prefix or tag for =
this?
And if all reviewers OK with change(or no comments at all), should I repost=
 this patch again after net-next opened?

Thanks,
Stefan.
