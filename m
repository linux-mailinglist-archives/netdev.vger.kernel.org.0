Return-Path: <netdev+bounces-10017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5871172BB0A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16229281023
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43300101D0;
	Mon, 12 Jun 2023 08:43:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA0F6105
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:43:26 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9C8131
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686559402; x=1718095402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r3LwebVJsW73DnljkY8f59YKVcdSbl0EIGgaXDQ5K2Y=;
  b=DPg5d6Cib2TkVdillX8PJ0bMdsbOglhFLCCEYKHMen3WODkpu7TDVOw8
   lK3yOmThtBe1lJC0ne8ZawHc+GAoXmvGul769B+iRzvgUlwRe5/nlHPAw
   P2/9m3n2sinoQyRM2yqVqitp2PdSqq0WAt/1TU37GZRUIwIDDkiqNi/bB
   NrMfajStguRc9dgPulqQ3ujM1BeBhwuAEeUw8IRjfB6bHGc9goWVFB5FG
   TFNrhpqskXJQkqF1ML0fTtb+G2CwyHhmnxZozzRtdUXtBIp6kbqXMpPOC
   sR8F7iot8qGdduWfkuBTZ4jHW452CuFmIz46wD/kTl7KGmiiJTeOJBN+V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="357962841"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="357962841"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:30:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="781080785"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="781080785"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jun 2023 00:30:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 00:30:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 00:30:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 00:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv4yMsmZ5JV75L1tgx1tP9nLmOm9iI3aW5OPgZJVBsyQkZkNjhx2m/nRbm0IrAsibYLpqGB86mTTa9uNMxj/gEvNEgioUMm7s8/aNN8Ocg6q/EPeTFwIRQ63PrH4snuqZ4cRLXWALtsYwwGqtK9nOSwLxVznMpA8diwsmXGAsybCXyMLbl5dMatAskhNRkdjXR0uBUhh//5u1bFQGB/7oypdI8FcYuKwdqaGTAcsfGfnB/Vzte3qd9zjFQNn8wD6GpR5M8DVbHlZ2AE4AeAq1YUqz9CmJqS7duCzVxrdGoSfC2DTI/bsSzBRjOEkSRkvHztS00ahH1qrq5BcU18STw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCOogWM6nULdhJIT4DSiBweds/4tS0KtRKjqMsRrzio=;
 b=Z2aaPdhirNn3jCYQ+OUIewUHYiZOVWxDxuLxy0hr7N4jXd2nJQBmkCWbdeA7cPYSJV+opMYUecaJkGvCdkuFzjnky/yYm3U1/3atPo5uOjwMMn3mPlpSYc9ACmHv7vznEu0nQweXgTG39l6BcFdAzReqCXSiaw71BeNnyQCkFf9HKlDBQsgBeCKuIwqc038Fac+Wk1S0EfTFrI2NTqiYYsUr6AbInT2Lqf+vRjNeGqqhkDjH2WogiqNOCrqzXLcQIc46PAj4WX9mFHS3dgFrN7ijvUSrqwtCOe3sL3xENvDAc1eL/JSEP6hdl95E2gLD/+OG48WAm4eBjJKUkpNvnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by DS7PR11MB6014.namprd11.prod.outlook.com (2603:10b6:8:73::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 07:30:01 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 07:30:01 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 02/13] ice: Prohibit rx mode
 change in switchdev mode
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 02/13] ice: Prohibit rx
 mode change in switchdev mode
