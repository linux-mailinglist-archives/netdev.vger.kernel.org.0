Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74E1EA830
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgFARJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 13:09:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:56310 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgFARJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 13:09:03 -0400
IronPort-SDR: T8gJkLrRyvTrECJrrq2w8irg3Jrf2NN3AQ4y0tSQ0DPZnALC3AUonNizi9+n9KdNiUv7R3zbPu
 qXSL03rAuMBw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 10:09:02 -0700
IronPort-SDR: 11fZNckbhcIwPy2PyJQlwhMJuwfq6Q+ujnO8QcKBbjqkKZO+3taq2Mg97uN2H2ReJ54T34sRq5
 RwIXWepNppRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,461,1583222400"; 
   d="scan'208";a="377469467"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga001.fm.intel.com with ESMTP; 01 Jun 2020 10:09:02 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jun 2020 10:09:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jun 2020 10:09:01 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jun 2020 10:09:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jun 2020 10:08:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mp3N5n7xD1f7npysst0FYUJrDBooSiZebdZiEfPBFtM1IDqRTQeCYDpmlvFzAcJWHDCeN2DEI1K+HpNpX2AO+8F0dN8krBUkMHU6DnbVSuY6uGWCAVHw5hwAiN8G3c2OsKnR9ldzIe3GPuwzTWgB1Nwk+X8q264jCc5gsv26OvqnpP3vCugYrHxjmWbNUN3LDNHVF6CbYgoQX6mveGU9DxPw22J8ns1wlbDF0oVFT4J01Zs1O/pp5Kl+twVD2MukoG5UWHUmTBZB+esBuarb91RMyDsaXJ7jtU9V6AXYXnx5oTWZH7uN+lUR7LVpsKnv/7V+pgr4o0k3JwxVGuFJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=446CGZjuMjEvJht67pQJl9QMTwN13TvQaq/zqc2q1oI=;
 b=FCDonl86K/sMWOfOjcQhVJ1RKOhRdC7jU/cCsa9Y0/bpYKvXVxMSRcjj9rOPzh35hMoJD+r63hTG0uvJ/mw4+3kGplLkShV40VHNGvXaBGWuXNYlXcSPt6xGIx2+SYVd71GnCuRkkJmlKzOxqST04odtfXxgvFD2o0wHzzuMZ+6OJl4OfkqkOQG1HeRu0LJWrlIJiYA/RiXYVBUQSb4E16BMD9HE+R/Mog/vrdO7+geLpl8uSUxVaGb5Cu6EJeWBNY6crEWNV94xvnLIyzeW5/EW33c0CaV5O38bxMiR+TXLEdnEDAqjiTwKNfqMgbtLtRNJz/TYyTVtxFZQ+kmrDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=446CGZjuMjEvJht67pQJl9QMTwN13TvQaq/zqc2q1oI=;
 b=ffhFiLckHl91kHtY57CA8m7ukXq5Dp3r5Rp++oPHjEYhAKDlDxKeXfHn9uDhtKho9AXRFIQ/xD2vWmIesTDMsRYOiDCFJ9tjKyEjrRBV8WtIfgEXZ+E9R8h/xzvlkVXXZDxya41juBgNlt54V6jWzRkl9TNh3qFriUWWk41i1bQ=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3754.namprd11.prod.outlook.com (2603:10b6:5:146::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Mon, 1 Jun 2020 17:08:55 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875%7]) with mapi id 15.20.3045.022; Mon, 1 Jun 2020
 17:08:55 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
CC:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: RE: [Intel-wired-lan] [PATCH] [net-next] e1000e: fix unused-function
 warning
Thread-Topic: [Intel-wired-lan] [PATCH] [net-next] e1000e: fix unused-function
 warning
