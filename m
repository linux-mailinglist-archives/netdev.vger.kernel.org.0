Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5FE1050
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 05:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389492AbfJWDC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 23:02:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24548 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731951AbfJWDC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 23:02:59 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9N2xBHn007574;
        Tue, 22 Oct 2019 20:02:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=my4lgxkdtCCKc3C4OimyrYVr7Lr9M32nW8izmkkZt8g=;
 b=ZDV7ePJco72ttTEbXtzGu6PtW+OR3uwULLF59YEbEPk+m0K/hSLMKLsb4NiMH6MnjHcF
 aW/5pLYvNeSr+qO5MkXDnUVoTVu7rrabaO2kQLXS+PnkHIgvrhKXsDQ9LYD1Hi6ui3SD
 9syc3FfMXVCC6ybInGdQjT5OTO/c2t02nYw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9tg92tb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 20:02:54 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 22 Oct 2019 20:02:53 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 20:02:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8XprhS0NRb1sIkMfr+pjhjwdblPkq8fEnvXQ6ZaW5Tkb/69xuyTKc0NMu5qUIc5+m7eNgqhBQtKAABt2rGeRnyR+8oqVQpDC4YyQXMkjFEe4cLgIciTdl/CYhWicKsYYieJ5zKFf7zjaivq6Qq7XI0FtpE8/pYA9kwQR2m2oGgxyd+XYAVqNvuVIFferljvn9oPS065VcjCdAJ7UWkNc5Z0mgCSwuZnX2kkhu61okmAnJzNFdWWQO7KhdyTGKdBEr6B/U2Rs5SWKu/fkGC5lgSblCnCeYqGO8CoIDujRUlWSpou/hz5xgQnX03x5eSt9GSfoceLSqHG+y1WJGaXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=my4lgxkdtCCKc3C4OimyrYVr7Lr9M32nW8izmkkZt8g=;
 b=f3RwM0xdBlJixuA9Mo1HmwTu8lGUEukdVmSHn88cRAu5+fkohBNALQaAn7Vo41ji38rljhPouCvxVbiEdIlPqH3rspzJCdTTKolVldJ+fMshDnGmixd1NJb4J27TGM2vcFR7bFI+b0fj4UHkCsZD4axPInTJBbmBYTbFloaXyI5BtZ0uiEY0RSkIcpk3a5dvJSu4w3oSWhIFvIZX0OEd9PHwdC6PkiJqWrjmWyhXbkJ6dkSUqw8hZS90wG4wsldp972w/JyGNz/bGTvsf7aBHVUhrS3ztrjxkhuLDs5olSlCLCDMGIRtde2NFrbuKZEmoqk/vV/vqtXKF4IY87Scug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=my4lgxkdtCCKc3C4OimyrYVr7Lr9M32nW8izmkkZt8g=;
 b=GfVslRYwmjC+Bj+JPMfCD5JP79olsxzqINFFNnW1H37U8LdthuCFLIRkteT/fkuwYVCeQcvQ7a9zjICfz4c3JCDI+APGx1W0ga4B91Vgyrh+5LGaHgzuGYBQcjwjafF6HwbBXVpKG3mUmNA3m6kocg+85t8POuZFqoBZAn28yk8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2456.namprd15.prod.outlook.com (52.135.193.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 23 Oct 2019 03:02:52 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 03:02:52 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Thread-Topic: [PATCH v15 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Thread-Index: AQHViU5brqJLWzKWNEuwFWWhXAwQ8A==
Date:   Wed, 23 Oct 2019 03:02:51 +0000
Message-ID: <e3138bca-14b1-6fcf-12be-992462abe0ce@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-5-cneirabustos@gmail.com>
In-Reply-To: <20191022191751.3780-5-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0064.namprd10.prod.outlook.com
 (2603:10b6:300:2c::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b6b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1e030a1-fb5e-4996-f5d8-08d757657e3c
x-ms-traffictypediagnostic: BYAPR15MB2456:
x-microsoft-antispam-prvs: <BYAPR15MB24565C89FFD9BC11DE7DAC48D36B0@BYAPR15MB2456.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:439;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(478600001)(14454004)(5660300002)(54906003)(31686004)(6246003)(316002)(6436002)(66946007)(6486002)(229853002)(31696002)(25786009)(64756008)(66556008)(4326008)(66476007)(6512007)(76176011)(36756003)(2501003)(99286004)(476003)(2906002)(8936002)(52116002)(486006)(6506007)(305945005)(5024004)(186003)(7736002)(14444005)(2616005)(6116002)(386003)(71200400001)(46003)(110136005)(86362001)(446003)(102836004)(66446008)(256004)(8676002)(11346002)(81166006)(81156014)(71190400001)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2456;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1JFPspcxq/BMbRlfA3A92jsjzIRwtmYQn6DkSxCCXUFo3fpvM21qT24pzoP9UUXknRIUVjV6ofABuxmHC+uJPZLQ0N4V4sWZ0loWBjgANB75oWfpFBRIhpWFgMHnS7yEWO3Cj2UN3iZGE3TJJoCIgzz71cARPrsbp6Lro+i0S6E1M6wWFtmzYxnY3/cp8lTadF2nnf14aSqqVpCei2Ou2C3FuGnnH2wwTrrxU9YH2NpR5NrUtTO0kGu2TkEHgRO7l0NoVe95o7+To61KKF47OTfhnX6HhNd2df+yGHDzswPEGgS5n4htYgIYCl2IZalphiikkJQrwG1okO3EY2hYwRLaLMxeXNibcUR0RQ08nc4YpRULOr9vG0o3OEc1+2w957Jxt+NbpZSefhwXozEq0xXDuQA/bwiOgaDSWgDJZ2zJ/SV8uqz/Y89JVToheSN
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5430302DBAC3264A8906DB02D2228EEF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e030a1-fb5e-4996-f5d8-08d757657e3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 03:02:51.9221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N2kAIpZ5PPfhy7AYaO1BUbrYWS4vI6rNV4tS3D9bCuuegLV7AZBhSA74bPP+Jehy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_01:2019-10-22,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910230029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIyLzE5IDEyOjE3IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+IFNlbGYgdGVz
dHMgYWRkZWQgZm9yIG5ldyBoZWxwZXINCg0KUGxlYXNlIG1lbnRpb24gdGhlIG5hbWUgb2YgdGhl
IG5ldyBoZWxwZXIgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDYXJsb3MgTmVpcmEgPGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20+DQoNCkxHVE0gQWNrIHdpdGgg
YSBmZXcgbml0cyBiZWxvdy4NCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
DQo+IC0tLQ0KPiAgIC4uLi9icGYvcHJvZ190ZXN0cy9uc19jdXJyZW50X3BpZF90Z2lkLmMgICAg
ICB8IDg3ICsrKysrKysrKysrKysrKysrKysNCj4gICAuLi4vYnBmL3Byb2dzL3Rlc3RfbnNfY3Vy
cmVudF9waWRfdGdpZC5jICAgICAgfCAzNyArKysrKysrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwg
MTI0IGluc2VydGlvbnMoKykNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvbnNfY3VycmVudF9waWRfdGdpZC5jDQo+ICAgY3JlYXRl
IG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X25zX2N1
cnJlbnRfcGlkX3RnaWQuYw0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9nX3Rlc3RzL25zX2N1cnJlbnRfcGlkX3RnaWQuYyBiL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL25zX2N1cnJlbnRfcGlkX3RnaWQuYw0KPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjI1N2YxODk5OWJiNg0KPiAtLS0g
L2Rldi9udWxsDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3Rz
L25zX2N1cnJlbnRfcGlkX3RnaWQuYw0KPiBAQCAtMCwwICsxLDg3IEBADQo+ICsvLyBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArLyogQ29weXJpZ2h0IChjKSAyMDE5IENhcmxv
cyBOZWlyYSBjbmVpcmFidXN0b3NAZ21haWwuY29tICovDQo+ICsjaW5jbHVkZSA8dGVzdF9wcm9n
cy5oPg0KPiArI2luY2x1ZGUgPHN5cy9zdGF0Lmg+DQo+ICsjaW5jbHVkZSA8c3lzL3R5cGVzLmg+
DQo+ICsjaW5jbHVkZSA8dW5pc3RkLmg+DQo+ICsjaW5jbHVkZSA8c3lzL3N5c2NhbGwuaD4NCj4g
Kw0KPiArc3RydWN0IGJzcyB7DQo+ICsJX191NjQgZGV2Ow0KPiArCV9fdTY0IGlubzsNCj4gKwlf
X3U2NCBwaWRfdGdpZDsNCj4gKwlfX3U2NCB1c2VyX3BpZF90Z2lkOw0KPiArfTsNCj4gKw0KPiAr
dm9pZCB0ZXN0X25zX2N1cnJlbnRfcGlkX3RnaWQodm9pZCkNCj4gK3sNCj4gKwljb25zdCBjaGFy
ICpwcm9iZV9uYW1lID0gInJhd190cmFjZXBvaW50L3N5c19lbnRlciI7DQo+ICsJY29uc3QgY2hh
ciAqZmlsZSA9ICJ0ZXN0X25zX2N1cnJlbnRfcGlkX3RnaWQubyI7DQo+ICsJaW50IGVyciwga2V5
ID0gMCwgZHVyYXRpb24gPSAwOw0KPiArCXN0cnVjdCBicGZfbGluayAqbGluayA9IE5VTEw7DQo+
ICsJc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nOw0KPiArCXN0cnVjdCBicGZfbWFwICpic3NfbWFw
Ow0KPiArCXN0cnVjdCBicGZfb2JqZWN0ICpvYmo7DQo+ICsJc3RydWN0IGJzcyBic3M7DQo+ICsJ
c3RydWN0IHN0YXQgc3Q7DQo+ICsJX191NjQgaWQ7DQo+ICsNCj4gKwlvYmogPSBicGZfb2JqZWN0
X19vcGVuX2ZpbGUoZmlsZSwgTlVMTCk7DQo+ICsJaWYgKENIRUNLKElTX0VSUihvYmopLCAib2Jq
X29wZW4iLCAiZXJyICVsZFxuIiwgUFRSX0VSUihvYmopKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+
ICsJZXJyID0gYnBmX29iamVjdF9fbG9hZChvYmopOw0KPiArCWlmIChDSEVDSyhlcnIsICJvYmpf
bG9hZCIsICJlcnIgJWQgZXJybm8gJWRcbiIsIGVyciwgZXJybm8pKQ0KPiArCQlnb3RvIGNsZWFu
dXA7DQo+ICsNCj4gKwlic3NfbWFwID0gYnBmX29iamVjdF9fZmluZF9tYXBfYnlfbmFtZShvYmos
ICJ0ZXN0X25zXy5ic3MiKTsNCj4gKwlpZiAoQ0hFQ0soIWJzc19tYXAsICJmaW5kX2Jzc19tYXAi
LCAiZmFpbGVkXG4iKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJcHJvZyA9IGJwZl9v
YmplY3RfX2ZpbmRfcHJvZ3JhbV9ieV90aXRsZShvYmosIHByb2JlX25hbWUpOw0KPiArCWlmIChD
SEVDSyghcHJvZywgImZpbmRfcHJvZyIsICJwcm9nICclcycgbm90IGZvdW5kXG4iLA0KPiArCQkg
IHByb2JlX25hbWUpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwltZW1zZXQoJmJzcywg
MCwgc2l6ZW9mKGJzcykpOw0KPiArCXBpZF90IHRpZCA9IHN5c2NhbGwoU1lTX2dldHRpZCk7DQo+
ICsJcGlkX3QgcGlkID0gZ2V0cGlkKCk7DQo+ICsNCj4gKwlpZCA9IChfX3U2NCkgdGlkIDw8IDMy
IHwgcGlkOw0KPiArCWJzcy51c2VyX3BpZF90Z2lkID0gaWQ7DQo+ICsNCj4gKwlpZiAoQ0hFQ0tf
RkFJTChzdGF0KCIvcHJvYy9zZWxmL25zL3BpZCIsICZzdCkpKSB7DQo+ICsJCXBlcnJvcigiRmFp
bGVkIHRvIHN0YXQgL3Byb2Mvc2VsZi9ucy9waWQiKTsNCj4gKwkJZ290byBjbGVhbnVwOw0KPiAr
CX0NCj4gKw0KPiArCWJzcy5kZXYgPSBzdC5zdF9kZXY7DQo+ICsJYnNzLmlubyA9IHN0LnN0X2lu
bzsNCj4gKw0KPiArCWVyciA9IGJwZl9tYXBfdXBkYXRlX2VsZW0oYnBmX21hcF9fZmQoYnNzX21h
cCksICZrZXksICZic3MsIDApOw0KPiArCWlmIChDSEVDSyhlcnIsICJzZXR0aW5nX2JzcyIsICJm
YWlsZWQgdG8gc2V0IGJzcyA6ICVkXG4iLCBlcnIpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsN
Cj4gKwlsaW5rID0gYnBmX3Byb2dyYW1fX2F0dGFjaF9yYXdfdHJhY2Vwb2ludChwcm9nLCAic3lz
X2VudGVyIik7DQo+ICsJaWYgKENIRUNLKElTX0VSUihsaW5rKSwgImF0dGFjaF9yYXdfdHAiLCAi
ZXJyICVsZFxuIiwNCj4gKwkJICBQVFJfRVJSKGxpbmspKSkNCj4gKwkJZ290byBjbGVhbnVwOw0K
DQpZb3UgYWxyZWFkeSBoYXZlIGRlZmF1bHQgbGluayA9IE5VTEwuDQpIZXJlLCBJIHRoaW5rIHlv
dSBjYW4gZG8NCgkJbGluayA9IE5VTEw7DQoJCWdvdG8gY2xlYW51cDsNCg0KPiArDQo+ICsJLyog
dHJpZ2dlciBzb21lIHN5c2NhbGxzICovDQo+ICsJdXNsZWVwKDEpOw0KPiArDQo+ICsJZXJyID0g
YnBmX21hcF9sb29rdXBfZWxlbShicGZfbWFwX19mZChic3NfbWFwKSwgJmtleSwgJmJzcyk7DQo+
ICsJaWYgKENIRUNLKGVyciwgInNldF9ic3MiLCAiZmFpbGVkIHRvIGdldCBic3MgOiAlZFxuIiwg
ZXJyKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJaWYgKENIRUNLKGlkICE9IGJzcy5w
aWRfdGdpZCwgIkNvbXBhcmUgdXNlciBwaWQvdGdpZCB2cy4gYnBmIHBpZC90Z2lkIiwNCj4gKwkJ
ICAiVXNlciBwaWQvdGdpZCAlbGx1IEVCUEYgcGlkL3RnaWQgJWxsdVxuIiwgaWQsIGJzcy5waWRf
dGdpZCkpDQoNCkVCUEYgLT4gQlBGPw0KDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gK2NsZWFudXA6
DQo+ICsNCg0KVGhlIGFib3ZlIGVtcHR5IGxpbmUgY2FuIGJlIHJlbW92ZWQuDQoNCj4gKwlpZiAo
IUlTX0VSUl9PUl9OVUxMKGxpbmspKSB7DQoNCldpdGggdGhlIGFib3ZlIHN1Z2dlc3RlZCBjaGFu
Z2UsIHlvdSBvbmx5IG5lZWQgdG8gY2hlY2sNCglpZiAoIWxpbmspDQoNCj4gKwkJYnBmX2xpbmtf
X2Rlc3Ryb3kobGluayk7DQo+ICsJCWxpbmsgPSBOVUxMOw0KPiArCX0NCj4gKwlicGZfb2JqZWN0
X19jbG9zZShvYmopOw0KPiArfQ0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL3Byb2dzL3Rlc3RfbnNfY3VycmVudF9waWRfdGdpZC5jIGIvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfbnNfY3VycmVudF9waWRfdGdpZC5jDQo+IG5ldyBmaWxl
IG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uY2RiNzdlYjFhNGZiDQo+IC0tLSAv
ZGV2L251bGwNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rf
bnNfY3VycmVudF9waWRfdGdpZC5jDQo+IEBAIC0wLDAgKzEsMzcgQEANCj4gKy8vIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsvKiBDb3B5cmlnaHQgKGMpIDIwMTkgQ2FybG9z
IE5laXJhIGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20gKi8NCj4gKw0KPiArI2luY2x1ZGUgPGxpbnV4
L2JwZi5oPg0KPiArI2luY2x1ZGUgPHN0ZGludC5oPg0KPiArI2luY2x1ZGUgImJwZl9oZWxwZXJz
LmgiDQo+ICsNCj4gK3N0YXRpYyB2b2xhdGlsZSBzdHJ1Y3Qgew0KPiArCV9fdTY0IGRldjsNCj4g
KwlfX3U2NCBpbm87DQo+ICsJX191NjQgcGlkX3RnaWQ7DQo+ICsJX191NjQgdXNlcl9waWRfdGdp
ZDsNCj4gK30gcmVzOw0KPiArDQo+ICtTRUMoInJhd190cmFjZXBvaW50L3N5c19lbnRlciIpDQo+
ICtpbnQgdHJhY2Uodm9pZCAqY3R4KQ0KPiArew0KPiArCV9fdTY0ICBuc19waWRfdGdpZCwgZXhw
ZWN0ZWRfcGlkOw0KPiArCXN0cnVjdCBicGZfcGlkbnNfaW5mbyBuc2RhdGE7DQo+ICsJX191MzIg
a2V5ID0gMDsNCj4gKw0KPiArCWlmIChicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQocmVzLmRl
diwgcmVzLmlubywgJm5zZGF0YSwNCj4gKwkJICAgc2l6ZW9mKHN0cnVjdCBicGZfcGlkbnNfaW5m
bykpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCW5zX3BpZF90Z2lkID0gKF9fdTY0KW5zZGF0
YS50Z2lkIDw8IDMyIHwgbnNkYXRhLnBpZDsNCj4gKwlleHBlY3RlZF9waWQgPSByZXMudXNlcl9w
aWRfdGdpZDsNCj4gKw0KPiArCWlmIChleHBlY3RlZF9waWQgIT0gbnNfcGlkX3RnaWQpDQo+ICsJ
CXJldHVybiAwOw0KPiArDQo+ICsJcmVzLnBpZF90Z2lkID0gbnNfcGlkX3RnaWQ7DQo+ICsNCj4g
KwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArY2hhciBfbGljZW5zZVtdIFNFQygibGljZW5zZSIp
ID0gIkdQTCI7DQoNClRoZSBuZXcgaGVscGVyIGRvZXMgbm90IHJlcXVpcmUgR1BMLCBjb3VsZCB5
b3UgZG91YmxlIGNoZWNrIHRoaXM/DQpUaGUgYWJvdmUgX2xpY2Vuc2Ugc2hvdWxkIG5vdCBiZSBu
ZWNlc3NhcnkuDQo=
