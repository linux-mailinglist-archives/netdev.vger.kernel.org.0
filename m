Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8818623428
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiKIUGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIUGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:06:08 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC982DC3
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668024364; x=1699560364;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=el4IveaMJyLlvlWJgC1yYhGFaf0WUSEfSFXh83YBr3I=;
  b=Fpftl8u8p28sHwIdlk4ReMG5OkllmMJLGAhZriKHIzTDk394uchTXW4D
   qVKt62mgjc4+H6nUqxh6SXQVaFPv0gokkohQzm6QGvJYqi78njM8WBU1y
   RxRrCKyYoDszE8UaBbpLPuCGJzwPi8ZjvIFAGeiw77KHWzq3NDrfwxqSj
   4FVDB8wWClOWtvoMTYD8qVp0nPLS0p2W7lnVOf56V165bsz2nPNMqm/43
   TB+yyydHTYfRXrmuxQ4JhbpfQZy42N9PcoaIVcmiTP1zAHp25+mmnbiaJ
   AxEoARD3NwUDjt6Wm+HulorMhOZCOGjZCCClExq1HVZ/e9upRBOfuhtW2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="291483816"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="291483816"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 12:05:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631377923"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="631377923"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 12:05:06 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 12:05:05 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 12:05:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 12:05:04 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 12:05:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4fP1NWEWXtskGAnvsfCM72AU1cRAbE7ZQd9MIyojS9bHP/2NOF6c4eq5MXtMyCCWDaFSpHMHw4z3l3vwoO2Rz+usdpkH4uNV5aT+OdawRuP4uUtTX6eXvTaZcKlS2//ngzx+LGL/61u6ROGTqBAqV7O8+R5Xlb9Coc9PqLRRdqoUlWFxlzVDSRN+mNJMFQL3Dh77gLyGKelSVFGKPqT2wptFgYOy6Ud2+zxJfZWErj1w6yWMLo5WweL/imeJmN4iU2FmfUrDB7nwHBmhzEs37LlFnGKg1hmV669YJ2he3v6TbYv5jZHrPyJqor2Gt/nZwr6fQRyv2PVhC7qDrfC5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1F2xGMenQ1e1aNvPb9HISyqg+qEIcgIFmJvSvfNRAPQ=;
 b=CcOUrC5hZ+JeB1yf8Mm8NijrTk4s/9n9Jf8OiOLHEGA42epmzSBlU6d/AumhQCayTRkqwDtXbmfsIrzAqixf7HrnTQ2qh3cEE/aNn2Wgfzfv8DH21LlEIf62eZrIPRIS7FjfdY485RhkwQY+2rHKXMLq9T5aQgmVPYQ5uPASZ9bIsRVbgbD5kDAQ8ltzvSn2bV2mKCNNE7XkXMUGcfYdSuhQdnwKkX3dOLGYyUuyJTSF2jCMbWeqgoPoZ3WJb8YTq4eHY2cX1wf7qOSv0xSNr/0ELZfkmDgO3KmKlywYaqH8Bml0+WJu8JeHD/F0usbz4XifcmicnCcGaIxFQcI+Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5022.namprd11.prod.outlook.com (2603:10b6:a03:2d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 20:05:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 20:05:01 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Jonathan Lemon" <bsd@meta.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v2] genetlink: fix single op policy dump when do
 is present
Thread-Topic: [PATCH net-next v2] genetlink: fix single op policy dump when do
 is present
Thread-Index: AQHY9Gm/n48rXMSbQE21exUVUGGazK43BCSA
Date:   Wed, 9 Nov 2022 20:05:01 +0000
Message-ID: <CO1PR11MB508906457A3065689598DAC7D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221109183254.554051-1-kuba@kernel.org>
In-Reply-To: <20221109183254.554051-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5022:EE_
x-ms-office365-filtering-correlation-id: d9c2d857-4ce8-43a3-b764-08dac28daf76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: emO+5/8GkmZoVT2vcYxk8JlHFqKteiF9Z9j1154tIt786msFvp9Sxch01p544F/gSqOfq6UWYeN8Bg1llwVDkf/Mxzi42l5ah/GxQYv/YkWYbqC5h3vral7Kia4Y/aFcOGjfmBr9KvSjtVSrJoLLxVVHko1FkwP5Nc3xoMoxlfoBMTOms97387nWwFds1qkjr6Qrqpy7NZU0A8n7GVXqPDF0iAE5gkz+XAMYU+E+SdkCbzu3AoqIU2f2QNyOYIhIp6Gu6T9SUOn4urrFO+dMkEM/Zj9JMC1zV1DxIHN4rBPlrAZf0IGubPsaWzvvt1/TFzuEuOYRVgU0tjyGWQ1XY/wXMsXpi1kYjYFFAptjj82QVu/GLVnTYWMITnOAMzuGFZDSsDYd738T6rb2a6P+da0KAJV5B9l2THnHywIIG4uFC24EFPohZfS/urohF9kq+HNh/6+jJcp3F5gMpL510IyJrzcwIAvwCwXnn2hu6sVrSHuYH2Rp2RGmVivLOV4ivaoQ4AwirjIB0rEcipKg2Auh9sHoyBB6+UwHTvr6Xy5NP+i8jLSzggxPSz78hq3eUucQIVKRt7Ak9bSFn9et3WRP/tV7pJYA24YMoTtU4upSvPx7XejZNaXN5R5s0m4SW/mQXHvdWp6FFklFSI7EqYaDbXM3/t0BY9aY6QvQVQem8uDXKJ0RwI8WP9QAN2EOEYuqsQ7IsroaQxwj5k+c655FQEFlNOxgBBTcVyZhhXIFfGtvmsx4VEmwZM/XVgKb/jhZFYn/MdDnxzOc9/ALsf+PNXnLvu5hWUb14hzDQk8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199015)(122000001)(2906002)(966005)(55016003)(71200400001)(478600001)(316002)(6506007)(64756008)(66946007)(9686003)(7696005)(66476007)(66556008)(66446008)(8676002)(26005)(53546011)(4326008)(186003)(41300700001)(52536014)(76116006)(5660300002)(8936002)(33656002)(82960400001)(86362001)(38100700002)(54906003)(38070700005)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Og24+G/FZ8RFy0acInp5gyBZsIbLz8AaYOoxpvn6n5eDSVccJu2bYkUaaoo3?=
 =?us-ascii?Q?Ex3IZFIUe7dz8Few8BjVmN0O7g/7NqF3COpOrIyggqiuXhiGfG9QqzfOeSMu?=
 =?us-ascii?Q?IVchTtI+rO7Xp+x+Akme4spkjnVPo2g4L3+ktVFskafh+Lee6kvMRcEFrcTC?=
 =?us-ascii?Q?neCBDYpGi+1E98Qo+vkLO617smhQQbGqhPkmYIYyeK4eJyUY+iCkIftt0HJ6?=
 =?us-ascii?Q?0T4tzJBmiqSKV5cV92M09Q4crKeqrrIAWpi2a66IgckwRMeLMyf+x6hl4Kx1?=
 =?us-ascii?Q?DeTIMf/000fMlyrnQPlWOGzJ061TEilNG4E+4wcL2AbiiuS5I6mzW3OBfmhI?=
 =?us-ascii?Q?IKc7zZppDn5/ORuJLW5Tooo0/GQavjT/aYTX5Aa2LslJs+VwnnajiLIJJEyB?=
 =?us-ascii?Q?0RmPXd+O4qKKzU3k0j0voK/uwCbV54aViDzwchqJBlYAl/HKFhbVRqD85o/t?=
 =?us-ascii?Q?D0CDBUbH9q42Boi+s7ozlH8hxGlWIswDsa6QwUmnaxGbX6ZiqG5beozMiL/X?=
 =?us-ascii?Q?ajihWxz8Jg4p9CFk8Fv+dUGQxpfk2spjJXFzt/PNoDtzSAaM0uFpF/nXkxJf?=
 =?us-ascii?Q?j5CUEz2xjuW4uVICODKdff9pPVI2yJu4XTXzM2/YegSno/Z+wgazTBUZWJiE?=
 =?us-ascii?Q?cEqsaTln4K1ARn8Z0Oa3Wd1Y0a9jXeSY2KujChfzILY6pe6jcVmeubws4+mR?=
 =?us-ascii?Q?hYoIidPHIic5VwUxdfAs6a2DH2KqFEpYCbBO5DDPj7139E9zkMI4KTTFwmFX?=
 =?us-ascii?Q?KBQ7gwkshW4guxQBIfxOzxY5kjEhsPMsVds7lJrV+gveda8nIyJB1oRHjEMt?=
 =?us-ascii?Q?O3M5zZffChiUWxdRKZ1zGBJtrz3BfnxGBfINuSK3k2iqE4coPfzRJEbgDNtQ?=
 =?us-ascii?Q?VdU+Wq/D49DQRpe+RPJ9lrK9XD7JDH5oBByyg/uFJcH6YLq06EyvEybzODA0?=
 =?us-ascii?Q?wNwCbbymQt/IVx50HVrLUVX5+siu/Rtg9yFZ/R7e/cUnvcYKSUhA1KLd7RTH?=
 =?us-ascii?Q?A3aYs29Eg9bBok4pU+2F9tGyLFGxMw/xgTqn1ltd27M7mWgp/p0XSB5hidEm?=
 =?us-ascii?Q?cKUzWSbEDDgXXoolZvJ++XNBj4TfZa3VX7r7pjd0Ku6/E2+nJmP3QkEoAqc4?=
 =?us-ascii?Q?0iiatHEf1vmsRbZpf9bUfx4l8DrS8gAhODJpgCmsUSU5L8Fi1t0jvkbmXxNz?=
 =?us-ascii?Q?i5+VQWPUgXWRkGcrIyh359cyZWXX+1+SnVvKMRkrpS0T1hvhaVjJ7xU/HVdp?=
 =?us-ascii?Q?jK3wyXAhud4Es8hT7lE89P2sMZDBzEcsOApFbRhTyLPLu79zX1YDaTugjVwy?=
 =?us-ascii?Q?xDk+3+9wdDvkLcjr03lDlD35/xtVjnX8y+USrxoRvubSfx8ZIsuQGFkTRcu8?=
 =?us-ascii?Q?nKprFK2aUs4sQCmEIM4Zug4hHPyl47sNvjLIxdwsqAOqZKqsGjzv/UJ0Jyu9?=
 =?us-ascii?Q?HdRNj2hHrvuUhwCfiemnbbIs62vFHlfazD4Ev8Rj24vDYEeI5fZ/A0EIJPqI?=
 =?us-ascii?Q?BVkl6Sy2M/pXs+0yYisdgUNtEx4v4v8USgz74K5hleyFhu0a3wmFo9aR5DwK?=
 =?us-ascii?Q?h//XwLYH9AiDPywIdy8BBJdE5AkIX0+BnTz94SzJ1ZQzMXIoVQi2NcZmzHtF?=
 =?us-ascii?Q?1w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c2d857-4ce8-43a3-b764-08dac28daf76
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 20:05:01.6160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJTLiC/na0y+7MISvXd38z9eUMfEACuvhzXS4d7raGwYHWI+s0sAwkhohfub2pLY2lBozbGuZUh4k+ZxC66VL5At+3IhzbC8n6i496I66Vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5022
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 9, 2022 10:33 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Jakub Kicinski <kuba@kernel.org>; Jonathan Lemon <bsd@meta.com>; Keller,
> Jacob E <jacob.e.keller@intel.com>; leon@kernel.org
> Subject: [PATCH net-next v2] genetlink: fix single op policy dump when do=
 is
