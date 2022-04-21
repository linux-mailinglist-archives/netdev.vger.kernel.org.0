Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6B50A604
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiDUQn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiDUQn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:43:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBADF40E59;
        Thu, 21 Apr 2022 09:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650559268; x=1682095268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hi1fuLDkkLe8SzQRckm5GJ1QXzhzYd7I8i93pm2NldE=;
  b=b/U68/4YKk5qfe2cIGpJfM5LbzehSvdI8+3UDwatdlhMUMVSGxzeD9OI
   WO/+9MvWVJD3QxJ+IWb73pXLCpfb+ys2VIlRINhkWTzo79pg6qt/2iKrx
   Tc8Vq1kWeHPULl6ELuwQRYhOnPcEFHvfhhb9IWJV8trGM1rD6Zn9M0gk5
   anZLXjX0e1LWcLcAQKUo5b/p1VcwTLBIhQKj3CfBRLZn/MjXTyK8XJolK
   9uGOWp+BSIWSUByHeGSMm0pcx3gvUOrdqhnvUuU6xKxVJWWkNyQWxlUcN
   P8Thg6mn9vsf6y3q/F+UejyRQcBOnvEoO1RSaVOxUH4qNpU6idbPa7hVV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264182841"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="264182841"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 09:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="593737516"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2022 09:41:02 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 09:41:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 09:41:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 09:41:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 09:41:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jkgha04T0posOoSiP8sYLJNS2cT700fI98ST5NG4S5Fya8saBP5r09wjy7OFZo6djkmLT1eYnn0Wx9XsrKg8+V6Z65z3EBHmJFXbUrfDjb6H3JTKdrZfVLWkeVhic4aToKDEaDaHqfApzs0DAQ66Iilw+e3Sbb/Q5csiEP8YEuBaYiw88x0A1Z0bBzFDJENBxhlhgf4sjWDI8MK/DDNMhUlmpzGgMnaJAIen34C+DTM3VJ1I+0hpaNEbQFJ6+SgBuUCEukIQGv89aZyBMpS9U/GMuT/4P00nCVWxC0TKucGQ2dqVIggun9UijIYS+o+1xybGZfUTLoSZSsSAGesNzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2TDL2Ze39z5bPizD9UMHjONLsYQD+SbaFKj/gdk9AI=;
 b=ORio3cTgTdc+YLz5OxbgvqQZC8+zZs+hqxsSTT/t2yfwdtJcB9w+O6yco9Ya5I1ws2c3Rje0n/K/WcfXKiSw1ypfOQIK8jAFLj0BwHHahAEbZWcJ2goBb8kfc3pEuTgh+NzY8Y+1SJUGSj5UVOktOv+//4uMZRvjPVfOUTiVN0N9YKZ0CzfI95WHTzsh470Zc9Ne4IsZ78cv6VBX0MJqgOruPwTmZf7sMTJUoDT5T6NULeT1dXYOyCnvRZujQowXdev426Gwyi3ihM+NUGUqXtr95GwzmbUNyirboLAsOMSi8wE3ciyXd37PzJ7fZm+A0m/Oj3ej5W+aGGFM1BAWIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY4PR11MB1957.namprd11.prod.outlook.com (2603:10b6:903:120::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Thu, 21 Apr
 2022 16:40:59 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::787d:a92b:8a18:e256]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::787d:a92b:8a18:e256%6]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 16:40:59 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Fei Liu <feliu@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt <mschmidt@redhat.com>,
        "Brett Creeley" <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Thread-Topic: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Thread-Index: AQHYU/jzRG+59mH6aU+ZW0d8w4pL+qz6lPZQ
