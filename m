Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21E42F5BD
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 16:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhJOOne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 10:43:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:60403 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240609AbhJOOnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 10:43:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="225386867"
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="225386867"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 07:41:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="571778219"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 15 Oct 2021 07:41:07 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 07:41:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 07:41:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 07:41:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7o4Gp/N69ZceNZuVuNPqk3nXmY1Z9bS3B6P1nKHRxCib+M1raL9IiixY4iuI1FZI6tdfkK9Y7rHFX34oRYPIDJbe98ZdXs78hQ6u5r0Tm7GKXPL/RHRnCXuxS0IvjFeswF7TUpDZCRFYUhpyOt2h2SXRRD9GiRQUKGTnIQHeHsY0Z81ApEFHiiED/EMG1bvA0rJs36t5zmineandr3UhgL6SpKXLVvZWbx4/tr42ZQ3jlooCt0FxUS9Hi07GfBcye+QkF/FrlCTTRXkF98l4Z5TG8Tgm9HTBbPPW6ibthmybZi4bAtANcLCptD+X1vzwIW/4Ud41xlyH6tym3EJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8D/av7bfEF+v6Ik3tTNMhyB5Lk4chPZYgsUJCTKvyEU=;
 b=k3CnM2udyQNxoy0uRf//CmY7mdNdJET9bwxCG5O/G5kHWXy36x5VmgJSy+Lv4Ez65mRcGbf8hDTDJNg3/hmvJAce8OnhqeIiZDSj7B5SfLekZ+lO1/gZVnHdpT6aA6neuwM/Ql8fO0f8XqUfwCGygguDMk7MwW2yiBHg/QYoDSJ+ALHZWUrWpAQHjazxN+bTSAfG2B1wGm4GtrrOFvn0QfOhKe7Vd/hZ+HelkoUqmDAhLFsNeGocfz7tfEfg4W2TJdHA3g9V+6V/Fx60DB9KRSRPTn8BELl1Je/7vKaWvUmRbZKjuepZPrQX31QlK9gURO1bDQg7QszuFTLJUlm0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8D/av7bfEF+v6Ik3tTNMhyB5Lk4chPZYgsUJCTKvyEU=;
 b=M7bn3dB3WE2N3uqMkaC4zojbi99jjbQNzQFlvmO8qa9hC91yOq432b/szq6vcmAqTdpdHEObXhyAaNSkJm27HSj5/cJsR7K+/AlU/yLhoyXyKinq69gOa3MEW8+8W9tZ6oQV5kbqqBf+sLkB67ZgkL5O67TB/lMP1Hhf+Nnk844=
