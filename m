Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F12577AF0
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbfG0Rz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:55:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387935AbfG0Rz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:55:29 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RHrF7R002565;
        Sat, 27 Jul 2019 10:55:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IAOCoFvJN02wOS355YnYWk8W1VumYgXFKLTnNe8uc74=;
 b=oilh9ATxX81fOL9TUL2gyGgBsvTL/MkbAOvstp+7IUY/zaq/93RjarRRrURjToBP594A
 /hfgRj97DBJ/qtIPqmBMWDjpEz8WL4+3mH2dxkSKBG+AJeIpk2eMBVrBW32qlj5ohfKC
 GtSz9bZSVGjX689IIqiXrvvPGcaux117rAY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0kqa1374-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 10:55:01 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 10:55:00 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 10:55:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5SoX0TDIC9UhoN7q9lIifFcLmjLWlK7ITPmDNZLPwaTI/oTvJfXqX9IglCaUtFJ+P+chInWUPEk6m3iPHkgC8bMQS4tmeZ6IVNXQuz5pYIdbJqV7f/BvVm3xyxrnommU2GSEbM289aGiAT9Oni2KaH1LXwuPgOyB8tT+sS5azla2clOGIN9d6eIULorUVRGCTUpbEjOvk8qKJEx30WIMC7ZWZUG7Sl0DuambaJL0QGEl0Yek7M9dIatUmaFTdYPfpKxrHmuhGC/L1UjYGe06KGBFHCjfZzXSGW+GLgf9esoxz0c3w6K8vizsDwVmh+ILJmGEkoqrieX2Kks4+zFGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAOCoFvJN02wOS355YnYWk8W1VumYgXFKLTnNe8uc74=;
 b=kr3TCcWCSNi2i4XlRhU966tyYF55EXppko5HUIWNDsiC38zW0Y435gpLdBjCDAj+ZwSnNFBn4MQ1hbEJPQcCMchJ1GECwFFRvsHHCqU1iqJVLHriIylJjbH6kiiMBqkvGjEVZ41nie6wx0CvIO2ow3h4hiM9cOQ75iKaQG7YCquOeo8lUKAgYWW8W647d1gFRalfXT6x26guVzoAlsi2S8DkkHu7RlopeSIFv+ZFP56mA8yhxaWjyQTrEzCJSafpjh9FHhAM+9oXenfk8fyluqA437GoXezHdflh/qDhOA0YHK65wSZQUbGPGJaVvRF8h33MXNpBipVTiUJoK+yXmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAOCoFvJN02wOS355YnYWk8W1VumYgXFKLTnNe8uc74=;
 b=dA96JXG0/nYmV5RXMxJJWEgtsa+LYUXuc2fwd44D4ex2fPgtLC/wUrQWdH3gbzSxKLwZa68N2CrbG2q81GuFfEPR92d5Us8DmborGlaogrS8Giz1dgSo+Ivzv6PFYnEkPJlalM1zA9HDiF3xxTsqWTGs2SAAxISG+esi5uj9OUc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3111.namprd15.prod.outlook.com (20.178.239.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Sat, 27 Jul 2019 17:54:58 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 17:54:58 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Stanislav Fomichev" <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Petar Penkov" <ppenkov@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
Thread-Topic: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
Thread-Index: AQHVQ1QXCeTWaDA0LUe7xenqsSu2v6bb9X6AgAGZs4CAATLxAA==
Date:   Sat, 27 Jul 2019 17:54:58 +0000
Message-ID: <358b01a4-88b9-817d-e9fb-addc472c6c6b@fb.com>
References: <20190724165803.87470-1-brianvv@google.com>
 <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
 <20190725235432.lkptx3fafegnm2et@ast-mbp>
 <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
 <CAADnVQJpp37fXLsu8ZnMFPoC0Uof3roz4gofX0QCewNkwtf-Xg@mail.gmail.com>
 <beb513cb-2d76-30d4-6500-2892c6566a7e@fb.com>
 <CABCgpaVB+iDGO132d9CTtC_GYiKJuuL6pe5_Krm3-THgvfMO=A@mail.gmail.com>
In-Reply-To: <CABCgpaVB+iDGO132d9CTtC_GYiKJuuL6pe5_Krm3-THgvfMO=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0064.namprd08.prod.outlook.com
 (2603:10b6:a03:117::41) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:16cd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1146728-87c2-4f03-f7e7-08d712bb8a5f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3111;
x-ms-traffictypediagnostic: BYAPR15MB3111:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB311123B89847DAE4C0338926D3C30@BYAPR15MB3111.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(396003)(346002)(136003)(199004)(189003)(76176011)(36756003)(446003)(68736007)(52116002)(2616005)(966005)(229853002)(11346002)(54906003)(256004)(25786009)(476003)(6116002)(186003)(14454004)(6916009)(5660300002)(8936002)(81156014)(14444005)(8676002)(486006)(478600001)(99286004)(81166006)(53936002)(6436002)(31696002)(46003)(2906002)(6246003)(6486002)(86362001)(31686004)(316002)(66556008)(66446008)(6512007)(64756008)(66476007)(53546011)(386003)(6506007)(66946007)(6306002)(7416002)(4326008)(102836004)(71200400001)(71190400001)(7736002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3111;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k1gSFnyRTiMHL76ADkqjuAuGCsgTx7zdx1YK7ka0Tx5TyIUNdx5ZHHADm04MaxUPaDHjOp66pHn7r+5PJRMZleyo3Gnvi/7p0Y+yoy/GK3AfGRUsjWKJSBBE71lsncyUWf/b6AgqajshJpdIFoA/xzizlxFnDgXQ9uEq7HTZLDQCdOWgk/oGtenGLi70+lWzcMzNT4OaRMpnKcwWXoIsJ2/Bh2SbfIeJVf9AVy3YcEmUjT/o4nqobSh7YuM6XTVNk/J83P80JEGE2y2Y+g8CQ6L68NCRBJLPbMKLXlRUlkp8rM95LqLVdnAXGnnGiK10AuXwZTs8LUfLx5CbmdVusuYQSD0W2Wbc4I6hgDCHLwO0IGBqRsNCmJ31FcSrPJFeuxuvGnpg9cCw5XB2xuBb+GaVTLC4vzeqrGcwwu3F2UQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A311E3F40C4A0B4F9255E0B9E8C17C86@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e1146728-87c2-4f03-f7e7-08d712bb8a5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 17:54:58.7603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3111
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270225
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjYvMTkgNDozNiBQTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4gT24gVGh1LCBK
dWwgMjUsIDIwMTkgYXQgMTE6MTAgUE0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6
DQo+Pg0KPj4NCj4+DQo+PiBPbiA3LzI1LzE5IDY6NDcgUE0sIEFsZXhlaSBTdGFyb3ZvaXRvdiB3
cm90ZToNCj4+PiBPbiBUaHUsIEp1bCAyNSwgMjAxOSBhdCA2OjI0IFBNIEJyaWFuIFZhenF1ZXog
PGJyaWFudnYua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4+DQo+Pj4+IE9uIFRodSwgSnVs
IDI1LCAyMDE5IGF0IDQ6NTQgUE0gQWxleGVpIFN0YXJvdm9pdG92DQo+Pj4+IDxhbGV4ZWkuc3Rh
cm92b2l0b3ZAZ21haWwuY29tPiB3cm90ZToNCj4+Pj4+DQo+Pj4+PiBPbiBUaHUsIEp1bCAyNSwg
MjAxOSBhdCAwNDoyNTo1M1BNIC0wNzAwLCBCcmlhbiBWYXpxdWV6IHdyb3RlOg0KPj4+Pj4+Pj4+
IElmIHByZXZfa2V5IGlzIGRlbGV0ZWQgYmVmb3JlIG1hcF9nZXRfbmV4dF9rZXkoKSwgd2UgZ2V0
IHRoZSBmaXJzdCBrZXkNCj4+Pj4+Pj4+PiBhZ2Fpbi4gVGhpcyBpcyBwcmV0dHkgd2VpcmQuDQo+
Pj4+Pj4+Pg0KPj4+Pj4+Pj4gWWVzLCBJIGtub3cuIEJ1dCBub3RlIHRoYXQgdGhlIGN1cnJlbnQg
c2NlbmFyaW8gaGFwcGVucyBldmVuIGZvciB0aGUNCj4+Pj4+Pj4+IG9sZCBpbnRlcmZhY2UgKGlt
YWdpbmUgeW91IGFyZSB3YWxraW5nIGEgbWFwIGZyb20gdXNlcnNwYWNlIGFuZCB5b3UNCj4+Pj4+
Pj4+IHRyaWVkIGdldF9uZXh0X2tleSB0aGUgcHJldl9rZXkgd2FzIHJlbW92ZWQsIHlvdSB3aWxs
IHN0YXJ0IGFnYWluIGZyb20NCj4+Pj4+Pj4+IHRoZSBiZWdpbm5pbmcgd2l0aG91dCBub3RpY2lu
ZyBpdCkuDQo+Pj4+Pj4+PiBJIHRyaWVkIHRvIHNlbnQgYSBwYXRjaCBpbiB0aGUgcGFzdCBidXQg
SSB3YXMgbWlzc2luZyBzb21lIGNvbnRleHQ6DQo+Pj4+Pj4+PiBiZWZvcmUgTlVMTCB3YXMgdXNl
ZCB0byBnZXQgdGhlIHZlcnkgZmlyc3Rfa2V5IHRoZSBpbnRlcmZhY2UgcmVsaWVkIGluDQo+Pj4+
Pj4+PiBhIHJhbmRvbSAobm9uIGV4aXN0ZW50KSBrZXkgdG8gcmV0cmlldmUgdGhlIGZpcnN0X2tl
eSBpbiB0aGUgbWFwLCBhbmQNCj4+Pj4+Pj4+IEkgd2FzIHRvbGQgd2hhdCB3ZSBzdGlsbCBoYXZl
IHRvIHN1cHBvcnQgdGhhdCBzY2VuYXJpby4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gQlBGX01BUF9EVU1Q
IGlzIHNsaWdodGx5IGRpZmZlcmVudCwgYXMgeW91IG1heSByZXR1cm4gdGhlIGZpcnN0IGtleQ0K
Pj4+Pj4+PiBtdWx0aXBsZSB0aW1lcyBpbiB0aGUgc2FtZSBjYWxsLiBBbHNvLCBCUEZfTUFQX0RV
TVAgaXMgbmV3LCBzbyB3ZQ0KPj4+Pj4+PiBkb24ndCBoYXZlIHRvIHN1cHBvcnQgbGVnYWN5IHNj
ZW5hcmlvcy4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gU2luY2UgQlBGX01BUF9EVU1QIGtlZXBzIGEgbGlz
dCBvZiBlbGVtZW50cy4gSXQgaXMgcG9zc2libGUgdG8gdHJ5DQo+Pj4+Pj4+IHRvIGxvb2sgdXAg
cHJldmlvdXMga2V5cy4gV291bGQgc29tZXRoaW5nIGRvd24gdGhpcyBkaXJlY3Rpb24gd29yaz8N
Cj4+Pj4+Pg0KPj4+Pj4+IEkndmUgYmVlbiB0aGlua2luZyBhYm91dCBpdCBhbmQgSSB0aGluayBm
aXJzdCB3ZSBuZWVkIGEgd2F5IHRvIGRldGVjdA0KPj4+Pj4+IHRoYXQgc2luY2Uga2V5IHdhcyBu
b3QgcHJlc2VudCB3ZSBnb3QgdGhlIGZpcnN0X2tleSBpbnN0ZWFkOg0KPj4+Pj4+DQo+Pj4+Pj4g
LSBPbmUgc29sdXRpb24gSSBoYWQgaW4gbWluZCB3YXMgdG8gZXhwbGljaXRseSBhc2tlZCBmb3Ig
dGhlIGZpcnN0IGtleQ0KPj4+Pj4+IHdpdGggbWFwX2dldF9uZXh0X2tleShtYXAsIE5VTEwsIGZp
cnN0X2tleSkgYW5kIHdoaWxlIHdhbGtpbmcgdGhlIG1hcA0KPj4+Pj4+IGNoZWNrIHRoYXQgbWFw
X2dldF9uZXh0X2tleShtYXAsIHByZXZfa2V5LCBrZXkpIGRvZXNuJ3QgcmV0dXJuIHRoZQ0KPj4+
Pj4+IHNhbWUga2V5LiBUaGlzIGNvdWxkIGJlIGRvbmUgdXNpbmcgbWVtY21wLg0KPj4+Pj4+IC0g
RGlzY3Vzc2luZyB3aXRoIFN0YW4sIGhlIG1lbnRpb25lZCB0aGF0IGFub3RoZXIgb3B0aW9uIGlz
IHRvIHN1cHBvcnQNCj4+Pj4+PiBhIGZsYWcgaW4gbWFwX2dldF9uZXh0X2tleSB0byBsZXQgaXQg
a25vdyB0aGF0IHdlIHdhbnQgYW4gZXJyb3INCj4+Pj4+PiBpbnN0ZWFkIG9mIHRoZSBmaXJzdF9r
ZXkuDQo+Pj4+Pj4NCj4+Pj4+PiBBZnRlciBkZXRlY3RpbmcgdGhlIHByb2JsZW0gd2UgYWxzbyBu
ZWVkIHRvIGRlZmluZSB3aGF0IHdlIHdhbnQgdG8gZG8sDQo+Pj4+Pj4gaGVyZSBzb21lIG9wdGlv
bnM6DQo+Pj4+Pj4NCj4+Pj4+PiBhKSBSZXR1cm4gdGhlIGVycm9yIHRvIHRoZSBjYWxsZXINCj4+
Pj4+PiBiKSBUcnkgd2l0aCBwcmV2aW91cyBrZXlzIGlmIGFueSAod2hpY2ggYmUgbGltaXRlZCB0
byB0aGUga2V5cyB0aGF0IHdlDQo+Pj4+Pj4gaGF2ZSB0cmF2ZXJzZWQgc28gZmFyIGluIHRoaXMg
ZHVtcCBjYWxsKQ0KPj4+Pj4+IGMpIGNvbnRpbnVlIHdpdGggbmV4dCBlbnRyaWVzIGluIHRoZSBt
YXAuIGFycmF5IGlzIGVhc3kganVzdCBnZXQgdGhlDQo+Pj4+Pj4gbmV4dCB2YWxpZCBrZXkgKHN0
YXJ0aW5nIG9uIGkrMSksIGJ1dCBobWFwIG1pZ2h0IGJlIGRpZmZpY3VsdCBzaW5jZQ0KPj4+Pj4+
IHN0YXJ0aW5nIG9uIHRoZSBuZXh0IGJ1Y2tldCBjb3VsZCBwb3RlbnRpYWxseSBza2lwIHNvbWUg
a2V5cyB0aGF0IHdlcmUNCj4+Pj4+PiBjb25jdXJyZW50bHkgYWRkZWQgdG8gdGhlIHNhbWUgYnVj
a2V0IHdoZXJlIGtleSB1c2VkIHRvIGJlLCBhbmQNCj4+Pj4+PiBzdGFydGluZyBvbiB0aGUgc2Ft
ZSBidWNrZXQgY291bGQgbGVhZCB1cyB0byByZXR1cm4gcmVwZWF0ZWQgZWxlbWVudHMuDQo+Pj4+
Pj4NCj4+Pj4+PiBPciBtYXliZSB3ZSBjb3VsZCBzdXBwb3J0IHRob3NlIDMgY2FzZXMgdmlhIGZs
YWdzIGFuZCBsZXQgdGhlIGNhbGxlcg0KPj4+Pj4+IGRlY2lkZSB3aGljaCBvbmUgdG8gdXNlPw0K
Pj4+Pj4NCj4+Pj4+IHRoaXMgdHlwZSBvZiBpbmRlY2lzaW9uIGlzIHRoZSByZWFzb24gd2h5IEkg
d2Fzbid0IGV4Y2l0ZWQgYWJvdXQNCj4+Pj4+IGJhdGNoIGR1bXBpbmcgaW4gdGhlIGZpcnN0IHBs
YWNlIGFuZCBnYXZlICdzb2Z0IHllcycgd2hlbiBTdGFuDQo+Pj4+PiBtZW50aW9uZWQgaXQgZHVy
aW5nIGxzZi9tbS9icGYgdWNvbmYuDQo+Pj4+PiBXZSBwcm9iYWJseSBzaG91bGRuJ3QgZG8gaXQu
DQo+Pj4+PiBJdCBmZWVscyB0aGlzIG1hcF9kdW1wIG1ha2VzIGFwaSBtb3JlIGNvbXBsZXggYW5k
IGRvZXNuJ3QgcmVhbGx5DQo+Pj4+PiBnaXZlIG11Y2ggYmVuZWZpdCB0byB0aGUgdXNlciBvdGhl
ciB0aGFuIGxhcmdlIG1hcCBkdW1wIGJlY29tZXMgZmFzdGVyLg0KPj4+Pj4gSSB0aGluayB3ZSBn
b3R0YSBzb2x2ZSB0aGlzIHByb2JsZW0gZGlmZmVyZW50bHkuDQo+Pj4+DQo+Pj4+IFNvbWUgdXNl
cnMgYXJlIHdvcmtpbmcgYXJvdW5kIHRoZSBkdW1waW5nIHByb2JsZW1zIHdpdGggdGhlIGV4aXN0
aW5nDQo+Pj4+IGFwaSBieSBjcmVhdGluZyBhIGJwZl9tYXBfZ2V0X25leHRfa2V5X2FuZF9kZWxl
dGUgdXNlcnNwYWNlIGZ1bmN0aW9uDQo+Pj4+IChzZWUgaHR0cHM6Ly91cmxkZWZlbnNlLnByb29m
cG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX193d3cuYm91bmN5Ym91bmN5Lm5ldF9ibG9nX2Jw
Zi01Rm1hcC01RmdldC01Rm5leHQtNUZrZXktMkRwaXRmYWxsc18mZD1Ed0lCYVEmYz01VkQwUlR0
TmxUaDN5Y2Q0MWIzTVV3JnI9REE4ZTFCNXIwNzN2SXFSckZ6N01SQSZtPVh2Tnhxc0RoUmk2Mmd6
WjA0SGJMUlRPRkpYOFg2bVR1SzdQWkduODBha1kmcz03cTdiZVp4T0pKM1EwZWw4TDByLXhEY3Rl
ZFNwbkVlako2UFZYMVhZb3RRJmU9ICkNCj4+Pj4gd2hpY2ggaW4gbXkgb3BpbmlvbiBpcyBhY3R1
YWxseSBhIGdvb2QgaWRlYS4gVGhlIG9ubHkgcHJvYmxlbSB3aXRoDQo+Pj4+IHRoYXQgaXMgdGhh
dCBjYWxsaW5nIGJwZl9tYXBfZ2V0X25leHRfa2V5KGZkLCBrZXksIG5leHRfa2V5KSBhbmQgdGhl
bg0KPj4+PiBicGZfbWFwX2RlbGV0ZV9lbGVtKGZkLCBrZXkpIGZyb20gdXNlcnNwYWNlIGlzIHJh
Y2luZyB3aXRoIGtlcm5lbCBjb2RlDQo+Pj4+IGFuZCBpdCBtaWdodCBsb3NlIHNvbWUgaW5mb3Jt
YXRpb24gd2hlbiBkZWxldGluZy4NCj4+Pj4gV2UgY291bGQgdGhlbiBkbyBtYXBfZHVtcF9hbmRf
ZGVsZXRlIHVzaW5nIHRoYXQgaWRlYSBidXQgaW4gdGhlIGtlcm5lbA0KPj4+PiB3aGVyZSB3ZSBj
b3VsZCBiZXR0ZXIgaGFuZGxlIHRoZSByYWNpbmcgY29uZGl0aW9uLiBJbiB0aGF0IHNjZW5hcmlv
DQo+Pj4+IGV2ZW4gaWYgd2UgcmV0cmlldmUgdGhlIHNhbWUga2V5IGl0IHdpbGwgY29udGFpbiBk
aWZmZXJlbnQgaW5mbyAoIHRoZQ0KPj4+PiBkZWx0YSBiZXR3ZWVuIG9sZCBhbmQgbmV3IHZhbHVl
KS4gV291bGQgdGhhdCB3b3JrPw0KPj4+DQo+Pj4geW91IG1lYW4gZ2V0X25leHQrbG9va3VwK2Rl
bGV0ZSBhdCBvbmNlPw0KPj4+IFNvdW5kcyB1c2VmdWwuDQo+Pj4gWW9uZ2hvbmcgaGFzIGJlZW4g
dGhpbmtpbmcgYWJvdXQgYmF0Y2hpbmcgYXBpIGFzIHdlbGwuDQo+Pg0KPj4gSW4gYmNjLCB3ZSBo
YXZlIG1hbnkgaW5zdGFuY2VzIGxpa2UgdGhpczoNCj4+ICAgICAgZ2V0dGluZyBhbGwgKGtleSB2
YWx1ZSkgcGFpcnMsIGRvIHNvbWUgYW5hbHlzaXMgYW5kIG91dHB1dCwNCj4+ICAgICAgZGVsZXRl
IGFsbCBrZXlzDQo+Pg0KPj4gVGhlIGltcGxlbWVudGF0aW9uIHR5cGljYWxseSBsaWtlDQo+PiAg
ICAgIC8qIHRvIGdldCBhbGwgKGtleSwgdmFsdWUpIHBhaXJzICovDQo+PiAgICAgIHdoaWxlKGJw
Zl9nZXRfbmV4dF9rZXkoKSA9PSAwKQ0KPj4gICAgICAgIGJwZl9tYXBfbG9va3VwKCkNCj4+ICAg
ICAgLyogZG8gYW5hbHlzaXMgYW5kIG91dHB1dCAqLw0KPj4gICAgICBmb3IgKGFsbCBrZXlzKQ0K
Pj4gICAgICAgIGJwZl9tYXBfZGVsZXRlKCkNCj4gDQo+IElmIHlvdSBkbyB0aGF0IGluIGEgbWFw
IHRoYXQgaXMgYmVpbmcgbW9kaWZpZWQgd2hpbGUgeW91IGFyZSBkb2luZyB0aGUNCj4gYW5hbHlz
aXMgYW5kIG91dHB1dCwgeW91IHdpbGwgbG9zZSBzb21lIG5ldyBkYXRhIGJ5IGRlbGV0aW5nIHRo
ZSBrZXlzLA0KPiByaWdodD8NCg0KQWdyZWVkLCBpdCBpcyBwb3NzaWJsZSB0aGF0IGlmIHRoZSBz
YW1lIGtleXMgYXJlIHJldXNlZCB0byBnZW5lcmF0ZSBkYXRhIA0KZHVyaW5nIGFuYWx5c2lzIGFu
ZCBvdXRwdXQgcGVyaW9kLCB3ZSB3aWxsIG1pc3MgdGhlbSBieSBkZWxldGluZyB0aGVtLg0KIEZy
b20gdGhhdCBwZXJzcGVjdGl2ZSwgeW91ciBhYm92ZSBhcHByb2FjaA0KICAgICAgIHdoaWxlIChi
cGZfZ2V0X25leHRfa2V5KCkpDQogICAgICAgICAgIGJwZl9tYXBfZGVsZXRlKHByZXZfa2V5KQ0K
ICAgICAgICAgICBicGZfbWFwX2xvb2t1cCgpDQogICAgICAgICAgIHJlc2V0IHByZXZfa2VleQ0K
c2hvdWxkIHByb3ZpZGUgYSBiZXR0ZXIgYWx0ZXJuYXRpdmUuDQoNCj4gDQo+PiBnZXRfbmV4dCts
b29rdXArZGVsZXRlIHdpbGwgYmUgZGVmaW5pdGVseSB1c2VmdWwuDQo+PiBiYXRjaGluZyB3aWxs
IGJlIGV2ZW4gYmV0dGVyIHRvIHNhdmUgdGhlIG51bWJlciBvZiBzeXNjYWxscy4NCj4+DQo+PiBB
biBhbHRlcm5hdGl2ZSBpcyB0byBkbyBiYXRjaCBnZXRfbmV4dCtsb29rdXAgYW5kIGJhdGNoIGRl
bGV0ZQ0KPj4gdG8gYWNoaWV2ZSBzaW1pbGFyIGdvYWwgYXMgdGhlIGFib3ZlIGNvZGUuDQo+IA0K
PiBXaGF0IEkgbWVudGlvbmVkIGFib3ZlIGlzIHdoYXQgaXQgbWFrZXMgbWUgdGhpbmsgdGhhdCB3
aXRoIHRoZQ0KPiBkZWxldGlvbiBpdCdkIGJlIGJldHRlciBpZiB3ZSBwZXJmb3JtIHRoZXNlIDMg
b3BlcmF0aW9ucyBhdCBvbmNlOg0KPiBnZXRfbmV4dCtsb29rdXArZGVsZXRlIGluIGEganVtYm8v
YXRvbWljIGNvbW1hbmQgYW5kIGJhdGNoIHRoZW0gbGF0ZXI/DQoNCkFncmVlLiBUaGlzIGlzIGlu
ZGVlZCB0aGUgb25lIG1vc3QgdXNlZnVsIGZvciBiY2MgdXNlIGNhc2UgYXMgd2VsbC4NCg0KPiAN
Cj4+DQo+PiBUaGVyZSBpcyBhIG1pbm9yIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGlzIGFwcHJvYWNo
DQo+PiBhbmQgdGhlIGFib3ZlIGdldF9uZXh0K2xvb2t1cCtkZWxldGUuDQo+PiBEdXJpbmcgc2Nh
bm5pbmcgdGhlIGhhc2ggbWFwLCBnZXRfbmV4dCtsb29rdXAgbWF5IGdldCBsZXNzIG51bWJlcg0K
Pj4gb2YgZWxlbWVudHMgY29tcGFyZWQgdG8gZ2V0X25leHQrbG9va3VwK2RlbGV0ZSBhcyB0aGUg
bGF0dGVyDQo+PiBtYXkgaGF2ZSBtb3JlIGxhdGVyLWluc2VydGVkIGhhc2ggZWxlbWVudHMgYWZ0
ZXIgdGhlIG9wZXJhdGlvbg0KPj4gc3RhcnQuIEJ1dCBib3RoIGFyZSBpbmFjY3VyYXRlLCBzbyBw
cm9iYWJseSB0aGUgZGlmZmVyZW5jZQ0KPj4gaXMgbWlub3IuDQo+Pg0KPj4+DQo+Pj4gSSB0aGlu
ayBpZiB3ZSBjYW5ub3QgZmlndXJlIG91dCBob3cgdG8gbWFrZSBhIGJhdGNoIG9mIHR3byBjb21t
YW5kcw0KPj4+IGdldF9uZXh0ICsgbG9va3VwIHRvIHdvcmsgY29ycmVjdGx5IHRoZW4gd2UgbmVl
ZCB0byBpZGVudGlmeS9pbnZlbnQgb25lDQo+Pj4gY29tbWFuZCBhbmQgbWFrZSBiYXRjaGluZyBt
b3JlIGdlbmVyaWMuDQo+Pg0KPj4gbm90IDEwMCUgc3VyZS4gSXQgd2lsbCBiZSBoYXJkIHRvIGRl
ZmluZSB3aGF0IGlzICJjb3JyZWN0bHkiLg0KPiANCj4gSSBhZ3JlZSwgaXQnbGwgYmUgaGFyZCB0
byBkZWZpbmUgd2hhdCBpcyB0aGUgcmlnaHQgYmVoYXZpb3IuDQo+IA0KPj4gRm9yIG5vdCBjaGFu
Z2luZyBtYXAsIGxvb3Bpbmcgb2YgKGdldF9uZXh0LCBsb29rdXApIGFuZCBiYXRjaA0KPj4gZ2V0
X25leHQrbG9va3VwIHNob3VsZCBoYXZlIHRoZSBzYW1lIHJlc3VsdHMuDQo+IA0KPiBUaGlzIGlz
IHRydWUgZm9yIHRoZSBhcGkgSSdtIHByZXNlbnRpbmcgdGhlIG9ubHkgdGhpbmsgdGhhdCBJIHdh
cw0KPiBtaXNzaW5nIHdhcyB3aGF0IHRvIGRvIGZvciBjaGFuZ2luZyBtYXBzIHRvIGF2b2lkIHRo
ZSB3ZWlyZCBzY2VuYXJpbw0KPiAoZ2V0dGluZyB0aGUgZmlyc3Qga2V5IGR1ZSBhIGNvbmN1cnJl
bnQgZGVsZXRpb24pLiBBbmQsIGluIG15IG9waW5pb24NCj4gdGhlIHdheSB0byBnbyBzaG91bGQg
YmUgd2hhdCBhbHNvIFdpbGxlbSBzdXBwb3J0ZWQ6IHJldHVybiB0aGUgZXJyIHRvDQo+IHRoZSBj
YWxsZXIgYW5kIHJlc3RhcnQgdGhlIGR1bXBpbmcuIEkgY291bGQgZG8gdGhpcyB3aXRoIGV4aXN0
aW5nIGNvZGUNCj4ganVzdCBieSBkZXRlY3RpbmcgdGhhdCB3ZSBkbyBwcm92aWRlIGEgcHJldl9r
ZXkgYW5kIGdvdCB0aGUgZmlyc3Rfa2V5DQo+IGluc3RlYWQgb2YgdGhlIG5leHRfa2V5IG9yIGV2
ZW4gaW1wbGVtZW50IGEgbmV3IGZ1bmN0aW9uIGlmIHlvdSB3YW50DQo+IHRvLg0KDQpBbHdheXMg
c3RhcnRpbmcgZnJvbSB0aGUgZmlyc3Qga2V5IGhhcyBpdHMgZHJhd2JhY2sgYXMgd2Uga2VlcCBn
ZXR0aW5nIA0KdGhlIG5ldyBlbGVtZW50cyBpZiB0aGV5IGFyZSBjb25zdGFudGx5IHBvcHVsYXRl
ZC4gVGhpcyBtYXkgc2tldw0KdGhlIHJlc3VsdHMgZm9yIGEgbGFyZ2UgaGFzaCB0YWJsZS4NCg0K
TWF5YmUgd2UgY2FuIGp1c3QgZG8gbG9va3VwK2RlbGV0ZSBvciBiYXRjaCBsb29rdXArZGVsZXRl
Pw0KdXNlciBnaXZlcyBOVUxMIG1lYW5zIHRoZSBmaXJzdCBrZXkgdG8gbG9va3VwL2RlbGV0ZS4N
CkV2ZXJ5IChiYXRjaCkgbG9va3VwK2RlbGV0ZSB3aWxsIGRlbGV0ZXMgb25lIG9yIGEgc2V0IG9m
IGtleXMuDQpUaGUgc2V0IG9mIGtleXMgYXJlIHJldHJpZXZlZCB1c2luZyBpbnRlcm5hbCBnZXRf
bmV4dCAuDQpUaGUgKGJhdGNoKSBsb29rdXArZGVsZXRlIHdpbGwgcmV0dXJuIG5leHQgYXZhaWxh
YmxlIGtleSwgd2hpY2gNCnVzZXIgY2FuIGJlIHVzZWQgZm9yIG5leHQgKGJhdGNoKSBsb29rdXAr
ZGVsZXRlLg0KSWYgdXNlciBwcm92aWRlZCBrZXkgZG9lcyBub3QgbWF0Y2gsIHVzZXIgY2FuIHBy
b3ZpZGUgYSBmbGFnDQp0byBnbyB0byB0aGUgZmlyc3Qga2V5LCBvciByZXR1cm4gYW4gZXJyb3Iu
DQoNCg0KPiANCj4+IEZvciBjb25zdGFudCBjaGFuZ2luZyBsb29wcywgbm90IHN1cmUgaG93IHRv
IGRlZmluZSB3aGljaCBvbmUNCj4+IGlzIGNvcnJlY3QuIElmIHVzZXJzIGhhdmUgY29uY2VybnMs
IHRoZXkgbWF5IG5lZWQgdG8ganVzdCBwaWNrIG9uZQ0KPj4gd2hpY2ggZ2l2ZXMgdGhlbSBtb3Jl
IGNvbWZvcnQuDQo+Pg0KPj4+IExpa2UgbWFrZSBvbmUganVtYm8vY29tcG91bmQvYXRvbWljIGNv
bW1hbmQgdG8gYmUgZ2V0X25leHQrbG9va3VwK2RlbGV0ZS4NCj4+PiBEZWZpbmUgdGhlIHNlbWFu
dGljcyBvZiB0aGlzIHNpbmdsZSBjb21wb3VuZCBjb21tYW5kLg0KPj4+IEFuZCB0aGVuIGxldCBi
YXRjaGluZyB0byBiZSBhIG11bHRpcGxpZXIgb2Ygc3VjaCBjb21tYW5kLg0KPj4+IEluIGEgc2Vu
c2UgdGhhdCBtdWx0aXBsaWVyIDEgb3IgTiBzaG91bGQgYmUgaGF2ZSB0aGUgc2FtZSB3YXkuDQo+
Pj4gTm8gZXh0cmEgZmxhZ3MgdG8gYWx0ZXIgdGhlIGJhdGNoaW5nLg0KPj4+IFRoZSBoaWdoIGxl
dmVsIGRlc2NyaXB0aW9uIG9mIHRoZSBiYXRjaCB3b3VsZCBiZToNCj4+PiBwbHMgZXhlY3V0ZSBn
ZXRfbmV4dCxsb29rdXAsZGVsZXRlIGFuZCByZXBlYXQgaXQgTiB0aW1lcy4NCj4+PiBvcg0KPj4+
IHBscyBleGVjdXRlIGdldF9uZXh0LGxvb2t1cCBhbmQgcmVwZWF0IE4gdGltZXMuDQo+IA0KPiBC
dXQgYW55IGF0dGVtcHQgdG8gZG8gZ2V0X25leHQrbG9va3VwIHdpbGwgaGF2ZSBzYW1lIHByb2Js
ZW0gd2l0aA0KPiBkZWxldGlvbnMgcmlnaHQ/DQo+IA0KPiBJIGRvbid0IHNlZSBob3cgd2UgY291
bGQgZG8gaXQgbW9yZSBjb25zaXN0ZW50IHRoYW4gd2hhdCBJJ20NCj4gcHJvcG9zaW5nLiBMZXQn
cyBqdXN0IHN1cHBvcnQgb25lIGNhc2U6IHJlcG9ydCBhbiBlcnJvciBpZiB0aGUNCj4gcHJldl9r
ZXkgd2FzIG5vdCBmb3VuZCBpbnN0ZWFkIG9mIHJldHJpZXZpbmcgdGhlIGZpcnN0X2tleS4gV291
bGQgdGhhdA0KPiB3b3JrPw0KPiANCj4+PiB3aGVyZSBlYWNoIGNvbW1hbmQgYWN0aW9uIGlzIGRl
ZmluZWQgdG8gYmUgY29tcG9zYWJsZS4NCj4+Pg0KPj4+IEp1c3QgYSByb3VnaCBpZGVhLg0KPj4+
DQo=
