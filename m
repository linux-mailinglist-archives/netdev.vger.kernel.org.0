Return-Path: <netdev+bounces-8700-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D8747253D7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEF9B1C20BD5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446954696;
	Wed,  7 Jun 2023 06:06:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEB263A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:06:20 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC1383
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686117979; x=1717653979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9dYQtX10hAtFXm4+8yjAy5UL1Wk8Y2UNVu3vtkXDH2s=;
  b=XsWdhfcsoc9EUKotwJQ4u3EHdmoqzIdWa3U233OYf1wNUvGKfGqX6rcC
   mPy8Yj9JEBiUqea4DNQY/9CHh8RrlOwuHa5w/ZuZFKlGE7Ubi9/O8efHq
   FFG/jObf8u/Is/QHVERvytzApdI7tHd5r6yuwLXMYToYWouBDxA6T54BN
   WTSXbDz7YV11jXSGdZQ57lLhGDoGHfna5qVaqW1VSaTEKg4HxKL1LtWUg
   AkKKbypPkRP8MZR/Cz/oHkjm5qGFqa9v5hg0OZzL6/H5l6YfeTBNpi8eq
   aVy0xtDCZ6RlNcC4APdFRJz7wt4azDY8S4oM1l8eRM/T7kopP35GLlXYc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="422737864"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="422737864"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 23:06:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853698374"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="853698374"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 23:06:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:06:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 23:06:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 23:06:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKTZg0/ZN+A7jLR+kSFYmSQwRa1Q96q6vXKV/tcDzUZjLahTZLbj7AICBcearXTETyH4qLYkwlyHbCSokX4fpJLDc1ekuEzINHqTUziICLJuy4s8OS+0HIpEvu8puEVIO8lujki2wjbemD9uUV+L+Bmez+pFw7KuNqA7GE+sLeTnXKIWN4vofNj9pIUhtQaU29FUpOOG2uNdS795OLRlIKBrP9j04bqSaeizUhtXqfWdf3x1foE21JlqatLDe2eK8coVbWrWyBgo/3eCsJFuOYpbr/iFAN3mVLSActhZY1ByNo8+igchwZj/a22Yy898/gt1fxqhwsVHc0/a7n9I9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGbNTWFuMiQfTMSqFovi9je3Eqi7pNmYSqEgLw8mGz8=;
 b=UAmLzLgx4BfySg+0LAfGMMtQEXv6+grg64OYefxvfcHLL4lbfN2sE1mN3vS8+MTgyGds1RmGMfJ5kWRaVruW+dAqJHyEVc+lOcxxhDkUeAdwVUWHPJNT5Y3QgpfXOYOKXIMav+Mbiv9MWBUaGNT9v9uj+lgIX7yElNOlIzHuVBc2nxvK6vzx/QGYW/FdtjjdXgKPJn+qLH8oPAUd5l4dJUeveTMl4hesPie1dZkvvFIueFsjGbOaw8K/EukQ1n7uh50+oH37sJwKLQo8xfOkeXLtPkuZFnDS0P7sO4xcjbW/lrsGmp8zOQ8tinOlNTuyJ3ipOHI4YXonVXgWonCJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 06:06:12 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:06:11 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 07/13] ice: Switchdev FDB
 events support
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 07/13] ice: Switchdev FDB
 events support
