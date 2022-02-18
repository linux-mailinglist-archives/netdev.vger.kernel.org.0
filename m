Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B14BBEE8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238895AbiBRSCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:02:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238892AbiBRSCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:02:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9E84DF47;
        Fri, 18 Feb 2022 10:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645207316; x=1676743316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NKk2AcT8d2ACrNUuTLkp0x8Je+wUnb3qXXp+IQOjBcM=;
  b=H7/R844fP4YYswKjEiazDBFmuE+OcZ0rY7q64a67SS7oGIRx1Xi225f3
   Zv2y+dOh7oxvzze8Ur2fl+daxBU1rufS6RP5bJZefoZIiiSEIeiA3HMCj
   RpwrtHlOy/nJ+MfyHiXVcv1Ux5vgKlmYT9PxrmA5ouPl9yDsxk+AYHAUk
   hXpPYak9QmIr573CamSRAU+UBY6qPj4LcphHG2/27ZkxmXhQIu295LvOm
   2+t2HeNVWwMO9tjSwCpqyKCh4rOvK+bTdlGdLNH+BYBA4bCH7qIBbDDVh
   vazMDmsl631TTQwtgekJJLc9gWHlJWmL3YKHOyoJFbduXfFK0+/CJZ7my
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="231814672"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="231814672"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 10:01:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="605619723"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 18 Feb 2022 10:01:55 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 10:01:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 10:01:54 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 18 Feb 2022 10:01:54 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 18 Feb 2022 10:01:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BG7nQAgSPUL3Qy7OB94ADyD3oRtaMuRCz9TROUTEBCAvZ1Gu6iWbxXV6MjeMz8JqMKiACxY5QXDJvExEnVp2BDiMLdXi2S1ZKUSV69+DA7c0xyThJBp/kqbBW1i85jcgvaLrOlOyjvG2a5hGqApaguLCLqhE7NHCJSyPgzClAXk097edRijwn2oyFsazlFoqsTENZfADAk54bChFBoYcV75Wh3Rdd7SHBt7hj5e3LBw2X5q3MhfFcj3TGUzLHlRmmpYlsT8oj2x6QOQOP76rsfAhgFhLD1nNN6NJbP2EHDNf2rgcNNquO5NKlHEDaoajHxuVGDqKZkHrYbMfKE+W9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZCjAnUM3ROu/yWSUFwjbqdLxJoEdQOuVvZqmI15Fo4=;
 b=Z4whIeXxlDgg8ZaN7ykUKVOlj7Cy6FT1uYk9fugbRqT7VBMRFbDKDpF2ErA5RJN9EIrPC4cfr9saKu6ZtVvmPPQnJqlft0zHQcDXi+pCu+I/dbqB0+FecH+/R04j25q5YQNNvsm7IhPcHxBvWUzCpS66RTikUA5qq2O67iu/CExPtCaDj3/+hxDNyRguPCbWnjBumLLxk9hF76/WBwSqJSRZJqpmdPu0B2SR4J+4JxzfgdeZT1c30axbt92frbqj9hTrG60sj36DSK9keH8dF4EVn3HsLgzCAkcgrxNtqzSizxVt1bPRTI2BimAdQaElu1x6AbkzqJV1rCkVXOTuMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MWHPR1101MB2255.namprd11.prod.outlook.com (2603:10b6:301:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 18:01:51 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 18:01:51 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: check the return of
 ice_ptp_gettimex64
Thread-Topic: [Intel-wired-lan] [PATCH] ice: check the return of
 ice_ptp_gettimex64
Thread-Index: AQHYIbG+aYlRzzbpbUaTCA/b0E7pgqyZn6yw
Date:   Fri, 18 Feb 2022 18:01:51 +0000
Message-ID: <BYAPR11MB336703B0319EADCC0EC3AEC6FC379@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220214143327.2884183-1-trix@redhat.com>
In-Reply-To: <20220214143327.2884183-1-trix@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a52ea4a-9052-4b05-c72b-08d9f308bd96
x-ms-traffictypediagnostic: MWHPR1101MB2255:EE_
x-microsoft-antispam-prvs: <MWHPR1101MB22552CD01272076A69DCC297FC379@MWHPR1101MB2255.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:534;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KbVMunEAi5nq8448+iIP/RinN74/gunokjGraQaGGIpcnpmC+TzKIkV/S6ip6f//F64ZtG2ASeJsP/iYkiJ/l6qgexbO41V7ANvJDb6L/Gb3DputoCv2Pis9OSbXBJ+hGms1iPZvURGygaodSBUPWV2D62owh+bPjSgvXfCJk6NgK5eY9j/fsJ9A3xdXImbvHK56l3OKfYXlxw8TdYzatAdER6wk8XC/q+AGtlMHubVXrUnYS//AM1JdN/lC8VPyQkv4YKdAAA+fvVofXgFrAR03h9D76OY/Llb6R+gFAg1NoAtl1NX24waPJ9hpvci5Jno5yjob9K4g6Tg0yVbqOvTDnsOkgZCOPPH6H/KLDF0Xux2uuT01NOr/9v3o3trQkwntGLIPCge++1RzEt22R5Tkjd+6+NKi8D+1sSXchOBNLSW7AemNtntdPUBHNqmcVEoPKF3FLna7SkB//FxkI3jsGTDKiCgTSnzoVrHYwKPf3OgycwA6L+FJRqVQIwOLuyIB+z6Woqhez5rfA7ey9kQ7C8pn4h0STvbgQnhNUsfBoHRi3XOIqYypNRWKXjlMxlThwjX+QKs4bRtkF1CXFhxccGRc9IQsNI2bUjIsCETm7Ymp4wGq57CDBfHXNZk+GlmHr3npg55dZ94nPVL3nxawYzMtzcynOL3V4knDAgV+QF9cqSEyXcVSvzUqTCAWAKqle3tJEWmCp34ZfRMaLJRYterr/gJ1059ZpYPk8ww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(122000001)(8936002)(9686003)(83380400001)(86362001)(5660300002)(7696005)(6506007)(52536014)(82960400001)(38100700002)(33656002)(71200400001)(4326008)(921005)(76116006)(66556008)(66476007)(66446008)(64756008)(8676002)(508600001)(66946007)(55016003)(38070700005)(54906003)(110136005)(186003)(26005)(6636002)(53546011)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kWF3kw1m1sTXe7HXiiFAetzKfcnOBLnVn8K05jwc/aoMwX6k3XqN6BGcREKE?=
 =?us-ascii?Q?53byi1jyjKetL8MG7oGWNCnCVwJYi+AGEmBF9XXl7uj9DMB4g+Lcr8q9e+4e?=
 =?us-ascii?Q?jv603vaBJHWGgKCQGTryr5opaEuuaDsC+PjP/ly2psADQ82HLYbLfQzLX2Im?=
 =?us-ascii?Q?zSdmzowfIm+laTzEouIuge+RtvzLMIaGB1r5KICm+3taCvl0z35puzQjiRml?=
 =?us-ascii?Q?74eUA1FLcST7ZzTpLjpg3zV6DlsUvplPqf3y5aoyyfEgCjfUC/edDeCMzH3s?=
 =?us-ascii?Q?gg0hEFrAkjUywYOj0qrfPc1JN9TSlqROg01XPmMDAT7X1JNOh5GtWwaglz5B?=
 =?us-ascii?Q?Cf/DeBtw1Jp/qjC3/a0ALMV3gDlpKJ60oQlFuzRpLggh0d86vY6c40Ybv6os?=
 =?us-ascii?Q?SCkYtv1I+nR2cLfs2+LNnzTqVG3R29MvTgisCoFff/TTokcNNeXthvWqwfxk?=
 =?us-ascii?Q?cHl8m4+rwEAH+wItq5HMjqFHkE39bjPrIfsEcHMqORjVrdM+XIoAW6Ssiam6?=
 =?us-ascii?Q?jJifgrQg5GuMrbOwhyg70wx6EKJ5SmKGSVRa2ak2s+T8Y8l6AF5eHzJRiUwR?=
 =?us-ascii?Q?1zdu4s+SJgA2dxFKulUZixcnOXAvvI28R02h5UzkvLBFg/Ziz3UeAdgC+vHE?=
 =?us-ascii?Q?EgsZXBxkqDjNEsQ8Cxzc0sWAOBt4c0ubdvC3fFpv8fcVtZkmxKBNkgQf30/N?=
 =?us-ascii?Q?TgiVIdbORqSfsjhSSputxLTQnxTsvN7YGrgvrFH3fJtgPtaAURn+d3bZmpY5?=
 =?us-ascii?Q?52kwgosAwfnyUPZ3zxtZekJ6FusEmAr6q3+8Swif5c8yPMdMX3BabiKHks9B?=
 =?us-ascii?Q?gI0ClUVnAUCeq3G43w+Pf48AClju+xQeA53pIglLAx92dyfOmohcf5aDD3L9?=
 =?us-ascii?Q?xKUVbkSJxyxz3smEMAH0fjAnyaqy4KaeKjqNAJnQkJQWRKD1unfO24X/gN30?=
 =?us-ascii?Q?81fI85uCCczdec2bEgQLqWb7lNI0azn+QyeCMKECDj/damQTXkEceglou8o4?=
 =?us-ascii?Q?coK3Y4sp1lBmWWkDdgR07SWUyBE+EgDrEYThWzGFton7cwhf+4ermcgIDvbJ?=
 =?us-ascii?Q?Y6694Z56Z/NHTDDQHh07/9k6l5MUtrTiAdHPSVgWxGRYqPSBVQjOBOZCQzaZ?=
 =?us-ascii?Q?VGcLv06Y1gRZ4Ge8y5gZBwl3Mx/aEkGpH8gJgxRWq8VRpm0uqIG1KImrPAGd?=
 =?us-ascii?Q?0axeym0gGT9fio2i111KOvFtiwKiVThZFg/n0vMDafOztBXDGevCWc3hh6WX?=
 =?us-ascii?Q?V7rGu25my2K3O7/3UZ0wHwQfAa3jbGLqrfAfeDftB+d6fytD9L2oT274LhZD?=
 =?us-ascii?Q?AlRGJiY4bdE8Yss+unraF4ljAk9FSVq3yMjDMHkfjl3nqqwp2diVZ4VBO8Cw?=
 =?us-ascii?Q?t9/6vTIebSmQOcHkTnzlS5qMQ8Lfsk6f+CNxAbXeKjiJrQPBEIgN22qOYOg5?=
 =?us-ascii?Q?rkLs5HGimn6GDSIR3WSesMjVpX4gHDGQreI6YV+lFsVMjIMdXHR7HgG//vaY?=
 =?us-ascii?Q?xVDdxZW7Y+zuMsD6+op7pUX6yZG9wc/kkRn5kJisazcIOmoM9Um3XNCp/0y3?=
 =?us-ascii?Q?NqAWJA4qi0GW3Ez7uefT43rj9wfbyvARbA+RcKsgJt3BF0p3uw3u9F4wzwu4?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a52ea4a-9052-4b05-c72b-08d9f308bd96
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 18:01:51.4449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2a+wC8cEEKfG2Qxts8NspH91OQL7E2RhrmfTJ+IK0jzp4e73/0J1TaevB4mvT2g7SvlljtjBstqystj7WvtFnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> trix@redhat.com
> Sent: Monday, February 14, 2022 8:03 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> nathan@kernel.org; ndesaulniers@google.com; Keller, Jacob E
> <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; llvm@lists.linux.dev; intel-wired-
> lan@lists.osuosl.org; linux-kernel@vger.kernel.org; Tom Rix
> <trix@redhat.com>
> Subject: [Intel-wired-lan] [PATCH] ice: check the return of
> ice_ptp_gettimex64
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> Clang static analysis reports this issue
> time64.h:69:50: warning: The left operand of '+'
>   is a garbage value
>   set_normalized_timespec64(&ts_delta, lhs.tv_sec + rhs.tv_sec,
>                                        ~~~~~~~~~~ ^ In ice_ptp_adjtime_no=
natomic(), the
> timespec64 variable 'now'
> is set by ice_ptp_gettimex64().  This function can fail with -EBUSY, so '=
now'
> can have a gargbage value.
> So check the return.
>=20
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810
> devices")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
