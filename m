Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E32583298
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiG0S7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiG0S7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:59:04 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82175019C
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658945355; x=1690481355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PVBSEoejxlEDEx/KxTdXSAkEgaq4Ss+EIIFviW17h+c=;
  b=im5/41pIA6PiobgUCWEJI+5ze5cXpBdl18Aj3Nd6v+TYh1uT0cQlWjgK
   M1qF3udVgQOfMS8hSgvWv8LGwS8DhFIyJ0vtyq2w7eDXBTZ5pY99yV/xx
   iitIC1S8rTRHa83Uu+ILjhxo1RFxlQ3bswbrgBLZJbsXIX0I4E8RvCcsR
   Fk3Q+T+DtYyi/Xv6L4J31+ciuXmKXap1kJUPmhDWen9hNE/jQHXf78VrK
   pdTNYvJNEb/Z4vL87HsJkydka/anjOSeva699pIFeJXYRb6il/+RwHNvu
   swa35P7mLPoueI0Ou5pqZ8FDuziNX7cmZFV2dc0f6F11l/YVgVVQaaSEa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="352305922"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="352305922"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 11:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="668448874"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jul 2022 11:09:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 11:09:14 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 11:09:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 27 Jul 2022 11:09:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 27 Jul 2022 11:09:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxkqpnc/yPJ8VWJQyHMlmPYYIDye0wiQoK0VVwv2RxRkqT1RQ0Dds+46JfhiZNJBvd5rhZSnu4qig42Np/6AvUjT4RpKEWDCYZCi5UznJRG2l7ayY9QmdIicp5TKOnsx5R52K7o4BSLd+QGMLINlzuFiACjfKu5IOLARkMWVwX36fd7tU03glTmzNcDjiOtDH/05AIh+oWVaI/0aqroenMygTqt7CmmbNr0IOYJrearc7xkOm10GovTxve5julF508VnfNXpDQPFmBbcvc6hTZyrRRhuNlalgo2RtNvD8HjJaCj5OgE6Li+nluUq3G1ZzzSq9oFEuRTxi9Yxq5T++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/fxZFfh/RVxIsgO8wJtge34dcLHyBpNQ/BnR4TSJoo=;
 b=UDML85EUU0WxuKI53ZyZOHpqEQV3ykLBo0HWy0wS+AeOq8WtQXNTnmZF4MVMI+x9XKQel5jYDxOoN3Cs5mBuBD/m5hs2+XOmwZz/Tect/0tnkYLbyHod+BpiH6jJgDprkH+TO/UEz3SBPJahOAxEruX3QGm9AJa/1Qo4bz9YFMI/Hwvj2UDonEkTMN5wHWwcqxr6t7jgKyB/snyXQ2YA9bjVv3XTtagIf3YxCQvXp8thiHDd+YKQp9juMdki2xdrXRKyKBLu1jYbbxxtFKbtRhGTtTF2h4ZvGTx3of6hENSmmyS86THgULPA4EpoJpETFIFZJQcsBzLVV2pahB4BzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by CY4PR1101MB2293.namprd11.prod.outlook.com (2603:10b6:910:22::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 18:09:12 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::a0d8:c7a2:c336:ac7e]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::a0d8:c7a2:c336:ac7e%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 18:09:12 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Gerasymenko, Anatolii" <anatolii.gerasymenko@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next 1/2] ice: compress branches
 in ice_set_features()
Thread-Topic: [Intel-wired-lan] [PATCH intel-next 1/2] ice: compress branches
 in ice_set_features()
Thread-Index: AQHYkerCgd0YU6Mas0mcWE+VP8qiaa2So9dA
Date:   Wed, 27 Jul 2022 18:09:12 +0000
Message-ID: <PH0PR11MB514453A6DE9120E0D33A39A9E2979@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20220707101651.48738-1-maciej.fijalkowski@intel.com>
 <20220707101651.48738-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20220707101651.48738-2-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe843c93-6d0d-4cb4-4300-08da6ffb1c17
