Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F3CC8FA2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfJBRTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:19:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24450 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbfJBRTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:19:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92HDGib032465;
        Wed, 2 Oct 2019 10:18:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2U9m3zEa1J2WIPmwVqO4XJTLvqrceRqseNnu6R99SKw=;
 b=ZXhg5O8iE8ufOiWOatkxb8tD1Y2btWqHG8csB3rFrYQ2Jcun4bg3waEg3yZ0pzmVNE96
 t+QsEOM5eqf8/cLzeNMeNu7pqjIciRFvnZEcJiumSw2pButzH9ef3JdeMOv7zRoupb0m
 Pwy5m6qm6CQ/FMy4MtK4McSSE7zF8raX78A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vc9fw63sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 10:18:25 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 10:18:24 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 10:18:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLGBGeI6h/qsf/NvyqbdhWrBGhPWvxXCJrfk08V0lifau9Pjyk0nWAYEvTxYo+mNa9hKWqN6MmliVmfuDBhBpwUQ1Va1VE7yEv2GjAoASiiKzD4WUK0c/Tkn4xLhVkcYfYCfnJsXttyR/fR1OH3bSPDOQbzXDSgU4onb6xM9r/AvdknG2El4gtdtRcqe1lb1E+5zEzAeA1HprKHAoTF2mNI+WQ5VAF4l9RrnQd6ohhDgOVRX2+8sogV8vwDyH8shNO1Jp2JyYK0Kw8CoiTNsv1XypcaaAEc+xnUJr9OwRpueLh9kyUz6moIisSIXaj/ue52rKvvLR7Z3kZlpjIie6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U9m3zEa1J2WIPmwVqO4XJTLvqrceRqseNnu6R99SKw=;
 b=cfIWBSJQuQpeby1sp2L6yAwocRm+LJgV2YInL56zwtRqBjMtVd5H/iz2ZOxAl9ANclVNlankD3q/K3s0pJCk/XkSCIkMtjvhGSvsyt1tgP030/LKlkYjvf8zFG5aorLbsOMGGzjRF3TCy5OM/JHvBGtl3YMWIKK53d8LOyJXBU8rJIfOQQDToR4ZXsl8yaC4seC4dPkHcbCpvkQqpmx5nmYiw7979VJuHDCtU7MrSrsjr0TaHvPUGor5JnnjIoRh/051TezVSw3O8We1QZKcWSBaJ05PAClS8PVhwRfTKP5nH7n3kGtAcAFc80ZjQNUtn2H3mt/UbXLY8K99EdDaLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U9m3zEa1J2WIPmwVqO4XJTLvqrceRqseNnu6R99SKw=;
 b=iCOsoNI7OEY0WOMI6a3r7bUuX4hnllE0gR5BXltB6RDL4oBAWiKe5F7zMvbfUgJ1ldEZk60hGCkZXFY0RkXAzfl0uqwWHTqGiIV4fKj3QV1GDHetXJFRKK4Z9DyX0kT64hUoNAC9EGJqCks2OYqWKPgKEI9JLBFLuot4GfDVHEU=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3336.namprd15.prod.outlook.com (20.179.57.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 17:18:22 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 17:18:22 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Andy Lutomirski" <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Thread-Topic: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Thread-Index: AQHVXRmQqSOzyqrm4ECmsLsG3CKso6cPnGwAgAAaLYCAAAXUgIAAP7UAgAAYzoCAARgsgIAAHuKAgAA4VQCAMGzZgIACzy2AgABy1ACAAVzMAIAAAg8AgAAIL4CAATZYgA==
Date:   Wed, 2 Oct 2019 17:18:21 +0000
Message-ID: <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
References: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home> <201909301129.5A1129C@keescook>
 <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
 <20191001181052.43c9fabb@gandalf.local.home>
 <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
 <20191001184731.0ec98c7a@gandalf.local.home>
In-Reply-To: <20191001184731.0ec98c7a@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:104:4::33) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2790]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa0908d2-eed9-4edb-2784-08d7475c861a
x-ms-traffictypediagnostic: BYAPR15MB3336:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB333622CFB6130434008111B2D79C0@BYAPR15MB3336.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(396003)(366004)(136003)(199004)(189003)(6512007)(99286004)(11346002)(305945005)(476003)(6506007)(52116002)(2906002)(102836004)(76176011)(256004)(14444005)(6116002)(386003)(53546011)(486006)(186003)(316002)(31696002)(7416002)(86362001)(7736002)(446003)(81156014)(25786009)(81166006)(8936002)(229853002)(2616005)(71190400001)(71200400001)(8676002)(31686004)(14454004)(6246003)(66476007)(66556008)(64756008)(66446008)(6436002)(66946007)(36756003)(6486002)(4326008)(46003)(6916009)(478600001)(54906003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3336;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5+lgMt+Nr9+bICJADGmgpYU0RCvPTmADTPcDlh6QviWJZHEA7exW1xMSyfc+V8lApUsVuD+lA7sh7AGndFqev2urNDgZQuY0aOpCG7RIyGQWBkQJfIEqJLTya2PDxSQ4mj3GPNFqkDWtC835l9E1x8PxNUTDQQ2vhng93ZlkgtMr9oFFBdgIpLeNMbaYC3jouW2ejbtO77he6f+vHwxQezfmrCFiu6krrRWl/IxHLO5ZiPE1DpXukpzffC05quyfVtjfRIB2nivxROYGPfGAGYvJ9ra7NHqK6FJ3jrocQsGdcm4C1x6PdQoQwhPtEe3luBBKNW6T1rtSGpMQOswsOe6gZarPymJyPr43tFZWj7SndEwNHt2ug7HSl74XnYoMw90fXGGZugjenabvgJJLxHy28+lEIFi0FCRsqk68Ts=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C67F4DB606ECE4B98C15C3E6FFF0E7B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0908d2-eed9-4edb-2784-08d7475c861a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 17:18:21.2226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7l488ctAl6vHfUK9i0xBRt5AWpyxdEGaOFUxlIiHTkXr+nSwJTVU3lIgJraWg4CG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3336
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_07:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910020145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMS8xOSAzOjQ3IFBNLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4gT24gVHVlLCAxIE9j
dCAyMDE5IDIyOjE4OjE4ICswMDAwDQo+IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGZiLmNvbT4g
d3JvdGU6DQo+IA0KPj4+IEFuZCB0aGVuIHlvdSBjYW4ganVzdCBmb3JtYXQgdGhlIHN0cmluZyBm
cm9tIHRoZSBicGZfdHJhY2VfcHJpbnRrKCkNCj4+PiBpbnRvIG1zZywgYW5kIHRoZW4gaGF2ZToN
Cj4+Pg0KPj4+IAl0cmFjZV9icGZfcHJpbnQobXNnKTsNCj4+DQo+PiBJdCdzIGFuIGludGVyZXN0
aW5nIGlkZWEsIGJ1dCBJIGRvbid0IHRoaW5rIGl0IGNhbiB3b3JrLg0KPj4gUGxlYXNlIHNlZSBi
cGZfdHJhY2VfcHJpbnRrIGltcGxlbWVudGF0aW9uIGluIGtlcm5lbC90cmFjZS9icGZfdHJhY2Uu
Yw0KPj4gSXQncyBhIGxvdCBtb3JlIHRoYW4gc3RyaW5nIHByaW50aW5nLg0KPiANCj4gV2VsbCwg
dHJhY2VfcHJpbnRrKCkgaXMganVzdCBzdHJpbmcgcHJpbnRpbmcuIEkgd2FzIHRoaW5raW5nIHRo
YXQgdGhlDQo+IGJwZl90cmFjZV9wcmludGsoKSBjb3VsZCBqdXN0IHVzZSBhIHZzbnByaW50Zigp
IGludG8gYSB0ZW1wb3JhcnkgYnVmZmVyDQo+IChsaWtlIHRyYWNlX3ByaW50aygpIGRvZXMpLCBh
bmQgdGhlbiBjYWxsIHRoZSB0cmFjZSBldmVudCB0byB3cml0ZSBpdA0KPiBvdXQuDQoNCmFyZSB5
b3UgcHJvcG9zaW5nIHRvIHJlcGxpY2F0ZSBnZXRfdHJhY2VfYnVmKCkgZnVuY3Rpb25hbGl0eQ0K
aW50byBicGZfdHJhY2VfcHJpbnRrPw0KU28gcHJpbnQgaW50byB0ZW1wIHN0cmluZyBidWZmZXIg
aXMgZG9uZSB0d2ljZT8NCkknbSBub3QgZXhjaXRlZCBhYm91dCBzdWNoIGhhY2suDQpBbmQgd2hh
dCdzIHRoZSBnb2FsPyBzbyB0aGF0IHRyYWNlX2JwZl9wcmludChzdHJpbmdfbXNnKTsNCmNhbiBn
byB0aHJvdWdoIF9ydW4tdGltZV8gY2hlY2sgd2hldGhlciB0aGF0IHBhcnRpY3VsYXIgdHJhY2Ug
ZXZlbnQNCndhcyBhbGxvd2VkIGluIHRyYWNlZnMgPw0KVGhhdCdzIG5vdCBob3cgZmlsZSBzeXN0
ZW0gYWNscyBhcmUgdHlwaWNhbGx5IGRlc2lnbmVkLg0KVGhlIHBlcm1pc3Npb24gY2hlY2sgaXMg
YXQgb3BlbigpLiBOb3QgYXQgd3JpdGUoKS4NCklmIEkgdW5kZXJzdG9vZCB5b3UgY29ycmVjdGx5
IHlvdSdyZSBwcm9wb3NpbmcgdG8gY2hlY2sgcGVybWlzc2lvbnMNCmF0IGJwZiBwcm9ncmFtIHJ1
bi10aW1lIHdoaWNoIGlzIG5vIGdvb2QuDQoNCmJwZl90cmFjZV9wcmludGsoKSBhbHJlYWR5IGhh
cyBvbmUgc21hbGwgYnVmZmVyIGZvcg0KcHJvYmVfa2VybmVsX3JlYWQtaW5nIGFuIHVua25vd24g
c3RyaW5nIHRvIHBhc3MgaW50byAlcy4NClRoYXQncyBub3QgZnRyYWNlLiBUaGF0J3MgY29yZSB0
cmFjaW5nLiBUaGF0IGFzcGVjdCBpcyBjb3ZlcmVkIGJ5IA0KQ0FQX1RSQUNJTkcgYXMgd2VsbC4N
Cg0KDQo+Pg0KPj4+IFRoZSB1c2VyIGNvdWxkIHRoZW4ganVzdCBlbmFibGUgdGhlIHRyYWNlIGV2
ZW50IGZyb20gdGhlIGZpbGUgc3lzdGVtLiBJDQo+Pj4gY291bGQgYWxzbyB3b3JrIG9uIG1ha2lu
ZyBpbnN0YW5jZXMgd29yayBsaWtlIC90bXAgZG9lcyAod2l0aCB0aGUNCj4+PiBzdGlja3kgYml0
KSBpbiBjcmVhdGlvbi4gVGhhdCB3YXkgcGVvcGxlIHdpdGggd3JpdGUgYWNjZXNzIHRvIHRoZQ0K
Pj4+IGluc3RhbmNlcyBkaXJlY3RvcnksIGNhbiBtYWtlIHRoZWlyIG93biBidWZmZXJzIHRoYXQg
dGhleSBjYW4gdXNlIChhbmQNCj4+PiBvdGhlcnMgY2FuJ3QgYWNjZXNzKS4NCj4+DQo+PiBXZSB0
cmllZCBpbnN0YW5jZXMgaW4gYmNjIGluIHRoZSBwYXN0IGFuZCBldmVudHVhbGx5IHJlbW92ZWQg
YWxsIHRoZQ0KPj4gc3VwcG9ydC4gVGhlIG92ZXJoZWFkIG9mIGluc3RhbmNlcyBpcyB0b28gaGln
aCB0byBiZSB1c2FibGUuDQo+IA0KPiBXaGF0IG92ZXJoZWFkPyBBbiBmdHJhY2UgaW5zdGFuY2Ug
c2hvdWxkIG5vdCBoYXZlIGFueSBtb3JlIG92ZXJoZWFkIHRoYW4NCj4gdGhlIHJvb3Qgb25lIGRv
ZXMgKGl0J3MgdGhlIHNhbWUgY29kZSkuIE9yIGFyZSB5b3UgdGFsa2luZyBhYm91dCBtZW1vcnkN
Cj4gb3ZlcmhlYWQ/DQoNClllcy4gTWVtb3J5IG92ZXJoZWFkLiBIdW1hbiB1c2VycyBkb2luZyBj
YXQvZWNobyBpbnRvIHRyYWNlZnMgd29uJ3QgYmUNCmNyZWF0aW5nIG1hbnkgaW5zdGFuY2VzLCBz
byB0aGF0J3MgdGhlIG9ubHkgcHJhY3RpY2FsIHVzYWdlIG9mIHRoZW0uDQoNCj4gDQo+Pg0KPj4+
DQo+Pj4gICAgDQo+Pj4+DQo+Pj4+IEJvdGggJ3RyYWNlJyBhbmQgJ3RyYWNlX3BpcGUnIGhhdmUg
cXVpcmt5IHNpZGUgZWZmZWN0cy4NCj4+Pj4gTGlrZSBvcGVuaW5nICd0cmFjZScgZmlsZSB3aWxs
IG1ha2UgYWxsIHBhcmFsbGVsIHRyYWNlX3ByaW50aygpIHRvIGJlIGlnbm9yZWQuDQo+Pj4+IFdo
aWxlIHJlYWRpbmcgJ3RyYWNlX3BpcGUnIGZpbGUgd2lsbCBjbGVhciBpdC4NCj4+Pj4gVGhlIHBv
aW50IHRoYXQgdHJhZGl0aW9uYWwgJ3JlYWQnIGFuZCAnd3JpdGUnIEFDTHMgZG9uJ3QgbWFwIGFz
LWlzDQo+Pj4+IHRvIHRyYWNlZnMsIHNvIEkgd291bGQgYmUgY2FyZWZ1bCBjYXRlZ29yaXppbmcg
dGhpbmdzIGludG8NCj4+Pj4gY29uZmlkZW50aWFsaXR5IHZzIGludGVncml0eSBvbmx5IGJhc2Vk
IG9uIGFjY2VzcyB0eXBlLg0KPj4+DQo+Pj4gV2hhdCBleGFjdGx5IGlzIHRoZSBicGZfdHJhY2Vf
cHJpbnRrKCkgdXNlZCBmb3I/IEkgbWF5IGhhdmUgb3RoZXIgaWRlYXMNCj4+PiB0aGF0IGNhbiBo
ZWxwLg0KPj4NCj4+IEl0J3MgZGVidWdnaW5nIG9mIGJwZiBwcm9ncmFtcy4gU2FtZSBpcyB3aGF0
IHByaW50aygpIGlzIHVzZWQgZm9yDQo+PiBieSBrZXJuZWwgZGV2ZWxvcGVycy4NCj4+DQo+IA0K
PiBIb3cgaXMgaXQgZXh0cmFjdGVkPyBKdXN0IHJlYWQgZnJvbSB0aGUgdHJhY2Ugb3IgdHJhY2Vf
cGlwZSBmaWxlPw0KDQp5ZXAuIEp1c3QgbGlrZSBrZXJuZWwgZGV2cyBsb29rIGF0IGRtZXNnIHdo
ZW4gdGhleSBzcHJpbmtsZSBwcmludGsuDQpidHcsIGlmIHlvdSBjYW4gZml4ICd0cmFjZScgZmls
ZSBpc3N1ZSB0aGF0IHN0b3BzIGFsbCB0cmFjZV9wcmludGsNCndoaWxlICd0cmFjZScgZmlsZSBp
cyBvcGVuIHRoYXQgd291bGQgYmUgZ3JlYXQuDQpTb21lIHVzZXJzIGhhdmUgYmVlbiBiaXR0ZW4g
YnkgdGhpcyBiZWhhdmlvci4gV2UgZXZlbiBkb2N1bWVudGVkIGl0Lg0K
