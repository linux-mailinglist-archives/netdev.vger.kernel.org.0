Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D42743608D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhJULrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:47:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:50184 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhJULrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:47:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="289855750"
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="289855750"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 04:45:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="534281192"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2021 04:45:19 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 21 Oct 2021 04:45:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 21 Oct 2021 04:45:18 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 21 Oct 2021 04:45:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltaVc0uqGsF4Fl4elPnX6AZQl9dbndUPUBi68ZG+NFR/nZ9vf9E6WMx8sudhwHmrQHOpQd8cg+NxPMsD0qSf1l8dItnEmXC3PQzrePKGaGPSDKWdQlK7qLIUMYP8gAx8nqkgyzayT0nYqlqQjJQwkY7z4gvEo46phlXhNRPVgZgPTxFd178Q9grb2x80lV6mFQF1MR0oLJFMQBOiIbICSknlVnquum4+gBrAx2HvYE+0rnt190LGfej1P6B9CZJJ7YYs1x+8xHEpsM5/CkjXOMzfUHbgv7DrP4GJGSfVdrWu68cS+jHcsYZ1+YlrBckaMpVMtn3zbf84R0cLl7WzFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIdCqW4/gPIhMKUGsvVhQbl+CN/dhuh0RXK+72LjHA0=;
 b=UwZBPU1Sdj1PXyeJbO040z1cOcRfGV2Ll4VZsudT7mnj4ZMNrD+o1C7OcQ/beaV/2AjgB/e3e8UxSkbL6sP0v1SA2ly+O4K4d+6IKERYfLutnKbWyi0N6zSB1ATY3xfUuByg7q62jDv4Kl0+9S52BFPVeVfaTrBXPvxvY5Vv8DtjZRVmwIiLyr8Hru67/j1bRy9tYfkneSXoVcAubYkrdalX/hgxrfCczh0FCIkqM/mj12NJrZr6McQQLWpVAzeC59TlxYr5ZL9uUxOi54576lz4hyCf8ZuF2Bjci7dK0CaYAi4egTUeOE3TH3T1lH2IuflOwQJlGiMP2sRklc92fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIdCqW4/gPIhMKUGsvVhQbl+CN/dhuh0RXK+72LjHA0=;
 b=Hv01+zn+uDVy5Bm5cYcK9jqUGqTqIr8CY5xN+C7OUPOU2IEJo4fv+eQ0oN5/61tR2ufJboJx6Bav01Vvnm4JkpITFx0gkP0PgoRgLpC+tgEf6krqjtkdZBdsf5I1YaCQjM4qRVw2jShGg4AfgByq4ZJOzLi+dSMgbJPPjxdOJiI=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BY5PR11MB3877.namprd11.prod.outlook.com (2603:10b6:a03:186::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 11:45:17 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce%7]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 11:45:16 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Fix clang -Wimplicit-fallthrough
 in ice_pull_qvec_from_rc()
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Fix clang -Wimplicit-fallthrough
 in ice_pull_qvec_from_rc()
