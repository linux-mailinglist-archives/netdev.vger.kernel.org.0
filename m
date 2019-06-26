Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94CC55D46
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFZBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:16:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbfFZBQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:16:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q1CvTe001034;
        Tue, 25 Jun 2019 18:16:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/okaWO5T+8c7eVEbMUuysNdVSN6ATHcSeu6Mtxc0JXc=;
 b=ZlC92PWVj0sv6tCWIUi/1HPRHezuKgJ69b9k6GFiJxiPUjR58hlAclRgIqIWBR8TPANJ
 4Y7L5esvxGLO0DmB5Zi+0yFjdmjDdP4va3TPyBmLBdq7jup7fQTq03uFBmaAvzEEQujB
 3gZ/r6fSXC1EpYS+AWehi/rjfVqUtQwZ6yY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbq829vn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 18:16:07 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 18:16:06 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Jun 2019 18:16:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/okaWO5T+8c7eVEbMUuysNdVSN6ATHcSeu6Mtxc0JXc=;
 b=Lbr3EkZWW5Ul9pojnta14X0UQbVU9Ae6Om2Gw7wZpGVfPJ5tLtpMDO6bnH5+xPjfzLhqzpjlAlh0q63MZmR3OwZUJWitj+mz+zHnR1aDiPRgTOr/LTAmZNflzBYFfPDb4vHy6gmCtewBgKYkJolNC073k3kqhN7uMvDEahRlg5w=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1949.namprd15.prod.outlook.com (10.175.8.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 01:16:04 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.017; Wed, 26 Jun 2019
 01:16:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH bpf-next] bpf: fix compiler warning with CONFIG_MODULES=n
