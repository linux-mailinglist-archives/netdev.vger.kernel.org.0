Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D060A532DDD
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiEXPx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiEXPx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:53:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3389154B;
        Tue, 24 May 2022 08:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653407607; x=1684943607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/42zUjivvevhfGh3FtAc66obsjhN78DzWMNBHK9JT3o=;
  b=MOlhH0+nhiiHh/77yXU3s1jKGev4Bgj4353wqcQ9a929sFoO4AFPicrF
   Asv00WRLZ7cbSo8xeiHpeF4rc7feMKqyf0TOkJbm4c8DxIeeI7Eb+FDL2
   no6GlTyZO/5Frh319OvoonxRpWVymUvVtkAuLbieB/8zzT3HlRkXfaJ6+
   5ThzVZEraLNNJiWb/V7InkpTlA7Hiy3y5KQJvLQ0hD7KY6E6SRspTGu8q
   X4n8q1viiPkQRSIdR4U8zYnAkeTdi2orCuG4aF8tWdZoi0Iz7rPOtNKKF
   1a5TABnx8ntHglYbZlR4fNDoYQbjzUejBAjQ9lLT70RrGPX+MmmElSHkB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="334213952"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="334213952"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 08:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="629938819"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 24 May 2022 08:52:31 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 08:52:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 24 May 2022 08:52:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 24 May 2022 08:52:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWfbeyp6GIOysiARhv34nvCbvHwNftNUvzOEqD+mCxwSeZQXCtJ78k3FtPWNHIbrf5i8LE9Qfoq51IdKDNjASxi2eijfZfAtSAmcmWDSD4uKtGumWojL7/xl0jRCt2z88HyLA+lTM/Vc55R1+K2/84uuliSC8k7dcXzWEejthY2/uvlC95iKT8Tt1W33s1Ee9xWJtiJYUqm6gai9sofw9z5YnPizqwN/fXENcJaNf1l38LNVFyFbCKYJ5UdhMmsm5J89lVKEZ9Hc4KM02+GZKKCWIg0/ii6Gc8VwElyZ8yl09Mv8OT0LvmB46VwoGKEhm4Mm/6XJhMevXBLlduHTUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ho5+/djL3WjiA+mGBlJiFHpWwvCXk4BW6pxH+uFeJaY=;
 b=VsFvPm/UN0VycXMyRoCqlUqYo0aFptVhz75RwcX/MsqMB0+9rKef9jLytlcB0IzLOrMNxIAVpPm+s2BRUPoDhYvQ12GIItKh+GG7S4QOQE92zlUPK6EakpCiZdelI5hY1X5x0LO9H27u9fgxJRfYwaeO3o8E64XbsrJxgt0YMN5+fJyaY2FZhVPO3M0+TIhLtr6SRUjMg0IlzwW342LUCuzeWQ7inMwSWZRTJaxu7klXDuNrKJK5hTMev+sd7u2hZuUydsaN+FNHjpMvJAyIYv0RlMI/OIFXgvMKUyl/rgq8RjvHo/A+rQl2TxhQMkejcxDesEUT0xZ0PS7e6buQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM6PR11MB4201.namprd11.prod.outlook.com (2603:10b6:5:200::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.17; Tue, 24 May 2022 15:52:27 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::5110:69c8:5d4f:e769]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::5110:69c8:5d4f:e769%3]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 15:52:27 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Maximilian Heyne <mheyne@amazon.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3] drivers, ixgbe: export vf statistics