Date:   Thu, 21 Apr 2022 16:40:59 +0000
Message-ID: <CO1PR11MB5089EDB8FE93BA8B8905E889D6F49@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220419142221.2349382-1-ivecera@redhat.com>
In-Reply-To: <20220419142221.2349382-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8999b3d3-c601-401f-c262-08da23b5b755
x-ms-traffictypediagnostic: CY4PR11MB1957:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR11MB1957749A8EC14C763C482EF0D6F49@CY4PR11MB1957.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d2LL1yJv5GMddcXOseMCkpa76TzIVlXUxtObXJvJTd86UhvV+bOUmqCdbStCsJ/uAdkQNK7sS2HLnt2pu4piClad3D2iGYlRGBJKycMuwZUlm6v3LHRxwj3VrNwuccvDJf0bOgtY3kLnvo1tFSuWBNXyX7W4deSugEunWQim3L9+ZJRHB6+UQ7JA2nOQMZDXzQss/5W1zVO8rzyrqh1ueKCi3m4z6nEKwN7fbYwn8+4jDtUk7447xpcPDeDI2oxHlovHc1IHj9j1dquiVjCuQL4It0DohIAO7M2VtJ/mIaek5st7KEK+0FsyrRobvKIaVe7rxh0t2Mj02OtQe5wupVlSNtRg0qB1J5DUCTD/mt/I0ZVa9v8oGrf/2jQjk8hWxgBqnEdSCDLg8XVQCs0W5RGyOgjqZQ2GNggU9UcpHIAH59We31WpQWMQwrfeKRYV65XBW7aEWP+FE41Rmhor947a/oz5+rE/ubgpfoLiI9V0B8DlFUKj04TKqUnnFsp3SfUMiUNOWgyxVGNlgq9PhmPGCH2kp4x7FJp+FFyoNdftPHcYgJ6mwKmLxARJEYkC4E56F21m8prfcvm96rFaoZW7OqB9yw21XC4C+fPOrsk+Fxx5XwwTcsDQYPZO4ecCCYoP/DP8qS7t3bOuv8G/loRnLudFRpurWkTmTN1iIFUkXSU8zYhpnJ15rYgTE61hzyn9lNINf1mSibHJ6lpHVNWUd6lj6QCnDOvMiBFDvj3QIs5IrkZkqNoYQTSRNBCdWbGpKnCfGndJR+J645tYxuZVcJllR/veGipLgjrZckw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(66446008)(64756008)(66556008)(66946007)(8676002)(66476007)(5660300002)(8936002)(110136005)(54906003)(71200400001)(6506007)(7696005)(508600001)(966005)(53546011)(4326008)(33656002)(83380400001)(316002)(76116006)(82960400001)(122000001)(86362001)(2906002)(9686003)(55016003)(38100700002)(38070700005)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XKLGVhZVZsrH07oQZzP/C2PAEJlXFpPPaxHbYLyNQNoUoOoMu3bbs8An4J7q?=
 =?us-ascii?Q?N5mK3reKWP/WysuqZ7n8vyN0ML0In8sa6C9k8b5VrdLeAHwtOLHSR2D35QqJ?=
 =?us-ascii?Q?ozZrOSjX5wZhZadYCEteidyg23QqveUna5E7RxxUOBp4i0kSNL07hn+Serlz?=
 =?us-ascii?Q?d6dLoT4R8GjSeYHpFYGrfUYIN/gSTWycGRaGHCYzDDHEnBcwBcEwwDIOWvLm?=
 =?us-ascii?Q?NEv7Qoe5wDcJYV2A3iTazwryscC74H5GpDDrYbdQD7l6pmu460pcmrRj2Ztd?=
 =?us-ascii?Q?N3ulHD/fEwMJsn0YU1M3+PvrTaMt/oJozAf3ZlgjYwYZeVZZ3/W88mtWk/Pq?=
 =?us-ascii?Q?Y1hnu1P70I6KpVrEmP04/3rvOeUzHL4/4zHQ0QFCRh226Yz9jhWAzfWCQkkH?=
 =?us-ascii?Q?1/kf09yzTWG1qWvlEtaXlhyIVp3Df+Hd9+zPeqvLbVnkxJDL4963ot715Ig0?=
 =?us-ascii?Q?2z9MybdloSilLbZP/7eEbcSRrKmWJn6KcTy4mYWIjAiyEdViMRm/d1h2uDYM?=
 =?us-ascii?Q?1Uo+4kkSqt88WLoHUK29e343waUCvGWfmTtMlmZdaK9wXgDnvRtdxMFh97Ll?=
 =?us-ascii?Q?86aQZlUCeqHS89TrkxNHbGZ0/natn2fMNIenMnd+07qGcl6mpTbDOfKnFtNe?=
 =?us-ascii?Q?iX4xfPSf7v1RF7EHShbI4HlmZ3rMABqVdF0g1JDJb+1FnhmuJTMFlzJsqNFw?=
 =?us-ascii?Q?vfLD6baTnuxmTXaWULsTzOrUuWCs7hWIfZ6Mzb4ZT2cbpxZYgA4XR+lkakFs?=
 =?us-ascii?Q?+pkxXnqw7LryUHh/udOsphvXsrBE5Iukeej6GRgnIxwhg0VLe44nfwty9sr0?=
 =?us-ascii?Q?tM6OSEFrFmKMih3VsKsxTIK/WohGoQy98wf9gWNj1TzQ4m9FpfouMu1FTrnl?=
 =?us-ascii?Q?lrv8nYbsNb+uIEM99JUz6WMu3qYXk+80DJNDk3AA4BRCdIZHC4vQqtJAAXcq?=
 =?us-ascii?Q?FNS7IqtGsp0qDaH9q2W0noIirXnV/VEalM8A4qli9cD0nxOnZ7hdJI+g8bW0?=
 =?us-ascii?Q?GlUzRSQTD8mHrTVvGnBefoKE0YLmTHStbINIJ5GLGKdpQ3+q7wpTa3zoidAe?=
 =?us-ascii?Q?9VZRPNq1P0V5HweLLnW50nTOUGdTUhN/baB4HZyqYWRV89wuOesh+caBbthl?=
 =?us-ascii?Q?CLRNXx/EAMidDIAGMQMKVYzQwFcWiRYtTGbY51LfeG6UzE62/D33aDGc92l5?=
 =?us-ascii?Q?m+OgOvVLBPk6xgVF0dET383FqaLFjG/p7XDpK3xS4943L2alhAo73HLbyvQj?=
 =?us-ascii?Q?ypAq8S6cBm9TWfBe5nE+8atJrstyFwZIdWjMbLq0hOmD7/BC32+goLJocS3k?=
 =?us-ascii?Q?tUdpEKCwws98PegIY9k+YA6c5Pb5n2msrmiu7GljTnFgNs5s9Ll4PQldwgNw?=
 =?us-ascii?Q?1slVHoMFQzhwX87jdEHnUeh4728/J844m+r+1GMJ8Fr7b1pzCfsqddWOGDLx?=
 =?us-ascii?Q?l/X836yoDosP7Fy73yoXwU/z0w0XEAobvnR/n9nwD5nxkhJDsGYp0eci1SvA?=
 =?us-ascii?Q?8SdruN3NGS3Y5smySU018WlS3F5OOcyethFIro1i8i3BAplcGqMGOjsecgXu?=
 =?us-ascii?Q?GQmaQGiTMH5uFEIXHd1ZP9qu0+HacWQN8zLLo6vU36uhzilFeo2DhH2tfrhZ?=
 =?us-ascii?Q?vUz4pedQbtoQMZL2/TKHwHYWAVN2tiOfewEt11nHrDV3r4uTymSXC/4U8R7E?=
 =?us-ascii?Q?n+jI3b+aYev25X1Um3PLrMWm26xjkS6n6bysszqs/r+r5CeJujLCv111qmTm?=
 =?us-ascii?Q?2cwEZCcfFw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8999b3d3-c601-401f-c262-08da23b5b755
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 16:40:59.8093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q1HnYCRZerhYjJsqHEIe7sFYJto+cT7sxAvGN0d/wFar+HO2wUuez2xmgSwOy4NxatY/lFobE7ZmqiOdlpNtHnrmJfK1whQ0FTvszB0b0Zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of I=
van
> Vecera
> Sent: Tuesday, April 19, 2022 7:22 AM
> To: netdev@vger.kernel.org
> Cc: Fei Liu <feliu@redhat.com>; moderated list:INTEL ETHERNET DRIVERS <in=
tel-
> wired-lan@lists.osuosl.org>; mschmidt <mschmidt@redhat.com>; Brett Creele=
y
> <brett.creeley@intel.com>; open list <linux-kernel@vger.kernel.org>; Jaku=
b
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Mil=
ler
> <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check by =
cfg_lock in
> ice_vc_process_vf_msg()
>=20
> Previous patch labelled "ice: Fix incorrect locking in
> ice_vc_process_vf_msg()"  fixed an issue with ignored messages
> sent by VF driver but a small race window still left.
>=20
> Recently caught trace during 'ip link set ... vf 0 vlan ...' operation:
>=20
> [ 7332.995625] ice 0000:3b:00.0: Clearing port VLAN on VF 0
> [ 7333.001023] iavf 0000:3b:01.0: Reset indication received from the PF
> [ 7333.007391] iavf 0000:3b:01.0: Scheduling reset task
> [ 7333.059575] iavf 0000:3b:01.0: PF returned error -5 (IAVF_ERR_PARAM) t=
o our
> request 3
> [ 7333.059626] ice 0000:3b:00.0: Invalid message from VF 0, opcode 3, len=
 4,
