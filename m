Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9B4212ED1
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGBV04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:26:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:39244 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGBV04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 17:26:56 -0400
IronPort-SDR: 1q471oQdgbQrDWnZQ4Pw9dutykFxsaGMOFbUaVRBaUwiPID3OCDoSnAvuNcjonqZKMNtSAneDr
 Lp4IP/y/p8Zw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="208554509"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="208554509"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 14:26:55 -0700
IronPort-SDR: 0MZzjM4DFGHlsFVTM8qf3gqTdlV0ESr39xpt6nVRtN+B59e3c98ZtncYDrKdiDRnsdYnR0Js9q
 xqdhDQmrXq6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="387449103"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 02 Jul 2020 14:26:55 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 14:26:55 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.81]) with mapi id 14.03.0439.000;
 Thu, 2 Jul 2020 14:26:54 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Francesco Ruggeri <fruggeri@arista.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Thread-Topic: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Thread-Index: AQHWTlrL81g79hVuZ0aaoDgUuhrbt6jwv/UAgABMxoCAAOZwIIADNT2A//+SuOCAAHnrAP//nSAg
Date:   Thu, 2 Jul 2020 21:26:54 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498748DAB@ORSMSX112.amr.corp.intel.com>
References: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
 <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+HUmGjHQPUh1frfy5E28Om9WTVr0W+UQVDsm99beC_mbTeMog@mail.gmail.com>
 <61CC2BC414934749BD9F5BF3D5D940449874358A@ORSMSX112.amr.corp.intel.com>
 <CA+HUmGhfxYY5QiwF8_UYbp0TY-k3u+cTYZDSqV1s=SUFnGCn8g@mail.gmail.com>
 <61CC2BC414934749BD9F5BF3D5D9404498748B57@ORSMSX112.amr.corp.intel.com>
 <CA+HUmGi6D8Ci5fk7vyengJN4qOEH6zz18Kw6B9Us-Kav-78oAg@mail.gmail.com>
In-Reply-To: <CA+HUmGi6D8Ci5fk7vyengJN4qOEH6zz18Kw6B9Us-Kav-78oAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGcmFuY2VzY28gUnVnZ2VyaSA8
ZnJ1Z2dlcmlAYXJpc3RhLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bHkgMiwgMjAyMCAxMzoy
MA0KPiBUbzogS2lyc2hlciwgSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+
DQo+IENjOiBOZ3V5ZW4sIEFudGhvbnkgTCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+OyBK
YWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwub3JnPjsgRGF2aWQgTWlsbGVyIDxkYXZlbUBk
YXZlbWxvZnQubmV0Pjsgb3BlbiBsaXN0IDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9y
Zz47IG5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IGludGVsLXdpcmVkLQ0KPiBsYW5A
bGlzdHMub3N1b3NsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBpZ2I6IHJlaW5pdF9sb2Nr
ZWQoKSBzaG91bGQgYmUgY2FsbGVkIHdpdGggcnRubF9sb2NrDQo+IA0KPiA+DQo+ID4gU28gd2ls
bCB5b3UgYmUgc2VuZGluZyBhIHYyIG9mIHlvdXIgcGF0Y2ggdG8gaW5jbHVkZSB0aGUgc2Vjb25k
IGZpeD8NCj4gDQo+IFllcywgSSBhbSB3b3JraW5nIG9uIGl0LiBKdXN0IHRvIGNvbmZpcm0sIHYy
IHNob3VsZCBpbmNsdWRlIGJvdGggZml4ZXMsIHJpZ2h0Pw0KDQpDb3JyZWN0Lg0KDQo=
