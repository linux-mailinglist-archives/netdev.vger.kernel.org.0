Return-Path: <netdev+bounces-11319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA52F73297D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 098CC1C20F7B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06E9944E;
	Fri, 16 Jun 2023 08:06:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD376AD22
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:06:27 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1961FD7;
	Fri, 16 Jun 2023 01:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686902785; x=1718438785;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CP9+6COdbCHr3IKIpWffUbLq8dRtkAikqouBCZciSM4=;
  b=eNgeVFbk09P5iCM7x4wL9rcsRCxd6g4wHDH30YVKTva+dUqYkxlmCBEk
   zkxBCDXEIXVSAoNZfnpOytt0rtOVS5n2g3HCpyX+INbyVu86QZT7bdvOw
   SLKq7Dve7TTtTG/mQ7ZNjJ6+V+3fX+kKlzY2jdtejHQZIAFv+vDlfBPFu
   PFIls1mWBPyHQLzi4pN7CnQ7qZhNYIrGsb9xE5HhUbMrvMhV+aMUxLveB
   NgBXsMveM7Ww6BLWDHtyzP2LS3QsC1YVybZKYGz8A4HlhQoOHx4zDgcAU
   JMIJrfopEUBIXkPHdmBO7q0kMZxiQmdkKaAdwxW0D4NazU/+gWsRiLAPW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="425094827"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="425094827"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:06:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="857291468"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="857291468"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jun 2023 01:06:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:06:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 01:06:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 01:06:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/ECnypuiPNvlHsw+APJ6PYIQ0XfrqxxzSXB2H4/p36Qcll1ENa1HCQqM15aJ9LLM87Bqemvd7C38/JW4iR23cAnW9E0tdfectjdwJhIn7v1GGXGK+YjaJh8jVgWuzNTJzeRFnXbicFQsm6BnH87KRixnfFwg3KNIvQ/Q/IHi4gaAnOyo/4Xp2hFdJWag/fkCvog4/IaY0HYDqsIr2lCS82B8Zgw9mgLUHudGADtHoFVpTAwNJFvDDp8ZiBbOU/aJSXwU0Lxmr+9iqqrKP8MpPQsY0MNmsOufNj95IN62+r6Yzau7LHhDjvM2KQ9EprCn6lTkgPFTDy28swpHunxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QllZzOQIfE2zwfsTiIp8rDjQIdl9wFUp+KdhWo6NR/0=;
 b=EF5iZAcX8SVzOe50z0yMRNq75SabOaTbeZKNXkIrsRkjfhX/UpHt9qaIzBnhaOye1U9sMDxl3nRiRu+vRKAJlTqJNU/Jr9hj9J3z09dZ4+JwqY3GMGlfMPSBaGX5QbMMZmwG7Y/wjhQ4Wjw750nGHlK3EAW4Eg4aO8ubRQTf6/6Wr/3nF5kltDlgoSULypWXeMPXjIRLz1GQN1HXPB2wR4Z3MAeAdk2luPLxevK4K0oN6Q7qWTuv4qeLZls2TdoKdROZK/OI1PYPSE1ADql1UzogDuvHCRPi4aCBPGCjLWcOJvaaH23anwld5gFb6nWQ+ColtvP49qMuZyrXn14+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4686.namprd11.prod.outlook.com (2603:10b6:806:97::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 08:06:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 08:06:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZlZ4kU3Fwl99xbECsoSBHo1JwW6+NFosQ
Date: Fri, 16 Jun 2023 08:06:21 +0000
Message-ID: <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-5-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4686:EE_
x-ms-office365-filtering-correlation-id: b4da5218-dec6-40bc-29d3-08db6e409241
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kWJbu1B4Xe+huH68cR68dikIr/QVZCWwrWOb2ItvxL9MoFyRUIpRuEvHTNFStENOd6CYpxUG1HyGpSkwwCBdm7uA3n8mgz75CyTSSwGTdXO7OY5s2s4YE9zFIfxPaLn/2ukjS8kZgTdbt9SQf6eAzGnWAdIg6Lp7TMCt6ZQao1XZhggcqc2FzWVZaMIju2Qov82/ZloY6LbQS2mE6Q4hGghPwvELmFUj6TsKhzeBBXBAcqmTI1oKzDHv4gf+G7pZ/3lvL6VO0Rew2Q43YEvRLYw68IRotfbfO1MFJjPdXk7VyIRKADXaxrmBSK5tqYZ87xjUqRB1TavkzEhqa3YvDgZOt/6X0CEuUwZkFGDq9xguUSlUxxnmInDdbK4ubz2+uzSB8EI59pbvUWCIXOIZ/Ghqb8GyVFKtc+rmAgzcQzepeMVMaXD+X+DexQI9jaMeQM+rRpWp+Qs+4kQ4gYhdbQdwo0PRGnMaEx1TQBbx6eqNvpZyC4Vd+AR3qlFkvjrbzWVaHPHL0Sg6/snFvDhxToE0XSn8+UJUuxH13UAIOAGOQWm/dY00o3sZyRsZRN4V/mmd5f3pPl8MhND2qRapF2zmaQLgxl/NHhuSi1am8nwSu0pnS7jLdH+laA5N0XXF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(8676002)(122000001)(83380400001)(66476007)(55016003)(7696005)(64756008)(71200400001)(26005)(9686003)(76116006)(6506007)(110136005)(5660300002)(186003)(86362001)(478600001)(2906002)(52536014)(33656002)(4326008)(38070700005)(316002)(41300700001)(38100700002)(66446008)(82960400001)(66556008)(66946007)(8936002)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HRXSaeBAyXND5QJsGB7CWqN84SIHZeIQHqVCixhqK1l1opml4jedph6H6xB/?=
 =?us-ascii?Q?nLc6aHy9ljqDU5em7p54Td4njM0HdN1DElKlvFNnRbvbolVqP+u41F/Zhhed?=
 =?us-ascii?Q?Nyl7IcwOhiMdwqV6sO6z3Yx9IJQbbs2iDu+Ia5XqhrJG8lbDv2XnaTq3R2oR?=
 =?us-ascii?Q?cFXyMy7eXSjzLUup23mtJVUpyH0tDxrCTHTyT7QGbQH/ufdgrmeECSkNhIzX?=
 =?us-ascii?Q?hAgvrz6xbVa669qLgTyOaKA1+0HMGqpQXc9SgpLtJSA0g3DDX/t6G6VJb3rd?=
 =?us-ascii?Q?RTTFyzTPFuhoePZQi1C9NKR4GEZxKoJQwGeY9Rm/OHOXgpaGux2glzqyMRjD?=
 =?us-ascii?Q?HCW1yXPJlF49XrHBKk82nmUozXAJB2+HiG6BfTpe1vPiqdqWEb8+8QLYdfVj?=
 =?us-ascii?Q?/TtxZWrM3Aclz6YvrcwxQOxaz08iRsm8gm/xtaC4Z1i5EjiCHqPYigBS+tzF?=
 =?us-ascii?Q?ABI+e6tgawmL4FUwTyAZWUz98UlJRFg7PR8OzbC+A/ZPZyUhMSs3uMk0DugF?=
 =?us-ascii?Q?yaLf52NZPJBNyfhN4WhTlGst5sLSaBXKRdaYkQuE2aqo1/fJ5aCe2btd9TuV?=
 =?us-ascii?Q?z3224wfYtzAvssmzEQNVWaL/kkna4cuEHGoFSXEzROUeydJVHz2yJdbACjfB?=
 =?us-ascii?Q?lmlI8opUxmCFKYC4qzOpzXJrrCTiXcKjeCdSPo2SFiGEG5hk3uY6VqcAezq8?=
 =?us-ascii?Q?dscqAD0ZgpgoD09zfSXOHiTpet3fmy1RlLdE4l1C6RWkW1rn1RED8YjG5qIi?=
 =?us-ascii?Q?Vyh26oVol3ujPCiKsozoFgMxCmxG6sdFZvqeXJBbKOlUNCVDjTeN/liOkiHp?=
 =?us-ascii?Q?Awo6VcG7Fnj973I7ZouRTyRPYI9ISOIr8RMhwjKcu3L2lxYzies4TxLHb6WA?=
 =?us-ascii?Q?tLTVlKKPZ/joepWfr8Ga/rhUqGTwyq+CQrr0PuKgKAv6Gkj6E+3YAp6NsnKp?=
 =?us-ascii?Q?h/kMQcdiv9dTgXR5SXoorMcB+l8oYTGJqJdyM3Xef47kAy4Hi3hpSRiugxQf?=
 =?us-ascii?Q?wV9Ivs+OB06fzZfeJM6vIAvhQN9n5KJ4EhR4zU760gv/6lkkYhT94xBh8deb?=
 =?us-ascii?Q?ZK7nzpC27TV1DdSAIX6ahDJU0VxIGsUnrrDKjwxi0xx7Tjh7134D4CCpn2Hm?=
 =?us-ascii?Q?kECX533iBsNGwihh8B3jFymU7DjUQ/EJTkXLolaH3cLAZQkz+uxoMmxtJsqb?=
 =?us-ascii?Q?n2I8d2+fDne9JvkLr5VGqO1A4vUhOIXgpIeX/n0eQV7dEsCaHixsLB6TuHnu?=
 =?us-ascii?Q?94Y/EKS1Zdk/ZJSomr0B+wNiAE4PG5SAoI2Ud1nFjVRsPQ22ZEuWhg0hHqLE?=
 =?us-ascii?Q?yiVPvLZ7k9+zqobzqFH61csF/e7y7sB5yE54EdHpRB652HNgv/0AHWLTRmE0?=
 =?us-ascii?Q?1vuqzzDjc+MPjupuyOgK63D2iAnBlxQQwa04ABdSKr968LAAGnoqXMuSZ5L4?=
 =?us-ascii?Q?myWNVMeUyNDEbxy50pHEKwfbd5QVgnXEQA85218S6GPPRaN5wNCTO2/vkrVM?=
 =?us-ascii?Q?s+Cn6vQaXuV7dsZ086afXNytza7Ub0jNIy1qvJbrb1fPrtsSePHp8D/Jr7Oa?=
 =?us-ascii?Q?CNMNPpKRS7nVtiFr9O+KAefZmaYKHlvByOMcaFbI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4da5218-dec6-40bc-29d3-08db6e409241
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 08:06:21.3272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dvCcvbgsa4kERZTfzlJVeQ/318SPYWZFbA0RMUzPlpFz22waMXfUNsIhWrzsT+JYUmoBTRChh/BGdJzIxSbMoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4686
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, June 3, 2023 6:03 AM
>=20
> Add live migration support via the VFIO subsystem. The migration
> implementation aligns with the definition from uapi/vfio.h and uses
> the pds_core PF's adminq for device configuration.
>=20
> The ability to suspend, resume, and transfer VF device state data is
> included along with the required admin queue command structures and
> implementations.
>=20
> PDS_LM_CMD_SUSPEND and PDS_LM_CMD_SUSPEND_STATUS are added to
> support
> the VF device suspend operation.
>=20
> PDS_LM_CMD_RESUME is added to support the VF device resume operation.
>=20
> PDS_LM_CMD_STATUS is added to determine the exact size of the VF
> device state data.
>=20
> PDS_LM_CMD_SAVE is added to get the VF device state data.
>=20
> PDS_LM_CMD_RESTORE is added to restore the VF device with the
> previously saved data from PDS_LM_CMD_SAVE.
>=20
> PDS_LM_CMD_HOST_VF_STATUS is added to notify the device when
> a migration is in/not-in progress from the host's perspective.

Here is 'the device' referring to the PF or VF?

and how would the device use this information?

> +
> +static int pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device *pds_vf=
io,
> +				      union pds_core_adminq_cmd *req,
> +				      size_t req_len,
> +				      union pds_core_adminq_comp *resp,
> +				      u64 flags)
> +{
> +	union pds_core_adminq_cmd cmd =3D {};
> +	size_t cp_len;
> +	int err;
> +
> +	/* Wrap the client request */
> +	cmd.client_request.opcode =3D PDS_AQ_CMD_CLIENT_CMD;
> +	cmd.client_request.client_id =3D cpu_to_le16(pds_vfio->client_id);
> +	cp_len =3D min_t(size_t, req_len,
> sizeof(cmd.client_request.client_cmd));

'req_len' is kind of redundant. Looks all the callers use sizeof(req).

> +static int
> +pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_suspend_status =3D {
> +			.opcode =3D PDS_LM_CMD_SUSPEND_STATUS,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	unsigned long time_limit;
> +	unsigned long time_start;
> +	unsigned long time_done;
> +	int err;
> +
> +	time_start =3D jiffies;
> +	time_limit =3D time_start + HZ * SUSPEND_TIMEOUT_S;
> +	do {
> +		err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd,
> sizeof(cmd),
> +						 &comp,
> PDS_AQ_FLAG_FASTPOLL);
> +		if (err !=3D -EAGAIN)
> +			break;
> +
> +		msleep(SUSPEND_CHECK_INTERVAL_MS);
> +	} while (time_before(jiffies, time_limit));

pds_vfio_client_adminq_cmd() has the exactly same mechanism
with 5s timeout and 1ms poll interval when FASTPOLL is set.

probably you can introduce another flag to indicate retry on
-EAGAIN and then handle it fully in pds_vfio_client_adminq_cmd()?

> +int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_suspend =3D {
> +			.opcode =3D PDS_LM_CMD_SUSPEND,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	int err;
> +
> +	dev_dbg(dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
> +
> +	err =3D pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
> &comp,
> +					 PDS_AQ_FLAG_FASTPOLL);
> +	if (err) {
> +		dev_err(dev, "vf%u: Suspend failed: %pe\n", pds_vfio->vf_id,
> +			ERR_PTR(err));
> +		return err;
> +	}
> +
> +	return pds_vfio_suspend_wait_device_cmd(pds_vfio);
> +}

The logic in this function is very confusing.

PDS_LM_CMD_SUSPEND has a completion record:

+struct pds_lm_suspend_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	union {
+		__le64 state_size;
+		u8     rsvd2[11];
+	} __packed;
+	u8     color;

Presumably this function can look at the completion record to know whether
the suspend request succeeds.

Why do you require another wait_device step to query the suspend status?

and I have another question. Is it correct to hard-code the 5s timeout in
the kernel w/o any input from the VMM? Note the guest has been stopped
at this point then very likely the 5s timeout will kill any reasonable SLA =
which
CSPs try to reach hard.

Ideally the VMM has an estimation how long a VM can be paused based on
SLA, to-be-migrated state size, available network bandwidth, etc. and that
hint should be passed to the kernel so any state transition which may viola=
te
that expectation can fail quickly to break the migration process and put th=
e
VM back to the running state.

Jason/Shameer, is there similar concern in mlx/hisilicon drivers?=20

> +
> +int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_resume =3D {
> +			.opcode =3D PDS_LM_CMD_RESUME,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +
> +	dev_dbg(dev, "vf%u: Resume device\n", pds_vfio->vf_id);
> +
> +	return pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
> &comp,
> +					  0);

'resume' is also in the blackout phase when the guest is not running.

So presumably FAST_POLL should be set otherwise the max 256ms
poll interval (PDSC_ADMINQ_MAX_POLL_INTERVAL) is really inefficient.

> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING && next =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +
> PDS_LM_STA_IN_PROGRESS);
> +		err =3D pds_vfio_suspend_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && next =3D=3D
> VFIO_DEVICE_STATE_RUNNING) {
> +		err =3D pds_vfio_resume_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP && next =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P)
> +		return NULL;
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && next =3D=3D
> VFIO_DEVICE_STATE_STOP)
> +		return NULL;

I'm not sure whether P2P is actually supported here. By definition
P2P means the device is stopped but still responds to p2p request
from other devices. If you look at mlx example it uses different
cmds between RUNNING->RUNNING_P2P and RUNNING_P2P->STOP.

But in your case seems you simply move what is required in STOP
into P2P. Probably you can just remove the support of P2P like
hisilicon does.

> +
> +/**
> + * struct pds_lm_comp - generic command completion
> + * @status:	Status of the command (enum pds_core_status_code)
> + * @rsvd:	Structure padding to 16 Bytes
> + */
> +struct pds_lm_comp {
> +	u8 status;
> +	u8 rsvd[15];
> +};

not used. Looks most comp structures are defined w/o an user
except struct pds_lm_status_comp.

