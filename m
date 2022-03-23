Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597B04E57A5
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbiCWRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343728AbiCWRiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:38:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C627EA00;
        Wed, 23 Mar 2022 10:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648056996; x=1679592996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cf0ddmcvhpXSN8h/dbSgGwAay6sZ5ALsUUIt0ukID1E=;
  b=dF3ZOXpZI/bcxNrqKfCR8RdJccWMRqrN62EY2rHyKyLUrZj44eRZQL8n
   zPwvIWEz7GrQEOMkxQirlKTynufoiS/K90P2/Nk7/u2FoIsqBWFL7vrKf
   hxLL7uYJqW7diOm9bU3xX+DL4ralQd/dyVs+jtDteC90TFdY1ZVy8ofeQ
   pMhqGaHO+8g97IZrWMsUjeFC7q24MRPS2JnZUbBjMrHB/l84tV0KR9OeX
   zboHRiu/TJav1TaIZMJcZZ4h+tiMCvdbsBZvDZ4p935gRiNVfBpIYP1hU
   26rAfmEIkSRHMvDOawNMkZNigqkadgbudZWrra15Io+EVQD2xgqMwMYoS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238786898"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="238786898"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:28:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="552575102"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2022 10:28:05 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 23 Mar 2022 10:28:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 23 Mar 2022 10:28:04 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 23 Mar 2022 10:28:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICij8jDDaLcS2+SjB3i7JC2KUHn0fQ8agmEtLLb7cIkUBWWlHGc5MdeMTLMV2ST62nLyBOahQJ2h4NTmCy8FEboiMTCu6Pw/I+CRyyMKAnx7aqz+uEs7dwcOHL2E2IF6JILkD8BAdoLqkb2ChLEkrNPNXPRceyYwOwT8L5dQoMjmHfVzvXmI1civX9McmZwgRLOvzCR3mT/RuUMimOh9B/1CIo1qpviOA8H5/WhIrW0iY1HnKEd0xQEyb/ajgkz7SxFICfp9OB4vLccCVSVqsbexTB7mRXDDsmthuzBjxz0Y1Lo8XBV1MG3LtiN7tTq3ijf9ZIzAX2V+UrlZxsVMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XjFGvGzLbNZXFjxyqzcRW7NhF3DeEqvc4Yj5Z5nYSw=;
 b=MlKPWPpLofxCzNj0kbXlX1qfAcKERS6gbIpTsGmp12Vl8ItOL5BgUEKCuAnzxOT3dlZFyTGlKCjtxqMVVLRtxoFsoG3B5vuwLgkPLo7G3DOK4zJmUaHK3EbfkBBTvBP15ylNtvVMzG2/mXE0OlwMYOAZGbFCNSxaNAavmsgTyUm777mbofNJrevbCb599EYV5CFs0g/agMTcmCSfz7vAHZ2A4HE2kZN7jXjSzc7R96eXDJV9hO2xTBWLCBeFaT0Thzly0ypBCAIvCc93ghDMQ4xfP3Gc5O+/+H1PoG+XzL6XpGZTYeLQPyrF93rSrnAZLsFWNaaxYJ43ksiWKt+LdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL0PR11MB3204.namprd11.prod.outlook.com (2603:10b6:208:60::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 17:28:03 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8%8]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 17:28:02 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "poros@redhat.com" <poros@redhat.com>,
        "mschmidt@redhat.com" <mschmidt@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] ice: Fix MAC address setting
