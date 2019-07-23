Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F25721EA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392243AbfGWWCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:02:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392265AbfGWWCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:02:53 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NLsVSX010626;
        Tue, 23 Jul 2019 15:02:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Q1+z9iF+cIE8cFwNV7NwlP8npU48yKfNZkkR3BeTm6g=;
 b=Ilm2vX/gQhx4vUu75SSEo3ohZs63HTNWvbBYL6x8h0ymCmGXcUn2C2fSS7g4217vCslA
 rnmn6Mi23mln/N6wooTAf0gb+JdSQ+8CJXN2cfm2jaaanPYhgzrLTkTF1ORHAwxkkNTO
 /V5ZuBDgJf3X9H9j9u1zpA2Svf7PZOt1fwI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tx61y96ut-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jul 2019 15:02:33 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 15:02:32 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 15:02:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhxtA5PSb1FidQ1TM0nPhB8lU5ppupcHjKtzZrdVaU1xiH2yi4MzYhkO5Fv9zgBNgaXppqIbrH5jEpdnvLYCXRi43q8jQPee7oMGpVQxgvNOrWX1KgnGQ39COgA3FOB3x/jUmyowSCZ8HmYnxRvOUdhEfHdSyLVXWgQAa/BW8oXQ93V0jHjXzuvo/EYJOPrehO5ZNY3u94JiD/xKfUWGK5f7DrYL/NZzICB/HDY+j2dMm1y6PhfJtwielu0RGzBAVCi1HrwdWzCwSwY6bx560n3PX2vFN3MWUBKwhGc1jOwjcLm9Z5m+Pn5Sc6U3wVi88ipUBg4y28fDTxVac5escA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1+z9iF+cIE8cFwNV7NwlP8npU48yKfNZkkR3BeTm6g=;
 b=KIX337yqqc5RDWmmhPoT18nQHwPDXuKLifHKlvj1YfEZ62w3j37HWQAWYAu6JXQ+SQdk90WoXJS76kceiAt/QxWdXtOL+f/kzqCJ7ZeNSfHTfc715Jg1dOiXfm09goVCzBVQpGHDmYdLxFvupehj4x5o4Je4FWJyycJ3bn9shUVhbgrSy/ZM3hpOgzP8zWHLCx1Xg3esbSqb4Z4dFoQrqJk5MxpLD6+DPQ5lQvph4FGC+SI72gYQMJe2pcgrbFMeNiOiFhjUzZbFGmq7xS7TBcqlGciQ2qDk3GIQD+76xzpdODnHBPlbBTqaZqdoh3vp5VFqY/1ESxpJ0z3iJB8MbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1+z9iF+cIE8cFwNV7NwlP8npU48yKfNZkkR3BeTm6g=;
 b=dEi5nFCNCX1SmEC2bIxJu8Tp/qVEJRv1k4NoHWoqZqpXXxvmxnfoLFUr+CYXyAEILwNM+AbUKehwQ0RQR9xLmkJewGl/X5OhcY8gh8526HI3TAScm0646wD5ThU6B1xvgORyUTY5CIu5NEDmawtV84JuiR3lnK/crw845P4FbGw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1150.namprd15.prod.outlook.com (10.175.8.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 22:02:30 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 22:02:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/5] selftests/bpf: convert
 test_get_stack_raw_tp to perf_buffer API
Thread-Topic: [PATCH v2 bpf-next 1/5] selftests/bpf: convert
 test_get_stack_raw_tp to perf_buffer API
Thread-Index: AQHVQZ6G5zGiRNeCI0ST/Rj5m55/86bYwWcA
Date:   Tue, 23 Jul 2019 22:02:30 +0000
Message-ID: <83019B99-2AC6-402B-9AB0-53B95069B504@fb.com>
References: <20190723213445.1732339-1-andriin@fb.com>
 <20190723213445.1732339-2-andriin@fb.com>
In-Reply-To: <20190723213445.1732339-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:bd93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3f3a0a8-1fb8-4845-357f-08d70fb97563
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1150;
x-ms-traffictypediagnostic: MWHPR15MB1150:
x-microsoft-antispam-prvs: <MWHPR15MB115025F2901FF87C57908C18B3C70@MWHPR15MB1150.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(68736007)(6506007)(86362001)(54906003)(6486002)(6636002)(99286004)(37006003)(6116002)(2616005)(446003)(76176011)(11346002)(6862004)(2906002)(6246003)(476003)(33656002)(53546011)(25786009)(53936002)(186003)(66946007)(50226002)(66446008)(64756008)(66556008)(6436002)(6512007)(4326008)(46003)(76116006)(81166006)(102836004)(558084003)(81156014)(8936002)(14454004)(66476007)(7736002)(486006)(5660300002)(57306001)(478600001)(229853002)(71190400001)(36756003)(316002)(71200400001)(8676002)(256004)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1150;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kBWOnAZt1lZKDyZakc+YhmBTbHdRUgmz0s0+mfnX5Nb5YSguzpciC0Gi7G+ly78/yS4qiGErKzu7UlFbZ3PUPf2UefLlJMKjJVQj9GZvoDZ5N0JOzuwL0wwNQfZuCQqpCyeWWhe4OdxYh2DZPZvPLCRfehUlYgrofvZjoBufdV6KATnTD+VnZMr2r9Sa/aMyEv/aZtXoAwPuECbDORR+9w3eUDEFGilKW0mD3cqCH7mbTUux7iZR3N50eGqkczIXysbYRBYzMfLc1iF4affusKnRZ5IRLbYSYgQ97rUepJ/UeH+qxo4vp+gsbfb3N1vrX5UpgF+WtdyCuTOoh1Stv4Wtie+0DmEwHOGscpJf1Mb0CVKJ70l/d47H8/anALIl+jbKZAVLSNjayGhP9Q3zVlm7t4R3OkRMsk4YMxxIXfE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4989F5B8F6BDC0479F46FC2F885F93B4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f3a0a8-1fb8-4845-357f-08d70fb97563
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:02:30.7395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1150
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=926 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230222
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 23, 2019, at 2:34 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Convert test_get_stack_raw_tp test to new perf_buffer API.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
