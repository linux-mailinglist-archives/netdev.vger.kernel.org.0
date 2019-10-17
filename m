Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA5DB108
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437525AbfJQPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:24:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404842AbfJQPYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:24:04 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9HFEZQw028248;
        Thu, 17 Oct 2019 08:23:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZvruH3ECF2WFcvb3vVnavqFaDCupU9tzuVsRsJIUf8w=;
 b=DVQdupenWAvAx50EmSw4dWuo0BHVsJ2APpMRoyMDuHzDfyUv9TUHN43zNiay076YmhEJ
 uiqqbbienyShU0fdEaQaMdLSCZl4/DBw7BzW+NSVa/sBp6B2hfREY+s4pBki//j/I/3X
 28BhYgBVHBRuLO1epY53r79K8Oh9/pUGLRI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vp3uk62mh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 08:23:46 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 17 Oct 2019 08:23:33 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 17 Oct 2019 08:23:33 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 08:23:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZafNQhFOfBjL4CUyx/kFAvnpEND2FW8MATyiKc5cATLIc+5dorX7EyCPTYegmYOS96e+pb4l+K63nxjAafa9d//yV9xEiLJnPaDp1XFjYwcT1gjSmVWHD0ETK9RvM5Q6YDL9N1/XPLxHer/geLFsS03nGlj2cch1EZtvk30ZB3H0K6CR32ocPKv3zHBGEKTsptC5FcAYuJptx38fc+ncRQaPc/k062DzjrP3JmlGcPdR+PKRU2L45F1zOVjstED8/7diga8u/eK7tA7/hC3mkWLwWNeBaUok4SRKQ5BjbivXoxskUUmiWWH3o/GWACxHVdsGBB1J6i4uNpSNNPTyhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvruH3ECF2WFcvb3vVnavqFaDCupU9tzuVsRsJIUf8w=;
 b=AOs4SUnkye7jcPXwxR6MYAE+lr3zckupeYlOc3bAMdjzbGPt80nxc7q6qv4jA24RLJCyqWlOu11uYWGUSqgmtvBiSL/xvHOkTdPbkglw20Ussz4PFMBiBkzuRuBSDOLzjGZ9oA70q5fGZnzQyNsNWpE7Xtex8sX7IWFuKMaX/rrzJ726xv6D7F3imN2JaaWwKA0FOu7ZNm6uN6e/5Jbc4QyZvnRIODJSuQdaecjmuvJwqHSSkv1fY0upiRLdEbHI2QSTwybDX1kbEVqaCLSkYtZzGyH5W7EnDNSjWcIk/QHUzGtxd2DZc/pHaBaPh+ULzAoCed5WkKSjHzM/VSdNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvruH3ECF2WFcvb3vVnavqFaDCupU9tzuVsRsJIUf8w=;
 b=Fc3xuxKt2iiJ9JTLYstADBWbeNsirTqMRDgmhrGCKVbLKlbCUTemCQK98gHOHedggiGL671p5GlrLtCtmgkRF+XRIVvetVgOYzs2gq577iS2haaS8MKJlUU4x2IVo/6ui74JuISg30rTI0iasmt71IjUFJSIGs0Aob3WUGT07tk=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2375.namprd15.prod.outlook.com (52.135.200.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Thu, 17 Oct 2019 15:23:31 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 15:23:31 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map
 type
Thread-Topic: [PATCH bpf] xdp: Handle device unregister for devmap_hash map
 type
Thread-Index: AQHVhCdlppQOzEei3k2WLH8m/CjHP6ddstKAgADv/oCAAFKHAA==
Date:   Thu, 17 Oct 2019 15:23:31 +0000
Message-ID: <d77bd569-eee2-b436-c575-9ff78bab4f1a@fb.com>
References: <20191016132802.2760149-1-toke@redhat.com>
 <2d516208-8c46-707c-4484-4547e66fc128@i-love.sakura.ne.jp>
 <87ftjrfyyy.fsf@toke.dk>
In-Reply-To: <87ftjrfyyy.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0005.namprd20.prod.outlook.com
 (2603:10b6:301:15::15) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::8d7c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93bec0f4-7d0a-43d2-41bb-08d75315f78f
x-ms-traffictypediagnostic: BYAPR15MB2375:
x-microsoft-antispam-prvs: <BYAPR15MB2375CDFE0EB8C29889C50175D76D0@BYAPR15MB2375.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(136003)(39860400002)(366004)(346002)(396003)(51444003)(199004)(189003)(81166006)(2906002)(305945005)(81156014)(8676002)(5660300002)(14454004)(7736002)(25786009)(6436002)(478600001)(8936002)(229853002)(31686004)(110136005)(486006)(6246003)(6486002)(54906003)(99286004)(36756003)(256004)(71190400001)(186003)(11346002)(71200400001)(2616005)(46003)(53546011)(386003)(6506007)(476003)(446003)(76176011)(6512007)(6116002)(52116002)(66574012)(102836004)(66446008)(64756008)(31696002)(66556008)(66476007)(86362001)(316002)(66946007)(4326008)(14444005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2375;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PcsYHRl46VT6KJXUcYOm3nHUqsVrzS2z45/TPeh0tr5MjGE1GKid44TuPiBgYk4891Hpd5DsFV9/aLu1Zi2egFWFosl4mSpcaXjQoZYAgrpsdiQG3hIL+F1pbSJOW4CHtD9ccJYsfKM2TEsc2q3NP3PhFYpuAQl3BT61koGB5nyxZE7OUR8kkaDyCOForxFOyTceiYg5OIW0OYPmddZF7o61bl/2SMVksJAhBDY00XpPEbtpmUzVHG2q/OcxPaGgfqsSmkid356dQY/LFl0Q3erOTkmyK8V4Ty+1suWEY5bTuxvj5lGW5mUN44rhsCS5cO6tw2PXVZwAMBeWFS4PmnwCQSVWxozR7pr7C0zNwD51DUBp89UjgjfJRhXdlozhbdegMkJ0dInlI0PNZPe0Uo3un55cMWqH23OzQCAPsXs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBA4EEA5213FBD498EDD1B1EAB0ADD9F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 93bec0f4-7d0a-43d2-41bb-08d75315f78f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 15:23:31.4380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JFCpaOPAUNVo/kMj5Uwi/eHHR9zhN/hvskMJa0utQpGKtVTvThGzucUHiKcAxcN5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2375
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=940 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1011 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTcvMTkgMzoyOCBBTSwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIHdyb3RlOg0KPiBU
ZXRzdW8gSGFuZGEgPHBlbmd1aW4ta2VybmVsQGktbG92ZS5zYWt1cmEubmUuanA+IHdyaXRlczoN
Cj4gDQo+PiBPbiAyMDE5LzEwLzE2IDIyOjI4LCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gd3Jv
dGU6DQo+Pj4gSXQgc2VlbXMgSSBmb3Jnb3QgdG8gYWRkIGhhbmRsaW5nIG9mIGRldm1hcF9oYXNo
IHR5cGUgbWFwcyB0byB0aGUgZGV2aWNlDQo+Pj4gdW5yZWdpc3RlciBob29rIGZvciBkZXZtYXBz
LiBUaGlzIG9taXNzaW9uIGNhdXNlcyBkZXZpY2VzIHRvIG5vdCBiZQ0KPj4+IHByb3Blcmx5IHJl
bGVhc2VkLCB3aGljaCBjYXVzZXMgaGFuZ3MuDQo+Pj4NCj4+PiBGaXggdGhpcyBieSBhZGRpbmcg
dGhlIG1pc3NpbmcgaGFuZGxlci4NCj4+Pg0KPj4+IEZpeGVzOiA2ZjlkNDUxYWIxYTMgKCJ4ZHA6
IEFkZCBkZXZtYXBfaGFzaCBtYXAgdHlwZSBmb3IgbG9va2luZyB1cCBkZXZpY2VzIGJ5IGhhc2hl
ZCBpbmRleCIpDQo+Pj4gUmVwb3J0ZWQtYnk6IFRldHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJuZWxA
SS1sb3ZlLlNBS1VSQS5uZS5qcD4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBUb2tlIEjDuGlsYW5kLUrD
uHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCj4+DQo+PiBXZWxsLCByZWdhcmRpbmcgNmY5ZDQ1
MWFiMWEzLCBJIHRoaW5rIHRoYXQgd2Ugd2FudCBleHBsaWNpdCAiKHU2NCkiIGNhc3QNCj4+DQo+
PiBAQCAtOTcsNiArMTIzLDE0IEBAIHN0YXRpYyBpbnQgZGV2X21hcF9pbml0X21hcChzdHJ1Y3Qg
YnBmX2R0YWIgKmR0YWIsIHVuaW9uIGJwZl9hdHRyICphdHRyKQ0KPj4gICAgICAgICAgY29zdCA9
ICh1NjQpIGR0YWItPm1hcC5tYXhfZW50cmllcyAqIHNpemVvZihzdHJ1Y3QgYnBmX2R0YWJfbmV0
ZGV2ICopOw0KPj4gICAgICAgICAgY29zdCArPSBzaXplb2Yoc3RydWN0IGxpc3RfaGVhZCkgKiBu
dW1fcG9zc2libGVfY3B1cygpOw0KPj4NCj4+ICsgICAgICAgaWYgKGF0dHItPm1hcF90eXBlID09
IEJQRl9NQVBfVFlQRV9ERVZNQVBfSEFTSCkgew0KPj4gKyAgICAgICAgICAgICAgIGR0YWItPm5f
YnVja2V0cyA9IHJvdW5kdXBfcG93X29mX3R3byhkdGFiLT5tYXAubWF4X2VudHJpZXMpOw0KPj4g
Kw0KPj4gKyAgICAgICAgICAgICAgIGlmICghZHRhYi0+bl9idWNrZXRzKSAvKiBPdmVyZmxvdyBj
aGVjayAqLw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+PiAr
ICAgICAgICAgICAgICAgY29zdCArPSBzaXplb2Yoc3RydWN0IGhsaXN0X2hlYWQpICogZHRhYi0+
bl9idWNrZXRzOw0KPj4NCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXmhlcmUNCj4+DQo+PiArICAgICAgIH0NCj4+ICsNCj4+ICAgICAgICAg
IC8qIGlmIG1hcCBzaXplIGlzIGxhcmdlciB0aGFuIG1lbWxvY2sgbGltaXQsIHJlamVjdCBpdCAq
Lw0KPj4gICAgICAgICAgZXJyID0gYnBmX21hcF9jaGFyZ2VfaW5pdCgmZHRhYi0+bWFwLm1lbW9y
eSwgY29zdCk7DQo+PiAgICAgICAgICBpZiAoZXJyKQ0KPj4NCj4+IGxpa2UgIih1NjQpIGR0YWIt
Pm1hcC5tYXhfZW50cmllcyAqIHNpemVvZihzdHJ1Y3QgYnBmX2R0YWJfbmV0ZGV2ICopIiBkb2Vz
Lg0KPj4gT3RoZXJ3aXNlLCBvbiAzMmJpdHMgYnVpbGQsICJzaXplb2Yoc3RydWN0IGhsaXN0X2hl
YWQpICogZHRhYi0+bl9idWNrZXRzIiBjYW4gYmVjb21lIDAuDQo+IA0KPiBPaCwgcmlnaHQuIEkg
a2luZGEgYXNzdW1lZCB0aGUgY29tcGlsZXIgd291bGQgYmUgc21hcnQgZW5vdWdoIHRvIGZpZ3Vy
ZQ0KPiB0aGF0IG91dCBiYXNlZCBvbiB0aGUgdHlwZSBvZiB0aGUgTEhTOyB3aWxsIHNlbmQgYSBz
ZXBhcmF0ZSBmaXggZm9yIHRoaXMuDQoNCmNvbXBpbGVyIHNtYXJ0IGVub3VnaD8hIHlvdSBtdXN0
IGJlIGtpZGRpbmcuDQpJdCdzIGEgQyBzdGFuZGFyZC4gQ29tcGlsZXIgaGFzIHRvIGRvIDMyIGJp
dCBtdWx0aXBseSBiZWNhdXNlIG5fYnVja2V0cw0KaXMgdTMyIGFuZCBzaXplb2YgaXMgMzIgYml0
IGluIDMyYml0IGFyY2hlcyBhcyBUZXRzdW8gZXhwbGFpbmVkLg0K
