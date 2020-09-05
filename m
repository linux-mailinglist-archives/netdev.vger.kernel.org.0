Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4925E535
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 05:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIEDFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 23:05:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:44467 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgIEDFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 23:05:05 -0400
IronPort-SDR: bWlxRzPx4zrnin2As+qL5mTcnqOXx9ikB4gl06lM7r10uavDSE/g2SVYvFKUol0SmUmrAXZTKU
 l/SJwXmUlasA==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="175886649"
X-IronPort-AV: E=Sophos;i="5.76,392,1592895600"; 
   d="scan'208";a="175886649"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 20:05:05 -0700
IronPort-SDR: Y0zw/IlYcCwll54rOLxCu05a1yqC0wKGi4MvG3JNCwO77zMAa35fKb6SgSDk9t2FNmHXU4yia8
 OpsG/8InWrhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,392,1592895600"; 
   d="scan'208";a="478769921"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 04 Sep 2020 20:05:05 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 20:05:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 20:05:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 20:04:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkMo4lL+V4A5zE93NuFwicmqEVCiMNgaofApAym3RaXel5zm1P4kCKTYF0rBmKD1G1nDve7YmbONxzVT1gB2dcdcUITtQ9kKtRAnoC3IkltZ6k+yHbek5Q064BZQwTvDxwj/4xx9nz3zeKliDXxOXSVZgHoWAJ5jVu7HJXYVkPsmDNd1cK22IQXG8P5m7HtBgMtGdKzH4ExizEVT/yFdI4glLiE2W0znGlYJ6wrBpJiPVBsOj9WLnCFxlyDqnNyBVm5153m4dg8nwQDYRJ2WZe7ycxSN8FLsZVMcgK1WQHtLvnZOPjrUK0vVV5/ZsetNJzt9b42oxiOCMwCSeJBUMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7H6PLhVHj1nbEgE62H/dnGhocBHeLCZDARPFwGXUTA=;
 b=bGBnyVMECfFLJcWeZOe/AFiNyTZj5dZ2ui1/jcmWFfcsgGBERbtf6VhvJqO35O7goG1pewgWhw1JNAp5EFyluN7WN8s3uMc6Z+74ZlqfqEfCLulA4ETn6ppQ2ukgPvdlreRT2AkqSTjfB237qa6aWlvID+TZr83DEeTFsTyyi+wWTW0pLBJKISGJU2L/rOQHIIEWvD6U5aaeSwbMdXuMnzxQSysQUu8HzBIwIWnKJzq26+CFgQ3vs1xOlrbYAygWBm/t4te7pl22+dJ6sjgnY3xU/KDmCFSoa0nd9cKAe457GSiX3ShB3djQaTOrf8hIU8MKa9lODLYkdkR7Odnocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7H6PLhVHj1nbEgE62H/dnGhocBHeLCZDARPFwGXUTA=;
 b=sydxSj2xQeyvsoLHAtk1JduxuINEazD6aQCtz736ss/myLtWV4B+bMW0d5h4cwD+I6VFkaNRrvwvVAkpAubjNSFJClPOxGzb3SrXCOlPneBBSKl28gtVSQHArgpRztO4B8f8q5Hfi9488ZGgaB2V6iu9HEYpRGVBjZ0nTdwGyyo=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4284.namprd11.prod.outlook.com (2603:10b6:5:205::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Sat, 5 Sep 2020 03:03:47 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Sat, 5 Sep 2020
 03:03:47 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 3/3] i40e, xsk: move buffer
 allocation out of the Rx processing loop
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 3/3] i40e, xsk: move buffer
 allocation out of the Rx processing loop
Thread-Index: AQHWetQPmw5QIUNsAU+30c5iHBlPwqlZbIHA
Date:   Sat, 5 Sep 2020 03:03:46 +0000
Message-ID: <DM6PR11MB2890BF5A351C1D7B016E5E12BC2A0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200825113556.18342-1-bjorn.topel@gmail.com>
 <20200825113556.18342-4-bjorn.topel@gmail.com>
