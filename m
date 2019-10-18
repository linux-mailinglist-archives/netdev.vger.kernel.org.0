Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18FDCC56
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634452AbfJRRKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:10:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62054 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388005AbfJRRKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:10:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IH6d4U023820;
        Fri, 18 Oct 2019 10:10:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OJTRVL0CPxFi2HwKGZlm1rpehMGBH72zZoxMC2eloE0=;
 b=gVjr5mSW4JBv8OXbarrLvK/UHx60yVWUlB18uLNz/rnD3/sO5qIDG82ERgE/yaM1E2ce
 FjeDPghXQRLvBopIgiAZMIw+Nuk01wnfE1I4AndxvMgP8Sl1PImo1jedmbqljVFx6GN5
 mcTjSinHt/RdAyYjCzjyduLlnaAhC+n34Og= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqhgjr0m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 10:10:43 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:10:42 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:10:42 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 10:10:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyRB9opGl0r8BBAUBsRl8QDqcJb3P2nGFzWeu2k0tRPhsSW8+EdlguWFjywyIYd32FCI+schNE9uQceB6upqvwwq4H3VEibHHMd9AJ9ubT7abKAfTh0L72+HE1WtiLQ+TooMrTe5Goe9v66XRBry3IBjf9WhADebutdjWtLTvHwIOhlnXrbvT/cHRJFDyLTnFfW7PcpOPJhf6G7hOyZWRCX2OWy+zqvNvccIjRd3ZVG9NeT4dAoPCthpJF2eJIG9LMTzYXYX/DuyNaMYr+1G/34FcSslf5z0FNGmP2hu+NFg7D0G263/Pu1w6DMDk38IaB/TVErnDe5bJoyRHncP0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJTRVL0CPxFi2HwKGZlm1rpehMGBH72zZoxMC2eloE0=;
 b=Qn8C8QzbMyU5mm01mGkXU7O7746Su0fO9aK7tv8FdxjwFh/NIr54xee+Q1MVWdrYnlWluYJzz5AJfqjeiKhAE1JCWnb8HDxSu9dn33gVuAh5MlqGDJScS8RvAKvj1Eh2gLQ69SknWEr2QwQoBaHP02Jlv2yuSWBc6b65SZegopgTOhql0okicM6WfjGuXbbNHKpCWZNhSsA/BHXOzYnFsGQKWqhmeX3oFEpW1QOKyDPXT2YGbeGv9HrYnU0XCr/ftsv/aInPHQ9datUTE8+XvjiJEW9anb3m00ME+bLTo/dtSC1dIP9+wXqlflA5LhztEcEMKOx+QM669cAEMTDN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJTRVL0CPxFi2HwKGZlm1rpehMGBH72zZoxMC2eloE0=;
 b=hgb8mTuLX+QrdU0Y75R+otw3XRNWE/GIVxWfo/wfN9dZUJXXqrkkJ6AQNWpF3l+X5sCGueZi/isIpUuouwEtSitchj3yJzMbQHecKf3OSyV8ClVOzaR75piFhSGS0Ky3fb6mu4DDw0HbZqIcrW7mifAWtxQOIOwCA2ZmXXYRUoY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3093.namprd15.prod.outlook.com (20.178.238.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 17:10:41 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 17:10:41 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v14 2/5] bpf: added new helper bpf_get_ns_current_pid_tgid
Thread-Topic: [PATCH v14 2/5] bpf: added new helper
 bpf_get_ns_current_pid_tgid
