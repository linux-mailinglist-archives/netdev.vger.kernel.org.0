Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F61C644D72
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLFUrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLFUrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:47:31 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B000143852;
        Tue,  6 Dec 2022 12:47:25 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 72B115FD0B;
        Tue,  6 Dec 2022 23:47:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1670359642;
        bh=RXAuKFFL3DdHV6ZC1u0qrVJ7WK0bJttm1jn/GbmOhzU=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Pn3qdlg69FjQA9KN6Nn6eSeoa+E4IG2dqSrMYZPqBB14i5aq0abPhc/AbEj0JTFxM
         BwFre8okOfT7Vg3Hc6B66hAI2906jryKPsN/EyxDNHGv5vmeYZUFpJJ8JZ1R4yedVM
         BMnLPHqFKgu47bmrsbAe++GS/2ia3Yq72ehKRsTrCeFP6Mtx8LIf4PyEyotGZ7xkXW
         PF4Jwp46eevOkt0fTYAYU6n+Z2hLYndAt71ylCKX5C8U38zRFb0fPeBz+q+BRpvziB
         EaUYVg9FQU9+BvhTuzj+cCByxyKtNgBSGXi9Iyzv3mbb9ib8TziCcopPGvhAyTDKYC
         Rdx54oj25WN6Q==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue,  6 Dec 2022 23:47:20 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>
