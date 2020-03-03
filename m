Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3AD176996
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgCCAx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:53:59 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:54924 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCCAx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583196839; x=1614732839;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=z2mEtjVc+3qxbOIN1ODX6CdFnbqr8Yktz8yDqqS0dTE=;
  b=GqkgTjvOy5ab2LbAJar43dW5iM2yNPd8D9yol+hhsOjKgsl1qlvqw94h
   BU5JiysUYCQxVHOLI0rFZbQyMr1ay6jlNcmRuWbsWN1DajZVT1CpraL6a
   gjYeWNzhyEV1x2ZARCERoRmgzxVpRr/C0dfb9MCi0q4gJYR/IzTnd9Ik3
   o=;
IronPort-SDR: fvj+Txs+AvGR/+kJfN93GCrWcowDVEQyROp23varxy2dG1upmgNQGcXoEY1WnzjO0mBeYV/AL4
 qdVzQp4TS3gQ==
X-IronPort-AV: E=Sophos;i="5.70,509,1574121600"; 
   d="scan'208";a="19191500"
Thread-Topic: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Subject: Re: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Mar 2020 00:53:58 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 8A6D2A2B45;
        Tue,  3 Mar 2020 00:53:56 +0000 (UTC)
Received: from EX13D22EUB001.ant.amazon.com (10.43.166.145) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 3 Mar 2020 00:53:56 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D22EUB001.ant.amazon.com (10.43.166.145) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Mar 2020 00:53:55 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Tue, 3 Mar 2020 00:53:54 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Josh Triplett <josh@joshtriplett.org>
CC:     "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHV7pdH5S0f1nvr+k6qVAg9VSe/lqg1beyAgACdZgD//33OgA==
Date:   Tue, 3 Mar 2020 00:53:54 +0000
Message-ID: <FFD8F5B1-671C-4879-94CE-EE42E2B11F62@amazon.com>
References: <20200229002813.GA177044@localhost>
 <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
 <20200303003952.GA264245@localhost>
