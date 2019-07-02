Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878965D2F6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfGBPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:35:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbfGBPfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:35:00 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62FU63j025733;
        Tue, 2 Jul 2019 08:34:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=M9OGNhj3G+faonyu5BvggKbmcsTYlqfqVKBgZiShogM=;
 b=dszk2AXlckgc9NJwvb4FD01ST+7qPuZbKRW8rXuc5Iy+hpGOCNRpPRzAtsw2uyc1W4ih
 VzC35WchoaMY9CU3nntXTQygIDxxrzWBziWufeRVjIsl7ME46iDEw0BeUe7w1C6T4zP3
 jyq8FqCrXyAODHTQCQT+0Wo/x1/X0OZP9/I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tg128hpuv-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Jul 2019 08:34:33 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jul 2019 08:34:27 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jul 2019 08:34:27 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 08:34:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9OGNhj3G+faonyu5BvggKbmcsTYlqfqVKBgZiShogM=;
 b=MONm113ByfPUtA70fA/WS//iZqyohksm+R91TaMhJyRu2X2ptxISobq+0w09TbFP/Hv55crShPv7zj0GFOdT8GrczVqC1lNSa5HXcR+4rNSfB8PLAD27Wi63zPNHaJ8tf7gO9h5+yzlNbZSWXSG0cLzwqjj8V5Dh1WmcTokc5KA=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3240.namprd15.prod.outlook.com (20.179.57.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 15:34:26 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 15:34:26 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Leo Yan <leo.yan@linaro.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] bpf, libbpf: Smatch: Fix potential NULL pointer
 dereference
Thread-Topic: [PATCH] bpf, libbpf: Smatch: Fix potential NULL pointer
 dereference
Thread-Index: AQHVMMCQpBA/2sc5Gk2Bc2EiDcSo2qa3db6A
Date:   Tue, 2 Jul 2019 15:34:26 +0000
Message-ID: <54a834d7-6adc-c0ad-92aa-1b89e8ada79d@fb.com>
References: <20190702102531.23512-1-leo.yan@linaro.org>
In-Reply-To: <20190702102531.23512-1-leo.yan@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:320:31::11) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8eae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a083866a-49c1-413d-8775-08d6ff02c3ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3240;
x-ms-traffictypediagnostic: BYAPR15MB3240:
x-microsoft-antispam-prvs: <BYAPR15MB3240DD922A5F1713343667B0D3F80@BYAPR15MB3240.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(346002)(376002)(366004)(189003)(199004)(76176011)(2616005)(86362001)(6512007)(8936002)(31696002)(71200400001)(14444005)(52116002)(53546011)(305945005)(68736007)(71190400001)(6506007)(6436002)(66556008)(66476007)(81156014)(7736002)(6486002)(6246003)(8676002)(256004)(53936002)(478600001)(4744005)(25786009)(229853002)(81166006)(102836004)(99286004)(5660300002)(66946007)(2906002)(486006)(2201001)(46003)(66446008)(14454004)(64756008)(36756003)(31686004)(476003)(73956011)(446003)(6116002)(316002)(11346002)(186003)(110136005)(386003)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3240;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K+G6n7xyvw1nY2FbjErHk3pK3mlCprvUJ6c3AoJ2BkUGmZIuFZGR0oxVnFG099dodOi7bOiCQcIIEsQNbY8HwDuSDXExpi50EWMC9lns60V8t7Ihl2ZdRi1KM9NT6N91BxgOf8wB1QyVMwLKPq5P+4+tnUbhLso8PpNs7SxAsHSfaYiowct0HbI/iXdJreCGr4G58IhkMsEVfiSBryQBPJ8xQJXfr36HyC1HTXB2rsD+8dNyQzR26YfzDaX1P89rHqsGyjSgz2QTvhjoEoQpBzBSocGFPKfqQgSNj5p7AQ4UgYtykWbgYWosMzRxmEsBUpVUc1qan9rqorPt2n5W+K2egS0eDg8MHq2ITNBv88wfVcplZjWE2WdwGHLXozT7DgUuPPt0Lm1jq4KsMWnIF98DvUpiCGWg/HigosoD8SM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5725C43851D6FA41A741E0DFF286D7E2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a083866a-49c1-413d-8775-08d6ff02c3ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 15:34:26.2623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3240
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=997 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMi8xOSAzOjI1IEFNLCBMZW8gWWFuIHdyb3RlOg0KPiBCYXNlZCBvbiB0aGUgZm9s
bG93aW5nIHJlcG9ydCBmcm9tIFNtYXRjaCwgZml4IHRoZSBwb3RlbnRpYWwNCj4gTlVMTCBwb2lu
dGVyIGRlcmVmZXJlbmNlIGNoZWNrLg0KPiANCj4gICAgdG9vbHMvbGliL2JwZi9saWJicGYuYzoz
NDkzDQo+ICAgIGJwZl9wcm9nX2xvYWRfeGF0dHIoKSB3YXJuOiB2YXJpYWJsZSBkZXJlZmVyZW5j
ZWQgYmVmb3JlIGNoZWNrICdhdHRyJw0KPiAgICAoc2VlIGxpbmUgMzQ4MykNCj4gDQo+IDM0Nzkg
aW50IGJwZl9wcm9nX2xvYWRfeGF0dHIoY29uc3Qgc3RydWN0IGJwZl9wcm9nX2xvYWRfYXR0ciAq
YXR0ciwNCj4gMzQ4MCAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgYnBmX29iamVjdCAq
KnBvYmosIGludCAqcHJvZ19mZCkNCj4gMzQ4MSB7DQo+IDM0ODIgICAgICAgICBzdHJ1Y3QgYnBm
X29iamVjdF9vcGVuX2F0dHIgb3Blbl9hdHRyID0gew0KPiAzNDgzICAgICAgICAgICAgICAgICAu
ZmlsZSAgICAgICAgICAgPSBhdHRyLT5maWxlLA0KPiAzNDg0ICAgICAgICAgICAgICAgICAucHJv
Z190eXBlICAgICAgPSBhdHRyLT5wcm9nX3R5cGUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBeXl5eXl4NCj4gMzQ4NSAgICAgICAgIH07DQo+IA0KPiBBdCB0aGUg
aGVhZCBvZiBmdW5jdGlvbiwgaXQgZGlyZWN0bHkgYWNjZXNzICdhdHRyJyB3aXRob3V0IGNoZWNr
aW5nIGlmDQo+IGl0J3MgTlVMTCBwb2ludGVyLiAgVGhpcyBwYXRjaCBtb3ZlcyB0aGUgdmFsdWVz
IGFzc2lnbm1lbnQgYWZ0ZXINCj4gdmFsaWRhdGluZyAnYXR0cicgYW5kICdhdHRyLT5maWxlJy4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IExlbyBZYW4gPGxlby55YW5AbGluYXJvLm9yZz4NCg0KQWNr
ZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo=
