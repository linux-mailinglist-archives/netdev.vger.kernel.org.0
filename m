Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646515EB8C7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiI0D2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiI0D1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:27:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E0E1003B8;
        Mon, 26 Sep 2022 20:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664249148; x=1695785148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ImMUiFYyNtLv2p2/uiMCkoCNgSD/1SLDJVh/3XSJI0I=;
  b=J6s/FIqWJWFh7wv7lyx8NFJsC/odmdwjNB8hD8++dTauHSCBHEERCUlb
   610CVXjLCQ7kcxuhcqP0kS9pgNwa928DbuzfK6WTTnFIjEO5xLWRxV9A2
   m9FYyCrM5rAKqmcDq51KrYHn1JdR1ffPbLIgGG04Xwb6yE/j+RJY0f0ET
   Lnc+k9jVrvZWtNEuoSjLMkXVaDGL8kxYpErzQi06zH2XmzumhkP65FEjf
   ZAyXtNFyY9bInB67B9eWItUdsD08n0y/Eu4KmSj5hpwXefEe2Q3zWnqEU
   2DwqoDePktb6knGNRgxNaxty4zVTR24SzM0xkbaa4MeI1yOSglSz4/zVK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="298803356"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="298803356"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="725334089"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="725334089"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2022 20:25:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 20:25:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 20:25:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 20:25:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqMYsBjBHciq/j8CFvEL7HrwguU7xcNg9lRX6SzTvxsEtlZ+mvuFB48kNxug+77zobP4ehFvhAX0mi201znxDaMYk/bzJEcDvf1KcmxjKENbtE+qlUa+H7QJBB4VunRbr2eWB1nySKKC+q7Tsv6yRf0dx8zNFAc0qtvGI1TGO1HSM56rEI2mmD6UC5cPbx3XEwwvM3uSgdlV2kUIRlTcoNNUCD4l2bjYvfKfCjKDo0yL41Kac68/YbDHnJad/VWI2JeRBXN8Dc3BviK+avoGlh4/qriIzRoJCfv6ltDoCbMJitsfMu9UhmNIoR+sQUYi3tOqKdKpXiQKbY0fLf8+VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+CRwpJ+KoHDCwl0yadAT0T9XFsIgrCOFYTvqaj7Jek=;
 b=HIdYhkp36QsNRLHiLNCR9Fp2EXLiZaUAFjsmWVdcN+gAdw1lEVWplHBoLIkag5J4oeJUHmeIy/s8f1VeMxQcVJHuPumTD34D18An9vYYX5/Sjp9PngKL8nXFMqPAH674J0zRpapTowkNMMQYet3EKcIuNCsrHgZ4vtP1bpYDBKBceu/6SV2mYEqJ6NADeg4RCB/w7oEo58q5mPEY+TNtGt8zbLfccXR/Fzkf21VDScPTw1enJiEqEhR/zIhAN1kuG5ruAs4bZmTO6E7dPu3zRQmTCQrnF2YdenJmBnssdDPe84q7aCLaODAUboYuhzQiLtebinhoR9zvnVF8bM/icQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Tue, 27 Sep
 2022 03:25:44 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::d1ff:f036:e0a7:9af6]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::d1ff:f036:e0a7:9af6%3]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 03:25:44 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "alasdair.mcwilliam@outlook.com" <alasdair.mcwilliam@outlook.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v3 intel-net 2/2] ice: xsk: drop power
 of 2 ring size restriction for AF_XDP
Thread-Topic: [Intel-wired-lan] [PATCH v3 intel-net 2/2] ice: xsk: drop power
 of 2 ring size restriction for AF_XDP
Thread-Index: AQHYve9d5G4vYkbPgUOMSrWmglaRIK3yxXRg
Date:   Tue, 27 Sep 2022 03:25:44 +0000
Message-ID: <PH0PR11MB5144E9C60B933B77DA50F7CEE2559@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20220901104040.15723-1-maciej.fijalkowski@intel.com>
 <20220901104040.15723-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20220901104040.15723-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5144:EE_|IA1PR11MB7319:EE_
