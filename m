Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C7B560054
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiF2Mog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiF2Mof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:44:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B45B2655F
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 05:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656506675; x=1688042675;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=OFGdW0kxgy18PVlqvnvRircl8tLYZhTdwrhjBvkMcOo=;
  b=Nut4ixuKJIGAqXHD0QjHz4dfwC5yp70TX2E76GxmgCSF9/DFm8vdBYaf
   ti6ia0abZ0gXMLOZfHdiraQSCm5ZYZe8OXB9uOtzY69g3n2GP1eoZPRm1
   JDFzPECN1RnbIn/LTjvZYxRF/OGu9YYkCN7/IC/MuzARv2QtOLM+/MEL3
   mXKA5E9BRscvdIQPxhnUM3+uk6/siKfTmn1encgDO+ZtCglLjLAPiEQYj
   EJO8nuR3GQOxBWslK3WTHcivzge8cBPBhvWOUxaCGvVRKZQMuuDGCc6Ni
   ZLBbXNsI7b6u+na+kCDW76lIVjMFfECRUmC6jZVd34pAyXxrOpXIvOiOw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368333515"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368333515"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 05:44:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="647379772"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2022 05:44:34 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 29 Jun 2022 05:44:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 29 Jun 2022 05:44:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 29 Jun 2022 05:44:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 29 Jun 2022 05:44:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCbF/XFG4VYxKqaFjuWveC/VsiGeJBFRHf/f9bagWuLUjOrE9l5Inetsw0RPsobLYpf5S8hHnAlm5Yb0xfxlBMOdZllZwemPzP55EVnoEWCq8seC3bWUi7aatjK6nUt4RCkZfNDBvYeoibimoWr2Vuf6TZ91gXTNwlTNY8ZhjCxTFd31R7qXYlYpy+5BPtbUcpN2yp0W78Y/o/78wdFfJkF0JYGwItAM0Hp4pQzuUQbvPPZ9XqW741ouB/O9wtrWqiE0GuovCw7pApV1yaBZ3Kv4fmZet9udeOvs2OrfF9oWeedYNjpgy+cl1sjCeXXPYSYWp6yS+ZElmvVYf2q56g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+LsozVn4cn6sxQZzHD9A+cod1VlJTQwt5SLJrgE0mE=;
 b=NiKvWb1w6JABhbBPXaI6WoId/tVgUaj5NsVNVBgMdTCIiSnQtGN2VlmIdv3hDtT/mQRNCk6+hqNfGP3wU0t74mmIS0uYNUQaQACDbM/q36LqWsNrd0sV+JzhJXBNNm0a1FOGi7y6AZCE6IKDBa2ROAdqHklwGxasSGbSR8UVjT7vgwgwKUcaMb8STiVl0o4NlfsbHVqeX5IxbG9YpyoTgFOWqsUZFL2U2YjiVTcA14IoiaqwQa8qcQs8b3RMUO8JefNgivoGVD1CDXkwCGAm6L/L09nYTCwmI4HkyMqMX6RQdx/v4Vn4cmuLZLKTKoJLFhVaU35Ax/0Gn0XARQqhhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MN0PR11MB6158.namprd11.prod.outlook.com (2603:10b6:208:3ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 29 Jun
 2022 12:44:31 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d1b2:ed18:5abf:364b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d1b2:ed18:5abf:364b%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 12:44:31 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] ice: Remove unnecessary NULL
 check before dev_put
Thread-Topic: [Intel-wired-lan] [PATCH net-next] ice: Remove unnecessary NULL
 check before dev_put
