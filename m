Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EF025E167
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgIDSS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 14:18:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:41419 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgIDSS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 14:18:26 -0400
IronPort-SDR: E1PAWAVHbsuAZkvKs/bPSt5105SFa4KXyFvyTtETiYKN2OpERQ/qK/hsncl2smR3YJZXDAbKNg
 SssH1Q0wBgYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="175850343"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="175850343"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 11:18:25 -0700
IronPort-SDR: 5NYkAmPkkhCo6WNJpoTUg4S9KifPq30S4sfcTRGssk2MPzWsZhvK1eN/zoXoJ+IlxAU5C8l+Y7
 LDuoKH9QZlnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="503028738"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 04 Sep 2020 11:18:24 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 11:18:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 11:18:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 11:17:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZK33qJWBBencau+h0YcMlyLQNKcHt49LAUBHY48SipKuNMs0dTHCrzo6lTGtccfAAPMfhGPv0ELN13fP+5yTrppngEFCGXv3ly7T3V+siMOs1lPLfdpt1Y2YSJ+tMLiGX666xIBwQrficQc7VPIG+YD9Zqgxx0mZGD3aiE7LYykjY+8ZYLdjh4izgsxArq8D+Mbw+lXCY3zbP+6xwohrLCcKar05LIeTUp6GFu9SdeeTpIqBoc3nu+fdwSjinSCGOm7kZEca9OdADz/ZVMU0DRx9he5o0HzeqmTtRouLpjid0yyByWvkTeetEll5siANP+oaOrc3x0q4uD6csw+nYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LehT2Kl59VbYr9q/ZWFIRc7+4JgMF9l5RM/cHJ4hLOk=;
 b=kfQX/b4CCWVSEYR6QkUwxLrWQJF1Z13GTGrSwXN6ZFCX/m1MAidnFhSck0GEyFYS/iyWqUJb3mtmNEy9/QKIDmLrf0/NiXZ1RK357SIlfEKrN6BkxmRdM9osJb9wthGX46lb7GFtmvsMbXmTgVlGyTDOztny/Y+3qhNs1tnx0tbBKNBjs+sB1+aUcOaPrJinfmlduRWFt0c+lcQYooV67Du5PSe5j/qPfXqgsukUPn2N9Hn/Z4+5I0cQYJWn3mSN+5u7rHtbiIyXNZBRmRIyc1bV3kFbX4K7sRMWF4QyGkPs+8eZSwgmbvOJ3yM9fRGBLK8Ir3wA69GibZuJIG5CjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LehT2Kl59VbYr9q/ZWFIRc7+4JgMF9l5RM/cHJ4hLOk=;
 b=dzKVprhbYQS0EYffkO7mI9KqPdUIP+2lmWP4yd6LJhRaKCk8NTIG4iV/2NBLIwOEtqVi5slGzVGQrBIThq+ereF8ykOy0kkH3vtbgdkKYlV5+YhPUnLVL4jQxOIoQJQPqvwil/J7zVs9q4gaqMkaZeKxXrogVZTgIzB2kK6Nbo8=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM5PR11MB1916.namprd11.prod.outlook.com (2603:10b6:3:10a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Fri, 4 Sep 2020 18:17:39 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 18:17:39 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2] i40e: fix return of uninitialized
 aq_ret in i40e_set_vsi_promisc
Thread-Topic: [Intel-wired-lan] [PATCH v2] i40e: fix return of uninitialized
 aq_ret in i40e_set_vsi_promisc
