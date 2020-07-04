Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFD82143EA
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 05:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGDD7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 23:59:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726501AbgGDD7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 23:59:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0643u5Dv022255;
        Fri, 3 Jul 2020 20:59:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=M9yXmi4rEGs2nWFmG+LUWm36TAtJT6YpbfNcPFiHcaI=;
 b=LN1+svyWvcyHzS2cxAtKLYhEWGcwk7tUm5oibDHJg8l28Ka8ljYEnuylfKcA4IenSvYK
 VRGzOpC5YsL9b8ObOvr4XAOtoqQy7YPJphpeDYQWDerN8nwzKmLXbHpAt/hQuGB6LSYM
 Mz87cFqPdnOPavpxB4sOTR4dAR9NNlTOANInOfmgRpQyEun31gA953rXpWx8MEt/NYne
 rJTf3sj4pIy0lmXzlfrZo1s/MwK7t7utoujYxdICobD0x3Sp2crzm62FkWAX20EYCqMw
 YI2gZHT+cM1qkSOnp/UA7X7zqGzQiP8onTGyzalBLhy9aUksALp/wjDaINkvo9gWaUAy bw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92x7y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 20:59:15 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 20:59:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 3 Jul 2020 20:59:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fV1Np/e1zZvnBjKqxF2/ZJgrmrBIbaBOkfkozS7CR2eF46HCKuOea+fiZDvWbxdceI1WezlD+fiIfg67MHDM1KQPkoa/ubO+vydl9FAg3WYtQ0Xv/XtTsK6xK4u79OA5p3exRbeGwt8mV5q4aq1WTjEDUUDZoxQWrWq+hiWg4aHFzlR1yv6UtZg5QtkCLNAEbAZnyhd7CNEgN5xg9v2G6dgIBpzofA4aImbYjKv/tdiZM2Mir0F8vYyxYXbqkcjE5QibHEEN0vBIgRGVIDERlfz10SBk5j7M0B6yl8RfuUhec+4qUikX89b3yUJhu9TG18yv6tkmW1Zn5ZHKIv5fBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9yXmi4rEGs2nWFmG+LUWm36TAtJT6YpbfNcPFiHcaI=;
 b=Vkc4n/cHkhffrMYOhFQoFYlkqJpCe0ma2NFFR342rd+WLsBYhnMKjVfzTGBghWiqYcbwnUR5Xu5o7nNSR1EaqjYg+ImM5rf4zskbcsxWfnLMmd+H5WMCar1aHvtmsOuzOX1I/oib4JI00uhSz+UkWwGyvuPPuN7X28G9BWqOqd5ossAxl0PGr4jXvR98uWsiYeEaEMzGy5Y8eP1pCuokbiVJNb5JECJGkGbNjFwtABZwHwG+BsRs15128myCF76Ig/YdxfOkTUdXIMb7egrB7WHGb/Pjet9ADBOOmarpMIMXHLmGxV67NG2lbMyDsmsHlawR8XByK7/mlVt58S/LAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9yXmi4rEGs2nWFmG+LUWm36TAtJT6YpbfNcPFiHcaI=;
 b=Hv672yPP9DozNAkrio281y3Op8I8DFceskJgd3kuViHfLue4vv0+l3VRlrTftoju+W0xCdglcAEFBzKgrTXgXFY3z/Ci4VubraxeFWA07uydllpiWzWaqr0izrvtq9IFfOKjAIgCkTfkNskMyVE5Hrjym5TYe39LITq/T8gGKeI=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (2603:10b6:208:a9::22)
 by MN2PR18MB2544.namprd18.prod.outlook.com (2603:10b6:208:109::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Sat, 4 Jul
 2020 03:59:12 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::dcc:95db:afcb:9b1b]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::dcc:95db:afcb:9b1b%7]) with mapi id 15.20.3153.028; Sat, 4 Jul 2020
 03:59:12 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next v2 2/4] bnx2x: Populate database for
 Idlechk tests.
Thread-Topic: [EXT] Re: [PATCH net-next v2 2/4] bnx2x: Populate database for
 Idlechk tests.
Thread-Index: AQHWUTLwA6RSwyHYt0KWJXboD26i1aj2R4mAgAAAMICAAIP7sA==
Date:   Sat, 4 Jul 2020 03:59:12 +0000
Message-ID: <MN2PR18MB25285E70DFA55968920485D2D36B0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
        <1593778190-1818-3-git-send-email-skalluru@marvell.com>
        <20200703.130307.571238079367654965.davem@davemloft.net>
 <20200703.130347.700992704113418218.davem@davemloft.net>
