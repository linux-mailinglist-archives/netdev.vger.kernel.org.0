Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC8E3E5C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfJXVkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:40:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726443AbfJXVkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:40:04 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9OLbmB7019808;
        Thu, 24 Oct 2019 14:39:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=02MMPhGgGwAgiqqF4ajewlWQ3L1YCmlDcTUmVWI0ruY=;
 b=OLIy0PNx7fogj50o3HJA2r/hXAA1AWYD53Iy3BdHlQUsitG3Nc9T8//h0f/gO3Wbi+9y
 DOw5VaPHD9D8ToCSL8irTQNzal4N96UUY4WMUvdnQ9LhC86TI+DkTMiBZ+e71RGDWvD4
 tSvdT5uyo6IMPd7qi84H55saAB4nREL6QV4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vt9ssufpn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Oct 2019 14:39:49 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 24 Oct 2019 14:39:49 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Oct 2019 14:39:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/GFTLmz9MixNfjktYQabJaE3aaTkUJbjZPAoYVXjuCuSxmt/9LEXLUokEX78T7awQuTtzAkufbQJaW5iCVRCxK8i4no9YJ72CQM6prhKbaNqxA7wtJmPF/WjMjAvZ1mHIMhK3TewVSXYpo1WotmVfu84I/jGZ9HmdoqD/j7kTKICcryG8tYeR6At01qhShe97ZUTaZT5UF1B1YQ0gOtvc+bNcWjXnhGbT1M+TJjQljVu5UqTSlwPfPbi09yWpJV5p/0qMJk1Dgx9eq/u5IDzhLB00mAyU5tqK5vMzD5gGjb+ylvYyrAO2LF5Iih/jAcdsEN92ZBY1N7t9Am6XmQfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02MMPhGgGwAgiqqF4ajewlWQ3L1YCmlDcTUmVWI0ruY=;
 b=Ax4ajKS/HBTYVYdxsCQl5HFScXMCDe8QiqG6OwJtVIKYkbSOzuQvtw/fapF6ihDahpyuwGctl6yiZmu9zw8+6p4ZzBfGRzPqnYeBi8CgH+GnNohqN4WZWrlkDPYEV2MTTR+PqNcsFyO7sXrP/HmmCcke7N6RT1II67lG7zr8echypgnpchruQiyJt9k1SXI57++9TSbqz81XdBAwhu8pj+CWJQov2zjcRsKnkWx3kzjgmsH1Iey14YXuJWW0pXAS7R5cwc8bNOu7+u+5OcH0uRXyfD0STeiGPVPQcdC2ILQsmR9+X0feEJezWozfPGMmb+NVHkXW2/vqE73EZlrNag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02MMPhGgGwAgiqqF4ajewlWQ3L1YCmlDcTUmVWI0ruY=;
 b=Q6M8ewogVUf2v3tURGty21BV/HaBwZS1FcNk9Gieq+uHkGbMuCFIp+5w2NHXZNeMaTUaaD3VMtPECBLFFn6hFYa1zwSXbALP49OU2k65wxQRJ0WTUHM/Q27PMkFErHcOkn9EKHZioOJc6NaX3C9/Tw1vYVoNEUT2/BpKoxkbb6A=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2824.namprd15.prod.outlook.com (20.179.157.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Thu, 24 Oct 2019 21:39:47 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2367.025; Thu, 24 Oct 2019
 21:39:47 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Prepare btf_ctx_access for non raw_tp use
 case.
Thread-Topic: [PATCH bpf-next] bpf: Prepare btf_ctx_access for non raw_tp use
 case.
Thread-Index: AQHViqfN2NWrsdgAjE29cuyrxHG0XadqUckA
Date:   Thu, 24 Oct 2019 21:39:47 +0000
Message-ID: <f229a628-52fc-2728-6dd8-1c47a4962201@fb.com>
References: <20191024201524.685995-1-kafai@fb.com>
In-Reply-To: <20191024201524.685995-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:104:5::11) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:c1d6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77ad69e3-b4d2-4e3a-f78d-08d758cab106
x-ms-traffictypediagnostic: BYAPR15MB2824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB282488EB08D9EF1A001B3E8FD76A0@BYAPR15MB2824.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(366004)(39860400002)(346002)(199004)(189003)(25786009)(14454004)(36756003)(256004)(2201001)(2501003)(14444005)(6116002)(6436002)(54906003)(52116002)(110136005)(81166006)(76176011)(316002)(486006)(81156014)(31696002)(5024004)(478600001)(6512007)(53546011)(8936002)(386003)(6506007)(102836004)(31686004)(446003)(7736002)(4326008)(8676002)(6246003)(46003)(186003)(66946007)(66446008)(64756008)(66556008)(99286004)(86362001)(71200400001)(6486002)(71190400001)(66476007)(5660300002)(2616005)(2906002)(11346002)(229853002)(476003)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2824;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZbJTn1BH8y5JmlEW+RMepW4VEKeyOByKZX4TM3jRe0JgOLXCXDG9hKEr3jJhAu6yG/Cua0HTTdaJhdz4CAsWvlttilDBzIuGiZBN30kC5tzWv09xtKJ592+yL92rkpdTPbzhtANFVILMyPgotVwABmBV6NFxdqjQVe4cLMZo2YMI+wvxK4hYh1wpd2EA967evi+GJNd4BNivPJcWftcAKQ1sYho/mj/2fAlYVOSEQUCrN3pOQ7vxuLGTBMTV5bMDRG8WHi7j+1BYb52JOVTSczo9vm6yQGQLEYbRLHRbmyYEk+w/fNDWdQC9IRFlOmEyk6p5tcMDB8mFsK/nZ/dTBQxxJisjA2X+v7HEA06enczM7e6/tdF+3EI+lqHPYTNYjrksf1/gXNjde56SwukWbfA9+OTBsZ7+GAIfbELxHa2lP7J38r82cch2QcfmMFGn
Content-Type: text/plain; charset="utf-8"
Content-ID: <B72CD89CDABC464999BA6895DAC2214D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ad69e3-b4d2-4e3a-f78d-08d758cab106
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 21:39:47.5155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lilASleElqwPIF/dU+r/CitCS4shmrAcwVD6oWW6MGQSpF+Zb6XhCiqhaK/bKB8T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-24_12:2019-10-23,2019-10-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910240204
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMjQvMTkgMToxNSBQTSwgTWFydGluIEthRmFpIExhdSB3cm90ZToNCj4gVGhpcyBwYXRj
aCBtYWtlcyBhIGZldyBjaGFuZ2VzIHRvIGJ0Zl9jdHhfYWNjZXNzKCkgdG8gcHJlcGFyZQ0KPiBp
dCBmb3Igbm9uIHJhd190cCB1c2UgY2FzZS4NCj4gDQo+IGJ0Zl9jdHhfYWNjZXNzKCkgb25seSBu
ZWVkcyB0aGUgYXR0YWNoX2J0Zl9pZCBmcm9tIHByb2cuICBIZW5jZSwgdGhpcyBwYXRjaA0KPiBv
bmx5IHBhc3NlcyB0aGUgYXR0YWNoX2J0Zl9pZCBpbnN0ZWFkIG9mIHBhc3NpbmcgcHJvZy4gIEl0
IGFsbG93cyBvdGhlcg0KPiB1c2UgY2FzZXMgd2hlbiB0aGUgcHJvZy0+YXV4LT5hdHRhY2hfYnRm
X2lkIG1heSBub3QgYmUgYSB0eXBlZGVmLg0KPiBGb3IgZXhhbXBsZSwgaW4gdGhlIGZ1dHVyZSwg
YSBicGZfcHJvZyBjYW4gYXR0YWNoIHRvDQo+ICJzdHJ1Y3QgdGNwX2Nvbmdlc3Rpb25fb3BzIiBh
bmQgaXRzIGF0dGFjaF9idGZfaWQgaXMNCj4gcG9pbnRpbmcgdG8gdGhlIGJ0Zl9pZCBvZiAic3Ry
dWN0IHRjcF9jb25nZXN0aW9uX29wcyIuDQo+IA0KPiBXaGlsZSBhdCBpdCwgYWxsb3cgYnRmX2N0
eF9hY2Nlc3MgdG8gZGlyZWN0bHkgdGFrZSBhIEJURl9LSU5EX0ZVTkNfUFJPVE8NCj4gYnRmX2lk
LiAgSXQgaXMgdG8gcHJlcGFyZSBmb3IgYSBsYXRlciBwYXRjaCB0aGF0IGRvZXMgbm90IG5lZWQg
YSAidHlwZWRlZiINCj4gdG8gZmlndXJlIG91dCB0aGUgZnVuY19wcm90by4gIEZvciBleGFtcGxl
LCB3aGVuIGF0dGFjaGluZyBhIGJwZl9wcm9nDQo+IHRvIGFuIG9wcyBpbiAic3RydWN0IHRjcF9j
b25nZXN0aW9uX29wcyIsIHRoZSBmdW5jX3Byb3RvIGNhbiBiZQ0KPiBmb3VuZCBkaXJlY3RseSBi
eSBmb2xsb3dpbmcgdGhlIG1lbWJlcnMgb2YgInN0cnVjdCB0Y3BfY29uZ2VzdGlvbl9vcHMiLg0K
PiANCj4gRm9yIHRoZSBubyB0eXBlZGVmIHVzZSBjYXNlLCB0aGVyZSBpcyBubyBleHRyYSBmaXJz
dCBhcmcuICBIZW5jZSwgdGhpcw0KPiBwYXRjaCBvbmx5IGxpbWl0cyB0aGUgc2tpcCBhcmcgbG9n
aWMgdG8gcmF3X3RwIG9ubHkuDQo+IA0KPiBTaW5jZSBhIEJURl9LSU5EX0ZVTkNfUFJPVE8gdHlw
ZSBkb2VzIG5vdCBoYXZlIGEgbmFtZSAoaS5lLiAiKGFub24pIiksDQo+IGFuIG9wdGlvbmFsIG5h
bWUgYXJnIGlzIGFkZGVkIGFsc28uICBJZiBzcGVjaWZpZWQsIHRoaXMgbmFtZSB3aWxsIGJlIHVz
ZWQNCj4gaW4gdGhlIGJwZl9sb2coKSBtZXNzYWdlIGluc3RlYWQgb2YgdGhlIHR5cGUncyBuYW1l
IG9idGFpbmVkIGZyb20gYnRmX2lkLg0KPiBGb3IgZXhhbXBsZSwgdGhlIGZ1bmN0aW9uIHBvaW50
ZXIgbWVtYmVyIG5hbWUgb2YNCj4gInN0cnVjdCB0Y3BfY29uZ2VzdGlvbl9vcHMiIGNhbiBiZSB1
c2VkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFydGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29t
Pg0KDQouLi4NCg0KPiArc3RhdGljIGJvb2wgYnRmX3R5cGVfaXNfdHlwZWRlZihjb25zdCBzdHJ1
Y3QgYnRmX3R5cGUgKnQpDQo+ICt7DQo+ICsJcmV0dXJuIEJURl9JTkZPX0tJTkQodC0+aW5mbykg
PT0gQlRGX0tJTkRfVFlQRURFRjsNCj4gK30NCg0KeWVhaC4gSSB3YXMgdG8gbGF6eSB0byBhZGQg
aXQuIFRoYW5rcyBmb3IgZG9pbmcgdGhpcyBjbGVhbnVwLg0KDQo+IEBAIC0zNDU5LDM3ICszNDY0
LDQ5IEBAIGJvb2wgYnRmX2N0eF9hY2Nlc3MoaW50IG9mZiwgaW50IHNpemUsIGVudW0gYnBmX2Fj
Y2Vzc190eXBlIHR5cGUsDQo+ICAgCX0NCj4gICANCj4gICAJdCA9IGJ0Zl90eXBlX2J5X2lkKGJ0
Zl92bWxpbnV4LCBidGZfaWQpOw0KPiAtCWlmICghdCB8fCBCVEZfSU5GT19LSU5EKHQtPmluZm8p
ICE9IEJURl9LSU5EX1RZUEVERUYpIHsNCj4gKwlpZiAoIXQgfHwgKCFidGZfdHlwZV9pc190eXBl
ZGVmKHQpICYmICFidGZfdHlwZV9pc19mdW5jX3Byb3RvKHQpKSkgew0KPiAgIAkJYnBmX2xvZyhs
b2csICJidGZfaWQgaXMgaW52YWxpZFxuIik7DQo+ICAgCQlyZXR1cm4gZmFsc2U7DQo+ICAgCX0N
Cj4gICANCj4gICAJdG5hbWUgPSBfX2J0Zl9uYW1lX2J5X29mZnNldChidGZfdm1saW51eCwgdC0+
bmFtZV9vZmYpOw0KPiAtCWlmIChzdHJuY21wKHByZWZpeCwgdG5hbWUsIHNpemVvZihwcmVmaXgp
IC0gMSkpIHsNCj4gLQkJYnBmX2xvZyhsb2csICJidGZfaWQgcG9pbnRzIHRvIHdyb25nIHR5cGUg
bmFtZSAlc1xuIiwgdG5hbWUpOw0KPiAtCQlyZXR1cm4gZmFsc2U7DQo+ICsJaWYgKGJ0Zl90eXBl
X2lzX3R5cGVkZWYodCkpIHsNCg0KVGhpcyBjaGVjayBjYW5ub3QgYmUgZG9uZSBjb25kaXRpb25h
bGx5Lg0KT3RoZXJ3aXNlIHJhd190cCBicGYgcHJvZyB3aXRoIHBhcnRpYWxseSAiaW52YWxpZCIg
YXR0YWNoX2J0Zl9pZA0Kd2lsbCBzdWNjZXNzZnVsbHkgbG9hZCwgYnV0IHdpbGwgZmFpbCB0byBh
dHRhY2ggdG8gcmF3X3RwDQppbiByYXdfdHBfb3BlbiBjb21tYW5kLg0KSSB0aGluayBiZXR0ZXIg
d2F5IGlzIHRvIG1vdmUgdGhpcyBjaGVjayBlYXJseSBpbnRvIHRoZSB2ZXJpZmllci4NClRoYXQg
d2lsbCBzcGVlZCB1cCB0aGlzIGZ1bmN0aW9uIGFzIHdlbGwgdGhhdCBpcyBjYWxsZWQNCm11bHRp
cGxlIHRpbWVzIGZvciBldmVyIGN0eCBhY2Nlc3MgaW4gdGhlIHByb2cuDQpUaGFua3MhDQo=
