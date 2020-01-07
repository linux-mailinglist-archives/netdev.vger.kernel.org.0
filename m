Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA29132DBD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgAGR6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:58:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1130 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728292AbgAGR6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:58:03 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007HtPjD031532;
        Tue, 7 Jan 2020 09:57:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xJ7VP4PCfwhA7s/ZiPFGD0L4iX9gr2p9A95l+UMfoz4=;
 b=bEAjUInk5/Kiixlk7bOGO3i0hUz3J+k15roIJxDNLPb73oDep9X04z7Qsy4co3oJklOW
 09DTlSTHcyhja+wA4078eCcyf7YqmBMLddKQylaXT55vDAQfAxaHZql61MnavePWdibW
 aCaQjcxHT+jOzNlFkU11hoqeaLSDKQcPYO8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xbbh1vrgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 09:57:46 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 7 Jan 2020 09:57:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 7 Jan 2020 09:57:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSM9Y+8/QV64wfSpvdjesWvEHU7uakDQFk1HzMuAba/4IBEgrF4WyCzqyMd4e1g447LklP59VNJd6lbWFhqe0YrWjnZk6UtmRlOUBWo3bye5YknRnwvWFPJXJ0eL+efJ0xP790X8YGGJp8CB/g/ashwO2e09eMnF0aE04FWuWhl3/hmi945JeN2VRwUU5P4VKF2bWlooHjnOhB/pgodO2oJmZwj1BZD/1vYqruQjzDIt4ViJbcvBEncxq+p9IelBdyOvcI1dWNcGPekEP3nfX7pRKDrVWHRmddqUUIHMCU4DoO9UZqkf28ASvO7xtXtogfEYD0Evb+6XwV0nvNjurw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ7VP4PCfwhA7s/ZiPFGD0L4iX9gr2p9A95l+UMfoz4=;
 b=a91v6/Vkf/XZbX5B07+39AJokwkYbqAdp6MhWnOQvsRwc+ldGCb1JKCBciFLQ/rNC39zQ4X4OEykKtdYmWUmqVvXXag2pIVOHGPp/a0JeCIOFLAFw+wp3sQEnt3JdxorBRNCK3Mi/FRxe4u/prr6Zq7MXyDCBCPsxPxTDD8tTlfQ9Kjd2c6YO6QYKpqEGljj2tVgjHuaHeg18KqsrNdGqnaBn8TCmXt/4W0o5Kb7ne/dsMf4AMk7UX3sDhzTqXUzFToIuEw41J6OynqdIar/evumX/RsYGKmZKFnHlpXXiGJ2XmOTy/BFt7MYacNsG8HIopc3Ovb7lf6P8jtEvW7Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ7VP4PCfwhA7s/ZiPFGD0L4iX9gr2p9A95l+UMfoz4=;
 b=I/tAevw9w0CzvkXRmxT8vpMRpkYP33ajD9z+kKRTnEB+qRmbzldNZsyOJO7YyOjypsnFNloKUb1DiZitmMQjjCkXKAsDqRZYtj0kk9tPEmW1D49ymAmSgv7jPcGydd/J7U2Q2Kx4yq74tJGEum6orjjNhZxOUTkw2fIaLDLQGw4=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1195.namprd15.prod.outlook.com (10.173.213.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 17:57:44 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 17:57:44 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::1:2af9) by MWHPR21CA0065.namprd21.prod.outlook.com (2603:10b6:300:db::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.3 via Frontend Transport; Tue, 7 Jan 2020 17:57:43 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>
CC:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 05/11] bpf: add generic_batch_ops to lpm_trie
 map
Thread-Topic: [PATCH v3 bpf-next 05/11] bpf: add generic_batch_ops to lpm_trie
 map
Thread-Index: AQHVsHMrZ7Y4XT6x5E2BfmAUzba9k6e4WXWAgCaP9oCAAL2XgA==
Date:   Tue, 7 Jan 2020 17:57:44 +0000
Message-ID: <44c7b96c-ff9f-a0b3-7c5e-1ccdbf4bf138@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-6-brianvv@google.com>
 <ba15746b-2cd8-5a04-08fa-3c85b94db15b@fb.com>
 <CABCgpaUHEWg6nwEEy47rF=aeK0AtNpAp3+pJVnObZU87FuUMgw@mail.gmail.com>
