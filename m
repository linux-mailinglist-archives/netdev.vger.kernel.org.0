Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37FA4E7116
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358806AbiCYKZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbiCYKZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:25:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27716972B5;
        Fri, 25 Mar 2022 03:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648203840; x=1679739840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zyl1EDsxRpf57YRYISuiBr6K/YW3eewEzqXYK2TLPWw=;
  b=MwpXQ5YGxQCkd2OIdQ2gdER8n8nhzXpVPzdOg6Mw3wNSj7jFfL9A9FfE
   2ER5D1hHFTRyTvOxTucEbzzOyoI8iTZe580zSo6n7bbf2DCmloRFa+z5S
   XS9WdoCEZWuqhSTq6rMvZBQ7rdgQ08Yd5xaua4UOF7431s+lKTl/rppy/
   R9q4rswrMSifYItdYwFUp+7Emni1tmsIo66oWx5DyrIjJDjvwBLYTRQIv
   kOxtXJ4fJuaO2aH31Ew0dHAdpuo06SvmkSYMdoDuNRryi52M2HWLAkvWr
   DcYFAklnEK2gESfyEiQXBDgcXaxUd4dBWnRoDC5KpgB3UEH3deWXUjGEm
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="345042171"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="345042171"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 03:23:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="825995946"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2022 03:23:59 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:23:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:23:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 25 Mar 2022 03:23:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 25 Mar 2022 03:23:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1TLT4EhmE6Z1GvZZUavrCOHnkQ3LYSscb7jTr7o/RvYRld15l3FAUCEhsYU9jY/gXh9rMya9th89gZW+qeuEta+wMhpqfcpYIOk2qik6EeFy1flyUxBfjieB/X8ERkSFtElzSBqGAzUwCN7SzkqW4MjZNsHqMEPtygsfmEm0Lu2qFDR6uppweQEAAg9UgAnNcbDSbeCOSruZm9QScxvg2afMm8QQUrvEA6SUE9mog2spXyNzEaFmT1FkMShmEQeVXppxlAxrFwhgDp0fnV8XsibglX5fHPodJ/A2+k0ZFuBy2wDTQWtRH0co5yZRFopRCbMB/D4TEVih0Dvyl1GwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1awZP9RPjTsPmYsaGy2RaSpLDDJYWgk3TePh1xOAeTM=;
 b=B57q/MKAwYBLgFUFCbuxDCO7lLZe0fcJVRc0sCkL9kBF8PNkMn9iA02qM+LWcIEq4GaHIrgr458WpH8qaWGVK3A2yoJHfiN6brQUmIJ9RY/EL/rAIApV/+Iy1DO8iVuJP20+O9ifPGH6+w4EdHRbZMr0RJm+3fuKxK1CFNNlyYry95uk0n7YpJ32sLovmVIq6NAuya8xGBUvLtAbckqnUQgcTRrF0USvjoSYWDMXSuVmJIpL3XT8LO2zp4MqwlBn2J2koQqjSDYZlxTUhmFNGnJrE3cXTJCp9GC3oGN94fCuH1dfclo2sQjzxPvWEktFKGLULQBSKWzhKvlDd6iUXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by DM5PR11MB1708.namprd11.prod.outlook.com (2603:10b6:3:d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.17; Fri, 25 Mar 2022 10:23:57 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df%7]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 10:23:56 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 1/5] ice: switch: add and
 use u16[] aliases to ice_adv_lkup_elem::{h, m}_u
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 1/5] ice: switch: add and
 use u16[] aliases to ice_adv_lkup_elem::{h, m}_u
Thread-Index: AQHYPRMdyikyh7n0eUeH/8nMui5eF6zP6olg
Date:   Fri, 25 Mar 2022 10:23:56 +0000
Message-ID: <MW3PR11MB4554B661BCDEAAB6F5558C599C1A9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
 <20220321105954.843154-2-alexandr.lobakin@intel.com>
