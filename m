Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D309651B68
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 08:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiLTHRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 02:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiLTHQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 02:16:51 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364B1263E;
        Mon, 19 Dec 2022 23:16:41 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 7B29D5FD04;
        Tue, 20 Dec 2022 10:16:39 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671520599;
        bh=5TEeyQjMSCugpLlqn25zZiJa9RZz4CI7g8CSW0c7C3s=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=dRgeSiD6/a0qgE5smiRGzUID5RK0gAY1u97sYw2qEoq4+1T1li/is15cHI7FNEFFP
         C3oT+fXXOnnS1yBBw2+ONkqCNmXs2s586ykwLjA/1E8cNzhityWTNjTyll4NXkhfmg
         cueMbOhyFSu86jRX224dhI6UicarAUTOP5FNYMR1mVYl3duhT9IjXl7eX8BsQtIQe7
         qwcD1q+B8bu1f1BAmk5exA/iXOsugjsIz7nFaNaBqXIl14L5KEJZqgETtHJ1RadABC
         bKB8aoCncZYROQ5EHn9VqiueVwTZhdGqfB+oPLUkdue9JxR50fTXlckfndq45awKBY
         O/c4uEMNEO5yA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 20 Dec 2022 10:16:38 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v5 0/4] vsock: update tools and error handling
