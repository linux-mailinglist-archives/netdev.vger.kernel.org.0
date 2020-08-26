Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD4253A9F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 01:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHZXWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 19:22:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:60036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgHZXWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 19:22:54 -0400
IronPort-SDR: 3XjQzvEfSevMBeiaDcfz/JUFXIVqYFQvqnX6rqFhTZXlBjvM1OWf/GLb6ftt+RC2kApmHAaP/f
 4zF5z0HZZrNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="157428059"
X-IronPort-AV: E=Sophos;i="5.76,357,1592895600"; 
   d="scan'208";a="157428059"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 16:22:53 -0700
IronPort-SDR: LjqgnZc9gOOkPIWkF0dTPmzM/f9Rj1gNeuzXuCenCZNVMIOni5W66sTxvoXgwiFupFyfZJozyw
 51vQE3nFXP2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,357,1592895600"; 
   d="scan'208";a="474958861"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2020 16:22:53 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Aug 2020 16:22:47 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Aug 2020 16:22:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Aug 2020 16:22:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 26 Aug 2020 16:22:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsrV8fq9IoukQLkcmHaxi+cGG+j+m2n1vkExnzMI7Ia+oTErqRDhAoF+p0YAy2VH4wQDsyYkfWspF20Jl2HoFIqDr4oT15kavoY8DmxFjtyVSIDrBE3dzwe0c/TU0LBlveN2XH6Tf8AHB3OB7T93zeAyN3RojmbESG5raNF0EVf64h9i6duftKO0ms3Ut7N9fEFdysCo/DvczF8kAuOWEGH+/ps3nEv6wgLTEyqlojWTltzeKxXGt3Mxn5r3zPo0TGW9REPsOnaVklvmuReRVhMZ/6h/f/zVAFs1d0QsPt0NNMTtXFvTQGwL1m5sDAtXrXpDtO3ovBfVH/gaSRV5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThBuHltBsYETsbJ72EnPtMyLam3tMCAL1VlNbVz0CNk=;
 b=kamCl6S2cmYzJ4x/DECmKTqDaEy1scYuB8IaGBM3v+2xJ3ziKMClCkeCA5xcEuuWeeVrsqRXgiQj+vmiczInmZDJUvNiZyQ3nWfPErFo3Fd51nnSvuMFGPNQ+GJGPM2Hs7dknvQG0G3IG+d9/9TG3wGVnrLdF9HFlTjn0zucBfGm/V1qNqpJsAvxVfnU+Qkh4pG//6tkhvW+0oW96Lw6U3p0VvV7wwIO576+uxXuZcfgiFyVWQ3QKVvbQe8YzvlqZ0uFg8kpWQlwlPfsUCseOp6qOzLX3YvyfQ6YvJP2qhB4A3XZvnntnt0R5+u6/cL5V2Q6Bk+DgPoMp74u/0zrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThBuHltBsYETsbJ72EnPtMyLam3tMCAL1VlNbVz0CNk=;
 b=OaXgyV6rwbYxC/KW62daGlS0wQFdzedGERJukGpNjsOYknlPnYCoaKN+H2UrBwnZ9O7ury4p8ZJNQ4PxRzXDd38dC8kNB2ZtL2LQHk8FKL2vbTYMqGd8pCk+cn22hf9fPxjh8cUZ3w9FJQtxkYmbpFA9x/HADSpemyGeeEjoERQ=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM5PR11MB1945.namprd11.prod.outlook.com (2603:10b6:3:10b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Wed, 26 Aug 2020 23:22:44 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3305.031; Wed, 26 Aug 2020
 23:22:44 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Bixuan Cui <cuibixuan@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: RE: [PATCH -next v2] net: ice: Fix pointer cast warnings
Thread-Topic: [PATCH -next v2] net: ice: Fix pointer cast warnings
Thread-Index: AQHWZyJ26lJRO5/MSU2ficxGgSvS46lLMVSQ
Date:   Wed, 26 Aug 2020 23:22:44 +0000
Message-ID: <DM6PR11MB289004F11B8936F7C421A863BC540@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200731105721.18511-1-cuibixuan@huawei.com>
 <5af7c5af-c45d-2174-de89-8b89eddb4f4d@huawei.com>
In-Reply-To: <5af7c5af-c45d-2174-de89-8b89eddb4f4d@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dbc2e83-e446-49f1-986d-08d84a16eff7
x-ms-traffictypediagnostic: DM5PR11MB1945:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1945F5708111E262C6BCE255BC540@DM5PR11MB1945.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:22;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BXKqwwhu3AOdNQMMd5AGn7vQ4YbHjoY3Ro5F3bnk5dZf4yT1IdZek8EJw3+UyQ7V1BWrJHMcyU/27MwtkAMliP0vHWQbpCC+z8uumrTxh8QC4a7gIzlSHi8hOSiUkZ/ReSIHjX3GV/ou0Xnfx84/0j9Ovfxcy66f+0GsvO9ZjZkLKts3QyZzQt7FAqyblPoKMXQguLU8CwtxUOfSiAVC5VjcOui8Ly2VefRjbOJqI8M8IHRb9W7+DW5HBG2og0GiA0cmjQsJgltEqK+SR9SBu/ShimZBa63CZ2hLMSzRseapOGEbxs7QRF3k6dqb8LAMxQ3+t6ryjEbpzkTHH9GzeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(52536014)(66556008)(64756008)(186003)(7696005)(4744005)(26005)(66476007)(33656002)(5660300002)(478600001)(9686003)(316002)(110136005)(55016002)(8676002)(4326008)(8936002)(54906003)(53546011)(76116006)(6506007)(83380400001)(66446008)(66946007)(2906002)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yCKR+8mRC40fWKf+N42h6V/rrRyc3GE5Gd4JNCalxmCePA9n7WzhPDaqQa5wz0qwfPNwIBVdmmmSenw1ds6goU/JpdWSIVJ48MGVFF/8mLNKXpK735ZaqJ+/Ahrrn2eaNTV1+/zK+8sdMt8J1gottg73QWqHff6xOEuy3EJBh5zddCZ42s4CKu820oQgNUQKNEAR7E6GZKIuaDtfzrIi69tH2EcnFzsPYjor6rPEHwh1oFS/vsUMMwgVccKDb+53gWoV+22jriTSz0wwwZJvzbbTUYOm+YdC4jk85RSb3R01WlMX1BwAF+GAE9kKrWFq+k9cUBExmvEz/6V8hcywnr66/s+fLqa15E5m3W7CRF8TtXz1xDB+gq86GC6miobLueoyY1YPiC/LvrspgxneEeXrRT4RXbbG7VBsRtjrutNIsEHUxBKQNzVT+462Xggf344y6eIanFGvZImzCteVK/Y3xyCqMA06HFiuChHeOVv3Oq2b6q/nb3FEX1n2qSeu1AR+MyIoxrhbxndyVqHaXvp0T+ojY5eTus5oqXgAy1U0Jos8w6P5SshOJVWEDBXNXFa4uzkb3Y7Nnu8U+z49JDvfy0vSF6M4txGXz0v4CT3t9I7128IqUsvFUeIs82axhV4bw2y+uYNmhNME0nAceg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbc2e83-e446-49f1-986d-08d84a16eff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 23:22:44.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2mGlDa7GKra2dkpNFqxUTGWJZ8p43ugYEJHzqnmYMiZVsvWs0ja+ha9bpABlx8Gfg11I30n0gcwQsrTA/iszog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1945
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBCaXh1YW4gQ3VpIDxjdWliaXh1YW5AaHVhd2VpLmNvbT4NCj4gU2VudDogRnJpZGF5
LCBKdWx5IDMxLCAyMDIwIDM6MDggQU0NCj4gVG86IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFA
a2VybmVsLm9yZw0KPiBDYzogS2lyc2hlciwgSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBp
bnRlbC5jb20+OyBpbnRlbC13aXJlZC0NCj4gbGFuQGxpc3RzLm9zdW9zbC5vcmc7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW5leHRAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQ
QVRDSCAtbmV4dCB2Ml0gbmV0OiBpY2U6IEZpeCBwb2ludGVyIGNhc3Qgd2FybmluZ3MNCj4gDQo+
IHBvaW50ZXJzIHNob3VsZCBiZSBjYXN0ZWQgdG8gdW5zaWduZWQgbG9uZyB0byBhdm9pZA0KPiAt
V3BvaW50ZXItdG8taW50LWNhc3Qgd2FybmluZ3M6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlX2Zsb3cuaDoxOTc6MzM6IHdhcm5pbmc6DQo+ICAgICBjYXN0IGZyb20g
cG9pbnRlciB0byBpbnRlZ2VyIG9mIGRpZmZlcmVudCBzaXplDQo+IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfZmxvdy5oOjE5ODozMjogd2FybmluZzoNCj4gICAgIGNhc3QgdG8g
cG9pbnRlciBmcm9tIGludGVnZXIgb2YgZGlmZmVyZW50IHNpemUNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEJpeHVhbiBDdWkgPGN1aWJpeHVhbkBodWF3ZWkuY29tPg0KPiAtLS0NCj4gdjItPnYxOiBh
ZGQgZml4Og0KPiAgaWNlX2Zsb3cuaDoxOTg6MzI6IHdhcm5pbmc6IGNhc3QgdG8gcG9pbnRlciBm
cm9tIGludGVnZXIgb2YgZGlmZmVyZW50IHNpemUgWy0NCj4gV2ludC10by1wb2ludGVyLWNhc3Rd
DQo+ICAjZGVmaW5lIElDRV9GTE9XX0VOVFJZX1BUUihoKSAoKHN0cnVjdCBpY2VfZmxvd19lbnRy
eSAqKShoKSkNCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Zsb3cu
aCB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkNCg0KVGVzdGVkLWJ5OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+
DQo=