> present
>=20
> Jonathan reports crashes when running net-next in Meta's fleet.
> Stats collection uses ethtool -I which does a per-op policy dump
> to check if stats are supported. We don't initialize the dumpit
> information if doit succeeds due to evaluation short-circuiting.
>=20
> The crash may look like this:
>=20
>    BUG: kernel NULL pointer dereference, address: 0000000000000cc0
>    RIP: 0010:netlink_policy_dump_add_policy+0x174/0x2a0
>      ctrl_dumppolicy_start+0x19f/0x2f0
>      genl_start+0xe7/0x140
>=20
> Or we may trigger a warning:
>=20
>    WARNING: CPU: 1 PID: 785 at net/netlink/policy.c:87
> netlink_policy_dump_get_policy_idx+0x79/0x80
>    RIP: 0010:netlink_policy_dump_get_policy_idx+0x79/0x80
>      ctrl_dumppolicy_put_op+0x214/0x360
>=20
> depending on what garbage we pick up from the stack.
>=20

Thanks!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Reported-by: Jonathan Lemon <bsd@meta.com>
> Fixes: 26588edbef60 ("genetlink: support split policies in
> ctrl_dumppolicy_put_op()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jacob.e.keller@intel.com
> CC: leon@kernel.org
>=20
> v2:
>  - add a helper instead of doing magic sums
>  - improve title
> v1: https://lore.kernel.org/all/20221108204041.330172-1-kuba@kernel.org/
> ---
>  net/netlink/genetlink.c | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
>=20
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

