Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B27E3FFAAD
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347476AbhICGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:52:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:62342 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347087AbhICGvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:51:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="206467390"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="206467390"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 23:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="429518849"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 02 Sep 2021 23:50:46 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:50:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 23:50:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 23:50:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlvVt1avvdKpSVUnToFlymGy3ivyBpzvoMFcE165wesCHGBaNSUYVFviNh71xB6lzaLv+XF1F13yY9CGQ45ocKmuHZq3y7fdFG7Y0cZl4574Nu00kuJKojyvXrPFO9brzwGnaEAUQMo0X6B8sHneBlJDtcgjyeQcOohlLWdYuwn65QxPD1oCIqo8IIh1ffbLcibL2RegUaYKTDm+pzXX4XNkownhE1Z8cXnADA2i1H5h7T4nuMJRwPf72JDEFWZ8lxA48if9VtWi1rxY/zi4nZW1krq3j93Y/Q25ajOjvJn3zLYd3RwZZoDohhN0FBi4BHNiWUi9+FPk73QqdHjD7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rHxM3/+uOFcDV0kfndYp4M9VogF+zJ1CXHSH7OI/CPM=;
 b=DCiZlirT004BWaY2G4Z7wYevODM6aqxl3pNACSccysjz+EoTzA4Q1lpNowAwGJq+cQci4y2qx8c0kbNHZoOcYu+Vc8R4J1eErvpLT4If/XEirV3sF7G1XNffIbF0gvSKy2XW8Gs6uLdnH6YVoZr/tCZVAywZWYRnxN9+CiRhkY2v1NgPgdVA1YsWFzat2+z5IKydp1t8Tzpd38vN6f1TljMy5jzv9Gq2ihOH1TMMoaPPYLIVQk6SgC9HDju3RLvd/TTc3Q49Lce9r12KcDjfgqH2jgVo/BUwX0Tg6XVg5o8asXjP5k6q5FnvBkoYss4FwgOb/m9rIut+EGWpK5Z5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHxM3/+uOFcDV0kfndYp4M9VogF+zJ1CXHSH7OI/CPM=;
 b=EYRa/CoVqsxaTecYFvRaxPtllnIefzlAEl8ZhkN2Xezic0cy5fJQXFyCIG7hunu6IHqu8proj5trr4s4+wHLR9nmhjArkhBREiSfGTThFuOXc2X5qHfa8L0CnOa/SCg0NGEo6z9jlC7xpeW5ePbvPl2j7WcXqCnuOZRRZ2RcQHA=
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by PH0PR11MB4856.namprd11.prod.outlook.com (2603:10b6:510:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Fri, 3 Sep
 2021 06:50:43 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885%3]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:50:43 +0000
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
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 8/9] ice: introduce XDP_TX
 fallback path
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 8/9] ice: introduce
 XDP_TX fallback path
