Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A613FFAB9
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347331AbhICGz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:55:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:57357 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234729AbhICGzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:55:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="283052686"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="283052686"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 23:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="521571636"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 02 Sep 2021 23:54:54 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:54:54 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:54:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 23:54:54 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 23:54:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0frTMOtGjCoH+lwugvg56B5TR2bpBfc3HfrkCMtVy/O2pmZm/NCPngKzrdZmTfFafzOzUpYjTGwDLldZVudC8hMeabBIk5UTPd1PQmJFPHjwohEAIqTCUh1xclAM8hUiKFFnDSYXnUasiD5GzB5kVp+50kpwyCohHwoaN93xyuSqhlPDXnfvjZ/qXPBblnwKtN13Ekd4ej3mb4ifRWeeqJCh8QhztETLt/07uY/izVbE5InvOk/DL7Gdi3T6oVFL/FGdKdHfw0swYwqXCyiFbSZQ8w/7zLJUcfcWexxkF3SpkQ5/ShE9GLiuDjZWz5XNBfn1W8myKIq2zSxv3fcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o/7GK4qnybP/C7+DAp+G3xob3++VtoqaYhLQ05qnqA=;
 b=QEJZ0JfoaU5MpsBtgP5o24ji0xVo6UkuUvsS7qRaWxM+mOEvTtQs/FXD5g1O/pTbj8eqDeuW5X6JFZBLsEduNdeu/J7cGlIlTBzSrApfqacRgromw4NfRV73DZz0kbaJ4pghpiA8+tYA/vmU4wKT1LqjH16VmOjn4n4uWhaH28uF8+GVRqezXq0v9gBNdB8za9nGGatG6Njq5X+2wopjrUiBAocn/AoQ6myAB9rhKSPEMeNnyunBE9iVOFFVbe0ojPvrJJmEOHaS5dtgFNp6uYkwIKGOotF3EwU8/D7oVjHA+caKh//hTRSIvsDdhq8R8d+p+v1ghe9LWOY4G75lRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o/7GK4qnybP/C7+DAp+G3xob3++VtoqaYhLQ05qnqA=;
 b=kUkXjS4kRD08QSjDiB/RGvA9vv5cKkNWHshBHpXZWlfGq96m+hYEa//4b5MYqjQslUh3mOwP9hKhucX9LOxPv2auFZpwhDX2UxUrLW/C1ufdNKcrHiquJQd83HBana2VH5pK6YyYTw38Ubd1Y2tJwA1K63Jp5PhSHlzGhBpdUSk=
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by PH0PR11MB4837.namprd11.prod.outlook.com (2603:10b6:510:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 06:54:50 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885%3]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:54:50 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v6 intel-next 9/9] ice: make use of
 ice_for_each_* macros
Thread-Topic: [Intel-wired-lan] [PATCH v6 intel-next 9/9] ice: make use of
 ice_for_each_* macros
Thread-Index: AQHXlDuPuciqmagVJ0uDushRzeP+L6uR+JhQ
Date:   Fri, 3 Sep 2021 06:54:50 +0000
Message-ID: <PH0PR11MB51445B9EAB6E3DE927E8FBAEE2CF9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20210818135916.25007-1-maciej.fijalkowski@intel.com>
 <20210818135916.25007-10-maciej.fijalkowski@intel.com>