Thread-Index: AQHXxOkoZwUNVu8wvkqNs3WbQqJt66vdWECw
Date:   Thu, 21 Oct 2021 11:45:16 +0000
Message-ID: <BYAPR11MB336790EF89C60CA88ACE0F35FCBF9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211019014203.1926130-1-nathan@kernel.org>
In-Reply-To: <20211019014203.1926130-1-nathan@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6691f585-8e7a-41ba-41d0-08d994884087
x-ms-traffictypediagnostic: BY5PR11MB3877:
x-microsoft-antispam-prvs: <BY5PR11MB38773E6E1F565118BE0E60AEFCBF9@BY5PR11MB3877.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1PhXHXCnTxMNf1lvdmOezoM2Zkh54MPsM0Wy1j1mzSHNXD0SN6oJOVZyMS16hOkV8V6bkk6PQAmG7nv6A2W9aoE06NCLlgpXZkjFHaQJNrfuDe1pgfIjCL8ZbbkchmHgFUgzv0owgZKgmqim7iyZcVTTpTnnl4m0rwsvoVWjggTQv/eaGESRABQmkPSwxFetw06kAJYeLZbZMVCfPmJNduQ/SgR20LbmnsAf4l3k9HkoZHMC1K1CPQTMOwQPT9az5ImQBUCHZsFo71KuDAMXJb4ET+OSmXZBPkYthHE6fzoyGaSGswW7LnrOfxxOwPofnjmXaaRpg7tHO8i/5AJDgzhqCVCi1z+atFMdFxSN74IZ/7u3c0LSiFrc/4LIBbufiYtrFm+MopEzvYeQwkwRF2jKtE2oCl2vMQamT22IxFkjbetaXFuPztJhZ8D/1mkSvGWyqCQSuaql+i2z3tb/4mb68seRsEiIu0+hS1OJx0M3bBsnlQEGpMjD+D3/r5/h0tgYz/fOyiqmfpiV6OzvYzK5uo0ST4i7I8RmX08+JNRvBU7YZgqIfi370lExAiKn9pfUInVNcizpHKoiSBFugDcrpdrdvTUScJuaxOODcb3yLgA4uHSQkAlnaBWqRMScpW/dC3hwnfgs9P/pnCgy9+a7bhSSgg3AIM1J0WumCjr5RsOA9YD1zboZ5mfjwZ11WT+gplRToIMp3oLYjG2/lPbq/3bqT18QpUUORvkfEUDTb+acA3QrdXEY/9fnuVi25Ud6AFNLWcgZHqMoJIqO1zJ15kB1rfNS+/uUrHcYQn0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(8676002)(38100700002)(6506007)(508600001)(26005)(122000001)(186003)(71200400001)(5660300002)(54906003)(7696005)(53546011)(110136005)(33656002)(316002)(52536014)(55016002)(9686003)(66556008)(66946007)(76116006)(66476007)(38070700005)(4326008)(64756008)(86362001)(8936002)(82960400001)(66446008)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7bhJcF7OajBW9gopdtsRuSroJuju9I//hOczhTLBc6OMXMwTQe7w7tPqIUJ6?=
 =?us-ascii?Q?SXOnrDnSdY09b4xoPkvB5pC+ZTemY26J3qyiTbYywtP6oCANb8lxbawqpYj/?=
 =?us-ascii?Q?kU1IBT4Fx9zwlX+vyf06BxzRuJLd20Jvz0eFHX1yf0/Tj38N6px1XPonjJ8U?=
 =?us-ascii?Q?KmWoq6Ypb7eHHvJrFfCADrRAV5rkMgkDdAj9E24bWnmBIDoyBiNhxoY11HRC?=
 =?us-ascii?Q?KnG2tCHcrH8t5EAReL3uTmUiWwFmvKiAOhO+n0Kpqk4OJDGfT2qFHxqQEsD1?=
 =?us-ascii?Q?eKl+UlTol2gIoDh44uen3Oz5JkjdNgIBFjOUGs4xUJU+bZbyv1tbBRBGLPsZ?=
 =?us-ascii?Q?nUR2Hnxyogkfmu1+vWCuzUsc9ctgUAOoVzTMjbepAnxIlL3lg2s/5yFAPD4Z?=
 =?us-ascii?Q?kEnpP9rZxOz7x+MC9Ohy1NHKMv0U6jxo1Ki8iL/I0PLNspwdGJv6UBuC39Zj?=
 =?us-ascii?Q?Idts3Re/SIINpa+gu5R3D2KcpARTVjBozQv4VPu3uHcYBmuIis83kkMPVHRx?=
 =?us-ascii?Q?9BvDY8nhC/lR175vlnAebX7Rn6f+Bs2s69E1Gc5h6trGGrPZHj0mQhjSYFjs?=
 =?us-ascii?Q?hnSsOZphRpFpH4KcOhwgGQmUYhc7hqbMUwqdsFiIo6w+ffiiOD7KCJccbkRm?=
 =?us-ascii?Q?7NJxyKzBdXXL5cV7sZ1zRH84kVnwaz57PyfJer9IL89VEYkbKSN7cmCSuc9e?=
 =?us-ascii?Q?JVh/zRbqNvMDtRnfu2nWNPookVAdxpLPH0tJcZPhfmQ8XHkiQjlkeDOTyG4l?=
 =?us-ascii?Q?tjloMfp8N9pXBkCka413GM+Wj5c9sxcdvTIa7zSiqRa0uWQoW5HM8aCsiQVX?=
 =?us-ascii?Q?WzeuM4wklFGZVRiMuqNK6Jt5oBllnm1YdOIVFwk2vAd+opvkiRfhNlB9EMmy?=
 =?us-ascii?Q?VtcYrj150VxSJNguhSFTTpDhDmhzFu5nRQ8o0jNXvJ5iNL7qc5fcNrgjt5Us?=
 =?us-ascii?Q?4mfOiBh8z3v66pAKEd86mhvDaVtHhbFeOx0eRg7Bt19hztVd7S1x0fZN+VR/?=
 =?us-ascii?Q?TaxkxBAMo3ENna7kWezkq3bB2o8y13/EuuGTaujd7ogsele5WPL+CyAim8eT?=
 =?us-ascii?Q?8wWkPipT5NKa8v9bkO8OMkltWKDVtuzky5MjwoF5kcHwUCtHuei0Tibv5e4z?=
 =?us-ascii?Q?FFOptaYjhH0cU6UwTCGQN1/S3e3YwmQ1uo1xzFvs8dZE/mqqu6MOjkXnnwYD?=
 =?us-ascii?Q?EeFOjLKPCG6GO2G6Pbz6ksy0Kc/NdKMbbkgw/97GPhMcj5DBskb7TJTAe3SG?=
 =?us-ascii?Q?TUceovWVv1eBxz6TL2gU7ychQlIZAQrVIsx121fLu42qLs1i6JM75vtxJ11z?=
 =?us-ascii?Q?2J6MhN3O5GTZIc3rk7qHWRUvnXrlIJ461uub4Q7qAZcBnl0l1eN1Mj3C7NsV?=
 =?us-ascii?Q?q49LFdhM6LEj8eN0iV94jVp5HJjBGkKT5Aqure6PeMPf/7nhm+TM84QTfgFo?=
 =?us-ascii?Q?U+s1Raum9aE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6691f585-8e7a-41ba-41d0-08d994884087
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 11:45:16.6846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gurucharanx.g@intel.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3877
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Nathan Chancellor
> Sent: Tuesday, October 19, 2021 7:12 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; llvm@lists.linux.dev; Nick Desaulniers
> <ndesaulniers@google.com>; linux-kernel@vger.kernel.org; Nathan Chancello=
r
> <nathan@kernel.org>; intel-wired-lan@lists.osuosl.org
> Subject: [Intel-wired-lan] [PATCH] ice: Fix clang -Wimplicit-fallthrough =
in
> ice_pull_qvec_from_rc()
>=20
> Clang warns:
>=20
> drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: error: unannotated fall-=
through
> between switch labels [-Werror,-Wimplicit-fallthrough]
>         default:
>         ^
> drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: note: insert 'break;' to=
 avoid
> fall-through
>         default:
>         ^
>         break;
> 1 error generated.
>=20
> Clang is a little more pedantic than GCC, which does not warn when fallin=
g
> through to a case that is just break or return. Clang's version is more i=
n line
> with the kernel's own stance in deprecated.rst, which states that all swi=
tch/case
> blocks must end in either break, fallthrough, continue, goto, or return. =
Add the
> missing break to silence the warning.
>=20
> Link: https://github.com/ClangBuiltLinux/linux/issues/1482
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
>  1 file changed, 1 insertion(+)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
