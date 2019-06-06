Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B8537EDE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFFUd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:33:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:13330 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbfFFUd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 16:33:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 13:33:26 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2019 13:33:27 -0700
Received: from orsmsx160.amr.corp.intel.com (10.22.226.43) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 6 Jun 2019 13:33:27 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.133]) by
 ORSMSX160.amr.corp.intel.com ([169.254.13.124]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 13:33:27 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Colin King <colin.king@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] ixgbe: fix potential u32 overflow on shift
Thread-Topic: [PATCH][next] ixgbe: fix potential u32 overflow on shift
Thread-Index: AQHVHGlIFzjSo2T24EekWjY0GDeFv6aPFTkQ
Date:   Thu, 6 Jun 2019 20:33:26 +0000
Message-ID: <02874ECE860811409154E81DA85FBB5896745DEE@ORSMSX121.amr.corp.intel.com>
References: <20190606131053.25103-1-colin.king@canonical.com>
In-Reply-To: <20190606131053.25103-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmMwMjZiNzItNjY5ZS00ZjI4LWE3ZTktODlhNzVjN2FkZDViIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS2l5ZlhmeUtkUG9kYUNhZFJlZEU0K1ArK2N4aEIzQTFvc3ZCc3hOMmlTVzBCbitDWHVsUnd3TjNcL2t2VnBJMWMifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBLaW5nIFttYWlsdG86
Y29saW4ua2luZ0BjYW5vbmljYWwuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSAwNiwgMjAx
OSA2OjExIEFNDQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNv
bT47IEtpcnNoZXIsIEplZmZyZXkgVA0KPiA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tPjsg
RGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IGludGVsLXdpcmVkLQ0KPiBs
YW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzoga2VybmVs
LWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBbUEFUQ0hdW25leHRdIGl4Z2JlOiBmaXggcG90ZW50aWFsIHUzMiBvdmVyZmxv
dyBvbiBzaGlmdA0KPiANCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25p
Y2FsLmNvbT4NCj4gDQo+IFRoZSB1MzIgdmFyaWFibGUgcmVtIGlzIGJlaW5nIHNoaWZ0ZWQgdXNp
bmcgdTMyIGFyaXRobWV0aWMgaG93ZXZlcg0KPiBpdCBpcyBiZWluZyBwYXNzZWQgdG8gZGl2X3U2
NCB0aGF0IGV4cGVjdHMgdGhlIGV4cHJlc3Npb24gdG8gYmUgYSB1NjQuDQo+IFRoZSAzMiBiaXQg
c2hpZnQgbWF5IHBvdGVudGlhbGx5IG92ZXJmbG93LCBzbyBjYXN0IHJlbSB0byBhIHU2NCBiZWZv
cmUNCj4gc2hpZnRpbmcgdG8gYXZvaWQgdGhpcy4NCj4gDQoNCkFoLCB5ZXAuIFRoYW5rcyBmb3Ig
dGhlIGZpeCENCg0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiVW5pbnRlbnRpb25hbCBpbnRlZ2Vy
IG92ZXJmbG93IikNCj4gRml4ZXM6IGNkNDU4MzIwNjk5MCAoIml4Z2JlOiBpbXBsZW1lbnQgc3Vw
cG9ydCBmb3IgU0RQL1BQUyBvdXRwdXQgb24gWDU1MA0KPiBoYXJkd2FyZSIpDQo+IEZpeGVzOiA2
OGQ5Njc2ZmMwNGUgKCJpeGdiZTogZml4IFBUUCBTRFAgcGluIHNldHVwIG9uIFg1NDAgaGFyZHdh
cmUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmlj
YWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2Jl
X3B0cC5jIHwgNCArKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2l4Z2JlL2l4Z2JlX3B0cC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUv
aXhnYmVfcHRwLmMNCj4gaW5kZXggMmM0ZDMyN2ZjYzJlLi5mZjIyOWQwZTkxNDYgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3B0cC5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3B0cC5jDQo+IEBAIC0y
MDksNyArMjA5LDcgQEAgc3RhdGljIHZvaWQgaXhnYmVfcHRwX3NldHVwX3NkcF9YNTQwKHN0cnVj
dCBpeGdiZV9hZGFwdGVyDQo+ICphZGFwdGVyKQ0KPiAgCSAqIGFzc3VtZXMgdGhhdCB0aGUgY3lj
bGUgY291bnRlciBzaGlmdCBpcyBzbWFsbCBlbm91Z2ggdG8gYXZvaWQNCj4gIAkgKiBvdmVyZmxv
d2luZyB3aGVuIHNoaWZ0aW5nIHRoZSByZW1haW5kZXIuDQo+ICAJICovDQo+IC0JY2xvY2tfZWRn
ZSArPSBkaXZfdTY0KChyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQpOw0KPiArCWNsb2NrX2Vk
Z2UgKz0gZGl2X3U2NCgoKHU2NClyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQpOw0KPiAgCXRy
Z3R0aW1sID0gKHUzMiljbG9ja19lZGdlOw0KPiAgCXRyZ3R0aW1oID0gKHUzMikoY2xvY2tfZWRn
ZSA+PiAzMik7DQo+IA0KDQpUaGlzIG1ha2VzIHNlbnNlIHRvIG1lLg0KDQpSZWdhcmRzLA0KSmFr
ZQ0KDQo+IEBAIC0yOTUsNyArMjk1LDcgQEAgc3RhdGljIHZvaWQgaXhnYmVfcHRwX3NldHVwX3Nk
cF9YNTUwKHN0cnVjdCBpeGdiZV9hZGFwdGVyDQo+ICphZGFwdGVyKQ0KPiAgCSAqIGFzc3VtZXMg
dGhhdCB0aGUgY3ljbGUgY291bnRlciBzaGlmdCBpcyBzbWFsbCBlbm91Z2ggdG8gYXZvaWQNCj4g
IAkgKiBvdmVyZmxvd2luZyB3aGVuIHNoaWZ0aW5nIHRoZSByZW1haW5kZXIuDQo+ICAJICovDQo+
IC0JY2xvY2tfZWRnZSArPSBkaXZfdTY0KChyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQpOw0K
PiArCWNsb2NrX2VkZ2UgKz0gZGl2X3U2NCgoKHU2NClyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11
bHQpOw0KPiANCj4gIAkvKiBYNTUwIGhhcmR3YXJlIHN0b3JlcyB0aGUgdGltZSBpbiAzMmJpdHMg
b2YgJ2JpbGxpb25zIG9mIGN5Y2xlcycgYW5kDQo+ICAJICogMzJiaXRzIG9mICdjeWNsZXMnLiBU
aGVyZSdzIG5vIGd1YXJhbnRlZSB0aGF0IGN5Y2xlcyByZXByZXNlbnRzDQo+IC0tDQo+IDIuMjAu
MQ0KDQo=