Thread-Index: AQHZjjqp2bAO+FzXJkqPVOyIyDAZ+69+77VA
Date: Wed, 7 Jun 2023 06:06:11 +0000
Message-ID: <PH0PR11MB5013746533A0421D9BA76C959653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-8-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-8-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|SN7PR11MB6946:EE_
x-ms-office365-filtering-correlation-id: 5247abe6-1880-45c2-8815-08db671d4b5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 645HmMgHNAAoqZYwETfbudP54g7jUKFgzIFrG3PfK2QeiNq7ZwOQVO0pyzHUKWLRk+HdonOBmmrxVnUZqViwFtYHHogLySyYFZZ3SdYfxThDXxJ4Qa01egJ+wkzOkRwettd38RK4JK4ms4WhQfKNutVkIg+YkHu2IK8fAC5W6+NHtqIyq0Bu5YnK+D+G/sguD7uYsX1hAdYLWhKHD7t316KEUhGTFy9UsKM35sTx6MXPZYbVD0wQ19JIg6hmIPmPcxQqGcnlSnKAiekeCn+D+qnWGGwzB0e/u6RR/dCWrIUpssctvRWSpBpLV57pKKZFZDZvFJML1zjOIeC1tuW2ZuEJ8j8RuCZbSFB9TPnIvLX4qTOG5Wo0ikS7E4dWLHwVcY4lMM6L3Iie5kqKO3FriSpaX10Dei3tleo2nXzL943vcgstrB2/KIrDx7Wv6cokB9fSmu1dQUMG4qzvFZHRX1hXmodh3b38cExEOcxowhgHW0+UHPkHF+2WqNDRReIh7B1BKSWL+uUJQdEqpGbZ+Sm27zSZ0qQyAXb/pRUVuS/OnZVefigRW2hYYZkJOLEYLePIRgwwzYht+Uvtd+k+e5QJICNE1h14JK34QIcyR65mJ+3Vpx4WuIP8bvnDP4Jx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(83380400001)(122000001)(4326008)(110136005)(82960400001)(54906003)(66446008)(64756008)(66946007)(76116006)(66476007)(38100700002)(71200400001)(7696005)(478600001)(66556008)(186003)(2906002)(8676002)(38070700005)(52536014)(8936002)(41300700001)(33656002)(5660300002)(316002)(55016003)(86362001)(9686003)(26005)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XMdRwXgR86QSL9FrUME4V7TMJe04Ttba1RPe+pRwCA3XxAEz5SgSg0FhPPiI?=
 =?us-ascii?Q?XaaeKcUkK2scwJnPaOx7Af4ru0LjUez35Ruuh12bASjB2cXf6abDNfFVgG85?=
 =?us-ascii?Q?/SpIXgCPdord7zsDRXyctckLIEj1gK2QqSHILCmQs+edlwdi0BZ1ws0tVUOo?=
 =?us-ascii?Q?Zjp1Q9kJ8tAOO2ji4N+PlNvW6BE4WxG1HqlcsKbm85iAmdL/xEMHEbLF6740?=
 =?us-ascii?Q?pCYFiElL0NSZltD3RPaqgjqbXUSf8wdKLKF7ewyISJxKh0t4C/fz3g5iGB9j?=
 =?us-ascii?Q?KnMm7jugs7R2agi9y4GmXEMvUu6w8HZjtevPPQSxUJC3xcFvEbLvWJOoUHgw?=
 =?us-ascii?Q?kfrxAuAK3jj+7ybMp8dgNOzy+fmQ2TWLGI3jufwXNDHuQYJKi8h/jULesC2l?=
 =?us-ascii?Q?D0kAGgF4uR+jQZ6c+DJDFZlHfbsjHBTWzvCOBPOky7M+TzLZIQozCpijg7F4?=
 =?us-ascii?Q?TgvSbKtfMn1AzxtdT65Pvmg7rGHuwDEitSloCzsaSDDyoeZ9prs8A/tL4JFI?=
 =?us-ascii?Q?vGuHV0Y0ySv5eN+DcwaCnpeo/bsOBak5y6WClDw83GoKwxQE07AImiAdUGAV?=
 =?us-ascii?Q?eP9p73BX9hRLiBoLb1/qRQtog77tHIHcfb6wrwALENGsG59Oj/S7HXpeZAV8?=
 =?us-ascii?Q?SiW5RYFp2izwBYNJYIPgEsKrm4sdLlknkeF7KxsTGWzOsppv/lnoBOREP3YI?=
 =?us-ascii?Q?2nxuq/FjCKOj5osSVGEXvBXu4j1yQW7l9KYfOvkDp1CLg9uqmsDeXlcfDcXa?=
 =?us-ascii?Q?ML6YlszzSZFzq4/EyflnyMTCTUPqx/8HhRamhKOJgdWrToY2Ur4xtBxluysa?=
 =?us-ascii?Q?rJdvV52VuHPZS4wwPa6RoTERRGjHAGYBLE71EH6t4BIXlG3EfduIC/nlA5Li?=
 =?us-ascii?Q?+7qv0gYzcTPux41gWoaPF7RNtCG8Y4FKFWtXXkNULoWi/0Ab4xOdBzXhND4x?=
 =?us-ascii?Q?7asoFEnaI7hWLul6Ww1ATPueLdTpworWmuVylooS39PeWLNYAYh1FTrvToQu?=
 =?us-ascii?Q?bUMIJhOqU6R7f5wwSkZMHvgI63w62RcEkXNtpomrRnjTSp3wgv4hG32HoZUD?=
 =?us-ascii?Q?9m8veFiZrbhCUBVRyxdn4VLcwYPMrkAleZd6HMi96QD+VT46t1CCvqA0KAnA?=
 =?us-ascii?Q?pAEt7p115iJxeCbuz3oA5fP53ZqoTjEpQ0yO+eL5qwUHk1sWcOxoq8gUhm/Q?=
 =?us-ascii?Q?wLSdy9CP9HJbFiQyCcCDaTKMf+ZSXzogdYCNX3CA8PItqMt9q68qaZ2Ka/cg?=
 =?us-ascii?Q?3hacnc/vbimBhQHHDD5ET5vf1kWbGuWGy6U/8ciQmCwS5sZw7tSdL9QljS6X?=
 =?us-ascii?Q?43jCiWaWu384/l//CHcGaZGz/zwB8STThgqkk+uWwc6VnNoyZhDZ0PZfd6Cg?=
 =?us-ascii?Q?fJNI5ntEXRYgqC1QjUkMJc6HGiIkMKDo6Bgc2T9DSqTEgfp3nWT2bUDxM2g8?=
 =?us-ascii?Q?c0uBbV3IfTU3inrvHbETs8dcUZQQFxg1YL0mZcef4u7UEd/M27rgBBpqZq97?=
 =?us-ascii?Q?BGQ3LPG1MxY39RgF/Rj1j9IaLJFC3hUUOn6pMVTE8emADzknANB6W5JtkLMM?=
 =?us-ascii?Q?ShrTAaHN5cykTiKSJEGZRSTCJjAoBhbDrMkL5ma3sOEwdJFtIByVqsKyZTab?=
 =?us-ascii?Q?ZA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5247abe6-1880-45c2-8815-08db671d4b5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:06:11.9096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xdB9Z5MHEAUezdbamSwTjFDduaOL8zXvzPnHlIdODD++YDEuaOHsSLfZxsOsKJcig5A1sQrhxJFB4Z2LUo6+QIpNJOhBuaav0mm19s3TACc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Wednesday, May 24, 2023 5:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 07/13] ice: Switchdev FDB
