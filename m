Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F23105990
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKUSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:30:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfKUSaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:30:30 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALIFQeh007135;
        Thu, 21 Nov 2019 10:30:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=m4QiLfx40epBvo/jkKhx1Y8a6t+YvWIHlLoivQrZgxM=;
 b=BfY/b7eAQUdYnHQJQkiE6tTaE7kEdFr7r3ZIEYwLwbZ7qzNphPTmpiMGewNzBF92QXRL
 xo2NXS3oOdd/DBbW6UuCFT/V+EsQbFWqLaAJjqrMytqExYV1c+x7ftcpUxfiOSdphN46
 EQggnqQb9JL9B1p7DEsOzVT9Hp2R9kvks2Q= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wd91htem7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 10:30:12 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 10:30:11 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 10:30:11 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 10:30:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa9QRG1hBlmd9su6AHFKLhUc58FLxPApnC+c0WenuXwsbyAgxdo2kWHVhn89nUY3KC2DYtn8dQEjaWRtprUmnDIYeyTC4fd/hBqO3/399SMoB5b7oLlO/qjiSKrl0PjDoeHU04UFctRxMUb634ZB2/u17TuJh9ybXdndfo7whHJPmUadf/n5ZwlRfe2I1A0aBCaY8qxryM0zHAyEdMmwGIU96KDHgxllVLHuhB1E/Ioqm3HPIL5hTSn4RTKdA3GFTPbfXCovTEgJ8ShcIBeme35sy9Bs9lBvwhtqEz41taqIYchrAwHEiVdC4OcZnERWwgXkr1qZeVgLthyLh0k0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4QiLfx40epBvo/jkKhx1Y8a6t+YvWIHlLoivQrZgxM=;
 b=afVQ3bEetB3YQ7AB54hvX/lt/HOIJoirhl7rfZNvVaZHhaKkgjCjk/Nl2n736WrDqyevA3GFvJEtulFgxaIm9QUCWU0exqKn4BQskajje0R4qIWKh0R6Bnn5q56Nt67UiN9z/n6neKzTR7awQ5l0v7YBZlUmEs+orN4H6/wEnwuXVfOXcWfTIK3UJ5NtKk7TZxysWuI5UtJRkFqVGs8DR3+upoOnXOZSkurSLK2SQ6KKFCiv6tRJUawcIYuq0LcAVzXP8/b6ScErPxRXZfEjBk1W2UJKs7bVHQsnUs5JtMyVfyNX09C6VAKydz2RNlJmkIWfVMILQoA/6H2gLNDWYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4QiLfx40epBvo/jkKhx1Y8a6t+YvWIHlLoivQrZgxM=;
 b=VE+rH3K5dAJ53aL40jIT4fsDwraSFTJPDAKK0+vad5MQ5yoenzCbmY6NenYYESlmhVSqA0JW/Bz3IkW3uxXk14zGfF96OMAoXBuwwdXS9e2tXQgg0CU/3hVacrSVU9cdwr7hsGgPzXBKJvFWU9zoP8VpZxs35C26ZT2YspGNz3o=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2837.namprd15.prod.outlook.com (20.178.237.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Thu, 21 Nov 2019 18:30:10 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 18:30:10 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 7/9] libbpf: add libbpf support to batch ops
Thread-Topic: [PATCH v2 bpf-next 7/9] libbpf: add libbpf support to batch ops
Thread-Index: AQHVnw/00b+a1L6Vt0u6+x6SeXV3ZaeV9UWA
Date:   Thu, 21 Nov 2019 18:30:09 +0000
Message-ID: <434eb25b-5d1a-4b33-232e-6735fc00e531@fb.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-8-brianvv@google.com>
In-Reply-To: <20191119193036.92831-8-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0065.namprd10.prod.outlook.com
 (2603:10b6:300:2c::27) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:b385]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d599a916-5134-4ce1-7d7f-08d76eb0d70f
