Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF46ABD13F
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406479AbfIXSMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:12:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:18482 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388114AbfIXSMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:12:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 11:12:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,545,1559545200"; 
   d="scan'208";a="203431922"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga001.fm.intel.com with ESMTP; 24 Sep 2019 11:12:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 11:12:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Sep 2019 11:12:43 -0700
Received: from crsmsx103.amr.corp.intel.com (172.18.63.31) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Sep 2019 11:12:43 -0700
Received: from crsmsx101.amr.corp.intel.com ([169.254.1.249]) by
 CRSMSX103.amr.corp.intel.com ([169.254.4.8]) with mapi id 14.03.0439.000;
 Tue, 24 Sep 2019 12:12:41 -0600
From:   "Guedes, Andre" <andre.guedes@intel.com>
To:     "Gomes, Vinicius" <vinicius.gomes@intel.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v3] net/sched: cbs: Fix not adding cbs instance to
 list
Thread-Topic: [PATCH net v3] net/sched: cbs: Fix not adding cbs instance to
 list
Thread-Index: AQHVcpW3N4QUhwP2FkWb9wAJwQL90Kc7hriA
Date:   Tue, 24 Sep 2019 18:12:41 +0000
Message-ID: <99755D97-F59A-4E68-87AE-6CE88EDE66A3@intel.com>
References: <20190924050458.14223-1-vinicius.gomes@intel.com>
In-Reply-To: <20190924050458.14223-1-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.12.61]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D513906FBC5AA4D8D6077C8CD6107AE@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMsDQoNCj4gT24gU2VwIDIzLCAyMDE5LCBhdCAxMDowNCBQTSwgVmluaWNpdXMg
Q29zdGEgR29tZXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiBUaGUg
cHJvYmxlbSBoYXBwZW5zIGJlY2F1c2UgdGhhdCB3aGVuIG9mZmxvYWRpbmcgaXMgZW5hYmxlZCwg
dGhlIGNicw0KPiBpbnN0YW5jZSBpcyBub3QgYWRkZWQgdG8gdGhlIGxpc3QuDQo+IA0KPiBBbHNv
LCB0aGUgY3VycmVudCBjb2RlIGRvZXNuJ3QgaGFuZGxlIGNvcnJlY3RseSB0aGUgY2FzZSB3aGVu
IG9mZmxvYWQNCj4gaXMgZGlzYWJsZWQgd2l0aG91dCByZW1vdmluZyB0aGUgcWRpc2M6IGlmIHRo
ZSBsaW5rIHNwZWVkIGNoYW5nZXMgdGhlDQo+IGNyZWRpdCBjYWxjdWxhdGlvbnMgd2lsbCBiZSB3
cm9uZy4gV2hlbiB3ZSBjcmVhdGUgdGhlIGNicyBpbnN0YW5jZQ0KPiB3aXRoIG9mZmxvYWRpbmcg
ZW5hYmxlZCwgaXQncyBub3QgYWRkZWQgdG8gdGhlIG5vdGlmaWNhdGlvbiBsaXN0LCB3aGVuDQo+
IGxhdGVyIHdlIGRpc2FibGUgb2ZmbG9hZGluZywgaXQncyBub3QgaW4gdGhlIGxpc3QsIHNvIGxp
bmsgc3BlZWQNCj4gY2hhbmdlcyB3aWxsIG5vdCBhZmZlY3QgaXQuDQo+IA0KPiBUaGUgc29sdXRp
b24gZm9yIGJvdGggaXNzdWVzIGlzIHRoZSBzYW1lLCBhZGQgdGhlIGNicyBpbnN0YW5jZSBiZWlu
Zw0KPiBjcmVhdGVkIHVuY29uZGl0aW9uYWxseSB0byB0aGUgZ2xvYmFsIGxpc3QsIGV2ZW4gaWYg
dGhlIGxpbmsgc3RhdGUNCj4gbm90aWZpY2F0aW9uIGlzbid0IHVzZWZ1bCAicmlnaHQgbm93Ii4N
Cg0KSSBiZWxpZXZlIHdlIGNvdWxkIGZpeCBib3RoIGlzc3VlcyBkZXNjcmliZWQgYWJvdmUgYW5k
IHN0aWxsIGRvbuKAmXQgbm90aWZ5IHRoZSBxZGlzYyBhYm91dCBsaW5rIHN0YXRlIGlmIHdlIGhh
bmRsZWQgdGhlIGxpc3QgaW5zZXJ0aW9uL3JlbW92YWwgaW4gY2JzX2NoYW5nZSgpIGluc3RlYWQu
DQoNClJlYWRpbmcgdGhlIGNicyBjb2RlIG1vcmUgY2FyZWZ1bGx5LCBpdCBzZWVtcyBpdCB3b3Vs
ZCBiZSBiZW5lZmljaWFsIHRvIHJlZmFjdG9yIHRoZSBvZmZsb2FkIGhhbmRsaW5nLiBGb3IgZXhh
bXBsZSwgd2UgY3VycmVudGx5IGluaXQgdGhlIHFkaXNjX3dhdGNoZG9nIGV2ZW4gaWYgaXTigJlz
IG5vdCB1c2VmdWwgd2hlbiBvZmZsb2FkIGlzIGVuYWJsZWQuIE5vdywgd2XigJlyZSBnb2luZyB0
byBub3RpZnkgdGhlIHFkaXNjIGV2ZW4gaWYgaXTigJlzIG5vdCB1c2VmdWwgdG9vLg0KDQpSZWdh
cmRzLA0KDQpBbmRyZQ==
