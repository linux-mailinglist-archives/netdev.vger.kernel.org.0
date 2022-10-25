Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D41660C2E8
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJYE6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJYE6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:58:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8212E0AF;
        Mon, 24 Oct 2022 21:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666673901; x=1698209901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kXFGMJyWCUU2wcdg0CWVcbr+VR7v4mPBE1OPgsw007k=;
  b=dvnC3Vt5dseGMU9oiGhYOxESQaVr60IthgO7jQglhLGWIlLByFctYIsZ
   dsqj6THUfAlFDKULrvMkSmUNySC/9qUvLfz+joYNtn0hUH/JDh4Qff6DN
   4HQAylVGZ9XRa94g83Mi4lfrRVQvyFKxptPCqwh7B0Eg9Px1TgVucTYOH
   mJpqZ6Nj7o7t0TKMPFIUUTpVLBk7nHhD5KLGPS29qzdgrji2rmKM3twhm
   YGsZ5W4d6cr/fbDbnPOhmqGhJS3yWWPIO67gDezQyGV2Y6S/8zfQuolsf
   npevFcy48q28XlBbdmeLdaqNMfjuSd84CHyl7lEL0l2DPmZBTEdEY0JiM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="287984744"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="287984744"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 21:58:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="626303928"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="626303928"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 24 Oct 2022 21:58:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 21:58:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 21:58:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 24 Oct 2022 21:58:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 24 Oct 2022 21:58:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3BNJNGgYfedjv5XlecBWwKW9KA/F7uaZktOju4bpTsBIsoqgPhLcDGy3P5goUzu7xcOoy8btff4MMjB9qi7jkumtgZvpMrsB0KrtLRT2enRPy1VzafpaEdKDyB/o4yWXFYXeAmz7DjsABPF3apyrjLWQNDeArwj1i62XvSLwJqoaY+skJAE7lxxjfnTtt6evq6g03LiAjHez5omdiscGDP+59vPYM/zXwmWRzVse7BaS8LE6MccMgvIfyiuD4IECglyr2NuBm/7jnAoJHB3oWA0DsWGw9H9QVOIxzNBUYK7V9+KExy15JDskLkk9eymWSZLh3ohep3S3SjoiqqUUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXFGMJyWCUU2wcdg0CWVcbr+VR7v4mPBE1OPgsw007k=;
 b=PHlVe2SIAPUCoNg8ZjGVbi0WBcnJ0WfLnh3T0XFJ17EnUSRdmTEOHouO8ekifaUnz35r4eIqohaNiOSpDpPvZIoHk7cxOJn8nF6vcSWKi2OwTiSgS+sqvCplsMnQm0QVIu2VBAUpGDMgt8e+7DTZCKQKrf3EKirFNlLP+gPW0ghnM7RbFi5hYIsfjwdyO7u3p0skJaeYtug7xP/QCsGlECI4FGSmxD+TnyTbMc3vfq7sKPAcna2EndXpTkP1toH7BAy48vOYbtTayb1U+3PP68Gf/Uq8+6czosgNeo9U3ea+UG1qBNTlo0YMHcLraTkptfFBDX2vSL9iGfFSZajCxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8)
 by SA2PR11MB4954.namprd11.prod.outlook.com (2603:10b6:806:11b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 04:58:13 +0000
Received: from BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::69e4:d3cf:7cd0:eb05]) by BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::69e4:d3cf:7cd0:eb05%6]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 04:58:13 +0000
From:   "Chang, Junxiao" <junxiao.chang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: stmmac: fix unsafe MTL DMA macro
Thread-Topic: [PATCH net-next 1/2] net: stmmac: fix unsafe MTL DMA macro
Thread-Index: AQHY5UQrIcPqwyKm2kGMfbK0lW2Bca4egg+AgAACBNA=
Date:   Tue, 25 Oct 2022 04:58:12 +0000
Message-ID: <BN9PR11MB537004886CC12D8ACE7CCF87EC319@BN9PR11MB5370.namprd11.prod.outlook.com>
References: <20221021114711.1610797-1-junxiao.chang@intel.com>
 <20221024210019.551e64ae@kernel.org>