x-ms-office365-filtering-correlation-id: 5a557ae8-dc98-4005-2199-08daa037f665
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kJTzGkyYJ3VHMonDMwQYfhFr4fbQtYFwifqc5/e4BtTbVqIv/w9mmMtLxng4Rr4R+nFjq1aRsnvS8eoHKWxRTpYGEi8Sv+5QEPoSPr8YTvpcp2V+wl+exgl4NnFrJaSdUuomxAjFyqhNfcMOFXJ6x0cw/wjEgNcd3uwfQDduoj8WaSropUsBSjyGgSA5fyI0VCRNIW4+wX0Q5qjjT7n5wQggFVvhSLGEaMFSK4T6XWdoqlx5dcp/yLbfWkWW7VBa6kqBQtnAVt0n5YsmE8Un7Hb1BYS9OOU1NkFsdNl7PR5CQq2ULDgnbrbdtO60tUwzyjnbpGhDQHW/dcEutOgAuFYpXjUVT8I6vnsATwzt5tVxQXUoNlDdxg1Qa3ufswhby5eXvaApkZuMP1QrhQaQyr1Dzh5ptPL4l/JL81hH2qhN62DSq8RLocwBd79q1OeFUdZLBS0vC7+mqoGrVuWi55e5ayzPnojMhYI+9xpZKBaHa+kmCk08isQg3+sJtve7k9mZUTJudxSMapLYj3W1tK0zVRuU1MALRmeak0bOGXPasB9Bi+MkqtXAHDrmfTyi5s1FEvaynRuoQgtWYienN2kAeBIRg7owDLcLpsVDnGRPd2BPj5Ip5zt1E/n/S7k7G2jqsGLEBTGWB6sed+D5LSbxM08h6UVH18xoGZZ61MvvKxBpe1lf1uGLb2lKDpJyNJC/k2YVnBylPu2TvhQPTg6knIT0R2fvzN5WpC/itVaHA1/yZ2DCLiayR6wep9noB961qwcJPx1q2Ui2nIxC1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(136003)(366004)(376002)(451199015)(41300700001)(71200400001)(478600001)(107886003)(33656002)(45080400002)(186003)(122000001)(8676002)(38100700002)(2906002)(110136005)(54906003)(83380400001)(86362001)(55016003)(6506007)(55236004)(7696005)(26005)(9686003)(53546011)(5660300002)(8936002)(66476007)(4744005)(52536014)(38070700005)(316002)(66446008)(66556008)(66946007)(76116006)(4326008)(64756008)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sFI9RCV1keqVHTB4UKMnHg3sOhO6HUHtdleVJaH4NGIEuj3q6TvhhrdFNpJ/?=
 =?us-ascii?Q?h676TZuwYi1A6q3UHBUB+YQHKdQXwgyVffX1EJO8vx2xrrlOyKVNWG6JiNjY?=
 =?us-ascii?Q?ar9m7gSvCoIP5RtusZM35+l9r+hr6O4VK4Jgy8waQiJBhoyMNuLDy7N+DRTm?=
 =?us-ascii?Q?MFjrTuA8WQ617814Jr2yYS4HEYSV+H9qbVnpdtKG9x8b5eFHN0dKp2m0roxM?=
 =?us-ascii?Q?hF8zNX4LeBn9/9cVL8egM8tiwZsp7igOyHmrHv1gOcBJJBFs8W2kSLoL2aFs?=
 =?us-ascii?Q?izu/tfh1pZsMFTW+nS+jrgXHfRCxaoNxxgSbvmT219APw2JdCV/OPrGujLcs?=
 =?us-ascii?Q?p/Esn7Z1/Mz3ithni22skWkk1QkEiRyQBqPuz8DQ35sAF1Jgh8hogE3l869j?=
 =?us-ascii?Q?XM65PUdUE/tFN/jVchoBdX3UJO1hKNs7IjxywH3AGBxVpr9monfTB6Uv74uf?=
 =?us-ascii?Q?yCLukzsWCGxctjBHE2AhWlZ+yNgWPyFqQ99eqMtwdTY6rGM7nfkKupUYtt7z?=
 =?us-ascii?Q?9Zt1Ubt1UXa6GPKmy2ThlGNVJUcRHo4Qt2MdWTJuZUhBOSVy6SzUcbi1smCN?=
 =?us-ascii?Q?sarqLL80Mjs/f0lDAZqVND/os1CsQtofMdoPjnskAQZhwXmOi21Ckv9v/g6E?=
 =?us-ascii?Q?rISivHw1BVRUoXsySWvN7Hm38NSgKsnlG4pYM3bCheroMrZWbr/d/gG9fIAh?=
 =?us-ascii?Q?kHe14HYJBOprdhp7cV+e3EADx7TLtc6v8Lc19ouSQGp1ZBEFZ7A/MX1pU5pf?=
 =?us-ascii?Q?viNLwIDphtr/8ZppbCkroKVApqkcG6/96oMknmLQFt2hh4ihtbVbGmILnA8I?=
 =?us-ascii?Q?PJ1S0LupFs67wvuJYzhgkH/IKAOqKRGNrXlWPmlEl39q/i7ViH4SeWy2jyoT?=
 =?us-ascii?Q?xWxrrcc99D1aOW+jeTedCFb7oUYHcZmfMvIr0WCaBFNfsYGkvmOkP/lZUuqM?=
 =?us-ascii?Q?sRNfQpRc1Xm63NnvosgXrvmuIxSmv8w1aUAcftjzjVRE13K7HOxIR7EEhvHc?=
 =?us-ascii?Q?WVA4GFghLhH9egIBKp4NQ7oKiJldhxIM+V0BHF/RjX80lpNKVs1HJskzmlCW?=
 =?us-ascii?Q?fU0YNZ0cDgmaXTN7ZZqEoTRHDppnwmaDv7LhWSQbqc2Yl5YJ+1N1/LTkqDpU?=
 =?us-ascii?Q?ho50V6gfvX/Y6O0L2i5j6umclixcogZlAV0Mbl0MEMh31iJxjnFZD45MRuIC?=
 =?us-ascii?Q?/ODDr0viOxFC/diZxVRJDbH5PZjA9g4KCln01uB08JShJm5tErA8c8puVOr4?=
 =?us-ascii?Q?s5+UoRISZqWG50Wa6oz10JLn3DnTBhqM2KR64IPydZtOuzOwT7k0J493pEVs?=
 =?us-ascii?Q?8D7SzBwiq3uCtPDKfLHnIi9BEOUu+CuMEGADitgpdXi5erCj+rzXfO+cpV9B?=
 =?us-ascii?Q?Wzakc65Zg9FDXkZzhIyUMPrJjRnTsnyacSVM9xS12QI7ZU8d01/XIerC9+Y8?=
 =?us-ascii?Q?X4RNh5uIZ/3u9AgfgD7ejDpnBRSYv78uGFsuY+USAbih51qQIcehQmX6zAQW?=
 =?us-ascii?Q?hygVTVgWQ0DKy4BuIK7OGHEgJPFB+EBoJuQqE1Wo16pvwtmVaTJwmvkHX3Kd?=
 =?us-ascii?Q?/ePhQMbiG7Sbh9MDtraOah/yDETlN1X1AbmgkHh4F5AyqTijLc47YUZaeG2R?=
 =?us-ascii?Q?xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a557ae8-dc98-4005-2199-08daa037f665
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 03:25:44.3189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9NiGGMGv5LnbL3BF6Cf3tXOnGd4cPr0S8APv3KzRKgAAfxsz8kPhEx81XySm4Y1S0/qEp4Me/1a71csAsRpheyC6ahom3yPksDzDEC3r6S4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, September 1, 2022 4:11 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: alasdair.mcwilliam@outlook.com; netdev@vger.kernel.org;
> bpf@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v3 intel-net 2/2] ice: xsk: drop power =
of 2 ring
> size restriction for AF_XDP
>=20
> We had multiple customers in the past months that reported commit
> 296f13ff3854 ("ice: xsk: Force rings to be sized to power of 2") makes th=
em
> unable to use ring size of 8160 in conjunction with AF_XDP.
> Remove this restriction.
>=20
> Fixes: 296f13ff3854 ("ice: xsk: Force rings to be sized to power of 2")
> CC: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>

