Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00123149A62
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 12:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbgAZLaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 06:30:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40396 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729317AbgAZLaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 06:30:00 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00QBTtqb028037;
        Sun, 26 Jan 2020 03:29:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=4wamVyEPxOI1wjutJmUJfv9w7/69b/hVup2DGTrP+FA=;
 b=rzaOwu2UKxk9EtD7+gUEuJeDe0tiWwkUV/ZS65tfo5CO6MIZPE+fTyZDQFqgq2cuBQVq
 6oOmXNekdhuTv4WMz5rO+Zo32AZ3lh00/C3dgkbl9kBq57hbFtOcbnfwj3DkoKazgx+f
 3Ys7JuCbOGovzJiFhNaqGW+cqMeTfmhh+olAoGKH2lqidvmkeDm3831bl2CYoyxsftW4
 FXsfjso8x25/ZbunV6+6p7TIGPbwhhfmW0yClmZPne6jRD0RMz1ynRIS9EF/s9Wufvl1
 2NIN127Hrg2RbELm42Run31veBAXolGtfGZol7bv3w4ypGmTtFdmOsXVjat47X1swhyD rQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xrp2su10d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 Jan 2020 03:29:55 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 26 Jan
 2020 03:29:52 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 26 Jan 2020 03:29:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehIvv3flkuYl6XXkB+q/meYhOkkzNiyB9GZC/5vSboZ730r1JdHS/uqGp6/kUsEwi+pEf3pWXG0DZpMC0CKJHCrrwb7ReU8DPN4oL6cPJ0a18Arjgd9xH43pMkvboeISeQelVbcZmYXfZ7esFzX1MZg0Ni9w4ObpuoQ0KAeAOfXAZ51AIuSx5TmaGI7znvPe+YUzJs/GVaFmwsf+JrnOMRwUQ5qBcHcS0qj3LWgnVttkPVJc6t5+xcZbS7PFEEhj40RjMKAKLTHmeE6LVs7XZJNRths2wuoM7MPJrnPlDCvvQahm9+k8G7pt/LjS2rSRq9VlDwB7w9NnJme+FNSBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wamVyEPxOI1wjutJmUJfv9w7/69b/hVup2DGTrP+FA=;
 b=kt8CMnNnNIk6yzwo0U0z3AbrBDXFehpNUCkmKER0PDsSijfYm+jZ+/fjEKDflclWiWOVO5ufe9ZCV3F4fBPLbcu5kNiR8WDS5PlXU0kadIaHWeQtm2IoPcEFatc3IqXN4lYg8agtaHsS5FGduZkl5VSIwPQcZemt312T/T+nQeG9q6YiQgrrvu6GHCV9aUmP3RMmkbHLVL8NOun2U8HFrXDEjqeflCfJUC0dKmr5Zjog6f7jtB5iA06/OSTxdfU+daVjwGrlwK/o0UOBDZZaRcmjbhersVQE0Z+oURpX0djO2NphoNlT324MHliJlYOYo2E/2UDqkPShgd4AVdooYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wamVyEPxOI1wjutJmUJfv9w7/69b/hVup2DGTrP+FA=;
 b=KZ/0rbh4J4NvgNSfkwJ1J22OmxOgK2Dm0xuW/0Fe2Sz6kGvaiIRTEddB7pgvECw9z5pL1J8w/Fvo31fL9qv7FGMRw7FWk1diKnGb6MlI8j716YVRixbrUMd3R+lgshHUgZEfzVUE9DnNayxfiOfayybYR5xWS9ef3dfzPX418cw=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3024.namprd18.prod.outlook.com (20.179.84.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sun, 26 Jan 2020 11:29:50 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::ed5e:f764:4726:6599]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::ed5e:f764:4726:6599%7]) with mapi id 15.20.2665.017; Sun, 26 Jan 2020
 11:29:50 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 00/13] qed*: Utilize FW 8.42.2.0
Thread-Topic: [PATCH v2 net-next 00/13] qed*: Utilize FW 8.42.2.0
Thread-Index: AQHV0dwXnqaSTkldXU2Q/xI2dRpRK6f4ffuAgARVS/A=
Date:   Sun, 26 Jan 2020 11:29:50 +0000
Message-ID: <MN2PR18MB318249831CD5207588443F6EA1080@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
 <20200123091629.0291bbaf@cakuba>
