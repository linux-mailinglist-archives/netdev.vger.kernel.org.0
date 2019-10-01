Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F558C42ED
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJAVsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:48:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12820 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbfJAVsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:48:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91Lj2pF027867;
        Tue, 1 Oct 2019 14:47:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7FF6FDrG24BQP5cFIpUBzsR1aA4CUTJUDO7p3CXeRzQ=;
 b=KRBQpU7JhvnYexZtcNPoLbX02cKOGPgZsiFwoYQfyq5SHezv9lyzgXlDbnD7nke9CswN
 Ulyu5qEWYT0Yy4eba6Cwl/DveWnfQp/98m1cfq7ElrlK0OQzL4e6hcwooufqLyO0u+3A
 GTkeVuUoOwvEiYBn3FuBeDXdVPB3lKAQj34= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcasb9g9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 14:47:51 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 1 Oct 2019 14:47:50 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 1 Oct 2019 14:47:50 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 14:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SODEGhk5LqqPzkr/s61UrqKlJDkWsAzYhTFAZWPObck6oiUHglnwLCzpKMzNFeGslYBpgrp4CKcuNarZR9TDFRnPo56oeeD+qhhDGbdnQY99dBMPx6/zL7Y08Cuvth5HdB2+PR/IuWNt0mM1JAaKdOGmj8XAUyR7aMt9IO2nwWhuqRW7ZGZTIf7kXNkvsT7g6zr7zx41W0yD/b4dYY7PXgid5BP3ZS6Xr3R4nMYCfiykGTZsxOWfZ+Bkc6AhR3kHo81Nm/MDZdH6jSyHJi2KzMOufOIO30OTqPlNBPI4WHa/wfPhoIk5o78c4RAIzSIwltCt/pIoI9w2yBzJKzma6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FF6FDrG24BQP5cFIpUBzsR1aA4CUTJUDO7p3CXeRzQ=;
 b=lONzZkFa5uBbKkI3QthEyoCqcPE8sNKrEvclrI6UqSjuvCZxPvPlymKd/Tv+0gscZjoeUqDTKUGimwsW6xVi6XjpHw7L61Rb76nFXS5vmC5eJgUl0b/VB3jzkla7cjZnQZL0bd7ujKakqNP7qO3bVOtHM1t733Qj6oViuBa+Quu80JkJK0/MznvLm7ne2R8BeXiJsBKzkESsPXh9+xljWz6qeDhJOaZ9ZyqmA2nnULXK9pjAbAmoHP7iXSHimhci/Q7syqtajuK8Y4I9HTgUoOw1uXsuWdYvwq6L+4m3cX5WPNSJaR3gtcy/oHg3ZwqUkbjIxo188kzTjyT4ZphVVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FF6FDrG24BQP5cFIpUBzsR1aA4CUTJUDO7p3CXeRzQ=;
 b=LgXxg3SjpviC+GtMbJnuhr8Br/Wrb/NeI5+7So4BAWW1WM9dGkJ7vgvMK+f0mFt6EPpBMCo1vmrjoJCtCSrjEk/FFtIaShrWDl9O6jaeQu4WMN6IotDl6wOK7ajBRixcPreJM1Qvp6KyZPKsn8s4TvhwzwgstmYZ1VeY1BzCZaw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1280.namprd15.prod.outlook.com (10.175.3.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 21:47:47 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 21:47:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: adjust CO-RE reloc tests for
 new BPF_CORE_READ macro
Thread-Topic: [PATCH bpf-next 5/6] selftests/bpf: adjust CO-RE reloc tests for
 new BPF_CORE_READ macro
Thread-Index: AQHVd8FNfE+g95IKgkOuRre54jGgJqdGVDYA
Date:   Tue, 1 Oct 2019 21:47:47 +0000
Message-ID: <4F50FF25-BCD3-4B72-9837-499962762238@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-6-andriin@fb.com>
In-Reply-To: <20190930185855.4115372-6-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:7bc9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cecce6d-0b77-403f-beec-08d746b8ffa1
x-ms-traffictypediagnostic: MWHPR15MB1280:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB12803626281000FAA669BDF3B39D0@MWHPR15MB1280.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:409;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(66446008)(66476007)(81156014)(66556008)(76116006)(5660300002)(66946007)(91956017)(64756008)(76176011)(6436002)(71200400001)(99286004)(6636002)(14454004)(8676002)(53546011)(6506007)(102836004)(6116002)(4744005)(50226002)(8936002)(186003)(25786009)(498600001)(86362001)(71190400001)(54906003)(229853002)(7736002)(36756003)(2906002)(6862004)(81166006)(6246003)(4326008)(46003)(11346002)(446003)(33656002)(256004)(305945005)(6486002)(37006003)(6512007)(2616005)(486006)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1280;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WG46Dww9EtSgvygpBcxmheFH8bAY8YMk+uIZfgGv87bfPizmy2/7er0hxhllhHiaB/1evaScKcg/C09Q1uaVO1dxELEUSf2fCkPm2gmK7KoKV09Dkgk7h+frrit1jCfGqoP+DtOma/DYjrdr/S82mJzl4NFNNqTTZ7HRpb3IgCxob76KLVg5z8Vy6ZBFc9FGIpGlVIVIt7ksqqo4+CrSqsO2MZxkipVMENiu8XuuxGHV4M2XBzqtq9UmL6tChmN17m64v5Ct9Nbh8bNzst6u95YNe08WkceXW1aEAWTiY3zjYKTaVeacO4J+q5F1VYUPQT5kSRq3WApAV7fvTarEK8TVpU81OTX9xSGQHki57mYWeNx25Od04igh+08fGX8bLFaJ/MSpHxY7su1B4M79YPtU+3aIQ7dTQkVkz8VkrS4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19D34133E55B5D45A324938B0F224884@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cecce6d-0b77-403f-beec-08d746b8ffa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:47:47.2101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k0buFrkpty5EO7Hdhe3NMS1sqoesPMeKGYkyESbTPIxFTQ/LG6htIlLmIt8seSYLnqK6605lcPrWrBl8lObKEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1280
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_10:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910010180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Given introduction of variadic BPF_CORE_READ with slightly different
> syntax and semantics, define CORE_READ, which is a thin wrapper around
> low-level bpf_core_read() macro, which in turn is just a wrapper around
> bpf_probe_read(). BPF_CORE_READ is higher-level variadic macro
> supporting multi-pointer reads and are tested separately.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>=20

Acked-by: Song Liu <songliubraving@fb.com>=20


