Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93BC39398
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbfFGRog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:20991 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfFGRog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 13:44:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 10:44:35 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jun 2019 10:44:35 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 7 Jun 2019 10:44:35 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.133]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.218]) with mapi id 14.03.0415.000;
 Fri, 7 Jun 2019 10:44:34 -0700
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
Thread-Index: AQHVHGlIFzjSo2T24EekWjY0GDeFv6aQeFNA
Date:   Fri, 7 Jun 2019 17:44:34 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589674E8A9@ORSMSX121.amr.corp.intel.com>
References: <20190606131053.25103-1-colin.king@canonical.com>
In-Reply-To: <20190606131053.25103-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzQ0NTdiMjYtMzdlZi00YjZkLWE1ZjgtNWZiMzNhYWZiMWNjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoic05lQVM1c3BPcGRjQk1xaXFsUVNnUEY1U1Z3cFcwdUxxV3ZEdGpcLzh3T1QyZFUwQ2hkS3VMeTJHUTFVXC9cL0FWUiJ9
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
cmUNCj4gc2hpZnRpbmcgdG8gYXZvaWQgdGhpcy4NCj4gDQo+IEFkZHJlc3Nlcy1Db3Zlcml0eTog
KCJVbmludGVudGlvbmFsIGludGVnZXIgb3ZlcmZsb3ciKQ0KPiBGaXhlczogY2Q0NTgzMjA2OTkw
ICgiaXhnYmU6IGltcGxlbWVudCBzdXBwb3J0IGZvciBTRFAvUFBTIG91dHB1dCBvbiBYNTUwDQo+
IGhhcmR3YXJlIikNCj4gRml4ZXM6IDY4ZDk2NzZmYzA0ZSAoIml4Z2JlOiBmaXggUFRQIFNEUCBw
aW4gc2V0dXAgb24gWDU0MCBoYXJkd2FyZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBL
aW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfcHRwLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfcHRwLmMNCj4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9wdHAuYw0KPiBpbmRleCAyYzRkMzI3ZmNjMmUu
LmZmMjI5ZDBlOTE0NiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aXhnYmUvaXhnYmVfcHRwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhn
YmUvaXhnYmVfcHRwLmMNCj4gQEAgLTIwOSw3ICsyMDksNyBAQCBzdGF0aWMgdm9pZCBpeGdiZV9w
dHBfc2V0dXBfc2RwX1g1NDAoc3RydWN0IGl4Z2JlX2FkYXB0ZXINCj4gKmFkYXB0ZXIpDQo+ICAJ
ICogYXNzdW1lcyB0aGF0IHRoZSBjeWNsZSBjb3VudGVyIHNoaWZ0IGlzIHNtYWxsIGVub3VnaCB0
byBhdm9pZA0KPiAgCSAqIG92ZXJmbG93aW5nIHdoZW4gc2hpZnRpbmcgdGhlIHJlbWFpbmRlci4N
Cj4gIAkgKi8NCg0KV2l0aCB0aGlzIGNoYW5nZSwgdGhlIGNvbW1lbnQgYWJvdmUgdGhlIGRpdl91
NjQgZG9lc24ndCBtYWtlIG11Y2ggc2Vuc2UuIEkgd291bGQgYWxzbyBkcm9wIHRoZSBwYXJ0IGFi
b3V0IHRoZSBhc3N1bWluZyBpdCB3b24ndCBvdmVyZmxvdyB0aGUgcmVtYWluZGVyLg0KDQo+IC0J
Y2xvY2tfZWRnZSArPSBkaXZfdTY0KChyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQpOw0KPiAr
CWNsb2NrX2VkZ2UgKz0gZGl2X3U2NCgoKHU2NClyZW0gPDwgY2MtPnNoaWZ0KSwgY2MtPm11bHQp
Ow0KPiAgCXRyZ3R0aW1sID0gKHUzMiljbG9ja19lZGdlOw0KPiAgCXRyZ3R0aW1oID0gKHUzMiko
Y2xvY2tfZWRnZSA+PiAzMik7DQo+IA0KPiBAQCAtMjk1LDcgKzI5NSw3IEBAIHN0YXRpYyB2b2lk
IGl4Z2JlX3B0cF9zZXR1cF9zZHBfWDU1MChzdHJ1Y3QgaXhnYmVfYWRhcHRlcg0KPiAqYWRhcHRl
cikNCj4gIAkgKiBhc3N1bWVzIHRoYXQgdGhlIGN5Y2xlIGNvdW50ZXIgc2hpZnQgaXMgc21hbGwg
ZW5vdWdoIHRvIGF2b2lkDQo+ICAJICogb3ZlcmZsb3dpbmcgd2hlbiBzaGlmdGluZyB0aGUgcmVt
YWluZGVyLg0KPiAgCSAqLw0KDQpTYW1lIGhlcmUuDQoNClRoYW5rcywNCkpha2UNCg0KPiAtCWNs
b2NrX2VkZ2UgKz0gZGl2X3U2NCgocmVtIDw8IGNjLT5zaGlmdCksIGNjLT5tdWx0KTsNCj4gKwlj
bG9ja19lZGdlICs9IGRpdl91NjQoKCh1NjQpcmVtIDw8IGNjLT5zaGlmdCksIGNjLT5tdWx0KTsN
Cj4gDQo+ICAJLyogWDU1MCBoYXJkd2FyZSBzdG9yZXMgdGhlIHRpbWUgaW4gMzJiaXRzIG9mICdi
aWxsaW9ucyBvZiBjeWNsZXMnIGFuZA0KPiAgCSAqIDMyYml0cyBvZiAnY3ljbGVzJy4gVGhlcmUn
cyBubyBndWFyYW50ZWUgdGhhdCBjeWNsZXMgcmVwcmVzZW50cw0KPiAtLQ0KPiAyLjIwLjENCg0K
