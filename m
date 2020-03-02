Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673E51767FD
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCBXQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:16:38 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:55550 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgCBXQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 18:16:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583190996; x=1614726996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+UWYgNwVFrpqbsiNpxtMLg5PLNo6oZ8uC9opvMf5BxM=;
  b=l7tmVuEdKKjSETcMNDAmO+0n+0TkXhUOpDquXdI/8bEHlKCjSY2FfWIH
   hJDX4Xt/5coGy+K29VzVC0/LeS/a0vgUQ2ibmF64EPpqQ6W2YvxR+AEvM
   ol2F8vAEa43E1BYD0dC85xk8Ia5v7Wnv3oaReop1937hksg1O2I2MQa02
   k=;
IronPort-SDR: XLFV+FAbo74E1bixS7QRul4MEISP8hS7PAr4ilEI1Meh59OGdRLNE/QAoxqdvhOztIdQ4SQCcD
 aWv1Zg7OTn2g==
X-IronPort-AV: E=Sophos;i="5.70,508,1574121600"; 
   d="scan'208";a="20370808"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 02 Mar 2020 23:16:34 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 1B10CA2D8B;
        Mon,  2 Mar 2020 23:16:34 +0000 (UTC)
Received: from EX13D22EUB002.ant.amazon.com (10.43.166.131) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 2 Mar 2020 23:16:33 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D22EUB002.ant.amazon.com (10.43.166.131) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 2 Mar 2020 23:16:32 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Mon, 2 Mar 2020 23:16:32 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Josh Triplett <josh@joshtriplett.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Thread-Topic: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Thread-Index: AQHV7pdH5S0f1nvr+k6qVAg9VSe/lqg1beyA
Date:   Mon, 2 Mar 2020 23:16:32 +0000
Message-ID: <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
References: <20200229002813.GA177044@localhost>
In-Reply-To: <20200229002813.GA177044@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.216]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD4EE2F666C630468D8BA52698FD5338@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiAyLzI4LzIwLCA0OjI5IFBNLCAiSm9zaCBUcmlwbGV0dCIgPGpvc2hAam9zaHRyaXBs
ZXR0Lm9yZz4gd3JvdGU6DQoNCiAgICBCZWZvcmUgaW5pdGlhbGl6aW5nIGNvbXBsZXRpb24gcXVl
dWUgaW50ZXJydXB0cywgdGhlIGVuYSBkcml2ZXIgdXNlcw0KICAgIHBvbGxpbmcgdG8gd2FpdCBm
b3IgcmVzcG9uc2VzIG9uIHRoZSBhZG1pbiBjb21tYW5kIHF1ZXVlLiBUaGUgZW5hIGRyaXZlcg0K
ICAgIHdhaXRzIDVtcyBiZXR3ZWVuIHBvbGxzLCBidXQgdGhlIGhhcmR3YXJlIGhhcyBnZW5lcmFs
bHkgZmluaXNoZWQgbG9uZw0KICAgIGJlZm9yZSB0aGF0LiBSZWR1Y2UgdGhlIHBvbGwgdGltZSB0
byAxMHVzLg0KICAgIA0KICAgIE9uIGEgYzUuMTJ4bGFyZ2UsIHRoaXMgaW1wcm92ZXMgZW5hIGlu
aXRpYWxpemF0aW9uIHRpbWUgZnJvbSAxNzMuNm1zIHRvDQogICAgMS45MjBtcywgYW4gaW1wcm92
ZW1lbnQgb2YgbW9yZSB0aGFuIDkweC4gVGhpcyBpbXByb3ZlcyBzZXJ2ZXIgYm9vdCB0aW1lDQog
ICAgYW5kIHRpbWUgdG8gbmV0d29yayBicmluZ3VwLg0KIA0KVGhhbmtzIEpvc2gsDQpXZSBhZ3Jl
ZSB0aGF0IHBvbGxpbmcgcmF0ZSBzaG91bGQgYmUgaW5jcmVhc2VkLCBidXQgcHJlZmVyIG5vdCB0
byBkbyBpdCBhZ2dyZXNzaXZlbHkgYW5kIGJsaW5kbHkuDQpGb3IgZXhhbXBsZSBsaW5lYXIgYmFj
a29mZiBhcHByb2FjaCBtaWdodCBiZSBhIGJldHRlciBjaG9pY2UuIFBsZWFzZSBsZXQgdXMgcmUt
d29yayBhIGxpdHRsZSB0aGlzIA0KcGF0Y2ggYW5kIGJyaW5nIGl0IHRvIHJldmlldy4gVGhhbmtz
ISAgICAgIA0KICAgDQogICAgQmVmb3JlOg0KICAgIFsgICAgMC41MzE3MjJdIGNhbGxpbmcgIGVu
YV9pbml0KzB4MC8weDYzIEAgMQ0KICAgIFsgICAgMC41MzE3MjJdIGVuYTogRWxhc3RpYyBOZXR3
b3JrIEFkYXB0ZXIgKEVOQSkgdjIuMS4wSw0KICAgIFsgICAgMC41MzE3NTFdIGVuYSAwMDAwOjAw
OjA1LjA6IEVsYXN0aWMgTmV0d29yayBBZGFwdGVyIChFTkEpIHYyLjEuMEsNCiAgICBbICAgIDAu
NTMxOTQ2XSBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0RdIGVuYWJsZWQgYXQgSVJRIDExDQogICAg
WyAgICAwLjU0NzQyNV0gZW5hOiBlbmEgZGV2aWNlIHZlcnNpb246IDAuMTANCiAgICBbICAgIDAu
NTQ3NDI3XSBlbmE6IGVuYSBjb250cm9sbGVyIHZlcnNpb246IDAuMC4xIGltcGxlbWVudGF0aW9u
IHZlcnNpb24gMQ0KICAgIFsgICAgMC43MDk0OTddIGVuYSAwMDAwOjAwOjA1LjA6IEVsYXN0aWMg
TmV0d29yayBBZGFwdGVyIChFTkEpIGZvdW5kIGF0IG1lbSBmZWJmNDAwMCwgbWFjIGFkZHIgMDY6
YzQ6MjI6MGU6ZGM6ZGEsIFBsYWNlbWVudCBwb2xpY3k6IExvdyBMYXRlbmN5DQogICAgWyAgICAw
LjcwOTUwOF0gaW5pdGNhbGwgZW5hX2luaXQrMHgwLzB4NjMgcmV0dXJuZWQgMCBhZnRlciAxNzM2
MTYgdXNlY3MNCiAgICANCiAgICBBZnRlcjoNCiAgICBbICAgIDAuNTI2OTY1XSBjYWxsaW5nICBl
bmFfaW5pdCsweDAvMHg2MyBAIDENCiAgICBbICAgIDAuNTI2OTY2XSBlbmE6IEVsYXN0aWMgTmV0
d29yayBBZGFwdGVyIChFTkEpIHYyLjEuMEsNCiAgICBbICAgIDAuNTI3MDU2XSBlbmEgMDAwMDow
MDowNS4wOiBFbGFzdGljIE5ldHdvcmsgQWRhcHRlciAoRU5BKSB2Mi4xLjBLDQogICAgWyAgICAw
LjUyNzE5Nl0gUENJIEludGVycnVwdCBMaW5rIFtMTktEXSBlbmFibGVkIGF0IElSUSAxMQ0KICAg
IFsgICAgMC41MjcyMTFdIGVuYTogZW5hIGRldmljZSB2ZXJzaW9uOiAwLjEwDQogICAgWyAgICAw
LjUyNzIxMl0gZW5hOiBlbmEgY29udHJvbGxlciB2ZXJzaW9uOiAwLjAuMSBpbXBsZW1lbnRhdGlv
biB2ZXJzaW9uIDENCiAgICBbICAgIDAuNTI4OTI1XSBlbmEgMDAwMDowMDowNS4wOiBFbGFzdGlj
IE5ldHdvcmsgQWRhcHRlciAoRU5BKSBmb3VuZCBhdCBtZW0gZmViZjQwMDAsIG1hYyBhZGRyIDA2
OmM0OjIyOjBlOmRjOmRhLCBQbGFjZW1lbnQgcG9saWN5OiBMb3cgTGF0ZW5jeQ0KICAgIFsgICAg
MC41Mjg5MzRdIGluaXRjYWxsIGVuYV9pbml0KzB4MC8weDYzIHJldHVybmVkIDAgYWZ0ZXIgMTky
MCB1c2Vjcw0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IEpvc2ggVHJpcGxldHQgPGpvc2hAam9z
aHRyaXBsZXR0Lm9yZz4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9u
L2VuYS9lbmFfY29tLmMgfCAyMiArKysrKysrKysrKystLS0tLS0tLS0tDQogICAgIDEgZmlsZSBj
aGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCiAgICANCiAgICBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfY29tLmMgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9jb20uYw0KICAgIGluZGV4IDFmYjU4Zjlh
ZDgwYi4uMjAzYjIxMzBkNzA3IDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FtYXpvbi9lbmEvZW5hX2NvbS5jDQogICAgKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1h
em9uL2VuYS9lbmFfY29tLmMNCiAgICBAQCAtNjIsNyArNjIsNyBAQA0KICAgICANCiAgICAgI2Rl
ZmluZSBFTkFfUkVHU19BRE1JTl9JTlRSX01BU0sgMQ0KICAgICANCiAgICAtI2RlZmluZSBFTkFf
UE9MTF9NUwk1DQogICAgKyNkZWZpbmUgRU5BX1BPTExfVVMJMTANCiAgICAgDQogICAgIC8qKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKi8NCiAgICAgLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLw0KICAgIEBAIC01
NzIsNyArNTcyLDcgQEAgc3RhdGljIGludCBlbmFfY29tX3dhaXRfYW5kX3Byb2Nlc3NfYWRtaW5f
Y3FfcG9sbGluZyhzdHJ1Y3QgZW5hX2NvbXBfY3R4ICpjb21wX2MNCiAgICAgCQkJZ290byBlcnI7
DQogICAgIAkJfQ0KICAgICANCiAgICAtCQltc2xlZXAoRU5BX1BPTExfTVMpOw0KICAgICsJCXVz
bGVlcF9yYW5nZShFTkFfUE9MTF9VUywgMiAqIEVOQV9QT0xMX1VTKTsNCiAgICAgCX0NCiAgICAg
DQogICAgIAlpZiAodW5saWtlbHkoY29tcF9jdHgtPnN0YXR1cyA9PSBFTkFfQ01EX0FCT1JURUQp
KSB7DQogICAgQEAgLTk0MywxMiArOTQzLDEzIEBAIHN0YXRpYyB2b2lkIGVuYV9jb21faW9fcXVl
dWVfZnJlZShzdHJ1Y3QgZW5hX2NvbV9kZXYgKmVuYV9kZXYsDQogICAgIHN0YXRpYyBpbnQgd2Fp
dF9mb3JfcmVzZXRfc3RhdGUoc3RydWN0IGVuYV9jb21fZGV2ICplbmFfZGV2LCB1MzIgdGltZW91
dCwNCiAgICAgCQkJCXUxNiBleHBfc3RhdGUpDQogICAgIHsNCiAgICAtCXUzMiB2YWwsIGk7DQog
ICAgKwl1MzIgdmFsOw0KICAgICsJdW5zaWduZWQgbG9uZyB0aW1lb3V0X2ppZmZpZXM7DQogICAg
IA0KICAgIC0JLyogQ29udmVydCB0aW1lb3V0IGZyb20gcmVzb2x1dGlvbiBvZiAxMDBtcyB0byBF
TkFfUE9MTF9NUyAqLw0KICAgIC0JdGltZW91dCA9ICh0aW1lb3V0ICogMTAwKSAvIEVOQV9QT0xM
X01TOw0KICAgICsJLyogQ29udmVydCB0aW1lb3V0IGZyb20gcmVzb2x1dGlvbiBvZiAxMDBtcyAq
Lw0KICAgICsJdGltZW91dF9qaWZmaWVzID0gamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXModGlt
ZW91dCAqIDEwMCk7DQogICAgIA0KICAgIC0JZm9yIChpID0gMDsgaSA8IHRpbWVvdXQ7IGkrKykg
ew0KICAgICsJd2hpbGUgKDEpIHsNCiAgICAgCQl2YWwgPSBlbmFfY29tX3JlZ19iYXJfcmVhZDMy
KGVuYV9kZXYsIEVOQV9SRUdTX0RFVl9TVFNfT0ZGKTsNCiAgICAgDQogICAgIAkJaWYgKHVubGlr
ZWx5KHZhbCA9PSBFTkFfTU1JT19SRUFEX1RJTUVPVVQpKSB7DQogICAgQEAgLTk2MCwxMCArOTYx
LDExIEBAIHN0YXRpYyBpbnQgd2FpdF9mb3JfcmVzZXRfc3RhdGUoc3RydWN0IGVuYV9jb21fZGV2
ICplbmFfZGV2LCB1MzIgdGltZW91dCwNCiAgICAgCQkJZXhwX3N0YXRlKQ0KICAgICAJCQlyZXR1
cm4gMDsNCiAgICAgDQogICAgLQkJbXNsZWVwKEVOQV9QT0xMX01TKTsNCiAgICAtCX0NCiAgICAr
CQlpZiAodGltZV9pc19iZWZvcmVfamlmZmllcyh0aW1lb3V0X2ppZmZpZXMpKQ0KICAgICsJCQly
ZXR1cm4gLUVUSU1FOw0KICAgICANCiAgICAtCXJldHVybiAtRVRJTUU7DQogICAgKwkJdXNsZWVw
X3JhbmdlKEVOQV9QT0xMX1VTLCAyICogRU5BX1BPTExfVVMpOw0KICAgICsJfQ0KICAgICB9DQog
ICAgIA0KICAgICBzdGF0aWMgYm9vbCBlbmFfY29tX2NoZWNrX3N1cHBvcnRlZF9mZWF0dXJlX2lk
KHN0cnVjdCBlbmFfY29tX2RldiAqZW5hX2RldiwNCiAgICBAQCAtMTQ1OCw3ICsxNDYwLDcgQEAg
dm9pZCBlbmFfY29tX3dhaXRfZm9yX2Fib3J0X2NvbXBsZXRpb24oc3RydWN0IGVuYV9jb21fZGV2
ICplbmFfZGV2KQ0KICAgICAJc3Bpbl9sb2NrX2lycXNhdmUoJmFkbWluX3F1ZXVlLT5xX2xvY2ss
IGZsYWdzKTsNCiAgICAgCXdoaWxlIChhdG9taWNfcmVhZCgmYWRtaW5fcXVldWUtPm91dHN0YW5k
aW5nX2NtZHMpICE9IDApIHsNCiAgICAgCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZhZG1pbl9x
dWV1ZS0+cV9sb2NrLCBmbGFncyk7DQogICAgLQkJbXNsZWVwKEVOQV9QT0xMX01TKTsNCiAgICAr
CQl1c2xlZXBfcmFuZ2UoRU5BX1BPTExfVVMsIDIgKiBFTkFfUE9MTF9VUyk7DQogICAgIAkJc3Bp
bl9sb2NrX2lycXNhdmUoJmFkbWluX3F1ZXVlLT5xX2xvY2ssIGZsYWdzKTsNCiAgICAgCX0NCiAg
ICAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFkbWluX3F1ZXVlLT5xX2xvY2ssIGZsYWdzKTsN
CiAgICAtLSANCiAgICAyLjI1LjENCiAgICANCiAgICANCg0K
