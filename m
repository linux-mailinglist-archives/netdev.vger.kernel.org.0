Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660751045E8
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKTVj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:39:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27056 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbfKTVj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:39:56 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAKLdZKu004371;
        Wed, 20 Nov 2019 13:39:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KwGogDVcc88IAUwyO88fR992LZFFJmUTSkl/vp0t9HY=;
 b=UAdPQfp5aTCph5wFyE12+B2f7G46S8dIsdHqkvs7YnKPZRNHWE0XhkBiZSjhDlCaCer9
 uoGWhf9mnXqrzNJmnz4e002USTm+iJjw0Xp/mf7Mg4gTZkAVdSQUvgn8YWmftDG+dtNl
 pOGEKTP6sqlTsDlVOoMElgWl2voGFYJqpC4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wd63q2nm2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 13:39:37 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 20 Nov 2019 13:39:15 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 20 Nov 2019 13:39:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl2ctqn4064JyeLeMb+K2qpXK6a6G5BONosl0FzBvK8euiroLqJedrxTbgYJ9bKqrAQSo+6i51HLuWjjhCR38h4VjBGMcdT+vBdH9MyvvzNWvorwlr5ZyOtFyS7bzGJboGwe6DAlS3MdYLITOhje3G3NwPUg9xvwNIozLFwjI/4GMk4v+ncSZF52FX0pd3VUuFF2wOhVgdm5ARRMNr1a1gWUmpHIMhNuKzqCkPKL18FzaGL2VwsAfjP1i1N6dydBOw4KQqxppcw17mQLpn/8e4QMJVvB6+XbSaGc2XAh1YOE8fj0jvrjFm019tKmmsCHDsV+qgcydejPYoa590xfIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwGogDVcc88IAUwyO88fR992LZFFJmUTSkl/vp0t9HY=;
 b=MERhsp4hsrBjEeuFhfpi8sUP0hLsm8eGO/JaMI+qYDij0DbqGZTO42aZ1/xxt8UyTwdTu1wNwSqm23zvB/Aq++cTVLySUwvW8GI5SLnuVLhbpMS2DWf8/LLJIpsRZKIKWIrYTqM4tOMpSvf8PhelcFF43fdV2vV1VARhPUimpttLxrAUS5Tz0Gm5+ODt1BqKGAxOSXXYO6sAKonUtcd7V6zlZv4drlxKeJrTNSt/WIHPQzAU2+3Imb4YrDNUarBC+e7oSQ2Y7elb1CjWVsnBoK5Ad8aefxpeLgKvqLCKg40cd9/ASWAV7Qrdbv+SSIy5ujCPKkZlXoHK/GrBZDmemA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwGogDVcc88IAUwyO88fR992LZFFJmUTSkl/vp0t9HY=;
 b=P74SxLRfxbcEh17nnq9WRAptXf3TVbM0qXP2olc1UoAYWC8TKUdYSV0e5fNuBmslUULy2e3tYajm2BAsp58b632HbnBb63ABCkDXWu9dRf+G/KH1FpOsmL3hxiMc06BNrTAtABGlm1i4dSVAqgm5EcZv5Jrwk9iO2o6ecqiBVXU=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2790.namprd15.prod.outlook.com (20.179.158.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Wed, 20 Nov 2019 21:39:14 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 21:39:14 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
Thread-Topic: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
Thread-Index: AQHVnRXP1WCUmtit50O/zE+NHNTys6eR1rKAgAA8PYCAAJK8AIAABJUAgADFMgCAASxFAA==
Date:   Wed, 20 Nov 2019 21:39:13 +0000
Message-ID: <11d4fde2-6cf5-72eb-9c04-b424f7314672@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
 <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com>
 <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
 <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:300:6c::30) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:9773]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb5a405a-a8c0-45ee-82d6-08d76e021644
