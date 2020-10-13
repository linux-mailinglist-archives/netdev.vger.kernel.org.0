Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD1B28C8AA
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 08:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbgJMGfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 02:35:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:12651 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389425AbgJMGfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 02:35:05 -0400
IronPort-SDR: /55eKnN0UeqvUq9bNFiAJC5m7LldkwaXfLY1CryD/icrNq1n0FcuNd3ssVvaCN0uzq2PEg6mo5
 /9wBkOqUldSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="163221413"
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="163221413"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 23:35:04 -0700
IronPort-SDR: dOO668doPGUJ4Zju7PTW4HHWFo1QVBjyQi6uM1XnO0d1NodHopr2pRQcSDF8ijkpfxERQtpxHi
 u3+L4X0PzIXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="345159190"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 12 Oct 2020 23:35:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 23:35:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 23:35:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 23:35:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyP9X4yDBmhEechUNaRzyGGKjd6hxxucV/MWYImBiy2SmvyztIAkqiiT/2/u8ev40XVucp+Re09TDxKV2NJx3BLTUGE+5ZhKZlyqkl43qvS1tiQro0JPcM0IzS8pIyGqv3qQ4USXCuw4y2lVLFm6RoguAV3+yoJnJ1uuseAG7Tp34vHAssiyyxCfqUoyE3J/+OsAL7LndS08Vie45iCF5iPUD9PV07dmX9ZNiRRFx0heEXtQy6TY9uPhu3k+nqOhnkzkKmSyCH3zjLRVcGhmQRnCLUZq29M3qnSya17YTc1Z2kNQxUhc+vyM/NrhpuowelO5phZjgOQBW+G0KbVgwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAi1aOHQgcESmR7M0YvdXOEBiEz4xoU8KJy73aIWmh0=;
 b=HhjMxVbhALfeNxMR37Y8GlX4sJu2cwUAw7OlaOrGBuawd3vtyeEs+nVXZBJRvKjXFkHSzjbmPKHDw+TxdZEoj8HkL24RV/FHfu3nyRDKsEiju9QHxJyduKMsQcXQWJHYehUe4dpq8feTd91mGywkLIxudG/aUs/q4x7Rox2WP6pP5Yj6b1PpM5LUe84M1lDU/tkrZH0MAfc/+nYMuwYwytxpAWMC560cZIzexQ2/K0MDAgzJVTafW/z6+UJZytoWl3y0vE9/oI1MqqNXe09XDxSyfCqtpnQS7t7SU4hw8aakmBuVOn3khtGwToAiNkzioBhHlGZxtRWs6J9lGAy2mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAi1aOHQgcESmR7M0YvdXOEBiEz4xoU8KJy73aIWmh0=;
 b=kLM78Lh8hsP5fKnDEhMzUrZqaIE8XeXyc1YLR1V/jxQMnvoMIMXTcWK+EnhtLgpLuxDMFuT+35En3lY8JMThpxPbfBdGeEioCweI4S1uG0BLJIZ6xPVQlFvNFHeg+mhpMoKkyDFc0kHpiRrI891DaUhB6jlM5hYn4aa02XnfdMo=
Received: from SN6PR11MB3008.namprd11.prod.outlook.com (2603:10b6:805:cf::18)
 by SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.30; Tue, 13 Oct
 2020 06:34:59 +0000
Received: from SN6PR11MB3008.namprd11.prod.outlook.com
 ([fe80::5072:297c:9cd1:48b3]) by SN6PR11MB3008.namprd11.prod.outlook.com
 ([fe80::5072:297c:9cd1:48b3%7]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 06:34:59 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     Marek Majtyka <alardam@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Majtyka, MarekX" <marekx.majtyka@intel.com>,
        "maciejromanfijalkowski@gmain.com" <maciejromanfijalkowski@gmain.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next] i40e: remove redundant
 assigment
Thread-Topic: [Intel-wired-lan] [PATCH net-next] i40e: remove redundant
 assigment