In-Reply-To: <20200123091629.0291bbaf@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.20.23.69]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33f2f4df-3d82-4aea-046d-08d7a2530e7f
x-ms-traffictypediagnostic: MN2PR18MB3024:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3024DCAA4A81E75F4A4DE2D0A1080@MN2PR18MB3024.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02945962BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(39850400004)(396003)(199004)(189003)(26005)(86362001)(186003)(6916009)(52536014)(4326008)(71200400001)(8936002)(81166006)(81156014)(8676002)(5660300002)(7696005)(33656002)(2906002)(66946007)(76116006)(66446008)(64756008)(66556008)(66476007)(55016002)(9686003)(53546011)(6506007)(966005)(478600001)(54906003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3024;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ZK1ejR4T1BztsrvvT8Thqpmh6b6zOLtAUrCSVTunet+Mk9ygOxq5hZ1HdIQB/XhitSVGvhLxSjBNMCkfi05B41XFhifdG6/oy8pVoJRsKaTLSw+5EU0Tg9dg1kVtTypvPuN5N2hy+VDTurVgSDoov54+lcXIKGc6+ppeNq+6XNkCH5jTD4O7ASfFNorEH6+L3PgWd/g9jzGMaTX/M9P2rLZCGftEyhIq1OHvewDHrKKQwDs+wvbERGUX4ZG13TdZp5ucTNScBy/6VWEjJY/cs6f1+9e+mZrL78vBXFQ+rldCoGkvT/20P4JOxsRlrEYEC1bltEen++Be4qHnYUsgWWKwkz80a8odmK71e39MwBDPbRbFAUwL2Zgrk8q5/OKo0nvSym2rxjcZqRr9T0mF5wEE/nLE9LZ+ukFsV1v+EWQAGepMs42KkoOTdUL7GTfMQpSskfm+eMugOGBB3NZfKhqj3mEoahwhHbwMNMjSMY83JupggyphVOSOgSRZ4dfqPjaeUfJBi48hT8U2o0gvg==
x-ms-exchange-antispam-messagedata: LaoqpV59qdVIcSjB9RWKmjji4lxQUSvHpXgyWl4IYLxI6xNNWTSvY3jh1ZsRfJT8VLq1gbsMCOjUO4wXd3NnWw+ZOSVqAH4hdege36j0NyUNAz+6AfihRRABxkRM2Pxn2WSekeuwZQXr53XyLi/d5g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f2f4df-3d82-4aea-046d-08d7a2530e7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2020 11:29:50.3386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkI8MV7nPJKxH4djyi9FGdbeMNQLSk0huipz6pRqQrOEjZUstWmVFP/jc6LWznnxJeZ6rkfcOzSnr+onsn05cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3024
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-25_09:2020-01-24,2020-01-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Jakub Kicinski
> Sent: Thursday, January 23, 2020 7:16 PM
> To: Michal Kalderon <mkalderon@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 net-next 00/13] qed*: Utilize FW 8.42.2.0
>=20
> On Thu, 23 Jan 2020 12:58:23 +0200, Michal Kalderon wrote:
> > Changes from V1
> > ---------------
> > - Remove epoch + kernel version from device debug dump
> > - don't bump driver version
>=20
> But you haven't fixed the fact that in patch 1 you already strat changing
> defines for the new FW version, even though the version is only enforced
> (reportedly) in patch 9?
Right, I'll move the version change to patch #1 in V3.=20

However,  the entire series is required (except a few patches not prefixed =
with FW 8.42.2.0 ) to be
taken to work correctly with the FW.
Our FW is not backward/forward compatible. I have mentioned this in the cov=
er letter, the split into smaller patches and prefix with
FW 8.42.2.0 is to ease review and was done due to previous feedback that it=
 is very difficult to review the FW patches:

https://www.spinics.net/lists/linux-rdma/msg58810.html

I am fine with squashing all the patches that are required to working with =
FW8.42.2.0 into one single patch if that is required and acceptable,
But I believe that would make reviewing the changes more difficult.

Thanks,
Michal

