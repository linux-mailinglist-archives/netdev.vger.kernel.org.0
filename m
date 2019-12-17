Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516A212389C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLQVYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:24:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbfLQVYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:24:10 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHLME7R017842;
        Tue, 17 Dec 2019 13:23:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=l5JNqrTPRv6hWEfs8xh55yMIiVeFxh9X19ODN4gfmTk=;
 b=Z+zgg3vxuZgGWhrhPeMBhEFlapSj58GFg0Yw66r9K88wSd54YOO3Dw3iyvYXssPUkYRL
 cj4ufpxAn7yjgP9inr7DNfgU7Ci1d8OrAYuR8qT3RGbTaI8MXe055xFQDqc7hhhLgqTM
 Rjoud4z5DVqfrP3BmaHm9D0GDO13LQgDLcU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxuptk9s7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 13:23:57 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 13:23:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 13:23:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrW1KcYNHfCnC5TCw5c5oygJ1fKBZ6IFldAOb2Ti1BAPwjDUQ03F8vZzb+/AZy37hsdQQ+tvCBeGDdNWgOnUOS4YRrqOxNtFChSSAWp9G3qvo23uyNbufbWBdbyazle/rB3WYV3xPolAeNUnWY9P0cEliwZqYtRWVUVVYztLjZaMRBrQvAqYHDwMTkbAl9EOyM+72ojOCPZopm28f9hMylkeR/1ToMRWQmd/2s3NX275Ha5sOqgIp0v7+hZOGiYzeTd/dvNVkqXzatmgOFMEx5XtZpfxCG/v1eSQR4LKQy2rR6kJT2nTX6DK1WuJtxBlaeY93XtskIPJAIH0CjKadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5JNqrTPRv6hWEfs8xh55yMIiVeFxh9X19ODN4gfmTk=;
 b=VVDbiYXXdp6NFMo8O/rudpbPr3KVEZlQO/XAQ3c/Gq8zoW36NqRqtTF+pUx9Wwx7EVtMusfspFg3leaHDQgUK5C0uKufsPVwR4F+zRO7h/Y41KHpHtArvthzQPUNP5eCZYF+0zl9M18OQ5gGUGqW06gpHWCasdwHKqyHEs5hrl5qdhwvN7gi3uFpl6ZNri2vq62hphKkUM2Il7kLEtGAwg5O4cMye707RwPflgQT2pQqYsfFbtdZniVsT+EM7nMUJZZzqg9Ru9mF1Wd5JdUks0DfHR3L4sMhhhC4ycN6WYyYJ7IG9BvgePlUkfp+FkZcmCtFQB4mqClQDMDqV8PdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5JNqrTPRv6hWEfs8xh55yMIiVeFxh9X19ODN4gfmTk=;
 b=k1xtrtTYPibPxS/yG7e/3iS02jlE0QK4ehR3uC/CcqZEkrubc2uyu3ItB0ufuXc0hKaP9yH9CpD1GwX0Hj5R2EJi22kDK3fYfI7+0Gy3WE1DN/tg5/hx8f2PWhWl7wW3l1xGPlzfMwJhWoYovvOzcGgnWIfgR5bu1IcLQmirnXw=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1385.namprd15.prod.outlook.com (10.173.223.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 21:23:54 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 21:23:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool, selftests/bpf: embed object file
 inside skeleton
Thread-Topic: [PATCH bpf-next 1/3] bpftool, selftests/bpf: embed object file
 inside skeleton
Thread-Index: AQHVtSBIQvSdv+AAYUupLd6Sg3iHrw==
Date:   Tue, 17 Dec 2019 21:23:54 +0000
Message-ID: <f90f24f0-35f8-7055-3146-cbfab1531b56@fb.com>
References: <20191217053626.2158870-1-andriin@fb.com>
 <20191217053626.2158870-2-andriin@fb.com>
In-Reply-To: <20191217053626.2158870-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0033.namprd21.prod.outlook.com
 (2603:10b6:300:129::19) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:406]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ad64ffb-7fa5-4109-2be2-08d783376b0d
x-ms-traffictypediagnostic: DM5PR15MB1385:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB138514AD09B1B8892382E387D3500@DM5PR15MB1385.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39860400002)(366004)(396003)(189003)(199004)(6512007)(52116002)(6486002)(316002)(36756003)(31686004)(478600001)(64756008)(66946007)(8936002)(8676002)(66446008)(81166006)(81156014)(66476007)(66556008)(110136005)(53546011)(86362001)(54906003)(31696002)(2616005)(2906002)(6506007)(71200400001)(4744005)(186003)(4326008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1385;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pB3oVUm343N8UQGnm1x1HfOp8kA6Yc1SqgAeZzb5q9dY74sA87O9lmU9cZWSc7cBndLT4u38LywZm4mbJQ5ZSKDf6upxpxOpsm9wdyPlDvkWccMMpjCBD3faTgDKMDgqV6vwInBYuAUKZZUNYQBoMh7+HFXPPNNodLHMY98zECg1kcj7yWHXdxXEMNsFCQfxy4pa3Bq2Ckdy11O037mU0LLQsWAlejhQJViTsV9wCpLSejvRL1HHMjRzwfsjqQMTAfn7SyrNeHrKKTSpzpxE1nsy/aL33OOkGewUq4ZGEobS5JBjuu+zwtEjJ9irO9dMwfizNSzvz3v3I8Ua+FxKafLmOmmLAX7u74oUr9SVupNvPsCDGZZsAsM7Z036BRz5oZwFJFAj3VuoiWklnq9nIF1cdr6+g4f/FNhQTviZkDYe8LQWjAr0l+iba/jkhK3t
Content-Type: text/plain; charset="utf-8"
Content-ID: <330F5B22272703478B341A8A02AD40B6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad64ffb-7fa5-4109-2be2-08d783376b0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 21:23:54.1688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXquybGw8xcT4lzSfLZYPFGyjsg1M/U+4xxiuxI5oJGTGNVbHASGNiNRcOG5kwQi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1385
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDk6MzYgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gRW1iZWQg
Y29udGVudHMgb2YgQlBGIG9iamVjdCBmaWxlIHVzZWQgZm9yIEJQRiBza2VsZXRvbiBnZW5lcmF0
aW9uIGluc2lkZQ0KPiBza2VsZXRvbiBpdHNlbGYuIFRoaXMgYWxsb3dzIHRvIGtlZXAgQlBGIG9i
amVjdCBmaWxlIGFuZCBpdHMgc2tlbGV0b24gaW4gc3luYw0KPiBhdCBhbGwgdGltZXMsIGFuZCBz
aW1waWZpZXMgc2tlbGV0b24gaW5zdGFudGlhdGlvbi4NCj4gDQo+IEFsc28gc3dpdGNoIGV4aXN0
aW5nIHNlbGZ0ZXN0cyB0byBub3QgcmVxdWlyZSBCUEZfRU1CRURfT0JKIGFueW1vcmUuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KDQpBY2tl
ZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
