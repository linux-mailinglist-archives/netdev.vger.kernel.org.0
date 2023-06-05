Return-Path: <netdev+bounces-7854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 915C0721D36
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:47:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2D5E1C20B13
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4C5631;
	Mon,  5 Jun 2023 04:47:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA1315BD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:47:55 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D94FB0;
	Sun,  4 Jun 2023 21:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685940474; x=1717476474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IHPU/MtRNZHNt7rfmPfx90VK9oQMer4rYYLFHEDjw1k=;
  b=cH3v3uLgUVHEeHDPrkE9UmB2YOT5rNUxdFmGLvk6itx7qp0vuPxQZZj9
   tWetZ7sRyk99Aoc+MbIsoS0xd1gSoq9cQ+Asqn666sCQe9iAcZFxutfov
   GME/8XfquTzsBTfZpnCeMmmI0RFcpr/oPyMcsfx4b7gnCzq+9cglGaTIH
   v7V/m7rKWs3EVqpaLfms1YtxZi91mtLXBLdxS2Y/icS0dZPEnix6w7LSY
   /4/tF3HkUvmaAX40EYSjoNtCRd5qtAmoFZv7RzVDHPm1olzVZ2SAjZQGT
   cfYTP7GPa0nPhDKCPDmtQVqZHdQU4F1UdXdF+jAPPRvfyxFQ9YDDgECCh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="358728234"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="358728234"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 21:47:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="821031309"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="821031309"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2023 21:47:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 4 Jun 2023 21:47:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 4 Jun 2023 21:47:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 4 Jun 2023 21:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhLHaeh3UsGprSo6DFS4f/Ojey8yaBZ/r6b/qett6Z4ZPXEu6KQ9eK+bYyItUHRtfaPvlVydjhuMUKuT5JF1SQ8J4D11N3RcTO+zOEpcPiT4Of1x86Nugz969rolCqPJ6Oa6lnNBD3k+2KqHNFvX8iZHS9VwzPX59BEqErlgAeNSpKN49dmAH6j2lK0WvtWyGhnfswY3lWZ658M2Yho02ROtWaUmXnTwSh9GpKGYLiJrINZQf2Gmmoull1/5KMaw9Z13Uku2tRr+O8+6ziyNCFUMWF6/3StJMf0N4LZ7tXmHP8qvCXvromX6QCXi8nLGirXNWUAFKQjpawe1qfpyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2Hqhnuim942NwSR0yrQKjaZ7TzHDIMdDU9/7uBjcYY=;
 b=of+wcTp2v7gamGQ/M2qkduj30d3JEIEf2u7V3xVSC7a2McZW7Mp2kOvJeVrztZyX4hZbmQ91+x6KVoNEOTedKXdQAN9DGx50ezU8kp8NP0M9wwOL8MWdEqPgOgaXKo5zytcO+iy6MBN/E1VSofBmV9+RTBeqJtDhfZzzTCvSuNFWxrtBjOzvDgDLJkg4VmAiwVwibtUWo8k7C1aR3IoDU+N9vTiAZrWkz+nXxmInddXTx0apvuQqa2TZyhsAO1LqdcqAbohfwk1iFSdMxvS/ML4hSG4Pogg4LKt1LHAoeNmBT21I81JOsoGksc+PDj3wY4Wy288FxAKBVwxiYlScRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by DM4PR11MB6216.namprd11.prod.outlook.com (2603:10b6:8:a8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.28; Mon, 5 Jun 2023 04:47:50 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::9723:863b:334a:b279]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::9723:863b:334a:b279%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 04:47:50 +0000
From: "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To: Ying Hsu <yinghsu@chromium.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "grundler@chromium.org" <grundler@chromium.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eric Dumazet
	<edumazet@google.com>, "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] igb: Fix igb_down hung on surprise
 removal
Thread-Topic: [Intel-wired-lan] [PATCH] igb: Fix igb_down hung on surprise
 removal
