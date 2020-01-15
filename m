Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463E013CDE2
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgAOUNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:13:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729061AbgAOUNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:13:31 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FK2IG0024446;
        Wed, 15 Jan 2020 12:13:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bY+FhCd6z8i3QKvyr1J8UVlPt2ftO0q0SnwtXvBKny0=;
 b=F8IKCg5cfb5FVQjVlQdnmpusSq/+HlqTy+0RN1nxuJ8LFQUCnYLmGCP587oYRRQVMf2A
 iXk6sSIqaDeSR2PnXg0FX7EarxtC5AXrJxWr+tnm2xB1p90VpRF+qqV9pD95UHquOYc6
 DTyxk/Vkc4LoBZu590I10s9Lz9biNQDyWJ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhd7r7sv8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jan 2020 12:13:09 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 12:13:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEDW9qv67y7XCiEwUhY0UP+Lv/o0gmiQvFPyz9LlhO5KlvlondLiQdHSsXXn+wJB/IycXG+dkizkrToVmUMhxEXB/RBRUfX1G08B+6zDeYeM/deXLoIcp61j9eC4hegQQCLts4D/hpyJf/NXBXIm9mZhJJgA3m2swf1VyZAz7UC7BWBcwtNLxQDIsTGTq7sYa1zxjfUyKBflfMST1FZ1D4J/w+I7saYaMz6W94JxsD+sBBGbryPcz/6Pz0BtUVFzTR4KIs8U6QUqT3VwnBRM0fwLw3ryjILfPter0FQb8rs9FX087d92bop7KpP9D0Rzc7vtWjkerrLuskziWibsAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY+FhCd6z8i3QKvyr1J8UVlPt2ftO0q0SnwtXvBKny0=;
 b=Vr7uGI7Ri+dQPTUjNBJ1nd7hhvOp/B4h2fcWoedO7JZ3JN9n3j+f+cu8juN9obVyk8hKXIrCBCqOQMLDEzNFXmtc0pL3Tk+xl91QuONFOr/zzP2aXcFcZCUmQlVU0VoXaeKjlXe2Aye2tK/FF+kGaL2JIK70jXpZYt/7nRv7fg/WeRMCqtT5epPj2staLqcQrvFh2xBk58fPV8Nc2m5M36i+ed22nN3h2/NT4UUQtBRa41IhogE/pkrBWPH1FLU1U+MYVGUaUNi6BfDvmfOfC0jP9TxoSkeO3SNDNSTvPlWmzWAkNpsWWoyXL6wnOBTzkYzFsyGsQj4rlBBPTFyqCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY+FhCd6z8i3QKvyr1J8UVlPt2ftO0q0SnwtXvBKny0=;
 b=EviIJNY/RiEoprAv+zq+G6YCEh5T93YLJynz4J/nOtNZsuNkG9gIJm6BNXnuMvEVfuQlNAYZ+4Q+zOIrZuh4nb8Q4Gwy0RHYAIHfquTtP97cLVsbecckW1Mgu5MPEif9jct3MjHwMBcFXy4sx6KBM2+5Kmvtbi888ufNpc+Njz4=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2204.namprd15.prod.outlook.com (20.176.67.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Wed, 15 Jan 2020 20:13:07 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 20:13:07 +0000
Received: from MacBook-Pro-52.local (2620:10d:c090:200::2:a3ec) by MWHPR08CA0038.namprd08.prod.outlook.com (2603:10b6:300:c0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Wed, 15 Jan 2020 20:13:06 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 0/9] add bpf batch ops to process more than 1
 elem
Thread-Topic: [PATCH v5 bpf-next 0/9] add bpf batch ops to process more than 1
 elem
Thread-Index: AQHVy9OrzGeDNAJmMkqjYt+LqUiC9KfsKLqA
Date:   Wed, 15 Jan 2020 20:13:07 +0000
Message-ID: <0ed19302-a43c-c04e-110e-eb1f0a72146f@fb.com>
References: <20200115184308.162644-1-brianvv@google.com>
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0038.namprd08.prod.outlook.com
 (2603:10b6:300:c0::12) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:a3ec]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eda325d0-300e-48d9-25e4-08d799f75601
