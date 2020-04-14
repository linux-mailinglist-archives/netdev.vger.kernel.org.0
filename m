Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFDC1A7275
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405307AbgDNEU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:20:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48934 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405226AbgDNEU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:20:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03E4CbC0004465;
        Mon, 13 Apr 2020 21:20:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=hdoenCk90BbyfhlOOLaFegUdI20B5pvhQd9onP38hug=;
 b=YQFOhEJKW9dTp9cwUdC0mehLgYF1U9yTOpUEeeLC7H1anxUtgFj6DBONew5r6Ldqm7GY
 5vr+QB2VApK4aPRHqVQbw3CImfAyN7sMQdwFJvkyOr73M0o5mpjJAtZ3P6mAePrtBDhy
 4mODofSfWlhvIzRRGDRtD9NiyHW1J0fWaX7Z9xTBDyO706DVJQ//RfISuQBT8C7eGtUB
 8Vlfbkw5SKTGvs64wPWTqRugbthHyzuMEgTnRMyK5cY9Th8wGWb24Vl8h7PLHoA/Z1kF
 OcwuT9fzlmBOOHL1iu7fVzDGkldrb9+u0byMKBVpZXvootqs1WN+/bPRQQlAwkn6uVXz Gw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30bddkru9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:20:24 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Apr
 2020 21:20:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Apr 2020 21:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdK5hSxgZF0pHI2JMjJ+nHw9Vi4y6FvLQhUhxM64GlpO6yBb2dfDi6IO1hBTC9IT3OXpo4vtXClDXbZiG5soa0j6pNspI91VL4WcauH4m33R3uN3tkJHz4SwV1xy3iveyWRZK4PQ/IZnvTFTIc45DtzzMsblwzBk1vL3t89nyO1phCnNf3bzxquhHlYucu9jfIJdhgA7KTNpAdIEapkFGr2GC6VwTsNSD1g4VyEZF5PHfwvzMnv78Rze83JSHMc9qVBV/HP7/BSqaIPAqYeAxPKsmHaf7aXJ6102NDbPyhIkYzFV8PPnT/aPsyRQZaic6bLMHofhMQOGnDkpTEkxWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdoenCk90BbyfhlOOLaFegUdI20B5pvhQd9onP38hug=;
 b=BaHEYPmfjOgoslvaY9D+mGUrK8neBQh/V2TXzONKyPLGzwUlHXFw7q8e1Ju8mMiDR3ReHe5VOqY96qJXqSdZR+p++Imp31I0XSqXL7cwFEW0VGHoVSHUgKQ3z1sI1HtqDxPyvrpesWYEzyd11PN0SVJIYQM6m6+IfdhemHkEMadSUsEGFaDvyQD3p5GKi82+b9Lo1Bu6GiT5zCOCj3IZ3q+BsiQ1cQuWBBajdPg35QuP9LvpNfFy17FUVxc6JN25XWLa4rSFggOY2/NqzjVjKb08PzE0gGgy6QoVv0s1E+83wg4J9dHBx9vLBv++3MaTntu0GkapOmvtrnqsjnkrWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdoenCk90BbyfhlOOLaFegUdI20B5pvhQd9onP38hug=;
 b=kg4x20TJClRfcgf3RAuzHLBp8T5wRaTRc1jIZaRIvRGqmypv2QmT9Pt7H4j6UxaDM0sllp6/u4t+KiRMPQCAar3oOKC/ZtXHYNIW3A3jnvuxjjWWpcsUKl/cAL5UXEbbCxH/gwBsqA3AncR+OEO3BYdgWvQJww8nnd/atdR2kYc=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB3151.namprd18.prod.outlook.com (2603:10b6:208:16b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23; Tue, 14 Apr
 2020 04:20:21 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 04:20:21 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Javed Hasan <jhasan@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 2/7] qedf: Fix for the deviations from the
 SAM-4 spec.
Thread-Topic: [EXT] Re: [PATCH v3 2/7] qedf: Fix for the deviations from the
 SAM-4 spec.
Thread-Index: AQHWCbDW1AI0SL8PJkKQoOCz8QviWKh346qigAAwvRA=
Date:   Tue, 14 Apr 2020 04:20:20 +0000
Message-ID: <MN2PR18MB25276120040AF0C600B8BC99D2DA0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-3-skashyap@marvell.com> <yq13696vp1y.fsf@oracle.com>
In-Reply-To: <yq13696vp1y.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [45.127.44.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb4d843a-8213-4063-a27c-08d7e02b2553
x-ms-traffictypediagnostic: MN2PR18MB3151:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3151C748984ECD81BD7B2036D2DA0@MN2PR18MB3151.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(33656002)(186003)(76116006)(66476007)(4326008)(9686003)(55016002)(54906003)(478600001)(316002)(81156014)(8676002)(7696005)(2906002)(66556008)(64756008)(5660300002)(66946007)(8936002)(6506007)(66446008)(26005)(52536014)(71200400001)(86362001)(53546011)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1206BkfZnt79mDSHC+Bhkx3Z5I1kfYGrSVeq/lHAaI4JFBK7dRmj5Nz3PA6Jb9cd51nmcmXpPkiI7WNbwhLqAoaJn1r0Q2dX0/04FRNe86FtVUoEBPjDfk5NSwtTPvltri2WSxTyguzr5zZA4KRYn2r1Jvx5flrvVJwGm7gwlDMlFNub+ieNG6C5mIE2+jgML0z5f1Gceo7cXCnjnLs2bS1o+9O1e8z8lVhIkNsShZruziHfvbc0rCwh9LL7wC1i533nKvkYqX9dGk1Kd6dqYrAbaJ0NyN+zDZd/u1taK/91EHYwiME6Lsw2NO/v0wlxN8JdjqiSkIUhcs4kj5BM6yZRQ8SkWLMLP+/io78+atG43ILJW9pcS+T58dBE2LaSYnSTzrUm4TwWbPC56KEe9AsRlOla8+ql+TbBNLu+2kKPIeCG8UPrLnPnwdBFdZFH
x-ms-exchange-antispam-messagedata: tTEdkgw3jgZ419W8YN4lWJ7G7A7p/WIg5NJ0BdFd8ZD5Q+/Ja1r9LUX69lThdcU5xgjyDDMLPbbZYLGnGrGLapfEOem5bAD2eR8u84mNgh0zHzcBUO8dXUc4+Vz4Om9E9jiC6t743bghXveNetU67Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4d843a-8213-4063-a27c-08d7e02b2553
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 04:20:20.9438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5NaO5ZSfCgTBS46PveyOCAvxTGOV5FzkvK0vTlu0LFw2qlbzYFXKF6bUFtDtUE/khHQRa9TXGAqV6v2+b1wrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3151
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_11:2020-04-13,2020-04-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Tuesday, April 14, 2020 6:53 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org; Javed Hasan
> <jhasan@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH v3 2/7] qedf: Fix for the deviations from the S=
AM-4
> spec.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Saurav,
>=20
> This should be 3 patches since there are 3 different functional
> changes.
>=20
> > - Upper limit for retry delay(QEDF_RETRY_DELAY_MAX)
> >   increased from 20 sec to 1 min.
>=20
> > - Log an event/message indicating throttling of I/O
> >   for the target and include scope and retry delay
> >   time returned by the target and the driver enforced delay.
>=20
> > - Synchronizing the update of the fcport->retry_delay_timestamp
> >   between qedf_queuecommand() and qedf_scsi_completion().
>=20
> "Synchronize".
>=20
> Please describe why this needs to be synchronized.

<SK> Sure, Shall I need to submit full patch set again?

Thanks,
~Saurav
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
