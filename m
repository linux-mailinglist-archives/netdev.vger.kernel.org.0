Return-Path: <netdev+bounces-8694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B76E7253C1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 858D91C20C46
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B551845;
	Wed,  7 Jun 2023 05:58:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB7F1840
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:58:04 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6233A83
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686117483; x=1717653483;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DDPcOXlV/zRYoVKG+uYg1ckDe90HZtXjDCRD9peSMFA=;
  b=ailFa/J6HTAphPrNlITUfGiEXMOko1YS6NxD1sGyL6xKKC8gUR7Y7/m8
   O2QcYDGoJnGNMOeI2x80Xd2VEigmgQnhp9b+gco5hVFjy+axzkT9SrlAp
   kYOYjV3qVtcGsnsjYPgBRDUHkCxINgVIiqKIV+Y8CdAjHczCQTKdXzY9b
   IS1hfNto4/CayvVuAyswRh1Rwj1kz1r4K0VN01MWMpWfps3fzRYKpHexC
   2IxSpzDcgJre9Au9OKQjHX0yU6yFey2j2SBSvcXLl9XBpsdASPdU8crOu
   49yZp62iwtF6VyHIC+epY83vvleZBl3HIr4lAsJTNogYsa/KC60aoXjlo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="346504414"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="346504414"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 22:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="742458142"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="742458142"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2023 22:58:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 22:58:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 22:58:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 22:58:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 22:58:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8eRJv+/h6W+rq0rwNLM+Sd4ygR4fW6EPhEdw4TnJ9d8TqKrNkjjqXMjUfr1UL67O6xv8XtKujp/yfybBvMn2+QeNoYtw3ScwA8OghTlOIBECiRQFK9mhFFASH0CHdURSU1QRaLm7OTiakE5HLCNHh0SqpiDUQJSauni9pv3MFRn9t2prbQ4pvUTQF8yTVIzRKK6Fa2Oo9MLt0BWhtdSV1o/hedSpqoSBD4Bkugyj1Ir2c9ewbcsUw6Gwk12TaUKUWd6sX85nqcK28mVWId04c5qQW9f8olMBgWdykP5lfsdFz7O3NyiuPsCMHPkumGep8JrQM10SHX51OAZJjqI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAKsZd0TwojDs14BhhvUJOBHwb7i5cco3PstzhiEW3I=;
 b=lpiP5G8vbHHArZCF8EoOAdh9nvBF9pO5u4ZFvucphDwsRXnn5nFSBP7J0W/7pS1XRo9Fa9NGVTCg753K/EqaV2szdea0NYCOa5TJBQw/V2u2x/zgvbmkrUKnjOMCUfR4a4DWrXSVy0nk+l7baga0+uFlUxeGt4oXW7x1UqpbLsxrRelzF/8p379VKsEokZjxQC9zB5ci4yQgXoIfY2e/cmMWMUbrPL4d+IHryPnk8Byz0SzAgkjPERn8zuEEZs1a/bMIkdhoM0rFOVHFQ1/cSVxQ74yBTdWsEGXvcb6IPCppbXMy0i045BcjL+4krpCVBB8ejIANIvc6yFc24xL7VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by BL1PR11MB5399.namprd11.prod.outlook.com (2603:10b6:208:318::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 05:57:54 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 05:57:54 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 03/13] ice: Don't tx before
 switchdev is fully configured
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 03/13] ice: Don't tx before
 switchdev is fully configured
