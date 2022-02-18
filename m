Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25514BB130
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiBRFTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:19:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiBRFTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:19:11 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1542DD74;
        Thu, 17 Feb 2022 21:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645161535; x=1676697535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NLcrK0eID626xiEcTkgeFvpesiI/JSFTh9pSnGo5Q1U=;
  b=TUydXZWnYIu1fvbfc4LhCYn3p2qcoUAygSLMcWvrH+Dd/FKXd2TT0xqn
   fNpkhjysmq5UluEiFcvF7v++tx0Sw1omYs4C+3KIcI43Wd8keXDBs2g1g
   arn+Q74hfiOuY9EQjlU/eYMVzzozWoSRHGDUeHns1fp8rCgALMwLpMiIY
   efDzvFQkE+vSckXfpFk9JGYIbOlyDq7tDXb4ar1B2dxURT5zXXd6EEG0R
   f5htZtwVh+AOt5+xcDL5Bka4Ytib9W6LixRN8XuoOif8SrH0AQ3JKHh7z
   PULqB5Swv3PuaWW88XAuKWsNWsydwmK97tjiv9UkRTxSPrXcQKjPQWK7K
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="234585237"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="234585237"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 21:18:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="705231111"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 17 Feb 2022 21:18:54 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 21:18:54 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 21:18:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 17 Feb 2022 21:18:53 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 17 Feb 2022 21:18:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvOuCdzOkqCr+er73vsJ7e5quwTdMb8t9K09MgxHxZzP4tg/EufVvUtdc6JT7SigKYarUqcMdAmLvcxLloS6xcg/w21NbXvALd0y4oM3riGoQ0D9UVp8UQrosH2ZPbpv/RGCRVhMzEZFUV1bqowNVVOwLhJQNinwC8qnpIvPgbziZKAOeNVGNbe4VtKLWshbc8XAPvUmI+e/ahdnTbi4H8jpBhL6Sxa92s5USOLBUp8M76U3MVZu/XPipfBD6Iik6w/BbKZe05y+e6Eh1iy0IUqieT92Wa5sO3OskGTQR6SVtoPrliIIsByyT2RP8Rh12UyN3H3L1I4KyZJnvI9MIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/+7UrMZp9ZmkddzxUQYaZAyumwYIDvqewkYRLfCsWM=;
 b=WyDPAv2Y5tAeWSUVfUdUgCHdU42Gfan80MZEhj3G8+iPSbS69Dv0BSD12tcsLcp866vsDv3FD0w6vqG0R1JSslb973uI2fStUOMb07M1cw1mZLnk4NdIDoneuct6mhX4WvyMq3CFJuj+q7vCnJwTtCWv9J07l6Eh88RLVqx8YdF3hROsFamlRapfr0ZNwXN0xH8YqsjrCMPY+ShzecE9GIUAA+zy39OOmkRMd92eVaoyWAvdR6ZxqspFmFnRqYOwCCEzYuh0cZmsMVzbalcxqNCUiJZjaUgnJ0IpIpEUGi7Dx4WAcRUPIFiBjYjY2cualysxj+z1ODIh3XFF93W2GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MN2PR11MB3568.namprd11.prod.outlook.com (2603:10b6:208:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 05:18:46 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a%4]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 05:18:46 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2 net-next 1/4] ice: switch: add and
 use u16[] aliases to ice_adv_lkup_elem::{h, m}_u
Thread-Topic: [Intel-wired-lan] [PATCH v2 net-next 1/4] ice: switch: add and
 use u16[] aliases to ice_adv_lkup_elem::{h, m}_u
Thread-Index: AQHYE5SGUyVYYLIpjU2OvOT0tAmHMKyY5rRA
Date:   Fri, 18 Feb 2022 05:18:46 +0000
Message-ID: <MW3PR11MB455479F0312E6C9DD12386659C379@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220127154009.623304-1-alexandr.lobakin@intel.com>
 <20220127154009.623304-2-alexandr.lobakin@intel.com>
