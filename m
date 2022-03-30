Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135204ECAA5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 19:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349297AbiC3Rau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 13:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiC3Ras (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 13:30:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39DA316;
        Wed, 30 Mar 2022 10:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648661342; x=1680197342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aJZOacJmddI8NzrwdYi2cDhGbh7fF8GgDM5M84REwIQ=;
  b=QNR2q5C9V4vgBrpEXTYF0cadgkegzdYt9EsScI/GHZacjRpebPVWOjx2
   /TkDANMR1h6rSla0wfWhQ4g2H8Ou69SchlxmnbytqBS75YT6ftNOTCwJ5
   0sCRbwRordwUTJpPobq8UVIL49McLAXjo4L6tZ4Fg+nyhxotV9yTPuQqQ
   wxJytIVnhTldzhxjXFpoB3K/u5SAOkhbTsFYTlOd7JtuRpYAtkd4JMqHK
   FQsy3KfCGmRJ5aHbwpsC0vlBG2vvuVLsWu6NLpUYxoJXF1Xi8TQF2cveY
   gCYCw/WI3Mg0z2Z3bQjmySc5nXn0X2wTiU91bcMHZz8NZx5LyfpgBhjBU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="346037544"
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="346037544"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 10:28:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="521989708"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 30 Mar 2022 10:28:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 10:28:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 10:28:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 30 Mar 2022 10:28:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 30 Mar 2022 10:28:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuRFidMLESiKHAyW6K9Bm77NbmKWdDDIeZA2LeFlmrliZUaTsybh6NPgZWCKissTAN1FdO/HCGoDetiA9+CyzTZzh6Qv1iOk3WJnwvYbz7/a6HRCdCU3KOkUOI/8p5EAcLeWQwFhW6tDDTHuBXGgbJ6AuNk/+i+uWdB63CMC5X1NxPg6Dsde4x9nf1vquADMxt3eq08jlcZSb8SP9esdHJHN0w5WbIhq8C1A1Dj1or5C+P18aBkgKqWyhUIOD3xGfXrE352IwB2irqjtjhNGGbQJBOaAE/z7FlOhf/GHzcwtedZNL+xPykH5g59NRK9ctzHNDFi98U2ADBpJJ7fF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSn7UvMwyMaWLZayJLgicN2sdwYHrw0LXwynAS37rGk=;
 b=Wbjkqiah8DAZHnDwTVZp1M/FpYMBY1jLiGbA+p6Hrg0YFUXBXMg6O6wmelVAL/ovF4XXsi6T9i5yaxgVkf/TWiR8aKIcd7HFuPr5tm7hsUkT+ehvCvWkDj+UqawdXLQyVC53uB9vu3Sz1DKeDIL5yCYk4gubn34xWebrk74zdcm0OSttniOmBPK/GPn2COchzTKnfiO2jx2qKJb+R9pzo9UQ6SKjwS21ZPckmb09GEWMnhjKUO4V6SCSkLGXI6O3DLmsyMPgOPxPeZ+EhDGycJWeSz8IvaDenfDGxzMKFP9+NJl4bw/S+Q3kwYcNdA/ifnlf6//5KZThIab2Ry69GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.20; Wed, 30 Mar 2022 17:28:53 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::c445:1c7b:8914:7968]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::c445:1c7b:8914:7968%5]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 17:28:53 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next] ice: introduce common helper
 for retrieving VSI by vsi_num
Thread-Topic: [Intel-wired-lan] [PATCH intel-next] ice: introduce common
 helper for retrieving VSI by vsi_num
Thread-Index: AQHYP3VOgwOM7LgCeku9d6pJ3hP7IazYOEXw
Date:   Wed, 30 Mar 2022 17:28:53 +0000
Message-ID: <DM8PR11MB56216945A750624D043AF8EAAB1F9@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220324114907.73459-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220324114907.73459-1-maciej.fijalkowski@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ef1bd64-ce2f-49c4-7aa2-08da1272c30f
x-ms-traffictypediagnostic: SA0PR11MB4606:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SA0PR11MB46068C6162DF5AC20E47093FAB1F9@SA0PR11MB4606.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pnvalnbTWIcYmok5yih3XwtQZp3NYnDY6fLT9Ha+QwC+NE4s0vDAoxQQGVKa0fs3TiMb/FYgeYVzpjOdIrmDE4QV0e2fg60X7Wdf4ntE5kvyv5gwYUAsG08eBUjhk2IsDJB6pkSBR1Pn9xxaL+30PeEv6mmy70fWyFRBp31rw+cDFRVkkj1yUGch0jxhL1kTYzn8m7Ds19cGti7MJs5mG3yM0S69IjcFn/YK6q+P2jT9xVrFZZtpSWHc4PYvCKpG1tEjWSvh3XntvBulNfQUYeU3gym80QfvOmW5M17ribDkuY2aXXKackxqFB+DIPnpdCmhZmnQ5xNLtGPOmrhnInRBw9E4BS+/tEa4xl5W5qtBz+Sdwh0oI5OzhP/xnvOYa1+3XJhIb62ee3xquKK52lr0yGRC/bc6d4gMqhWG1xdNwjpRG5UYboZTzKlTfTFkPN4mKmJLC0PlwnzJqTVu8R6Iiw3qjmLJ/AeKC/l0sJKjipgAcuVQdBS2+czjkFNVk0btmSZGNXftF1KLGCzHPruV8due37Vv6069rkUUm/tqrgLbKtO2IUayrtSy/u4PLQ/dFD0+GV2giz8sho6YzQCwdDwgFnTUunDEXpZoIdcqMkBXuOQLjsjScZ/0LuLPQy0HBzAPFv7kz213ppJ9pKov0ZVqsTiNmliy+WxfHTo9tY7C5abSlu0lebiIxCoG9g7jy1lEESGcYhQ8yFmDjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(2906002)(52536014)(38100700002)(82960400001)(83380400001)(122000001)(8936002)(33656002)(38070700005)(66446008)(66476007)(71200400001)(107886003)(8676002)(64756008)(4326008)(26005)(186003)(110136005)(86362001)(54906003)(66556008)(66946007)(76116006)(53546011)(508600001)(55016003)(316002)(9686003)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gw1x3UKWimS1lcqYvmIQBo9Hw1hfCxUymumu8zUOT9r3g79eqhq+qOLA3xe3?=
 =?us-ascii?Q?iefGQ52wWqGLKrIB5txBGLSmndh6PJBYbfb9QeIqAqCRC0fLGHefQ33QFIEN?=
 =?us-ascii?Q?xcjCQVMYH012JZ6rbVBd9XEB4eMN9kRLtb9p+EikpglxknyoASPMkYNQxFSs?=
 =?us-ascii?Q?6+HWawVbrFUuez8z5TWfCu0R5tUmEtkPg5tcW6uVdjjnig1/aSO6ZXCH9j6E?=
 =?us-ascii?Q?a/Nzbgh15z15Thh6JXKSCIFQ24l7+FVw5C0niqWBY2iJvyjt/BKtkXX2/PgD?=
 =?us-ascii?Q?Rp9D/UPilVOxYP1Urk52usjJkB1hjVAa3mqu+9lXoSepE+rMyomB2cwGTqlN?=
 =?us-ascii?Q?jus5xqif3IG/3RBYZSzHgiAZ7epCq7IuoqQptYUIymovHXV5veqLOyK93W2c?=
 =?us-ascii?Q?q8Ftc7NRASkGTZGp5VYguHFxs7VMHu/3nUI80zGrgh+z/J7HG7CUb5impooe?=
 =?us-ascii?Q?nAADrVzYBE1Sm7QCiPmYdLIgvBHUD7qVaIz60Oqz+978IvL0uGzI8WxXZb8O?=
 =?us-ascii?Q?WqfoXBrUmnAq/rKyXCGAlS4spuC0vwk3iKSb+EqkmP2JRJsyrDQhh4apuIKz?=
 =?us-ascii?Q?mmpW14A18L9DLZo70CTuJSkysDpiKecQtvIdWJkS5363FViZh7q6fYtfaV/P?=
 =?us-ascii?Q?E122Roxk+8NpLJNONbZVabtMjQQVdflcunnouqsA37LsMK2e0nZrcoWqKRBT?=
 =?us-ascii?Q?D0Re7NljXfIywzpQERTCqOkc9K0nHRFpfDs5vIvL4OHZ9bgML1nkIkSS75WC?=
 =?us-ascii?Q?p1594m89Xd6ZDSRDoesC69X9IIGhwzWsqyhUZfXd3dmsBxjiIY09YfNojaPE?=
 =?us-ascii?Q?lR1iyeSIyruCPvA5DQNzVBbEB14d0rg3HlG+uhDd2I+2F3es2v4JcXxG5rGJ?=
 =?us-ascii?Q?8YKszBTUQNncIN5sVMPzg6vYfBCwZyUdzH74bK/DWvDKzq2BPzas7Zc3gKnM?=
 =?us-ascii?Q?o7dEPEvyd1guyxjRd36VeKbSkbyVRgrdq7WsNdIaK2IXoxrh9630+2/Z2pkO?=
 =?us-ascii?Q?J0tGdygmzGtKM3kFUbHTXLXAoSeKlx5s1U9JXCPZKzdnOYIk6fbY8J69zHZm?=
 =?us-ascii?Q?i3inJlvh9GTgyJ6WX+07AOMxGCZjbB7eHbrjrfdAZfBcQwjMWgPKf6AIG9Oo?=
 =?us-ascii?Q?STl+1kgmY/4lgwF4NOgpTFVcM803G4iT7B26jYSv+BSAAv5NmbJztAKW75Ez?=
 =?us-ascii?Q?JP3ai377h8B+Ihq0y607ao1CabTdRNJFT1eBguj3yYnrL5BwD/C3O1bHSGUE?=
 =?us-ascii?Q?t7hGWx4/UtixUNKPnslGQ4yxgqH7Jm+4aUliqsKfQ61NEVzmiim9r7ksk1n3?=
 =?us-ascii?Q?oQM4edi3GHAks7nmGPcO8lEjD5NmhsmF6fT6Ibgz7JVld8YZsdvMKcJavnUf?=
 =?us-ascii?Q?42FFFCVk/PJYlCeiyHk2u06uJVApnQLpevF/I26wEHf27oexLmiEWdG2UNVY?=
 =?us-ascii?Q?NH9alFFedeIhs8JguqWE92KuxDCcZ4rqWONIvGgU2v8eIkAxB9uTAAJihnrh?=
 =?us-ascii?Q?Qd3dksrfB4KdpDmrFtWep101F+Zz4ASv6xWWvVzOJ1Fp3wMx6LqF4kmQ3sRW?=
 =?us-ascii?Q?iTNNm8fWidMI0e79n1XVkZqAFovn2uu2z9w3WbGZjLOoGJL8Cz2cj05tbQLq?=
 =?us-ascii?Q?5gKzFokr8y2MPUPbf9qsB+tLwW5mKhZO3qTWnQzp+NpmKcrPLuqsSvZ6iazB?=
 =?us-ascii?Q?p/nDlw2aK1qVR+ZEAo7z+j4FXh5KJlJ0ld16nXSaZcvk7pX/NtR9G3lenzIT?=
 =?us-ascii?Q?Q09pfUDwXtvMe1ZLADaX/Qs88epR80E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef1bd64-ce2f-49c4-7aa2-08da1272c30f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 17:28:53.3396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +82ZetUKtiq1MqiB6NqnNx9qzUjK1ZY11o+BfozKMMGZml73vOY6in3Vj34J42q7x5zQELly5avkh1wvMhUDVKdHyd5wblPa2T0xFfquGf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Maciej Fijalkowski
> Sent: Thursday, March 24, 2022 12:49 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; kuba@kernel.org; bpf@vger.kernel.org;
> pabeni@redhat.com; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-next] ice: introduce common helpe=
r
> for retrieving VSI by vsi_num
>=20
> Both ice_idc.c and ice_virtchnl.c carry their own implementation of a hel=
per
> function that is looking for a given VSI based on provided vsi_num. Their
> functionality is the same, so let's introduce the common function in ice.=
h that
> both of the mentioned sites will use.
>=20
> This is a strictly cleanup thing, no functionality is changed.
>=20
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h          | 15 +++++++++++++
>  drivers/net/ethernet/intel/ice/ice_idc.c      | 15 -------------
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 22 ++-----------------
>  3 files changed, 17 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index e9aa1fb43c3a..a541446b96e8 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