Thread-Index: AQHWheecZ1AT+nXQY0G4US3AI+MauqmVNpBQ
Date:   Tue, 13 Oct 2020 06:34:58 +0000
Message-ID: <SN6PR11MB30082C2927FF8287E58FF69EE2040@SN6PR11MB3008.namprd11.prod.outlook.com>
References: <20200908123440.11278-1-marekx.majtyka@intel.com>
In-Reply-To: <20200908123440.11278-1-marekx.majtyka@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [106.200.10.148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ecdb008-1ea7-42b3-db92-08d86f421b5c
x-ms-traffictypediagnostic: SA2PR11MB5067:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB50675455DC84482CACF41FDEE2040@SA2PR11MB5067.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 601U2FXWoCq56qAnXmmPj4oVY17xJVkTJ5W9VQkxjS/AULhm7ds9INmbuQnBTTeMnDWwY53fGBqUrp5/TtBnkuGfqZJgcfmAfup5vekp1Y3ZU4X2FyEBlEPkcqfJUhg3ggIKqLt0BykqUKcb/VjuByKvLNgm8mrphQyqJyAUgjfa5yUsOOdDercUcClrtTu800atu0t7iJXwVEpbVT26HOJCuZLe0X9HxoWe6k7TiY3OIEU3wqJBdwwglANTLEVgM0gYUfGHK4frQ8bAE5f9lqy3ctC1t6v98OkafC4rk2xOqXPyBcIIlf5VWmPA3r0f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(52536014)(4744005)(8936002)(5660300002)(9686003)(8676002)(71200400001)(186003)(478600001)(53546011)(4326008)(66556008)(54906003)(66476007)(2906002)(66446008)(66946007)(64756008)(33656002)(83380400001)(76116006)(55016002)(110136005)(316002)(7696005)(6506007)(26005)(86362001)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AJ1b6ur0Kk9wLWt4fHeCSIioirMoFyDwjmy5PCjsO/Ix2kLiGJEqDpb5PmAb1bsM7awkaM5ICInmzloItEO7igwqLqI0Zc5pQUN5561Re5njOOn8jj4f5zT3+IBm1oe7vZSVT+6si8JmT4jiiep8I1nMrhdhiZhD9602u7Ev5Wfz5s0f3uf8K+8jPuckQ2U2x6AfAZcqXQ4RljWoA8C7SURjy/mLJRcbPgGIVDdKjtoTW+az6wQvT3k9vaMwrnLkBw7Gfiw2T1pF1R8BlLlHoRpwhzF3qe2d2u7gDUQ6i3TnL0lKVAvLtPTpHz6NLLQKmaeLNGLpcMU+Jd1/e5I5KVMLy65Z5XsFO6UFrALxr2cPKHuw+YWJt/sU6DACHRboGh9HYFVBVHi7qNSmKiyh+X51x51lHx+cr5YCL+ikmyntN3s9JQvomgs8Klo3TPBAY/Zca6LYzYN9SNV7hC2QQRnaefx9oZkLFdzG6+0hu0TQuSn3bYN4G8sG9a+OT4tiZnJK3ITOxZPlwL0u6KRBTzdAZU8nUJwbVletxkPcC02MvLoEAqlSvRMwKVYayM+tagHeh+oKWuLoHXRg3CsC9iqMrMLjvF2cLWLK0mPB7mcz3rfyDJrD+wTN8tpaDutKAt8oqF40Ndsy9JEoFEupeQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ecdb008-1ea7-42b3-db92-08d86f421b5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2020 06:34:58.9131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DAqQOhvm0KYj6ZhvR0S1NjWB7SSFbdi9mGxCh6/FnyaHhZuXlKZR6yvDC5YlnfZXH8/adB1S9CVu5HC/AvWM4L5aB1FduNyPb9XXEU+PUh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Mar=
ek Majtyka
Sent: Tuesday, September 8, 2020 6:05 PM
To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn <bjorn.topel=
@intel.com>; intel-wired-lan@lists.osuosl.org; Kirsher, Jeffrey T <jeffrey.=
t.kirsher@intel.com>
Cc: netdev@vger.kernel.org; Fijalkowski, Maciej <maciej.fijalkowski@intel.c=
om>; Majtyka, MarekX <marekx.majtyka@intel.com>; maciejromanfijalkowski@gma=
in.com
Subject: [Intel-wired-lan] [PATCH net-next] i40e: remove redundant assigmen=
t

Remove a redundant assigment of the software ring pointer in the i40e drive=
r. The variable is assigned twice with no use in between, so just get rid o=
f the first occurrence.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 -
 1 file changed, 1 deletion(-)

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>