Thread-Index: AQHZjjqL1byktwjS6ku6SpG5AwQXQK+G4fKQ
Date: Mon, 12 Jun 2023 07:30:00 +0000
Message-ID: <PH0PR11MB50137097208278AE754EBECC9654A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-3-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-3-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|DS7PR11MB6014:EE_
x-ms-office365-filtering-correlation-id: 36393b77-6ef6-48e7-ccac-08db6b16d4ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7icfZWSToo7bWooZKZ5LDrAevD1IIg2ItaMQjoddBEA3d9u6Xc4wfJvW+zcDrJx4z7qrsli+YeJEd1uE+UWQX9sN/ZXDTg5oSImr1JIMZTWQzki4xmzM7zYY5XBC5ozBLWCj9w+70S496oxwty38tw78tp2xe4CHdB6FfHQIiyVso8qvdcknIMgZywe5nyI0FXzHvwu9XYMHhdRQtywigdMrf7Z0a8LtbEpS3iJ+anndvgW9H/r/la8kfWadAVgig4Pl/CphfABAatGhTlG0nr2/S0/rdqcfwiLbwX/7FS5iQMhCZohVSvXZHP5o8NYsy2pLBjXmAsQoAI6huaS6AyAh3AVFF1soYhJqwnfHkg/teb6BUboR1PN9BGoyVrlev789FDsXnEeLXPKJJvdaApyZ3SeT5Zutg0Ci40pvFvumG+kxkzCaFemchs425RLe9kEkXf/awt8P4ObW4f2wJ7dyQxpml/Y6vJI+Fl55vhIljU2+yXlXOb0OT5AWtj8ZfmhdbMoKM+rRVPz6qnRMSoi8cYWzl2gsuVk7SSY5+dM21DPyxMSer4W44xQCSmzm7PgwU5P1u1XDtsP8HGz0rAWAG0wTMFPbU6HIeQbm6o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(83380400001)(82960400001)(33656002)(38100700002)(86362001)(122000001)(38070700005)(55016003)(478600001)(110136005)(54906003)(4326008)(7696005)(71200400001)(8936002)(8676002)(2906002)(5660300002)(52536014)(66556008)(66946007)(64756008)(66476007)(66446008)(76116006)(41300700001)(316002)(186003)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yihLiUZAL+liIHvj0TVXAzLzUy5vZZ5ZjWfM7URcTo/Q41IpE9StxO1Z3Po9?=
 =?us-ascii?Q?19xSyhMFpfwXJj9lmDHD82zLLLQV41vcU/bGXJTxwTlVzRc8PR/gd2zrvPQC?=
 =?us-ascii?Q?MveKTtVpJNdzDVJ2YOQim+Owyy4MwUThLYv95WBFba8kijjoK0ndDXgY2I/x?=
 =?us-ascii?Q?/0qOy24JMFyzocGE8EK7JNZVFf0G5cXXHpefGzLnbBac/FAvO8sZ4460BbdE?=
 =?us-ascii?Q?X7mjKVBa+khn2fiVmwHVKsQsSHOK8KJSzolOEvqWVS6Vw8kbCvAhAXSo5DE/?=
 =?us-ascii?Q?qkx5N8ABmMCuqZsaphB9Bx0CkYV3nL/e4WPYzgMXf1Nrqmxjyfj4grYo9QXF?=
 =?us-ascii?Q?BsunI/wwazBPGT2TTfxJ0PdDpnEl5v+Tk81RimpvvFTDHHWcUZ5xaCuXKZB8?=
 =?us-ascii?Q?SuLazs94eL9iy7UH3v23+5jy4Q6u0t0IQXF91/yijtJ/ycQ7F5pZOZytB9SO?=
 =?us-ascii?Q?L8HPOpvuzM+k4yOQKXoY6ms0sh141xpDB4Bz+DemOTnlzf65WVlygUEZ25Oc?=
 =?us-ascii?Q?tAAKHQ7LMuS9DBFiaENGjmAYxS/CSx90bouUaVJaiq4IqRBsF1M1tEY3Tw/M?=
 =?us-ascii?Q?fT3ZP9SAnD7rXTciTldDqmYxb3H4WhDqnbEDKPeaukOgFrK+soCwsjpgS7oR?=
 =?us-ascii?Q?2dUDdeGLxR0akWIqDDeJByRKwtJgeKAsi65JGZFwcI/r+fbDTo1v2tbA/7Ut?=
 =?us-ascii?Q?xB7S0+A7PmLzJh9kgR2OfbTl3uaYwNKGwnYOMOcDqK+pggID+mYnP0wbBLSW?=
 =?us-ascii?Q?plzJAfxJbgQK+UHRd3B7bCHEYZqSKvn6qbN5uZBXjvVxiD6tGG0Ujhe5GwGk?=
 =?us-ascii?Q?XNMoNF0NS0jGUl/36bVcNgZU+x7gty+YfRidO7Yot98vN4rSJV56YxMFpFPY?=
 =?us-ascii?Q?UmWZbqykSo9fHkf9IIthoG5xQjdfSxS06h9QOp7A3ZNp1USvjl8ruVKSLn6N?=
 =?us-ascii?Q?fS6cZ6CgQV2C2QEWt+MTan+jSp9ZYi6IQXaY2hp72UYY6wxu1sTh1CZ8QHAq?=
 =?us-ascii?Q?8tNnmFvMgGXLOZ5CzVabV25lvZXhVW73cqYIabePbKPC8DI//zH0avFmEVji?=
 =?us-ascii?Q?kY5gtQxJT8i6T19srRbzo0cN9mYUcrSqI0UFdLK/Eg2I+kCNAzz/2+2tHxV+?=
 =?us-ascii?Q?bJYfOkplMADIrjQ7m4n3puxndibmlO95Uq6mTH91p8dQQXy96I6MS9Ak4aCO?=
 =?us-ascii?Q?v/FafmYMIAvin8jEbu/qh4BM8pZ6VBWrGEpnyKHAp0PfVihl0uC3uaxIF9In?=
 =?us-ascii?Q?72qwdEz6qOkjUOLuQ/PVIvuiPYhgiLJJubGZhf/WaSUJ4Y5exHzUDSJN5WZ+?=
 =?us-ascii?Q?1xGigUztvdnY2WYS8EKEmkt0l37cClKXF/4l5tmEa15l/7b4L9ZKRIOB8WMx?=
 =?us-ascii?Q?omx72DqrMWHVcNnQdHi2YqjN9bACd9sYD8tUccRN31e/ZkNcxAwTJTNrE3/b?=
 =?us-ascii?Q?OQP/hO6bsZojxycB1Rlo5E0D9NKdqmD0rYjcTbR8Zi3nX1WrQaVmk0SP/QIK?=
 =?us-ascii?Q?Bk4HgQVySsiSTVq6VKmMAHtEP9Am+f5h37nvhFHETa+uBgYeYWrhgC24um/e?=
 =?us-ascii?Q?+eZ/HZn8axCmyh9zVRHouAtCCbNG18jmCJX3zAFMIKQJ+DWTygjddOHarLp/?=
 =?us-ascii?Q?dw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 36393b77-6ef6-48e7-ccac-08db6b16d4ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 07:30:00.9793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HcDrqWlQPcsScQkZAPQPTYQ4f5hgT7lyRNrwrtYUiw5lUQxhiYr/QByax5HZi+aIfDPkMEoOZNUC6W2wXLjyvilyDk0novCJB4gnO3ihReI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6014
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Don't allow to change promisc mode in switchdev mode.
> When switchdev is configured, PF netdev is set to be a default VSI. This =
is
> needed for the slow-path to work correctly.
> All the unmatched packets will be directed to PF netdev.
>=20
> It is possible that this setting might be overwritten by ndo_set_rx_mode.
> Prevent this by checking if switchdev is enabled in ice_set_rx_mode.
>=20
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

