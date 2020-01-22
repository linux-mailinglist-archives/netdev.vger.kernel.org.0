Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA91145931
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVQCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:02:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3668 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgAVQCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:02:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MFkbhX013756;
        Wed, 22 Jan 2020 08:02:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=P7/qdvOXgyhT5/NZ4l03GAV7ndZnqoXBN2i27mJyLqQ=;
 b=DHZFmBsvC896XcvRKxdwNp7DlHnOjjttw8fl/U19QUwgkAMYRqNi5S+6+vFbmPD5rRB3
 wH7SpiJn+4H27qzJJRSmYwW6KpxZ44b1mJygs9AxUNsLwXZtNAhFIH0RynFkY/RfTAPL
 TIPymXu8h/JkWXvjsAbnt2t0ejE1h4FMyR9WFmLAo10U4PyLf5fMP5PFyKHPf5l6BPyL
 VbXl/kf9IFJIfuFCVkR2IO28nXUCqgaeDNq1ixoMYIYr+vxtwZ4wE7eedhQ5jduFGZHT
 hdZh2rMh5mgV3XIVb/d63EsYBfhoeExR4Jb50HoMQY7j+BLASh4j0NhVhMSs/l+CoxOn Sg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dt7n55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 08:02:09 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 08:02:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jan 2020 08:02:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dudm8xNoU4ZPEaJPqUIhGIyu6M+uA/Mlo7yLM1ln4cfywIUFXbntFC9I/r7Vifg2K2dXGGoEtACPGcMYWotUcs4FYfajFVfBx8DegkhfYYFsSsd5ecpfQxFQUHzv3cjlPZ+Ii6+MKd7Bp384cpYZLC2eC0b0YCwETRldGJZsJS2py3r8Io2ytzjv9qrDYTKdfC8ymV90jGgBy0zmHeSW/tEc+vSHiXLm1X7dj15yZJ7zCcynoNFMtyCl1JrRYeK0AD4RegN4SmYyrzAJB3uyJuJtcrGVbrBaufPFRH9g1ktR8rlxDb79olUNa80RyTufimKQ+yOWg2HFE9IXNGfFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7/qdvOXgyhT5/NZ4l03GAV7ndZnqoXBN2i27mJyLqQ=;
 b=SODNnWenimw+9hBwOKgRGlGB078aSUGbsXaiywXQgrmzDgPQjJnAoIn0R61rVlV970LzUi1SWHuSYB/e4eZz+cgeO09CtG9cL8cN1KDLFczy7vLieqWeIRtgicqt5FaSlwf9SAIbIxOtvgjlImJgqP6mi1EDvRXuRtXwDv0vSfJZevPOxZ34dM5wuaWUUNBCGUlE59m2sW8oVE8/R/WnOzJYfY0bqbP00R9E044i3fRDxPmNZ+enHGRPRN0YqzL41aiTYqrQJHtTmUuSHLBjeddIu9vcN9yk7/HRTSnrJCoz9grxSONSuNGAz5E74tC7+mMq632qIkiGbPQuZXGp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7/qdvOXgyhT5/NZ4l03GAV7ndZnqoXBN2i27mJyLqQ=;
 b=qNOLmePpdHExxziMkluEmKpJ2pfgf7hZ8GzmJKAntEHJmO34H49ZZ73yJ/uj4i08ltRri1ZLSUf7iiWL4InN+YdhPtv+qpBj0CDGj+TXPRiqHzMVu5Ol48xhS1N0GFEOcbfRIB7LNA0SnHXMx9p8auM05j6ikr9r9RPQoAJ7sio=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2846.namprd18.prod.outlook.com (20.179.21.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 16:02:06 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 16:02:06 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH net-next 01/14] qed: FW 8.42.2.0 Internal ram offsets
 modifications
Thread-Topic: [PATCH net-next 01/14] qed: FW 8.42.2.0 Internal ram offsets
 modifications
Thread-Index: AQHV0ThXF21HVyUJXEOianVvUfsj2Kf2038AgAAENaA=
Date:   Wed, 22 Jan 2020 16:02:06 +0000
Message-ID: <MN2PR18MB3182AB7FB24C2F4EC9E16B64A10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
        <20200122152627.14903-2-michal.kalderon@marvell.com>
 <20200122074528.670d3d2a@cakuba>
In-Reply-To: <20200122074528.670d3d2a@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bef5947d-4a9b-4289-77e0-08d79f546dc8
x-ms-traffictypediagnostic: MN2PR18MB2846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2846C29D8CDB57C74008F030A10C0@MN2PR18MB2846.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(8936002)(9686003)(6506007)(66946007)(5660300002)(55016002)(316002)(8676002)(2906002)(66476007)(64756008)(54906003)(66556008)(4744005)(7696005)(71200400001)(66446008)(52536014)(33656002)(81156014)(6916009)(81166006)(26005)(478600001)(4326008)(76116006)(86362001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2846;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B7qPSJKItytJ5NpfxwbR4Y/5thv6f5/Dh88o0892pogD4mvJhevpqdKU4SSFB111vVZUVWqaFUe0nsJgVsjSWkeu21DziRihJENmQA64+OQc1DJ30Gfs3aDDfYMYXxE7PVlSCoCtbnQ5qIgmRbCnKB3PE3VtwVXPhyfUeYQFAjdzkMmslUhZbL0VehPkYwemPWshgNGhSaerd5rRUGQPMGuCQOrRTfGHmA5bRLx9XGgSTaQ4dNK97SHWAad1hbdoGznCf5pkdiMVUV5y7IuGGIGWTpZwCjupCbOMok4cb3KlOhNJXxYCxKRNh2RvQ9hiCWisQf3iJ3Ej0iDfxI4rMwMrt0VgZ4nsdo4UWXBd3JUy0WgvUN5EOH382U8xvrs2a1PzNOhRusR2JcgUB/WeHJeaQmZHN3y8WVXIYaeDprGq5+/2y2fgUihizCoLCjJL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bef5947d-4a9b-4289-77e0-08d79f546dc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 16:02:06.2798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mcw196jrCZwTEqwTq4gXRintozhTB/iw33MckAxWxZ05x7w83bL8C5Ui2l1WluZzqGb+xwHGFRxZ6VdJ7kKC7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2846
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Jakub Kicinski
>=20
> On Wed, 22 Jan 2020 17:26:14 +0200, Michal Kalderon wrote:
> > IRO stands for internal RAM offsets. Updating the FW binary produces
> > different iro offsets. This file contains the different values, and a
> > new representation of the values.
> >
> > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
>=20
> If you have different offsets depending on FW build - where is the code t=
hat
> checks the FW version is the one driver expects? At a quick glance you're=
 not
> bumping any numbers in this patch..
The FW version is bumped in patch 0009-qed-FW-8.42.2.0-HSI-Changes.patch an=
d the driver loads
The FW binary according to this version.=20
