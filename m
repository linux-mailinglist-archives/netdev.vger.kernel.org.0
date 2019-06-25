Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F0152054
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfFYBWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:22:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4160 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbfFYBWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 21:22:38 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P1DNAo030401;
        Mon, 24 Jun 2019 18:22:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=grzfR8S8bvhn+VfZNx/MYt1nBa1Zzw4eNAvzdKsbVIU=;
 b=crhS8yhPF11Oht0SGBM2FYutdcBGX8L3w/1B7DBHa3EJLple07YzY8l9mDCBp+CwEWH1
 /mYI9SPFhaRoWv5cMUanaUSMyyYBM1PQaAAAy5dDZoDigmpy/Fq7gI9ZhlbpXQwUJTHC
 ILvRHLdOuZ5zRud7et85YCTNxzR9de2qukw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2taxvpjn6t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 18:22:16 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 24 Jun 2019 18:22:13 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 24 Jun 2019 18:22:13 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 18:22:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grzfR8S8bvhn+VfZNx/MYt1nBa1Zzw4eNAvzdKsbVIU=;
 b=UD1vryvfVEVtUvw7J4WpPpcR9RnPNbVBwVr2i4tGm+zA7MPXhVwTPPUIJGS3Pm2oPD7Z0Wul1kdOfUeOjBe7laGyirWlwlQvSr9Sy56IeZCCzcKMA8IIMPIxGEyU0eoLY3uYQx5W/Qu85HLam2y5xWbrHq8m2hda4AoBWUjq3HA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2391.namprd15.prod.outlook.com (52.135.198.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 01:22:12 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 01:22:12 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Topic: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Index: AQHVKIFy6hPwND0Mwky2apMHopnX+aaq33qAgAB9YoCAAAbxAIAAB5SAgAAPW4CAAArHgIAAAXUAgAACSYD//410AIAAd2UAgAAJsYA=
Date:   Tue, 25 Jun 2019 01:22:12 +0000
Message-ID: <c0dbf0d4-900f-6372-f0e4-1ed8cc7b374b@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
 <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
 <20190624145111.49176d8e@cakuba.netronome.com>
 <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
 <20190624154309.5ef3357b@cakuba.netronome.com>
 <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
 <20190624171641.73cd197d@cakuba.netronome.com>
 <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
 <20190624173005.06430163@cakuba.netronome.com>
 <01c2c76b-5a45-aab0-e698-b5a66ab6c2e7@fb.com>
 <20190624174726.2dda122b@cakuba.netronome.com>
In-Reply-To: <20190624174726.2dda122b@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0006.namprd14.prod.outlook.com
 (2603:10b6:300:ae::16) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:d5ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 718ed8e4-2f3d-45e3-1ca4-08d6f90b8c83
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2391;
x-ms-traffictypediagnostic: BYAPR15MB2391:
x-microsoft-antispam-prvs: <BYAPR15MB23913643198BE6C55950C60AD7E30@BYAPR15MB2391.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(396003)(376002)(136003)(199004)(189003)(86362001)(76176011)(256004)(14444005)(6916009)(6436002)(6512007)(486006)(2616005)(476003)(6486002)(186003)(229853002)(99286004)(54906003)(6506007)(52116002)(386003)(53546011)(53936002)(102836004)(316002)(11346002)(14454004)(6116002)(66476007)(64756008)(66446008)(66556008)(73956011)(66946007)(68736007)(446003)(2906002)(478600001)(7736002)(4326008)(31686004)(25786009)(36756003)(5660300002)(305945005)(8936002)(71190400001)(71200400001)(6246003)(31696002)(81156014)(8676002)(81166006)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2391;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Scrr/im9MDs1vbr163QRMg1Lv9weDbx2FGdYODAaEZaaMLDRZS1SuEB9C79QGtm8cs130YxYwsFY8fr10CP65auXZqnZ6ndQ3PyzJRP99SCSis08WyIsbQWw1k2BBDdEUo7K0kJgKsCszzYFpgRxaCWBH4ZxG0g+ThImfgAPunokfOGYNCe8J20PwLH+AyRUnNE8q1TD4U9H7vvM3O396TLurju9NlRXKk5fWh1McfDfq6XZM6Kq+ULEaa/qph7JedoXKs1bjroIghJSLyG7wogqDXnKwvuqXKCYPZls2vzB++2UnY5SLtbgLVr+wSgWyMjFck/ZfH3WLHQV34lSZgFbiTyQDEDMugKaAAq4RAFZtM2vwbUjt/9XW9jiDp5YZZ8aII0jFMaZRkRpOwcvTyf5eRxz8TibHLa5W9tjSY4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10CCC12E8A12CB4D92B495FA71691C54@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 718ed8e4-2f3d-45e3-1ca4-08d6f90b8c83
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 01:22:12.0311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2391
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=865 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNC8xOSA1OjQ3IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVHVlLCAyNSBK
dW4gMjAxOSAwMDo0MDowOSArMDAwMCwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gT24g
Ni8yNC8xOSA1OjMwIFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+PiBPbiBUdWUsIDI1IEp1
biAyMDE5IDAwOjIxOjU3ICswMDAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+Pj4+IE9u
IDYvMjQvMTkgNToxNiBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+Pj4+PiBPbiBNb24sIDI0
IEp1biAyMDE5IDIzOjM4OjExICswMDAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+Pj4+
Pj4gSSBkb24ndCB0aGluayB0aGlzIHBhdGNoIHNob3VsZCBiZSBwZW5hbGl6ZWQuDQo+Pj4+Pj4g
SSdkIHJhdGhlciBzZWUgd2UgZml4IHRoZW0gYWxsLg0KPj4+Pj4NCj4+Pj4+IFNvIHdlIGFyZSBn
b2luZyB0byBhZGQgdGhpcyBicm9rZW4gb3B0aW9uIGp1c3QgdG8gcmVtb3ZlIGl0Pw0KPj4+Pj4g
SSBkb24ndCB1bmRlcnN0YW5kLg0KPj4+Pj4gSSdtIGhhcHB5IHRvIHNwZW5kIHRoZSAxNSBtaW51
dGVzIHJld3JpdGluZyB0aGlzIGlmIHlvdSBkb24ndA0KPj4+Pj4gd2FudCB0byBwZW5hbGl6ZSBU
YWtzaGFrLg0KPj4+Pg0KPj4+PiBobW0uIEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGUgJ2Jyb2tlbicg
cGFydC4NCj4+Pj4gVGhlIG9ubHkgaXNzdWUgSSBzZWUgdGhhdCBpdCBjb3VsZCBoYXZlIGJlZW4g
bG9jYWwgdnMgZ2xvYmFsLA0KPj4+PiBidXQgdGhleSBhbGwgc2hvdWxkIGhhdmUgYmVlbiBsb2Nh
bC4NCj4+Pg0KPj4+IEkgZG9uJ3QgdGhpbmsgYWxsIG9mIHRoZW0uICBPbmx5IC0tbWFwY29tcGF0
IGFuZCAtLWJwZmZzLiAgYnBmZnMgY291bGQNCj4+PiBiZSBhcmd1ZWQuICBPbiBtYXBjb21wYXQg
SSBtdXN0IGhhdmUgbm90IHJlYWQgdGhlIHBhdGNoIGZ1bGx5LCBJIHdhcw0KPj4+IHVuZGVyIHRo
ZSBpbXByZXNzaW9uIGl0cyBhIGdsb2JhbCBsaWJicGYgZmxhZyA6KA0KPj4+DQo+Pj4gLS1qc29u
LCAtLXByZXR0eSwgLS1ub21vdW50LCAtLWRlYnVnIGFyZSBnbG9iYWwgYmVjYXVzZSB0aGV5IGFm
ZmVjdA0KPj4+IGdsb2JhbCBiZWhhdmlvdXIgb2YgYnBmdG9vbC4gIFRoZSBkaWZmZXJlbmNlIGhl
cmUgaXMgdGhhdCB3ZSBiYXNpY2FsbHkNCj4+PiBhZGQgYSBzeXNjYWxsIHBhcmFtZXRlciBhcyBh
IGdsb2JhbCBvcHRpb24uDQo+Pg0KPj4gc3VyZS4gSSBvbmx5IGRpc2FncmVlZCBhYm91dCBub3Qg
dG91Y2hpbmcgb2xkZXIgZmxhZ3MuDQo+PiAtLWVmZmVjdGl2ZSBzaG91bGQgYmUgbG9jYWwuDQo+
PiBJZiBmb2xsb3cgdXAgcGF0Y2ggbWVhbnMgOTAlIHJld3JpdGUgdGhlbiByZXZlcnQgaXMgYmV0
dGVyLg0KPj4gSWYgaXQncyAxMCUgZml4dXAgdGhlbiBpdCdzIGRpZmZlcmVudCBzdG9yeS4NCj4g
DQo+IEkgc2VlLiAgVGhlIGxvY2FsIGZsYWcgd291bGQgbm90IGFuIG9wdGlvbiBpbiBnZXRvcHRf
bG9uZygpIHNlbnNlLCB3aGF0DQo+IEkgd2FzIHRoaW5raW5nIHdhcyBhYm91dCBhZGRpbmcgYW4g
ImVmZmVjdGl2ZSIga2V5d29yZDoNCj4gDQo+ICMgYnBmdG9vbCAtZSBjZ3JvdXAgc2hvdyAvc3lz
L2ZzL2Nncm91cC9jZ3JvdXAtdGVzdC13b3JrLWRpci9jZzEvDQo+IA0KPiBiZWNvbWVzOg0KPiAN
Cj4gIyBicGZ0b29sIGNncm91cCBzaG93IC9zeXMvZnMvY2dyb3VwL2Nncm91cC10ZXN0LXdvcmst
ZGlyL2NnMS8gZWZmZWN0aXZlDQo+IA0KPiBUaGF0J3MgaG93IHdlIGhhbmRsZSBmbGFncyBmb3Ig
dXBkYXRlIGNhbGxzIGZvciBpbnN0YW5jZS4uDQo+IA0KPiBTbyBJIHRoaW5rIGEgcmV2ZXJ0IDoo
DQoNCmZhaXIgZW5vdWdoLg0KcmVtb3ZlZCBpdCBhbmQgZm9yY2UgcHVzaGVkIGJwZi1uZXh0Lg0K
DQo=
