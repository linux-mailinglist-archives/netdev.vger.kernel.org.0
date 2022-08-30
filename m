Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4338B5A6EA8
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiH3UuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiH3UuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:50:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5319116585;
        Tue, 30 Aug 2022 13:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661892605; x=1693428605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wg2Agm196/3dPHKJYqG4Si8O+l0vboBJE6EM73CHXXM=;
  b=cYqN3xA9Brmzme4gTOAt1Rf8hERJoP8YWL/NdepxfsODuskqYcHM8Ik1
   YNcVAguGrbrlfTCr5gfXAD3MOSuOhkh2WS8ncIhYHMqYRra+jVysgWrpr
   7+8AAiYin8A2SyMYA+do/0VQPTBhkjNITLN85z0fxovyX3+KyN1CUyXSy
   p/VAelyb3k5bWcf7IOV52IdWxdKN6d1YLzO77CYF+6sM1Fsw0cBUj2djA
   VZVrGyObPKrIZueaqSZW8WFmTMbaq0MCeaWKs66XAHpfBknZhsuCtqbP/
   xyhEH7FcgrVfMRvcQZjieNHo9z9p3gqKarLnqyI4DZuptdhbscUugqNyr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="292874180"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="292874180"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 13:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="588773256"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 30 Aug 2022 13:50:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 13:49:59 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 13:49:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 13:49:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 13:49:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4AztDSKQbu14BQu4K2WnZPgtSDOEevRZN6IbUtl/36NAW4IZqF+v64NcZxK/kycjoIXNtHcTqLD3XQcO/R1KZF5kEeA60Va1dkPSER9yoaV+hotJDyFaNnE0tTw2O1XAel39UznlwXjqar/epmRGrK1yA6Xe+owmaMNVV9CSZZSjZAsbf8NTeJMYLGiBhGzySBwhMSZw2+4oGfR4GmGPXpXM3KeuKK1sBhKmO1yVyTRMHIRjAeLQyNZdZmYPn5F9IqA0dhcwzn2I0JkYDVK9Iu9tfmy1GXXU+npVHoXMCFfnQEB8bLWWr0enJ3yjvAf0P4WcvtovASMTSoBadZv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMKRCKMMbFlifYaNWyK5ee1xcBjfWAVOXAHgv/LmcLw=;
 b=e9sbfGxlYZ06C+HQsizh5xFNiLavmF6VC/cpUgeKaa8AjioD1gX//3KkamkH0eLJXkrnGnBV0cprdX9cn9EjhZuM5g1V/aR0j6BtBbCY/zJmrktGyY94+3SPZXmQbeJkWXWp811yPntt68hHneXlDCSEcwjr572bRONB8b4Snk/Q1EfgOu86a9fnBHd4PZEHcbt8gFnCUtIDoytDS6R5LtaX2VP5u+17uRND/aSD0tgUhf0OzXnbzkljbPiKP2HHI4FV1N7/9E27X/XtDjB8DLJDGqWsMoqz6lspdk5vbnbdE9jqEUAC4yP1hRV2OydM55cH4kUVISmoLnEb3JJQTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3113.namprd11.prod.outlook.com (2603:10b6:5:69::19) by
 CY4PR11MB1608.namprd11.prod.outlook.com (2603:10b6:910:e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Tue, 30 Aug 2022 20:49:54 +0000
Received: from DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::7100:8281:521b:ff31]) by DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::7100:8281:521b:ff31%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 20:49:54 +0000
From:   "Laba, SlawomirX" <slawomirx.laba@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2] iavf: Detach device during reset task
Thread-Topic: [PATCH net v2] iavf: Detach device during reset task
Thread-Index: AQHYvEjhCJvnRrVNjEyX8LmyQxwL263H6JFw
Date:   Tue, 30 Aug 2022 20:49:54 +0000
Message-ID: <DM6PR11MB31134AD7D5D1CB5382A5052887799@DM6PR11MB3113.namprd11.prod.outlook.com>
References: <20220830081627.1205872-1-ivecera@redhat.com>
In-Reply-To: <20220830081627.1205872-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c53c1a2-df10-4fc4-fa8d-08da8ac93111
x-ms-traffictypediagnostic: CY4PR11MB1608:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pLX95oYJL28cWt1o0MxqIjFW5mJlkn0Kupulsjm2co0zr2kKMmNua+uTMDlzI6lE11DalMyDgIdcgbqQybz1fvGFA3/EIypQeR5Ycpsc7UmcGnsU4Mvy25G2n2yi5Qn01kXiH0PvQV8HjBmul7sDFOPgwzEbFBDctkrJlxxvwUOO778tZGTUJLK5m0pYpWX5aNbWzKVh7AfzmTayG+NPaDEeqsssn44shs1lf5VPZgpOgWcj678TTlqw2ppMjIOY2vkVM4ioqOGCl6idvgoarr3kJ5UIeiTpdw00OIQ0lYRECPAbNW9P1zUZ35JEvGLfMrY1Lrd170eyMl/zkpTGQgcTB1Emy7aguSCMIHkIMfl4/uvsCe7COcBdOzn7vA9Wgz6zEykvhZpjX3NrI84gRivxRqr/YygV7+6MlgaaFzWuK7URJgzS+jCiO58QhMbmTrDG0KOc8FXUGm5bjawOL6G75zv0aDVbE4OqfiBK+21RuxUohbPpaNB3d0QykJoaf6WhgSe8RuVRnFwybAWsdZW70qAsRwH7BtvWiTfVywOX2qgHh2fnNDEJEe+C90i0J22w0Wjoo2YVtRD8mboLQr3s+CbRcibbbZSQLdMLYcxyu5iFHP8msZtPHwv5//Bnxo1DUGh8sgdaKR4MLoPCD7X2VtUdWfIygallq8bFWz6tqe8XexSvn/Xyx0B06NndpRF/4FKr/gsVAcF+tR9g6MMYe+oPOEWHhxBvZ4jvclhh1nFHnIqhMjpTNcVHKr5CYPOOmnFHTjPd6Nx3iA6dKGGRzK4HWpfeJF/Cm9qoLHM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3113.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(366004)(136003)(346002)(396003)(66446008)(76116006)(66556008)(478600001)(4326008)(966005)(66476007)(66946007)(316002)(110136005)(54906003)(8676002)(71200400001)(55016003)(2906002)(64756008)(5660300002)(52536014)(8936002)(38070700005)(82960400001)(122000001)(38100700002)(86362001)(33656002)(53546011)(6506007)(9686003)(7696005)(26005)(186003)(41300700001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z5YR1I1Ve6bFDYYEkptn0BgHbIhpqj81znq0/yHqo81BywcLMdy6YFkjGi/D?=
 =?us-ascii?Q?JzCqnnZi1cqp6q7+fOaVHrKH/9qgXOIhtWwNYcSQiC3mWKEK/UulO8ilfL9D?=
 =?us-ascii?Q?kKml7MjUcyNbrukHFUTYFt7FAa8T5t5LrGXcgzp/pYqpMOjKm+b8Z7cdEbQE?=
 =?us-ascii?Q?aBDcvDK9kqF9ZrsLej9rBhDak3NYvEVSrwvvaqtroD49Y0nrQv5r0dK5+Onf?=
 =?us-ascii?Q?FYTl/nWSNjk4ZLeN/cVc889aRfn5+55kPNyp9LfgQDsEaik//rlISVkvy71P?=
 =?us-ascii?Q?LfdB9C4/kcRpivVa136hHoqJe5/A4UBqm543uDnKZyxHDsLXhKl9H95eUgv2?=
 =?us-ascii?Q?wWvVfvANOkROqMW1mEyyd84yi3qdfBbY+Ix8TglDQ7xlZr5ZSnUd8StuhBfw?=
 =?us-ascii?Q?bb1gTV3oD8ThXWZ4+RysJMFOjrwpvEZ0BjQk5IGJhFEfengA412fWEBUttvW?=
 =?us-ascii?Q?UQJ4ny3zQ5vvYynAvcCNrqcxjKtZV+99n2+xNl/HULDvXsOsTL50JjwzwfSf?=
 =?us-ascii?Q?dZ48WyoP9zYNmt5jw7uxY9u4PQafMV92T8MZA7RHCKqduQFuqxxnYcEYJYfL?=
 =?us-ascii?Q?OezCkt9vNVMFuL1SzMApVLI5CV7wpCYO+1D8ifVuJDscTu5NTcKJmKF/lpu9?=
 =?us-ascii?Q?VfhShFabsAvIbhyC3OBLxs7oxkSVXvI3xmcJObKbJ3b6r+TwEgIuDtlNnYfo?=
 =?us-ascii?Q?wEkDpqJyJgo++tGJ3+AdJMzI6LxKf8nT/FnLxEmsr/in2Y53W0m5vI5VzvSL?=
 =?us-ascii?Q?jMB2oZ7MZaplj1kSXBykKJUt83QWdOkCmqKnc3wowtt2xJs7P3rSrhQ2O8hr?=
 =?us-ascii?Q?qQGL5RQgM7UY41qxK+3+BGcs1NaIf7QBKNfYbhZ+AIQxsINo8LMdpPTiPsfq?=
 =?us-ascii?Q?h6JSS5GGWvcHCFLYTY3NB+O50SxQOlod4QKAGJLtnol1dSmBVnKeSmZMNGoS?=
 =?us-ascii?Q?b7lvc/oHGvK6r27zh7b8CwfRizGmIeO5uIMy6plaALWuat/yypm8Tt8Ltp3t?=
 =?us-ascii?Q?WOq9mc1WxQRgfRlmmplz5FVuEgqkrnRGzlr/5fLbG96uJWh82tO4CNMQtFU5?=
 =?us-ascii?Q?R9IKTM3+WEWjoV/44j+KnhozVXcLPjO8g2B0z/59rvK1gxBMmJvUzkslRwjj?=
 =?us-ascii?Q?oCxQHVGqJJfHHzhT99PE2A/duCpmOQf2oaiaGiJDgjs/espJdNV8AQMU0th6?=
 =?us-ascii?Q?gSqwJ5/haRuQCgD0740jKqfS85DJUExrb7hh7tfIY3ldYEKaxWW4QJyiZqd/?=
 =?us-ascii?Q?a9SBo+2zoYF1cTBQiANojhz9/jGYyPaT9he1IGWr+PetTbhw7EBhNmKeoKBy?=
 =?us-ascii?Q?7oGmbb/3E9mx3A97BD3wWVdMhs8gLtcG3BnOF2hJVwjHnBiboqqcv4ri5bvX?=
 =?us-ascii?Q?PsUcyBYgKtY2me6yR7DTeBdnxtE3RG92xKCe3H36VC6I1NeKdB0fSt5xWbay?=
 =?us-ascii?Q?Rl3SuMv2TeNmja8FQBsbxoXQ9FVhr+ZrOGObO9ekzlzg78HnOX4RMmCaLPHC?=
 =?us-ascii?Q?K/bVoxA/u4UuTH4lhFftd3aPDHph3kHK2vfAA0VKlmXM8vSgMD9esyEvnm0T?=
 =?us-ascii?Q?pl0cKUqTc6kpQFYa4lTW3W4/HSG71UTNtDk2yiQv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3113.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c53c1a2-df10-4fc4-fa8d-08da8ac93111
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 20:49:54.2042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /kIBcHNJFJMRikp8I3Ir358KQkfCgVmGaNdOGqhhX67z+j9+SvSxdH4Egn7x19VNITIc7HQDOVu2C53kLgn2FO5n2Jul4EViWJUYVtq4CWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Tuesday, August 30, 2022 10:16 AM
> Subject: [PATCH net v2] iavf: Detach device during reset task
>=20
> iavf_reset_task() takes crit_lock at the beginning and holds it during wh=
ole call.
> The function subsequently calls
> iavf_init_interrupt_scheme() that grabs RTNL. Problem occurs when userspa=
ce
> initiates during the reset task any ndo callback that runs under RTNL lik=
e
> iavf_open() because some of that functions tries to take crit_lock. This =
leads to
> classic A-B B-A deadlock scenario.
>=20
> To resolve this situation the device should be detached in
> iavf_reset_task() prior taking crit_lock to avoid subsequent ndos running=
 under