> events support
>=20
> Listen for SWITCHDEV_FDB_{ADD|DEL}_TO_DEVICE events while in
> switchdev mode. Accept these events on both uplink and VF PR ports. Add
> HW rules in newly created workqueue. FDB entries are stored in rhashtable
> for lookup when removing the entry and in the list for cleanup purpose.
> Direction of the HW rule depends on the type of the ports on which the FD=
B
> event was received:
>=20
> ICE_ESWITCH_BR_UPLINK_PORT:
> TX rule that forwards the packet to the LAN (egress).
>=20
> ICE_ESWITCH_BR_VF_REPR_PORT:
> RX rule that forwards the packet to the VF associated with the port
> representor.
>=20
> In both cases the rule matches on the dst mac address.
> All the FDB entries are stored in the bridge structure.
> When the port is removed all the FDB entries associated with this port ar=
e
> removed as well. This is achieved thanks to the reference to the port tha=
t
> FDB entry holds.
>=20
> In the fwd rule we use only one lookup type (MAC address) but lkups_cnt
> variable is already introduced because we will have more lookups in the
> subsequent patches.
>=20
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: declare-time initialization, code style nitpicks,
>     use typeof instead of full type name in the container_of
>     macro, use PTR_ERR_OR_ZERO in ice_eswitch_br_flow_create
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 448 +++++++++++++++++-
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  46 ++
>  2 files changed, 493 insertions(+), 1 deletion(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

