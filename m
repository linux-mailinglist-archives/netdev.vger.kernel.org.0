Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1EC416520
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbhIWSWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:22:22 -0400
Received: from mail-eopbgr1400137.outbound.protection.outlook.com ([40.107.140.137]:57587
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242679AbhIWSWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:22:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3FEfsOo3Q+6xmuNqFjtPYHqg0xKt4NsAS+liXhRanXIGzxt7Fus1SScnm01NrJGLcktZ8Wz/mHkWbM3rCLplBs0HNpuZ3LbEIokjqGd6WG63RMF7Yup4MmlfaSsaSX2BfjYWGSRAzDY3qX12fE5XPhpYtX+OtANNYxx5vs9Qph2ZvgJhZ2CwqUje4jvmFCqSEGjOlWo5kXL+2i2kCPMLipT4JnJkmhFsEU4UdOqMoUE7htR7Nct6tBRztoHpiAc/OPfwuWZcvUn3zDIyv2ofBEZG/wLJoCNrjyqKqEJG3kx7aBLaKsvLXRC2+sbLIefU7oM4b7GlbGh+SVQxuJixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=r98nBRwKai2kOtDxLr48zSgLpsctbJZFHrel2XeJwOY=;
 b=CHW8f2d3majw67tyI+W1a2xbEjBagHQfnj6itUKysHHSXhSPe6imOOBHj2d54BCmi4D9L8ZQ3w+62B5++q/aFNRI4PxyYRA6Lk9s2jSu2ZxOcFpNkqgONfwUWcHMWxYmhHwxSxbslNMykQSYVjLoCefuNh35vdCLA1j/z8j+d02+bpJ+Ls26PkWahUtp5OkrukeYeh2l0YRNH34SU71W+peaJj6pQqVxzXZ+ExNtf3c7QefjJGwY1wXqQ/do0BQMYp9/6JUmv1lKLnt9GfcCtI16ZosYiOQpYalNr/oQMArziyHDZZnGJMoTI1aPQDljXolUm+NX083KFjTPD5Ieww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r98nBRwKai2kOtDxLr48zSgLpsctbJZFHrel2XeJwOY=;
 b=gbIFnrPuQuHVh8UUu87fzvwqMKG/M3ed2tvQC3d0Z4C+lLv7zxEjuq8g5doU8IFVWeEjMgujI61goP+ygAH/qiPq6MRrJH5Ip4DZailXwQmC14sohwVSVGbLPbhLBgaiJzffuzdqQXH/5imUViDEBCkJ57ZNyDA159gBJhSesiU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4979.jpnprd01.prod.outlook.com (2603:1096:604:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 18:20:38 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 18:20:38 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
Thread-Topic: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
Thread-Index: AQHXsIR6i8xRzRPknU2rkuHPKtaM+auxyTsAgAAE3lCAABnwgIAABInw
Date:   Thu, 23 Sep 2021 18:20:38 +0000
Message-ID: <OS0PR01MB59228BD43B2423B61EF60E6C86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-3-biju.das.jz@bp.renesas.com>
 <e54aa4c9-9438-bd99-559a-6aaa3676d733@omp.ru>
 <OS0PR01MB59228BE53DE8DB7AA491F03F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <2d2760da-8400-c43a-8629-a16e78f79326@omp.ru>
In-Reply-To: <2d2760da-8400-c43a-8629-a16e78f79326@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d470a54-ef63-4099-9a55-08d97ebed829
x-ms-traffictypediagnostic: OSAPR01MB4979:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4979B8959FF9E6B2F2A1038986A39@OSAPR01MB4979.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gW95OzN5knoNi5hI8fv/ppUD79C55XDjUY4bLALNYLvRQ/TsoAzUHYn8UVwMm6gyVYKyHrJPzrKccfBcA/VoOIxvuavCNfklJAT0XsYs34UG69MVF2jjpiM8ZGrxaGCo3iHUuKwlWMsE1rX9YZd2xDI9oV1HKHcDGeUPFrS38vkrPSEM1EFA2mjM887NpeY+KaPZFuSf8Vvcoofh5J+Rb1UFURghZvL8AbwEC4MzmosCKqtIQQXodbNjH/gVZIkrnLmiGOVLwj6d3o5o/IMvt9r/7zJdfRByijdLKIJb+ZGv0i2G3N0w2MV20vEC76moqlv20UWLOWXIbW5n0jbOmBiLlirNbYm9t3h26bWm3LdK86g84eNu8pYNxDVPiy735raG6k2GZ1CLQMo4maOLxrHvcgYmPE6RXFPpVegiqxvlwZapLMFD2kEZRf421zJtVfnACERx+bXUjidC1F5YCN5jyxRX/5ATyCyufsGMpFr9wc1Ya/UdWLhsDqBIXmuIgMQEcXcNjug6+ko+YQY6KNr3WpWFla8bdWAR80xWFTzrqKuO6k33f16JdNrANhsUwEI416nrkm6FLRJlV2LteLF4X0J9MuFunOzIOB6cKdsiTcOWvjo2JKtLlbhdgufFHzwekqFftCs70FVnnz5+q5m1fhLrcy2y+PmIZb5oubgWisS0BH3qGILHykmgatePCJ+12NiRhti5oEvlmBFl70UdXBZEQiQCBwgi0VIiQZEL2JJkjTPDBB1Z7d6Ca/vHIBYO4qnPjMbvmABBJrzAoGmu6aRhf2Ilisg4OOjywR0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(110136005)(8676002)(26005)(107886003)(38100700002)(7696005)(9686003)(33656002)(55016002)(64756008)(8936002)(66446008)(186003)(66476007)(66556008)(83380400001)(52536014)(6506007)(54906003)(66946007)(53546011)(4326008)(76116006)(45080400002)(508600001)(966005)(122000001)(71200400001)(38070700005)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EphAlDrn0nMiY73H2EnoRCG0wWMatg6SjvNirnPytxy8MS+vzGB2v79ExwrN?=
 =?us-ascii?Q?y+FxRBv8kd6oa1C8W5AHOt/NwWzOg6y4i6s2iULBg8DZlVgwztTSAsVBcJvf?=
 =?us-ascii?Q?eYBUG64uf+5cCmuEKcVqDa+fN8aezYCszivjUkgqPmkE2usDOuHNg1laK/gi?=
 =?us-ascii?Q?rO8c5iTUCn8OD9JE5L4ryQq5XviU0Wdu6HbSzxOHefiZtdtwH3tWXW9v9C/t?=
 =?us-ascii?Q?kUDaHnhuJv6uCFLoGZk8U7Dczr+v0mPlvflE5/Rc2u90wZWRnZgjOxRbmYmz?=
 =?us-ascii?Q?W3PwrGmqKyBNilmscsBBkkLQnV3J3K4urwwuI3Q0g7gKkpQGQq/01Xsy/6lI?=
 =?us-ascii?Q?hPguzEZkDrBZfP76RDaf+M8a10xXKF8UY8VkyZiSag0NPdldeEIslGubTger?=
 =?us-ascii?Q?Ddonc27Jg4udAKh6K0bZbpRe3lUOdJvtGvns+Jx8qU3vVxE7CW75aWc7Y/TO?=
 =?us-ascii?Q?FchcmbPr2go2v0vZ0mWafYyqnX8im0rxMSndVCSSEWCGXQ7KvCrLow4+LEFm?=
 =?us-ascii?Q?GCQ5SbcYAGaGwluIPLw5yXnJAyjFG9Ap3vzrreS4L9IurYGBC1aWIWN8KKgr?=
 =?us-ascii?Q?cg/bzGjIbTMy53ynsETBUr+JaV3VlPadYBY8CMVY7SkiVfLp6qEknK8tW09T?=
 =?us-ascii?Q?934NSO2asGHiHoNla5fwQZP61AZ0NUtgJB27WQ29eS+2gcIlPQahKjNo5HMO?=
 =?us-ascii?Q?c6JwNWdGwtJzJ7ukawtfQD5tN4Wj/fpVFVb5BiRZt1CWbLxHLPUzmtsEeApj?=
 =?us-ascii?Q?5128bL/pShSQZrP1ew6i0jpr3KjC/3/82Q/+t0baYUWQXuurVskvexassgZR?=
 =?us-ascii?Q?Ae2pbx8RZDKM27qAqXC0H7+YjeASN2QaYuzmgdMZdSYXwXjEq101iQsy6aPa?=
 =?us-ascii?Q?WQrSPJofevTbeET3tNdJc+OInnGtQH5Ly6xws5oxrA8I19DuRGQbjmsMFoQN?=
 =?us-ascii?Q?Ut4RyrCamc03SfZ90fQIvTKkXCWtJxRuFeI6+TxbmtS9jlunZpujWWu6eiL7?=
 =?us-ascii?Q?l0hYDtiaWV+9lA5epXjp5fkqmjcfD8gGK/xXB95yPEHtDQTkYSJDEtVncLo5?=
 =?us-ascii?Q?SJ4eCrbH4aHhrQ/6P0TgUFYIRsebPWLspXrk0iZokuuLvLLJbjlseb8T0tRL?=
 =?us-ascii?Q?b6+Wx5UHo1B5hhFSR2oV09V0thJulkeg+E2OJzg/s3x206El1LTcHXUyNAHQ?=
 =?us-ascii?Q?r7P6RV56prUqP6IgUZl0B83N6Pne/7tApkA09pX8NMEMUdr64ptTekcnF9zN?=
 =?us-ascii?Q?UNY4hBzspmHt3Q8ZAw+1RlrR0CEdRt7PM+KJG0lpHTjXJETDya/cE5C48gok?=
 =?us-ascii?Q?O3Z8ipnPk/NyxpswEoDXsBBA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d470a54-ef63-4099-9a55-08d97ebed829
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 18:20:38.3295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rX9UwJIKOwtx99nV6DZzwVLCfbmXSBJdvPmeJo6YJtfGCdd+s0AWYXVonUKlbk2pO/onUA0CG0qpNZ+EMtvN5EFVouRh6ihFPuV5f8v1sUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4979
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

> Subject: Re: [RFC/PATCH 02/18] ravb: Rename the variables
> "no_ptp_cfg_active" and "ptp_cfg_active"
>=20
> On 9/23/21 7:35 PM, Biju Das wrote:
>=20
> [...]
> >>> Rename the variable "no_ptp_cfg_active" with "no_gptp" with inverted
> >>> checks and "ptp_cfg_active" with "ccc_gac".
> >>
> >>    That's not exactly rename, no? At least for the 1st case...
> >
> > This is what we agreed as per last discussion[1].
> >
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> > hwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Fpatch%2F2021082507015
> > 4.14336-5-biju.das.jz%40bp.renesas.com%2F&amp;data=3D04%7C01%7Cbiju.das=
.
> > jz%40bp.renesas.com%7Cec41661b87e14f9e810808d97ebbae07%7C53d82571da194
> > 7e49cb4625a166a4a2a%7C0%7C0%7C637680166814248680%7CUnknown%7CTWFpbGZsb
> > 3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > 7C1000&amp;sdata=3Dze0ica0K57exFOSQ9LyMuQ%2FFimvOW4PtH8ETxYJ8o6Y%3D&amp=
;
> > reserved=3D0
>=20
>    Sorry, I've changed my mind about 'no_gpgp' after seeing all the
> checks. I'd like to avoiud the double negations in those checks -- this
> should make the code more clear. My 1st idea (just 'gp[tp') turned out to
> be more practical, sorry about this going back-and-forth. :-<

So Just to confirm the name to be used are "ccc_gac" and "gptp".

Case 1) On R-Car Gen3, gPTP support is active in config mode. (replace "ptp=
_cfg_active" with "ccc_gac")
Case 2) On R-Car Gen2, gPTP support is not active in config mode ( replace =
"no_ptp_cfg_active" with "gptp")
Case 3) RZ/G2L does not support the gPTP feature(if "no_gac" or "gptp" then=
 it falls to case 3).

Regards,
Biju