Thread-Index: AQHWcWS1XFnoU1+xfUmX04HX0r02wKlY7GXQ
Date:   Fri, 4 Sep 2020 18:17:39 +0000
Message-ID: <DM6PR11MB289078074C929E1892B65CFEBC2D0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200813112638.12699-1-sassmann@kpanic.de>
In-Reply-To: <20200813112638.12699-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a376cc19-2d7c-4d3f-670e-08d850fecf11
x-ms-traffictypediagnostic: DM5PR11MB1916:
x-microsoft-antispam-prvs: <DM5PR11MB1916BBCC0349E9D3D4F247D0BC2D0@DM5PR11MB1916.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4483Mt2IMPSv9gSFtYv2kw4jIIHhxgJmh2v/5hLdHTrdKv6G5ebiRwhc3dmmIuFIzGe63OAlv0IyDbIbftng+UQ7naYoiZm+D/3FIqn8M9XCoOB66YShJi+A5xsTtZn64jCPrx2StebCAU6vqW8d7Lx/rYyUvJAKNmBPHx6rQYxiZOoIiO6xvb5tIgFBs/8SWxjLm7xJ6gB7RbyFx/gs+Q6T2tuRrQ2jFHYqVSMgCtdu+neMfEB7D6PRvB2WBWM3FZ38EgjBdmnL8BQOAyRA2vgEy97xEJV0g4JCI/TpuXZ0QwX/xNWzCMTix434TgQsLIsPXe2WL8XHExfdD7MI1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(4326008)(26005)(7696005)(8936002)(66476007)(8676002)(2906002)(66946007)(66446008)(64756008)(6506007)(5660300002)(86362001)(66556008)(186003)(76116006)(53546011)(71200400001)(9686003)(33656002)(55016002)(110136005)(54906003)(316002)(83380400001)(52536014)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JmxFO+4DBIJ8KiZEqQ2kARth5iN0PflFG/g9fqI0cm5nhEvW8cKCvTHnvG+SYGD7yptMRhSL3PlXJM0JVyicSA+OlF/K2yx/mUXiYEMQWTkRI1VLHJW2C4xcqK7IgEbXItHd9r4NZkvM1CebgfQ3x+svApOTq3uByDqRsXcFJUuISxHj9dV3Gpoo6QsEm9htnQmlafIHPuUuSWJqLQxbPRA/mNoBICuVh6atfrvO5n9N6OLQswpN4h6+08AKrP73Q2QYGen9IYIv4r6CgOnl3aB7xnxizqZTGzl36NtuM/SemCg591fRxLEWO+nBbgSBN4EDL3nY+IFgE8XwsghQccCnWIojro3muzQu/EWuViJSGfFy+DdfhFDlyC3n3hzCcV1gJdptShQik5GaxM/zvg/47OawBuOoT/N57TAdyeNMztp7DQrrY9QXjWBIBhLwVjJffP48ArmQjJjSgdCOYofuqT96vyg+4sLK9J8uyktFsIFS2C0VPJdPDRrjlMAjRx0saMeSs5fuGxyVnM9fdsAqxhYo71SXyMJ4p3btuE6Yva26h89Wj+t99SIzm4uLiFt1r79bI+uIcAQNx+Zi9QH7KSxUhAcdS/LbKfCTqJ0f9sX3S0QLIpjXhMuHzLnl3YlFaM2b3E5UfYtbcqwFhQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a376cc19-2d7c-4d3f-670e-08d850fecf11
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 18:17:39.7695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K386kTwysZuR2DEjOQqsaWYf+4/fEOl1Gj3+iCZyTw66N3cWz3ck+NRcb5dnECc47r5GhtSCLxvyV34HUEoIwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1916
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGludGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5v
cmc+IE9uIEJlaGFsZiBPZg0KPiBTdGVmYW4gQXNzbWFubg0KPiBTZW50OiBUaHVyc2RheSwgQXVn
dXN0IDEzLCAyMDIwIDQ6MjcgQU0NCj4gVG86IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wu
b3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBzYXNzbWFubkBrcGFuaWMuZGU7IGt1
YmFAa2VybmVsLm9yZzsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiBTdWJqZWN0OiBbSW50ZWwt
d2lyZWQtbGFuXSBbUEFUQ0ggdjJdIGk0MGU6IGZpeCByZXR1cm4gb2YgdW5pbml0aWFsaXplZCBh
cV9yZXQgaW4NCj4gaTQwZV9zZXRfdnNpX3Byb21pc2MNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2k0MGUvaTQwZV92aXJ0Y2hubF9wZi5jOiBJbiBmdW5jdGlvbg0KPiDigJhpNDBl
X3NldF92c2lfcHJvbWlzY+KAmToNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9p
NDBlX3ZpcnRjaG5sX3BmLmM6MTE3NjoxNDogZXJyb3I6IOKAmGFxX3JldOKAmQ0KPiBtYXkgYmUg
dXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rpb24gWy1XZXJyb3I9bWF5YmUtdW5pbml0
aWFsaXplZF0NCj4gICBpNDBlX3N0YXR1cyBhcV9yZXQ7DQo+IA0KPiBJbiBjYXNlIHRoZSBjb2Rl
IGluc2lkZSB0aGUgaWYgc3RhdGVtZW50IGFuZCB0aGUgZm9yIGxvb3AgZG9lcyBub3QgZ2V0DQo+
IGV4ZWN1dGVkIGFxX3JldCB3aWxsIGJlIHVuaW5pdGlhbGl6ZWQgd2hlbiB0aGUgdmFyaWFibGUg
Z2V0cyByZXR1cm5lZCBhdA0KPiB0aGUgZW5kIG9mIHRoZSBmdW5jdGlvbi4NCj4gDQo+IEF2b2lk
IHRoaXMgYnkgY2hhbmdpbmcgbnVtX3ZsYW5zIGZyb20gaW50IHRvIHUxNiwgc28gYXFfcmV0IGFs
d2F5cyBnZXRzDQo+IHNldC4gTWFraW5nIHRoaXMgY2hhbmdlIGluIGFkZGl0aW9uYWwgcGxhY2Vz
IGFzIG51bV92bGFucyBzaG91bGQgbmV2ZXINCj4gYmUgbmVnYXRpdmUuDQo+IA0KPiBGaXhlczog
MzdkMzE4ZDc4MDVmICgiaTQwZTogUmVtb3ZlIHNjaGVkdWxpbmcgd2hpbGUgYXRvbWljIHBvc3Np
YmlsaXR5IikNCj4gU2lnbmVkLW9mZi1ieTogU3RlZmFuIEFzc21hbm4gPHNhc3NtYW5uQGtwYW5p
Yy5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfdmly
dGNobmxfcGYuYyB8IDggKysrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pDQoNClRlc3RlZC1ieTogQWFyb24gQnJvd24gPGFhcm9uLmYuYnJv
d25AaW50ZWwuY29tPg0K