In-Reply-To: <20220321105954.843154-2-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90f0fece-3a30-4837-6c5d-08da0e4991df
x-ms-traffictypediagnostic: DM5PR11MB1708:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1708435AD7AB9DD2DDAB428C9C1A9@DM5PR11MB1708.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfBX1mjm4J/L9SmXhXewbg6jkQVuEObTnMmFWkm8f1dpn9U/rt7iJfMuQdxNDVF7WF7MAuVklBUVnGGvk9TRiN81vyoFNXmxlqPoAgj4xIDqYyrc3o5GEEc7SYvfhBYxOPPSzsWk0J8ilPWCastIBaBgYX/piQwfmoIU11qBq3gTJfL4C9yL5YLNjldJK4efNfzA7bWcHKGRRifgZ5v3n1X/eFlAKe9cajsWuEvaVt/dGH0LKNvtQd4m07qUVSKi6svJuc7pRKbL4IaLdyzvRMeS7IN3oenIrMSZ9XBnLBNmqWc2Rs9INJc4fW5pBHlH0nfJRbax+5B32qBBYMCp2eY5drTCID2rDLThwTkH1EJrYIJK1c4wO2GZXQctPiREqqeNV1dG5ayjMXTUxam0b3dvfeF0g2O8ycqi8iel2hJPbuD15MRaN+wkVkAygucSW6EzHIQ5RUuCtnEpDBq6NklECuOHJCEM4Zdu7ih45dxNfphoTdgspg9IM6RI0LGhajKdfqVSwIxHrU2/y2q0OO4/GuT34MsSRR0lyfEIyg5O0WbsuizF7OvFMMZ9Zmzv6OBSyNfGUOqpDEMdYu3swkpDjni9lad1VgxZTa9dYJhZ14v3o/td9U7Ch62vaS5dRQCoD/fKuqYZ/B9rC8R2VP3LqfSN+ZABNu8LglcqO3vY9IoXSxccJ5oT6i5awxb+vt/lrCanBVx1arMip1zE6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(52536014)(508600001)(8936002)(66946007)(76116006)(316002)(83380400001)(64756008)(66476007)(66556008)(38070700005)(66446008)(110136005)(54906003)(8676002)(4326008)(122000001)(9686003)(26005)(7696005)(38100700002)(2906002)(33656002)(6506007)(186003)(86362001)(82960400001)(71200400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fKYmAFXzZ/vjCl3K7CtJeCRZ0ZER+pVcYpUk1POXNNGt0PbLFcDKzPDzosbK?=
 =?us-ascii?Q?HWmcOX77e065hGQZoptrpNFJS704aZL9lEAIAyjC8JRNPsO0sayS1rLEWbru?=
 =?us-ascii?Q?N5vHX1+GkBBMVXLQ95nLHBxAwqBI0Fwr33ff8m9Z9KgU9T4Zn1yYNt0Cl6oM?=
 =?us-ascii?Q?JoRxadz7djtbN67PKvFDr/5aBw5amjURlEHteAwob012sXdcyUDNVj3nPuuY?=
 =?us-ascii?Q?n1LM1KNDLphR5FQQuuJlCsvo0GIlmYOi/181Ehrmct0eFxZ0uh9enr42OEAh?=
 =?us-ascii?Q?InqOq3jsGLH+NNVNtGiCUz16cZkgaicWVk7+tedrNK3O3QSyhV7+abhN///T?=
 =?us-ascii?Q?ncTy/YAlN2npBMtFkFqxVj6HRL4/Thb35V/OyRugVpY2lebHg4oGWrVwtCZn?=
 =?us-ascii?Q?PuHLHphX7gNc6X2j9l6gOg3Wwt47GdotUoaM4iMF8D6xMlSwe6jmyKIhO0Pa?=
 =?us-ascii?Q?InZ31UhxlwDkMPFPViL2GuqViJCT3Tgu2BRX4hnAJGyjSbAiszS79GcRF/Pc?=
 =?us-ascii?Q?oDFNAwRjvl7jJl+XCgInkzeDya27DJSyiPB6TZiuweyyKUw2K5pMolOzd4xZ?=
 =?us-ascii?Q?Z5A7g8Tjh5KtypxZ9WQykI1A1/aMASUY7ipws/HN1tbl+ts4oXF50wUi1t5G?=
 =?us-ascii?Q?vGR+mCfu0dcBlEC0QgRAaLHK0b0OcU3wVNuzzQKAZzYBOiYaoi4uO89v9yqi?=
 =?us-ascii?Q?NmV+4LplD7wB6+dILxgeRX1psCtAzT5d2M+9Ya54l7ZEhV9oxzh2ga1Ny1rk?=
 =?us-ascii?Q?ttUud+YFazxLaqKN/DpQ1FxULmslHca6cFgWl9CF8+7WHBSjmIEYIOhTWTLX?=
 =?us-ascii?Q?baWMr73hZZ5GhBBUJFudnvt2Pf1+JekYUEQPNQtgspD9lvwPT7nIb5c9aKjg?=
 =?us-ascii?Q?IN00uJUXhJRiTI5vZeIm3MDtNDmbmriNxkIxolZkbTIw4JqvKr5DELLOWG9m?=
 =?us-ascii?Q?7PKk3uaq4a7cg3ATU8J2qBD70bEKgBneVos6xkev/eqoveFebBeqUz2VGKho?=
 =?us-ascii?Q?X8w9//WnEyglhsYPFxm/ZswnRKfi/7q31vM2QUJfuucWvN4n28es3Res5rt2?=
 =?us-ascii?Q?UkpPPZe4YdFNFzzwjrz5s82x4Pk2Xnuj1NQ1AbQ2GyHdzMIT60QYlTChGPGu?=
 =?us-ascii?Q?pI4sTgixQ7UVsht77JBadGpzkRpX8DUo2VqQ4HriaTXhrjyzpbfFoMl1rnYO?=
 =?us-ascii?Q?uS/ssLTCtSOrgcoOiZ+0+9elbxHCYV3OLqmh8WxBapbzSz/tB2zy4PgHw5YJ?=
 =?us-ascii?Q?rk20Yc4q0kCzX4l8is9a9xXPNZzJL1T9dOvot3VKxIbuhYwHJkHTpZgf8e12?=
 =?us-ascii?Q?dEsiNqGzFubOUPmiYeanbZvE5hy4Ui94FNAsuht4e7ptxLoIs+Rv5uQr1nk4?=
 =?us-ascii?Q?WNXOA/8ge0uwQBPDogUuJTdTEMaNQGIhoPooLnbZ5kU/elYkrlzlxKO9Ye1O?=
 =?us-ascii?Q?ldWzTqINWtw2+J5IJOU9dsHkhkgpeK+I5ReTS4vwkgbbUVeMOsD+iN5xppsO?=
 =?us-ascii?Q?UE3opN40gAtvGzkvGxtSf/tckR0ODos97hdOZSX1f0inCm+OK/0TuBX5TuWD?=
 =?us-ascii?Q?Mmcp+CR6/Kvql8lrsLSAWVvchiAxnpk9x/awjOgJLOtZhc8bpPGd9yUka40N?=
 =?us-ascii?Q?nef4r3NxCU6eCIwA4QvpJzu7BI733eByKgfaERsUzIyOyJCXB0fNEpz0D+vN?=
 =?us-ascii?Q?4XGCQYELuXym7IoMHFU+oxMN42oFIZ2+ITvEIsUT2atKkG0K/9iKN/axrctF?=
 =?us-ascii?Q?9AgIMKcJ95y9PDP781KQI5un1eC1geY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f0fece-3a30-4837-6c5d-08da0e4991df
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 10:23:56.8305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/G7mPpjgSXP3F+402D+2u49mrvGGQOedOzctlAHIPFhzkBTVogFEoUqm1pqPa98JlQhgkgOJc+NVIIzYIV6fjhcN8LaMkSCrstBVY9mYXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1708
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Monday, March 21, 2022 4:30 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
><davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v4 net-next 1/5] ice: switch: add and us=
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
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 15 +++++++--------
>drivers/net/ethernet/intel/ice/ice_switch.h | 12 ++++++++++--
> 2 files changed, 17 insertions(+), 10 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
