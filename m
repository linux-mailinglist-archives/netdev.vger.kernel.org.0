Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D3F27A756
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 08:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgI1GTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 02:19:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:2836 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgI1GTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 02:19:30 -0400
IronPort-SDR: Y1K6SxzBC9VuZEegO+oOqlO2jRv9wMzXt99ubO3T3DugiiPqCq0VuBAbtVJq7tjovq0tWvwsya
 F1D/DnWPbj4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="159291778"
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="159291778"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 23:13:26 -0700
IronPort-SDR: hwF5m6QvYePL7/ipbapYjSrK2vsqH0HZW4HLatd918awkUqG3iv0agS5KeoIZSMS91PYa/CtAH
 3USqcQM0xPTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="456706837"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 27 Sep 2020 23:13:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 27 Sep 2020 23:13:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 27 Sep 2020 23:13:25 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 27 Sep 2020 23:13:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfpxPtvW4ZXKbh5Do9ynNs5YX4lB6Ypr/PVnJbiGNhdaNTEzYBSR+CazkIEF4ia//yaX3PIAB63j3cjZIYVvPdbGpYLpItn/P/fLtUvOruNnRdJH7RcvCnuCTJYzJyYjHcOmTMRxtos+9kV802g7fEINblpLg7zJVQebtAw0xvpMIfo/f5rDNsiVTAR4eEnl4qV8D3UxaagRn9NMABnC+vjnCQI2+N+epEK1U+nDjnxD0/dOfOQVWatggTZ8CaWs06pJOqefAC3vo4r1K2cVwZs85lh8l0CAlZnXajVnlIyv0bfbJ1XO6R5tvCBbgwPVmu7FSktxaY1dwSxd9xtDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v91NShPXLaorPLDF9ArQj8vDuHMef7Hw1fJvONxDt6I=;
 b=If+ctNGnXBT+BR3KHE9XXYAtEW82osK1qKRc1TuSFuK+/MlgRv4NJR8XVst+qJZ42tp91PPz5oX1w3OOfmfssQVD2IpSfSRfPe/FJ7Psc2qvjdMe/QoWQcCSNORQjV+l0nQwPSZ4Joky0PUPPV3Arc+R+V2NJeAf+i+5DJTLb0nz7dwLFQcfeN5QcPWi4owLuR011G0DAKNNXII7gGfyHxdPxQVqDbws739tqKyur9A0yb+QWbi38wPauotPe1h967P0nZmueqcPBd5P7VFfmvVIRTAI1MJvpv0EYv51Vv6AKj7EQu5vuVty9hwPTEijIfaZsH1zy+inW5R1I7Hvyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v91NShPXLaorPLDF9ArQj8vDuHMef7Hw1fJvONxDt6I=;
 b=v8VcYOv3pKXMq/R5UR7hwkA12ds+6b7OfOFqAkL5JVxSm2Ds26uTXnANptXhSxKcZklntq+cEdoWnwNIDRnGORWcaAPqirMj/OEHlfSdgmy+JkgpCN5DWs4x35WtAYUwh7RxitqyuXxTgx8qAxKCPmZU8LMZwUcLMlZyEoXxL7A=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2616.namprd11.prod.outlook.com (2603:10b6:a02:c6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Mon, 28 Sep
 2020 06:13:15 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::718c:ac63:d72e:f3c9]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::718c:ac63:d72e:f3c9%4]) with mapi id 15.20.3412.028; Mon, 28 Sep 2020
 06:13:15 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stf_xl@wp.pl" <stf_xl@wp.pl>,
        "torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "jcliburn@gmail.com" <jcliburn@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-net-drivers@solarflare.com" <linux-net-drivers@solarflare.com>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "dsd@gentoo.org" <dsd@gentoo.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luc.vanoostenryck@gmail.com" <luc.vanoostenryck@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "ganapathi.bhat@nxp.com" <ganapathi.bhat@nxp.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "j@w1.fi" <j@w1.fi>,
        "tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "stas.yakovlev@gmail.com" <stas.yakovlev@gmail.com>,
        "pterjan@google.com" <pterjan@google.com>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        linuxwifi <linuxwifi@intel.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "pkshih@realtek.com" <pkshih@realtek.com>,
        "kune@deine-taler.de" <kune@deine-taler.de>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>
