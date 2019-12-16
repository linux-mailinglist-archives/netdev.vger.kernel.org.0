Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F5C121A01
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfLPTeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:34:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35414 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfLPTeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:34:09 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGJPPKN015823;
        Mon, 16 Dec 2019 11:33:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AYh3YjksU1Fjkdc3+frvUqOjppsbzLY4diTV/M6Cops=;
 b=ozFsavC5Lv+giUGLPISJEFv6CRkPleLryKjkGIIGbAn70h2GXpH0rTt5GsyMFZTj6D3Q
 HXzVW94y1OicYN/E6JSSIYXgMw4moLEz24MewSz98wj6SMLjsKWxGFL+5TtmynEewJud
 IvRkDKFuwocyrgw2WehEPvorqbj0lKhSetk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwtq14b1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 11:33:51 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 11:33:50 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 11:33:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQA9jtC2gq6AQ7ssoD8ozfZaHzp6+lFXyeBjN/9vZ9DghjAcqsxEs+hqkgV4HCrVCpZmvtVZkFoK/OlS7AXwliTqWvvX5zT2jZvnnrjrGEQA66XF1psaVgg1vpwncsNJociUmZ9/Uf2PRJjEMx4KmMpxA+GUnJJoeT1YsbNv5n8nZRU+SJ3iSe96RNeElJxLlex9YMdEz+jcRZWblXLwsaArztkP22X4Z2hIZchNEeMus0klBFt17RCmppHUp+a+x83K2ZS4Q7c6kEc/vTtslFYUHVmjP7Ug8HNIINc+Q4D/expgtLkYU+CqJg33DFhwoKuqS/EuQmUJaYTsP7uICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYh3YjksU1Fjkdc3+frvUqOjppsbzLY4diTV/M6Cops=;
 b=oWmipoUyyUGnWRU8U9NHBkcRdbGtkKqbi0xW+7h8cSWYDzgOtF4WM9sO+ye1/Szj6BLCFH7AHxsnWIxBf5HrUBVt2XiUuSJvkt/3t8isX6GM1G4HrpBY/sKCo3Li+xjb8PQ8ubPE9ykTPxtpTCiyEaHA9Gv3DEiH1F7ZOVs+BfWHsvNhezGV7/rL6q23mHGIplEoLzYNin7ecad4sQiYx10gew+q5i8i5jdwYwSXOkFMKZbinPCU1qVTbT+Z0sfH5IPcJwH6xkasjXu+ByjuazreWfJ+uZ1o16xVPhIG9lFuq98DNfay8Gy0gQzpnaQbGSbgzmKUyBvpLUgYA6cZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYh3YjksU1Fjkdc3+frvUqOjppsbzLY4diTV/M6Cops=;
 b=GU3npQ66EKgWq0rxQq49nWMPU8yFHnMzBCXzVfFKShqjuBoQZPtU9oBMviS9EFkjllAdnTTXttpNT8t7txD0cl3sunls2iUv1G62wqhK8IHEjUto53+p/83r/FsZgQg7tCwUn7hJKHF+0yka1MK7QEF9krfVbor8b113CILRErs=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1626.namprd15.prod.outlook.com (10.175.105.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 19:33:49 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 19:33:49 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH bpf-next] libbpf: add zlib as a dependency in pkg-config
 template
Thread-Topic: [PATCH bpf-next] libbpf: add zlib as a dependency in pkg-config
 template