Thread-Index: AQHYgYpjR+iZgRTQR0eGsMLapewZya1maLOg
Date:   Wed, 29 Jun 2022 12:44:31 +0000
Message-ID: <BYAPR11MB3367DCDF2FE713C84FA9349CFCBB9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220616045259.1130087-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220616045259.1130087-1-william.xuanziyang@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef3349d0-6377-4100-59a3-08da59cd1d25
x-ms-traffictypediagnostic: MN0PR11MB6158:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vaQG3SiC3oSybOwUCCJxR8XQcxB9Qfm2itaRQbDohkP/u+2GsemN218s7xAQS1KRTa9vZBuiIlUXE73AFWMBArbnNCrs/BzfBkMnrzO6JtVLXkyxMyT/5YM59jW9IydymDg8XIVLBynqIzvY5g6626J3bZEUT7ZlHcVvSuMIvPe6fczVqbwTlI5TpdkeaUXD43JsL9jFV82NCgzXJsHlidwnqUa2FRA9NqgvKwHwACulv69gPL9wrudleJOi//EBSbAQiHB9OsEcgRgaanRsZTmAPIsmMahlJZ5M7pru18dkxpi4+iDL9aXw1Qy0vXxGxHpTsCzEy7/N2Ichx8lh8Ry76TRrwJ00wkFZ2XDV++4WN1VCIM851GgBCYgVpjOn+uoL84BflFUp58nSVtOsdT+VXa6o2zeql0517VqzSCCHzYqQ4GgfIEv1V9vDgMq5aOsQWBHWAGGrSTQYg4omTqDESBbfAMmQhZ4Uv1ccKBqVcZU7Bi4lpX26MTvphui5p1FR74C9P+ZMErIzITp/wJYTmWT4DEc9nh5cT4IWlKKZ6SM/YFaoVyumQCASUCx7PeRjS7ZLvAopoD87/ZbkEs69WuGTe8dIujq7r4DlR9W3ZTKOm/LFZO3ZXwyM257WQdFsRxEQwPj2SqvBq+kj7B4ks7aHMdS+Ndqbzgkda8w0Cooh4vcxGgGxa6O3SVuGyzc9l8HKNzxFNmUOrvWMVjbAyTwbJBIlGAboatkptfdHD/tC98o6NV4kn4ImZQhQXkhfMZFOdk+yfC/lntu81Zg+PUZeWRx+NLcORHOqP2dCKQUSjmGLFN315SSnEynP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(41300700001)(38100700002)(8676002)(33656002)(52536014)(6506007)(83380400001)(110136005)(478600001)(82960400001)(186003)(316002)(38070700005)(122000001)(2906002)(921005)(71200400001)(66476007)(9686003)(86362001)(64756008)(53546011)(55016003)(8936002)(66446008)(7696005)(66946007)(4744005)(5660300002)(26005)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RkTaRcenbM/RaVy2veKouhFaGwko06Znb1Oz2wUXo5yqP+LLlyv+FxzLmMhP?=
 =?us-ascii?Q?ay7k37TIhl4q1WMenMkCXv6bu87H4ghiHdSjlyNxH7/8o4UPseDF0GeT0gUO?=
 =?us-ascii?Q?S1gpY8nXY275su1KIpMfVYsO2i6K3Z+1OMF8kaS20RNfqCz7yg/U5Ryoivbz?=
 =?us-ascii?Q?/A8mjH0ULW/CqDIB2ZItYzfn9YvZoXVgDun7/lzSAlQXYzRslGtVpx6BNaxW?=
 =?us-ascii?Q?tCHzKW6qSdV1JT6RNbVfsvJuWc5kBBSI6clHPypq/HqDYGbsisPIxlUmkL67?=
 =?us-ascii?Q?dhm/amTaieXh9I4/j44ebF4b2w8ff/HmVI3SZm9KioQpuWpi2JFInMH0LHPa?=
 =?us-ascii?Q?xtT2+/gEImVfSrB4R8KMpI/fg9FDSdD3SGpoiWvWSKnA40Y9rniiG1r4JlMY?=
 =?us-ascii?Q?+x9N8RRHUCWiJ2hIEJ/qxiSRRWfTViJfTmhZl4H5WgTR8OtjOvGzsYSYWPl2?=
 =?us-ascii?Q?nQUx5IhRCzKvz1wgoQAAUmTwf5W0Zz9ph7NQ4XM8au2iYKL+Z+tXT0M3UU0e?=
 =?us-ascii?Q?wCLNnflSR4xo15PBLDzM41Be84RaDXx0B1uBRXR9+Vf3dxFxJ+DQjYZ+eSvq?=
 =?us-ascii?Q?VsSb+qN6lvgtTj4vY2udeltMysxyyt8qcW6sttbQJgkrp7hLvBaoo3gN983z?=
 =?us-ascii?Q?zG74pd569hgNcZHQDlv8nFMWm5l69Idmnr9ev3Xr2RYxpkwdZrZDf6nJpJq7?=
 =?us-ascii?Q?1lgXZARnNAslCGwQhExhPoepKyHkS4wJB7fl8CDcI9vLNRYifixxrFvYZbUG?=
 =?us-ascii?Q?MyoYmzOmfDwWHSxvdO/sMiolNvRUfS4QZd+1Yg04KlJXA1cY+TDjfeRNZcLW?=
 =?us-ascii?Q?cb5X2JLJel7avx8Qe5bdfTabPleNAL6P2hBzzT+eysGsYHcFX0k6/JjWDka+?=
 =?us-ascii?Q?BXinuDoAPHfwJ7zajvdhq9yVhBd2eLAsr5XsLfTFKdBqEgOM16IkqVhkOu+b?=
 =?us-ascii?Q?RGBjwtyNNImD3XQ4U9eAQ5Uil8BlwWzFUuDpfcRbexf6P7+Ff/jEpoc3z2aL?=
 =?us-ascii?Q?Na8di2h1eQ5gRV4SwzinDjEssT2RG3FQZG/JcQlrKwzkxqW2qz1JBoWtmCvp?=
 =?us-ascii?Q?/FLydQmBYlEP5ux/OL8ID98mn5HF3xrC64droaqVjNT2a/TLajUlecrsOA/G?=
 =?us-ascii?Q?09cCBd/DOZp4d1LHnqOD1E/vKTnJgks5KmzHNWQrRR2r1NFEuCRCL3dB1XXt?=
 =?us-ascii?Q?whOUXcqE23vZBOtgskCV50hSyV9a/CQRtg5x/nuFkK4wDkiyibZuOa6Enc0V?=
 =?us-ascii?Q?dgWn3NnHgefMx25/y8CHmOY/jZeQBBg28wx3kzjyGiZr/YJ4cB/ozKU8mM68?=
 =?us-ascii?Q?54ypOMrpqxB4CUcv2nOtCA1ixvIOI+26BHYaMmnEP48LJYLarIgJny3EillN?=
 =?us-ascii?Q?E0VuQxi5qHFEONbfRMohPHHWP9ganEzh2q7DlBKqDGiU5cgXuL2I1qI2ObC7?=
 =?us-ascii?Q?eciEC6S8l6qEJDOzpix6viEfAd6aRDILTHs6PhWVWonXfne7m2oWQnQZVkk5?=
 =?us-ascii?Q?G68/eUNzzmQdJuGZytSaAcbYiQNtI9xZdEjZfA+bHJdWq07pAPNx2bn1S1k5?=
 =?us-ascii?Q?WLjE2T+/ryCLxJ3MUmQvZ6vhoOpQN2zyVfTOkaqy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef3349d0-6377-4100-59a3-08da59cd1d25
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 12:44:31.7876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vAvrGV+FHTuTaK5WnUwEPApT7sxckMTeIkPzsnaztDD6XBSAEQ0XBivYVN3MmSjugy/O0sbiNTNZ7BsSBD16vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6158
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ziyang Xuan
> Sent: Thursday, June 16, 2022 10:23 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; intel-
> wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next] ice: Remove unnecessary NULL
> check before dev_put
>=20
> Since commit b37a46683739 ("netdevice: add the case if dev is NULL"),
> dev_put(NULL) is safe, check NULL before dev_put() is not needed.
>=20
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lag.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
