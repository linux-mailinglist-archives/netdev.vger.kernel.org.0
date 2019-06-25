Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A315655742
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbfFYScl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:32:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36394 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729106AbfFYScl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:32:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PIR2CP009583;
        Tue, 25 Jun 2019 11:32:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=pY+CX/XB9MsqJjNMAElvS2xx2nt3L5hHfaag6Tah4GE=;
 b=y4tmfTg9zHR/VMDZ6KuLF3SC+CmLAzobkcUaFV+rqyOjTLDtrDZjmdkuYS175mwRbg7d
 FB7J/b2MpJkRgch8E1LqgkUX6WR1XpCQJwEgl9eRHY7UZuecxbHLYfXWt5uPVzX6CHd4
 nsW4c+G2e3lEwY0xduLiKD9tF8dUc0Y1UhtCdsouC6iuSaa8lGBWSwimoq+4AdLRDQIm
 AEAUU0v4aCk5tEnpldjXpedxStxT1D1lzSTz9xMwKcLTMmw2j5yEz4veTC9yUKYMM+Y7
 F1xVVRj8A1xKedqop5X6iAXC+ucyEd1PEiLmrX11cnk2KT3h+wrj+Zf6WOlQKftJnKzo ww== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tbpmngqvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 11:32:35 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 25 Jun
 2019 11:32:33 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 25 Jun 2019 11:32:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pY+CX/XB9MsqJjNMAElvS2xx2nt3L5hHfaag6Tah4GE=;
 b=W5w+ruj+1kaRtb6is3kmVI8a1r1X8ydo0cQl0yCGpC5LE0l3V5gLTIGjBdC75PDYM04McCRYi3LDGjXORcWjiKq0TXxrhD+eC5NF8qFpzzTSrtHVaG2/CEOBVDHEwT0x38KqdNafPjBVtWC6HlxqUuqshEK1HfOlA3q6PmY7zTE=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB3004.namprd18.prod.outlook.com (20.179.107.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 18:32:31 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 18:32:31 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        David Miller <davem@davemloft.net>
CC:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 10/16] qlge: Factor out duplicated expression
Thread-Topic: [PATCH net-next 10/16] qlge: Factor out duplicated expression
Thread-Index: AQHVKmHNaYyHKDs7KUm/dsJHMlwK66ass1cg
Date:   Tue, 25 Jun 2019 18:32:31 +0000
Message-ID: <DM6PR18MB26974EE53AF9BC66D9E3F0FEABE30@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-10-bpoirier@suse.com>
 <20190623.105935.2293591576103857913.davem@davemloft.net>
 <20190624075225.GA27959@f1>
In-Reply-To: <20190624075225.GA27959@f1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 099012bb-abf1-4fd8-d9d0-08d6f99b7bf4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB3004;
x-ms-traffictypediagnostic: DM6PR18MB3004:
x-microsoft-antispam-prvs: <DM6PR18MB30042B5607EBDCE0345FB800ABE30@DM6PR18MB3004.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(366004)(396003)(346002)(376002)(39860400002)(13464003)(189003)(199004)(53936002)(14444005)(8936002)(9686003)(55016002)(71200400001)(8676002)(6436002)(25786009)(66446008)(256004)(476003)(52536014)(11346002)(446003)(486006)(5660300002)(81156014)(71190400001)(229853002)(33656002)(76176011)(4326008)(478600001)(81166006)(6246003)(68736007)(3846002)(6116002)(66066001)(26005)(86362001)(76116006)(102836004)(305945005)(73956011)(74316002)(7736002)(99286004)(66946007)(316002)(6506007)(7696005)(110136005)(2906002)(54906003)(53546011)(14454004)(64756008)(66556008)(66476007)(186003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB3004;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YUGMm3oSgbg/Z6dmKNiJiKeZeAOBnKqEsaWP1Th6iNhKuWfHt8l1yIGZChF1Lyw4VrX0U+1DwBubH+a2HtE/teim59pon1RmyXRb7PeGxhy6VTBOsJPQ5lmrC6xd0/7236JdZKFk/BKHQ1zHYGKZjGuUet1pCUP8vZvLhlhQKVeiMKvRQOtNrfcH8lZhtmBqIr00DZfsCAseMCFJG9IjhmjTLKFEdq9Luyuw2wMq+EdgaFOw3CQEbe6UEOGw2OgTQDLWUV/MXYekmiWai3w6oY791buuDc/pbvj6W1/YciqWMgKahJrcSAnS46+rIHgEe/rYBLfzNiXHVsXHSDH3mEViAL1Gi0cG/pH6kCFdQ7UR0dZgxsvhX0nAfitd/XgGU+qoBhBlEu/1Ny6Qie44GJKA/W/xhlplsWPgxO7lw+4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 099012bb-abf1-4fd8-d9d0-08d6f99b7bf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 18:32:31.3085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3004
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Benjamin Poirier
> Sent: Monday, June 24, 2019 1:22 PM
> To: David Miller <davem@davemloft.net>
> Cc: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> NIC-Dev@marvell.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 10/16] qlge: Factor out duplicated expressio=
n
>=20
> On 2019/06/23 10:59, David Miller wrote:
> > From: Benjamin Poirier <bpoirier@suse.com>
> > Date: Mon, 17 Jun 2019 16:48:52 +0900
> >
> > > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> > > ---
> > >  drivers/net/ethernet/qlogic/qlge/qlge.h      |  6 ++++++
> > >  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 18
> > > ++++++------------
> > >  2 files changed, 12 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h
> > > b/drivers/net/ethernet/qlogic/qlge/qlge.h
> > > index 5a4b2520cd2a..0bb7ccdca6a7 100644
> > > --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> > > +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> > > @@ -77,6 +77,12 @@
> > >  #define LSD(x)  ((u32)((u64)(x)))
> > >  #define MSD(x)  ((u32)((((u64)(x)) >> 32)))
> > >
> > > +#define QLGE_FIT16(value) \
> > > +({ \
> > > +	typeof(value) _value =3D value; \
> > > +	(_value) =3D=3D 65536 ? 0 : (u16)(_value); \
> > > +})
> > > +
> >
> > "(u16) 65536" is zero and the range of these values is 0 -- 65536.
> >
> > This whole expression is way overdone.
>=20
> Indeed, I missed that a simple cast is enough :/
>=20
> What I inferred from the presence of that expression though is that in th=
e
> places where it is used, the device interprets a value of 0 as 65536. Man=
ish,
> can you confirm that? As David points out, the expression is useless. A
> comment might not be however.

Yes,  I think it could be simplified to simple cast just.
