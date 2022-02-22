Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF394BEF5A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiBVCBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:01:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiBVCBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:01:03 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084831EECA;
        Mon, 21 Feb 2022 18:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645495239; x=1677031239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+/7cLdGxq6o5zcnaePHYXGoDkloYXxdAU9CahgFv1o4=;
  b=Oi/4Mjqgf78xQwtVyx8w0eHw7ZgrCu+svL1GAajw10sHhsXiLfKHontF
   2rNbCpNeRF3rSRB9KvbQR3CozkxBEe6y7PiCLHmFbZv0Vv6NUszd+4b4q
   gbD226GCkFf82JetAvNGl1h1zdTKKg6jr5vteuPTKXf0jGStxX4IlqgAI
   1U8P0kUBf7528zwaUhrgmhNizEcIJ6MLaWqBGZCHEZ3SInM9/VBCWeTxp
   2zDL+2dTmSQP+H+ZeueddvtASiCEDAcClxQCiESyqLNnZpd7303gHrDnb
   eAFXtw+adihjDuLaLSe65tW3DeRVFEFJmNgT+sa5fbQvi3nRMkHyitK3Y
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="231561133"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="231561133"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 18:00:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="636832955"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 21 Feb 2022 18:00:30 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 21 Feb 2022 18:00:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 21 Feb 2022 18:00:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 21 Feb 2022 18:00:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnXIeKN8S/d8agex7PkmMbaUNrWzpW4SMxdG4rD1WYAerbMli8Qw+t973AK10FZej9ITsHJm6j4+7uetmT4msy+gALeHD5VPfpfZXeXm6C7ik3vQKEj7VYHWc0BgZyIB5eOGD41O1RdTLPh429GuESwaL28sAioqmna9sg/AilcQB6vR12/E88YvV+WwbMwE35jnEikBSB0pm9LLK4PMD/8hPD4mzUVSqKfqdvmfjYmjRrka1YEKmVLAyH/HHG2oWxIJPFP/AT34e/rSOr99X+E84Wr3jDxMPvrGYBcPlYnh7fYbV7ngYz0bdKXToPN6VTgqeqI8WpdNSMnHl8QjPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8b3K9zOvlxr4nf3YHxJYo2If1QVRf7J/7HANwC0baY=;
 b=KuxQDoupcpxEd5j71vcG8bbOi6ep+Gmg4w9UxYlc3BSlr2wcosNjOEoBZQPxgo1EfVkXLJkBXqVlB9chYSvnMa1XcVdlRGaehCJnkSY8CSQ74Igq2cTvzeZ5/X7fxDd8heD+woGu9SVxJOmnyrUSe2J89a/nJ7mUtr9ZLX3TofdB65tvMTQ/IhMZbYv2FKaoY/8zUSxD0ovzYIbTVkbG5MX8ty9ONDW/8m1q3ART8HRZSCrC9u0xHj2iHe2iv2EJAceefK5vw9QOhjU4Bn3Iwgf81qeyZTp1dtYF2NntKeeDizXI37myyib/XRhwlf/IOsG0MCU/zofxglVgvtySyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2744.namprd11.prod.outlook.com (2603:10b6:a02:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 02:00:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 02:00:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V8 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Thread-Topic: [PATCH V8 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Thread-Index: AQHYJkCIQZYhKgnN9k6QejU5xw8v6Kye002Q
Date:   Tue, 22 Feb 2022 02:00:24 +0000
Message-ID: <BN9PR11MB5276AE8019D9D2482C8972958C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-11-yishaih@nvidia.com>
In-Reply-To: <20220220095716.153757-11-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d135906-6f93-4359-f11d-08d9f5a71711
x-ms-traffictypediagnostic: BYAPR11MB2744:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB2744EFB31CB1D34BFE4357A38C3B9@BYAPR11MB2744.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qM3M4dd4syx8TMehQ2ui/qsYhWOIiNTomsQx2d1c3LkmvgjuLWWM+J6dMGw48nZnVj1ZhUxjRdk2hvsr39VbXIQ6z4I8TlNOl5Ts31EGrmjs7BCFIZrEY9YIeHsGRL1QlUZQWXjPUrofsxdhXzgd/xJ25h04B0krNswCxjcfoO2QKaPJ4ijOECjTw128FVozr1nleCEK0klAe6gPAavuXoOPHNrSV6mUtbaRCdj3iemk8T0aMluHCoDO9NITUuzJpd3sEmLWlM7S0Yv7N5Mc8DxSGBe4jh5umDPoWGRoQf3zJz1KFat/pCmxhFr995L3QhlBmnHFgER0OGSMuLG225RmIgZ6n0DQ2p+OiuP1XTLBwDaTy7lRUjRj+JSWbPiJUx39advfffwg2W0v2kcM5r+g7GMht2Q7RYWplLqbbLEtIP1sDck4tNpkM6fPCLgV6zYKv20gxAD5HPUy6YhD4JBHoYQg4wrX28A5UKiqMYscM51kCEF97wBGuvqr8kMcwHrdxd4z4XHz8A/Bw+we8PztqEwm79mdEoQvb4RqSQFFNMrh7IhsrXSi1gS/4iI/HuA4fJiwUq74rp/SwwNFCCQhl4EM61rqZ3pCT+9bZQ9YPUXTSUFeoyP91i3RJuEOiEsLuQ0bX6Lw4NtO3CASyCp5lyYw8GVEUxuXa63wJ5vdkplexSrshMW+Bl6vTakzavU3h9DJbNujx7UHO8OEcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66476007)(66446008)(66556008)(64756008)(26005)(55016003)(122000001)(82960400001)(186003)(508600001)(7696005)(6506007)(9686003)(76116006)(4326008)(83380400001)(71200400001)(33656002)(110136005)(316002)(54906003)(66946007)(8936002)(2906002)(7416002)(5660300002)(30864003)(38070700005)(38100700002)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O0NI5TpnobKXOSfG/OuvHcihpI6SFtZUeOlsuL618/qVxw0NHksbJxoDcdn0?=
 =?us-ascii?Q?BR0/RDDmwcZ50D8KRi8C0rKbzaxe4KN/dyJdZxfCwV2PeL+mKRxRaxkAufWH?=
 =?us-ascii?Q?nO0XUTEN3xqsuutL5MXngRUMNLEMuaJQ310P8EjBbedXpjywqCEF8G+K0wVf?=
 =?us-ascii?Q?wAV46F0SkEBqrZNme9HdxXonPPNxA575GbX16Q4WT+IfPICeZ/CVhIf3iG7l?=
 =?us-ascii?Q?/nwx/uw5scEiSYpRBKKB6i+JIFTpZyx4D2XLgv2XiamqVr5wrfXNns9raaUI?=
 =?us-ascii?Q?Oo2ZE+1FDu2FFgi4PSiElvUNBuQiN9/AGnNOeBgkZrTvhFD0ktz9EvtT4I30?=
 =?us-ascii?Q?6lX4jf0r7xCeBCl0UgtZj36bzYI5juFqXDgrSYhcAw1+CmkU4pqp/aT/98Mi?=
 =?us-ascii?Q?evy8C0/EKaiiy/4agM6XWdqavqbhmRsgMuw33J1X4xgaj63DGA8+RO8wdsvo?=
 =?us-ascii?Q?/iOiWhGIG7GozTlX39/O0MB3rBMTzovxugNl0D0PEPzkvescKcqxfW15XU+M?=
 =?us-ascii?Q?ogN1aDYqfHw+apDteCdk2w+4MUa3JpHlLgRs4Q4326j1T8uAxpsim2ZKsCQq?=
 =?us-ascii?Q?ZnTGW1n0vNL2DEYuSMYUd+gHtZfTK82yWwA3VpTQjTalxUzDK/K4Um2DIMoJ?=
 =?us-ascii?Q?bp9J4zUw5RlsR3xB0W7X8/CQjUuxSIws9nzLSDsr3vp8i37PjSdn21rJPLgM?=
 =?us-ascii?Q?l6qvkA1lN7IpYfGWSTsFWdoOGwGRPkZ9ktZjKh1VxBG7Z3WXo3U907adWPeA?=
 =?us-ascii?Q?HwYe6250F6adtePPfXflbSmLYyQiHdSLIlI9HQtKrO5CWOHGkmgREmth0Xe7?=
 =?us-ascii?Q?WxkaQH0sV1Hdklv3WIEYcJ7n/CXO5sMdIPb3Sz8UFyP3X9E8aJnQgQdD9YJz?=
 =?us-ascii?Q?4NrtbNwufPJ6qXZn4tkelOWe+AK+9F0oBL5mfVmyPQPgIgJl0hN6QfN5MCR0?=
 =?us-ascii?Q?ZnmR3v+O2uZbhOf4ECUJRBmC9iVrq/UWl6QLwtdFQOPSdf5e/+vDrFAoIO4V?=
 =?us-ascii?Q?VbHb3hJdwp+OuNup5EqX1iFZ6P3BOBKl05r/C0xPNr9x9jICZaCYarkCP2xW?=
 =?us-ascii?Q?pJvepnL1VozvLIDVvhSEdDcyUZ8BId05ZGGMpdZElZ2IivzM8QiKXA9cvYrG?=
 =?us-ascii?Q?x1ZJpi+xoqmDhJwa4JYzrxx8/JQ3cgMjko9up5/a08WI/zPZwUgUC+2ZHpux?=
 =?us-ascii?Q?5lGZ2T9ovPKPJ9j6J6YUA0QoDnlM+budUUQUKs65FRw/C31obSC8WDDIIoN3?=
 =?us-ascii?Q?+jiwaltbj/Lm0mATmdMf10l8ZcSSb89rYJ/HAuGW499IGkf5yp3n9lNpoXlG?=
 =?us-ascii?Q?pjv5g/CShr0UcVmgjKZosN/Tc1nVqEj6vspHc28CSdhsPwXgjmTuKQmKQLsd?=
 =?us-ascii?Q?Q6Ykjl9g+fQtS7qiky8SV/+eY5aB3vKn1PbM1Ai/5etIShWTDDIusboryJCM?=
 =?us-ascii?Q?J0Wa/vHgbZy6OcgthAISFHYLYUKEARuVohqcCe1Nz2B1oiFQINvBC5OJKqiI?=
 =?us-ascii?Q?d8CczoPlkinhPwTMgjsmN04UyS16eWumjEQ1wHstFelufExWCOcNO+hSf+Ec?=
 =?us-ascii?Q?Wy8pEwkNhrDRM+H4yYrVO9kBybjH0wwz8gkrS9UFGaC0jO8PvLsYH2S6UyYd?=
 =?us-ascii?Q?yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d135906-6f93-4359-f11d-08d9f5a71711
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 02:00:24.3468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihqsdB2/bkAVH+NbBINXevc8Og1WJSZREtbwp2DFEuF5Y37z6tBsO2EhcO8LQfOQ9ViOS1e/CdqpsEGs64w1MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2744
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Sunday, February 20, 2022 5:57 PM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> The RUNNING_P2P state is designed to support multiple devices in the same
> VM that are doing P2P transactions between themselves. When in
> RUNNING_P2P
> the device must be able to accept incoming P2P transactions but should no=
t
> generate outgoing P2P transactions.
>=20
> As an optional extension to the mandatory states it is defined as
> inbetween STOP and RUNNING:
>    STOP -> RUNNING_P2P -> RUNNING -> RUNNING_P2P -> STOP
>=20
> For drivers that are unable to support RUNNING_P2P the core code
> silently merges RUNNING_P2P and RUNNING together. Unless driver support
> is present, the new state cannot be used in SET_STATE.
> Drivers that support this will be required to implement 4 FSM arcs
> beyond the basic FSM. 2 of the basic FSM arcs become combination
> transitions.
>=20
> Compared to the v1 clarification, NDMA is redefined into FSM states and i=
s
> described in terms of the desired P2P quiescent behavior, noting that
> halting all DMA is an acceptable implementation.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c       | 84 +++++++++++++++++++++++++++++++--------
>  include/linux/vfio.h      |  1 +
>  include/uapi/linux/vfio.h | 36 ++++++++++++++++-
>  3 files changed, 102 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index b37ab27b511f..bdb5205bb358 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1577,39 +1577,55 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  			    enum vfio_device_mig_state new_fsm,
>  			    enum vfio_device_mig_state *next_fsm)
>  {
> -	enum { VFIO_DEVICE_NUM_STATES =3D
> VFIO_DEVICE_STATE_RESUMING + 1 };
> +	enum { VFIO_DEVICE_NUM_STATES =3D
> VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
>  	/*
> -	 * The coding in this table requires the driver to implement 6
> +	 * The coding in this table requires the driver to implement
>  	 * FSM arcs:
>  	 *         RESUMING -> STOP
> -	 *         RUNNING -> STOP
>  	 *         STOP -> RESUMING
> -	 *         STOP -> RUNNING
>  	 *         STOP -> STOP_COPY
>  	 *         STOP_COPY -> STOP
>  	 *
> -	 * The coding will step through multiple states for these combination
> -	 * transitions:
> -	 *         RESUMING -> STOP -> RUNNING
> +	 * If P2P is supported then the driver must also implement these FSM
> +	 * arcs:
> +	 *         RUNNING -> RUNNING_P2P
> +	 *         RUNNING_P2P -> RUNNING
> +	 *         RUNNING_P2P -> STOP
> +	 *         STOP -> RUNNING_P2P
> +	 * Without P2P the driver must implement:
> +	 *         RUNNING -> STOP
> +	 *         STOP -> RUNNING
> +	 *
> +	 * If all optional features are supported then the coding will step
> +	 * through multiple states for these combination transitions:
> +	 *         RESUMING -> STOP -> RUNNING_P2P
> +	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
>  	 *         RESUMING -> STOP -> STOP_COPY
> -	 *         RUNNING -> STOP -> RESUMING
> -	 *         RUNNING -> STOP -> STOP_COPY
> +	 *         RUNNING -> RUNNING_P2P -> STOP
> +	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
> +	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
> +	 *         RUNNING_P2P -> STOP -> RESUMING
> +	 *         RUNNING_P2P -> STOP -> STOP_COPY
> +	 *         STOP -> RUNNING_P2P -> RUNNING
>  	 *         STOP_COPY -> STOP -> RESUMING
> -	 *         STOP_COPY -> STOP -> RUNNING
> +	 *         STOP_COPY -> STOP -> RUNNING_P2P
> +	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
>  	 */
>  	static const u8
> vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STA
> TES] =3D {
>  		[VFIO_DEVICE_STATE_STOP] =3D {
>  			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> -			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP_COPY,
>  			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_RUNNING] =3D {
> -			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_RUNNING,
> -			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP,
> -			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_STOP_COPY] =3D {
> @@ -1617,6 +1633,7 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP_COPY,
>  			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_RESUMING] =3D {
> @@ -1624,6 +1641,15 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING_P2P] =3D {
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_ERROR] =3D {
> @@ -1631,17 +1657,41 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_ERROR,
>  			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_ERROR,
>  			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> VFIO_DEVICE_STATE_ERROR,
>  			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
>  		},
>  	};
>=20
> -	if (WARN_ON(cur_fsm >=3D ARRAY_SIZE(vfio_from_fsm_table)))
> +	static const unsigned int
> state_flags_table[VFIO_DEVICE_NUM_STATES] =3D {
> +		[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_MIGRATION_STOP_COPY,
> +		[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_MIGRATION_STOP_COPY,
> +		[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_MIGRATION_STOP_COPY,
> +		[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_MIGRATION_STOP_COPY,
> +		[VFIO_DEVICE_STATE_RUNNING_P2P] =3D
> +			VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P,
> +		[VFIO_DEVICE_STATE_ERROR] =3D ~0U,
> +	};
> +
> +	if (WARN_ON(cur_fsm >=3D ARRAY_SIZE(vfio_from_fsm_table) ||
> +		    (state_flags_table[cur_fsm] & device->migration_flags) !=3D
> +			state_flags_table[cur_fsm]))
>  		return -EINVAL;
>=20
> -	if (new_fsm >=3D ARRAY_SIZE(vfio_from_fsm_table))
> +	if (new_fsm >=3D ARRAY_SIZE(vfio_from_fsm_table) ||
> +	   (state_flags_table[new_fsm] & device->migration_flags) !=3D
> +			state_flags_table[new_fsm])
>  		return -EINVAL;
>=20
> +	/*
> +	 * Arcs touching optional and unsupported states are skipped over.
> The
> +	 * driver will instead see an arc from the original state to the next
> +	 * logical state, as per the above comment.
> +	 */
>  	*next_fsm =3D vfio_from_fsm_table[cur_fsm][new_fsm];
> +	while ((state_flags_table[*next_fsm] & device->migration_flags) !=3D
> +			state_flags_table[*next_fsm])
> +		*next_fsm =3D vfio_from_fsm_table[*next_fsm][new_fsm];
> +
>  	return (*next_fsm !=3D VFIO_DEVICE_STATE_ERROR) ? 0 : -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
> @@ -1731,7 +1781,7 @@ static int
> vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  					       size_t argsz)
>  {
>  	struct vfio_device_feature_migration mig =3D {
> -		.flags =3D VFIO_MIGRATION_STOP_COPY,
> +		.flags =3D device->migration_flags,
>  	};
>  	int ret;
>=20
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 3bbadcdbc9c8..3176cb5d4464 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -33,6 +33,7 @@ struct vfio_device {
>  	struct vfio_group *group;
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
> +	unsigned int migration_flags;
>=20
>  	/* Members below here are private, not for driver use */
>  	refcount_t refcount;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 02b836ea8f46..46b06946f0a8 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1010,10 +1010,16 @@ struct vfio_device_feature {
>   *
>   * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
>   * RESUMING are supported.
> + *
> + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that
> RUNNING_P2P
> + * is supported in addition to the STOP_COPY states.
> + *
> + * Other combinations of flags have behavior to be defined in the future=
.
>   */
>  struct vfio_device_feature_migration {
>  	__aligned_u64 flags;
>  #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +#define VFIO_MIGRATION_P2P		(1 << 1)
>  };
>  #define VFIO_DEVICE_FEATURE_MIGRATION 1
>=20
> @@ -1064,10 +1070,13 @@ struct vfio_device_feature_mig_state {
>   *  RESUMING - The device is stopped and is loading a new internal state
>   *  ERROR - The device has failed and must be reset
>   *
> + * And 1 optional state to support VFIO_MIGRATION_P2P:
> + *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer
> DMA
> + *
>   * The FSM takes actions on the arcs between FSM states. The driver
> implements
>   * the following behavior for the FSM arcs:
>   *
> - * RUNNING -> STOP
> + * RUNNING_P2P -> STOP
>   * STOP_COPY -> STOP
>   *   While in STOP the device must stop the operation of the device. The
> device
>   *   must not generate interrupts, DMA, or any other change to external =
state.
> @@ -1094,11 +1103,16 @@ struct vfio_device_feature_mig_state {
>   *
>   *   To abort a RESUMING session the device must be reset.
>   *
> - * STOP -> RUNNING
> + * RUNNING_P2P -> RUNNING
>   *   While in RUNNING the device is fully operational, the device may
> generate
>   *   interrupts, DMA, respond to MMIO, all vfio device regions are funct=
ional,
>   *   and the device may advance its internal state.
>   *
> + * RUNNING -> RUNNING_P2P
> + * STOP -> RUNNING_P2P
> + *   While in RUNNING_P2P the device is partially running in the P2P
> quiescent
> + *   state defined below.
> + *
>   * STOP -> STOP_COPY
>   *   This arc begin the process of saving the device state and will retu=
rn a
>   *   new data_fd.
> @@ -1128,6 +1142,18 @@ struct vfio_device_feature_mig_state {
>   *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
>   *   device_state back to RUNNING.
>   *
> + * The optional peer to peer (P2P) quiescent state is intended to be a
> quiescent
> + * state for the device for the purposes of managing multiple devices wi=
thin
> a
> + * user context where peer-to-peer DMA between devices may be active.
> The
> + * RUNNING_P2P states must prevent the device from initiating
> + * any new P2P DMA transactions. If the device can identify P2P transact=
ions
> + * then it can stop only P2P DMA, otherwise it must stop all DMA. The
> migration
> + * driver must complete any such outstanding operations prior to
> completing the
> + * FSM arc into a P2P state. For the purpose of specification the states
> + * behave as though the device was fully running if not supported. Like
> while in
> + * STOP or STOP_COPY the user must not touch the device, otherwise the
> state
> + * can be exited.
> + *
>   * The remaining possible transitions are interpreted as combinations of=
 the
>   * above FSM arcs. As there are multiple paths through the FSM arcs the
> path
>   * should be selected based on the following rules:
> @@ -1140,6 +1166,11 @@ struct vfio_device_feature_mig_state {
>   * fails. When handling these types of errors users should anticipate fu=
ture
>   * revisions of this protocol using new states and those states becoming
>   * visible in this case.
> + *
> + * The optional states cannot be used with SET_STATE if the device does =
not
> + * support them. The user can discover if these states are supported by
> using
> + * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions
> the user can
> + * avoid knowing about these optional states if the kernel driver suppor=
ts
> them.
>   */
>  enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_ERROR =3D 0,
> @@ -1147,6 +1178,7 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING =3D 2,
>  	VFIO_DEVICE_STATE_STOP_COPY =3D 3,
>  	VFIO_DEVICE_STATE_RESUMING =3D 4,
> +	VFIO_DEVICE_STATE_RUNNING_P2P =3D 5,
>  };
>=20
>  /* -------- API for Type1 VFIO IOMMU -------- */
> --
> 2.18.1

