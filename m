Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF87581F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfGYTkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:40:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39536 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726177AbfGYTkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:40:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6PJeKj2024415;
        Thu, 25 Jul 2019 12:40:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=vni8BkDaWSy1JToRDwJnxuKyQ5Aj69SJRWAHG9ouWsM=;
 b=QbXVTSDvebXPSBz948YOLq0aQShcZRfkqt/lym4GGjk8Kp/lVT31jHclXd1YLXbtFP9x
 9Oq2N4PuOLwwnveA5dEaur21JO8g5AMIn7coR8VuSnomtQZAN9jp+Q0o4RjZIyYflNY0
 P+rKdHZBfuzwR/QzdubHiAmjllJXfHw4DbhBdJ9uy+6Ch6wP6p/O7+2WKaXg3td8nS+i
 SHQ/PZkJ2Gty8biW2x8bcjmYTI2pWt5hL1J+NK+n/UO8ucoyhRzR7izZ/dhvLW3UaXOb
 CAw4J/6LEWfB3ZmfrrTwbf06sNhAPj0Zjfp16ZXdVb6dSUKToJzr7lN/gNE6j/6HLXO1 2Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rk989-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 12:40:42 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 25 Jul
 2019 12:40:41 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 25 Jul 2019 12:40:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1ObnlE0j+hmZVCQssULhhFLFtGTJ0XTJiZZXOmnjBBm5bXRb85AlkaNH8++GYnAMatuDVCpzRLRCuKkc+Ttt71JZIRvE88X+UIOZJY8eDzlRpBvTlYKpXXCRNbG1KId1pV1ev7tI6ZXZJuPUZVMsakBJkSjv2lTnb2wW23UJXPTVd8XXnosji53gFYEl52eX/KTfepyplSJH13HoIpv7ucLLbKZ0i/JnIVUyjEDmeC4EGhLyKKeDgc9aadFqs2qxBwO+WdkcSDnBCqlqtBimpkcjMUsUoB/QlMZGslEJ1jruHlIPd69SZqkqy0Vovmy2lac1QcdPsvgtKgaPd7JbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vni8BkDaWSy1JToRDwJnxuKyQ5Aj69SJRWAHG9ouWsM=;
 b=a/fv2MzQadmySMW5Q3u9k8/btQi2dv79tP06EaaH81yw4XKg1AgU4Nft32AEXda0oTOoBB6rHmgH0FPkkZWAoDyAqxMrhZ/bYPXuqC2yzaAthgmDx24BGtrmXLZaWUJMJ+x43GJxFws3mrUXr2m3ZIadlo0XoLWA3AemMVDo+2ThTOiQY7WTkuMfdAD30Jtd0zNd0w1a+HJ2nnzAUc0JRmVfa1GdcxS1PsBqQdL5LCqa+9pM54kro7VvmMcOGsG3nfKNA2i0OqZEC3lBgfGtDQnZS9d227HPX2XP6rPUL++uEgrPY3b0703VMVxcI0Ty6I+oiJJda81QHeZV6xbg2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vni8BkDaWSy1JToRDwJnxuKyQ5Aj69SJRWAHG9ouWsM=;
 b=pmN/bhZb4fvWhJiVzImfjeVXMBDvBF7b7Sq9CKqpKDP4+il9AiWWkICCbrD2PXNGUgYb5rzKte2ligEAqYvjFjAq6DdfE78+fs+L1I7MqnVDiMlRqCRsrV6g15qAmFwVfBNNIXQq9niol+smLElLc6/VO4R2OfTX7zq4KDgy+ds=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3342.namprd18.prod.outlook.com (10.255.238.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 19:40:40 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 19:40:39 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: RE: [EXT] Re: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell
 overflow recovery mechanism for RDMA
Thread-Topic: [EXT] Re: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell
 overflow recovery mechanism for RDMA
Thread-Index: AQHVNmFEi5cj5CRQsk6/b2TwF5IUvKbbuUsAgAAbfnA=
Date:   Thu, 25 Jul 2019 19:40:39 +0000
Message-ID: <MN2PR18MB31823642A1E8F1F59DD97117A1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190725180148.GA20288@ziepe.ca>
In-Reply-To: <20190725180148.GA20288@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.183.34.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d85ae871-1e4a-44b2-2281-08d71137f94e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3342;
x-ms-traffictypediagnostic: MN2PR18MB3342:
x-microsoft-antispam-prvs: <MN2PR18MB3342EA898FECB119A8688934A1C10@MN2PR18MB3342.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(189003)(199004)(66446008)(25786009)(64756008)(102836004)(66476007)(66946007)(86362001)(26005)(6436002)(5660300002)(52536014)(76116006)(76176011)(66556008)(486006)(81156014)(99286004)(55016002)(4326008)(81166006)(6246003)(14444005)(8936002)(256004)(9686003)(478600001)(53936002)(3846002)(71200400001)(71190400001)(316002)(8676002)(54906003)(2906002)(14454004)(186003)(6916009)(11346002)(476003)(446003)(66066001)(74316002)(6506007)(305945005)(7696005)(7736002)(33656002)(6116002)(68736007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3342;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PuM4xmrIhKj03AEYPek5SdrqCznFxos1tjnhk3c7X3W0qH/KigEYKhRnDLjxfG20P3rvBz+9Nqf5X6Zjwq9TBdHnqYrOlsQHpwiF1h0NLF/VC6UjyPXmu9ZwOkGLX39kb1hQZFTHqMW8dCQhO1/aQhstrP2q1sTTsnRmCaz14pcjTiMXK0yRTaN8uD2nTZBs9OcQ/bIngQ532z46WFHr55h86hMJGCxjuO+1k1MiXyGQWJ2AtWFVwQaEBmvyd2yaXd8vp0I11eaBFm81ebOxENDptZibewx4eVW4jNN0UkqY/OaXQFxUMzDVFlgTQuFUbiz80ojvPzhkyuoVkA2sLDfm+SL7X8KRXXIvOLBa6qEu7foxi9/VtMNhTm4v+d9NVxMfeak2o6V3Lm09xQuNLQBAkS6xe5AC6+OR0rvumEE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d85ae871-1e4a-44b2-2281-08d71137f94e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 19:40:39.8436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3342
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-25_07:2019-07-25,2019-07-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, July 25, 2019 9:02 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Jul 09, 2019 at 05:17:29PM +0300, Michal Kalderon wrote:
> > This patch series uses the doorbell overflow recovery mechanism
> > introduced in commit 36907cd5cd72 ("qed: Add doorbell overflow
> > recovery mechanism") for rdma ( RoCE and iWARP )
> >
> > The first three patches modify the core code to contain helper
> > functions for managing mmap_xa inserting, getting and freeing entries.
> > The code was taken almost as is from the efa driver.
> > There is still an open discussion on whether we should take this even
> > further and make the entire mmap generic. Until a decision is made, I
> > only created the database API and modified the efa and qedr driver to
> > use it. The doorbell recovery code will be based on the common code.
> >
> > Efa driver was compile tested only.
> >
> > rdma-core pull request #493
> >
> > Changes from V5:
> > - Switch between driver dealloc_ucontext and mmap_entries_remove.
> > - No need to verify the key after using the key to load an entry from
> >   the mmap_xa.
> > - Change mmap_free api to pass an 'entry' object.
> > - Add documentation for mmap_free and for newly exported functions.
> > - Fix some extra/missing line breaks.
>=20
> Lets do SIW now as well, it has the same xa scheme copied from EFA
ok
>=20
> Thanks,
> Jason