In-Reply-To: <20200825113556.18342-4-bjorn.topel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91c94406-4a59-453b-07d3-08d851484eaa
x-ms-traffictypediagnostic: DM6PR11MB4284:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB428445BE638EE65A370B5C22BC2A0@DM6PR11MB4284.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 07HXI/vWkTHDn07DtsCzlATf+vm+tPSkMnbYSsxU9HF4IL4VueGA4LyonhJFGIrD0jCdv8Ts/08MUbTYuvjBkMpVtX0Xi3YO4yOvULF0Ra7dk0IUjAihgNZd+oMCTh+xfbpGKwizBpTZYFPEByyKTU1GhItTURt/7EacgYxh/IozDrv/sf38H/qYJzRrBY2xsUyip18Y1X1376kDRTwjUkdvknQl2BHhVgb1dThLzC8auRDnOPkV0tQDsH0f0LKsVQwMty3U9BOspKm+7a4RlOm+aUFrlpdu4kfgWDrSZw9tCQ+fAndEaeQtNn3mLW5B5RYLsNlKfP+WZgDePGWtxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(54906003)(110136005)(86362001)(83380400001)(6506007)(66574015)(7696005)(53546011)(33656002)(8936002)(9686003)(5660300002)(76116006)(66446008)(8676002)(4744005)(316002)(52536014)(66476007)(64756008)(55016002)(26005)(186003)(66556008)(4326008)(66946007)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: nIaCtVgoTS3dr1QRGcrHhr/RW0KF2JNRYAT4zd9ZutffFVCsKs+WfI6PZOr5mgGEyAz9k9dFMR2RHQSjjrGABG4A9HsWTq6vy0kTkt50TiHpFoX8irb9fBd4bxUgdMims67zXUzXwMNe7UpBigZ+DaFqjVnMUfCb9YAYPHCdesGYlPscDywY6usp/4UV44G8RZKOUGPyM2Q1OzwJkQ/vF/AReTNIr4zQy0HQdrPBDP3jfqMJ0gXjQKLH0Le7T2UZS6k1+iwXb6QJ6IqyqoorbEi94AiBOdh2th/5It95kPqi2vjZnVnWhSLs9JZENXBQ01YvIwAomyUyO3peeSqz8awCPGJyZ8TalsQqJQYczkpLv2gxR0iHMlYiJ+5yUTuQD/jkMHZ4qo0WaXXb5HwAMK4VN7pTpsTUcNKXD6mJVP7UCC2ldGQsHB0/hezeByGj+Kh24Joe4q9x8Da1gwN6tyaD/2EBKxLHRQX2nKcE1lfq2a1YmQE2MpwvVD5kwPwIh2TkpD1GFo6fU80s1fLbAd1NKPMUz4pv3d2PG0P4QdPXdC+IT5QokFub70AwvMujGMfh9lZyNQncrB3IR2Ov9hjTiXw3TQ+cvBcHiJNNJ/X5xe2bGRs2kYrDLK9pCZVoHxTQen5MCIcAHW3EY8oT1g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c94406-4a59-453b-07d3-08d851484eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 03:03:47.0597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ga649QnPvbb4/0j5h1cu+VROifOWF0s1lu+0Ifosv3mugsIN1Xd1erHLWYuG+P4P1qpAYQGob0sKXkNUGGhrAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4284
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGludGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5v
cmc+IE9uIEJlaGFsZiBPZg0KPiBCasO2cm4gVMO2cGVsDQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3Vz
dCAyNSwgMjAyMCA0OjM2IEFNDQo+IFRvOiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9y
Zw0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZzsgVG9w
ZWwsIEJqb3JuDQo+IDxiam9ybi50b3BlbEBpbnRlbC5jb20+OyBLYXJsc3NvbiwgTWFnbnVzIDxt
YWdudXMua2FybHNzb25AaW50ZWwuY29tPjsNCj4ga3ViYUBrZXJuZWwub3JnDQo+IFN1YmplY3Q6
IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSCBuZXQtbmV4dCB2MiAzLzNdIGk0MGUsIHhzazogbW92
ZSBidWZmZXINCj4gYWxsb2NhdGlvbiBvdXQgb2YgdGhlIFJ4IHByb2Nlc3NpbmcgbG9vcA0KPiAN
Cj4gRnJvbTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiANCj4gSW5z
dGVhZCBvZiBjaGVja2luZyBpbiBlYWNoIGl0ZXJhdGlvbiBvZiB0aGUgUnggcGFja2V0IHByb2Nl
c3NpbmcNCj4gbG9vcCwgbW92ZSB0aGUgYWxsb2NhdGlvbiBvdXQgb2YgdGhlIGxvb3AgYW5kIGRv
IGl0IG9uY2UgZm9yIGVhY2ggbmFwaQ0KPiBhY3RpdmF0aW9uLg0KPiANCj4gRm9yIEFGX1hEUCB0
aGUgcnhfZHJvcCBiZW5jaG1hcmsgd2FzIGltcHJvdmVkIGJ5IDYlLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYyB8IDEyICsrKystLS0tLS0t
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4g
DQpUZXN0ZWQtYnk6IEFhcm9uIEJyb3duIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT4NCg==