In-Reply-To: <CABCgpaUHEWg6nwEEy47rF=aeK0AtNpAp3+pJVnObZU87FuUMgw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0065.namprd21.prod.outlook.com
 (2603:10b6:300:db::27) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2af9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1c6365e-e9c4-47b6-b9da-08d7939b18b4
x-ms-traffictypediagnostic: DM5PR15MB1195:
x-microsoft-antispam-prvs: <DM5PR15MB11954F1A115BB64D3603331CD33F0@DM5PR15MB1195.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(366004)(396003)(39860400002)(199004)(189003)(6916009)(66556008)(6506007)(36756003)(53546011)(66946007)(4326008)(66476007)(7416002)(2616005)(66446008)(478600001)(64756008)(16526019)(186003)(86362001)(52116002)(81156014)(2906002)(54906003)(8936002)(81166006)(5660300002)(31696002)(8676002)(6512007)(316002)(6486002)(31686004)(71200400001)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1195;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vnPw+wACBu2hYN94utvqj2bCUwEIFgM1sEf7C6+qn1aqv65XECJ6fkhN4SUpTWXe5JfEOBUis/0Wf9DGj2bVb4B6hWGbESDcvkQhSk10svfUutsdGu6SDNCESfk/fWiCizPkYAqrwMgHg7vHj1uOv660PlX/iMOhEDKRbkk8i0eQQrIzFip9wwq+hN/sdoN+jCzlX5S75Qr8wRGoGaJuD9MNkdIjiZcNhYbhfhhqPsqk+Odm8WD1fTHQUi5YsaI/WVg7vgj/kSApVo1hs55atf6ObacFpzP5AzSlKDvz56v4yqRY4Wa1z8dCWNb/yEjoPdzXJCEGvM1cqWv4usd8ykdEVDtFdgBB7DELIM1qZAVDmaOPP6nFYLHY+PB6DO1erx662JO0n17SBAfSYSzcxp+TcEMhVY9uqKcrbQ9ByPQhU1MqAKSL811Aaawpi3Ta2Q/escDe+csJD6pY04NEk3hDyH2YaRu5Be8MLdfpbBIttYcUmrCLJ1kYXGN4g4jR
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8149A4B52317FA4387E9D1BF2C048FEA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c6365e-e9c4-47b6-b9da-08d7939b18b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 17:57:44.1674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aXC0OIHtKjA3A6kJ0pe4s0YqH6n+0t5V/ETkYcsuMDgjH3Mz/cMISjbT18bnJt/Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1195
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=971
 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvNi8yMCAxMDozOSBQTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4gSGkgWW9uZ2hv
