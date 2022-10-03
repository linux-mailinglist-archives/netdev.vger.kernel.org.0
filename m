Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754115F2E92
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJCKCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiJCKCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:02:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B4348C91
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664791357; x=1696327357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O3MuIhJ1XV6LaSUBaX0KqOUluGKYBWDjsYL78b1pcxA=;
  b=jkSazCkbIWVcUimhqbREPe2ObUCm39JbBrgANojl1E0xlzX/v+Huhw3B
   XWTKgsTOpqFNTr8xwFOhSRsBF8C9wapZLJxkeMmA53liK/08uMdnslmzv
   wr/TNue2hOLYfqiSDZDo8Ssfd5BusCZ0yEpj7dlrS/upbbAtLwSKsBsij
   TumMpYiLOpZe+stE1LDzAeZ6Y8Cqt2b5xC1VImYXQhmzVB77I+INfYizs
   Hc8bF9/yVGNfdzzgNRtp0zU8Ltotmm8NIbGMhP8Htvxn669+FbDkGbFfW
   FxKzY720gCsNJUdKPjKDI5fcSYVlJIMDuQwmyGx8xA4u0nTLhpKH5SC0y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="388884117"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="388884117"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 03:02:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="748929801"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="748929801"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 03 Oct 2022 03:02:19 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 03:02:19 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 03:02:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 03:02:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 03:02:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0xpw/y4H8vZgb/FtlJksjT4vNXW65L/mqi0lU1yWiU0/u+uDWijjZObLVhBM6yLm4bLvIcMIljKc2REyVEagbU4f8jegu35jSBzGnyGnIHEQegWW6DFGtum/s6EQ18DaJLyAV3VVXltK/mJTs6HOrneeQdthKyrwRw1GUE891RQ/hmuHekClWZp654SzvdT3h20TbgFqZxx0GNBAZjE1igNJWXYqIB/7dDkfieUbU3aCTrLVtSU9r9ijEL00XymF7bP+juf4UWEQLUCHphlwCn4+A4OtN+8vou/OmDfpCepDrxP5OFVRM/3pWl43hpEx77OqPj4Cdo4DsZS7Fm+ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjLqcvfTT0zZaPhYWq6kxuPyir3rNQpULg7DdZ5BowY=;
 b=WKHvxDN/ofBSG5Ebv88nPWCdoGbxz6/Dl8CWGIvlBEidaCDvd5hZf7UwiB5dWGpfHF/0OCyHzpygEJp3NWY4QhUW1LTigo7nqRjFYQmn7dWhAbbCKd509DOzF1O2t7LcssLLWPMEPCUKeCjY2aaiPxL5kdNpJYUSHtNjFGV8VGEw5/uOOkD5p0vweaHm2aZZLpab25HSyXyDYUtuYKcsUjnevxkwh4AJ8xIEFKzQBMBByEqV515V5Q9GzgRNNYXW1AkOzzcJnNuiuOrynnwDQZv+XWyzsmZ07VysDyKQ5c1LTWyM8yW9Pf0MSBzagHGXPNESfx6JyW2QM3gb4cFcKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BL3PR11MB6530.namprd11.prod.outlook.com (2603:10b6:208:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 3 Oct
 2022 10:02:16 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c70d:ba8e:c2da:e24e]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c70d:ba8e:c2da:e24e%7]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 10:02:16 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        linuxwwan <linuxwwan@intel.com>
