Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF7C3B70D2
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 12:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhF2KkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 06:40:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:31737 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233092AbhF2KkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 06:40:19 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-276-Ynsqbt41MGGLMnUmWg75qQ-1; Tue, 29 Jun 2021 11:37:49 +0100
X-MC-Unique: Ynsqbt41MGGLMnUmWg75qQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 11:37:48 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Tue, 29 Jun 2021 11:37:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andreas Fink' <afink@list.fink.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC:     Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net] sctp: prevent info leak in sctp_make_heartbeat()
Thread-Topic: [PATCH net] sctp: prevent info leak in sctp_make_heartbeat()
Thread-Index: AQHXbMDx0xuH4caApku27XGH6SriJKsqyrWg
Date:   Tue, 29 Jun 2021 10:37:48 +0000
Message-ID: <c76a03be72ae4dfc9b6a65d418d699e2@AcuMS.aculab.com>
References: <YNrXoNAiQama8Us8@mwanda>
 <886e4daf-c239-c1ce-da52-4b4684449908@list.fink.org>
In-Reply-To: <886e4daf-c239-c1ce-da52-4b4684449908@list.fink.org>
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

PiA+IC0Jc3RydWN0IHNjdHBfc2VuZGVyX2hiX2luZm8gaGJpbmZvOw0KPiA+ICsJc3RydWN0IHNj
dHBfc2VuZGVyX2hiX2luZm8gaGJpbmZvID0ge307DQoNCj4gRG9lcyB0aGF0IGdjYyBleHRlbnNp
b24gd29yayB3aXRoIGFsbCBjb21waWxlcnMsIGVzcGVjaWFsbHkgY2xhbmc/DQoNCj4gPiBTbyB0
aGF0J3MgbmljZSwgYmVjYXVzZSBhZGRpbmcgbWVtc2V0KClzIHRvIHplcm8gZXZlcnl3aGVyZSB3
YXMgdWdseS4NCg0KVGhlICdyZWFsIGZ1bicgKHRtKSBzdGFydHMgd2hlbiB0aGUgYml0IHBhdHRl
cm4gZm9yIHRoZSBOVUxMDQpwb2ludGVyIGlzbid0ICdhbGwgemVyb3MnLg0KVXNpbmcgbWVtc2V0
KCkgaXMgdGhlbiBicm9rZW4gLSBJIHN1c3BlY3QgdGhlIGNvbXBpbGVyIGlzDQpleHBlY3RlZCB0
byBpbml0aWFsaXNlIHBvaW50ZXJzIHRvIHRoZSBjb3JyZWN0IE5VTEwgcGF0dGVybi4NCg0KTm90
IHRoYXQgSSB0aGluayBhbnlvbmUgc2FuZSB3b3VsZCBjb25zaWRlciB0cnlpbmcgdG8gY29tcGls
ZQ0KYW55ICdub3JtYWwnIEMgY29kZSBmb3Igc3VjaCBhIHN5c3RlbS4NCg0KT1RPSCBpdCBpcyBw
cm9iYWJseSB3aHkgY2xhbmcgaXMgYmxlYXRpbmcgYWJvdXQgKGludCkoKGNoYXIgKikwICsgNCkN
CmJlaW5nIHVuZGVmaW5lZCBiZWhhdmlvdXIuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

