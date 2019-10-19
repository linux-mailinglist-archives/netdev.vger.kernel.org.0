Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE20DD5FA
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 03:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfJSBdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 21:33:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55106 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726195AbfJSBdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 21:33:09 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9J1OUmY008131;
        Fri, 18 Oct 2019 18:31:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JzJAuyL4X8TOkA0ZlOlw3S7qDTKXT0p/n731er8IjTk=;
 b=BXnjn+z1ZB1uoUB7UWAJ7UPCbbLT4xpPxzGXpEG7dm5S9Ab+QXgLioal+i01ygWUp1zd
 j2YaK1aO9hiQKMNR1V47zDHXOns8+DCqVZViR4toF1G4JEd/U1YmgO0811SFP21YNqKt
 xMQ+J7OiA+8MD+rTkrUYJEjb4+rKJNV/g84= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqhgjsvxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 18:31:48 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 18:31:46 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 18:31:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1YJTbVbwBZpkEhRs/LH+d/oUt/zFyjfAGbSfyYbNmtCtpYPvCNXWiENisNE3uXPQLRvCtgATq4YyTMQqX6Kimec1wGRg+t5kEy4rZq30PuvuIKnOjw8mShjsnJ4n1B4xCtkB0YqFc09mfmVLrkThF0rBksObknKB0zkzunNsoyfgLhZ9NX/TbXk/hfF+HGoliQMWP8o3t6j9ZJWldAKvNQGDWQNCGpW3gnDRMDVNGMJy54Unk4J0NkdItqqYQGQ9+O4NU/sCxh1I0Q4t9CQSsM6xBHjxCvivEMVINtC9UPueZdgiBK/jdXliWo5onNv58jWCLcDZzjy2yqlggKRWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzJAuyL4X8TOkA0ZlOlw3S7qDTKXT0p/n731er8IjTk=;
 b=J4ui0SX02Chfn7ICTB34gygJDEPId3eBD96+fSol8IkEs4lpBF3RxVFIBzv/w0wAu86t+srCbKw9XlYmRor3fA05QkKPHiDht+sbMD5v4WICz8mEt6OJpE8tGIb/V31lB6C98rcN7HMXiZOmBoIV2GXVXpvwqj1junNsOUQ0w0Jl0lgru//kGim/oF53JabRBAWGwMd063o6Yn/pcV9xyZDH2KCrmnqLVmhlpLnClkB3rZ8YaNVZujwR6OHY8mAw8CGnDrs35u8nidsxXcmHghchSiTC81GWHzYAfTUZrkNgVJqJZ6MI0G71ngxIY4US+DQPY+sxoIlYaxRhunXbPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzJAuyL4X8TOkA0ZlOlw3S7qDTKXT0p/n731er8IjTk=;
 b=FrG5tG6oi58ueiXJwPLCVUl6G8Q9rFpPYPcuuHOKXy0za9YFMrFV1PeSk9ZkbaFYxMiliqOZyGI4ftpju50KjN851m+4bv0wFNjWgwCCtdHaGT0vJzMV5VV1GAkmMZqvEDjid1VjlhdliKmoL0Ttg/VH2og31RnHGzXq7LucBeM=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3649.namprd15.prod.outlook.com (52.133.253.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Sat, 19 Oct 2019 01:31:46 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.024; Sat, 19 Oct 2019
 01:31:45 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Sven Van Asbroeck" <TheSven73@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Bhupesh Sharma" <bhsharma@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVgIJ8iNM2JFB8dkCGpaKji+MwkKdeE2WAgADjLwCAAIm8gP//mREAgAB8xoCAAP8DAIAAiv4A//+jaYA=
Date:   Sat, 19 Oct 2019 01:31:45 +0000
Message-ID: <3D78AA04-A502-4A9F-87A0-0D62D56952AF@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
 <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
 <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
 <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
 <9AA81274-01F2-4803-8905-26F0521486CE@fb.com>
 <f6d5cb45a9aa167533135c5b218b45b1d210d31a.camel@kernel.crashing.org>
 <529EF9B4-DFDE-4DB7-BE26-3AED8D814134@fb.com>
 <0ef567e985ce3fe821cbd80265f85a35d16be373.camel@kernel.crashing.org>
In-Reply-To: <0ef567e985ce3fe821cbd80265f85a35d16be373.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::7259]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21b0d7a1-8c0c-4af6-3ca6-08d754341abc
x-ms-traffictypediagnostic: BY5PR15MB3649:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3649A5965417FCDC20331D8DDD6F0@BY5PR15MB3649.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(189003)(486006)(476003)(6486002)(446003)(36756003)(2616005)(11346002)(46003)(7736002)(6512007)(305945005)(7416002)(256004)(14444005)(6436002)(6116002)(4001150100001)(54906003)(110136005)(6246003)(229853002)(2906002)(25786009)(2501003)(71190400001)(33656002)(478600001)(99286004)(2201001)(14454004)(102836004)(71200400001)(4326008)(81166006)(81156014)(86362001)(76116006)(8676002)(66446008)(64756008)(66556008)(66476007)(186003)(8936002)(5660300002)(76176011)(316002)(6506007)(91956017)(66946007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3649;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5re7MZzsxXdY3OvtbNuvxZN7WADHgVveTnbC/tRQgKqX3oJBO55Ei5Atv+voZKB96D/Dc6+eMSVelaFOBmE7jqJeU1h9d0kTiNXRPmVV+Y+UAOMPNdEr2U26J2kDQVDYvf9jR4fZRMJ7+UpHPi7bChwj4oomyDIgnDhoqVn3ODMaYfeTjfAy6CpJo3uhbVcNExHU+MLP532oZpHSVZS9HSzbnlH/oq93zll46RWlJqPVp5EuQ8Wq5wbqeN2ypg8fRYFT/095Mi2ipOLyUal2kXNWON111XmCrIaCQR75vefa6AiZdXFoFCnyYD9ECvkBNub/xU9zBKktONO+oegbnqnf6CzgAW0yj1ULJPBuKapdxwT33dyoNi1Y6APeA3Y5egTJZVAObi5SDTmgfAAbMrX1ZCU7qj6PpWY5IxYHq2Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E39D3B3187B71345A399D0A6D0E51DC7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b0d7a1-8c0c-4af6-3ca6-08d754341abc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2019 01:31:45.8771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFuNK9htYYsBB+XGU4nvPNL6lV82gaD0Fkh3qkaIPntaHgLarZa3F8G1J51PndXsHX+HfkeIjYt+M1OQM3PMlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3649
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_06:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=812 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910190009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzE4LzE5LCA1OjAzIFBNLCAiQmVuamFtaW4gSGVycmVuc2NobWlkdCIgPGJl
bmhAa2VybmVsLmNyYXNoaW5nLm9yZz4gd3JvdGU6DQoNCiAgICBPbiBGcmksIDIwMTktMTAtMTgg
YXQgMjI6NTAgKzAwMDAsIFZpamF5IEtoZW1rYSB3cm90ZToNCiAgICA+IEkgZG9uJ3QgaGF2ZSBt
dWNoIHVuZGVyc3RhbmRpbmcgb2YgSVAgU3RhY2sgYnV0IEkgd2VudCB0aHJvdWdoIGNvZGUgZGV0
YWlscyBhbmQgDQogICAgPiB5b3UgYXJlIHJpZ2h0IGFuZCBmb3VuZCB0aGF0IGl0IHNob3VsZCBm
YWxsYmFjayB0byBTVyBjYWxjdWxhdGlvbiBmb3IgSVBWNiBidXQgaXQgZG9lc24ndA0KICAgID4g
aGFwcGVuIGJlY2F1c2UgZnRnbWFjMTAwX2hhcmRfc3RhcnRfeG1pdCBjaGVja3MgZm9yIENIRUNL
U1VNX1BBUlRJQUwgYmVmb3JlDQogICAgPiBzZXR0aW5nIEhXIGNoZWNrc3VtIGFuZCBjYWxsaW5n
IGZ0Z21hYzEwMF9wcmVwX3R4X2NzdW0gZnVuY3Rpb24uIEFuZCBpbiBteSANCiAgICA+IHVuZGVy
c3RhbmRpbmcsIHRoaXMgdmFsdWUgaXMgc2V0IENIRUNLU1VNX1BBUlRJQUwgaW4gSVAgc3RhY2su
IEkgbG9va2VkIHVwIElQIHN0YWNrIGZvcg0KICAgID4gSVBWNiwgZmlsZSBuZXQvaXB2Ni9pcDZf
b3V0cHV0LmMsIGZ1bmN0aW9uIF9faXA2X2FwcGVuZF9kYXRhOiBoZXJlIGl0IHNldHMgDQogICAg
PiBDSEVDS1NVTV9QQVJUSUFMIG9ubHkgZm9yIFVEUCBwYWNrZXRzIG5vdCBmb3IgVENQIHBhY2tl
dHMuIFBsZWFzZSBsb29rIGF0IGxpbmUNCiAgICA+ICBudW1iZXIgMTg4MC4gVGhpcyBjb3VsZCBi
ZSBhbiBpc3N1ZSB3ZSBhcmUgc2VlaW5nIGhlcmUgYXMgd2h5DQogICAgPiBmdGdtYWMxMDBfcHJl
cF90eF9jc3VtIGlzIG5vdCBnZXR0aW5nIHRyaWdnZXJlZCBmb3IgSVBWNiB3aXRoIFRDUC4gUGxl
YXNlIGNvcnJlY3QNCiAgICA+IG1lIGlmIG15IHVuZGVyc3RhbmRpbmcgaXMgd3JvbmcuDQogICAg
PiAgICAgDQogICAgDQogICAgTm90IGVudGlyZWx5IHN1cmUuIHRjcF92Nl9zZW5kX3Jlc3BvbnNl
KCkgaW4gdGNwX2lwdjYuYyBkb2VzIHNldA0KICAgIENIRUNLU1VNX1BBUlRJQUwgYXMgd2VsbC4g
SSBkb24ndCByZWFsbHkga25vdyBob3cgdGhpbmdzIGFyZSBiZWluZw0KICAgIGhhbmRsZWQgaW4g
dGhhdCBwYXJ0IG9mIHRoZSBuZXR3b3JrIHN0YWNrIHRob3VnaC4NCiAgICANCiAgICBGcm9tIGEg
ZHJpdmVyIHBlcnNwZWN0aXZlLCBpZiB0aGUgdmFsdWUgb2YgaXBfc3VtbWVkIGlzIG5vdA0KICAg
IENIRUNLU1VNX1BBUlRJQUwgaXQgbWVhbnMgd2Ugc2hvdWxkIG5vdCBoYXZlIHRvIGNhbGN1bGF0
ZSBhbnkgY2hlY2tzdW0uDQogICAgQXQgbGVhc3QgdGhhdCdzIG15IHVuZGVyc3RhbmRpbmcgaGVy
ZS4NCiAgICANCiAgICBZb3UgbWF5IG5lZWQgdG8gYWRkIHNvbWUgdHJhY2VzIHRvIHRoZSBkcml2
ZXIgdG8gc2VlIHdoYXQgeW91IGdldCBpbg0KICAgIHRoZXJlLCB3aGF0IHByb3RvY29sIGluZGlj
YXRpb24gZXRjLi4uIGFuZCBhbmFseXplIHRoZSBjb3JyZXNwb25kaW5nDQogICAgcGFja2V0cyB3
aXRoIHNvbWV0aGluZyBsaWtlIHRjcGR1bXAgb3Igd2lyZXNoYXJrIG9uIHRoZSBvdGhlciBlbmQu
DQoNClRoYW5rcyBCZW4sDQpJIHdpbGwgdHJ5IHRvIGFkZCBzb21lIHRyYWNlIGFuZCB0ZXN0IHdo
YXRldmVyIHBvc3NpYmxlIGFuZCB0ZXN0IGl0LiBBcyB3ZQ0KZG9uJ3QgaGF2ZSB0Y3BkdW1wIGlu
dG8gb3VyIGltYWdlIGFuZCBJIGhhdmUgbGltaXRlZCB1bmRlcnN0YW5kaW5nIG9mDQpuZXR3b3Jr
aW5nIHN0YWNrIHNvIGlmIHlvdSBnZXQgc29tZSB0aW1lIHRvIHZlcmlmeSBpcHY2LCBpdCB3aWxs
IGJlIHJlYWxseQ0KaGVscGZ1bC4gDQogICAgDQogICAgQ2hlZXJzLA0KICAgIEJlbi4NCiAgICAN
CiAgICANCiAgICANCg0K