Thread-Index: AQHZiZs4Csxm/mDEk0y5moePAHW/va97vVpA
Date: Mon, 5 Jun 2023 04:47:49 +0000
Message-ID: <BL0PR11MB31222538EC9046D11BEC4885BD4DA@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
In-Reply-To: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|DM4PR11MB6216:EE_
x-ms-office365-filtering-correlation-id: abf104cf-7034-46e9-25f7-08db658003ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p3OXc8EjeI1e1Mgs9xKTe5YsLJfFtQG7ZfGJQ2rkZp6CuTQ96HKBXjEsAlvjKITta8JDw1t8IArnnTmHD4hQwX1rv9OtOJVGbTv1vOuh5TWy7YsbTX2J5Vt1LOn86fhKOt4eoU3/vcoerzvGr7d7rq6vzws8FdxmQ+jS51VESLvTDZm5xdiis0lIxWHOk7uMGyAnL0kJ2zCKa/FqHqqIbDr0M/RessErwHdWUk6H9kKg9ojHT4gzoYI93XyVRhHlDhQMVroRv57I/UG2wUXh+XbyYvpyG3u3yEAuGg+dm0bQXeCkoAdcht7tQiTyEqbPtbwIkhNupA15AA3JSmtp8jPqhxGg6Aa1osrjxU/nCJOpRrvitHeErQ0RIEONvnUd0IkX609H+k2PQQXLV6jFjFDP705orlinL7bWXShCrlazDJ/6EEbMfbrmB/iSnNmMFF4nN/7LbwUlZ2kHuQ0+36Y9+fuDe/DUIdBpxCiQebK24DunNHNLhEZi9vxM/gSsSzzukUV/bDrl2VYn3PaRVy9/Dv4uyz1Mf0RsNBJowoNiJki6dxuhDO3RZnnB63RLatutC3/eJtGnN61qKuAs6f5qFk/Ur5EgB5F+EFuFfiY4KdUqmj9IRHhwpz/la7Wc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199021)(110136005)(71200400001)(478600001)(52536014)(54906003)(5660300002)(8676002)(38070700005)(33656002)(2906002)(86362001)(8936002)(4326008)(66446008)(66946007)(64756008)(122000001)(66476007)(66556008)(76116006)(316002)(55016003)(82960400001)(38100700002)(41300700001)(83380400001)(9686003)(6506007)(53546011)(26005)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7vP2HZ0HKb/4iBYCJK5Nr6uQC3nhjOvD4fcS3s+lticddmER1hWt7Lwse+3A?=
 =?us-ascii?Q?hzrfuM6ne6UzIrp+BBg2T2pkQDsO5Z6g91ibEShayNJAapBCB5FaRpBPkJ3c?=
 =?us-ascii?Q?k5Xdxz3WFwJZvb4Q3TLx9dh+vOjfTw2kdjl8S/pddbOm17UK5YNIkVH6GTWt?=
 =?us-ascii?Q?JIvMcK5aavEC0vLWfCM1VVhTPEfsAMtJOOJCeCIP/Ofc2HtZWbrv7IlPnrqI?=
 =?us-ascii?Q?lqkDh7SyzF4zHOZbCDDOlrEG7V1oTCUIDE/5izoc/8K8DLcx0/oqvkDT/wcm?=
 =?us-ascii?Q?KjJsokaxzTikwZyQSTpanw1fnjWJhCKwpA5n3RdJcOnBNlPok5V2WhMl/qxC?=
 =?us-ascii?Q?qgRvruL2ulX5QWX2MdctTm0PAfG77CWcLZB6tX1R1JPHBtnzNvLC7l6hotF9?=
 =?us-ascii?Q?E3XK15EhBHCB40g0Fr9TEry2yjZvTpPNUMChXGfTp1/DdfX4r/3DWqJ4Bx5R?=
 =?us-ascii?Q?FWzJgKPOulGPCoHBWSlFyjzSFpRhoLkhbUAdZ3TIpXdV0pFsCHh6wLV6bNUj?=
 =?us-ascii?Q?LqqadKIJtJMHp/LgfJFnuT9hj5KOgg5x2bRnhbZ5E6Dk0oGsIVFmFGBzZCWb?=
 =?us-ascii?Q?jTE5qCBLmz4ABplDJqG5bLY1dTnOUHrF6dSS9lMPLvJ5p1Ch/mKhT0MU7YhS?=
 =?us-ascii?Q?VGPCaX0PyglUtuuhN+8yKn4s5QMvMgLiPsIIUr72hVovDJna37TkmLL1o2ZN?=
 =?us-ascii?Q?UVrUdTc7fQEzG7X7QmFhVqxV+r5H7D2omiN+MXZpmOoQNS8afuFLRlW9JYhd?=
 =?us-ascii?Q?NUVsPfAdix554toBFbkeDtsH+bHAaAi4X2tKxuSaa5LzqksvKKeG7Fn7whXH?=
 =?us-ascii?Q?owmOtW/CAZDnrMGamu54SFS1CRK5rlXHHSa52QYM19HMsdaEs0+51thUqiof?=
 =?us-ascii?Q?l2rF3+lkVxydiGlAeiJRBPtXKHm6DCHi4z2dDbAkfpUBA6TdxlLEWf7UvYjs?=
 =?us-ascii?Q?YNIwbmvjSyiVccTVM7DP46RwTuBY7X7uzgRQ5id+9fYfVLfJbW95D3mR6Tqn?=
 =?us-ascii?Q?sp4ivY7Z8aFz7lszEnec078o90zvmKPYX+UU4mXFI/zdra3WGyYOg3CX/wQF?=
 =?us-ascii?Q?HEDIxKH+5iShKSpYuoL4ph1/btWCRcbg//Xx+fZkWHPAAw8ynWJSfXoTN1lR?=
 =?us-ascii?Q?zBvUeI9tCmyylL1jyAGr8paCGOCAqFhCj+ctIViHm6Wg3qOlRKNgmaw+FjCp?=
 =?us-ascii?Q?ZTx2E1qJTVkBoLrZpu33w/komyrzlaj3MKAF4cMKrcBYlsmlqWsP4l04oULF?=
 =?us-ascii?Q?f+hckdqiHWVRh61+RWxYVkudr5AZMxOomwGkBzlF13d5SOCRFfDASJ707MUI?=
 =?us-ascii?Q?7CZIk3wy2UwNLP+SAaPEq8sQvf9ueU73m7Bew+AlBVkJUedbSyPY8YWtO6h2?=
 =?us-ascii?Q?MKiKPjc8W3L3y4jMvlk7hWZJvJsd9Id+fZzOcCN5/6RdxhLZLWMo7hw7sIQG?=
 =?us-ascii?Q?cW4YXBbBKSE70Ly9x6uLXNQHwwdALdcAaeDZxyXPsMKRgoHvMgHyNGbPhkIA?=
 =?us-ascii?Q?nR2lbJPtXkKesjGh504Uj4aHQ/t0KIHWQMjDSlfW0AQoT4HdoeH81UIhyxkB?=
 =?us-ascii?Q?aUbwh+mlPWWzUyLD/IrYamQIEAPuZk8fy/vw9od6ePCJMsqOBsnEVm6Iad4p?=
 =?us-ascii?Q?lw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf104cf-7034-46e9-25f7-08db658003ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 04:47:49.8873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +SqarNMSSePA4xA3mWS39E3DeBelua7dnWx+VF9x2l5nj18ub/Wd2Gf4z4jPoXWizE35PgKpijzR1v0zzAYe8rHORdn1g/Zq9EvOgeEc7tOukDkpYZt7smxDy4sJ5m1E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Y=
