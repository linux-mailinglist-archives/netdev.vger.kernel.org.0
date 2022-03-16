Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F189E4DAA7E
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 07:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353782AbiCPGPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 02:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbiCPGPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 02:15:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EBC340CA;
        Tue, 15 Mar 2022 23:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647411273; x=1678947273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oRZ2kyfXQEZBfhEvbJqH1ebiV5fhOMT9+fkYV2aQKXU=;
  b=eFuc0+31Glny3XjA528VWQReYe2aGEEZ8siesCKzY4sAY3C0V9LV4nn6
   0NfR8t8A3t/Z6DaR5bUf+zJ4GdI9TNRDbWV8sHggqX/CrkUBoLwyGWu0k
   L/NPaVylYBDPrsx2SayGCLnplIVLxNXLGJXNS3jNY0TtDxW3fhbdDrwpd
   aJL8d2/L/w8MHtUzz29tnYmDKVyW8/sKfO611uP0tfY2pcBvk1PtwW/6e
   IRS0CK32lqMIbakpokFa8BPbT7GnJAlPLE1Pa3Ps+xEf6mSlIK6NxFFq+
   JBm0ldnCsdqgs8s9ZziBqcLdNboEwIODeVPhbwQYkD1iausdDGDQJul8d
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="243955914"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="243955914"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 23:14:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="613527070"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 15 Mar 2022 23:14:32 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 23:14:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 15 Mar 2022 23:14:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 15 Mar 2022 23:14:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXWGM/v7JpgROb8CORpyq0TPkni7Yi8/Vy1uD1GapuP03jIUTcLhZR2XzgubMwv9DfPOVb9oAL9cWD/8kUOhNwLsk6AxWdBWM0y6Vymt8rXMUEWZqaGOa0APE5hy2hccFFQfa6xtBzBx/AUt3nH1/4kzpV7v6eTe8Srx8L/ixJS25aKjvxKXSH7SOW5SX641W8wReVfp866ZqovYzkgwNh+wjF0ti7QtR9VvpkzxkQWieaVB1vg8JMudxjE7hi0JFt/jSikAniMTYPB6DD0VgLyffQwqvRFhXSuKhpMSthlIruDUif9Y7FBOkFbUzaCsgAUzZrCFhLssozjfGwtvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kawNmd2gJILum81JFNbz0vQE6pgsvo/fkdaQXgHlmRs=;
 b=Oli1CNPUh3b4ZHrBBFybI+Jn6/ITGPaeletKoFaG7IOcIKVQpFEvQjN46A7dmME/Dbc055Uu8VNGnHmc6yys47YxHME0lxH0mt0QoK+skI8GtRviB8zmVTfPoToxlQg31K8y4JMVA98P2igtGusQgeM+uKXy+H1ctvEDTQ7iVdGG7aG76usbBmZxrlIUvKUACzghaX6Hw1GZlvkBsI21L15qs8/icDwn1VxbPGGw/ENgitmqrO/5tqoeTPwgwWVCSH1sNRBCX1di8BxJn7ZAlYgtzRK8+mTix4Jzp8nqp1BBFweh4YQqnd7wpCPqbNuvKwd1kwTh+h2wuN+m6evZqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by DM6PR11MB4218.namprd11.prod.outlook.com (2603:10b6:5:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 06:14:24 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::8113:f21a:30e7:26db]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::8113:f21a:30e7:26db%4]) with mapi id 15.20.5061.026; Wed, 16 Mar 2022
 06:14:24 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] igb: zero hwtstamp by default
