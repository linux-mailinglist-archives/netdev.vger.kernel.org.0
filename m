Return-Path: <netdev+bounces-10214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5AC072CFC6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C99F01C20B56
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4875D8BF8;
	Mon, 12 Jun 2023 19:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3959D881E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 19:42:45 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138CFE62
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686598964; x=1718134964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=425OBCKJn98xe9sPyWFrCMszsiy+0LDixd/FVYlaANQ=;
  b=gKTzL4I+fiod7yWzs02nRuJmUzLtnS1MGNiC1M0qiOT6r5CGLPS65Ec+
   O/D97bxSRtoALDcPjWqEP0g2zKQutjuCBh2C3N1oa9d9hfrL3ZOgY0r/g
   92vRyGLkLKQYdijZPFoAK7UQSZJLhfmPZ/FBeb6c6qX2qpgSLImgHtKA1
   BHfShY9ffYEdKHOZAv+HwEdnXB4RUbDxYNYDnmk5yYugtIVbNf7BtMULm
   vn08c3gB7LSRBQ4C7BxSyTSD+zk1sQtL/yGdu+YnbCP/hSQVQaREV+4y+
   JfrG2sDadDvC9psdRDsXteLG1zJtqAFu5d84Un4lbqiUmJa7VtnwLteoF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="342831949"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="342831949"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 12:42:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="855783515"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="855783515"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jun 2023 12:42:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 12:42:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 12:42:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 12:42:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 12:42:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwVmSBHvEgDa/oawBFPe9nYpI/ALhMzbLtVVwHUYoMMpQcf/afcbVg1ZIB/3V8Tgp0VpytOfWbezn0Ekykc70iRAHGF1I2C5wDS5r9V7n7FP5yo7OG4VcuKI9qZud8/1I0ZNVup/eQr8pjxuwjLCXu8mo1cuLb5GIK5THVNUaj0PQTNEaUruzfX7/DBBIfNXsQgO+99R1P6oI++1rjfDpeE6UIrjHiPwpLhpZBOMLbS/r2D2PJHPpu9BUfL8UorxURoxYngpsMzNnH4u1Bx4K6Y/DA1scJX7ueSxClVn9ZkFNImA+vkLg5q2Ev9gTQy6VRUOks8nDEAP0lyc/RHypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3/Yd8DU7i186Xy4H2vlswlPW38lAcHNEaFwf4rmxWc=;
 b=TWteDve0bhdwi0D1B2S7A951BdQYFHoj5LYfRkdtIUA4NF6Bu7b6SMGl6KfDeBkXhI5GPRCEwhQCVrEcJP8PgX9PQpeWtOYVZo4qgOigjjmWrGvZdBrPP7k9ChwtJmlUoUarF8JuV+fatikpTdrrjJ9Of+SsrDJzekqVqfbmBTx18ePE/rTR0871HMs6QKzglA/HfdAqqO6BlGVSD34xh4zkQQ8ah7DbHplVGhecrjsz4B4wN0agLMis/Z0q4Hpj43SVEByZESTjDSmdWjc5q4h/5QrXd4uf/IK0NSS0Zs42aGdVyvjlgmTJhYxT9DiZQJc/k+aZqimFfSPNXx63WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5866.namprd11.prod.outlook.com (2603:10b6:a03:429::10)
 by MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 19:42:14 +0000
Received: from SJ0PR11MB5866.namprd11.prod.outlook.com
 ([fe80::b6df:3f53:8c10:aeaa]) by SJ0PR11MB5866.namprd11.prod.outlook.com
 ([fe80::b6df:3f53:8c10:aeaa%4]) with mapi id 15.20.6455.045; Mon, 12 Jun 2023
 19:42:14 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Pucha, HimasekharX Reddy"
	<himasekharx.reddy.pucha@intel.com>
Subject: RE: [PATCH net v2 3/3] igb: fix nvm.ops.read() error handling
Thread-Topic: [PATCH net v2 3/3] igb: fix nvm.ops.read() error handling
Thread-Index: AQHZmu2lEW05Xxa5wkiShr6oOC1pSa+CqR6AgATsoqA=
Date: Mon, 12 Jun 2023 19:42:14 +0000
Message-ID: <SJ0PR11MB5866D9C9759CD6409EECFF00E554A@SJ0PR11MB5866.namprd11.prod.outlook.com>
References: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
 <20230609161058.3485225-4-anthony.l.nguyen@intel.com>
 <ZINTSVYbu9byMMFZ@boxer>
