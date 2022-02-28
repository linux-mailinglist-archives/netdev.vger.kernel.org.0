Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA4F4C7048
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbiB1PIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiB1PIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:08:34 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2794527E4;
        Mon, 28 Feb 2022 07:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646060874; x=1677596874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Muq4KfTgw6fd7qyT0x2OpJl8xwzcyJizyqXL/6UNB3s=;
  b=CDpQKKbBZEHpug9ap+eZkgmY9JGOL/Mhhp/LFXbKt9usX070ZeZX3Um8
   fvBy9zTNiAxpwdFhNjGiaRKl+Y5AkNnP1SNtCXOzbwOk8+ApaKfEF5HNY
   Dgira8y7OH1Dys2Abn66AfZ0pvcwX7XcvPqO2/YaURrvKEelIoAq5CNIe
   6mGWNdSobxufyHZAg3QqgETXi8O9Hi4PVf8Z9DPzE3z0DKcEAVpVUtigw
   dStH/jTOs6RNwSx7NLn9opvMUrFb1TwG7kto+zXffUa2WAXRkDPdK0HJC
   r22TdjIneMKqs5+IVjoravf+QCj2t4/ZW4f2CtUPpuDjpXCY6K0jx7fC9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="313619041"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="313619041"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 07:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="507444520"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 28 Feb 2022 07:07:36 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 07:07:36 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 07:07:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 28 Feb 2022 07:07:35 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 28 Feb 2022 07:07:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nB0NW4BTJkpG3LlAsfZuJH85ZhMqWC8cQ6ZmTQ0+Zannb91jVzxDVVtSErj/Oo8pbzj5uIIZmgm2Z1BisXUJZtOysRcEYTuH7EvEBAccHwLvXxvhN1cpL/vEp+Tdwky/6MEOXHulSijBpJexWhGkS5iVP+T/5kQKHoJkJmSmxXRflF4oLuJbKnU5uNCVLB/hg1j1ycF8GcgMAlZEnSf6vE1xRPlII+SfxBuWkKefkOhy6rw8ufljw/b5hM2ZI3ynA+Mc0aPDP71u1P1fll2VRl2S0LA5DBo3pdxduYHwTCxHEK5M2MOwOEPQeCMESibzipQBjjq/CRhBraqa95+MzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOg8eeFtgYRsULh/YlzZC8U+MF8T8IzhVjeCqJwh2gs=;
 b=ZfvYbU071flrZcuaE8qJzSoThHahdxflTzvvRvL7Xqum3f3rGkTvfLkEm4XAGk71TcZu6ctvdIxlw7ZWz5tBBZIXrJiVodhuSOMLm+5I5ylzPXfvv+50aU1ceEkCGrcO/h4s651WSmnih4jH38l/SMCMHb5n3vNkCfWoILV9mmkOHzWPP6aEjHjQXcHzI4BbIXF+FSZL8+y9isRjY5SBmEd48EuKaxwP2+6zLpNDcFAGdlEPOQj/V/3erJFZkuvXDH2l/LIyUY2bWI/eg9lIxqVSqpj7Qcfyc4M4acdXim6CHlNIVd9qtcNELGgQIKjZ83snBhWE7IBVTFCu5gEI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 (2603:10b6:910:24::18) by DM5PR11MB0044.namprd11.prod.outlook.com
 (2603:10b6:4:64::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 15:07:33 +0000
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::e192:cb9:660a:8267]) by CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::e192:cb9:660a:8267%5]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 15:07:33 +0000
From:   "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] ice: Don't use GFP_KERNEL in atomic context
Thread-Topic: [PATCH] ice: Don't use GFP_KERNEL in atomic context
Thread-Index: AQHYCwlkw2uQqSZEEkOvBqyE3XsZ3KypRZBQ
Date:   Mon, 28 Feb 2022 15:07:33 +0000
Message-ID: <CY4PR1101MB2101D3A3815052A2BD52D600EE019@CY4PR1101MB2101.namprd11.prod.outlook.com>
References: <40c94af2f9140794351593047abc95ca65e4e576.1642358759.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <40c94af2f9140794351593047abc95ca65e4e576.1642358759.git.christophe.jaillet@wanadoo.fr>
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
x-ms-office365-filtering-correlation-id: 6676cde4-1d72-4bca-3335-08d9facc0c36
x-ms-traffictypediagnostic: DM5PR11MB0044:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR11MB0044ECE3F0487AE41DAB5C51EE019@DM5PR11MB0044.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zlZY4DDxZhU43bTdoJmWFG6iG77haRDUacaoftuE4BrJHBi2hFqImNPDlEsja2MGtht9qMbU+zqlDlCM2grpO6KyqCe5Ct06dAXOD6pUCb6qzxraGAZ1S/6THeeknPk0wAhimpNHsd6S/05lXRl++ZZQkEhpM0OhJGAqsC+rc7Zs2n1kZQrsVcYS8Nh1Vkjty/dU9bd3aEGqY13mMPsQMjTzcm0vi46MBymjSEvtUfh3NmBuSlBun8HUwb4rVbLpbqshW9Jx/CvfpCJtvS4aA7aj8Y84fUdmZztNlauvOgCol0x+YMoX+Peyw1WYU6WNpXjwYKsa0M/Lswro01ahjpcb6E5dJlqTrwOmdrPnDxSNtAJraQOq3OxR6N1oeBotXk7mxPh2kd//cIJtECMb6L+4FMg8iotE6P4rd4vrDtKd8Wralatm3tTylKGdRtl4Jg5Ky1P88/tLv81EwvQ+v5klo18H/8Q1/5XUevcExqW6noyMysLM9qlPwXLgxeTizPNxK9wwZn1C1flRvan+Dl91q8qiMSQocJQMHXw8tpfE0T+iZsJGEMEvyXwyk/RKK2BNT1aV9D9RuqWbSpthUguHdPVTNJd0Vz/MncWBgYbnwP83IntRBCiYQjw4X6d8CrlKUvzA8L3OhhOL1wNiRJGEiNARcLgCCwkTmZZW6SYQhTZJSDhagJDCO53JVUJVEVRQMW0tWyRvB6UfmZMmkXR5FGhKI08bn/grudkWc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2101.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(71200400001)(86362001)(33656002)(316002)(53546011)(9686003)(7696005)(6506007)(6636002)(26005)(186003)(110136005)(54906003)(83380400001)(122000001)(66556008)(38100700002)(4326008)(66446008)(66476007)(64756008)(8676002)(2906002)(921005)(508600001)(52536014)(82960400001)(66946007)(76116006)(5660300002)(38070700005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IhhZQMbwf2tJCh/WYaUxEWsLO4wVlrhbS+FLPrNgZcEjLQJq7f5ozQpu60QL?=
 =?us-ascii?Q?ZO7wVj7ElK+J+fDS5a7+9rTKG+YgCYxeBMBCu8DmOppOTEmQNrXLZJPrd2WM?=
 =?us-ascii?Q?Xx0Mvinltr5oZsBTMt0o9/enLyWCokhiKY4t5l5vNi22MFE95CO0gJQpPLkD?=
 =?us-ascii?Q?nCQhqWPhuItsXWGa7v5y1sqrFvHbT1c59wKQmgGQ6to1NYtKG+QKsvElwjdR?=
 =?us-ascii?Q?a4v8wQpmCNWlCxXkuStyKcVqPW6T9gQKf7pISKcARs9u0Rdb4cDxQPEjunEn?=
 =?us-ascii?Q?5wN2C0N9YiEzjUTLjRJ0pPkw7aGGe4fKkYHCRWTEltpAimRwRY9Y1FrhIUam?=
 =?us-ascii?Q?WR7SAzIYr/hm3Jhoiu5VMiUJv58Bv9UD8QhtzcFQPz7Sd76ukXebMkT6eYOO?=
 =?us-ascii?Q?bsVPAFesW9M4323WauBPtci1qKiDIIHyaD2myX4WHThJvaA2LLFEdJPHr3sR?=
 =?us-ascii?Q?/OIOB8HdMCzQjOZdd3KDGaimrSO65CV3Aw9PgaO2/4VNHPXV2QXg19v7Nowl?=
 =?us-ascii?Q?Ej8jgSIeYWPEh8potOnRcSlnPyn8ZIaNWLKqw72tUjwqofoG0zEmSSHf7Y1o?=
 =?us-ascii?Q?NFfi5Dy9LLiNmLwZin6T9K5WenXZv1wknEutDicCYqfxPHR0lYeFsQ4BHOwK?=
 =?us-ascii?Q?jIC+sQ/myqL4LeAWBt5yuvW2Jo8deJwKxFr2HPO16opI+sM0esuhzZ0Vl7/N?=
 =?us-ascii?Q?PvNoKr3xgeuxIqQYIZ94qsAOf6gPw6HncXRvWgIRI7W/MpkNojSIvGrkh3I/?=
 =?us-ascii?Q?8obLW/X0gbyb0GKXnfxAvlIlopKo/Sm8t1srbydZF9X0vIYTGF5eQ4YciHU4?=
 =?us-ascii?Q?J+Obe3l4ACpk8Vs1bncoA8aEKgDBEiOKzgsX23MjVwzdK9pIo4K4v6ciItka?=
 =?us-ascii?Q?VfgizgaIGb8hnoj3eHJ8DttI4PEgN7L3HfEFlc9BIPrkKY6Jbns6YSuDngc1?=
 =?us-ascii?Q?GHeZuTLUMnTiAViF7xqUK/IhZDcPERhVXyDz/gS/XRGcFxJID/ZRFovRupTM?=
 =?us-ascii?Q?jldOH/ICdH/NLST6n4YhazZa7PVYmd/GQPG8FHOwW4dJBfq0GZ0Ew0UpuhCE?=
 =?us-ascii?Q?yiunc7rCI5oPbi/Z2iWAaOf6dGu5dfj6OFFaAaStwzy7y0Qs2Mjwuwt9AHNN?=
 =?us-ascii?Q?uEhNDpB7bnKQ/N3kd0ZKpPcgAdJ9rVD2sXeok3dYrZKVMZK0yFrBInW4K1P4?=
 =?us-ascii?Q?vKMxOUt0s4exhG+7pxr6Fxi138sHAMlNjo+YRFLNzxeyUmbyOWYseU0r/Q1P?=
 =?us-ascii?Q?m9Anm8Cf16dO8yrUY7TJwtpQOVe+3nYbNP9UEqOG+1s0sy1J38b00/23YT8g?=
 =?us-ascii?Q?Me73NT4dvDS7zU/LxrmVmTjXhHRimmuYLGDgoED6lixPCkQFa++u1QpoZycV?=
 =?us-ascii?Q?sYLiKaxT7CTcOaSjzKk2um/XMtB6d8TB4ylGEmbUC53EBN+P5IjD8F6/08uj?=
 =?us-ascii?Q?+in3pPm2aN6jlxxiqjm+ZaK424zIK/13I3gQuqktfN5oWtbEBQkzPuGHJUte?=
 =?us-ascii?Q?8/0bMPv4lazLquNmlIy3UrkyGvhd/6iBSYcHuz8A47XRl6ZG54W6E11330p6?=
 =?us-ascii?Q?2a4V50aICbkAW+94vWR9sAFaq92sK3m5lcKYi2X0yWYV12w45nfxI6ZQnEWB?=
 =?us-ascii?Q?tJCrD3MW7Lv7nk+PICqdw0C9nM6mZ02ZhQBvacSQO3J8lAejfjxqJRukbnQ2?=
 =?us-ascii?Q?GEonEg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2101.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6676cde4-1d72-4bca-3335-08d9facc0c36
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 15:07:33.3537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bW8Zku8BENs2iWbjg6YBnesblbjtwzmTOjb7B/BNW4kg7lFXXKnDJHSuax3XXBnsb+Gb57iexaVvpyfn6He7radM26vEQ2J07VK62Y/Wc40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0044
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
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, January 16, 2022 7:46 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; Saleem, Shiraz <shiraz.saleem@intel.com>; Ert=
man,
> David M <david.m.ertman@intel.com>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Christ=
ophe
> JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org=
;
> netdev@vger.kernel.org
> Subject: [PATCH] ice: Don't use GFP_KERNEL in atomic context
>=20
> ice_misc_intr() is an irq handler. It should not sleep.
>=20
> Use GFP_ATOMIC instead of GFP_KERNEL when allocating some memory.
>=20
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I've never played a lot with irq handler. My understanding is that they s=
hould never
> sleep. So GFP_KERNEL must be avoided. So I guess that this patch is corre=
ct.
>=20
> However, I don't know if some special cases allow such allocation.
> Any feedback/pointer to a good doc/explanation is welcome :)
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
