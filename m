Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B94D50DE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbiCJRt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiCJRt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:49:26 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F312340916;
        Thu, 10 Mar 2022 09:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646934505; x=1678470505;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YI+o4BlT1syvY0nshjS4Al8/v7TCAG8qmuSa68a1lUI=;
  b=ae/xF7CxUEsZCfp44ZWETGypdv6zXh/zsH6/kHUpId742iiZC0UVHkrY
   q7CP89tYIDbow4kb8PbHLBzBT/xNyB+uAT3yWdiJW9FiKo52cvA145uLF
   BfLn4pq2cos6mMcqHctO8E/Pq2P10/34baq853tdcZ1X0QYU6NyZaQStW
   gTMKXFr56RdKqVD/GjFRgMS/wR2jbE/eoFwoklwMyh+6nFLLX8Wn0sCAZ
   suJO4WDPO55dpmZzuU5YcJy71K7jRtlYbDpwtZVZMtTGODfOKyWSIdrR+
   qxuEEuZbqBg6QABq+/wlhQfvpBeRhdBq7Fs8v4dolhCq80M7crFjKd+W7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="242766413"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="242766413"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 09:48:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="644537498"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 10 Mar 2022 09:48:24 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 09:48:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 09:48:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 09:48:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qfpp/w+OZ6dLE3EMGIN5BUizDNky269jlXLHpa/cq76onvtadW0WlNp66xf+TZ+pqWLkNgW/+X4hoE4q8Rrz+i0SluGyHa7WX6PPxcSIbqHgEMiF0LmO0S6NRy1+t1JTOiWNAEYc45h2xzDiQqGkUG6ZhvutwhsEq3PLHf9YROlZETsrh3f9GPbfDHyO0zvltBLkLsGrp3u6r41W01Hed/6rGHJ4hSMdEbwDCvspJU/KhSCKB/5i8sfX/muzlO01kUdNXT+VuwQq4O6zNMWJnLsRHJINXHdv7tBiMr1DVnfQKMQdFpmmNg6w/pH6Crx0/zmlqmQlxJB1kIZp+iCWeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPzFq+45eQw8o1nl+ipgdjPhWqtUXv2YnGt+YnaC25s=;
 b=fYH/v6z5wuocLX1HVyPBI/7a3jrneAmOZmcYZwymr76RVtVLqsY72uSmTUU1HKhq60qba+ynMQYRLADq3TS7ViI7xBYLWsJaijyDF8c28PyVSjN6qblnD2aBs13hbQK5l+NkkG9wHG28Xd3dRVfwcJ6HP0y7uGWB+Y+D03B+E2eoCyDXbQtpnFq6WgnXTveDDuagG4npWhNKwF8A2jFoOk8n5kVRFeKmi2ATvdUhJWLOXVT4RVBe5865mouc3gGWM0i1Ptla7gXx1of+MR5ImA9pJo7Re/drlFj+uKDtm0EyWpZeBfJ6Yf1+g32FFYH09Dw/cjpeupmwBSFdOxQdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by DS7PR11MB5989.namprd11.prod.outlook.com (2603:10b6:8:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.23; Thu, 10 Mar
 2022 17:48:17 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::f02f:1868:e11a:ce8e]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::f02f:1868:e11a:ce8e%6]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 17:48:16 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Oros <poros@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] ice: Fix race condition during interface enslave
