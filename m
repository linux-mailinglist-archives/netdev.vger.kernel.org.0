Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8982D52997E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiEQGYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiEQGYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:24:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7BB443EB;
        Mon, 16 May 2022 23:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652768678; x=1684304678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qg8DqPwvXzHwv6YFGt7PUXssVRix+XcQhF8KEg9IAbg=;
  b=VT7B49KhTYLZd0uM3oJMcjyipLJ1HfvzaIWA4OXdA6UUPMskkYI1E8Zs
   awb+wrXnLbNM7PU6ZHgYfVCb6oqirSjL/lvALdp9bOD2zxd/txL56lhKR
   I8XYeV7oXGl4W2KqggCDXIJZPl0onts4DoC4NVODmrCel4LEWNm6/w9xl
   pIIOLPP5cQvPDCh+euRje1Sbdkf2ts576CECTzNjn9qtS0RF4mvCj1l/h
   RSU1UrzrBMTlzEu+COT6uNnC96TVGL8YDvENm2ol+shg/m8EOfGo0Z0vB
   Aud7VHdsSURKXhTPLBhAKBZNghNyxLuWbewBdlPUkZ099T3lbssm8qOkT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="271022120"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="271022120"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 23:23:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="741619044"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2022 23:23:57 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 16 May 2022 23:23:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 16 May 2022 23:23:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 16 May 2022 23:23:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAFVQkLFh9bucS5CfcLWklThZw/n2B4k4UQ9Z9e4Q5xJlFye5xNu5c3YiYCs665UdgNjhNgZw8GZurdnS1DG+ZYSKWzuoxWUIl7ERLuT/GRvsCxB+jSS17TiQlnJEKS4fzJ5FzY7U23xKlGffQr0ZZ6rlu1blv/3QPPAdmMIV4Xe4KdNV2tuC3UxbfpD01sxQB1hBxCtx+rjqfxf3zc+xoSrXE4up/B34cw7lvYNxzeSitNqxnWwO5pfAkiB1XRZOIRrnNjhDRXO+8kb7RXRWWbwNTb5z7nyF1tH9Zpm0Xmbc8aYB2so8UeFiZDf+CAdRrjItUSkqGSdmUa5jeWI7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cf/6GqQakmk2M56CJX6PEdCOU6FMsC00efeeAZ6+UN0=;
 b=K1B3mgl1+kmBTDxIYmFtYuJCR9HsPuTTCUIzFLECbX0Ty6WEYOQSG3hq30cf1DQH99/bDO9aEqmEJQuqa9mRm+oigIsGAB8SoVwSqYdyHahmv/nAF2cKG+30EXZyxBp+JQIBSTDRQW/b5ndHt1aBHzrXAihiAcRAKwkDvc2/XL/Hr8OlPIS67G1vKbw6rBJmj7NeH4Q4V5SKYGHmFE/hO33qsIijqobbgbMNdDwTpRHQ7yLBBQjMPm40KtxQi5uZkakTpu0fcvwNp9CbD1UwhyDGl0TM8rBLfkR9ut313qd+vTSQMlBUIQAn/JRNhogTB0SfpUVYtvpnLV6nxnZ0QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by DS7PR11MB6014.namprd11.prod.outlook.com (2603:10b6:8:73::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 06:23:53 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 06:23:53 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Kevin Mitchell <kevmitch@arista.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takuma Ueba <t.ueba11@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] igb: skip phy status check where
 unavailable
Thread-Topic: [Intel-wired-lan] [PATCH] igb: skip phy status check where
 unavailable