In-Reply-To: <20210818135916.25007-10-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d427bc8-ad77-4507-4cca-08d96ea7b9d4
x-ms-traffictypediagnostic: PH0PR11MB4837:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4837FEC5BCD8A1D7589FA09BE2CF9@PH0PR11MB4837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ljUGXCfyQLkD3oeT+Z+HmqANzMbRatH3pfIXEieYty1egUrvGU+HIXZMqGBALWIYOk2FA6Jjs9AFh4nIdFhlvNq5XLRI3vDXMuRjSIJU/M6Uv2noole6rtGZeIRyQlsPIZHVGOwJlNm/Vvgc+DOL392ye/t75FXjmwVpu/wlGKifLXTQDNNynS0sqK4a/B7lHp8sRipaSlT+djVFUQDqvln/H6BMIf3DYEsy1Tuqh27/YsiqOnCDntNIf7LZzrlgWUwa0mYrc5v60hRdhLkNBUIWZ4nNqx/ei+NFsTwoJbM2AN04V5PywUtGpaubv57nFCWdxTBNBzvWT/bCTnFmnoCGr/7fDROU6NbMVlm6Rbuqn/p6Y3glpG2ve6y57GhTwlViVWbyLNfcYsj6PwKNB0eUui//ZcmT+46Y+dBrC7sJVRX6p+hFtjFU+TLca78TQoWRypRz2H7peLXgq3ISoFVyirJqf3RQ628b19YD+s5E7Zm0kVL2kMZWREPhZDEcgXrrCmU2AP3uIsNV6EViJOZ7UOuBZVP3CDF81h+HXHt2fDJEBQseC5QWup+hKa9Baws57Vk+UCS+Y1NcXnHYSLGEXzuKp8QsciwO1/xT9pTvQbK/AOzAy4pCqQSDlQMSqS61QsqIwJCLkYjJ5rAgI0Mu/isLfDMAtvOQwUg1jYXa8c5UIRIB+fsRTrrHSOcC1hd98QCUb1mc4JoJTlKHkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(316002)(83380400001)(4326008)(110136005)(33656002)(7696005)(38070700005)(8676002)(122000001)(6506007)(26005)(76116006)(66946007)(107886003)(55016002)(71200400001)(53546011)(38100700002)(8936002)(52536014)(54906003)(2906002)(64756008)(66476007)(66556008)(86362001)(66446008)(186003)(9686003)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RF0UFL8dJbzIzSM97n5fqP6kv6yuJrL4JSVjwJoFPDWXPQJHakXXOVwX7/pY?=
 =?us-ascii?Q?8q+nLwjgPe6h5aIyqb3SGI8dSQmfG58iqauapW5bHZeqgf1BtIFwjVhGTjJz?=
 =?us-ascii?Q?hP6IrbUwiHDgqGXADtGZHLtF/1S7Ocnslmu5SX/LDnOifu+GIvhSflYaDXwh?=
 =?us-ascii?Q?XQTW2SHHhUgpVuiJBBxiHGdLkLw5MiQdurvBpG/yo3k6h4S9v92Os3GjsP3i?=
 =?us-ascii?Q?geveQ2chdP/zyBM7Z1NKb2/pKAxNyHWIcNgQuwzwllk3iHRJBrkcyyz/5yXr?=
 =?us-ascii?Q?iwFOkkScLiTnNqsVpKSvyV8+/2BcrVaffDx6kG2ESFQqqf5pZ5D8jGVC5h8p?=
 =?us-ascii?Q?HlqHl8bOyn5eIKHDJSoIS6fkbi6tzUyLS/6fMYx3KK2diW47ojP2yiQh6fKf?=
 =?us-ascii?Q?jYXLCMmtvjbjSCY48o5oDIkbW9KGgPW+clhCI/t7N9mS+sTGs/tzG2CRSkTF?=
 =?us-ascii?Q?DdYFpfmmM9RvUNNkfwR8GKWpPfd9IOTVC1SGF189b0kNq7mORsmQDQ+DbCKR?=
 =?us-ascii?Q?M0rjv561lV/KkN40BpXsbZ4MXEhXn+O/c/MUuwIpfsfezCtb5ablwqoyZUJR?=
 =?us-ascii?Q?CwuaQ41eZZsF3xYJK2hSWXDEDyAZ1QywO1VFkGX4ktpLwFF6xDSqksi+0UZg?=
 =?us-ascii?Q?3HqKF+hs4y7lWT6ChoPMXWlwYqT9mm55ZFbshDIGfoYhK5UhIkUBgWpE/Mv6?=
 =?us-ascii?Q?mqKZpwbAAKR/O3+QPOJHZgFChZ+lTN4oOpJKxjpcJiWa+/sP4D9C3krMzeID?=
 =?us-ascii?Q?o2bFaPJWNh+NCzAWCgwTKDZadU6o39cytiOU3BGq0bK3WfUBRPEdrCa/H6RL?=
 =?us-ascii?Q?GZSgZE5tXSV8Jiz0vO9iuPx9Ewppt1MtLHSXrt/wf2TrgTz0mdZeBwiwdj+L?=
 =?us-ascii?Q?8O0OBC7U61V7c1OHU6uKhmTJaUoOLZhqrgspk3flNQvHYFW61RuMDoPDxHjB?=
 =?us-ascii?Q?VmHL0paQiD82Pudi9yE63KHswk9tQ9qP86a4mq1pw9kvkqIqkp7HaYF1vJki?=
 =?us-ascii?Q?h8bz+i7Hd7kwRSd/zudf4RXwEyABIbbMOaR6E0KPtMiOWdRwjUbjCtnelJMo?=
 =?us-ascii?Q?iX9nzhcFuNMrm65MoTnHieAz1OH45cNT2xUwYBlsZ+Jt4lG+WJcVTv8nWpF3?=
 =?us-ascii?Q?iXSmQkSX8kSnSjuubgdAbPSkKAOmBDLtixvgnpcB3a8rWdXT77rKx6B3b75T?=
 =?us-ascii?Q?nuwVq6omimxj1YwiGqH3FxovpqL1QRZNUailaT6K7oHDyL4XudsoZSLZZmst?=
 =?us-ascii?Q?w9XgYPOaVUp9/mqNX1C4oAk8kuD8N4T4gi6zqpmG2Kp0TUsNba9k32EMl5e3?=
 =?us-ascii?Q?k/umwVWrkVFQ4hbCr0uGq8LF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d427bc8-ad77-4507-4cca-08d96ea7b9d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:54:50.5151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Ro+EHth5s8MEzXYUqRaT4Cx21iH6BvcOU1DG7KxvZmNwCrYDG2wQYf1C+l7OaDe9HdXJe26MsXbNr62juqodwBK5dwWxWm2US/ZzC/FmO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4837
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Wednesday, August 18, 2021 7:29 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org; kuba@kernel.or=
g;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v6 intel-next 9/9] ice: make use of ice=
_for_each_*
> macros
>=20
> Go through the code base and use ice_for_each_* macros.  While at it, int=
roduce
> ice_for_each_xdp_txq() macro that can be used for looping over xdp_rings =
array.
>=20
> Commit is not introducing any new functionality.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h         |  5 ++++-
>  drivers/net/ethernet/intel/ice/ice_arfs.c    |  2 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 ++--
> drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 ++++-----
>  drivers/net/ethernet/intel/ice/ice_lib.c     | 22 ++++++++++----------
>  drivers/net/ethernet/intel/ice/ice_main.c    | 14 ++++++-------
>  6 files changed, 30 insertions(+), 27 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