Thread-Topic: [PATCH bpf-next] bpf: fix compiler warning with CONFIG_MODULES=n
Thread-Index: AQHVK7cd+qp2zkpV+0WRQ5uIlT1wfKatIgOA
Date:   Wed, 26 Jun 2019 01:16:04 +0000
Message-ID: <2A287A9B-F7F8-4C71-BA49-0FD66399E292@fb.com>
References: <20190626003503.1985698-1-yhs@fb.com>
In-Reply-To: <20190626003503.1985698-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:8487]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbf52ea8-6236-446f-b7d1-08d6f9d3dc13
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1949;
x-ms-traffictypediagnostic: MWHPR15MB1949:
x-microsoft-antispam-prvs: <MWHPR15MB194949A5EC0AB4AA6E3F6E83B3E20@MWHPR15MB1949.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:275;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39860400002)(396003)(189003)(199004)(51914003)(50226002)(53936002)(7736002)(5660300002)(6246003)(6512007)(25786009)(305945005)(14454004)(6862004)(8936002)(54906003)(37006003)(6436002)(6486002)(81156014)(81166006)(316002)(8676002)(478600001)(36756003)(86362001)(229853002)(6636002)(2906002)(446003)(66946007)(66476007)(186003)(99286004)(66556008)(71200400001)(76116006)(66446008)(46003)(6506007)(71190400001)(73956011)(486006)(11346002)(2616005)(476003)(6116002)(64756008)(102836004)(4326008)(76176011)(57306001)(33656002)(256004)(14444005)(53546011)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1949;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Hs0GnYwr93KaYj5JzpxLzb3v0rFX6X+CQHFiRQuq4oeIJREZHFFZGuyfcjBKw2R4TBFGgGEQ5ZCZgrX0IG5FhS3/YXjFDu418zqAiELzAyETHRwcmbSnG/HUIeSjJiVtTtkJ3IlcUMtjAu68tgqQms155mFyKe7X698gdilpmRKxWT9ZVm2oy4oskMOhNTk/FQBrFuqfpwegiwGTgoU3OZtnXTqRiFssC7BcFl0ECKJf1MtwCC8zrmBrcy0AXeZNjrXDS1Ay9D2chV5xKODqXpNcacgZLqzA4S1wRIi7+3VEi7sfBR/yIlBeuwrAg+LwpVM4hLsqCoM9uOSZR6dCopFsmr8k30fyu3epiJojMuOFGSdf3pIMQt9L9R/eIv9QkfsVVEJ2d3W2X9cwBaupA2NxJ81LJLZMgvOqm2qWpc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <979BF3F873C24A4493AB14E4F7D68DAF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf52ea8-6236-446f-b7d1-08d6f9d3dc13
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 01:16:04.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260012
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVuIDI1LCAyMDE5LCBhdCA1OjM1IFBNLCBZb25naG9uZyBTb25nIDx5aHNAZmIu
Y29tPiB3cm90ZToNCj4gDQo+IFdpdGggQ09ORklHX01PRFVMRVM9biwgdGhlIGZvbGxvd2luZyBj
b21waWxlciB3YXJuaW5nIG9jY3VyczoNCj4gIC9kYXRhL3VzZXJzL3locy93b3JrL25ldC1uZXh0
L2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYzo2MDU6MTM6IHdhcm5pbmc6DQo+ICAgICAg4oCYZG9f
YnBmX3NlbmRfc2lnbmFs4oCZIGRlZmluZWQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1mdW5jdGlv
bl0NCj4gIHN0YXRpYyB2b2lkIGRvX2JwZl9zZW5kX3NpZ25hbChzdHJ1Y3QgaXJxX3dvcmsgKmVu
dHJ5KQ0KPiANCj4gVGhlIF9faW5pdCBmdW5jdGlvbiBzZW5kX3NpZ25hbF9pcnFfd29ya19pbml0
KCksIHdoaWNoIGNhbGxzDQo+IGRvX2JwZl9zZW5kX3NpZ25hbCgpLCBpcyBkZWZpbmVkIHVuZGVy
IENPTkZJR19NT0RVTEVTLiBIZW5jZSwNCj4gd2hlbiBDT05GSUdfTU9EVUxFUz1uLCBub2JvZHkg
Y2FsbHMgc3RhdGljIGZ1bmN0aW9uIGRvX2JwZl9zZW5kX3NpZ25hbCgpLA0KPiBoZW5jZSB0aGUg
d2FybmluZy4NCj4gDQo+IFRoZSBpbml0IGZ1bmN0aW9uIHNlbmRfc2lnbmFsX2lycV93b3JrX2lu
aXQoKSBzaG91bGQgd29yayB3aXRob3V0DQo+IENPTkZJR19NT0RVTEVTLiBNb3ZpbmcgaXQgb3V0
IG9mIENPTkZJR19NT0RVTEVTDQo+IGNvZGUgc2VjdGlvbiBmaXhlZCB0aGUgY29tcGlsZXIgd2Fy
bmluZywgYW5kIGFsc28gbWFrZSBicGZfc2VuZF9zaWduYWwoKQ0KPiBoZWxwZXIgd29yayB3aXRo
b3V0IENPTkZJR19NT0RVTEVTLg0KPiANCj4gRml4ZXM6IDhiNDAxZjllZDI0NCAoImJwZjogaW1w
bGVtZW50IGJwZl9zZW5kX3NpZ25hbCgpIGhlbHBlciIpDQo+IFJlcG9ydGVkLUJ5OiBBcm5kIEJl
cmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBZb25naG9uZyBTb25nIDx5
aHNAZmIuY29tPg0KDQpUaGFua3MgZm9yIHRoZSBmaXghDQoNCkFja2VkLWJ5OiBTb25nIExpdSA8
c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KDQoNCj4gLS0tDQo+IGtlcm5lbC90cmFjZS9icGZfdHJh
Y2UuYyB8IDI3ICsrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPiAxIGZpbGUgY2hhbmdlZCwg
MTQgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEva2Vy
bmVsL3RyYWNlL2JwZl90cmFjZS5jIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+IGluZGV4
IGMxMDJjMjQwYmIwYi4uY2ExMjU1ZDE0NTc2IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvdHJhY2Uv
YnBmX3RyYWNlLmMNCj4gKysrIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+IEBAIC0xNDMx
LDYgKzE0MzEsMjAgQEAgaW50IGJwZl9nZXRfcGVyZl9ldmVudF9pbmZvKGNvbnN0IHN0cnVjdCBw
ZXJmX2V2ZW50ICpldmVudCwgdTMyICpwcm9nX2lkLA0KPiAJcmV0dXJuIGVycjsNCj4gfQ0KPiAN
Cj4gK3N0YXRpYyBpbnQgX19pbml0IHNlbmRfc2lnbmFsX2lycV93b3JrX2luaXQodm9pZCkNCj4g
K3sNCj4gKwlpbnQgY3B1Ow0KPiArCXN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsN
Cj4gKw0KPiArCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpIHsNCj4gKwkJd29yayA9IHBlcl9j
cHVfcHRyKCZzZW5kX3NpZ25hbF93b3JrLCBjcHUpOw0KPiArCQlpbml0X2lycV93b3JrKCZ3b3Jr
LT5pcnFfd29yaywgZG9fYnBmX3NlbmRfc2lnbmFsKTsNCj4gKwl9DQo+ICsJcmV0dXJuIDA7DQo+
ICt9DQo+ICsNCj4gK3N1YnN5c19pbml0Y2FsbChzZW5kX3NpZ25hbF9pcnFfd29ya19pbml0KTsN
Cj4gKw0KPiAjaWZkZWYgQ09ORklHX01PRFVMRVMNCj4gc3RhdGljIGludCBicGZfZXZlbnRfbm90
aWZ5KHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsIHVuc2lnbmVkIGxvbmcgb3AsDQo+IAkJCSAg
ICB2b2lkICptb2R1bGUpDQo+IEBAIC0xNDc4LDE4ICsxNDkyLDUgQEAgc3RhdGljIGludCBfX2lu
aXQgYnBmX2V2ZW50X2luaXQodm9pZCkNCj4gCXJldHVybiAwOw0KPiB9DQo+IA0KPiAtc3RhdGlj
IGludCBfX2luaXQgc2VuZF9zaWduYWxfaXJxX3dvcmtfaW5pdCh2b2lkKQ0KPiAtew0KPiAtCWlu
dCBjcHU7DQo+IC0Jc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrICp3b3JrOw0KPiAtDQo+IC0J
Zm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgew0KPiAtCQl3b3JrID0gcGVyX2NwdV9wdHIoJnNl
bmRfc2lnbmFsX3dvcmssIGNwdSk7DQo+IC0JCWluaXRfaXJxX3dvcmsoJndvcmstPmlycV93b3Jr
LCBkb19icGZfc2VuZF9zaWduYWwpOw0KPiAtCX0NCj4gLQlyZXR1cm4gMDsNCj4gLX0NCj4gLQ0K
PiBmc19pbml0Y2FsbChicGZfZXZlbnRfaW5pdCk7DQo+IC1zdWJzeXNfaW5pdGNhbGwoc2VuZF9z
aWduYWxfaXJxX3dvcmtfaW5pdCk7DQo+ICNlbmRpZiAvKiBDT05GSUdfTU9EVUxFUyAqLw0KPiAt
LSANCj4gMi4xNy4xDQo+IA0KDQo=
