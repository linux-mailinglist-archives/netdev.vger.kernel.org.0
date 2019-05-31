Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DCF31156
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfEaPaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:30:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfEaPaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:30:17 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VFO3SC026799;
        Fri, 31 May 2019 08:25:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v2od4TWNAt1+tHWyh84uoVuXpsfyxugtVZnF+Zq49p0=;
 b=jeBzRVb3QGellsffHBT1f1F7YJF934k4A0Gp+P3DBqXGrtFbul9O+mG2uiGtWIrhrHx9
 w7cOVX/w6In+bY2to3UzpNZqvHRcAhSTgZPvsw5bKNEVqndM1n1EcciHSU67j3gBSAoI
 ToliVbJyUbvvxeWdAJqyLy8flWAU0SF2WZ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2su0hr16k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 May 2019 08:25:31 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 May 2019 08:25:29 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 May 2019 08:25:29 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 31 May 2019 08:25:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2od4TWNAt1+tHWyh84uoVuXpsfyxugtVZnF+Zq49p0=;
 b=hQP8tiZABGR2jh0T+VUF3xl/QoE8GykC68TIEEBKabJDGIJ5pdnO0C5tQJvDf7SwbDJeG3/IYH4+nlzJOOSDDe+R6Tpc8Q4abKI473Wv3CjMdut1J3OngyWuTzGt9w0au0e+dfJsbabltuwcjMJzgNQ5ZUwFhPzF9T7ybwzEjWk=
Received: from DM5PR15MB1290.namprd15.prod.outlook.com (10.173.212.17) by
 DM5PR15MB1578.namprd15.prod.outlook.com (10.173.222.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 15:25:26 +0000
Received: from DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::69f8:55e8:1759:8a93]) by DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::69f8:55e8:1759:8a93%10]) with mapi id 15.20.1922.021; Fri, 31 May
 2019 15:25:26 +0000
From:   Chris Mason <clm@fb.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "dtrace-devel@oss.oracle.com" <dtrace-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Thread-Topic: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Thread-Index: AQHVD2aSHt9N3RjmOE6c7Suri9irRqZ13i0AgAAMqoCAACVtAIAAC4aAgAAemICAAFARgIABDTWAgACWzACAAP76AIAKuaGAgAGEQwA=
Date:   Fri, 31 May 2019 15:25:25 +0000
Message-ID: <5AD44AC7-F88F-4068-B122-962839F968B2@fb.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com>
 <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
 <20190530161543.GA1835@oracle.com>
