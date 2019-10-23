Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E464E1034
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbfJWCwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:52:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732555AbfJWCwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:52:07 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9N2oE2h010700;
        Tue, 22 Oct 2019 19:52:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NKpVbxEldn4bPQfTOZorYGeUchdKs4/u1Yi1O4H+Ylc=;
 b=mpq78/nTRWak2ALM00zBVrG0YthinPro6JXV7LQyjfD7k0t3INZT7GPg04lmgNmWz8cQ
 oT7PSfBNVnm4JXGXfWFAeZIafRfNk9aU1eeb7wputeSd1gGdbX/KEwjzriTfItMk/aeS
 ENXVenETMx1LlQLuU1/UO+lcF0xu/Tsu5IY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9tt11my-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Oct 2019 19:52:04 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Oct 2019 19:52:00 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 19:52:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kwa3pu5Uw6puSwLD0eivjjz0svJuf1mbZQKCCKW5fTMqdDlzsi+q0ERR3mR/JpJzWns3H1CltAnqod9dLzIeG82LHThXfDgrJUnbv/IkazzB/7u3PCjEoBGiXzgQzs81pfKi4IZycytVSP5+J0qlcedEfhK/Z62g2Jm4VtqxhDoXGzIeM9G8T+1yWHw+jx1aGaWHqhW1MOAG8VCRzvkZGKisTpf/6trU3jBsafo9lGTDuqu6wLaEp/AFxAOnb3oRzjrfJCcZU3Z2PLOq8j0TgZ4lSfc7uEYMdM6BJJDfcSj+Ul0yJY1WTYwRAi65XsKHX0YAEj39JocY1ZBjwlk4eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKpVbxEldn4bPQfTOZorYGeUchdKs4/u1Yi1O4H+Ylc=;
 b=gLtg4iipO1dfuqWm5XH2yhmBTdiwP3sHxiHEfvfFHAfu27BljL3Da6ueAIz0EcwiNFXamF0ag7+C0trafjfH+4zlw1t1gtlIISdUwbwj094NfzqInjRn3dD55RnIVLxiqxSBl0aS21A9S0zrRLlROuIYCieS2Jf9B7TLYHqb38xgDDUTix0lkjwcgBGh2rRldTZD2ydSTqvNYFJeo5LzMGoRGD0nDADhMFs7Cd1YOq2cEOTUi7HuV6U1ZqLd/CU6j+k3LBbDQsyWV4GwnwwPK+H2F3KJJSNm1Z1oI2KwEP6dAagUtOIp1kla8etmjNyyFUtPyi3ZpmCjubFOlzU37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKpVbxEldn4bPQfTOZorYGeUchdKs4/u1Yi1O4H+Ylc=;
 b=hM1D5HrkRPawaVEx8iT9zY5tUdrJyjHu7dzlUiTEPlFYa6/fpPk+RVIn7xIN8vTChpvAdGyHGJl8orByMowqfrCuBIsaYyl4gwN+KcsAFZLR+ZkM6+R/JkJspo+GF2Wog8wmCjb+kaKPhtl32xixkyGedjqwppjv7bhOLsa+RVQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2213.namprd15.prod.outlook.com (52.135.194.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 23 Oct 2019 02:51:59 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 02:51:59 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Thread-Topic: [PATCH v15 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Thread-Index: AQHViQ11yW2Sb+WaGky2o9l+Y+3nq6dnh4wA
Date:   Wed, 23 Oct 2019 02:51:58 +0000
Message-ID: <795afbde-6ecf-4ecc-528d-c549e701b05e@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-4-cneirabustos@gmail.com>
In-Reply-To: <20191022191751.3780-4-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:300:13d::17) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b6b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aa246f2-8c32-4a01-81c3-08d75763f8f4
x-ms-traffictypediagnostic: BYAPR15MB2213:
x-microsoft-antispam-prvs: <BYAPR15MB2213968DF249FE75D2389A45D36B0@BYAPR15MB2213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(25786009)(31686004)(4326008)(8936002)(6246003)(8676002)(81166006)(81156014)(256004)(305945005)(7736002)(14444005)(2501003)(316002)(46003)(66446008)(64756008)(66946007)(66476007)(66556008)(86362001)(6512007)(102836004)(229853002)(446003)(11346002)(2616005)(6436002)(486006)(6486002)(476003)(99286004)(5660300002)(6116002)(52116002)(386003)(53546011)(6506007)(36756003)(76176011)(2906002)(186003)(54906003)(110136005)(478600001)(14454004)(31696002)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2213;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ibN/xN+HLKOquxHiGAVRWQ++/wwHnTSKgAGW2OtrEG0l0ovFyd1g7uMO+ajeYbYHcCooFRUy3HJW3ExlnzyWNBJ8Ppy7EtKDt7lbu0aOj7ITETh4PXj4Y3aOcLnzu22vUBN68sW58QJ7GMMuoehYFdZ/oSDeFV9MlgbpeTpY09zx26j1uE+ekuOQytU3GzE9rLLcgNcIAXISUeySll/Fx1ctri9N8qfgzT6rRpiMhBiEKw7CgvryfWwz9saIn+wMUPWEkRKI0il3ktfjIBI/ynWfACZD+uBBn4TrpxOMYmYp5FZrxHTYprPOgtSoz60CCaPQRNHT2G9cTJzOW48YxoHniBPOaBVeEuqMMjNeJbj7gVibofW+GVgPDI/Bx39Rn+LFDFYaLTYY/g+ViEl25reVJligwQ9Df0dCyWRq8fj8e+1q/xwwzdch0dNvmHo
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8A3CBAD347BD64791DB3411D0928CD0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa246f2-8c32-4a01-81c3-08d75763f8f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 02:51:58.9015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQgL6W/f1I2RS9oJsvb5XtRWqDxfmRGgdpEbsVk3fGkKJ9JyRqfJ6P1kc1ppQ+pZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_01:2019-10-22,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIyLzE5IDEyOjE3IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+IHN5bmMgdG9v
bHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHRvIGluY2x1ZGUgbmV3IGhlbHBlci4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IENhcmxvcyBOZWlyYSA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4NCg0K
QWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+ICAgdG9vbHMv
aW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwgMjAgKysrKysrKysrKysrKysrKysrKy0NCj4gICAx
IGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCBiL3Rvb2xzL2luY2x1ZGUv
dWFwaS9saW51eC9icGYuaA0KPiBpbmRleCA0YWY4YjA4MTlhMzIuLjRjM2UwYjA5NTJlNiAxMDA2
NDQNCj4gLS0tIGEvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ICsrKyBiL3Rvb2xz
L2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiBAQCAtMjc3NSw2ICsyNzc1LDE5IEBAIHVuaW9u
IGJwZl9hdHRyIHsNCj4gICAgKiAJCXJlc3RyaWN0ZWQgdG8gcmF3X3RyYWNlcG9pbnQgYnBmIHBy
b2dyYW1zLg0KPiAgICAqIAlSZXR1cm4NCj4gICAgKiAJCTAgb24gc3VjY2Vzcywgb3IgYSBuZWdh
dGl2ZSBlcnJvciBpbiBjYXNlIG9mIGZhaWx1cmUuDQo+ICsgKg0KPiArICogaW50IGJwZl9nZXRf
bnNfY3VycmVudF9waWRfdGdpZCh1NjQgZGV2LCB1NjQgaW5vLCBzdHJ1Y3QgYnBmX3BpZG5zX2lu
Zm8gKm5zZGF0YSwgdTMyIHNpemUpDQo+ICsgKglEZXNjcmlwdGlvbg0KPiArICoJCVJldHVybnMg
MCBvbiBzdWNjZXNzLCB2YWx1ZXMgZm9yICpwaWQqIGFuZCAqdGdpZCogYXMgc2VlbiBmcm9tIHRo
ZSBjdXJyZW50DQo+ICsgKgkJKm5hbWVzcGFjZSogd2lsbCBiZSByZXR1cm5lZCBpbiAqbnNkYXRh
Ki4NCj4gKyAqDQo+ICsgKgkJT24gZmFpbHVyZSwgdGhlIHJldHVybmVkIHZhbHVlIGlzIG9uZSBv
ZiB0aGUgZm9sbG93aW5nOg0KPiArICoNCj4gKyAqCQkqKi1FSU5WQUwqKiBpZiBkZXYgYW5kIGlu
dW0gc3VwcGxpZWQgZG9uJ3QgbWF0Y2ggZGV2X3QgYW5kIGlub2RlIG51bWJlcg0KPiArICogICAg
ICAgICAgICAgIHdpdGggbnNmcyBvZiBjdXJyZW50IHRhc2ssIG9yIGlmIGRldiBjb252ZXJzaW9u
IHRvIGRldl90IGxvc3QgaGlnaCBiaXRzLg0KPiArICoNCj4gKyAqCQkqKi1FTk9FTlQqKiBpZiBw
aWRucyBkb2VzIG5vdCBleGlzdHMgZm9yIHRoZSBjdXJyZW50IHRhc2suDQo+ICsgKg0KPiAgICAq
Lw0KPiAgICNkZWZpbmUgX19CUEZfRlVOQ19NQVBQRVIoRk4pCQlcDQo+ICAgCUZOKHVuc3BlYyks
CQkJXA0KPiBAQCAtMjg4OCw3ICsyOTAxLDggQEAgdW5pb24gYnBmX2F0dHIgew0KPiAgIAlGTihz
a19zdG9yYWdlX2RlbGV0ZSksCQlcDQo+ICAgCUZOKHNlbmRfc2lnbmFsKSwJCVwNCj4gICAJRk4o
dGNwX2dlbl9zeW5jb29raWUpLAkJXA0KPiAtCUZOKHNrYl9vdXRwdXQpLA0KPiArCUZOKHNrYl9v
dXRwdXQpLAkJCVwNCj4gKwlGTihnZXRfbnNfY3VycmVudF9waWRfdGdpZCksDQo+ICAgDQo+ICAg
LyogaW50ZWdlciB2YWx1ZSBpbiAnaW1tJyBmaWVsZCBvZiBCUEZfQ0FMTCBpbnN0cnVjdGlvbiBz
ZWxlY3RzIHdoaWNoIGhlbHBlcg0KPiAgICAqIGZ1bmN0aW9uIGVCUEYgcHJvZ3JhbSBpbnRlbmRz
IHRvIGNhbGwNCj4gQEAgLTM2MzksNCArMzY1Myw4IEBAIHN0cnVjdCBicGZfc29ja29wdCB7DQo+
ICAgCV9fczMyCXJldHZhbDsNCj4gICB9Ow0KPiAgIA0KPiArc3RydWN0IGJwZl9waWRuc19pbmZv
IHsNCj4gKwlfX3UzMiBwaWQ7DQo+ICsJX191MzIgdGdpZDsNCj4gK307DQo+ICAgI2VuZGlmIC8q
IF9VQVBJX19MSU5VWF9CUEZfSF9fICovDQo+IA0K
