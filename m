Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2E58B0C1
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 22:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbiHEUMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 16:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiHEUMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 16:12:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B60A19C2E
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 13:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659730372; x=1691266372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Z95ZD4c7MX4PO53Y+vsEbcmp8axpOXrxZBAIPClW7w=;
  b=NmouBYxGvUzmb0lA5NqvWlH+ETZM2P9jXETmdSI6LgGPb6ewKsVGXSgb
   beyHpUriDwdJ7RksN6GnhL0mkt4b0xMEQJeVeYqdn2G1ZN3+Ck9TL7aS7
   7nazMu1rA3lfSOZ4GE+6m0I7xtJHNAmWpHjjPm7wIcGmPYB3zwle9VdeM
   lA0ZU4hQHy5BvwCK8DHJ+Nkl7OQ4z3AAQTzozLNDbrY6GhGN/o8UeDN27
   Dqzz/LfnWC+6BW+9JR6eS/mKQETF8aPcO5dtnDtF1MsURURPLvSoWr+ti
   RGCgQRreJ5D5Hroj6ZZpc7HoWpXRvZ4ka9DqQoH8qU4Wkr4ZMHCds4ZbI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289039370"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="289039370"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 13:12:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="600470081"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 05 Aug 2022 13:12:51 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 13:12:51 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 13:12:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 13:12:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 13:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqwhmNjOnKQwtZ/LcU68jCiyDLDVYVSOsNpHP2TJwKnZQTRW8ESj3SPCsCoQt/TTBSImnhglb8B9PSnX35sQ7EGQTOvj1eI0V1jL4I2L0b52+kOQVqavupjx7JyyClObybl8SDRJCTzMsxqbSrUkqfyU6n0MpRXadz/W9Gv8hSW4rMrN+O5R62mWOA2jrp3vmhyILyxc5+RplypzsLrw+J+zpetyOPT7V10QSCCd5AYgb0opYMIqAmBlPIgWKkVf5NE9430HviFc/6Dlfs9vESXP2V7kN8qUtqBCBDkzkLliiRLGZVxt+VwPvnYp4iyDltwMcBSfTgaDp0U2WG4+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Z95ZD4c7MX4PO53Y+vsEbcmp8axpOXrxZBAIPClW7w=;
 b=iga7JrS9IFS4Q72zcMSLzDmkNKuzVyEfWkHnTDCwj+5pmcPYm5SejlPHQM+W5mI7ScWmmjiA5n4Zk6HnWvR3YUeNiwoOcPUmRRfHyKGaZAYN8RqhW6IXsCLSlv5uZMFCd3v4mbwSOYUjXqyJiRKb3Pakc7Ul1PRXF8aTsz09chV0psVi75h1GBehtd0HgBnZ5XQKyN7/q6eICQYKBtrSOnTdth4+28nRZQMTTxdfzik3ePprff4plGTaMIM76A6VHS1hhzZv4Zb4KRD+IOYdYVY7Lajr9q54SiRoQTZ+bcrVQljdCuKrhjwZafZenQlX7oUz8UXhLprEDp/yhidzPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5088.namprd11.prod.outlook.com (2603:10b6:a03:2df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Fri, 5 Aug
 2022 20:12:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 20:12:47 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "moshe@nvidia.com" <moshe@nvidia.com>
Subject: RE: [patch net-next 2/4] net: devlink: convert reload command to take
 implicit devlink->lock
Thread-Topic: [patch net-next 2/4] net: devlink: convert reload command to
 take implicit devlink->lock
Thread-Index: AQHYoxqTvuyVf0CqCkWk1qQvKmvjbq2giFWwgAA8/YCAAAOD8A==
Date:   Fri, 5 Aug 2022 20:12:47 +0000
Message-ID: <CO1PR11MB5089EB42A97F4A712B14BC53D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220729071038.983101-1-jiri@resnulli.us>
        <20220729071038.983101-3-jiri@resnulli.us>
        <CO1PR11MB50899F33FF6F1B95CD3F1B11D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220805125843.540fbc9c@kernel.org>
In-Reply-To: <20220805125843.540fbc9c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2865452-cea6-4d14-4e24-08da771edd5f
x-ms-traffictypediagnostic: SJ0PR11MB5088:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GPT2B75YnXVEpd77a334QwKzSNZP1Uoteqqcy7wXWcnchHgmEOhHVWsPhjvqKn+hDEBCcM1BHt/Ak6xRvj5EP8dZYuh7H1Hl+5p/qcG7eNkSgRufxM2niD9nnVPQJJ1BCYPsQ312x/eapugJ0pesJPgN7PrT1rx1l+2Z6o1Q0quenUZ4utdWY+iuNFS0kangJCwTuSCBdmO/M3HEWlGIQX0ytK2DVJgIl/iSeV5zBYA+9muPamnAMyK7+VMP96XC/qNe8B1HhyILWgm+54HUGy2QblCcdGrSTpA7wYOePjGfXXRDqTvVsBbH302bRTAexrUsmEX1VqNHfnzx1VV7xZM7AIAYCSbty8NMt0wpqpcAgHCRljFvx7Dloe86YtfvHGwQ0W+PsCi5RC8T97Cmk4dSIA+EZHzR1PyZHvfV5Vpq2OU4unJWWjtthlu3rYkyw099PCDaVZ7yIBs7oCcYnMqReYjzqFnfCM4oNjvdpKj19AhtyD+rwjGb2fG5vx2GclSrGzSRKzL6E8cLaSl0x/TiKQr05us6XB4XUOL1Pu3eBwkktkSfV+ZGFdmlTwd1vO1k5pea0BXqbH9OvXvvayISD+1OE7jZ7iUZnCP4msMd3glb78UDTZxHRFuEulKs5/0YD7U9Zn6TpWx9X55XacoEpaQI7DZPqX4WSsCXOv4qCbZOmSzDk0R7owHKn6cGaDRsoC8we/PbnPeBiQUQ9nur/D52AVqhymYtEM9hj3QS9uQkaNbGc7WP4bRVWiQc0YvqfNRswp4G8jP7j6KfkfXzZIkQSJlIQDPnnW/63ncOvpKW4yokcFqnu/bnXwNI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(39860400002)(346002)(376002)(71200400001)(478600001)(66446008)(8676002)(86362001)(4326008)(55016003)(64756008)(66476007)(76116006)(66946007)(66556008)(316002)(54906003)(6916009)(122000001)(83380400001)(38100700002)(26005)(53546011)(82960400001)(7696005)(9686003)(6506007)(38070700005)(41300700001)(186003)(8936002)(52536014)(2906002)(5660300002)(7416002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r9yFgVlbsoA3VG1mDsKAjFYBDtr/MR2vuUhhBghl+yxlKgLB73ZHyc97bzEw?=
 =?us-ascii?Q?ZTNdR+whXIggCF25Z7naMXaDErINYEaqPc15m83ZWeXIPaXagUPAA1IW7gKl?=
 =?us-ascii?Q?s/ffWxk4vqt9pME3WCa+uk76k/S7/tEm2LkXTXEaXYOOKMNarbNfa7HwtYTi?=
 =?us-ascii?Q?RR87UWXKZXcWnuCe3xdwPchfFaGbm1IqZ1z7vyK4IWvw8PdNTq3yXjLjx7Rc?=
 =?us-ascii?Q?ZgS51Bld2lWGZ/1Np+MNBbcb0kPjVSKGc0M4Xp09xmQ8nr/HUF9nk5wwrSkg?=
 =?us-ascii?Q?mGbrkG0Ebhbml0H7hTfWPLV8dHq3dEXAbr5h7JbLxkCGqazgV7WmXPm8XzTz?=
 =?us-ascii?Q?OrYPK5IdEx/m06/KGgnLb6MAtEwq8ZIN2YSsLMO8hDNc0NOWa6khbhq2Y4mf?=
 =?us-ascii?Q?U4xps/mk7+8Q6GYGl4YWmyuS0lZq3Uv5LJ12ez6RsyA9e8ul/IcL+dAGn5Hs?=
 =?us-ascii?Q?3mP2h4sk51mhfOS9jmgR2Veu5t9GirPHt9oZyMVq9AUpbD4IAkU47fy0XRd1?=
 =?us-ascii?Q?4Rk2EK1MlAS8jG+DQYE3/+YA4i0L/3BExCtu3B5yz9oiHXDd8wKh/6xAZXCZ?=
 =?us-ascii?Q?IIdv0pmplUH/mlMMoQslkVF7ZArPhyIGoKPYxxURE2TAhB95Mxgi/JV1O79M?=
 =?us-ascii?Q?aGpWjgSFMvefZ158xqlBJLhUBvcKp+0nRvNvhi1kcl6yPVDN2wukp5OMEsnj?=
 =?us-ascii?Q?atK0CiP/o92W1rEsOd3mxetKPRVbtPmqwGFOGR/5vcO8Hk2hPMLiWChpIZI5?=
 =?us-ascii?Q?dQgOMwMPnEz1V3Bq9BXfNVyATR1iqoZPyUzFbIVT6rlRkV9wyMtQv+zxHcsO?=
 =?us-ascii?Q?No6J8MBaEM/a8UX7yJSbVWdXD5pRCy9pU02UR3hbIHH2fD3jQ2+8HjIv+up1?=
 =?us-ascii?Q?icyvBXCvRNz6e7LpvIsz6zQ9PwOMN3bPw04KviAaMBlf5Rh50GndHxoqguQ0?=
 =?us-ascii?Q?p1EgHtSFnBGktkcst/bduI9hAfSy3xliCeHf310ZPk4afq9Suuy4PEBR/tMp?=
 =?us-ascii?Q?1KXzWZwbY0q90uJ7YTNzD8OVU5bBZ76iFluaBIEfHKwTgq7MEyuOrAY/meJF?=
 =?us-ascii?Q?PdqSmUgyrIBobPGRDU1997fvS+D+g0EhFaIJ0r/pu5ABZ66w3Yj0+3z5nMTu?=
 =?us-ascii?Q?Cn0qHPGjgrUSRtmIHfvqM4vwZW54NUKj7SU33cnfSRs9OXvyQsY/E2c/UyvI?=
 =?us-ascii?Q?jmsGJr4GFzNPAOCBICMA71USq4i1GJZQ7nniXPxRK9ILPQyiIP6BxLwJ3eba?=
 =?us-ascii?Q?S9Gi30C124SrRb0ZNh1mHbBnnuWjgvVoZr5RDW+alj9PoMn8ReyRoFcgtNOm?=
 =?us-ascii?Q?hzj0bouRJzhnMJp9NLbxjOcjoMnJ28wR0WVK4L3fvJB3QEwVBq8kiuFISs+w?=
 =?us-ascii?Q?pwLCpMQGHbOsXC66Pcnlkkrx7de2QZkD8JCskAvwDFS5axUT6gYzdye0THD+?=
 =?us-ascii?Q?7v2qBtaCRJi7VgwNUOSACkeYjPWyM+dJFVxEgJQT14Q8m1tbFe5gDmFYQCmC?=
 =?us-ascii?Q?eDXhqBBPPSmaZVDEEeTGwfEOWcMLbiMRDsg0f85MpFILRn3CYyH6UW2Gqxsf?=
 =?us-ascii?Q?7ICdcShLQuU8eb5HxBAiisnOyoc0sqNQ6P2fbbGb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2865452-cea6-4d14-4e24-08da771edd5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 20:12:47.2888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8SMeTSpLOOBkw29BiZmtwzBkMGo4scQu7ZkrXVbFL/WYR3VSiR/4VWFf1JqWcaAFdeEjBgXYBojzafgJrsfMtNiwTddQlUns6hFGZd2Enfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5088
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 05, 2022 12:59 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org; davem@davemlof=
t.net;
> idosch@nvidia.com; petrm@nvidia.com; pabeni@redhat.com;
> edumazet@google.com; mlxsw@nvidia.com; saeedm@nvidia.com;
> tariqt@nvidia.com; leon@kernel.org; moshe@nvidia.com
> Subject: Re: [patch net-next 2/4] net: devlink: convert reload command to=
 take
> implicit devlink->lock
>=20
> On Fri, 5 Aug 2022 16:21:16 +0000 Keller, Jacob E wrote:
> > > Convert reload command to behave the same way as the rest of the
> > > commands and let if be called with devlink->lock held. Remove the
> > > temporary devl_lock taking from drivers. As the DEVLINK_NL_FLAG_NO_LO=
CK
> > > flag is no longer used, remove it alongside.
> > >
> > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >
> > Wasn't reload avoiding the lock done so that drivers could perform othe=
r
> devlink operations during reload? Or is that no longer a problem with the=
 recent
> refactors done to move devlink initialization and such earlier so that it=
s now safe?
>=20
> Drivers have control over the lock now, they can take the lock
> themselves (devl_lock()) and call the "I'm already holding the lock"
> functions. So the expectation is that shared paths used by probe and
> reload will always run under the lock.

Ah perfect. So essentially, they already take the lock and are calling the =
"i'm locked" version of the functions, but this now moves the take the lock=
 part into core.

Ok great! That sounds better than assuming drivers will take the lock thems=
elves.

Thanks,
Jake