Thread-Topic: [PATCH net] ice: Fix MAC address setting
Thread-Index: AQHYPr4hauPE06ST902GLu0SWnA6xqzNOMNA
Date:   Wed, 23 Mar 2022 17:28:02 +0000
Message-ID: <CO1PR11MB508946CC906E8B851D69D31AD6189@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220323135829.4015645-1-ivecera@redhat.com>
In-Reply-To: <20220323135829.4015645-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1130538c-c040-4f84-390c-08da0cf27c13
x-ms-traffictypediagnostic: BL0PR11MB3204:EE_
x-microsoft-antispam-prvs: <BL0PR11MB320471433B92EF3F5FF77772D6189@BL0PR11MB3204.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3gRUU7gMpo5+yNz3Vl+kzfDz77WoaDlf5Av+wnYhJziJgROioXLJ0iub4DO6xiDtORtGjBHmuarMEpqFvYblEx2WFrJPCqFpQiElv9/UntCMeuZm9PJACxj5IXkR6qeLCfvC+vUdE7A5C8VDy0JNU4GcDVPPos0uEhjHGHAaECVutqhP4K1F1jSQXl71Dg4pG+iROrwGOqUKi/ZMXB84tuFWGptHKNoWc5eD/3cGNlN43GbGKugpqRBExrPLZ6ldhJpecKilqg/Nkose2ZgsgQzJgly5W/Lv5AJJnE/NoYPSOTrR1TXC+QUZiVOmGlNGV+adq9WCGOOxImA4z8OdUDKAMEEwi0rNnlNki6M70Q41Bqqtit49J1f7MN4gQfpVfBLM428WKhDwL+MGSwLMFknID38ZYm/Pq/i7xTwvbNGNLHvq1ceJFdVaImJ5/gEBtW2ljEQhhymEaDou6KjCxqYoW+bsHde27nIhvXYnKE6mIQnYpZqVY6djETe5+Hxb7cpOnS3cRsea3EkuJ0m43bx6RyM/U++tIjQtLyTod2r/O/IMTK19RT8a2MY1Of8LW4LLYN/dQhyfUYQiPLJQDzcYK65QNJxUf/4z/TXivmhJ9QO4NHEEVi1OPT0AQzoeTWEgg75J93CoYZmlEBya96vAjq7FEio9Xpocm02Im+kZQXDErw9yYSkQ6rwvmmjSsfQ7xOdFuH8qlUjlU4NF+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(122000001)(2906002)(82960400001)(71200400001)(55016003)(26005)(186003)(508600001)(7696005)(83380400001)(6506007)(38100700002)(53546011)(9686003)(5660300002)(86362001)(66946007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(8936002)(52536014)(110136005)(316002)(54906003)(76116006)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/ZecxsUj/paJzwHn39B222evKjbCQD6gPKjhNTjYp69DIM3tDmekTBkvmwgn?=
 =?us-ascii?Q?NOH1Gk7rrEUHIyMAw4+NfXHqO5+FM3NWalzs12w5mCJ/Cf2oN7q+JB8d/Lso?=
 =?us-ascii?Q?HpI4mOfzFx2Zzcgp+yyZQU4q+gwJab7ESioIDy4mkDzhMiYyqMXKtrDSGjct?=
 =?us-ascii?Q?qe3ZDUVXFmUrjwmlbcBJQzBqC96llOKsori0BFTyHC1gWQ6IL1Y3LZW38/sW?=
 =?us-ascii?Q?bO3ZXXbMjZBDqWQ6IiY4dManUM00U8uXlrk1uPvq0Mo2IuzsqgEnSFAUxFDn?=
 =?us-ascii?Q?9n0gkY5Y1JckWzirVElyoO3WIFk1jDQHoEpqWsl937EPus1vLPYKg53V2cV7?=
 =?us-ascii?Q?PbEDBbHApOYO24+L/8ACSBxraT7TpclUaS1oz8t8SLodJ6LGOfDKUtBbLSZu?=
 =?us-ascii?Q?bsJM9awYGh+ZCC+GIlpe99IzqYJtm47CF7QbOgKf0bI8h29Z9cqDHhLuvKEM?=
 =?us-ascii?Q?UxL4GvmYLKfvHSlJ7ovPjQGCTraqMmKFOlq1Jd1lUK2KbitkuVfPgHjLKWHU?=
 =?us-ascii?Q?+QiHCsv2T2HnBywISz/DKNoCD9L6S6qCFt7mhuhhQumQ+rSdFzVDVvqtpaOQ?=
 =?us-ascii?Q?HRpm/dEHTa9UaXkZH/r188LXlaDWKGQ7MD8IEwItitLfCzRKnqwa9q5Pa4c7?=
 =?us-ascii?Q?hDZYnVzO38GtU2LD2NK5hSYH0ijphXfQFqPgpR5oVwWIk2J8dVi60+mA/PQv?=
 =?us-ascii?Q?Ck5KJIyB/lJG0JvDHtfIo8R0NUAJbpwvMdJTRHcdc36dIuastcS5OCZL3+bH?=
 =?us-ascii?Q?cCyeGFoUltmjAt4vw82fOitH/hC3ZmnV5oTMGAtZWvsGdNC+1tsZKnmoJrmq?=
 =?us-ascii?Q?XkdTc/wxYP5rHVESF3xhiktksLV9A8zzQFsmLMjr8U+Z567ZoOnu4C5qpcm2?=
 =?us-ascii?Q?de++99OYke5dVkXFW2nv1vUFs4FlkC0lBZ2vp2WkG3lw/F0wv+rr5ryQuK7e?=
 =?us-ascii?Q?EfeZCnJpcfilM0j8ELfA1iPaQDiezMNA2sDdQKQL1RLh8ltqu6/1gisfVFHo?=
 =?us-ascii?Q?lDBUSAfDee0RSOSPVwAYfLNJ+9YkV/sddF6PeyIT80EqqfTeysn/VqTQYMAg?=
 =?us-ascii?Q?ROFPQC/74AwD6vTbiuzKt9amfDVvTGnWjra7kKSQuTfO+wZbym5tif8+iU2A?=
 =?us-ascii?Q?chSt6wT1qxpJ/E3FEWoDCeEGnTOsskrEvyCrgfPgqLHptP4hrmf/dKEmIDox?=
 =?us-ascii?Q?sEfA8nYriGGircVuA9HrbuVcmrsSwLoKPq+EmoulCwFi+3Io7gucmnzxcoco?=
 =?us-ascii?Q?bvxfg6FuHgTCTBPy+fCzuxXzrXoRls49vyCKQ+pFhR43oNOcdCQgAbaXjmzH?=
 =?us-ascii?Q?+ztlHdjR5j5WWhqk6j8SBNyoAupGIjuk0vLnFqWAiFsomggsTSr+3eKfcqeI?=
 =?us-ascii?Q?H6DEthijIqH++14eWiQ15Ry51jBHvJVBScH829yMRO1CzxtM3VRcHOC0qfW/?=
 =?us-ascii?Q?FnN3o/opvUyVFvNaDoLK8bFmg62lxf6O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1130538c-c040-4f84-390c-08da0cf27c13
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 17:28:02.8974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 60WuGwmyUUXbrA9ykbUpjwqvJd/86BJm55EBFYqeaQqq4jyicDxnLuPa82len25P55tsTjkf10o5njivxHjbYSSC14qoJVHFdkjxRTJI/Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3204
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Wednesday, March 23, 2022 6:58 AM
> To: netdev@vger.kernel.org
> Cc: poros@redhat.com; mschmidt@redhat.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; moderated
> list:INTEL ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>; open list=
 <linux-
> kernel@vger.kernel.org>
> Subject: [PATCH net] ice: Fix MAC address setting
>=20
> Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
> the usage of 'status' and 'err' variables into single one in
> function ice_set_mac_address(). Unfortunately this causes
> a regression when call of ice_fltr_add_mac() returns -EEXIST because
> this return value does not indicate an error in this case but
> value of 'err' value remains to be -EEXIST till the end of
> the function and is returned to caller.
>=20
> Prior this commit this does not happen because return value of
> ice_fltr_add_mac() was stored to 'status' variable first and
> if it was -EEXIST then 'err' remains to be zero.
>=20
> The patch fixes the problem by reset 'err' to zero when
> ice_fltr_add_mac() returns -EEXIST.
>=20
> Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index 168a41ea37b8..420558d1cd21 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5474,14 +5474,15 @@ static int ice_set_mac_address(struct net_device
> *netdev, void *pi)
>=20
>  	/* Add filter for new MAC. If filter exists, return success */
>  	err =3D ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
> -	if (err =3D=3D -EEXIST)
> +	if (err =3D=3D -EEXIST) {
>  		/* Although this MAC filter is already present in hardware it's
>  		 * possible in some cases (e.g. bonding) that dev_addr was
>  		 * modified outside of the driver and needs to be restored back
>  		 * to this value.
>  		 */
>  		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
> -	else if (err)
> +		err =3D 0;
> +	} else if (err)
>  		/* error if the new filter addition failed */
>  		err =3D -EADDRNOTAVAIL;
>=20

Style wise, don't we typically use {} for all branches if its needed on one=
?

I'm ok takin this fix as-is now and doing the {} fix up afterwards if we wa=
nt to avoid delay.

Thanks,
Jake

> --
> 2.34.1

