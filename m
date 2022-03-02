Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DA14C9D9C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 06:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbiCBFuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 00:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiCBFuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 00:50:04 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA6FB0C69;
        Tue,  1 Mar 2022 21:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646200161; x=1677736161;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ubjFXcNp5m5UkMvHpkuzsabzx2XVsb8abwf5snCFXgo=;
  b=DSxHHBj4B5poVnHkWUMQG0CDqbP6Y49jxl/rLRlqztefmCkH/6NtkQR3
   xQTn4XiCim9SSIEpIuyuGtxnua9Er4018WboxDb8P2O0qHY2SXoYlC8Gi
   QylJI/MMozXriLd1WxJTgyWzy4j+5923yXnKTj4wzIIhtrl8BHP7ec3Cy
   9rNuynHMIHfKJRBPZQ5IXsMITwfifCIxRoi+739NcBHV/N8WkY7vXuzaI
   t0VDUrMFcS5d+orh8XSakyxW/V56GTJuOfll0xCO/ZISNdzhkhTPyvz+u
   BRJ/niTKENbhzCBleAX8emIRuf7hATwvNXe8+v8HjkccdMsRs0bHhCqPy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="277988975"
X-IronPort-AV: E=Sophos;i="5.90,148,1643702400"; 
   d="scan'208";a="277988975"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 21:49:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,148,1643702400"; 
   d="scan'208";a="639661168"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 01 Mar 2022 21:49:20 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 21:49:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 1 Mar 2022 21:49:19 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 1 Mar 2022 21:49:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCgFB7Hva1CXDuibktNJA++TNBV5ISjZDKFFV1T+/L8Ow74CFajESJ5cN1Ne6hkl3R+yK2EGjtZ/UuhxmJ0yArLTjWlL/3rglG4W9pLQGHtb9FXWDH1lEuz3y7+cqP3YdvjoqWmYDS12P5W5sc88qMJL4ZLZc0N8UfqG1FqmAF8I8+Bi3tHAjAC8AEsAxj+jnYhjxzblVCqvXaR6Jwtib9o8Qw2HNvYE9SYv68ovS7CRQ3u0L96gGbeSP0Ya79YUrv6KdQU5SviHXskLwbDZhDCTW8FJ19ZJRckchlIfeH3utN0SYcnH9n5w7de3tqv9fcLlcrb5v7C2CiM6v+08kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubjFXcNp5m5UkMvHpkuzsabzx2XVsb8abwf5snCFXgo=;
 b=JXhaKsqpVkaMB+yN0LohNyHGED3inwxz9kHMXLNtCgC+GHEvfW2gjGwJkIdJUW3yPWglo5rGWhGa6YKbGiLrNyCoTdujzR1siwi1kWFQNW2WhOl5yVh/TS5iecMo2z9g/GQ582KYbUqXchqSxC3YaI4xiPgBXoDJboVvS5k7dWYuoXK71nutCMgO6kdVQxPKy23f+9oQiVOIOEeLwYGXgLWO0eQBueUCUezO0qNTSdev+KAIE9laObGbXnxmxa/MIvwX8fST9vuOgts9DYIAwWxVtfn91geagA/TKg0RsC7FWvPVZGtgPCgF6/By5Nf1E4eDNFXRjeGO2j9WYaFMsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CY4PR1101MB2168.namprd11.prod.outlook.com (2603:10b6:910:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Wed, 2 Mar
 2022 05:49:17 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 05:49:17 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Maurice Baijens <maurice.baijens@ellips.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net] ixgbe: xsk: change
 !netif_carrier_ok() handling in ixgbe_xmit_zc()
Thread-Topic: [Intel-wired-lan] [PATCH intel-net] ixgbe: xsk: change
 !netif_carrier_ok() handling in ixgbe_xmit_zc()