x-ms-traffictypediagnostic: CY4PR1101MB2293:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XiXouTuvcZSFlw7X57rX6cggD5vw7qqTrfjEBCqV1JWW5ZA3/XodZvSLelnMfxNftJrDKiHTjFSnQ1xz60bLdybnCYj+HEk9/jiPUT/wOAC1ohpDoyuWmUp+AxepZ8XVss1TtZjVwBT95YHLp+h15GM157/K8403d7IL5ZA/TlDy1yUwMriBVvHRZFww+cmPkST4r1koWWBs8wulm+Hseyc4KR5ewnaVPR+ASnMupmVgBs+Y8/84/7RnQoIT2IuCmDf7tnwVh6lDDMMbPlj4ijC0Ejiv+eBt9uNQxuOP7RLuJ77U3MGzsB/D24mKejgK+oso9KJvWrZT46y/gqR0JxthI5n/oFYFGyWDJ6xF5Wi552eE3Tnnuf8JaderbcphU9VXfhnRjkSSpLU0GNxkkMP2FxhJhUQMVFyE5Gh0lSoY8jmTjQu+YgcXbHHjqYrky7G9Z6acarjzShYPzvF4U+L7rrnarYqNkoOo5yyHB6CSmpSKnHSZ6n2d7PHnqVYO49bB1B0nvPW2l3GdrtHi89wfES9S+LUD6RnIoCL3OBUWTunI7KOLnXd4UZjFupumwYQe4cVF9e2GvNj54EReDoM6quJdgiQgBzpsT+LehMn8NX7sDdoqLgaQVVebhl2Swk6xAIQipQbL0C2XVhOSXxp2egi7bC1X1qpu7vRbZN1QPkSzdtawCcPVWMEpTlKOp1XyKh0nxXrxbfllBXSh8JuJgM01Z/HyuS6PpfjC0BD6NimwFEs9dhM7dzl9z5IgP9rMitX5aXG5/dEUHzfdOZM+LifaCb2n2Aobu9yL1KaXi/4Ht28ls6l86YHwmFU+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(396003)(366004)(39860400002)(107886003)(53546011)(8676002)(186003)(7696005)(66556008)(52536014)(6506007)(71200400001)(9686003)(4326008)(76116006)(66476007)(64756008)(66446008)(66946007)(83380400001)(110136005)(5660300002)(54906003)(26005)(38070700005)(8936002)(38100700002)(2906002)(82960400001)(478600001)(86362001)(316002)(33656002)(55016003)(41300700001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fHvFxeHUoEsSVc9K4JP6v6WVNZ7++b5i8H2/NWrN/QOOCMOjM2xnbpJxsx8S?=
 =?us-ascii?Q?nryNfZOfMPUkaimieUqP1ybXdX+oy0mIdbUUUI7D9jtmG6GKDAy5c3qvdVl2?=
 =?us-ascii?Q?rkTM3sO8gkG3HazYfS69SVfmJQoC5mQ+nhZ0Uhnn618fSOL6Vz52BFKhyTcT?=
 =?us-ascii?Q?pLjx3Uh+ClLetVPjS+WDgSiPZ28o7zlvyErQpJhbSwHbGLQMMtB18Z1aDn43?=
 =?us-ascii?Q?sG23uIelzZZAhs0MFv/eAP/JXdFyFqqfp2f65o1zQjT4lXdujAd+VnGfL1WJ?=
 =?us-ascii?Q?2t/IFJzhxcLc/L1ZkV1E3Tw7kbpP8SQKmmdF6C9rWAZ2K8og1iTq+98mpZGf?=
 =?us-ascii?Q?rJk1K2+L/50MmNPAVTP2SNkb7H8H0xndpV4UTbeb6WSVBFtQe22irVxzMPMU?=
 =?us-ascii?Q?C/l+LynUd4dBcJDBEUmP2zKhKhm6V+KFpzv/7ju1A3AozP1ntJPf8z54oCNn?=
 =?us-ascii?Q?CVcFHczWAM5XfuP5nRosXmcOXBTkz35iZLqkss+Q+NhyTxoP1cq9vaGx/aEC?=
 =?us-ascii?Q?W7/LDNn+hmPOamCEdQpRJJE6QcRy0yhcoDI85MLy1lEOJV3KU4yaVXT6qTbW?=
 =?us-ascii?Q?cW8CLqiWYeWJuJAKb7khvyo2jtpcB8Iyf5pH3dF/8fZPhbT7OeHxuXUjHJPf?=
 =?us-ascii?Q?BCFC2i66mWAdyVnQ4fOp5JvymLmFK/15RdCR6c7xl4Mn6egthPitmEMt4nNK?=
 =?us-ascii?Q?/LBrnmeyh6REEZMBKjt1gNyn0lJcDlaqGnuo80Bqnf0qhK84518NvTNArt4R?=
 =?us-ascii?Q?j6xQptvxBUEhkcCSF5M3JpNb6oCfZR6hlt5iUvEiQZNF5RdYDd805KTv03v1?=
 =?us-ascii?Q?xgN6aVN3yozkiThc3dC6zeW82MK7UzAeLRwq9BCrlw36VaVpB7gZjEIt49Ik?=
 =?us-ascii?Q?YEXYQc3aHl3gismy+IURxii0H4BqtSAw1BPh4Z0gzqu02YA1r2XQF4SY51qV?=
 =?us-ascii?Q?VSl3u6nJAxwgRT0pyuAAVpyLpEuXZ3x13EMk7jaJ3rHXtsaIK/FI6Vfrm/lT?=
 =?us-ascii?Q?9WccumdNBxzYpa9JAr4aewjDamHLcnFeTcxU+8ZFNNlxDnY1UE9kyfFqMYqS?=
 =?us-ascii?Q?gOPYak52oDyItemauY4ys65AgQak38oniBQaf6fiBnjaUCqSiyIsWuUTkwL0?=
 =?us-ascii?Q?z3IY25ccaUD7h4rlVxdMdrVy4+YTWoF/JxK1MAdzG3vz0/i7943KpI/i1i3T?=
 =?us-ascii?Q?JCROKDXX1Gl0NDG4lAmeG9TU961q5UOJHZ1R87vwq+Msebs6hZkatXdomoGp?=
 =?us-ascii?Q?VzBUrxcrrllA4/bonZvSTqzwppQCk27PJ3LcOLo74bT0idyFix6S/+1UdnjP?=
 =?us-ascii?Q?Jd4JPBY89kp07G/NvduM37uDW3bHd/YTvVJ0s1cdqkEgaWS+pgNzpyxLSnTz?=
 =?us-ascii?Q?mtaqnkbD0eq6PbwTlKMqf8aGv6UADinpEzb/S1TT6j0KKme+ASeP0jT4Ih1t?=
 =?us-ascii?Q?qH7m9SYsQiffdscySbcPxmMZTVobb7pXboHQrEEWHlZfaila6pK1kLoc9VPh?=
 =?us-ascii?Q?t/oqJweJv0xrlC8pXGW2enqf3BrU07EGn+ppbFUxjBo6qnpFxoBz+GWjWxH7?=
 =?us-ascii?Q?eHyfJUEPOFzQ4qntYRubncN4gFxx04ByelNd2p0TO/RGziffo1Q9mfapR4Ms?=
 =?us-ascii?Q?cA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe843c93-6d0d-4cb4-4300-08da6ffb1c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 18:09:12.4588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jFm9sRzo3cWxXwAt3i1eYfMJF7P/rN09TIuZd9i5/3+BAf3qu67z4BAqs4S8e//N/gFYxcZilDo/gyuYGE7o5pu+a+QyjOMz1FiG9FuIsCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2293
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, July 7, 2022 3:47 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; john.fastabend@gmail.com; Gerasymenko, Anatol=
ii
> <anatolii.gerasymenko@intel.com>; kuba@kernel.org; davem@davemloft.net;
> Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-next 1/2] ice: compress branches =
in
> ice_set_features()
>=20
> Instead of rather verbose comparison of current netdev->features bits vs =
the
> incoming ones from user, let us compress them by a helper features set th=
at will be
> the result of netdev->features XOR features. This way, current, extensive=
 branches:
>=20
> 	if (features & NETIF_F_BIT && !(netdev->features & NETIF_F_BIT))
> 		set_feature(true);
> 	else if (!(features & NETIF_F_BIT) && netdev->features & NETIF_F_BIT)
> 		set_feature(false);
>=20
> can become:
>=20
> 	netdev_features_t changed =3D netdev->features ^ features;
>=20
> 	if (changed & NETIF_F_BIT)
> 		set_feature(!!(features & NETIF_F_BIT));
>=20
> This is nothing new as currently several other drivers use this approach,=
 which I find
> much more convenient.
>=20
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 40 +++++++++++------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
