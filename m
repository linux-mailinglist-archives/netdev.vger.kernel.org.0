Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07F8147024
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAWR5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:57:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12716 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728760AbgAWR5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:57:05 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NHukcF009571;
        Thu, 23 Jan 2020 09:56:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JFvD0shaGY2HvJ7Gqrji+2IYQLtSoq+CHdYPM+wq1rQ=;
 b=A1IhVSZtA8sd/ywtaND8CULVSrLii0Iiios0z9e8tM3S58fpZEiUYNkokcfBjwXuZDec
 gAtcpsfFGypJ2vie5pa9JBKjCZ2dPVtKjknKrJyWggQKZOH5UNDAeTCZmUrNPZzymfN/
 ZIKNjeij/7SaLLVJLVUI09z4TKylJ8UWnP8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xqc881a54-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 09:56:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 09:56:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGI5Gz2mXN5HyWQ8uFKRocY5z0vLWMQDgZtxBlo6s+obY9+TTP9fqc26qsCAjI3xjtCOwHRUOg/OmtBolzNtja9Inzlv8XD6eKSxBMa1B00pt4oPlrFpfdvonIcRAZcJ4rumPTlEJpz6fEP9dQLrJi0YgDWvqlepPOlXtI5bFa+6i4adMMS35yxvfK7WNy84/zOtj9q88z2Gu27FQndgSR2AwpTyMPqYc668k4ljOJzc328mjC7EoS8N4GYS7aQ7EZirSgJLF5NNxWyWoB21MO09QyFVBIiPYBHUabXxYv4PchMkDXoJkMJvNhx7wTXf5dVMNBdfgFk1LbOxfX7BIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFvD0shaGY2HvJ7Gqrji+2IYQLtSoq+CHdYPM+wq1rQ=;
 b=n3GP0RlT9Fshv9Okg4oveQUvMuzQnEOBVKfB6MDnvI/gVswcgxaJjQGdbVLpWQbX4dbncTqlyUJlvJ6t0xoHNMwQxD7AOYTeGir5HZYj65/COR051wgr6o98d2knUSjT2lULmHrSr2IcQJhPZsvD/2DugixtNXHVB10kut1c2JSSkkO3pAnsB5ZdosaEqSsP/P9DEfU33ae+zlqwvNgmqf0LCN/GEF/QyL8NL+nFRt8glWAw+lTMdchb1XwBIVMEToGtf/Mcobg8mcBDxPAyfgLO7tthjLtUPRS3avr4+A3fVAiLLExfSwzk7F1rak0UdqvdWCwPqoP6ate28+AHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFvD0shaGY2HvJ7Gqrji+2IYQLtSoq+CHdYPM+wq1rQ=;
 b=bfwm8n350p2bucIrwFhQCbpH7GMf/sWL+fsP+BzQdEBdVLkEULAopdjhDChKD5ibBmaTpwJkAZ+EJm28tkldIMAgcIcCwUxgI3Z8j5gic2hY09i60fg6XoyqoqYVcC3stsTOD/k9/18VPIHUVj+L0Ashfi5RCdg4En5lg0COOhE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2719.namprd15.prod.outlook.com (20.179.146.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Thu, 23 Jan 2020 17:56:47 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 17:56:47 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:d66d) by CO2PR18CA0045.namprd18.prod.outlook.com (2603:10b6:104:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Thu, 23 Jan 2020 17:56:46 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf 4/4] selftests: bpf: reset global state between
 reuseport test runs
Thread-Topic: [PATCH bpf 4/4] selftests: bpf: reset global state between
 reuseport test runs
Thread-Index: AQHV0g6SqqQcnu2MV0ypmzGJv4yvkaf4iNUA
Date:   Thu, 23 Jan 2020 17:56:47 +0000
Message-ID: <20200123175644.x3j7jhl5owi34fdo@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-5-lmb@cloudflare.com>
In-Reply-To: <20200123165934.9584-5-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0045.namprd18.prod.outlook.com
 (2603:10b6:104:2::13) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d66d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a64cff7e-a7b2-4861-06bd-08d7a02d9da2
x-ms-traffictypediagnostic: MN2PR15MB2719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB27191905A2F83AC95DE0B941D50F0@MN2PR15MB2719.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(9686003)(186003)(6506007)(52116002)(16526019)(2906002)(4326008)(7696005)(55016002)(86362001)(4744005)(5660300002)(66476007)(66556008)(64756008)(66946007)(1076003)(66446008)(81166006)(81156014)(8676002)(8936002)(6916009)(54906003)(478600001)(316002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2719;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LCrlu9bZA5ID+161CfQRBUBTJrVhvjYvGPutXunDJ0LuFLDqA/WzmHq0WEZOEC+3xV710JRm8o8AU8SruEojDKWVINTwkFBF4NMaU64ISoTzgPELr04kgUjMCwIc6Ky67LjxiSzw473RASu1Hf3EcY3v4lXSU9nWv4QcVaXT9KGa786irsQ38UTZEp1qxaHAGJc5u1hxHT94i7w0tavOTbrYRCyoj6dKzuT9XLrT0Ebnc3Bi05bcZlantGIdM4Zvm8kYx/ZjUmoQOcN8g7Nb1NgIfgYUI/kn5JEmHC7U25Di7R9Iqx20iSUtkoR10aEpvWM0cRoxxTNX7TvlnHwp5lt++ZHmtbqlruZD1ozwwOeePfYk+8L+pHTFhH6kB0HIQ/J6tzQAVYb1GEqQ7+zgTRtYhLoqXDStyQHPfpSVmAkmk1MeI5hrltdrEOHBlOV/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <501BAC2656A9BD4B9D7F9D55BC72CCD5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a64cff7e-a7b2-4861-06bd-08d7a02d9da2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 17:56:47.6877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /3DhYisfttcQUHTL2uzzM1g1UqWyD+prGxpofRMT8w/OQCyuToQQSwoQnknYlbOp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2719
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_11:2020-01-23,2020-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=861
 spamscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 04:59:33PM +0000, Lorenz Bauer wrote:
> Currently, there is a lot of false positives if a single reuseport test
> fails. This is because expected_results and the result map are not cleare=
d.
Ah, right.  An earlier test failure has ripple effect on the following test=
s.

I notice another embarrassing typo.  Can you also make this change in this =
fix?

-static enum result expected_results[NR_RESULTS];
+static __u32 expected_results[NR_RESULTS];

>=20
> Zero both after individual test runs, which fixes the mentioned false
> positives.
Thanks for the fix!

Acked-by: Martin KaFai Lau <kafai@fb.com>