In-Reply-To: <20200303003952.GA264245@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.216]
Content-Type: text/plain; charset="utf-8"
Content-ID: <701E372361047443920024735C628325@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDMvMi8yMCwgNDo0MCBQTSwgIkpvc2ggVHJpcGxldHQiIDxqb3NoQGpvc2h0cmlw
bGV0dC5vcmc+IHdyb3RlOg0KICAgIA0KICAgIA0KICAgIE9uIE1vbiwgTWFyIDAyLCAyMDIwIGF0
IDExOjE2OjMyUE0gKzAwMDAsIE1hY2h1bHNreSwgWm9yaWsgd3JvdGU6DQogICAgPg0KICAgID4g
T24gMi8yOC8yMCwgNDoyOSBQTSwgIkpvc2ggVHJpcGxldHQiIDxqb3NoQGpvc2h0cmlwbGV0dC5v
cmc+IHdyb3RlOg0KICAgID4NCiAgICA+ICAgICBCZWZvcmUgaW5pdGlhbGl6aW5nIGNvbXBsZXRp
b24gcXVldWUgaW50ZXJydXB0cywgdGhlIGVuYSBkcml2ZXIgdXNlcw0KICAgID4gICAgIHBvbGxp
bmcgdG8gd2FpdCBmb3IgcmVzcG9uc2VzIG9uIHRoZSBhZG1pbiBjb21tYW5kIHF1ZXVlLiBUaGUg
ZW5hIGRyaXZlcg0KICAgID4gICAgIHdhaXRzIDVtcyBiZXR3ZWVuIHBvbGxzLCBidXQgdGhlIGhh
cmR3YXJlIGhhcyBnZW5lcmFsbHkgZmluaXNoZWQgbG9uZw0KICAgID4gICAgIGJlZm9yZSB0aGF0
LiBSZWR1Y2UgdGhlIHBvbGwgdGltZSB0byAxMHVzLg0KICAgID4NCiAgICA+ICAgICBPbiBhIGM1
LjEyeGxhcmdlLCB0aGlzIGltcHJvdmVzIGVuYSBpbml0aWFsaXphdGlvbiB0aW1lIGZyb20gMTcz
LjZtcyB0bw0KICAgID4gICAgIDEuOTIwbXMsIGFuIGltcHJvdmVtZW50IG9mIG1vcmUgdGhhbiA5
MHguIFRoaXMgaW1wcm92ZXMgc2VydmVyIGJvb3QgdGltZQ0KICAgID4gICAgIGFuZCB0aW1lIHRv
IG5ldHdvcmsgYnJpbmd1cC4NCiAgICA+DQogICAgPiBUaGFua3MgSm9zaCwNCiAgICA+IFdlIGFn
cmVlIHRoYXQgcG9sbGluZyByYXRlIHNob3VsZCBiZSBpbmNyZWFzZWQsIGJ1dCBwcmVmZXIgbm90
IHRvIGRvIGl0IGFnZ3Jlc3NpdmVseSBhbmQgYmxpbmRseS4NCiAgICA+IEZvciBleGFtcGxlIGxp
bmVhciBiYWNrb2ZmIGFwcHJvYWNoIG1pZ2h0IGJlIGEgYmV0dGVyIGNob2ljZS4gUGxlYXNlIGxl
dCB1cyByZS13b3JrIGEgbGl0dGxlIHRoaXMNCiAgICA+IHBhdGNoIGFuZCBicmluZyBpdCB0byBy
ZXZpZXcuIFRoYW5rcyENCiAgICANCiAgICBUaGF0J3MgZmluZSwgYXMgbG9uZyBhcyBpdCBoYXMg
dGhlIHNhbWUgbmV0IGltcHJvdmVtZW50IG9uIGJvb3QgdGltZS4NCiAgICANCiAgICBJJ2QgYXBw
cmVjaWF0ZSB0aGUgb3Bwb3J0dW5pdHkgdG8gdGVzdCBhbnkgYWx0ZXJuYXRlIGFwcHJvYWNoIHlv
dSBtaWdodA0KICAgIGhhdmUuDQogICAgDQogICAgKEFsc28sIGFzIGxvbmcgYXMgeW91J3JlIHdv
cmtpbmcgb24gdGhpcywgeW91IG1pZ2h0IHdpc2ggdG8gbWFrZSBhDQogICAgc2ltaWxhciBjaGFu
Z2UgdG8gdGhlIEVGQSBkcml2ZXIsIGFuZCB0byB0aGUgRnJlZUJTRCBkcml2ZXJzLikgDQoNCkFi
c29sdXRlbHkhIEFscmVhZHkgZm9yd2FyZGVkIHRoaXMgdG8gdGhlIG93bmVycyBvZiB0aGVzZSBk
cml2ZXJzLiAgVGhhbmtzIQ0KICAgIA0KICAgID4gICAgIEJlZm9yZToNCiAgICA+ICAgICBbICAg
IDAuNTMxNzIyXSBjYWxsaW5nICBlbmFfaW5pdCsweDAvMHg2MyBAIDENCiAgICA+ICAgICBbICAg
IDAuNTMxNzIyXSBlbmE6IEVsYXN0aWMgTmV0d29yayBBZGFwdGVyIChFTkEpIHYyLjEuMEsNCiAg
ICA+ICAgICBbICAgIDAuNTMxNzUxXSBlbmEgMDAwMDowMDowNS4wOiBFbGFzdGljIE5ldHdvcmsg
QWRhcHRlciAoRU5BKSB2Mi4xLjBLDQogICAgPiAgICAgWyAgICAwLjUzMTk0Nl0gUENJIEludGVy
cnVwdCBMaW5rIFtMTktEXSBlbmFibGVkIGF0IElSUSAxMQ0KICAgID4gICAgIFsgICAgMC41NDc0
MjVdIGVuYTogZW5hIGRldmljZSB2ZXJzaW9uOiAwLjEwDQogICAgPiAgICAgWyAgICAwLjU0NzQy
N10gZW5hOiBlbmEgY29udHJvbGxlciB2ZXJzaW9uOiAwLjAuMSBpbXBsZW1lbnRhdGlvbiB2ZXJz
aW9uIDENCiAgICA+ICAgICBbICAgIDAuNzA5NDk3XSBlbmEgMDAwMDowMDowNS4wOiBFbGFzdGlj
IE5ldHdvcmsgQWRhcHRlciAoRU5BKSBmb3VuZCBhdCBtZW0gZmViZjQwMDAsIG1hYyBhZGRyIDA2
OmM0OjIyOjBlOmRjOmRhLCBQbGFjZW1lbnQgcG9saWN5OiBMb3cgTGF0ZW5jeQ0KICAgID4gICAg
IFsgICAgMC43MDk1MDhdIGluaXRjYWxsIGVuYV9pbml0KzB4MC8weDYzIHJldHVybmVkIDAgYWZ0
ZXIgMTczNjE2IHVzZWNzDQogICAgPg0KICAgID4gICAgIEFmdGVyOg0KICAgID4gICAgIFsgICAg
MC41MjY5NjVdIGNhbGxpbmcgIGVuYV9pbml0KzB4MC8weDYzIEAgMQ0KICAgID4gICAgIFsgICAg
MC41MjY5NjZdIGVuYTogRWxhc3RpYyBOZXR3b3JrIEFkYXB0ZXIgKEVOQSkgdjIuMS4wSw0KICAg
ID4gICAgIFsgICAgMC41MjcwNTZdIGVuYSAwMDAwOjAwOjA1LjA6IEVsYXN0aWMgTmV0d29yayBB
ZGFwdGVyIChFTkEpIHYyLjEuMEsNCiAgICA+ICAgICBbICAgIDAuNTI3MTk2XSBQQ0kgSW50ZXJy
dXB0IExpbmsgW0xOS0RdIGVuYWJsZWQgYXQgSVJRIDExDQogICAgPiAgICAgWyAgICAwLjUyNzIx
MV0gZW5hOiBlbmEgZGV2aWNlIHZlcnNpb246IDAuMTANCiAgICA+ICAgICBbICAgIDAuNTI3MjEy
XSBlbmE6IGVuYSBjb250cm9sbGVyIHZlcnNpb246IDAuMC4xIGltcGxlbWVudGF0aW9uIHZlcnNp
b24gMQ0KICAgID4gICAgIFsgICAgMC41Mjg5MjVdIGVuYSAwMDAwOjAwOjA1LjA6IEVsYXN0aWMg
TmV0d29yayBBZGFwdGVyIChFTkEpIGZvdW5kIGF0IG1lbSBmZWJmNDAwMCwgbWFjIGFkZHIgMDY6
YzQ6MjI6MGU6ZGM6ZGEsIFBsYWNlbWVudCBwb2xpY3k6IExvdyBMYXRlbmN5DQogICAgPiAgICAg
WyAgICAwLjUyODkzNF0gaW5pdGNhbGwgZW5hX2luaXQrMHgwLzB4NjMgcmV0dXJuZWQgMCBhZnRl
ciAxOTIwIHVzZWNzDQogICAgDQoNCg==
