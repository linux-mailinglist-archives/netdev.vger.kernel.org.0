Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3742235A772
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDIT4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:56:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:50145 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhDIT4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:56:19 -0400
IronPort-SDR: f8NeKMoWKkhaBu64Ry/gk0kdlZUQJlX6O+LeOgvzTbGnrqfMltLSTc/FjKAQIdsHGO8Lq9PxoV
 hUYLh45NyRRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="173914106"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="173914106"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:56:06 -0700
IronPort-SDR: p6/J3OJBIl0xALXHjFvy4Sf1fpbDVPvoOxc6SISYNpBSzGpeAAnehg7efw6SAZH/n+HWLXMOfo
 mx6U1FinrCgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="416402280"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 09 Apr 2021 12:56:06 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 12:56:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 9 Apr 2021 12:56:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 9 Apr 2021 12:56:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jI2oL1AmW9xpqn47LAz4lzlMZfSAM6SgCVzLG2Fh+6LS/tL/oTS/s6gFk4c+I+AotcXkxcjxE3Yjr1uVD45iwhVF1Dg+9EH7TyYPtWM2adPVLlK6VEaA40LLbVdSluSgEmMrFtFINjm8FQWNwLfBCftcD2EsiQ7nrE3p68YJ5iNYev+HmZJ6tth4Pkb7e/RzPf5xmvLB7ClS4w3U7zPW6sqWRMRYik0j9LtROV2QouYOSa8skbiJWzJnDMJuWPMaT91oX3/HPiXRfKX9vE3f4t+wI0MrRT3XHDb8EjbW/9CKmibWAqTR4wvHXUBNL5Gu6K1x2uu3AlW6ph87S9qcSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwIBPQ+TCBFSmsJLlGgzkwTA1BbNvJp0ERKigPDRSTc=;
 b=VTOj62U6I/mqeiKcPuLJ/UOiyUkA/kU/9Fx8VEowD40W3jDhHpo7WgJme9I0b0wNkgoyyU8VXCzTJuqSdQcim4Y1eMOgjFNmVgM389MIZsn1E+Bd29zv24F5qTi7QrTDwLntk66fo9JgQWzYnPgukZFP1l0iDllatoweAkmX7wCAxdVqYKD+fKkDr9xPOh6toWJm8t/RFyHHJca3fPBYn7eRg1DaEup0859n6YUyou3grtHDMokUhl7lgU8u3nlIJekY73tHT2zHksorEBEEO4hHnlDkCLLZOtDDsuGJpgiX9IJ+3bEjUhWAzmpbyKYJ5/Iwf3aWXXb/QaKVnvOAHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwIBPQ+TCBFSmsJLlGgzkwTA1BbNvJp0ERKigPDRSTc=;
 b=D6LDuDaTXNnjNf7DycFimWNuHHBLtjPiqsUocZDdSF40qXyGH3QYg6wHKx/2XwdTn5k0V3CM6wDfrtK40D+TNLCM/2qs3/58sDwYFHGSGpdLGkYg6mD+gGR3Db2K/zKqmJn4oL+A3XfFzIZxbGUFPuH9uWNFxq008UbO1DU4LAU=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by CO1PR11MB5026.namprd11.prod.outlook.com (2603:10b6:303:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 19:56:03 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 19:56:03 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Yongxin Liu <yongxin.liu@windriver.com>,
        "vaibhavgupta40@gmail.com" <vaibhavgupta40@gmail.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net] ixgbe: fix unbalanced device enable/disable in
 suspend/resume
Thread-Topic: [PATCH net] ixgbe: fix unbalanced device enable/disable in
 suspend/resume