x-ms-traffictypediagnostic: BYAPR15MB2837:
x-microsoft-antispam-prvs: <BYAPR15MB28371D09D5BE04AF9FF23377D34E0@BYAPR15MB2837.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(2906002)(102836004)(81166006)(256004)(81156014)(14444005)(25786009)(86362001)(31696002)(446003)(5024004)(2616005)(66556008)(186003)(64756008)(66446008)(14454004)(99286004)(8936002)(8676002)(66476007)(66946007)(7416002)(305945005)(7736002)(6512007)(498600001)(76176011)(229853002)(52116002)(5660300002)(36756003)(110136005)(54906003)(71190400001)(71200400001)(6116002)(11346002)(6486002)(4326008)(46003)(6246003)(386003)(6436002)(31686004)(6506007)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2837;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wtODOubgVHBdFb/v6D0G9O9CLbZw7VVmCInf70fxl1ZDtEqqKdrfq6wcdU8was+q4SxncOJecJoINdsqWfiHrQ9R53wdIyiUgjNfyS1TrYvb263wIoPEhvXLn/oxr5HVmWJD6mtpSxbK6QSTg4lFPj9m/Me+TNJOV2CS8cUS9K3EMqcdAg2alsQMRLWz4KtyWrRzAafOtumSj8RGZWSmLoTsm1COkOp0/47xUL5CQqgvgTDohxC1TmXZPs42Bdzpbml8iSunfCEx4tyw48G2V0lHEBC4/RQ3i7mf+ZfSoW8hdfF77BfcMR+UA/7YtY7HNGMFxQCj/BP/wLgzvg8AxSWfiPf2wO7D0oDvw9BazK+R/4+1ZkjOUnYuGXyAyn2JQEQsQ4+itD3rn1f4PMrFbBMokNr8VNuIvj4VxpEKd72xeeO/Ct9qyUpJDBQT+Lib
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A435BD64616A7243AD9EA37FFAA62FE1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d599a916-5134-4ce1-7d7f-08d76eb0d70f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 18:30:09.9229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zMzKtgpPFUEHeghQzs0omqTLO1eYYlXsLKLSn5yU8j1rxjDUwCoBbWf464410d1W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2837
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_05:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzE5LzE5IDExOjMwIEFNLCBCcmlhbiBWYXpxdWV6IHdyb3RlOg0KPiBGcm9tOiBZ
b25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPiANCj4gQWRkZWQgZm91ciBsaWJicGYgQVBJIGZ1
bmN0aW9ucyB0byBzdXBwb3J0IG1hcCBiYXRjaCBvcGVyYXRpb25zOg0KPiAgICAuIGludCBicGZf
bWFwX2RlbGV0ZV9iYXRjaCggLi4uICkNCj4gICAgLiBpbnQgYnBmX21hcF9sb29rdXBfYmF0Y2go
IC4uLiApDQo+ICAgIC4gaW50IGJwZl9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2goIC4uLiAp
DQo+ICAgIC4gaW50IGJwZl9tYXBfdXBkYXRlX2JhdGNoKCAuLi4gKQ0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4gLS0tDQo+ICAgdG9vbHMvbGliL2Jw
Zi9icGYuYyAgICAgIHwgNjEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiAgIHRvb2xzL2xpYi9icGYvYnBmLmggICAgICB8IDE0ICsrKysrKysrKw0KPiAgIHRvb2xz
L2xpYi9icGYvbGliYnBmLm1hcCB8ICA0ICsrKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgNzkgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvYnBmLmMgYi90b29s
cy9saWIvYnBmL2JwZi5jDQo+IGluZGV4IDk4NTk2ZTE1MzkwZmIuLjlhY2Q5MzA5YjQ3YjMgMTAw
NjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvYnBmLmMNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9i
cGYuYw0KPiBAQCAtNDQzLDYgKzQ0Myw2NyBAQCBpbnQgYnBmX21hcF9mcmVlemUoaW50IGZkKQ0K
PiAgIAlyZXR1cm4gc3lzX2JwZihCUEZfTUFQX0ZSRUVaRSwgJmF0dHIsIHNpemVvZihhdHRyKSk7
DQo+ICAgfQ0KPiAgIA0KWy4uLl0+ICAgTElCQlBGX0FQSSBpbnQgYnBmX29ial9waW4oaW50IGZk
LCBjb25zdCBjaGFyICpwYXRobmFtZSk7DQo+ICAgTElCQlBGX0FQSSBpbnQgYnBmX29ial9nZXQo
Y29uc3QgY2hhciAqcGF0aG5hbWUpOw0KPiAgIExJQkJQRl9BUEkgaW50IGJwZl9wcm9nX2F0dGFj
aChpbnQgcHJvZ19mZCwgaW50IGF0dGFjaGFibGVfZmQsDQo+IGRpZmYgLS1naXQgYS90b29scy9s
aWIvYnBmL2xpYmJwZi5tYXAgYi90b29scy9saWIvYnBmL2xpYmJwZi5tYXANCj4gaW5kZXggOGRk
YzJjNDBlNDgyZC4uNTY0NjJmZWE2NmY3NCAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGliL2JwZi9s
aWJicGYubWFwDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPiBAQCAtMjA3LDQg
KzIwNyw4IEBAIExJQkJQRl8wLjAuNiB7DQo+ICAgCQlicGZfcHJvZ3JhbV9fc2l6ZTsNCj4gICAJ
CWJ0Zl9fZmluZF9ieV9uYW1lX2tpbmQ7DQo+ICAgCQlsaWJicGZfZmluZF92bWxpbnV4X2J0Zl9p
ZDsNCj4gKwkJYnBmX21hcF9kZWxldGVfYmF0Y2g7DQo+ICsJCWJwZl9tYXBfbG9va3VwX2FuZF9k
ZWxldGVfYmF0Y2g7DQo+ICsJCWJwZl9tYXBfbG9va3VwX2JhdGNoOw0KPiArCQlicGZfbWFwX3Vw
ZGF0ZV9iYXRjaDsNCg0KUGxlYXNlIGluc2VydCBuZXcgQVBJIGZ1bmN0aW9ucyBmb2xsb3dpbmcg
YWxwaGFiZXQgb3JkZXJpbmcuDQoNCj4gICB9IExJQkJQRl8wLjAuNTsNCj4gDQo=