In-Reply-To: <ZINTSVYbu9byMMFZ@boxer>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: anthony.l.nguyen@intel.com
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5866:EE_|MW5PR11MB5881:EE_
x-ms-office365-filtering-correlation-id: 78d489a7-eebe-4d59-aaba-08db6b7d1f39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6dG19/nlLJRA6vPbg3F7KH32gtUSdhynNIHQEJh4hxaO3FjVWPmtSWzg1yaubZ3bbk4WDF1a0GXnp83T13mliXPiVWWSl85y5C4HUclMgr71/4aPpiY9+95gyK8eX7cN7xQeBYiLeG9AJLrg8ra53+LBcxWfKdz0CLDAXb2xMdm2fZ51Zg+Oogoy8hC6sin+KJbgjJJki1n26iVf+zrRASEXDMVh6jiq10sYR2aiFWe5ZBqy73mEO65oyKyftgMVFCt5WZncYUpQhGwNKIvGIT+w2jDt3F+rqPMtf0efShBcIDiLh1R9+4p3w4FC4W0vPL3QCje50viHNcYtxbsmEKzgTAuiHrcIjjZcPLbnA4iJmV9ttSCp9fpceE6Cby0LKHpzAEymoFQQlTH9j5YTVxZoJtDpKRwyQcH3xlam9yt0UWR1wCfQcXj8WGvEFBGwAcMOSK22uq/09KA7MHAAaZ0CwDUdSss70fKD1w+Xj0YGB1I4mJa4O3M+iJqreYJ80Zhm04lUPjuNrm6z+uu818xHCWZvSDHlyRCCovWBqqiXx07gHy0L6JJV7He3E72l0oXlmSWPeurYz6G2MJUNqmWw/o4mM4LKf/7ZzfOAqPob8mxqDfwmMCBrRam+kj+F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5866.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(38070700005)(33656002)(86362001)(66556008)(54906003)(110136005)(478600001)(6636002)(4326008)(76116006)(316002)(71200400001)(64756008)(107886003)(66446008)(66476007)(66946007)(7696005)(55016003)(8936002)(8676002)(41300700001)(5660300002)(2906002)(52536014)(82960400001)(38100700002)(122000001)(9686003)(6506007)(26005)(53546011)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DRcbE6nhKfV7DfaBfExwLDJuOimvXvtdMaCPwEaJ+lHtybRnreG6xqncxfKo?=
 =?us-ascii?Q?byxNhEX20H9zakqiwFtq5SWN5AA+W2DImr65UIMyK+PjaAyo5L2Op2KzfwD6?=
 =?us-ascii?Q?mwL0T0gXZfXiT3wK4iCGvJ1TeY/u2AjfuNtST0JXokLEHha9nEH1Nd8Sj/2R?=
 =?us-ascii?Q?DmR/qY4nEuHq5stgqXLAEskV9+n4Je4L8fo1R5W8C1E5aKm8wbMnw1jbveyP?=
 =?us-ascii?Q?7+AASa6Q0KAhsrMbUk0fxDEztk/NuIrWiGTw1sJVpQPj8eaQzO0EIkFl0z3m?=
 =?us-ascii?Q?gkHq/rbwTjfIdTeeokYLzVV61cxV/Y+mYkwkn2+40E5Zo0XC4DsigIMXqFBt?=
 =?us-ascii?Q?E/4+hxGaEXmlTLiyp0o3CWe0m1hC3DjTfTQcwGIb9e/5npQ0yBTHMq21nz3s?=
 =?us-ascii?Q?MRtjVU8f1gdaoAheFBGxqS5NgFYosPw6mt8yDOselsF6QVTDLKe23Pks+Cc/?=
 =?us-ascii?Q?tyxLs7X3PObrmOaTon2m+yuntsH8o8Qddz6FQLGXhDV+rKKqwxn5kRgxir46?=
 =?us-ascii?Q?+2pbdw7XTqoKLhiMEmzV0rUnVoxw5PXF3Rb8qoL5QjGtAspmI9h3jV3kebkl?=
 =?us-ascii?Q?my+Mfvt/T/FRVDXdqlWxZOqTv5gebLNGQ+skUyyKxH1TOGPlKjqpgUl5OuE6?=
 =?us-ascii?Q?DE1ib+90Ymoi3yrwhKCeTR8A2AvuQXCbk7F4hglUI1mc5dELsfjcrJgrFR+E?=
 =?us-ascii?Q?yI6UmoN0F2Kt1+RAHGVK9gWj5TnkqQ0lp/Mx6+Aicb+LQef6GHbItT+5hFgq?=
 =?us-ascii?Q?JC/UtgorxndXA5qG5T8gUJqQKM8sHJpgPUaTCq8NyDURyB/udu3c3f5M356y?=
 =?us-ascii?Q?2thALqwGcdgGmhtm0WEoppg0FPIVO6tb/jiqj6mfpGDDi1B3LxwFUk2ugwCr?=
 =?us-ascii?Q?FBdajDNHTVeC4u/MHKoktaGW7ckoSCqC4M8J2TkGvSsiP9HlAiA1iSbXyzLj?=
 =?us-ascii?Q?clxXTwy19glfzPV+itJFdy2/9qPyQ5ztkwaQIz9YvMJth360gh0qjH6EvxYR?=
 =?us-ascii?Q?Dp8sk0VSMsPLCfoBQv4k2tJMoxvy/MqKGxWRa33fsjXan4jg9cKaPPnhhx/d?=
 =?us-ascii?Q?GCP/LYtr1vPSIAB64IsK34bL9xyeaUtrF+4XgkUiaV9I0875WHEslLh4v8vi?=
 =?us-ascii?Q?ODq6LyGAPwbsF4EaWWtIMYZ0e1Xv6E/kyoHtxnwdDKt0NemWD+GlSVpP4bGO?=
 =?us-ascii?Q?+ssI8nSICyfdIYQGolwetn4L2LPTKKpSByjNUp+emgEKxrzrgtiIQ/w0Ge3m?=
 =?us-ascii?Q?YSl/hG47D5AU6sRaPIXbyQAPogMHGre3UxnfAnPy5IvC28o3eAf0fa8ZU7Tz?=
 =?us-ascii?Q?v8yy3hyxYLqplf6K2DiD2f5tHqcmRk9FqAV8Pdq0+VSU+rwHEeBnP4IAOIk1?=
 =?us-ascii?Q?BhHaa/wGQ3VK8rlV11LVAw0PzECfsLiU5eGkInyO+LjI7SA2jKBYFxz5J+Cy?=
 =?us-ascii?Q?juvGMJ9vmDtj54pAcZ8XZUBrJB5A83nmGsaXcK5wnj/3VG6UpHxiXuLz6IpS?=
 =?us-ascii?Q?b7jEd3Y2GNHjVZBhdm2xMdqEZY1WPLwup66QdBojzeu7PltylgbMUewTpUqs?=
 =?us-ascii?Q?PuzczR7YyF26uKVA0XmVg7T72ivih0BDsI1VoCVigkdN4TLXcy8kZ91cr3jq?=
 =?us-ascii?Q?cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5866.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d489a7-eebe-4d59-aaba-08db6b7d1f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 19:42:14.1611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i8OCNwDqx2pX1RKUObuMtON8/uCZkPPMCaZdHi52ZThJYCHFUiBf+6obQ1xFI1wntlrfkjmKbs7v4uVmcdHnN+J+m0zcGNUpD2EicconLoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Friday, June 9, 2023 6:29 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; netdev@vger.kernel.org; Loktionov, Aleksandr
