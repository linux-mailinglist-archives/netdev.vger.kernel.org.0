Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA2C4B3959
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 05:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiBMEx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 23:53:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBMEx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 23:53:57 -0500
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 20:53:52 PST
Received: from mxo1.dft.dmz.twosigma.com (mxo1.dft.dmz.twosigma.com [208.77.212.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2AB5E764
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 20:53:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mxo1.dft.dmz.twosigma.com (Postfix) with ESMTP id 4JxF9k0t3Kz2xtx;
        Sun, 13 Feb 2022 04:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=twosigma.com;
        s=202008; t=1644727434;
        bh=m4jt9L8tQC8344HWv3E5ulcqkPpSIFUfjMFsrzdzxds=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=I3pAdHOLrDUjv1V7Wz2DMbqLWoii4JTcQLJPvTo5GTz7T/NBzgpn6G9NgoXq56R+t
         q+9Skn4td1FYFAwwGYtHH7h7Tln8xO3s4/Yd0dYYfN8StJ6gLeBc+QYBqNIDubbJXK
         wakz0wePkSzzfZKtbqZWLVpUnMkZHWpGObPT14fGWqlhu7+RTw+sLDpqhW5B5Tu3HL
         UXRbp5C8Wnggth9qEd+5c89bDZ8wNuP5nNp85jj7XOP6oIE3reZstCFsb09tQtiJ6w
         W6wHKfJMIcYfK+L65bktejP78FR3gKohsJTM63UTSlnAZTsRER1XN1EMGe7eFsoPlB
         OBUQ9LWO8HUow==
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo1.dft.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo1.dft.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n4ffKSdjUcK7; Sun, 13 Feb 2022 04:43:54 +0000 (UTC)
Received: from exmbdft7.ad.twosigma.com (exmbdft7.ad.twosigma.com [172.22.2.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo1.dft.dmz.twosigma.com (Postfix) with ESMTPS id 4JxF9j6gKlz2xsq;
        Sun, 13 Feb 2022 04:43:53 +0000 (UTC)
Received: from EXMBDFT10.ad.twosigma.com (172.23.127.159) by
 exmbdft7.ad.twosigma.com (172.22.2.43) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 13 Feb 2022 04:43:53 +0000
Received: from exmbdft6.ad.twosigma.com (172.22.1.5) by
 EXMBDFT10.ad.twosigma.com (172.23.127.159) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Feb 2022 04:43:53 +0000
Received: from exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c]) by
 exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c%17]) with mapi id
 15.00.1497.012; Sun, 13 Feb 2022 04:43:53 +0000
From:   Tian Lan <Tian.Lan@twosigma.com>
To:     Eric Dumazet <edumazet@google.com>, Tian Lan <tilan7663@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        Andrew Chester <Andrew.Chester@twosigma.com>
Subject: RE: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Topic: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Index: AQHYII8R50vJ9luEckWkqpgQGqAi+KyQ4b2AgAABZ5A=
Date:   Sun, 13 Feb 2022 04:43:53 +0000
Message-ID: <9bd37d176e29457885588b36cfcee292@exmbdft6.ad.twosigma.com>
References: <20220213040545.365600-1-tilan7663@gmail.com>
 <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