Thread-Topic: [PATCH net-next v3] drivers, ixgbe: export vf statistics
Thread-Index: AQHYb4ZEbUc0OtsnIEGBv94lwfGtoQ==
Date:   Tue, 24 May 2022 15:52:26 +0000
Message-ID: <DM8PR11MB562165BE16503138D1100255ABD79@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220509110340.100814-1-mheyne@amazon.de>
In-Reply-To: <20220509110340.100814-1-mheyne@amazon.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b61e79ea-a8bf-4853-6817-08da3d9d66cc
x-ms-traffictypediagnostic: DM6PR11MB4201:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4201C39CB8A34EE4CD0AA7AFABD79@DM6PR11MB4201.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D0K20M0sTNHwl4Wu9yAV1Z+KH73KS0D01imZxbN0VyAU7vAdYTHhSR3BL1WRnbIx4oMQE/ty3yeBepGxRIPEoo1ahkYt9hVHQU2CFBPDzzQyFIcm04XfH8Ao8L39YyVvsLk7UmkXDwAeh2L1s5kLbhNuEAj60l68DbFzOuDsRgrcPIkf1qVovXvpgA9UlcYRIxer3op5oIrvk7IIQ4wi8xRk/5SLT/vYYqzXOYsUX9A44/1HYSZCzokUdZTzFB4FPIhVWZzzDmbZ3zYtl9I3/g91ornJz+Xc4SXnhBI71oAdXyguZBiDi4IMyF1h4vV7QRyhjDR3t0aNJu2PZHW7/+B3WKSiK38Ug/0/l3VUwo88YszQlDN1kASr3rSFuGWG8jplezHQt+r7oloWVp1vIWiK07sCtUi074wuFiWQ/w5YIX2cwlOGlRkbZltRmk9ydYQTuF3Fb07/fs2Mr6M7K2x6Ok4rCMsdXDOezxlrR5luZEt22mJ7Vs08s3F/bAxbqdpueBMStfpBWtmT/sGV0LaVey0XYLOU1BT41PTCb/5T73Bj8bsxH69Cuk/XVY+lV9UMcwVH/ue/4Iaot13aLp/sPshVUAQDTeaJc9Ry7XCYmKWc0nY6EYWWatkjjCOAx05uTMf+UIarkBP5dEPrd4MBwzpUdtVKl++dyV7749RQOThErdJAXpic1jJTXG3rbvdmrp1I/kAQlIr5bvrhnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(316002)(66556008)(86362001)(66446008)(4326008)(8676002)(64756008)(66476007)(76116006)(186003)(83380400001)(66946007)(7696005)(508600001)(55016003)(26005)(9686003)(122000001)(38070700005)(6506007)(82960400001)(38100700002)(110136005)(33656002)(54906003)(71200400001)(5660300002)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8CkmFX7vHNU0LElQE09jHLRH/le/JoUYiCrmP2OlZqghUWImugqtFiyKBcDJ?=
 =?us-ascii?Q?G98+XRTIZJHJ72JKivfNxGvZKXH/5YmZ8Z8hqA0Jw35IQqwi5w0E0ZTryceb?=
 =?us-ascii?Q?qBZbs3pjfBqbDtnyhejnLLCHIN+iAMhhHCG8fRIjwt1MaMCbSt0MGNbE3tlc?=
 =?us-ascii?Q?5yvDuwqcb2P1iHinIEAPZ/eNKlS0WT8icwrJDytfgeB+wym7aotV8RL2cROZ?=
 =?us-ascii?Q?UC7+wslUc1x+wpJ2sdKUFp/mvLzUXva0cnTS9ENrfFZ0dyTkNCIhRfucVwwj?=
 =?us-ascii?Q?qCNkwb7acc7PSaHw7frPWE9dhEGHpcs1dUhpJ6F/l0+1tqBTYwe/LwRTELdH?=
 =?us-ascii?Q?+3LWXyb+N69teE7TpIysZ+hcE5yIR+JDUbyWJsdxSWmBeI/xWEq2WNnGHLeZ?=
 =?us-ascii?Q?3OELse72mTKMJ/Ah0fZiTXiU5g/CsYKRXZnnn1rAurOnL2OhfdLuQjHEvO6Q?=
 =?us-ascii?Q?cGlm/NxdasPi3BXDKgA34PR9XIqwhWq6FQrrSH9B260M231NHnpIr8KuY6mx?=
 =?us-ascii?Q?sekt66GL/3iMWv2oujdvfsdTDRudnYoihLp788hKN5xp6asq7GcHORdHFYvb?=
 =?us-ascii?Q?Nd/ETl4PY90Xqjyr2jPLHdOCiNmEZfqELChzbiS9+oWq6Zh3sHOBbIRLakhj?=
 =?us-ascii?Q?LPNegJwi77IMOGebPXH7/ubjAGRuIhEA2wq7LLqRJMJit4heSloH5RavH3r1?=
 =?us-ascii?Q?uRuBR4Yhj13nAUpioiNQln8AoFdxPQsHNcxfgOgYq+d8cloZoFvRTTvSlwP/?=
 =?us-ascii?Q?t5pxlqdnIyFh+CKl21zkR/6wilH456G2gPzV49MMnuj5Yg4R8hYOtz4iPFOD?=
 =?us-ascii?Q?RrlflZYG78pfcDyjdjt8yXdOd2JF2YTA6zLm1AAe6ZKE7/qSF0PpMN7PK+8D?=
 =?us-ascii?Q?2nL0esOM3h8xzDisaPauVoVZ7xTWN+3LN+LDNZFEV6dJuOqfLLP7EoIZ6Ymt?=
 =?us-ascii?Q?zzu9lHO0OsoGukOR4MFst6Ahapf8vCTWL1w7DItR+7kJdS6ddswK5s2tzMCz?=
 =?us-ascii?Q?eG25ZyUKAQ23yksTTwbP+CKpubUzjFKDdDF4I3ov8jFDHEw5DazAYbaovF5s?=
 =?us-ascii?Q?nv0xVV1LdJmlMP/9+1Rsntlub5rY9NwrGBsTOUeUdCJ7cCyMDToh+YFgP4WK?=
 =?us-ascii?Q?0EMeAo7N8YEFvkHJG012MLfqLE1eeYIn4WDhF+JfIAvCAGCX8yGvYjrnHTBq?=
 =?us-ascii?Q?JBOQZGgNrECu8MUoJbLRrvGriCsFifhuSiRmOUhKRDm0rTmLCoNRxnsQukXz?=
 =?us-ascii?Q?X3u30qa9vtQxVmA7piwiOS9ck0BUZXeQq+izXNLV1oLQgJv9rysHxjTWRrFb?=
 =?us-ascii?Q?/RwgE1V1virZcR9rMfjgddfzPUSqMZoDkKN6owxc4zkFD6MTPWCxe6avP1NX?=
 =?us-ascii?Q?SBGp7am5ZGXB3griP6MzHeCI4bb34H/KTdEpKIWzxVL+jUcNnJkMJoLXRkct?=
 =?us-ascii?Q?e7+qfgP6Zp0ru+VsUBxaEVPOF08h29SPE2YIKKm+z+8LTpMJ92qJWRECnS+h?=
 =?us-ascii?Q?i2lni+gm7w9QhJMQQZaS0DMeCGJ9iIKAMlh4PW4yGDZ/bDzdHnNCtw2zWLEq?=
 =?us-ascii?Q?lFYA3n+zLIFkVRNqrhPAFOIlUcAS3ZeUiAqb0DohtIVSsEQMlGQFXUIEX5TX?=
 =?us-ascii?Q?nUjPjb3VLa0gqHg6Wgvw5waiVTI5JyBr3nHzXw5gtbVHo6PtEDPL8KQkZZsF?=
 =?us-ascii?Q?x9VPicdDygz6yz3QWX9n4X+nsvIzK6nOi6Z/6nnz4MW5pnpSB4cCfjJWhljz?=
 =?us-ascii?Q?ntFySfBdkfmF3Y4BzvkrlPvmHz6xsIo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61e79ea-a8bf-4853-6817-08da3d9d66cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 15:52:27.0021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0WH/UqjwRuGzAyletcU5KmQo4qwoIB8JklhJooOJtkkbottcOR1jQfXfE2Jd5ChkFZFuChvy6eiZrTQQJopKwQWr5Vop8hl9VYMCeo1lkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Maximilian Heyne <mheyne@amazon.de>
> Sent: Monday, May 9, 2022 1:04 PM
> Cc: Maximilian Heyne <mheyne@amazon.de>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH net-next v3] drivers, ixgbe: export vf statistics
>=20
> This change retrieves network metrics for virtual functions from the devi=
ce
> and exports them via the iproute2 interface.
>=20
> The code for retrieving the statistics from the device is taken from the =
out-of-
> tree driver.  The feature was introduced with version 2.0.75.7, so the di=
ff
> between this version and the previous version 2.0.72.4 was used to identi=
fy
> required changes. The export via ethtool is omitted in favor of using the
> standard ndo_get_vf_stats interface.
>=20
> Per-VF statistics can now be printed, for instance, via
>=20
>   ip --statistics link show dev eth0
>=20
> Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
> ---
> v2: implemented the ndo_get_vf_stats callback
> v3: as per discussion, removed the ethtool changes
>=20
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 34 ++++++++
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 86 +++++++++++++++++++
> drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  7 ++
>  3 files changed, 127 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index 921a4d977d65..48444ab9e0b1 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
>=20

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
