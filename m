Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72C364C2B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfGJSgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:36:10 -0400
Received: from LLMX2.LL.MIT.EDU ([129.55.12.48]:43134 "EHLO llmx2.ll.mit.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfGJSgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 14:36:09 -0400
X-Greylist: delayed 744 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 14:36:09 EDT
Received: from LLE2K16-MBX02.mitll.ad.local (LLE2K16-MBX02.mitll.ad.local) by llmx2.ll.mit.edu (unknown) with ESMTPS id x6AINaap003832; Wed, 10 Jul 2019 14:23:36 -0400
From:   "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Dustin Marquess" <dmarquess@apple.com>
Subject: RE: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Thread-Topic: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Thread-Index: AQKw2gvaIH+7kp/NrCmbg6L94CyO5gHbs90WAiPXn9kCN14y2gIOoPmspMqxmMA=
Date:   Wed, 10 Jul 2019 18:23:33 +0000
Message-ID: <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
In-Reply-To: <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.1.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100206
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8xNy8xOSA4OjE5IFBNLCBDaHJpc3RvcGggUGFhc2NoIHdyb3RlOg0KPiANCj4gWWVzLCB0
aGlzIGRvZXMgdGhlIHRyaWNrIGZvciBteSBwYWNrZXRkcmlsbC10ZXN0Lg0KPiANCj4gSSB3b25k
ZXIsIGlzIHRoZXJlIGEgd2F5IHdlIGNvdWxkIGVuZCB1cCBpbiBhIHNpdHVhdGlvbiB3aGVyZSB3
ZSBjYW4ndA0KPiByZXRyYW5zbWl0IGFueW1vcmU/DQo+IEZvciBleGFtcGxlLCBza193bWVtX3F1
ZXVlZCBoYXMgZ3Jvd24gc28gbXVjaCB0aGF0IHRoZSBuZXcgdGVzdCBmYWlscy4NCj4gVGhlbiwg
aWYgd2UgbGVnaXRpbWF0ZWx5IG5lZWQgdG8gZnJhZ21lbnQgaW4gX190Y3BfcmV0cmFuc21pdF9z
a2IoKSB3ZQ0KPiB3b24ndCBiZSBhYmxlIHRvIGRvIHNvLiBTbyB3ZSB3aWxsIG5ldmVyIHJldHJh
bnNtaXQuIEFuZCBpZiBubyBBQ0sNCj4gY29tZXMgYmFjayBpbiB0byBtYWtlIHNvbWUgcm9vbSB3
ZSBhcmUgc3R1Y2ssIG5vPw0KDQpXZSBzZWVtIHRvIGJlIGhhdmluZyBleGFjdGx5IHRoaXMgcHJv
YmxlbS4gV2XigJlyZSBydW5uaW5nIG9uIHRoZSA0LjE0IGJyYW5jaC4gQWZ0ZXIgcmVjZW50bHkg
dXBkYXRpbmcgb3VyIGtlcm5lbCwgd2XigJl2ZSBiZWVuIGhhdmluZyBhIHByb2JsZW0gd2l0aCBU
Q1AgY29ubmVjdGlvbnMgc3RhbGxpbmcgLyBkeWluZyBvZmYgd2l0aG91dCBkaXNjb25uZWN0aW5n
LiBUaGV5J3JlIHN0dWNrIGFuZCBuZXZlciByZWNvdmVyLg0KDQpJIGJpc2VjdGVkIHRoZSBwcm9i
bGVtIHRvIDQuMTQuMTI3IGNvbW1pdCA5ZGFmMjI2ZmY5MjY3OWQwOWFlY2ExYjVjMTI0MGUzNjA3
MTUzMzM2IChjb21taXQgZjA3MGVmMmFjNjY3MTYzNTcwNjZiNjgzZmIwYmFmNTVmODE5MWEyZSB1
cHN0cmVhbSk6IHRjcDogdGNwX2ZyYWdtZW50KCkgc2hvdWxkIGFwcGx5IHNhbmUgbWVtb3J5IGxp
bWl0cy4gVGhhdCBsZWFkIG1lIHRvIHRoaXMgdGhyZWFkLg0KDQpPdXIgZW52aXJvbm1lbnQgaXMg
YSBzdXBlcmNvbXB1dGluZyBjZW50ZXI6IGxvdHMgb2Ygc2VydmVycyBpbnRlcmNvbm5lY3RlZCB3
aXRoIGEgbm9uLWJsb2NraW5nIDEwR2JpdCBldGhlcm5ldCBuZXR3b3JrLiBXZeKAmXZlIHplcm9l
ZCBpbiBvbiB0aGUgcHJvYmxlbSBpbiB0d28gc2l0dWF0aW9uczogcmVtb3RlIHVzZXJzIG9uIFZQ
TiBhY2Nlc3NpbmcgbGFyZ2UgZmlsZXMgdmlhIHNhbWJhIGFuZCBjb21wdXRlIGpvYnMgdXNpbmcg
SW50ZWwgTVBJIG92ZXIgVENQL0lQL2V0aGVybmV0LiBJdCBjZXJ0YWlubHkgYWZmZWN0cyBvdGhl
ciBzaXR1YXRpb25zLCBtYW55IG9mIG91ciB3b3JrbG9hZHMgaGF2ZSBiZWVuIHVuc3RhYmxlIHNp
bmNlIHRoaXMgcGF0Y2ggd2VudCBpbnRvIHByb2R1Y3Rpb24sIGJ1dCB0aG9zZSBhcmUgdGhlIHR3
byB3ZSBjbGVhcmx5IGlkZW50aWZpZWQgYXMgdGhleSBmYWlsIHJlbGlhYmx5IGV2ZXJ5IHRpbWUu
IFdlIGhhZCB0byB0YWtlIHRoZSBzeXN0ZW0gZG93biBmb3IgdW5zY2hlZHVsZWQgbWFpbnRlbmFu
Y2UgdG8gcm9sbCBiYWNrIHRvIGFuIG9sZGVyIGtlcm5lbC4NCg0KVGhlIFRDUFdxdWV1ZVRvb0Jp
ZyBjb3VudCBpcyBpbmNyZW1lbnRpbmcgd2hlbiB0aGUgcHJvYmxlbSBvY2N1cnMuDQoNClVzaW5n
IGZ0cmFjZS90cmFjZS1jbWQgb24gYW4gYWZmZWN0ZWQgcHJvY2VzcywgaXQgYXBwZWFycyB0aGUg
Y2FsbCBzdGFjayBpczoNCnJ1bl90aW1lcl9zb2Z0aXJxDQpleHBpcmVfdGltZXJzDQpjYWxsX3Rp
bWVyX2ZuDQp0Y3Bfd3JpdGVfdGltZXINCnRjcF93cml0ZV90aW1lcl9oYW5kbGVyDQp0Y3BfcmV0
cmFuc21pdF90aW1lcg0KdGNwX3JldHJhbnNtaXRfc2tiDQpfX3RjcF9yZXRyYW5zbWl0X3NrYg0K
dGNwX2ZyYWdtZW50DQoNCkFuZHJldyBQcm91dA0KTUlUIExpbmNvbG4gTGFib3JhdG9yeSBTdXBl
cmNvbXB1dGluZyBDZW50ZXINCg0K
