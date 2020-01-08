Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258AF134B62
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgAHTRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:17:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64060 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbgAHTRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:17:02 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008JG7rW031035;
        Wed, 8 Jan 2020 11:16:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lPekulZoIs0JxDzNum+dBCbscVCKFiD9pXuwyGBu94g=;
 b=egnaO3CEr38Qj68hIf/MKR4EeoFnTupCfoViI2+8ZoIx9vrC8QRslWRc8nV5nvUGOECj
 eCyNbq/j0AYe8+YhVySnVrmTQxPXnSH9yqDLGWxVOVWRXS7o1JNVS9uwtmSi92hj5l7g
 V452Dq/VrG8FR0o6MUrQZXm+5+z8gdUm67Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xcy1vpprg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 11:16:48 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 11:16:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeX2QkMsRMHBOxBtyInBhB026GkMJZoW8uClKi7HL+Nl7R+090DmrUG8q5ljsFyFWVTeLIMtGZrfbBHRxyDzDOhOKIWiX1LXxzNCcquL3k2XGw+dvLqLpBXnXHRiyj712etM+Qxra+DZ4pAjk3EzEOpiSKNttngO8kXL/DdokKqBTpagYRFQXYC+gsHNxwsUjw/lY6WMsIcht38xoSGSqNlPYCVIhQ7R9em4xz4/MY3kiYMH4xok2HSTOAgbC0aT1CUJyhwpdaft0sWm49O9ZT34m8WR40efFu4k+Dh/xpyOxgf+1QS9so5JRWf+u6GSuB+D7CLCf7zbiSflTRpKWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPekulZoIs0JxDzNum+dBCbscVCKFiD9pXuwyGBu94g=;
 b=YZxn/77hgxTb63kJfgLzQVID6Mn8F11GH/nAvUvCNvkIS/mfD64RSJ1MLHodfzgFzDYtii24ZeYu094Qb5YNDIy1kjz38IxLil1OU6nj3hWjkn0vfyr47LE3/UnXVbPBsEJki6H39uxWLRhAhI1vCY0BhAfSBjEdt8V1FrEF9Lih69NvGw1lgR+sYmGqltEUVasHoNSqppHCHTXv9IpDCN4cWgNx0uISjhvWtzQl9rO9JXhhPdcWnG/BgJvAYfY2OiuLpYpqdSg3L+qa6sekQUMDO8bKYGIRiONufIxyi/erSQEr8bxfohSL0FG/Z+iIInL4IwZm2D5iXqtuRtAWlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPekulZoIs0JxDzNum+dBCbscVCKFiD9pXuwyGBu94g=;
 b=b7gUZvdABQlm8M7pew5p1Zyk2VuBiaN7inPAT4awRmer/1Qn5K9neF9fPBEcGVxRSEXcoHr/j/Z+h5/x93h2YXI0yIKXQtFJNQccpyvBCcoP3oaJIPhr+PPJISxt7h7gdGch+qAgDLcwp8CZAHH9twMGDJuF1S2cWKxIigAxhJ8=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3333.namprd15.prod.outlook.com (20.179.58.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Wed, 8 Jan 2020 19:16:45 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:16:45 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: Add a test for a large global
 function
Thread-Topic: [PATCH bpf-next 5/6] selftests/bpf: Add a test for a large
 global function
Thread-Index: AQHVxfTjbzXi7NA/6kibXmNTdS98SafhJGoA
Date:   Wed, 8 Jan 2020 19:16:45 +0000
Message-ID: <CBF99827-3048-4517-BFE9-0AEE37BA278B@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-6-ast@kernel.org>
In-Reply-To: <20200108072538.3359838-6-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8931a147-db6a-43c5-1ecf-08d7946f4d38
x-ms-traffictypediagnostic: BYAPR15MB3333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33332DC3EA32DEC5AFA5A10DB33E0@BYAPR15MB3333.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(189003)(558084003)(2616005)(54906003)(6916009)(36756003)(71200400001)(2906002)(66476007)(64756008)(66446008)(66556008)(316002)(6512007)(33656002)(6486002)(86362001)(186003)(76116006)(66946007)(91956017)(8676002)(81156014)(8936002)(81166006)(53546011)(6506007)(5660300002)(478600001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3333;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cVMt9wIJOS2VhUy9hNHygk/X4lhpHaYYhrSt3VZxuYZSidgGHzTp2ImbWU1yDVt/AeEa4p9IOzsguZQZUFTPGuDno1n0Lu/r6Jukoi+FsF4uAstMPNVFe6AB0WS5+L+67wkKjn+ptxh78Czd6PeEXVTlJa3POQr8eRkYRLpAbsicY5695JmM0O+nSaaUAgCv8rY+v/6beSQy63YZPuSXp0Fmg9/+XSCJFe8hlayywF1lJnaoiPe77O4bbuSVQ5XyGkmRakDJu5w6nFhjcTmDa33VLROmStQe4PXcK+1ktlG3w6fBRqzf4a1DW0jDys4ESMr3o+ixZOWDzaOrcTUi6xJgyC7NC1VDJ0ZjsxPPmmvWR16NHm02DuGxznuoJyGBkpMU72U5SpsRm0LMV30FgPq8NXXxmMKJDwOQhhBvSC8EBLLACLGxtni7Wb71h51O
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7FA7AC7493F84449AB5E0DD10C705468@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8931a147-db6a-43c5-1ecf-08d7946f4d38
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 19:16:45.2629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLGAMFKUyWAu4ksHRxyNt5KHpUdEBVgQkwJgOYWy1y7ThsV0O4B6+yWPvL1z3XvQUi5SrhSzsEZs0f7hKUN8mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3333
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=687
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> test results:
> pyperf50 with always_inlined the same function five times: processed 4637=
8 insns
> pyperf50 with global function: processed 6102 insns
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>=
