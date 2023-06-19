Return-Path: <netdev+bounces-12054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C64735D4E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6F65281148
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A625F1426F;
	Mon, 19 Jun 2023 18:08:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A55FC2C5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:08:52 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2115E63;
	Mon, 19 Jun 2023 11:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687198107; x=1718734107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U2ctTSFOTWoYyvS9yEFAkk74WBvCVtondtDhQhn9/5c=;
  b=NRwP7Ft6Uso1RZngKTmCDzUB7sFJMqasBdSY/A7E7+QdmAWzQEpvIoEw
   uOtIN/J1LSFL367XXtYM6zWSXN22mRSwS9HdCJZ9bvBGa1R9P8GkG97QN
   CQJoforvXMhYGtqkcroAOhdhqL27oS20zXstdwyJ5LzIVrJgUTU3w4JlK
   /aqiYNt32sikJIQKaaXUj5wgR8jHHu2HqFuXAlzavENG3BmDDLa7EJ0QY
   viCuZy4dPFKgfmAv+MFjGU+dnnm05sO1PLoaV4CZqHfDzE7EgKx6ZOKhk
   7T1tZqi4V/oY0IIkZ/8OlrIV+v13hqiU91xWAeYB31cIndNg5EcMGZUux
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="425640080"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="425640080"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 11:08:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="1043961387"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="1043961387"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2023 11:08:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 11:08:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 11:08:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 11:08:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 11:08:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY9IsBCnmW5SoKrf+1+VlV2omPkH4n6+eD/k7c1Jp0qxngG0uQVOGlG8jP9HXRM9qBWZ13fUAieRNjuPWcR+r4RkuBem9Ni7+e9PZa+4ZfeIo3pSzO+R1mY2Pdzedwn4y2MHPZv4R3ld0YkmyhPa0iOte/Lpypv81ZAuxU4foEmzBL85jYWAHfima6ejszmiaS/KArNvP0Hh/PR5Q89BGHOf7JmQqCHRNH1dCawGpjx7D9fYyqwI7WNf78QZWt718rYdZn7fvVV3MAyRmqNNd+UtRCLXiKW18a1ynNgs7btIolbBpRk2WMFDBkuJowF0aZOOMzb20m/2fizcqX/z2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6j/bY4YZSpyGIHl5Ux5fK481j5gZuyPUKv2rJKAo3uA=;
 b=K8YNEV5dooSVrhaXNkevUMeOcIz4pmslOk6WMVJQ2XYfeZ0A4au2K2zNlK32GZ64VdiK2SRMrZtRqcWBoCoJTx0fBV5sr4dTMIsVNG/U0suNgst2On5j0as6s7O4le21xmyyDfBCjIX6ktP83UQ4jd/lrhp5vlqDlNY9nIU5N2tRaWnhrnV+McHAhgcp4o1Knwoj1R8QAq1jEBD17RiS27XriPiH0Zf4tr2h5WGX4GV8cbiHcgX2MdlIdsCsEtsy8yc7w6f893RFsWYPWKl7Z7aUfPcPSONFTIMsYsGcI0W0O3WIhe/K7PMFqPczMG64O0PNdM2AkazGE7nTv7LS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6546.namprd11.prod.outlook.com (2603:10b6:510:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 18:08:12 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 18:08:12 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: "kuba@kernel.org" <kuba@kernel.org>, "vadfed@meta.com" <vadfed@meta.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "M, Saeed" <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "richardcochran@gmail.com"
	<richardcochran@gmail.com>, "sj@kernel.org" <sj@kernel.org>,
	"javierm@redhat.com" <javierm@redhat.com>, "ricardo.canuelo@collabora.com"
	<ricardo.canuelo@collabora.com>, "mst@redhat.com" <mst@redhat.com>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>, "Michalik, Michal"
	<michal.michalik@intel.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "jacek.lawrynowicz@linux.intel.com"
	<jacek.lawrynowicz@linux.intel.com>, "airlied@redhat.com"
	<airlied@redhat.com>, "ogabbay@kernel.org" <ogabbay@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>, "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "linux@zary.sk" <linux@zary.sk>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
	"geert+renesas@glider.be" <geert+renesas@glider.be>, "Olech, Milena"
	<milena.olech@intel.com>, "kuniyu@amazon.com" <kuniyu@amazon.com>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "andy.ren@getcruise.com" <andy.ren@getcruise.com>,
	"razor@blackwall.org" <razor@blackwall.org>, "idosch@nvidia.com"
	<idosch@nvidia.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "phil@nwl.cc"
	<phil@nwl.cc>, "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v8 08/10] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v8 08/10] ice: implement dpll interface to control
 cgu
Thread-Index: AQHZms0YKn5zDyH6hUaEbqiMD+5Ufq+DzkSAgA6YwQA=
Date: Mon, 19 Jun 2023 18:08:11 +0000
Message-ID: <DM6PR11MB4657C07B0DA46408BDD957CD9B5FA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-9-arkadiusz.kubalewski@intel.com>
 <ZIRI+/YDZMQJVs3i@nanopsycho>
In-Reply-To: <ZIRI+/YDZMQJVs3i@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6546:EE_
x-ms-office365-filtering-correlation-id: 92d0d364-d35a-49cc-af65-08db70f024fe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8rOMDvey4JfyyE9iHEwAX2n3KIcFjDRcalGgFWqRp5FMHWq8oQF2KjxoBX5qgEMq/ki5tSTsdXzPCsMC+3Naq1J+YxHjXlOJT3flZSJWHE/mfUD+Da/tAgnSQElStVPt5jdaAZS7lTuGTeslu779O+sexmGeacSvKtY+rLaWhxvDRNEp/lrHhIB2rs1Mb4CaaocgfciJ4xm1vuFe0C1fau/OLvduhjFreJLjUA4e8BFd29uPQFc3XSadpEBWE7qGwb8I75WBfhX4y0EqMz7OIAkATHR2OT4nTYtFbSWUQORn6JEzk+5xdpApwatGwws1JjD0LpBnwd9L8oF2LwYQD98q5I0/lUlqtCPYM4054HPmxLInRc5+u6RZ7ETZhwdvL4xa6vzKeElS38ZlvhZHqzlKTFYJt8veBYuoG8GhNgr2sDYlF92QOAz49GnPvlrke/iSGcNEykT06cx5EIWVVDvzI2M+cHzl0RbpEs/GJ44nXPwmj0IKQRmQujU2rKKI4nmk+9CFywTD9OmwdX0qzdGXha/rr8In6oqDjR8FYuM+XEwgl0m1jA790TW/r/iBLRVb7SEtdbKAU98AX51vlRdiugL9R6WXOfdkqWza28WeuEIznbaFFsbmtQEtReNg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199021)(52536014)(8676002)(8936002)(55016003)(478600001)(41300700001)(7406005)(7416002)(5660300002)(2906002)(30864003)(316002)(4326008)(64756008)(66476007)(66556008)(66946007)(66446008)(6916009)(76116006)(186003)(26005)(6506007)(54906003)(33656002)(71200400001)(86362001)(38070700005)(82960400001)(83380400001)(9686003)(7696005)(38100700002)(122000001)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T0mXeSJ8EMVmpClzNJP2xv8aBsJ/FKeD4wFXeMFhKtp3otlHhumwGKosNS8n?=
 =?us-ascii?Q?lOL+SMDYxMEeta8CvwrMSRxLKPqAaPByAoQOGyHWwR7rFnOgALSkWWQqY2wf?=
 =?us-ascii?Q?jFlvw3dfhahtqpnBWZ8x4QAO3m7XIKfW6vqPtpafdodMggFUnQl0HnJtflWr?=
 =?us-ascii?Q?zyaEMSITknzo7VleshTLwhb4OgJk0gPeX40+l3Wt68ZqANeHpsZYvZb9lMH8?=
 =?us-ascii?Q?BZ5oZ88jJvi2jImENgUSlB5fYHoj52WB6ct4Y6vziEFx3ZZqq1ale8NnF0hI?=
 =?us-ascii?Q?OOvfAlRgoOcVB+SnkAsxO1xWJKconjcK06IX3+XEs6Qcc/JvpHfPlRBI42zb?=
 =?us-ascii?Q?3evKPWacmbqmndSwrGFg9FcFaVYM90Ucq4kh0pSrVvgnHfh+zwYl3tqLlqXD?=
 =?us-ascii?Q?Dqj7tB9Z9lZUIVo4IW1f3A9o6NBl6xkdZOrOfl/lkqSGv1mrTBp6FFWOtn9Y?=
 =?us-ascii?Q?xTtEDjxeaYpSsfamejGpdJmn+mclxcaEfdEGaC6a2dLYfNrMaS3kaQJflfxw?=
 =?us-ascii?Q?V3sySNKF6u473YebypAHZwxatR5f9HqxAbTCDrXjlQvs69Ons3RAIm71R6fr?=
 =?us-ascii?Q?8rPYQL4yFHh140Vf6QkE8N0ufvziAD1DOQvglk3JaDyBwLuXFN5xrh3k2P7q?=
 =?us-ascii?Q?3m25H3BBU40+nwgh6FHkKAcOccXwY1miNxtmEc46Ril9qB6ZAB1sGq6eIhqx?=
 =?us-ascii?Q?sOhIOUXcu1wkq/Zt5V5qCnEJjggQQrzQGKcdwzmGBzX4yAhOZO52U5bdSNCS?=
 =?us-ascii?Q?k0ZZhLkEjlKJ9dxua55Gqk495gOwyCUHmFqgCYXqKGmnfMp8gs0HVeipsWqS?=
 =?us-ascii?Q?kFbm2irEYG9gu3LN+AVis4STv8SipI+IJXvNA+ZAdu/85Ep5I0uax1ndkyU0?=
 =?us-ascii?Q?VB8XuVyRg+emhJEo/MiqLyHCK4A2GyGfAZ6G+EEQBN5kXlUx1WHeTU29Gych?=
 =?us-ascii?Q?CT8wEHibABoz0Ykc+I0BStWdwZsWA4qVqHLpAy/vz7DRbbfoiCiAy7+Z1eVk?=
 =?us-ascii?Q?3t+rn/J7e/AYKEVjPurMLFORu7OD4qyNnJW3WnvTI0ASbkwCSGmfCwR78EbR?=
 =?us-ascii?Q?Ku2QuNBIYG29R1BmmQCMHFBqFmUDr21nWMznpKAF+xNSUImXE6Kew6oVZqGQ?=
 =?us-ascii?Q?nzW6TB6TkQ0+/jSYBbRoui1Zx9iejVCPP/W05EfDQWRRSdTbbZE/xoMRWBIe?=
 =?us-ascii?Q?Zx0TS9IoQCzMRMpbKJobEqpSFs9dl1rsc6KtsPEZrWWSPgduieFx0/p43dPq?=
 =?us-ascii?Q?ilAoMaeVJ/48XSt/1hrkg4rz5YzPUT/+TzCs3HlBsYZ3Psoz6q7XNCExE7+B?=
 =?us-ascii?Q?qV9khl5Y2+d81V4TWv54+k//nYVNk8sm5svZQFCxX+yxDAcQv92Mj4bXDZnB?=
 =?us-ascii?Q?ake6XxWD/62uSs6eu/cpsd/8sWuZ5yzN1NBDQSFhhnv0Ir46+OqsfJVPiCGJ?=
 =?us-ascii?Q?1QGeJCiv48yV6aTDjTgs/6dqS1WyR8bLg/CBmQ+bihT2b/l/tu4an16yYILZ?=
 =?us-ascii?Q?ktVF93xEYNqqBWux+AhdXQOnLM5s040vnBdrNAeX/Ge+yNmzWPVH06E0Ru3g?=
 =?us-ascii?Q?ldR1QXzmhVnpLCcKtWYFlk7Z9IlSJ5acflGMbvAG7Sn87eyjqcTuaOzR34DD?=
 =?us-ascii?Q?gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d0d364-d35a-49cc-af65-08db70f024fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 18:08:11.7909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dF3+W0xbyeIxA5xGi0efm1y9KUhqF0rqC2l50WP2casWpFcxTFVMcNLdn9pfPLIoCC+O/rgf4krrqoS5Pwj8y6fR4in0eeDz0BXjsvii/MA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6546
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Saturday, June 10, 2023 11:57 AM
>
>Fri, Jun 09, 2023 at 02:18:51PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>Control over clock generation unit is required for further development
>>of Synchronous Ethernet feature. Interface provides ability to obtain
>>current state of a dpll, its sources and outputs which are pins, and
>>allows their configuration.
>>
>>Co-developed-by: Milena Olech <milena.olech@intel.com>
>>Signed-off-by: Milena Olech <milena.olech@intel.com>
>>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>---
>> drivers/net/ethernet/intel/Kconfig        |    1 +
>> drivers/net/ethernet/intel/ice/Makefile   |    3 +-
>> drivers/net/ethernet/intel/ice/ice.h      |    4 +
>> drivers/net/ethernet/intel/ice/ice_dpll.c | 2015 +++++++++++++++++++++
>> drivers/net/ethernet/intel/ice/ice_dpll.h |  102 ++
>> drivers/net/ethernet/intel/ice/ice_main.c |    7 +
>> 6 files changed, 2131 insertions(+), 1 deletion(-)
>> create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.c
>> create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
>>
>>diff --git a/drivers/net/ethernet/intel/Kconfig
>>b/drivers/net/ethernet/intel/Kconfig
>>index 9bc0a9519899..913dcf928d15 100644
>>--- a/drivers/net/ethernet/intel/Kconfig
>>+++ b/drivers/net/ethernet/intel/Kconfig
>>@@ -284,6 +284,7 @@ config ICE
>> 	select DIMLIB
>> 	select NET_DEVLINK
>> 	select PLDMFW
>>+	select DPLL
>> 	help
>> 	  This driver supports Intel(R) Ethernet Connection E800 Series of
>> 	  devices.  For more information on how to identify your adapter, go
>>diff --git a/drivers/net/ethernet/intel/ice/Makefile
>>b/drivers/net/ethernet/intel/ice/Makefile
>>index 817977e3039d..85d6366d1f5b 100644
>>--- a/drivers/net/ethernet/intel/ice/Makefile
>>+++ b/drivers/net/ethernet/intel/ice/Makefile
>>@@ -34,7 +34,8 @@ ice-y :=3D ice_main.o	\
>> 	 ice_lag.o	\
>> 	 ice_ethtool.o  \
>> 	 ice_repr.o	\
>>-	 ice_tc_lib.o
>>+	 ice_tc_lib.o	\
>>+	 ice_dpll.o
>> ice-$(CONFIG_PCI_IOV) +=3D	\
>> 	ice_sriov.o		\
>> 	ice_virtchnl.o		\
>>diff --git a/drivers/net/ethernet/intel/ice/ice.h
>>b/drivers/net/ethernet/intel/ice/ice.h
>>index ae58d7499955..8a110272a799 100644
>>--- a/drivers/net/ethernet/intel/ice/ice.h
>>+++ b/drivers/net/ethernet/intel/ice/ice.h
>>@@ -76,6 +76,7 @@
>> #include "ice_vsi_vlan_ops.h"
>> #include "ice_gnss.h"
>> #include "ice_irq.h"
>>+#include "ice_dpll.h"
>>
>> #define ICE_BAR0		0
>> #define ICE_REQ_DESC_MULTIPLE	32
>>@@ -198,6 +199,7 @@
>> enum ice_feature {
>> 	ICE_F_DSCP,
>> 	ICE_F_PTP_EXTTS,
>>+	ICE_F_PHY_RCLK,
>> 	ICE_F_SMA_CTRL,
>> 	ICE_F_CGU,
>> 	ICE_F_GNSS,
>>@@ -506,6 +508,7 @@ enum ice_pf_flags {
>> 	ICE_FLAG_UNPLUG_AUX_DEV,
>> 	ICE_FLAG_MTU_CHANGED,
>> 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
>>+	ICE_FLAG_DPLL,			/* SyncE/PTP dplls initialized */
>> 	ICE_PF_FLAGS_NBITS		/* must be last */
>> };
>>
>>@@ -628,6 +631,7 @@ struct ice_pf {
>> #define ICE_VF_AGG_NODE_ID_START	65
>> #define ICE_MAX_VF_AGG_NODES		32
>> 	struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
>>+	struct ice_dplls dplls;
>> };
>>
>> struct ice_netdev_priv {
>>diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c
>>b/drivers/net/ethernet/intel/ice/ice_dpll.c
>>new file mode 100644
>>index 000000000000..22a69197188a
>>--- /dev/null
>>+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
>>@@ -0,0 +1,2015 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/* Copyright (C) 2022, Intel Corporation. */
>>+
>>+#include "ice.h"
>>+#include "ice_lib.h"
>>+#include "ice_trace.h"
>>+#include <linux/dpll.h>
>>+
>>+#define ICE_CGU_STATE_ACQ_ERR_THRESHOLD		50
>>+#define ICE_DPLL_LOCK_TRIES			1000
>>+#define ICE_DPLL_PIN_IDX_INVALID		0xff
>>+#define ICE_DPLL_RCLK_NUM_PER_PF		1
>>+
>>+/**
>>+ * dpll_lock_status - map ice cgu states into dpll's subsystem lock
>>status
>>+ */
>>+static const enum dpll_lock_status
>>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] =3D {
>>+	[ICE_CGU_STATE_INVALID] =3D 0,
>
>It's already 0, drop this pointless assign.
>

Fixed.

>
>>+	[ICE_CGU_STATE_FREERUN] =3D DPLL_LOCK_STATUS_UNLOCKED,
>>+	[ICE_CGU_STATE_LOCKED] =3D DPLL_LOCK_STATUS_LOCKED,
>>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] =3D DPLL_LOCK_STATUS_LOCKED_HO_ACQ,
>>+	[ICE_CGU_STATE_HOLDOVER] =3D DPLL_LOCK_STATUS_HOLDOVER,
>>+};
>>+
>>+/**
>>+ * ice_dpll_pin_type - enumerate ice pin types
>>+ */
>>+enum ice_dpll_pin_type {
>>+	ICE_DPLL_PIN_INVALID =3D 0,
>
>Not needed to set 0 here, it is implicit.
>

Fixed.

>
>>+	ICE_DPLL_PIN_TYPE_INPUT,
>>+	ICE_DPLL_PIN_TYPE_OUTPUT,
>>+	ICE_DPLL_PIN_TYPE_RCLK_INPUT,
>>+};
>>+
>>+/**
>>+ * pin_type_name - string names of ice pin types
>>+ */
>>+static const char * const pin_type_name[] =3D {
>>+	[ICE_DPLL_PIN_TYPE_INPUT] =3D "input",
>>+	[ICE_DPLL_PIN_TYPE_OUTPUT] =3D "output",
>>+	[ICE_DPLL_PIN_TYPE_RCLK_INPUT] =3D "rclk-input",
>>+};
>>+
>>+/**
>>+ * ice_dpll_cb_lock - lock dplls mutex in callback context
>>+ * @pf: private board structure
>>+ *
>>+ * Lock the mutex from the callback operations invoked by dpll subsystem=
.
>>+ * Prevent dead lock caused by `rmmod ice` when dpll callbacks are under
>>stress
>
>"dead lock", really? Which one? Didn't you want to write "livelock"?
>

As explained, rmmod takes and destroys lock, it can happen that
netlink request/ops hangs on trying to lock when rmmod started deinit.

>If this is livelock prevention, is this something you really see or
>just an assumption? Seems to me unlikely.
>
>Plus, see my note in ice_dpll_init(). If you remove taking the lock from
>ice_dpll_init() and ice_dpll_deinit(), do you still need this? I don't
>think so.
>

I won't remove it from there, as the lock shall serialize the access to ice=
 dpll
data, so it must be held on init until everything is ready for netlink acce=
ss,
or when deinit takes place, until everything is released.

>
>>+ * tests.
>>+ *
>>+ * Return:
>>+ * 0 - if lock acquired
>>+ * negative - lock not acquired or dpll was deinitialized
>>+ */
>>+static int ice_dpll_cb_lock(struct ice_pf *pf)
>>+{
>>+	int i;
>>+
>>+	for (i =3D 0; i < ICE_DPLL_LOCK_TRIES; i++) {
>>+		if (mutex_trylock(&pf->dplls.lock))
>>+			return 0;
>>+		usleep_range(100, 150);
>>+		if (!test_bit(ICE_FLAG_DPLL, pf->flags))
>
>How exactly could this happen? I don't think it can. Drop it.
>

Asynchronously called deinit, and kworker tries to update at the same time.

>
>>+			return -EFAULT;
>>+	}
>>+
>>+	return -EBUSY;
>>+}
>>+
>>+/**
>>+ * ice_dpll_cb_unlock - unlock dplls mutex in callback context
>>+ * @pf: private board structure
>>+ *
>>+ * Unlock the mutex from the callback operations invoked by dpll
>>subsystem.
>>+ */
>>+static void ice_dpll_cb_unlock(struct ice_pf *pf)
>>+{
>>+	mutex_unlock(&pf->dplls.lock);
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_freq_set - set pin's frequency
>>+ * @pf: private board structure
>>+ * @pin: pointer to a pin
>>+ * @pin_type: type of pin being configured
>>+ * @freq: frequency to be set
>>+ *
>>+ * Set requested frequency on a pin.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error on AQ or wrong pin type given
>>+ */
>>+static int
>>+ice_dpll_pin_freq_set(struct ice_pf *pf, struct ice_dpll_pin *pin,
>>+		      enum ice_dpll_pin_type pin_type, const u32 freq)
>>+{
>>+	int ret =3D -EINVAL;
>>+	u8 flags;
>>+
>>+	switch (pin_type) {
>>+	case ICE_DPLL_PIN_TYPE_INPUT:
>>+		flags =3D ICE_AQC_SET_CGU_IN_CFG_FLG1_UPDATE_FREQ;
>>+		ret =3D ice_aq_set_input_pin_cfg(&pf->hw, pin->idx, flags,
>>+					       pin->flags[0], freq, 0);
>>+		break;
>>+	case ICE_DPLL_PIN_TYPE_OUTPUT:
>>+		flags =3D ICE_AQC_SET_CGU_OUT_CFG_UPDATE_FREQ;
>>+		ret =3D ice_aq_set_output_pin_cfg(&pf->hw, pin->idx, flags,
>>+						0, freq, 0);
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+	if (ret) {
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"err:%d %s failed to set pin freq:%u on pin:%u\n",
>>+			ret, ice_aq_str(pf->hw.adminq.sq_last_status),
>>+			freq, pin->idx);
>
>Why you need dev_err here? Why can't this be rather put to the extack
>message? Much better. Try to avoid polluting dmesg.
>

Fixed.

>
>>+		return ret;
>>+	}
>>+	pin->freq =3D freq;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_frequency_set - wrapper for pin callback for set frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: frequency to be set
>>+ * @extack: error reporting
>>+ * @pin_type: type of pin being configured
>>+ *
>>+ * Wraps internal set frequency command on a pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't set in hw
>>+ */
>>+static int
>>+ice_dpll_frequency_set(const struct dpll_pin *pin, void *pin_priv,
>>+		       const struct dpll_device *dpll, void *dpll_priv,
>>+		       const u32 frequency,
>>+		       struct netlink_ext_ack *extack,
>>+		       enum ice_dpll_pin_type pin_type)
>>+{
>>+	struct ice_pf *pf =3D ((struct ice_dpll *)dpll_priv)->pf;
>
>Rather do:
>	struct ice_dpll *dpll =3D dpll_priv;
>	struct ice_pf *pf =3D dpll->pf;
>And avoid the cast. Easier to read as well.
>Same on other places.
>

Fixed.

>
>>+	struct ice_dpll_pin *p =3D pin_priv;
>>+	int ret =3D -EINVAL;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D ice_dpll_pin_freq_set(pf, p, pin_type, frequency);
>>+	ice_dpll_cb_unlock(pf);
>>+	if (ret)
>>+		NL_SET_ERR_MSG(extack, "frequency was not set");
>
>Yeah, that is stating the obvious as the use got error value, but tell
>him some other details. Fill this in ice_dpll_pin_freq_set() by the
>message you have there for dev_err() instead.
>

Fixed.

>
>
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_frequency_set - input pin callback for set frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: frequency to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal set frequency command on a pin.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't set in hw
>>+ */
>>+static int
>>+ice_dpll_input_frequency_set(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     u64 frequency, struct netlink_ext_ack *extack)
>>+{
>>+	return ice_dpll_frequency_set(pin, pin_priv, dpll, dpll_priv,
>>frequency,
>>+				      extack, ICE_DPLL_PIN_TYPE_INPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_frequency_set - output pin callback for set frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: frequency to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal set frequency command on a pin.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't set in hw
>>+ */
>>+static int
>>+ice_dpll_output_frequency_set(const struct dpll_pin *pin, void *pin_priv=
,
>>+			      const struct dpll_device *dpll, void *dpll_priv,
>>+			      u64 frequency, struct netlink_ext_ack *extack)
>>+{
>>+	return ice_dpll_frequency_set(pin, pin_priv, dpll, dpll_priv,
>>frequency,
>>+				      extack, ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_frequency_get - wrapper for pin callback for get frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: on success holds pin's frequency
>>+ * @extack: error reporting
>>+ * @pin_type: type of pin being configured
>>+ *
>>+ * Wraps internal get frequency command of a pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't get from hw
>>+ */
>>+static int
>>+ice_dpll_frequency_get(const struct dpll_pin *pin, void *pin_priv,
>>+		       const struct dpll_device *dpll, void *dpll_priv,
>>+		       u64 *frequency, struct netlink_ext_ack *extack,
>>+		       enum ice_dpll_pin_type pin_type)
>>+{
>>+	struct ice_pf *pf =3D ((struct ice_dpll *)dpll_priv)->pf;
>>+	struct ice_dpll_pin *p =3D pin_priv;
>>+	int ret =3D -EINVAL;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	*frequency =3D p->freq;
>>+	ice_dpll_cb_unlock(pf);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_frequency_get - input pin callback for get frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: on success holds pin's frequency
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal get frequency command of a input pin.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't get from hw
>>+ */
>>+static int
>>+ice_dpll_input_frequency_get(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     u64 *frequency, struct netlink_ext_ack *extack)
>>+{
>>+	return ice_dpll_frequency_get(pin, pin_priv, dpll, dpll_priv,
>>frequency,
>>+				      extack, ICE_DPLL_PIN_TYPE_INPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_frequency_get - output pin callback for get frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: on success holds pin's frequency
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal get frequency command of a pin.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't get from hw
>>+ */
>>+static int
>>+ice_dpll_output_frequency_get(const struct dpll_pin *pin, void *pin_priv=
,
>>+			      const struct dpll_device *dpll, void *dpll_priv,
>>+			      u64 *frequency, struct netlink_ext_ack *extack)
>>+{
>>+	return ice_dpll_frequency_get(pin, pin_priv, dpll, dpll_priv,
>>frequency,
>>+				      extack, ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_enable - enable a pin on dplls
>>+ * @hw: board private hw structure
>>+ * @pin: pointer to a pin
>>+ * @pin_type: type of pin being enabled
>>+ *
>>+ * Enable a pin on both dplls. Store current state in pin->flags.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - OK
>>+ * * negative - error
>>+ */
>>+static int
>>+ice_dpll_pin_enable(struct ice_hw *hw, struct ice_dpll_pin *pin,
>>+		    enum ice_dpll_pin_type pin_type)
>>+{
>>+	int ret =3D -EINVAL;
>>+	u8 flags =3D 0;
>>+
>>+	switch (pin_type) {
>>+	case ICE_DPLL_PIN_TYPE_INPUT:
>>+		if (pin->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_ESYNC_EN)
>>+			flags |=3D ICE_AQC_SET_CGU_IN_CFG_FLG2_ESYNC_EN;
>>+		flags |=3D ICE_AQC_SET_CGU_IN_CFG_FLG2_INPUT_EN;
>>+		ret =3D ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
>>+		break;
>>+	case ICE_DPLL_PIN_TYPE_OUTPUT:
>>+		if (pin->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN)
>>+			flags |=3D ICE_AQC_SET_CGU_OUT_CFG_ESYNC_EN;
>>+		flags |=3D ICE_AQC_SET_CGU_OUT_CFG_OUT_EN;
>>+		ret =3D ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+	if (ret)
>>+		dev_err(ice_pf_to_dev((struct ice_pf *)(hw->back)),
>>+			"err:%d %s failed to enable %s pin:%u\n",
>>+			ret, ice_aq_str(hw->adminq.sq_last_status),
>>+			pin_type_name[pin_type], pin->idx);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_disable - disable a pin on dplls
>>+ * @hw: board private hw structure
>>+ * @pin: pointer to a pin
>>+ * @pin_type: type of pin being disabled
>>+ *
>>+ * Disable a pin on both dplls. Store current state in pin->flags.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - OK
>>+ * * negative - error
>>+ */
>>+static int
>>+ice_dpll_pin_disable(struct ice_hw *hw, struct ice_dpll_pin *pin,
>>+		     enum ice_dpll_pin_type pin_type)
>>+{
>>+	int ret =3D -EINVAL;
>>+	u8 flags =3D 0;
>>+
>>+	switch (pin_type) {
>>+	case ICE_DPLL_PIN_TYPE_INPUT:
>>+		if (pin->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_ESYNC_EN)
>>+			flags |=3D ICE_AQC_SET_CGU_IN_CFG_FLG2_ESYNC_EN;
>>+		ret =3D ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
>>+		break;
>>+	case ICE_DPLL_PIN_TYPE_OUTPUT:
>>+		if (pin->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN)
>>+			flags |=3D ICE_AQC_SET_CGU_OUT_CFG_ESYNC_EN;
>>+		ret =3D ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+	if (ret)
>>+		dev_err(ice_pf_to_dev((struct ice_pf *)(hw->back)),
>>+			"err:%d %s failed to disable %s pin:%u\n",
>>+			ret, ice_aq_str(hw->adminq.sq_last_status),
>>+			pin_type_name[pin_type], pin->idx);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_state_update - update pin's state
>>+ * @hw: private board struct
>>+ * @pin: structure with pin attributes to be updated
>>+ * @pin_type: type of pin being updated
>>+ *
>>+ * Determine pin current state and frequency, then update struct
>>+ * holding the pin info. For input pin states are separated for each
>>+ * dpll, for rclk pins states are separated for each parent.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - OK
>>+ * * negative - error
>>+ */
>>+int
>>+ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
>>+			  enum ice_dpll_pin_type pin_type)
>>+{
>>+	int ret =3D -EINVAL;
>>+
>>+	switch (pin_type) {
>>+	case ICE_DPLL_PIN_TYPE_INPUT:
>>+		ret =3D ice_aq_get_input_pin_cfg(&pf->hw, pin->idx, NULL, NULL,
>>+					       NULL, &pin->flags[0],
>>+					       &pin->freq, NULL);
>>+		if (ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN & pin->flags[0]) {
>>+			if (pin->pin) {
>>+				pin->state[pf->dplls.eec.dpll_idx] =3D
>>+					pin->pin =3D=3D pf->dplls.eec.active_input ?
>>+					DPLL_PIN_STATE_CONNECTED :
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+				pin->state[pf->dplls.pps.dpll_idx] =3D
>>+					pin->pin =3D=3D pf->dplls.pps.active_input ?
>>+					DPLL_PIN_STATE_CONNECTED :
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+			} else {
>>+				pin->state[pf->dplls.eec.dpll_idx] =3D
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+				pin->state[pf->dplls.pps.dpll_idx] =3D
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+			}
>>+		} else {
>>+			pin->state[pf->dplls.eec.dpll_idx] =3D
>>+				DPLL_PIN_STATE_DISCONNECTED;
>>+			pin->state[pf->dplls.pps.dpll_idx] =3D
>>+				DPLL_PIN_STATE_DISCONNECTED;
>>+		}
>>+		break;
>>+	case ICE_DPLL_PIN_TYPE_OUTPUT:
>>+		ret =3D ice_aq_get_output_pin_cfg(&pf->hw, pin->idx,
>>+						&pin->flags[0], NULL,
>>+						&pin->freq, NULL);
>>+		if (ICE_AQC_SET_CGU_OUT_CFG_OUT_EN & pin->flags[0])
>>+			pin->state[0] =3D DPLL_PIN_STATE_CONNECTED;
>>+		else
>>+			pin->state[0] =3D DPLL_PIN_STATE_DISCONNECTED;
>>+		break;
>>+	case ICE_DPLL_PIN_TYPE_RCLK_INPUT:
>>+		u8 parent, port_num =3D ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT;
>>+
>>+		for (parent =3D 0; parent < pf->dplls.rclk.num_parents;
>>+		     parent++) {
>>+			ret =3D ice_aq_get_phy_rec_clk_out(&pf->hw, parent,
>>+							 &port_num,
>>+							 &pin->flags[parent],
>>+							 &pin->freq);
>>+			if (ret)
>>+				return ret;
>>+			if (ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN &
>>+			    pin->flags[parent])
>>+				pin->state[parent] =3D DPLL_PIN_STATE_CONNECTED;
>>+			else
>>+				pin->state[parent] =3D
>>+					DPLL_PIN_STATE_DISCONNECTED;
>>+		}
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_find_dpll - find ice_dpll on a pf
>>+ * @pf: private board structure
>>+ * @dpll: kernel's dpll_device pointer to be searched
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * pointer if ice_dpll with given device dpll pointer is found
>>+ * * NULL if not found
>>+ */
>>+static struct ice_dpll
>>+*ice_find_dpll(struct ice_pf *pf, const struct dpll_device *dpll)
>>+{
>>+	if (!pf || !dpll)
>>+		return NULL;
>>+
>>+	return dpll =3D=3D pf->dplls.eec.dpll ? &pf->dplls.eec :
>>+	       dpll =3D=3D pf->dplls.pps.dpll ? &pf->dplls.pps : NULL;
>>+}
>>+
>>+/**
>>+ * ice_dpll_hw_input_prio_set - set input priority value in hardware
>>+ * @pf: board private structure
>>+ * @dpll: ice dpll pointer
>>+ * @pin: ice pin pointer
>>+ * @prio: priority value being set on a dpll
>>+ *
>>+ * Internal wrapper for setting the priority in the hardware.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int
>>+ice_dpll_hw_input_prio_set(struct ice_pf *pf, struct ice_dpll *dpll,
>>+			   struct ice_dpll_pin *pin, const u32 prio)
>>+{
>>+	int ret;
>>+
>>+	ret =3D ice_aq_set_cgu_ref_prio(&pf->hw, dpll->dpll_idx, pin->idx,
>>+				      (u8)prio);
>>+	if (ret)
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"err:%d %s failed to set pin prio:%u on pin:%u\n",
>>+			ret, ice_aq_str(pf->hw.adminq.sq_last_status),
>>+			prio, pin->idx);
>>+	else
>>+		dpll->input_prio[pin->idx] =3D prio;
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_lock_status_get - get dpll lock status callback
>>+ * @dpll: registered dpll pointer
>>+ * @status: on success holds dpll's lock status
>>+ *
>>+ * Dpll subsystem callback, provides dpll's lock status.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_lock_status_get(const struct dpll_device *dpll, void
>>*priv,
>>+				    enum dpll_lock_status *status,
>>+				    struct netlink_ext_ack *extack)
>>+{
>>+	struct ice_dpll *d =3D priv;
>>+	struct ice_pf *pf =3D d->pf;
>>+	int ret =3D -EINVAL;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	*status =3D ice_dpll_status[d->dpll_state];
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pf:%p, ret:%d\n", __func__,
>>+		dpll, pf, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_mode_get - get dpll's working mode
>>+ * @dpll: registered dpll pointer
>>+ * @priv: private data pointer passed on dpll registration
>>+ * @mode: on success holds current working mode of dpll
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Provides working mode of dpll.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_mode_get(const struct dpll_device *dpll, void *priv,
>>+			     enum dpll_mode *mode,
>>+			     struct netlink_ext_ack *extack)
>>+{
>>+	*mode =3D DPLL_MODE_AUTOMATIC;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_mode_get - check if dpll's working mode is supported
>>+ * @dpll: registered dpll pointer
>>+ * @priv: private data pointer passed on dpll registration
>>+ * @mode: mode to be checked for support
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Provides information if working mode is
>>supported
>>+ * by dpll.
>>+ *
>>+ * Return:
>>+ * * true - mode is supported
>>+ * * false - mode is not supported
>>+ */
>>+static bool ice_dpll_mode_supported(const struct dpll_device *dpll, void
>>*priv,
>>+				    enum dpll_mode mode,
>>+				    struct netlink_ext_ack *extack)
>>+{
>>+	if (mode =3D=3D DPLL_MODE_AUTOMATIC)
>>+		return true;
>>+
>>+	return false;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_state_set - set pin's state on dpll
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: state of pin to be set
>>+ * @extack: error reporting
>>+ * @pin_type: type of a pin
>>+ *
>>+ * Set pin state on a pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - OK or no change required
>>+ * * negative - error
>>+ */
>>+static int
>>+ice_dpll_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
>>+		       const struct dpll_device *dpll, void *dpll_priv,
>>+		       bool enable, struct netlink_ext_ack *extack,
>>+		       enum ice_dpll_pin_type pin_type)
>>+{
>>+	struct ice_pf *pf =3D ((struct ice_dpll *)dpll_priv)->pf;
>>+	struct ice_dpll_pin *p =3D pin_priv;
>>+	int ret =3D -EINVAL;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	if (enable)
>>+		ret =3D ice_dpll_pin_enable(&pf->hw, p, pin_type);
>>+	else
>>+		ret =3D ice_dpll_pin_disable(&pf->hw, p, pin_type);
>>+	if (!ret)
>>+		ret =3D ice_dpll_pin_state_update(pf, p, pin_type);
>>+	ice_dpll_cb_unlock(pf);
>>+	if (ret)
>>+		dev_err(ice_pf_to_dev(pf),
>
>You have another dev_err inside ice_dpll_pin_enable(). Please avoid
>redundancies like that.
>

Fixed.

>
>>+			"%s: dpll:%p, pin:%p, p:%p pf:%p enable:%d ret:%d\n",
>>+			__func__, dpll, pin, p, pf, enable, ret);
>
>Quite cryptic. Make it more readable and use extack to pass the error
>message to the user.
>
>Actually, I don't want to repeat myself, but could you please do this
>conversion in the rest of the ops as well. I mean, if you have extack,
>just fill it up properly so the user knows what is wrong. Avoid the
>dev_errs() in that cases.
>

Fixed.

>
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_state_set - enable/disable output pin on dpll device
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: dpll being configured
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: state of pin to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Set given state on output type pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - successfully enabled mode
>>+ * * negative - failed to enable mode
>>+ */
>>+static int
>>+ice_dpll_output_state_set(const struct dpll_pin *pin, void *pin_priv,
>>+			  const struct dpll_device *dpll, void *dpll_priv,
>>+			  enum dpll_pin_state state,
>>+			  struct netlink_ext_ack *extack)
>>+{
>>+	bool enable =3D state =3D=3D DPLL_PIN_STATE_CONNECTED ? true : false;
>
>Just:
>	bool enable =3D state =3D=3D DPLL_PIN_STATE_CONNECTED;
>

Fixed.

>
>>+
>>+	return ice_dpll_pin_state_set(pin, pin_priv, dpll, dpll_priv, enable,
>>+				      extack, ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_state_set - enable/disable input pin on dpll levice
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: dpll being configured
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: state of pin to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Enables given mode on input type pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - successfully enabled mode
>>+ * * negative - failed to enable mode
>>+ */
>>+static int
>>+ice_dpll_input_state_set(const struct dpll_pin *pin, void *pin_priv,
>>+			 const struct dpll_device *dpll, void *dpll_priv,
>>+			 enum dpll_pin_state state,
>>+			 struct netlink_ext_ack *extack)
>>+{
>>+	bool enable =3D state =3D=3D DPLL_PIN_STATE_SELECTABLE ? true : false;
>
>Just:
>	bool enable =3D state =3D=3D DPLL_PIN_STATE_SELECTABLE;

Fixed.

>
>>+
>>+	return ice_dpll_pin_state_set(pin, pin_priv, dpll, dpll_priv, enable,
>>+				      extack, ICE_DPLL_PIN_TYPE_INPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_state_get - set pin's state on dpll
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: on success holds state of the pin
>>+ * @extack: error reporting
>>+ * @pin_type: type of questioned pin
>>+ *
>>+ * Determine pin state set it on a pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failed to get state
>>+ */
>>+static int
>>+ice_dpll_pin_state_get(const struct dpll_pin *pin, void *pin_priv,
>>+		       const struct dpll_device *dpll,  void *dpll_priv,
>>+		       enum dpll_pin_state *state,
>>+		       struct netlink_ext_ack *extack,
>>+		       enum ice_dpll_pin_type pin_type)
>>+{
>>+	struct ice_pf *pf =3D ((struct ice_dpll *)dpll_priv)->pf;
>>+	struct ice_dpll_pin *p =3D pin_priv;
>>+	struct ice_dpll *d;
>>+	int ret =3D -EINVAL;
>
>Pointless init, drop it.
>

Fixed.

>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	d =3D ice_find_dpll(pf, dpll);
>
>This is a leftover. please remove, use dpll_priv and remove
>ice_find_dpll() entirely.
>

Fixed.

>
>>+	if (!d)
>>+		goto unlock;
>>+	ret =3D ice_dpll_pin_state_update(pf, p, pin_type);
>>+	if (ret)
>>+		goto unlock;
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_INPUT)
>>+		*state =3D p->state[d->dpll_idx];
>>+	else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT)
>>+		*state =3D p->state[0];
>>+	ret =3D 0;
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	if (ret)
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"%s: dpll:%p, pin:%p, pf:%p state: %d ret:%d\n",
>>+			__func__, dpll, pin, pf, *state, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_state_get - get output pin state on dpll device
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: on success holds state of the pin
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Check state of a pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failed to get state
>>+ */
>>+static int
>>+ice_dpll_output_state_get(const struct dpll_pin *pin, void *pin_priv,
>>+			  const struct dpll_device *dpll, void *dpll_priv,
>>+			  enum dpll_pin_state *state,
>>+			  struct netlink_ext_ack *extack)
>>+{
>>+	return ice_dpll_pin_state_get(pin, pin_priv, dpll, dpll_priv, state,
>>+				      extack, ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_state_get - get input pin state on dpll device
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: on success holds state of the pin
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Check state of a input pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failed to get state
>>+ */
>>+static int
>>+ice_dpll_input_state_get(const struct dpll_pin *pin, void *pin_priv,
>>+			 const struct dpll_device *dpll, void *dpll_priv,
>>+			 enum dpll_pin_state *state,
>>+			 struct netlink_ext_ack *extack)
>>+{
>>+	return ice_dpll_pin_state_get(pin, pin_priv, dpll, dpll_priv, state,
>>+				      extack, ICE_DPLL_PIN_TYPE_INPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_prio_get - get dpll's input prio
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @prio: on success - returns input priority on dpll
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for getting priority of a input pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int
>>+ice_dpll_input_prio_get(const struct dpll_pin *pin, void *pin_priv,
>>+			const struct dpll_device *dpll, void *dpll_priv,
>>+			u32 *prio, struct netlink_ext_ack *extack)
>>+{
>>+	struct ice_dpll_pin *p =3D pin_priv;
>>+	struct ice_dpll *d =3D dpll_priv;
>>+	struct ice_pf *pf =3D d->pf;
>>+	int ret =3D -EINVAL;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	*prio =3D d->input_prio[p->idx];
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pin:%p, pf:%p ret:%d\n",
>>+		__func__, dpll, pin, pf, ret);
>
>What exactly is this good for?
>

Removed.

>
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_prio_set - set dpll input prio
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @prio: input priority to be set on dpll
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for setting priority of a input pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int
>>+ice_dpll_input_prio_set(const struct dpll_pin *pin, void *pin_priv,
>>+			const struct dpll_device *dpll, void *dpll_priv,
>>+			u32 prio, struct netlink_ext_ack *extack)
>>+{
>>+	struct ice_dpll_pin *p =3D pin_priv;
>>+	struct ice_dpll *d =3D dpll_priv;
>>+	struct ice_pf *pf =3D d->pf;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (prio > ICE_DPLL_PRIO_MAX) {
>>+		NL_SET_ERR_MSG_FMT(extack, "prio out of supported range 0-%d",
>>+				   ICE_DPLL_PRIO_MAX);
>>+		return ret;
>>+	}
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D ice_dpll_hw_input_prio_set(pf, d, p, prio);
>>+	if (ret)
>>+		NL_SET_ERR_MSG_FMT(extack, "unable to set prio: %u", prio);
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pin:%p, pf:%p ret:%d\n",
>>+		__func__, dpll, pin, pf, ret);
>
>Same here.
>

Removed.

>
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_input_direction - callback for get input pin direction
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @direction: holds input pin direction
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for getting direction of a input pin=
.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ */
>>+static int
>>+ice_dpll_input_direction(const struct dpll_pin *pin, void *pin_priv,
>>+			 const struct dpll_device *dpll, void *dpll_priv,
>>+			 enum dpll_pin_direction *direction,
>>+			 struct netlink_ext_ack *extack)
>>+{
>>+	*direction =3D DPLL_PIN_DIRECTION_INPUT;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_direction - callback for get output pin direction
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @direction: holds output pin direction
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for getting direction of an output
>>pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ */
>>+static int
>>+ice_dpll_output_direction(const struct dpll_pin *pin, void *pin_priv,
>>+			  const struct dpll_device *dpll, void *dpll_priv,
>>+			  enum dpll_pin_direction *direction,
>>+			  struct netlink_ext_ack *extack)
>>+{
>>+	*direction =3D DPLL_PIN_DIRECTION_OUTPUT;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_rclk_state_on_pin_set - set a state on rclk pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @parent_pin: pin parent pointer
>>+ * @state: state to be set on pin
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback, set a state of a rclk pin on a parent pin
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int
>>+ice_dpll_rclk_state_on_pin_set(const struct dpll_pin *pin, void
>>*pin_priv,
>>+			       const struct dpll_pin *parent_pin,
>>+			       void *parent_pin_priv,
>>+			       enum dpll_pin_state state,
>>+			       struct netlink_ext_ack *extack)
>>+{
>>+	bool enable =3D state =3D=3D DPLL_PIN_STATE_CONNECTED ? true : false;
>
>You have an odd pattern of this assing. Please avoid "? true : false"
>in the whole patch.
>

Fixed.

>
>>+	struct ice_dpll_pin *p =3D pin_priv, *parent =3D parent_pin_priv;
>>+	struct ice_pf *pf =3D p->pf;
>>+	int ret =3D -EINVAL;
>
>Also you have an odd patter of initializing "ret" variable and assign
>value to it 2 lines below. Please avoid it.
>

Fixed.

>
>>+	u32 hw_idx;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	hw_idx =3D parent->idx - pf->dplls.base_rclk_idx;
>>+	if (hw_idx >=3D pf->dplls.num_inputs)
>>+		goto unlock;
>>+
>>+	if ((enable && p->state[hw_idx] =3D=3D DPLL_PIN_STATE_CONNECTED) ||
>>+	    (!enable && p->state[hw_idx] =3D=3D DPLL_PIN_STATE_DISCONNECTED)) {
>>+		ret =3D -EINVAL;
>
>Extack.
>

Fixed.

>
>>+		goto unlock;
>>+	}
>>+	ret =3D ice_aq_set_phy_rec_clk_out(&pf->hw, hw_idx, enable,
>>+					 &p->freq);
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"%s: parent:%p, pin:%p, pf:%p hw_idx:%u enable:%d ret:%d\n",
>>+		__func__, parent_pin, pin, pf, hw_idx, enable, ret);
>
>What is this good for? Again, lots of debug messages like this in the
>whole patch. Do you need it, for what? If not, remove please.
>

Removed most of them.

>
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_rclk_state_on_pin_get - get a state of rclk pin
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @parent_pin: pin parent pointer
>>+ * @state: on success holds pin state on parent pin
>>+ * @extack: error reporting
>>+ *
>>+ * dpll subsystem callback, get a state of a recovered clock pin.
>>+ *
>>+ * Context: Acquires pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int
>>+ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin, void
>>*pin_priv,
>>+			       const struct dpll_pin *parent_pin,
>>+			       void *parent_pin_priv,
>>+			       enum dpll_pin_state *state,
>>+			       struct netlink_ext_ack *extack)
>>+{
>>+	struct ice_dpll_pin *p =3D pin_priv, *parent =3D parent_pin_priv;
>>+	struct ice_pf *pf =3D p->pf;
>>+	int ret =3D -EFAULT;
>>+	u32 hw_idx;
>>+
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret)
>>+		return ret;
>>+	hw_idx =3D parent->idx - pf->dplls.base_rclk_idx;
>>+	if (hw_idx >=3D pf->dplls.num_inputs)
>>+		goto unlock;
>>+
>>+	ret =3D ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_RCLK_INPUT);
>>+	if (ret)
>>+		goto unlock;
>>+
>>+	*state =3D p->state[hw_idx];
>>+	ret =3D 0;
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"%s: parent:%p, pin:%p, pf:%p hw_idx:%u state:%u ret:%d\n",
>>+		__func__, parent_pin, pin, pf, hw_idx, *state, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+static const struct dpll_pin_ops ice_dpll_rclk_ops =3D {
>>+	.state_on_pin_set =3D ice_dpll_rclk_state_on_pin_set,
>>+	.state_on_pin_get =3D ice_dpll_rclk_state_on_pin_get,
>>+	.direction_get =3D ice_dpll_input_direction,
>>+};
>>+
>>+static const struct dpll_pin_ops ice_dpll_input_ops =3D {
>>+	.frequency_get =3D ice_dpll_input_frequency_get,
>>+	.frequency_set =3D ice_dpll_input_frequency_set,
>>+	.state_on_dpll_get =3D ice_dpll_input_state_get,
>>+	.state_on_dpll_set =3D ice_dpll_input_state_set,
>>+	.prio_get =3D ice_dpll_input_prio_get,
>>+	.prio_set =3D ice_dpll_input_prio_set,
>>+	.direction_get =3D ice_dpll_input_direction,
>>+};
>>+
>>+static const struct dpll_pin_ops ice_dpll_output_ops =3D {
>>+	.frequency_get =3D ice_dpll_output_frequency_get,
>>+	.frequency_set =3D ice_dpll_output_frequency_set,
>>+	.state_on_dpll_get =3D ice_dpll_output_state_get,
>>+	.state_on_dpll_set =3D ice_dpll_output_state_set,
>>+	.direction_get =3D ice_dpll_output_direction,
>>+};
>>+
>>+static const struct dpll_device_ops ice_dpll_ops =3D {
>>+	.lock_status_get =3D ice_dpll_lock_status_get,
>>+	.mode_get =3D ice_dpll_mode_get,
>>+	.mode_supported =3D ice_dpll_mode_supported,
>>+};
>>+
>>+/**
>>+ * ice_dpll_deinit_info - release memory allocated for pins info
>>+ * @pf: board private structure
>>+ *
>>+ * Release memory allocated for pins by ice_dpll_init_info function.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void ice_dpll_deinit_info(struct ice_pf *pf)
>>+{
>>+	kfree(pf->dplls.inputs);
>>+	pf->dplls.inputs =3D NULL;
>>+	kfree(pf->dplls.outputs);
>>+	pf->dplls.outputs =3D NULL;
>>+	kfree(pf->dplls.eec.input_prio);
>>+	pf->dplls.eec.input_prio =3D NULL;
>>+	kfree(pf->dplls.pps.input_prio);
>>+	pf->dplls.pps.input_prio =3D NULL;
>
>Why you NULL the pointers? Do you use them later on? If not, please
>drop it, it's confusing.
>

Fixed.

>
>
>>+}
>>+
>>+/**
>>+ * ice_dpll_deinit_rclk_pin - release rclk pin resources
>>+ * @pf: board private structure
>>+ *
>>+ * Deregister rclk pin from parent pins and release resources in dpll
>>subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void ice_dpll_deinit_rclk_pin(struct ice_pf *pf)
>>+{
>>+	struct ice_dpll_pin *rclk =3D &pf->dplls.rclk;
>>+	struct ice_vsi *vsi =3D ice_get_main_vsi(pf);
>>+	struct dpll_pin *parent;
>>+	int i;
>>+
>>+	for (i =3D 0; i < rclk->num_parents; i++) {
>>+		parent =3D pf->dplls.inputs[rclk->parent_idx[i]].pin;
>>+		if (!parent)
>>+			continue;
>>+		if (!IS_ERR_OR_NULL(rclk->pin))
>>+			dpll_pin_on_pin_unregister(parent, rclk->pin,
>>+						   &ice_dpll_rclk_ops, rclk);
>>+	}
>>+	if (WARN_ON_ONCE(!vsi || !vsi->netdev))
>>+		return;
>>+	netdev_dpll_pin_clear(vsi->netdev);
>>+	dpll_pin_put(rclk->pin);
>>+	rclk->pin =3D NULL;
>
>Why you need to NULL it? If don't, please drop to avoid confusions.
>Same goes to the rest of the NULLing occurances in deinit() functions.
>

Fixed.

>
>>+}
>>+
>>+/**
>>+ * ice_dpll_unregister_pins - unregister pins from a dpll
>>+ * @dpll: dpll device pointer
>>+ * @pins: pointer to pins array
>>+ * @ops: callback ops registered with the pins
>>+ * @count: number of pins
>>+ *
>>+ * Unregister pins of a given array of pins from given dpll device
>>registered in
>>+ * dpll subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void
>>+ice_dpll_unregister_pins(struct dpll_device *dpll, struct ice_dpll_pin
>>*pins,
>>+			 const struct dpll_pin_ops *ops, int count)
>>+{
>>+	struct ice_dpll_pin *p;
>>+	int i;
>>+
>>+	for (i =3D 0; i < count; i++) {
>>+		p =3D &pins[i];
>>+		if (p && !IS_ERR_OR_NULL(p->pin))
>
>How can the p be NULL? I don't think it can.
>
>Please void the whole check here.
>Do the error path rollback in init() function properly.
>

Fixed.

>
>>+			dpll_pin_unregister(dpll, p->pin, ops, p);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_release_pins - release pins resources from dpll subsystem
>>+ * @pf: board private structure
>>+ * @pins: pointer to pins array
>>+ * @count: number of pins
>>+ *
>>+ * Release resources of given pins array in the dpll subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void ice_dpll_release_pins(struct ice_dpll_pin *pins, int count)
>>+{
>>+	struct ice_dpll_pin *p;
>>+	int i;
>>+
>>+	for (i =3D 0; i < count; i++) {
>>+		p =3D &pins[i];
>>+		if (p && !IS_ERR_OR_NULL(p->pin)) {
>
>Same here.
>
>Please void the whole check here.
>Do the error path rollback in init() function properly.
>

Fixed.

>
>>+			dpll_pin_put(p->pin);
>>+			p->pin =3D NULL;
>>+		}
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_get_pins - get pins from dpll subsystem
>>+ * @pf: board private structure
>>+ * @pins: pointer to pins array
>>+ * @start_idx: get starts from this pin idx value
>>+ * @count: number of pins
>>+ * @clock_id: clock_id of dpll device
>>+ *
>>+ * Get pins - allocate - in dpll subsystem, store them in pin field of
>>given
>>+ * pins array.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - allocation failure reason
>>+ */
>>+static int
>>+ice_dpll_get_pins(struct ice_pf *pf, struct ice_dpll_pin *pins,
>>+		  int start_idx, int count, u64 clock_id)
>>+{
>>+	int i, ret;
>>+
>>+	for (i =3D 0; i < count; i++) {
>>+		pins[i].pin =3D dpll_pin_get(clock_id, i + start_idx,
>>THIS_MODULE,
>>+					   &pins[i].prop);
>>+		if (IS_ERR(pins[i].pin)) {
>>+			ret =3D PTR_ERR(pins[i].pin);
>>+			goto release_pins;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+
>>+release_pins:
>>+	ice_dpll_release_pins(pins, i);
>
>
>Please call dpll_pin_put() in a loop here.
>

Fixed.

>
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_register_pins - register pins with a dpll
>>+ * @dpll: dpll pointer to register pins with
>>+ * @pins: pointer to pins array
>>+ * @ops: callback ops registered with the pins
>>+ * @count: number of pins
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Register pins of a given array with given dpll in dpll subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - registration failure reason
>>+ */
>>+static int
>>+ice_dpll_register_pins(struct dpll_device *dpll, struct ice_dpll_pin
>>*pins,
>>+		       const struct dpll_pin_ops *ops, int count)
>>+{
>>+	int ret, i;
>>+
>>+	for (i =3D 0; i < count; i++) {
>>+		ret =3D dpll_pin_register(dpll, pins[i].pin, ops, &pins[i]);
>>+		if (ret)
>>+			goto unregister_pins;
>>+	}
>>+
>>+	return 0;
>>+
>>+unregister_pins:
>>+	ice_dpll_unregister_pins(dpll, pins, ops, i);
>
>Please call dpll_pin_unregister() in a loop here.
>

Fixed.

>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_direct_pins - initialize direct pins
>>+ * @dpll: dpll pointer to register pins with
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ * @pins: pointer to pins array
>>+ * @start_idx: on which index shall allocation start in dpll subsystem
>>+ * @count: number of pins
>>+ * @ops: callback ops registered with the pins
>>+ * @first: dpll device pointer
>>+ * @second: dpll device pointer
>>+ *
>>+ * Allocate directly connected pins of a given array in dpll subsystem.
>>+ * If cgu is owned register allocated pins with given dplls.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - registration failure reason
>>+ */
>>+static int
>>+ice_dpll_init_direct_pins(struct ice_pf *pf, bool cgu,
>>+			  struct ice_dpll_pin *pins, int start_idx, int count,
>>+			  const struct dpll_pin_ops *ops,
>>+			  struct dpll_device *first, struct dpll_device *second)
>>+{
>>+	int ret;
>>+
>>+	ret =3D ice_dpll_get_pins(pf, pins, start_idx, count, pf-
>>dplls.clock_id);
>>+	if (ret)
>>+		return ret;
>>+	if (cgu) {
>>+		ret =3D ice_dpll_register_pins(first, pins, ops, count);
>>+		if (ret)
>>+			goto release_pins;
>>+		ret =3D ice_dpll_register_pins(second, pins, ops, count);
>>+		if (ret)
>>+			goto unregister_first;
>>+	}
>>+
>>+	return 0;
>>+
>>+unregister_first:
>>+	ice_dpll_unregister_pins(first, pins, ops, count);
>>+release_pins:
>>+	ice_dpll_release_pins(pins, count);
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_deinit_direct_pins - deinitialize direct pins
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ * @pins: pointer to pins array
>>+ * @count: number of pins
>>+ * @ops: callback ops registered with the pins
>>+ * @first: dpll device pointer
>>+ * @second: dpll device pointer
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * If cgu is owned unregister pins from given dplls.
>>+ * Release pins resources to the dpll subsystem.
>>+ */
>>+static void
>>+ice_dpll_deinit_direct_pins(bool cgu, struct ice_dpll_pin *pins, int cou=
nt,
>>+			    const struct dpll_pin_ops *ops,
>>+			    struct dpll_device *first,
>>+			    struct dpll_device *second)
>>+{
>>+	if (cgu) {
>>+		ice_dpll_unregister_pins(first, pins, ops, count);
>>+		ice_dpll_unregister_pins(second, pins, ops, count);
>>+	}
>>+	ice_dpll_release_pins(pins, count);
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_rclk_pins - initialize recovered clock pin
>>+ * @dpll: dpll pointer to register pins with
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ * @pins: pointer to pins array
>>+ * @start_idx: on which index shall allocation start in dpll subsystem
>>+ * @count: number of pins
>>+ * @ops: callback ops registered with the pins
>>+ *
>>+ * Allocate resource for recovered clock pin in dpll subsystem. Register=
 the
>>+ * pin with the parents it has in the info. Register pin with the pf's m=
ain
>>vsi
>>+ * netdev.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - registration failure reason
>>+ */
>>+static int
>>+ice_dpll_init_rclk_pins(struct ice_pf *pf, struct ice_dpll_pin *pin,
>>+			int start_idx, const struct dpll_pin_ops *ops)
>
>It is a good practise to have the init/cleanup functions of the same
>thing one behind the another. Could you please reorder the code to
>achieve that?
>

Sure, fixed.

>
>>+{
>>+	struct ice_vsi *vsi =3D ice_get_main_vsi(pf);
>>+	struct dpll_pin *parent;
>>+	int ret, i;
>>+
>>+	ret =3D ice_dpll_get_pins(pf, pin, start_idx, ICE_DPLL_RCLK_NUM_PER_PF,
>>+				pf->dplls.clock_id);
>>+	if (ret)
>>+		return ret;
>>+	for (i =3D 0; i < pf->dplls.rclk.num_parents; i++) {
>>+		parent =3D pf->dplls.inputs[pf->dplls.rclk.parent_idx[i]].pin;
>>+		if (!parent) {
>>+			ret =3D -ENODEV;
>>+			goto unregister_pins;
>>+		}
>>+		ret =3D dpll_pin_on_pin_register(parent, pf->dplls.rclk.pin,
>>+					       ops, &pf->dplls.rclk);
>>+		if (ret)
>>+			goto unregister_pins;
>>+	}
>>+	if (WARN_ON((!vsi || !vsi->netdev)))
>>+		return -EINVAL;
>>+	netdev_dpll_pin_set(vsi->netdev, pf->dplls.rclk.pin);
>>+
>>+	return 0;
>>+
>>+unregister_pins:
>>+	while (i) {
>>+		parent =3D pf->dplls.inputs[pf->dplls.rclk.parent_idx[--i]].pin;
>>+		dpll_pin_on_pin_unregister(parent, pf->dplls.rclk.pin,
>>+					   &ice_dpll_rclk_ops, &pf->dplls.rclk);
>>+	}
>>+	ice_dpll_release_pins(pin, ICE_DPLL_RCLK_NUM_PER_PF);
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_pins - init pins and register pins with a dplls
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Initialize directly connected pf's pins within pf's dplls in a Linux =
dpll
>>+ * subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - initialization failure reason
>>+ */
>>+static int ice_dpll_init_pins(struct ice_pf *pf, bool cgu)
>>+{
>>+	u32 rclk_idx;
>>+	int ret;
>>+
>>+	ret =3D ice_dpll_init_direct_pins(pf, cgu, pf->dplls.inputs, 0,
>>+					pf->dplls.num_inputs,
>>+					&ice_dpll_input_ops,
>>+					pf->dplls.eec.dpll, pf->dplls.pps.dpll);
>>+	if (ret)
>>+		return ret;
>>+	if (cgu) {
>>+		ret =3D ice_dpll_init_direct_pins(pf, cgu, pf->dplls.outputs,
>>+						pf->dplls.num_inputs,
>>+						pf->dplls.num_outputs,
>>+						&ice_dpll_output_ops,
>>+						pf->dplls.eec.dpll,
>>+						pf->dplls.pps.dpll);
>>+		if (ret)
>>+			goto deinit_inputs;
>>+	}
>>+	rclk_idx =3D pf->dplls.num_inputs + pf->dplls.num_outputs + pf-
>>hw.pf_id;
>>+	ret =3D ice_dpll_init_rclk_pins(pf, &pf->dplls.rclk, rclk_idx,
>>+				      &ice_dpll_rclk_ops);
>>+	if (ret)
>>+		goto deinit_outputs;
>>+
>>+	return 0;
>>+deinit_outputs:
>>+	ice_dpll_deinit_direct_pins(cgu, pf->dplls.outputs,
>>+				    pf->dplls.num_outputs,
>>+				    &ice_dpll_output_ops, pf->dplls.pps.dpll,
>>+				    pf->dplls.eec.dpll);
>>+deinit_inputs:
>>+	ice_dpll_deinit_direct_pins(cgu, pf->dplls.inputs, pf-
>>dplls.num_inputs,
>>+				    &ice_dpll_input_ops, pf->dplls.pps.dpll,
>>+				    pf->dplls.eec.dpll);
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_generate_clock_id - generates unique clock_id for registering
>>dpll.
>>+ * @pf: board private structure
>>+ *
>>+ * Generates unique (per board) clock_id for allocation and search of
>>dpll
>>+ * devices in Linux dpll subsystem.
>>+ *
>>+ * Return: generated clock id for the board
>>+ */
>>+static u64 ice_generate_clock_id(struct ice_pf *pf)
>>+{
>>+	return pci_get_dsn(pf->pdev);
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_dpll - initialize dpll device in dpll subsystem
>>+ * @pf: board private structure
>>+ * @d: dpll to be initialized
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ * @type: type of dpll being initialized
>>+ *
>>+ * Allocate dpll instance for this board in dpll subsystem, if cgu is
>>controlled
>>+ * by this NIC, register dpll with the callback ops.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - initialization failure reason
>>+ */
>>+static int
>>+ice_dpll_init_dpll(struct ice_pf *pf, struct ice_dpll *d, bool cgu,
>>+		   enum dpll_type type)
>>+{
>>+	u64 clock_id =3D pf->dplls.clock_id;
>>+	int ret;
>>+
>>+	d->dpll =3D dpll_device_get(clock_id, d->dpll_idx, THIS_MODULE);
>>+	if (IS_ERR(d->dpll)) {
>>+		ret =3D PTR_ERR(d->dpll);
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"dpll_device_get failed (%p) err=3D%d\n", d, ret);
>>+		return ret;
>>+	}
>>+	d->pf =3D pf;
>>+	if (cgu) {
>>+		ret =3D dpll_device_register(d->dpll, type, &ice_dpll_ops, d);
>>+		if (ret) {
>>+			dpll_device_put(d->dpll);
>>+			return ret;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_update_state - update dpll state
>>+ * @pf: pf private structure
>>+ * @d: pointer to queried dpll device
>>+ *
>>+ * Poll current state of dpll from hw and update ice_dpll struct.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - AQ failure
>>+ */
>>+static int
>>+ice_dpll_update_state(struct ice_pf *pf, struct ice_dpll *d, bool init)
>>+{
>>+	struct ice_dpll_pin *p;
>>+	int ret;
>>+
>>+	ret =3D ice_get_cgu_state(&pf->hw, d->dpll_idx, d->prev_dpll_state,
>>+				&d->input_idx, &d->ref_state, &d->eec_mode,
>>+				&d->phase_offset, &d->dpll_state);
>>+
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"update dpll=3D%d, prev_src_idx:%u, src_idx:%u, state:%d,
>>prev:%d\n",
>>+		d->dpll_idx, d->prev_input_idx, d->input_idx,
>>+		d->dpll_state, d->prev_dpll_state);
>>+	if (ret) {
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"update dpll=3D%d state failed, ret=3D%d %s\n",
>>+			d->dpll_idx, ret,
>>+			ice_aq_str(pf->hw.adminq.sq_last_status));
>>+		return ret;
>>+	}
>>+	if (init) {
>>+		if (d->dpll_state =3D=3D ICE_CGU_STATE_LOCKED &&
>>+		    d->dpll_state =3D=3D ICE_CGU_STATE_LOCKED_HO_ACQ)
>>+			d->active_input =3D pf->dplls.inputs[d->input_idx].pin;
>>+		p =3D &pf->dplls.inputs[d->input_idx];
>>+		return ice_dpll_pin_state_update(pf, p,
>>+						 ICE_DPLL_PIN_TYPE_INPUT);
>>+	}
>>+	if (d->dpll_state =3D=3D ICE_CGU_STATE_HOLDOVER ||
>>+	    d->dpll_state =3D=3D ICE_CGU_STATE_FREERUN) {
>>+		d->active_input =3D NULL;
>>+		p =3D &pf->dplls.inputs[d->input_idx];
>>+		d->prev_input_idx =3D ICE_DPLL_PIN_IDX_INVALID;
>>+		d->input_idx =3D ICE_DPLL_PIN_IDX_INVALID;
>>+		ret =3D ice_dpll_pin_state_update(pf, p,
>>+						ICE_DPLL_PIN_TYPE_INPUT);
>>+	} else if (d->input_idx !=3D d->prev_input_idx) {
>>+		p =3D &pf->dplls.inputs[d->prev_input_idx];
>>+		ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_INPUT);
>>+		p =3D &pf->dplls.inputs[d->input_idx];
>>+		d->active_input =3D p->pin;
>>+		ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_INPUT);
>>+		d->prev_input_idx =3D d->input_idx;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_notify_changes - notify dpll subsystem about changes
>>+ * @d: pointer do dpll
>>+ *
>>+ * Once change detected appropriate event is submitted to the dpll
>>subsystem.
>>+ */
>>+static void ice_dpll_notify_changes(struct ice_dpll *d)
>>+{
>>+	if (d->prev_dpll_state !=3D d->dpll_state) {
>>+		d->prev_dpll_state =3D d->dpll_state;
>>+		dpll_device_change_ntf(d->dpll);
>>+	}
>>+	if (d->prev_input !=3D d->active_input) {
>>+		if (d->prev_input)
>>+			dpll_pin_change_ntf(d->prev_input);
>>+		d->prev_input =3D d->active_input;
>>+		if (d->active_input)
>>+			dpll_pin_change_ntf(d->active_input);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_periodic_work - DPLLs periodic worker
>>+ * @work: pointer to kthread_work structure
>>+ *
>>+ * DPLLs periodic worker is responsible for polling state of dpll.
>>+ * Context: Holds pf->dplls.lock
>>+ */
>>+static void ice_dpll_periodic_work(struct kthread_work *work)
>>+{
>>+	struct ice_dplls *d =3D container_of(work, struct ice_dplls,
>>work.work);
>>+	struct ice_pf *pf =3D container_of(d, struct ice_pf, dplls);
>>+	struct ice_dpll *de =3D &pf->dplls.eec;
>>+	struct ice_dpll *dp =3D &pf->dplls.pps;
>>+	int ret =3D 0;
>>+
>>+	if (!test_bit(ICE_FLAG_DPLL, pf->flags))
>
>How exactly could this happen? I don't think it can. Drop it.
>

I will change a bit here, ice_dpll_cb_lock returns an error
if that flag was already down, so will use it instead.

>
>>+		return;
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret) {
>>+		d->lock_err_num++;
>
>Drop this struct field, you don't use it anywhere.
>

Sure, fixed.

>
>>+		goto resched;
>>+	}
>>+	ret =3D ice_dpll_update_state(pf, de, false);
>>+	if (!ret)
>>+		ret =3D ice_dpll_update_state(pf, dp, false);
>>+	if (ret) {
>>+		d->cgu_state_acq_err_num++;
>>+		/* stop rescheduling this worker */
>>+		if (d->cgu_state_acq_err_num >
>>+		    ICE_CGU_STATE_ACQ_ERR_THRESHOLD) {
>>+			dev_err(ice_pf_to_dev(pf),
>>+				"EEC/PPS DPLLs periodic work disabled\n");
>>+			return;
>>+		}
>>+	}
>>+	ice_dpll_cb_unlock(pf);
>>+	ice_dpll_notify_changes(de);
>>+	ice_dpll_notify_changes(dp);
>>+resched:
>>+	/* Run twice a second or reschedule if update failed */
>>+	kthread_queue_delayed_work(d->kworker, &d->work,
>>+				   ret ? msecs_to_jiffies(10) :
>>+				   msecs_to_jiffies(500));
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_worker - Initialize DPLLs periodic worker
>>+ * @pf: board private structure
>>+ *
>>+ * Create and start DPLLs periodic worker.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - create worker failure
>>+ */
>>+static int ice_dpll_init_worker(struct ice_pf *pf)
>>+{
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	struct kthread_worker *kworker;
>>+
>>+	ice_dpll_update_state(pf, &d->eec, true);
>>+	ice_dpll_update_state(pf, &d->pps, true);
>>+	kthread_init_delayed_work(&d->work, ice_dpll_periodic_work);
>>+	kworker =3D kthread_create_worker(0, "ice-dplls-%s",
>>+					dev_name(ice_pf_to_dev(pf)));
>>+	if (IS_ERR(kworker))
>>+		return PTR_ERR(kworker);
>>+	d->kworker =3D kworker;
>>+	d->cgu_state_acq_err_num =3D 0;
>>+	kthread_queue_delayed_work(d->kworker, &d->work, 0);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_deinit_pins - deinitialize direct pins
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is controlled by this pf
>>+ *
>>+ * If cgu is owned unregister directly connected pins from the dplls.
>>+ * Release resources of directly connected pins from the dpll subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void ice_dpll_deinit_pins(struct ice_pf *pf, bool cgu)
>>+{
>>+	struct ice_dpll_pin *outputs =3D pf->dplls.outputs;
>>+	struct ice_dpll_pin *inputs =3D pf->dplls.inputs;
>>+	int num_outputs =3D pf->dplls.num_outputs;
>>+	int num_inputs =3D pf->dplls.num_inputs;
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	struct ice_dpll *de =3D &d->eec;
>>+	struct ice_dpll *dp =3D &d->pps;
>>+
>>+	ice_dpll_deinit_rclk_pin(pf);
>>+	if (cgu) {
>>+		ice_dpll_unregister_pins(dp->dpll, inputs, &ice_dpll_input_ops,
>>+					 num_inputs);
>>+		ice_dpll_unregister_pins(de->dpll, inputs, &ice_dpll_input_ops,
>>+					 num_inputs);
>>+	}
>>+	ice_dpll_release_pins(inputs, num_inputs);
>>+	if (cgu) {
>>+		ice_dpll_unregister_pins(dp->dpll, outputs,
>>+					 &ice_dpll_output_ops, num_outputs);
>>+		ice_dpll_unregister_pins(de->dpll, outputs,
>>+					 &ice_dpll_output_ops, num_outputs);
>>+		ice_dpll_release_pins(outputs, num_outputs);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_deinit_dpll - deinitialize dpll device
>>+ * @pf: board private structure
>>+ *
>>+ * If cgu is owned unregister the dpll from dpll subsystem.
>>+ * Release resources of dpll device from dpll subsystem.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void
>>+ice_dpll_deinit_dpll(struct ice_pf *pf, struct ice_dpll *d, bool cgu)
>>+{
>>+	if (!IS_ERR(d->dpll)) {
>>+		if (cgu)
>>+			dpll_device_unregister(d->dpll, &ice_dpll_ops, d);
>>+		dpll_device_put(d->dpll);
>>+		dev_dbg(ice_pf_to_dev(pf), "(%p) dpll removed\n", d);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_deinit_worker - deinitialize dpll kworker
>>+ * @pf: board private structure
>>+ *
>>+ * Stop dpll's kworker, release it's resources.
>>+ *
>>+ * Context: Called under pf->dplls.lock
>>+ */
>>+static void ice_dpll_deinit_worker(struct ice_pf *pf)
>>+{
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+
>>+	kthread_cancel_delayed_work_sync(&d->work);
>>+	if (!IS_ERR_OR_NULL(d->kworker)) {
>>+		kthread_destroy_worker(d->kworker);
>>+		d->kworker =3D NULL;
>>+		dev_dbg(ice_pf_to_dev(pf), "DPLLs worker removed\n");
>
>What is this msg good for?
>

Will remove it.

>
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_deinit - Disable the driver/HW support for dpll subsystem
>>+ * the dpll device.
>>+ * @pf: board private structure
>>+ *
>>+ * Handles the cleanup work required after dpll initialization,freeing
>>resources
>>+ * and unregistering the dpll, pin and all resources used for handling
>>them.
>>+ *
>>+ * Context: Function holds pf->dplls.lock mutex.
>>+ */
>>+void ice_dpll_deinit(struct ice_pf *pf)
>>+{
>>+	bool cgu =3D ice_is_feature_supported(pf, ICE_F_CGU);
>>+
>>+	if (test_bit(ICE_FLAG_DPLL, pf->flags)) {
>
>How about avoiding the indent are rather do:
>	if (!test_bit(ICE_FLAG_DPLL, pf->flags))
>		return;
>
>?
>

Sure, fixed.

>>+		mutex_lock(&pf->dplls.lock);
>
>Related to my question in ice_dpll_init(), why do you need to lock the
>mutex
>here?

Because before deinit takes place on driver unload the user can still ask
for the info from the dpll subsystem or kworker can try to alter the status=
.

>
>
>>+		ice_dpll_deinit_pins(pf, cgu);
>>+		ice_dpll_deinit_info(pf);
>>+		ice_dpll_deinit_dpll(pf, &pf->dplls.pps, cgu);
>>+		ice_dpll_deinit_dpll(pf, &pf->dplls.eec, cgu);
>
>Please reorder to match error path in ice_dpll_init()
>

Fixed.

>>+		if (cgu)
>
>In ice_dpll_init() you call this "cgu_present". Please be consistent in
>naming.
>

Fixed.

>
>>+			ice_dpll_deinit_worker(pf);
>>+		clear_bit(ICE_FLAG_DPLL, pf->flags);
>>+		mutex_unlock(&pf->dplls.lock);
>>+		mutex_destroy(&pf->dplls.lock);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_info_direct_pins - initializes direct pins info
>>+ * @pf: board private structure
>>+ * @pin_type: type of pins being initialized
>>+ *
>>+ * Init information for directly connected pins, cache them in pf's pins
>>+ * structures.
>>+ *
>>+ * Context: Function initializes and holds pf->dplls.lock mutex.
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure reason
>>+ */
>>+static int
>>+ice_dpll_init_info_direct_pins(struct ice_pf *pf,
>>+			       enum ice_dpll_pin_type pin_type)
>>+{
>>+	struct ice_dpll *de =3D &pf->dplls.eec, *dp =3D &pf->dplls.pps;
>>+	int num_pins, i, ret =3D -EINVAL;
>>+	struct ice_hw *hw =3D &pf->hw;
>>+	struct ice_dpll_pin *pins;
>>+	u8 freq_supp_num;
>>+	bool input;
>>+
>>+	switch (pin_type) {
>>+	case ICE_DPLL_PIN_TYPE_INPUT:
>>+		pins =3D pf->dplls.inputs;
>>+		num_pins =3D pf->dplls.num_inputs;
>>+		input =3D true;
>>+		break;
>>+	case ICE_DPLL_PIN_TYPE_OUTPUT:
>>+		pins =3D pf->dplls.outputs;
>>+		num_pins =3D pf->dplls.num_outputs;
>>+		input =3D false;
>>+		break;
>>+	default:
>>+		return ret;
>>+	}
>>+
>>+	for (i =3D 0; i < num_pins; i++) {
>>+		pins[i].idx =3D i;
>>+		pins[i].prop.board_label =3D ice_cgu_get_pin_name(hw, i, input);
>>+		pins[i].prop.type =3D ice_cgu_get_pin_type(hw, i, input);
>>+		if (input) {
>>+			ret =3D ice_aq_get_cgu_ref_prio(hw, de->dpll_idx, i,
>>+						      &de->input_prio[i]);
>>+			if (ret)
>>+				return ret;
>>+			ret =3D ice_aq_get_cgu_ref_prio(hw, dp->dpll_idx, i,
>>+						      &dp->input_prio[i]);
>>+			if (ret)
>>+				return ret;
>>+			pins[i].prop.capabilities |=3D
>>+				DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE;
>>+		}
>>+		pins[i].prop.capabilities |=3D DPLL_PIN_CAPS_STATE_CAN_CHANGE;
>>+		ret =3D ice_dpll_pin_state_update(pf, &pins[i], pin_type);
>>+		if (ret)
>>+			return ret;
>>+		pins[i].prop.freq_supported =3D
>>+			ice_cgu_get_pin_freq_supp(hw, i, input, &freq_supp_num);
>>+		pins[i].prop.freq_supported_num =3D freq_supp_num;
>>+		pins[i].pf =3D pf;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_rclk_pin - initializes rclk pin information
>>+ * @pf: board private structure
>>+ * @pin_type: type of pins being initialized
>>+ *
>>+ * Init information for rclk pin, cache them in pf->dplls.rclk.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure reason
>>+ */
>>+static int ice_dpll_init_rclk_pin(struct ice_pf *pf)
>>+{
>>+	struct ice_dpll_pin *pin =3D &pf->dplls.rclk;
>>+	struct device *dev =3D ice_pf_to_dev(pf);
>>+
>>+	pin->prop.board_label =3D dev_name(dev);
>
>What??? Must be some sort of joke, correct?
>"board_label" should be an actual writing on a board. For syncE, I don't
>think it makes sense to fill any label. The connection to the netdev
>should be enough. That is what I do in mlx5.
>
>Please drop this.
>

No, we want a label, as this is recovered clock, will change it to
package_label but the name will stay for now, this is much more meaningful
then i.e. "phy0" or "RCLK".

>
>
>>+	pin->prop.type =3D DPLL_PIN_TYPE_SYNCE_ETH_PORT;
>>+	pin->prop.capabilities |=3D DPLL_PIN_CAPS_STATE_CAN_CHANGE;
>>+	pin->pf =3D pf;
>>+
>>+	return ice_dpll_pin_state_update(pf, pin,
>>+					 ICE_DPLL_PIN_TYPE_RCLK_INPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_pins_info - init pins info wrapper
>>+ * @pf: board private structure
>>+ * @pin_type: type of pins being initialized
>>+ *
>>+ * Wraps functions for pin initialization.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure reason
>>+ */
>>+static int
>>+ice_dpll_init_pins_info(struct ice_pf *pf, enum ice_dpll_pin_type
>>pin_type)
>>+{
>>+	switch (pin_type) {
>>+	case ICE_DPLL_PIN_TYPE_INPUT:
>>+	case ICE_DPLL_PIN_TYPE_OUTPUT:
>>+		return ice_dpll_init_info_direct_pins(pf, pin_type);
>>+	case ICE_DPLL_PIN_TYPE_RCLK_INPUT:
>>+		return ice_dpll_init_rclk_pin(pf);
>>+	default:
>>+		return -EINVAL;
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_info - prepare pf's dpll information structure
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Acquire (from HW) and set basic dpll information (on pf->dplls
>>struct).
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure reason
>>+ */
>>+static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
>>+{
>>+	struct ice_aqc_get_cgu_abilities abilities;
>>+	struct ice_dpll *de =3D &pf->dplls.eec;
>>+	struct ice_dpll *dp =3D &pf->dplls.pps;
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	struct ice_hw *hw =3D &pf->hw;
>>+	int ret, alloc_size, i;
>>+
>>+	d->clock_id =3D ice_generate_clock_id(pf);
>>+	ret =3D ice_aq_get_cgu_abilities(hw, &abilities);
>>+	if (ret) {
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"err:%d %s failed to read cgu abilities\n",
>>+			ret, ice_aq_str(hw->adminq.sq_last_status));
>>+		return ret;
>>+	}
>>+
>>+	de->dpll_idx =3D abilities.eec_dpll_idx;
>>+	dp->dpll_idx =3D abilities.pps_dpll_idx;
>>+	d->num_inputs =3D abilities.num_inputs;
>>+	d->num_outputs =3D abilities.num_outputs;
>>+
>>+	alloc_size =3D sizeof(*d->inputs) * d->num_inputs;
>>+	d->inputs =3D kzalloc(alloc_size, GFP_KERNEL);
>>+	if (!d->inputs)
>>+		return -ENOMEM;
>>+
>>+	alloc_size =3D sizeof(*de->input_prio) * d->num_inputs;
>>+	de->input_prio =3D kzalloc(alloc_size, GFP_KERNEL);
>>+	if (!de->input_prio)
>>+		return -ENOMEM;
>>+
>>+	dp->input_prio =3D kzalloc(alloc_size, GFP_KERNEL);
>>+	if (!dp->input_prio)
>>+		return -ENOMEM;
>>+
>>+	ret =3D ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_INPUT);
>>+	if (ret)
>>+		goto deinit_info;
>>+
>>+	if (cgu) {
>>+		alloc_size =3D sizeof(*d->outputs) * d->num_outputs;
>>+		d->outputs =3D kzalloc(alloc_size, GFP_KERNEL);
>>+		if (!d->outputs)
>>+			goto deinit_info;
>>+
>>+		ret =3D ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_OUTPUT);
>>+		if (ret)
>>+			goto deinit_info;
>>+	}
>>+
>>+	ret =3D ice_get_cgu_rclk_pin_info(&pf->hw, &d->base_rclk_idx,
>>+					&pf->dplls.rclk.num_parents);
>>+	if (ret)
>>+		return ret;
>>+	for (i =3D 0; i < pf->dplls.rclk.num_parents; i++)
>>+		pf->dplls.rclk.parent_idx[i] =3D d->base_rclk_idx + i;
>>+	ret =3D ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_RCLK_INPUT);
>>+	if (ret)
>>+		return ret;
>>+
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"%s - success, inputs:%u, outputs:%u rclk-parents:%u\n",
>>+		__func__, d->num_inputs, d->num_outputs, d->rclk.num_parents);
>>+
>>+	return 0;
>>+
>>+deinit_info:
>>+	dev_err(ice_pf_to_dev(pf),
>>+		"%s - fail: d->inputs:%p, de->input_prio:%p, dp->input_prio:%p,
>>d->outputs:%p\n",
>>+		__func__, d->inputs, de->input_prio,
>>+		dp->input_prio, d->outputs);
>>+	ice_dpll_deinit_info(pf);
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_init - initialize support for dpll subsystem
>>+ * @pf: board private structure
>>+ *
>>+ * Set up the device dplls, register them and pins connected within Linu=
x
>>dpll
>>+ * subsystem. Allow userpsace to obtain state of DPLL and handling of
>>DPLL
>>+ * configuration requests.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure reason
>>+ */
>>+int ice_dpll_init(struct ice_pf *pf)
>>+{
>>+	bool cgu_present =3D ice_is_feature_supported(pf, ICE_F_CGU);
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	int err =3D 0;
>>+
>>+	mutex_init(&d->lock);
>>+	mutex_lock(&d->lock);
>
>Seeing pattern like this always triggers questions.
>Why exactly do you need to lock the mutex here?
>

Could do it few lines below before the dplls are inited,
but this would make error path confusing.

>
>>+	err =3D ice_dpll_init_info(pf, cgu_present);
>>+	if (err)
>>+		goto err_exit;
>>+	err =3D ice_dpll_init_dpll(pf, &pf->dplls.eec, cgu_present,
>>+				 DPLL_TYPE_EEC);
>>+	if (err)
>>+		goto deinit_info;
>>+	err =3D ice_dpll_init_dpll(pf, &pf->dplls.pps, cgu_present,
>>+				 DPLL_TYPE_PPS);
>>+	if (err)
>>+		goto deinit_eec;
>>+	err =3D ice_dpll_init_pins(pf, cgu_present);
>>+	if (err)
>>+		goto deinit_pps;
>>+	set_bit(ICE_FLAG_DPLL, pf->flags);
>>+	if (cgu_present) {
>>+		err =3D ice_dpll_init_worker(pf);
>>+		if (err)
>>+			goto deinit_pins;
>>+	}
>>+	mutex_unlock(&d->lock);
>>+	dev_info(ice_pf_to_dev(pf), "DPLLs init successful\n");
>
>What is this good for? Please avoid polluting dmesg and drop this.
>

Sure, removed.

>
>>+
>>+	return err;
>>+
>>+deinit_pins:
>>+	ice_dpll_deinit_pins(pf, cgu_present);
>>+deinit_pps:
>>+	ice_dpll_deinit_dpll(pf, &pf->dplls.pps, cgu_present);
>>+deinit_eec:
>>+	ice_dpll_deinit_dpll(pf, &pf->dplls.eec, cgu_present);
>>+deinit_info:
>>+	ice_dpll_deinit_info(pf);
>>+err_exit:
>>+	clear_bit(ICE_FLAG_DPLL, pf->flags);
>>+	mutex_unlock(&d->lock);
>>+	mutex_destroy(&d->lock);
>>+	dev_warn(ice_pf_to_dev(pf), "DPLLs init failure err:\n");
>
>You are missing the err. But why do you need the message?
>

To give a clue that something went wrong on dpll init.

>
>>+
>>+	return err;
>>+}
>>diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.h
>>b/drivers/net/ethernet/intel/ice/ice_dpll.h
>>new file mode 100644
>>index 000000000000..287892825deb
>>--- /dev/null
>>+++ b/drivers/net/ethernet/intel/ice/ice_dpll.h
>>@@ -0,0 +1,102 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/* Copyright (C) 2022, Intel Corporation. */
>>+
>>+#ifndef _ICE_DPLL_H_
>>+#define _ICE_DPLL_H_
>>+
>>+#include "ice.h"
>>+
>>+#define ICE_DPLL_PRIO_MAX	0xF
>>+#define ICE_DPLL_RCLK_NUM_MAX	4
>>+/** ice_dpll_pin - store info about pins
>>+ * @pin: dpll pin structure
>>+ * @pf: pointer to pf, which has registered the dpll_pin
>>+ * @flags: pin flags returned from HW
>>+ * @idx: ice pin private idx
>>+ * @state: state of a pin
>>+ * @type: type of a pin
>>+ * @freq_mask: mask of supported frequencies
>>+ * @freq: current frequency of a pin
>>+ * @caps: capabilities of a pin
>>+ * @name: pin name
>>+ */
>>+struct ice_dpll_pin {
>>+	struct dpll_pin *pin;
>>+	struct ice_pf *pf;
>>+	u8 idx;
>>+	u8 num_parents;
>>+	u8 parent_idx[ICE_DPLL_RCLK_NUM_MAX];
>>+	u8 flags[ICE_DPLL_RCLK_NUM_MAX];
>>+	u8 state[ICE_DPLL_RCLK_NUM_MAX];
>>+	struct dpll_pin_properties prop;
>>+	u32 freq;
>>+};
>>+
>>+/** ice_dpll - store info required for DPLL control
>>+ * @dpll: pointer to dpll dev
>>+ * @pf: pointer to pf, which has registered the dpll_device
>>+ * @dpll_idx: index of dpll on the NIC
>>+ * @input_idx: currently selected input index
>>+ * @prev_input_idx: previously selected input index
>>+ * @ref_state: state of dpll reference signals
>>+ * @eec_mode: eec_mode dpll is configured for
>>+ * @phase_offset: phase delay of a dpll
>>+ * @input_prio: priorities of each input
>>+ * @dpll_state: current dpll sync state
>>+ * @prev_dpll_state: last dpll sync state
>>+ * @active_input: pointer to active input pin
>>+ * @prev_input: pointer to previous active input pin
>>+ */
>>+struct ice_dpll {
>>+	struct dpll_device *dpll;
>>+	struct ice_pf *pf;
>>+	int dpll_idx;
>>+	u8 input_idx;
>>+	u8 prev_input_idx;
>>+	u8 ref_state;
>>+	u8 eec_mode;
>>+	s64 phase_offset;
>>+	u8 *input_prio;
>>+	enum ice_cgu_state dpll_state;
>>+	enum ice_cgu_state prev_dpll_state;
>>+	struct dpll_pin *active_input;
>>+	struct dpll_pin *prev_input;
>>+};
>>+
>>+/** ice_dplls - store info required for CCU (clock controlling unit)
>>+ * @kworker: periodic worker
>>+ * @work: periodic work
>>+ * @lock: locks access to configuration of a dpll
>>+ * @eec: pointer to EEC dpll dev
>>+ * @pps: pointer to PPS dpll dev
>>+ * @inputs: input pins pointer
>>+ * @outputs: output pins pointer
>>+ * @rclk: recovered pins pointer
>>+ * @num_inputs: number of input pins available on dpll
>>+ * @num_outputs: number of output pins available on dpll
>>+ * @cgu_state_acq_err_num: number of errors returned during periodic wor=
k
>>+ * @base_rclk_idx: idx of first pin used for clock revocery pins
>>+ * @clock_id: clock_id of dplls
>>+ */
>>+struct ice_dplls {
>>+	struct kthread_worker *kworker;
>>+	struct kthread_delayed_work work;
>>+	struct mutex lock;
>>+	struct ice_dpll eec;
>>+	struct ice_dpll pps;
>>+	struct ice_dpll_pin *inputs;
>>+	struct ice_dpll_pin *outputs;
>>+	struct ice_dpll_pin rclk;
>>+	u32 num_inputs;
>>+	u32 num_outputs;
>>+	int cgu_state_acq_err_num;
>>+	int lock_err_num;
>>+	u8 base_rclk_idx;
>>+	u64 clock_id;
>>+};
>>+
>>+int ice_dpll_init(struct ice_pf *pf);
>>+
>>+void ice_dpll_deinit(struct ice_pf *pf);
>>+
>>+#endif
>>diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
>>b/drivers/net/ethernet/intel/ice/ice_main.c
>>index 62e91512aeab..ba5f3bc9075a 100644
>>--- a/drivers/net/ethernet/intel/ice/ice_main.c
>>+++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>@@ -4595,6 +4595,10 @@ static void ice_init_features(struct ice_pf *pf)
>> 	if (ice_is_feature_supported(pf, ICE_F_GNSS))
>> 		ice_gnss_init(pf);
>>
>>+	if (ice_is_feature_supported(pf, ICE_F_CGU) ||
>>+	    ice_is_feature_supported(pf, ICE_F_PHY_RCLK))
>>+		ice_dpll_init(pf);
>
>Why do you have the function returning int when you don't check it here?
>

Will make it void.

Thank you!
Arkadiusz

>
>>+
>> 	/* Note: Flow director init failure is non-fatal to load */
>> 	if (ice_init_fdir(pf))
>> 		dev_err(dev, "could not initialize flow director\n");
>>@@ -4621,6 +4625,9 @@ static void ice_deinit_features(struct ice_pf *pf)
>> 		ice_gnss_exit(pf);
>> 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
>> 		ice_ptp_release(pf);
>>+	if (ice_is_feature_supported(pf, ICE_F_PHY_RCLK) ||
>>+	    ice_is_feature_supported(pf, ICE_F_CGU))
>>+		ice_dpll_deinit(pf);
>> }
>>
>> static void ice_init_wakeup(struct ice_pf *pf)
>>--
>>2.37.3
>>

