Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D30559C8E9
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbiHVTcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbiHVTau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:30:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E118052E50
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661196340; x=1692732340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1C7U5Qf0QtQJqR6/MOz9wfR91KWx5K4/9DSaUxgfzWI=;
  b=Ry9Qn8TKRIEQLISGBst9qbMCY3X80Sj5+ei3AY5okNm2pT/LBKl2KleH
   R3gZ1zkduuOeuZyy047pl/QAJIWEGRMFpTWqzNt3ZBrs7ldtjb0qZEYES
   URAVbeph15KOhinIXzsBcRmqEZpsilJ2x/Gb6Q4/tTwiwo6h5QrvU7a5J
   ZFOk734ThLLjwYQTsSfwVTn0lPt4DgvrqMuRLVAbeG45JQ3NfEf/hUfqm
   y6EulHPRTXFtd8G43wusha67P6dcomLSF8Ck0BIWJRdUW0jCO+b/v0pXn
   G8Ewfy6kjNtRHDGIl+XwUGFwiD8To/Rds/Eb8MPgtIvNpT+BYyw/eZM9C
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="355233488"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="355233488"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 12:23:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="609078483"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 22 Aug 2022 12:23:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 12:23:57 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 12:23:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 12:23:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 12:23:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShqeYWz+osn/+qe0dmVnoSCfgasIK79hDGelgwmndSMIwl3AlctzXIdmU6sQJwLzLuEbj53oq3XjnyU+k4+IeDrbFLyKglr5bn1622ik067rYxmraQw8OhKEh3Cy6xvF33S0kmTkvZPIKgSG9c1PPXMnnSSf+guk+u2oM6GIxYTc2KsNM3nd5wgYZtVFNUyLrZ4vTqfKzLAFNEy+fuVVvcuQX77f+R3HvNwSrKtMA5ygd2AsNFx5m+tNeBw/GK90y7DA0OUc8J5EY34gQNCFKizKz/oEg6+uWuS1vriF/H/AezO0NL2AchLPkt4SHkTsZUM+9rXwW+lcNs49FXT+iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ln2Yx7bHScLwnD1PLJ+/voOXkiPcZP/9mc/CaJGTwWo=;
 b=Xxkz8+t2An7hd34mN/YTWESjwLP2xdMGi2e4k3oqm+ZYJdNDEAA5LDSqleF75m1N2k9yus+j03rb9PAANTc5NBytGTYW2habgZu7P+kI8qxHK71snKp2gv6SNY9jNnzztTtxSp+/p1udHVsmFsZjyt6GSPquS65qk8372gMYzH62yEWJ78BxE1102+LL32uk30Td34ryqF/6kBqJgT676f9dVKvrIp25R2/sEynwJG/vmPddH94sEx9DI/KZ5Wlmt60U6UDcRnmY+2T82AHDGEmwJWLRToLpnm/1yN6JkwIf+pu97z0AFu1WwqrEU1VN9qQBMRCPP9di3pIqLItDVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ1PR11MB6154.namprd11.prod.outlook.com (2603:10b6:a03:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 19:23:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 19:23:49 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next v2 0/4] net: devlink: sync flash and dev info
 commands
Thread-Topic: [patch net-next v2 0/4] net: devlink: sync flash and dev info
 commands
