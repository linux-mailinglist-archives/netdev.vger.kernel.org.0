Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62576E1057
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 05:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389525AbfJWDFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 23:05:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40868 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727831AbfJWDFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 23:05:07 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9MLYqCS004221;
        Tue, 22 Oct 2019 20:05:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=I8YyIQ6INq4jUz3JXc3RaIS1OdvLlfxoxaAiS6clumo=;
 b=OrpnQXWiuhYy4WmPqSA/hJkum3/iHjctDSOsOVbnUvDVeYwUkjM4me29iBlMggkl9KN/
 eMuJZbS865ba7iz85cLsY3TZxOGG9xFL0rEXFG/Xt6Ik9gU3+wP4ZWB9vGv7IxbJAYFa
 aQZlKpEkBo8Ey/U7l1HS0S9EeSd5GCTnITQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vt9teh3vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 20:05:04 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 22 Oct 2019 20:05:03 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 20:05:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gf4X87YDRMYAnLOQOamAeAdY2B9JGpmbKKw+LIuF+o3Wp26VgFykKRp+RqQm9i8gswozV4e0QXLflTAbTmAQ0dx4uF68mf7JyO+47ypTQle09L3iwh+tnA0nNCM/O5TI4yZbpGNpxjiAWcxg85YzOOk4We+Nl7HvhAD7/c1gaT3UfHP/wxHEfEvVpM9dEQOGBJXw5AsUxL9Bf4CCh2jq57ST5Tj6kprZ007Hzd3yvn1me0POhv2p7OaBzlTZFVe22pId8e92stLzZx4PQIRy3esLC+YeE5mpA1cWlabU870BZzeP38PAnzLhdXvXlzaIb9Zfhe6rgJYAiV8joR+G9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8YyIQ6INq4jUz3JXc3RaIS1OdvLlfxoxaAiS6clumo=;
 b=fmEK1B/Enncm3f/82hiwaEO+AfVy67dlrw6LnUyLwjKREVjTxq1JrtFDwCV/h/AlzYJlNw3wNKvOIXuyOVVQcuPbuI5dOEALTonPW/Do2qAy1AsK2qAAYJ5EN0eKNmW+64XuGpvaSqL15fllHSqK3y/YArAiR52SxjNweYKIu32dIiu9popW/6ZcESRw7LVZbkFq2IbKhSHAf4d/D3OPXbqqMncd5nCA1VM4VbI2J+ueokSYIpJDEgefCAdtWrmGTPqria/yAoUAiMzXjGk36OzwNOPHwfIrsHLWPqqTrEDtX9YECoPgaiaTNn2WGo3qoWD/frxujvX7wn7a428+HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8YyIQ6INq4jUz3JXc3RaIS1OdvLlfxoxaAiS6clumo=;
 b=D3uIcO1nErT6Sd4cLrLwRWjbzFrPf+CKNmpguSPpdiROjtdxo6sWbiUj1UoeeAvC6vD/GvhEt4+QbM3UaZ49Zwe81XVlT7et9F3U9s7ixaS9AqMzS0CikvUu5YdP/vlxnsqUR4UZD2JPFmsIfiD+QPVviLR/rU9u/W+Pg65FFCE=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2456.namprd15.prod.outlook.com (52.135.193.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 23 Oct 2019 03:05:01 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 03:05:01 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Topic: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Index: AQHViQ10L4Sk4Hu3bUSGIRdEQH4YW6dnizGA
Date:   Wed, 23 Oct 2019 03:05:01 +0000
Message-ID: <7b7ba580-14f8-d5aa-65d5-0d6042e7a566@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-2-cneirabustos@gmail.com>
In-Reply-To: <20191022191751.3780-2-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0016.namprd16.prod.outlook.com
 (2603:10b6:300:da::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b6b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10bfaf71-b4a3-450c-a115-08d75765cb99
x-ms-traffictypediagnostic: BYAPR15MB2456:
x-microsoft-antispam-prvs: <BYAPR15MB2456A2ED0B8E3C49663A8300D36B0@BYAPR15MB2456.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(478600001)(14454004)(5660300002)(54906003)(31686004)(6246003)(316002)(6436002)(66946007)(6486002)(229853002)(31696002)(25786009)(64756008)(66556008)(4326008)(66476007)(6512007)(76176011)(36756003)(2501003)(99286004)(476003)(2906002)(8936002)(52116002)(486006)(6506007)(305945005)(186003)(7736002)(2616005)(6116002)(386003)(71200400001)(46003)(110136005)(86362001)(446003)(102836004)(66446008)(256004)(8676002)(11346002)(81166006)(81156014)(71190400001)(53546011)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2456;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: no67lepQw87GFjo9dNyPKqY22eJBwCwF+rigHctDV28Mt5OQlcdnpPnKvJ2w3z3qztrKHUTQENyef1/qI+4Q86gWhXm58AQdx+ApSgjF/sEFLcwK7jTvpQ288B5SK3XNnu0/m5FjXiXAbwXCGFfe+9fhqNPwxVJPNuX1FbsK/F9luORojVKiY70hszWa/JMw+Z1MsEVgDjPOsnSoC7tob3YKb5835J4j5yWd3piz6O5A0aIrzE/svMuePfWeo60wtN0jmZKL8aTplFng/lY3ON1fhVqFNHeRq8azPaVVBcV7A+50aZ/GtUIKMZ4QmH/9VcKmyUvDNBGVONlhL+u2wvRk5Gb7VsmUssT+eBAxLJ7mlKmMMXqu2/FjdIyCLoUomxrIxtgRA1TjapF+/wOPYCSpoeY4nA3+1b0QcnaEU49ZyhasDB/hV5ad3cvPEZu+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD6050F7A12D4C48834D5D584AEA6DF4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bfaf71-b4a3-450c-a115-08d75765cb99
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 03:05:01.7279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T6MR64TT0YJ4KtmfanJoHlCb6PZWt7J7PYiUm382GEMbgEZH1UZZ3SfA9UGmecBH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
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

DQpIaSwgRXJpYywNCg0KQ291bGQgeW91IHRha2UgYSBsb29rIGF0IHRoaXMgcGF0Y2ggdGhlIHNl
cmllcyBhcyB3ZWxsPw0KSWYgaXQgbG9va3MgZ29vZCwgY291bGQgeW91IGFjayB0aGUgcGF0Y2gg
IzE/DQoNClRoYW5rcyENCg0KT24gMTAvMjIvMTkgMTI6MTcgUE0sIENhcmxvcyBOZWlyYSB3cm90
ZToNCj4gbnNfbWF0Y2ggcmV0dXJucyB0cnVlIGlmIHRoZSBuYW1lc3BhY2UgaW5vZGUgYW5kIGRl
dl90IG1hdGNoZXMgdGhlIG9uZXMNCj4gcHJvdmlkZWQgYnkgdGhlIGNhbGxlci4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENhcmxvcyBOZWlyYSA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4NCj4gLS0t
DQo+ICAgZnMvbnNmcy5jICAgICAgICAgICAgICAgfCAxNCArKysrKysrKysrKysrKw0KPiAgIGlu
Y2x1ZGUvbGludXgvcHJvY19ucy5oIHwgIDIgKysNCj4gICAyIGZpbGVzIGNoYW5nZWQsIDE2IGlu
c2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9uc2ZzLmMgYi9mcy9uc2ZzLmMNCj4g
aW5kZXggYTA0MzE2NDJjNmI1Li5lZjU5Y2YzNDcyODUgMTAwNjQ0DQo+IC0tLSBhL2ZzL25zZnMu
Yw0KPiArKysgYi9mcy9uc2ZzLmMNCj4gQEAgLTI0NSw2ICsyNDUsMjAgQEAgc3RydWN0IGZpbGUg
KnByb2NfbnNfZmdldChpbnQgZmQpDQo+ICAgCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOw0KPiAg
IH0NCj4gICANCj4gKy8qKg0KPiArICogbnNfbWF0Y2goKSAtIFJldHVybnMgdHJ1ZSBpZiBjdXJy
ZW50IG5hbWVzcGFjZSBtYXRjaGVzIGRldi9pbm8gcHJvdmlkZWQuDQo+ICsgKiBAbnNfY29tbW9u
OiBjdXJyZW50IG5zDQo+ICsgKiBAZGV2OiBkZXZfdCBmcm9tIG5zZnMgdGhhdCB3aWxsIGJlIG1h
dGNoZWQgYWdhaW5zdCBjdXJyZW50IG5zZnMNCj4gKyAqIEBpbm86IGlub190IGZyb20gbnNmcyB0
aGF0IHdpbGwgYmUgbWF0Y2hlZCBhZ2FpbnN0IGN1cnJlbnQgbnNmcw0KPiArICoNCj4gKyAqIFJl
dHVybjogdHJ1ZSBpZiBkZXYgYW5kIGlubyBtYXRjaGVzIHRoZSBjdXJyZW50IG5zZnMuDQo+ICsg
Ki8NCj4gK2Jvb2wgbnNfbWF0Y2goY29uc3Qgc3RydWN0IG5zX2NvbW1vbiAqbnMsIGRldl90IGRl
diwgaW5vX3QgaW5vKQ0KPiArew0KPiArCXJldHVybiAobnMtPmludW0gPT0gaW5vKSAmJiAobnNm
c19tbnQtPm1udF9zYi0+c19kZXYgPT0gZGV2KTsNCj4gK30NCj4gKw0KPiArDQo+ICAgc3RhdGlj
IGludCBuc2ZzX3Nob3dfcGF0aChzdHJ1Y3Qgc2VxX2ZpbGUgKnNlcSwgc3RydWN0IGRlbnRyeSAq
ZGVudHJ5KQ0KPiAgIHsNCj4gICAJc3RydWN0IGlub2RlICppbm9kZSA9IGRfaW5vZGUoZGVudHJ5
KTsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcHJvY19ucy5oIGIvaW5jbHVkZS9saW51
eC9wcm9jX25zLmgNCj4gaW5kZXggZDMxY2I2MjE1OTA1Li4xZGE5ZjMzNDg5ZjMgMTAwNjQ0DQo+
IC0tLSBhL2luY2x1ZGUvbGludXgvcHJvY19ucy5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvcHJv
Y19ucy5oDQo+IEBAIC04Miw2ICs4Miw4IEBAIHR5cGVkZWYgc3RydWN0IG5zX2NvbW1vbiAqbnNf
Z2V0X3BhdGhfaGVscGVyX3Qodm9pZCAqKTsNCj4gICBleHRlcm4gdm9pZCAqbnNfZ2V0X3BhdGhf
Y2Ioc3RydWN0IHBhdGggKnBhdGgsIG5zX2dldF9wYXRoX2hlbHBlcl90IG5zX2dldF9jYiwNCj4g
ICAJCQkgICAgdm9pZCAqcHJpdmF0ZV9kYXRhKTsNCj4gICANCj4gK2V4dGVybiBib29sIG5zX21h
dGNoKGNvbnN0IHN0cnVjdCBuc19jb21tb24gKm5zLCBkZXZfdCBkZXYsIGlub190IGlubyk7DQo+
ICsNCj4gICBleHRlcm4gaW50IG5zX2dldF9uYW1lKGNoYXIgKmJ1Ziwgc2l6ZV90IHNpemUsIHN0
cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywNCj4gICAJCQljb25zdCBzdHJ1Y3QgcHJvY19uc19vcGVy
YXRpb25zICpuc19vcHMpOw0KPiAgIGV4dGVybiB2b2lkIG5zZnNfaW5pdCh2b2lkKTsNCj4gDQo=
