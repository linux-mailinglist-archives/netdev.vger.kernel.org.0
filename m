Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDB6F3D62
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKHBWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:22:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725928AbfKHBWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:22:47 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA81JpPm021336;
        Thu, 7 Nov 2019 17:22:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XCK3oYZU9a9nXljPtYzSfWKaEx6p0Afstu3fv9FZuvM=;
 b=FCL7wVHJxfb1SSZt/Jp40/2uVwfNTBp1q2apqodQPF9lQQq7vI7j+ZRg9aDJgz5/E3+6
 kvKNpDwXIA1IC4WrDuy2FNro5HxeP7jTBZBy2sOzUAGDaM30lOqmBgKPLT/jmq/7rnQY
 4eB+7/wYmOAqED3s3EbTKdbqrl8PH7NhQ8Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2w4ujf8w5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 17:22:33 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 17:22:32 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 17:22:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mge5UPST0iQFC/06Q/NQeKfmfQGZ11aVlUQQRbNgvZKiG3rhVB8rS2pp4e85YJwogtTt80f8XPQyfrHjm0YsGMK+fpsgD4ysB7dFjlM2SSsVr1P0u8b/nKTHHOmHXLmAL2WAZ/S9B6Al/IFtJ1ZlA7o3IqwShca0VYCTIauuMDVbtWluNumelbr98O/MgGhN1MPm6w2KKA/bjXN5+snMtcD+ibjyyMhgElNW4wNJBymn2jRLtT2yT574BYm4EPZ9ujaxAwn4MXHxq50LaZsuxafn125o9KkP7JcNL4nSSI80T8ai7k4LMd8PjAjq0IZ8XmPc/IhnlcvSfL7Vp3DlVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCK3oYZU9a9nXljPtYzSfWKaEx6p0Afstu3fv9FZuvM=;
 b=AxKrJKJKh+aYeM7Glgs2M1RhzauPz+od3BFE/XXRhCR1ITlI4W70AfLOOp6Cyl8glpxcO3LGAVX2sRFcyRdlmALersIcTIOzPGLFbpAiHYWimzbALi9o+v0nXCXHtyw8E/QG+b7lq9fjaig18hENfKxntjrmEEaHPEigaynyo7Rl/Z/LgDK2F2yxmzSjdZB+kyqqs3n4Uuigqw0J2vdLg8GcdOD9EGoXAoWLHviz0iwhQJrXg50/CJrLqCblXor7oJpswbgiRVTEZjzEWPCsVS0bcJQbOUvM9qlWkyzgG32FqYK10SkbUvPcmZlyT2BztF1TyBfj6IFq7vImeNnR+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCK3oYZU9a9nXljPtYzSfWKaEx6p0Afstu3fv9FZuvM=;
 b=Rh1ueD30lPDRMPtdOVZ/3Ribb4LuRahiBuBSpPRNhrphFLKYUzwbdSTYiB5kd3bPzSRtQ+cB8I7c3WkVVxUBOBVaXvJEBG1vWqnWKEJLk2cucqVW7tpxuiMAmYDKDMPhaBvJO94mSiGWAzsoymJZ2jlDFObZcGU4IWa/+s+E7bI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1583.namprd15.prod.outlook.com (10.173.235.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 01:22:31 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 01:22:31 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 08/17] selftests/bpf: Add fexit tests for BPF
 trampoline
Thread-Topic: [PATCH v2 bpf-next 08/17] selftests/bpf: Add fexit tests for BPF
 trampoline
Thread-Index: AQHVlS7grtNFSdnr6kWEI01GLTHA+6eAe5oA
Date:   Fri, 8 Nov 2019 01:22:31 +0000
Message-ID: <56A33FC9-7553-4DC2-8BAD-D4A5BEA34806@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-9-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-9-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::b23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36fe0ff0-1210-4493-bf1b-08d763ea20b2
x-ms-traffictypediagnostic: MWHPR15MB1583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB15833DF2F8F9BB3694731B36B37B0@MWHPR15MB1583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(446003)(316002)(33656002)(54906003)(6506007)(53546011)(486006)(5660300002)(305945005)(7736002)(6512007)(76176011)(8936002)(66946007)(76116006)(71200400001)(81166006)(71190400001)(81156014)(36756003)(64756008)(66446008)(66556008)(186003)(4326008)(6246003)(6916009)(6436002)(8676002)(50226002)(2906002)(6486002)(99286004)(229853002)(86362001)(66476007)(25786009)(6116002)(256004)(478600001)(558084003)(14454004)(46003)(11346002)(102836004)(2616005)(476003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1583;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7coqfA+Z39HrMwv3VMyqfoITv4dpMy92zW5nRro0UMstBVsPXeh4T5BIAkLGfY81YylNiYVXP+n+U5fiflLyUpJed/g6tVKHr/s8qr/nSGuSuIsEQFZbIEjRCm6UHh5+yKS5amxYyu/Am8/wtJObsTc3VX+rCkOWHuDIu9STox2BDTXW1Q8wMa+e5G+iqesOAADGiejNbHnCfTdFTXK9Pjj54YGU3gWvgU3480IybkggSiBnbKkjgiUtHRARJ94tVFxRiCatMkRlzYqdfvyyaCkOzSS1FwUnE2nDxB3fivbkmq5cMdec8zn87Sqf6aFXpxNJoS94IdkbTPLSW66n6oLN+cP5CADNlVOltHFOshkw+5JB2PHG+tKZ0Mc1H3k424Weejh1UyZhOhD7QOtBU84rd0gc/AYZMBQL70hejdH3C3cxly1JfhPTHNCCFZHq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FAABBE1E9DA38E44BFB51BAD6C47B197@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 36fe0ff0-1210-4493-bf1b-08d763ea20b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 01:22:31.6197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qf0oxhPxc5UZfmRDdnVc5WCKV1QmgsxxQhv7iZ5n5X7SH36RNyVYsIPFs3eGsTrksDR1QuF79xCGxLE31nGUKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 mlxlogscore=644
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add fexit tests for BPF trampoline that checks kernel functions
> with up to 6 arguments of different sizes and their return values.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
