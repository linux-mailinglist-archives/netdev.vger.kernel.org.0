Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584303BC7A2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhGFIJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:09:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:26594 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhGFIJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 04:09:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="196356820"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="196356820"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 01:07:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="422761826"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jul 2021 01:07:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 01:07:05 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 01:07:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 6 Jul 2021 01:07:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 6 Jul 2021 01:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSA+QrSDjOgJyGbDJALLwLN+R2xGlBkBE60IAwqInLCdXxx6RXj4a1NRv68q6lhXgMuqZ5Ml3+qbqJ76sxbxoNxzkkoejwsKEFxTd8zrPlfVEpclTfS5IENm5qJhPaHgr+DnAfsAn5mDbTgACdPmOSH/vbhDb8uZSCaLM+5XITD+A+QVCCZ0rUamhiKGgYnCfEG4hMjkS1YZXhnt527WTJiz42KwQss8UJczpy4KiQOPIb3uvqnS+G3PX0HwnENj2Ra3oX0XRFZjl9qvqO9io3NmiGrIbejudfS+bc8Z/gjmpz3tJwKZcFZf2kgLDz4TI7FNTLusvxtiT+43Tk0jBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RQGuoEq8NuDjn16zJQHVQV2X19YO8nK6f2I2njFwak=;
 b=TLI0hCS7u7VDgpRFEQG8VHUsp3rb5/9QBVgBuDti4WNkI4FalZv7Rsxm5kYfAPOSBLzzVJkAiKoYjq4AYk49zJ6i2N/jtVhHcPzOSvK9bYhzraBfgrsieNGLFXZFNnTsiVmrRjFPoLL25WKQ0KBDajwqGfxJdODuSqIDVZwAOO+pMYLdRQzEjcQb4bxx9UfFjDeTSyaCzY4ijyg7Uvpv5fTzhxc4QPBC7KuPc1HyKN8uTNK8eOPBt2GirHCBCEF8oOxe4LtphpxkEQiiekhOBzcZHDwTXHO2lKhbseaMkIMtvyb/vLDXoHkPNVsPhpSXkji8Pen3fDrsveJJmsUVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RQGuoEq8NuDjn16zJQHVQV2X19YO8nK6f2I2njFwak=;
 b=GYFXYQZMylGdHiToHE6sM2l8u9tA8phz/UgqhUUn29bC14Z/QBK3+E2yHwhCnDWp45rtQ3HQ0V6fYYDR36kQEtq3YCU26mMhmQDbsQiL2gK2jjQjEMjUIyaiSzKYwX6cc9VyUrDJbWUP5xG7uZeAfDRY9lzDL98P5GxRBcfgR3c=
