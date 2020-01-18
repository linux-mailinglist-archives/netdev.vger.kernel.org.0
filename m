Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A6D1415C8
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 05:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgAREOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 23:14:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726566AbgAREOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 23:14:44 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00I4A6Ar007962;
        Fri, 17 Jan 2020 20:14:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Dl2zuaTn+gCKKtNR61umPRvW3OzAwXA6TFukTc4cLhM=;
 b=R/98o4Pm0iazYlDH/SfKTSXITz59hFqU2UhKDiimvQoBpBUlNppdVx9fAYnhAVp1H4js
 gXG+ZqOabmh8TaN190eo4p55E3WE+0Jm/8CVdABtqUm6+ULiCwV8q+W4EOlAZc30XQLo
 GovWQEInHhQ8ZaDx1kFTlzYOHyZBNVInlbQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xkm5f9cqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Jan 2020 20:14:24 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 17 Jan 2020 20:14:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evMs9qm/aPk8iWYafug+fdcQ2zU3kfHnTRiOja91PjI8Rbb8LCaHD8Hw6fha4a1hghz49T3LDQR5aGSPvSzBhq1nz4LVtRQLlQfHOCzd7ppwlK1auVly2XYXNG8SDA0ul8GCAhIpuo/Z9Ahr1ugEkDdOCpTacttrDjPc+vZGMbYSV6E5O1U7PiNw3/p4iH630OHERGZUlMXhnZ9viDWUDVK2PXNxhpoPkdBYFJwlPGKQIuqgfLH9fToif7pFw7tQHt686Hy/F9wkWuZx2uJlyoM7FzG75HN/IJXlHLJ0bjMEhju5vikrdC6/M6QY/AhsVBDMYmBWItNl7mNhbTNjjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dl2zuaTn+gCKKtNR61umPRvW3OzAwXA6TFukTc4cLhM=;
 b=nl4ZkNqX16e2Jb1KcEIRxVVV5dytXXvYkMq/i0j3pvCQNfZDHxsoMwCPJleSKs0hqmlHG98WDlDK1w99pTWsXFleaxiop98prI2SUloCXa63A/LaJwXNtzwyep406GrbiKncqrLETz/qXuVO2V634C/aNrR11S7QOaLPkcwz7qm6vfYjGGH4wpyyk96eSZSLYihBGnRm4uiJw8Po0LrT0OahnbN0RCK+l2VZ/8i2X6HwqdBFX5uQB3fr4Bu7RcQBJHh5uPNXIbkNXdUsIn3oTX1olgdGHpyRzXSeoWld4Ych4AufSKX7xD0t3/5KEj8nKUuRYxshuzmCINjBKYXvVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dl2zuaTn+gCKKtNR61umPRvW3OzAwXA6TFukTc4cLhM=;
 b=AndQN7MPL+L9rQ0tqQVYMaF15n3M21ftrt7AfHICAT619Y/zcLFa8EXqtNvdiD4ofN56dgvD6CjBEm//Zw3M0t6QSPafqAvrw2SpYkr6yvDYEvhoXwWFKMG8Aib0HbRjNLD3TgbfMmY9kqtUmcXpMAlo2wSW5O47Ki4AG4UcK5E=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3708.namprd15.prod.outlook.com (10.141.169.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Sat, 18 Jan 2020 04:14:08 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2644.023; Sat, 18 Jan 2020
 04:14:08 +0000
Received: from swagatghimire-mbp.dhcp.thefacebook.com (2620:10d:c090:180::4980) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.21 via Frontend Transport; Sat, 18 Jan 2020 04:14:06 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH bpf-next] bpf: Fix memory leaks in generic update/delete
 batch ops
Thread-Topic: [PATCH bpf-next] bpf: Fix memory leaks in generic update/delete
 batch ops
