Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2E414FE0
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbhIVS3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:29:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:49578 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhIVS3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:29:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="223313433"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="223313433"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 11:28:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="474790543"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2021 11:28:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 11:28:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 11:28:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 11:28:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 11:28:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+0R8M/UOco9ayRY0k3C1gwaxiV2Oyad/VV4eXSUPAgIqGoNhgw8P4MGn9Nije96fBdtCebY+7cPsZr/OZ1CI9fT1fnSrquTAxwKTGYRu6cX0kMwwBJjsRilVUkEDQiJ+aPic8jkuueODqP6hKOHtmjrPTZAZBSdOUBF7Buic9nA40pUfz9FEsVIQBLaQD4H2cBKUCVJtxJrILqNZf6Ez8Jy/Gczhp2U85jfvqs3yQ4ERIX2PGBFrqA/0xCpOXMz56mZ5SBfnnhUr5UJKsqgtHb0aEk3aSqR0Tfi8clMLC0P85hIjd/ia+FFg/pUHneOytXqrxKD6XPJLZjl80ybUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mYLtdSUJ1GZ+Jl1zyUY4uyfc683e4sa6LaAFaK0fUto=;
 b=ZeIjN+BAm7vj6KIOJKIrkAw+YkpeMXM1OA6EVye4dbUrBvTx4y5CACkSoeOLcLHgyx4ntcXcXumvA5J3cKNYMIHWp4aPsH6ybDhBQ1Cc1b+yyzVvUvukWOgS9Er2Jo3OVwolk2KmKcWspH9u0tOwSV6S99llmyzA8sRiru/bioUOtN5qHzvludavl3d++6RLSXxm+ELGkLFB4fkaDUfVazAy2f94oMguPzjDH64lhs5Mb3U03aaErNbBM+HVSEa0pVBzwCn3Go4NDb2nVqfgyRzyvHMflUlaAMDuLpmFvHfgaO+bsevK5uOS1VFeRFNCKbxtzLTvDl7rhOEPiPKN4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYLtdSUJ1GZ+Jl1zyUY4uyfc683e4sa6LaAFaK0fUto=;
 b=OYbNwh3jUHFCzN4GbWzR/st5g3SbBINV3MUujpYiSAmTns8afkWkTnJnyULiNXd9xW/kZl2UPe6etAxdbRDdTXfGsRjjAWYgLb2b16rHFIPilR9LBEoW+A79QfEVnxUdhxGh99A2f4D0ETWdwdTOsydkZo3+wAuiHwmp2wCexQY=
Received: from BL0PR11MB3363.namprd11.prod.outlook.com (2603:10b6:208:6f::20)
 by BL3PR11MB5699.namprd11.prod.outlook.com (2603:10b6:208:33e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 18:28:07 +0000
Received: from BL0PR11MB3363.namprd11.prod.outlook.com
 ([fe80::b838:ffe:36cb:d8d9]) by BL0PR11MB3363.namprd11.prod.outlook.com
 ([fe80::b838:ffe:36cb:d8d9%2]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 18:28:07 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
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
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 3/9] ice: split ice_ring
 onto Tx/Rx separate structs
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 3/9] ice: split ice_ring
 onto Tx/Rx separate structs