In-Reply-To: <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.23.151.37]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGV5IEVyaWMsDQoNClRoYW5rcyBmb3IgdGhlIGNvbW1lbnQuIEkgYWdyZWUgd2l0aCB5b3UgdGhh
dCB0aGlzIGNoYW5nZSB3aWxsIG5vdCBtYWtlIHJlY2VpdmVyIGFkdmVydGlzZSBhIGxhcmdlciBy
d25kIGluIHRoZSAzV0hTLiBCdXQgSSB0aGluayBpdCBjYW4gaGVscCBvbiB0aGUgcnduZCBzY2Fs
aW5nIGFmdGVyIHRoZSBmaXJzdCBSVFQgKHRoZSByZWNlaXZlciB3b3VsZCBhZHZlcnRpc2UgbmV3
IHJ3bmQgYmFzZWQgb24gYSBtdWNoIGxhcmdlciByY3Zfc3N0aHJlc2gpLg0KDQpGcm9tIG91ciBi
ZW5jaG1hcmsgdGVzdGluZyAobW9zdGx5IGZvciBkYXRhIDwgNE1pQiksIGl0IHNlZW1zIGxpa2Ug
dGhhdCB0aGUgc2VuZGVyIHdhcyBtb3N0bHkgd2FpdGluZyBvbiB0aGUgcmVjZWl2ZXIgdG8gc2Nh
bGUgdXAgdGhlIHJlY2VpdmUgd2luZG93LiBGb3IgbmV0d29yayB3aXRoIGhpZ2ggbGF0ZW5jeSwg
dGhpcyBpcyB2ZXJ5IGNvc3RseSBldmVuIHdlIHRyeSB0byBzZXQgYSBsYXJnZSBpbml0aWFsIGN3
bmQgdG8gdGFrZSBhZHZhbnRhZ2Ugb2YgZnVsbCByd25kIHdpbmRvdyBhZHZlcnRpc2VkIGluaXRp
YWxseS4gSSdtIGhhcHB5IHRvIGRpc2N1c3Mgb3RoZXIgYWx0ZXJuYXRpdmVzIGlmIHlvdSB0aGlu
ayB0aGVyZSBhcmUgYmV0dGVyIG9wdGlvbnMgdG8gc2NhbGUgdXAgcnduZCBtdWNoIG1vcmUgYWdn
cmVzc2l2ZWx5Lg0KDQotQmVzdA0KVGlhbg0KIA0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4gDQpTZW50OiBTYXR1cmRh
eSwgRmVicnVhcnkgMTIsIDIwMjIgMTE6MjMgUE0NClRvOiBUaWFuIExhbiA8dGlsYW43NjYzQGdt
YWlsLmNvbT4NCkNjOiBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBBbmRyZXcgQ2hl
c3RlciA8QW5kcmV3LkNoZXN0ZXJAdHdvc2lnbWEuY29tPjsgVGlhbiBMYW4gPFRpYW4uTGFuQHR3
b3NpZ21hLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIHRjcDogYWxsb3cgdGhlIGluaXRpYWwg
cmVjZWl2ZSB3aW5kb3cgdG8gYmUgZ3JlYXRlciB0aGFuIDY0S2lCDQoNCk9uIFNhdCwgRmViIDEy
LCAyMDIyIGF0IDg6MDYgUE0gVGlhbiBMYW4gPHRpbGFuNzY2M0BnbWFpbC5jb20+IHdyb3RlOg0K
Pg0KPiBGcm9tOiBUaWFuIExhbiA8VGlhbi5MYW5AdHdvc2lnbWEuY29tPg0KPg0KPiBDb21taXQg
MTNkM2IxZWJlMjg3ICgiYnBmOiBTdXBwb3J0IGZvciBzZXR0aW5nIGluaXRpYWwgcmVjZWl2ZSAN
Cj4gd2luZG93IikgaW50cm9kdWNlZCBhIEJQRl9TT0NLX09QUyBvcHRpb24gd2hpY2ggYWxsb3dz
IHNldHRpbmcgYSANCj4gbGFyZ2VyIHZhbHVlIGZvciB0aGUgaW5pdGlhbCBhZHZlcnRpc2VkIHJl
Y2VpdmUgd2luZG93IHVwIHRvIHRoZSANCj4gcmVjZWl2ZSBidWZmZXIgc3BhY2UgZm9yIGJvdGgg
YWN0aXZlIGFuZCBwYXNzaXZlIFRDUCBjb25uZWN0aW9ucy4NCj4NCj4gSG93ZXZlciwgdGhlIGNv
bW1pdCBhMzM3NTMxYjk0MmIgKCJ0Y3A6IHVwIGluaXRpYWwgcm1lbSB0byAxMjhLQiBhbmQgDQo+
IFNZTiByd2luIHRvIGFyb3VuZCA2NEtCIikgd291bGQgbGltaXQgdGhlIGluaXRpYWwgcmVjZWl2
ZSB3aW5kb3cgdG8gYmUgDQo+IGF0IG1vc3QgNjRLaUIgd2hpY2ggcGFydGlhbGx5IG5lZ2F0ZXMg
dGhlIGNoYW5nZSBtYWRlIHByZXZpb3VzbHkuDQo+DQo+IFdpdGggdGhpcyBwYXRjaCwgdGhlIGlu
aXRpYWwgcmVjZWl2ZSB3aW5kb3cgd2lsbCBiZSBzZXQgdG8gdGhlIA0KPiBtaW4oNjRLaUIsIHNw
YWNlKSBpZiB0aGVyZSBpcyBubyBpbml0X3Jjdl93bmQgcHJvdmlkZWQuIEVsc2Ugc2V0IHRoZSAN
Cj4gaW5pdGlhbCByZWNlaXZlIHdpbmRvdyB0byBiZSB0aGUgbWluKGluaXRfcmN2X3duZCAqIG1z
cywgc3BhY2UpLg0KDQoNCkkgZG8gbm90IHNlZSBob3cgcHJldGVuZGluZyB0byBoYXZlIGEgbGFy
Z2UgcmN2d2luIGlzIGdvaW5nIHRvIGhlbHAgZm9yIHBhc3NpdmUgY29ubmVjdGlvbnMsIGdpdmVu
IHRoZSBXSU4gaW4gU1lOIGFuZCBTWU5BQ0sgcGFja2V0IGlzIG5vdCBzY2FsZWQuDQoNClNvIHRo
aXMgcGF0Y2ggSSB0aGluayBpcyBtaXNsZWFkaW5nLiBHZXQgb3ZlciBpdCwgVENQIGhhcyBub3Qg
YmVlbiBkZXNpZ25lZCB0byBhbm5vdW5jZSBtb3JlIHRoYW4gNjRLQiBpbiB0aGUgM1dIUy4NCg0K
VGhlIG9ubHkgd2F5IGEgc2VuZGVyIGNvdWxkIHVzZSB5b3VyIGJpZ2dlciB3aW5kb3cgd291bGQg
YmUgdG8gdmlvbGF0ZSBUQ1Agc3BlY3MgYW5kIHNlbmQgbW9yZSB0aGFuIDY0S0IgaW4gdGhlIGZp
cnN0IFJUVCwgYXNzdW1pbmcgdGhlIHJlY2VpdmVyIGhhcyBpbiBmYWN0IGEgUldJTiBiaWdnZXIg
dGhhbiA2NEsgPz8/Pw0K
