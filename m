Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8B7283F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfGXGbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:31:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfGXGba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:31:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6O6MnAZ032736;
        Tue, 23 Jul 2019 23:31:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9InBMBEX3dZx6e71vixLsMXJWngsKpeOSDu4CZFJ3JM=;
 b=m9ZRFNqIGiNUBBI+hAqvL5v4e2KCtbvTpUf0QP7t0RKZHFiR9N+5XBbyvNLY5X+qs2nr
 uwSXe/MOp99wMNwbhDnDtdpOtBfcY2XdIRxMozYYGcxUoQUwhXMS+TRflfNYz4g942Ps
 wVAuDD+m8kYiZELHYopqOrCnLkl4bf1hFao= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2txcwagxxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jul 2019 23:31:02 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 23:31:00 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 23:31:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0QYV5AzLcnj2urhnVNR1s7uPV1j95RiwYdCKqzBShWyA2hcY+s+7u/pe5aELcskqPps54V0+ENy2rOvJOF7/Yr2Pc0jLEDuJPjTdATB7/ZaFNYmy1b/Heq7JJlZjEg+Age8o3hQ26HvX+LgM4fcAVx1cK9Obvit9W94G6JEawV/kYyROGlaCHc8lTSGaBeP3TAAXsL+CTGshNa35U9Rh0sUxi28+uKTQL1J1XMve9PbKEQoOQui79xZOxBW5d4En5gnhPDNI2rtWd/nHWwqRJfRrDuxtfb1nuEriTTWEOClxxeveZTPTAN265x5duyAVEgjmnqO1qwnRcTuoz/Vew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9InBMBEX3dZx6e71vixLsMXJWngsKpeOSDu4CZFJ3JM=;
 b=amisgaUXUyiJps6x/hXLXoROVTrDxkeQjX/4KzVOCdkrUEmHq0QNb7Gj98Nt/FU/mQLyOwH0CLNNG/sqau06IJBOMuXghBlIyveW43PFty8DahyhmITYOtQEKZN5y3b/6fhrJQiEObOYd2RlK7nHCsVPQkXq4P6EfxmRicUf9czfCtbL2uEa9jbBWz08WQ6vkkOA9TMeesSKWlzmoWrbUvboV1xuhHUetpsf+5ykEGTvrCwppx5n0aA6KV4Dd+nBu0P1Pg/yt1PM4yMXqtrZEGrTNrKrWfHy6PYq6VsUk6sEZVd+QBX2n5SGalA6a7eaTP0Q6cX/+M3IZnUp0CCqIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9InBMBEX3dZx6e71vixLsMXJWngsKpeOSDu4CZFJ3JM=;
 b=Zwp26m1Hd8PvdfYBitjq2y9rdalJvcFvQX0kY0I4qi8+aRi7nanGRSILfRsfLmTKwyqPSa/yu4KVFzy9qH7P4YSgRk6P+7d5xzW5GhLIc6vWOXblDumR8YMtTkHMu3AONjZ4v4ALtJWeMVC64WBbnX/CHaBIOA2Np8tPPqAR3nI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1326.namprd15.prod.outlook.com (10.175.4.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 06:30:58 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Wed, 24 Jul 2019
 06:30:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAA==
Date:   Wed, 24 Jul 2019 06:30:58 +0000
Message-ID: <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
In-Reply-To: <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:87bf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5181e40e-1b3c-40da-cd71-08d710007d74
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1326;
x-ms-traffictypediagnostic: MWHPR15MB1326:
x-microsoft-antispam-prvs: <MWHPR15MB1326D607EE64A986C32C27FAB3C60@MWHPR15MB1326.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(51444003)(51914003)(6506007)(6916009)(102836004)(53936002)(229853002)(186003)(53546011)(46003)(57306001)(33656002)(6436002)(2906002)(76176011)(5660300002)(305945005)(476003)(6246003)(6512007)(8676002)(446003)(6116002)(68736007)(2616005)(11346002)(6486002)(561944003)(7736002)(50226002)(71200400001)(71190400001)(8936002)(66476007)(66946007)(81166006)(76116006)(66446008)(81156014)(66556008)(64756008)(256004)(478600001)(36756003)(486006)(14454004)(99286004)(86362001)(7416002)(4326008)(316002)(5024004)(14444005)(54906003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1326;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z36XzbpczlLlwjRD0LwNIh/4rmUXLdVfwdIDRaWQR+uAVDvLvpCpE4nN/Lh1jtCOf0XjNSfOzEl8Mqb3hebgF/bvipuWZTz0wSjrpoCxXXlh4CtCUfym4Ycf1XU3bQ8Y2IWOnLC8mfrIP5HTSpt3qbCsKA4/IKF0XkdUxKUfbSEn8L/vhcfjo1Z5OQaUV4ETih3yandEGbkYBqQOIVJ+SHf9QNv2D89YPThP/RDhV4AoVaucpPmN5HJ8/3LL98vkjYQvO6YaVxxLrbbb5v95GcKUobdjwwOobFjSn6c1urwod3EMRF8y83RJsrXWAgDwR/KnOhN7uRZY1c8TGlqE64522jtV2GHoQ1mmuvOFb496LxYODMSGtr/pHuMIcWAi/qivISia7zk/e1m0OQUM3Ao4G2XosBA00MM4ijE/hyk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFB0CEDB4E2B584EB66CE08BF2DDEB8F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5181e40e-1b3c-40da-cd71-08d710007d74
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 06:30:58.5173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1326
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240072
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVsIDIzLCAyMDE5LCBhdCA2OjQwIFBNLCBBbmR5IEx1dG9taXJza2kgPGx1dG9A
YW1hY2FwaXRhbC5uZXQ+IHdyb3RlOg0KPiANCj4gDQo+IA0KPj4gT24gSnVsIDIzLCAyMDE5LCBh
dCAzOjU2IFBNLCBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPiB3cm90ZToNCj4+IA0K
Pj4gDQo+PiANCj4+PiBPbiBKdWwgMjMsIDIwMTksIGF0IDg6MTEgQU0sIEFuZHkgTHV0b21pcnNr
aSA8bHV0b0BrZXJuZWwub3JnPiB3cm90ZToNCj4+PiANCj4+PiBPbiBNb24sIEp1bCAyMiwgMjAx
OSBhdCAxOjU0IFBNIFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+IHdyb3RlOg0KPj4+
PiANCj4+Pj4gSGkgQW5keSwgTG9yZW56LCBhbmQgYWxsLA0KPj4+PiANCj4+Pj4+IE9uIEp1bCAy
LCAyMDE5LCBhdCAyOjMyIFBNLCBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz4gd3Jv
dGU6DQo+Pj4+PiANCj4+Pj4+IE9uIFR1ZSwgSnVsIDIsIDIwMTkgYXQgMjowNCBQTSBLZWVzIENv
b2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4gd3JvdGU6DQo+Pj4+Pj4gDQo+Pj4+Pj4+IE9uIE1v
biwgSnVsIDAxLCAyMDE5IGF0IDA2OjU5OjEzUE0gLTA3MDAsIEFuZHkgTHV0b21pcnNraSB3cm90
ZToNCj4+Pj4+Pj4gSSB0aGluayBJJ20gdW5kZXJzdGFuZGluZyB5b3VyIG1vdGl2YXRpb24uICBZ
b3UncmUgbm90IHRyeWluZyB0byBtYWtlDQo+Pj4+Pj4+IGJwZigpIGdlbmVyaWNhbGx5IHVzYWJs
ZSB3aXRob3V0IHByaXZpbGVnZSAtLSB5b3UncmUgdHJ5aW5nIHRvIGNyZWF0ZQ0KPj4+Pj4+PiBh
IHdheSB0byBhbGxvdyBjZXJ0YWluIHVzZXJzIHRvIGFjY2VzcyBkYW5nZXJvdXMgYnBmIGZ1bmN0
aW9uYWxpdHkNCj4+Pj4+Pj4gd2l0aGluIHNvbWUgbGltaXRzLg0KPj4+Pj4+PiANCj4+Pj4+Pj4g
VGhhdCdzIGEgcGVyZmVjdGx5IGZpbmUgZ29hbCwgYnV0IEkgdGhpbmsgeW91J3JlIHJlaW52ZW50
aW5nIHRoZQ0KPj4+Pj4+PiB3aGVlbCwgYW5kIHRoZSB3aGVlbCB5b3UncmUgcmVpbnZlbnRpbmcg
aXMgcXVpdGUgY29tcGxpY2F0ZWQgYW5kDQo+Pj4+Pj4+IGFscmVhZHkgZXhpc3RzLiAgSSB0aGlu
ayB5b3Ugc2hvdWxkIHRlYWNoIGJwZnRvb2wgdG8gYmUgc2VjdXJlIHdoZW4NCj4+Pj4+Pj4gaW5z
dGFsbGVkIHNldHVpZCByb290IG9yIHdpdGggZnNjYXBzIGVuYWJsZWQgYW5kIHB1dCB5b3VyIHBv
bGljeSBpbg0KPj4+Pj4+PiBicGZ0b29sLiAgSWYgeW91IHdhbnQgdG8gaGFyZGVuIHRoaXMgYSBs
aXR0bGUgYml0LCBpdCB3b3VsZCBzZWVtDQo+Pj4+Pj4+IGVudGlyZWx5IHJlYXNvbmFibGUgdG8g
YWRkIGEgbmV3IENBUF9CUEZfQURNSU4gYW5kIGNoYW5nZSBzb21lLCBidXQNCj4+Pj4+Pj4gbm90
IGFsbCwgb2YgdGhlIGNhcGFibGUoKSBjaGVja3MgdG8gY2hlY2sgQ0FQX0JQRl9BRE1JTiBpbnN0
ZWFkIG9mIHRoZQ0KPj4+Pj4+PiBjYXBhYmlsaXRpZXMgdGhhdCB0aGV5IGN1cnJlbnRseSBjaGVj
ay4NCj4+Pj4+PiANCj4+Pj4+PiBJZiBmaW5lciBncmFpbmVkIGNvbnRyb2xzIGFyZSB3YW50ZWQs
IGl0IGRvZXMgc2VlbSBsaWtlIHRoZSAvZGV2L2JwZg0KPj4+Pj4+IHBhdGggbWFrZXMgdGhlIG1v
c3Qgc2Vuc2UuIG9wZW4sIHJlcXVlc3QgYWJpbGl0aWVzLCB1c2UgZmQuIFRoZSBvcGVuIGNhbg0K
Pj4+Pj4+IGJlIG1lZGlhdGVkIGJ5IERBQyBhbmQgTFNNLiBUaGUgcmVxdWVzdCBjYW4gYmUgbWVk
aWF0ZWQgYnkgTFNNLiBUaGlzDQo+Pj4+Pj4gcHJvdmlkZXMgYSB3YXkgdG8gYWRkIHBvbGljeSBh
dCB0aGUgTFNNIGxldmVsIGFuZCBhdCB0aGUgdG9vbCBsZXZlbC4NCj4+Pj4+PiAoaS5lLiBGb3Ig
dG9vbC1sZXZlbCBjb250cm9sczogbGVhdmUgTFNNIHdpZGUgb3BlbiwgbWFrZSAvZGV2L2JwZiBv
d25lZA0KPj4+Pj4+IGJ5ICJicGZhZG1pbiIgYW5kIGJwZnRvb2wgYmVjb21lcyBzZXR1aWQgImJw
ZmFkbWluIi4gRm9yIGZpbmUtZ3JhaW5lZA0KPj4+Pj4+IGNvbnRyb2xzLCBsZWF2ZSAvZGV2L2Jw
ZiB3aWRlIG9wZW4gYW5kIGFkZCBwb2xpY3kgdG8gU0VMaW51eCwgZXRjLikNCj4+Pj4+PiANCj4+
Pj4+PiBXaXRoIG9ubHkgYSBuZXcgQ0FQLCB5b3UgZG9uJ3QgZ2V0IHRoZSBmaW5lLWdyYWluZWQg
Y29udHJvbHMuIChUaGUNCj4+Pj4+PiAicmVxdWVzdCBhYmlsaXRpZXMiIHBhcnQgaXMgdGhlIGtl
eSB0aGVyZS4pDQo+Pj4+PiANCj4+Pj4+IFN1cmUgeW91IGRvOiB0aGUgZWZmZWN0aXZlIHNldC4g
IEl0IGhhcyBzb21ld2hhdCBiaXphcnJlIGRlZmF1bHRzLCBidXQNCj4+Pj4+IEkgZG9uJ3QgdGhp
bmsgdGhhdCdzIGEgcmVhbCBwcm9ibGVtLiAgQWxzbywgdGhpcyB3b3VsZG4ndCBiZSBsaWtlDQo+
Pj4+PiBDQVBfREFDX1JFQURfU0VBUkNIIC0tIHlvdSBjYW4ndCBhY2NpZGVudGFsbHkgdXNlIHlv
dXIgQlBGIGNhcHMuDQo+Pj4+PiANCj4+Pj4+IEkgdGhpbmsgdGhhdCBhIC9kZXYgY2FwYWJpbGl0
eS1saWtlIG9iamVjdCBpc24ndCB0b3RhbGx5IG51dHMsIGJ1dCBJDQo+Pj4+PiB0aGluayB3ZSBz
aG91bGQgZG8gaXQgd2VsbCwgYW5kIHRoaXMgcGF0Y2ggZG9lc24ndCByZWFsbHkgYWNoaWV2ZQ0K
Pj4+Pj4gdGhhdC4gIEJ1dCBJIGRvbid0IHRoaW5rIGJwZiB3YW50cyBmaW5lLWdyYWluZWQgY29u
dHJvbHMgbGlrZSB0aGlzIGF0DQo+Pj4+PiBhbGwgLS0gYXMgSSBwb2ludGVkIHVwdGhyZWFkLCBh
IGZpbmUtZ3JhaW5lZCBzb2x1dGlvbiByZWFsbHkgd2FudHMNCj4+Pj4+IGRpZmZlcmVudCB0cmVh
dG1lbnQgZm9yIHRoZSBkaWZmZXJlbnQgY2FwYWJsZSgpIGNoZWNrcywgYW5kIGEgYnVuY2ggb2YN
Cj4+Pj4+IHRoZW0gd29uJ3QgcmVzZW1ibGUgY2FwYWJpbGl0aWVzIG9yIC9kZXYvYnBmIGF0IGFs
bC4NCj4+Pj4gDQo+Pj4+IFdpdGggNS4zLXJjMSBvdXQsIEkgYW0gYmFjayBvbiB0aGlzLiA6KQ0K
Pj4+PiANCj4+Pj4gSG93IGFib3V0IHdlIG1vZGlmeSB0aGUgc2V0IGFzOg0KPj4+PiAxLiBJbnRy
b2R1Y2Ugc3lzX2JwZl93aXRoX2NhcCgpIHRoYXQgdGFrZXMgZmQgb2YgL2Rldi9icGYuDQo+Pj4g
DQo+Pj4gSSdtIGZpbmUgd2l0aCB0aGlzIGluIHByaW5jaXBsZSwgYnV0Og0KPj4+IA0KPj4+PiAy
LiBCZXR0ZXIgaGFuZGxpbmcgb2YgY2FwYWJsZSgpIGNhbGxzIHRocm91Z2ggYnBmIGNvZGUuIEkg
Z3Vlc3MgdGhlDQo+Pj4+ICAgYmlnZ2VzdCBwcm9ibGVtIGhlcmUgaXMgaXNfcHJpdiBpbiB2ZXJp
Zmllci5jOmJwZl9jaGVjaygpLg0KPj4+IA0KPj4+IEkgdGhpbmsgaXQgd291bGQgYmUgZ29vZCB0
byB1bmRlcnN0YW5kIGV4YWN0bHkgd2hhdCAvZGV2L2JwZiB3aWxsDQo+Pj4gZW5hYmxlIG9uZSB0
byBkby4gIFdpdGhvdXQgc29tZSBjYXJlLCBpdCB3b3VsZCBqdXN0IGJlY29tZSB0aGUgbmV4dA0K
Pj4+IENBUF9TWVNfQURNSU46IGlmIHlvdSBjYW4gb3BlbiBpdCwgc3VyZSwgeW91J3JlIG5vdCBy
b290LCBidXQgeW91IGNhbg0KPj4+IGludGVyY2VwdCBuZXR3b3JrIHRyYWZmaWMsIG1vZGlmeSBj
Z3JvdXAgYmVoYXZpb3IsIGFuZCBkbyBwbGVudHkgb2YNCj4+PiBvdGhlciB0aGluZ3MsIGFueSBv
ZiB3aGljaCBjYW4gcHJvYmFibHkgYmUgdXNlZCB0byBjb21wbGV0ZWx5IHRha2UNCj4+PiBvdmVy
IHRoZSBzeXN0ZW0uDQo+PiANCj4+IFdlbGwsIHllcy4gc3lzX2JwZigpIGlzIHByZXR0eSBwb3dl
cmZ1bC4gDQo+PiANCj4+IFRoZSBnb2FsIG9mIC9kZXYvYnBmIGlzIHRvIGVuYWJsZSBzcGVjaWFs
IHVzZXJzIHRvIGNhbGwgc3lzX2JwZigpLiBJbiANCj4+IHRoZSBtZWFud2hpbGUsIHN1Y2ggdXNl
cnMgc2hvdWxkIG5vdCB0YWtlIGRvd24gdGhlIHdob2xlIHN5c3RlbSBlYXNpbHkNCj4+IGJ5IGFj
Y2lkZW50LCBlLmcuLCB3aXRoIHJtIC1yZiAvLg0KPiANCj4gVGhhdOKAmXMgZWFzeSwgdGhvdWdo
IOKAlCBicGZ0b29sIGNvdWxkIGxlYXJuIHRvIHJlYWQgL2V0Yy9icGZ1c2VycyBiZWZvcmUgYWxs
b3dpbmcgcnVpZCAhPSAwLg0KDQpUaGlzIGlzIGEgZ3JlYXQgaWRlYSEgZnNjYXBzICsgL2V0Yy9i
cGZ1c2VycyBzaG91bGQgZG8gdGhlIHRyaWNrLiANCg0KPiANCj4+IA0KPj4gSXQgaXMgc2ltaWxh
ciB0byBDQVBfQlBGX0FETUlOLCB3aXRob3V0IHJlYWxseSBhZGRpbmcgdGhlIENBUF8uICANCj4+
IA0KPj4gSSB0aGluayBhZGRpbmcgbmV3IENBUF8gcmVxdWlyZXMgbXVjaCBtb3JlIGVmZm9ydC4g
DQo+PiANCj4gDQo+IEEgbmV3IENBUF8gaXMgc3RyYWlnaHRmb3J3YXJkIOKAlCBhZGQgdGhlIGRl
ZmluaXRpb24gYW5kIGNoYW5nZSB0aGUgbWF4IGNhcC4NCj4gDQo+Pj4gDQo+Pj4gSXQgd291bGQg
YWxzbyBiZSBuaWNlIHRvIHVuZGVyc3RhbmQgd2h5IHlvdSBjYW4ndCBkbyB3aGF0IHlvdSBuZWVk
IHRvDQo+Pj4gZG8gZW50aXJlbHkgaW4gdXNlciBjb2RlIHVzaW5nIHNldHVpZCBvciBmc2NhcHMu
DQo+PiANCj4+IEl0IGlzIG5vdCB2ZXJ5IGVhc3kgdG8gYWNoaWV2ZSB0aGUgc2FtZSBjb250cm9s
OiBvbmx5IGNlcnRhaW4gdXNlcnMgY2FuDQo+PiBydW4gY2VydGFpbiB0b29scyAoYnBmdG9vbCwg
ZXRjLikuIA0KPj4gDQo+PiBUaGUgY2xvc2VzdCBhcHByb2FjaCBJIGNhbiBmaW5kIGlzOg0KPj4g
MS4gdXNlIGxpYmNhcCAocGFtX2NhcCkgdG8gZ2l2ZSBDQVBfU0VUVUlEIHRvIGNlcnRhaW4gdXNl
cnM7DQo+PiAyLiBhZGQgc2V0dWlkKDApIHRvIGJwZnRvb2wuDQo+PiANCj4+IFRoZSBkaWZmZXJl
bmNlIGJldHdlZW4gdGhpcyBhcHByb2FjaCBhbmQgL2Rldi9icGYgaXMgdGhhdCBjZXJ0YWluIHVz
ZXJzDQo+PiB3b3VsZCBiZSBhYmxlIHRvIHJ1biBvdGhlciB0b29scyB0aGF0IGNhbGwgc2V0dWlk
KCkuIFRob3VnaCBJIGFtIG5vdCANCj4+IHN1cmUgaG93IG1hbnkgdG9vbHMgY2FsbCBzZXR1aWQo
KSwgYW5kIGhvdyByaXNreSB0aGV5IGFyZS4gDQo+IA0KPiBJIHRoaW5rIHlvdeKAmXJlIG1pc3Vu
ZGVyc3RhbmRpbmcgbWUuIEluc3RhbGwgYnBmdG9vbCB3aXRoIGVpdGhlciB0aGUgc2V0dWlkIChT
X0lTVUlEKSBtb2RlIG9yIHdpdGggYW4gYXBwcm9wcmlhdGUgZnNjYXAgYml0IOKAlCBzZWUgdGhl
IHNldGNhcCg4KSBtYW5wYWdlLg0KPiANCj4gVGhlIGRvd25zaWRlIG9mIHRoaXMgYXBwcm9hY2gg
aXMgdGhhdCBpdCB3b27igJl0IHdvcmsgd2VsbCBpbiBhIGNvbnRhaW5lciwgYW5kIGNvbnRhaW5l
cnMgYXJlIGNvb2wgdGhlc2UgZGF5cyA6KQ0KPiANCj4+IA0KPj4+IA0KPj4+IEZpbmFsbHksIGF0
IHJpc2sgb2YgcmVoYXNoaW5nIHNvbWUgb2xkIGFyZ3VtZW50cywgSSdsbCBwb2ludCBvdXQgdGhh
dA0KPj4+IHRoZSBicGYoKSBzeXNjYWxsIGlzIGFuIHVudXN1YWwgZGVzaWduIHRvIGJlZ2luIHdp
dGguICBBcyBhbiBleGFtcGxlLA0KPj4+IGNvbnNpZGVyIGJwZl9wcm9nX2F0dGFjaCgpLiAgT3V0
c2lkZSBvZiBicGYoKSwgaWYgSSB3YW50IHRvIGNoYW5nZSB0aGUNCj4+PiBiZWhhdmlvciBvZiBh
IGNncm91cCwgSSB3b3VsZCB3cml0ZSB0byBhIGZpbGUgaW4NCj4+PiAvc3lzL2tlcm5lbC9jZ3Jv
dXAvdW5pZmllZC93aGF0ZXZlci8sIGFuZCBub3JtYWwgREFDIGFuZCBNQUMgcnVsZXMNCj4+PiBh
cHBseS4gIFdpdGggYnBmKCksIGhvd2V2ZXIsIEkganVzdCBjYWxsIGJwZigpIHRvIGF0dGFjaCBh
IHByb2dyYW0gdG8NCj4+PiB0aGUgY2dyb3VwLiAgYnBmKCkgc2F5cyAib2gsIHlvdSBhcmUgY2Fw
YWJsZShDQVBfTkVUX0FETUlOKSAtLSBnbyBmb3INCj4+PiBpdCEiLiAgVW5sZXNzIEkgbWlzc2Vk
IHNvbWV0aGluZyBtYWpvciwgYW5kIEkganVzdCByZS1yZWFkIHRoZSBjb2RlLA0KPj4+IHRoZXJl
IGlzIG5vIGNoZWNrIHRoYXQgdGhlIGNhbGxlciBoYXMgd3JpdGUgb3IgTFNNIHBlcm1pc3Npb24g
dG8NCj4+PiBhbnl0aGluZyBhdCBhbGwgaW4gY2dyb3VwZnMsIGFuZCB0aGUgZXhpc3RpbmcgQVBJ
IHdvdWxkIG1ha2UgaXQgdmVyeQ0KPj4+IGF3a3dhcmQgdG8gaW1wb3NlIGFueSBraW5kIG9mIERB
QyBydWxlcyBoZXJlLg0KPj4+IA0KPj4+IFNvIEkgdGhpbmsgaXQgbWlnaHQgYWN0dWFsbHkgYmUg
dGltZSB0byByZXBheSBzb21lIHRlY2hpbmNhbCBkZWJ0IGFuZA0KPj4+IGNvbWUgdXAgd2l0aCBh
IHJlYWwgZml4LiAgQXMgYSBsZXNzIGludHJ1c2l2ZSBhcHByb2FjaCwgeW91IGNvdWxkIHNlZQ0K
Pj4+IGFib3V0IHJlcXVpcmluZyBvd25lcnNoaXAgb2YgdGhlIGNncm91cCBkaXJlY3RvcnkgaW5z
dGVhZCBvZg0KPj4+IENBUF9ORVRfQURNSU4uICBBcyBhIG1vcmUgaW50cnVzaXZlIGJ1dCBwZXJo
YXBzIGJldHRlciBhcHByb2FjaCwgeW91DQo+Pj4gY291bGQgaW52ZXJ0IHRoZSBsb2dpYyB0byB0
byBtYWtlIGl0IHdvcmsgbGlrZSBldmVyeXRoaW5nIG91dHNpZGUgb2YNCj4+PiBjZ3JvdXA6IGFk
ZCBwc2V1ZG8tZmlsZXMgbGlrZSBicGYuaW5ldF9pbmdyZXNzIHRvIHRoZSBjZ3JvdXANCj4+PiBk
aXJlY3RvcmllcywgYW5kIHJlcXVpcmUgYSB3cml0YWJsZSBmZCB0byAqdGhhdCogdG8gYSBuZXcg
aW1wcm92ZWQNCj4+PiBhdHRhY2ggQVBJLiAgSWYgYSB1c2VyIGNvdWxkIGRvOg0KPj4+IA0KPj4+
IGludCBmZCA9IG9wZW4oIi9zeXMvZnMvY2dyb3VwLy4uLi9icGYuaW5ldF9hdHRhY2giLCBPX1JE
V1IpOyAgLyogdXN1YWwNCj4+PiBEQUMgYW5kIE1BQyBwb2xpY3kgYXBwbGllcyAqLw0KPj4+IGlu
dCBicGZfZmQgPSBzZXR1cCB0aGUgYnBmIHN0dWZmOyAgLyogbm8gcHJpdmlsZWdlIHJlcXVpcmVk
LCB1bmxlc3MNCj4+PiB0aGUgcHJvZ3JhbSBpcyBodWdlIG9yIG5lZWRzIGlzX3ByaXYgKi8NCj4+
PiBicGYoQlBGX0lNUFJPVkVEX0FUVEFDSCwgdGFyZ2V0ID0gZmQsIHByb2dyYW0gPSBicGZfZmQp
Ow0KPj4+IA0KPj4+IHRoZXJlIHdvdWxkIGJlIG5vIGNhcGFiaWxpdGllcyBvciBnbG9iYWwgcHJp
dmlsZWdlIGF0IGFsbCByZXF1aXJlZCBmb3INCj4+PiB0aGlzLiAgSXQgd291bGQganVzdCB3b3Jr
IHdpdGggY2dyb3VwIGRlbGVnYXRpb24sIGNvbnRhaW5lcnMsIGV0Yy4NCj4+PiANCj4+PiBJIHRo
aW5rIHlvdSBjb3VsZCBldmVuIHB1bGwgb2ZmIHRoaXMgdHlwZSBvZiBBUEkgY2hhbmdlIHdpdGgg
b25seQ0KPj4+IGxpYmJwZiBjaGFuZ2VzLiAgSW4gcGFydGljdWxhciwgdGhlcmUncyB0aGlzIGNv
ZGU6DQo+Pj4gDQo+Pj4gaW50IGJwZl9wcm9nX2F0dGFjaChpbnQgcHJvZ19mZCwgaW50IHRhcmdl
dF9mZCwgZW51bSBicGZfYXR0YWNoX3R5cGUgdHlwZSwNCj4+PiAgICAgICAgICAgICAgICAgIHVu
c2lnbmVkIGludCBmbGFncykNCj4+PiB7DQo+Pj4gICAgICB1bmlvbiBicGZfYXR0ciBhdHRyOw0K
Pj4+IA0KPj4+ICAgICAgbWVtc2V0KCZhdHRyLCAwLCBzaXplb2YoYXR0cikpOw0KPj4+ICAgICAg
YXR0ci50YXJnZXRfZmQgICAgID0gdGFyZ2V0X2ZkOw0KPj4+ICAgICAgYXR0ci5hdHRhY2hfYnBm
X2ZkID0gcHJvZ19mZDsNCj4+PiAgICAgIGF0dHIuYXR0YWNoX3R5cGUgICA9IHR5cGU7DQo+Pj4g
ICAgICBhdHRyLmF0dGFjaF9mbGFncyAgPSBmbGFnczsNCj4+PiANCj4+PiAgICAgIHJldHVybiBz
eXNfYnBmKEJQRl9QUk9HX0FUVEFDSCwgJmF0dHIsIHNpemVvZihhdHRyKSk7DQo+Pj4gfQ0KPj4+
IA0KPj4+IFRoaXMgd291bGQgaW5zdGVhZCBkbyBzb21ldGhpbmcgbGlrZToNCj4+PiANCj4+PiBp
bnQgc3BlY2lmaWNfdGFyZ2V0X2ZkID0gb3BlbmF0KHRhcmdldF9mZCwgYnBmX3R5cGVfdG9fdGFy
Z2V0W3R5cGVdLCBPX1JEV1IpOw0KPj4+IGF0dHIudGFyZ2V0X2ZkID0gc3BlY2lmaWNfdGFyZ2V0
X2ZkOw0KPj4+IC4uLg0KPj4+IA0KPj4+IHJldHVybiBzeXNfYnBmKEJQRl9QUk9HX0lNUFJPVkVE
X0FUVEFDSCwgJmF0dHIsIHNpemVvZihhdHRyKSk7DQo+Pj4gDQo+Pj4gV291bGQgdGhpcyBzb2x2
ZSB5b3VyIHByb2JsZW0gd2l0aG91dCBuZWVkaW5nIC9kZXYvYnBmIGF0IGFsbD8NCj4+IA0KPj4g
VGhpcyBnaXZlcyBmaW5lIGdyYWluIGFjY2VzcyBjb250cm9sLiBJIHRoaW5rIGl0IHNvbHZlcyB0
aGUgcHJvYmxlbS4gDQo+PiBCdXQgaXQgYWxzbyByZXF1aXJlcyBhIGxvdCBvZiByZXdvcmsgdG8g
c3lzX2JwZigpLiBBbmQgaXQgbWF5IGFsc28gDQo+PiBicmVhayBiYWNrd2FyZC9mb3J3YXJkIGNv
bXBhdGliaWxpdHk/DQo+PiANCj4gDQo+IEkgdGhpbmsgdGhlIGNvbXBhdGliaWxpdHkgaXNzdWUg
aXMgbWFuYWdlYWJsZS4gVGhlIGN1cnJlbnQgYnBmKCkgaW50ZXJmYWNlIHdvdWxkIGJlIHN1cHBv
cnRlZCBmb3IgYXQgbGVhc3Qgc2V2ZXJhbCB5ZWFycywgYW5kIGxpYmJwZiBjb3VsZCBkZXRlY3Qg
dGhhdCB0aGUgbmV3IGludGVyZmFjZSBpc27igJl0IHN1cHBvcnRlZCBhbmQgZmFsbCBiYWNrIHRo
ZSBvbGQgaW50ZXJmYWNlDQoNCllvdSBhcmUgcmlnaHQuIE5ldyBCUEZfUFJPR19JTVBST1ZFRF9B
VFRBQ0ggaGVscHMgY29tcGF0aWJpbGl0eS4gDQpJIG1pc3NlZCB0aGF0IHBhcnQuIA0KDQo+IA0K
Pj4gUGVyc29uYWxseSwgSSB0aGluayBpdCBpcyBhbiBvdmVya2lsbCBmb3IgdGhlIG9yaWdpbmFs
IG1vdGl2YXRpb246IA0KPj4gY2FsbCBzeXNfYnBmKCkgd2l0aCBzcGVjaWFsIHVzZXIgaW5zdGVh
ZCBvZiByb290LiANCj4gDQo+IEl04oCZcyBvdmVya2lsbCBmb3IgeW91ciBzcGVjaWZpYyB1c2Ug
Y2FzZSwgYnV0IEnigJltIHRyeWluZyB0byBlbmNvdXJhZ2UgeW91IHRvIGVpdGhlciBzb2x2ZSB5
b3VyIHByb2JsZW0gZW50aXJlbHkgaW4gdXNlcnNwYWNlIG9yIHRvIHNvbHZlIGEgbW9yZSBnZW5l
cmFsIHByb2JsZW0gaW4gdGhlIGtlcm5lbCA6KQ0KDQpJIGRvIGxpa2UgYm90aCBwcm9wb3NhbHMu
IFRoYW5rcyBmb3IgdGhlc2UgaW52YWx1YWJsZSBzdWdnZXN0aW9ucy4gDQoNCj4gDQo+IEluIGZ1
cnRoZXJhbmNlIG9mIGJwZuKAmXMgZ29hbCBvZiB3b3JsZCBkb21pbmF0aW9uLCBJIHRoaW5rIGl0
IHdvdWxkIGJlIGdyZWF0IGlmIGl0IEp1c3QgV29ya2VkIGluIGEgY29udGFpbmVyLiBNeSBwcm9w
b3NhbCBkb2VzIHRoaXMuDQoNCkxldCBtZSB0aGluayBtb3JlIGFib3V0IHRoaXMgYW5kIGRpc2N1
c3Mgd2l0aCB0aGUgdGVhbS4gDQoNClRoYW5rcyBhZ2FpbiwgDQpTb25n