CC:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] net: wwan: iosm: Call mutex_init before locking it
Thread-Topic: [PATCH net] net: wwan: iosm: Call mutex_init before locking it
Thread-Index: AQHY1YSc0h9rpYGKUEGool5QN3vfla38cvMQ
Date:   Mon, 3 Oct 2022 10:02:16 +0000
Message-ID: <SJ0PR11MB5008A868F028CFA3802BBA1FD75B9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20221001105713.160666-1-maxtram95@gmail.com>
In-Reply-To: <20221001105713.160666-1-maxtram95@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|BL3PR11MB6530:EE_
x-ms-office365-filtering-correlation-id: ad60b21c-4735-4be0-849e-08daa5265a41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ia0/jIwqoMHz5jJiqeziRpncE7p5RcRxiBksaGzhpYhhbJwT6Kwx0Djj+VyTo+OOE9SoB6w8Sepw9/NA2fK5p9R1gmGS9GYviKU4u8trXb1tXeeGYUkB2gbIu7ZtSjFocFPEuKaH/ZWGDqwzjdyLVcqk9KwSaahPhcN/0aXmmvW99NEEzQVdqlEO2vXIfwJWeX+VyiNW//SXgYIX/K2srgcHSUcKKz5yoIVoyJxek6PP+ZKuxRXzr+Z59NB61P7k6peGA2SNZYB0NZrHoPyz37Dl8AMyoNbGAY4yMtnwyZtU9kg/fIg3JU8HAF1DZXqwjbTl27WG3F76oK1bp7K9xOU5pYbcDn5Dbj+10Ug7GiFq09zUnVdIsdT6BlVZD+MfiEgV04i9GF+Vis+vtmaBsTouVyZLm0VlGkzhZL7RpkKcC0i1Vgll38C1HmzPOpII7IY0znw1CDYWnr3tdI2mMBxeyCxSyRNyNzDIM7NVSC4kSAEGqaGaMAHJTdeeAoxrKGRJdcQev8sXAymBx7ksMcLAzjBcCH20JFzfpZjeGTWYUCQ9YNajmgBYHhUS7U9JTHlvLSCz5kfAmgQ0TlJ3oGOVOpezM+fkG98vPfH/WF3xZGWhKYadJ+PAU3xrooTiiBfpt3JgcnX9YB59IJhIRamvCAOZ1C9KvqBurVDgxeqaY0emLTbzhDMETO2zAGYcqMIsmi2C4A3w6/36mOj/R6b0448YfzS5x/fRodr5NHVgA28xXr3ofnduDa+j2jih4WqSDhUhybXr/WhDDJJy2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199015)(53546011)(110136005)(26005)(316002)(41300700001)(478600001)(7696005)(55016003)(71200400001)(66446008)(2906002)(6506007)(186003)(9686003)(66946007)(54906003)(8676002)(6636002)(64756008)(4326008)(8936002)(66476007)(52536014)(66556008)(76116006)(86362001)(82960400001)(122000001)(5660300002)(38100700002)(38070700005)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+ooT5H/YZjQKXqVOE3CJeb6dPyZfoefwyqvo7eIBfPKObSt5h5IkxThsmo2y?=
 =?us-ascii?Q?AyOLnkLWUTsegWV8oHx3j00hW04bMR1eSEbnM8/b0hz5ata8nlEhsTZt5+hZ?=
 =?us-ascii?Q?85/vquZKYbCsq5Wf24fzEdR7Jx6AoszZ6zHksPFsCrWsGKy1qZLJqdABFrTK?=
 =?us-ascii?Q?XXiEW0dMn7laT2FHysdoRzyoq5u5DoGpXLTB5ouYarVnQbLqS5XvWbTOFEWj?=
 =?us-ascii?Q?XfBBdn1HdDBJTbRL1Ii6wCSIRR1kZG8yHN/XWkHx3dqccxbSOzMgSS5JTjse?=
 =?us-ascii?Q?fmsqCoBvp1UDxlBcg2DchELPMB5fXJlrmzGyXhPOLs7/4ZpABvlOENLvtknv?=
 =?us-ascii?Q?3Sr0rxZV4BWOkbuUFypVr1vtqDhm9z/doXVkFcthrrFakBdwdJinbcTfBMbo?=
 =?us-ascii?Q?5RHTLKD9W519lRb2f7Qw3WK38jDu7gDK4qAB0wKT+7Y1HZpGGShynrd/BkTQ?=
 =?us-ascii?Q?zbYx0LGoOPdgs9UbP9nyHDqo91hjsMB/+YFXYvVk59y5TEGC0SeNg2D9JcHn?=
 =?us-ascii?Q?TBdKvUUD5HAe18EU1Oovs6v+lH65CYHBS9CRTWKh1dBA2Z/VTTjeeQdAd2k5?=
 =?us-ascii?Q?4qWYMF4zNW50Lm81lOt+2EjFNiAff41DbbNRqJfqFjc9Y12tEm7yEZh/K9kd?=
 =?us-ascii?Q?LZ7U/t1/3o2TPVRzE1+DyAJfFXb7XgyCkg+Q/CHVCmb5IRl06FbQFxWksmNi?=
 =?us-ascii?Q?BfbQgvneoz/mgTx0Wyh8d9Hxo5YcjabB4M9puBqYZcpccHNB2Xup8oVKwoxb?=
 =?us-ascii?Q?vw/RnL1mrl3T+Y+A7iZUo6mFI4eT4Brm1Jv5qqbD00NcHdzdb2d1VW60Q9ik?=
 =?us-ascii?Q?L6Fci7OoUpudggIeYwWKWALzDpYe2T1wOpmagwBqhPtvJV3p9M3+DjqMHSVC?=
 =?us-ascii?Q?rWtIbPO5lCsEtyv74JnX7KLhOESJSvnbUDMUtnpYrr6Rv/GU7NQFuNoeKvZ8?=
 =?us-ascii?Q?zLxm9GBPFCzedNeV5T3Qa5Jqig+rc1qaKgd/3clQqKQogqz0lXNUY9ubYrZF?=
 =?us-ascii?Q?CqPnt1olvB8gv9ZmFRDqif8KMfy3r7YAGuVuZQs6A1a4HKw1P/eK2tPEvAYs?=
 =?us-ascii?Q?YgioKSt9WMQuNb1UDQT2JRsu+9KWF/L23d4CPqHRnkRBu7HgKHxoWSO7cxSN?=
 =?us-ascii?Q?v+BcpH7MH00Ndv9en0+GaaKVANoIF0zN81E/PRJ008GNItpdhp8+ZSMdJwU3?=
 =?us-ascii?Q?P+59z8ODn3vZnXp/ah/zCgEYxodNZ5FSorEst1PFQaOoUo5DuN15bzeT5LeW?=
 =?us-ascii?Q?jaRaQZiFiXyYg2Pmq1STGwm9FIoVJztZr1tEm+MMLiO/I1e4rxRONHa86vWD?=
 =?us-ascii?Q?U0MmhOsYQvJjgXCW7LWHlV5wFdE/JuzPv0GAEQeIuIzoi8N6qIx0q3O7UnoR?=
 =?us-ascii?Q?rhDKK1NfncuOQih3ZANUsbZoxthIWLpkykBcyf42EkluYbhyuojtWeuVaPpm?=
 =?us-ascii?Q?VUUGRJvBVumX8NewbseRByOQOcfmNeg8F1Wvp0frF5GVaqSQqeeE0tgel22J?=
 =?us-ascii?Q?sd8zJ79LSFxT4OfCtFfuYOkgtJcNX24AHU3bhKc0kZrBRhQCA7fTsrogVPd0?=
 =?us-ascii?Q?Z4i15Jr9GjNp/NdJj06TmUkOUKN+WUwCNTOVpDzX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad60b21c-4735-4be0-849e-08daa5265a41
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 10:02:16.7305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BlCiOUDKKsjkqx0MeCS9q77147h6n9Stks5HclLpzN5GAUnWrEa2XdxLxo6l7z2wPuzvuSXGNT4ArogROSGoALHv0RrjUqdSsREsOnx9hjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6530
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
> From: Maxim Mikityanskiy <maxtram95@gmail.com>
> Sent: Saturday, October 1, 2022 4:27 PM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>
> Cc: Loic Poulain <loic.poulain@linaro.org>; Sergey Ryazanov
> <ryazanov.s.a@gmail.com>; Johannes Berg <johannes@sipsolutions.net>;
> David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org; Maxim Mikityanskiy
> <maxtram95@gmail.com>
> Subject: [PATCH net] net: wwan: iosm: Call mutex_init before locking it
>=20
> wwan_register_ops calls wwan_create_default_link, which ends up in the
> ipc_wwan_newlink callback that locks ipc_wwan->if_mutex. However, this
> mutex is not yet initialized by that point. Fix it by moving mutex_init a=
bove
> the wwan_register_ops call. This also makes the order of operations in
> ipc_wwan_init symmetric to ipc_wwan_deinit.
>=20
> Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> index 27151148c782..4712f01a7e33 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -323,15 +323,16 @@ struct iosm_wwan *ipc_wwan_init(struct
> iosm_imem *ipc_imem, struct device *dev)
>  	ipc_wwan->dev =3D dev;
>  	ipc_wwan->ipc_imem =3D ipc_imem;
>=20
> +	mutex_init(&ipc_wwan->if_mutex);
> +
>  	/* WWAN core will create a netdev for the default IP MUX channel */
>  	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops,
> ipc_wwan,
>  			      IP_MUX_SESSION_DEFAULT)) {
> +		mutex_destroy(&ipc_wwan->if_mutex);
>  		kfree(ipc_wwan);
>  		return NULL;
>  	}
>=20
> -	mutex_init(&ipc_wwan->if_mutex);
> -
>  	return ipc_wwan;
>  }

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