In-Reply-To: <20220127154009.623304-2-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61b000c9-f452-47aa-76f4-08d9f29e2370
x-ms-traffictypediagnostic: MN2PR11MB3568:EE_
x-microsoft-antispam-prvs: <MN2PR11MB35686102C3B7DF0EB9330EA99C379@MN2PR11MB3568.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OfevLUann9X9eqRHsMUrmxdbDE8UobMOPx9pC2kNpsr/6tOhH3dJ8jy88amZfK0f59XxKnFDRAGy4AyC6gxbVaToLAfk81LkifkoHSMrcVHKApCpHT/f7wXdw6ixecT86nvHqk3SdNBVBX3dPEK7XrJIrUbfXVdhNwFCGdbUdiV5fKaS5oXIeWwOnI/CQ2SjUMyWK9bsKqs22y9tegp7hD1FO2SBtIrParjzUe+Ai9YjZrcZ7dsJHNh7l2pYRNDRgBK5CfR17xseqNugigKidCrqJoa+d41v3BaHYH5uH356ZSI5HVwFkQ7bSvmo6JXo0WkUP7bGNn9b0/sZm1kaTRe5MALm5UwbBZpFfILWAKtywy4PPHnGj0lvgtPOBhm1Lxsn5Nzq96k8hCF8utfyVNBqsFHy9aK/AOJx94q88v33ZjA2ZhLacsWh64XdMeS4TAjVQYY3bmKqW4oC7/qtidCXUiTtl7WeIQ6cThFlPBBSbhXZ7C3ads1v12r2tTODuM8TOQOwrlETpFllJb6wrEF/Gta61sEQ8E29dAU8hpQxYgNP7Brdny2TvZ4aw6f29mINlG6FnJVK4qfbKQQGB9BykNMZk4i/1i4/I/ULCE19VWZPJDUVBB9IBsyTOPusYwwrK2z9+ZryAM4j6C0eWYna+ArAxAee7iJxWdlqg9cIb0pFhfma77PhcceEEzY+GKMZXADc7KKD2+5MLmQgRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(4326008)(8676002)(52536014)(38100700002)(76116006)(66556008)(6506007)(7696005)(64756008)(2906002)(8936002)(55016003)(71200400001)(66446008)(26005)(186003)(86362001)(38070700005)(316002)(122000001)(83380400001)(82960400001)(508600001)(9686003)(33656002)(110136005)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BBaqI3mdwKeuOtsOb3m1eopImylYlTTPycRmFtpnNZu5CvT2R4xw7M20HPNZ?=
 =?us-ascii?Q?tmVUz/oIVGwQFHbCpXSpLQ9Ha+NnMcrQQ/5oLD3J06hWxiwN6da3Ldx4H4kr?=
 =?us-ascii?Q?EvjtnXb3HjrV6+PVE97L5gZiQw699n3CGDexeS6uMGF18iwKXRIt9/yCfQ2h?=
 =?us-ascii?Q?qzvMFOGqkhFlzXcs5syJNQK1xq9964SudGRlCDOvoLWgan69j2W/5wz3jlVq?=
 =?us-ascii?Q?CIbHd+ffxb+ONMo4tuOy8vWW6IPWJUGhFtPN4bZlJ0WHOZXYHFm3BEztcgNy?=
 =?us-ascii?Q?sXgPm2RUgLVWaZRFnYW2+sJGObHY2oZYLJVXzeuxeeCOaYs+84zLTMBR2gPK?=
 =?us-ascii?Q?5AouYfAOwsjjqwMZHDRcy9hTjOTIGZV/glht4WFSVAL7T+9qCrpuiZ/tRhhD?=
 =?us-ascii?Q?yROc1MguZtxGUPXvAtpSIoJNV53GHuFIL/0bHK71jaG00oiXecivn6g4uELk?=
 =?us-ascii?Q?Cj9BnHGxqc4eUuY5/mF+SERsoX4HJyoN+4Bo1u3tYOV1pTJqFL0I7yJ+L9Zk?=
 =?us-ascii?Q?r4TT+65O+XTJutMll4WaRnGPoWLpkCxbJBb8tW3YzC/RcIPLQ33Bj1wFWPqN?=
 =?us-ascii?Q?6ObQWVyjT/UQsXNDb+FrTc4HsZSoj92ZLJq0ffWkpCL1vzQF8o8dBhF3MLmf?=
 =?us-ascii?Q?GcB/r1hgKlpLrWgrnCC6cLJmwo9YTOiXtlmtGRtiVV2qhDTPDySXN489s1y/?=
 =?us-ascii?Q?C0kVLYeDaa18CKjnwMhZIPKfJjODgmWisT8EYM1cMEJSq8I69khv0PjSJ+gG?=
 =?us-ascii?Q?+VO0ak0NnYavc3umbh0hirHGVAhSopAJle/JJ0XCVs+9sV1SFgfPQsfUyrOO?=
 =?us-ascii?Q?hefD7CVFsziojFRlRrV5QtM/m9KbQ3rjgK5F6Xjcp/ULoDvxVwAvmTdtPjPO?=
 =?us-ascii?Q?N0fn02gkeTwPFOOQuNGQBxk2SjIGwwoPVos6IT+0mrc//hfLHR7ASo6SIg2z?=
 =?us-ascii?Q?vPHgii9eQzFpF48qqWrMO0ZDtYhRnPWzjqdrts+vF/ZdqZoXLbQbq4AaOlei?=
 =?us-ascii?Q?AW227DwHcYdHUlxSl7SSl/fCT3F4tRV8FMfLvxu+ORmJ9jeBsCuc92MW8ktR?=
 =?us-ascii?Q?16BP9Ur5DNOs3d1NRzYEbVz3+PD1u0w+bJzb4TojqjhtCHjU/dl66bcupHSQ?=
 =?us-ascii?Q?o/VRce517461wsFHtSTbYaG+pBowzQV3SM8Y3b5XEePCF/zKSxNz9/wCh7AB?=
 =?us-ascii?Q?WoX6g60P+g9/xJtgwdLuTSA9UUD04AluXA8yehf4RPIwg/7C5wdHOLHZP2ma?=
 =?us-ascii?Q?s6R+lcqU/lxKs0/Pn+MLyuzU6R6+9GAsiBYLnoJjZF/M/v9CD5iAvSgxEchw?=
 =?us-ascii?Q?gbgHVb3ILPH6XjOyZa8m9qLgHlpUIdvn9xMLCdxzyinFruHRsoYl8EhQcQxN?=
 =?us-ascii?Q?n+lfykHvUfKIceoTHyrBR8CzljMH1X9pVkumhLcqSBguaYH8vdOl+mKwQgDh?=
 =?us-ascii?Q?9WiekeHEqUcTyyflVj6SovRBTCqbDIig3FhZH+YQsjv6c3lCFD7SrirSzitX?=
 =?us-ascii?Q?xLX9fqSh7/F4SnshxxiNcbuc+/Na9eo3LI1Ljl8mjefQSLwf7nOi62SpJ092?=
 =?us-ascii?Q?wZ7ejt7kp3I3tnczj/L2aSxqgYQ2h5QcD9gtAekmjQFaqarHgL8uZpwyQoXG?=
 =?us-ascii?Q?RSrFH/fE/NCMy1MYzh4mk6paQAWThDy4givauJ+lcmsXBbVo42zGKlH5ELfo?=
 =?us-ascii?Q?gIG4XQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b000c9-f452-47aa-76f4-08d9f29e2370
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 05:18:46.1557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kcg/QaNRMH2kvmSwsbaRvxUrOK8dTXgcV9nv3u0SvpyzsV5NqqPmOtb3WHIIXyoK8HegSG8eJW6bZmMoukyxH+/nHObK1oMrcRsvtucTeuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Thursday, January 27, 2022 9:10 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; David S. Miller <davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v2 net-next 1/4] ice: switch: add and us=
e
>u16[] aliases to ice_adv_lkup_elem::{h, m}_u
>
>ice_adv_lkup_elem fields h_u and m_u are being accessed as raw u16 arrays
>in several places.
>To reduce cast and braces burden, add permanent array-of-u16 aliases with
>the same size as the `union ice_prot_hdr` itself via anonymous unions to t=
he
>actual struct declaration, and just access them directly.
>
>This:
> - removes the need to cast the union to u16[] and then dereference
>   it each time -> reduces the horizon for potential bugs;
> - improves -Warray-bounds coverage -- the array size is now known
>   at compilation time;
> - addresses cppcheck complaints.
>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 15 +++++++--------
>drivers/net/ethernet/intel/ice/ice_switch.h | 12 ++++++++++--
> 2 files changed, 17 insertions(+), 10 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
