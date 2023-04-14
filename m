Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BFF6E2971
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDNRaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjDNR3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:29:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250869EF7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681493376; x=1713029376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qqTl9m15C3Wb74yfB/v9K0G1pPadizXInHmk1MFi3f4=;
  b=VX9d8k9RTBY0hdjnl3VWrcvJALYtwYW3UkFvIwa74Cubh58DjiN3K0/X
   +waMqVvqvyWs3WLu7848JqUqGU/7OEpF0+bGH4gRURcgH6jdRnKy1aot1
   WI1+PXbWQBry53c4q3pcX5Ru9y8KykRXbzvDGGq31FYyHtFnMYBC4/flB
   KW8xdL+rHHTyJ+xWHM3yvmymUuERI/pa5kE6Ay7DW7Pe3hFukuzSO6/eo
   52xLpGqHJh75Ws85sF8Tsy0L2+U9EW2efyOSCOpDvdUXu3LqyofWzVgg0
   woSY+LHSOEw5+UzSInfRVuhoUK8UroqGDgEe+vC34QK4Fdf7o6Pjz17LR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="372388319"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="372388319"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 10:29:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="720357669"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="720357669"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2023 10:29:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 10:29:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4q1mhb5FN4qpgvj1nLqjDiICf7D5m4O/Rqa+tiuvOoo9NVRh0S1Erky2uxdInuRR6HkPoN0NWaydQqzPFkJoD6gEJa+AMnrEwaeNUB4R+EPB13CBAaEFVht6N2tpuyTnE7D5QHv5K288gC2+ei5IWcp87sls/dbV6J7p3Dj3wi5qNOuoPlecMVNCbb86kOu/DcSYmfYjDUBa+nnrcoV6MMx8q3Du3y91McrQQrecfAL7q+BUZpXrwG66RGqWvOlfQ+1vS+3ox0+FdJAE4GN/6yf1QGeL/3Sk1rgQX4zClMBictvoa8rU7elbFtU5dLbpoFomHz8CAVr378SShqoqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqTl9m15C3Wb74yfB/v9K0G1pPadizXInHmk1MFi3f4=;
 b=Y433nwbwg/K5kcwASRP6OfheQVhI2bC7ArTkjRIni6qj8Cj53LIVp8qBzxekaEcw5Xd6CQS0KIExVuHpBFxkjkM9saEdm6SavV0vwXpMegqbAFrXJSJxUlRXVBYaWlE7tWsD9MP9yDxN/SaVU0FrDliET33eIBdVUJjd6dMi+8tRPzMe5a8bNjYB/45n865IylW2NwMOa9mU5Vgjw9i97bFDbwGji1gtH7n6TQY69YmkkKDYUHgI2jHTQhKSvW8EpUMGtVOrZcBJxccVVKvaZ/rMoza4atPoyqL5uwM1H8oQhOp9X+t2PplfVLs8nHbleSH4MKSwVOTvU8kwxXIBWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6454.namprd11.prod.outlook.com (2603:10b6:8:b8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Fri, 14 Apr 2023 17:29:15 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 17:29:15 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        poros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net-next v2 0/6] ice: lower CPU usage with GNSS
Thread-Topic: [PATCH net-next v2 0/6] ice: lower CPU usage with GNSS
Thread-Index: AQHZbReYR74qAgPUYEur6DUNnPoK/K8q7hDQ
Date:   Fri, 14 Apr 2023 17:29:15 +0000
Message-ID: <DM6PR11MB4657B72AE60739B0814B2D639B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-1-mschmidt@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6454:EE_
x-ms-office365-filtering-correlation-id: 22bc058d-d04e-42c3-087d-08db3d0dc50d
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bc058d-d04e-42c3-087d-08db3d0dc50d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 17:29:15.2574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fVgirMrAPDj48O4Hy2CteqKNVQt2rypqZ0Cb0yTu8hlN9QXTizncLvn5ifaiKDqhneQEOQ8F+QPKZVilma+qGbie9hjU3qrX5cvNvZi85UA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PkZyb206IE1pY2hhbCBTY2htaWR0IDxtc2NobWlkdEByZWRoYXQuY29tPg0KPlNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgMTIsIDIwMjMgMTA6MTkgQU0NCj4NCj5UaGlzIHNlcmllcyBsb3dlcnMgdGhl
IENQVSB1c2FnZSBvZiB0aGUgaWNlIGRyaXZlciB3aGVuIHVzaW5nIGl0cw0KPnByb3ZpZGVkIC9k
ZXYvZ25zcyouDQo+DQo+djI6DQo+IC0gQ2hhbmdlZCBzdWJqZWN0IG9mIHBhdGNoIDEuIFJlcXVl
c3RlZCBieSBBbmRyZXcgTHVubi4NCj4gLSBBZGRlZCBwYXRjaCAyIHRvIGNoYW5nZSB0aGUgcG9s
bGluZyBpbnRlcnZhbCBhcyByZWNvbW1lbmRlZCBieSBJbnRlbC4NCj4gLSBBZGRlZCBwYXRjaCAz
IHRvIHJlbW92ZSBzcV9jbWRfdGltZW91dCBhcyBzdWdnZXN0ZWQgYnkgU2ltb24gSG9ybWFuLg0K
Pg0KPk1pY2hhbCBTY2htaWR0ICg2KToNCj4gIGljZTogZG8gbm90IGJ1c3ktd2FpdCB0byByZWFk
IEdOU1MgZGF0YQ0KPiAgaWNlOiBpbmNyZWFzZSB0aGUgR05TUyBkYXRhIHBvbGxpbmcgaW50ZXJ2
YWwgdG8gMjAgbXMNCj4gIGljZTogcmVtb3ZlIGljZV9jdGxfcV9pbmZvOjpzcV9jbWRfdGltZW91
dA0KPiAgaWNlOiBzbGVlcCwgZG9uJ3QgYnVzeS13YWl0LCBmb3IgSUNFX0NUTF9RX1NRX0NNRF9U
SU1FT1VUDQo+ICBpY2U6IHJlbW92ZSB1bnVzZWQgYnVmZmVyIGNvcHkgY29kZSBpbiBpY2Vfc3Ff
c2VuZF9jbWRfcmV0cnkoKQ0KPiAgaWNlOiBzbGVlcCwgZG9uJ3QgYnVzeS13YWl0LCBpbiB0aGUg
U1Egc2VuZCByZXRyeSBsb29wDQo+DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfY29tbW9uLmMgICB8IDI5ICsrKysrLS0tLS0tLS0NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9jb250cm9scS5jIHwgMTIgKysrLS0tDQo+IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfY29udHJvbHEuaCB8ICAzICstDQo+IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfZ25zcy5jICAgICB8IDQyICsrKysrKysrKy0tLS0tLS0tLS0NCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9nbnNzLmggICAgIHwgIDMgKy0NCj4g
NSBmaWxlcyBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspLCA1MyBkZWxldGlvbnMoLSkNCj4NCj4t
LQ0KPjIuMzkuMg0KDQpJbiBnZW5lcmFsIEkgY291bGRuJ3QgZmluZCBhbnkgaXNzdWVzIHdpdGgg
dGhlIHNlcmllcy4NClRoYW5rIHlvdSBhbGwgZm9yIHN1Z2dlc3Rpb25zIGFuZCB5b3VyIHdvcmsg
b24gdGhpcy4NCg0KUmV2aWV3ZWQtYnk6IEFya2FkaXVzeiBLdWJhbGV3c2tpIDxhcmthZGl1c3ou
a3ViYWxld3NraUBpbnRlbC5jb20+DQo=
