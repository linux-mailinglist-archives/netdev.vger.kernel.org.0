Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248BC6EC65F
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDXGhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjDXGhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:37:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FCD3A98
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 23:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682318261; x=1713854261;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NM7vteDS+4c8GnKbQzHZdVdHezsw9jB8M9XEajLBY94=;
  b=L0s9kRgC3YeAnm/Cw274G0R95BHe86rdgddQ/zfWGtrYk5+97+RWgQfS
   UZUDFxP8vVur8lHZj/OFQ9ys0QDBNDJSd62z6E+yVTu+hi7TNe0Y5VOQE
   gQO5+GKjt9egkikTAnbNjqm7arUENzguGl8XQDMY+YBQOyBPa2UfH4eLX
   Dkv4Fb9X2km98zns0ycJPLmyYC6tt/iNBhyfSvx816PI/PQqFNkn9eojp
   Cfr6muOvj0rksJc3hzzJBz6Y4hncF5ZxprkG3P4WjhODIYaVbRLM7bIe9
   h77Pk0xuHwmj+r4QP29ISVZAPR6YARjIIvSDV0wmC6qAFi9VZ1u+WYVOi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="326694140"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="326694140"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:37:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="867372306"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="867372306"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2023 23:37:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:37:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 23:37:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 23:37:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqlwSkvSXeclDSaDYeHGFk3n4yR8NE4kcB/+6Gis9qyixszwyF25nquwt5wN85kxmutPBC4yCTpOidEHu/mZptqOzyZ0aElS2nQuv/UqeJYz/YIoVH45v1mHlZOGzcxIv7hXhIzBsqfZoxvq0TSnuHy0lMYgzQw4dUBVxutLPqHR0sQbTwrKGcnvvq7mtIwJCj4EfwVRjTWhyYSX+CNXaUp89euMz0fusPvUYzMIH+W22Sa3jIer5djndMPgb4YdUqMAfDMhX5tJaC8KX0V3sH84mzcCfqcY7YuWx5B+Tklu4x26aeAPosuoBbIP5JTunx5jM0p0W+mMTDXZt4WFuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5zk9zbw6LROg5sYySfHGeB2z5mnUj6oeqJL8xOhoeY=;
 b=DGkwQdJE4NoviZCrpPqrpiQGQ9zArc1OlyF9QaZ4v7fpBpzDk5T5XnIpivoz1sfX1PFhMtIb1GoSuMH2HGE/IfMLoLMFdjDLDQ9n6XwEETGpYEYep6m/vvKq96DEISxDVuE8z80awp4NhOrq4sh4yMZPZiO068aZNyWWijPsr05uw0L+xWHRNgxKujPVY0NYxSTDLgeUM3RlCu0oVxaBWDmgjUExyadTXR6UO8vo9TziEIITVuucyiWG+cV68DefTQhbbyLQ6vuEbR9lKjeVtp8Dkl/c/wMMhC0UFms/IUB83ZthSV5Www5HHe6TVv2mWf6qbpGRQxDp537nNLDCRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by PH7PR11MB7477.namprd11.prod.outlook.com (2603:10b6:510:279::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 06:37:33 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c%2]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:37:33 +0000
From:   "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v4 4/5] ice: allow matching on
 meta data
Thread-Topic: [Intel-wired-lan] [PATCH net-next v4 4/5] ice: allow matching on
 meta data
