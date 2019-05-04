Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81A61370E
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfEDCik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:38:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726302AbfEDCik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:38:40 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x442c0L5006371;
        Fri, 3 May 2019 19:38:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=n6QSfUWs6JVXAqPZfbgR+AS7wuTKpVB6t73KuoPt/ug=;
 b=orsyrJu52WJELYM/zAgV2u3/lbfQx4fT0oyc55tF6sKvfULJr6j0qF0iPdgxg2h0np9K
 q/xELaBQzdG6vHOr6pt5xT1+OdkarH/m78f+36qGTKtKVi0SN4dfoOJxotjAA4Wurz0d
 Sx1C7dnq+9U/mKL7/2wOnE2CQj11K/oE9RE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2s8ssxsdvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 03 May 2019 19:38:18 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 May 2019 19:38:18 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 3 May 2019 19:38:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6QSfUWs6JVXAqPZfbgR+AS7wuTKpVB6t73KuoPt/ug=;
 b=Z5IA3PoXE8TETkQo3gGQAxLQZLbBZCx36HZKxuN68bGiPnJ1C98V0H+DbTmLPnjJyIknOTNy8JPWsIqZESeHNn9PjBzXC7vDZ0c9eKKxyFcQEEmwtvWbeiF7ZMALom3Vq+55HyyhfwxnTepzTFBi4+Z6/0h6xpkp+gnqR/0tH+s=
Received: from BYAPR15MB2311.namprd15.prod.outlook.com (52.135.197.145) by
 BYAPR15MB2197.namprd15.prod.outlook.com (52.135.196.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Sat, 4 May 2019 02:38:16 +0000
Received: from BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::d0cd:ad09:6bf5:7e06]) by BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::d0cd:ad09:6bf5:7e06%6]) with mapi id 15.20.1856.012; Sat, 4 May 2019
 02:38:16 +0000
From:   Lawrence Brakmo <brakmo@fb.com>
To:     Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 5/7] bpf: sysctl for probe_on_drop
Thread-Topic: [PATCH v2 bpf-next 5/7] bpf: sysctl for probe_on_drop
Thread-Index: AQHU6ntMBPt++Bc1k02B9em4sME2AKYyd80AgAAOKYCAAAjhAIAna7KA
Date:   Sat, 4 May 2019 02:38:16 +0000
Message-ID: <EABEEF62-A141-4F8B-8691-8361A246B6F3@fb.com>
References: <20190404001250.140554-1-brakmo@fb.com>
 <20190404001250.140554-6-brakmo@fb.com>
 <CADVnQynFtNiQxsRNx7phxsxgSRXowFag1=qbw0WrHyWHOnZ7Lw@mail.gmail.com>
 <1c827078-f462-0bbd-e03d-1c3d07ec593b@gmail.com>
 <CAK6E8=c3dJtubxWWFYyVGj5THtbtLFVx69VbbepR5HNwkyc8WQ@mail.gmail.com>