ing Hsu
> Sent: Thursday, May 18, 2023 12:57 PM
> To: netdev@vger.kernel.org
> Cc: grundler@chromium.org; intel-wired-lan@lists.osuosl.org; Ying Hsu <yi=
nghsu@chromium.org>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; linux-=
kernel@vger.kernel.org; Eric Dumazet <edumazet@google.com>; Nguyen, Anthony=
 L <anthony.l.nguyen@intel.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Ab=
eni <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] igb: Fix igb_down hung on surprise rem=
oval
>
> In a setup where a Thunderbolt hub connects to Ethernet and a display thr=
ough USB Type-C, users may experience a hung task timeout when they remove =
the cable between the PC and the Thunderbolt hub.
> This is because the igb_down function is called multiple times when the T=
hunderbolt hub is unplugged. For example, the igb_io_error_detected trigger=
s the first call, and the igb_remove triggers the second call.
> The second call to igb_down will block at napi_synchronize.
> Here's the call trace:
>    __schedule+0x3b0/0xddb
>    ? __mod_timer+0x164/0x5d3
>    schedule+0x44/0xa8
>    schedule_timeout+0xb2/0x2a4
>    ? run_local_timers+0x4e/0x4e
>    msleep+0x31/0x38
>    igb_down+0x12c/0x22a [igb 6615058754948bfde0bf01429257eb59f13030d4]
>    __igb_close+0x6f/0x9c [igb 6615058754948bfde0bf01429257eb59f13030d4]
>    igb_close+0x23/0x2b [igb 6615058754948bfde0bf01429257eb59f13030d4]
>    __dev_close_many+0x95/0xec
>    dev_close_many+0x6e/0x103
>    unregister_netdevice_many+0x105/0x5b1
>    unregister_netdevice_queue+0xc2/0x10d
>    unregister_netdev+0x1c/0x23
>    igb_remove+0xa7/0x11c [igb 6615058754948bfde0bf01429257eb59f13030d4]
>    pci_device_remove+0x3f/0x9c
>    device_release_driver_internal+0xfe/0x1b4
>    pci_stop_bus_device+0x5b/0x7f
>    pci_stop_bus_device+0x30/0x7f
>    pci_stop_bus_device+0x30/0x7f
>    pci_stop_and_remove_bus_device+0x12/0x19
>    pciehp_unconfigure_device+0x76/0xe9
>    pciehp_disable_slot+0x6e/0x131
>    pciehp_handle_presence_or_link_change+0x7a/0x3f7
>   pciehp_ist+0xbe/0x194
>    irq_thread_fn+0x22/0x4d
>    ? irq_thread+0x1fd/0x1fd
>    irq_thread+0x17b/0x1fd
>    ? irq_forced_thread_fn+0x5f/0x5f
>    kthread+0x142/0x153
>    ? __irq_get_irqchip_state+0x46/0x46
>    ? kthread_associate_blkcg+0x71/0x71
>    ret_from_fork+0x1f/0x30
>
> In this case, igb_io_error_detected detaches the network interface and re=
quests a PCIE slot reset, however, the PCIE reset callback is not being inv=
oked and thus the Ethernet connection breaks down.
> As the PCIE error in this case is a non-fatal one, requesting a slot rese=
t can be avoided.
> This patch fixes the task hung issue and preserves Ethernet connection by=
 ignoring non-fatal PCIE errors.
>
> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> ---
> This commit has been tested on a HP Elite Dragonfly Chromebook and a Cald=
igit TS3+ Thunderbolt hub. The Ethernet driver for the hub is igb. Non-fata=
l PCIE errors happen when users hot-plug the cables connected to the chrome=
book or to the external display.
>
> drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
> 1 file changed, 5 insertions(+)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)


