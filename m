Return-Path: <netdev+bounces-11885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E62735020
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:29:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 540111C20848
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64693C130;
	Mon, 19 Jun 2023 09:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5048ABE7A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:25:31 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8798B10C1
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687166707; x=1718702707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FR7kkvC9BFUa18dLqpkK3Wg0UP4uplpfo9vDnr+OXac=;
  b=K5rnI/0jOf9iOWI4xoHiRSthFbe6LrpTux7Ip3PGh91j4jCZpibDt6CV
   Z/0fZn5MKPBf/+4V7OSSHAzGeVWfHNykHTVAXuSExvrV4ozlLX5WNqM2J
   Fj/ATbkdx5nThhEl2f8G75CmQCZzMamtUg2rTc06dtjpFMJeI5zeK+vGk
   7YGtIOowstCjKPtBm9XlV8oyo9QZiEO27aDnJ5jC7XlbR7732EQ6bfPdP
   De3d2dod0ppL+4NMzKy19GQx0KOdQjzeUp9BhNU7ee180R/mRP+tYpeiI
   TqdQyoEazrkgbp9Bxrdb4l+XOAr98KI3oPqiWGAtdptJLjdkRRQqNJivh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339924658"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339924658"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:25:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="803558352"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="803558352"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jun 2023 02:25:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:25:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:25:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:25:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZLov6r5yAO+ERmD9b4Qzvcm/ghW9QBPye2UDi0SyH/nB3UJgqKdahHXUlB5BuVCa9pFcVidoMVbjMUBGhxRLBZONMCUuyjYPJc9dzrN5sxB+C9nSNCUxQc0+mGnbRCAppbx5nk9rRRRoVlRAoP258pYA+/qBhKgYoCfdZfKJ178r91w5c6K1gNM1uVGl7s+myYbFifHd0I7Jeyj99pkLEi71rec93yv2bbQtODJtUIeumaVmFoUV+M8VHg1RWQor547AB31vbK9UKQM+xZfF9M766BZGc8cOdKrzW/qgm9dMorS5x3ysQokzSiH7ZrWWx+ftNkABtcswjxQflIZlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/2Isct4Hz2u0B+xQEZuqERVgLTIYvfKcvNDzPoJOFQ=;
 b=KtrCjMytnc+rLc21SJhaiXsJ/dQqnNamVXIQhXYsyjDTQHhRSKXoJVJvmZR9/BWGvYnFTjTsUB4d7FNpCJkPs5pB4wv0Jmeef4QONcdOYDh3qJA2FcE9RHRWRtDW3VUA7SikEOz7xFsA1DCRc7+27x7zwt5a0ig0lX5uaDKbU1BLROA4XfR9WHMbEP3ICF1xRbyU+7/6ORm/6coiD/+EmEZlXjWc2yKT/EZJ/un/g9mOQZ8mi7skEvcCSz0ziRHG7laxXcpoSthfc9UvK2FYYLYrCBO91PfZzH65+o/MxYJnhpV9U8SwryietqblxQ65TxVgcTxZVjz2wPtr8rdVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by PH7PR11MB7478.namprd11.prod.outlook.com (2603:10b6:510:269::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 09:25:00 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:25:00 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v5 06/12] ice: Implement basic
 eswitch bridge setup
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v5 06/12] ice: Implement basic
 eswitch bridge setup
Thread-Index: AQHZneAKoLbYqL64QU2n7MRM3qneR6+R4/gQ
Date: Mon, 19 Jun 2023 09:25:00 +0000
Message-ID: <PH0PR11MB5013B59ED3CCEDB492004B15965FA@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
 <20230613101330.87734-7-wojciech.drewek@intel.com>