In-Reply-To: <CAK6E8=c3dJtubxWWFYyVGj5THtbtLFVx69VbbepR5HNwkyc8WQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.18.0.190414
x-originating-ip: [2620:10d:c090:200::1:d434]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40877553-883e-4e33-82bd-08d6d0398ff2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2197;
x-ms-traffictypediagnostic: BYAPR15MB2197:
x-microsoft-antispam-prvs: <BYAPR15MB2197BE9DFBBD8511F5CBEE1FA9360@BYAPR15MB2197.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0027ED21E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39860400002)(136003)(346002)(199004)(189003)(65514003)(53936002)(102836004)(486006)(6486002)(229853002)(66476007)(66946007)(76116006)(66446008)(64756008)(6116002)(66556008)(91956017)(73956011)(81166006)(81156014)(76176011)(58126008)(68736007)(53546011)(6506007)(11346002)(316002)(71190400001)(476003)(83716004)(2616005)(14454004)(446003)(99286004)(71200400001)(110136005)(478600001)(6246003)(54906003)(4326008)(6436002)(46003)(36756003)(305945005)(6512007)(7736002)(256004)(5660300002)(8936002)(25786009)(2906002)(82746002)(8676002)(186003)(33656002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2197;H:BYAPR15MB2311.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fTveImIaf/xUKaSg5Fytg12wm9vZNt0WiEaOSPs3cuvtrH4Q5C/lLQMc2iU6vo6bg2YzkYc+5QdyJiARJ2avCxbsfZmFJUPNR1KVNWPFJNzPuKBdTwxenp0+QseqsNSKjriHD+ZRlquon+lftJE7jyia0gZLeiYrh1ZNdYNUdSbBKqRPfgluQlyRYZDwCO8fwpY7ZnPVZyalHx1zzRyhnvEjpO7rbEdfyciCnPYNrJ/l/T7OKDdGAZGMfZQ5ntmN8uDmwqasy4l48sPQLLsQXSQ3TT0P5fFSO2pwU41RYR80P6FQGoOcTmDkUbMCuVnrwnK/7VA1Hs1poVxstvU1n1+j8QdlkkgUZ5rHLLz+lGcnhv2KYMtSxKLrwIgWX5czb8/kYJJuv10CM5qPts4gIUFtjN7pY+Kr9jq/4e8HTMA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0B72FB4FE1D7A4795343C98E91A881F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40877553-883e-4e33-82bd-08d6d0398ff2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2019 02:38:16.4861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-04_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=425 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905040020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA0LzgvMTksIDEwOjM5IEFNLCAiWXVjaHVuZyBDaGVuZyIgPHljaGVuZ0Bnb29nbGUu
Y29tPiB3cm90ZToNCg0KICAgIE9uIE1vbiwgQXByIDgsIDIwMTkgYXQgMTA6MDcgQU0gRXJpYyBE
dW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPiB3cm90ZToNCiAgICA+DQogICAgPg0KICAg
ID4NCiAgICA+IE9uIDA0LzA4LzIwMTkgMDk6MTYgQU0sIE5lYWwgQ2FyZHdlbGwgd3JvdGU6DQog
ICAgPiA+IE9uIFdlZCwgQXByIDMsIDIwMTkgYXQgODoxMyBQTSBicmFrbW8gPGJyYWttb0BmYi5j
b20+IHdyb3RlOg0KICAgID4gPj4NCiAgICA+ID4+IFdoZW4gYSBwYWNrZXQgaXMgZHJvcHBlZCB3
aGVuIGNhbGxpbmcgcXVldWVfeG1pdCBpbiAgX190Y3BfdHJhbnNtaXRfc2tiDQogICAgPiA+PiBh
bmQgcGFja2V0c19vdXQgaXMgMCwgaXQgaXMgYmVuZWZpY2lhbCB0byBzZXQgYSBzbWFsbCBwcm9i
ZSB0aW1lci4NCiAgICA+ID4+IE90aGVyd2lzZSwgdGhlIHRocm91Z2hwdXQgZm9yIHRoZSBmbG93
IGNhbiBzdWZmZXIgYmVjYXVzZSBpdCBtYXkgbmVlZCB0bw0KICAgID4gPj4gZGVwZW5kIG9uIHRo
ZSBwcm9iZSB0aW1lciB0byBzdGFydCBzZW5kaW5nIGFnYWluLiBUaGUgZGVmYXVsdCB2YWx1ZSBm
b3INCiAgICA+ID4+IHRoZSBwcm9iZSB0aW1lciBpcyBhdCBsZWFzdCAyMDBtcywgdGhpcyBwYXRj
aCBzZXRzIGl0IHRvIDIwbXMgd2hlbiBhDQogICAgPiA+PiBwYWNrZXQgaXMgZHJvcHBlZCBhbmQg
dGhlcmUgYXJlIG5vIG90aGVyIHBhY2tldHMgaW4gZmxpZ2h0Lg0KICAgID4gPj4NCiAgICA+ID4+
IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIG5ldyBzeXNjdGwsIHN5c2N0bF90Y3BfcHJvYmVfb25f
ZHJvcF9tcywgdGhhdCBpcw0KICAgID4gPj4gdXNlZCB0byBzcGVjaWZ5IHRoZSBkdXJhdGlvbiBv
ZiB0aGUgcHJvYmUgdGltZXIgZm9yIHRoZSBjYXNlIGRlc2NyaWJlZA0KICAgID4gPj4gZWFybGll
ci4gVGhlIGFsbG93ZWQgdmFsdWVzIGFyZSBiZXR3ZWVuIDAgYW5kIFRDUF9SVE9fTUlOLiBBIHZh
bHVlIG9mIDANCiAgICA+ID4+IGRpc2FibGVzIHNldHRpbmcgdGhlIHByb2JlIHRpbWVyIHdpdGgg
YSBzbWFsbCB2YWx1ZS4NCiAgICA+DQogICAgPiBUaGlzIHNlZW1zIHRvIGNvbnRyYWRpY3Qgb3Vy
IHJlY2VudCB3b3JrID8NCiAgICA+DQogICAgPiBTZWUgcmVjZW50IFl1Y2h1bmcgcGF0Y2ggc2Vy
aWVzIDoNCiAgICA+DQogICAgPiBjMWQ1Njc0ZjgzMTNiOWY4ZTY4M2MyNjVmMWMwMGEyNTgyY2Y1
ZmM1IHRjcDogbGVzcyBhZ2dyZXNzaXZlIHdpbmRvdyBwcm9iaW5nIG9uIGxvY2FsIGNvbmdlc3Rp
b24NCiAgICA+IDU5MGQyMDI2ZDYyNDE4YmIyN2RlOWNhODc1MjZlOTEzMWMxZjQ4YWYgdGNwOiBy
ZXRyeSBtb3JlIGNvbnNlcnZhdGl2ZWx5IG9uIGxvY2FsIGNvbmdlc3Rpb24NCiAgICANCiAgICBJ
IHdvdWxkIGFwcHJlY2lhdGUgYSBkaXJlY3QgY2hhbmdlIHRvIFRDUCBzdGFjayBzdGFydHMgd2l0
aCB0Y3A6DQogICAgc3ViamVjdCBpbnN0ZWFkIG9mIHRoZSBjb25mdXNpbmcgYnBmIGZvciBUQ1Ag
ZGV2ZWxvcGVycy4NCg0KWW91IGFyZSByaWdodCwgdGhhbmsgeW91IGZvciBwb2ludGluZyB0aGlz
IG91dC4NCiAgICANCiAgICBwYWNrZXQgYmVpbmcgZHJvcHBlZCBhdCBsb2NhbCBsYXllciBpcyBh
IHNpZ24gb2Ygc2V2ZXJlIG9mIGNvbmdlc3Rpb24NCiAgICAtLSBpdCdzIGNhdXNlZCBieSBhcHBs
aWNhdGlvbiBidXJzdGluZyBvbiBtYW55IChpZGxlIG9yIG5ldykNCiAgICBjb25uZWN0aW9ucy4g
V2l0aCB0aGlzIHBhdGNoLCB0aGUgKG1hbnkpIGNvbm5lY3Rpb25zIHRoYXQgZmFpbCBvbiB0aGUN
CiAgICBmaXJzdCB0cnkgKGluY2x1ZGluZyBTWU4gYW5kIHB1cmUgQUNLcykgd2lsbCBhbGwgY29t
ZSBiYWNrIGF0IDIwbXMsDQogICAgaW5zdGVhZCBvZiB0aGUgUlRUcy1hZGp1c3RlZCBSVE9zLiBT
byB0aGUgZW5kIGVmZmVjdCBpcyB0aGUNCiAgICBhcHBsaWNhdGlvbiByZXBldGl0aXZlbHkgcG91
bmRpbmcgdGhlIGxvY2FsIHFkaXNjIHRocm91Z2ggdG8gc3F1ZWV6ZQ0KICAgIG91dCBzb21lIHBl
cmZvcm1hbmNlLg0KICAgIA0KICAgIFRoaXMgcGF0Y2ggc2VlbXMgdG8gYXBwbHkgZm9yIGEgc3Bl
Y2lhbCBjYXNlIHdoZXJlIGxvY2FsIGNvbmdlc3Rpb24NCiAgICBvbmx5IGxpdmVzIGZvciBhIHZl
cnkgc2hvcnQgcGVyaW9kLiBJIGRvbid0IHRoaW5rIGl0IGFwcGxpZXMgd2VsbCBhcyBhDQogICAg
Z2VuZXJhbCBwcmluY2lwbGUgZm9yIGNvbmdlc3Rpb24gY29udHJvbC4NCiAgICANCkkgYW0gdGFr
aW5nIHRoaXMgb3V0IG9mIHRoZSBwYXRjaHNldCBhbmQgd2lsbCByZXZpc2l0IGl0IGxhdGVyLg0K
ICAgIA0KICAgIA0KICAgID4gOTcyMWU3MDlmYTY4ZWY5Yjg2MGMzMjJiNDc0Y2ZiZDFmODI4NWIw
ZiB0Y3A6IHNpbXBsaWZ5IHdpbmRvdyBwcm9iZSBhYm9ydGluZyBvbiBVU0VSX1RJTUVPVVQNCiAg
ICA+IDAxYTUyM2IwNzE2MThhYmJjNjM0ZDE5NTgyMjlmZTNiZDJkZmE1ZmEgdGNwOiBjcmVhdGUg
YSBoZWxwZXIgdG8gbW9kZWwgZXhwb25lbnRpYWwgYmFja29mZg0KICAgID4gYzdkMTNjOGZhYTc0
ZjRlOGVmMTkxZjg4YTI1MmNlZmFiNjgwNWIzOCB0Y3A6IHByb3Blcmx5IHRyYWNrIHJldHJ5IHRp
bWUgb24gcGFzc2l2ZSBGYXN0IE9wZW4NCiAgICA+IDdhZTE4OTc1OWNjNDhjZjhiNTRiZWViZmY1
NjZlOWZkMmQ0ZTdkN2MgdGNwOiBhbHdheXMgc2V0IHJldHJhbnNfc3RhbXAgb24gcmVjb3ZlcnkN
CiAgICA+IDdmMTI0MjJjNDg3M2U5YjI3NGJjMTUxZWE1OWNiMGNkZjk0MTVjZjEgdGNwOiBhbHdh
eXMgdGltZXN0YW1wIG9uIGV2ZXJ5IHNrYiB0cmFuc21pc3Npb24NCiAgICA+DQogICAgDQoNCg==
