Return-Path: <netdev+bounces-1101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF456FC2FD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9D9E1C20AD9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86A9AD42;
	Tue,  9 May 2023 09:40:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542CAD3C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:40:34 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6BEE5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683625233; x=1715161233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W5xzLCt213Tgk21ER7cXaKup+uRX49mTYSrSXWoNTTg=;
  b=afdMO8wQYsdnJLtSaVausyMLBGWZE5EQFyw5o/fKMLGQa5j2OC2YhKVV
   WDyi/x1ahhT1GGH7wL21gf0evqGbLzWzOZzn6bVrZM5xT67/DNnWUuiRg
   J0DZDIDU6Rb7+BXqvFm64tPNJAzZpvAbOl4sJOP/FaIms9g1qfj2E90bD
   Er0oAYeFlJIrJrH9e7FHijcP4Lvx55CEUxfzUeBTlDCH8Xyz2EUuId+Xh
   Dwh4XvQW5hBm6D91eKC2KxG/qBkRZoPuH4Iq2/V69rip8VKsbLg8owjc6
   aIjQPGOdtT4Nr9N1nnm3kMbh2MaAVdENGAaN20ta2iE/Uac0kQaUwUchE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="329497324"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="329497324"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 02:38:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="701762930"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="701762930"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 09 May 2023 02:37:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 02:37:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 02:37:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 02:37:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 02:37:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWxQZqJpuKR40jhu10cyna8GNbbqzkjS/8/M2Scbj+wi56EbUMghH6LP8I0Kyibo1pYUjOraxFpmCJFMmUzU6YX6MG66/HGl+K/9g8xWlKPABiJNSF70FjWCNetofCOJMnk27E3/ovf2DVBNSGc52WJmKyU0nqROcYAHYbrIQkIBelYKLedUOLG9QoNYJrDg32pZ59EAyqz6NE6TLYlqIn2xcRBefzhGZNuvKNpVSCIjdNcAMnAGBTCj9zgRaRIl9LUS9Dsst0OZlWscYlthTwMFvvuhJgCZ5K5ZqSNAmh5kSw4Gv5Uzszo4iUp0bzmSwJKw8QRRg7jc9mvoMjnEgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEDyfHLDYUELh3ZR1bpiyW3g5cMFs31EdzuWmeqzfXM=;
 b=AVRVtmhaBbN0FlH9tFwHM0pOpPEv77FAO/L7gn8xrNuX1LWziSqVWzCO6vaxwQlxW4RSg+y7qtlnOPoPjT3gdfqjiuqZ6aSIrz1v3PsZhqYLhFwidlBJWoXOgRqPvtq8ufqzj6vAUi0/VQUZkj9z489artG9gPgIkgSHrnfptC8AqdGyy6WVkBQ+WGmCVPIpxyHphFqWWp4/ssFAZY0I0/yfZTuKwn2agL1pw2opEp4+HrC7Wq7lodTbM6jjzGVTn70a0j9b4Ad70mRgoPydO91bCQf/zHzC0hBuG9YHipA6Q9E/r1dKuX55CqhjF38VzHe6iLYEZH10dGEEJpE5bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by DM4PR11MB6333.namprd11.prod.outlook.com (2603:10b6:8:b4::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Tue, 9 May 2023 09:36:59 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 09:36:59 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: Jakub Kicinski <kuba@kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RMvuAgABRCkCAAB3xAIAADncA
Date: Tue, 9 May 2023 09:36:59 +0000
Message-ID: <CH3PR11MB73458835C7F7E0316A6325FFFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230508190605.11346b2f@kernel.org>
 <CH3PR11MB7345C6C523BDA425215538D8FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <ZFoHpoFDkoT77afk@corigine.com>
In-Reply-To: <ZFoHpoFDkoT77afk@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|DM4PR11MB6333:EE_
x-ms-office365-filtering-correlation-id: c621293a-cbd4-4405-b5b7-08db5070efc7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NkQkU5jD9eiCIKuZv4O9ljOFe4nOpvZjemp/LQe55ejyqVYXWJ7THvyJ9Jz4omqspvHQgst3dlVzvqOoyiGgFtBH0mGKY568IjhgDHri9EyC8gpmhRa4xIqhmnHmBFUJpd1UPTFA3haw5fz2ye4FKIbGm85sWH6NdF7MxVtZSaCtMZIqqj4sO0CdIGVGzw1+VzbenH+g1rvLG6apt1IixPx7NRQYBllF5zNyx256tLJSzD/doLJalhxDM1XVVAhM0mUh02DpHNDkfJEvRsJge07ErQYkWPvun3xQSxgzWVkK/4KbxfW1hLiaaAYslvAEodORNebqftQQQ6ZYzU0i+J199AEVcS+8GIXbDYb7oviZKO4VL8HD9wbxUgpnVyBYqxfahsYzPiAvE7CXS8j9yj3NvCV5wlNOGyG585mztokRF8oBjgjoY0m+cDSf2/E1NLl8I1i8l+t71lmY2cVYGe0v2OCa4IzrcKG4HpBiL7/Nx+cxYG7D9BO0iw1yecyQGlAgTT5qkbUCCiY3kv1QMAdk6CsFnlHvo6YmGvb01Y4SkUXJm2cejT4EwsGJ4u0ibVjh/9LXWeOx6Ns4yTZsBIAkrFpoYKB7YuwPK2sUsA//B9uNPtUNXnYe9vD7koBr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(55016003)(478600001)(41300700001)(52536014)(33656002)(8936002)(8676002)(5660300002)(66946007)(66556008)(66446008)(66476007)(6916009)(4326008)(316002)(54906003)(2906002)(76116006)(64756008)(38100700002)(6506007)(122000001)(26005)(186003)(9686003)(53546011)(83380400001)(86362001)(7696005)(71200400001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2OLjzvxl/S8DPjChruDeNmfArCWNEQT+8D4HCRSYs0U8zDvnjspm+XqDMm3T?=
 =?us-ascii?Q?oqdpnrZN8pI4EhXki8JFSu1ek8AfTresqJ21lbj+QjQ2pkRHYeEn3DNmlIO9?=
 =?us-ascii?Q?+xng0kA6RWlrPWLMajqt4Fgu2hk8XrhIYUOll67RV5yDoFuW7Xf/5u9eBLRH?=
 =?us-ascii?Q?G11kfThL3gkZC03SepbFwgfmIQlUDywdlE6hUiM29IJDDqxDfysOITb30aSM?=
 =?us-ascii?Q?GBVaXV5K1oR+WFRPDsbdpI7MvcVkX2LsnbsVtBrYaa5pUBaPbtDHces1OB+R?=
 =?us-ascii?Q?m1cijCv21pHoPChcHRFUJtC1ks2gS0KLbCaFTOKEZWfimxho22i+F+mOkxJt?=
 =?us-ascii?Q?Cil2WILogDd/lJ57BcXJWkfWf/jxZKGlgHQO8cuzsuGrz1UJQmqnNtPyntB/?=
 =?us-ascii?Q?a0e2g1Zpddte6y63MuYvSW4Dmuu2agMjkqBGGoRpLzSrQ9NjkPBluBMpHplg?=
 =?us-ascii?Q?v2IuIlg/edrd39qGK0TBUv7UxTTlLrvu3d6AqWH59NHuwulefIU0u/MYxJNi?=
 =?us-ascii?Q?OgVg1VwmZ4mZX4HCJW8DBYodvrMnG5u2EcEvlQ0VPWrHBlDtaOGAmL6dg4u3?=
 =?us-ascii?Q?7tqPUAgDFt36ASQZ+ap7qoEhsxpv1g9mW3IhlAjFv9C4SpQETx85wZG2omrQ?=
 =?us-ascii?Q?MBHYXOLMMbc+bSl6hHpfQtfl/ZEQWmW4Z32VngrwSHv5z1pquv9YgLFBF27S?=
 =?us-ascii?Q?WBfxExUiQVnU1C7FFduOWgU9AAulm7xAoSdwHADsryBHaJ0j0vrQ5TpQmeUA?=
 =?us-ascii?Q?YxWmhI6+JLR0eq6WXsI+gm8EWGC8dLzcS5RWg6GJyZN9P/CM0BUX+rdN/OuY?=
 =?us-ascii?Q?fyJ7qq5FJJj1gAb+h/abkLFu9CdsssHeMrPSF4HB0RKm4ohLHgyeE8evzadg?=
 =?us-ascii?Q?3DkhWySDPQuCWEHasy4u5CHjwABHySh6bIeLfi76LC1u6h/ksmJhQ1otv6DE?=
 =?us-ascii?Q?H5GWePjxxK9C+lwRsv0OldNrHtYP8olmQeYN8htQ2aiSrsVWTkGxoP9LOz2f?=
 =?us-ascii?Q?xJZ7mLdSFwuZjnC2ri0riLIrdmXfR6cxg1tswuIEGXF5sk746TzI7z/DGnf5?=
 =?us-ascii?Q?3V1UeujJ2K33NRF8R7I1iyE7L2Do+2/S8CIgqZK4nXdDzpMRefkTzQl7Y2N6?=
 =?us-ascii?Q?PmlnfSTKNL4YI/m192K8x86N2rIAELCE3rR8SRzA/rsMQePp3gKONmo5KtSs?=
 =?us-ascii?Q?0dOT20gDuHvQ+hnK4hfP4HL+GyQaBTnRUmo9fSOFkYb86Po+B2CW0Dykutd7?=
 =?us-ascii?Q?G1uTg7SbaNCzaQd5lHuTVzn5gQ8Ea/4haXGO6sFT2Vdok1feZ6jj5kAxAkIO?=
 =?us-ascii?Q?rx0pzi+8H+fvQCROtSAzyuYqDUtNNlVAdbMOksPS8rfpYin2N2JLKKBaOkoe?=
 =?us-ascii?Q?IE/iOjumH8j4mH2AYMfwK/plvPaQnfLzruVEEc+DLDkU2SqqcS88zXVxnZhy?=
 =?us-ascii?Q?Nwcuj4fYNRFp7w5G7u95vD3LrCyI6qWdk5/MoQkirBWGyk3H1XbJiTkVs6Y4?=
 =?us-ascii?Q?9IGU2qByLKiQmLva0Anu8IdPX22SULJhyxeIoaDrsBbYgqhcw2MfTndf9Dln?=
 =?us-ascii?Q?oloM26662Tn4KIRQ2pTC3kkAWrcWFIQYnf74Orzh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c621293a-cbd4-4405-b5b7-08db5070efc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 09:36:59.1958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6KiaCw0eGPVaibMreXqf0viUjtrMgoF2RzTVpnWM1/FkVgo92kwBbcCicHFFsLhJ16zNrey5+ipsNuDxJipxJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6333
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Tuesday, May 9, 2023 4:43 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; edumazet@google.com;
> davem@davemloft.net; pabeni@redhat.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Tue, May 09, 2023 at 06:57:44AM +0000, Zhang, Cathy wrote:
> >
> >
> > > -----Original Message-----
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Tuesday, May 9, 2023 10:06 AM
> > > To: Zhang, Cathy <cathy.zhang@intel.com>
> > > Cc: edumazet@google.com; davem@davemloft.net; pabeni@redhat.com;
> > > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > a proper size
> > >
> > > On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> > > > Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> > > > possible")
> > > >
> > >
> > > Ah, and for your future patches - no empty lines between trailers /
> > > tags, please.
> >
> > Sorry, I do not quite get your point here. Do you mean there should be =
no
> blanks between 'Fixes' line and 'Signed-off-by' line?
>=20
> I'm not Jakub.

My apologies :-)

> But, yes, I'm pretty sure that is what he means here.

Sure, I will pay attention to. For checkpatch.pl does not report error, I s=
ubmit
as it.

>=20
> > >
> > > > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > > > Signed-off-by: Lizhen You <lizhen.you@intel.com>
> > > > Tested-by: Long Tao <tao.long@intel.com>
> > > > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > > > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > > Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>
> >

