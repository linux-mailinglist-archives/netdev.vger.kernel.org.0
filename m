Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28277DB2A4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409035AbfJQQlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:41:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729529AbfJQQlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 12:41:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9HGYHV9009935;
        Thu, 17 Oct 2019 09:41:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=biC6d3J3xM2y0Boyn68Bv7vjpLvbZxs4rz6+ku3/e9o=;
 b=bwtR3/7AAOEc+HLkMaaFSXpiUDZJ0NOn5NMuaIzqPg7t0tIevpMDp8LjtSLpaV06+DZ3
 /jIMP15MmTwhIswnRMbOxC4z5av6+i5RoJ3pOy1nb3kOWxE8en72MiHW3dK3A1SvJo7d
 Ra9jC+squs3VJrhtSUm3zi5BwoMcoP08lrw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vp3uk6e8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Oct 2019 09:41:32 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Oct 2019 09:41:31 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 09:41:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGQIDac/VZi2IzfwqC2XnPnIwhL+ELsspsKopjVqZDZ8hlAqQCi6GRACWNd2V/b90F+YGrpn1sgJG7nujqW0lUNA/1kxMHcrB1Hp04e6tbQ/jc3CELkjhtpkYdd1E3JvNv7sCcyuhh5cxV20OElMUWMD58+HmAhNDJ6SdqFtf0pvsh2rGhkKkWRCkUwsTsZ65QK9fblMo2CqnnXLF0U36ayD13IraHibWu/cDQIKor9IECmAy7XcOvls442Y4iji5mcMDYDHPHrYc+qlIW3ciU5E7mUFbpO6rvmYhDTYAU26z1E9wQXBea35srDks7lNyYpcXQoBp+T1GG2SPiJqNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biC6d3J3xM2y0Boyn68Bv7vjpLvbZxs4rz6+ku3/e9o=;
 b=HWspeh1fW0hlBuef0m+R4H3Rr+l9eoVMGnBkzBtfp1TfkeB8jCbdJlt1VP9kOz5sKv7janT5J7tsyS6g5sNXvMslxdPS78cu3jALrXskZ6idwJl2yu0L7QvHlelOrfmE2ux8S3hVpeZliYcCe9WHIsK+ZKR42OfstYkMhgbF+5c7pIYWIiHLTAAo5D/ob5rVwuAHlDJCsKEeHN8CIR+Rwj8CG+wQ9rEc/845FhOG4cd4UbRIB5dsQCm6JXrmm/49ixFTLQVJccMTBrSwJairCyPzWEfX4BVnfcK5GfY3yPgO6hc6u+G/S6J4C05sefo9e6Cr5bywcNR1lK1k3BPcIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biC6d3J3xM2y0Boyn68Bv7vjpLvbZxs4rz6+ku3/e9o=;
 b=O4s/lwHYQ+xiKQ154gawPPaRABQUx0Ko8lsu9kozHBH5pqsiIKzNHjclX1fcd92h1Gu3EeT1nlbDe5hbPSMRLNDVmJCyRkWJdPFiV7c2VJjTQ2puTofOyUDi/QIMpeliaFx5r/5cb1Cl/h7xW16f4P3O1YSpoP181oT+g024Ueo=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1408.namprd15.prod.outlook.com (10.173.234.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 16:41:29 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::24c9:a1ce:eeeb:9246]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::24c9:a1ce:eeeb:9246%10]) with mapi id 15.20.2347.023; Thu, 17 Oct
 2019 16:41:29 +0000
From:   Tao Ren <taoren@fb.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Arun Parameswaran" <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v9 0/3] net: phy: support 1000Base-X
 auto-negotiation for BCM54616S
Thread-Topic: [PATCH net-next v9 0/3] net: phy: support 1000Base-X
 auto-negotiation for BCM54616S