Thread-Index: AQHWNC13H1Zf9GItw0SQd/zLJBeAQqjEBgcA
Date:   Mon, 1 Jun 2020 17:08:55 +0000
Message-ID: <DM6PR11MB28902EB65134561890C52CB6BC8A0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200527134716.948148-1-arnd@arndb.de>
In-Reply-To: <20200527134716.948148-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccc88b76-1442-4a57-72c2-08d8064e7770
x-ms-traffictypediagnostic: DM6PR11MB3754:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3754FD6E5CF9DD2EF340EFF0BC8A0@DM6PR11MB3754.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0421BF7135
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xvnkm2cwiECf/kQoxIfnE+RNig7Ingnh17ARiqCi5DRBOQnCaMegZz9JEI7Rom1fv8tlesn86WGyHFUAFdNIOTzyFkZnfUh0NOIlX/9NMOEyHQhfoQyXjWIakwkCDCHVSNcAFNWysaVZPdFkMXK4Zu9pLG7tlajbcZudkBHD0DDur06fuspa1O1vTjs57g6EguNqi1FdRipA+uWfk2YK0D/5iRyAAGeiovpUonINlx9aSgd1pVPxLEn2BVnXRGJhwD1BTIBL4xZVFo/C8wcwWwsq57uePvpb/TC4uD6GA6eksGX6UEm2f/N25XOx2k4mZrHg3AY9rjABXuBjqCiCng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(316002)(9686003)(33656002)(186003)(2906002)(110136005)(8676002)(71200400001)(8936002)(55016002)(54906003)(7696005)(478600001)(53546011)(6506007)(76116006)(52536014)(83380400001)(5660300002)(6636002)(64756008)(66476007)(66556008)(66446008)(26005)(4326008)(86362001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7aZbXF8fN8s/wBKqZ/QA1g8nBngMQuRgGeQ84zrlp2Npmru3bRDyasK2NUROMQuahqZJd0//OA5gr07P9bE7kLdcD8xIGqbBlYQTh2wzRGdy9C16hOiNm7VEv5F5enCAqu5S0VhuhVvZYl1c4taL29TrIgOeCxhNBlc9XyNDXo/rkgGunHzSb1Qpyz5J8QfAowZlAYF43b0Vl0F4fjy3RFi47kV3h/F9e5qZ1RvEtypdpHZqNiD4JynxOM1Wg9ywU943gJNlyrIaPXd7oIeZxsOMpEWQlXw24AXww6BDMtnBn9rTSsl0u98eYBr2synwhyKg55giPaX/+JiAEgtDH1HJv7nNpvdOE3lSE16aPY5XSWyzLddP/mPhjfqIhEKNbd1vZ4zzm8UjScGkQvU4C1QGjlJrzYeJR2SDX3OxjX+Gsy/wJkDi46ZLqTECTO3glLHtpFrIzmW3O/M9ET5kMh9r4J+SEn03dTknK9xExk5QPw3fqAfIdVxyjH5l2Iq0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc88b76-1442-4a57-72c2-08d8064e7770
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2020 17:08:55.2509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LpiQjor599mMk8Pcsl+jUAESEDZDPZ0P9C7bDrA4ZPZfiUbWXuBjWiD4//ShdQKsY3GYij0NtAgnN2vcgBEWjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3754
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of A=
rnd
> Bergmann
> Sent: Wednesday, May 27, 2020 6:47 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Lifshits, Vitaly
> <vitaly.lifshits@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Konstantin Khlebnikov
> <khlebnikov@yandex-team.ru>; netdev@vger.kernel.org; Wysocki, Rafael J
> <rafael.j.wysocki@intel.com>; linux-kernel@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Subject: [Intel-wired-lan] [PATCH] [net-next] e1000e: fix unused-function
> warning
>=20
> The CONFIG_PM_SLEEP #ifdef checks in this file are inconsistent,
> leading to a warning about sometimes unused function:
>=20
> drivers/net/ethernet/intel/e1000e/netdev.c:137:13: error: unused function
> 'e1000e_check_me' [-Werror,-Wunused-function]
>=20
> Rather than adding more #ifdefs, just remove them completely
> and mark the PM functions as __maybe_unused to let the compiler
> work it out on it own.
>=20
> Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME sy=
stems")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>=20
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