bmcsIHRoYW5rcyBmb3IgcmV2aWV3aW5nIGl0IGFuZCBzb3JyeSBmb3IgdGhlIGxhdGUgcmVwbHkg
SQ0KPiBoYWQgYmVlbiB0cmF2ZWxpbmcuDQo+IA0KPiBPbiBGcmksIERlYyAxMywgMjAxOSBhdCAx
MTo0NiBBTSBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPiB3cm90ZToNCj4+DQo+Pg0KPj4NCj4+
IE9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+Pj4gVGhpcyBhZGRz
IHRoZSBnZW5lcmljIGJhdGNoIG9wcyBmdW5jdGlvbmFsaXR5IHRvIGJwZiBscG1fdHJpZS4NCj4+
Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEJyaWFuIFZhenF1ZXogPGJyaWFudnZAZ29vZ2xlLmNvbT4N
Cj4+PiAtLS0NCj4+PiAgICBrZXJuZWwvYnBmL2xwbV90cmllLmMgfCA0ICsrKysNCj4+PiAgICAx
IGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEva2Vy
bmVsL2JwZi9scG1fdHJpZS5jIGIva2VybmVsL2JwZi9scG1fdHJpZS5jDQo+Pj4gaW5kZXggNTZl
NmM3NWQzNTRkOS4uOTJjNDdiNGYwMzMzNyAxMDA2NDQNCj4+PiAtLS0gYS9rZXJuZWwvYnBmL2xw
bV90cmllLmMNCj4+PiArKysgYi9rZXJuZWwvYnBmL2xwbV90cmllLmMNCj4+PiBAQCAtNzQzLDQg
Kzc0Myw4IEBAIGNvbnN0IHN0cnVjdCBicGZfbWFwX29wcyB0cmllX21hcF9vcHMgPSB7DQo+Pj4g
ICAgICAgIC5tYXBfdXBkYXRlX2VsZW0gPSB0cmllX3VwZGF0ZV9lbGVtLA0KPj4+ICAgICAgICAu
bWFwX2RlbGV0ZV9lbGVtID0gdHJpZV9kZWxldGVfZWxlbSwNCj4+PiAgICAgICAgLm1hcF9jaGVj
a19idGYgPSB0cmllX2NoZWNrX2J0ZiwNCj4+PiArICAgICAubWFwX2xvb2t1cF9iYXRjaCA9IGdl
bmVyaWNfbWFwX2xvb2t1cF9iYXRjaCwNCj4+PiArICAgICAubWFwX2xvb2t1cF9hbmRfZGVsZXRl
X2JhdGNoID0gZ2VuZXJpY19tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2gsDQo+Pg0KPj4gTm90
IDEwMCUgc3VyZSB3aGV0aGVyIHRyaWUgc2hvdWxkIHVzZSBnZW5lcmljIG1hcA0KPj4gbG9va3Vw
L2xvb2t1cF9hbmRfZGVsZXRlIG9yIG5vdC4gSWYgdGhlIGtleSBpcyBub3QgYXZhaWxhYmxlLA0K
Pj4gdGhlIGdldF9uZXh0X2tleSB3aWxsIHJldHVybiB0aGUgJ2xlZnRtb3N0JyBub2RlIHdoaWNo
IHJvdWdobHkNCj4+IGNvcnJlc3BvbmRpbmcgdG8gdGhlIGZpcnN0IG5vZGUgaW4gdGhlIGhhc2gg
dGFibGUuDQo+Pg0KPiANCj4gSSB0aGluayB5b3UncmUgcmlnaHQsIHdlIHNob3VsZG4ndCB1c2Ug
Z2VuZXJpYw0KPiBsb29rdXAvbG9va3VwX2FuZF9kZWxldGUgZm9yIGxwbV90cmllLiBUaGF0IGJl
aW5nIHNhaWQsIHdvdWxkIHlvdSBiZQ0KPiBvaywgaWYgd2UgZG9uJ3QgYWRkIGxwbV90cmllIHN1
cHBvcnQgaW4gdGhpcyBwYXRjaCBzZXJpZXM/IEFsc28gd2UgY2FuDQo+IGRyb3AgdGhlIGdlbmVy
aWNfbWFwX2xvb2t1cF9hbmRfZGVsZXRlIGltcGxlbWVudGF0aW9uIGluIHRoaXMgcGF0Y2gNCj4g
c2VyaWVzIGFuZCBhZGQgaXQgaW4gdGhlIGZ1dHVyZSwgaWYgbmVlZGVkLiBXaGF0IGRvIHlvdSB0
aGluaz8NCg0KWWVzLCB3ZSBjYW4gZHJvcCBnZW5lcmljX21hcF9sb29rdXBfYW5kX2RlbGV0ZSgp
LCBpdCBwcm9iYWJseSB3aWxsIG5vdA0KYmUgdXNlZCBhIGxvdC4gVGhlIG5vcm1hbCBhcnJheSBt
YXAsIHlvdSBjYW5ub3QgZGVsZXRlIGVsZW1lbnRzLg0KRm9yIGZkX2FycmF5IG1hcHMsIHRoZXkg
dGVuZCB0byBiZSBzbWFsbC4NCg0KPiANCj4+PiArICAgICAubWFwX2RlbGV0ZV9iYXRjaCA9IGdl
bmVyaWNfbWFwX2RlbGV0ZV9iYXRjaCwNCj4+PiArICAgICAubWFwX3VwZGF0ZV9iYXRjaCA9IGdl
bmVyaWNfbWFwX3VwZGF0ZV9iYXRjaCx3aXRoIGVmYXVsdA0KPj4+ICAgIH07DQo+Pj4NCg==
