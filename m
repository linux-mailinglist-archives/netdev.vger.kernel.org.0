Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E0636AB3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbiKWUQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238755AbiKWUQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:16:38 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6235E9C2;
        Wed, 23 Nov 2022 12:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669234596; x=1700770596;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2mZ3/n+qxBYYknuXkbZo7K3HO75+gh/PWNcQ1l0ZtIA=;
  b=RGUaclmIaoMDec0k8bO7Lqt1LrXRmQsTnOI8KRvWLNUABmsF6UGciXgY
   Uw6LTc60ivhQ1FxgMb8QWYiAaZ2rp6ALby2kGPKL2PqQrjUegC/IB01QK
   B8usW9wVx7w5N2VEIjv1MX3jI1Q85X8/TqFNofueLc1XoHGMrkqCO99Pz
   r/a67LY0pnttG4PBNyUCm89kjHSBuDr5Qck2ZzrT1KU2qFwVwuTaMTKk2
   NxHnyt80Kb4nKtW0vvWPiqSm8n5RY32/Ukko9Z2xebC5R3KwtgdHbS7jN
   T144bLdrh8EyBSMi6KlZhkXdTiC0VzDKsPxQPG1XiHxF9gq1MYy/21k+Y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294539626"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294539626"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:16:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="730902272"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="730902272"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2022 12:16:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:16:35 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:16:34 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 12:16:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 12:16:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edy8yQniYb6DMlOSW/f2VqFguYnlnZjPxfXvLWexNr7U61sSp3gMgt7A0zHQw5OCMkxmzjCJctz2yK9CTXkN+s46TilurxwBpygbY2U49SUjaUd2IJtEf9nDv+sa/spe5AHkTjzy5KhOShq1rivj1qeJT/vuGnKzKRlC5006GghQekrnrLuc/dLCuCPEpxweYQ+9zgRSxt0q9pfsr5Z3nJXay3k7YqGDtvL/5ATeTKzOp7GrgzMkQK4UkgvrlsMsTpIa/nvLxgovmH5xOxj/xehqF8GCITkwpEoxJEWaFn3xggcl9v8dhBcc3JJ6dnpEatLdNFeGn+Lt9KOEcE/l3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i32ot+qngACrzAhwaFAr1cN//85TWDbv+IjqB4jZudg=;
 b=OufHR4GEzix4iBvPY9aiRVitVxTuQPp4p0uwghjtaSbpWBsnktoHkPw681wdxJhY/Ez/jGB116z+64YnusGaDr9oj+x0z0DG43BTyaRh5k4U/ySZsvpY0VVjioyvgDT4jsoBShficiZFAi6CjRxlrNYAIGIDdg+IfzmOjV4u3R3dG6cypXH7TFuxINND2XChuy+889LeR/DNs88HHpp3uOmKDk98o5vFB5g4feh+z9xHHN7sQMRbtDoqMVwVsW4LtsZdICGgNUnRjR63K8JEVpfMdzV5ZgrZeiikysX/i6zC+CVbYOhnfsZvxzv4+p4iHoXC4S7l4KdLiC4FjJ5vFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB7107.namprd11.prod.outlook.com (2603:10b6:930:51::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 20:16:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 20:16:32 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: loopback: use NET_NAME_PREDICTABLE for
 name_assign_type
Thread-Topic: [PATCH] net: loopback: use NET_NAME_PREDICTABLE for
 name_assign_type
Thread-Index: AQHY/0aKnTM/S23KHU2uX1j8XfZvJ65M8anQ
Date:   Wed, 23 Nov 2022 20:16:32 +0000
Message-ID: <CO1PR11MB5089116CBF3DC327E6F4C4CBD60C9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221123141829.1825170-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221123141829.1825170-1-linux@rasmusvillemoes.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CY8PR11MB7107:EE_
x-ms-office365-filtering-correlation-id: e8be5e00-b3bc-4a15-a1b2-08dacd8f9ced
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f2KzEnPLLz94aCiLo0HuFV0TMMWSC5DBJBbrDoXPFJUmhcmi9rFBnMgF19KpQcHaaiKuug2s7vC0zGgR9c+UFC5leRXVPv6RJ8peYL29X/yWeq+YzLGvQVapdaQqi0YbL1nFfkSvb6rKj/NgeCe84Wknxd9wuNvqdrbalkHwHSM9SoHjgU8BChvbAfzxpv70BdCna1ehx16uzd38w3mOyRQc1Pl2Q1u9/hEtuIG3ow7PHWg6HiSE7vywkgwjMZylAYFEUKRg1nHjgcooNR6HCDtmWhm82c/zhYsyf5VynWOXipjChkywEVt2DM1clxi0+RYSHtoWnS3SsCZ53oHT0o2mxpczwQPTPlqvvWsk/ql+eGdwsyVKTe4B5SuHImOBD4/VIDDCLCtFwsrVjicWTfL0rs1S0J/2secY3IT6iQ7MHUNm1Ror9S/36zzm8ccx737DsKB9MadZ/HXcO0PxHWy+xkakaqRRjj4iesFyBvJildCczLW7jMW9ltWbFeApUiHYf/FRC2qQXw2PkLbo+TQtKivZbr+GrYk9mHBb/q/X6lRIzfiU0MdXSHfdvxiHZAY76HCNSFnrHgQy3CkaZjCqMM82LYb2zVOPloj5+g+siAQlP827wLCMhEK9KUdP72tcqr4XGto8XIC1/20w4eXWeZwmEkH7x9LY7UQsNDyCWAt96IgZ9/L5cGnfheuuEF/tS4AWXvR47DhCbI/9fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(4326008)(76116006)(52536014)(8936002)(66446008)(66946007)(41300700001)(64756008)(82960400001)(33656002)(8676002)(7696005)(6506007)(5660300002)(9686003)(26005)(122000001)(83380400001)(54906003)(186003)(71200400001)(55016003)(316002)(38070700005)(38100700002)(66556008)(53546011)(478600001)(110136005)(86362001)(2906002)(66476007)(66899015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BF3D9pcqGSK4rjvFRRQQ4VGcxpwUgI/NNgRYjYV0tQtHH/TCfOdb++dyHtge?=
 =?us-ascii?Q?MlR9z1kJyAJ1AFo5pcOHjDckA69rszsxHKA9kw5ltTPm84HDWPneT7EVzb9r?=
 =?us-ascii?Q?YmEjaQ0UbAgyxVfUMLDjjDkE0WvduH7tCdMJCo27Sqzeg4MRQBB8S3z0CdQ3?=
 =?us-ascii?Q?IeRN35x/lA5I+LdlViROKUGaQUCiFty0cFlUK3PheY2BPP7pKODSbbiTROx1?=
 =?us-ascii?Q?kSFe0gNPrdX4DxDKMJBLdbz0lTned+T9MqfSR46gI6r8FS3/wiAHWpmDuPcs?=
 =?us-ascii?Q?DUMhd0gvfd2QCWP14utJv8sr9Rerk6TTIXEEiTameSO53hLZYBK7vUOgWZ1e?=
 =?us-ascii?Q?KPTek8vDoEM5+28JGiUBTRh2kfb/dd7umRR36ZeYTweO4SECBhXq0ByWXbSs?=
 =?us-ascii?Q?EW2Ctwc91JKLwP8Nrbsi4COdObV50Yn/vsZ/hu5NT8ovRqzpV8g3JI/ZnN9R?=
 =?us-ascii?Q?ZSqOl3g/wqfLqCVvdpcIMFRuhSoNustlMdxvinI2pLgQX1AfKdP/N1PtWaOl?=
 =?us-ascii?Q?5WPh+vIpad9YmLOUZCidb7cKPJx4YtiXA09f6Tk1UybXmiAZgLK/3rl0qPGA?=
 =?us-ascii?Q?fXScaPw2Uy34le8ubVPSgcFfOS6gNqY/4drCpUubidAMBEtq3n9zqq509iod?=
 =?us-ascii?Q?bF2SAMwM1AmmOI3JoK3S5L3+KZNiNbuM2PPjv4KXz028TlNdeyg7hoDHpQAp?=
 =?us-ascii?Q?QZnTNONseQQSWNQCWZwBhkWSTwu71N6HLG+aUeoOa5P2h2OCdLZyt5ojLjut?=
 =?us-ascii?Q?DP2A1wlKlyHhqskwr7YKa0NChfzCH2f5fTRaxiuNWuXfI3Zm4z9K6gna4Cki?=
 =?us-ascii?Q?BM0VP3oJJTwoJxOcLGc8sQfFHxfewGaena0yksWNZvKc9a7/GGH+9cMs6i9+?=
 =?us-ascii?Q?FnGR/HhasqfZx8rbZ2t8ywIux+MwtKYNnuI6dvArk1XQ5O3fvtIIwDGtUMjq?=
 =?us-ascii?Q?pvYhmq629yr6Me/TIEbQbvET1RVa9PhPA+M2XLhZ6DAnj+2tfwO19sExgc5z?=
 =?us-ascii?Q?GOV856KgeppyruCt8f2BCKHaZD7l4jZhFHoZ8o4TbsEfy+3JVHYWs6XxuwEz?=
 =?us-ascii?Q?v3P7c6Otjb4hLPmi8+ITenSXYWA2QyUfielhhF+9Tb6yCU47iBmPymy0V5xp?=
 =?us-ascii?Q?c9TRaMjiVe3EIjEC9w2bBE5gClfJ2mNbK08oC5K07LbivKKPoZWGdTDhtzLD?=
 =?us-ascii?Q?7C/PoqI0JXC9XbHtUU2R+UwaHQFlI2iNKgKgUfT1yT8AR1cs7B5yQOHR8SkM?=
 =?us-ascii?Q?s6DqJNGhPlgaYPVtvop0Fe1aVFIQqBfZRhTLQEH8YO8qWoZmuyZDQQdeZXI8?=
 =?us-ascii?Q?+Jh2dbJZIaVbSv7yUGpa4pn1PBcymU36gFKdc6a1Rs6uzmv51gAszQeHNVN9?=
 =?us-ascii?Q?VxWpdeBVxg/ZB+SZd+tjQiD2ampeQob1j3L7bAD3+Vf+Ho1P0UGnTDWV9o1Z?=
 =?us-ascii?Q?w59hg9/y9Jc0AQo3+VjDFR3KD1/7zXvF0GpS9KVsdVZgQfa5nxCiESZt3uAR?=
 =?us-ascii?Q?y/j7HVBArd2pmP0PEvh06K4Og60HA4eXHLBqclzSF0BICohUe7OHsVXmrWuq?=
 =?us-ascii?Q?tnYBRcy5shnf1myk2ib7KxpuukJHX23YEivkxHdH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8be5e00-b3bc-4a15-a1b2-08dacd8f9ced
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 20:16:32.3026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nyhZCsoujjbJA4DsFqKK2P33thvxiCUiJzNMYo21DD/gfx5ALDVAH2iISezJHmn5jRvVS4++b+DTIK6x7RtRTquDItBuBIUoRAuaFg2Gf2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7107
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Sent: Wednesday, November 23, 2022 6:18 AM
> To: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] net: loopback: use NET_NAME_PREDICTABLE for
> name_assign_type
>=20
> When the name_assign_type attribute was introduced (commit
> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
> loopback device was explicitly mentioned as one which would make use
> of NET_NAME_PREDICTABLE:
>=20
>     The name_assign_type attribute gives hints where the interface name o=
f a
>     given net-device comes from. These values are currently defined:
> ...
>       NET_NAME_PREDICTABLE:
>         The ifname has been assigned by the kernel in a predictable way
>         that is guaranteed to avoid reuse and always be the same for a
>         given device. Examples include statically created devices like
>         the loopback device [...]
>=20

Heh, so the doc says loopback is an example of this but we weren't using it=
 for that :D

> Switch to that so that reading /sys/class/net/lo/name_assign_type
> produces something sensible instead of returning -EINVAL.
>=20

This seems reasonable to me.

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>=20
> This is mostly cosmetic, but ideally I'd like to get to a situation
> where I don't need to do
>=20
>   assign_type=3D$(cat /sys/class/net/$dev/name_assign_type 2> /dev/null |=
| echo
> 0)
>=20
> or otherwise special-case [ $dev =3D "lo" ].
>=20
> As always, there's a small chance that this could cause a regression,
> but it seems extremely unlikely that anybody relies on
> /sys/class/net/lo/name_assign_type being unreadable and thus
> effectively is known to be NET_NAME_UNKNOWN.
>=20

I don't think I would consider this a regression. Previously name_assign_ty=
pe was returning an error here, now it reports something useful. And we kno=
w the name is predictable because=20
it is the loopback device.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/loopback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> index 14e8d04cb434..2e9742952c4e 100644
> --- a/drivers/net/loopback.c
> +++ b/drivers/net/loopback.c
> @@ -211,7 +211,7 @@ static __net_init int loopback_net_init(struct net *n=
et)
>  	int err;
>=20
>  	err =3D -ENOMEM;
> -	dev =3D alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
> +	dev =3D alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
>  	if (!dev)
>  		goto out;
>=20
> --
> 2.37.2