Thread-Index: AQHZaXQVNxr+Pacy/kmggP8PxE1T2q86G1wQ
Date:   Mon, 24 Apr 2023 06:37:32 +0000
Message-ID: <PH0PR11MB501368D97FF7FE6681584A0596679@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-5-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230407165219.2737504-5-michal.swiatkowski@linux.intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|PH7PR11MB7477:EE_
x-ms-office365-filtering-correlation-id: a90223e7-8e34-486f-b3f3-08db448e6257
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3F2d0xnCa+mW+ixryRlRFFT8CEmKUnKtBNjcGl+KQ+Nyq7AUlPBsHLwTyI3tILENT4ofK6A8+rRaWQHHJ3S4ifqxDITABYo5QNHVmQ2yu8/rz8MRB7/CaKnh5I7lsFwWqhwZYGCoE1ilDQZZXsH6j/mkirEEunL64igTwsYH+z/Cnf7EWU20A9YMntJqwxa6jUCl0GDgDecDemOegxcJvh8UW6aspxHECi3fMrvQCfcf2t8VQGpJLxO6jO/el40NuF0FF6IThggxXVlKomVVEqfIpAEuZsJ2MvfsECC1iZeMRok2rjBjJtRiPqsOP6QerI5hBV7aS+WQAduH/zo5m1Hwe3uLpTZROHPiPw+9Di81TMrVr8a27G8F+Q5UNMR1CrT/CCF1tsgt3Le8viP6KEGTPvmHx5ErGmr22D0S0NWlqhmEy+tApVujs+pV+GAqDqepYL9TH6SEHqLRPEKQdUBmnaK9zsNZt7SMTyLxHdlHUTmTrODzUKNxgpe390zVXpAf7P5H2XSslUyXZscWjF1T/RvbabLPFJDI3gp272BBcN8N2qpAno+0zcit5/VCPwegqwpOOV6OMuX+TEmEXhe3TWJ8v2cTgcgY8tV27Ll0291dGwiFdBIJrzdWOw4g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(38100700002)(122000001)(82960400001)(6506007)(9686003)(53546011)(26005)(55016003)(186003)(83380400001)(33656002)(2906002)(8676002)(8936002)(52536014)(5660300002)(54906003)(478600001)(7696005)(71200400001)(38070700005)(110136005)(316002)(4326008)(41300700001)(64756008)(66446008)(66556008)(66946007)(76116006)(86362001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C0O4UDr4lPRmU/2SWKJPJABAceCLGoFD7oAbtyssQEpkthxZlJiKTJanzgWU?=
 =?us-ascii?Q?vhuCiBHk/CnEurxdzxElyOAYRj3pYBydAGvkbpJqe0v4o+MYgOkZQqVpaPoi?=
 =?us-ascii?Q?JmqRYRncBbwINE3GrXq2lySei40bMWPxyaTHhJzttG1wVbFOwh6MHotWOfle?=
 =?us-ascii?Q?jQ7HO/lqc94vEiobH44CFV2pTiDDcAEOwfqa1d3lC3tINbopGCSy+uicpPnz?=
 =?us-ascii?Q?ytcImyembEHZm62kh60lJmNgoN8QOUyxyInpDafzcY7CljxfAuBtQxT/3smG?=
 =?us-ascii?Q?tXm7io8YZOMFvMShmWpn+6YvCETMdvtIc/VEdKFlXBK+BjzJWuPM/0T4VRy+?=
 =?us-ascii?Q?n0SG2OZVCMnSCdHh5wmM4hMjQCBW1RvgrLuD7JWz24md4+2klygHIluydevU?=
 =?us-ascii?Q?/vrdudkDpzobbAoe6WOKY2Atmc0ofZdo0x79UB5kHJUDzeELZxRbGCEcw/CF?=
 =?us-ascii?Q?RNL+AGWX3sPO5b6zoDU783BflWUJ4y3HYarxjKi3diZzxUvGlIxujwz9veTY?=
 =?us-ascii?Q?Kji8/mYNavBByoEYfrxXyUwXj8//T4iEBU1MvqdllqetgsZlAZVGZXavAa+M?=
 =?us-ascii?Q?1KsXcPlzenfjp5/YeDkhXKxQ7Lh0d58CUmY3H5JLDPdjQsBCkBWMebvc2/iF?=
 =?us-ascii?Q?2+9p/JhkeZ8GJrbMaIEDZflGsQiP716LOMIwlHnNwvxnKN7to9605Liv25RS?=
 =?us-ascii?Q?42WD2NPYrCIpTkbCHmSDBx6Z8tGyMw2mRTKoFKULYZ9JIyMrsk2M94b8X4Xo?=
 =?us-ascii?Q?wihbK1Yo+OpdgqRiISBHrhMOVUnwjYol8rZX0XgjZpYkp1GUl3+xM8/nYKGf?=
 =?us-ascii?Q?jpz8QLmvL2FQk9skJ83vCqcx2vfASb1OBzoKXhxMfY/BxfZQPlCaDjJBiel3?=
 =?us-ascii?Q?BAMTC8E68vRDt6KGtf2TpzduNH0MaH0puXjUsGu979lE32w++nYDKbKfYXEi?=
 =?us-ascii?Q?jI31IWzjgyccB7EJZ+uRQul/+OKtVk4jtg84HPaG5FUZqAzccdue3cscvrsS?=
 =?us-ascii?Q?115nTOFz6qdlFMJcUXvxjZuKYC2s8mFgV5F62CH0Sl4DttiAxnI7PZTL4Y71?=
 =?us-ascii?Q?HjQQBbImYUltKVubaZSUG5V+IXwVFSeYFGzwv1x+XtB5QmieYbdSe1T65GrB?=
 =?us-ascii?Q?aSZpnY81Wvl6sKs4KpIGc4WtqzCgRr5wcqrOLQHuKPtcWbP+vo1Z09jCvydv?=
 =?us-ascii?Q?o8keHQo5FaYQAKIziTUVFbzJ5O2GOAHrk28fy1kEMXDTh6llAJXfKTwkntuV?=
 =?us-ascii?Q?kQFdfgO5hbH/7CyRPCZT0CixgxiVTP0kZ77cZC53avdI79VDK+CXgeIYfahy?=
 =?us-ascii?Q?7g/BhnV8kXUreUXNpwfzDC3mdYZqd0gWRQ8soPfGww7jwBprXQ1pYy4kOhRq?=
 =?us-ascii?Q?muDtJ61Yj5JPOvNIsFr0rPYcCa/g5/TTc74bkTrk6LCUmF+ysGa8jgTfxvNJ?=
 =?us-ascii?Q?2DSdvzzKIfhioH9hm0syu4jm2IGM7CJwutWWfPTne5VmXRBAKVRyt44s0JCX?=
 =?us-ascii?Q?VQLg1ljObPXdQLxGPMF5paqMWq4i6byHoMQN9f4Xz+ylceoZY3GcaVGORo8G?=
 =?us-ascii?Q?6cZmybnc0to0tpsTAuwz2CQeZQBNyxqm8JIAzqTtKPGLDiCu5MmcQnegM16e?=
 =?us-ascii?Q?8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90223e7-8e34-486f-b3f3-08db448e6257
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 06:37:32.8396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZ9Sdv2Rxlf3D3pPsvG8u6wR99w8vNrbVcv4z4LaKFyyiSgdn6Uw/xJmuuxZYK8aBBbgXptnZASl7SwBPp0Y2B6XJFzvZEr573woWIYuTvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Michal Swiatkowski
> Sent: Friday, April 7, 2023 10:22 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org; Simon Horman
> <simon.horman@corigine.com>
> Subject: [Intel-wired-lan] [PATCH net-next v4 4/5] ice: allow matching on
> meta data
>=20
> Add meta data matching criteria in the same place as protocol matching
> criteria. There is no need to add meta data as special words after parsin=
g all
> lookups. Trade meta data in the same why as other lookups.
>=20
> The one difference between meta data lookups and protocol lookups is that
> meta data doesn't impact how the packets looks like. Because of that igno=
re
> it when filling testing packet.
>=20
> Match on tunnel type meta data always if tunnel type is different than
> TNL_LAST.
>=20
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../ethernet/intel/ice/ice_protocol_type.h    |   8 +
>  drivers/net/ethernet/intel/ice/ice_switch.c   | 158 +++++++-----------
>  drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  29 +++-
>  drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   1 +
>  5 files changed, 95 insertions(+), 105 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
