Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611C28CC54
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfHNHNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:13:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfHNHNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 03:13:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7E7ADCD021406;
        Wed, 14 Aug 2019 00:12:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DsJRXdNXjRoXBhTOcQCgQsGc63bQ6vVDVfC5MQF7eQk=;
 b=Ifdqgyijai7j5rBHgt32aqoOgnWKl9ClQ+qehYP7Z4txed11+cmA+mkAaWYNsR/581VA
 1V/yYi8KWj8Iv1f4GK2VzLOlShaWO0oEXitcRnqT9oKSmEUTjCHcvnUZ2iz37XnyU7Sm
 zeCGQ4cxlg31cTlCo7s04/zmFG0oUSxC4Zg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uc4uhhw6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Aug 2019 00:12:48 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 14 Aug 2019 00:12:47 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 14 Aug 2019 00:12:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7u6bs1TR8NXq82CUZaJS3ZUfzpi/0Q54elKIMraT6ExP3QnoAdEQ/RNx9vo8vX1THiU/ikvX2bMQBW/XO41uUDkADBTPrC9itqkpZ0hIuyXajECQteiSmS5S1+4I68r0RTbCi+ArxYX2EHT/bWPpXypEVz6c3nrrM7vawS56Rbppehg+9h79LFIOcHSFjDpQuTv7zUlOnVx4WsCl5Gj/8MXW2ODxsOO7/Gr9Cl1+oBGglxqb/3OFXCMgBBEfFJfUixOCTDfS351InVEJawP3mI4c5DcyVnqXjynuOPWik6T+OdYYX6qccu/qg55WM1bGTCWR7iXR3IjBtMJQ3BYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsJRXdNXjRoXBhTOcQCgQsGc63bQ6vVDVfC5MQF7eQk=;
 b=GmL8pJgQPwMjb4P/5c3vFGECHlouruOljdvI1trgcFb0Om8Al9RIvoM5rIhh3eV0VJ71DladOUJFQMq2k1yp6KD2jLwe8kUzOdmi9SwNU5ZSp5yBULVUQXK4DMwOFXLd6DJlMnxCJuxcVkL8w8VdQ4emf4rR2uG0tugdNUfxMr6AIItoyQP/+MeOGYNkGHdjOOAKd2V5e4JmU+LZtZeSgdDHLSWVtZHR3NAM+8xyfY0Je+jRxS1fsw1o3VP/Vf2gd1+HXpeDh+7uBxW9cdr82ick3QmLhyinUleTD2LWUCy+0bKORnUmn9RtZ3MQcclyOdpGQELf53RM7Zd1bI6BeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsJRXdNXjRoXBhTOcQCgQsGc63bQ6vVDVfC5MQF7eQk=;
 b=e7brw1+WSOYsP2ObIQY/YKq/CHh92qFFaxgHFJ+c+nO4rLiX9jxO1LouIRprgZMYHHGV3nc1q4vLyQk/Ccfg6DXzeidMC8sAZKQe72vMUuVXoHOlmb4jb5z32cBNeCpaSygE1JDAiQ7i6FdLwejumVA0zpDWzzRoKkT8t8Um/LE=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1448.namprd15.prod.outlook.com (10.172.162.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 07:12:45 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1%9]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 07:12:45 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
Thread-Topic: [PATCH bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
Thread-Index: AQHVUi5Ju+2OlijuzEGK9AnOiFXIR6b5ygEAgABHz4CAACkmAA==
Date:   Wed, 14 Aug 2019 07:12:45 +0000
Message-ID: <20190814071242.GA41688@rdna-mbp>
References: <20190813232408.1246694-1-andriin@fb.com>
 <20190814002824.GA29281@rdna-mbp>
 <CAEf4Bza49YeDM=rgSOWoqAA9qc166x_dend=1U_3mMLiSdxFrQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza49YeDM=rgSOWoqAA9qc166x_dend=1U_3mMLiSdxFrQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:300:13d::20) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::bed3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 250bd508-6298-463a-a76c-08d72086ce2b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1448;