Thread-Index: AQHVtEASVSOXUEeCZEOUZ24TxYRvpae9JvcA
Date:   Mon, 16 Dec 2019 19:33:49 +0000
Message-ID: <b50659cb-4dcc-110e-e770-31615a11b5e7@fb.com>
References: <20191216183830.3972964-1-andriin@fb.com>
In-Reply-To: <20191216183830.3972964-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a1affd5-46b8-43a7-6202-08d7825ee00b
x-ms-traffictypediagnostic: DM5PR15MB1626:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1626414340B777BA0F75402AD3510@DM5PR15MB1626.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(189003)(199004)(186003)(5660300002)(86362001)(54906003)(110136005)(71200400001)(31696002)(316002)(6506007)(53546011)(66446008)(64756008)(66946007)(66556008)(52116002)(81166006)(81156014)(4326008)(2906002)(478600001)(31686004)(36756003)(8676002)(2616005)(6512007)(6486002)(66476007)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1626;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wKz+N5VkyWJu+X2mH/ta2IHwD1kU+chiVI2ztFu3eVt5FMGBFdVfxz3+yOI23L6INwWEcGm+aq3PM1P8UlWcqeLNJB1+dMtXqeI4tdSwriWLnTf5v36kXOHhgM2kpLDN/lyDgh2WplLvCR8fU+gVa/CUBqJX+O4v6aV7WIB/+94Pci+5g6MVRvkYni0dJQpufuib+Pa8Bd9kMAZcHg16jei1pMVDTsLVkq4NzIMknXU4sMBcp/PRZOd/iRIxqetVK/RRatQlb4GVc/6CkZcTFOgg93NFAsvRrhCLnyn/+xdB8bZl7wBXGWO3pD3y8xi87HkRfB0Epf0rS4YqmoVpcrdr3Ir3k2jBu/tCJPlj/LTXnKdLYqdYpb174GbIURR2XtzQzphn/7p6VD/5EK1MbZ8tX9q8U+6+/BcOSaNbFrb3XUjLXPWRzmpxSN81ed5q
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6092F117CBE9F41B06B34B4E0855DF7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1affd5-46b8-43a7-6202-08d7825ee00b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 19:33:49.5642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mBrHXvfyqO3wYc/CXJH3HK1H0Wmh26WtF2kKgu4ypmA0bOlztNWOuHBfkwYDX49H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1626
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 spamscore=0 mlxlogscore=862
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDEwOjM4IEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IExpc3Qg
emxpYiBhcyBhbm90aGVyIGRlcGVuZGVuY3kgb2YgbGliYnBmIGluIHBrZy1jb25maWcgdGVtcGxh
dGUuDQo+IFZlcmlmaWVkIGl0IGlzIGNvcnJlY3RseSByZXNvbHZlZCB0byBwcm9wZXIgLWx6IGZs
YWc6DQo+IA0KPiAkIG1ha2UgREVTVERJUj0vdG1wL2xpYmJwZi1pbnN0YWxsIGluc3RhbGwNCj4g
JCBwa2ctY29uZmlnIC0tbGlicyAvdG1wL2xpYmJwZi1pbnN0YWxsL3Vzci9sb2NhbC9saWI2NC9w
a2djb25maWcvbGliYnBmLnBjDQo+IC1ML3Vzci9sb2NhbC9saWI2NCAtbGJwZg0KPiAkIHBrZy1j
b25maWcgLS1saWJzIC0tc3RhdGljIC90bXAvbGliYnBmLWluc3RhbGwvdXNyL2xvY2FsL2xpYjY0
L3BrZ2NvbmZpZy9saWJicGYucGMNCj4gLUwvdXNyL2xvY2FsL2xpYjY0IC1sYnBmIC1sZWxmIC1s
eg0KDQpFdmVuIHdpdGhvdXQgdGhpcyBwYXRjaCwgSSBhbHJlYWR5IGdvdCAtbHogZm9yIHN0YXRp
YyBsaW5rIGxpYnJhcmllczoNCg0KLWJhc2gtNC40JCBjYXQgbGliYnBmLnBjLnRlbXBsYXRlDQou
Li4NClJlcXVpcmVzLnByaXZhdGU6IGxpYmVsZg0KLi4uDQotYmFzaC00LjQkIHBrZy1jb25maWcg
LS1saWJzIC0tc3RhdGljIA0KL3RtcC9saWJicGYtaW5zdGFsbC91c3IvbG9jYWwvbGliNjQvcGtn
Y29uZmlnL2xpYmJwZi5wYw0KLUwvdXNyL2xvY2FsL2xpYjY0IC1sYnBmIC1sZWxmIC1seg0KDQps
aWJlbGYgZGVwZW5kaW5nIG9uIHpsaWIuIE1heWJlIC1seiBpcyBpbnRyb2R1Y2VkIGR1ZSB0byBs
aWJlbGYuDQoNCkJ1dCBpbiBhbnkgY2FzZSwgYWRkIGV4cGxpY2l0IGRlcGVuZGVuY3kgdG8gemxp
YiBmcm9tIGxpYmJwZiBwcm9iYWJseQ0KYSBnb29kIHRoaW5nIHNpbmNlIGxpYmJwZiBkaXJlY3Rs
eSB1c2VzIGl0cyBBUEkgZnVuY3Rpb25zLg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhz
QGZiLmNvbT4NCg0KDQpbLi4uXQ0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYu
cGMudGVtcGxhdGUgYi90b29scy9saWIvYnBmL2xpYmJwZi5wYy50ZW1wbGF0ZQ0KPiBpbmRleCBh
YzE3ZmNlZjIxMDguLmI0NWVkNTM0YmRmYiAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGliL2JwZi9s
aWJicGYucGMudGVtcGxhdGUNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYucGMudGVtcGxh
dGUNCj4gQEAgLTgsNSArOCw1IEBAIE5hbWU6IGxpYmJwZg0KPiAgIERlc2NyaXB0aW9uOiBCUEYg
bGlicmFyeQ0KPiAgIFZlcnNpb246IEBWRVJTSU9OQA0KPiAgIExpYnM6IC1MJHtsaWJkaXJ9IC1s
YnBmDQo+IC1SZXF1aXJlcy5wcml2YXRlOiBsaWJlbGYNCj4gK1JlcXVpcmVzLnByaXZhdGU6IGxp
YmVsZiB6bGliDQo+ICAgQ2ZsYWdzOiAtSSR7aW5jbHVkZWRpcn0NCj4gDQo=
