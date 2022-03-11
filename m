Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D0E4D5BA6
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 07:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343789AbiCKGf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 01:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbiCKGf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 01:35:58 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510E319CCF0;
        Thu, 10 Mar 2022 22:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646980496; x=1678516496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xeb7aQKUt83ZfMi8bsxbPNRKu8X2cLigIcvDTXVXXN8=;
  b=T1/VWwIOKOxVXh/4Hk5diVUCZUlzgxQr4o/j0iagVJaGcJoeo3Vl1OU+
   p10u6iR9kyC0j9lmq/IUxbWPrj1wPrn4OvCtiId9m8qWko4AfL3nEf5Io
   j7G6RfutLPvUWYk6JMdXnMaPHzcPnFNzzErV84G93S3RBA+4hzWUsj65K
   +KEhwb1JJweG99d8QijubnhFCLWX949Xdq67n+e1AkV/clGcNxbcFipdi
   YN9Tac9YlCAVm82sy66kehLxNhOBprDpFRx6HQQU+bsUppLuUiStjm3JB
   +JL68sXP54I78R/1zHb4L+Y2B2p4+JEo2cHrCE6hxpur50QaCoqUe4eqa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="235463497"
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="235463497"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 22:34:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="781773157"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 10 Mar 2022 22:34:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 22:34:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 22:34:55 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 22:34:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuoHC0NYCBIRQNFQ0LSoIh1ysi5a3ptzTONSLQNTF3kV3OEbcWw079R8X9jI+Ip6NId1MhblNKaYTt8wMLVFRUnVhadM1wdSpVJ0SVjyDV5iKHlmw6Y7G0WGigOpGp9Nx66Y5zaEBQf25VPYrskX2gzYHb86Xqdosi71tCOlmNRTlPlgxFpvaNHxj/sM3dZ+xoPdzctIWP/XhehNf854+Tv9+Nysw6fsWhAx5L3tnxwzisHEj91C/ixBH+EO4sS3yUHlOSFXJPQDDW24GwrysSzpItZrutFZtyPamOsL5k6BxGA2XBYTMo4HAP1IZ1MaNojdCnshyTQp0ZyN7oHSvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWiVaix/lzZP0TxaJa6TAd//VWXMN/ofYHgg08xtbA4=;
 b=UDouiMi53eIwYsWU5huNJAcThfPPvGJmwlcpQ6xOjxIRLodPpN/5aOgxul6hWceCSjAas5FZyWmSUdgzZZL/W5QEpE+CLjq2Fqp8psx8yjJhlIO6V0NSqQ2ncKp2RvI78Y3oGTaN6yfUQIN0Y3Z/DeR0/Ue19S/9t/UYrKfAqJhqY9GqFA70LB9K5d2MBvZhJ3/gqTMS52/TjS6EBzbxKMZ0YCKE4D1OyeQIEIcr/TTv5OpyqihQY1BoEwNYjityc02fGVYZPqzxkc6iAjTEA3TRWTGX+jfvdX+BrZjUoOFhd0bktdm/KgYwPCKL8j3S3oNKvKGt8blSftTSxj1F3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3239.namprd11.prod.outlook.com (2603:10b6:a03:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 06:34:53 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::44af:c21:2bed:47b5]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::44af:c21:2bed:47b5%6]) with mapi id 15.20.5038.023; Fri, 11 Mar 2022
 06:34:53 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>
