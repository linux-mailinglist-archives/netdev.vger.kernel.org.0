Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FAA276359
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIWVvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:51:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgIWVvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:51:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NLokAM000964;
        Wed, 23 Sep 2020 14:50:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RCBIyHZ+e7fOry9uYZ5UGcabKF1D6bUSXTKwgFt4WbY=;
 b=B9X8Hvj7OT3IV8UfUZKTF9BAe+bg6xhexGT66GCRuoBVlaFNj9neXJd0usuAOZeCXu00
 F6hTtc4Q8iC8ZCU5gKUyAqsiB+KdfqCLVTDAHMLK/RN59O2/aITEqLSPCrqzbwtxi4Ee
 lfaNAx/CjZaC1wOC45oONF5chNrKCs6Hl1M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp6p8ja-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 14:50:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 14:50:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3rR8Fjphs6aN7iGP/kD4APFEiOl17Yq/q985ZTphWNWQAlC0F4zbpfidwvxu0XXnKYaMOrSmOHT5cKtdv9WUhAwGRMgpRB83k1tUrZsggS3zomd6bpKaYszWMO6dh3bYh5hhhgAmIb5b3woIyk9oZCBRnfjvgLN5xb27x4ACU5Zn0bKadUrttCniP7u4sqjeEYlAPvi8I4rVuVhURRlIP7FoDOk+2Gb0knSwWYBLcIqbcpki7ykzbrq3I0TgoXnHNiXlMAjyADbBXOEV/V6/xwuVHwCRrSITu9owpgDA5FsLI2I2/jOBLVwh+gjti3xy00dUSbT6OE438iwTZlyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCBIyHZ+e7fOry9uYZ5UGcabKF1D6bUSXTKwgFt4WbY=;
 b=hGEIsDTG75qavCe/mPhmxEMI9YLxVjsrizFZrftEShwEg4faKCoTV27P1yPeYvqzJ5Xstz/lNDoRFkCXJzuswTKDVBdklMZDlrpzZYSVxea1/8z9vj1e+9ukWJ2fuPASXPiWSEEO3SBPvmqEXNnQdsGzokUOyQWYTnjpGQjbXT7ZNB99paz8WsxNgJu98+OQPmkAsP342NTd+VBqILP0vonvu/zHpZfgMrWLlbWoVLY/r8JP/yEdYO7HwS/iCF1ekZqYpiirlg9Av19iIE7AQrjOH0Ye2G0bP5BNlQXm4HsEwYswDkow7zrAr/PMj95uHCau56LTHr1qdU+fBZqfYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCBIyHZ+e7fOry9uYZ5UGcabKF1D6bUSXTKwgFt4WbY=;
 b=NvDjkeoEUB2gWIWy3g3aY62E4Wl9d10dZCjB1SkJsB1/B000BH4FvItn6gdxjyI0vt5rnvi/RYdSjIYrygZgpoTCREfA2erP4s51GbBpHW8r7rymOYVnPPZ3kwTwN9I2Bxr/wyb4x+pDGP9fDVj91W5RdEC98Rw43WIO5EkESy0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Wed, 23 Sep
 2020 21:50:36 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 21:50:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v3 bpf-next 0/3] enable BPF_PROG_TEST_RUN for raw_tp
