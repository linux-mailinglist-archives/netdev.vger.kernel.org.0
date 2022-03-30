Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBA94EBE90
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiC3KV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 06:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiC3KV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 06:21:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40D61D8306;
        Wed, 30 Mar 2022 03:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648635611; x=1680171611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fmB/9DpS74ZMe3CeSFv9yTd3w4KvOuuxMi7ap1vkbFo=;
  b=K2oXVMROPzYr8FULSfc9MX2Km65kPgcd5lO6e1Nfnc6y17F/En8BOtdG
   x2h97epqZ2fX49MC/lVTMvL3NXiLPGP9PZfP3xxT1C592b4NRL/1Fqsot
   +VPolMULV4ANH6q57NAu/lMnSJxOqC+7kETM/rvkr6diCQSDQ3zwpk35R
   8wjPoiF5y6HBZZvrtQU+T8WmvU4TXZwaTdYwe+uhBGsXZ0yp3fDgKjDMe
   pTX3dtdWeQmnx/TmJccp6WynO6hl4uYH+Y/q90bdGbsOGJ1v8vB4ok3ez
   jHVs2am9OrSmR6xQORnjk7E94QVYfjMoB1S+hIhzuZMMq/Tbs5CyPZKx2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="257087156"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="257087156"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 03:20:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="554614480"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 30 Mar 2022 03:20:11 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 03:20:11 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 03:20:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 30 Mar 2022 03:20:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 30 Mar 2022 03:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmJnwNzK/aZAvheWSClP+ncYJp9yMoF7p+e6sLyQNCq9TpPhYgrcwBliiPzRXoEyaR5JI6llQ4MrH68Fx9unR9yyIjhIW1DA/vxyit4g779bGi2KITu1rS9tNPHcSOXELleb2zBKVzXYyiQBpAPpJEnqVIPHSaBC1evM9V4OPF1ZJM0oB5ka6OhetnLMXRB5c0siXy6CCgLougemTBBorXo3+aEZZxjMd0CNEg7QAFPdPcQd7MIGbOGoMb891n3hnh37jtIpSHyoCTMpE4fC7MqnjCyvdSaF8Xah6tKD6fk8YF3mlGpnBvkWBq8lOWILNdqFvQ8S8CZ5q/O9gXAQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zHpXgnYoDNfmIm5+rgyj3SYhZ9eOxe2oMaSryrW/Gw=;
 b=c4RzM1LKmkQx5HIrsLDrGRSIdXIGsQEs0g5f64kLQQOBuOtrBvFuQDn+zTnHlQz04IU0VG0Jl7y306wMp0+8eV2TrhQZ0aw5sqtaDsdeqjMaoqQF8Zcds5mmPnnxLtGOtO/yKT1G0hLG+XuXMnHp5lsJUjTjUURg9YlPO/RVv4t9B7Xv5LrDD1bbfgLnsO6wt5z5MYFl+YnY4A6+i+51Ti8+j5vU3bdrjhBlZb/vZCnpVnMtfMKq6rY4OoBhAYn5ukcWXGN5FYHiu3oO3YTFYc7ARKa7cFcZl6U7EC0nxLNjn0ZSJJH1Hpv3MSN1W55klr9iaH3v3w66idjg8XZwaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9)
 by BN9PR11MB5498.namprd11.prod.outlook.com (2603:10b6:408:103::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 30 Mar
 2022 10:20:08 +0000
Received: from MW4PR11MB5822.namprd11.prod.outlook.com
 ([fe80::f40d:5cd8:1ecf:4b95]) by MW4PR11MB5822.namprd11.prod.outlook.com
 ([fe80::f40d:5cd8:1ecf:4b95%7]) with mapi id 15.20.5102.022; Wed, 30 Mar 2022
 10:20:08 +0000
From:   "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net 2/3] ice: xsk: fix VSI state
 check in ice_xsk_wakeup()
Thread-Topic: [Intel-wired-lan] [PATCH intel-net 2/3] ice: xsk: fix VSI state
 check in ice_xsk_wakeup()
Thread-Index: AQHYOi4kg8GlfVwb3UCCnLYNRkFGJKzXylTA
Date:   Wed, 30 Mar 2022 10:20:07 +0000
Message-ID: <MW4PR11MB5822077DEE9490C0874EF2D4901F9@MW4PR11MB5822.namprd11.prod.outlook.com>
References: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
 <20220317183629.340350-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20220317183629.340350-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0a17946-254f-4610-251e-08da1236dd8a
x-ms-traffictypediagnostic: BN9PR11MB5498:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB54988ADDCECE378A5BDA47C2901F9@BN9PR11MB5498.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1uIcZpJtOgk6nA1ThTtgBip4xTQxQ8mnVyOonjowwsvNm5FytVHroIviHLq8wmk3pR2oIDZikIK1fH1cdfWWsuZ6aooj629AFddl4oqkRuIYd4PK1kyyuAoEd7+IFA2EGZdq3CkfRiziZMKRSYIyH/vzR+FRYJQnDjm9/VRoFMgtCdES5lzeW1jAyS760qPlbMagMeSz9Q2rmdSi74GnQoHDuJ3MfPR6pQgroA7+OfFfxMfg8NCqZDMCJRG7sJsLfjOIv0waarax8zPhUn0YDr/kVUK+6vkYiOf28IHX+1TdwcFEm+fYTwUdx4CDxRLtsmOYrVS5H5osFJDYjrjk3M74Bm8BXFBPbIq+kEqPEBE2adpqHVuYcKoNXAWs21JOnmfMjUpNwZNdeYFncipydiT4QR3u5tC80q3pZ/AwxmQCoKR8zCDzVqlK4sf2uHd/XwJYqH2wKzcRz4KMqT8PTItjDgSiJ5TfD2hPCRGJtZ1+um5UvUmtzAnGZI4k1iA8dB+syLUPwAQItgBgEPyvjwJcp7wqV/lGiwBrLTX2F/uHilNsE2/mcST2GB481ltJ0+X0/9oJKjcDdLK0GNM9y5zlg3wGk8zs7K7KCJwhoIXDOx+fzZoPWPzrLiMjLezIinZkUs/cXGAkDRnFVu8sm07Lh+YEnbPl4daLL488CD1/fiNaqFPLRzrakfBLO3DJwOOQ08ikpa5bGIgW2HVgpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5822.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(33656002)(82960400001)(122000001)(38100700002)(38070700005)(316002)(54906003)(110136005)(5660300002)(2906002)(55236004)(66556008)(52536014)(508600001)(66476007)(66946007)(4744005)(8676002)(64756008)(55016003)(26005)(186003)(66446008)(76116006)(4326008)(7696005)(53546011)(9686003)(83380400001)(8936002)(107886003)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sMSbhRcQAiKjulQnV9aS97V3evBOgg7PwOiSg7emNIaRM8ui5AmHNCuB+BIf?=
 =?us-ascii?Q?Ly74J34vXfZzXM+dADa/R80zrv54NmK6R0rXIf96fSzqEsx+pLHhleOQmX4W?=
 =?us-ascii?Q?iRpscidlFFb/j385XB/3pwqy+e094pCp88PUW0CioBI8a/ZVYMRC46pjp2Hy?=
 =?us-ascii?Q?bOzqv17EQ8tGr7uW/kxatcGZto1IYcDZ9pXo6L2KPkfOwqQUlgfpvK68D2i3?=
 =?us-ascii?Q?qZe/RgnMXG8gN2BSoQiGo0jh9f9tDTjC8/oTGHRhSRLY6y5kUlpjM46TC1dg?=
 =?us-ascii?Q?TjCLP+qns3nywQkJjojLBxhj4bB5ajACxm2K42P0zIUPaDyn/cZKGoDLP5y7?=
 =?us-ascii?Q?fn3xsA7Z75pyxgS0i3ezMUX2DcMLXlhkKBp6hsTiebKkfCND43y4a1ZkJEE/?=
 =?us-ascii?Q?9+zfJGJXXGT+YaCAQoXxXKDo0USJI4UwogLmBFIsgk6/zeLKwcmRxquQjQTC?=
 =?us-ascii?Q?90klG25MhLQyhqd71f1O+wneWepuSiFXJSP3BHO9pnYgHud5YUGPcpxBb6/V?=
 =?us-ascii?Q?szG7qPxNHA1WcQTcdrvEV2EGcobdKFzLUsi6yZvo1BYOU+igKdsUkHK8kf9a?=
 =?us-ascii?Q?0YADSg3GltRw7hBQUkM1lU4ORru5+l3IrVjKj35QmANMPrs/Y14DPbzqkCgZ?=
 =?us-ascii?Q?EJFP3OsPNV/ZIHDBmTjASPDs80OEvWxtbcEoKyxq6c7MqR3gKlKCBXupmqiJ?=
 =?us-ascii?Q?VqfLmQT09xEkwQRuAr7yo5kFZhxVFjEF6dq977SHGBpNWbrJwTcdNHiCvRc4?=
 =?us-ascii?Q?7euTy5dxgvCynmgFKPaz5+Ilv4GrOjGBaBRoUCwDntHe7gaNdf/h9s3JU3h2?=
 =?us-ascii?Q?Lj/P3HYEEZgmLdRrUfvfe89neOq5o8SbaRuTY5pOY+XWo6HGUYUuQhZvhOKn?=
 =?us-ascii?Q?2MFyUr32VZLP4IbiebhpRlWXzDYzMYERkexNo1HBWyyK2AdEhl2WSougpCR7?=
 =?us-ascii?Q?+OThygjIulc5vrO9AQwu/vPjxO3Vde8dpnaoqfrOhMLi7iljZgiKDZerCzfl?=
 =?us-ascii?Q?nDw0UCYydbLxJK7fIYM2/HgNwF+pcNqLbrWgBV27612ikXoTLM2rkPWSAnsx?=
 =?us-ascii?Q?n9gmiCCvwHadQJBtt5SluGgZQFjDS2zNwrT+7ZpaRutbDwJyasSGrIBymfx1?=
 =?us-ascii?Q?IXwcC0tFktWb3a9s1Hg66wkn3Hx/hxgunHE6MBsgB0RBeqJADbGXp/KwOrBX?=
 =?us-ascii?Q?IH4Dgbg+D4TfcntBB7SGCPkEs5O8KqJg94jdcsmTMDi5J0d3UVIAfzZUXg3G?=
 =?us-ascii?Q?ZlxoyjGsPPmLNEVjYv1cRdX7heIccMp5M1qkBOJnVuz/Dzxxg+l8vlYWQQR2?=
 =?us-ascii?Q?5apfW1AABIHVmosB17oPL0YEdCizU4YLEuJcL1buDVp7pbENLCFgxTZXUBKJ?=
 =?us-ascii?Q?ZatPyo5D2I2rCRZoWijNMWzbvP9YRH40RVIks/hL25FEQh8ooebeTnJYsmy6?=
 =?us-ascii?Q?+xKp2AGGHTkUhGdWSQIbOQPomii5D8TRqpt0EKxLLs2+tlQR2WFhxRPNG3TQ?=
 =?us-ascii?Q?wkLL86AJ9htoGPSRRq5XdjdBPKXCcy9RHezVg0OkQ29tDoAx+Pkdm3OePGVH?=
 =?us-ascii?Q?Glt01zFHS72zEOR/rrX0ME45+IbrZk1ZRcoaibvaFd10Z2DwmuKltk9g0Wxh?=
 =?us-ascii?Q?uzzbYHoWIhWncao7R0q7kC6dLuofTJw0LcPG2I9wi04w7IxOsdtV+c0P/OVi?=
 =?us-ascii?Q?UfoQ174ht2MbNQMAb3BkZ4nSvhzHwJeQs1kvoaeIosC8FNHx8Rh9hqmW/RH5?=
 =?us-ascii?Q?n+pIFA/t4xwffiU+go8+8inYo8P7PhQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5822.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a17946-254f-4610-251e-08da1236dd8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 10:20:07.9605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4SYa+hoiEbNrO9hKJArl/LmxQKM/f3W9HtC3XM3fEhJq8ypabwMVXmPS3wOKS4A83erUQ+F5JGDNATre9Baz//e6Azwdqe5Ck/y/x5pSlo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5498
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Friday, March 18, 2022 12:06 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; kuba@kernel.org; bpf@vger.kernel.org;
> davem@davemloft.net; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net 2/3] ice: xsk: fix VSI state =
check in
> ice_xsk_wakeup()
>=20
> ICE_DOWN is dedicated for pf->state. Check for ICE_VSI_DOWN being set on
> vsi->state in ice_xsk_wakeup().
>=20
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>=20

