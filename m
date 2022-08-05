Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA95758AE01
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241268AbiHEQV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241175AbiHEQVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:21:24 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306EC71BF0
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 09:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659716482; x=1691252482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0FXhvArqb75FJAd+c8E4NT295ayRaYcWult3h4fwHS4=;
  b=gotH++cQKyEXVP4fH5zIriAe36E8kdJF+FWHje+IfxMUHHS6ZskepVxo
   BsSFINq0nlEYCMhmdMLkjLV2N8nRMtB0FgIwH4P42uERewJ0FX489uXnF
   jRHx5vYeJBZwlZFrtJMOv0wFPMstdIQVEVulZjrm9xQ4W13LDd7prfVEO
   P5oBE6nm8oK7UAl15VZDaZwFm6yohs8K3MJAlw9wGjmv9iRre36PPaIW2
   4ng3pOXyJ8U5U7g7xEfneH+1RwqRl4ihXK1YssiDFWRmexQPvInvq0KJ5
   lET+vdNK7VLh0kL4UPXph31AxRdz8i674JGzLl7U43+cA4xVD786H85SB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="354234795"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="354234795"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 09:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="931281941"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 05 Aug 2022 09:21:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 09:21:20 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 09:21:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 09:21:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 09:21:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDG88sNtniqlvRbCsixo/ojbW0HizPBvqcNicHM+uMDPSqw9xpAvGIz3FTJ82QNvH06PrTd12m0Wi0vS6oP0PcJGbKEAwn/LdahMeVxNEcemP8NQvtZ9M8fkIdol2uj/XSGulgqQI/pM0rl3mP3Mi2/vaYuATqPQLQXNUW4lpd7U0m73B+pC/cBN8Kf3udZaHrnzmiBQ3w1vXXHmKadSHWvkLKx7C3Q+Aeck7ty/SGbxNpF7RWO+L1C9H6Ihpd1+0TRM52w3Fxj6WYXdPjGW4i7mI0nxUFqGuA8Yk1WiJVfphqBvOlwjc+9tz5id0oyS/Lqcx7C1zm+smiOLqjB/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXBBQ5quf+c6ZyA23e0eLzz7bUvh0dNZHEFoULljYvI=;
 b=G9Ad7dRO7o6bAa1GCPcf8eT55NWNHwfWUCMach4sCxZqFaoVaCq0l3rkVUdJ9X6LHPL4esGrtMhALR/cJ/FJvbhd4GLAZvKxe0qHvd4FMzSfRwTQNQR85pTN41FbjtdNZBSGe0tl4uzikzXCxwJU+7EW3G+I1NGUqu/ZFykj8IIKTmQ8sNksnbuNgWGCf0KGFgFuQHsnlD7ACMlv23tuekfwwPfaQIvhdzoNeYl7bpoBNIlK2h9htv/w4xhUPGl321wJu5QZyaEtu167nCkhaL6MbgTpPq48MscVZbrAa/UflRv9InLHmohbPpMxAay529uqxoz5zKOUF+mEo7P83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY4PR11MB0022.namprd11.prod.outlook.com (2603:10b6:910:79::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Fri, 5 Aug
 2022 16:21:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 16:21:16 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
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
Thread-Index: AQHYoxqTvuyVf0CqCkWk1qQvKmvjbq2giFWw
Date:   Fri, 5 Aug 2022 16:21:16 +0000
Message-ID: <CO1PR11MB50899F33FF6F1B95CD3F1B11D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220729071038.983101-1-jiri@resnulli.us>
 <20220729071038.983101-3-jiri@resnulli.us>
In-Reply-To: <20220729071038.983101-3-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59c0e498-0bd3-4563-9ecc-08da76fe85d4
x-ms-traffictypediagnostic: CY4PR11MB0022:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jlD/VRq6zun9dEUs9MLrH4K8LjKwRiCgC0rpwqDJxohFPEPWJsF0jfIFfnvJ8hqnEXjQD86KHRzRdnIgb1Q897+pecPNJ5G3umAwMuf7bj08YgqMGPvFPY9Q88UHo0tStbyXb7dJxDs4jFdlfRrajfWqpISaER9ReyWwYxAoFy5rT0aRc8IwLFyVWD/oiUUaTmlZWdNpLhLe/9u+RUqSgFPCFuLSVmVz/7Cp9qL1vCnFCSS5FGPsYOj8clZgP8isDmjUQ43aJmU9jCgHfC82mYTmK+Qo+CgLs25v4ZupS2E/jP0XfarvBxtJ5OHSsghuX2tQ6zVQcENr8+DlLoKqOKx0IwkT12T6u3RW8zF4BxnIqP9/CNVl9f1Mv+0EFUqcvOH0UC8B1l5YiF+1nySRffcLoAsqUEPnlr8yuQkOYmyfAttscBVPd+sO13TSH9JYQpnU6RInjKJolHhPZM1O9osP0O/8d1rcYgd4if9NPs0i2ALkQaqDnHDJ5lG5oGMpVe8KEhK8uSbP2rgtnu2UoZB4DkXBRHyL5MWl1A/7R1rOkK50W4G30Jf48urxLnDX36pgNodUXai6ro2j0SHzawy96YLELHyOZzcNhHkSwJPj2ru8bG2EhqJaviVxCsDhz69To7+leO4Q9QSetNGo77eFMwxMm/rUhukCsR2meyjFrzeToQB5TL5rQdxWdQoIojV00vmIlJB9tZ67BZmVmsyXaxUV6fnM+Ftl5hV38bwhrHH+a5cvILzJutY5z8rMRfGiI4gbyjUW37RV1XyxmwsbfXvyEIXT13rDZ7xa+wcrKSxptDcFs6S4zsZzee7M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(376002)(366004)(396003)(7696005)(2906002)(6506007)(316002)(53546011)(7416002)(8676002)(66446008)(66476007)(64756008)(76116006)(186003)(66556008)(26005)(9686003)(478600001)(33656002)(86362001)(55016003)(71200400001)(41300700001)(5660300002)(66946007)(54906003)(38070700005)(83380400001)(110136005)(52536014)(82960400001)(4326008)(8936002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mqBf0EGbNgYYxtiRmajDMOKzhcR7ToIp06p6fQs+ZfvfxY4RgZRuCgAo5Yy6?=
 =?us-ascii?Q?B7ZQlRRZVIgGv0ZA3x5iQsZA3WqFJZP3f1ecsnzJS7Q++L7PFRfpDQjkogWq?=
 =?us-ascii?Q?zMtx5HQpMwbHs1+A6MhhUL/5jULZVWrnAbnv9VFxuq/YSB4l2ARhKd/R0R+O?=
 =?us-ascii?Q?/idM9gZsg5b/66kj9FXo6RdyW1PGLENpU0+n64ygzqqMaoGVwlAhxuw+4GiU?=
 =?us-ascii?Q?KT6Oyu24xjviYdmbp4guz/i0y3jFF80i8fXB6dKRw9nDmF9UWqacTgdbJ/zk?=
 =?us-ascii?Q?4r5Pfqf6l/3+p3zW6/Vp8dSP93kq9xIizPdT+F0evkUW+7TnARiSFA4vsRwJ?=
 =?us-ascii?Q?/zjY76HjJRG6+QaZwwev6KJ7/YFVuleLSTekJMGLORPq84C/Nb3epDPsLnAh?=
 =?us-ascii?Q?mrjS1uXkhRenqlbR18RZZko49PDndaV2wwclMm/X0he9hZiYsfrtcmXBXIFC?=
 =?us-ascii?Q?EHldylH3WLh3GXljofVdw4ClQ7vhDVZjZi+PjY0VI6EMYw7eKEfc9OzxM1f4?=
 =?us-ascii?Q?kzMnifJXYWKUvZHxCJKQSLv1Q5WjCkyG/x6MCImzvMNDTqhejtzfGmthAEWY?=
 =?us-ascii?Q?AWRkqDT/cjyhwmfNU35Rz/UES9DHxo+GTKg4C6bEJmI6987hhkJdXl8toonM?=
 =?us-ascii?Q?6D0aMbHglVRgL9h1ddLS0w1XNOC3p7m2aRDhqslP2PcVIgHGxgdEJEaynb5A?=
 =?us-ascii?Q?F1KVFwJD7Nj13eZVi1pGIL08Dw1zvFGzauKlpNLU+kJ8efIOgkFNWqiVCrBy?=
 =?us-ascii?Q?LEEwRkEQBJBmb55dSUL528yP8AmvswavAVzCi0Z+1b0hBo8Qzn1MjoyXdzP0?=
 =?us-ascii?Q?1xi+eBMnO3VyWYn2P58xpdiiwVS+sB/Y2WFIJI3JaXm3tu/E4boEHHjEhDZP?=
 =?us-ascii?Q?9SnwpYKGWYNoHZXCHgUA14bSB6anrgQogrdXvZpKBjT9bYw5nnndGqU5B3I+?=
 =?us-ascii?Q?jUh5C5Qax6W5GFZLO7ZVQW16zqmoypxtgZVlKIPlPeCRkKLNXnWw4RBiqR0N?=
 =?us-ascii?Q?T3q0tmnu7zXTvW0i3ab4ttE1VnmLVWTDnJ1AO9xU1i1Xh0RzAT3k33yMz3k3?=
 =?us-ascii?Q?F/x88nDWLVkbZF664ChZqfrM+4eaxcfTJCK6e6sfkNWd0XYAOUTwCvxkjXye?=
 =?us-ascii?Q?ubnQn3Mg4fhiTDjtzDERuMsrW0eEhuFQyLk32UKK6bgYMpbZNkMR0hmkl75R?=
 =?us-ascii?Q?Kem/LsPCIfaq6PvuE/GooDcaWYwxS6AnYfVjskx7f9VcSJTzig+D4XbThxLe?=
 =?us-ascii?Q?bZMsxChjLtD+Ldk4IjDOHLrKhnuGWAlqXfGWWYT++/qQrhGSXY4R8vz6kmhS?=
 =?us-ascii?Q?SqpeSaeOPH8RAIhmKCkgSuh2yMjhM1vFvel55pkaegAe4h/7XVMwJflY/Wl0?=
 =?us-ascii?Q?/RvUAeHtmISvmzLSBezhu2c7a6VaJxVWGh42savcghSTFtNiV7NoZ+qos/8M?=
 =?us-ascii?Q?nW943fOxRQYYKcu56xSmPyEpqAWt+cYnANjneBcerPOFdZUaNskcng9zpE+p?=
 =?us-ascii?Q?9ncC1NHDaP2JCl+zvV0RqBrhLLPW5MnyD9sx077e/ViuRheqz3nblVzxiXDH?=
 =?us-ascii?Q?tbm/v32izcjSilD5LfWgXcDWhWAUxMS5D1gMw3cp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c0e498-0bd3-4563-9ecc-08da76fe85d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 16:21:16.4952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L8dgi8KOs98rQX21z7Cx5YTVT+ZfnribiBvp8y6pUc0inGwGIXVWRzC2Jl1W27ocYiMoaGLWhYnVeW0rcohMYWcy2Tp9+qusBDpZs6Ohmeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0022
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
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, July 29, 2022 12:11 AM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; idosch@nvidia.com;
> petrm@nvidia.com; pabeni@redhat.com; edumazet@google.com;
> mlxsw@nvidia.com; saeedm@nvidia.com; tariqt@nvidia.com; leon@kernel.org;
> moshe@nvidia.com
> Subject: [patch net-next 2/4] net: devlink: convert reload command to tak=
e
> implicit devlink->lock
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Convert reload command to behave the same way as the rest of the
> commands and let if be called with devlink->lock held. Remove the
> temporary devl_lock taking from drivers. As the DEVLINK_NL_FLAG_NO_LOCK
> flag is no longer used, remove it alongside.
>=20
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Wasn't reload avoiding the lock done so that drivers could perform other de=
vlink operations during reload? Or is that no longer a problem with the rec=
ent refactors done to move devlink initialization and such earlier so that =
its now safe?

Thanks,
Jake

> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c      |  4 ----
>  .../net/ethernet/mellanox/mlx5/core/devlink.c  |  4 ----
>  drivers/net/ethernet/mellanox/mlxsw/core.c     |  4 ----
>  drivers/net/netdevsim/dev.c                    |  6 ------
>  net/core/devlink.c                             | 18 +++++-------------
>  5 files changed, 5 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c
> b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 2c764d1d897d..78c5f40382c9 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3958,11 +3958,9 @@ static int mlx4_devlink_reload_down(struct devlink
> *devlink, bool netns_change,
>  		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not
> supported");
>  		return -EOPNOTSUPP;
>  	}
> -	devl_lock(devlink);
>  	if (persist->num_vfs)
>  		mlx4_warn(persist->dev, "Reload performed on PF, will cause
> reset on operating Virtual Functions\n");
>  	mlx4_restart_one_down(persist->pdev);
> -	devl_unlock(devlink);
>  	return 0;
>  }
>=20
> @@ -3975,10 +3973,8 @@ static int mlx4_devlink_reload_up(struct devlink
> *devlink, enum devlink_reload_a
>  	struct mlx4_dev_persistent *persist =3D dev->persist;
>  	int err;
>=20
> -	devl_lock(devlink);
>  	*actions_performed =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
>  	err =3D mlx4_restart_one_up(persist->pdev, true, devlink);
> -	devl_unlock(devlink);
>  	if (err)
>  		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=3D%d\n",
>  			 err);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index 1c05a7091698..66c6a7017695 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -164,7 +164,6 @@ static int mlx5_devlink_reload_down(struct devlink
> *devlink, bool netns_change,
>  		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is
> unfavorable");
>  	}
>=20
> -	devl_lock(devlink);
>  	switch (action) {
>  	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
>  		mlx5_unload_one_devl_locked(dev);
> @@ -181,7 +180,6 @@ static int mlx5_devlink_reload_down(struct devlink
> *devlink, bool netns_change,
>  		ret =3D -EOPNOTSUPP;
>  	}
>=20
> -	devl_unlock(devlink);
>  	return ret;
>  }
>=20
> @@ -192,7 +190,6 @@ static int mlx5_devlink_reload_up(struct devlink *dev=
link,
> enum devlink_reload_a
>  	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
>  	int ret =3D 0;
>=20
> -	devl_lock(devlink);
>  	*actions_performed =3D BIT(action);
>  	switch (action) {
>  	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
> @@ -211,7 +208,6 @@ static int mlx5_devlink_reload_up(struct devlink *dev=
link,
> enum devlink_reload_a
>  		ret =3D -EOPNOTSUPP;
>  	}
>=20
> -	devl_unlock(devlink);
>  	return ret;
>  }
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c
> b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index a48f893cf7b0..e12918b6baa1 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -1499,9 +1499,7 @@ mlxsw_devlink_core_bus_device_reload_down(struct
> devlink *devlink,
>  	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_RESET))
>  		return -EOPNOTSUPP;
>=20
> -	devl_lock(devlink);
>  	mlxsw_core_bus_device_unregister(mlxsw_core, true);
> -	devl_unlock(devlink);
>  	return 0;
>  }
>=20
> @@ -1515,12 +1513,10 @@ mlxsw_devlink_core_bus_device_reload_up(struct
> devlink *devlink, enum devlink_re
>=20
>  	*actions_performed =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>  			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
> -	devl_lock(devlink);
>  	err =3D mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>  					     mlxsw_core->bus,
>  					     mlxsw_core->bus_priv, true,
>  					     devlink, extack);
> -	devl_unlock(devlink);
>  	return err;
>  }
>=20
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 5802e80e8fe1..e88f783c297e 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -948,18 +948,15 @@ static int nsim_dev_reload_down(struct devlink
> *devlink, bool netns_change,
>  {
>  	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
>=20
> -	devl_lock(devlink);
>  	if (nsim_dev->dont_allow_reload) {
>  		/* For testing purposes, user set debugfs dont_allow_reload
>  		 * value to true. So forbid it.
>  		 */
>  		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for
> testing purposes");
> -		devl_unlock(devlink);
>  		return -EOPNOTSUPP;
>  	}
>=20
>  	nsim_dev_reload_destroy(nsim_dev);
> -	devl_unlock(devlink);
>  	return 0;
>  }
>=20
> @@ -970,19 +967,16 @@ static int nsim_dev_reload_up(struct devlink *devli=
nk,
> enum devlink_reload_actio
>  	struct nsim_dev *nsim_dev =3D devlink_priv(devlink);
>  	int ret;
>=20
> -	devl_lock(devlink);
>  	if (nsim_dev->fail_reload) {
>  		/* For testing purposes, user set debugfs fail_reload
>  		 * value to true. Fail right away.
>  		 */
>  		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for
> testing purposes");
> -		devl_unlock(devlink);
>  		return -EINVAL;
>  	}
>=20
>  	*actions_performed =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
>  	ret =3D nsim_dev_reload_create(nsim_dev, extack);
> -	devl_unlock(devlink);
>  	return ret;
>  }
>=20
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 6b20196ada1a..57865b231364 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -768,12 +768,6 @@ devlink_region_snapshot_get_by_id(struct
> devlink_region *region, u32 id)
>  #define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
>  #define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
>=20
> -/* The per devlink instance lock is taken by default in the pre-doit
> - * operation, yet several commands do not require this. The global
> - * devlink lock is taken and protects from disruption by user-calls.
> - */
> -#define DEVLINK_NL_FLAG_NO_LOCK			BIT(5)
> -
>  static int devlink_nl_pre_doit(const struct genl_ops *ops,
>  			       struct sk_buff *skb, struct genl_info *info)
>  {
> @@ -788,8 +782,7 @@ static int devlink_nl_pre_doit(const struct genl_ops =
*ops,
>  		mutex_unlock(&devlink_mutex);
>  		return PTR_ERR(devlink);
>  	}
> -	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> -		devl_lock(devlink);
> +	devl_lock(devlink);
>  	info->user_ptr[0] =3D devlink;
>  	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
>  		devlink_port =3D devlink_port_get_from_info(devlink, info);
> @@ -831,8 +824,7 @@ static int devlink_nl_pre_doit(const struct genl_ops =
*ops,
>  	return 0;
>=20
>  unlock:
> -	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> -		devl_unlock(devlink);
> +	devl_unlock(devlink);
>  	devlink_put(devlink);
>  	mutex_unlock(&devlink_mutex);
>  	return err;
> @@ -849,8 +841,7 @@ static void devlink_nl_post_doit(const struct genl_op=
s
> *ops,
>  		linecard =3D info->user_ptr[1];
>  		devlink_linecard_put(linecard);
>  	}
> -	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> -		devl_unlock(devlink);
> +	devl_unlock(devlink);
>  	devlink_put(devlink);
>  	mutex_unlock(&devlink_mutex);
>  }
> @@ -9414,7 +9405,6 @@ static const struct genl_small_ops devlink_nl_ops[]=
 =3D {
>  		.validate =3D GENL_DONT_VALIDATE_STRICT |
> GENL_DONT_VALIDATE_DUMP,
>  		.doit =3D devlink_nl_cmd_reload,
>  		.flags =3D GENL_ADMIN_PERM,
> -		.internal_flags =3D DEVLINK_NL_FLAG_NO_LOCK,
>  	},
>  	{
>  		.cmd =3D DEVLINK_CMD_PARAM_GET,
> @@ -12507,10 +12497,12 @@ static void __net_exit
> devlink_pernet_pre_exit(struct net *net)
>  	mutex_lock(&devlink_mutex);
>  	devlinks_xa_for_each_registered_get(net, index, devlink) {
>  		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
> +		mutex_lock(&devlink->lock);
>  		err =3D devlink_reload(devlink, &init_net,
>  				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>  				     DEVLINK_RELOAD_LIMIT_UNSPEC,
>  				     &actions_performed, NULL);
> +		mutex_unlock(&devlink->lock);
>  		if (err && err !=3D -EOPNOTSUPP)
>  			pr_warn("Failed to reload devlink instance into
> init_net\n");
>  		devlink_put(devlink);
> --
> 2.35.3

