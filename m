Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423DA2DBEDB
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 11:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgLPKkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 05:40:36 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22130 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgLPKkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 05:40:35 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-212-Ub8oJyahMCWCrAmRpZs81Q-1; Wed, 16 Dec 2020 10:38:56 +0000
X-MC-Unique: Ub8oJyahMCWCrAmRpZs81Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 16 Dec 2020 10:38:56 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 16 Dec 2020 10:38:56 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: RE: [Patch bpf-next v2 2/5] bpf: introduce timeout map
Thread-Topic: [Patch bpf-next v2 2/5] bpf: introduce timeout map
Thread-Index: AQHW01R6Sggx3wYPikaoTV76dzuU7Kn5h55w
Date:   Wed, 16 Dec 2020 10:38:56 +0000
Message-ID: <a73e4e66b8a541d7bf74fe8a66ebbc6a@AcuMS.aculab.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com>
 <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net>
 <CAM_iQpVedtfLLbMroGCJuuRVrBPoVFgsLkQenTrwKD8uRft2wQ@mail.gmail.com>
 <20201216011422.phgv4o3jgsrg33ob@ast-mbp>
 <CAM_iQpVJLg5yCF=2w3ZpBBiR3pR4FWSNjz7FvJGqx0R+BomWDw@mail.gmail.com>
 <CAADnVQL70bVdms6_D_ep1L2v-OcgXu-9KTtLULQdfCMftLhENQ@mail.gmail.com>
In-Reply-To: <CAADnVQL70bVdms6_D_ep1L2v-OcgXu-9KTtLULQdfCMftLhENQ@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxleGVpIFN0YXJvdm9pdG92DQo+IFNlbnQ6IDE2IERlY2VtYmVyIDIwMjAgMDI6MzYN
Ci4uLg0KPiA+IFRoZSBwcm9ibGVtIGlzIG5ldmVyIGFib3V0IGdyYW51bGFyaXR5LCBpdCBpcyBh
Ym91dCBob3cgZWZmaWNpZW50IHdlIGNhbg0KPiA+IEdDLiBVc2VyLXNwYWNlIGhhcyB0byBzY2Fu
IHRoZSB3aG9sZSB0YWJsZSBvbmUgYnkgb25lLCB3aGlsZSB0aGUga2VybmVsDQo+ID4gY2FuIGp1
c3QgZG8gdGhpcyBiZWhpbmQgdGhlIHNjZW5lIHdpdGggYSBtdWNoIGxvd2VyIG92ZXJoZWFkLg0K
PiA+DQo+ID4gTGV0J3Mgc2F5IHdlIGFybSBhIHRpbWVyIGZvciBlYWNoIGVudHJ5IGluIHVzZXIt
c3BhY2UsIGl0IHJlcXVpcmVzIGEgc3lzY2FsbA0KPiA+IGFuZCBsb2NraW5nIGJ1Y2tldHMgZWFj
aCB0aW1lIGZvciBlYWNoIGVudHJ5LiBLZXJuZWwgY291bGQgZG8gaXQgd2l0aG91dA0KPiA+IGFu
eSBhZGRpdGlvbmFsIHN5c2NhbGwgYW5kIGJhdGNoaW5nLiBMaWtlIEkgc2FpZCBhYm92ZSwgd2Ug
Y291bGQgaGF2ZQ0KPiA+IG1pbGxpb25zIG9mIGVudHJpZXMsIHNvIHRoZSBvdmVyaGVhZCB3b3Vs
ZCBiZSBiaWcgaW4gdGhpcyBzY2VuYXJpby4NCj4gDQo+IGFuZCB0aGUgdXNlciBzcGFjZSBjYW4g
cGljayBhbnkgb3RoZXIgaW1wbGVtZW50YXRpb24gaW5zdGVhZA0KPiBvZiB0cml2aWFsIGVudHJ5
IGJ5IGVudHJ5IGdjIHdpdGggdGltZXIuDQoNClRoZSBrZXJuZWwgY2FuIGFsc28gZ2MgZW50cmll
cyB3aGVuIHNjYW5uaW5nIGhhc2ggbGlzdHMgZHVyaW5nIGluc2VydA0KKG9yIGV2ZW4gZHVyaW5n
IGxvb2t1cCBpZiBub3QgdXNpbmcgcncgbG9ja3MpLg0KDQpBcGFydCBmcm9tIHRoZSBtZW1vcnkg
dXNlIHRoZXJlIGlzbid0IHJlYWxseSBhIHByb2JsZW0gaGF2aW5nIHRpbWVkLW91dA0KZW50cmll
cyBpbiB0aGUgaGFzaCB0YWJsZSBpZiBub3RoaW5nIGlzIGxvb2tpbmcgYXQgdGhlbS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