Thread-Index: AQHXlPP3OoCR58yIm0urmzVSZff/PauwlOQQ
Date:   Wed, 22 Sep 2021 18:28:07 +0000
Message-ID: <BL0PR11MB336312F04BF37B31B133B8DBFCA29@BL0PR11MB3363.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-4-maciej.fijalkowski@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d73c5f7-6c62-48d6-dae3-08d97df6b953
x-ms-traffictypediagnostic: BL3PR11MB5699:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL3PR11MB5699FBB5C653494316F59091FCA29@BL3PR11MB5699.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g2WPmcZXzywcbIDSMdKMnsxg/QUg2IP3fHHzJU/wOl2luheUsryNjRgbEcDKQPde5+82/gsnBI3uMobWcfQ70q5bh6ty/RTvLemw/u9AXRUp3ktsOmrGs5lfujUedRauaFjgvt9XmIRyf1c4wYmuZpN7J3mRluP/yziwtk/rgrdcPeJ/PaU7zV+JYp3U/zaYlieyfnTI0U/VaV8TVr9CHvddjZUROr9TBg3PAmmp875lVyG2Evhexs86cRNkE4yyVh6o9XNYUmVe67ASIC+OJP02Qsz89GWHVgpBQ93VdIQNLY5dkAOtloTnJf45Ga20+iVYQexHubDtQTE1Sm6Y9gjcawyO2+1eOnyHMblutMyPgB9bRhyJA2a9GPRhamWWdWn7CDdMTdOibsNd8eTWZN6eYMSWJTqdrRxtuuCs97znuIWHJpouk1c/Uod5xnDLEyf/MkDmqzAXrCWCSey8iLFykVJswcJgjs6x9YIbBzrhuCj0r/aNcQAol1+W29wBbDgM+DpSYy+TfBe1JyioqdxaeLDOaqSe2Iu8Hcruu7vHQ9YDCk91Es9AjAadchGTqVDJvXni6/KCFg1tULkqlk70hMu0I/M73K/zuj7eEgpehgpzRnv3V1nGzJ1rtfkaiyyozNQ5gNWu3GD9zkLfOUMlfjjX+Ks4WgZX9hvsvuHtcrJErfNMScLMuJBbA12g8PQs5xSY/JORbYtbV1XJHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3363.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(38070700005)(8676002)(33656002)(66446008)(66946007)(26005)(53546011)(5660300002)(6506007)(186003)(54906003)(122000001)(110136005)(86362001)(9686003)(2906002)(7696005)(83380400001)(4326008)(66476007)(76116006)(71200400001)(508600001)(8936002)(52536014)(38100700002)(66556008)(107886003)(64756008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h99kZUl5dBi066AJXwy2H0BpaOPR3A8iH8XP0N6t67juRlq7N8yDNYJIysuY?=
 =?us-ascii?Q?XNbPVJ/V6NMFz252GfrpB9KFeDWvPzq4bg+aaKC82X7xtQ8u8Ep/bB+KMm0o?=
 =?us-ascii?Q?470TQ5h4X6UVrBiaH3mbiKX13vYg4HIRfsex0XHf5Emqi2x3oIc8Kk/d6vQj?=
 =?us-ascii?Q?0h4wMfhSTjGcdxlwr5qbr+sQdi9CTUhdcLBfpWQaUh8S2Qb8GlyKTo/RskEQ?=
 =?us-ascii?Q?woekjNZWlVjcWxU4i4FXrtLA1KpbY6QbzHO5PENm1j/AUIWVzWeb6E9Qnj0v?=
 =?us-ascii?Q?gRt59vPKtNktcuAvy0iczvKxaufuM5uKToPSJIjPkUKWLefdIZ6HGCEF3VqV?=
 =?us-ascii?Q?0TzM0ctyrKT+JMb4vuHTGs6YjZWu4y3ta52Ffx1TCQ7W76obKcHRzJSZYhlF?=
 =?us-ascii?Q?7n5KF4woXsnkbrQhSRpKMYgzKwe/7emeX+BHY9+y9E3x7oWR7xV27Kx6lrSb?=
 =?us-ascii?Q?Y53GCujQILNV1dvlHOlyb1TYEzgTelhmCSggfD0hcVEe138Esn02VuanDM11?=
 =?us-ascii?Q?Wau83EztTgkSFjHkP8IvFOUyhHPOclacOeA+AWMtJ/gbofAENDYg+BZy11r3?=
 =?us-ascii?Q?8dt0pMFjt2KoLixGPbQHf6jEG+pPmxMIXtl/rtZ7Ks6/69S5rpzEnYCHSOOk?=
 =?us-ascii?Q?S0GE8E8GmUL24bBjZWpyJyF228tXIA5cJxHb3Kb86sL6MFZxg2RpCpx6msLN?=
 =?us-ascii?Q?A0i4USx7mBFlYjMs2rp74iiZStWhzhsXzFXqH9w+2hX5SDMQQbG/PrPx3v5h?=
 =?us-ascii?Q?yIuL+t8pncJcDCaiXqRmirpHKqBW1letGVWuo4QBqecvSzeNKOOtzpBvQsaJ?=
 =?us-ascii?Q?VtpWZc6VdnhViPaWcfNc7BiUqY9/F4qLQ4drOxVcjvwddK+4yZlunbF0Or8x?=
 =?us-ascii?Q?1keE3URCWkYiFGHsKBk9Mk9hUb5rCicRhS1sZJDAfiwXeLZ0mJoSxxdlrbH/?=
 =?us-ascii?Q?NmpUEFT5YVynk9G8qa1rpOV4tBCwlzPQ+KF/hDJ1FpGz3m2En1ZzGXPkye7g?=
 =?us-ascii?Q?0ZS7jlwXVzYSTu7/SKISBFUZNK0SdHVqP8fOmtJosARYG/JpvNtIWl25Kti8?=
 =?us-ascii?Q?2Lde4v0IVoTH3uxRboiXMLNdnS67le+Jveh0SeJS3tdrxCHZ+jNHzYrWBW8k?=
 =?us-ascii?Q?Ivjh03qL16CIAPZ0S4zaIJ/X2hX0h17vYuFvGEX/wtm/+0eRf3fu+MrREZfN?=
 =?us-ascii?Q?l8DQUZTeBa9/c1jdbUMFdgSh9Ft6Xkroth+3cOS/3veZm4FLMwTHptnJLwzN?=
 =?us-ascii?Q?OUy7HgxyMnPHqsQEW0dSejHtc8lPHcG96lF5caFXo4RW+sOlEgR/JXlBGhQz?=
 =?us-ascii?Q?vj+cB1tMUoAyfblOubwZZoUf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3363.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d73c5f7-6c62-48d6-dae3-08d97df6b953
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 18:28:07.3213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+SUugsnPXqVu0cx7A0ho831Ek2JP/jFa3hzt6zWL+ZCBoR9zOlAR9S3SiTG7WL3X6yUpD/hrUlqzGWNaGyjCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5699
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 3/9] ice: split ice_ring =
onto
> Tx/Rx separate structs
>=20
> While it was convenient to have a generic ring structure that served
> both Tx and Rx sides, next commits are going to introduce several
> Tx-specific fields, so in order to avoid hurting the Rx side, let's
> pull out the Tx ring onto new ice_tx_ring and ice_rx_ring structs.
>=20
> Rx ring could be handled by the old ice_ring which would reduce the code
> churn within this patch, but this would make things asymmetric.
>=20
> Make the union out of the ring container within ice_q_vector so that it
> is possible to iterate over newly introduced ice_tx_ring.
>=20
> Remove the @size as it's only accessed from control path and it can be
> calculated pretty easily.
>=20
> Change definitions of ice_update_ring_stats and
> ice_fetch_u64_stats_per_ring so that they are ring agnostic and can be
> used for both Rx and Tx rings.
>=20
> Sizes of Rx and Tx ring structs are 256 and 192 bytes, respectively. In
> Rx ring xdp_rxq_info occupies its own cacheline, so it's the major
> difference now.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h          |  33 +++--
>  drivers/net/ethernet/intel/ice/ice_base.c     |  57 ++++----
>  drivers/net/ethernet/intel/ice/ice_base.h     |   8 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   5 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
>  drivers/net/ethernet/intel/ice/ice_eswitch.c  |  35 ++---
>  drivers/net/ethernet/intel/ice/ice_eswitch.h  |   4 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  49 ++++---
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  64 +++++----
>  drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |  69 +++++----
>  drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
>  drivers/net/ethernet/intel/ice/ice_ptp.h      |   4 +-
>  drivers/net/ethernet/intel/ice/ice_trace.h    |  28 ++--
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 131 ++++++++++--------
>  drivers/net/ethernet/intel/ice/ice_txrx.h     | 114 +++++++++------
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  18 +--
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
>  .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      |  49 ++++---
>  drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +--
>  21 files changed, 397 insertions(+), 325 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
