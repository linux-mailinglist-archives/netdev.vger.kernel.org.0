Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2080777B00
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387985AbfG0SUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:20:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17790 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387841AbfG0SUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:20:46 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIJ276022482;
        Sat, 27 Jul 2019 11:20:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=78XAT6hkN5sh3f9EbG3MCmBvbQwWm7t3yxmYusVe+4o=;
 b=Qht3Ri/yRRBSxk1qWkdyR9GOGAdjfM/9VqtF4jM3BT5/6IdA0fGWXQ+8juVOuhtjavac
 WmbJgoA9oGs2tXFaE9dgir8yVr1veERUtW+inEGICmeOWBRbDsviesXxcmGblhGvrlCt
 Y/rCRrpre8w8a/emzU0povJQ170MIBOzUlw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0hwm9cgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 11:20:20 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 11:20:19 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 11:20:19 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 11:20:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBukWEQ6M/eDZJOu7pr/vC4ukW1Ei5g0EWQ4Wbt4ZH+HMIYWQJYJkpBUZEDfLMqw1EFmQvODWa+6ZE5Pkf7/joBao+Zu/dpBhsDhvHbcIZAeFWEDFkNgAIkfNPB9RAShpmiafkKg4GJfqvC8+0S6cIvtszgrw+D1POc4Z6Ws7aCA4RgPWHBDKzjc3g7HJNOJX8lsWtvK9+M332hV50Jk8XnRWEP0xUpKzsbzu0TAlUHxqTwyrQnb/LFt7+inTjrfVd9OcC01AjarzC48e6BLjSd0QB2vI4d/dj8iy0SdlUTCkYejfnA+gzS8OMZdII3m0vxmsXcP/oQ/LD7LDlCChg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78XAT6hkN5sh3f9EbG3MCmBvbQwWm7t3yxmYusVe+4o=;
 b=S/hTtP8zO5P2wO0RnqrDzLUpNCIiKXgqSYDbQnj1gw1b5RyatXghbmCtcUa5s4amiB+IsK+Zi+/0xUoJ//zSkK9SRpP5XkmWBQ+7FDoSGVTtmsx0QmFG+KDKUVQXK4v+lCumoeNb7nV5HWLke3XilL0zwhVKxkvT0TjgNnsEkABEYQDmF09VcMrQMu5IYLVQQ/pOWMiMFpDEL42wq3JwaA7qDylag7z1JEkguIpGE2Sr7vS0jjLO+GuMDhA0qkFKrHVyMd6vGMUmzzJ7UEmBDXNIoiozVG2lrjIhXVyKqYLQc9p5C40x1KO+XM5aENzON7uo5C0Itrv2blfiVgU75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78XAT6hkN5sh3f9EbG3MCmBvbQwWm7t3yxmYusVe+4o=;
 b=BnwOCdq+S4GdP8/shU0PGRnn+bmURUrfY1qVNx+hPHtFAbMQ+NPymohymAFCdkNvV4ulW5ay7Hv9z9D6Qxb5cr3jPJrLRcUfH/fv49QKdvJEvKdiCe7mZ8BmWW6YLingCle4OYRe8fv566oxHDLQvpbbnDlGyJqwOQjjlvbCDQ4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Sat, 27 Jul 2019 18:20:17 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 18:20:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwA
