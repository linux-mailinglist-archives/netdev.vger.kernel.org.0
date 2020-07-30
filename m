Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C41B233A26
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgG3U5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:57:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10908 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730405AbgG3U5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 16:57:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06UKsW0R029654;
        Thu, 30 Jul 2020 13:57:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yc5cWjDsQWcNZL9LiPxDdmRNnVqR3pRrJAvsE5hC9+E=;
 b=jDVKhU479O06c+J3IL/Y09YVp+rScSRJ9gX+EPkVjF9gYNtXUBqATDrClwNUByvr2kpU
 N39Y9xq967XCq9Gb0NSaBj2UIfjzszM1LhLRvaaN8d/ckahbnHuYUitTYJlPD/TOV7Pb
 uxtwmDHDUFIwIwQ41GhMEv4KhwTA9le6OqU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32kgmsnke5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 13:57:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 13:57:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdtPaOk9uzHqc6ujCVg91Z5WjIiBMdRBE46NUklCNXnNlh//FxAjdis4VqwVX6EGu54y08UmHmBlXUQH5ASHiMhTv5W7zhUFmo0ICcsRTeqvOC9z0jtlDaPt0jpn2uEMmdEPX7IdG1ysjUeKP/6j7yZ5k505uMeKgT8LQfaRq/SqzjIoVkvPDEkHaph3TdhJiR0K/Ufmla4QOg28IPxzVZxhlEvHc0PWYBa+f/D7L3Tkiu/LuYMhUTtLcvUV/clre/m3FkO0ke28GwpER18PZ9qOem6G7dJozDglB2+zuPVKJryD6t9nWEEqVE6JYOtsl+IBv/P7RLivmI1iOd9Kxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yc5cWjDsQWcNZL9LiPxDdmRNnVqR3pRrJAvsE5hC9+E=;
 b=EhYOzZg+Lg/T2NXkUx/13JxcGCoIoAvEeZB7WQd2kMFoS1Vdja8uNKb1Qe6XX5N3J1qA/RpMKZ34/MtijKh8Qy2od69EpWrh9LP16hUsrlJJ5jmN2m23i7ctbqOiWqOWnWVl55yijVSUkDkEGJrug+tLstklHPG2383ulVO4or4jWR0lH5Xo6uS2MOsCNgGuQmmPrAvv+IayYqHDqBbxVo3mwbgOzSzVAppMdLp37Gl7makFEWchd/I1qAj8ROYW074kj1FSIfzskiX2Cz56znNUUmydHO6HDYYmCkxNQZnYiLd22RRCL4mrHJZ4PWpQsYeJCV2qLZF4a809xhotxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yc5cWjDsQWcNZL9LiPxDdmRNnVqR3pRrJAvsE5hC9+E=;
 b=ND8+BSTYrR7uDgwUHUy4MDiqmhr5he4aZkl73la7gLtj9OWu0fuVCfAbUDJngEUsZy6wzz3lgByoAvfLzo1tlrwKpysfLdOxeD3TydNNMa4ha6Qv245lp1UmFT12fHYnLS2EnqmCyzvjGVWKfTwvVQ5qw3HuT3s/JIk3jVp6jZE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3367.namprd15.prod.outlook.com (2603:10b6:a03:105::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 30 Jul
 2020 20:56:59 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 20:56:59 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: add link detach tests for
 cgroup, netns, and xdp bpf_links
Thread-Topic: [PATCH bpf-next 3/5] selftests/bpf: add link detach tests for
 cgroup, netns, and xdp bpf_links
Thread-Index: AQHWZfzVJp3aQRrT1UGoirJ54breo6kgm/MA
Date:   Thu, 30 Jul 2020 20:56:59 +0000
Message-ID: <67C6BA22-52F6-4E1A-AEFD-E971B657A73C@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-4-andriin@fb.com>
In-Reply-To: <20200729230520.693207-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76257d6e-31da-4faa-01fd-08d834cb1a54
x-ms-traffictypediagnostic: BYAPR15MB3367:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33679B794FF8D840A22C8495B3710@BYAPR15MB3367.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gFd4YETB6/nMfkSQWu2AXzlwUapR1/hTEN53KHDyKJ02VfL1312uJnMO+7dV6o49wXQlMNxKHRegK/9N2NhM6yHRfEJsyIkrEgu0rf/lT/FziB+HSy5x8vK7GRcYk2zoYcvvgjTVb8vMfHlWbhyu97BELUdkUuTudmWU6SmDa1vCQQ2d2B+8XjgYekdlxBaqKlp4GnzAQeFfvGVRSqhWTp+1DqOqJUTWeJQKgaPUvHZ9MhCGo1e9VMQJXnzBuDKx8N5jheA/ROLPB1kIkv2rM6VJlwH487XBeIvvjKimAeymTgXbc7WMK6XLfLlx/5Wkz+gFTbxDecWvp1u3mFhYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(36756003)(6486002)(6636002)(86362001)(186003)(4326008)(6862004)(5660300002)(2616005)(558084003)(71200400001)(6506007)(53546011)(76116006)(33656002)(316002)(54906003)(37006003)(6512007)(66556008)(66446008)(8676002)(2906002)(66476007)(64756008)(8936002)(66946007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wwcROYhngAeLFhB2Q9lr7V3EsRMdQv3ZTTiSHABmlbzjJHqmbXG3wZ2zAz3ARP1ufVYalw9O9DNnt9P7wSTLwwavqcuZ12V9WWVAzZQBoStSFnIEzKSJ9LuK1nQdfQ5MNtLYFzQb+iH0MVm3RjGM8laM3FWOkiz0MxpO+TeZVbAK5qQagnzUSG1HOaMKIlnSl/r5HUxgpGZFXhJ+1PLac73QkIH/ISCxKreELxUgIJotEwEP3M+6EQ8JEk1NNX60oV4Cexaihsj/tETu9xoM5tAOJ7OMN3lzLAEanLgaEIaDpGd1llcrB66cPYza+O+tbFCIH/LxfGoZHxo+fKrJU7JRmdqFbtnBlN3RkC77jl3h1ws4d/tsEeZ0xfw6tztVzf1mNlWNz7ceAFOwXXikmdJxO8yXKLXhJld93XSCFlF3G/zIj5LGBvEVZ22GIPNKpeU8ExG1lRjMFBeSLjEs78BCU7AEhof/ZamP5Dn2zdNOW6XA5fDJIFmpzInxwDnRwnCLaV68MPDZrDgtmKS2Cg==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7A8BD0B57B807B4C92A5408CA0E82AC5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76257d6e-31da-4faa-01fd-08d834cb1a54
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 20:56:59.6004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yOupiS+UPa/tgXJ+PflUpzj3Hk4++3N+Rpx3ovnxetMzOEH1nqLiRA/Zay88q1wRqKUs3jGVGvURHGGmVuDGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=945
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007300147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add bpf_link__detach() testing to selftests for cgroup, netns, and xdp
> bpf_links.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]