Thread-Topic: [PATCH v3 bpf-next 0/3] enable BPF_PROG_TEST_RUN for raw_tp
Thread-Index: AQHWkfFCCtsFxzHz2UW7kvY68Z00g6l2wz+A
Date:   Wed, 23 Sep 2020 21:50:36 +0000
Message-ID: <E5742A1C-28F8-423F-8568-1025C9DF4431@fb.com>
References: <20200923213337.3432472-1-songliubraving@fb.com>
In-Reply-To: <20200923213337.3432472-1-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cec2fbbc-b0e5-47eb-bed5-08d8600ab44b
x-ms-traffictypediagnostic: BYAPR15MB2200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB22007BCC6A10C324D55C7C15B3380@BYAPR15MB2200.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0C8NOrAJbDQBweLNZznac1UpA1L0ewq39yBLt5iImxezti4JqyEmG3sJRm+WOJ8vwkduKTb7HIg+BMa3YUOL76D67tB/B187+ueYZEdB2KhZAqtpAz4B8ziWoa5goaT54cw1DuuheH5ZXwhXgPqBDM+KU/QUt9y/yk/+0EXqYWYnW5+9TqaW0cNuMiW+IAwzWYW1IEg2jm7Pl/hpbvr0s9W2bh1ujAzSqnsKTaTbEFYx+IiSh8TMVi+WBdHxthahNr+xHmNMyhWLCcrYpeAWXkjaGgZxG4cchRI+/bUGJSO0S+7j+YBo/S4ZY9Wpt0BGF+SPGza7pBoKeCLNwwyN8wX0OIhO9HRExjMcc/KVvh8ODngu1EjjHmxGfe4+iUCO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(6486002)(36756003)(83380400001)(8936002)(8676002)(33656002)(110136005)(316002)(6512007)(54906003)(186003)(91956017)(2906002)(478600001)(86362001)(53546011)(66946007)(66476007)(64756008)(66446008)(71200400001)(66556008)(76116006)(5660300002)(6506007)(4744005)(2616005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2eUnRla40+7bjl9MkfCiceGkVeDxn3U2NZ8e3iCq8accG6HyuuOjsgWYHM8KeDXGTgC2mPn82cC+YFklNqlU+FHCnl4KZTQmPuMRdn55f3qfDD12T2BJJfbGhwZy9QiYieXlv6jFbmWmXvLW28XBIqTF6GdnFze+4FCaVYFjaoq3WvIJtdrbJ+ZvcXe3uSlLQUugalubdr24UaI8xosSRNs9U3Y0nx5uQHTs++AAxaSE/F2LOm+lL5Ek4p6DjmAXRyNOlaqb8exojTMKkdHkUTRT/ChhCC4Pltm9H17/d3PvGTeCl+CgOliQl9sj5yvHZy9dtsK3VqzXhDM6/tmiXQK1uUha/IcB+MGDfkYihzbXG87qLoq3rXi4SM3pjbqdIz6hd4b7pfEw1YQwPx1s5P9/+sBio7z4UOVeFVdFTcxjgq3R3hT4KYssojDyXBsSg06axOTaTZjExAatcbApsRQc6sahg34KiGs2JhHIl7gV8oZq2/E8bGmuUnR4YmJP7ga4sElB80YSbfLyilxerjng1ugQcuLxqA+YiEjl5uGjfb32DSGspglPhyBgRTxOX4V/UKzx5cJbFJcvHE8METC+bR34vKAn6hC9V9YUY1UZGsF7q85tXh1bacUGvJ57nv0I+yolNw+2fzwWQtlb/GK59qp1PKrWrOQP187J/3tZYDZ0J12GVIe4U87mUEKy
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AFDB2CE0949A1A438AC57E18EA91B328@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec2fbbc-b0e5-47eb-bed5-08d8600ab44b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 21:50:36.2028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nnADnmsqH6Da1mqC71FS1HKODX6FxjLHO7MaXw5VVmvyfeNQL5lnx9XIrDHBwmQ52VL0cK/4FC3/yJMiNglnsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230164
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 2:33 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> This set enables BPF_PROG_TEST_RUN for raw_tracepoint type programs. This
> set also enables running the raw_tp program on a specific CPU. This featu=
re
> can be used by user space to trigger programs that access percpu resource=
s,
> e.g. perf_event, percpu variables.
>=20
> Changes v2 =3D> v3:
> 1. Fix memory leak in the selftest. (Andrii)
> 2. Use __u64 instead of unsigned long long. (Andrii)
>=20
> Changes v1 =3D> v2:
> 1. More checks for retval in the selftest. (John)
> 2. Remove unnecessary goto in bpf_prog_test_run_raw_tp. (John)

I somehow missed Andrii's other comments and sent v3 too fast.=20

Please ignore this version.=20