Thread-Index: AQHYXiyXdlo1dFaWAkKS1NtVi+QR/a0isOFw
Date:   Tue, 17 May 2022 06:23:52 +0000
Message-ID: <BYAPR11MB33679FBF58306FE9FFCF8267FCCE9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220429235554.13290-1-kevmitch@arista.com>
In-Reply-To: <20220429235554.13290-1-kevmitch@arista.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5839313a-59e2-453b-fac5-08da37cdd066
x-ms-traffictypediagnostic: DS7PR11MB6014:EE_
x-microsoft-antispam-prvs: <DS7PR11MB60143D5A1AE8D350642AC069FCCE9@DS7PR11MB6014.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BbEIVDxNZtJM2rSUO2qqJDIeXsos6kfTZHAdjXTRjbf5P9aCXeReEC52kBXUy5xLThoiVoEMsMZrrYLCvHGg6j1xxxtlEIcU4aP3AQzCHy2WUhSWNfItE4VrrXOU0w8UrTuXvds77amUMApgjMuj54J9TRwaXF2O1DVGTtrJAEnRtXnp+ngkzxddDZsjdgmHy303P6ND6QZanoOs5D1xmekoD1NnhTBkuhsCUCDOtzr4GfEyy3ofeJhUsLiTapzxSt92hv7ATV6jiM5qrIlaWKj9Xbl7pYjVFI29taz20KuGH13qoQEzOEnbVmBCtsW5hDoUOBWHih2EE5dJxh2JDB6ZlBVkkWMKpAPtPuLjCTNsf1R2YbY8afR0I7g9/JsiQ3y8LCeLcOmutCIzSJ0Zj0zPB3xcwQpZE4sz2kKiI26TFNKlcDRe26FPdUm4QzAwabIBYcV3ki7IRub3wkLQNUPsrASAZyziT5ILBLGdDDWNXRQGOsayPD+iKzdFWOxwCqGC0PJFqeCvSERorT1u9gbIKPdI0yHNdv9IoL+RdHdiBCuSbyrYfEIySWWtxnv+v1QXzdhjM8IqZ+HJde6GQbTMpBWQBLMuaxOAuiuYCAPQ61XY1CO4NTg8Ppz2IbwiZYp5SYRLMDu7cf6ghknTm2Os/22kCakn80LyNcSlR3P6j7kYv2rc8lEP8VgFE8y4sEGtM0eZyjxMGgUc2n8qhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(55236004)(55016003)(8936002)(52536014)(38100700002)(33656002)(7696005)(9686003)(2906002)(71200400001)(26005)(6506007)(5660300002)(66476007)(66446008)(8676002)(6916009)(38070700005)(122000001)(316002)(83380400001)(82960400001)(54906003)(66946007)(66556008)(76116006)(64756008)(186003)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8bWaQsSR0ADcUipYB/DX0eGyz9sf6NMhJt8r5iSQa42qeAnDYfPZfRaVfvZU?=
 =?us-ascii?Q?2qDere+ZeCACyA1gfV9q1Civs/pQ3iElA8M77uCM67yXEWtC3cLGU8yP1QLG?=
 =?us-ascii?Q?yVJUwqTmSP6N/BTMlZ/nloSkXuAGUcp5LVpxy7lrRV09ZZNA6WPiic9Rsjvp?=
 =?us-ascii?Q?PIXpR4zHDgK6FfGBKPLz94EIa/5iquwwKLVv3DDexE78l3fsFdwCsM4tstcq?=
 =?us-ascii?Q?9gnIkxenOCbHZt2OpY6xWZfqw49jYHA58DxR95ky7yfOItFhsheUCWNnQH2m?=
 =?us-ascii?Q?Iu1xXRF6xMR+y+KaTVr6vYuFFl8FghavWyrDFJzJLb9X4XD92nwA21/KlM48?=
 =?us-ascii?Q?vcpd2BUSP5arW9DxUptmHYhv+G1AH8576K/v6prT3bJrplrkealaaTW8D/zu?=
 =?us-ascii?Q?/c5QMDBXrEQ3utibHZqJsSqej/pgoUaT2o6Vc6NF0IQ/4g0Z/TZ4aOBQdoo6?=
 =?us-ascii?Q?UCnWnCbbpBOay1+V68nQyiuMdR645kBuFU/NL2ZdFxbDnEF5LX43kNalxbm0?=
 =?us-ascii?Q?sTbiC8fpNFJlSKF+EmGAMV8mCpXo5H4uJl0MahiwKhEr3G/3VXyMHa8hL3tW?=
 =?us-ascii?Q?VeVuZCrTawSrJZehkCKaaU+ULF9ShMZVoEenCtpkgneO+FUecvAGMOnTrcy5?=
 =?us-ascii?Q?u9bfs1Fpy2vF19GTT6kZhxBd/x0sKPaWtHfQnpo8+pEBDgSPV+LB1B61pZ6z?=
 =?us-ascii?Q?ZbeuJ4Ybhz3efb+EL3Iu6nyKKjpwodUIxKQZlTBEMas6DKNylutCXhgsh0id?=
 =?us-ascii?Q?erRGGResNcuXrJfjrTpJ8gMQEGNd4Q2jl90GOV24+0tU+Kgrzk0+TSsUPVQA?=
 =?us-ascii?Q?K6OXHGGtTMbxLjXPQ+6vM1Qs+/E8Fitw3qZSelXWXxVSDqCQJZeGvHvV61dl?=
 =?us-ascii?Q?ldAzT9dQbsXqQf2Vgo/rsTwr2CTBN6yUMKZ/amlvkgbZFLh50kzk1jic5tw9?=
 =?us-ascii?Q?MfA6EPF/cRWBkSpCVNee8xHILIGlbbf+J+Tnx2gPw7XRsWh6nkPP7thht665?=
 =?us-ascii?Q?P/ovACwGuTWzwk1ZzK7CgE2jbDZQ4tZ3j/sE5GFsAPC2VQO6Z7UW316DM1uT?=
 =?us-ascii?Q?szZ+gc51bNsPhEx9Y6iKw5Rex45QAzsrVSbkjlwFfb6D7VczW2USN/mpEXnz?=
 =?us-ascii?Q?1H7zrpYH4uqVAE035elbEFaYagQU/nUFtA+Vw1nvkx+jd0biiIFv43e+0zQv?=
 =?us-ascii?Q?vMRyPG+p4g0VVNN07Cr5SyJ5iHXLiJCnu6nR8lppZwfPSmbgpYtI2eu/4/fB?=
 =?us-ascii?Q?9bPb3MIfTfxYPnZnpLpaDNy+gvOYAHV0LiT1zUwH0ij+KcL1FNspSvwfbELE?=
 =?us-ascii?Q?MkPgGF+WhtIThAZHe4mceFJBllM3QhrkZno9W7P0JWIzT+3dlsxjILY6rRFd?=
 =?us-ascii?Q?UfC4uyq1QHZNbVv9X0LWBiUwK3DQTzxNmlr/cFu0fIpaQEF7oRYrKp0BeiRn?=
 =?us-ascii?Q?dRLS55U87unCOSe94HcbhILcr0xxhFs2TeRlYh4P+eMGNa+eE1ohx6QN69Cn?=
 =?us-ascii?Q?IDdhli/4ap3fdT46fhu4zoJ/NwAQLyDIxucXe1KiNmlP2bLbAfT/ioZJtb8h?=
 =?us-ascii?Q?VnQ789PJZnU14VrkS/k+xFsTNio1xQgKOxhkmnmw9AvNWggbKTBTIf3vInIq?=
 =?us-ascii?Q?06JbIdXy8WBvIwzZUBAJLWZ6SfedahReczU81tG5M/0lTxg7k5Jj2+dq8VNO?=
 =?us-ascii?Q?D3/dbMhb5VkAM1zZ+vfHKCcGQjogPkUYY9tovVi9nDwzApQopI+hkiH2TXMU?=
 =?us-ascii?Q?XJvt/sgApQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5839313a-59e2-453b-fac5-08da37cdd066
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 06:23:53.0110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JsOa63VC8/Ohu75NY7O3kVhWDDJ8y3q66HNkyz0X4MLyi0Q8F5u4vH6IYRK14sFzxgCRlBoVUxW9vBCjczXVhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6014
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Kevin Mitchell
> Sent: Saturday, April 30, 2022 5:26 AM
> Cc: kevmitch@arista.com; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; Takuma Ueba <t.ueba11@gmail.com>; Jeff Kirsher
> <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] igb: skip phy status check where
> unavailable
>=20
> igb_read_phy_reg() will silently return, leaving phy_data untouched, if
> hw->ops.read_reg isn't set. Depending on the uninitialized value of
> phy_data, this led to the phy status check either succeeding immediately =
or
> looping continuously for 2 seconds before emitting a noisy err-level time=
out.
> This message went out to the console even though there was no actual
> problem.
>=20
> Instead, first check if there is read_reg function pointer. If not, proce=
ed
> without trying to check the phy status register.
>=20
> Fixes: b72f3f72005d ("igb: When GbE link up, wait for Remote receiver sta=
tus
> condition")
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