CC:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v4 0/4] vsock: update tools and error handling
Thread-Topic: [RFC PATCH v4 0/4] vsock: update tools and error handling
Thread-Index: AQHZCbPuYNvdlDeEMUa49xMsY3aUrw==
Date:   Tue, 6 Dec 2022 20:47:19 +0000
Message-ID: <6be11122-7cf2-641f-abd8-6e379ee1b88f@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CE74A867B854345A2042FBF696520AD@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/06 12:14:00 #20663216
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGF0Y2hzZXQgY29uc2lzdHMgb2YgdHdvIHBhcnRzOg0KDQoxKSBLZXJuZWwgcGF0Y2gNCk9uZSBw
YXRjaCBmcm9tIEJvYmJ5IEVzaGxlbWFuLiBJIHRvb2sgc2luZ2xlIHBhdGNoIGZyb20gQm9iYnk6
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2Q4MTgxOGI4NjgyMTZjNzc0NjEzZGQwMzY0
MWZjZmU2M2NjNTVhNDUNCi4xNjYwMzYyNjY4LmdpdC5ib2JieS5lc2hsZW1hbkBieXRlZGFuY2Uu
Y29tLyBhbmQgdXNlIG9ubHkgcGFydCBmb3INCmFmX3Zzb2NrLmMsIGFzIFZNQ0kgYW5kIEh5cGVy
LVYgcGFydHMgd2VyZSByZWplY3RlZC4NCg0KSSB1c2VkIGl0LCBiZWNhdXNlIGZvciBTT0NLX1NF
UVBBQ0tFVCBiaWcgbWVzc2FnZXMgaGFuZGxpbmcgd2FzIGJyb2tlbiAtDQpFTk9NRU0gd2FzIHJl
dHVybmVkIGluc3RlYWQgb2YgRU1TR1NJWkUuIEFuZCBhbnl3YXksIGN1cnJlbnQgbG9naWMgd2hp
Y2gNCmFsd2F5cyByZXBsYWNlcyBhbnkgZXJyb3IgY29kZSByZXR1cm5lZCBieSB0cmFuc3BvcnQg
dG8gRU5PTUVNIGxvb2tzDQpzdHJhbmdlIGZvciBtZSBhbHNvKGZvciBleGFtcGxlIGluIEVNU0dT
SVpFIGNhc2UgaXQgd2FzIGNoYW5nZWQgdG8NCkVOT01FTSkuDQoNCjIpIFRvb2wgcGF0Y2hlcw0K
U2luY2UgdGhlcmUgaXMgd29yayBvbiBzZXZlcmFsIHNpZ25pZmljYW50IHVwZGF0ZXMgZm9yIHZz
b2NrKHZpcnRpby8NCnZzb2NrIGVzcGVjaWFsbHkpOiBza2J1ZmYsIERHUkFNLCB6ZXJvY29weSBy
eC90eCwgc28gSSB0aGluayB0aGF0IHRoaXMNCnBhdGNoc2V0IHdpbGwgYmUgdXNlZnVsLg0KDQpU
aGlzIHBhdGNoc2V0IHVwZGF0ZXMgdnNvY2sgdGVzdHMgYW5kIHRvb2xzIGEgbGl0dGxlIGJpdC4g
Rmlyc3Qgb2YgYWxsDQppdCB1cGRhdGVzIHRlc3Qgc3VpdGU6IHR3byBuZXcgdGVzdHMgYXJlIGFk
ZGVkLiBPbmUgdGVzdCBpcyByZXdvcmtlZA0KbWVzc2FnZSBib3VuZCB0ZXN0LiBOb3cgaXQgaXMg
bW9yZSBjb21wbGV4LiBJbnN0ZWFkIG9mIHNlbmRpbmcgMSBieXRlDQptZXNzYWdlcyB3aXRoIG9u
ZSBNU0dfRU9SIGJpdCwgaXQgc2VuZHMgbWVzc2FnZXMgb2YgcmFuZG9tIGxlbmd0aChvbmUNCmhh
bGYgb2YgbWVzc2FnZXMgYXJlIHNtYWxsZXIgdGhhbiBwYWdlIHNpemUsIHNlY29uZCBoYWxmIGFy
ZSBiaWdnZXIpDQp3aXRoIHJhbmRvbSBudW1iZXIgb2YgTVNHX0VPUiBiaXRzIHNldC4gUmVjZWl2
ZXIgYWxzbyBkb24ndCBrbm93IHRvdGFsDQpudW1iZXIgb2YgbWVzc2FnZXMuIE1lc3NhZ2UgYm91
bmRzIGNvbnRyb2wgaXMgbWFpbnRhaW5lZCBieSBoYXNoIHN1bQ0Kb2YgbWVzc2FnZXMgbGVuZ3Ro
IGNhbGN1bGF0aW9uLiBTZWNvbmQgdGVzdCBpcyBmb3IgU09DS19TRVFQQUNLRVQgLSBpdA0KdHJp
ZXMgdG8gc2VuZCBtZXNzYWdlIHdpdGggbGVuZ3RoIG1vcmUgdGhhbiBhbGxvd2VkLiBJIHRoaW5r
IGJvdGggdGVzdHMNCndpbGwgYmUgdXNlZnVsIGZvciBER1JBTSBzdXBwb3J0IGFsc28uDQoNClRo
aXJkIHRoaW5nIHRoYXQgdGhpcyBwYXRjaHNldCBhZGRzIGlzIHNtYWxsIHV0aWxpdHkgdG8gdGVz
dCB2c29jaw0KcGVyZm9ybWFuY2UgZm9yIGJvdGggcnggYW5kIHR4LiBJIHRoaW5rIHRoaXMgdXRp
bCBjb3VsZCBiZSB1c2VmdWwgYXMNCidpcGVyZicsIGJlY2F1c2U6DQoxKSBJdCBpcyBzbWFsbCBj
b21wYXJpbmcgdG8gJ2lwZXJmKCknLCBzbyBpdCB2ZXJ5IGVhc3kgdG8gYWRkIG5ldw0KICAgbW9k
ZSBvciBmZWF0dXJlIHRvIGl0KGVzcGVjaWFsbHkgdnNvY2sgc3BlY2lmaWMpLg0KMikgSXQgaXMg
bG9jYXRlZCBpbiBrZXJuZWwgc291cmNlIHRyZWUsIHNvIGl0IGNvdWxkIGJlIHVwZGF0ZWQgYnkg
dGhlDQogICBzYW1lIHBhdGNoc2V0IHdoaWNoIGNoYW5nZXMgcmVsYXRlZCBrZXJuZWwgZnVuY3Rp
b25hbGl0eSBpbiB2c29jay4NCg0KSSB1c2VkIHRoaXMgdXRpbCB2ZXJ5IG9mdGVuIHRvIGNoZWNr
IHBlcmZvcm1hbmNlIG9mIG15IHJ4IHplcm9jb3B5DQpzdXBwb3J0KHRoaXMgdG9vbCBoYXMgcngg
emVyb2NvcHkgc3VwcG9ydCwgYnV0IG5vdCBpbiB0aGlzIHBhdGNoc2V0KS4NCg0KUGF0Y2hzZXQg
d2FzIHJlYmFzZWQgYW5kIHRlc3RlZCBvbiBza2J1ZmYgdjUgcGF0Y2ggZnJvbSBCb2JieSBFc2hs
ZW1hbjoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMTIwMjE3MzUyMC4xMDQy
OC0xLWJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20vDQoNCkNoYW5nZWxvZzoNCiB2MyAtPiB2
NDoNCiAtIEtlcm5lbCBwYXRjaDogdXBkYXRlIGNvbW1pdCBtZXNzYWdlIGJ5IGFkZGluZyBlcnJv
ciBjYXNlIGRlc2NyaXB0aW9uDQogLSBNZXNzYWdlIGJvdW5kcyB0ZXN0Og0KICAgLSBUeXBvIGZp
eDogcy9jb250b2xzL2NvbnRyb2xzDQogICAtIEZpeCBlcnJvciBvdXRwdXQgb24gJ3NldHNvY2tv
cHQoKSdzDQogLSB2c29ja19wZXJmOg0KICAgLSBBZGQgJ3Zzb2NrX3BlcmYnIHRhcmdldCB0byAn
YWxsJyBpbiBNYWtlZmlsZQ0KICAgLSBGaXggZXJyb3Igb3V0cHV0IG9uICdzZXRzb2Nrb3B0KCkn
cw0KICAgLSBTd2FwIHNlbmRlci9yZWNlaXZlciByb2xlczogbm93IHNlbmRlciBkb2VzICdjb25u
ZWN0KCknIGFuZCBzZW5kcw0KICAgICBkYXRhLCB3aGlsZSByZWNlaXZlciBhY2NlcHRzIGNvbm5l
Y3Rpb24uDQogICAtIFVwZGF0ZSBhcmd1bWVudHMgbmFtZXM6IHMvbWIvYnl0ZXMsIHMvc29fcmN2
bG93YXQvcmN2bG93YXQNCiAgIC0gVXBkYXRlIHVzYWdlIG91dHB1dCBhbmQgZGVzY3JpcHRpb24g
aW4gUkVBRE1FDQoNCiB2MiAtPiB2MzoNCiAtIFBhdGNoZXMgZm9yIFZNQ0kgYW5kIEh5cGVyLVYg
d2VyZSByZW1vdmVkIGZyb20gcGF0Y2hzZXQoY29tbWVudGVkIGJ5DQogICBWaXNobnUgRGFzYSBh
bmQgRGV4dWFuIEN1aSkNCiAtIEluIG1lc3NhZ2UgYm91bmRzIHRlc3QgaGFzaCBpcyBjb21wdXRl
ZCBmcm9tIGRhdGEgYnVmZmVyIHdpdGggcmFuZG9tDQogICBjb250ZW50KGluIHYyIGl0IHdhcyBz
aXplIG9ubHkpLiBUaGlzIGFwcHJvYWNoIGNvbnRyb2xzIGJvdGggZGF0YQ0KICAgaW50ZWdyaXR5
IGFuZCBtZXNzYWdlIGJvdW5kcy4NCiAtIHZzb2NrX3BlcmY6DQogICAtIGdyYW1tYXIgZml4ZXMN
CiAgIC0gb25seSBsb25nIHBhcmFtZXRlcnMgc3VwcG9ydGVkKGluc3RlYWQgb2Ygb25seSBzaG9y
dCkNCg0KIHYxIC0+IHYyOg0KIC0gVGhyZWUgbmV3IHBhdGNoZXMgZnJvbSBCb2JieSBFc2hsZW1h
biB0byBrZXJuZWwgcGFydA0KIC0gTWVzc2FnZSBib3VuZHMgdGVzdDogc29tZSByZWZhY3Rvcmlu
ZyBhbmQgYWRkIGNvbW1lbnQgdG8gZGVzY3JpYmUNCiAgIGhhc2hpbmcgcHVycG9zZQ0KIC0gQmln
IG1lc3NhZ2UgdGVzdDogY2hlY2sgJ2Vycm5vJyBmb3IgRU1TR1NJWkUgYW5kICBtb3ZlIG5ldyB0
ZXN0IHRvDQogICB0aGUgZW5kIG9mIHRlc3RzIGFycmF5DQogLSB2c29ja19wZXJmOg0KICAgLSB1
cGRhdGUgUkVBRE1FIGZpbGUNCiAgIC0gYWRkIHNpbXBsZSB1c2FnZSBleGFtcGxlIHRvIGNvbW1p
dCBtZXNzYWdlDQogICAtIHVwZGF0ZSAnLWgnIChoZWxwKSBvdXRwdXQNCiAgIC0gdXNlICdzdGRv
dXQnIGZvciBvdXRwdXQgaW5zdGVhZCBvZiAnc3RkZXJyJw0KICAgLSB1c2UgJ3N0cnRvbCcgaW5z
dGVhZCBvZiAnYXRvaScNCg0KQm9iYnkgRXNobGVtYW4oMSk6DQogdnNvY2s6IHJldHVybiBlcnJv
cnMgb3RoZXIgdGhhbiAtRU5PTUVNIHRvIHNvY2tldA0KDQpBcnNlbml5IEtyYXNub3YoMyk6DQog
dGVzdC92c29jazogcmV3b3JrIG1lc3NhZ2UgYm91bmQgdGVzdA0KIHRlc3QvdnNvY2s6IGFkZCBi
aWcgbWVzc2FnZSB0ZXN0DQogdGVzdC92c29jazogdnNvY2tfcGVyZiB1dGlsaXR5DQoNCiBuZXQv
dm13X3Zzb2NrL2FmX3Zzb2NrLmMgICAgICAgICB8ICAgMyArLQ0KIHRvb2xzL3Rlc3RpbmcvdnNv
Y2svTWFrZWZpbGUgICAgIHwgICAzICstDQogdG9vbHMvdGVzdGluZy92c29jay9SRUFETUUgICAg
ICAgfCAgMzQgKysrDQogdG9vbHMvdGVzdGluZy92c29jay9jb250cm9sLmMgICAgfCAgMjggKysr
DQogdG9vbHMvdGVzdGluZy92c29jay9jb250cm9sLmggICAgfCAgIDIgKw0KIHRvb2xzL3Rlc3Rp
bmcvdnNvY2svdXRpbC5jICAgICAgIHwgIDEzICsrDQogdG9vbHMvdGVzdGluZy92c29jay91dGls
LmggICAgICAgfCAgIDEgKw0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfcGVyZi5jIHwgNDM0
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KIHRvb2xzL3Rlc3Rpbmcv
dnNvY2svdnNvY2tfdGVzdC5jIHwgMTk3ICsrKysrKysrKysrKysrKystLQ0KIDkgZmlsZXMgY2hh
bmdlZCwgNjk4IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KLS0gDQoyLjI1LjENCg==