x-ms-traffictypediagnostic: DM6PR15MB2204:
x-microsoft-antispam-prvs: <DM6PR15MB220490C0429299669FB7E66AD3370@DM6PR15MB2204.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(66946007)(4326008)(86362001)(66446008)(966005)(31686004)(5660300002)(316002)(6512007)(31696002)(110136005)(8936002)(81166006)(2906002)(64756008)(66556008)(66476007)(81156014)(8676002)(478600001)(16526019)(2616005)(7416002)(52116002)(53546011)(54906003)(6506007)(36756003)(186003)(6486002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2204;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N5s8R9vG+DQqH0olB1fjho2SqH8eT1v2G58mUMLD8fmaKU8EBeJ3yaqV6jLn5S9s34M8vIy9qcN9Buaxhml3Fx/yV+faB2WIWQ2aEt9PlNOv5fKfh/WnJMqXV0KHFwRWOQHfvxL58JUux5Fc/ZUnicqT2rjXV4ydqPa6t3MooIvI+MMdHqL8B8eq7xD6zlCcTA+87F7zcby+9m9JJCmPVR+WBEQqdCu2cSOwcWflQdX4RNL0JdvaCh8Atvtx6NIYFb06JuCwO5xrLuwV/XY0BdwaU7KFk/sFDLyFaKVrRXTz+ErXhV3zPkg9iHZOjUDrOx0wxDElAcZatSQMHjiXnZwqLOt7rH2yDE4tQZe3yd1zPuPbZnKGTkRiCvQeqwKqKBo08o2z+nylxzFyD7upo1cu2L4PiBXgF9bKeUKxlyN0fbB/NICm4Gq2r6gl9cz7rYacLshvcXbEesSbYHiKZeAVcj+W6KRj4dLULhNQNDw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5CEB5B16DA74A44AABA143FDD0F84E2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eda325d0-300e-48d9-25e4-08d799f75601
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 20:13:07.6371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7jgaEXTUbQX8zkdmdAMCwi+adNNfN0lhcA2CujIxUUHXVNq7ZX+wV3X3MxK5xwdr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2204
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTUvMjAgMTA6NDIgQU0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoaXMgcGF0
Y2ggc2VyaWVzIGludHJvZHVjZSBiYXRjaCBvcHMgdGhhdCBjYW4gYmUgYWRkZWQgdG8gYnBmIG1h
cHMgdG8NCj4gbG9va3VwL2xvb2t1cF9hbmRfZGVsZXRlL3VwZGF0ZS9kZWxldGUgbW9yZSB0aGFu
IDEgZWxlbWVudCBhdCB0aGUgdGltZSwNCj4gdGhpcyBpcyBzcGVjaWFsbHkgdXNlZnVsIHdoZW4g
c3lzY2FsbCBvdmVyaGVhZCBpcyBhIHByb2JsZW0gYW5kIGluIGNhc2UNCj4gb2YgaG1hcCBpdCB3
aWxsIHByb3ZpZGUgYSByZWxpYWJsZSB3YXkgb2YgdHJhdmVyc2luZyB0aGVtLg0KPiANCj4gVGhl
IGltcGxlbWVudGF0aW9uIGluY2x1ZXMgYSBnZW5lcmljIGFwcHJvYWNoIHRoYXQgY291bGQgcG90
ZW50aWFsbHkgYmUNCj4gdXNlZCBieSBhbnkgYnBmIG1hcCBhbmQgYWRkcyBpdCB0byBhcnJheW1h
cCwgaXQgYWxzbyBpbmNsdWRlcyB0aGUgc3BlY2lmaWMNCj4gaW1wbGVtZW50YXRpb24gb2YgaGFz
aG1hcHMgd2hpY2ggYXJlIHRyYXZlcnNlZCB1c2luZyBidWNrZXRzIGluc3RlYWQNCj4gb2Yga2V5
cy4NCj4gDQo+IFRoZSBicGYgc3lzY2FsbCBzdWJjb21tYW5kcyBpbnRyb2R1Y2VkIGFyZToNCj4g
DQo+ICAgIEJQRl9NQVBfTE9PS1VQX0JBVENIDQo+ICAgIEJQRl9NQVBfTE9PS1VQX0FORF9ERUxF
VEVfQkFUQ0gNCj4gICAgQlBGX01BUF9VUERBVEVfQkFUQ0gNCj4gICAgQlBGX01BUF9ERUxFVEVf
QkFUQ0gNCj4gDQo+IFRoZSBVQVBJIGF0dHJpYnV0ZSBpczoNCj4gDQo+ICAgIHN0cnVjdCB7IC8q
IHN0cnVjdCB1c2VkIGJ5IEJQRl9NQVBfKl9CQVRDSCBjb21tYW5kcyAqLw0KPiAgICAgICAgICAg
X19hbGlnbmVkX3U2NCAgIGluX2JhdGNoOyAgICAgICAvKiBzdGFydCBiYXRjaCwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogTlVMTCB0byBzdGFydCBmcm9t
IGJlZ2lubmluZw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Ki8NCj4gICAgICAgICAgIF9fYWxpZ25lZF91NjQgICBvdXRfYmF0Y2g7ICAgICAgLyogb3V0cHV0
OiBuZXh0IHN0YXJ0IGJhdGNoICovDQo+ICAgICAgICAgICBfX2FsaWduZWRfdTY0ICAga2V5czsN
Cj4gICAgICAgICAgIF9fYWxpZ25lZF91NjQgICB2YWx1ZXM7DQo+ICAgICAgICAgICBfX3UzMiAg
ICAgICAgICAgY291bnQ7ICAgICAgICAgIC8qIGlucHV0L291dHB1dDoNCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogaW5wdXQ6ICMgb2Yga2V5L3ZhbHVlDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGVsZW1lbnRzDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIG91dHB1dDogIyBv
ZiBmaWxsZWQgZWxlbWVudHMNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICovDQo+ICAgICAgICAgICBfX3UzMiAgICAgICAgICAgbWFwX2ZkOw0KPiAgICAgICAg
ICAgX191NjQgICAgICAgICAgIGVsZW1fZmxhZ3M7DQo+ICAgICAgICAgICBfX3U2NCAgICAgICAg
ICAgZmxhZ3M7DQo+ICAgIH0gYmF0Y2g7DQo+IA0KPiANCj4gaW5fYmF0Y2ggYW5kIG91dF9iYXRj
aCBhcmUgb25seSB1c2VkIGZvciBsb29rdXAgYW5kIGxvb2t1cF9hbmRfZGVsZXRlIHNpbmNlDQo+
IHRob3NlIGFyZSB0aGUgb25seSB0d28gb3BlcmF0aW9ucyB0aGF0IGF0dGVtcHQgdG8gdHJhdmVy
c2UgdGhlIG1hcC4NCj4gDQo+IHVwZGF0ZS9kZWxldGUgYmF0Y2ggb3BzIHNob3VsZCBwcm92aWRl
IHRoZSBrZXlzL3ZhbHVlcyB0aGF0IHVzZXIgd2FudHMNCj4gdG8gbW9kaWZ5Lg0KPiANCj4gSGVy
ZSBhcmUgdGhlIHByZXZpb3VzIGRpc2N1c3Npb25zIG9uIHRoZSBiYXRjaCBwcm9jZXNzaW5nOg0K
PiAgIC0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIwMTkwNzI0MTY1ODAzLjg3NDcwLTEt
YnJpYW52dkBnb29nbGUuY29tLw0KPiAgIC0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIw
MTkwODI5MDY0NTAyLjI3NTAzMDMtMS15aHNAZmIuY29tLw0KPiAgIC0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYnBmLzIwMTkwOTA2MjI1NDM0LjM2MzU0MjEtMS15aHNAZmIuY29tLw0KPiANCj4g
Q2hhbmdlbG9nIHNpbnZlIHY0Og0KPiAgIC0gUmVtb3ZlIHVubmVjZXNzYXJ5IGNoZWNrcyBmcm9t
IGxpYmJwZiBBUEkgKEFuZHJpaSBOYWtyeWlrbykNCj4gICAtIE1vdmUgREVDTEFSRV9MSUJCUEZf
T1BUUyB3aXRoIGFsbCB2YXIgZGVjbGFyYXRpb25zIChBbmRyaWkgTmFrcnlpa28pDQo+ICAgLSBD
aGFuZ2UgYnVja2V0IGludGVybmFsIGJ1ZmZlciBzaXplIHRvIDUgZW50cmllcyAoWW9uZ2hvbmcg
U29uZykNCj4gICAtIEZpeCBzb21lIG1pbm9yIGJ1Z3MgaW4gaGFzaHRhYiBiYXRjaCBvcHMgaW1w
bGVtZW50YXRpb24gKFlvbmdob25nIFNvbmcpDQo+IA0KPiBDaGFuZ2Vsb2cgc2ludmUgdjM6DQo+
ICAgLSBEbyBub3QgdXNlIGNvcHlfdG9fdXNlciBpbnNpZGUgYXRvbWljIHJlZ2lvbiAoWW9uZ2hv
bmcgU29uZykNCj4gICAtIFVzZSBfb3B0cyBhcHByb2FjaCBvbiBsaWJicGYgQVBJcyAoQW5kcmlp
IE5ha3J5aWtvKQ0KPiAgIC0gRHJvcCBnZW5lcmljX21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRj
aCBzdXBwb3J0DQo+ICAgLSBGcmVlIG1hbGxvYy1lZCBtZW1vcnkgaW4gdGVzdHMgKFlvbmdob25n
IFNvbmcpDQo+ICAgLSBSZXZlcnNlIGNocmlzdG1hcyB0cmVlIChZb25naG9uZyBTb25nKQ0KPiAg
IC0gQWRkIGFja2VkIGxhYmVscw0KPiANCj4gQ2hhbmdlbG9nIHNpbnZlIHYyOg0KPiAgIC0gQWRk
IGdlbmVyaWMgYmF0Y2ggc3VwcG9ydCBmb3IgbHBtX3RyaWUgYW5kIHRlc3QgaXQgKFlvbmdob25n
IFNvbmcpDQo+ICAgLSBVc2UgZGVmaW5lIE1BUF9MT09LVVBfUkVUUklFUyBmb3IgcmV0cmllcyAo
Sm9obiBGYXN0YWJlbmQpDQo+ICAgLSBSZXR1cm4gZXJyb3JzIGRpcmVjdGx5IGFuZCByZW1vdmUg
bGFiZWxzIChZb25naG9uZyBTb25nKQ0KPiAgIC0gSW5zZXJ0IG5ldyBBUEkgZnVuY3Rpb25zIGlu
dG8gbGliYnBmIGFscGhhYmV0aWNhbGx5IChZb25naG9uZyBTb25nKQ0KPiAgIC0gQ2hhbmdlIGhs
aXN0X251bGxzX2Zvcl9lYWNoX2VudHJ5X3JjdSB0bw0KPiAgICAgaGxpc3RfbnVsbHNfZm9yX2Vh
Y2hfZW50cnlfc2FmZSBpbiBodGFiIGJhdGNoIG9wcyAoWW9uZ2hvbmcgU29uZykNCj4gDQo+IENo
YW5nZWxvZyBzaW5jZSB2MToNCj4gICAtIEZpeCBTT0Igb3JkZXJpbmcgYW5kIHJlbW92ZSBDby1h
dXRob3JlZC1ieSB0YWcgKEFsZXhlaSBTdGFyb3ZvaXRvdikNCj4gDQo+IENoYW5nZWxvZyBzaW5j
ZSBSRkM6DQo+ICAgLSBDaGFuZ2UgYmF0Y2ggdG8gaW5fYmF0Y2ggYW5kIG91dF9iYXRjaCB0byBz
dXBwb3J0IG1vcmUgZmxleGlibGUgb3BhcXVlDQo+ICAgICB2YWx1ZXMgdG8gaXRlcmF0ZSB0aGUg
YnBmIG1hcHMuDQo+ICAgLSBSZW1vdmUgdXBkYXRlL2RlbGV0ZSBzcGVjaWZpYyBiYXRjaCBvcHMg
Zm9yIGh0YWIgYW5kIHVzZSB0aGUgZ2VuZXJpYw0KPiAgICAgaW1wbGVtZW50YXRpb25zIGluc3Rl
YWQuDQo+IA0KPiBCcmlhbiBWYXpxdWV6ICg1KToNCj4gICAgYnBmOiBhZGQgYnBmX21hcF97dmFs
dWVfc2l6ZSx1cGRhdGVfdmFsdWUsbWFwX2NvcHlfdmFsdWV9IGZ1bmN0aW9ucw0KPiAgICBicGY6
IGFkZCBnZW5lcmljIHN1cHBvcnQgZm9yIGxvb2t1cCBiYXRjaCBvcA0KPiAgICBicGY6IGFkZCBn
ZW5lcmljIHN1cHBvcnQgZm9yIHVwZGF0ZSBhbmQgZGVsZXRlIGJhdGNoIG9wcw0KPiAgICBicGY6
IGFkZCBsb29rdXAgYW5kIHVwZGF0ZSBiYXRjaCBvcHMgdG8gYXJyYXltYXANCj4gICAgc2VsZnRl
c3RzL2JwZjogYWRkIGJhdGNoIG9wcyB0ZXN0aW5nIHRvIGFycmF5IGJwZiBtYXANCj4gDQo+IFlv
bmdob25nIFNvbmcgKDQpOg0KPiAgICBicGY6IGFkZCBiYXRjaCBvcHMgdG8gYWxsIGh0YWIgYnBm
IG1hcA0KPiAgICB0b29scy9icGY6IHN5bmMgdWFwaSBoZWFkZXIgYnBmLmgNCj4gICAgbGliYnBm
OiBhZGQgbGliYnBmIHN1cHBvcnQgdG8gYmF0Y2ggb3BzDQo+ICAgIHNlbGZ0ZXN0cy9icGY6IGFk
ZCBiYXRjaCBvcHMgdGVzdGluZyBmb3IgaHRhYiBhbmQgaHRhYl9wZXJjcHUgbWFwDQo+IA0KPiAg
IGluY2x1ZGUvbGludXgvYnBmLmggICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxOCArDQo+
ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgICAgICAgICAgICAgICAgIHwgIDIxICsN
Cj4gICBrZXJuZWwvYnBmL2FycmF5bWFwLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIg
Kw0KPiAgIGtlcm5lbC9icGYvaGFzaHRhYi5jICAgICAgICAgICAgICAgICAgICAgICAgICB8IDI2
NCArKysrKysrKysNCj4gICBrZXJuZWwvYnBmL3N5c2NhbGwuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCA1NTQgKysrKysrKysrKysrKystLS0tDQo+ICAgdG9vbHMvaW5jbHVkZS91YXBpL2xp
bnV4L2JwZi5oICAgICAgICAgICAgICAgIHwgIDIxICsNCj4gICB0b29scy9saWIvYnBmL2JwZi5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgNTggKysNCj4gICB0b29scy9saWIvYnBmL2Jw
Zi5oICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMjIgKw0KPiAgIHRvb2xzL2xpYi9icGYv
bGliYnBmLm1hcCAgICAgICAgICAgICAgICAgICAgICB8ICAgNCArDQo+ICAgLi4uL2JwZi9tYXBf
dGVzdHMvYXJyYXlfbWFwX2JhdGNoX29wcy5jICAgICAgIHwgMTI5ICsrKysNCj4gICAuLi4vYnBm
L21hcF90ZXN0cy9odGFiX21hcF9iYXRjaF9vcHMuYyAgICAgICAgfCAyODMgKysrKysrKysrDQo+
ICAgMTEgZmlsZXMgY2hhbmdlZCwgMTI0OCBpbnNlcnRpb25zKCspLCAxMjggZGVsZXRpb25zKC0p
DQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9tYXBf
dGVzdHMvYXJyYXlfbWFwX2JhdGNoX29wcy5jDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9tYXBfdGVzdHMvaHRhYl9tYXBfYmF0Y2hfb3BzLmMNCg0K
VGhhbmtzIGZvciB0aGUgd29yayEgTEdUTS4gQWNrIGZvciB0aGUgd2hvbGUgc2VyaWVzLg0KDQpB
Y2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0K