In-Reply-To: <20190530161543.GA1835@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.5r5635)
x-clientproxiedby: MN2PR12CA0004.namprd12.prod.outlook.com
 (2603:10b6:208:a8::17) To DM5PR15MB1290.namprd15.prod.outlook.com
 (2603:10b6:3:b8::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:480::1ea3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f217613-9d3e-4bba-7ccc-08d6e5dc3489
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1578;
x-ms-traffictypediagnostic: DM5PR15MB1578:
x-microsoft-antispam-prvs: <DM5PR15MB15780AC1D7109E1E153CD8A0D3190@DM5PR15MB1578.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(396003)(366004)(39860400002)(189003)(199004)(46003)(5660300002)(54906003)(486006)(6436002)(83716004)(6246003)(478600001)(186003)(256004)(50226002)(446003)(2906002)(6512007)(33656002)(11346002)(2616005)(6916009)(6486002)(229853002)(4326008)(5024004)(25786009)(36756003)(68736007)(71200400001)(8676002)(71190400001)(81156014)(82746002)(66476007)(102836004)(66556008)(76176011)(81166006)(386003)(305945005)(316002)(8936002)(99286004)(7736002)(66946007)(53546011)(52116002)(6506007)(66446008)(53936002)(14454004)(73956011)(476003)(86362001)(6116002)(64756008)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1578;H:DM5PR15MB1290.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: stoqxbeJ/TKNSEtQy3i58QcqNGg7H1OhI7TTiieH6kfBzlqDOMxAHzqN5audbvoYx/rjsz19qbY21XkOMwPKJxL39CfCFTs5JWOEEsFLC+sYPHVO+mrOo5g2uuZpkdUa97Eut9hUk0GAPWs7aUS15+PhDLv2Q8uWQ9ehnj41FUD1VzsfUZatEXpFiJE8Poa5ucJjJv2YEWgmDoB3sA3kP/gaQUw6ugk4cnutuldL8dHPXffFwTxJO7AV8ewrS811/S4LZ4p8GvcBU3VlRZ7BevDT44lDKiewOETLIDWSdjvo6K+tWWhDrgLr1r0erA3V1AT8kmgcr7Lhd8H3z0J2KWvf5BuxzAkdLxDqyT3yaB81bsZF4FapWBdOQVjor0cusUbm38c6B+FKsjkWOUvLG/fNOddZdSFJcoELvOfTwmk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f217613-9d3e-4bba-7ccc-08d6e5dc3489
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 15:25:25.9667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: clm@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1578
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310096
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpJJ20gYmVpbmcgcHJldHR5IGxpYmVyYWwgd2l0aCBjaG9wcGluZyBkb3duIHF1b3RlZCBtYXRl
cmlhbCB0byBoZWxwIA0KZW1waGFzaXplIGEgcGFydGljdWxhciBvcGluaW9uIGFib3V0IGhvdyB0
byBib290c3RyYXAgZXhpc3RpbmcgDQpvdXQtb2YtdHJlZSBwcm9qZWN0cyBpbnRvIHRoZSBrZXJu
ZWwuICBNeSBnb2FsIGhlcmUgaXMgdG8gdGFsayBtb3JlIA0KYWJvdXQgdGhlIHByb2Nlc3MgYW5k
IGxlc3MgYWJvdXQgdGhlIHRlY2huaWNhbCBkZXRhaWxzLCBzbyBwbGVhc2UgDQpmb3JnaXZlIG1l
IGlmIEkndmUgaWdub3JlZCBvciBjaGFuZ2VkIHRoZSB0ZWNobmljYWwgbWVhbmluZyBvZiBhbnl0
aGluZyANCmJlbG93Lg0KDQpPbiAzMCBNYXkgMjAxOSwgYXQgMTI6MTUsIEtyaXMgVmFuIEhlZXMg
d3JvdGU6DQoNCj4gT24gVGh1LCBNYXkgMjMsIDIwMTkgYXQgMDE6Mjg6NDRQTSAtMDcwMCwgQWxl
eGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPg0KPiAuLi4gSSBiZWxpZXZlIHRoYXQgdGhlIGRpc2N1
c3Npb24gdGhhdCBoYXMgYmVlbiBnb2luZyBvbiBpbiBvdGhlcg0KPiBlbWFpbHMgaGFzIHNob3du
IHRoYXQgd2hpbGUgaW50cm9kdWNpbmcgYSBwcm9ncmFtIHR5cGUgdGhhdCBwcm92aWRlcyBhDQo+
IGdlbmVyaWMgKGFic3RyYWN0ZWQpIGNvbnRleHQgaXMgYSBkaWZmZXJlbnQgYXBwcm9hY2ggZnJv
bSB3aGF0IGhhcyANCj4gYmVlbiBkb25lDQo+IHNvIGZhciwgaXQgaXMgYSBuZXcgdXNlIGNhc2Ug
dGhhdCBwcm92aWRlcyBmb3IgYWRkaXRpb25hbCB3YXlzIGluIA0KPiB3aGljaCBCUEYNCj4gY2Fu
IGJlIHVzZWQuDQo+DQoNClsgLi4uIF0NCg0KPg0KPiBZZXMgYW5kIG5vLiAgSXQgZGVwZW5kcyBv
biB3aGF0IHlvdSBhcmUgdHJ5aW5nIHRvIGRvIHdpdGggdGhlIEJQRiANCj4gcHJvZ3JhbSB0aGF0
DQo+IGlzIGF0dGFjaGVkIHRvIHRoZSBkaWZmZXJlbnQgZXZlbnRzLiAgRnJvbSBhIHRyYWNpbmcg
cGVyc3BlY3RpdmUsIA0KPiBwcm92aWRpbmcgYQ0KPiBzaW5nbGUgQlBGIHByb2dyYW0gd2l0aCBh
biBhYnN0cmFjdCBjb250ZXh0IHdvdWxkIC4uLg0KDQpbIC4uLiBdDQoNCj4NCj4gSW4gdGhpcyBt
b2RlbCBrcHJvYmUva3N5c193cml0ZSBhbmQgDQo+IHRyYWNlcG9pbnQvc3lzY2FsbHMvc3lzX2Vu
dGVyX3dyaXRlIGFyZQ0KPiBlcXVpdmFsZW50IGZvciBtb3N0IHRyYWNpbmcgcHVycG9zZXMgLi4u
DQoNClsgLi4uIF0NCg0KPg0KPiBJIGFncmVlIHdpdGggd2hhdCB5b3UgYXJlIHNheWluZyBidXQg
SSBhbSBwcmVzZW50aW5nIGFuIGFkZGl0aW9uYWwgdXNlIA0KPiBjYXNlDQoNClsgLi4uIF0NCg0K
Pj4NCj4+IEFsbCB0aGF0IGFzaWRlIHRoZSBrZXJuZWwgc3VwcG9ydCBmb3Igc2hhcmVkIGxpYnJh
cmllcyBpcyBhbiBhd2Vzb21lDQo+PiBmZWF0dXJlIHRvIGhhdmUgYW5kIGEgYnVuY2ggb2YgZm9s
a3Mgd2FudCB0byBzZWUgaXQgaGFwcGVuLCBidXQNCj4+IGl0J3Mgbm90IGEgYmxvY2tlciBmb3Ig
J2R0cmFjZSB0byBicGYnIHVzZXIgc3BhY2Ugd29yay4NCj4+IGxpYmJwZiBjYW4gYmUgdGF1Z2h0
IHRvIGRvIHRoaXMgJ3BzZXVkbyBzaGFyZWQgbGlicmFyeScgZmVhdHVyZQ0KPj4gd2hpbGUgJ2R0
cmFjZSB0byBicGYnIHNpZGUgZG9lc24ndCBuZWVkIHRvIGRvIGFueXRoaW5nIHNwZWNpYWwuDQoN
ClsgLi4uIF0NCg0KVGhpcyB0aHJlYWQgaW50ZXJtaXhlcyBzb21lIGFic3RyYWN0IGNvbmNlcHR1
YWwgY2hhbmdlcyB3aXRoIHNtYWxsZXIgDQp0ZWNobmljYWwgaW1wcm92ZW1lbnRzLCBhbmQgaW4g
Z2VuZXJhbCBpdCBmb2xsb3dzIGEgZmFtaWxpYXIgcGF0dGVybiANCm90aGVyIG91dC1vZi10cmVl
IHByb2plY3RzIGhhdmUgaGl0IHdoaWxlIHRyeWluZyB0byBhZGFwdCB0aGUga2VybmVsIHRvIA0K
dGhlaXIgZXhpc3RpbmcgY29kZS4gIEp1c3QgZnJvbSB0aGlzIG9uZSBlbWFpbCwgSSBxdW90ZWQg
dGhlIGFic3RyYWN0IA0KbW9kZWxzIHdpdGggdXNlIGNhc2VzIGV0YywgYW5kIHRoaXMgaXMgb2Z0
ZW4gd2hlcmUgdGhlIGRpc2N1c3Npb25zIHNpZGUgDQp0cmFjayBpbnRvIGxlc3MgcHJvZHVjdGl2
ZSBhcmVhcy4NCg0KPg0KPiBTbyB5b3UgYXJlIGJhc2ljYWxseSBzYXlpbmcgdGhhdCBJIHNob3Vs
ZCByZWRlc2lnbiBEVHJhY2U/DQoNCkluIHlvdXIgcGxhY2UsIEkgd291bGQgaGF2ZSByZW1vdmVk
IGZlYXR1cmVzIGFuZCBhZGFwdGVkIGR0cmFjZSBhcyBtdWNoIA0KYXMgcG9zc2libGUgdG8gcmVx
dWlyZSB0aGUgYWJzb2x1dGUgbWluaW11bSBvZiBrZXJuZWwgcGF0Y2hlcywgb3IgZXZlbiANCmJl
dHRlciwgbm8gcGF0Y2hlcyBhdCBhbGwuICBJJ2QgZG9jdW1lbnQgYWxsIG9mIHRoZSBmZWF0dXJl
cyB0aGF0IHdvcmtlZCANCmFzIGV4cGVjdGVkLCBhbmQgdW5kZXJsaW5lIGFueXRoaW5nIGVpdGhl
ciBtaXNzaW5nIG9yIHN1Ym9wdGltYWwgdGhhdCANCm5lZWRlZCBhZGRpdGlvbmFsIGtlcm5lbCBj
aGFuZ2VzLiAgVGhlbiBJJ2QgZm9jdXMgb24gZXhwYW5kaW5nIHRoZSANCmNvbW11bml0eSBvZiBw
ZW9wbGUgdXNpbmcgZHRyYWNlIGFnYWluc3QgdGhlIG1haW5saW5lIGtlcm5lbCwgYW5kIHdvcmsg
DQp0aHJvdWdoIHRoZSBzZXJpZXMgZmVhdHVyZXMgYW5kIGltcHJvdmVtZW50cyBvbmUgYnkgb25l
IHVwc3RyZWFtIG92ZXIgDQp0aW1lLg0KDQpZb3VyIGN1cnJlbnQgYXBwcm9hY2ggcmVsaWVzIG9u
IGFuIGFsbC1vci1ub3RoaW5nIGxhbmRpbmcgb2YgcGF0Y2hlcyANCnVwc3RyZWFtLCBhbmQgdGhp
cyBjb25zaXN0ZW50bHkgbGVhZHMgdG8gY29uZmxpY3QgZXZlcnkgdGltZSBhIHByb2plY3QgDQp0
cmllcyBpdC4gIEEgbW9yZSBpbmNyZW1lbnRhbCBhcHByb2FjaCB3aWxsIHJlcXVpcmUgYmlnZ2Vy
IGNoYW5nZXMgb24gDQp0aGUgZHRyYWNlIGFwcGxpY2F0aW9uIHNpZGUsIGJ1dCBvdmVyIHRpbWUg
aXQnbGwgYmUgbXVjaCBlYXNpZXIgdG8gDQpqdXN0aWZ5IHlvdXIga2VybmVsIGNoYW5nZXMuICBZ
b3Ugd29uJ3QgaGF2ZSB0byB0YWxrIGluIGFic3RyYWN0IG1vZGVscywgDQphbmQgeW91J2xsIGhh
dmUgbWFueSBtb3JlIGNvbmNyZXRlIGV4YW1wbGVzIG9mIHBlb3BsZSBhc2tpbmcgZm9yIGR0cmFj
ZSANCmZlYXR1cmVzIGFnYWluc3QgbWFpbmxpbmUuICBNb3N0IGltcG9ydGFudGx5LCB5b3UnbGwg
bWFrZSBkdHJhY2UgDQphdmFpbGFibGUgb24gbW9yZSBrZXJuZWxzIHRoYW4ganVzdCB0aGUgYWJz
b2x1dGUgbGF0ZXN0IG1haW5saW5lLCBhbmQgDQpyZW1vdmluZyBkZXBlbmRlbmNpZXMgbWFrZXMg
dGhlIHByb2plY3QgbXVjaCBlYXNpZXIgZm9yIG5ldyB1c2VycyB0byANCnRyeS4NCg0KLWNocmlz
DQo=