> RTNL and reattach the device at the end.
>=20
> Fixes: 62fe2a865e6d ("i40evf: add missing rtnl_lock() around
> i40evf_set_interrupt_capability")
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>
> Tested-by: Vitaly Grinberg <vgrinber@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
>
> @@ -2884,7 +2889,7 @@ static void iavf_reset_task(struct work_struct *wor=
k)
>  		if (adapter->state !=3D __IAVF_REMOVE)
>  			queue_work(iavf_wq, &adapter->reset_task);
>=20
> -		return;
> +		goto reset_finish;
>  	}
>=20
>  	while (!mutex_trylock(&adapter->client_lock))

Ivan, what do you think about this flow [1]? Shouldn't it also goto reset_f=
inish label?

	if (i =3D=3D IAVF_RESET_WAIT_COMPLETE_COUNT) {
		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
			reg_val);
		iavf_disable_vf(adapter);
		mutex_unlock(&adapter->client_lock);
		mutex_unlock(&adapter->crit_lock);
		return; /* Do not attempt to reinit. It's dead, Jim. */
	}

I am concerned that if the reset never finishes and iavf goes into disabled=
 state, and then for example if driver reload operation is performed, bad t=
hings can happen.

[1] https://elixir.bootlin.com/linux/v6.0-rc3/source/drivers/net/ethernet/i=
ntel/iavf/iavf_main.c#L2939
