Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A919A7BAE1
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 09:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfGaHpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 03:45:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59068 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbfGaHpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 03:45:12 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V7i8fl008973;
        Wed, 31 Jul 2019 00:44:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=L02jmGCaESxdCPaSBku2X75BLnjX08maH6Nx09ZYhVo=;
 b=iSkUmOTfsUyG+zCOYXR1/gokr6Mg4IxZWZirEF7rqtE3KoRbAC+9DN5cTzjd8rtJkgUJ
 0MmiTP7x+RB+N328PsUuK9At5iYoc6uU6wikoazqOYBzbWTSkWEnnpIw5jM0Sw2uhkpi
 DoIVNCE3f0i+ZFNuJBxhp6ifzFnclyMd1SU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u35byg7st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 00:44:47 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 00:44:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 00:44:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpISKGGiVvW+qclJc/DrMzHRS1A5Fv5x6wWYAAWHKrSJsoYW6lw37Nwfy/+vazjQSqErMGvkNvf/KkED3wRbHaaV2v2mmlMSR2PP3IEmUzmVutHqwNUlPOrgUoxw2jWmbJ+22U2fi0cmIpD5x3AY/uebNdq4mN1XTPKw7qXJGQOWCT4wA3xseAWsfFR+Dyy3oFNSyMVUfD8lXrdj2gKNYaOmGndt8/dhBzpNUE0ql5PlvhOfOG96rOMe8EeC7sdugPbZLr177PN7zw+1YcEc75b7loPNfflX6bZSpe+azMwSc02qfdrk94WyBjeoiYnyrW1xaw8kxD0Ez/r+mI7WIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L02jmGCaESxdCPaSBku2X75BLnjX08maH6Nx09ZYhVo=;
 b=NwF2ovIbrlGEo87dCMJDM5UA3EqJi4PPWQiIxf3eNvmGO1IIW4tJ6i/erUQR3fLbBfgWsGD7WmWj/trAi3uZzPXoial4ND880Atv5mnSyRBGhMjLBG66pHsfNs0I/tZqff7LactT9JAtZ4aYsz8C3asjqtdhvgB5JAwwbPJULU2xZvRruu3FypjbfVkR6TUmDCmI6pX6c4JxH8pB/hyQ/92jd3J3JLwPzywDdCyoRWTqFaoyB9oGPK7fkGd6jIaqaApMetefpP9tdQTrRubjD0SoUsT+YnRwbWgmlRSuMcdusVkrdd5Oih5UVKoqSflzM7Lvg6B0JaEpc3oHynlqVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L02jmGCaESxdCPaSBku2X75BLnjX08maH6Nx09ZYhVo=;
 b=R61+ZPmAr2CZRm20vY7CLI/klrJGolsRT8dmaVWRUgI+kJxLa20aUkjLmtmxUkPaHGkcDnM9c2qjsUWyiGn6lrhMxek58dnAwM9myQ8UNN56PTyWXblmMb3V8FbWxhRYLfqY+sTJsf9rTnCePIKXSvV+R1OFP5v+mPhADJN5wiY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1533.namprd15.prod.outlook.com (10.173.235.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Wed, 31 Jul 2019 07:44:45 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 07:44:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
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
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwAgATYfgCAAL9EAA==
Date:   Wed, 31 Jul 2019 07:44:44 +0000
Message-ID: <B167C8E2-76B9-4FAF-9903-2C3C0D7CB329@fb.com>
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
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
 <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <CALCETrVS5FwtmTyspyg-UNoZTHes9wUNbbsvNYwQwXUUfrtaiQ@mail.gmail.com>
In-Reply-To: <CALCETrVS5FwtmTyspyg-UNoZTHes9wUNbbsvNYwQwXUUfrtaiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6d8b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50c0d83c-e18d-4a42-7c93-08d7158af498
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1533;
x-ms-traffictypediagnostic: MWHPR15MB1533:
x-microsoft-antispam-prvs: <MWHPR15MB15337F20ADF73B235B08187BB3DF0@MWHPR15MB1533.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(4326008)(36756003)(256004)(5024004)(14444005)(86362001)(25786009)(6486002)(8936002)(186003)(14454004)(57306001)(68736007)(6246003)(316002)(7416002)(6916009)(54906003)(99286004)(53546011)(50226002)(76176011)(6506007)(478600001)(102836004)(6116002)(6512007)(5660300002)(561944003)(305945005)(7736002)(11346002)(476003)(81166006)(2616005)(33656002)(81156014)(229853002)(446003)(8676002)(66476007)(53936002)(66556008)(64756008)(486006)(66446008)(66946007)(46003)(76116006)(6436002)(2906002)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1533;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iYpDXC+cJhtvdccZdzuMkrx0voZrVtdox2SFxptbEmtdfsI+M4ZYGvblmGirqjHf0M7MdDcMO/6yA3Iy/xRh+HousC1coUWh6GEnrh4soxEBH5ChyUqQESJjgUFBJp4PH4SNxPFvxJGDUDoBs9YOdDy/4cr5Zgp1I44W+Fmow1Fn7GeUtFfgrqgXQORot8f5YBinuWXQWRworBhljLDeMDGGoRa0jir1tG1Elyt4mEVkDSLhCr75sclYIdj7ppw5BQNl7cLS+MhTvAKsyR5dVx1HojZPoLmdLgkPYs6e6ZPI0IWOYU5bkuESVeX7WgWGmrnI8xX56M9IO2i65P3xKHqbM0UY5B2Pb0ipdb05I4Ce7DJAu5G8OJhUp/L4ufn6jjauVg1gUHOS+PkD/hxDmzjpgvIfBgrp1PcCtVfHoKg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9122C7C82A47CE43B716A2187D3F1C34@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c0d83c-e18d-4a42-7c93-08d7158af498
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 07:44:44.7166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1533
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310082
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5keSwNCg0KPiBPbiBKdWwgMzAsIDIwMTksIGF0IDE6MjAgUE0sIEFuZHkgTHV0b21pcnNr
aSA8bHV0b0BrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFNhdCwgSnVsIDI3LCAyMDE5IGF0
IDExOjIwIEFNIFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+IHdyb3RlOg0KPj4gDQo+
PiBIaSBBbmR5LA0KPj4gDQo+Pj4+Pj4gDQo+Pj4+PiANCj4+Pj4+IFdlbGwsIHllcy4gc3lzX2Jw
ZigpIGlzIHByZXR0eSBwb3dlcmZ1bC4NCj4+Pj4+IA0KPj4+Pj4gVGhlIGdvYWwgb2YgL2Rldi9i
cGYgaXMgdG8gZW5hYmxlIHNwZWNpYWwgdXNlcnMgdG8gY2FsbCBzeXNfYnBmKCkuIEluDQo+Pj4+
PiB0aGUgbWVhbndoaWxlLCBzdWNoIHVzZXJzIHNob3VsZCBub3QgdGFrZSBkb3duIHRoZSB3aG9s
ZSBzeXN0ZW0gZWFzaWx5DQo+Pj4+PiBieSBhY2NpZGVudCwgZS5nLiwgd2l0aCBybSAtcmYgLy4N
Cj4+Pj4gDQo+Pj4+IFRoYXTigJlzIGVhc3ksIHRob3VnaCDigJQgYnBmdG9vbCBjb3VsZCBsZWFy
biB0byByZWFkIC9ldGMvYnBmdXNlcnMgYmVmb3JlIGFsbG93aW5nIHJ1aWQgIT0gMC4NCj4+PiAN
Cj4+PiBUaGlzIGlzIGEgZ3JlYXQgaWRlYSEgZnNjYXBzICsgL2V0Yy9icGZ1c2VycyBzaG91bGQg
ZG8gdGhlIHRyaWNrLg0KPj4gDQo+PiBBZnRlciBzb21lIGRpc2N1c3Npb25zIGFuZCBtb3JlIHRo
aW5raW5nIG9uIHRoaXMsIEkgaGF2ZSBzb21lIGNvbmNlcm5zDQo+PiB3aXRoIHRoZSB1c2VyIHNw
YWNlIG9ubHkgYXBwcm9hY2guDQo+PiANCj4+IElJVUMsIHlvdXIgcHJvcG9zYWwgZm9yIHVzZXIg
c3BhY2Ugb25seSBhcHByb2FjaCBpcyBsaWtlOg0KPj4gDQo+PiAxLiBicGZ0b29sIChhbmQgb3Ro
ZXIgdG9vbHMpIGNoZWNrIC9ldGMvYnBmdXNlcnMgYW5kIG9ubHkgZG8NCj4+ICAgc2V0dWlkIGZv
ciBhbGxvd2VkIHVzZXJzOg0KPj4gDQo+PiAgICAgICAgaW50IG1haW4oKQ0KPj4gICAgICAgIHsN
Cj4+ICAgICAgICAgICAgICAgIGlmICgvKiB1aWQgaW4gL2V0Yy9icGZ1c2VycyAqLykNCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgc2V0dWlkKDApOw0KPj4gICAgICAgICAgICAgICAgc3lzX2Jw
ZiguLi4pOw0KPj4gICAgICAgIH0NCj4+IA0KPj4gMi4gYnBmdG9vbCAoYW5kIG90aGVyIHRvb2xz
KSBpcyBpbnN0YWxsZWQgd2l0aCBDQVBfU0VUVUlEOg0KPj4gDQo+PiAgICAgICAgc2V0Y2FwIGNh
cF9zZXR1aWQ9ZStwIC9iaW4vYnBmdG9vbA0KPj4gDQo+IA0KPiBZb3UgaGF2ZSB0aGlzIGEgYml0
IGJhY2t3YXJkcy4gIFlvdSB3b3VsZG4ndCB1c2UgQ0FQX1NFVFVJRC4gIFlvdQ0KPiB3b3VsZCB1
c2UgdGhlIHNldHVpZCAqbW9kZSogYml0LCBpLmUuIGNobW9kIDQxMTEgKG9yIDQxMDAgYW5kIHVz
ZSBBQ0xzDQo+IHRvIGZ1cnRoZXIgbG9jayBpdCBkb3duKS4gIE9yIHlvdSBjb3VsZCB1c2Ugc2V0
Y2FwIGNhcF9zeXNfYWRtaW49cCwNCj4gYWx0aG91Z2ggdGhlIGRldGFpbHMgdmFyeS4gIEl0IHdv
a3MgYSBiaXQgbGlrZSB0aGlzOg0KPiANCj4gRmlyc3QsIGlmIHlvdSBhcmUgcnVubmluZyB3aXRo
IGVsZXZhdGVkIHByaXZpbGVnZSBkdWUgdG8gU1VJRCBvcg0KPiBmc2NhcHMsIHRoZSBrZXJuZWwg
YW5kIGdsaWJjIG9mZmVyIHlvdSBhIGRlZ3JlZSBvZiBwcm90ZWN0aW9uOiB5b3UgYXJlDQo+IHBy
b3RlY3RlZCBmcm9tIHB0cmFjZSgpLCBMRF9QUkVMT0FELCBldGMuICBZb3UgYXJlICpub3QqIHBy
b3RlY3RlZA0KPiBmcm9tIHlvdXJzZWxmLiAgRm9yIGV4YW1wbGUsIHlvdSBtYXkgYmUgcnVubmlu
ZyBpbiBhIGNvbnRleHQgaW4gd2hpY2gNCj4gYW4gYXR0YWNrZXIgaGFzIG1hbGljaW91cyB2YWx1
ZXMgaW4geW91ciBlbnZpcm9ubWVudCB2YXJpYWJsZXMsIENXRCwNCj4gZXRjLiAgRG8geW91IG5l
ZWQgdG8gY2FyZWZ1bGx5IGRlY2lkZSB3aGV0aGVyIHlvdSBhcmUgd2lsbGluZyB0byBydW4NCj4g
d2l0aCBlbGV2YXRlZCBwcml2aWxlZ2Ugb24gYmVoYWxmIG9mIHRoZSB1c2VyLCB3aGljaCB5b3Ug
bGVhcm4gbGlrZQ0KPiB0aGlzOg0KPiANCj4gdWlkX3QgcmVhbF91aWQgPSBnZXR1aWQoKTsNCj4g
DQo+IFlvdXIgZGVjaXNpb24gbWF5IG1heSBkZXBlbmQgb24gY29tbWFuZC1saW5lIGFyZ3VtZW50
cyBhcyB3ZWxsIChpLmUuDQo+IHlvdSBtaWdodCB3YW50IHRvIGFsbG93IHRyYWNpbmcgYnV0IG5v
dCBmaWx0ZXJpbmcsIHNheSkuICBPbmNlIHlvdSd2ZQ0KPiBtYWRlIHRoaXMgZGVjaXNpb24sIHRo
ZSBkZXRhaWxzIHZhcnk6DQo+IA0KPiBGb3IgU1VJRCwgeW91IGVpdGhlciBjb250aW51ZSB0byBy
dW4gd2l0aCBldWlkID09IDAsIG9yIHlvdSBkcm9wDQo+IHByaXZpbGVnZSB1c2luZyBzb21ldGhp
bmcgbGlrZToNCj4gDQo+IGlmIChzZXRyZXN1aWQocmVhbF91aWQsIHJlYWxfdWlkLCByZWFsX3Vp
ZCkgIT0gMCkgew0KPiAvKiBvcHRpb25hbGx5IHByaW50IGFuIGVycm9yIHRvIHN0ZGVyciAqLw0K
PiBleGl0KDEpOw0KPiB9DQo+IA0KPiBGb3IgZnNjYXBzLCBpZiB5b3Ugd2FudCB0byBiZSBwcml2
aWxlZ2VkLCB5b3UgdXNlIHNvbWV0aGluZyBsaWtlDQo+IGNhcG5nX3VwZGF0ZSgpOyBjYXBuZ19h
cHBseSgpIHRvIHNldCBDQVBfU1lTX0FETUlOIHRvIGJlIGVmZmVjdGl2ZQ0KPiB3aGVuIHlvdSB3
YW50IHByaXZpbGVnZS4gIElmIHlvdSB3YW50IHRvIGJlIHVucHJpdmlsZWdlZCAoYmVjYXVzZQ0K
PiBicGZ1c2VycyBzYXlzIHNvLCBmb3IgZXhhbXBsZSksIHlvdSBjb3VsZCB1c2UgY2FwbmdfdXBk
YXRlKCkgdG8gZHJvcA0KPiBDQVBfU1lTX0FETUlOIGVudGlyZWx5IGFuZCBzZWUgaWYgdGhlIGNh
bGxzIHN0aWxsIHdvcmsgd2l0aG91dA0KPiBwcml2aWxlZ2UuICBCdXQgdGhpcyBpcyBhIGxpdHRs
ZSBiaXQgYXdrd2FyZCwgc2luY2UgeW91IGRvbid0IGRpcmVjdGx5DQo+IGtub3cgd2hldGhlciB0
aGUgdXNlciB0aGF0IGludm9rZWQgeW91IGluIHRoZSBmaXJzdCBwbGFjZSBoYWQNCj4gQ0FQX1NZ
U19BRE1JTiB0byBiZWdpbiB3aXRoLg0KPiANCj4gSW4gZ2VuZXJhbCwgU1VJRCBpcyBhIGJpdCBl
YXNpZXIgdG8gd29yayB3aXRoLg0KDQpUaGFua3MgYSBsb3QgZm9yIHRoZXNlIGV4cGxhbmF0aW9u
cy4gSSBsZWFybmVkIGEgbG90IHRvZGF5IHZpYSByZWFkaW5nDQp0aGlzIGVtYWlsIGFuZCBHb29n
bGluZy4gDQoNCj4gDQo+PiBUaGlzIGFwcHJvYWNoIGlzIG5vdCBpZGVhbCwgYmVjYXVzZSB3ZSBu
ZWVkIHRvIHRydXN0IHRoZSB0b29sIHRvIGdpdmUNCj4+IGl0IENBUF9TRVRVSUQuIEEgaGFja2Vk
IHRvb2wgY291bGQgZWFzaWx5IGJ5cGFzcyAvZXRjL2JwZnVzZXJzIGNoZWNrDQo+PiBvciB1c2Ug
b3RoZXIgcm9vdCBvbmx5IHN5cyBjYWxscyBhZnRlciBzZXR1aWQoMCkuDQo+IA0KPiBIb3c/ICBU
aGUgd2hvbGUgU1VJRCBtZWNoYW5pc20gaXMgZGVzaWduZWQgZmFpcmx5IGNhcmVmdWxseSB0byBw
cmV2ZW50DQo+IHRoaXMuICAvYmluL3N1ZG8gaXMgbGlrZWx5IHRvIGJlIFNVSUQgb24geW91ciBz
eXN0ZW0sIGJ1dCB5b3UgY2FuJ3QNCj4ganVzdCAiaGFjayIgaXQgdG8gYmVjb21lIHJvb3QuDQoN
CkkgZ3Vlc3MgImhhY2tlZCIgd2FzIG5vdCB0aGUgcmlnaHQgZGVzY3JpcHRpb24uIEkgc2hvdWxk
IGhhdmUgdXNlZCANCiJidWdneSIgaW5zdGVhZC4gDQoNClNVSUQgbWVjaGFuaXNtIGlzIGdyZWF0
IGZvciBzbWFsbCBhbmQgc29saWQgdG9vbHMsIGxpa2Ugc3VkbywgcGFzc3dkLA0KbW91bnQsIGV0
Yy4gVGhlIHVzZXIgb3Igc3lzIGFkbWluIGNvdWxkIHRydXN0IHRoZSB0b29sIHRvIGFsd2F5cyBk
byB0aGUgDQpyaWdodCB0aGluZy4gT24gdGhlIG90aGVyIGhhbmQsIEkgdGhpbmsgU1VJRCBpcyBu
b3QgaWRlYWwgZm9yIGNvbXBsZXgNCnRvb2xzIHRoYXQgYXJlIHVuZGVyIGhlYXZ5IGRldmVsb3Bt
ZW50LiBBcyB5b3UgbWVudGlvbmVkLCBTVUlEIGRvZXNuJ3QgDQpwcm90ZWN0IGFnYWluc3Qgb25l
c2VsZi4gVGhlcmVmb3JlLCBpdCB3b24ndCBwcm90ZWN0IHRoZSBzeXN0ZW0gZnJvbSANCmJ1Z2d5
IHRvb2wgdGhhdCB1c2VzIFNVSUQgb24gc29tZXRoaW5nIGl0IHNob3VsZCBub3QuIA0KDQpJIHRo
aW5rIFNVSUQgaXMgZ29vZCBmb3IgYnBmdG9vbCwgYmVjYXVzZSBpdCBpcyBlYXN5IHRvIHVzZSBT
VUlEIA0KY29ycmVjdGx5IGluIGJwZnRvb2wuIEJ1dCwgaXQgaXMgbm90IGVhc3kgdG8gdXNlIFNV
SUQgY29ycmVjdGx5IGluIA0Kc3lzdGVtZC4gDQoNCnN5c3RlbWQgYW5kIHNpbWlsYXIgdXNlciBz
cGFjZSBkYWVtb25zIHVzZSBzeXNfYnBmKCkgdG8gbWFuYWdlIGNncm91cCANCmJwZiBwcm9ncmFt
cyBhbmQgbWFwcyAoQlBGX01BUF9UWVBFXypDR1JPVVAqLCBCUEZfUFJPR19UWVBFX0NHUk9VUF8q
LCANCkJQRl9DR1JPVVBfKikuIFRoZSBkYWVtb24gcnVucyBpbiB0aGUgYmFja2dyb3VuZCwgYW5k
IGhhbmRsZXMgdXNlciANCnJlcXVlc3RzIHRvIGF0dGFjaC9kZXRhY2ggQlBGIHByb2dyYW1zLiBJ
ZiB0aGUgZGFlbW9uIHVzZXMgU1VJRCBvciANCnNpbWlsYXIgbWVjaGFuaXNtLCBpdCBoYXMgdG8g
dXNlIGV1aWQgPT0gMCBmb3Igc3lzX2JwZigpLiBIb3dldmVyLCANCnN1Y2ggZGFlbW9ucyBhcmUg
dXN1YWxseSBwcmV0dHkgY29tcGxpY2F0ZWQuIEl0IGlzIG5vdCBlYXN5IHRvIHByb3ZlIA0KdGhl
IGRhZW1vbiB3b24ndCBtaXN1c2UgZXVpZCA9PSAwLiANCg0KRG9lcyB0aGlzIG1ha2Ugc2Vuc2Ug
c28gZmFyPyBJIHdpbGwgZGlzY3VzcyBtb3JlIGFib3V0IGNncm91cCBpbiB0aGUgDQpuZXh0IGVt
YWlsLiANCg0KVGhhbmtzLA0KU29uZw==