Thread-Index: AQHYtkkVTeROOAnNvUO4Y7SipVDZ/q27TK2w
Date:   Mon, 22 Aug 2022 19:23:49 +0000
Message-ID: <CO1PR11MB5089416F9A21228278C2959ED6719@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220822170247.974743-1-jiri@resnulli.us>
In-Reply-To: <20220822170247.974743-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb48fcea-b420-416c-ba99-08da8473d760
x-ms-traffictypediagnostic: SJ1PR11MB6154:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6qSh/VNG6Y/7B0vTIfVuy9oGe26Ex7NU/YGHXDS71b9SCgUkUz47Ja0wrs86pbL/i7gnNzugomrpBenkdVlP316ETUS4yFkRmrVUpyUdsHKtECK2nKfkl5OSbEXdm2zol5tOBQrmzvPvxRgSIFrlNVMvnhZY7Wv8A87l2HsQ3zuPjV5EEWMPE4C2NDzaG9LRNXnV+jcEwPKLsXab2XaATPrY8QQ3H4xTo7hngyrQCaDimOVCW0RsdCg/agkvwdCnbnhNFFTVg0hHo2om/Mh66cBtDZopTbZHxso3qgG2UepTmW/DDk2AP/CUs5qxe5etvUIdxLxQTTv6NU0ApKWQ0ct6KivSXRjqotMl4QtKUKiVpzlDgT80QBQ2hYSnuTyVtYCYJKlnF53ikb1XdssvcDHek+2S19G0+DEKr3MpRHVMTEt8P1VcFYAQbdQr65jFZAAhb6I55Q3yhGevyG9C5UXCuFT4mRFhrAI5eGiVwUv4BcvHshgJrL9PX4zPQnlEooduFCuPs+rVEUQ5jCm4Tx31oHOzuhyuCunighS9fUS1cbLwYvB4gkR7O6z63ZZWp4NNDsgM12EivvMsFzx4X1t08DDVw3n6gLAy4CIngzOiSs1EDCQypNQdT7NMgU8h0FKfheFlZlARHF1YtqtNwNTmpjvyRYblEEQBRawzH7tIuoHystKnTk0zEhAg6s1ikaH+BbrNcavWaRljhxltsnksWR7BpYQqze3Vt2raFpBxqwJJxsZsLJkHrI7D8pzqN/hJ1iCqNAeWir3G1zC1eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(376002)(39860400002)(136003)(122000001)(5660300002)(66556008)(66946007)(66476007)(64756008)(8676002)(38100700002)(82960400001)(38070700005)(4326008)(76116006)(66446008)(478600001)(316002)(7696005)(41300700001)(26005)(6506007)(71200400001)(52536014)(7416002)(8936002)(9686003)(2906002)(54906003)(83380400001)(33656002)(53546011)(186003)(110136005)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5u7wH53jH6HAYk6AqVoow/D3/tVeEdS8YsUZPfiwKm3FLDXRfsOCr73dDcoH?=
 =?us-ascii?Q?/G42+4W/zU+tvKa5CtNmP/HYF6IAsTrr6pSZhKNfQt7t22NGRAFo+Fi0tMe8?=
 =?us-ascii?Q?YHZn0enosHyhb5I0YzESGpX2avRJtRVSGfkixKOOJ5VQp1CKYKWpBxThGaZl?=
 =?us-ascii?Q?z/eph+4YpUXb+ZhzdPN1qmMr2TZPhuIJsQ1tGg5KpJ4Zw39k84g/ssuzwUYf?=
 =?us-ascii?Q?fAqQjpaXh5bqxObUbKdvZdd8nV+8RfQlI+VN3Nh3/4fO540RJRaRNXH/UUZs?=
 =?us-ascii?Q?vDe78+yZHoYe/7Nigqgw3b1DVDcaJifdFrFlSy635GxnMKJVf7nd0sBSofLr?=
 =?us-ascii?Q?YZQ6SuFf60HZULTik5hwQBfPLXjW623bgK3Z/pUYNy8DvsCgHnbMJ1QePakd?=
 =?us-ascii?Q?LN+ctjgx5OvprikrUGfxCAda9kyZSQiWFlS+m8GZYBR8Mpcl01Rj/lFJRg2B?=
 =?us-ascii?Q?oJpqRdTpB1pgTphCR2mgLBgmDGHNn1+nT17tDan2lsZuafsugG+hr2fK39KH?=
 =?us-ascii?Q?UJjXR/99GykgiYDusqBcO6A8IQnHY41DnO9c6xg3ALXj1b14nABqJuX6od8o?=
 =?us-ascii?Q?jSSJ9AMCSjM3Uy8vsN93ZZ9p9R9eVP4tbgS83xINK0Le5wXhCPuh1Ac4NBMZ?=
 =?us-ascii?Q?VEMqm7mypYj/zt/8bIjteweMoJ/CdQ7YYev/3vZHr36aOxGImch9fqKSZ2d3?=
 =?us-ascii?Q?erSRyKvAdih/DWSMqrfcpzegRTYLgjve1pRhO2RqZF15nan74WgeE0YeqzlC?=
 =?us-ascii?Q?ztegK0s2dpPHCJGDI2Z+6s6pjlP8Blfq1bic3fh1257p+SQfz255+1gXNHR9?=
 =?us-ascii?Q?+3zzXHw4itGs4QGZ1aS67KsE8Db1D79SnEqNNIzGXgv6mgXtC/e/r8ZAzhTa?=
 =?us-ascii?Q?vFfB2jWTC8j4Q+mtBGcD6yHCRyCtTiR2csVckTB4yYxIEStdXSvX3+FxaIJf?=
 =?us-ascii?Q?0qi3rLXiHPkoS/q3IYck98w5caVCwLqU7Ayc9iLTGJ0qQ08dUpk1h4JSNjSN?=
 =?us-ascii?Q?HUOX1rw9xQNIQwDEYGQsgqNR9M2P3YZRn40qNmK4Ye0Brt9ZxbDWpHbDwY9/?=
 =?us-ascii?Q?CWDgaOniGbs4wjw3YRZAogmzNkTmBYYptZwjd7pthrWr2sxCcCIip74dNFId?=
 =?us-ascii?Q?uR/1OtrT4o8huZhm10mBiE20jBP1C4icY76o8ZlCdXrJClKYYC4iZO3Ob5Sn?=
 =?us-ascii?Q?Ya/G99MuOQonJgL835E4FWddhvgWQeeZb25sZUXVEnQSEkK0DPbmgxEp9ayA?=
 =?us-ascii?Q?rs5ZvnATqUUglNnB8LnDIXB4ZAlJ+0YeW99gk4/LAeuQBY7yv7gdsm2lfoXI?=
 =?us-ascii?Q?AKeayh2IOdz7+S/cl0x8lMh4CTQ+Hb9+AiqVXrQpCIAkW9mnYM5suOYIU9vN?=
 =?us-ascii?Q?ae/4eCFIr+dp1/u5DatkgjljmrARG+uyFAraOmLgXoiEATdnrCN8XFiBU1rx?=
 =?us-ascii?Q?w4QlVYUn0fIb/0B9+lLCon7YTjotKY2zv/bwG0nKBoNW0br6n2qFlI2LZF3/?=
 =?us-ascii?Q?ygh3G6rq/zeP43emX4td3/51wK9xCw23uZ4DzOUJvPNmyYnJgOQFQ5KMgXvk?=
 =?us-ascii?Q?NWHMK4U1dnkyKdvvc0AyC3B65vV9WWC+i2CGHQJy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb48fcea-b420-416c-ba99-08da8473d760
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 19:23:49.5423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VWWn0g7qSKJBBclNaPcU/kQ+izWwIEb2rR1QatSkRBQ8L6yQ9UhzDQpf/5m7N6W+lFYUwcnqT69RCV6OOjOtUrmIV1gaz9BCSZ5EjzJFhLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6154
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Monday, August 22, 2022 10:03 AM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; idosch@nvidia.com;
> pabeni@redhat.com; edumazet@google.com; saeedm@nvidia.com; Keller, Jacob
> E <jacob.e.keller@intel.com>; vikas.gupta@broadcom.com;
> gospo@broadcom.com
> Subject: [patch net-next v2 0/4] net: devlink: sync flash and dev info co=
mmands
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Purpose of this patchset is to introduce consistency between two devlink
> commands:
>   devlink dev info
>     Shows versions of running default flash target and components.
>   devlink dev flash
>     Flashes default flash target or component name (if specified
>     on cmdline).
>=20
> Currently it is up to the driver what versions to expose and what flash
> update component names to accept. This is inconsistent. Thankfully, only
> netdevsim currently using components so it is still time
> to sanitize this.
>=20
> This patchset makes sure, that devlink.c calls into driver for
> component flash update only in case the driver exposes the same version
> name.
>=20
> Also there a new flag exposed to the use over netlink for versions.
> If driver considers the version represents flashable component,
> DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT is set. This provides a list of
> component names for the user.
>=20
> Example:
> $ devlink dev info
> netdevsim/netdevsim10:
>   driver netdevsim
>   versions:
>       running:
>         fw.mgmt 10.20.30
>         fw 11.22.33
>       flash_components:
>         fw.mgmt
> $ devlink dev flash netdevsim/netdevsim10 file somefile.bin
> [fw.mgmt] Preparing to flash
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flash select
> [fw.mgmt] Flashing done
> $ devlink dev flash netdevsim/netdevsim10 file somefile.bin component fw.=
mgmt
> [fw.mgmt] Preparing to flash
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flash select
> [fw.mgmt] Flashing done
> $ devlink dev flash netdevsim/netdevsim10 file somefile.bin component dum=
my
> Error: selected component is not supported by this device.
>=20
> ---
> v1->v2:
> - see changelog of individual patches, no code changes, just split patch
> - removed patches that exposed "default flash target"
>=20

Thanks for splitting this. It was much easier to read and process the chang=
es. This version looks great to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Jiri Pirko (4):
>   net: devlink: extend info_get() version put to indicate a flash
>     component
>   netdevsim: add version fw.mgmt info info_get() and mark as a component
>   net: devlink: limit flash component name to match version returned by
>     info_get()
>   net: devlink: expose the info about version representing a component
>=20
>  drivers/net/netdevsim/dev.c  |  12 +++-
>  include/net/devlink.h        |  15 +++-
>  include/uapi/linux/devlink.h |   2 +
>  net/core/devlink.c           | 133 +++++++++++++++++++++++++++++------
>  4 files changed, 136 insertions(+), 26 deletions(-)
>=20
> --
> 2.37.1

