Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A135B1459FF
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgAVQjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:39:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14578 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgAVQjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:39:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MGGHms000699;
        Wed, 22 Jan 2020 08:39:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=91uvQCkR1PgnUy1IbV1qdmjfgZpLsXRjxYgUQlPtrEs=;
 b=mGkTDXMuuZ1+qsA6nmuWpX+vw/Omm/4MNs2y9rR0aSNL8uNL+7ayLCzntGFPiX5DnlUP
 9XYOSRQqUSmpejmXJPSfb8YQgLY5bi0LCdMgG1nT3RlMTX26TJGVopk1G7eqzjlhrjCe
 ehU+gBjc/UznDax3bMkVpki32cbWwkoCpTkNNfs13so722lIowwI8zzmQrwZXszjA5KB
 axDResHtWYb2xYA5EPdI1IJnSJ0lMrx4a6oUuX2SiaTbxP2HITa1KR8hAGYSN8Bvf3h1
 yyZTZkfUJHrfnOdrpuK7R1cMhJT1Ea9+6LoXWAn/0qKWRQx8ZQSRJOpEGCEKfCjWclgR kA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xpm901fjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 08:39:29 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 08:39:28 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jan 2020 08:39:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+k5SMgWrmkaUq05M/zMg9HQ1pHqNaOZqtCTtVlFfYDeeX1FUyZcd4Y+wFke8+9cMG0TRt8xloXDND6ItYRbi5NIw7tZXE3P+Fnryb6cePqLKK5eODlu/TcfInyJSd+C2ssaBckj0Ge+MJtTExoS+y+StxsZtWvFrh3KZQ+D46UGgYzvAL96C03kb6LQijM75zqYRrLOatsz+I6BNO/jm2m4epIzjlEhTT254HKSTUwRMBHj6MVOMGxkJM4SvA7EiArFXf/AeKUC4NzHWzn/woZmU3w1CoPP1FQJikXOClkExdk1kMCHFGLEJzKTQ2WOvqtQlQSdzL5V+VltfjHr9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91uvQCkR1PgnUy1IbV1qdmjfgZpLsXRjxYgUQlPtrEs=;
 b=mVOV3/QUYQMYATXmIC4g6DjPACnTPXmIco7tRuzrRE1RtZWfMlhAr+Jtg+T3KElkTfD6ANeDfLXhNgMaOVUidYz0Jnoovp+CNYeVIF4j/xHw7EvFX2Bjg4zJcDXOT2GUapCewW0HvYoNevmcoH1kgcjFRmHri5KHiGCPM22M7IWRL2s6cu6oglt7VTjRoK4vhO0LotNSo1lR92SRbNPFOeMn56I4Kw0QMesAo5QJOpQnunN0ej/FKyNWgxOykVd5aWQRuRTniM6NdMu/3bPI7vGDIG4VGJQiyWGF6grZ5stfqZocLU+dCpjNOmo7s5Hgp0LjYgiO652w9Lk2/4jY7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91uvQCkR1PgnUy1IbV1qdmjfgZpLsXRjxYgUQlPtrEs=;
 b=eK3HDutiQu+fK1kS5GznsQcMVgTFCEaaAZL0CDLZbe2s16HHMBPA753JoV16STxEsB02/1QKAxdxLJY58gZeRVJCECsE112mPbdk2z6eYvb423IJFnbXAIokoqcvFlVFpPXFiaRNaAWlh4vwRIXSVgyLwKNGaH4d90JonECSRX8=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3214.namprd18.prod.outlook.com (10.255.236.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 16:39:27 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 16:39:27 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
Thread-Topic: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
Thread-Index: AQHV0ThpJrFvaqxCKkSHPokHVLLx0Kf223CAgAAFkkA=
Date:   Wed, 22 Jan 2020 16:39:26 +0000
Message-ID: <MN2PR18MB31821C711CBB377437F3EECCA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-15-michal.kalderon@marvell.com>
 <20200122161353.GG7018@unreal>
In-Reply-To: <20200122161353.GG7018@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91e7f6ac-f6da-446c-5166-08d79f59a549
x-ms-traffictypediagnostic: MN2PR18MB3214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB321448586946EC3F0BC94042A10C0@MN2PR18MB3214.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(189003)(199004)(2906002)(81166006)(81156014)(8936002)(8676002)(4326008)(86362001)(186003)(33656002)(6506007)(26005)(7696005)(6916009)(64756008)(66946007)(66446008)(76116006)(66556008)(66476007)(478600001)(316002)(54906003)(52536014)(9686003)(71200400001)(55016002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3214;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GemfH8KOcdgu9xm9u3yIRoVWzATqLEA/Wmng+ck+R+sANMZhF6pu0lgWVeBJbHGOXk52P1qZGkyM62LU++2ZfLPLRPCnXf+bB7AM6MKIOcv/PPcZP5MdB7j0FeQoOJx5qbIqqSxlXE++fsJ9TV7BDGlVbeZ4MIZ03tvg7AFMPCtlYRfp+BN53RKqJowNGWlTxd1Imybz/OyIZ9rINFEwz/pS8Ib3CCOlKDq77XWBwGvdnV1nIQBa/fHihYUBmqP7drMmii5JY8ZbfBdw6rxipsMc2KLAa+q62j19Mx2Yvjd+LLg6iK23un7yG8i7xEPkzhvsh2B5xxwYGKyV9anXpTKU6RTTr9MSzHWS9Cytjy/MQRl+JHSGTikEra4stCUdV0KVgo9a7euZJi+WYCX1bI667Zzq02SoUtTspV74IJ26vTDE4BXmAbkUf7oUHtkh
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e7f6ac-f6da-446c-5166-08d79f59a549
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 16:39:26.8646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9B+C1EXNzQwCoyMshuiXiP3BaZFYKNBYGkAFUnkqCYP9cAx9C+HAY2dmqNVjfNmW4iB43Bzd9UbFVcjmoxdUKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3214
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, January 22, 2020 6:14 PM
>=20
> ----------------------------------------------------------------------
> On Wed, Jan 22, 2020 at 05:26:27PM +0200, Michal Kalderon wrote:
> > The FW brings along a large set of fixes and features which will be
> > added at a later phase. This is an adaquete point to bump the driver
> version.
> >
> > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
>=20
> We discussed this a lot, those driver version bumps are stupid and have
> nothing close to the reality. Distro kernels are based on some kernel ver=
sion
> with extra patches on top, in RedHat world this "extra"
> is a lot. For them your driver version say nothing. For users who run van=
illa
> kernel, those versions are not relevant too, because running such kernels
> requires knowledge and understanding.
>=20
> You definitely should stop this enterprise cargo cult of "releasing softw=
are"
> by updating versions in non-controlled by you distribution chain.
>=20
> Thanks
Due to past discussions on this topic, qedr driver version was not added an=
d not bumped.
However, customers are used to seeing a driver version for qed/qede=20
We only bump major version changes (37 -> 42)  and not the minor versions a=
nymore.=20
This does give a high-level understanding of the driver supports, helps us =
and the customers.=20

