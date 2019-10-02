Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A144C934D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfJBVLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:11:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:57883 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbfJBVLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 17:11:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 14:11:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="205435824"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga001.fm.intel.com with ESMTP; 02 Oct 2019 14:11:51 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 2 Oct 2019 14:11:51 -0700
Received: from orsmsx114.amr.corp.intel.com ([169.254.8.55]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.93]) with mapi id 14.03.0439.000;
 Wed, 2 Oct 2019 14:11:50 -0700
From:   "Duyck, Alexander H" <alexander.h.duyck@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "johunt@akamai.com" <johunt@akamai.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "willemb@google.com" <willemb@google.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net v2 2/2] udp: only do GSO if # of segs > 1
Thread-Topic: [PATCH net v2 2/2] udp: only do GSO if # of segs > 1
Thread-Index: AQHVeUbsqE3fexPfaUW7WEMvU/rMp6dITs4A
Date:   Wed, 2 Oct 2019 21:11:50 +0000
Message-ID: <5d19e8d2fe1c54ef3c94b40805e8d8d78625557c.camel@intel.com>
References: <1570037363-12485-1-git-send-email-johunt@akamai.com>
         <1570037363-12485-2-git-send-email-johunt@akamai.com>
In-Reply-To: <1570037363-12485-2-git-send-email-johunt@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.7.198.76]
Content-Type: text/plain; charset="utf-8"
Content-ID: <75E1E530C794ED4D9369AC127AA34AEC@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTAyIGF0IDEzOjI5IC0wNDAwLCBKb3NoIEh1bnQgd3JvdGU6DQo+IFBy
aW9yIHRvIHRoaXMgY2hhbmdlIGFuIGFwcGxpY2F0aW9uIHNlbmRpbmcgPD0gMU1TUyB3b3J0aCBv
ZiBkYXRhIGFuZA0KPiBlbmFibGluZyBVRFAgR1NPIHdvdWxkIGZhaWwgaWYgdGhlIHN5c3RlbSBo
YWQgU1cgR1NPIGVuYWJsZWQsIGJ1dCB0aGUNCj4gc2FtZSBzZW5kIHdvdWxkIHN1Y2NlZWQgaWYg
SFcgR1NPIG9mZmxvYWQgaXMgZW5hYmxlZC4gSW4gYWRkaXRpb24gdG8gdGhpcw0KPiBpbmNvbnNp
c3RlbmN5IHRoZSBlcnJvciBpbiB0aGUgU1cgR1NPIGNhc2UgZG9lcyBub3QgZ2V0IGJhY2sgdG8g
dGhlDQo+IGFwcGxpY2F0aW9uIGlmIHNlbmRpbmcgb3V0IG9mIGEgcmVhbCBkZXZpY2Ugc28gdGhl
IHVzZXIgaXMgdW5hd2FyZSBvZiB0aGlzDQo+IGZhaWx1cmUuDQo+IA0KPiBXaXRoIHRoaXMgY2hh
bmdlIHdlIG9ubHkgcGVyZm9ybSBHU08gaWYgdGhlICMgb2Ygc2VnbWVudHMgaXMgPiAxIGV2ZW4N
Cj4gaWYgdGhlIGFwcGxpY2F0aW9uIGhhcyBlbmFibGVkIHNlZ21lbnRhdGlvbi4gSSd2ZSBhbHNv
IHVwZGF0ZWQgdGhlDQo+IHJlbGV2YW50IHVkcGdzbyBzZWxmdGVzdHMuDQo+IA0KPiBGaXhlczog
YmVjMWY2ZjY5NzM2ICgidWRwOiBnZW5lcmF0ZSBnc28gd2l0aCBVRFBfU0VHTUVOVCIpDQo+IFNp
Z25lZC1vZmYtYnk6IEpvc2ggSHVudCA8am9odW50QGFrYW1haS5jb20+DQo+IC0tLQ0KPiAgbmV0
L2lwdjQvdWRwLmMgICAgICAgICAgICAgICAgICAgICAgIHwgMTEgKysrKysrKy0tLS0NCj4gIG5l
dC9pcHY2L3VkcC5jICAgICAgICAgICAgICAgICAgICAgICB8IDExICsrKysrKystLS0tDQo+ICB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9uZXQvdWRwZ3NvLmMgfCAxNiArKysrLS0tLS0tLS0tLS0t
DQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQ0K
DQpSZXZpZXdlZC1ieTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuaC5kdXlja0BsaW51eC5p
bnRlbC5jb20+DQoNCg0K