In-Reply-To: <20200703.130347.700992704113418218.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2409:4070:189:5a56:74fb:1b1d:e672:68a3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 401efca7-5764-477f-3248-08d81fce9c8f
x-ms-traffictypediagnostic: MN2PR18MB2544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2544D8645C5BA5FE159BD164D36B0@MN2PR18MB2544.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0454444834
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5OiQP/Xk50HA6i8ARUiMw6FsAMqbr7kXV5KKIzUDayZGeb23ZD7b5/TQH8OSNy8uDC4l8cHE/RgJRUsag/egS/UVWxMO+0RM0HEmZRTQWFzp112CqDAzq5FbpbioLUlxkMuTaEHnnofDUuBhbS0+ysJ0D5lmpLiOHmLYCSBYuvXPYC8vZEI396wU5CrCWT6CaEFcnsDfWRmdbM6amEFgaDQ1yplFxXVXccx5jySEjxoZzyys/sHNJdC4wt50RLC7c86FyDp6oDvawx5S0qRu0gYcF1VNJd69szfp/I2dVkVZI4rV2Cza5/cz04WAnrTBramx9Wt5Am9lqsp9Gq7Nva67Y9dit47Y3e9GWHO6rmtARKpzxqOKv35Nb3EDX028
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2528.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(366004)(396003)(136003)(376002)(346002)(71200400001)(76116006)(52536014)(83380400001)(55016002)(9686003)(86362001)(6916009)(6506007)(66556008)(53546011)(66476007)(66946007)(64756008)(66446008)(7696005)(4326008)(8936002)(316002)(186003)(54906003)(478600001)(8676002)(5660300002)(2906002)(33656002)(107886003)(130980200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: EakvX2+0vYPqlSsI7pkGQlfdTBdrwkkMmWKBtlLkxt8qXYhqmN3BeUUSTbbfRk1m2eYWq/8gj2I3CdDNYTkBza8n0wcMqmKaQmOjq2WeMIeVRtXkTHtRGQsd2QsvYgcasl5hNIHRKHppj/Gi3i+CNgP2nAK3Ix84Uaog+C+XuYnD/StIaDvmQ1OKqC6EnhRhpDiUKdxYBAZSUzm4Gl8e6gHlTM92cOGsXTQv3uMO0x2Q9nABd0UuJ3xXQL8NeY1Ug//foDB5fBRWmL2kYtki8x069DjI1hFBRIfu0a/FNSh2eww/NmNolw2cKj5ESsLr4LUQt9elRdmblNy060+lxTC+7BZASPp62WmOR1Jj0tr5d5DoJkO0IjHkZr7NRO6+pBIyCC+A067HQN5ZA5OZgX0RSg0pZ4ltqYfh4l574Nt/xTarUXIblCw06DoRnXYbkkGzg27xkWohZ5ODx/QKKfLQlgxpBU2Lwk2dO4tCZx1g5oV4oHb5a7S31aydr49Az4IQ+R4QTP1+GN53EEi36U4lnk/vzoOKqqSEMUFcbtbKZgs7kRxU9968jQ+vZMVk
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB2528.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 401efca7-5764-477f-3248-08d81fce9c8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2020 03:59:12.1520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cXX0Ov5FLmIw9Umyx9xrysrLpiY1/8ue8INuUeUbGYLmK63b6nunLo4iIglC7r+K1C8UAuvEXWLMt5/tOYafCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2544
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-04_02:2020-07-02,2020-07-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Saturday, July 4, 2020 1:34 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Igor Russki=
kh
> <irusskikh@marvell.com>; Michal Kalderon <mkalderon@marvell.com>
> Subject: [EXT] Re: [PATCH net-next v2 2/4] bnx2x: Populate database for
> Idlechk tests.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: David Miller <davem@davemloft.net>
> Date: Fri, 03 Jul 2020 13:03:07 -0700 (PDT)
>=20
> > From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Date: Fri, 3 Jul 2020 17:39:48 +0530
> >
> >> +/* struct holding the database of self test checks (registers and
> >> +predicates) */
> >> +/* lines start from 2 since line 1 is heading in csv */ #define
> >> +ST_DB_LINES 468 struct st_record st_database[ST_DB_LINES] =3D {
> >
> > This will introduce a build warning because there is no external
> > declaration for this global variable.
> >
> > A patch series must be fully bisectable, meaning that you can't just
> > add this declaration in a future patch in the series.  It has to be
> > added in the same patch where the symbol is defined.
>=20
> Actually, looking further, it's even worse.
>=20
> You mark it global here, and then mark it static in the next patch.
>=20
> Don't do that please.

Dave, thanks for your review and the inputs. Will add the implementation in=
 a single patch, and provide version 3 of the series.
Sorry for the inconvenience.
