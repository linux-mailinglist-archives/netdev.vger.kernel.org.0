Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58375A174F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 18:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242451AbiHYQ55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 12:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiHYQ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 12:57:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA760B028A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 09:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661446674; x=1692982674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ct0Kxbu86uYd3MOYof5D+K1j7KbTVLAebbK5kNoXaxs=;
  b=Ow8NOzM+K1ACVn1iFLZ7rem2GTvj46MQOJpO29nTPiAOqqGTv5/huSkX
   FLM0YixyDvdBnSmpJuepa+0BY/ax/NyXMB3D33qdg/t4PvgJGp684oX7h
   lXmzUoDC1O+yitm/+4KTu0fl2d3mlL51+HokEDRS5dFgUAgi6cFmm4FYu
   5BJ4Byw0GdjPinuMH7QyxGQwk246URDB1QInSBzNFzNVhp8VqOm4IQUXP
   UUxD2BDwgNwDkgGWTw4l6QnhtrfoIQOkJeMcVp/3+CzHvMFdqvPIRjPYK
   AuMAbaxOS1OmrXWphN9iKMgbIqMAvSq3CbGK88bUAjLmfViZcxAPHI96G
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="274694008"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="274694008"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 09:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="786079542"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 25 Aug 2022 09:57:53 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 09:57:53 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 09:57:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 09:57:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 09:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxiwI2rlOWYiV39D5p3oZ9TaS2AEY1zaihVNgS+Tw577BBMuJ4gjqSxRksh2S0uuBVZuIPjOPloWnKdc6AQOk2vSftIi9jH/P8Xr0t0L9ISohpdMg8lPNuYmMZuSwbLRDrHqsFgAyTeZmblBNHFDvZiJV3Nx4Yut/ds2igFmoVkXbeyJltlvI9GikZugy0kS/A8kJr1B49Td8myYe9qb0wZjPvkn7EN6yYhaVtA9zgkl/9A0f7Da6T7X/Gp9BEU17jZKId79onVFPqIPgLtBmqfKjVkGxGM+lwnapH13UdNjbdJF4oiWHaAfZJO7BbRgBCc7EpwFyWJX56aSs/LTbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ct0Kxbu86uYd3MOYof5D+K1j7KbTVLAebbK5kNoXaxs=;
 b=oQ/EtbeMWa9RQknh8+VrPx0G236vMA0zTUhdDOrenf/rTcvByJfvDVCdiffPpCBgAFnsIA/u5B+puCk4f2+xeTahY3gOjjle8MAVSjFypMenUgis/JYEIAmE+0CfM0kmrQasIYIVyf/K88lc2rS4769xGCD511li1GcgBqTiUS38lt/lnQn15eU/kM0ziUyhgw3wtwfrTnT4h2Z1cYBQJ1Hrr16JittgFFKcsUenhmfMW8mC0s41yaI7/tRLS+DFLyS/q6kgzx/0BlR3mO0ptwB1sQDvZgT7EzUkn70aLpdtTCykZJjkDMAAHkZ2hSLXeAUPD8c/3l4xhG7hk7Z/7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB7108.namprd11.prod.outlook.com (2603:10b6:930:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Thu, 25 Aug
 2022 16:57:50 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 16:57:50 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9CAAOPjgIAAnPyAgAAHflA=
Date:   Thu, 25 Aug 2022 16:57:50 +0000
Message-ID: <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
In-Reply-To: <20220825092957.26171986@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1aae6ce4-b770-461a-f8f9-08da86baf18f
x-ms-traffictypediagnostic: CY8PR11MB7108:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5lHo036Itr4ywSc+obk4Doa5UJh77R7go4IeziurN5iildK94lOmOgABbnvSJAfzkOeUG87rswQYnm0znjE28SZhCouWXuKGiVHBg0Pj8M7AmGVmGzqe+Hzkd/lu+rwmVyzUnQT81mpsvL60Ng3rca60yF9KOjP9nwuQjqxLuA5E+5uDQM4Ti7ZEW7aiJCXcmtD0gwaoHP69C9oclV46Usl9Qd2yTVmcya0gYbjli5cY7+HqYNRgwR4dMSrAiP77hX7uam4H7e9A0CSZaLN4LSmi0WiZeNSA8G1UHdPkrN0n2Ppy/d3CInHliyriEdh5oYLL4yOxdFEbzP79Jsq4lA9X+H3sCITkNTkpNK0nkZLrMI30B2xzdRTA86O+hiwxT35ReKnaQkBa5w3nQaW0gmRrecbL4A1G/phSmJhCWwzFzl/K2CXtNBWGHLcLQWBu4ueEnufE+TFDb7+K8pmbVn03RnlmEAVrYEVxwtnvGvMFdmj257FPvyNkAPGN/exdiAsUgW+gNUrldJqTcDsx7/Q5yk3IHXbtDjJT/cO2iVbB2EYiAuEtp0bKPLHdSBXJWCRak5nKfGd0Ja9daJjmrMiLdUBRo5O4Tjwpqw2XHf/lUU11UtStXoCOk+j91Qfqq0asapXiJ7i40Yq/n+XijsdYE6xgHx1W3P9ERp27GIGTSCuoMv6gh/1742re8wKmfJIBK9Jt9voSsACa0TjQQm28jYk91ncxvx20LGMGLWiZFTccTakebV3cLFiNoNeI1prkEkDYROisYFpJkxszVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39860400002)(366004)(136003)(71200400001)(86362001)(38070700005)(82960400001)(122000001)(38100700002)(110136005)(316002)(54906003)(66476007)(8936002)(66556008)(8676002)(66946007)(76116006)(5660300002)(186003)(2906002)(4326008)(64756008)(66446008)(83380400001)(33656002)(55016003)(52536014)(478600001)(53546011)(9686003)(7696005)(6506007)(26005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PD7yKA7tfAd4DVNQb2EHoX8e2BciuMiace41Q/9fz5TEZ/uwFfBRUw5X4EsO?=
 =?us-ascii?Q?gPkfoHdQ3KRY9zNBshnJ9pIvgooL8EWSuQk34B2RUN5HASoxuaGy+qq/wqHl?=
 =?us-ascii?Q?l4zEjj7KcjDBns6SpXZEqqvSgQp3KdJI5iUGAnxNOaJMURzKwN7aAhuGIDYU?=
 =?us-ascii?Q?JUVnxZDX/Od8pWDFg25zbiUF0D91bfQxrIshGpAh1lNLL4t18CCjWjrTjOVW?=
 =?us-ascii?Q?lYfErLeDGmPypOv/i+IQBaqBbMxuQq7AN/kDPxwLwMVCx9qLArlngMaKukVc?=
 =?us-ascii?Q?lnfxOqLiqilaZ/ALN5XcO1sDHesV710azctOeiPvGx7zYDsncmaEvObE5iQQ?=
 =?us-ascii?Q?zMYnjTzA7QPSODlHLHfw9XlA7yCLzVF9z9pqchY63ZvwkTy1RTFeX3Yq2iHq?=
 =?us-ascii?Q?7nJ5t7mctpezWKOsCbglCxqjxkZD8d6cSY5pq3uGjptIM+NLUN5SAQ+3FIwi?=
 =?us-ascii?Q?n3PsdrzQXeVI35bgWr59vu2zgYfruKOE1/U93dIfpcZBAX9+8LkWqWDLsiSg?=
 =?us-ascii?Q?dLlqGnIhK8Tt85H9y6tvnd6Xqx8jVoxoDfDGuo6DlkG/1gP6/HAEnej7aDC4?=
 =?us-ascii?Q?znQmAFlHSb+LvfhHyQeVoy9oW6QcsC7IZ5QgjCX0i3cPNrigJd6fJKdE4mS4?=
 =?us-ascii?Q?2aC6Y0jD79zZynIH8YY3vOgN63dw5zzAEa6Qodpit8xRAdHDp5tjeNC83hEZ?=
 =?us-ascii?Q?hoUYmm7cQSKtBhog6mQtv7LhU7B5DaG4gTYNxS/nfM70uzr6w7sRsii12OIg?=
 =?us-ascii?Q?i0Mvv/3wV/PnbRVzGnJchVLCnfKM3Q85DcACG1ems8fdjD4dij39VXUxvxUL?=
 =?us-ascii?Q?Kt9oXx5HPjQa435rGcYuPH0jLA7Ikf5oGs+w4UqUbm8GO+VEps3IiZWLMAHY?=
 =?us-ascii?Q?mz7AaCuXs3MGzXHwt8rT3/XmSOM7W+4WA6Jyy32+0Au6/rPt/mjc37ogE0Cn?=
 =?us-ascii?Q?2rajonmcGWdYUkIvLh3B25txWEBYlfyN/K0f28HchcQhwP/3UbYx0IMycJtN?=
 =?us-ascii?Q?bDJKEQu+K7UpzYorvw4rejgt40/hOGRPoJD98qD8wO3fwe26aXzO/589pR9z?=
 =?us-ascii?Q?Aj+tW5VwN5MLSnYRmezxdbDEy4yQN1XfUcqmIbF92BjA4DQb/fPRl0F7eZUQ?=
 =?us-ascii?Q?zIucXpvGKBp4MKz/rD7TT7Bp3DxwBIsuKJeR17gFQLc2qdUFptAxz8yOcYEd?=
 =?us-ascii?Q?IWrPs/kq2o79YN1LFu2uxM9Z6Ic4lez6Fd5939369tCKUNxvW6YgwxU6KR+Q?=
 =?us-ascii?Q?BehRd01z3XplPyLAQNsBdjXg5XUKmDbHLjyLzaTVf89s37plfMCmVTpdBRd6?=
 =?us-ascii?Q?ExPoGxRlBHe0qWaFB9W4JOO/bOmPQfHF5NGIZVLW6zJAe4bK4Jzh2a50NpHA?=
 =?us-ascii?Q?AhanVW0PDAbUxpOGF3em4PJcHLV+xJxDvZDUVbfkoknKXaMaYQvoTVgmX1Ma?=
 =?us-ascii?Q?noVQxrq3CfKsbjtpetPzMjmYMsOfdrWBrnwS/w+JQI6TIz7KM1SZ5PEskNK+?=
 =?us-ascii?Q?45qqWHlVDMVvGAdmucqWUt0x3vXk/8upJj5MDg4CIFKcDhiZW22cZBykPUgZ?=
 =?us-ascii?Q?WGJHLEJovtEl1VQ/q5ilDdUuHmWmPh79DhjflhNU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aae6ce4-b770-461a-f8f9-08da86baf18f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 16:57:50.0973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i0aWmCH5DV3R6N787xlXa+sE2kzL7v7et7vPqmYh6yAMTXqQ+MO3120+OzgH//B+MjxfS3Xb5ook90p4Rp+yh3+36EeAOkAkfp2AgsPRV/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7108
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 25, 2022 9:30 AM
> To: Gal Pressman <gal@nvidia.com>
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; Saeed Mahameed
> <saeedm@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
>=20
> On Thu, 25 Aug 2022 10:08:05 +0300 Gal Pressman wrote:
> > Then maybe adding a new flag is the right thing to do here.
> >
> > That way the existing auto mode will keep its current meaning (all mode=
s
> > including off), which you'll be able to support on newer firmware
> > versions, and the new auto flag (all modes excluding off) will be
> > supported on all firmware versions.
> > Then maybe we can even add support for the new flag in mlx5 (I need to
> > check whether that's feasible with our hardware).
>=20
> Sorry, I misinterpreted your previous reply, somehow I thought you
> quoted option (3), because my fallible reading of mlx5 was that it
> accepts multiple flags.
>=20
> (First) option 2 is fine.
>=20


Even though existing behavior doesn't do that for ice right now and wouldn'=
t be able to do that properly with old firmware?

Thanks,
Jake

> Do you happen to have a link to what SONiC defined?
> We really need to establish some expectations before we start extending
> the API. Naively I thought the IEEE spec was more prescriptive :(

Yea its a bit unfortunate :(