Received: from CY4PR11MB1576.namprd11.prod.outlook.com (2603:10b6:910:d::15)
 by CY4PR1101MB2262.namprd11.prod.outlook.com (2603:10b6:910:18::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Tue, 6 Jul
 2021 08:07:03 +0000
Received: from CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::b1bd:33e5:3890:e999]) by CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::b1bd:33e5:3890:e999%6]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 08:07:03 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Laba, SlawomirX" <slawomirx.laba@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] iavf: fix locking of critical sections
Thread-Topic: [Intel-wired-lan] [PATCH] iavf: fix locking of critical sections
Thread-Index: AQHXGkuHFKGC6SACr0e2u/mNFyyEyqs2Rx7w
Date:   Tue, 6 Jul 2021 08:07:03 +0000
Message-ID: <CY4PR11MB1576DF9D75817184274CAFC0AB1B9@CY4PR11MB1576.namprd11.prod.outlook.com>
References: <20210316100141.53551-1-sassmann@kpanic.de>
In-Reply-To: <20210316100141.53551-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [188.147.96.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9f35f8e-c7cd-45c9-3fb7-08d940550a1a
x-ms-traffictypediagnostic: CY4PR1101MB2262:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2262428A4D62CBAC0CB39282AB1B9@CY4PR1101MB2262.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:95;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TnDj3cil2i6fhnhUibGi5DGAWIpWr32FNKmsDmSi6Wvy6KXPXb070T6BC3IVKLBImNsUot2/FVjdWV4CZ/3JgQB5gC5UbUHRvG0zD6ReCu2JNkseEKu6BFTJ8Bf5zgyDRYLYj4F7uTuQ0Jc9+oPTUbQuKlG9EveU2M7uXTsNL7+jDfZwQCENkV/Ctgaj5p0a6nArxQNHaKwiP2VuW3nSG9mZpB92p/N480rlrt8EP2YVHOrHQd9oY24NCJrZAGMkiKf5YXG8+R8xCUZzQmt7vbtNJHX9Esg4wyOb50elmQ8lkpW03HidaBIZq77CJRYOJCFTMDl8nhLnfzeHJC28ztNxd4WgBTElSra2OGlpe2Lp7P3bG0ZIZvW9/lP37EDLVFSKYCWv/BkG5fjql0Cl5gpywJ+pplzwXUmoxHWk/X+0XliwiDUffM2bp6wmaAsr1/D5wVcvM0SoIf5AjfyCZiVe7RyopCtEOzFpCfVD2MEQh8itdxjtSSO8yc/tUfzqJzfaTmVu38CIaycwZnw0Hnty72/b633QNvWiEpFu2m6fch6PqUl5VC6cUtkSmnhVRHNURaG45qywjoEFp8th9SrDjtQichqvUT62C8AKG0m+th7NlxW0XKw4XBB0uY80Z0zYygMLQXlqq82tYEmnVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1576.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(66476007)(38100700002)(76116006)(66446008)(71200400001)(9686003)(122000001)(66556008)(5660300002)(53546011)(2906002)(86362001)(316002)(83380400001)(6506007)(64756008)(7696005)(8936002)(33656002)(186003)(55016002)(54906003)(110136005)(4326008)(66946007)(26005)(478600001)(52536014)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bwALsj9YiS13Azi+yy6Y6qvWQn7gV37WlUs3zDiZM5tmsyhf9vqHb2jiGRj9?=
 =?us-ascii?Q?JHhh3Mo82pM0DHhpBc67dRC3ebiKzwdp3wCAjB/dRRKbAefSMRyanY11ZHm9?=
 =?us-ascii?Q?b3ykbZA6Dum1LlV5UxyF0xmSU9DviM0MCvIjs4UEDKJn0C7DRVahtt+T9+w4?=
 =?us-ascii?Q?tRM0PFerKZXoDHePEoW6BcPJbWnYZ3+YvwLbYvVfG2C0nOfGFi2CIpr+JEDY?=
 =?us-ascii?Q?lVgOdlf/yv8Gctz1dakq7tSX4dUen7Lk/SQb5Zm4/7OCATzKiOBGFNZb25/r?=
 =?us-ascii?Q?YUc1JEm/D6B4SB9k3dk7Ncd8xeJpG4BsRQ5R0BpjBo0t+QqvPxCznw8Ex0x8?=
 =?us-ascii?Q?cUqWhpYUq2FdjTpM8sbcdAqKo1VeDKMwdMjHT11ZR2HeY87MpHTuNa3vWZ2K?=
 =?us-ascii?Q?+lqLpDwiXCFKfW5eNSwlZymUQjMTSzVOK0TejEnijMu3LTAFMEF7gPVajh0E?=
 =?us-ascii?Q?ox7+JJWlSrVpP7tuMRCJG+VQoTZ+NIcr5L+aNQhnK0Xlh3Cwyl1zip1fLka2?=
 =?us-ascii?Q?BYU4lDNVYKNRoBlcTArTZJ9Ty1AvuRHWB17CTlXnYEUEEWncp3N6w/29bPTT?=
 =?us-ascii?Q?eNkC0iDQjV8uH60bQosfli88eh/xkXfgk0M78REJy4hRh+sMEZuBkXx6hDfM?=
 =?us-ascii?Q?6Gtwj0aBJYLY+N+26qfzUlqi9s5LexxK4gWoaREmU4DS/djS5epuJdqybWXI?=
 =?us-ascii?Q?otBy49mMRH1Cdn5hhG6xlMDJMlXFo+usBUlHuz7/p6AChqq6giFZ7JzvHO1J?=
 =?us-ascii?Q?kTWNP8vUzhh3/YrDVqqTjL3u7PWE+cxFojYpvSUUIiqOY0ZpgTszQVKS0bv3?=
 =?us-ascii?Q?VfW0CKr7141drGPvUtxdoKWnsnhr9u5tOu8ok2NupoBio0Iw3YwQiuaej+A3?=
 =?us-ascii?Q?rEZ1Isv9Q4O6U2sJo1tw4OV3EhKIPTnpsafAFaAFcinajGrIJORRjqiFvS3+?=
 =?us-ascii?Q?HSR0mbrL3OJAsIaQp7EHR5hSbhcujnhVRBHRPRpmOlIcdVLBS8sGLxtB5ces?=
 =?us-ascii?Q?7wlktLI2p98c7uatmgM1fJFFBHgvvwjtuZoyom4g4govsmkSZwG5jwps4ka+?=
 =?us-ascii?Q?Yb1l4tNIYwuTya2yNsNbvovJIZ5RLlumGgaIa+Y3xPrz3EOWnMSnUg6gAPP2?=
 =?us-ascii?Q?Tb9OUJxYKqhJ5uN++gWWuALLjsCsFiuAVbEyuQyelUrDIhct2ko0rbEABsgO?=
 =?us-ascii?Q?PLI1fDtaJ5mxxtEgv6XIo9DbWi2afEJgIE37JXjxUBBvK8ROvdorVAMUUeWH?=
 =?us-ascii?Q?bgL3uvtnt6mfznnkrvgttYtj1ImKaJtTO/wFZfzD0p0/msu/afVjhgfAr8ro?=
 =?us-ascii?Q?INxDsmdQxlyaRofBXwfjK5yI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1576.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f35f8e-c7cd-45c9-3fb7-08d940550a1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2021 08:07:03.4316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0phu7hhz+CkU6Hqx+Bw2hep3+ATZ/vJ5kmP4vVLpWWaquC/5N11XJT3xf3axECOFW0q1Tl5iDogPhuI287CRnw3fvqV09E+aVTqud+bt7pM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2262
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Stefan Assmann
> Sent: wtorek, 16 marca 2021 11:02
> To: intel-wired-lan@lists.osuosl.org
> Cc: Laba, SlawomirX <slawomirx.laba@intel.com>; netdev@vger.kernel.org;
> sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] iavf: fix locking of critical sections
>=20
> To avoid races between iavf_init_task(), iavf_reset_task(),
> iavf_watchdog_task(), iavf_adminq_task() as well as the shutdown and
> remove functions more locking is required.
> The current protection by __IAVF_IN_CRITICAL_TASK is needed in additional
> places.
>=20
> - The reset task performs state transitions, therefore needs locking.
> - The adminq task acts on replies from the PF in
>   iavf_virtchnl_completion() which may alter the states.
> - The init task is not only run during probe but also if a VF gets stuck
>   to reinitialize it.
> - The shutdown function performs a state transition.
> - The remove function perorms a state transition and also free's
>   resources.
>=20
> iavf_lock_timeout() is introduced to avoid waiting infinitely and cause a
> deadlock. Rather unlock and print a warning.
>=20
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 57 ++++++++++++++++++---
>  1 file changed, 50 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index dc5b3c06d1e0..538b7aa43fa5 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -131,6 +131,30 @@ enum iavf_status iavf_free_virt_mem_d(struct
> iavf_hw *hw,
>  	return 0;
>  }
>=20
> +/**
> + * iavf_timeout - try to set bit but give up after timeout
> + * @adapter: board private structure
> + * @bit: bit to set
> + * @msecs: timeout in msecs
> + *
> + * Returns 0 on success, negative on failure  **/ static inline int
> +iavf_lock_timeout(struct iavf_adapter *adapter,
> +				    enum iavf_critical_section_t bit,
> +				    unsigned int msecs)
> +{
> +	unsigned int wait, delay =3D 10;
> +
> +	for (wait =3D 0; wait < msecs; wait +=3D delay) {
> +		if (!test_and_set_bit(bit, &adapter->crit_section))
> +			return 0;
> +
> +		msleep(delay);
> +	}
> +
> +	return -1;
> +}
> +
>  /**
>   * iavf_schedule_reset - Set the flags and schedule a reset event
>   * @adapter: board private structure
> @@ -2069,6 +2093,10 @@ static void iavf_reset_task(struct work_struct
> *work)
>  	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
>  		return;
>=20
> +	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200)) {
> +		schedule_work(&adapter->reset_task);
> +		return;
> +	}
>  	while (test_and_set_bit(__IAVF_IN_CLIENT_TASK,
>  				&adapter->crit_section))
>  		usleep_range(500, 1000);
> @@ -2275,6 +2303,8 @@ static void iavf_adminq_task(struct work_struct
> *work)
>  	if (!event.msg_buf)
>  		goto out;
>=20
> +	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200))
> +		goto freedom;
>  	do {
>  		ret =3D iavf_clean_arq_element(hw, &event, &pending);
>  		v_op =3D (enum
> virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
> @@ -2288,6 +2318,7 @@ static void iavf_adminq_task(struct work_struct
> *work)
>  		if (pending !=3D 0)
>  			memset(event.msg_buf, 0,
> IAVF_MAX_AQ_BUF_SIZE);
>  	} while (pending);
> +	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
>=20
>  	if ((adapter->flags &
>  	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
> @@ -3590,6 +3621,10 @@ static void iavf_init_task(struct work_struct
> *work)
>  						    init_task.work);
>  	struct iavf_hw *hw =3D &adapter->hw;
>=20
> +	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000)) {
> +		dev_warn(&adapter->pdev->dev, "failed to set
> __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
> +		return;
> +	}
>  	switch (adapter->state) {
>  	case __IAVF_STARTUP:
>  		if (iavf_startup(adapter) < 0)
> @@ -3602,14 +3637,14 @@ static void iavf_init_task(struct work_struct
> *work)
>  	case __IAVF_INIT_GET_RESOURCES:
>  		if (iavf_init_get_resources(adapter) < 0)
>  			goto init_failed;
> -		return;
> +		goto out;
>  	default:
>  		goto init_failed;
>  	}
>=20
>  	queue_delayed_work(iavf_wq, &adapter->init_task,
>  			   msecs_to_jiffies(30));
> -	return;
> +	goto out;
>  init_failed:
>  	if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
>  		dev_err(&adapter->pdev->dev,
> @@ -3618,9 +3653,11 @@ static void iavf_init_task(struct work_struct
> *work)
>  		iavf_shutdown_adminq(hw);
>  		adapter->state =3D __IAVF_STARTUP;
>  		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
> -		return;
> +		goto out;
>  	}
>  	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
> +out:
> +	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
>  }
>=20
>  /**
> @@ -3637,9 +3674,12 @@ static void iavf_shutdown(struct pci_dev *pdev)
>  	if (netif_running(netdev))
>  		iavf_close(netdev);
>=20
> +	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
> +		dev_warn(&adapter->pdev->dev, "failed to set
> __IAVF_IN_CRITICAL_TASK
> +in %s\n", __FUNCTION__);
>  	/* Prevent the watchdog from running. */
>  	adapter->state =3D __IAVF_REMOVE;
>  	adapter->aq_required =3D 0;
> +	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
>=20
>  #ifdef CONFIG_PM
>  	pci_save_state(pdev);
> @@ -3866,10 +3906,6 @@ static void iavf_remove(struct pci_dev *pdev)
>  				 err);
>  	}
>=20
> -	/* Shut down all the garbage mashers on the detention level */
> -	adapter->state =3D __IAVF_REMOVE;
> -	adapter->aq_required =3D 0;
> -	adapter->flags &=3D ~IAVF_FLAG_REINIT_ITR_NEEDED;
>  	iavf_request_reset(adapter);
>  	msleep(50);
>  	/* If the FW isn't responding, kick it once, but only once. */ @@ -
> 3877,6 +3913,13 @@ static void iavf_remove(struct pci_dev *pdev)
>  		iavf_request_reset(adapter);
>  		msleep(50);
>  	}
> +	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
> +		dev_warn(&adapter->pdev->dev, "failed to set
> __IAVF_IN_CRITICAL_TASK
> +in %s\n", __FUNCTION__);
> +
> +	/* Shut down all the garbage mashers on the detention level */
> +	adapter->state =3D __IAVF_REMOVE;
> +	adapter->aq_required =3D 0;
> +	adapter->flags &=3D ~IAVF_FLAG_REINIT_ITR_NEEDED;
>  	iavf_free_all_tx_resources(adapter);
>  	iavf_free_all_rx_resources(adapter);
>  	iavf_misc_irq_disable(adapter);
> --
> 2.29.2

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>