x-ms-traffictypediagnostic: CY4PR15MB1448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1448CF8EFEC346201A31C244A8AD0@CY4PR15MB1448.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(136003)(39860400002)(346002)(376002)(366004)(199004)(189003)(14444005)(8676002)(81166006)(256004)(478600001)(54906003)(81156014)(6246003)(25786009)(4326008)(5660300002)(6116002)(71190400001)(71200400001)(7736002)(99286004)(305945005)(14454004)(53936002)(316002)(486006)(6506007)(66556008)(66946007)(386003)(66476007)(446003)(476003)(102836004)(8936002)(52116002)(6512007)(186003)(64756008)(86362001)(46003)(6486002)(6916009)(229853002)(2906002)(6436002)(76176011)(66574012)(53546011)(33656002)(66446008)(11346002)(9686003)(33716001)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1448;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7yVBnB6oypU50KiwVTezpzIPKIjcsiAQolDQq5tXBf054ze9D85Wll8sOlN/z5qA3+NwBUspUoJk5i28eUASkkwZXrwp4Jb8LjpRzA311nh4WOnmnTLkxPD3aZbNfvdffGdycKccurqiOGI2JI3ohjZen55xTiBIG0rswxmHvG2GVfGN8wlqMCsr8e0WScBE52wlvdLYRkk9j0yHjJnqbcWdsD6DjaG0fdjAtYpEOPoNlxzVeZ2IVs0Hvx5Xnk8UQ+TylwYKsrn9Vjct0oniEOrKLqzDjW7Y7yFVpgvkv671+6UB8WnMfAe8UBGw2rgHMcZj9U/Y1LN2GnN1JsDaWnFnBUWZnDm5RbzOtDrBud1vocE/KBd41dzbrH27jWxDkeuuiSFKXCtCA943w31FmjDLsxoR87xy2ffapXeJlzg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51E8A30D76ECAC4C94377CA271F56079@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 250bd508-6298-463a-a76c-08d72086ce2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 07:12:45.5907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bmz+1rAzPm7pllh6RtXl9U0So5MPz2aPz7AzNHLILCYf+ycUfAm86uUT1uqXu0Xg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1448
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140068
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmlpIE5ha3J5aWtvIDxhbmRyaWkubmFrcnlpa29AZ21haWwuY29tPiBbVHVlLCAyMDE5LTA4
LTEzIDIxOjQ2IC0wNzAwXToNCj4gT24gVHVlLCBBdWcgMTMsIDIwMTkgYXQgNToyOCBQTSBBbmRy
ZXkgSWduYXRvdiA8cmRuYUBmYi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQW5kcmlpIE5ha3J5aWtv
IDxhbmRyaWluQGZiLmNvbT4gW1R1ZSwgMjAxOS0wOC0xMyAxNjoyNCAtMDcwMF06DQo+ID4gPiBD
dXJyZW50bHkgbGliYnBmIHZlcnNpb24gaXMgc3BlY2lmaWVkIGluIDIgcGxhY2VzOiBsaWJicGYu
bWFwIGFuZA0KPiA+ID4gTWFrZWZpbGUuIFRoZXkgZWFzaWx5IGdldCBvdXQgb2Ygc3luYyBhbmQg
aXQncyB2ZXJ5IGVhc3kgdG8gdXBkYXRlIG9uZSwNCj4gPiA+IGJ1dCBmb3JnZXQgdG8gdXBkYXRl
IGFub3RoZXIgb25lLiBJbiBhZGRpdGlvbiwgR2l0aHViIHByb2plY3Rpb24gb2YNCj4gPiA+IGxp
YmJwZiBoYXMgdG8gbWFpbnRhaW4gaXRzIG93biB2ZXJzaW9uIHdoaWNoIGhhcyB0byBiZSByZW1l
bWJlcmVkIHRvIGJlDQo+ID4gPiBrZXB0IGluIHN5bmMgbWFudWFsbHksIHdoaWNoIGlzIHZlcnkg
ZXJyb3ItcHJvbmUgYXBwcm9hY2guDQo+ID4gPg0KPiA+ID4gVGhpcyBwYXRjaCBtYWtlcyBsaWJi
cGYubWFwIGEgc291cmNlIG9mIHRydXRoIGZvciBsaWJicGYgdmVyc2lvbiBhbmQNCj4gPiA+IHVz
ZXMgc2hlbGwgaW52b2NhdGlvbiB0byBwYXJzZSBvdXQgY29ycmVjdCBmdWxsIGFuZCBtYWpvciBs
aWJicGYgdmVyc2lvbg0KPiA+ID4gdG8gdXNlIGR1cmluZyBidWlsZC4gTm93IHdlIG5lZWQgdG8g
bWFrZSBzdXJlIHRoYXQgb25jZSBuZXcgcmVsZWFzZQ0KPiA+ID4gY3ljbGUgc3RhcnRzLCB3ZSBu
ZWVkIHRvIGFkZCAoaW5pdGlhbGx5KSBlbXB0eSBzZWN0aW9uIHRvIGxpYmJwZi5tYXANCj4gPiA+
IHdpdGggY29ycmVjdCBsYXRlc3QgdmVyc2lvbi4NCj4gPiA+DQo+ID4gPiBUaGlzIGFsc28gd2ls
bCBtYWtlIGl0IHBvc3NpYmxlIHRvIGtlZXAgR2l0aHViIHByb2plY3Rpb24gY29uc2lzdGVudA0K
PiA+ID4gd2l0aCBrZXJuZWwgc291cmNlcyB2ZXJzaW9uIG9mIGxpYmJwZiBieSBhZG9wdGluZyBz
aW1pbGFyIHBhcnNpbmcgb2YNCj4gPiA+IHZlcnNpb24gZnJvbSBsaWJicGYubWFwLg0KPiA+DQo+
ID4gVGhhbmtzIGZvciB0YWtpbmcgY2FyZSBvZiB0aGlzIQ0KPiA+DQo+ID4NCj4gPiA+IENjOiBB
bmRyZXkgSWduYXRvdiA8cmRuYUBmYi5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkg
TmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgdG9vbHMvbGliL2Jw
Zi9NYWtlZmlsZSAgIHwgMTIgKysrKystLS0tLS0tDQo+ID4gPiAgdG9vbHMvbGliL2JwZi9saWJi
cGYubWFwIHwgIDMgKysrDQo+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyks
IDcgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYv
TWFrZWZpbGUgYi90b29scy9saWIvYnBmL01ha2VmaWxlDQo+ID4gPiBpbmRleCA5MzEyMDY2YTFh
ZTMuLmQ5YWZjODUwOTcyNSAxMDA2NDQNCj4gPiA+IC0tLSBhL3Rvb2xzL2xpYi9icGYvTWFrZWZp
bGUNCj4gPiA+ICsrKyBiL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gPiA+IEBAIC0xLDkgKzEs
MTAgQEANCj4gPiA+ICAjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiAoTEdQTC0yLjEgT1IgQlNE
LTItQ2xhdXNlKQ0KPiA+ID4gICMgTW9zdCBvZiB0aGlzIGZpbGUgaXMgY29waWVkIGZyb20gdG9v
bHMvbGliL3RyYWNlZXZlbnQvTWFrZWZpbGUNCj4gPiA+DQo+ID4gPiAtQlBGX1ZFUlNJT04gPSAw
DQo+ID4gPiAtQlBGX1BBVENITEVWRUwgPSAwDQo+ID4gPiAtQlBGX0VYVFJBVkVSU0lPTiA9IDQN
Cj4gPiA+ICtCUEZfRlVMTF9WRVJTSU9OID0gJChzaGVsbCBcDQo+ID4NCj4gPiBOaXQ6IFNob3Vs
ZCBpdCBiZSBMSUJCUEZfVkVSU0lPTj8gSU1PIGl0J3MgbW9yZSBkZXNjcmlwdGl2ZSBuYW1lLg0K
PiANCj4gTElCQlBGX1ZFUlNJT04gaXMgdXNlZCBiZWxvdywgYnV0IGNvbWJpbmluZyB5b3VyIHN1
Z2dlc3Rpb24gd2l0aA0KPiBKYWt1YidzIGVhZ2VyIGV2YWx1YXRpb24sIEkgY2FuIHVzZSBqdXN0
IExJQkJQRl9WRVJTSU9OIGFuZCBkcm9wDQo+IEJQRl9GVUxMX1ZFUlNJT04gYWx0b2dldGhlci4N
Cj4gDQo+ID4NCj4gPiA+ICsgICAgIGdyZXAgLUUgJ0xJQkJQRl8oWzAtOV0rKVwuKFswLTldKylc
LihbMC05XSspIFx7JyBsaWJicGYubWFwIHwgXA0KPiA+ID4gKyAgICAgdGFpbCAtbjEgfCBjdXQg
LWQnXycgLWYyIHwgY3V0IC1kJyAnIC1mMSkNCj4gPg0KPiA+IEl0IGNhbiBiZSBkb25lIHNpbXBs
ZXIgYW5kIElNTyB2ZXJzaW9ucyBzaG91bGQgYmUgc29ydGVkIGJlZm9yZSB0YWtpbmcNCj4gPiB0
aGUgbGFzdCBvbmUgKGp1c3QgaW4gY2FzZSksIHNvbWV0aGluZyBsaWtlOg0KPiA+DQo+ID4gZ3Jl
cCAtb0UgJ15MSUJCUEZfWzAtOS5dKycgbGliYnBmLm1hcCB8IGN1dCAtZF8gLWYgMiB8IHNvcnQg
LW5yIHwgaGVhZCAtbiAxDQo+IA0KPiBBaCwgeW91IG1lYW4gbWFraW5nIHJlZ2V4IHNpbXBsZXI/
IFllYWgsIEkgb3JpZ2luYWxseSBpbnRlbmRlZCB0bw0KPiBleHRyYWN0IG1ham9yLCBwYXRjaCwg
YW5kIGV4dHJhIHZlcnNpb24sIGJ1dCByYWxpemVkIHBhdGNoIGFuZCBleHRyYQ0KPiBhcmUgbm90
IHVzZWQgZm9yIGFueXRoaW5nLiBJJ2xsIHNpbXBsaWZ5IHJlZ2V4LiBCdXQgc2Vjb25kIGBjdXQg
LWQnICcNCj4gLWYxYCBpcyBzdGlsbCBuZWVkZWQgdG8gZHJvcCAiIHsiLg0KDQpZZWFoLCByZWdl
eCwgYnV0IG5vdCBvbmx5LiBOb3RlIGAtbycgaW4gdGhlIGBncmVwJyBhcmd1bWVudHMsIGl0IHJl
dHVybnMNCm9ubHkgbWF0Y2hlZCBwaWVjZSBvZiBhIHN0cmluZyBhbmQgdGhlIHNlY29uZCBgY3V0
JyBpcyBub3QgbmVlZGVkLg0KDQoNCj4gUmVnYXJkaW5nIHNvcnRpbmcuIEkgZG9uJ3QgdGhpbmsg
aXQncyBuZWNlc3NhcnksIGFzIEkgY2FuJ3QgaW1hZ2luZQ0KPiBoYXZpbmcgbm9uLW9yZGVyZWQg
bGliYnBmLm1hcC4gRXZlbiBtb3JlIHNvLCBzb3J0IC1uciBkb2Vzbid0IHNvcnQNCj4gdmVyc2lv
bnMgbGlrZSB0aGVzZSBjb3JyZWN0bHkgYW55d2F5Og0KPiANCj4gMC4xLjINCj4gMC4xLjEyDQo+
IA0KPiBTbyB0aGlzIHdpbGwganVzdCBnaXZlIHVzIGZhbHNlIHNlbnNlIG9mIGNvcnJlY3RuZXNz
LCB3aGlsZSBiZWluZyBhICJ0aW1lIGJvbWIiLg0KDQpSaWdodCwgYC1uJyBpcyBub3QgYSBnb29k
IG9uZSwgYC1WJyBpcyBtdWNoIGJldHRlciBzaW5jZSBpdCdzIGludGVuZGVkDQp0byBzb3J0IHNw
ZWNpZmljYWxseSB2ZXJzaW9uczoNCg0KICAlIHByaW50ZiAiMC4xLjJcbjAuMS4xMlxuMC4xLjEx
XG4iDQogIDAuMS4yDQogIDAuMS4xMg0KICAwLjEuMTENCiAgJSBwcmludGYgIjAuMS4yXG4wLjEu
MTJcbjAuMS4xMVxuIiB8IHNvcnQgLWNWDQogIHNvcnQ6IC06MzogZGlzb3JkZXI6IDAuMS4xMQ0K
ICAlIHByaW50ZiAiMC4xLjJcbjAuMS4xMlxuMC4xLjExXG4iIHwgc29ydCAtVg0KICAwLjEuMg0K
ICAwLjEuMTENCiAgMC4xLjEyDQoNCg0KVGhlIHJlYXNvbiBJIGJyb3VnaHQgdGhpcyB1cCBpcyB0
aGUgdmVyc2lvbiBzdHJpbmcgY2FuIGJlIGFuIGFyYml0cmFyeSBzdHJpbmcNCmFuZCBmb3IgZXhh
bXBsZSBnbGliYyBkb2VzIHRoaXM6DQoNCiAgJSBncmVwIC1FbyAnXlxzK0dMSUJDX1xTKycgc3lz
ZGVwcy91bml4L3N5c3YvbGludXgvVmVyc2lvbnMgfCB0YWlsIC1uIDMNCiAgR0xJQkNfMi4yOQ0K
ICBHTElCQ18yLjMwDQogIEdMSUJDX1BSSVZBVEUNCg0KSSBhZ3JlZSB0aG91Z2ggdGhhdCBpdCdz
IG5vdCBhIHByb2JsZW0gd2l0aCB0aGUgY3VycmVudCB2ZXJzaW9uIHNjcmlwdA0Kc3RydWN0dXJl
IGFuZCBpdCBzaG91bGQgYmUgZmluZSB0byBwb3N0cG9uZSBhZGRpbmcgc29tZSBraW5kIG9mIHNv
cnRpbmcgdGlsbA0KdGhlIHRpbWUgdGhpcyBzdHJ1Y3R1cmUgaXMgY2hhbmdlZCAoaWYgYXQgYWxs
KS4NCg0KPiA+ID4gK0JQRl9WRVJTSU9OID0gJChmaXJzdHdvcmQgJChzdWJzdCAuLCAsJChCUEZf
RlVMTF9WRVJTSU9OKSkpDQo+ID4gPg0KPiA+ID4gIE1BS0VGTEFHUyArPSAtLW5vLXByaW50LWRp
cmVjdG9yeQ0KPiA+ID4NCj4gPiA+IEBAIC03OSwxNSArODAsMTIgQEAgZXhwb3J0IHByZWZpeCBs
aWJkaXIgc3JjIG9iag0KPiA+ID4gIGxpYmRpcl9TUSA9ICQoc3Vic3QgJywnXCcnLCQobGliZGly
KSkNCj4gPiA+ICBsaWJkaXJfcmVsYXRpdmVfU1EgPSAkKHN1YnN0ICcsJ1wnJywkKGxpYmRpcl9y
ZWxhdGl2ZSkpDQo+ID4gPg0KPiA+ID4gK0xJQkJQRl9WRVJTSU9OICAgICAgID0gJChCUEZfRlVM
TF9WRVJTSU9OKQ0KPiA+ID4gIFZFUlNJT04gICAgICAgICAgICAgID0gJChCUEZfVkVSU0lPTikN
Cj4gPiA+IC1QQVRDSExFVkVMICAgPSAkKEJQRl9QQVRDSExFVkVMKQ0KPiA+ID4gLUVYVFJBVkVS
U0lPTiA9ICQoQlBGX0VYVFJBVkVSU0lPTikNCj4gPiA+DQo+ID4gPiAgT0JKICAgICAgICAgID0g
JEANCj4gPiA+ICBOICAgICAgICAgICAgPQ0KPiA+ID4NCj4gPiA+IC1MSUJCUEZfVkVSU0lPTiAg
ICAgICA9ICQoQlBGX1ZFUlNJT04pLiQoQlBGX1BBVENITEVWRUwpLiQoQlBGX0VYVFJBVkVSU0lP
TikNCj4gPiA+IC0NCj4gPiA+ICBMSUJfVEFSR0VUICAgPSBsaWJicGYuYSBsaWJicGYuc28uJChM
SUJCUEZfVkVSU0lPTikNCj4gPiA+ICBMSUJfRklMRSAgICAgPSBsaWJicGYuYSBsaWJicGYuc28q
DQo+ID4gPiAgUENfRklMRSAgICAgICAgICAgICAgPSBsaWJicGYucGMNCj4gPiA+IGRpZmYgLS1n
aXQgYS90b29scy9saWIvYnBmL2xpYmJwZi5tYXAgYi90b29scy9saWIvYnBmL2xpYmJwZi5tYXAN
Cj4gPiA+IGluZGV4IGY5ZDMxNmU4NzNkOC4uNGU3MmRmOGU5OGJhIDEwMDY0NA0KPiA+ID4gLS0t
IGEvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+ID4gPiArKysgYi90b29scy9saWIvYnBmL2xp
YmJwZi5tYXANCj4gPiA+IEBAIC0xODQsMyArMTg0LDYgQEAgTElCQlBGXzAuMC40IHsNCj4gPiA+
ICAgICAgICAgICAgICAgcGVyZl9idWZmZXJfX25ld19yYXc7DQo+ID4gPiAgICAgICAgICAgICAg
IHBlcmZfYnVmZmVyX19wb2xsOw0KPiA+ID4gIH0gTElCQlBGXzAuMC4zOw0KPiA+ID4gKw0KPiA+
ID4gK0xJQkJQRl8wLjAuNSB7DQo+ID4gPiArfSBMSUJCUEZfMC4wLjQ7DQo+ID4NCj4gPiBJJ20g
bm90IHN1cmUgdmVyc2lvbiBzaG91bGQgYmUgYnVtcGVkIGluIHRoaXMgcGF0Y2ggc2luY2UgdGhp
cyBwYXRjaCBpcw0KPiA+IGFib3V0IGtlZXBpbmcgdGhlIHZlcnNpb24gaW4gb25lIHBsYWNlLCBu
b3QgYWJvdXQgYnVtcGluZyBpdCwgcmlnaHQ/DQo+IA0KPiBUaGlzIGlzIGFjdHVhbGx5IGZpeGlu
ZyBhIHZlcnNpb24uIEN1cnJlbnQgbGliYnBmIHZlcnNpb24gaW4gYnBmLW5leHQNCj4gaXMgMC4w
LjUsIGl0IGp1c3Qgd2FzIG5ldmVyIHVwZGF0ZWQgaW4gTWFrZWZpbGUuDQo+IA0KPiA+DQo+ID4N
Cj4gPiA+IC0tDQo+ID4gPiAyLjE3LjENCj4gPiA+DQo+ID4NCj4gPiAtLQ0KPiA+IEFuZHJleSBJ
Z25hdG92DQoNCi0tIA0KQW5kcmV5IElnbmF0b3YNCg==