In-Reply-To: <20221024210019.551e64ae@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5370:EE_|SA2PR11MB4954:EE_
x-ms-office365-filtering-correlation-id: 944469db-5795-4896-0cfe-08dab645853e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7oZisnbLU5Dl25ttcAlI/SFJUmVwz+GYmGGzMu+tQCLdbmOl9D7Ph0xpq9il+tW3IpjhJFnJ+jpoxXkKhNyCFxDjxUiUgKDAlW/Y3SCiJ3D56VqZ9iESdVuS/7vkzvpkCFZNIo24A/13VeA1dRenfXBsis3DWg/kwaV5rDxuVw3Wn46s81Advl7druOgYIXvoN/+ifhz7iz/oB8i3wDpPtkBoI6VLbMM6Ga28nczE5p093xqMlLvN20yKDArg3UiXR5ONduKS+PGISdzv6FS9gwZtGcrTz9UTdkmJWCudV28n0lHg1bDSbFMiRa+/6s7u3zRrSjGFgvNZN88Dy4xrTxpqvkbirzWB4YOFBNUA4xQ7YpEcyL058uTp3ugcYkigxxoGTOI9xJsdQEPy5P5Cwt3hi2Pg82njaaWv5WIdYt3Ca0vh0FN+Og1MGycAuN71+vVB8t3iDJe+LAVlXPwPnnOP2ibt/33av9oPSYpoQic8CifCY+MWa9Td2YU1J4kMckAKmrIpnNhU6QRSWEhqNOfNlvW1JTqjsuQTkANVthN3KP1e3TBuJI0y2jlF5OBFPBHE53oTQAHAk8Rtb89kTeYTtRsw4lyb3rKM7Ca2UsFeqlrIq1Nu950+iJbmktGhgTJK29NlGjYCqYzc3EEh5SbtizVePej8fKnNgq5aiXJBI1XK543cf9CL3ntG7I1fNaP/HD+ld45Q4Ja96XmbLBuqL634EVUgF8/KW3emHVJ63ZDw0OIG5E98WO9fTVc+bNvw68qyqHgm3fZ6Wkj6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(316002)(6916009)(54906003)(33656002)(71200400001)(7416002)(5660300002)(76116006)(66446008)(8676002)(4326008)(66946007)(66476007)(8936002)(52536014)(66556008)(64756008)(41300700001)(55016003)(6506007)(9686003)(122000001)(38070700005)(38100700002)(86362001)(26005)(53546011)(7696005)(83380400001)(186003)(82960400001)(478600001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w1LEHAqAZ84gabTXFyXDaFROyTJbXa+bYVax2Uip7Xh6pkB0GQoHBkIHlgy6?=
 =?us-ascii?Q?F7KJtccB/W7R+Cxwv05DdiWWNA4B8DCwgKmAswrpJzNoraCCzw3hjLH5mT+1?=
 =?us-ascii?Q?kSpBwLHQyqzAxPlw7ajH3WHtmj6LJ/B1e0InoZ3jBngv+MadW07oOrDTznBH?=
 =?us-ascii?Q?xz5JVhWWa9Ej4xKtpNAIeS1b2V41zRZhZ8PBsaUov/44b3m0tnG2oj/blFAh?=
 =?us-ascii?Q?JllKe9C/6pSvtcodgmOoZr5mEs/PNvdW8PAzgjY4oEFNMYbylRi2S0pjzhlL?=
 =?us-ascii?Q?5WgpUwlxSVn0DI9U2/AC0YLqZrXwyX9IvJdzHa002CtBrYxeRFWaEKAk1Z4R?=
 =?us-ascii?Q?ze5ccC5V9OKuzw4cR8ueyQP6prs3WdbfNg+bAtdu9YsMCehLz6TtswOSEECq?=
 =?us-ascii?Q?2ERe3lrqplAinmw0ThTzKMRH18dJQhepWDNK0iDVj1qZVd4QHlYzFHjxLnBg?=
 =?us-ascii?Q?t1XNoPTRNrcDgNqeD9Z7QLu0+BfLLguWI8rc95PM36N66/n0cRUQACcPonWu?=
 =?us-ascii?Q?kf1bIg3jFZLchwZMWOfBE62WBsptRGDlH+149HpL3tVSzW4ziwiioNDPzpYk?=
 =?us-ascii?Q?vpIQa2zDOruQhWi27Aps1sjsoOWHtoMt283LutKD3O4Bfuk1h8Y+kq0IDDhq?=
 =?us-ascii?Q?ms8pOBUhBNoIyuLAlB20R2VJL1e1TLFTO0PH3auqfLovLArJ+RRYahcxXBRE?=
 =?us-ascii?Q?tP5RKoXxYlZZ0xN+0llJGF2l1CQMmD4He+aM0J4OGljdbYMx995JgdPAlnoV?=
 =?us-ascii?Q?QVOFQWm2VKT8jcM+vPOoEqEJ0eB2egXSarFytkoQL8OkYgFvaeuueO10my0H?=
 =?us-ascii?Q?9fKAdmvCrULJTQCWVo6M1az8ViOhp8zxyYW/exX/DYAANe3UH9WNLpskNTPI?=
 =?us-ascii?Q?ZHm2hJgtcQK9G/Z1GVIDQ8fgmjbU7nVEz7lFb2pKvzVfzFTlwI7gGG/D1wDh?=
 =?us-ascii?Q?+Eb5pe6xUJovYf9Njz2yU/Cbs7HEjC/6TmMxswsEFwMitn0x0q6FfeZqnuam?=
 =?us-ascii?Q?GFWsSHqh3L88+rBN3hzNru3UNwkEx3Z1MiSloJ4T98htsH3+XQUSP22egz0i?=
 =?us-ascii?Q?Kdhd1Tl3otAt6pQZUcALh/866oNF2VC7roQtw/d4g5o5/MjTq/S2CnDDaYGc?=
 =?us-ascii?Q?rcjGH6jU8xVy+bNYbvTX3tuiR+giiB6a3bG5HJVst3BXa0vXQ6NTCrpQ8gNK?=
 =?us-ascii?Q?w+G9JizcMMyOUogfS06jIykHrhchbaHlBWb+tVqatQngUNgi+UL2BE1kp07L?=
 =?us-ascii?Q?2bKBOpsVaUUNDuJV3wLRvC3PzmwZH0mCGIYlYPYw1rJt5iLQ9bmbHAJ82hmm?=
 =?us-ascii?Q?WlJ8SJUoP3uFSO27o+zGqBLwkZ5FzhJa3GwhRHgj4nN1ohqJWdpv6PbMa6L8?=
 =?us-ascii?Q?VxAK2kV+o5XpMUJRpCIlvhGro8fXozhI6sR7IC/CEw/GVu2ouxZJrcWo7fgc?=
 =?us-ascii?Q?S0Ht/fQmgor+OqZKo6t5T3V+x+dLcbGeohpCqFJYARNUQUu88tVYVH5bDybA?=
 =?us-ascii?Q?4tBO0r1OyMS5jnr+NipVy0QaVPXuC6WpAUIoFrFsgl/7o5lewVJSQrCHNsN6?=
 =?us-ascii?Q?Ez355kjkzqvpRfsWzrgljEv6lyu2JL1HGcFBlt2i?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944469db-5795-4896-0cfe-08dab645853e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 04:58:13.0468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C4naoMnmzngYQw9BhcIUsV3NjnlstNGhwHcyV6WyNkniOjah8/EYGUpb5k0t+0ib65AdX3UFfoc4gjQ2TKbZAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4954
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for reviewing it. There is no real issue if this macro only be us=
ed in stmmac driver and parameter is not function or "i++".

I will squash these two patches.

Regards,
Junxiao

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Tuesday, October 25, 2022 12:00 PM
To: Chang, Junxiao <junxiao.chang@intel.com>
Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com; joabreu@synopsys.=
com; davem@davemloft.net; edumazet@google.com; pabeni@redhat.com; mcoquelin=
.stm32@gmail.com; Joao.Pinto@synopsys.com; netdev@vger.kernel.org; linux-st=
m32@st-md-mailman.stormreply.com; linux-arm-kernel@lists.infradead.org; lin=
ux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: stmmac: fix unsafe MTL DMA macro

On Fri, 21 Oct 2022 19:47:10 +0800 Junxiao Chang wrote:
> Macro like "#define abc(x) (x, x)" is unsafe which might introduce=20
> side effects. Each MTL RxQ DMA channel mask is 4 bits, so using (0xf=20
> << chan) instead of GENMASK(x + 3, x) to avoid unsafe macro.
>=20
> Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")

You need to point out an existing usage where this is causing problems, oth=
erwise this is not a fix.

And squash the two patches together, it's going to be easier to review.