In-Reply-To: <20230613101330.87734-7-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|PH7PR11MB7478:EE_
x-ms-office365-filtering-correlation-id: c987aa54-ceb0-4a63-0c79-08db70a70e79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hiMnzP89WYPcJiKMmzbf7bPXfyUUFX3fdLNt+DCbkzcDMn8G9JKp/+gcckOcZKxVKuYDyQDKxFse/6nEjICx7jWLerAgR5+s5oCxpmz20gooQnEGjDFh7Dfelwd7KRY68k/PJtmH7tztRJ3XB90568bcxQXhOPAjdCebGfMmukqrDb6vaG83Ywf62AS4hS4qRbwSBS1W6TKdBeWSQ+7p2OpakvYDc45vZNiKYtlSquK4eE7AuiwMxG9Xymp/jnwZpR9pl8duJ3ydFy9uxC8GgGcfc6VyLw6DN+pk0wwSkVXI4vR3l+ENRaXlCy7MOCkMOugNdDz31ufK2Y+bn36KN/MhRutZMWP/A8SxOs/cCymPpJdJi3lp5VY6dXlqrIjAQxFjXW6N+Ky6axbonrmBy/JbN5toUxVZNKJvDqiHL7GjftFpEUSuBoA7PZ7LlzMbmvw305vQC71nBogW1Uv/8hPGNZRPxWGbLTXcfrO4rv5BDGT+KdcenVmW+VsuoZ6BOI9i7HuEtlfe1JgBgMW/0pOJOeYRMrLvi87YRgWOkZ06MAuLjMauOWh6sTGt+NPScMKZ2zIHE60kRQiLOBxQM03Qzl6eJrPVdDmw+EHOrWidd04vrGaNsndFC+W0teWp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(53546011)(66946007)(8936002)(8676002)(64756008)(66556008)(76116006)(66446008)(66476007)(38070700005)(26005)(186003)(9686003)(6506007)(82960400001)(83380400001)(41300700001)(38100700002)(5660300002)(4326008)(316002)(52536014)(54906003)(7696005)(55016003)(478600001)(2906002)(33656002)(122000001)(71200400001)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?56IvxgqNcw8fQj19R4DJVeDlk60wQQUpGvhNu3IZPHgwwUp965ggYPQ0Fp/e?=
 =?us-ascii?Q?zS+rLs/Ulc0A4jK0sUIDS661TEiOAGHKTdb/qVQO6jJ1Y4m/NraHhGgbfsua?=
 =?us-ascii?Q?kRf8hquaQBH4SQIsauU/9kz1L+vqEUzKrIp8NjNJciUWD5u2fQGCJGcMkcZW?=
 =?us-ascii?Q?gtWPNsTP92qp65QhhXKyZaXmiio3PN7+6s84OnZwalWDMg0C49tkpfZ9ZK4Y?=
 =?us-ascii?Q?c9B4IZ3KfQebjibo7km0KPp3+bJKH3iJBcif1wleTbjwmGizQEPU2thxRKFa?=
 =?us-ascii?Q?cquS9agX9aoJ2Guee0Ead3ZPO2NWjrVWKEgtIBH4mZXO9LyA95E3qQedQn3p?=
 =?us-ascii?Q?XaPRc5/P/IPDKpPOU6O4+KkgenlNtzn6Il8QT2ML6vhmnfUHGfv3yTUeuxSD?=
 =?us-ascii?Q?r9+A9qmF/5Jdufdt17xlsmc1YjxjcU7W4JUQ6dE4bTm8yXXYeSsQcTiu03Yl?=
 =?us-ascii?Q?D3WBHvIL8gnvaxA4/5yIXij/2Mu9vtmAJA+VIv+0zo//6FZDl2MzefkqvnTU?=
 =?us-ascii?Q?R1JNFbSMB80HtJpBOXNTLpI+S95Ma/JUtpJfi1QhW7YzmSeA63C7lqBvSGsI?=
 =?us-ascii?Q?+8vXeCNMQQ6LijiN4g4+vZz2185zrz0ix87V6HY5PE63TyaVknLSSH66tbr7?=
 =?us-ascii?Q?r1gEzADOTKCT0wVswlRuIp2xVeNetxtLbfDnmVAX2a5haVQQqArre5VUGy7Y?=
 =?us-ascii?Q?5lkpfU4taN0zuRZeeo9PLe3+Na0Zws9V8batLODKImR9IveBcmst1vZdx2PF?=
 =?us-ascii?Q?Gw8vT8eOcvgl4k5vJ3ezbl7kMIxuaNMQTCZQYH2q5WzpTb5CtCldLvWN3vrP?=
 =?us-ascii?Q?5Q+bLzKNTGUKgV/8o5MKHxA5kEPrXPJOBu7yO7DtvLdQJUUCVBd6hh0pzUk9?=
 =?us-ascii?Q?R+5EfYxz1NM9ryBsVbJZUXNXwSsAeYpAeLtRcYq4/AcokZww7ZDbbtoeQgYt?=
 =?us-ascii?Q?1XjwB/n3TDTOk4PlMqj8epfh4E5VXlbtVbhC923BcQPHWrlwzwt0orhckw2Q?=
 =?us-ascii?Q?qzEXCJwxrIGOQD5RtRY0rZ5wmXoFhhCEfz6VrIyMsRgTmEem3WFTBeogazJ1?=
 =?us-ascii?Q?8wJ/ZSPZuA6H224XxuoNv+csOuhN9kaRe+/+CuAslwHAz3pgCi4VkUpn/9JF?=
 =?us-ascii?Q?EkyOYLzGCPNDdhAOKCEBhkTcqzhJYkqAMG2wzn0o3TVPzVhhpQYchFsMqBHF?=
 =?us-ascii?Q?AjLI7IvPP0/ek/x4DGXNaPMo9yEfJY8u2Tqth1iX5rtxHYAuf7zGRrKdNg0c?=
 =?us-ascii?Q?n2xRMx5JuuZfg5uXpn8LnLxZpPjacfLK66KRAhLTJOSGOPn+emnHe8C74xbC?=
 =?us-ascii?Q?eilR1kUKHXGkxvUMQuo0B2K8XBeIS7GLDSpD9H+9MgP0L6sE+U4QYlXdC3y3?=
 =?us-ascii?Q?vDV2d+3KVuKO72MQLuwAxXTZ+NWNnlGQP7ljRrhjLRZwy6Aj7NAYHiDK5AgA?=
 =?us-ascii?Q?eTvxV8P1g3N/dyil0x1Gy58Ao1nhNk5VxQIWskpq0IsyKwShjIT8P1gTLUZN?=
 =?us-ascii?Q?8PCfWzbuewpbHllsenqaLzZR2cx1flDtPDVaIy1uRfvrY3UgR17OgIrbSv5Z?=
 =?us-ascii?Q?ardWOrWpzWveOXAHj/+6DJq5JM+3u/d8XbbDaB5diolRhBNMKuaXhs1mfGT8?=
 =?us-ascii?Q?uw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c987aa54-ceb0-4a63-0c79-08db70a70e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:25:00.7165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPg5meMD46DVO+BrE5n688oafFJmEQOyoZDj+TmR7/gRlCk9Kmu6TXbTUqap447d5NhCZ3sxSFFbqo9FAPQlj7v/UAw5cncWNqeqGH8OFII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7478
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Tuesday, June 13, 2023 3:43 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v5 06/12] ice: Implement basic
> eswitch bridge setup
>=20
> With this patch, ice driver is able to track if the port representors or =
uplink
> port were added to the linux bridge in switchdev mode. Listen for
> NETDEV_CHANGEUPPER events in order to detect this. ice_esw_br data
> structure reflects the linux bridge and stores all the ports of the bridg=
e
> (ice_esw_br_port) in xarray, it's created when the first port is added to=
 the