x-ms-traffictypediagnostic: BYAPR15MB2790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2790A00F8257FFB336785946D74F0@BYAPR15MB2790.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(76176011)(256004)(316002)(8676002)(71200400001)(476003)(2616005)(11346002)(486006)(71190400001)(446003)(52116002)(6506007)(102836004)(31696002)(36756003)(14454004)(186003)(99286004)(478600001)(53546011)(386003)(25786009)(8936002)(66556008)(64756008)(66446008)(31686004)(4326008)(6246003)(6436002)(7736002)(6486002)(305945005)(81166006)(6916009)(81156014)(229853002)(46003)(54906003)(5660300002)(66476007)(6116002)(86362001)(2906002)(6512007)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2790;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X+51CCSbzliv1XjDqE5s5dOV//92EG1Yeg0+nXTeUjEZeQof8dOjem7T2I9P5foC3bJhs5+vORchXKfltcYKMMzJynwkMn4CpY/4aI0iPIPHfgMBrWfl1jUiyq0By/5H5y/iG8+N+ovF+inTZz3JNxVvhPbOz+FJNe2XGgHHLqzkBjRAq0c/+BXfaMtO+n+R5zrdKTAFeqAhqTbuYtFbiXxf/RwcXw3/XwKqDOc7eCuLESNqK9VxXLV9AuaNuqoWuo4709BBJsRAbu7lHU9zqY5/VxRNNgn4BHY2osY+6LQ8mvfGJJEKqwxnCy0Qv6NHpasdgbBSkRcpUJ9lmeqZ+m/nRKW8Jg75z88UUDPWI1sQMVNTcorGlNbi51Wx9zRQehhcncWhff9071OsAQRdH5jZC/u9yIqBqUDwZw6TL6y1/sGHa6skIqASkkBZ9KGQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <69C08BEF84CECC4ABAE6F29DC1611CAF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cb5a405a-a8c0-45ee-82d6-08d76e021644
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 21:39:13.9902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RKNbtc78GrQurwTosy6hd3EVKn4Mg/eTLPtwyNj3ydIDyXGFpwKevhl8j8SvtKVR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2790
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_07:2019-11-20,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxscore=0 phishscore=0 mlxlogscore=835 suspectscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911200182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTkvMTkgNzo0NCBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBTbywgdG8gc3Vt
bWFyaXplLCB3ZSBwcm9jZWVkIHdpdGggdWludDY0X3QgZm9yIGV2ZXJ5dGhpbmcsIHdpdGggYWRk
ZWQNCj4gYml0cyBvZiB3ZWFrIHZzIHN0cm9uZyBoYW5kbGluZy4gVGhlbiBpbiBwYXJhbGxlbCB3
ZSdsbCB3b3JrIG9uIGFkZGluZw0KPiBCVEYgZm9yIGV4dGVybnMgYW5kIF9fYnVpbHRpbl9leHRl
cm5fcmVzb2x2ZWQgKGFuZCBjb3JyZXNwb25kaW5nIG5ldw0KPiBraW5kIG9mIEJURiByZWxvY2F0
aW9uKSBhbmQgd2lsbCBrZWVwIG1ha2luZyB0aGlzIHdob2xlIEFQSSBldmVuDQo+IGJldHRlciwg
d2hpbGUgYWxyZWFkeSBoYXZpbmcgc29tZXRoaW5nIHVzZWZ1bCBhbmQgZXh0ZW5zaWJsZS4NCg0K
SSBkaWRuJ3Qga25vdyBleHRlcm4gY2FuIGJlIHdlYWsuIFRoYXQgd2FzIGEgZ29vZCBmaW5kLg0K
SW5kZWVkIHVuZGVmaW5lZCBjb25maWdfKiBjYW4gYmUgcmVwcmVzZW50ZWQgYXMgdWludDY0IHpl
cm8gdmFsdWUuDQpCdXQgSSBzdGlsbCBoYXZlIGFuIGlzc3VlIHdpdGggJ3Byb2NlZWQgdWludDY0
X3QgZm9yIGV2ZXJ5dGhpbmcnLA0Kc2luY2Ugc3RyaW5ncyBhbmQgdHJpLXN0YXRlIGRvbid0IGZp
dCBpbnRvIHVpbnQ2NC4NCg0KSG93IGFib3V0IHN0cnRvbCBiZSBhcHBsaWVkIGJ5IGxpYmJwZiBv
bmx5IGZvciB0aGluZ3MgdGhhdCBwYXJzZSANCnN1Y2Nlc3NmdWxseSAobGlrZSBkZWNpbWFsIGFu
ZCBoZXgpIGFuZCBldmVyeXRoaW5nIGVsc2Ugd2lsbCBiZSANCnJlcHJlc2VudGVkIHJhdyA/DQpM
aWtlIENPTkZJRz15IHdpbGwgYmUgMTIxLg0KQ09ORklHPW0gd2lsbCBiZSAxMDkNCkNPTkZJRz0i
YWJjIiB3aWxsIGJlIDB4NjM2MjYxDQpJbiBvdGhlciB3b3JkcyBDT05GSUdfQSBpcyBhbiBhZGRy
ZXNzIGFuZA0KJ2V4dGVybiB3ZWFrIHVpbnQ2NF90IENPTkZJR19BJyByZWFkcyByYXcgYnl0ZXMg
ZnJvbSB0aGF0IGxvY2F0aW9uLg0KV2hlbiB0aGF0IENPTkZJR19BIGlzIHVuZGVmaW5lZCBpbiAv
Ym9vdC9jb25maWcuZ3ogdGhlIHU2NCByZWFkDQpmcm9tIHRoYXQgYWRkcmVzcyB3aWxsIHJldHVy
biB6ZXJvLg0KdTggcmVhZCBmcm9tIHRoYXQgYWRkcmVzcyB3aWxsIHJldHVybiB6ZXJvIHRvby4N
Cg==
