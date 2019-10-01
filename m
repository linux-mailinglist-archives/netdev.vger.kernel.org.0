Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6AC4299
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfJAVXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:23:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25236 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727454AbfJAVXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:23:24 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91L8OtS022346;
        Tue, 1 Oct 2019 14:23:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UHEPTeZS4RJr04o5kX4lEh5kbQENb1uBYZZtZt8h2AM=;
 b=QoqW+zKHLwjIzVqKxYNwyADv3lB7ZxXBUuqUDltTfnL3qPvdb6ezSsLxVhuZkIdeHgbZ
 ufdWciSe2AJGgH558XmUlkQ7iWT38FRG2Gk7l+vFPmpJDYaz5q5EQ2oPhgnb1bFIMovF
 KMm1Dt5LWTLswFVvgsD+TNfVsKmqNhHh7Dk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vc9fw1rww-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Oct 2019 14:23:12 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Oct 2019 14:22:59 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 14:22:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0jvWf7HrsPKg3txcF5btMft9qJvLBNhwyjFRibP6wqxGtNLYRdTz28X48kskJohLOF6i63OHrVqQhYy0R3nXoVV3voccLI5CeRpcFHG+lLFt6soQHBbD7AYGbiTfdXxcuzs+KqVpMTQByQosLoVJbUL1TimGeLU7pHNRCFPBWjEmRRYnT5+7z288uiu5nSQaGlI9PeDvgGxk5wiraobbLRTAkCj2kuC2sk4uUKUzWUKzt4qfzoIUBUWbwfpJMwqPmrk4i2vPLW3JpTs56nhq/joVnoGNkzsRY1yE0tGwm+Urfg3FHtKjwzemFLl8xfH4mzt7B9Aasood+nJQt5Qvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHEPTeZS4RJr04o5kX4lEh5kbQENb1uBYZZtZt8h2AM=;
 b=dNHCPWeLKYvK8W3eOi7k3Qsgaklr6vHARAhokojJJw2/x0DFaemFtZln6tMnbHGnRVNK3VVA5BC36Op8SEmXfgrLX22MTKnuHNbQdq/qr7EBYlVASiJCKXnNsUWCbyYNdWdxyfYknpAS+dt/JT0GJcLNun6sT205UMEQ5fiGitMMn67IjqFUaP3hbNqy/42nRgTJpOCIjwlkLacLNIn0rMB97wfVA+i4UT3z+2VTo0NIEOL2LdcUYPNqfcRfq3YOFTqvAD9SuUKcyH0hYTXs9XMhL9MJCAYgl1hq29QSnVsHoIKWtMHfAI9T4hMUv+D5rl0h8vJS+SrAaxq+ySehew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHEPTeZS4RJr04o5kX4lEh5kbQENb1uBYZZtZt8h2AM=;
 b=SVBYpsF/N6rwTgFv8mFkxtdRgEnq0wFPmJt0cYDpK9ej4fh41tu1B6wnATb/aX9sKma9mCwa2H6XPQp6SBi57zClurUW8miKFgzLKGkY9L/21L4JlgR8OzIxcY9zOONbX+Si2sGKICYh49qkRGSlWtQ64StxmDiHOjjBFfwQKxs=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1200.namprd15.prod.outlook.com (10.175.3.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 21:22:57 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 21:22:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 6/6] selftests/bpf: add BPF_CORE_READ and
 BPF_CORE_READ_STR_INTO macro tests
Thread-Topic: [PATCH bpf-next 6/6] selftests/bpf: add BPF_CORE_READ and
 BPF_CORE_READ_STR_INTO macro tests
Thread-Index: AQHVd8Ew7yVg65uJt0iaXPsWAYav06dGKr6AgAAiiYA=
Date:   Tue, 1 Oct 2019 21:22:57 +0000
Message-ID: <0D1BA872-E7CC-4596-999A-49DF37EA8A94@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-7-andriin@fb.com>
 <5d93a6b96a6ef_85b2b0fc76de5b4a3@john-XPS-13-9370.notmuch>
In-Reply-To: <5d93a6b96a6ef_85b2b0fc76de5b4a3@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:7bc9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fa885d1-3e60-42a8-ccba-08d746b587c0
x-ms-traffictypediagnostic: MWHPR15MB1200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB120036C8EC9598CCF32547FEB39D0@MWHPR15MB1200.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(396003)(346002)(189003)(199004)(478600001)(6246003)(66446008)(476003)(2616005)(66946007)(64756008)(66556008)(33656002)(316002)(46003)(11346002)(229853002)(6486002)(446003)(76116006)(91956017)(66476007)(6436002)(71190400001)(71200400001)(54906003)(4744005)(486006)(256004)(14454004)(76176011)(102836004)(99286004)(6506007)(53546011)(14444005)(6512007)(4326008)(25786009)(86362001)(50226002)(6116002)(8936002)(2906002)(81166006)(8676002)(81156014)(6916009)(7736002)(36756003)(305945005)(5660300002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1200;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EtByl9ne/Pgewp2D+yuiCPuj5XEbmVBPb4SC1AvzjyX8a9wGc/e+zkQAqnEdQm/3EHRHL/c0NEjPv/hL4Q2b33grrotroXnuaryqBV4eu6hPHk4GOES3Hz5ngnDEvB2jRATqp7XzJ6oHxwXuWFak2fh2XvWkAohXIWlkTPTA3n+TteRzgpITjdcMDw3Df0L8t/ag0XtuRch4pMKryO9TMKgT6iZgOy6HROzf4K0YwNNpEMajYIC8Qo/cg821e9bqAHv97TZI4SmFvJF/dMB8YQ2lEwQ9iw5ntyHGmIjsnQ6qeVlv5b8L1OF9Lj2DdZb2jwEKKD+i/Lg0T27oEVGpX2ElNcG2LZN7VPmQdvxwwvJXo7WnaBfAWO7NeHQUM+hCNGw+xNhHuqfPmMsQSW6qS8jp95RjtQXkby7Y6vG4lZk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6C96FCD73458541B2A55B900D956628@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa885d1-3e60-42a8-ccba-08d746b587c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:22:57.5189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4+ZxenK6+AJ69xNouQEK0gWft4VhDjDqOhMpntY5CruzdzP0lEHE3cTver+TjPDoxUJQr5U6/7CK/AfnGlnXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_09:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=774
 malwarescore=0 clxscore=1011 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910010176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 1, 2019, at 12:19 PM, John Fastabend <john.fastabend@gmail.com> wr=
ote:
>=20
> Andrii Nakryiko wrote:
>> Validate BPF_CORE_READ correctness and handling of up to 9 levels of
>> nestedness using cyclic task->(group_leader->)*->tgid chains.
>>=20
>> Also add a test of maximum-dpeth BPF_CORE_READ_STR_INTO() macro.
>>=20
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>=20
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>=20