> bridge and freed once the last port is removed. Note that only one bridge=
 is
> supported per eswitch.
>=20
> Bridge port (ice_esw_br_port) can be either a VF port representor port or
> uplink port (ice_esw_br_port_type). In both cases bridge port holds a
> reference to the VSI, VF's VSI in case of the PR and uplink VSI in case o=
f the
> uplink. VSI's index is used as an index to the xarray in which ports are =
stored.
>=20
> Add a check which prevents configuring switchdev mode if uplink is alread=
y
> added to any bridge. This is needed because we need to listen for
> NETDEV_CHANGEUPPER events to record if the uplink was added to the
> bridge. Netdevice notifier is registered after eswitch mode is changed to
> switchdev.
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: fix structure holes, wrapping improvements
> v4: fix potential Null pointer dereference in
>     ice_eswitch_br_port_unlink
> v5: update ice_esw_br_port::vsi on VF reset
> ---
>  drivers/net/ethernet/intel/ice/Makefile       |   2 +-
>  drivers/net/ethernet/intel/ice/ice.h          |   4 +-
>  drivers/net/ethernet/intel/ice/ice_eswitch.c  |  26 +-
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 384 ++++++++++++++++++
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  42 ++
>  drivers/net/ethernet/intel/ice/ice_main.c     |   2 +-
>  drivers/net/ethernet/intel/ice/ice_repr.c     |   2 +-
>  drivers/net/ethernet/intel/ice/ice_repr.h     |   3 +-
>  8 files changed, 456 insertions(+), 9 deletions(-)  create mode 100644
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

