Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421795C1BD
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfGARJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:09:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36838 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbfGARJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:09:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61Gm1Gb025957;
        Mon, 1 Jul 2019 10:09:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UESjToWq9b18LUuofpvFDWP3e4c8A23ExxrjeFHrdYg=;
 b=GuMudfpU0YFPUQPuRfJ45Jtpade/DaEY+7tJWdx1CKrp3lpjS2Mll4PZKYJWMAI6Qghe
 FnF/xQ7EdslRDcMh+lufT2LhygD/60Doj+Ec7ajH5GoVVJPwWOzUjzmRm9+3i/2B6DZz
 rKR9iyWr51vppIFWmE8Vi3TLM/jKnVHtzYY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfkpsrpqe-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:09:28 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:09:26 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:09:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UESjToWq9b18LUuofpvFDWP3e4c8A23ExxrjeFHrdYg=;
 b=YWJmk9fo1urzCl2xDkWSo/+wqVpAC63HPl7FyjwQWHg3XFXtRLgsBfHNzzmrk57+W2sPYcYIDose3L+hWeo3K+vKSWXIxllaFMfG3Wq3cPdsr9bsI5tNpiZa+lxsWUtTkXu6V+ekXBKJFDlxUHNWzLE0iQsPRuoab2XnCyuUqKo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2453.namprd15.prod.outlook.com (52.135.198.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 17:09:23 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:09:23 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
Thread-Topic: [PATCH v4 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
Thread-Index: AQHVLi2oHpfMFWNFX0yVKZ3kaOR2LKa2AxWA
Date:   Mon, 1 Jul 2019 17:09:23 +0000
Message-ID: <fbc744f2-74c9-7fca-b9bc-76353b1cf7b5@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-5-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:104:6::22) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 982af8b6-6c33-41a4-ba30-08d6fe46dcfd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2453;
x-ms-traffictypediagnostic: BYAPR15MB2453:
x-microsoft-antispam-prvs: <BYAPR15MB2453681BD4E10B8056C82E00D3F90@BYAPR15MB2453.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:293;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(136003)(346002)(366004)(189003)(199004)(6512007)(316002)(31686004)(5660300002)(68736007)(6116002)(71190400001)(53936002)(99286004)(71200400001)(6486002)(6436002)(6246003)(110136005)(478600001)(46003)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(36756003)(2201001)(305945005)(53546011)(102836004)(86362001)(186003)(8676002)(76176011)(52116002)(7736002)(14454004)(2501003)(229853002)(386003)(81166006)(81156014)(31696002)(8936002)(6506007)(25786009)(2906002)(2616005)(446003)(486006)(11346002)(5024004)(476003)(256004)(14444005)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2453;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iGCjLYpwqKPiZEIoWXou/sgNHMtcOPSzlCmTgLP+xsHrmEprrmmK17+mupw6pEVLYm6AVgnBnCINlAr3+BpqhCN+ZXMs5IPbDxufwPyVPVN/Na49YZtJFjyXPQHNEheZ1U8jY0SfCm4SdCsOrCjviiVPFd4mqPogKc1yuluB1ErTiztLR/J1/zS6dreuweT07CqKKCtAECzlZH13eUGv9WKZaGyv7dd7+ZsvIvywozao2slkfVP5EONI8I0BQUc9E2Jly/uvLU2V1S7cyNSRfsLvj5a/2p4xKGLbScWp8cROyNpFLfgaS3vJtRV9C7LsUn7Xdq2avII+TnEEF4NoUVMdntsRDCCdLUGsWFD3+lnvZrCRusrHHn2hnty9fSBhwiO0aV7udAz56Rtl0VzElx1gesce1R1X+dcLetdPZO4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA4FE75D323F9D46835F7596FE7F0BDB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 982af8b6-6c33-41a4-ba30-08d6fe46dcfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:09:23.0774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgODo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBZGQgYWJp
bGl0eSB0byBhdHRhY2ggdG8ga2VybmVsIGFuZCB1c2VyIHByb2JlcyBhbmQgcmV0cHJvYmVzLg0K
PiBJbXBsZW1lbnRhdGlvbiBkZXBlbmRzIG9uIHBlcmYgZXZlbnQgc3VwcG9ydCBmb3Iga3Byb2Jl
cy91cHJvYmVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWlu
QGZiLmNvbT4NCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgIHwgMTY1ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIHRvb2xzL2xpYi9icGYvbGli
YnBmLmggICB8ICAgNyArKw0KPiAgIHRvb2xzL2xpYi9icGYvbGliYnBmLm1hcCB8ICAgMiArDQo+
ICAgMyBmaWxlcyBjaGFuZ2VkLCAxNzQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4
IDk4YzE1NWVjM2JmYS4uMmY3OWU5NTYzZGI5IDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBm
L2xpYmJwZi5jDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTQwMTksNiAr
NDAxOSwxNzEgQEAgc3RydWN0IGJwZl9saW5rICpicGZfcHJvZ3JhbV9fYXR0YWNoX3BlcmZfZXZl
bnQoc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLA0KPiAgIAlyZXR1cm4gKHN0cnVjdCBicGZfbGlu
ayAqKWxpbms7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCBwYXJzZV92YWx1ZV9mcm9tX2Zp
bGUoY29uc3QgY2hhciAqZmlsZSwgY29uc3QgY2hhciAqZm10KQ0KDQpIZXJlLCB0aGUgdmFsdWUg
ZnJvbSB0aGUgZmlsZSBtdXN0IGJlIHBvc2l0aXZlIGludCB2YWx1ZXMgdG8gYXZvaWQNCmNvbmZ1
c2lvbiBiZXR3ZWVuIHZhbGlkIHZhbHVlIHZzLiBlcnJvciBjb2RlLg0KQ291bGQgeW91IGFkZCBh
IGNvbW1lbnQgdG8gc3RhdGUgdGhpcyBmYWN0IGZvciB0aGUgY3VycmVudCANCnVwcm9iZS9rcHJv
YmUvdHJhY2Vwb2ludCBzdXBwb3J0Pw0KDQo+ICt7DQo+ICsJY2hhciBidWZbU1RSRVJSX0JVRlNJ
WkVdOw0KPiArCWludCBlcnIsIHJldDsNCj4gKwlGSUxFICpmOw0KPiArDQo+ICsJZiA9IGZvcGVu
KGZpbGUsICJyIik7DQo+ICsJaWYgKCFmKSB7DQo+ICsJCWVyciA9IC1lcnJubzsNCj4gKwkJcHJf
ZGVidWcoImZhaWxlZCB0byBvcGVuICclcyc6ICVzXG4iLCBmaWxlLA0KPiArCQkJIGxpYmJwZl9z
dHJlcnJvcl9yKGVyciwgYnVmLCBzaXplb2YoYnVmKSkpOw0KPiArCQlmY2xvc2UoZik7DQoNCmZj
bG9zZShmKSBpcyBub3QgbmVlZGVkLiBmb3BlbiBoYXMgZmFpbGVkLg0KDQo+ICsJCXJldHVybiBl
cnI7DQo+ICsJfQ0KPiArCWVyciA9IGZzY2FuZihmLCBmbXQsICZyZXQpOw0KPiArCWlmIChlcnIg
IT0gMSkgew0KPiArCQllcnIgPSBlcnIgPT0gRU9GID8gLUVJTyA6IC1lcnJubzsNCj4gKwkJcHJf
ZGVidWcoImZhaWxlZCB0byBwYXJzZSAnJXMnOiAlc1xuIiwgZmlsZSwNCj4gKwkJCWxpYmJwZl9z
dHJlcnJvcl9yKGVyciwgYnVmLCBzaXplb2YoYnVmKSkpOw0KPiArCQlmY2xvc2UoZik7DQo+ICsJ
CXJldHVybiBlcnI7DQo+ICsJfQ0KPiArCWZjbG9zZShmKTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiAr
fQ0KPiArDQo+ICtzdGF0aWMgaW50IGRldGVybWluZV9rcHJvYmVfcGVyZl90eXBlKHZvaWQpDQo+
ICt7DQo+ICsJY29uc3QgY2hhciAqZmlsZSA9ICIvc3lzL2J1cy9ldmVudF9zb3VyY2UvZGV2aWNl
cy9rcHJvYmUvdHlwZSI7DQo+ICsNCj4gKwlyZXR1cm4gcGFyc2VfdmFsdWVfZnJvbV9maWxlKGZp
bGUsICIlZFxuIik7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbnQgZGV0ZXJtaW5lX3Vwcm9iZV9w
ZXJmX3R5cGUodm9pZCkNCj4gK3sNCj4gKwljb25zdCBjaGFyICpmaWxlID0gIi9zeXMvYnVzL2V2
ZW50X3NvdXJjZS9kZXZpY2VzL3Vwcm9iZS90eXBlIjsNCj4gKw0KPiArCXJldHVybiBwYXJzZV92
YWx1ZV9mcm9tX2ZpbGUoZmlsZSwgIiVkXG4iKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBk
ZXRlcm1pbmVfa3Byb2JlX3JldHByb2JlX2JpdCh2b2lkKQ0KPiArew0KPiArCWNvbnN0IGNoYXIg
KmZpbGUgPSAiL3N5cy9idXMvZXZlbnRfc291cmNlL2RldmljZXMva3Byb2JlL2Zvcm1hdC9yZXRw
cm9iZSI7DQo+ICsNCj4gKwlyZXR1cm4gcGFyc2VfdmFsdWVfZnJvbV9maWxlKGZpbGUsICJjb25m
aWc6JWRcbiIpOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IGRldGVybWluZV91cHJvYmVfcmV0
cHJvYmVfYml0KHZvaWQpDQo+ICt7DQo+ICsJY29uc3QgY2hhciAqZmlsZSA9ICIvc3lzL2J1cy9l
dmVudF9zb3VyY2UvZGV2aWNlcy91cHJvYmUvZm9ybWF0L3JldHByb2JlIjsNCj4gKw0KPiArCXJl
dHVybiBwYXJzZV92YWx1ZV9mcm9tX2ZpbGUoZmlsZSwgImNvbmZpZzolZFxuIik7DQo+ICt9DQo+
ICsNCj4gK3N0YXRpYyBpbnQgcGVyZl9ldmVudF9vcGVuX3Byb2JlKGJvb2wgdXByb2JlLCBib29s
IHJldHByb2JlLCBjb25zdCBjaGFyICpuYW1lLA0KPiArCQkJCSB1aW50NjRfdCBvZmZzZXQsIGlu
dCBwaWQpDQo+ICt7DQo+ICsJc3RydWN0IHBlcmZfZXZlbnRfYXR0ciBhdHRyID0ge307DQo+ICsJ
Y2hhciBlcnJtc2dbU1RSRVJSX0JVRlNJWkVdOw0KPiArCWludCB0eXBlLCBwZmQsIGVycjsNCj4g
Kw0KPiArCXR5cGUgPSB1cHJvYmUgPyBkZXRlcm1pbmVfdXByb2JlX3BlcmZfdHlwZSgpDQo+ICsJ
CSAgICAgIDogZGV0ZXJtaW5lX2twcm9iZV9wZXJmX3R5cGUoKTsNCj4gKwlpZiAodHlwZSA8IDAp
IHsNCj4gKwkJcHJfd2FybmluZygiZmFpbGVkIHRvIGRldGVybWluZSAlcyBwZXJmIHR5cGU6ICVz
XG4iLA0KPiArCQkJICAgdXByb2JlID8gInVwcm9iZSIgOiAia3Byb2JlIiwNCj4gKwkJCSAgIGxp
YmJwZl9zdHJlcnJvcl9yKHR5cGUsIGVycm1zZywgc2l6ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0
dXJuIHR5cGU7DQo+ICsJfQ0KPiArCWlmIChyZXRwcm9iZSkgew0KPiArCQlpbnQgYml0ID0gdXBy
b2JlID8gZGV0ZXJtaW5lX3Vwcm9iZV9yZXRwcm9iZV9iaXQoKQ0KPiArCQkJCSA6IGRldGVybWlu
ZV9rcHJvYmVfcmV0cHJvYmVfYml0KCk7DQo+ICsNCj4gKwkJaWYgKGJpdCA8IDApIHsNCj4gKwkJ
CXByX3dhcm5pbmcoImZhaWxlZCB0byBkZXRlcm1pbmUgJXMgcmV0cHJvYmUgYml0OiAlc1xuIiwN
Cj4gKwkJCQkgICB1cHJvYmUgPyAidXByb2JlIiA6ICJrcHJvYmUiLA0KPiArCQkJCSAgIGxpYmJw
Zl9zdHJlcnJvcl9yKGJpdCwgZXJybXNnLA0KPiArCQkJCQkJICAgICBzaXplb2YoZXJybXNnKSkp
Ow0KPiArCQkJcmV0dXJuIGJpdDsNCj4gKwkJfQ0KPiArCQlhdHRyLmNvbmZpZyB8PSAxIDw8IGJp
dDsNCj4gKwl9DQo+ICsJYXR0ci5zaXplID0gc2l6ZW9mKGF0dHIpOw0KPiArCWF0dHIudHlwZSA9
IHR5cGU7DQo+ICsJYXR0ci5jb25maWcxID0gKHVpbnQ2NF90KSh2b2lkICopbmFtZTsgLyoga3By
b2JlX2Z1bmMgb3IgdXByb2JlX3BhdGggKi8NCj4gKwlhdHRyLmNvbmZpZzIgPSBvZmZzZXQ7CQkg
ICAgICAgLyoga3Byb2JlX2FkZHIgb3IgcHJvYmVfb2Zmc2V0ICovDQo+ICsNCj4gKwkvKiBwaWQg
ZmlsdGVyIGlzIG1lYW5pbmdmdWwgb25seSBmb3IgdXByb2JlcyAqLw0KPiArCXBmZCA9IHN5c2Nh
bGwoX19OUl9wZXJmX2V2ZW50X29wZW4sICZhdHRyLA0KPiArCQkgICAgICBwaWQgPCAwID8gLTEg
OiBwaWQgLyogcGlkICovLA0KPiArCQkgICAgICBwaWQgPT0gLTEgPyAwIDogLTEgLyogY3B1ICov
LA0KPiArCQkgICAgICAtMSAvKiBncm91cF9mZCAqLywgUEVSRl9GTEFHX0ZEX0NMT0VYRUMpOw0K
PiArCWlmIChwZmQgPCAwKSB7DQo+ICsJCWVyciA9IC1lcnJubzsNCj4gKwkJcHJfd2FybmluZygi
JXMgcGVyZl9ldmVudF9vcGVuKCkgZmFpbGVkOiAlc1xuIiwNCj4gKwkJCSAgIHVwcm9iZSA/ICJ1
cHJvYmUiIDogImtwcm9iZSIsDQo+ICsJCQkgICBsaWJicGZfc3RyZXJyb3JfcihlcnIsIGVycm1z
Zywgc2l6ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0dXJuIGVycjsNCj4gKwl9DQo+ICsJcmV0dXJu
IHBmZDsNCj4gK30NCj4gKw0KPiArc3RydWN0IGJwZl9saW5rICpicGZfcHJvZ3JhbV9fYXR0YWNo
X2twcm9iZShzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+ICsJCQkJCSAgICBib29sIHJldHBy
b2JlLA0KPiArCQkJCQkgICAgY29uc3QgY2hhciAqZnVuY19uYW1lKQ0KPiArew0KPiArCWNoYXIg
ZXJybXNnW1NUUkVSUl9CVUZTSVpFXTsNCj4gKwlzdHJ1Y3QgYnBmX2xpbmsgKmxpbms7DQo+ICsJ
aW50IHBmZCwgZXJyOw0KPiArDQo+ICsJcGZkID0gcGVyZl9ldmVudF9vcGVuX3Byb2JlKGZhbHNl
IC8qIHVwcm9iZSAqLywgcmV0cHJvYmUsIGZ1bmNfbmFtZSwNCj4gKwkJCQkgICAgMCAvKiBvZmZz
ZXQgKi8sIC0xIC8qIHBpZCAqLyk7DQo+ICsJaWYgKHBmZCA8IDApIHsNCj4gKwkJcHJfd2Fybmlu
ZygicHJvZ3JhbSAnJXMnOiBmYWlsZWQgdG8gY3JlYXRlICVzICclcycgcGVyZiBldmVudDogJXNc
biIsDQo+ICsJCQkgICBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLA0KPiArCQkJICAg
cmV0cHJvYmUgPyAia3JldHByb2JlIiA6ICJrcHJvYmUiLCBmdW5jX25hbWUsDQo+ICsJCQkgICBs
aWJicGZfc3RyZXJyb3JfcihwZmQsIGVycm1zZywgc2l6ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0
dXJuIEVSUl9QVFIocGZkKTsNCj4gKwl9DQo+ICsJbGluayA9IGJwZl9wcm9ncmFtX19hdHRhY2hf
cGVyZl9ldmVudChwcm9nLCBwZmQpOw0KPiArCWlmIChJU19FUlIobGluaykpIHsNCj4gKwkJY2xv
c2UocGZkKTsNCj4gKwkJZXJyID0gUFRSX0VSUihsaW5rKTsNCj4gKwkJcHJfd2FybmluZygicHJv
Z3JhbSAnJXMnOiBmYWlsZWQgdG8gYXR0YWNoIHRvICVzICclcyc6ICVzXG4iLA0KPiArCQkJICAg
YnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSwNCj4gKwkJCSAgIHJldHByb2JlID8gImty
ZXRwcm9iZSIgOiAia3Byb2JlIiwgZnVuY19uYW1lLA0KPiArCQkJICAgbGliYnBmX3N0cmVycm9y
X3IoZXJyLCBlcnJtc2csIHNpemVvZihlcnJtc2cpKSk7DQo+ICsJCXJldHVybiBsaW5rOw0KPiAr
CX0NCj4gKwlyZXR1cm4gbGluazsNCj4gK30NCj4gKw0KPiArc3RydWN0IGJwZl9saW5rICpicGZf
cHJvZ3JhbV9fYXR0YWNoX3Vwcm9iZShzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+ICsJCQkJ
CSAgICBib29sIHJldHByb2JlLCBwaWRfdCBwaWQsDQo+ICsJCQkJCSAgICBjb25zdCBjaGFyICpi
aW5hcnlfcGF0aCwNCj4gKwkJCQkJICAgIHNpemVfdCBmdW5jX29mZnNldCkNCj4gK3sNCj4gKwlj
aGFyIGVycm1zZ1tTVFJFUlJfQlVGU0laRV07DQo+ICsJc3RydWN0IGJwZl9saW5rICpsaW5rOw0K
PiArCWludCBwZmQsIGVycjsNCj4gKw0KPiArCXBmZCA9IHBlcmZfZXZlbnRfb3Blbl9wcm9iZSh0
cnVlIC8qIHVwcm9iZSAqLywgcmV0cHJvYmUsDQo+ICsJCQkJICAgIGJpbmFyeV9wYXRoLCBmdW5j
X29mZnNldCwgcGlkKTsNCj4gKwlpZiAocGZkIDwgMCkgew0KPiArCQlwcl93YXJuaW5nKCJwcm9n
cmFtICclcyc6IGZhaWxlZCB0byBjcmVhdGUgJXMgJyVzOjB4JXp4JyBwZXJmIGV2ZW50OiAlc1xu
IiwNCj4gKwkJCSAgIGJwZl9wcm9ncmFtX190aXRsZShwcm9nLCBmYWxzZSksDQo+ICsJCQkgICBy
ZXRwcm9iZSA/ICJ1cmV0cHJvYmUiIDogInVwcm9iZSIsDQo+ICsJCQkgICBiaW5hcnlfcGF0aCwg
ZnVuY19vZmZzZXQsDQo+ICsJCQkgICBsaWJicGZfc3RyZXJyb3JfcihwZmQsIGVycm1zZywgc2l6
ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0dXJuIEVSUl9QVFIocGZkKTsNCj4gKwl9DQo+ICsJbGlu
ayA9IGJwZl9wcm9ncmFtX19hdHRhY2hfcGVyZl9ldmVudChwcm9nLCBwZmQpOw0KPiArCWlmIChJ
U19FUlIobGluaykpIHsNCj4gKwkJY2xvc2UocGZkKTsNCj4gKwkJZXJyID0gUFRSX0VSUihsaW5r
KTsNCj4gKwkJcHJfd2FybmluZygicHJvZ3JhbSAnJXMnOiBmYWlsZWQgdG8gYXR0YWNoIHRvICVz
ICclczoweCV6eCc6ICVzXG4iLA0KPiArCQkJICAgYnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZh
bHNlKSwNCj4gKwkJCSAgIHJldHByb2JlID8gInVyZXRwcm9iZSIgOiAidXByb2JlIiwNCj4gKwkJ
CSAgIGJpbmFyeV9wYXRoLCBmdW5jX29mZnNldCwNCj4gKwkJCSAgIGxpYmJwZl9zdHJlcnJvcl9y
KGVyciwgZXJybXNnLCBzaXplb2YoZXJybXNnKSkpOw0KPiArCQlyZXR1cm4gbGluazsNCj4gKwl9
DQo+ICsJcmV0dXJuIGxpbms7DQo+ICt9DQo+ICsNCj4gICBlbnVtIGJwZl9wZXJmX2V2ZW50X3Jl
dA0KPiAgIGJwZl9wZXJmX2V2ZW50X3JlYWRfc2ltcGxlKHZvaWQgKm1tYXBfbWVtLCBzaXplX3Qg
bW1hcF9zaXplLCBzaXplX3QgcGFnZV9zaXplLA0KPiAgIAkJCSAgIHZvaWQgKipjb3B5X21lbSwg
c2l6ZV90ICpjb3B5X3NpemUsDQo+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBmL2xpYmJwZi5o
IGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiBpbmRleCAxYmY2NmM0YTkzMzAuLmJkNzY3Y2Mx
MTk2NyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiArKysgYi90b29s
cy9saWIvYnBmL2xpYmJwZi5oDQo+IEBAIC0xNzEsNiArMTcxLDEzIEBAIExJQkJQRl9BUEkgaW50
IGJwZl9saW5rX19kZXN0cm95KHN0cnVjdCBicGZfbGluayAqbGluayk7DQo+ICAgDQo+ICAgTElC
QlBGX0FQSSBzdHJ1Y3QgYnBmX2xpbmsgKg0KPiAgIGJwZl9wcm9ncmFtX19hdHRhY2hfcGVyZl9l
dmVudChzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csIGludCBwZmQpOw0KPiArTElCQlBGX0FQSSBz
dHJ1Y3QgYnBmX2xpbmsgKg0KPiArYnBmX3Byb2dyYW1fX2F0dGFjaF9rcHJvYmUoc3RydWN0IGJw
Zl9wcm9ncmFtICpwcm9nLCBib29sIHJldHByb2JlLA0KPiArCQkJICAgY29uc3QgY2hhciAqZnVu
Y19uYW1lKTsNCj4gK0xJQkJQRl9BUEkgc3RydWN0IGJwZl9saW5rICoNCj4gK2JwZl9wcm9ncmFt
X19hdHRhY2hfdXByb2JlKHN0cnVjdCBicGZfcHJvZ3JhbSAqcHJvZywgYm9vbCByZXRwcm9iZSwN
Cj4gKwkJCSAgIHBpZF90IHBpZCwgY29uc3QgY2hhciAqYmluYXJ5X3BhdGgsDQo+ICsJCQkgICBz
aXplX3QgZnVuY19vZmZzZXQpOw0KPiAgIA0KPiAgIHN0cnVjdCBicGZfaW5zbjsNCj4gICANCj4g
ZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcCBiL3Rvb2xzL2xpYi9icGYvbGli
YnBmLm1hcA0KPiBpbmRleCA3NTZmNWFhODAyZTkuLjU3YTQwZmI2MDcxOCAxMDA2NDQNCj4gLS0t
IGEvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBm
Lm1hcA0KPiBAQCAtMTY5LDcgKzE2OSw5IEBAIExJQkJQRl8wLjAuNCB7DQo+ICAgCWdsb2JhbDoN
Cj4gICAJCWJwZl9saW5rX19kZXN0cm95Ow0KPiAgIAkJYnBmX29iamVjdF9fbG9hZF94YXR0cjsN
Cj4gKwkJYnBmX3Byb2dyYW1fX2F0dGFjaF9rcHJvYmU7DQo+ICAgCQlicGZfcHJvZ3JhbV9fYXR0
YWNoX3BlcmZfZXZlbnQ7DQo+ICsJCWJwZl9wcm9ncmFtX19hdHRhY2hfdXByb2JlOw0KPiAgIAkJ
YnRmX2R1bXBfX2R1bXBfdHlwZTsNCj4gICAJCWJ0Zl9kdW1wX19mcmVlOw0KPiAgIAkJYnRmX2R1
bXBfX25ldzsNCj4gDQo=