Thread-Topic: [PATCH net] ice: Fix race condition during interface enslave
Thread-Index: AQHYNKcFldlqr1eV60WCnd9uUWOM8g==
Date:   Thu, 10 Mar 2022 17:48:16 +0000
Message-ID: <MW5PR11MB58114999381C7B98598BB568DD0B9@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220310171641.3863659-1-ivecera@redhat.com>
In-Reply-To: <20220310171641.3863659-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e2f0e1c-a557-4cbb-3f84-08da02be2855
x-ms-traffictypediagnostic: DS7PR11MB5989:EE_
x-microsoft-antispam-prvs: <DS7PR11MB5989270A62D6C1BD398C47FFDD0B9@DS7PR11MB5989.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MvTcBpmjOu18Du9dmy2WeR0fUQYEPtfh7D4cC84xkI1B5rpayKvExCQdGFNocB09EGDqxQi1ZcRan9/NAyfZ6BSOonsknuex7rurXrUhg1B5t3s0YoFDRhv4EnNbx+pzarExhHYzUgi5jGuvQu/R4GqHyXqdPjrjWM0hCiUVYOM/txlfUC5cQb+2/iossrlzXkxC1V2wAxLV35a/b1p6yEtj6VGSLG2dWIopZ5TFo8rzOlmKUrVEk/Nfz9H9YoTpya4SAJb69sDMICTzFGFQrOz6jaMrlUxntF74+lTFvwKtskfa51mbrPho2SzT6oi3fsmoa75kaxt5QFX5Vy7SwI2RR2EDVS9QXRbNjB3OcgAM6wVCKXNE292F/o8posjYPuieWws9/1saRrf9Zf590IzflupZ8jLQD1sZbNBbSEXdL4EgCeCzf+J7LYvaOctU9ccis9WqGNc/BI7Evf1wom8/4MYUkoHrX8dds1p88jZIwy3UpGRcDXrt9a+S3adUEPddqYAbbnkQrBqXk0fx+jg/ZHjSOtVp/zayMJe6xpPiNXYG1qFTNzxrzjypYroKYRqj/i7vkNc+UVNCsSwTNHSz1JuO0KhT8zaImqQt3IcX5TUH9bjpcBUg3JNDj4HOP1Rjj6gnAvfSnwm6LkctyKLwVaUEaiovtzIJKXgeh2jsGYSrDyBNoUrps1vN8Y5tlNBIm4kNnJ0cDEF1A/Auww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(38070700005)(7696005)(4326008)(5660300002)(83380400001)(8936002)(71200400001)(6506007)(316002)(508600001)(9686003)(53546011)(54906003)(110136005)(186003)(122000001)(76116006)(66946007)(55016003)(26005)(33656002)(66476007)(66446008)(66556008)(64756008)(38100700002)(86362001)(82960400001)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3CXvkBiHFR8EAxwim80aI32n5NE77mtkZNGeedhS31AsL5NHDKINKg/Ms36i?=
 =?us-ascii?Q?ZiArehcdQhnVsGSN64CBkom+RVGri7/HVbMfB6edgmiVYawL6ny0EmJ0yj6z?=
 =?us-ascii?Q?WaG+Yk2eGp7XMXDQXvRjanjPc+JBX8og6ZwTuLvKA8pVU2psUVGNhH29RWBf?=
 =?us-ascii?Q?i+OPD/rMLEJ1k7KD3i+bwnj7c2i4HdLbQSoTr85g5JKiMnPMqpPJzhWVvmJl?=
 =?us-ascii?Q?a/9ZALlASdIH1eSTzGJJjiI1BpzUpzWPRi8MZrzS4bY8UEzj3nstHWaV8wAl?=
 =?us-ascii?Q?phDcY/6Ax0XR91sc7egs7BpE4F47ItNCrhj5g6i9rbp8dN2eIOQ+uKWvuU2u?=
 =?us-ascii?Q?atWywDub7afLe8QUz7ckevLF1RGCdAEGabGwh04aFBDAe2aOlyoMF7qVwYwh?=
 =?us-ascii?Q?mHgfvjN9ifyys/g9Eb3fEmsVP1P5AO3ROIsPrk0Xg/f9DNh0vqXpKdppBlEY?=
 =?us-ascii?Q?c/NckBYtFLYS1RCboEs9kq9/JE83F+v7Xt+sbSrfeay9hH1Ha4cmSfda3aiY?=
 =?us-ascii?Q?uDsjQKXZlWEAngt5qCdvNSJv8ddDh4CnX4caiCK6LFDREwIzxzkEfSxMtGas?=
 =?us-ascii?Q?KcAUZvXseLqBiK47SQO32ZLt3A+zpCSdsrRdr9QLqd7XgtX1NR6e3Vj2pPsE?=
 =?us-ascii?Q?2jtQhh/lqsoydnaJbPG59px1f98eNZh9OjrZP8jMcM8zNz/eeodMRcmaY6AC?=
 =?us-ascii?Q?hNpusQQx1DiFMrLOY1rAavjek/KdCog+q3pXupYRh1riJeviz5aTe24sOngi?=
 =?us-ascii?Q?g10FaEOVFtHudttwrpE9Hxtv3AfHQ+OyUBGCjqSOTMmgIfzrEfnP6yXMuDDE?=
 =?us-ascii?Q?7ifWyBOnAnifYlVTunnvnFHS2IW/t+ok4Nnb3GzUm1L2D0CSLG+TCdflw+5w?=
 =?us-ascii?Q?CLEdZcBqeGrv//dQ57mfLxTAmmLG4f885LDCZj/JZKHVtl4JfzRu0tvnZQ+7?=
 =?us-ascii?Q?eQ7UG+iKhk3sKtvY44wLCs86JGgvPbMuMBQR+FIOi9ctZwGTsUG4ZXw4WMJ0?=
 =?us-ascii?Q?kvPXmSsG24CkTZ7n1r2euvY7L5RJ7L4xHH9wbJxTzrRevcchDPbHYWeGv3xk?=
 =?us-ascii?Q?cQcEvkTAcNQGdh9d4+oMj3veQzT51gwI2ZRVqMOcyMVazW9UTg3yzLN4jPvE?=
 =?us-ascii?Q?kpdyjmPmyng/QopI7IuESCAPUFCz4zZyDxH5lHbwKKkuO+toBZY1lWeR+qUO?=
 =?us-ascii?Q?2FqZ0niwI55mbR0xfCxkYxLmY+3tfgZ+FN4bRdMZjuna9jxu893WTu8+ABom?=
 =?us-ascii?Q?X2JrqhcwSTnf3fNluvv99aJhO8AyPAUre+XGejTqCTUII+xDYXj2ErYmn734?=
 =?us-ascii?Q?zIYTs3SyjwopXpq2/Lgg0j2HYWZ6TifYyuSBRgk7xk0ri0SEd9GwTB0NpQeh?=
 =?us-ascii?Q?hsEFalXUUpPsrDkP7ZkK+ZauNMPOJJ40yzqnKNpakgwe5A99z4APt48iVFbD?=
 =?us-ascii?Q?5QBEuJPEgIt8LHZJsnKz9T7b+BCfUqXFYaj9qTaGnunNhlbRhmYNNhYQt+S3?=
 =?us-ascii?Q?pjpFOLfD2X9tOHncl0u4DkZHaxXOO/5fsL0Jo2kbWx//qykk05vH42L/x2ht?=
 =?us-ascii?Q?gVXx5mNajgp2+nX1vvMO9bSyi2kzjGnGyUvQZdTEKUJRwNnxRrAn4nGGDmNJ?=
 =?us-ascii?Q?vArYZw1OAp7bHFGlKfCZ4t352ARrEkxdT7jL/1O+kpG8A5jnbHkv5Jm1MM8z?=
 =?us-ascii?Q?VrRcWw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2f0e1c-a557-4cbb-3f84-08da02be2855
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 17:48:16.8800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 72rkNZXP3pswC4n3b0wamRANkOmQLtE5pdhidBjhwYWP8/Q8PyG5gdqQUPvjDFZOTX2Nnoxj0N+1Nw/gF5VDPkkpGbLpPZMkQjkVnpsdP4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Thursday, March 10, 2022 9:17 AM
> To: netdev@vger.kernel.org
> Cc: Petr Oros <poros@redhat.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; moderated list:INTEL ETHERNET DRIVERS
> <intel-wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.o=
rg>
> Subject: [PATCH net] ice: Fix race condition during interface enslave
>=20
> Commit 5dbbbd01cbba83 ("ice: Avoid RTNL lock when re-creating
> auxiliary device") changes a process of re-creation of aux device
> so ice_plug_aux_dev() is called from ice_service_task() context.
> This unfortunately opens a race window that can result in dead-lock
> when interface has left LAG and immediately enters LAG again.
>=20
> Reproducer:
> ```
> #!/bin/sh
>=20
> ip link add lag0 type bond mode 1 miimon 100
> ip link set lag0
>=20
> for n in {1..10}; do
>         echo Cycle: $n
>         ip link set ens7f0 master lag0
>         sleep 1
>         ip link set ens7f0 nomaster
> done
> ```
>=20
> This results in:
> [20976.208697] Workqueue: ice ice_service_task [ice]
> [20976.213422] Call Trace:
> [20976.215871]  __schedule+0x2d1/0x830
> [20976.219364]  schedule+0x35/0xa0
> [20976.222510]  schedule_preempt_disabled+0xa/0x10
> [20976.227043]  __mutex_lock.isra.7+0x310/0x420
> [20976.235071]  enum_all_gids_of_dev_cb+0x1c/0x100 [ib_core]
> [20976.251215]  ib_enum_roce_netdev+0xa4/0xe0 [ib_core]
> [20976.256192]  ib_cache_setup_one+0x33/0xa0 [ib_core]
> [20976.261079]  ib_register_device+0x40d/0x580 [ib_core]
> [20976.266139]  irdma_ib_register_device+0x129/0x250 [irdma]
> [20976.281409]  irdma_probe+0x2c1/0x360 [irdma]
> [20976.285691]  auxiliary_bus_probe+0x45/0x70
> [20976.289790]  really_probe+0x1f2/0x480
> [20976.298509]  driver_probe_device+0x49/0xc0
> [20976.302609]  bus_for_each_drv+0x79/0xc0
> [20976.306448]  __device_attach+0xdc/0x160
> [20976.310286]  bus_probe_device+0x9d/0xb0
> [20976.314128]  device_add+0x43c/0x890
> [20976.321287]  __auxiliary_device_add+0x43/0x60
> [20976.325644]  ice_plug_aux_dev+0xb2/0x100 [ice]
> [20976.330109]  ice_service_task+0xd0c/0xed0 [ice]
> [20976.342591]  process_one_work+0x1a7/0x360
> [20976.350536]  worker_thread+0x30/0x390
> [20976.358128]  kthread+0x10a/0x120
> [20976.365547]  ret_from_fork+0x1f/0x40
> ...
> [20976.438030] task:ip              state:D stack:    0 pid:213658 ppid:2=
13627
> flags:0x00004084
> [20976.446469] Call Trace:
> [20976.448921]  __schedule+0x2d1/0x830
> [20976.452414]  schedule+0x35/0xa0
> [20976.455559]  schedule_preempt_disabled+0xa/0x10
> [20976.460090]  __mutex_lock.isra.7+0x310/0x420
> [20976.464364]  device_del+0x36/0x3c0
> [20976.467772]  ice_unplug_aux_dev+0x1a/0x40 [ice]
> [20976.472313]  ice_lag_event_handler+0x2a2/0x520 [ice]
> [20976.477288]  notifier_call_chain+0x47/0x70
> [20976.481386]  __netdev_upper_dev_link+0x18b/0x280
> [20976.489845]  bond_enslave+0xe05/0x1790 [bonding]
> [20976.494475]  do_setlink+0x336/0xf50
> [20976.502517]  __rtnl_newlink+0x529/0x8b0
> [20976.543441]  rtnl_newlink+0x43/0x60
> [20976.546934]  rtnetlink_rcv_msg+0x2b1/0x360
> [20976.559238]  netlink_rcv_skb+0x4c/0x120
> [20976.563079]  netlink_unicast+0x196/0x230
> [20976.567005]  netlink_sendmsg+0x204/0x3d0
> [20976.570930]  sock_sendmsg+0x4c/0x50
> [20976.574423]  ____sys_sendmsg+0x1eb/0x250
> [20976.586807]  ___sys_sendmsg+0x7c/0xc0
> [20976.606353]  __sys_sendmsg+0x57/0xa0
> [20976.609930]  do_syscall_64+0x5b/0x1a0
> [20976.613598]  entry_SYSCALL_64_after_hwframe+0x65/0xca
>=20
> 1. Command 'ip link ... set nomaster' causes that ice_plug_aux_dev()
>    is called from ice_service_task() context, aux device is created
>    and associated device->lock is taken.
> 2. Command 'ip link ... set master...' calls ice's notifier under
>    RTNL lock and that notifier calls ice_unplug_aux_dev(). That
>    function tries to take aux device->lock but this is already taken
>    by ice_plug_aux_dev() in step 1
> 3. Later ice_plug_aux_dev() tries to take RTNL lock but this is already
>    taken in step 2
> 4. Dead-lock
>=20
> The patch fixes this issue by following changes:
> - Bit ICE_FLAG_PLUG_AUX_DEV is kept to be set during ice_plug_aux_dev()
>   call in ice_service_task()
> - The bit is checked in ice_clear_rdma_cap() and only if it is not set
>   then ice_unplug_aux_dev() is called. If it is set (in other words
>   plugging of aux device was requested and ice_plug_aux_dev() is
>   potentially running) then the function only clears the bit
> - Once ice_plug_aux_dev() call (in ice_service_task) is finished
>   the bit ICE_FLAG_PLUG_AUX_DEV is cleared but it is also checked
>   whether it was already cleared by ice_clear_rdma_cap(). If so then
>   aux device is unplugged.
>=20
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> Co-developed-by: Petr Oros <poros@redhat.com>
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      | 11 ++++++++++-
>  drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++++++++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index 3121f9b04f59..bea1d1e39fa2 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -898,7 +898,16 @@ static inline void ice_set_rdma_cap(struct ice_pf
> *pf)
>   */
>  static inline void ice_clear_rdma_cap(struct ice_pf *pf)
>  {
> -	ice_unplug_aux_dev(pf);
> +	/* We can directly unplug aux device here only if the flag bit
> +	 * ICE_FLAG_PLUG_AUX_DEV is not set because
> ice_unplug_aux_dev()
> +	 * could race with ice_plug_aux_dev() called from
> +	 * ice_service_task(). In this case we only clear that bit now and
> +	 * aux device will be unplugged later once ice_plug_aux_device()
> +	 * called from ice_service_task() finishes (see ice_service_task()).
> +	 */
> +	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> +		ice_unplug_aux_dev(pf);
> +
>  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
>  	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
>  }
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index 83e3e8aae6cf..493942e910be 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -2255,9 +2255,19 @@ static void ice_service_task(struct work_struct
> *work)
>  		return;
>  	}
>=20
> -	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> +	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
> +		/* Plug aux device per request */
>  		ice_plug_aux_dev(pf);
>=20
> +		/* Mark plugging as done but check whether unplug was
> +		 * requested during ice_plug_aux_dev() call
> +		 * (e.g. from ice_clear_rdma_cap()) and if so then
> +		 * plug aux device.
> +		 */
> +		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf-
> >flags))
> +			ice_unplug_aux_dev(pf);
> +	}
> +
>  	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
>  		struct iidc_event *event;
>=20
> --
> 2.34.1

This only addresses one case of unplugging the auxiliary bus.  Rather than =
controlling one instance of
calling ice_unplig_aux_dev(), it seems like it would be better to modify ic=
e_unplug_aux_dev so that it
will pause until any plugging is done by the service task (check for the pf=
->flag bit and wait until it clears
before progressing).

This way resets, devlink calls, etc would also be controlled from runaway p=
lugging / unplugging of the aux
devices.  This would eliminate the second check in the service task also, s=
ince unplug would not be allowed
to progress until the bit is cleared by the service task.

In an upcoming patch I am making all plugging of the aux devices done in th=
e service task, this would centralize
it and protect it against looping plug/unplug of the auxiliary devices.

