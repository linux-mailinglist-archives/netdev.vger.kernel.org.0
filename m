Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1A5220107
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGNXZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:25:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:33724 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgGNXZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 19:25:38 -0400
IronPort-SDR: twW4AZN3/lL5cv9Vi2pI80aY10vWuq/w5oVj8kqe5nI/FtD86IgIjH+o21PcK1h3O23Juis/gv
 xFbleYQ4oG7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233902278"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="233902278"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 16:25:37 -0700
IronPort-SDR: HtCqJ64ZNd0we8/S++nAA7ie98ore7NKqY6KjQNUPeN8W4mxWyRk1FZMKC5OzUDIBKuJRoH8v6
 WCaTKfUEyPTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="285917108"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2020 16:25:36 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 16:25:36 -0700
Received: from fmsmsx121.amr.corp.intel.com ([169.254.6.72]) by
 FMSMSX113.amr.corp.intel.com ([169.254.13.121]) with mapi id 14.03.0439.000;
 Tue, 14 Jul 2020 16:25:36 -0700
From:   "Westergreen, Dalon" <dalon.westergreen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ooi, Joyce" <joyce.ooi@intel.com>,
        "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Topic: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Index: AQHWWjYTVV3ajQ05iEOFRF+KY1O0Lw==
Date:   Tue, 14 Jul 2020 23:25:35 +0000
Message-ID: <566faf7eeec336d0ecfa9bd16790d6e3042b9267.camel@intel.com>
References: <3bcb9020f0a3836f41036ddc3c8034b96e183197.camel@intel.com>
         <20200714092903.38581b74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9a8ba2616f72fb44cdc3b45fabfb4d7bdf961fd0.camel@intel.com>
         <20200714.132355.1352071851569568246.davem@davemloft.net>
In-Reply-To: <20200714.132355.1352071851569568246.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
x-originating-ip: [10.212.241.105]
Content-Type: text/plain; charset="utf-8"
Content-ID: <84D7DC58D03CEC4FA1E12EFC61151B6F@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIFR1ZSwgMjAyMC0wNy0xNCBhdCAxMzoyMyAtMDcwMCwgRGF2aWQgTWlsbGVyIHdyb3Rl
Og0KPiBGcm9tOiAiV2VzdGVyZ3JlZW4sIERhbG9uIiA8ZGFsb24ud2VzdGVyZ3JlZW5AaW50ZWwu
Y29tPg0KPiBEYXRlOiBUdWUsIDE0IEp1bCAyMDIwIDE4OjUxOjE1ICswMDAwDQo+IA0KPiA+IEkg
ZG9uJ3QgdGhpbmsgdGhpcyBpcyBuZWNlc3NhcnksIGkgdGhpbmsganVzdCBoYXZpbmcgYSBtb2R1
bGUgcGFyYW1ldGVyDQo+ID4gbWVldHMgb3VyIG5lZWRzLiAgSSBkb24ndCBzZWUgYSBuZWVkIGZv
ciB0aGUgdmFsdWUgdG8gY2hhbmdlIG9uIGEgcGVyDQo+ID4gaW50ZXJmYWNlIGJhc2lzLiAgVGhp
cyB3YXMgcHJpbWFyaWx5IHVzZWQgZHVyaW5nIHRlc3RpbmcgLyBicmluZ3VwLg0KPiANCj4gUGxl
YXNlIG5vIG1vZHVsZSBwYXJhbWV0ZXJzLi4uDQoNCkkgdGhpbmsgd2UgYXJlIGZpbmUganVzdCBo
YXJkIGNvZGluZyB0aGUgdmFsdWUuICB0aGF0IHNlZW1zIHRvIGJlIHRoZSBiZXN0IHBhdGgNCmZv
cndhcmQuDQoNCi0tZGFsb24NCg==
