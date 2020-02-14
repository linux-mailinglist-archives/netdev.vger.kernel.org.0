Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A69415FAB7
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgBNXh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:37:58 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11094 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgBNXh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:37:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581723478; x=1613259478;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=EQ7DYgwRNfv/wLxL7rAiSYHGXBWj+UpFbImhG+fPeeA=;
  b=frwXioL5A6gIcBbvs3qeVm8regPJYzCZP19izrYOZ9sgVJZwiTn/8HW8
   wKpvMxIynKFbKQ11mFgdY+D7bzZNP0lk2yFs5m6rqkAtvq81xiMDoFePX
   I+ukea/T9UdV3cqIcJJKz20FXf8tUc4WkOXC/YjOHpRLcanJ/RlS9JYeX
   8=;
IronPort-SDR: Q+WsFLrDc545+uyxEQXx2T1ZRLEWdxxBOun40BWcJP2NUiHjjlq24uaOoUb2DTvjrBMDx/6M8O
 LKQVe6HaWxjw==
X-IronPort-AV: E=Sophos;i="5.70,442,1574121600"; 
   d="scan'208";a="16799280"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Feb 2020 23:37:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id C02A6A25F4;
        Fri, 14 Feb 2020 23:37:48 +0000 (UTC)
Received: from EX13D05UWB001.ant.amazon.com (10.43.161.181) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:37:47 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13D05UWB001.ant.amazon.com (10.43.161.181) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:37:46 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1367.000;
 Fri, 14 Feb 2020 23:37:46 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH v3 00/12] Enable PM hibernation on guest VMs
Thread-Topic: [RFC PATCH v3 00/12] Enable PM hibernation on guest VMs
Thread-Index: AQHV4fPo8eXu12vqTkyMeBw6bIMui6gY9+iAgAHdmAA=
Date:   Fri, 14 Feb 2020 23:37:46 +0000
Message-ID: <F2086290-8DF5-4CD5-B142-DA9FD85D27E1@amazon.com>
References: <20200212222935.GA3421@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <87a75m3ftk.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87a75m3ftk.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.233]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EB21256422AE247A547687FA7DB3733@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBkaWQgcmVzZW5kIHRoZW0gdG9kYXkuIEFwb2xvZ2llcyBmb3IgZGVsYXkNCmh0dHBzOi8vbGtt
bC5vcmcvbGttbC8yMDIwLzIvMTQvMjc4OQ0KDQpUaGFua3MsDQpBbmNoYWwNCg0K77u/ICAgIEFu
Y2hhLA0KICAgIA0KICAgIEFuY2hhbCBBZ2Fyd2FsIDxhbmNoYWxhZ0BhbWF6b24uY29tPiB3cml0
ZXM6DQogICAgDQogICAgPiBIZWxsbywNCiAgICA+IEkgYW0gc2VuZGluZyBvdXQgYSB2MyB2ZXJz
aW9uIG9mIHNlcmllcyBvZiBwYXRjaGVzIHRoYXQgaW1wbGVtZW50cyBndWVzdA0KICAgID4gUE0g
aGliZXJuYXRpb24uDQogICAgDQogICAgY2FuIHlvdSBwcmV0dHkgcGxlYXNlIHRocmVhZCB5b3Vy
IHBhdGNoIHNlcmllcyBzbyB0aGF0IHRoZSAxLW4vbiBtYWlscw0KICAgIGhhdmUgYQ0KICAgIA0K
ICAgICAgUmVmZXJlbmNlczogPG1lc3NhZ2UtaWQtb2YtMC1vZi1uLW1haWxAd2hhdGV2ZXJ5b3Vy
Y2xpZW50cHV0c3RoZXJlPg0KICAgIA0KICAgIGluIHRoZSBoZWFkZXJzPyBnaXQtc2VuZC1lbWFp
bCBkb2VzIHRoYXQgcHJvcGVyIGFzIGRvIG90aGVyIHRvb2xzLg0KICAgIA0KICAgIENvbGxlY3Rp
bmcgdGhlIGluZGl2aWR1YWwgbWFpbHMgaXMgcGFpbmZ1bC4NCiAgICANCiAgICBUaGFua3MsDQog
ICAgDQogICAgICAgICAgICB0Z2x4DQogICAgDQoNCg==
