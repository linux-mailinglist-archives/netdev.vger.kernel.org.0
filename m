Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A9176964
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgCCAnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:43:50 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:53348 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCCAnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:43:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583196229; x=1614732229;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=uKOQzWqqml5Fl7TZfjr0DuRHte2xy5OTAcenQOkMamE=;
  b=ZzNEb/TsNK8pAnZ4CyEaY2Lww3ZfnP2Lw6BcMYuRosuvTTR7d+29e9CG
   hb2Lj3hgwd8BRHxAUS79cAppHjzP6Ji30K9vPogu08zEryKKB0TBi8pfX
   LwFr8opnhT5oRCtxNaBeuVomfRR3Qjpi4inFpUhpzk+saOlWY4JQrFQ8E
   Q=;
IronPort-SDR: kAO8f4mGYIFRLAhjkmfHHZgWWVrePzjKt3KgpYBUlxW2qo3v7Uy6zoxgqnUyBdiHhHFgctomlW
 6ReFvzFneNog==
X-IronPort-AV: E=Sophos;i="5.70,509,1574121600"; 
   d="scan'208";a="19190248"
Thread-Topic: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Subject: Re: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Mar 2020 00:43:37 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id ACA32A2C69;
        Tue,  3 Mar 2020 00:43:34 +0000 (UTC)
Received: from EX13D22EUB001.ant.amazon.com (10.43.166.145) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 3 Mar 2020 00:43:34 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D22EUB001.ant.amazon.com (10.43.166.145) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Mar 2020 00:43:33 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Tue, 3 Mar 2020 00:43:33 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Josh Triplett <josh@joshtriplett.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHV7pdH5S0f1nvr+k6qVAg9VSe/lqg1beyAgACQZID//4fqgA==
Date:   Tue, 3 Mar 2020 00:43:32 +0000
Message-ID: <34E786FC-1177-47B9-A13B-DE19EC4D6DA7@amazon.com>
References: <20200229002813.GA177044@localhost>
 <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
 <20200302155319.273ee513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200302155319.273ee513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.216]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0F578480E8CF642ACD763DBF5672BDE@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDMvMi8yMCwgMzo1NCBQTSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToNCg0KICAgICAgICANCiAgICANCiAgICBPbiBNb24sIDIgTWFyIDIwMjAgMjM6
MTY6MzIgKzAwMDAgTWFjaHVsc2t5LCBab3JpayB3cm90ZToNCiAgICA+IE9uIDIvMjgvMjAsIDQ6
MjkgUE0sICJKb3NoIFRyaXBsZXR0IiA8am9zaEBqb3NodHJpcGxldHQub3JnPiB3cm90ZToNCiAg
ICA+DQogICAgPiAgICAgQmVmb3JlIGluaXRpYWxpemluZyBjb21wbGV0aW9uIHF1ZXVlIGludGVy
cnVwdHMsIHRoZSBlbmEgZHJpdmVyIHVzZXMNCiAgICA+ICAgICBwb2xsaW5nIHRvIHdhaXQgZm9y
IHJlc3BvbnNlcyBvbiB0aGUgYWRtaW4gY29tbWFuZCBxdWV1ZS4gVGhlIGVuYSBkcml2ZXINCiAg
ICA+ICAgICB3YWl0cyA1bXMgYmV0d2VlbiBwb2xscywgYnV0IHRoZSBoYXJkd2FyZSBoYXMgZ2Vu
ZXJhbGx5IGZpbmlzaGVkIGxvbmcNCiAgICA+ICAgICBiZWZvcmUgdGhhdC4gUmVkdWNlIHRoZSBw
b2xsIHRpbWUgdG8gMTB1cy4NCiAgICA+DQogICAgPiAgICAgT24gYSBjNS4xMnhsYXJnZSwgdGhp
cyBpbXByb3ZlcyBlbmEgaW5pdGlhbGl6YXRpb24gdGltZSBmcm9tIDE3My42bXMgdG8NCiAgICA+
ICAgICAxLjkyMG1zLCBhbiBpbXByb3ZlbWVudCBvZiBtb3JlIHRoYW4gOTB4LiBUaGlzIGltcHJv
dmVzIHNlcnZlciBib290IHRpbWUNCiAgICA+ICAgICBhbmQgdGltZSB0byBuZXR3b3JrIGJyaW5n
dXAuDQogICAgPg0KICAgID4gVGhhbmtzIEpvc2gsDQogICAgPiBXZSBhZ3JlZSB0aGF0IHBvbGxp
bmcgcmF0ZSBzaG91bGQgYmUgaW5jcmVhc2VkLCBidXQgcHJlZmVyIG5vdCB0byBkbw0KICAgID4g
aXQgYWdncmVzc2l2ZWx5IGFuZCBibGluZGx5LiBGb3IgZXhhbXBsZSBsaW5lYXIgYmFja29mZiBh
cHByb2FjaA0KICAgID4gbWlnaHQgYmUgYSBiZXR0ZXIgY2hvaWNlLiBQbGVhc2UgbGV0IHVzIHJl
LXdvcmsgYSBsaXR0bGUgdGhpcyBwYXRjaA0KICAgID4gYW5kIGJyaW5nIGl0IHRvIHJldmlldy4g
VGhhbmtzIQ0KICAgIA0KICAgIFVwIHRvIEpvc2ggaWYgdGhpcyBpcyBmaW5lIHdpdGggaGltLCBi
dXQgaW4gbXkgZXhwZXJpZW5jZSAibGV0IHVzIHJld29yaw0KICAgIHlvdXIgcGF0Y2ggYmVoaW5k
IHRoZSBjbG9zZSBkb29ycyIgaXMgbm90IHRoZSByZXNwb25zZSBvcGVuIHNvdXJjZQ0KICAgIGNv
bnRyaWJ1dG9ycyBhcmUgZXhwZWN0aW5nLg0KDQpOb3Qgc3VyZSBJJ20gZm9sbG93aW5nIHdoYXQg
eW91IG1lYW4gYnkgImJlaGluZCB0aGUgY2xvc2UgZG9vciIuIEV2ZXJ5dGhpbmcgaXMgb3BlbiBo
ZXJlLg0KSSBvZmZlcmVkIHRoYXQgRU5BIGZvbGtzIHdvdWxkIHRha2UgaXQgZnVydGhlciwgYmVj
YXVzZSBzdWNoIGNoYW5nZSByZXF1aXJlICAoaW4gYWRkaXRpb24gdG8gDQpJbXBsZW1lbnRhdGlv
biBjaGFuZ2UgdGhhdCB3ZSBwcm9wb3NlKSBhIGNhcmVmdWwgIHRlc3Rpbmcgd2l0aCBkaWZmZXJl
bnQgcGxhdGZvcm1zIGFuZCANCmluc3RhbmNlIHR5cGVzLiBIYXZpbmcgc2FpZCB0aGF0LCBKb3No
LCBpZiB5b3Ugd291bGQgbGlrZSB0byB0YWtlIGNhcmUgb2YgaXQsIHdlIHdpbGwgZ2xhZGx5IGhl
bHAuDQpBbmQgdGhhbmsgeW91IGFnYWluIGZvciBjYXRjaGluZyB0aGlzISAgIA0KDQoNCiAgICAN
Cg0K