Subject: Re: [patch 28/35] net: iwlwifi: Remove in_interrupt() from tracing
 macro.
Thread-Topic: [patch 28/35] net: iwlwifi: Remove in_interrupt() from tracing
 macro.
Thread-Index: AQHWlQh/JW5wj9yvMUGHzMIKohlOGql9ktIA
Date:   Mon, 28 Sep 2020 06:13:14 +0000
Message-ID: <ab22cc7b0d1f98e1d620e77ce7abce1f95b6813e.camel@intel.com>
References: <20200927194846.045411263@linutronix.de>
         <20200927194922.629869406@linutronix.de>
In-Reply-To: <20200927194922.629869406@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.191.233.107]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e6d0f52-3c3d-4c3d-ed55-08d863759625
x-ms-traffictypediagnostic: BYAPR11MB2616:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB26165A549D21C656D7367F7890350@BYAPR11MB2616.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxUIYXyEaA1gKroiEZbP/ha+boO6xOvD1R9rW6wdW8PTbjgXTG0gkuflwRsjFdFnr8620MXy1rY0WJfosXnunN8igv/9YcPCZnhMstffrhl6deapA95+FDXCVk4KnkejoadaW9hVcovZZv09DOwGBEtiDbdJWjE4DOhoIXeMl3AqfLMtwCsRqqjVTj+8cZl4gzbrHi0mMKi14NGSZZcAK1yRwnXiCI2djTMMcXyKlOc2IC5j/+l8NWsxF892mps21PqhfK/gBmPiPWTYZDUSmLUQbDJlZWvea5hH8dH/MPBfAhdnPg3ApWGgQuv+CPJRZpCM/6yw9pvJjZapgwD58fPm7ysmLP4zDuvAT1qv/CYHlyioxHyH4BHKvRB75MrJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(7416002)(7366002)(7406005)(36756003)(6512007)(66476007)(71200400001)(91956017)(76116006)(86362001)(66446008)(66946007)(66556008)(8676002)(64756008)(5660300002)(2616005)(186003)(4326008)(6486002)(26005)(6506007)(478600001)(2906002)(316002)(8936002)(83380400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VsGwApBGm0NBGAEVSmBr7J0gOK3cf/mHi7lcKdsJLKxbrMyNvcTh3pZd3WOJSvJTpRhgq5/yNEBWUmIck+uWtIf2FZBtqdF4IgwHFY0V1/o1Py4fdRkzUwky1OeZfE3eoTYatwgVG9zvGU5isJjXNC9hr+BL4a0PVRwftEkWSK6OtPKid++IOqtDnxzY76VypxcHNqPTQXHp5ES8W2N5DgdiE0rywFxgtDL/75gi8FBB7TZL0TZFhS78/CekugCv8/34VweHv4WQ+1PsBzM+LG9XmyP7Qj2S4WlLfpEq9KFecEgQnJNqm9HqV/PzTUyQhobdOo7mXwHCrvzDb/erCsM41pYyNasvKD3HjoYIqwHe8B05Dcog+2cAVNshukjLMfQf27XR4jXMOSDFaH07OSouq8cRNgXFcv/S1Dd/RZEbI8TX85yZoMMf9Zw0G+pbMroIpCBH094MfODYzwp9z916nuNfnxkqmaCPjiM1u9rrGDE1Gk8oQQ8dB7Ltu6Ypsa79hLrmgJT4DaTH4jwbxAIuhHJ8JoPT1bA1B5FtfBMDLJMd4SLc4r/eqYoJPElyzKa5xeQ2yHHCBifP+/1nUDu+WXsv//wKuLK9oTtaDF5RslgSpDWQov/TnKOz6T1UGdcXrln7TD+cFij0hzj/fw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EC18655EA315646977202E236D35B5B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6d0f52-3c3d-4c3d-ed55-08d863759625
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 06:13:15.0009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ssquw4STZOlqvXnvG0eg0UwJoGWbnmLzDSIbk6cgG+xoMV2uky1TqOZtgQ4RXopay1qvfNHMxX63dEsPHjCNLb/YAvoNQrNHzEQUBZEbAVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2616
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA5LTI3IGF0IDIxOjQ5ICswMjAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
DQo+IEZyb206IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3IgPGJpZ2Vhc3lAbGludXRyb25peC5k
ZT4NCj4gDQo+IFRoZSB1c2FnZSBvZiBpbl9pbnRlcnJ1cHQpIGluIGRyaXZlciBjb2RlIGlzIHBo
YXNlZCBvdXQuDQo+IA0KPiBUaGUgaXdsd2lmaV9kYmcgdHJhY2Vwb2ludCByZWNvcmRzIGluX2lu
dGVycnVwdCgpIHNlcGVyYXRlbHksIGJ1dCB0aGF0J3MNCj4gc3VwZXJmbHVvdXMgYmVjYXVzZSB0
aGUgdHJhY2UgaGVhZGVyIGFscmVhZHkgcmVjb3JkcyBhbGwga2luZCBvZiBzdGF0ZSBhbmQNCj4g
Y29udGV4dCBpbmZvcm1hdGlvbiBsaWtlIGhhcmRpcnEgc3RhdHVzLCBzb2Z0aXJxIHN0YXR1cywg
cHJlZW1wdGlvbiBjb3VudA0KPiBldGMuDQo+IA0KPiBBc2lkZSBvZiB0aGF0IHRoZSByZWNvcmRp
bmcgb2YgaW5faW50ZXJydXB0KCkgYXMgYm9vbGVhbiBkb2VzIG5vdCBhbGxvdyB0bw0KPiBkaXN0
aW5ndWlzaCBiZXR3ZWVuIHRoZSBwb3NzaWJsZSBjb250ZXh0cyAoaGFyZCBpbnRlcnJ1cHQsIHNv
ZnQgaW50ZXJydXB0LA0KPiBib3R0b20gaGFsZiBkaXNhYmxlZCkgd2hpbGUgdGhlIHRyYWNlIGhl
YWRlciBnaXZlcyBwcmVjaXNlIGluZm9ybWF0aW9uLg0KPiANCj4gUmVtb3ZlIHRoZSBkdXBsaWNh
dGUgaW5mb3JtYXRpb24gZnJvbSB0aGUgdHJhY2Vwb2ludCBhbmQgZml4dXAgdGhlIGNhbGxlci4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3IgPGJpZ2Vhc3lA
bGludXRyb25peC5kZT4NCj4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxp
bnV0cm9uaXguZGU+DQo+IENjOiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNv
bT4NCj4gQ2M6IEVtbWFudWVsIEdydW1iYWNoIDxlbW1hbnVlbC5ncnVtYmFjaEBpbnRlbC5jb20+
DQo+IENjOiBMdWNhIENvZWxobyA8bHVjaWFuby5jb2VsaG9AaW50ZWwuY29tPg0KPiBDYzogSW50
ZWwgTGludXggV2lyZWxlc3MgPGxpbnV4d2lmaUBpbnRlbC5jb20+DQo+IENjOiBLYWxsZSBWYWxv
IDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz4NCj4gQ2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBk
YXZlbWxvZnQubmV0Pg0KPiBDYzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4g
Q2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZw0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1Y2FAY29lbGhvLmZpPg0KDQotLQ0K
THVjYS4NCg==
