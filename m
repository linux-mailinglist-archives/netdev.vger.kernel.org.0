Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F72C622074
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiKHXte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKHXtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:49:14 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C8C45EFA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667951354; x=1699487354;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rlteHe6S0HcjzohvcaEB9ufUkqzn5vkkpFUAOIVlRdA=;
  b=BrGJXRciHqd6a/lesYsKWaZbUtFa079hXxShUSYE9zAC+v+kdeg5ChXT
   dqNxI4+VoKlgSLmmfKu60eaJVJnmcnJu4yK/bgx66Cz5CMc037iCg+BT8
   Hs54Xsl+2K+GZOi2qZYgIVhk7/AW5xq5ozWgDkf5WwsZronB9FVGI3w4R
   7d55mDGTVXXy+/PkHcqkD5yBaqW1DYCj2+fmqezb+tlmu1u4Pp3028umX
   Y2TLTznbJCc9E44nE2jtV/u/saQQYJ6kxM44S73/293zQR+HAlmFmDPM+
   +R3C5+BBMbf3j4bjnKjmA+RdylCERHRxtViDc33SOIruVXxpvmi99QISZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="309550829"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="309550829"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 15:49:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="614462489"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="614462489"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2022 15:49:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 15:49:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 15:49:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 15:49:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 15:49:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmEEvQ1QkSlrkTADdzJFbxtzUesFYlxrtps2u4Q4eD49SXD74DJ9ZrnqEECBoK2aUUStFxsB0QwgiKdY0I9TEaUwhrF8wgLzOy0X826qjVEoWXTKfExvhC7/K7eCwX3io0l7nWFe6YKdTTQZ0YgJEPGFS6wN3aPxdtnP3JKgk8VIKuBhvBUSZddjyVAchMgH+psvcZP4V72cpVksDviswk7BLm6vXlyVeyJe6+1UAJcCaIIUEQJK2xCrFmSenD85m95hEPNUmFQwZ794uhFDymAjCVJG/KTsrqWaUOY+T0aj4vGoUt50IJGDwaTvotffDunYYnopMDv8Ryb7Y12s6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FosyRo9qMGlPF5VI6Zmfyi5N0ZobItOp/7O2mkcZXxQ=;
 b=K0rEH3PxKbACkEmr2qu2t2OAjU8ve3uqcrTwu/3cdKz/HihsQJilQlr117lduWUC7NDvPdk+6qUJ/6LC7UAzNPhyZYDjKbigksX5OUv8KFLP9qHmlP6W8HHr4MN+SiBvpeArEcVxpebXdVlUAKo9VKwLnlk/lymiRnh+uYeshLgnyuJcsjflWjM/IkW3UdzKJQU437ugjlv/n9lvCweQoosBZgYUJFbchAUxJX5NtTMdnnjgev46VQcokyA2LtfNtazi8onbEOng2ySWI0W7NVy8ldwau+s+VDGZCY2z912VR2fE/w6Vui3tj8YF+bdxjQ0vtTEx3F2nYSTvc/Eqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB7111.namprd11.prod.outlook.com (2603:10b6:806:2b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 23:49:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 23:49:10 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Jonathan Lemon <bsd@meta.com>
Subject: RE: [PATCH net-next] genetlink: fix policy dump for dumps
Thread-Topic: [PATCH net-next] genetlink: fix policy dump for dumps
Thread-Index: AQHY87J3PJ91FsvdGkawuKDY7cP1mK41fsCQgAAx7QCAAAE3sA==
Date:   Tue, 8 Nov 2022 23:49:10 +0000
Message-ID: <CO1PR11MB5089B5FB303D6B29367E0FF3D63F9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221108204041.330172-1-kuba@kernel.org>
        <CO1PR11MB5089F3CECB59624025A648A3D63F9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20221108154426.3a882067@kernel.org>
In-Reply-To: <20221108154426.3a882067@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SA1PR11MB7111:EE_
x-ms-office365-filtering-correlation-id: 0ac8e042-0b50-436d-0643-08dac1e3d579
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e1t3EpgQ8w66xNNJgMumKgl8b72AQgwZJSO45fZvUFSPosT6FpM9DyGNIdTfPibkk2SF0lzsIYtKqFE/vl+pBODmCaan1j4SlVxMO4pX+IilvA4u3qefbTeGseSa5deWwHSZqd3fVqQ8xwpFLP+goSSWT0DDHuA3enaILgQnh8Czz6gA1MZkLdLcWOaCfvEyzAXKTHpje3/T8zfeVcG1xfAqChdBRWdLITSsr3aN4+59E83zlwTlHIkwSBBb+9noKmN5ofSfs2HTVI8alGWyBMnquLCOdq0euQkXeqYw4ByGSNKta8/DfIgo++DP1c2YGvmthKjmwaLtSj0smnBEsTWFbQKNMGIgBY+bk77EO0VUaQuOsCeFAHc4nvxpt9Lp3zIWe5lDHpopCn00SJwHWiMa+Y2AbvGMAWKpIfP9Djsp+TMeloQ4vU9ssip3BF2/TSPKKXfvVN7Km0N92ZkqLHuoYEfi3H9uckwSc9nFCRqN1ZLK3WhdQDUK+pFmh8qG56jPwH02oGHqQgSMVGA/yy5vJpbyfwY4jpO/5SGiUQ+PxKuSlfJcEFppcxHUqIx2dRnp+DzaqbMmHTKgcsdw6DTY9QLZc+YXM+hKHRGvVhAq3y/zbwT2GsbLB8PXwpEP1AiaIMpwhYg8x1E7sHnksGENl0qfeVmTEezm0DxzaKgepUGM1OkWJvtRbkMKGSNjs2y061mk4IcufivB9+1IjZsgbktBM9moM95xt1O34jXguOBf90rjq2553ZaPQgojq9Ou+xDHe1o2hb2NtJnoGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199015)(66946007)(66446008)(66476007)(478600001)(33656002)(76116006)(316002)(52536014)(4326008)(66556008)(8676002)(64756008)(5660300002)(83380400001)(8936002)(2906002)(71200400001)(6916009)(55016003)(38070700005)(41300700001)(9686003)(122000001)(38100700002)(7696005)(86362001)(6506007)(186003)(26005)(53546011)(54906003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P5hQhfAN2M9PgttXr0uv6fK9K3Oa7s0cNxnsqq/FqE478MuDAhU1FcosQXoZ?=
 =?us-ascii?Q?jDfNaUeL+1vtmiwdA4SkB75rJSX+ctu5MIdA6ocNY3PbjG4Sq1nbYOT/jYI9?=
 =?us-ascii?Q?cchCD5MZZySCjkZYK/S836dAtILpthLAtnPPOVNMrxFjqTgjMIHh+HgypqxA?=
 =?us-ascii?Q?ebgKxMejw0NZRz0s/qiL21aDxSmG6v/BGaxLkDr2w7y+MHiLhiNmqVaX93/f?=
 =?us-ascii?Q?eg5NEU/GAanL4g61MstXUfC8Dc2H/Pdtm4FBZzFIgxkS/PEayRT76lMi0UJo?=
 =?us-ascii?Q?cw7GDLdr5vvwGkFLUIGZEpkcXFjs/L1y2Kv8hOxvPdVZEA+so0T71bwj3hXh?=
 =?us-ascii?Q?tqiFxpRlV1O79EhbDJ7j6Y3PXnFuTPosqzjfOVzq64n6G3/Lm4wuezYVXA5X?=
 =?us-ascii?Q?nBKHA6B/skIuRw+RUHwdbwxU40qcUW2dtCyzhgfvTkoOTQollgxrCc0khpv4?=
 =?us-ascii?Q?cvC9HoUBEty+ZYsIxk2xGtWw0JwIW/te3YzUBjqqBHumvJbjdKeHM/HxrKp+?=
 =?us-ascii?Q?IY8nyyn0Ug+zBzw68fbsOax0lRFHBpxUboWmC3GBB5heLqXZeqwT4hyBKz+K?=
 =?us-ascii?Q?KzmRlmorombURLORCQ3t6kTGckU/UiKnaMGA7WVsdBblr2FIVPN8IeID7kjL?=
 =?us-ascii?Q?hxZyfcE0OI/IXd/tuXHw8s8UB+RgsGwqSAo7ytvcf7GEf38N4xGK5W3NsVQw?=
 =?us-ascii?Q?NtZDntBu0mS4xEQwZvjW5sCLOUfs0PBSFdw59ZyzYeUkdt1xcIX9vmxTvJ3/?=
 =?us-ascii?Q?brYg/Fd1U4oQc5d+sa3795/iiwqd5HXCVOGTnbMmzPHj42+8vkW7JZDRpdQq?=
 =?us-ascii?Q?ebjjZaXVpvQddjDlYJ6u98beNlfbaCQzvIl5OCejwNRcjZITPeZdm6YZFfE5?=
 =?us-ascii?Q?LRvo5lRQbOUB/iOpPfGY2LcyTGge6c7sKb4F3ls/fNCkTuWT9ZdaVjpaB9gz?=
 =?us-ascii?Q?Rg5oflsGyiB/ZrghNzfS1/3CjWkMYeaTjBFl7nAds/uN/PIj+l8XK4prxbsZ?=
 =?us-ascii?Q?lIjruHF1QdQ0NnJaYwkua09KjV78GYDpj7VrS1ozZlIFEYFkjAxd9AX+t+Cz?=
 =?us-ascii?Q?6XafKB6rbtU5nH1TViSmqq2RXZi7QOUViYHbpV94zZkVRLuNbn9NO+qBKNn4?=
 =?us-ascii?Q?p9HxoS1IScMZr8ku1F+hcTcorP6MUsiyRwIQ66aT8/Bm56wKmP+ewcrM73++?=
 =?us-ascii?Q?sRht6Y4XXLjNlpd+FrZpHueQwGnTDiiee/o+ezXf2HGVUSP17iCHkUHG1W6a?=
 =?us-ascii?Q?iPLb4xvXIYJB1bOlIXLxeGYYthT6emfb8TC1HTYZdXj0b8AzE7wN+Wl2kKRk?=
 =?us-ascii?Q?Q9Ea6+XQVB6ZK3OE2D2nLTXevmp5Mt1AHSACV8gd6k1WPEPD9HYdfvtadokn?=
 =?us-ascii?Q?lubtY66cr+zC3JoRktwU6WDMr95CXBueT7YYWZgMdffvy0uiPf7QZv/1PmmO?=
 =?us-ascii?Q?uT4FMOOotcnyIVfDpD/JJbYxHGQIVnZE3nhbLUov5EZT6JZl8iGDe6zSmjCg?=
 =?us-ascii?Q?jUct+rehy0ZA4a8Y36o81r8oXitUGa3ZbtLiATwUq6pqhZopixDKIYptpuyX?=
 =?us-ascii?Q?Z46tkI6avDPTvnlUUUHcHGF97A0yHGM2EUnryctw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac8e042-0b50-436d-0643-08dac1e3d579
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 23:49:10.9405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqSDOpmbatD9IrWgi8pWk0d+Eg5N/XCxrRhnsrkdtVof1CcaGlMKWG/ZiNR6Vv9DQI6N9nyMCS4qAkoQPlm6zW+7prybB779856Zz+yRxM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7111
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 8, 2022 3:44 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; edumazet@google.com;
> pabeni@redhat.com; Jonathan Lemon <bsd@meta.com>
> Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
>=20
> On Tue, 8 Nov 2022 20:47:57 +0000 Keller, Jacob E wrote:
> > A little bit tricky code here, but it makes sense. We could rewrite thi=
s to be a bit
> more verbose like:
> >
> > doit_err =3D genl_get_cmd(.. GENL_CMD_CAP_DO ..);
> > dumpit_err =3D genl_get_cmd(.. GENL_CMD_CAP_DUMPIT ..);
> > if (doit_err && dumpit_err) {
> >   ...
> > }
> >
> > That might be a bit easier to read than the !! ( ) + ( ) < 1 notation.
>=20
> True, I should not give into the bit math temptations.
>=20
> How about a helper:
>=20

Much better, the little explanation about the zero init helps too.

Thanks,
Jake

> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 9b7dfc45dd67..600993c80050 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -282,6 +282,7 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
>  	return 0;
>  }
>=20
> +/* Must make sure that op is initialized to 0 on failure */
>  static int
>  genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
>  	     struct genl_split_ops *op)
> @@ -302,6 +303,21 @@ genl_get_cmd(u32 cmd, u8 flags, const struct
> genl_family *family,
>  	return err;
>  }
>=20
> +/* For policy dumping only, get ops of both do and dump.
> + * Fail if both are missing, genl_get_cmd() will zero-init in case of fa=
ilure.
> + */
> +static int
> +genl_get_cmd_both(u32 cmd, const struct genl_family *family,
> +		  struct genl_split_ops *doit, struct genl_split_ops *dumpit)
> +{
> +	int err1, err2;
> +
> +	err1 =3D genl_get_cmd(cmd, GENL_CMD_CAP_DO, family, doit);
> +	err2 =3D genl_get_cmd(cmd, GENL_CMD_CAP_DUMP, family, dumpit);
> +
> +	return err1 && err2 ? -ENOENT : 0;
> +}
> +
>  static bool
>  genl_op_iter_init(const struct genl_family *family, struct genl_op_iter =
*iter)
>  {
> @@ -1406,10 +1422,10 @@ static int ctrl_dumppolicy_start(struct
> netlink_callback *cb)
>  		ctx->single_op =3D true;
>  		ctx->op =3D nla_get_u32(tb[CTRL_ATTR_OP]);
>=20
> -		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> -		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
> +		err =3D genl_get_cmd_both(ctx->op, rt, &doit, &dump);
> +		if (err) {
>  			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
> -			return -ENOENT;
> +			return err;
>  		}
>=20
>  		if (doit.policy) {
> @@ -1551,13 +1567,9 @@ static int ctrl_dumppolicy(struct sk_buff *skb, st=
ruct
> netlink_callback *cb)
>  		if (ctx->single_op) {
>  			struct genl_split_ops doit, dumpit;
>=20
> -			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
> -					 ctx->rt, &doit) &&
> -			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
> -					 ctx->rt, &dumpit)) {
> -				WARN_ON(1);
> +			if (WARN_ON(genl_get_cmd_both(ctx->op, ctx->rt,
> +						      &doit, &dumpit)))
>  				return -ENOENT;
> -			}
>=20
>  			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
>  				return skb->len;
> --
> 2.38.1

