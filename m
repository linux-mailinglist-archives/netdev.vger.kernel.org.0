Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E42C5C5D5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGAXFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:05:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20008 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbfGAXFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:05:11 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61N4S4f025646;
        Mon, 1 Jul 2019 16:04:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=resYpOD3Bj9b9kkB9cZsUnApFwep8gTlDqk1ASwssF0=;
 b=Co09/Li3tcyWSulEb9kbcKatO5V9RJmeKDRnb/fgU+kvoUTN5cYUW9FuUup3whRs84bo
 Dku5DZhBaHM/FeSf9SJTHuCCx4cq6rdq+skwSEHFLy06Jgxzja93VmkAAa3ePkmuoNKt
 mN09+GalmKxxidTNXfieOejayaFlrQiC2A4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfqa0rwu9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 16:04:50 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 16:04:44 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 16:04:44 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 16:04:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=resYpOD3Bj9b9kkB9cZsUnApFwep8gTlDqk1ASwssF0=;
 b=H8IrM0TLEns8l1y/9Ymvps6NnahDEiB+541FaE5mpmKyspTPGnfBbXENFQYjoOH3xUQIn7Z7VJVtC1tiOj4CsGsgRHbGLIQOqnRTiUV7gU/epLssRG6YbJwez0+utlrfkfKEplnFG/U0IsrGDyv2h52JQctSrkFKgAsVb5sgPR0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3159.namprd15.prod.outlook.com (20.178.207.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 23:04:43 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 23:04:43 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
Thread-Topic: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
Thread-Index: AQHVLi2rAoPQPf+NCkqAuxw7NA58oqa2BC6AgABXhQCAAAqqAA==
Date:   Mon, 1 Jul 2019 23:04:43 +0000
Message-ID: <cf314380-a96e-eae6-6fb5-b136c50cec71@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-7-andriin@fb.com>
 <e6be6907-4587-6106-9868-e76fbf38a3f5@fb.com>
 <CAEf4BzYRpgE5VPwuv2zkXZ2N9BQVPASvYbtsZDM10C1kwdX3eg@mail.gmail.com>
In-Reply-To: <CAEf4BzYRpgE5VPwuv2zkXZ2N9BQVPASvYbtsZDM10C1kwdX3eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0007.namprd10.prod.outlook.com
 (2603:10b6:301:2a::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f16ad442-101e-4279-c6d0-08d6fe7880f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3159;
x-ms-traffictypediagnostic: BYAPR15MB3159:
x-microsoft-antispam-prvs: <BYAPR15MB315979A8DCF3C0735592EFF5D3F90@BYAPR15MB3159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:114;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(376002)(136003)(396003)(366004)(346002)(199004)(189003)(256004)(31696002)(14444005)(86362001)(5024004)(478600001)(36756003)(66446008)(66556008)(64756008)(66946007)(446003)(316002)(73956011)(7736002)(6246003)(305945005)(8676002)(6916009)(81156014)(81166006)(6512007)(53936002)(6486002)(46003)(71190400001)(6436002)(71200400001)(229853002)(2616005)(476003)(186003)(14454004)(5660300002)(11346002)(486006)(68736007)(54906003)(25786009)(8936002)(53546011)(6506007)(386003)(102836004)(31686004)(4326008)(76176011)(99286004)(66476007)(52116002)(6116002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3159;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9s+fXIo62JF3tOO+kh6Xw1J/M7XC8Lnzsn3IxCCbTE8laXsF48q3sFGUXJJvDZY2ErfBbJU2zoFCuA4uEb5UdF5m59pYEt+3L28kkPGrK/qi1YHERP7vRJdeh8HeWEBjllTaK9usd/d9elnAcDGDrve5Iuh+NaGi1JuBG4YYrPvfv5jtwLy3K7yh6fijQlA3oOxBbmNjo2axaaAHaUK61LFPxkN4snSgWrf2QIe/3KYJAkHSNKWNsBwpsvbBEaY3UV7VIlBplTSrT31nixhmODn+wvirIsuXHhdobubMVZ1TWNlR07sZYycPfjvKLR3/ndZ9t4aerZq0amdCuQP2ZCh4l0AmfvADPF5qMI7JLftF3Fs++RZKbIa16qqjg0fUfZH9cxNN9XDgwN1hQntpgBLijD0PTSFICsOXLfzlDdM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C3807A4BBE71D41ABE4A9F066EB9329@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f16ad442-101e-4279-c6d0-08d6fe7880f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 23:04:43.5954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010268
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMS8xOSAzOjI2IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIE1vbiwg
SnVsIDEsIDIwMTkgYXQgMTA6MTMgQU0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6
DQo+Pg0KPj4NCj4+DQo+PiBPbiA2LzI4LzE5IDg6NDkgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90
ZToNCj4+PiBBZGQgYSB3cmFwcGVyIHV0aWxpemluZyBicGZfbGluayAiaW5mcmFzdHJ1Y3R1cmUi
IHRvIGFsbG93IGF0dGFjaGluZyBCUEYNCj4+PiBwcm9ncmFtcyB0byByYXcgdHJhY2Vwb2ludHMu
DQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29t
Pg0KPj4+IEFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPj4+IC0t
LQ0KPj4+ICAgIHRvb2xzL2xpYi9icGYvbGliYnBmLmMgICB8IDM3ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4+PiAgICB0b29scy9saWIvYnBmL2xpYmJwZi5oICAgfCAg
MyArKysNCj4+PiAgICB0b29scy9saWIvYnBmL2xpYmJwZi5tYXAgfCAgMSArDQo+Pj4gICAgMyBm
aWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25zKCspDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9v
bHMvbGliL2JwZi9saWJicGYuYyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4+PiBpbmRleCA4
YWQ0ZjkxNWRmMzguLmY4YzdhN2VjYjM1ZSAxMDA2NDQNCj4+PiAtLS0gYS90b29scy9saWIvYnBm
L2xpYmJwZi5jDQo+Pj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYuYw0KPj4+IEBAIC00MjYz
LDYgKzQyNjMsNDMgQEAgc3RydWN0IGJwZl9saW5rICpicGZfcHJvZ3JhbV9fYXR0YWNoX3RyYWNl
cG9pbnQoc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLA0KPj4+ICAgICAgICByZXR1cm4gbGluazsN
Cj4+PiAgICB9DQo+Pj4NCj4+PiArc3RhdGljIGludCBicGZfbGlua19fZGVzdHJveV9mZChzdHJ1
Y3QgYnBmX2xpbmsgKmxpbmspDQo+Pj4gK3sNCj4+PiArICAgICBzdHJ1Y3QgYnBmX2xpbmtfZmQg
KmwgPSAodm9pZCAqKWxpbms7DQo+Pj4gKw0KPj4+ICsgICAgIHJldHVybiBjbG9zZShsLT5mZCk7
DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0cnVjdCBicGZfbGluayAqYnBmX3Byb2dyYW1fX2F0dGFj
aF9yYXdfdHJhY2Vwb2ludChzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+Pj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICp0cF9u
YW1lKQ0KPj4+ICt7DQo+Pj4gKyAgICAgY2hhciBlcnJtc2dbU1RSRVJSX0JVRlNJWkVdOw0KPj4+
ICsgICAgIHN0cnVjdCBicGZfbGlua19mZCAqbGluazsNCj4+PiArICAgICBpbnQgcHJvZ19mZCwg
cGZkOw0KPj4+ICsNCj4+PiArICAgICBwcm9nX2ZkID0gYnBmX3Byb2dyYW1fX2ZkKHByb2cpOw0K
Pj4+ICsgICAgIGlmIChwcm9nX2ZkIDwgMCkgew0KPj4+ICsgICAgICAgICAgICAgcHJfd2Fybmlu
ZygicHJvZ3JhbSAnJXMnOiBjYW4ndCBhdHRhY2ggYmVmb3JlIGxvYWRlZFxuIiwNCj4+PiArICAg
ICAgICAgICAgICAgICAgICAgICAgYnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSk7DQo+
Pj4gKyAgICAgICAgICAgICByZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4+PiArICAgICB9DQo+
Pj4gKw0KPj4+ICsgICAgIGxpbmsgPSBtYWxsb2Moc2l6ZW9mKCpsaW5rKSk7DQo+Pj4gKyAgICAg
bGluay0+bGluay5kZXN0cm95ID0gJmJwZl9saW5rX19kZXN0cm95X2ZkOw0KPj4NCj4+IFlvdSBj
YW4gbW92ZSB0aGUgImxpbmsgPSBtYWxsb2MoLi4uKSIgZXRjLiBhZnRlcg0KPj4gYnBmX3Jhd190
cmFjZXBvaW50X29wZW4oKS4gVGhhdCB3YXksIHlvdSBkbyBub3QgbmVlZCB0byBmcmVlKGxpbmsp
DQo+PiBpbiB0aGUgZXJyb3IgY2FzZS4NCj4gDQo+IEl0J3MgZWl0aGVyIGBmcmVlKGxpbmspYCBo
ZXJlLCBvciBgY2xvc2UocGZkKWAgaWYgbWFsbG9jIGZhaWxzIGFmdGVyDQo+IHdlIGF0dGFjaGVk
IHByb2dyYW0uIEVpdGhlciB3YXkgZXh0cmEgY2xlYW4gdXAgaXMgbmVlZGVkLiBJIHdlbnQgd2l0
aA0KPiB0aGUgZmlyc3Qgb25lLg0KDQpPa2F5IHdpdGggbWUuDQpCVFcsIGRvIHlvdSB3YW50IHRv
IGNoZWNrIHdoZXRoZXIgbWFsbG9jKCkgbWF5IGZhaWx1cmUgYW5kIGxpbmsgbWF5IGJlIE5VTEw/
DQoNCj4+DQo+Pj4gKw0KPj4+ICsgICAgIHBmZCA9IGJwZl9yYXdfdHJhY2Vwb2ludF9vcGVuKHRw
X25hbWUsIHByb2dfZmQpOw0KPj4+ICsgICAgIGlmIChwZmQgPCAwKSB7DQo+Pj4gKyAgICAgICAg
ICAgICBwZmQgPSAtZXJybm87DQo+Pj4gKyAgICAgICAgICAgICBmcmVlKGxpbmspOw0KPj4+ICsg
ICAgICAgICAgICAgcHJfd2FybmluZygicHJvZ3JhbSAnJXMnOiBmYWlsZWQgdG8gYXR0YWNoIHRv
IHJhdyB0cmFjZXBvaW50ICclcyc6ICVzXG4iLA0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAg
ICBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLCB0cF9uYW1lLA0KPj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgICBsaWJicGZfc3RyZXJyb3JfcihwZmQsIGVycm1zZywgc2l6ZW9mKGVy
cm1zZykpKTsNCj4+PiArICAgICAgICAgICAgIHJldHVybiBFUlJfUFRSKHBmZCk7DQo+Pj4gKyAg
ICAgfQ0KPj4+ICsgICAgIGxpbmstPmZkID0gcGZkOw0KPj4+ICsgICAgIHJldHVybiAoc3RydWN0
IGJwZl9saW5rICopbGluazsNCj4+PiArfQ0KPj4+ICsNCj4+PiAgICBlbnVtIGJwZl9wZXJmX2V2
ZW50X3JldA0KPj4+ICAgIGJwZl9wZXJmX2V2ZW50X3JlYWRfc2ltcGxlKHZvaWQgKm1tYXBfbWVt
LCBzaXplX3QgbW1hcF9zaXplLCBzaXplX3QgcGFnZV9zaXplLA0KPj4+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdm9pZCAqKmNvcHlfbWVtLCBzaXplX3QgKmNvcHlfc2l6ZSwNCj4+PiBkaWZm
IC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuaCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmgN
Cj4+PiBpbmRleCA2MDYxMWY0YjRlMWQuLmY1NTkzMzc4NGY5NSAxMDA2NDQNCj4+PiAtLS0gYS90
b29scy9saWIvYnBmL2xpYmJwZi5oDQo+Pj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0K
Pj4+IEBAIC0xODIsNiArMTgyLDkgQEAgTElCQlBGX0FQSSBzdHJ1Y3QgYnBmX2xpbmsgKg0KPj4+
ICAgIGJwZl9wcm9ncmFtX19hdHRhY2hfdHJhY2Vwb2ludChzdHJ1Y3QgYnBmX3Byb2dyYW0gKnBy
b2csDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqdHBfY2F0
ZWdvcnksDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqdHBf
bmFtZSk7DQo+Pj4gK0xJQkJQRl9BUEkgc3RydWN0IGJwZl9saW5rICoNCj4+PiArYnBmX3Byb2dy
YW1fX2F0dGFjaF9yYXdfdHJhY2Vwb2ludChzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+Pj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqdHBfbmFtZSk7DQo+
Pj4NCj4+PiAgICBzdHJ1Y3QgYnBmX2luc247DQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMv
bGliL2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+Pj4gaW5kZXgg
M2M2MThiNzVlZjY1Li5lNmI3ZDRlZGJjOTMgMTAwNjQ0DQo+Pj4gLS0tIGEvdG9vbHMvbGliL2Jw
Zi9saWJicGYubWFwDQo+Pj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+Pj4gQEAg
LTE3MSw2ICsxNzEsNyBAQCBMSUJCUEZfMC4wLjQgew0KPj4+ICAgICAgICAgICAgICAgIGJwZl9v
YmplY3RfX2xvYWRfeGF0dHI7DQo+Pj4gICAgICAgICAgICAgICAgYnBmX3Byb2dyYW1fX2F0dGFj
aF9rcHJvYmU7DQo+Pj4gICAgICAgICAgICAgICAgYnBmX3Byb2dyYW1fX2F0dGFjaF9wZXJmX2V2
ZW50Ow0KPj4+ICsgICAgICAgICAgICAgYnBmX3Byb2dyYW1fX2F0dGFjaF9yYXdfdHJhY2Vwb2lu
dDsNCj4+PiAgICAgICAgICAgICAgICBicGZfcHJvZ3JhbV9fYXR0YWNoX3RyYWNlcG9pbnQ7DQo+
Pj4gICAgICAgICAgICAgICAgYnBmX3Byb2dyYW1fX2F0dGFjaF91cHJvYmU7DQo+Pj4gICAgICAg
ICAgICAgICAgYnRmX2R1bXBfX2R1bXBfdHlwZTsNCj4+Pg0K