Subject: RE: [PATCH -next] ice: fix return value check in ice_gnss.c
Thread-Topic: [PATCH -next] ice: fix return value check in ice_gnss.c
Thread-Index: AQHYMG6vYwftpU9FC0ah8yTxfFMlKqy5wzTQ
Date:   Fri, 11 Mar 2022 06:34:53 +0000
Message-ID: <BYAPR11MB3367F780F7761EC6EBD87B2EFC0C9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220305090430.3078757-1-yangyingliang@huawei.com>
In-Reply-To: <20220305090430.3078757-1-yangyingliang@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af08a961-65fd-465b-0abc-08da03294043
x-ms-traffictypediagnostic: BYAPR11MB3239:EE_
x-microsoft-antispam-prvs: <BYAPR11MB32391DA5D4B91B001D8BF40EFC0C9@BYAPR11MB3239.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mFuXqPeHEqmO+DjFE6YehQMAYjzq/ZZiH3fth8sEYx/9U9LQb7aJIU3R4OzTn5Nw0Wln0XLR1j3wDcOwlVqRZbcGgVXrRxfw8zvMGyCiWJCGRR00zEf50Fqbka/69I6vIsu2gThGBUx38e4TT/iwLOlxP2lOS6T9DzQo6PGd2zMLsU6ocu8ZLuSA6Sx0oElEka0QwiVeIitlKOXarEUEmQPVy7IJU11sW2FDbVtKOzsAMZSmjDfGs81cEeQv0txgBziaAV8BdbgSt9L9ZAmc/QU/HyOe0Qm6/rMtNurMGNTPCmEVD03cRrLDkJm4WMJNCHbDt2HgpS8wSLT/UBQuNQ64qqEVAi53jQgLJdnxr/goYH+STsY8xlwipbrwevKCBY2mY4VxDpgzU2pzfYgf874PMBQ6DUKV6w+LoKAkDonI47x2mnKA55zVzcncfafvU6oyyD3SpH7QZIAwyjZXkSJG1qUGTgpYehLgc85dWjHCt2WhuaiIgLcZPm/e2Du43V9wEqLb+Makq35PfLO0qe0/TlOkizyX5ufjlo6fNI39UgTHQhmC+INdEjyaDWY7REGraWvRSEXGJLnoz8GWlSOjyuRgRy74xmxam/MhMlEZphYWotfbpV8g6HWzL9+/yhTFhVRyV5MkSJEhUM0vHsgil4FN/e+J+dJgiu/th/HUeu09Ha2W1MUPK4G4vl++MyyMx1ErwNEOTnggUwBXVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(8676002)(33656002)(8936002)(4326008)(6506007)(110136005)(7696005)(9686003)(55016003)(2906002)(52536014)(86362001)(71200400001)(55236004)(53546011)(122000001)(54906003)(82960400001)(508600001)(5660300002)(38070700005)(38100700002)(76116006)(107886003)(66946007)(66556008)(66476007)(66446008)(64756008)(186003)(4744005)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sW7GgxcFrKrA2xGw/to60+0Zz1XKS9maya5W+euvdXBZHvTTBbXBS+XSmgjp?=
 =?us-ascii?Q?jgirAfEXzNKaQ0o5U1a/SiC4cF1ZjcBTzhfkb6XyoyULf/OJ1ioqyXY7ZXq8?=
 =?us-ascii?Q?kH07LYGLE8pmaunDiwjsa+OjMmhhbKGqpEJY4v9TZU3V80aVSQ3yHXnyvyKl?=
 =?us-ascii?Q?IdqM/GfEJdVIX5KpVvIBB6l0sAGu1LSD06+0dJceGvVN8CwUEeTkNeJ1zaWA?=
 =?us-ascii?Q?Bn0xr8xGqVz8Frr0PHfGBB/yJcAT/CDEhGTKb7Qnk4QtIVnsLL/NUsGdFR5G?=
 =?us-ascii?Q?XrkW9Hp/4RSbO/nwE07mbB9oVGGt3C1LPQ/R0A90ZIFxCvZau4zDWMuhws+Z?=
 =?us-ascii?Q?nHMXhG7f2wVRJj2v5foHrA+QkKHTmXewG3u7TghXwuzlP49ABY2cXOdH2YQ+?=
 =?us-ascii?Q?mivqjvOtn/NaDZY9zRSm7ynUtwXiDw4l4z2oDUnHZnqqFs3LdJcz+yaYtSTU?=
 =?us-ascii?Q?IeW/OFpFznP0NfQb1fxGlNO/8qG/KWP/rKNCAPHxISOJAytCWzAXVUiWdXNU?=
 =?us-ascii?Q?6R3BS6MRU2XLUZbE9vdMz93as+KtIO4J2EHIPAx/Wsgyr0OKm6F/RNhctUr8?=
 =?us-ascii?Q?259F4h13F/dZLjZSZTOyE75/UmRbeoYte1+vK3E/T1xnxk0dfbWMw3Ws6dOp?=
 =?us-ascii?Q?UzsCtEvXeltENvu13PKN4HyUBQ2cTDqIGj5ndqprkZg2Iuz0JDTzQ/ofBvRh?=
 =?us-ascii?Q?WApqeJcRbzeryG+HCkBlRA1A0VhtrrY6MXZQq1BLiWxypIFIQ0y7I35gLrIk?=
 =?us-ascii?Q?Se13Pwzb0GRjP+7aqtLeP94fpS/LT1KubKT49NCAGQym7lNbTkj/2utP/S2+?=
 =?us-ascii?Q?2w6PwWwiC/Gr/+ld3Dgpkp/+qbSiy+99PvRYR7QdGDIH7VmXhp0QEOOdZc9d?=
 =?us-ascii?Q?fju45tsyMh4Ql2ZckuAdAPmRFCp6hgN8XD217KZEvx1lCNpo1JTI04kFIy6o?=
 =?us-ascii?Q?im4TR4JfRo3GmRJpG2V53Pt25NkQHrVo8ui0x1ASATxFJyNme92sr0h1LAvJ?=
 =?us-ascii?Q?VIdBTdPYs4xjGBdgRpYmxT12q1MlxNGsx1a4IV3i7lMLleCT4m5eWogxBvzT?=
 =?us-ascii?Q?wGb4jHuY5KmxB1THYDo0jT4FwmYNssiywPnEoXe0cdBuZqYCqTYQdPgyK0hz?=
 =?us-ascii?Q?64lWTFhyUu9I5H4dc9XzWxcIuLDGiQxxEuskE2WzhuprbrEkTjue8lSzibOC?=
 =?us-ascii?Q?gJn/kA2LCvsJzGi//z/evPxWCJHBJs6PW72L2Jszwc0NG+/2cdWJuNbioir3?=
 =?us-ascii?Q?zVizR89jrp+GgHJQGg3H7+5wxCXYOfiYspHlqKwdXnA8hb09FrbzeTOokt2W?=
 =?us-ascii?Q?+xAoPdMtembXU23lpl7XkGYJfFYAXofJmH+y/E0slIUIXODi2J/SthGMtcas?=
 =?us-ascii?Q?pmQmy0Elv+svi0W8WVZh61t6qHmsghi6PG2bk8ojLfManurBhUnsBHZdHnIK?=
 =?us-ascii?Q?BzOTk3ORznbpXeDIlyNVsPFZeoTz5Y+8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af08a961-65fd-465b-0abc-08da03294043
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 06:34:53.2087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8G+wHnS3RhIesS03xKRY0yU6Z4izam+4h3WWCS9yfibyl2qInz50X/Lhd1V731HsQPiMpdwTz0hN5jnLnDUovg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3239
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Yang Yingliang <yangyingliang@huawei.com>
> Sent: Saturday, March 5, 2022 2:35 PM
> To: linux-kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; kuba@kernel.org; davem@davemloft.net;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Kolacinski, Karol
> <karol.kolacinski@intel.com>
> Subject: [PATCH -next] ice: fix return value check in ice_gnss.c
>=20
> kthread_create_worker() and tty_alloc_driver() return ERR_PTR() and never
> return NULL. The NULL test in the return value check should be replaced w=
ith
> IS_ERR().
>=20
> Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