Thread-Topic: [RFC PATCH v5 0/4] vsock: update tools and error handling
Thread-Index: AQHZFEMAQA1kPjJjEE22ZwRXjunQBQ==
Date:   Tue, 20 Dec 2022 07:16:38 +0000
Message-ID: <e04f749e-f1a7-9a1d-8213-c633ffcc0a69@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <745CFE863090454596892ADE6730C2C7@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/20 03:38:00 #20687629
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
bCBjb3VsZCBiZSB1c2VmdWwgYXMNCidpcGVyZicvJ3VwZXJmJywgYmVjYXVzZToNCjEpIEl0IGlz
IHNtYWxsIGNvbXBhcmluZyB0byAnaXBlcmYnIG9yICd1cGVyZicsIHNvIGl0IHZlcnkgZWFzeSB0
byBhZGQNCiAgIG5ldyBtb2RlIG9yIGZlYXR1cmUgdG8gaXQoZXNwZWNpYWxseSB2c29jayBzcGVj
aWZpYykuDQoyKSBJdCBhbGxvd3MgdG8gc2V0IFNPX1JDVkxPV0FUIGFuZCBTT19WTV9TT0NLRVRT
X0JVRkZFUl9TSVpFIG9wdGlvbi4NCiAgIFdob2xlIHRocm91Z2h0cHV0IGRlcGVuZHMgb24gYm90
aCBwYXJhbWV0ZXJzLg0KMykgSXQgaXMgbG9jYXRlZCBpbiB0aGUga2VybmVsIHNvdXJjZSB0cmVl
LCBzbyBpdCBjb3VsZCBiZSB1cGRhdGVkIGJ5DQogICB0aGUgc2FtZSBwYXRjaHNldCB3aGljaCBj
aGFuZ2VzIHJlbGF0ZWQga2VybmVsIGZ1bmN0aW9uYWxpdHkgaW4gdnNvY2suDQoNCkkgdXNlZCB0
aGlzIHV0aWwgdmVyeSBvZnRlbiB0byBjaGVjayBwZXJmb3JtYW5jZSBvZiBteSByeCB6ZXJvY29w
eQ0Kc3VwcG9ydCh0aGlzIHRvb2wgaGFzIHJ4IHplcm9jb3B5IHN1cHBvcnQsIGJ1dCBub3QgaW4g
dGhpcyBwYXRjaHNldCkuDQoNCkhlcmUgaXMgY29tcGFyaXNvbiBvZiBvdXRwdXRzIGZyb20gdGhy
ZWUgdXRpbHM6ICdpcGVyZicsICd1cGVyZicgYW5kDQondnNvY2tfcGVyZicuIEluIGFsbCB0aHJl
ZSBjYXNlcyBzZW5kZXIgd2FzIGF0IGd1ZXN0IHNpZGUuIHJ4IGFuZA0KdHggYnVmZmVycyB3ZXJl
IGFsd2F5cyA2NEtiKGJlY2F1c2UgYnkgZGVmYXVsdCAndXBlcmYnIHVzZXMgOEspLg0KDQppcGVy
ZjoNCg0KICAgWyBJRF0gSW50ZXJ2YWwgICAgICAgICAgIFRyYW5zZmVyICAgICBCaXRyYXRlDQog
ICBbICA1XSAgIDAuMDAtMTAuMDAgIHNlYyAgMTIuOCBHQnl0ZXMgIDExLjAgR2JpdHMvc2VjIHNl
bmRlcg0KICAgWyAgNV0gICAwLjAwLTEwLjAwICBzZWMgIDEyLjggR0J5dGVzICAxMS4wIEdiaXRz
L3NlYyByZWNlaXZlcg0KDQp1cGVyZjoNCg0KICAgVG90YWwgICAgIDE2LjI3R0IgLyAgMTEuMzYo
cykgPSAgICAxMi4zMEdiL3MgICAgICAgMjM0NTVvcC9zDQoNCnZzb2NrX3BlcmY6DQoNCiAgIHR4
IHBlcmZvcm1hbmNlOiAxMi4zMDE1MjkgR2JpdHMvcw0KICAgcnggcGVyZm9ybWFuY2U6IDEyLjI4
ODAxMSBHYml0cy9zDQoNClJlc3VsdHMgYXJlIGFsbW9zdCBzYW1lIGluIGFsbCB0aHJlZSBjYXNl
cy4NCg0KUGF0Y2hzZXQgd2FzIHJlYmFzZWQgYW5kIHRlc3RlZCBvbiBza2J1ZmYgdjggcGF0Y2gg
ZnJvbSBCb2JieSBFc2hsZW1hbjoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIy
MTIxNTA0MzY0NS4zNTQ1MTI3LTEtYm9iYnkuZXNobGVtYW5AYnl0ZWRhbmNlLmNvbS8NCg0KQ2hh
bmdlbG9nOg0KIHY0IC0+IHY1Og0KIC0gS2VybmVsIHBhdGNoOiB1cGRhdGUgY29tbWl0IG1lc3Nh
Z2UNCiAtIHZzb2NrX3BlcmY6DQogICAtIEZpeCB0eXBvIGluIGNvbW1pdCBtZXNzYWdlDQogICAt
IFVzZSAiZnByaW50ZihzdGRlcnIsIiBpbnN0ZWFkIG9mICJwcmludGYoIiBmb3IgZXJyb3JzDQog
ICAtIE1vcmUgc3RhdHMgZm9yIHR4OiB0b3RhbCBieXRlcyBzZW50IGFuZCB0aW1lIGluIHR4IGxv
b3ANCiAgIC0gUHJpbnQgdGhyb3VnaHB1dCBpbiAnZ2lnYWJpdHMnIGluc3RlYWQgb2YgJ2dpZ2Fi
eXRlcycoYXMgaW4NCiAgICAgJ2lwZXJmJyBhbmQgJ3VwZXJmJykNCiAgIC0gT3V0cHV0IGNvbXBh
cmlzb25zIGJldHdlZW4gJ2lwZXJmJywgJ3VwZXJmJyBhbmQgJ3Zzb2NrX3BlcmYnDQogICAgIGFk
ZGVkIHRvIENWLg0KDQogdjMgLT4gdjQ6DQogLSBLZXJuZWwgcGF0Y2g6IHVwZGF0ZSBjb21taXQg
bWVzc2FnZSBieSBhZGRpbmcgZXJyb3IgY2FzZSBkZXNjcmlwdGlvbg0KIC0gTWVzc2FnZSBib3Vu
ZHMgdGVzdDoNCiAgIC0gVHlwbyBmaXg6IHMvY29udG9scy9jb250cm9scw0KICAgLSBGaXggZXJy
b3Igb3V0cHV0IG9uICdzZXRzb2Nrb3B0KCkncw0KIC0gdnNvY2tfcGVyZjoNCiAgIC0gQWRkICd2
c29ja19wZXJmJyB0YXJnZXQgdG8gJ2FsbCcgaW4gTWFrZWZpbGUNCiAgIC0gRml4IGVycm9yIG91
dHB1dCBvbiAnc2V0c29ja29wdCgpJ3MNCiAgIC0gU3dhcCBzZW5kZXIvcmVjZWl2ZXIgcm9sZXM6
IG5vdyBzZW5kZXIgZG9lcyAnY29ubmVjdCgpJyBhbmQgc2VuZHMNCiAgICAgZGF0YSwgd2hpbGUg
cmVjZWl2ZXIgYWNjZXB0cyBjb25uZWN0aW9uLg0KICAgLSBVcGRhdGUgYXJndW1lbnRzIG5hbWVz
OiBzL21iL2J5dGVzLCBzL3NvX3Jjdmxvd2F0L3Jjdmxvd2F0DQogICAtIFVwZGF0ZSB1c2FnZSBv
dXRwdXQgYW5kIGRlc2NyaXB0aW9uIGluIFJFQURNRQ0KDQogdjIgLT4gdjM6DQogLSBQYXRjaGVz
IGZvciBWTUNJIGFuZCBIeXBlci1WIHdlcmUgcmVtb3ZlZCBmcm9tIHBhdGNoc2V0KGNvbW1lbnRl
ZCBieQ0KICAgVmlzaG51IERhc2EgYW5kIERleHVhbiBDdWkpDQogLSBJbiBtZXNzYWdlIGJvdW5k
cyB0ZXN0IGhhc2ggaXMgY29tcHV0ZWQgZnJvbSBkYXRhIGJ1ZmZlciB3aXRoIHJhbmRvbQ0KICAg
Y29udGVudChpbiB2MiBpdCB3YXMgc2l6ZSBvbmx5KS4gVGhpcyBhcHByb2FjaCBjb250cm9scyBi
b3RoIGRhdGENCiAgIGludGVncml0eSBhbmQgbWVzc2FnZSBib3VuZHMuDQogLSB2c29ja19wZXJm
Og0KICAgLSBncmFtbWFyIGZpeGVzDQogICAtIG9ubHkgbG9uZyBwYXJhbWV0ZXJzIHN1cHBvcnRl
ZChpbnN0ZWFkIG9mIG9ubHkgc2hvcnQpDQoNCiB2MSAtPiB2MjoNCiAtIFRocmVlIG5ldyBwYXRj
aGVzIGZyb20gQm9iYnkgRXNobGVtYW4gdG8ga2VybmVsIHBhcnQNCiAtIE1lc3NhZ2UgYm91bmRz
IHRlc3Q6IHNvbWUgcmVmYWN0b3JpbmcgYW5kIGFkZCBjb21tZW50IHRvIGRlc2NyaWJlDQogICBo
YXNoaW5nIHB1cnBvc2UNCiAtIEJpZyBtZXNzYWdlIHRlc3Q6IGNoZWNrICdlcnJubycgZm9yIEVN
U0dTSVpFIGFuZCAgbW92ZSBuZXcgdGVzdCB0bw0KICAgdGhlIGVuZCBvZiB0ZXN0cyBhcnJheQ0K
IC0gdnNvY2tfcGVyZjoNCiAgIC0gdXBkYXRlIFJFQURNRSBmaWxlDQogICAtIGFkZCBzaW1wbGUg
dXNhZ2UgZXhhbXBsZSB0byBjb21taXQgbWVzc2FnZQ0KICAgLSB1cGRhdGUgJy1oJyAoaGVscCkg
b3V0cHV0DQogICAtIHVzZSAnc3Rkb3V0JyBmb3Igb3V0cHV0IGluc3RlYWQgb2YgJ3N0ZGVycicN
CiAgIC0gdXNlICdzdHJ0b2wnIGluc3RlYWQgb2YgJ2F0b2knDQoNCkJvYmJ5IEVzaGxlbWFuKDEp
Og0KIHZzb2NrOiByZXR1cm4gZXJyb3JzIG90aGVyIHRoYW4gLUVOT01FTSB0byBzb2NrZXQNCg0K
QXJzZW5peSBLcmFzbm92KDMpOg0KIHRlc3QvdnNvY2s6IHJld29yayBtZXNzYWdlIGJvdW5kIHRl
c3QNCiB0ZXN0L3Zzb2NrOiBhZGQgYmlnIG1lc3NhZ2UgdGVzdA0KIHRlc3QvdnNvY2s6IHZzb2Nr
X3BlcmYgdXRpbGl0eQ0KDQogbmV0L3Ztd192c29jay9hZl92c29jay5jICAgICAgICAgfCAgIDMg
Ky0NCiB0b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlICAgICB8ICAgMyArLQ0KIHRvb2xzL3Rl
c3RpbmcvdnNvY2svUkVBRE1FICAgICAgIHwgIDM0ICsrKw0KIHRvb2xzL3Rlc3RpbmcvdnNvY2sv
Y29udHJvbC5jICAgIHwgIDI4ICsrKw0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svY29udHJvbC5oICAg
IHwgICAyICsNCiB0b29scy90ZXN0aW5nL3Zzb2NrL3V0aWwuYyAgICAgICB8ICAxMyArKw0KIHRv
b2xzL3Rlc3RpbmcvdnNvY2svdXRpbC5oICAgICAgIHwgICAxICsNCiB0b29scy90ZXN0aW5nL3Zz
b2NrL3Zzb2NrX3BlcmYuYyB8IDQ0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyB8IDE5NyArKysrKysrKysr
KysrKystLQ0KIDkgZmlsZXMgY2hhbmdlZCwgNzA1IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9u
cygtKQ0KLS0gDQoyLjI1LjENCg==