> <aleksandr.loktionov@intel.com>; Pucha, HimasekharX Reddy
> <himasekharx.reddy.pucha@intel.com>
> Subject: Re: [PATCH net v2 3/3] igb: fix nvm.ops.read() error handling
>=20
> On Fri, Jun 09, 2023 at 09:10:58AM -0700, Tony Nguyen wrote:
> > From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>=20
> Hey Aleksandr,
>=20
> >
> > Add error handling into igb_set_eeprom() function, in case
> > nvm.ops.read() fails just quit with error code asap.
> >
> > Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
> > Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> > Tested-by: Pucha Himasekhar Reddy
> <himasekharx.reddy.pucha@intel.com>
> > (A Contingent worker at Intel)
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > index 7d60da1b7bf4..99b6b21caa02 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > @@ -822,6 +822,8 @@ static int igb_set_eeprom(struct net_device
> *netdev,
> >  		 */
> >  		ret_val =3D hw->nvm.ops.read(hw, last_word, 1,
> >  				   &eeprom_buff[last_word - first_word]);
> > +		if (ret_val)
> > +			goto out;
> >  	}
> >
> >  	/* Device's eeprom is always little-endian, word addressable */ @@
> > -839,7 +841,7 @@ static int igb_set_eeprom(struct net_device *netdev,
> >  	/* Update the checksum if nvm write succeeded */
> >  	if (ret_val =3D=3D 0)
> >  		hw->nvm.ops.update(hw);
> > -
> > +out:
> >  	igb_set_fw_version(adapter);
>=20
> why would you want to call the above in case of fail? just move out below
> and stick only to kfree() and return error code.

You're right it's better to move out: one line below.
@Nguyen, Anthony L can you make it?=20
=20
> >  	kfree(eeprom_buff);
> >  	return ret_val;
> > --
> > 2.38.1
> >
> >