Received: from DM4PR11MB5280.namprd11.prod.outlook.com (2603:10b6:5:38b::18)
 by DM6PR11MB4692.namprd11.prod.outlook.com (2603:10b6:5:2aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 14:41:05 +0000
Received: from DM4PR11MB5280.namprd11.prod.outlook.com
 ([fe80::50ee:dd49:1b33:c557]) by DM4PR11MB5280.namprd11.prod.outlook.com
 ([fe80::50ee:dd49:1b33:c557%2]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 14:41:05 +0000
From:   "Nitka, Grzegorz" <grzegorz.nitka@intel.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Fix missing error code in
 ice_ena_vfs()
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Fix missing error code in
 ice_ena_vfs()
Thread-Index: AQHXwdFF9D9HGiAfhEOILrrrimizZavUIRyw
Date:   Fri, 15 Oct 2021 14:41:05 +0000
Message-ID: <DM4PR11MB528003D5122D7831F9A5F72A92B99@DM4PR11MB5280.namprd11.prod.outlook.com>
References: <1634292249-63098-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1634292249-63098-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc195d64-5fe7-4477-3f8a-08d98fe9d171
x-ms-traffictypediagnostic: DM6PR11MB4692:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB46922A0EE92E4E5DDA3E107892B99@DM6PR11MB4692.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UXR096ZHRMZb/+p+KIxF4AmfS/FgL4flLNnwGaZaZJsLJL+OjDDkv91Pt2SkK7H0TS36t748aI+X2/xaJJbZtkvixLmNBXGMgod2ai0TlJg5MHP0qeqHDdusrFSMzQJvtZdwMiP1KYuSc9GfYDAOwJ6sxnpejPCYd/O34XsPlBZb8CZUP52H4EjyA+Ifh9wS7uNK0siGX96yHgYDSFkS7IbRNdxoM3m3IhGJDkElc+B7NDj/EfNmMpuxYXoboScoLoyXcqoiYPoLLwBmR/CXCVRVRvHQ5Md74RhDRPE9UZCSw8yQfm5izClRQE2TCSDL1y7igm5cNFjtyj19UP0+nnkozpKW9YXQCWruIRm6YX3VUCZ7E0h0CWNtCn80flppHTzs/R6Yf9xAob0ux/r8qbaBXEerQPTatSDxsFchyiPp/x+75QGB85n96hAn6wPcSmj6mpElm706uE9mF/V9drKIW/Ap0a9QHA8rrMdhpIxPpC6nZiQDUiWCIYFWAhLVssJ+H5Q+Poz7m5P0a3j1SILMx2U9j3X50R+h+7Zn1VvQQtZgncEAptctQuIeTpSZqHZKsIvABR64+NLAN9NOnRXiptXFW/9lQa8bPA/ELh8XY9ur6Shov3KZRBKMrYyS6ZnHnVzyllxIxiNjRnM0OBQEJjLbqm+US86xjJscMsq20xo6USyUfxWGQ57MAxL9D6Q1tP9GsbvdHnrREsAEdnU4NoUngv3DWCMUSuPSUe5uWrLkfuip7JSLGjlvOV6K8M0qWue59XUwm0XfPBOolOMcNhqwEAELlZC7jh3QIjlVpEiedllVQAQzF8MOO1869DoBz4dPttpHbnEh6H8/JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5280.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(55016002)(76116006)(66946007)(9686003)(83380400001)(33656002)(508600001)(6636002)(66556008)(7696005)(66476007)(8676002)(4326008)(186003)(6506007)(966005)(53546011)(54906003)(8936002)(122000001)(86362001)(71200400001)(38070700005)(5660300002)(52536014)(26005)(38100700002)(110136005)(82960400001)(64756008)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?coI7zBQ/hX8NcdnmtprgSmK8waRSdHSl9lIaX8TUDjcyc53UPh59nK2FtU7k?=
 =?us-ascii?Q?bRiHlSnUBkBIXFVUsfTfEruSzJ5Vo3jZFW1zIOGCYowC4F1Xx7q0qkVbKC5L?=
 =?us-ascii?Q?ZZxfZw/8dHtmO+dvx0bt8/v/acxbSi1gENzVQP1BNYvWf9hWkTnRDn2dbpMi?=
 =?us-ascii?Q?GflDnPM9pHFGgBwHr08BgXgHPM0lA1F6YVSo1H1NPTI4M/8RJi1rbCwrJ+Ss?=
 =?us-ascii?Q?t6mugLQAURbrY9Xh08lqSu2yc74EGTqQvBEcw4G16EwMy5R9IytM2L46AChk?=
 =?us-ascii?Q?XupT3e1r74BFbS11o86maVrIWcOKAiazKiNLWYWWac8BikDRnSCDH19lo6eb?=
 =?us-ascii?Q?G0Lpuxp/0O1N9y9QPikqFEehzPqdf/Yo8Jk1oXchv/mfEQGFK8N6mgEbAm6U?=
 =?us-ascii?Q?6nvkgeOxdrgoMbNUyHHxh3Yq/tP5lmN250DGVIQwV5WKcmPv25j9xuDFU1P0?=
 =?us-ascii?Q?0DhaJUer4IwOHfsjnHh4x072wpbDhArGNyHEeTx3AUwCZBd3Q7jLHfwhSGir?=
 =?us-ascii?Q?uWntNXgebA1YhlNCJ8JZP1WX2/+ypYivmI9LuMXqhJhGL7RU1DW12ijG3CMw?=
 =?us-ascii?Q?9Sgy81teb4C9UAnvyTiq+cCb51IyU/BkpWwVDHsPD3vTEDdVdDnjjknEjB/Y?=
 =?us-ascii?Q?RmJid+lUXJI/K6JiGv/wPNEG7aFJ3zxr52hgLro63FNSUh8nZBgm5UHAAZy9?=
 =?us-ascii?Q?aAccYXU/yetvow9KteGxob0oLwaBCNqC+YhGh3Zfx7UhqyFo+sXW62DHkPHb?=
 =?us-ascii?Q?4YN1z6hzKsbO9mOt3PYWwmaX6vuNeFHEwRENbg16pAuTPpLg4IKjlXN+4YcF?=
 =?us-ascii?Q?ctpDuBBVHM29vKEuxCcjH7Ma3p42qb42yDWtIc5uqsPTrFrOx42znPRS9kS3?=
 =?us-ascii?Q?YL+2swSDCqJebNeuqYNIY6FiPtcW/CFotRovYPNLd/nZPjc9SW/pS76T7XQH?=
 =?us-ascii?Q?/JAKT1c0S3p15Tsn3ofnoB5xHwjWJX0zeicsrAyme5GUAKRaS7WGreCoRp3I?=
 =?us-ascii?Q?hP+G1vy3bZnMuQeId8aXj0MNVytnFBKYxuDZi8qvKyjCQl8VbxQowOqTFobp?=
 =?us-ascii?Q?C+3w1gIgO/8KxRPGjEqPPbgXO4omtNWfRfu0x23y5q0IFXO40DLcTeqxrSYz?=
 =?us-ascii?Q?APPzXmEN08X/mINhqSkBpI/30hP71YIJlv0+YQnF6suf0mTAPDi5KXaJ4i5p?=
 =?us-ascii?Q?aGjbuxL8V16Z2zNk1aX1JvuCcXN3sO+qR6oKYCDvKWqvBO+tTKAYXdjn4G6d?=
 =?us-ascii?Q?baXis3mp/cfPW+S1iffrj3iNjJswtiq+Wf6RJBdZnQpe2XNQMyy3NbbKY2wS?=
 =?us-ascii?Q?c/IZwxdbuuxGb7RTzSJf5R4o?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5280.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc195d64-5fe7-4477-3f8a-08d98fe9d171
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 14:41:05.2532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JzdlF/WwoTnwBDhIOIGxQ/Gk4VocVMG04+IFFYFxk96Rf0gQYg0ASaGhLq51Gf/5qPr34iMTU1KRhugTHfovgI9hBl+0Cad5fq1rFJ77KG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4692
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Jiapeng Chong
> Sent: Friday, October 15, 2021 12:04 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; kuba@kernel.org; davem@davemloft.net
> Subject: [Intel-wired-lan] [PATCH] ice: Fix missing error code in ice_ena=
_vfs()
>=20
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'ret'.
>=20
> Eliminate the follow smatch warning:
>=20
> drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:1979 ice_ena_vfs()
> warn: missing error code 'ret'.

Seems to be already addressed by Dan Carpenter with this patch:
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20211013080012.G=
B6010@kili/

>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 1c54c839935b ("ice: enable/disable switchdev when managing VFs")
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> index 4d0b643..b2a018c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> @@ -1975,8 +1975,10 @@ static int ice_ena_vfs(struct ice_pf *pf, u16
> num_vfs)
>=20
>  	clear_bit(ICE_VF_DIS, pf->state);
>=20
> -	if (ice_eswitch_configure(pf))
> +	if (ice_eswitch_configure(pf)) {
> +		ret =3D -EINVAL;
>  		goto err_unroll_sriov;
> +	}
>=20
>  	return 0;
>=20
> --
> 1.8.3.1
>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