Date:   Sat, 27 Jul 2019 18:20:17 +0000
Message-ID: <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
In-Reply-To: <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6595]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 530703c3-613c-4495-d72c-08d712bf13a9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1216;
x-ms-traffictypediagnostic: MWHPR15MB1216:
x-microsoft-antispam-prvs: <MWHPR15MB1216B0ECC85F81802E385960B3C30@MWHPR15MB1216.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(346002)(396003)(136003)(199004)(189003)(2616005)(8676002)(446003)(81166006)(7736002)(81156014)(71200400001)(76116006)(64756008)(476003)(2906002)(66476007)(6116002)(561944003)(71190400001)(6512007)(256004)(486006)(76176011)(66446008)(33656002)(66556008)(53936002)(66946007)(6486002)(14454004)(99286004)(305945005)(229853002)(11346002)(6436002)(68736007)(25786009)(57306001)(316002)(7416002)(46003)(8936002)(50226002)(6916009)(54906003)(36756003)(4326008)(478600001)(186003)(5660300002)(102836004)(6246003)(6506007)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1216;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eTy3dS5bFVYHRnBkPIi0jHyHbSFgApC6tye38I1LhIJ7YcMXKeELGnLwwKv6STw5mKVPyTKQ3jOO4p3dqk7Y974gCURcexJQWRa4v43vll84bONOO1apiiYCzXLd9t6si5p6o14qAm5zb5t89mWbWGFc7Cj5rRH49ISYcPnzh77aAXvr0aBK5c2BqHesnOGqB8kdZlSQSx1zhBEE8XAfac0eh+I6if1LMecWnsImD9mL00fVvsXaaFXEAgko8wR9P2iAOv5RJs7bPy1+13nAMOBxQOsGNh7UGYMpaVxg5FB/D+85KnpmTSNMvULs5/zY4ORm/FvxUKVTfnwVtLfQM2gPJaa/YWZnxigBH0WP3hh0iGpNoD5Vh9kVTT+P1uzgOkcZgfZBsBix8sbdjruSeRW8uzpuyd9nND1MRaeMYVY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3B1AC11B31A674F9AFF087411C1D71E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 530703c3-613c-4495-d72c-08d712bf13a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 18:20:17.2774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1216
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=996 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270229
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5keSwgDQoNCj4+Pj4gDQo+Pj4gDQo+Pj4gV2VsbCwgeWVzLiBzeXNfYnBmKCkgaXMgcHJl
dHR5IHBvd2VyZnVsLiANCj4+PiANCj4+PiBUaGUgZ29hbCBvZiAvZGV2L2JwZiBpcyB0byBlbmFi
bGUgc3BlY2lhbCB1c2VycyB0byBjYWxsIHN5c19icGYoKS4gSW4gDQo+Pj4gdGhlIG1lYW53aGls
ZSwgc3VjaCB1c2VycyBzaG91bGQgbm90IHRha2UgZG93biB0aGUgd2hvbGUgc3lzdGVtIGVhc2ls
eQ0KPj4+IGJ5IGFjY2lkZW50LCBlLmcuLCB3aXRoIHJtIC1yZiAvLg0KPj4gDQo+PiBUaGF04oCZ
cyBlYXN5LCB0aG91Z2gg4oCUIGJwZnRvb2wgY291bGQgbGVhcm4gdG8gcmVhZCAvZXRjL2JwZnVz
ZXJzIGJlZm9yZSBhbGxvd2luZyBydWlkICE9IDAuDQo+IA0KPiBUaGlzIGlzIGEgZ3JlYXQgaWRl
YSEgZnNjYXBzICsgL2V0Yy9icGZ1c2VycyBzaG91bGQgZG8gdGhlIHRyaWNrLiANCg0KQWZ0ZXIg
c29tZSBkaXNjdXNzaW9ucyBhbmQgbW9yZSB0aGlua2luZyBvbiB0aGlzLCBJIGhhdmUgc29tZSBj
b25jZXJucyANCndpdGggdGhlIHVzZXIgc3BhY2Ugb25seSBhcHByb2FjaC4gIA0KDQpJSVVDLCB5
b3VyIHByb3Bvc2FsIGZvciB1c2VyIHNwYWNlIG9ubHkgYXBwcm9hY2ggaXMgbGlrZTogDQoNCjEu
IGJwZnRvb2wgKGFuZCBvdGhlciB0b29scykgY2hlY2sgL2V0Yy9icGZ1c2VycyBhbmQgb25seSBk
byANCiAgIHNldHVpZCBmb3IgYWxsb3dlZCB1c2VyczoNCg0KCWludCBtYWluKCkNCgl7DQoJCWlm
ICgvKiB1aWQgaW4gL2V0Yy9icGZ1c2VycyAqLykNCgkJCXNldHVpZCgwKTsNCgkJc3lzX2JwZigu
Li4pOw0KCX0NCg0KMi4gYnBmdG9vbCAoYW5kIG90aGVyIHRvb2xzKSBpcyBpbnN0YWxsZWQgd2l0
aCBDQVBfU0VUVUlEOg0KDQoJc2V0Y2FwIGNhcF9zZXR1aWQ9ZStwIC9iaW4vYnBmdG9vbA0KDQoz
LiBzeXMgYWRtaW4gbWFpbnRhaW5zIHByb3BlciAvZXRjL2JwZnVzZXJzLiANCg0KVGhpcyBhcHBy
b2FjaCBpcyBub3QgaWRlYWwsIGJlY2F1c2Ugd2UgbmVlZCB0byB0cnVzdCB0aGUgdG9vbCB0byBn
aXZlIA0KaXQgQ0FQX1NFVFVJRC4gQSBoYWNrZWQgdG9vbCBjb3VsZCBlYXNpbHkgYnlwYXNzIC9l
dGMvYnBmdXNlcnMgY2hlY2sNCm9yIHVzZSBvdGhlciByb290IG9ubHkgc3lzIGNhbGxzIGFmdGVy
IHNldHVpZCgwKS4gDQoNCkRvZXMgdGhpcyBtYWtlIHNlbnNlPyAoT3IgZGlkIEkgbWlzdW5kZXJz
dGFuZCBhbnl0aGluZz8pDQoNClRoYW5rcywNClNvbmcNCg0K