> error -1
>=20
> Setting of VLAN for VF causes a reset of the affected VF using
> ice_reset_vf() function that runs with cfg_lock taken:
>=20
> 1. ice_notify_vf_reset() informs IAVF driver that reset is needed and
>    IAVF schedules its own reset procedure
> 2. Bit ICE_VF_STATE_DIS is set in vf->vf_state
> 3. Misc initialization steps
> 4. ice_sriov_post_vsi_rebuild() -> ice_vf_set_initialized() and that
>    clears ICE_VF_STATE_DIS in vf->vf_state
>=20
> Step 3 is mentioned race window because IAVF reset procedure runs in
> parallel and one of its step is sending of VIRTCHNL_OP_GET_VF_RESOURCES
> message (opcode=3D=3D3). This message is handled in ice_vc_process_vf_msg=
()
> and if it is received during the mentioned race window then it's
> marked as invalid and error is returned to VF driver.
>=20
> Protect vf_state check in ice_vc_process_vf_msg() by cfg_lock to avoid
> this race condition.
>=20
> Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling =
and VF
> ndo ops")
> Tested-by: Fei Liu <feliu@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Thanks, this looks good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index 5612c032f15a..b72606c9e6d0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -3625,6 +3625,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struc=
t
> ice_rq_event_info *event)
>  		return;
>  	}
>=20
> +	mutex_lock(&vf->cfg_lock);
> +
>  	/* Check if VF is disabled. */
>  	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
>  		err =3D -EPERM;
> @@ -3648,19 +3650,14 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, str=
uct
> ice_rq_event_info *event)
>  				      NULL, 0);
>  		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d,
> error %d\n",
>  			vf_id, v_opcode, msglen, err);
> -		ice_put_vf(vf);
> -		return;
> +		goto finish;
>  	}
>=20
> -	mutex_lock(&vf->cfg_lock);
> -
>  	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
>  		ice_vc_send_msg_to_vf(vf, v_opcode,
>  				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
> NULL,
>  				      0);
> -		mutex_unlock(&vf->cfg_lock);
> -		ice_put_vf(vf);
> -		return;
> +		goto finish;
>  	}
>=20
>  	switch (v_opcode) {
> @@ -3773,6 +3770,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struc=
t
> ice_rq_event_info *event)
>  			 vf_id, v_opcode, err);
>  	}
>=20
> +finish:
>  	mutex_unlock(&vf->cfg_lock);
>  	ice_put_vf(vf);
>  }
> --
> 2.35.1
>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