Thread-Topic: [Intel-wired-lan] [PATCH] igb: zero hwtstamp by default
Thread-Index: AQHYNutt+L5RW/R3dE+eXMovLeKQLKzBjDKA
Date:   Wed, 16 Mar 2022 06:14:24 +0000
Message-ID: <BYAPR11MB3367BC9F34175A1D52EB68D4FC119@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220313150210.1508203-1-trix@redhat.com>
In-Reply-To: <20220313150210.1508203-1-trix@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 102e11a9-f5c1-4dab-63e5-08da0714380e
x-ms-traffictypediagnostic: DM6PR11MB4218:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4218720A9AADD7E6E6D1FE21FC119@DM6PR11MB4218.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b7AK/oiMZSKkXVHOaQQmEPsAhyTz+TTSJpsRi/A88fgIn5DyvwQd0LvPeAVZ0lSthOR6LVa/4HKWhxQCJgaGc1IlZWQ1ZJsBHeGqQeTKe/123qr3//R0LJqGUC4EfT7/Vdw28YjL4Fcg8nWVlYIKLCyLVEj/l6kNn0sayTy+iUb95S5mpG7yqwIwlUnZQ60q4MwV/Weo8mGqx+f95oJGpfFldT3iKPwzCWiwdVHTbmdKw/rTPqJx65HEnOVQBcEKM+R7EqI4C9VWmkpX3Q+qUNtm9986mz2plqGxr69jBVv9LR+12Ao77BaxSakNslSSSgAsm99KdTUbbkqSVfzY0ZItWvyoIlXH8IVexrx3fI8ZgxsDUfAW07skgk5I/+u0zTasDKYqIdbm3oEUGZ7nPIfJjp+Qkg2WJfyUmSm3H/PN1w5AU3nZ+coqoxjFuwfkOzkt+kQd2sMzYXypinwV62M59cp7r2UFVr28Z4XgaIV/vI3bq4HDa4JAlAmtUIwwjKVxSEXJ3bMQ5m5WTAMPEAIxE8vcvL7KaDW8gCWaRpxAVhUpXvpDOSJJMvV4AGp7t7c/9rrRlYKbhcNe7vMOYoe895HahghkStwbax2LLVZMlKRYLpiogDpeu6xwpjRL1ujnbYCT2ASBsDck6DHyzqAqPAVlczqHgXtlSAwL0azt8vzxSfalDUIapw5xYTn2/xvChRDIHNQopgN2LVdBkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(122000001)(71200400001)(82960400001)(508600001)(66556008)(38100700002)(76116006)(66476007)(66446008)(64756008)(66946007)(110136005)(316002)(8676002)(86362001)(54906003)(26005)(186003)(4326008)(53546011)(9686003)(7696005)(6506007)(83380400001)(2906002)(33656002)(8936002)(52536014)(55016003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qAkHyJ2Nrvh4QKhIknWOUIHM1teu49ZZp6GRD5ce0PacH+GVQ+Vp8DITG12x?=
 =?us-ascii?Q?6RzuYClgb3YaVL5Pmhn8abukYQU/fZ76xTTJ1QQdmJgLS0Qa4Ofgx89ZUAiu?=
 =?us-ascii?Q?Fkvfr39XhGIzAEbuuQXob6AKHn06kGq5H7W1iMF4cQ3zu3UNz7Sdzo9zQoaD?=
 =?us-ascii?Q?9ctZSfGdBeYFg54v+KM1r60EVwz9kUCHqrDunCwy/OQotQnEGJV7+hcapC0Q?=
 =?us-ascii?Q?tGMybYPNXCTXGjjwvuCplYGMx0T6/dvPMHmPJ61pI6R/SstIQK7Yac8Zm+rm?=
 =?us-ascii?Q?2BtCQyF0yxC8T5HRXkNb3ypIelrNpPjya0iVNlCLrhNcbP/B12IJuXCvbuMg?=
 =?us-ascii?Q?sHjsCqDDCTIsKISCo/sUaDb5CHZlZ7VW986BsSvtKm2dVR9rW1hehWnn4UEZ?=
 =?us-ascii?Q?Jwn6sCiypibcySYkLgKs1Xb47jrYtwOx4Te6xoOJIK5B1aoTbSTzuP/0788F?=
 =?us-ascii?Q?X1VxM5q5u6VEhNnVGJaVuEGNnOFg8iWVQNUwQwWihqPsfdBuVRmiP5Xberyy?=
 =?us-ascii?Q?+L4CoIsyVESjgg9vogP58hWS0yU9YxAEaJdATwiYufpuouvKBpcFXtpAlliF?=
 =?us-ascii?Q?O5hE5qNV8wvzPD/CxL+r0cHvJqr2xmEZLc2gtDPVqLIsGwb334YTt4bux8tB?=
 =?us-ascii?Q?XKfxI1Vp5+tB6/dMEGyIjIInqi61HfSojffaL7HCMVoJQlTURps8/i2NBzxq?=
 =?us-ascii?Q?jXLNDNAzzRvXWNPL3/fueHr7jFxal6ibwHbX/SyO/W/mDMvqALeMj+wg+o3w?=
 =?us-ascii?Q?h1QsHqYKdHJapqiJYXeoUhAZgFELxEiSMaY5r1Bhq8P9FY/Y/C6IGqABqsP1?=
 =?us-ascii?Q?FOhraD3mhpwF2X11jhnrr4jJIB6xbV21JIAEYh6i/c6xkNl9/BkP+YIjoMsi?=
 =?us-ascii?Q?dTXP8i0zbWl63FKsp6/THBR6gsg6HpyIg12NLezHjpBA8jGEiq5KdgqLBzp7?=
 =?us-ascii?Q?rx3iNOQp6WNP9o0iph4lz3as3nyBFPu4562csGPqqYfTHEZRdioFoCj35bFP?=
 =?us-ascii?Q?yq1e15BzL3O4IvukXR97y9ampAe6sOkXDWX72iuZPqYsVae1LDgeNjuoAQ/y?=
 =?us-ascii?Q?Pf6AoQFKAWWbxd6kzimmL1xPKyj2y8Ui3Ak0/iwRiE6vxdT0GsZ9rBzNZ2LW?=
 =?us-ascii?Q?O9LCnpZrHAViSWKWm9O5aszjHnxKqbMXR0b2Ja/u+m9NvQW+1YoWG2tBpP1T?=
 =?us-ascii?Q?aRr8Einvv5BKiKt8Zwas3MA4EAm0Wt9zDt4zKe3BnRL4KMsGf1GD2JF0V3OW?=
 =?us-ascii?Q?TOlefG1ezzWzM0mjoQiAPbYHAxCa1oaMOKnkA9LJEH2LZS1LNxluxUl5KPuI?=
 =?us-ascii?Q?5B+FvLoFv2VHCiSosL22MzX/xGPrFnbaIQdUyAP1Nqbeeitb4rCiGy0INhbx?=
 =?us-ascii?Q?CmyuLaB8PbFtEY9TmyW2aNWisEhFOU/rEh4OuFbIPn2snZdcfNbWGmZ+Reip?=
 =?us-ascii?Q?wr1hYhI6iAYinGssXLG+wSU/Ab3X0nQh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102e11a9-f5c1-4dab-63e5-08da0714380e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 06:14:24.6460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZ04nw5ALHR7JUVD8nAEKKO3gtv3eNptDaHMbHhuLt+PLweJnn8tHHB1AxjFeupfpbL0JIGHaaHsOTTHpCBTwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4218
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> trix@redhat.com
> Sent: Sunday, March 13, 2022 8:32 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> nathan@kernel.org; ndesaulniers@google.com
> Cc: netdev@vger.kernel.org; llvm@lists.linux.dev; intel-wired-
> lan@lists.osuosl.org; linux-kernel@vger.kernel.org; Tom Rix
> <trix@redhat.com>
> Subject: [Intel-wired-lan] [PATCH] igb: zero hwtstamp by default
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> Clang static analysis reports this representative issue
> igb_ptp.c:997:3: warning: The left operand of '+' is a
>   garbage value
>   ktime_add_ns(shhwtstamps.hwtstamp, adjust);
>   ^            ~~~~~~~~~~~~~~~~~~~~
>=20
> shhwtstamps.hwtstamp is set by a call to igb_ptp_systim_to_hwtstamp().  I=
n
> the switch-statement for the hw type, the hwtstamp is zeroed for matches
> but not the default case.  Move the memset out of switch-statement.  This
> degarbages the default case and reduces the size.
>=20
> Some whitespace cleanup of empty lines
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
