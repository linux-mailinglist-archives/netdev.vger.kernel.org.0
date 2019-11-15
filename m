Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3ACFE747
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKOVsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:48:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17528 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbfKOVsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 16:48:11 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFLiWJr032254;
        Fri, 15 Nov 2019 13:47:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7rlFsxIup2fV+K8qyiM9qHHZFKQyWZv2MPNmWCsMEF0=;
 b=ZhWssz1Gonfr0N4SpbpY+tmcnB7eMGZIbBxCNo7UcnQ0OFvXiBunly82BlHNp0FsSI7Y
 jyD7MvGFuufz2sRfGyqXIFsOl++ixg95GfWLhDB0QkqKV2hXSKgmsJaJnK7mDH8Jt4qz
 k4VbwRAvxE9curRFTzfoM8668LfB1qUJgG4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w90t8qwn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Nov 2019 13:47:58 -0800
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 Nov 2019 13:47:57 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 15 Nov 2019 13:47:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1Np2OtCCE6gY5EMzqgWOHP7zFwLG9+uQT+nwcCgV/2RfXTuvrjYRaqBOmUCxv+wjUskUe9JrY1LfVr6qqjaPJLtX8StaEvzJhji6XOoX/fWO4Xc5RMzwuUcTxRp4dhQyjYIobTp3nPfjZFLKHg/CvvGT60ba7hBW2PbefUmFOf+LBVQs8dB2E9P8+nH8ospkYkW/8LeC3/YxgVdrZwei2SOD/mIFbBkGfDcRBSi21BPw137XmeRreOUpj+R60sjxGXai+Sma0pbzkufa6kfWxmZ4ZWXw/hLkAq7sui8ZqkcfCaUX9ZRLQJSx+KHyNlnOZtPNex/SbKzJBFxyz+jIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rlFsxIup2fV+K8qyiM9qHHZFKQyWZv2MPNmWCsMEF0=;
 b=noMdSwu1TDNbNkcHHanb3u2kRs0gR2/k/qDm2sSTX0QI6at2G4ipyuJdS9UC/8aqOzDyZg0eDXKAmmpfeD6Y2e/RZDAj4WzJFO25x4hJCpMT6SHCjl+dbbDo5R5aJw2BVFI/787pohhvGi1eyMjWvuGiQ48bUfNQMxqJuDRT2GZ2PQ6+3uYRHlQECMPoLo/o6KZL8fISyll8Zyik4AR1EhXiWWVLGeeXDiIcfUI8Zxt0eZJ67jGSAb3deOZv77KiEqBiUp3oFpKJLRIBvIbUOoinLnHKGvCRpVC/ywzoQBwoVikGQVe5coUtwcvFKCvNfjpoz4KpoxCVePd1by3IrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rlFsxIup2fV+K8qyiM9qHHZFKQyWZv2MPNmWCsMEF0=;
 b=TgVYOnJO5XgAV0NbncMAQmCYeGmppNWkiwzyt6ci5ToL+De6QUfTSfZ2IR92EHWIaFrTEAQa+xfYz+QJ62QYordcKKMVsFGfbSuggTT9fVmnKexyTbhSkw+zR5NjvYNYoTP2fKa0CSnDagge0t6D1Lh3yprzTCLEgxusGk0bVfo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1214.namprd15.prod.outlook.com (10.175.2.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Fri, 15 Nov 2019 21:47:56 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9%4]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 21:47:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 1/4] bpf: switch bpf_map ref counter to 64bit
 so bpf_map_inc never fails
Thread-Topic: [PATCH v4 bpf-next 1/4] bpf: switch bpf_map ref counter to 64bit
 so bpf_map_inc never fails
Thread-Index: AQHVm2mRVgl7bIo0OEGpB1OHuFn9VKeMxdmA
Date:   Fri, 15 Nov 2019 21:47:56 +0000
Message-ID: <AAF69EA9-C7B3-4EB1-BF5B-556EAB2E4DF1@fb.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-2-andriin@fb.com>
In-Reply-To: <20191115040225.2147245-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:582]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d20dcd89-5b51-4666-b215-08d76a15799a
x-ms-traffictypediagnostic: MWHPR15MB1214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1214CAF8E6B119483E2A68DEB3700@MWHPR15MB1214.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(39860400002)(366004)(199004)(189003)(66476007)(64756008)(186003)(36756003)(305945005)(4744005)(476003)(46003)(99286004)(6862004)(4326008)(6246003)(486006)(81156014)(81166006)(86362001)(25786009)(2616005)(50226002)(11346002)(8676002)(446003)(8936002)(7736002)(102836004)(229853002)(76176011)(478600001)(14454004)(53546011)(71190400001)(6506007)(6486002)(6436002)(71200400001)(316002)(5660300002)(54906003)(37006003)(256004)(6116002)(66946007)(2906002)(6636002)(66556008)(66446008)(76116006)(6512007)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1214;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 46I72UcWvRh6yoMytKnI3Fsy+9yxAoDiSWjE2ayoMumaramo+4ntcS0G8d9q9nlnVY4qfWCtiKF6aXUgT9S00J5a3zKifvgW1W2atIOms3QJpefAvG99l5dY3AQ7bFOKdqxcMIs84GtPAxtUMI2dStsj2ihACZVd74FtViTa9WpqS89FeM9GXf+6Wk9W9tIZdukFfLFt+BIlHzK4eQieNPnC9nHX5VugffLw4b2lShR+X/iXM8egjlYGyZKgFQGF62dk5wzGRiXpTzJ8yzhi6uBg2CgQl+6ZbJTlKukaP8xfeA18dggpCqxgr7D+D38S1VTmHDebjy+7a2DoPVgBOxR2dwOZM/QH5YvFd1dVpSWiAmvm0q5PA7lN9Yew9uZLMfbrvRWVu3G0ZmedcXOkPGt4Q1kBQJxzKDmNPyhXReg+Q+wcjENbB9pL65BSidpX
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C114E9E4EBE1C4FB8C70CA2EC660F42@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d20dcd89-5b51-4666-b215-08d76a15799a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 21:47:56.2033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8aecALGGQ2gR/GVgk129Fx/Z68LZaboA1RNwdgoP05EdQyiDjU9jKzMjoKsQo9VLC8taeBw6fjzmwie+QnOtYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1214
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_07:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=598 phishscore=0
 spamscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 14, 2019, at 8:02 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20

[...]=20

>=20
> This patch, while modifying all users of bpf_map_inc, also cleans up its
> interface to match bpf_map_put with separate operations for bpf_map_inc a=
nd
> bpf_map_inc_with_uref (to match bpf_map_put and bpf_map_put_with_uref,
> respectively). Also, given there are no users of bpf_map_inc_not_zero
> specifying uref=3Dtrue, remove uref flag and default to uref=3Dfalse inte=
rnally.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>=
