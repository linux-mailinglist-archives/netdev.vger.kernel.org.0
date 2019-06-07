Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B204F39689
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 22:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfFGUMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 16:12:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:46026 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbfFGUMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 16:12:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 13:12:34 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jun 2019 13:12:33 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 7 Jun 2019 13:12:33 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.133]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.126]) with mapi id 14.03.0415.000;
 Fri, 7 Jun 2019 13:12:33 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Colin King <colin.king@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next][V2] ixgbe: fix potential u32 overflow on shift
Thread-Topic: [PATCH][next][V2] ixgbe: fix potential u32 overflow on shift
Thread-Index: AQHVHV2OjqHrl9oJCUOLbN4+Vk3DLaaQn9mg
Date:   Fri, 7 Jun 2019 20:12:33 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589674F4D9@ORSMSX121.amr.corp.intel.com>
References: <20190607181920.23339-1-colin.king@canonical.com>
In-Reply-To: <20190607181920.23339-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDgzYTI2MjctYWRmOC00MzIyLTg3ZjktYmQ4ZWJhZjYxNjQ2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiXC9BM3NKY01ieTVneE1rRWRGbldvZWlRYjVJT01DZHByNTJodE15bEkrc3RJM1hYTks1TVE0dDFlMmV3TEw0M2wifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBLaW5nIFttYWlsdG86
Y29saW4ua2luZ0BjYW5vbmljYWwuY29tXQ0KPiBTZW50OiBGcmlkYXksIEp1bmUgMDcsIDIwMTkg
MTE6MTkgQU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29t
PjsgS2lyc2hlciwgSmVmZnJleSBUDQo+IDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+OyBE
YXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgaW50ZWwtd2lyZWQtDQo+IGxh
bkBsaXN0cy5vc3Vvc2wub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrZXJuZWwt
amFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFtQQVRDSF1bbmV4dF1bVjJdIGl4Z2JlOiBmaXggcG90ZW50aWFsIHUzMiBvdmVy
ZmxvdyBvbiBzaGlmdA0KPiANCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fu
b25pY2FsLmNvbT4NCj4gDQo+IFRoZSB1MzIgdmFyaWFibGUgcmVtIGlzIGJlaW5nIHNoaWZ0ZWQg
dXNpbmcgdTMyIGFyaXRobWV0aWMgaG93ZXZlcg0KPiBpdCBpcyBiZWluZyBwYXNzZWQgdG8gZGl2
X3U2NCB0aGF0IGV4cGVjdHMgdGhlIGV4cHJlc3Npb24gdG8gYmUgYSB1NjQuDQo+IFRoZSAzMiBi
aXQgc2hpZnQgbWF5IHBvdGVudGlhbGx5IG92ZXJmbG93LCBzbyBjYXN0IHJlbSB0byBhIHU2NCBi
ZWZvcmUNCj4gc2hpZnRpbmcgdG8gYXZvaWQgdGhpcy4gIEFsc28gcmVtb3ZlIGNvbW1lbnQgYWJv
dXQgb3ZlcmZsb3cuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiVW5pbnRlbnRpb25hbCBp
bnRlZ2VyIG92ZXJmbG93IikNCj4gRml4ZXM6IGNkNDU4MzIwNjk5MCAoIml4Z2JlOiBpbXBsZW1l
bnQgc3VwcG9ydCBmb3IgU0RQL1BQUyBvdXRwdXQgb24gWDU1MA0KPiBoYXJkd2FyZSIpDQo+IEZp
eGVzOiA2OGQ5Njc2ZmMwNGUgKCJpeGdiZTogZml4IFBUUCBTRFAgcGluIHNldHVwIG9uIFg1NDAg
aGFyZHdhcmUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0Bj
YW5vbmljYWwuY29tPg0KPiAtLS0NCj4gDQo+IFYyOiB1cGRhdGUgY29tbWVudA0KDQpUaGFua3Mg
Q29saW4hDQoNCkFja2VkLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNv
bT4NCg0KUmVnYXJkcywNCkpha2UNCg0KPiANCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9peGdiZS9peGdiZV9wdHAuYyB8IDE0ICsrKystLS0tLS0tLS0tDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9wdHAuYw0KPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3B0cC5jDQo+IGluZGV4IDJjNGQz
MjdmY2MyZS4uMGJlMTNhOTBmZjc5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9peGdiZS9peGdiZV9wdHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9peGdiZS9peGdiZV9wdHAuYw0KPiBAQCAtMjA1LDExICsyMDUsOCBAQCBzdGF0aWMgdm9p
ZCBpeGdiZV9wdHBfc2V0dXBfc2RwX1g1NDAoc3RydWN0DQo+IGl4Z2JlX2FkYXB0ZXIgKmFkYXB0
ZXIpDQo+ICAJICovDQo+ICAJcmVtID0gKE5TX1BFUl9TRUMgLSByZW0pOw0KPiANCj4gLQkvKiBB
ZGp1c3QgdGhlIGNsb2NrIGVkZ2UgdG8gYWxpZ24gd2l0aCB0aGUgbmV4dCBmdWxsIHNlY29uZC4g
VGhpcw0KPiAtCSAqIGFzc3VtZXMgdGhhdCB0aGUgY3ljbGUgY291bnRlciBzaGlmdCBpcyBzbWFs
bCBlbm91Z2ggdG8gYXZvaWQNCj4gLQkgKiBvdmVyZmxvd2luZyB3aGVuIHNoaWZ0aW5nIHRoZSBy
ZW1haW5kZXIuDQo+IC0JICovDQo+IC0JY2xvY2tfZWRnZSArPSBkaXZfdTY0KChyZW0gPDwgY2Mt
PnNoaWZ0KSwgY2MtPm11bHQpOw0KPiArCS8qIEFkanVzdCB0aGUgY2xvY2sgZWRnZSB0byBhbGln
biB3aXRoIHRoZSBuZXh0IGZ1bGwgc2Vjb25kLiAqLw0KPiArCWNsb2NrX2VkZ2UgKz0gZGl2X3U2
NCgoKHU2NClyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQpOw0KPiAgCXRyZ3R0aW1sID0gKHUz
MiljbG9ja19lZGdlOw0KPiAgCXRyZ3R0aW1oID0gKHUzMikoY2xvY2tfZWRnZSA+PiAzMik7DQo+
IA0KPiBAQCAtMjkxLDExICsyODgsOCBAQCBzdGF0aWMgdm9pZCBpeGdiZV9wdHBfc2V0dXBfc2Rw
X1g1NTAoc3RydWN0DQo+IGl4Z2JlX2FkYXB0ZXIgKmFkYXB0ZXIpDQo+ICAJICovDQo+ICAJcmVt
ID0gKE5TX1BFUl9TRUMgLSByZW0pOw0KPiANCj4gLQkvKiBBZGp1c3QgdGhlIGNsb2NrIGVkZ2Ug
dG8gYWxpZ24gd2l0aCB0aGUgbmV4dCBmdWxsIHNlY29uZC4gVGhpcw0KPiAtCSAqIGFzc3VtZXMg
dGhhdCB0aGUgY3ljbGUgY291bnRlciBzaGlmdCBpcyBzbWFsbCBlbm91Z2ggdG8gYXZvaWQNCj4g
LQkgKiBvdmVyZmxvd2luZyB3aGVuIHNoaWZ0aW5nIHRoZSByZW1haW5kZXIuDQo+IC0JICovDQo+
IC0JY2xvY2tfZWRnZSArPSBkaXZfdTY0KChyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQpOw0K
PiArCS8qIEFkanVzdCB0aGUgY2xvY2sgZWRnZSB0byBhbGlnbiB3aXRoIHRoZSBuZXh0IGZ1bGwg
c2Vjb25kLiAqLw0KPiArCWNsb2NrX2VkZ2UgKz0gZGl2X3U2NCgoKHU2NClyZW0gPDwgY2MtPnNo
aWZ0KSwgY2MtPm11bHQpOw0KPiANCj4gIAkvKiBYNTUwIGhhcmR3YXJlIHN0b3JlcyB0aGUgdGlt
ZSBpbiAzMmJpdHMgb2YgJ2JpbGxpb25zIG9mIGN5Y2xlcycgYW5kDQo+ICAJICogMzJiaXRzIG9m
ICdjeWNsZXMnLiBUaGVyZSdzIG5vIGd1YXJhbnRlZSB0aGF0IGN5Y2xlcyByZXByZXNlbnRzDQo+
IC0tDQo+IDIuMjAuMQ0KDQo=
