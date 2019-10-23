Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF52E1F15
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406598AbfJWPU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:20:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3846 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390636AbfJWPU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:20:28 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9NAFG2d004229;
        Wed, 23 Oct 2019 08:20:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gYgR8u44BHu6VIV7oIV+YPL0kQGBpuHgmh9ejlc+2ng=;
 b=AXcVQxLSl6280bsMvRCoR9cNqL7saOnk9Jj0eYD91t2exebh0pYfPs3hKSlAOf12XFBB
 johf0a4/XzGL0Prjs/mTlp4PihL7+E1t3pRVFqE7wpAnMo4wWRNgp551RLS/1xClJCjJ
 HfticDPt2WxOgxhrIV2p7sA/aLhv93GubAQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vt9tekyfa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 23 Oct 2019 08:20:23 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 23 Oct 2019 08:20:21 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 23 Oct 2019 08:20:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWkHTWHEKCQyYK2NRKCWBve0we5bDIJkVdx7Qfhx0pNYQvTimqtrPAyELCcVLIyev/rvoE33uLb3OtFm6eKmGFhwErzn+YHVx7UvV1/DUeQwa/KcUGKdBaXzq+pGM5mQLTGO89pgSG0FM4VUb7WqLpoPhzNDGHlFPb+j5/VVVO6XTZ01VIlPg1oWYfKIj9pMyPPte5H8m8yGYZkeXD4BD0GJeY1V6r+v5PRFbL8HFghn5Jp9Zmyre1tyq1SlwKHljJM/2goTmZNEiARcIu5YDUjBsBKPAFqdv7qQJXetlp4KIkoF11H4eEbGWiT/kbHBMKMW/18gU5qTUfbA91Ubeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYgR8u44BHu6VIV7oIV+YPL0kQGBpuHgmh9ejlc+2ng=;
 b=cdVoe+5whBYDI/6GXvQjegrZvw+dbVVYzoarT+sZxCY34r8eCVcJ21m5jL6LvDcWOgI7HHfblBZZJtApB/Peyh4fdwDJwoTSnSFLJf1G2JWHQ7mmb0w+PKgIILskr1CUM5Qu125wHfV0bl8YXu7xEgg75bgEWSQKvYYyQ4eoMRHOjfkLqTtRWWmUdXtF8b77eUByYjgRRfL7saWV97At5JvlfglLFjH84Rz7zxM45SKz5fNirGEusYJSmt1yH+XyD2mcf3MzP5g/02oYGkr4Ey2AJwlDHiZAE3IBhJaGBn68DBuFsB/70yEMxT7Ajq2L8eE3l87VvXYSHvBbo606eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYgR8u44BHu6VIV7oIV+YPL0kQGBpuHgmh9ejlc+2ng=;
 b=KqamqIZnc6HPtxZDWVAFknwBDB9Kl/qc+Xjok2A+Asp+N23gsqKk4Z6oLC03RjUqLuXFpJQnVjvVR1XMhAjHmvaPC4ZhFVm7LzkwSkzo4hT0fjDBwamZxWFFPj2U5PNd9Me6f2L4quX+EDl0Cf5InZdMTrTxbQihVwev7cuZqeI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2661.namprd15.prod.outlook.com (20.179.158.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 15:20:19 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 15:20:19 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Thread-Topic: [PATCH v15 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Thread-Index: AQHViU5brqJLWzKWNEuwFWWhXAwQ8KdoTacAgAAKcQA=
Date:   Wed, 23 Oct 2019 15:20:19 +0000
Message-ID: <37a89099-d1da-5c09-3ab6-cfed2b4bc5ba@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-5-cneirabustos@gmail.com>
 <e3138bca-14b1-6fcf-12be-992462abe0ce@fb.com>
 <20191023144245.GA4112@ebpf00.byteswizards.com>
In-Reply-To: <20191023144245.GA4112@ebpf00.byteswizards.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:104:6::13) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c7b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2398ae5-c485-44d5-9c25-08d757cc83d1
x-ms-traffictypediagnostic: BYAPR15MB2661:
x-microsoft-antispam-prvs: <BYAPR15MB2661EE5EFBF3FE743E9FF19CD36B0@BYAPR15MB2661.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(189003)(53546011)(31696002)(476003)(2616005)(11346002)(6506007)(386003)(25786009)(46003)(186003)(6246003)(316002)(71190400001)(36756003)(7736002)(305945005)(86362001)(4326008)(1411001)(54906003)(71200400001)(5660300002)(14444005)(486006)(8936002)(14454004)(256004)(478600001)(6486002)(76176011)(6436002)(446003)(2906002)(52116002)(6916009)(31686004)(5024004)(99286004)(8676002)(66476007)(6116002)(229853002)(6512007)(66946007)(81166006)(81156014)(102836004)(66446008)(64756008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2661;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CoVP6yIwAj3CPGVAaLte5eCobrrhbrckGauQEkDUyG+MYqECfMeibvmfHD8zMh2baMNbxjx0rsLnLhH4KouqAsU90/f/y6zCSwuccBaFsHAAslSEhjaAQKiPy7WzuoQTqeDxlYZAHjnqY0vx/ToOEDvYJx+1KR9hndxli0p2u6Ll6iIhaq9eN58Z02+M6HuHi9ZgwH8lp3E6t8ua/v3QHzYHfZq+ADa4F25HTNRogQhO27uR5auUICSC/wxh2PmMYUQtvyxx9vLOtYCf2NSpVPUumeSmT5B2QxEAmM48iFAJrHn7Nef0FX/cS5uW61DSfMinSWGYUbJcFo1USB71XZ6QNTgutkCV4ExEQfGFSNmHiJ0jrd6UAeZJT9oVhJIwzoR5GoQSd5KEbVhwqlFOtGx+zkxgLOD2oZ6YbEtgKQPZfOlIu9D+CRdwmJpsMFdx
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <96E8AEBCFF0A91449AE5179E06DA83FF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d2398ae5-c485-44d5-9c25-08d757cc83d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 15:20:19.5709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5BtzpEasjjD80Lb/KYodZKoFfT/0fA+iU8me5qi5hvMIeRpTgOkXv+pSSqBAJTm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2661
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_06:2019-10-22,2019-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910220185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIzLzE5IDc6NDIgQU0sIENhcmxvcyBBbnRvbmlvIE5laXJhIEJ1c3RvcyB3cm90
ZToNCj4gT24gV2VkLCBPY3QgMjMsIDIwMTkgYXQgMDM6MDI6NTFBTSArMDAwMCwgWW9uZ2hvbmcg
U29uZyB3cm90ZToNCj4+DQo+Pg0KPj4gT24gMTAvMjIvMTkgMTI6MTcgUE0sIENhcmxvcyBOZWly
YSB3cm90ZToNCj4+PiBTZWxmIHRlc3RzIGFkZGVkIGZvciBuZXcgaGVscGVyDQo+Pg0KPj4gUGxl
YXNlIG1lbnRpb24gdGhlIG5hbWUgb2YgdGhlIG5ldyBoZWxwZXIgaW4gdGhlIGNvbW1pdCBtZXNz
YWdlLg0KPj4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IENhcmxvcyBOZWlyYSA8Y25laXJhYnVz
dG9zQGdtYWlsLmNvbT4NCj4+DQo+PiBMR1RNIEFjayB3aXRoIGEgZmV3IG5pdHMgYmVsb3cuDQo+
PiBBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4+DQo+Pj4gLS0tDQo+Pj4g
ICAgLi4uL2JwZi9wcm9nX3Rlc3RzL25zX2N1cnJlbnRfcGlkX3RnaWQuYyAgICAgIHwgODcgKysr
KysrKysrKysrKysrKysrKw0KPj4+ICAgIC4uLi9icGYvcHJvZ3MvdGVzdF9uc19jdXJyZW50X3Bp
ZF90Z2lkLmMgICAgICB8IDM3ICsrKysrKysrDQo+Pj4gICAgMiBmaWxlcyBjaGFuZ2VkLCAxMjQg
aW5zZXJ0aW9ucygrKQ0KPj4+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9uc19jdXJyZW50X3BpZF90Z2lkLmMNCj4+PiAgICBjcmVh
dGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfbnNf
Y3VycmVudF9waWRfdGdpZC5jDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvbnNfY3VycmVudF9waWRfdGdpZC5jIGIvdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvbnNfY3VycmVudF9waWRfdGdpZC5jDQo+Pj4g
bmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+PiBpbmRleCAwMDAwMDAwMDAwMDAuLjI1N2YxODk5OWJi
Ng0KPj4+IC0tLSAvZGV2L251bGwNCj4+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ190ZXN0cy9uc19jdXJyZW50X3BpZF90Z2lkLmMNCj4+PiBAQCAtMCwwICsxLDg3IEBA
DQo+Pj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+Pj4gKy8qIENvcHly
aWdodCAoYykgMjAxOSBDYXJsb3MgTmVpcmEgY25laXJhYnVzdG9zQGdtYWlsLmNvbSAqLw0KPj4+
ICsjaW5jbHVkZSA8dGVzdF9wcm9ncy5oPg0KPj4+ICsjaW5jbHVkZSA8c3lzL3N0YXQuaD4NCj4+
PiArI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KPj4+ICsjaW5jbHVkZSA8dW5pc3RkLmg+DQo+Pj4g
KyNpbmNsdWRlIDxzeXMvc3lzY2FsbC5oPg0KPj4+ICsNCj4+PiArc3RydWN0IGJzcyB7DQo+Pj4g
KwlfX3U2NCBkZXY7DQo+Pj4gKwlfX3U2NCBpbm87DQo+Pj4gKwlfX3U2NCBwaWRfdGdpZDsNCj4+
PiArCV9fdTY0IHVzZXJfcGlkX3RnaWQ7DQo+Pj4gK307DQo+Pj4gKw0KPj4+ICt2b2lkIHRlc3Rf
bnNfY3VycmVudF9waWRfdGdpZCh2b2lkKQ0KPj4+ICt7DQo+Pj4gKwljb25zdCBjaGFyICpwcm9i
ZV9uYW1lID0gInJhd190cmFjZXBvaW50L3N5c19lbnRlciI7DQo+Pj4gKwljb25zdCBjaGFyICpm
aWxlID0gInRlc3RfbnNfY3VycmVudF9waWRfdGdpZC5vIjsNCj4+PiArCWludCBlcnIsIGtleSA9
IDAsIGR1cmF0aW9uID0gMDsNCj4+PiArCXN0cnVjdCBicGZfbGluayAqbGluayA9IE5VTEw7DQo+
Pj4gKwlzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2c7DQo+Pj4gKwlzdHJ1Y3QgYnBmX21hcCAqYnNz
X21hcDsNCj4+PiArCXN0cnVjdCBicGZfb2JqZWN0ICpvYmo7DQo+Pj4gKwlzdHJ1Y3QgYnNzIGJz
czsNCj4+PiArCXN0cnVjdCBzdGF0IHN0Ow0KPj4+ICsJX191NjQgaWQ7DQo+Pj4gKw0KPj4+ICsJ
b2JqID0gYnBmX29iamVjdF9fb3Blbl9maWxlKGZpbGUsIE5VTEwpOw0KPj4+ICsJaWYgKENIRUNL
KElTX0VSUihvYmopLCAib2JqX29wZW4iLCAiZXJyICVsZFxuIiwgUFRSX0VSUihvYmopKSkNCj4+
PiArCQlyZXR1cm47DQo+Pj4gKw0KPj4+ICsJZXJyID0gYnBmX29iamVjdF9fbG9hZChvYmopOw0K
Pj4+ICsJaWYgKENIRUNLKGVyciwgIm9ial9sb2FkIiwgImVyciAlZCBlcnJubyAlZFxuIiwgZXJy
LCBlcnJubykpDQo+Pj4gKwkJZ290byBjbGVhbnVwOw0KPj4+ICsNCj4+PiArCWJzc19tYXAgPSBi
cGZfb2JqZWN0X19maW5kX21hcF9ieV9uYW1lKG9iaiwgInRlc3RfbnNfLmJzcyIpOw0KPj4+ICsJ
aWYgKENIRUNLKCFic3NfbWFwLCAiZmluZF9ic3NfbWFwIiwgImZhaWxlZFxuIikpDQo+Pj4gKwkJ
Z290byBjbGVhbnVwOw0KPj4+ICsNCj4+PiArCXByb2cgPSBicGZfb2JqZWN0X19maW5kX3Byb2dy
YW1fYnlfdGl0bGUob2JqLCBwcm9iZV9uYW1lKTsNCj4+PiArCWlmIChDSEVDSyghcHJvZywgImZp
bmRfcHJvZyIsICJwcm9nICclcycgbm90IGZvdW5kXG4iLA0KPj4+ICsJCSAgcHJvYmVfbmFtZSkp
DQo+Pj4gKwkJZ290byBjbGVhbnVwOw0KPj4+ICsNCj4+PiArCW1lbXNldCgmYnNzLCAwLCBzaXpl
b2YoYnNzKSk7DQo+Pj4gKwlwaWRfdCB0aWQgPSBzeXNjYWxsKFNZU19nZXR0aWQpOw0KPj4+ICsJ
cGlkX3QgcGlkID0gZ2V0cGlkKCk7DQo+Pj4gKw0KPj4+ICsJaWQgPSAoX191NjQpIHRpZCA8PCAz
MiB8IHBpZDsNCj4+PiArCWJzcy51c2VyX3BpZF90Z2lkID0gaWQ7DQo+Pj4gKw0KPj4+ICsJaWYg
KENIRUNLX0ZBSUwoc3RhdCgiL3Byb2Mvc2VsZi9ucy9waWQiLCAmc3QpKSkgew0KPj4+ICsJCXBl
cnJvcigiRmFpbGVkIHRvIHN0YXQgL3Byb2Mvc2VsZi9ucy9waWQiKTsNCj4+PiArCQlnb3RvIGNs
ZWFudXA7DQo+Pj4gKwl9DQo+Pj4gKw0KPj4+ICsJYnNzLmRldiA9IHN0LnN0X2RldjsNCj4+PiAr
CWJzcy5pbm8gPSBzdC5zdF9pbm87DQo+Pj4gKw0KPj4+ICsJZXJyID0gYnBmX21hcF91cGRhdGVf
ZWxlbShicGZfbWFwX19mZChic3NfbWFwKSwgJmtleSwgJmJzcywgMCk7DQo+Pj4gKwlpZiAoQ0hF
Q0soZXJyLCAic2V0dGluZ19ic3MiLCAiZmFpbGVkIHRvIHNldCBic3MgOiAlZFxuIiwgZXJyKSkN
Cj4+PiArCQlnb3RvIGNsZWFudXA7DQo+Pj4gKw0KPj4+ICsJbGluayA9IGJwZl9wcm9ncmFtX19h
dHRhY2hfcmF3X3RyYWNlcG9pbnQocHJvZywgInN5c19lbnRlciIpOw0KPj4+ICsJaWYgKENIRUNL
KElTX0VSUihsaW5rKSwgImF0dGFjaF9yYXdfdHAiLCAiZXJyICVsZFxuIiwNCj4+PiArCQkgIFBU
Ul9FUlIobGluaykpKQ0KPj4+ICsJCWdvdG8gY2xlYW51cDsNCj4+DQo+PiBZb3UgYWxyZWFkeSBo
YXZlIGRlZmF1bHQgbGluayA9IE5VTEwuDQo+PiBIZXJlLCBJIHRoaW5rIHlvdSBjYW4gZG8NCj4+
IAkJbGluayA9IE5VTEw7DQo+PiAJCWdvdG8gY2xlYW51cDsNCj4+DQo+Pj4gKw0KPj4+ICsJLyog
dHJpZ2dlciBzb21lIHN5c2NhbGxzICovDQo+Pj4gKwl1c2xlZXAoMSk7DQo+Pj4gKw0KPj4+ICsJ
ZXJyID0gYnBmX21hcF9sb29rdXBfZWxlbShicGZfbWFwX19mZChic3NfbWFwKSwgJmtleSwgJmJz
cyk7DQo+Pj4gKwlpZiAoQ0hFQ0soZXJyLCAic2V0X2JzcyIsICJmYWlsZWQgdG8gZ2V0IGJzcyA6
ICVkXG4iLCBlcnIpKQ0KPj4+ICsJCWdvdG8gY2xlYW51cDsNCj4+PiArDQo+Pj4gKwlpZiAoQ0hF
Q0soaWQgIT0gYnNzLnBpZF90Z2lkLCAiQ29tcGFyZSB1c2VyIHBpZC90Z2lkIHZzLiBicGYgcGlk
L3RnaWQiLA0KPj4+ICsJCSAgIlVzZXIgcGlkL3RnaWQgJWxsdSBFQlBGIHBpZC90Z2lkICVsbHVc
biIsIGlkLCBic3MucGlkX3RnaWQpKQ0KPj4NCj4+IEVCUEYgLT4gQlBGPw0KPj4NCj4+PiArCQln
b3RvIGNsZWFudXA7DQo+Pj4gK2NsZWFudXA6DQo+Pj4gKw0KPj4NCj4+IFRoZSBhYm92ZSBlbXB0
eSBsaW5lIGNhbiBiZSByZW1vdmVkLg0KPj4NCj4+PiArCWlmICghSVNfRVJSX09SX05VTEwobGlu
aykpIHsNCj4+DQo+PiBXaXRoIHRoZSBhYm92ZSBzdWdnZXN0ZWQgY2hhbmdlLCB5b3Ugb25seSBu
ZWVkIHRvIGNoZWNrDQo+PiAJaWYgKCFsaW5rKQ0KPj4NCj4+PiArCQlicGZfbGlua19fZGVzdHJv
eShsaW5rKTsNCj4+PiArCQlsaW5rID0gTlVMTDsNCj4+PiArCX0NCj4+PiArCWJwZl9vYmplY3Rf
X2Nsb3NlKG9iaik7DQo+Pj4gK30NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dzL3Rlc3RfbnNfY3VycmVudF9waWRfdGdpZC5jIGIvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfbnNfY3VycmVudF9waWRfdGdpZC5jDQo+Pj4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4+PiBpbmRleCAwMDAwMDAwMDAwMDAuLmNkYjc3ZWIxYTRmYg0K
Pj4+IC0tLSAvZGV2L251bGwNCj4+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
cHJvZ3MvdGVzdF9uc19jdXJyZW50X3BpZF90Z2lkLmMNCj4+PiBAQCAtMCwwICsxLDM3IEBADQo+
Pj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+Pj4gKy8qIENvcHlyaWdo
dCAoYykgMjAxOSBDYXJsb3MgTmVpcmEgY25laXJhYnVzdG9zQGdtYWlsLmNvbSAqLw0KPj4+ICsN
Cj4+PiArI2luY2x1ZGUgPGxpbnV4L2JwZi5oPg0KPj4+ICsjaW5jbHVkZSA8c3RkaW50Lmg+DQo+
Pj4gKyNpbmNsdWRlICJicGZfaGVscGVycy5oIg0KPj4+ICsNCj4+PiArc3RhdGljIHZvbGF0aWxl
IHN0cnVjdCB7DQo+Pj4gKwlfX3U2NCBkZXY7DQo+Pj4gKwlfX3U2NCBpbm87DQo+Pj4gKwlfX3U2
NCBwaWRfdGdpZDsNCj4+PiArCV9fdTY0IHVzZXJfcGlkX3RnaWQ7DQo+Pj4gK30gcmVzOw0KPj4+
ICsNCj4+PiArU0VDKCJyYXdfdHJhY2Vwb2ludC9zeXNfZW50ZXIiKQ0KPj4+ICtpbnQgdHJhY2Uo
dm9pZCAqY3R4KQ0KPj4+ICt7DQo+Pj4gKwlfX3U2NCAgbnNfcGlkX3RnaWQsIGV4cGVjdGVkX3Bp
ZDsNCj4+PiArCXN0cnVjdCBicGZfcGlkbnNfaW5mbyBuc2RhdGE7DQo+Pj4gKwlfX3UzMiBrZXkg
PSAwOw0KPj4+ICsNCj4+PiArCWlmIChicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQocmVzLmRl
diwgcmVzLmlubywgJm5zZGF0YSwNCj4+PiArCQkgICBzaXplb2Yoc3RydWN0IGJwZl9waWRuc19p
bmZvKSkpDQo+Pj4gKwkJcmV0dXJuIDA7DQo+Pj4gKw0KPj4+ICsJbnNfcGlkX3RnaWQgPSAoX191
NjQpbnNkYXRhLnRnaWQgPDwgMzIgfCBuc2RhdGEucGlkOw0KPj4+ICsJZXhwZWN0ZWRfcGlkID0g
cmVzLnVzZXJfcGlkX3RnaWQ7DQo+Pj4gKw0KPj4+ICsJaWYgKGV4cGVjdGVkX3BpZCAhPSBuc19w
aWRfdGdpZCkNCj4+PiArCQlyZXR1cm4gMDsNCj4+PiArDQo+Pj4gKwlyZXMucGlkX3RnaWQgPSBu
c19waWRfdGdpZDsNCj4+PiArDQo+Pj4gKwlyZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+PiAr
Y2hhciBfbGljZW5zZVtdIFNFQygibGljZW5zZSIpID0gIkdQTCI7DQo+Pg0KPj4gVGhlIG5ldyBo
ZWxwZXIgZG9lcyBub3QgcmVxdWlyZSBHUEwsIGNvdWxkIHlvdSBkb3VibGUgY2hlY2sgdGhpcz8N
Cj4+IFRoZSBhYm92ZSBfbGljZW5zZSBzaG91bGQgbm90IGJlIG5lY2Vzc2FyeS4NCj4gDQo+IFRo
YW5rcywgWW9uZ2hvbmcuDQo+IA0KPiBEbyBJIG5lZWQgdG8gcmUtc2VuZCB0aGUgc2VyaWVzIG9m
IHBhdGNoZXMgYXMgdjE2ID8gb3IgSSBjb3VsZCByZXBseSB0byB0aGlzIHRocmVhZCBhZGRyZXNz
aW5nIHlvdXIgY29tbWVudHMgZm9yIHBhdGNoIDQvNS4NCg0KWW91IGNhbiB3YWl0IGZvciBFcmlj
J3MgQUNLIGFuZCB0aGVuIHJlc2VuZCBhIG5ldyB2ZXJzaW9uIG9mIHRoZSBwYXRjaCANCnNldCB3
aXRoIGFsbCBBY2sncy4NCg0KPiBUaGFua3MgYWdhaW4gZm9yIHlvdXIgc3VwcG9ydC4NCj4gDQo+
IEJlc3RzDQo+IA0K