During our testing, we found out that PF netdev promisc mode settings can b=
e changed in Switchdev mode.
Is this expected as per the implementation of this patch?

[root@wolfpass-switchdev ~]# ip link show dev ens802f0np0
193: ens802f0np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq maste=
r br0 state UP mode DEFAULT group default qlen 1000
    link/ether 6c:fe:54:5a:18:98 brd ff:ff:ff:ff:ff:ff
    vf 0     link/ether 52:52:00:00:00:01 brd ff:ff:ff:ff:ff:ff, spoof chec=
king on, link-state enable, trust off
    vf 1     link/ether 52:52:00:00:00:02 brd ff:ff:ff:ff:ff:ff, spoof chec=
king on, link-state enable, trust off
    altname enp175s0f0np0
[root@wolfpass-switchdev ~]# ip link set dev ens802f0np0 promisc on
[root@wolfpass-switchdev ~]# ip link show dev ens802f0np0
193: ens802f0np0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc =
mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 6c:fe:54:5a:18:98 brd ff:ff:ff:ff:ff:ff
    vf 0     link/ether 52:52:00:00:00:01 brd ff:ff:ff:ff:ff:ff, spoof chec=
king on, link-state enable, trust off
    vf 1     link/ether 52:52:00:00:00:02 brd ff:ff:ff:ff:ff:ff, spoof chec=
king on, link-state enable, trust off
    altname enp175s0f0np0
[root@wolfpass-switchdev ~]# ip link set dev ens802f0np0 promisc off
[root@wolfpass-switchdev ~]# ip link show dev ens802f0np0
193: ens802f0np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq maste=
r br0 state UP mode DEFAULT group default qlen 1000
    link/ether 6c:fe:54:5a:18:98 brd ff:ff:ff:ff:ff:ff
    vf 0     link/ether 52:52:00:00:00:01 brd ff:ff:ff:ff:ff:ff, spoof chec=
king on, link-state enable, trust off
    vf 1     link/ether 52:52:00:00:00:02 brd ff:ff:ff:ff:ff:ff, spoof chec=
king on, link-state enable, trust off
    altname enp175s0f0np0