Thread-Index: AQHXHuuFTZRBCqPfykeVpmQB3jgFbaqstsPA
Date:   Fri, 9 Apr 2021 19:56:03 +0000
Message-ID: <MW3PR11MB47481E32E6F0701CDA1BAD20EB739@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <20210322071448.12023-1-yongxin.liu@windriver.com>
In-Reply-To: <20210322071448.12023-1-yongxin.liu@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.40.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4f68e3c-3717-4b69-a87d-08d8fb9181a9
x-ms-traffictypediagnostic: CO1PR11MB5026:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5026DE5CDE9095289BB2F41FEB739@CO1PR11MB5026.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GDj4b6by13Wz4ImBqNgzW3RPn2X5p30icauJkdV8C0UHi4USXo37ieLgNCyBONtrxa7LLBvFIZEEfUZ9TIJqEo/4i8R4t58U4Dl5s+Z+LebJCj4fW+Tg6Fkke2ZY/OYS9Nf0JfueoA5XuO6Sy663KCtWWqK2ZB2zQS9zqRFv12ZUQig+tVm9DN6r+W2adEAOtd5JcC4tqTp+k/EgbMUoxxLZWzSDxAGjjaYLzczOJayS1c3I+LeItp4+WCcD7D+439owptrb4wbJQ3NuBuuaqnnDenv/pFpVKcoFTV2a19uZNruO8cwB9CT6wfuN51AhDSj066WaCyWcOMAYEH/yT9ft+Dh9+GB2QxTtYPeN2Q1gVKx+2z9lN6vrhxvzgCTgMm9zEScui6GtiXsrU9Phl8WkM1xmoqNz7dJfHMlFnXHypHf8U99aNdmy6z7jSdmdhoq0ChoHOTuODHj1mSDlklVAPZcd5rBNn+0epdARJVHt0uO+B2K4vTmdaNrsfframxL65Yqhmc7VCKUbnV45MUyXOMtDDY0EdP+dwdrd6P6sA3GOLMQdCK/h1rJsG0hnSiJRmqYeVRD/PQkMtQ7MhBESI41SqE45ARKwzBZPEmMhXLxzRL3iWhTiVy1oJBgah7e+6upGQUWXrZcjHQCpr45ceCyfTz6w90Jtk5Ceupw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(52536014)(9686003)(2906002)(83380400001)(64756008)(6506007)(54906003)(66946007)(71200400001)(38100700001)(66476007)(76116006)(66446008)(55016002)(66556008)(5660300002)(33656002)(6636002)(15650500001)(186003)(86362001)(478600001)(8676002)(8936002)(4326008)(7696005)(110136005)(26005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kDK4CaFISRYK57PevkBbYHFdHWQMhjCJIxspA1s0RkV7aZGaDZnYPjzNWHqJ?=
 =?us-ascii?Q?2AK1z5yRpAwf43XGhxlVA/6jZDVsqQCk5dRKGq3G4T3YgLh4LW6gCyslte6Z?=
 =?us-ascii?Q?yKM3rxNpcshyoMTqxCpxZo+BMykdLCFMfa56mzZzdH6QA+KF9aopCmNdgnQc?=
 =?us-ascii?Q?QLQlji/SuNCvpKmIMR5iR1bMSMM9wBf5uqarHVqFWSwE/KudPzbpASkUCqiD?=
 =?us-ascii?Q?qD10JyVCaQzAJS4BOlaVGii16s0fzikRdxaP+KeB5GRl+TpS/IT2rxjlQNTk?=
 =?us-ascii?Q?WXZrNoZpVuTpkd+fK+leXPH+vIvZRJ9b9g3JBGgIR4idkj9XUCGKJbIhn6mq?=
 =?us-ascii?Q?qEW9VMChYVWu3Nfmz5u4RrSJRSyX3jvD8EUwNzMoixwtceiQVZrglb5E/0EA?=
 =?us-ascii?Q?uB2d0R7izA7Lz1B5fJkAQZIo72WML2TFR5p3z0xeXtPR3e8obRJgOib3/dVB?=
 =?us-ascii?Q?Ho4lPamj9u0DIo0J4qW+03j+SaSxGu0lGes+MC1xGLqNrkS2qIXdgWNIj1IZ?=
 =?us-ascii?Q?XZA4CqFTOTM2Z4uKzYCylNwWRvZ5W28i2Y1WuaK3UE9zTN+jKUOGRG3axEUH?=
 =?us-ascii?Q?TcHVjxF2VjD3t69vsiv2eZgadvOhcf3GypOebTPNem13x6MPigQv59A6QeBy?=
 =?us-ascii?Q?hbixyUjeGcvAs7FS0kqF6nuXv/rnAdDlIQ7vyLx9nR81yuZFNQRjyRqtT2PW?=
 =?us-ascii?Q?vz1B4vF52d7zfhnSHQZuYqGgpgHrcDvy18OB5O+MjiqaGubNolUhmDUcixll?=
 =?us-ascii?Q?v4j1a0PG0JT9tXSum9ohvtugIQRQ2Obhmpch4nsMPKLYn92ASDj5C/YyWskX?=
 =?us-ascii?Q?c5+9D1hD4s0V23wntFvHM4sCbrFrysrgBgcPHLdfrznVv24uuXgJD+YkaB5E?=
 =?us-ascii?Q?pZh4VbQYkxAIlHqmne58BaXG2XdW89NK20JAdFV4C+lTCR62wKOq5zVzgoDS?=
 =?us-ascii?Q?/K/GKwnlm7H14nPRkFmgLk4WpntnEd/QCsVKfdj+PxugOexlqg8iGPNB2Uav?=
 =?us-ascii?Q?SKgiC5KoHMc1QpsksOvoI+k8zbDdnNsMFewNJuL3ZlhHiRVIutsOE31zeHIT?=
 =?us-ascii?Q?iBLzQss+sETE0StmLRaTfzq8AELRDIoYJiKIMSA2yJ5Xqkshda8gRq796qvT?=
 =?us-ascii?Q?6wYPG1xbfa+dvXBawFKY7jMmkTF0Ig3PTtjCmAtx/GBQ71KAAL6RCwjkrVc4?=
 =?us-ascii?Q?bIalaSMiOqxKh9jJcAhdogPsovGtDUdeXnCKdQ0BWWJTMzmOy7FRiQ9oKaM0?=
 =?us-ascii?Q?QwyP22F/ExR6Xk3Rmx/VFO96c9Cq5IIFw6pzsjmAO/2bkahDaydOP0/pwHOY?=
 =?us-ascii?Q?Jss=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f68e3c-3717-4b69-a87d-08d8fb9181a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 19:56:03.5999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jEgaZPKYj7+pcWy+sos5LA/v90TvYuByHxJGIrc/Hmy02UDUqebvJULQrQ/d/T8/YDq13HMnvda0FIr2EYdV9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5026
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>-----Original Message-----
>From: Yongxin Liu <yongxin.liu@windriver.com>
>Sent: Monday, March 22, 2021 12:15 AM
>To: vaibhavgupta40@gmail.com; andrewx.bowers@intel.com; Nguyen, Anthony
>L <anthony.l.nguyen@intel.com>
>Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>davem@davemloft.net; Brandeburg, Jesse <jesse.brandeburg@intel.com>; intel=
-
>wired-lan@lists.osuosl.org; kuba@kernel.org
>Subject: [PATCH net] ixgbe: fix unbalanced device enable/disable in
>suspend/resume
>
>pci_disable_device() called in __ixgbe_shutdown() decreases
>dev->enable_cnt by 1. pci_enable_device_mem() which increases enable_cnt
>dev->by 1, was removed from ixgbe_resume() in commit
>6f82b2558735 ("ixgbe: use generic power management"). This caused
>unbalanced increase/decrease. So add pci_enable_device_mem() back.
>
>Fix the following call trace.
>
>  ixgbe 0000:17:00.1: disabling already-disabled device
>  Call Trace:
>   __ixgbe_shutdown+0x10a/0x1e0 [ixgbe]
>   ixgbe_suspend+0x32/0x70 [ixgbe]
>   pci_pm_suspend+0x87/0x160
>   ? pci_pm_freeze+0xd0/0xd0
>   dpm_run_callback+0x42/0x170
>   __device_suspend+0x114/0x460
>   async_suspend+0x1f/0xa0
>   async_run_entry_fn+0x3c/0xf0
>   process_one_work+0x1dd/0x410
>   worker_thread+0x34/0x3f0
>   ? cancel_delayed_work+0x90/0x90
>   kthread+0x14c/0x170
>   ? kthread_park+0x90/0x90
>   ret_from_fork+0x1f/0x30
>
>Fixes: 6f82b2558735 ("ixgbe: use generic power management")
>Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
Tested-by: Dave Switzer <david.switzer@intel.com>