Thread-Index: AQHXlPQGtuYdkIA80k2U7h9Bux5w2quR9f9w
Date:   Fri, 3 Sep 2021 06:50:43 +0000
Message-ID: <PH0PR11MB51444F66A6FB34EA3D91B844E2CF9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-9-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-9-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: 2fce6c49-ab37-4f1c-c3c9-08d96ea726c4
x-ms-traffictypediagnostic: PH0PR11MB4856:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4856330B27FBBFF6D8653B7AE2CF9@PH0PR11MB4856.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: za/Y38IPZwJieGjdQCIa2D4NQL/67IFVHwc1OhzuW5QlFzqzEe8pr+WJrJc5lo1jsul2vlSpEu/aiLFP9lYG3pcI4NOKg4fV6Pl3dSP4JcOqkzpyDszQejx8IDqTsoHgdKIsfOv1f6vwaldKL6GZztZLW9a5ZfAS+ANB3g9wU3F4V5TFmf/+5EOo1d2Giuhe4DUO0WyeTymrWk6zTbQVrod7Pn8H8+y/BdIz9q6p2OLW0cS2KfCdM2iN9QQOGCg+EtntK/fuHbqF+udYTtHt05bofxx1hZshxmFBfFWxxmzZ7Ysby9B7N86ArrelAgD2Syz0fx35RZKpfi9UDZWKk/AnFDPHfBLKHsA9ay9nbnpUpuFFPmi/HJw9/zcNJ5z67cQqviN0VivbAhl/IdNgIImRCnoItgdhqhuiuuJZ3tVOJjw4m9/l+1UQ19llfH83q04HifWneHL65JKgQoWK8FJvSQKKWhbH5sWNZ0qt/0EJG68RXFFYmD32nsbVROosOIkgoxxMyxM6XB+/XhApYLfU0XuykC2g1XWI5PYugxEwnbQXx8c7jGytbKJ5zAiwhw7AhSlM6LzxGc2Si/uxNznNfqrIgMLnwci1T4GM+YO2frVntF+mXsPaOXMTPf6usOHio7ZopaAEfaAYz0DF3b8RQdABa6mqCXcrYUV3YwA5YoF4aHLqZ+eYDGt9FQshODMlFHxnyXLIoamiLlxmSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(7696005)(8676002)(83380400001)(86362001)(66556008)(66476007)(122000001)(66446008)(64756008)(66946007)(33656002)(38070700005)(4326008)(38100700002)(54906003)(6506007)(53546011)(186003)(5660300002)(9686003)(478600001)(2906002)(8936002)(71200400001)(52536014)(110136005)(55016002)(76116006)(26005)(107886003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LIJohm/CTR/aPaaHmySUoeQMWrrhSpfjEb4jpvcv++WwOJFFDRhlEtzjEpfp?=
 =?us-ascii?Q?IwhgEdM2FJFYAxdC8wZvj41gzZFQ++bK7osP1KagCsq6oG4+gWs87ijTZwPk?=
 =?us-ascii?Q?0ewKWpqU5rc6bUdZQ6toQdbH3wHiRhwM1B2z1CM4HG4YN4eBPUcoh/VSDylA?=
 =?us-ascii?Q?XwyUYL1NjzLMFldhjtEx3RRL66G8omjkgG5JMYHD5kgEnSLwIY+TqbR9Y1je?=
 =?us-ascii?Q?SHRUY4EasRKJahmHuMTCuuiBhX4CBQOx9BProa9EvqDKjLlPq4m4S3GC9++O?=
 =?us-ascii?Q?IPqfoPnNRFYtzC3IvToAKOESEVMz4rVYAwZhw3XOlcL9HRcDb7aXuxy5OYM1?=
 =?us-ascii?Q?hfDDy7dHvfxsd3q/VggUzKo2agE58flzlzHlG0n5mlJq5VpuPtfmt/XsapjX?=
 =?us-ascii?Q?bDp0+jNv8ATk7UQVMNsSRMbmAL1kjzsBehyQIXKY3RcdRplck0GLSkMwpKXw?=
 =?us-ascii?Q?qwowr+XfiPG7/VltIHXk/1nYjGuPbbWZJUfsfpKvt9n6fT7AyPhlPv7tHWT5?=
 =?us-ascii?Q?Dzt5ajQZnjkEb2QdmHnRl4l1my8TCCAI9G8QHz3kjgWPuf6oWpgtf3HnkYV9?=
 =?us-ascii?Q?8zqOwMf7IHylR6H++ymfxqezp9b728QL/xw2uPZJBH5/XF1IiwJ/TecjjQYt?=
 =?us-ascii?Q?DHqLphm3qB2EC892xLDGLLqhbNV9Nn47lISWFyCGwRb9yIerpqitfBv1NPwe?=
 =?us-ascii?Q?Aw6KG66bw2xe093YthKFCFS+zs6WoXjNQVJy3m+iJFjf1MSolPTxr4GRhuhW?=
 =?us-ascii?Q?+j8d2XDfSt9JNo6GAapEgXKnAbNPSTAfC3uME1CS3J8x29wSwZcJE3Of0I2l?=
 =?us-ascii?Q?uQkf7RzOOvbB8Y3UVeS1M0p725piGB2Gf2wxIVqKnE0+9eT50HJHqvyVaUbS?=
 =?us-ascii?Q?cPIQhEFLS2DzfJQGcrRsz/gIKkHCdymovX1KMtb8I9Pn1Lea74ScqgBn1Vgl?=
 =?us-ascii?Q?/R2toAwNYxxOpGVEvsqUlPoeAirKA3aTaLyx9gD30oCkb6tEqXzqjsMR+oeP?=
 =?us-ascii?Q?8uebzm2uYMBkRRJ1iBP+iwQhZpsqBfdkxxF2t3eztFEvMA3Admx/F/2xlAsI?=
 =?us-ascii?Q?+9YnuSUjuoQMh082k8lAMDOgm3wY61zugtrV2AEoZhMDYMYZriPb0yazVlxR?=
 =?us-ascii?Q?Ms8ILDJ0XLe9eXNvpHuOPqS15OY0ANkZbrZoitroPFwL6AMvV6F6w8brgTmU?=
 =?us-ascii?Q?UDGCl1esEi+eBGMArTARZjwY+357zvpZ5EAlkCaYHdzCQ2grbwD14edpUUWR?=
 =?us-ascii?Q?IicNrjB+G1In6+ySJsieTcvBX0nlqCsHpBzS+kGYf6raDIuym56WJAOdzLbo?=
 =?us-ascii?Q?HsZv2AHhvE6kdSVJ0l2tDyr1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fce6c49-ab37-4f1c-c3c9-08d96ea726c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:50:43.7613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZO51BbeyudPO8mznOaHQ0VJdEixXLaHG387Qfl/cFbJA7qwMu0F5W4/F6E0XjMthMTJeH7Bp0ObeioI/+eTfi/MQSseuukr4WePrCZG+gYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4856
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org; kuba@kernel.or=
g;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 8/9] ice: introduce XDP_T=
X fallback
> path
>=20
> Under rare circumstances there might be a situation where a requirement o=
f having
> XDP Tx queue per CPU could not be fulfilled and some of the Tx resources =
have
> to be shared between CPUs. This yields a need for placing accesses to xdp=
_ring
> inside a critical section protected by spinlock.
> These accesses happen to be in the hot path, so let's introduce the stati=
c branch
> that will be triggered from the control plane when driver could not provi=
de Tx queue
> dedicated for XDP on each CPU.
>=20
> Currently, the design that has been picked is to allow any number of XDP =
Tx
> queues that is at least half of a count of CPUs that platform has.
> For lower number driver will bail out with a response to user that there =
were not
> enough Tx resources that would allow configuring XDP. The sharing of ring=
s is
> signalled via static branch enablement which in turn indicates that lock =
for xdp_ring
> accesses needs to be taken in hot path.
>=20
> Approach based on static branch has no impact on performance of a non-fal=
lback
> path. One thing that is needed to be mentioned is a fact that the static =
branch will
> act as a global driver switch, meaning that if one PF got out of Tx resou=
rces, then
> other PFs that ice driver is servicing will suffer. However, given the fa=
ct that HW
> that ice driver is handling has 1024 Tx queues per each PF, this is curre=
ntly an
> unlikely scenario.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h          |  3 ++
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     | 53 ++++++++++++++++---
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 16 +++++-
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  7 ++-
>  6 files changed, 75 insertions(+), 9 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