Thread-Index: AQHVg41FO/qeyAwO4EK9T4uclEB8OqdfDFQA
Date:   Thu, 17 Oct 2019 16:41:29 +0000
Message-ID: <d7ba7fc9-45b1-b958-fafa-0eae5e116796@fb.com>
References: <20191015191213.4028603-1-taoren@fb.com>
In-Reply-To: <20191015191213.4028603-1-taoren@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::34) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::c20e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc8e9401-20d7-4a79-70a3-08d75320dc3b
x-ms-traffictypediagnostic: MWHPR15MB1408:
x-microsoft-antispam-prvs: <MWHPR15MB1408D6137A292C9D768D0676B26D0@MWHPR15MB1408.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(366004)(136003)(346002)(189003)(199004)(6506007)(53546011)(58126008)(6512007)(14454004)(31686004)(52116002)(99286004)(478600001)(6246003)(5660300002)(316002)(110136005)(386003)(102836004)(6116002)(25786009)(36756003)(71190400001)(71200400001)(76176011)(2906002)(6486002)(31696002)(8936002)(11346002)(65956001)(46003)(476003)(186003)(81156014)(5024004)(81166006)(486006)(2616005)(8676002)(256004)(65806001)(66446008)(66946007)(2501003)(305945005)(2201001)(7736002)(64756008)(66556008)(66476007)(86362001)(446003)(6436002)(229853002)(7416002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1408;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s/PhF1moTZRAX0Yz5lK3/qr1wA1eNYCBLwN3z2JZTa66QU2cgko8hm+ajpPzbNIibfI2+u6UbLIA3n4TCDNYXA2ECzKdCMOIGg/DuNokm2R8uiQV2wLau85Ik+NjtoNmspQD7hl7DYz5EyUsEnzgYtlydL/OpUil/5wK61NlcMCeGmqbSaNdFe/o35evRmi0H2Fj338Lp6DMKKBE3f/e1gX/UlGISD4PKu0DWBu4RI3BLNbekG3Vcdxh3b8JqFM6JbD42XLEVJMb6xe8yQDn+24406OfVkTZd9Rjao9zbQo2zZFylWnNWUUyyEZ/jgF3RUYDuhCXp8a9/MBz/xZbMYhkN09pzyFAImQoNfIyyJ0LbhA5atVaIaI/VsMr3kuUFKbQxCl+WSN2jqmbiMZw7DfGuSdCn5MeJ1piuRJv+Mw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03FA344F482C554B9A97BAED5F990AD2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8e9401-20d7-4a79-70a3-08d75320dc3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 16:41:29.8155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fVAZSrBcDBxCCM1t3FriYoS90XIpI5/L8YE608ymnLh19nd+y6Yw/yYEXWjXx6cH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCkknbSBub3Qgc3VyZSBpZiB0aGUgcGF0Y2ggc2VyaWVzIHY5IHdhcyBkZWxp
dmVyZWQgdG8geW91ciBtYWlsYm94IHN1Y2Nlc3NmdWxseSwNCmJ1dCBzb21laG93IEkgc3RpbGwg
Y2Fubm90IGZpbmQgdGhlIHBhdGNoZXMgaW4gcGF0Y2h3b3JrLg0KDQpBbnkgc3VnZ2VzdGlvbnM/
IE1heWJlIG15IGdpdCBpcyBtaXMtY29uZmlndXJlZD8gDQoNCg0KVGhhbmtzLA0KDQpUYW8NCg0K
T24gMTAvMTUvMTkgMTI6MTIgUE0sIFRhbyBSZW4gd3JvdGU6DQo+IFRoaXMgcGF0Y2ggc2VyaWVz
IGFpbXMgYXQgc3VwcG9ydGluZyBhdXRvIG5lZ290aWF0aW9uIHdoZW4gQkNNNTQ2MTZTIGlzDQo+
IHJ1bm5pbmcgaW4gMTAwMEJhc2UtWCBtb2RlOiB3aXRob3V0IHRoZSBwYXRjaCBzZXJpZXMsIEJD
TTU0NjE2UyBQSFkgZHJpdmVyDQo+IHdvdWxkIHJlcG9ydCBpbmNvcnJlY3QgbGluayBzcGVlZCBp
biAxMDAwQmFzZS1YIG1vZGUuDQo+IA0KPiBQYXRjaCAjMSAob2YgMykgbW9kaWZpZXMgYXNzaWdu
bWVudCB0byBPUiB3aGVuIGRlYWxpbmcgd2l0aCBkZXZfZmxhZ3MgaW4NCj4gcGh5X2F0dGFjaF9k
aXJlY3QgZnVuY3Rpb24sIHNvIHRoYXQgZGV2X2ZsYWdzIHVwZGF0ZWQgaW4gQkNNNTQ2MTZTIFBI
WSdzDQo+IHByb2JlIGNhbGxiYWNrIHdvbid0IGJlIGxvc3QuDQo+IA0KPiBQYXRjaCAjMiAob2Yg
MykgYWRkcyBzZXZlcmFsIGdlbnBoeV9jMzdfKiBmdW5jdGlvbnMgdG8gc3VwcG9ydCBjbGF1c2Ug
MzcNCj4gMTAwMEJhc2UtWCBhdXRvLW5lZ290aWF0aW9uLCBhbmQgdGhlc2UgZnVuY3Rpb25zIGFy
ZSBjYWxsZWQgaW4gQkNNNTQ2MTZTDQo+IFBIWSBkcml2ZXIuDQo+IA0KPiBQYXRjaCAjMyAob2Yg
MykgZGV0ZWN0cyBCQ001NDYxNlMgUEhZJ3Mgb3BlcmF0aW9uIG1vZGUgYW5kIGNhbGxzIGFjY29y
ZGluZw0KPiBnZW5waHlfYzM3XyogZnVuY3Rpb25zIHRvIGNvbmZpZ3VyZSBhdXRvLW5lZ290aWF0
aW9uIGFuZCBwYXJzZSBsaW5rDQo+IGF0dHJpYnV0ZXMgKHNwZWVkLCBkdXBsZXgsIGFuZCBldGMu
KSBpbiAxMDAwQmFzZS1YIG1vZGUuDQo+IA0KPiBIZWluZXIgS2FsbHdlaXQgKDEpOg0KPiAgIG5l
dDogcGh5OiBhZGQgc3VwcG9ydCBmb3IgY2xhdXNlIDM3IGF1dG8tbmVnb3RpYXRpb24NCj4gDQo+
IFRhbyBSZW4gKDIpOg0KPiAgIG5ldDogcGh5OiBtb2RpZnkgYXNzaWdubWVudCB0byBPUiBmb3Ig
ZGV2X2ZsYWdzIGluIHBoeV9hdHRhY2hfZGlyZWN0DQo+ICAgbmV0OiBwaHk6IGJyb2FkY29tOiBh
ZGQgMTAwMEJhc2UtWCBzdXBwb3J0IGZvciBCQ001NDYxNlMNCj4gDQo+ICBkcml2ZXJzL25ldC9w
aHkvYnJvYWRjb20uYyAgIHwgIDU3ICsrKysrKysrKysrKystDQo+ICBkcml2ZXJzL25ldC9waHkv
cGh5X2RldmljZS5jIHwgMTQxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+
ICBpbmNsdWRlL2xpbnV4L2JyY21waHkuaCAgICAgIHwgIDEwICsrLQ0KPiAgaW5jbHVkZS9saW51
eC9waHkuaCAgICAgICAgICB8ICAgNCArDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDIwNSBpbnNlcnRp
b25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCg==