Thread-Index: AQHYGP3PohV6ilfrKESl0Ugv2iIZlqyrwEuQ
Date:   Wed, 2 Mar 2022 05:49:17 +0000
Message-ID: <MW3PR11MB45547E1C71573E66FEE94F409C039@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220203125803.19407-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220203125803.19407-1-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: f7d0084a-99b9-4886-ee2b-08d9fc1063ef
x-ms-traffictypediagnostic: CY4PR1101MB2168:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR1101MB21683A38B0856BC49E2795D19C039@CY4PR1101MB2168.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kwaS8J5InZofcdj98r+AJom/JXd1yAphPnolmZN+yD9WFGoXhQ8ygBCTtTSCpZkIIUV73lLYZKPupqTf+dni9qutgn6FALhDUUA4hfPX5cFkuVNpI9OAalktuW9lDjMRYXXPSJMQco2NHMjYsfZqwST2Cv7ADPBkEYi54CYMdQ2uFJd2KNUg76GB62iYNLXRI0dxtpIUwcET/0SX0yksJmNsOyMA97yg3AUabaAUdWNlYWotBptHBjBrCxn9lT1fOlXZFErv8FK5EZKQgOldDDCYNllZyycw8/4K9qN0z0+YluZxHEdESzGDPFl89EOWpyeiup5pwOsxfqzfwYwktogrtm2lxPAculxSpwwcY1PIRWlEITUFgCalcAjq0u4/c2Ts4/omGrFaCclxXJzclGzSKcquBg5Igv3mmtOIIIe5tFP/VHev1hUei/7MjVx67s5UuhFxkhEhpubkMMQtfrUds80TkuBn/V11YeOGQmjWcSudoBwR0KSzEV+CnDwYAzMkCRvtxguWzQg3xSn6nzVLqv4UhOTiq7Gng0puaxdXDRb6NUNZxVC38CwKDANM+fze282cXtVzpqZWoyF706sf/CvKioU6vd2CAsrfEulz/Gk8Vg7Ax+5QTiODtcW3A7qCau6Gyt6y52c6J3Z8G0CDatuBaGUm2lQNXhVBUjoZfWjOrGWLdtoIEADUDIy/bV3QmUik/CZaypUKCnU5Qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(122000001)(38100700002)(9686003)(7696005)(55016003)(107886003)(82960400001)(83380400001)(186003)(33656002)(2906002)(26005)(5660300002)(54906003)(110136005)(316002)(8936002)(52536014)(8676002)(4326008)(64756008)(66446008)(66476007)(71200400001)(66556008)(508600001)(66946007)(76116006)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vCg83UpgGxBVQ9Uzxdk5kDcFTTdL7TpWdWC7vchVs4wp8/ctz5QLuyaIXB64?=
 =?us-ascii?Q?zhoZL6OJizBNmV2/uhdD6Zu+dbFORq+U8GSIF19qnPe2fhnmjAFBWUZZH7cr?=
 =?us-ascii?Q?MwH2ULaph/mVNXkp3nXfbYMKFlyw8U9ZVy3QIc63JXul1tTTqt82bTaz/IJv?=
 =?us-ascii?Q?lGu9rfxLDsCpoXEmk0kYwW2VtrzNfWIJt8wF7D25PpjJIZUe3OJrof0RIklh?=
 =?us-ascii?Q?soPC0oTQShtlSqzt2khtVSRAl/MkXW2LXmf5LqlYRUBSzslkxpAoldTZq567?=
 =?us-ascii?Q?y0vqUZlvp6gyycc9FrxME95dXicVjg6wBRG80D7BKK2GvskKzpUd8i5GCNYq?=
 =?us-ascii?Q?oKEo7SeE2qEJmPrkcY1JErzlz2l6vXPg5AYQOJesQ5CFuNdo8XtpSYwkVtMW?=
 =?us-ascii?Q?GN/pYhUVZ/Xp2k/z5uah7CrJ2PIcy7eZhZf6AgHr3HSuyolIzJCDMO/VBHME?=
 =?us-ascii?Q?h72rAVpG5iC1h2lrhrphpK3lkGj8P+THq7SgfOWQWvmFaymKTkt2ikTi6zr6?=
 =?us-ascii?Q?i5aVMR9YlsFC26xCwd8cVbcTdMj2HI+wVUQgWXT76e97fBgPAwGF9VbkrGvF?=
 =?us-ascii?Q?bAHW/5Tl+BZtpuq9k/SP7S46KLahRcg7Uam0pi4ux91ZjO0UBmuuGvoC16/8?=
 =?us-ascii?Q?igPYBJ7o12j4eMnBq/Czx1/X1JhfupmFuWQXqMOGdrb6FDWSB0WBGgy0Pl0r?=
 =?us-ascii?Q?gZel0M0grDNBADRmp5FdQ2miYESC5P8yK1ii/36rIOTLAhLJfUxsDaJr1uBW?=
 =?us-ascii?Q?IU5JQFENn3UlSEkCX+DEh6d9x1tiRjXBSQfrPJ0/2r8L+n+rOBzXuNh9JzRe?=
 =?us-ascii?Q?dt3mRV5dQOkFK6oMo/LRn72o3wGRxotdUglChSImXyWS5cKGMo4VXyyUO0wI?=
 =?us-ascii?Q?pZ/WXOpJRnY/1azelNrSGtB+JQ/IvkmfF9h6xXEdT+eRonhBLq6p54yw6K9p?=
 =?us-ascii?Q?GfPkJqxl0kkI83xJjLUnZqagkV++YkxJb1CxQMdUA7P6a4rqfoDk++W/rflq?=
 =?us-ascii?Q?hHe3bqnpePazLexyCzLaU1iv3g2+pE26eFFOBI3odvxJ7z1sPdtcOGEfBR91?=
 =?us-ascii?Q?iFbUeyYVY5qjRaXOib2Fvqk9wTARLytZnpfTLferKUbwtZqvxU7YIckEAQ39?=
 =?us-ascii?Q?LYsReL1xCWKIKasoZTUOXf+GKfKIZQSK6JcdqQlKi9kqupo/CxbaY21ECWA3?=
 =?us-ascii?Q?p0xb47OPV3ngbrTaq+csOxeKvgqeU2m6y0T2zGICrcG2F42m+Bc+QS1KSP/E?=
 =?us-ascii?Q?f38F5kiyZ1SWw2p9myjK7n245299NGK9WHTiS30zGdA6iEBVOAG13oj5Fz35?=
 =?us-ascii?Q?PEHzVEfU/uzMB+YnBTnwMZMbod4+Rkx1ZQ/Rz4fw9SlTrgouoNC9Qm2QI2RC?=
 =?us-ascii?Q?b+ER2duhXmUWLVU1tzQuNwQmr1qRQjIm1DQclWcdV563/2Z+4lOYWrrhgb4q?=
 =?us-ascii?Q?gQLOPMkuswvenoBZDuT3KhQzmTzcwmpbHQvR2VRPo4vv5bzKXpyJIrsafW8u?=
 =?us-ascii?Q?GD/20FmTMuplXRhzqhQH6AAXGfErpiuVWbrDgczanPZmnfxeySNNg66GWB2P?=
 =?us-ascii?Q?eYnjFm2ZVONK4jbYLCwx/s6Yz2VOPNRwGFqiPuqS4zODjwvgZvBg8WRmspFj?=
 =?us-ascii?Q?mkF4mvcjDrz9Cl/mwu9/uBrwRvECP/OKFQY4XuLj5Kzi19T7LZ2+wmCYE+ZP?=
 =?us-ascii?Q?S8ygpA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d0084a-99b9-4886-ee2b-08d9fc1063ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 05:49:17.4729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: unUy5y99WwBSNRSZjFu2L32KPtf9clfkmba1DTM9D2CWjQrfvMjS6RIwFgJZXfnJJ0GjbguRgbsw4rthyGfuy0AweXdxinqkhUqyiNXhf5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2168
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Maciej Fijalkowski
>Sent: Thursday, February 3, 2022 6:28 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Maurice Baijens <maurice.baijens@ellips.com>; netdev@vger.kernel.org;
>kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
>Magnus <magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-net] ixgbe: xsk: change
>!netif_carrier_ok() handling in ixgbe_xmit_zc()
>
>Commit c685c69fba71 ("ixgbe: don't do any AF_XDP zero-copy transmit if net=
if
>is not OK") addressed the ring transient state when
>MEM_TYPE_XSK_BUFF_POOL was being configured which in turn caused the
>interface to through down/up. Maurice reported that when carrier is not ok
>and xsk_pool is present on ring pair, ksoftirqd will consume 100% CPU cycl=
es
>due to the constant NAPI rescheduling as ixgbe_poll() states that there is=
 still
>some work to be done.
>
>To fix this, do not set work_done to false for a !netif_carrier_ok().
>
>Fixes: c685c69fba71 ("ixgbe: don't do any AF_XDP zero-copy transmit if net=
if is
>not OK")
>Reported-by: Maurice Baijens <maurice.baijens@ellips.com>
>Tested-by: Maurice Baijens <maurice.baijens@ellips.com>
>Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