Thread-Index: AQHVzYlUIK12lJcvLU+dXHp+zl7Acqfv0FsA
Date:   Sat, 18 Jan 2020 04:14:07 +0000
Message-ID: <2d954f70-a2d0-85c7-33c8-c71d6ed9572d@fb.com>
References: <20200117225608.220838-1-brianvv@google.com>
In-Reply-To: <20200117225608.220838-1-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::4980]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23d369a7-d07f-4237-7d47-08d79bccdc98
x-ms-traffictypediagnostic: DM6PR15MB3708:
x-microsoft-antispam-prvs: <DM6PR15MB3708CDECF34E7785496AF00ED3300@DM6PR15MB3708.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-forefront-prvs: 0286D7B531
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(39860400002)(376002)(346002)(189003)(199004)(6486002)(31696002)(86362001)(4326008)(5660300002)(2906002)(54906003)(15650500001)(31686004)(4744005)(110136005)(36756003)(316002)(53546011)(6506007)(52116002)(6512007)(8676002)(478600001)(16526019)(186003)(71200400001)(8936002)(81156014)(66446008)(66476007)(66556008)(64756008)(66946007)(2616005)(81166006)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3708;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Dv5FuhCJid+a/QOBmpdFBUh/MHZVENnk44KqxXhRvuhEjUxKu48HvfsFfRAUbVcXsa+ouEb8IjK9+hoHi2psvnb2eGdOIlPOTRAdH9kXuHXuPy/sBUQKbbbCjGMrKVTpnq7xkqP6HURSkM9THu3j1s1HLq0JjaiYnr7SAtkLdE3THlYHIs3b2aSUqgJn3b01+UwhlKRkWX6Noym35PaWLdLuirqNkRgIEgIgo37wsWgAcz+9YSOKyc/rW1XRz7/gGwqSqXqgbRXqsZIIWor0YVeL6svjMjsPPu9fXtDtdVIaufP+tEBzFnF/hNMx/k/xfqhFXeJIcKw5mnIQGykqfASq6Kd+/nnQAUgo+ahvWqmUWmWJcNQiQBYXDn/oxe5xT+lMb0WZTPpqihMZkMbMKMYnWlAx7odGXpm+qCophbPG37uvOZ+s3O+n6ahAc4htI2bCHNoO18hz/PyFLmNVuRiCKtMLdIxDZG3ZdUjpaVw9zvxbYI+/pwCz7FbF8bS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EB0BA6FB3DBE846A680FCDDF9AB5F0A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d369a7-d07f-4237-7d47-08d79bccdc98
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2020 04:14:08.2283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y1SZ5XM5rU558Hd2K/cwhhgXrZsglom1hDe3CWc3AT81Dje0JbCzRqrf0HRUmxHi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3708
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-18_01:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001180032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTcvMjAgMjo1NiBQTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4gZ2VuZXJpYyB1
cGRhdGUvZGVsZXRlIGJhdGNoIG9wcyBmdW5jdGlvbnMgd2VyZSB1c2luZyBfX2JwZl9jb3B5X2tl
eQ0KPiB3aXRob3V0IHByb3Blcmx5IGZyZWVpbmcgdGhlIG1lbW9yeS4gSGFuZGxlIHRoZSBtZW1v
cnkgYWxsb2NhdGlvbiBhbmQNCj4gY29weV9mcm9tX3VzZXIgc2VwYXJhdGVseS4NCj4gDQo+IFJl
cG9ydGVkLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+DQo+IEZp
eGVzOiBhYTJlOTNiOGU1OGUgKCJicGY6IEFkZCBnZW5lcmljIHN1cHBvcnQgZm9yIHVwZGF0ZSBh
bmQgZGVsZXRlDQo+IGJhdGNoIG9wcyIpDQoNClBsZWFzZSBwdXQgdGhlIHN1YmplY3Qgb2YgRml4
ZXMgY29tbWl0IGluIHRoZSBzYW1lIGxpbmUuDQpUaGlzIHdpbGwgbWFrZSB0b29scyBlYXNpZXIg
dG8gZ3JlcCAiRml4ZXMiIHRhZy4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBCcmlhbiBWYXpxdWV6IDxi
cmlhbnZ2QGdvb2dsZS5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29t
Pg0K
