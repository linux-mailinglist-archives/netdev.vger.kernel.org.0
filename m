Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137B86E295C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDNR3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDNR3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:29:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB387ED0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681493356; x=1713029356;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EtAQXuE7JcVSCpeizl57933iR/EXu7zdqmFrCOFudHY=;
  b=VQ0VrjLVZd8tWcXOyDfjY5udok+E8c6erH5kZROhmgjnMBqHsfO4+YDs
   aDBVtxwUiDmvYjuNzwTNbzOnZMX5WKkg58jK6AQQ+UVfLu9Mh7JYWXgyo
   723jdTo3WDwgSOXtk6OBNuyZDDtBKJZtLECQfyl7KISipERkBBgrgb3kk
   dzlMcSpaX6uYxiZZGKc7dQ7zMBEsKYkb4aGKgKDkYH/08suXV1tanhaEx
   TTYiN9Ut4wBfHpuCT+qS6jyl3mPRAcwA7+G/CSy5DEwgXAF92maTsjalh
   hyuXma7qFbSz7z1nKr0E85JAqTm7VOrFbtIlbo4G197QVxtBZiA8RKbQ/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="409724962"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="409724962"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 10:29:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="779252890"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="779252890"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Apr 2023 10:29:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 10:29:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbLcWR7NUyHuVOO7g6wQbCJu48cJHeP0lgnmj63tDn3329yEDpbVvqeUH10UDAdqQa1J5Ui3jUk+x6LeoobcnrRXCVrFy70WRojJRA164lnmh9oI5x+RSYITJ6TmTB4sVXkD/59y9IaOHx2qnfy8rJeLP0fd3KDZnbmsBisENa3LK2EwdFr8vYAeZtAxy5R63BVR/DcIPV2z/itpJnWFxAWo7bIIRlqT2cAoj4TsuDwpL9F61LssxfDTvnxDZVE0j1nGjYaCf7K9UWspUVbg20RSBsQHi9bw9xyQwDhwoFlJ0d9PecGeXw2Hkt9kZOg0ZoIBX6rvQkUrr6Mzy7tCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtAQXuE7JcVSCpeizl57933iR/EXu7zdqmFrCOFudHY=;
 b=fwnrJxWgDm1CzEwXpg4Sgh2PwHMp4oCIBr9jTnOQLeHmhWHEHM4gnxiFYgcKHuvlzKyBkz5fssT93kZxl6GLR0jb1RnQX1oI1y0dLa3ri16HHfGiPB19vDF0rqwbUrlZ49BEkZKUiiqYper2GdI8C8NJsIcA0D1TEnneDi6eyBR/V+mlx3toutgw3awStP1UanFH0qlEL2r/Ux3lA7w4Mu6uiYeDBmuUBWlfxnPKSlHX92iZtZKOK9LU6wEwR6o+ERgwJSjdS04HMG1kqYiQ+Fh4VtKis/ZLRdive2TQN0pmzMC7jJY36oZSdtKvQJmhFbtly5b5HwLLQZ4EeTOrwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6454.namprd11.prod.outlook.com (2603:10b6:8:b8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Fri, 14 Apr 2023 17:29:13 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 17:29:12 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        poros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Brent Rowsell <browsell@redhat.com>
Subject: RE: [PATCH net-next v2 4/6] ice: sleep, don't busy-wait, for
 ICE_CTL_Q_SQ_CMD_TIMEOUT
Thread-Topic: [PATCH net-next v2 4/6] ice: sleep, don't busy-wait, for
 ICE_CTL_Q_SQ_CMD_TIMEOUT
Thread-Index: AQHZbReaUJk3su3/TE2cWGTuQFqXd68q7ddg
Date:   Fri, 14 Apr 2023 17:29:12 +0000
Message-ID: <DM6PR11MB46578BD9292D6ECB0FD8C3BE9B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-5-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-5-mschmidt@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6454:EE_
x-ms-office365-filtering-correlation-id: bf02feea-5392-4c42-e9aa-08db3d0dc396
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(38070700005)(7696005)(71200400001)(41300700001)(55016003)(86362001)(8936002)(26005)(2906002)(186003)(52536014)(33656002)(6506007)(5660300002)(76116006)(478600001)(66946007)(66446008)(64756008)(66556008)(4326008)(8676002)(9686003)(66476007)(110136005)(54906003)(82960400001)(38100700002)(122000001)(316002)(83380400001);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf02feea-5392-4c42-e9aa-08db3d0dc396
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 17:29:12.7980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Sc+GbMKfblUqrBM+VyNM9Q5N+T1MwIVcQ6rpia6Sh1+l/o5UJ6MbSMTd2nZz03JPvGuq7o1eok9lQ2vN58Pkaq3VbXnxcT88pDaLf4m+vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PkZyb206IE1pY2hhbCBTY2htaWR0IDxtc2NobWlkdEByZWRoYXQuY29tPg0KPlNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgMTIsIDIwMjMgMTA6MTkgQU0NCj4NCj5UaGUgZHJpdmVyIHBvbGxzIGZvciBp
Y2Vfc3FfZG9uZSgpIHdpdGggYSAxMDAgwrVzIHBlcmlvZCBmb3IgdXAgdG8gMSBzDQo+YW5kIGl0
IHVzZXMgdWRlbGF5IHRvIGRvIHRoYXQuDQo+DQo+TGV0J3MgdXNlIHVzbGVlcF9yYW5nZSBpbnN0
ZWFkLiBXZSBrbm93IHNsZWVwaW5nIGlzIGFsbG93ZWQgaGVyZSwNCj5iZWNhdXNlIHdlJ3JlIGhv
bGRpbmcgYSBtdXRleCAoY3EtPnNxX2xvY2spLiBUbyBwcmVzZXJ2ZSB0aGUgdG90YWwNCj5tYXgg
d2FpdGluZyB0aW1lLCBtZWFzdXJlIHRoZSB0aW1lb3V0IGluIGppZmZpZXMuDQo+DQo+SUNFX0NU
TF9RX1NRX0NNRF9USU1FT1VUIGlzIHVzZWQgYWxzbyBpbiBpY2VfcmVsZWFzZV9yZXMoKSwgYnV0
IHRoZXJlDQo+dGhlIHBvbGxpbmcgcGVyaW9kIGlzIDEgbXMgKGkuZS4gMTAgdGltZXMgbG9uZ2Vy
KS4gU2luY2UgdGhlIHRpbWVvdXQgd2FzDQo+ZXhwcmVzc2VkIGluIHRlcm1zIG9mIHRoZSBudW1i
ZXIgb2YgbG9vcHMsIHRoZSB0b3RhbCB0aW1lb3V0IGluIHRoaXMNCj5mdW5jdGlvbiBpcyAxMCBz
LiBJIGRvIG5vdCBrbm93IGlmIHRoaXMgaXMgaW50ZW50aW9uYWwuIFRoaXMgcGF0Y2gga2VlcHMN
Cj5pdC4NCj4NCj5UaGUgcGF0Y2ggbG93ZXJzIHRoZSBDUFUgdXNhZ2Ugb2YgdGhlIGljZS1nbnNz
LTxkZXZfbmFtZT4ga2VybmVsIHRocmVhZA0KPm9uIG15IHN5c3RlbSBmcm9tIH44ICUgdG8gbGVz
cyB0aGFuIDEgJS4NCj4NCj5JIHJlY2VpdmVkIGEgcmVwb3J0IG9mIGhpZ2ggQ1BVIHVzYWdlIHdp
dGggcHRwNGwgd2hlcmUgdGhlIGJ1c3ktd2FpdGluZw0KPmluIGljZV9zcV9zZW5kX2NtZCBkb21p
bmF0ZWQgdGhlIHByb2ZpbGUuIFRoaXMgcGF0Y2ggaGFzIGJlZW4gdGVzdGVkIGluDQo+dGhhdCB1
c2VjYXNlIHRvbyBhbmQgaXQgbWFkZSBhIGh1Z2UgaW1wcm92ZW1lbnQgdGhlcmUuDQo+DQo+VGVz
dGVkLWJ5OiBCcmVudCBSb3dzZWxsIDxicm93c2VsbEByZWRoYXQuY29tPg0KPlNpZ25lZC1vZmYt
Ynk6IE1pY2hhbCBTY2htaWR0IDxtc2NobWlkdEByZWRoYXQuY29tPg0KPi0tLQ0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbW1vbi5jICAgfCAxNCArKysrKysrLS0tLS0t
LQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbnRyb2xxLmMgfCAgOSAr
KysrKy0tLS0NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9jb250cm9scS5o
IHwgIDIgKy0NCj4gMyBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlv
bnMoLSkNCj4NCj5kaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9jb21tb24uYw0KPmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9jb21tb24u
Yw0KPmluZGV4IGY0YzI1NjU2MzI0OC4uMzYzODU5OGQ3MzJiIDEwMDY0NA0KPi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29tbW9uLmMNCj4rKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbW1vbi5jDQo+QEAgLTE5OTIsMTkgKzE5OTIsMTkg
QEAgaWNlX2FjcXVpcmVfcmVzKHN0cnVjdCBpY2VfaHcgKmh3LCBlbnVtDQo+aWNlX2FxX3Jlc19p
ZHMgcmVzLA0KPiAgKi8NCj4gdm9pZCBpY2VfcmVsZWFzZV9yZXMoc3RydWN0IGljZV9odyAqaHcs
IGVudW0gaWNlX2FxX3Jlc19pZHMgcmVzKQ0KPiB7DQo+LQl1MzIgdG90YWxfZGVsYXkgPSAwOw0K
PisJdW5zaWduZWQgbG9uZyB0aW1lb3V0Ow0KPiAJaW50IHN0YXR1czsNCj4NCj4tCXN0YXR1cyA9
IGljZV9hcV9yZWxlYXNlX3JlcyhodywgcmVzLCAwLCBOVUxMKTsNCj4tDQo+IAkvKiB0aGVyZSBh
cmUgc29tZSByYXJlIGNhc2VzIHdoZW4gdHJ5aW5nIHRvIHJlbGVhc2UgdGhlIHJlc291cmNlDQo+
IAkgKiByZXN1bHRzIGluIGFuIGFkbWluIHF1ZXVlIHRpbWVvdXQsIHNvIGhhbmRsZSB0aGVtIGNv
cnJlY3RseQ0KPiAJICovDQo+LQl3aGlsZSAoKHN0YXR1cyA9PSAtRUlPKSAmJiAodG90YWxfZGVs
YXkgPCBJQ0VfQ1RMX1FfU1FfQ01EX1RJTUVPVVQpKQ0KPnsNCj4tCQltZGVsYXkoMSk7DQo+Kwl0
aW1lb3V0ID0gamlmZmllcyArIDEwICogSUNFX0NUTF9RX1NRX0NNRF9USU1FT1VUOw0KPisJZG8g
ew0KPiAJCXN0YXR1cyA9IGljZV9hcV9yZWxlYXNlX3JlcyhodywgcmVzLCAwLCBOVUxMKTsNCj4t
CQl0b3RhbF9kZWxheSsrOw0KPi0JfQ0KPisJCWlmIChzdGF0dXMgIT0gLUVJTykNCj4rCQkJYnJl
YWs7DQo+KwkJdXNsZWVwX3JhbmdlKDEwMDAsIDIwMDApOw0KPisJfSB3aGlsZSAodGltZV9iZWZv
cmUoamlmZmllcywgdGltZW91dCkpOw0KPiB9DQo+DQo+IC8qKg0KPmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbnRyb2xxLmMNCj5iL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29udHJvbHEuYw0KPmluZGV4IGM4ZmIxMDEwNmVjMy4u
ZDJmYWYxYmFhZDJmIDEwMDY0NA0KPi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfY29udHJvbHEuYw0KPisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfY29udHJvbHEuYw0KPkBAIC05NjQsNyArOTY0LDcgQEAgaWNlX3NxX3NlbmRfY21kKHN0cnVj
dCBpY2VfaHcgKmh3LCBzdHJ1Y3QNCj5pY2VfY3RsX3FfaW5mbyAqY3EsDQo+IAlzdHJ1Y3QgaWNl
X2FxX2Rlc2MgKmRlc2Nfb25fcmluZzsNCj4gCWJvb2wgY21kX2NvbXBsZXRlZCA9IGZhbHNlOw0K
PiAJc3RydWN0IGljZV9zcV9jZCAqZGV0YWlsczsNCj4tCXUzMiB0b3RhbF9kZWxheSA9IDA7DQo+
Kwl1bnNpZ25lZCBsb25nIHRpbWVvdXQ7DQo+IAlpbnQgc3RhdHVzID0gMDsNCj4gCXUxNiByZXR2
YWwgPSAwOw0KPiAJdTMyIHZhbCA9IDA7DQo+QEAgLTEwNTcsMTMgKzEwNTcsMTQgQEAgaWNlX3Nx
X3NlbmRfY21kKHN0cnVjdCBpY2VfaHcgKmh3LCBzdHJ1Y3QNCj5pY2VfY3RsX3FfaW5mbyAqY3Es
DQo+IAkJY3EtPnNxLm5leHRfdG9fdXNlID0gMDsNCj4gCXdyMzIoaHcsIGNxLT5zcS50YWlsLCBj
cS0+c3EubmV4dF90b191c2UpOw0KPg0KPisJdGltZW91dCA9IGppZmZpZXMgKyBJQ0VfQ1RMX1Ff
U1FfQ01EX1RJTUVPVVQ7DQo+IAlkbyB7DQo+IAkJaWYgKGljZV9zcV9kb25lKGh3LCBjcSkpDQo+
IAkJCWJyZWFrOw0KPg0KPi0JCXVkZWxheShJQ0VfQ1RMX1FfU1FfQ01EX1VTRUMpOw0KPi0JCXRv
dGFsX2RlbGF5Kys7DQo+LQl9IHdoaWxlICh0b3RhbF9kZWxheSA8IElDRV9DVExfUV9TUV9DTURf
VElNRU9VVCk7DQo+KwkJdXNsZWVwX3JhbmdlKElDRV9DVExfUV9TUV9DTURfVVNFQywNCj4rCQkJ
ICAgICBJQ0VfQ1RMX1FfU1FfQ01EX1VTRUMgKiAzIC8gMik7DQo+Kwl9IHdoaWxlICh0aW1lX2Jl
Zm9yZShqaWZmaWVzLCB0aW1lb3V0KSk7DQo+DQo+IAkvKiBpZiByZWFkeSwgY29weSB0aGUgZGVz
YyBiYWNrIHRvIHRlbXAgKi8NCj4gCWlmIChpY2Vfc3FfZG9uZShodywgY3EpKSB7DQo+ZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29udHJvbHEuaA0KPmIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9jb250cm9scS5oDQo+aW5kZXggZTc5
MGIyZjRlNDM3Li45NTBiN2Y0YTdhMDUgMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWNlL2ljZV9jb250cm9scS5oDQo+KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9jb250cm9scS5oDQo+QEAgLTM0LDcgKzM0LDcgQEAgZW51bSBpY2VfY3Rs
X3Egew0KPiB9Ow0KPg0KPiAvKiBDb250cm9sIFF1ZXVlIHRpbWVvdXQgc2V0dGluZ3MgLSBtYXgg
ZGVsYXkgMXMgKi8NCj4tI2RlZmluZSBJQ0VfQ1RMX1FfU1FfQ01EX1RJTUVPVVQJMTAwMDAgLyog
Q291bnQgMTAwMDAgdGltZXMgKi8NCj4rI2RlZmluZSBJQ0VfQ1RMX1FfU1FfQ01EX1RJTUVPVVQJ
SFogICAgLyogV2FpdCBtYXggMXMgKi8NCj4gI2RlZmluZSBJQ0VfQ1RMX1FfU1FfQ01EX1VTRUMJ
CTEwMCAgIC8qIENoZWNrIGV2ZXJ5IDEwMHVzZWMgKi8NCj4gI2RlZmluZSBJQ0VfQ1RMX1FfQURN
SU5fSU5JVF9USU1FT1VUCTEwICAgIC8qIENvdW50IDEwIHRpbWVzICovDQo+ICNkZWZpbmUgSUNF
X0NUTF9RX0FETUlOX0lOSVRfTVNFQwkxMDAgICAvKiBDaGVjayBldmVyeSAxMDBtc2VjICovDQo+
LS0NCj4yLjM5LjINCg0KTG9va3MgZ29vZCwgdGhhbmsgeW91IE1pY2hhbCENCg0KUmV2aWV3ZWQt
Ynk6IEFya2FkaXVzeiBLdWJhbGV3c2tpIDxhcmthZGl1c3oua3ViYWxld3NraUBpbnRlbC5jb20+
DQo=