Thread-Index: AQHVhPuw35ZPzyzMrU6M+wkTrci3e6dgo/UA
Date:   Fri, 18 Oct 2019 17:10:40 +0000
Message-ID: <f4697e1e-6a1f-f29e-240c-ac4aa92ecc94@fb.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-3-cneirabustos@gmail.com>
In-Reply-To: <20191017150032.14359-3-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:301:1::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc408ab0-7422-4b18-3874-08d753ee1a69
x-ms-traffictypediagnostic: BYAPR15MB3093:
x-microsoft-antispam-prvs: <BYAPR15MB3093AD405E88033643D95D85D36C0@BYAPR15MB3093.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(66556008)(66476007)(6512007)(66446008)(66946007)(64756008)(6246003)(4326008)(31696002)(86362001)(2906002)(2501003)(6486002)(6436002)(6116002)(305945005)(7736002)(229853002)(102836004)(53546011)(6506007)(386003)(256004)(14444005)(36756003)(186003)(478600001)(54906003)(52116002)(14454004)(76176011)(99286004)(71190400001)(316002)(110136005)(71200400001)(46003)(11346002)(31686004)(486006)(476003)(446003)(2616005)(8936002)(81166006)(81156014)(25786009)(5660300002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3093;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aSrL3VuCU7CMVcc5BgoylECPyxst6tI2xxiAjewDbyj2fIvpc0ZnDN9RiBhnWmxwCDbnzImOpw5zbuuKBQPlqTpaGPuteZfIt3M1edn9oVo4e/zNnWJSFUd1j7AjRjZwOy0CWpzDXjs0qXLuAy2TWY7nY5A2OE0lNbCP3kR/cQn/E5MBSW5eLbfbbWRhn6PHTlnzdHinraNuEy5MBK4XlI/kSRvPDdVfVtJ8ELv9DqB0Lf/OjnAKwI7ynYcN/snwsA1akjgPqE4l+MiiGn7XVon6jWsWOuLrcTx/IHCww8DDp30k4qe8oCeCvMSsKydYCicyuF2di9K0Ltm/ZqYbUUM0hGotWl51fd5ZebOB/ryzUKoftsTgS5JusHJIsu1d1K5v9GWU/l9O4TDUtDSzSqZa8rqtBxSQOfiuKD4rcqmp0O1syNr+Wji5C/mSMtmp
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2705E5780197A84296E25373DE30497B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc408ab0-7422-4b18-3874-08d753ee1a69
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 17:10:40.8828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afkMSB8ZeIiI+gi07uYbr3sz1mU6jyV+kKu9cfeE0Kl7GhEaLdFN3+JjRYesTz2o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3093
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDg6MDAgQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gTmV3IGJwZiBo
ZWxwZXIgYnBmX2dldF9uc19jdXJyZW50X3BpZF90Z2lkLA0KPiBUaGlzIGhlbHBlciB3aWxsIHJl
dHVybiBwaWQgYW5kIHRnaWQgZnJvbSBjdXJyZW50IHRhc2sNCj4gd2hpY2ggbmFtZXNwYWNlIG1h
dGNoZXMgZGV2X3QgYW5kIGlub2RlIG51bWJlciBwcm92aWRlZCwNCj4gdGhpcyB3aWxsIGFsbG93
cyB1cyB0byBpbnN0cnVtZW50IGEgcHJvY2VzcyBpbnNpZGUgYSBjb250YWluZXIuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDYXJsb3MgTmVpcmEgPGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20+DQoNCllv
dSBuZWVkIHRvIHJlYmFzZSB0aGUgd2hvbGUgc2VyaWVzLCBhIG5ldyBoZWxwZXIgc2tiX291dHB1
dA0KaXMganVzdCBhZGRlZC4NCg0KDQoNCj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9icGYuaCAg
ICAgIHwgIDEgKw0KPiAgIGluY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDIwICsrKysrKysrKysr
KysrKysrLQ0KPiAgIGtlcm5lbC9icGYvY29yZS5jICAgICAgICB8ICAxICsNCj4gICBrZXJuZWwv
YnBmL2hlbHBlcnMuYyAgICAgfCA0NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICAga2VybmVsL3RyYWNlL2JwZl90cmFjZS5jIHwgIDIgKysNCj4gICA1IGZpbGVz
IGNoYW5nZWQsIDY4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS9saW51eC9icGYuaA0KPiBpbmRleCA1
YjlkMjIzMzg2MDYuLjIzMTAwMTQ3NTUwNCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9i
cGYuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+IEBAIC0xMDU1LDYgKzEwNTUsNyBA
QCBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfbG9jYWxfc3RvcmFn
ZV9wcm90bzsNCj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9zdHJ0
b2xfcHJvdG87DQo+ICAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfc3Ry
dG91bF9wcm90bzsNCj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl90
Y3Bfc29ja19wcm90bzsNCj4gK2V4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBm
X2dldF9uc19jdXJyZW50X3BpZF90Z2lkX3Byb3RvOw0KPiAgIA0KPiAgIC8qIFNoYXJlZCBoZWxw
ZXJzIGFtb25nIGNCUEYgYW5kIGVCUEYuICovDQo+ICAgdm9pZCBicGZfdXNlcl9ybmRfaW5pdF9v
bmNlKHZvaWQpOw0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5j
bHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IGluZGV4IGE2NWMzYjBjNjkzNS4uYTE3NTgzYWU5YWEz
IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gKysrIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0yNzUwLDYgKzI3NTAsMTkgQEAgdW5pb24gYnBmX2F0
dHIgew0KPiAgICAqCQkqKi1FT1BOT1RTVVBQKioga2VybmVsIGNvbmZpZ3VyYXRpb24gZG9lcyBu
b3QgZW5hYmxlIFNZTiBjb29raWVzDQo+ICAgICoNCj4gICAgKgkJKiotRVBST1RPTk9TVVBQT1JU
KiogSVAgcGFja2V0IHZlcnNpb24gaXMgbm90IDQgb3IgNg0KPiArICoNCj4gKyAqIHU2NCBicGZf
Z2V0X25zX2N1cnJlbnRfcGlkX3RnaWQodTY0IGRldiwgdTY0IGlubywgc3RydWN0IGJwZl9waWRu
c19pbmZvICpuc2RhdGEsIHUzMiBzaXplKQ0KDQotRUlOVkFMLy1FTk9FTlQgbWF5IGJlIHJldHVy
bmVkLCBzbyBsZXQgdXMgaGF2ZSByZXR1cm4gdHlwZSAiaW50IiBpbnN0ZWFkLg0KDQo+ICsgKglE
ZXNjcmlwdGlvbg0KPiArICoJCVJldHVybnMgMCBvbiBzdWNjZXNzLCB2YWx1ZXMgZm9yICpwaWQq
IGFuZCAqdGdpZCogYXMgc2VlbiBmcm9tIHRoZSBjdXJyZW50DQo+ICsgKgkJKm5hbWVzcGFjZSog
d2lsbCBiZSByZXR1cm5lZCBpbiAqbnNkYXRhKi4NCj4gKyAqDQo+ICsgKgkJT24gZmFpbHVyZSwg
dGhlIHJldHVybmVkIHZhbHVlIGlzIG9uZSBvZiB0aGUgZm9sbG93aW5nOg0KPiArICoNCj4gKyAq
CQkqKi1FSU5WQUwqKiBpZiBkZXYgYW5kIGludW0gc3VwcGxpZWQgZG9uJ3QgbWF0Y2ggZGV2X3Qg
YW5kIGlub2RlIG51bWJlcg0KPiArICogICAgICAgICAgICAgIHdpdGggbnNmcyBvZiBjdXJyZW50
IHRhc2ssIG9yIGlmIGRldiBjb252ZXJzaW9uIHRvIGRldl90IGxvc3QgaGlnaCBiaXRzLg0KPiAr
ICoNCj4gKyAqCQkqKi1FTk9FTlQqKiBpZiAvcHJvYy9zZWxmL25zIGRvZXMgbm90IGV4aXN0cy4N
Cg0KTGV0IHVzIGRvIG5vdCBoYXJkIGNvZGUgdGhlIC9wcm9jL3NlbGYvbnMgcGF0aC4gSnVzdCBt
ZW50aW9uIHRoYXQgdGhlIA0KcGlkbnMgZG9lcyBub3QgZXhpc3QgZm9yIHRoZSBjdXJyZW50IHRh
c2suDQoNCj4gKyAqDQo+ICAgICovDQo+ICAgI2RlZmluZSBfX0JQRl9GVU5DX01BUFBFUihGTikJ
CVwNCj4gICAJRk4odW5zcGVjKSwJCQlcDQo+IEBAIC0yODYyLDcgKzI4NzUsOCBAQCB1bmlvbiBi
cGZfYXR0ciB7DQo+ICAgCUZOKHNrX3N0b3JhZ2VfZ2V0KSwJCVwNCj4gICAJRk4oc2tfc3RvcmFn
ZV9kZWxldGUpLAkJXA0KPiAgIAlGTihzZW5kX3NpZ25hbCksCQlcDQo+IC0JRk4odGNwX2dlbl9z
eW5jb29raWUpLA0KPiArCUZOKHRjcF9nZW5fc3luY29va2llKSwgICAgICAgICAgXA0KPiArCUZO
KGdldF9uc19jdXJyZW50X3BpZF90Z2lkKSwNCj4gICANCj4gICAvKiBpbnRlZ2VyIHZhbHVlIGlu
ICdpbW0nIGZpZWxkIG9mIEJQRl9DQUxMIGluc3RydWN0aW9uIHNlbGVjdHMgd2hpY2ggaGVscGVy
DQo+ICAgICogZnVuY3Rpb24gZUJQRiBwcm9ncmFtIGludGVuZHMgdG8gY2FsbA0KPiBAQCAtMzYx
Myw0ICszNjI3LDggQEAgc3RydWN0IGJwZl9zb2Nrb3B0IHsNCj4gICAJX19zMzIJcmV0dmFsOw0K
PiAgIH07DQo+ICAgDQo+ICtzdHJ1Y3QgYnBmX3BpZG5zX2luZm8gew0KPiArCV9fdTMyIHBpZDsN
Cj4gKwlfX3UzMiB0Z2lkOw0KPiArfTsNCj4gICAjZW5kaWYgLyogX1VBUElfX0xJTlVYX0JQRl9I
X18gKi8NCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvY29yZS5jIGIva2VybmVsL2JwZi9jb3Jl
LmMNCj4gaW5kZXggNjYwODhhOWU5YjllLi5iMmZkNTM1OGY0NzIgMTAwNjQ0DQo+IC0tLSBhL2tl
cm5lbC9icGYvY29yZS5jDQo+ICsrKyBiL2tlcm5lbC9icGYvY29yZS5jDQo+IEBAIC0yMDQyLDYg
KzIwNDIsNyBAQCBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2dldF9jdXJyZW50X3Vp
ZF9naWRfcHJvdG8gX193ZWFrOw0KPiAgIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZf
Z2V0X2N1cnJlbnRfY29tbV9wcm90byBfX3dlYWs7DQo+ICAgY29uc3Qgc3RydWN0IGJwZl9mdW5j
X3Byb3RvIGJwZl9nZXRfY3VycmVudF9jZ3JvdXBfaWRfcHJvdG8gX193ZWFrOw0KPiAgIGNvbnN0
IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfZ2V0X2xvY2FsX3N0b3JhZ2VfcHJvdG8gX193ZWFr
Ow0KPiArY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfbnNfY3VycmVudF9waWRf
dGdpZF9wcm90byBfX3dlYWs7DQo+ICAgDQo+ICAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3Rv
ICogX193ZWFrIGJwZl9nZXRfdHJhY2VfcHJpbnRrX3Byb3RvKHZvaWQpDQo+ICAgew0KPiBkaWZm
IC0tZ2l0IGEva2VybmVsL2JwZi9oZWxwZXJzLmMgYi9rZXJuZWwvYnBmL2hlbHBlcnMuYw0KPiBp
bmRleCA1ZTI4NzE4OTI4Y2EuLjU0NzdhZDk4NGQ3YyAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2Jw
Zi9oZWxwZXJzLmMNCj4gKysrIGIva2VybmVsL2JwZi9oZWxwZXJzLmMNCj4gQEAgLTExLDYgKzEx
LDggQEANCj4gICAjaW5jbHVkZSA8bGludXgvdWlkZ2lkLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4
L2ZpbHRlci5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9jdHlwZS5oPg0KPiArI2luY2x1ZGUgPGxp
bnV4L3BpZF9uYW1lc3BhY2UuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9wcm9jX25zLmg+DQo+ICAg
DQo+ICAgI2luY2x1ZGUgIi4uLy4uL2xpYi9rc3RydG94LmgiDQo+ICAgDQo+IEBAIC00ODcsMyAr
NDg5LDQ2IEBAIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfc3RydG91bF9wcm90byA9
IHsNCj4gICAJLmFyZzRfdHlwZQk9IEFSR19QVFJfVE9fTE9ORywNCj4gICB9Ow0KPiAgICNlbmRp
Zg0KPiArDQo+ICtCUEZfQ0FMTF80KGJwZl9nZXRfbnNfY3VycmVudF9waWRfdGdpZCwgdTY0LCBk
ZXYsIHU2NCwgaW5vLA0KPiArCSAgIHN0cnVjdCBicGZfcGlkbnNfaW5mbyAqLCBuc2RhdGEsIHUz
Miwgc2l6ZSkNCj4gK3sNCj4gKwlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2sgPSBjdXJyZW50Ow0K
PiArCXN0cnVjdCBwaWRfbmFtZXNwYWNlICpwaWRuczsNCj4gKwlpbnQgZXJyID0gLUVJTlZBTDsN
Cj4gKw0KPiArCWlmICh1bmxpa2VseShzaXplICE9IHNpemVvZihzdHJ1Y3QgYnBmX3BpZG5zX2lu
Zm8pKSkNCj4gKwkJZ290byBjbGVhcjsNCj4gKw0KPiArCWlmICh1bmxpa2VseSgodTY0KShkZXZf
dClkZXYgIT0gZGV2KSkNCj4gKwkJZ290byBjbGVhcjsNCj4gKw0KPiArCWlmICh1bmxpa2VseSgh
dGFzaykpDQo+ICsJCWdvdG8gY2xlYXI7DQo+ICsNCj4gKwlwaWRucyA9IHRhc2tfYWN0aXZlX3Bp
ZF9ucyh0YXNrKTsNCj4gKwlpZiAodW5saWtlbHkoIXBpZG5zKSkgew0KPiArCQllcnIgPSAtRU5P
RU5UOw0KPiArCQlnb3RvIGNsZWFyOw0KPiArCX0NCj4gKw0KPiArCWlmICghbnNfbWF0Y2goJnBp
ZG5zLT5ucywgKGRldl90KWRldiwgaW5vKSkNCj4gKwkJZ290byBjbGVhcjsNCj4gKw0KPiArCW5z
ZGF0YS0+cGlkID0gdGFza19waWRfbnJfbnModGFzaywgcGlkbnMpOw0KPiArCW5zZGF0YS0+dGdp
ZCA9IHRhc2tfdGdpZF9ucl9ucyh0YXNrLCBwaWRucyk7DQo+ICsJcmV0dXJuIDA7DQo+ICtjbGVh
cjoNCj4gKwltZW1zZXQoKHZvaWQgKiluc2RhdGEsIDAsIChzaXplX3QpIHNpemUpOw0KPiArCXJl
dHVybiBlcnI7DQo+ICt9DQo+ICsNCj4gK2NvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZf
Z2V0X25zX2N1cnJlbnRfcGlkX3RnaWRfcHJvdG8gPSB7DQo+ICsJLmZ1bmMJCT0gYnBmX2dldF9u
c19jdXJyZW50X3BpZF90Z2lkLA0KPiArCS5ncGxfb25seQk9IGZhbHNlLA0KPiArCS5yZXRfdHlw
ZQk9IFJFVF9JTlRFR0VSLA0KPiArCS5hcmcxX3R5cGUJPSBBUkdfQU5ZVEhJTkcsDQo+ICsJLmFy
ZzJfdHlwZQk9IEFSR19BTllUSElORywNCj4gKwkuYXJnM190eXBlICAgICAgPSBBUkdfUFRSX1RP
X1VOSU5JVF9NRU0sDQo+ICsJLmFyZzRfdHlwZSAgICAgID0gQVJHX0NPTlNUX1NJWkUsDQo+ICt9
Ow0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jIGIva2VybmVsL3RyYWNl
L2JwZl90cmFjZS5jDQo+IGluZGV4IDQ0YmQwOGYyNDQzYi4uMzIzMzFhMWRjYjZkIDEwMDY0NA0K
PiAtLS0gYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gKysrIGIva2VybmVsL3RyYWNlL2Jw
Zl90cmFjZS5jDQo+IEBAIC03MzUsNiArNzM1LDggQEAgdHJhY2luZ19mdW5jX3Byb3RvKGVudW0g
YnBmX2Z1bmNfaWQgZnVuY19pZCwgY29uc3Qgc3RydWN0IGJwZl9wcm9nICpwcm9nKQ0KPiAgICNl
bmRpZg0KPiAgIAljYXNlIEJQRl9GVU5DX3NlbmRfc2lnbmFsOg0KPiAgIAkJcmV0dXJuICZicGZf
c2VuZF9zaWduYWxfcHJvdG87DQo+ICsJY2FzZSBCUEZfRlVOQ19nZXRfbnNfY3VycmVudF9waWRf
dGdpZDoNCj4gKwkJcmV0dXJuICZicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWRfcHJvdG87DQo+
ICAgCWRlZmF1bHQ6DQo+ICAgCQlyZXR1cm4gTlVMTDsNCj4gICAJfQ0KPiANCg==