Thread-Index: AQHZjjqUDHAzl8QDyEGtnnvokAbUY69+7V7A
Date: Wed, 7 Jun 2023 05:57:54 +0000
Message-ID: <PH0PR11MB501378185F930A7C9A7886039653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-4-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-4-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|BL1PR11MB5399:EE_
x-ms-office365-filtering-correlation-id: 54bc612a-959a-47fa-a70d-08db671c22d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikJArXxq6ijxBGrJ65EDKJ6cqPExN7/S2ZqWlkmXVncltgSIZReHeVEF41i5n4ZTVd2DDejYExLpA2WNIOUZpfwxeBvJs8brnRnDsrdSrNL9m6KOUUIWmSmXLYEDcfdKR1BGmnfGMGiAXjdIyYSlDGi+LH1++S0/iGJVBfn7QOkpcwG88v7zTj2dCAoHT3SPKrkqXhjYGlgTb5bmOhz40CdGJtn2hyHysvMDAnvF0UyULQVFY/9bD7tNVRcqmlhWuDPbY0wZbab9amo49d7hVJivw78IOnrT5IAnZuDn4H1NfJogEoikOQf9Y/tiMoF3ST3Qb2yCR4O7RcI7qBU/C0IB5oZjAiTYw7KHG47h4wS+riOAtKI+e5rUXW1xHmztaoRUq4gY76dpTItUMytg1FlYc/T/TbJYxCSNIgyy8ipdMwY25VHFfo4lVYueod62Dr5E1FIf0/7lYDDYNdltOOirIygE8dZ0Bj5AvUpScPlh3f4Xvrmz7SJ24owUiqD6FWdKCUFldPoq+OBd7wsQd4+Z1KiVeGu6BIVIVAtMkGhiXOLQPoBlY4Ym0wCWQ2Pn8UKVhnD3/E7VXMALqjF1SBvzWuwKzltOv+k5D8ABBDav1dL9E8pfQBr5W8PNUFDW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199021)(54906003)(110136005)(71200400001)(478600001)(66556008)(52536014)(8936002)(8676002)(2906002)(5660300002)(33656002)(38070700005)(86362001)(4744005)(4326008)(64756008)(122000001)(66446008)(76116006)(66476007)(66946007)(316002)(82960400001)(55016003)(38100700002)(6506007)(41300700001)(53546011)(9686003)(26005)(83380400001)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TbZx0vHjkluWydk0q8RPDbeVZUsNEAyjnGnWzH4OQsOjtVnofULzVEo7LQdT?=
 =?us-ascii?Q?ZPy7acPzoOuyekkou5c7CoeUDZ+n/S2VAEBGVJCZNhmVZK8Av3MYBygTih35?=
 =?us-ascii?Q?JjYvTkfvHAZXhQPuAp5cHRNIQek2rUyDg20vEYHdtwzAhyPWJM6T5U7UrYz0?=
 =?us-ascii?Q?0YSyZkur9PRRkdKOvIFrfU9Isg75zXyqBd0gi2E9hOKQz6i9FiOLUmufYVQf?=
 =?us-ascii?Q?1Nb3bVti8fwO/U8IaieCw5jKHr4vMQNlUcgt51IWzfTZVlxeJ8h/NfWLfZN8?=
 =?us-ascii?Q?rv2r4csBc1nNk2s7JmQbAiEBMgCcvdrfgsJjJ2yYu7FZxpLbvKTkY1FUulz1?=
 =?us-ascii?Q?SH+8CiO9dxtaW1J/3T5n9Z7BVHBvNe+Z2eVStRXJQ/vEC0Imk4BDdfuRDuvE?=
 =?us-ascii?Q?uoPFrwiO1g3w+OOtvJ4BoQ/39GaLwQFc8D11R2iFR0Pd5VnRQTAYUD2fR9Ie?=
 =?us-ascii?Q?7rHeFbLRGcpxU+tPQdBEF8RDuXaWrfTENMdbtXqEpHx+M8/YAK10hCLLwnPV?=
 =?us-ascii?Q?Z6G5YbMIgjkZi+8klSRMEaeS7ThK0b+Sj8vUkOwAdZHtmeDSWdlD0U+8sSGu?=
 =?us-ascii?Q?K/yb4li7+IH7qFDBDNor7JAHNV1fuibBLgoQFnM4aRlN5zulKKyfVigCS9tK?=
 =?us-ascii?Q?REKHVJV6swLYAU318+4jQGnlR422sOiLxBzpPh3hTL86oEldEYGjqPSyD0Ij?=
 =?us-ascii?Q?aMHAx0KsLyMLagmxPUS9WF2wV+86y4OzJEwgmy5RVjUql+SJu3Se34VZrApj?=
 =?us-ascii?Q?KCxigqNMr78aQcCr3Khpf6ZRNT1ukG6gxx+ropCG/qa1JWRv2/zX41Mxq7r0?=
 =?us-ascii?Q?rZuKzXTuEPigH29P3iQiklyWjRgEu87JeiywY2E2BjyDPqX+ezpnMsUCa7je?=
 =?us-ascii?Q?RlbV9xIj6MD2jrhYE6XsgiGlR9t2jxkHFN+Tup80OeJcRa0Mmh5IxlG16CoL?=
 =?us-ascii?Q?YpPCMtuHa0TIQolU4DKE4HMGmila6+z9KPQoGMJmUwy9IZJQO4lH8eZEoPJV?=
 =?us-ascii?Q?ayMxOD+6i9exvcefULDhlUo0PNSGqNk1LKtJ60LBNul66LobPhhk6rFk6MyW?=
 =?us-ascii?Q?xmO7/7H6DSSg4w++aqhmGVNoY042hCGKPIV8Pf1PsNjA/xt0bLvs6Ot/upiN?=
 =?us-ascii?Q?NrVh397tUavFyO9WUGmM+cW0RhGh96JpSs4Dl+s2sVyo/BEeCwIqOWhkSABn?=
 =?us-ascii?Q?b2LJZ5FuvspyBUAKek9RntLYuG5uCE95DsOP9vGQ7zJcNTzmOyG+Z7iMyci3?=
 =?us-ascii?Q?TQf71ecZmFSqCGteCkHkkAeOz2BbQm33+n1nbRKu0PRtAk7QUQujeEZ5MKdn?=
 =?us-ascii?Q?YJg9KBFU7bfJkKddFBQMZ6IjTsl4ARXyrcI8EI0bRakBki99BATgJpLa7M7N?=
 =?us-ascii?Q?fHHzlJZAVmqrdLEv30Hx4WlBtNFcQVC8/mu4YY3wKr+C1wTGwOedk6EztMGY?=
 =?us-ascii?Q?TGx0mW18ObcS1SSK9Y+pk2Kim6zhxrxwrcW9T7v1PS7rkc2lZQUyndHz7vFo?=
 =?us-ascii?Q?0aXZK3sEynIO5FdjDbaPXI2KqrJ4x2y4eYaiGpIaedip+rU4++zbaPSQ4Ii8?=
 =?us-ascii?Q?u+A2rMG04cSM2c1sjO625a2Kdohw8t6CWHc0IZTOaJmnI+B7H/HxL6+/Y8f8?=
 =?us-ascii?Q?nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54bc612a-959a-47fa-a70d-08db671c22d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 05:57:54.4259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1AEbPLiccOKMe4Im2at6fRKsjdAw61LYTgm2GOppbHVpdNHgYb2m3YzrwnOzrtqchpB7xmZ805OLFX8NmHu4Qm5zO1cjQq/PasImU91Gt4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5399
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Wednesday, May 24, 2023 5:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 03/13] ice: Don't tx before
> switchdev is fully configured
>=20
> There is possibility that ice_eswitch_port_start_xmit might be called whi=
le
> some resources are still not allocated which might cause NULL pointer
> dereference. Fix this by checking if switchdev configuration was finished=
.
>=20
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

