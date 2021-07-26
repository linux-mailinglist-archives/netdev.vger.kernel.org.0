Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF83D5A82
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhGZNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:00:54 -0400
Received: from mail-eopbgr1410103.outbound.protection.outlook.com ([40.107.141.103]:6800
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234043AbhGZNAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 09:00:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPeCUwbxnZAlPtfdkz/jT9WOqw2OS4+eM/PPpolhRMD+bX6epBV81Y1tCdT+8JBXsvAldHAABjsizNWPdQbk6jXxwjo7ANrp/jW4/QBAFVoYD8KyqFSuSZRCsWw9GLyo62+mearBCo8p8GuOLIW97xr1MHHLVkho6hO2PZ6vNTERlJXI7CDcX/O/Gm5rnumz+OZIEgTgh8328pg7y9vs1WuDLPUAtCTUcayM6GOwgo9imLRwRlB9ERVbCX+9kEn52KCvUgxyl4H4+IGJd0U/mEPtqAjYAKFl/NxQ21NW0mddDmw6RZEpqL8U8saljDg9DhXGkIAMWuTap6hjS1ErTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4u1PL2wq4KLlubReuJCWqfe7fhaAkUn8LIjPEP74+8=;
 b=iAlNSnSNWyd56jcRD/dXnUtzOfw4qyGf7xKxMSh+800fQN5D3PeTk7lfA6Dht5x/C9G8FE8vVRdd5KRhtF21iz4YSoCfZ9GF1cnKRdNmrSxCQzj6M7SeYVYenHTzL72ocRXCyykVYs1I5O4Grwa29Z7FYVBVRxn3FddXivXjcN7aaQ9mBxGnPRTgnTyvdKf/GXMPyaaHrJPgbwgoqkYVqJI31tuTTkgbPnRq06zo5BSD7iga3E9bb8Glb9VAWRAhsOSogQ/Q6RDIRHh3BzJ5txH8J6+bVmTAKPB+Mk84DHFVvyaicuoKmNhvFTz+SW2Xe+lS29fpLEGo6QsppRBYDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4u1PL2wq4KLlubReuJCWqfe7fhaAkUn8LIjPEP74+8=;
 b=UzUYertY+/VlQyb+eGC7JWnFooJB9NEgMFN+6VRt2/5Po2lCNgH5ZOifRJo7DE4uEWdwBr52LYqL+rRmDLiFO+Nf+nBvuIsc2y1IjkiWOKVEKQ1l160GG5t177UoggF/YdH2sYyCrC/+by4UG6S6Wbmq50GiHnGDoi/nNkXLTPU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6357.jpnprd01.prod.outlook.com (2603:1096:604:102::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Mon, 26 Jul
 2021 13:41:14 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 13:41:14 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next 06/18] ravb: Factorise ptp feature
Thread-Topic: [PATCH net-next 06/18] ravb: Factorise ptp feature
Thread-Index: AQHXfwPcEE3uxo4VyE6TwdT22KqiVqtRDH2AgAPiWDCAAFHeAIAACLGA
Date:   Mon, 26 Jul 2021 13:41:13 +0000
Message-ID: <OS0PR01MB5922CD112A3ADA610B9A7EF386E89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-7-biju.das.jz@bp.renesas.com>
 <bff55135-c801-0a9e-e194-460469688afe@gmail.com>
 <OS0PR01MB5922DF642B0549BFCFCDA77C86E89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <YP6z3i62A9YjyBvj@lunn.ch>
In-Reply-To: <YP6z3i62A9YjyBvj@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5353d2c7-68e7-4400-50d1-08d9503b097d
x-ms-traffictypediagnostic: OS3PR01MB6357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB63573D23CDBB039E1A78AF4286E89@OS3PR01MB6357.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UQ0ljvAaGZRCI1IWBs+jMiMN3mjTM7Ww30M2OV5he7mv8PTPFUPpT/y1Cq3gk82FZl8vze/mmgt+jCue5F/kVXWy7XLdFVvAaZRdyFEi3VS1kpxLgkkhsm86IXN3GNLXgDYvWwBMrOLQHi7PZSA64TCJF5M+cUflbQtP8DFRVAW03QhlmLRDJbhWmSjI6vJUVBzV5Xjg3t3qi8SVC1Rxs6abZ+2fd9+jHhktvenTb2x3WLiZ3INfBlGwoMoASEUCH2FrkSUJXBg4fFUCLOMiwdoo59pOwD7j/xvjoaZI2aNgxV2+Lww5wwvZsFSIe50QCB6j5GWzmEwPJwN1fNmNMJv+rXfo/9eiixbWobJp5N0mKxzt5BeiNeG4iIQeFpVEckKo501BWgpgqraQctgCz05gL+PYhWyRFdc4s5Tz8I7/jcaFtHtR1XxgueFx7AZa2sVm8g+109i+KOs3pxkbYqsbHetm4uCO/o8CIoe5UF0H+HjQ24rDmR2xMc9XKtp3/Ffpyv7ornH/Ba5jqkFaK/EGWPf38dgZyf6Hl8klrgMQLrPRSw/RmZmutKt7s/LrMJ1jMRgf9kAEk5hsfLFH+x1yrQgUCUbDcLMSTZHUUNBjDijKWF6340Qha7I+wgMoZLQQSesmwcso2jXg4BoH+NmnhY0COT5yKzL9YJUcpWZPZBzJVZgpD9x1+tGYyQ0qfYFTfOX0jxac+yXQG17WCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(7696005)(76116006)(38100700002)(66946007)(478600001)(26005)(64756008)(55016002)(66556008)(6916009)(316002)(33656002)(54906003)(9686003)(8936002)(186003)(66446008)(6506007)(66476007)(53546011)(4326008)(7416002)(5660300002)(107886003)(8676002)(83380400001)(71200400001)(122000001)(52536014)(86362001)(2906002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7SPYUYl++B5mntH/RC3MYMX7QNLY1+GcfxAnno61Q6/hEvm+kFpTMKbSDGgd?=
 =?us-ascii?Q?P/6IFzQwFgmcPrbNwFU93WcsbdIOt+AKw6VCPVQDyklzmK2iGbWt7DqVfSIh?=
 =?us-ascii?Q?bxlfYShlxnOsEenRohT5jSlBCe0BZMDLVcRbkFMgp3bny1yJfJrc09EiOdE/?=
 =?us-ascii?Q?DZcnpLwZ13GhOV/f3mjvMCjvimRvDo7HBryLOZKuBhtaFexNWiYSCxkkNEWu?=
 =?us-ascii?Q?EuQNYfMBgQIn2Om+kJZGX1LvcKG1R0lvtbaTd953oqCp922cbs1cld60amIX?=
 =?us-ascii?Q?Hj03i7LiSxgQjkoRpL8/REzmtczwdUajVevDRhhPY7G5mSCanwfNwZsXkULS?=
 =?us-ascii?Q?TeCH3OXRiBW04F8Dv/Ed+3rsf8AtlXvyHv1/r9DIFUZ0u/+aA8fvRXgKz0Ms?=
 =?us-ascii?Q?aZ/ETgHHD1C4ATYnxlwPV65PwclGoOslkg6dMNNZXw16xGa5rtuDzaWGlfuW?=
 =?us-ascii?Q?t5mDgwQTWM3UDy+8whzZU0PZZgC5hF/uE0aGZA6drKMHpSmNDZVcjDk2CQbD?=
 =?us-ascii?Q?oydmz/GuTAn4FWzt9N9da9a34G1xRWcIC/O3YkpuSB7PjlzHBUxLrNkmh4DG?=
 =?us-ascii?Q?8+UEqr4gYiiNpnr9N/P6MRKc9+FQyITp26RORAV91vclXDTb/nxdYSpGvZTB?=
 =?us-ascii?Q?Fx9MknWC2ZUV/ZzTQRPwjryouLWFGeYEoRGRMvINB+Xidk654rP3gY+TfzW4?=
 =?us-ascii?Q?n7DZ4/dZ1HcLpcbsP0rDe7u81DSH8Co5OYIAiWsIolFWtDjLgA/iY3rwBjzQ?=
 =?us-ascii?Q?Yy8Xla8FlUsnexleB1pG+KHyI6LBiiVBm4Wev5u4TuIeqjNWnRZzRgIXb83t?=
 =?us-ascii?Q?3cVw4lO0lz0cWH9FmWZZ4NxiuXoT6fRqpGCnxs2Dumw3oLW5LilPCprvgGgf?=
 =?us-ascii?Q?V6LZtc6F8hp50JLzAQFNTo/aNAEJUmARIPgUJa1BppAzpuTRzq2zN9PuHeho?=
 =?us-ascii?Q?LpP6ZO6kOxEoBZc6OjgELtpJKOZwsE/Sd8BX/XTRCEj+krzimN16ykXu6Qfl?=
 =?us-ascii?Q?mpmwi8zgvmC7x5PPneUT6s8SFZVK9tMnJR3IGG8imuWyFcOslWBt9VkJ8vIq?=
 =?us-ascii?Q?2nUyx+KoyfCrLdPn7g5tst+eNI1f+NeXu62sMkTCt/ojgYLR/dddfLG49wrV?=
 =?us-ascii?Q?CCWjfZ5MRQ8Vkoik3htLJCKLs33MhYfkNLJre0kLHlj6he32lTpvGMeVZXph?=
 =?us-ascii?Q?SvI0Z7xLNCstNEOtNkiygjfj8RW25UD0HALUVQ/VbaZVMfPI8tky1k+iHe4c?=
 =?us-ascii?Q?Asc/v4xWL1tacwW7x4pLoj999LgSiV3yTLcE2TRGIyO9mdLGIMykf2jTGPhH?=
 =?us-ascii?Q?V2FJMaArx4U2G6WzRHWwt12h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5353d2c7-68e7-4400-50d1-08d9503b097d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 13:41:14.0124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /4ngJmSPUDpk+QFpom37VyTYY05St1iWV1rSJK4+XIzpUI++LXkNUzxvKlQaZxiEHX0jowH+Pl8nDXVrXsMZwEfiH5RnhuVWyiNMOUQeL9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6357
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for the feedback.

> Subject: Re: [PATCH net-next 06/18] ravb: Factorise ptp feature
>=20
> On Mon, Jul 26, 2021 at 09:01:29AM +0000, Biju Das wrote:
> > Hi Sergei,
> >
> > Thanks for the feedback.
> >
> > > Subject: Re: [PATCH net-next 06/18] ravb: Factorise ptp feature
> > >
> > > HEllo!
> > >
> > > On 7/22/21 5:13 PM, Biju Das wrote:
> > >
> > > > Gptp is active in CONFIG mode for R-Car Gen3, where as it is not
> > >
> > >    It's gPTP, the manuals say. :-)
> >
> > Ok.
> >
> > >
> > > > active in CONFIG mode for R-Car Gen2. Add feature bits to handle
> > > > both cases.
> > >
> > >    I have no idea why this single diff requires 2 fetaure bits....
> >
> > Basically this is a HW feature.
> >
> > 1) for R-Car Gen3, gPTP is active in config mode (R-Car Gen3)
> > 2) for R-Car Gen2, gPTP is not active in config mode (R-Car Gen2)
> > 3) RZ/G2L does not support ptp feature.
>=20
> This is useful information to put in he commit message. The commit messag=
e
> should answer the question "Why is this change being made?", since what i=
s
> being changed should be obvious from the patch.

OK. will add this in commit description.

Regards,
Biju

>=20
>       Andrew
