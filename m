Return-Path: <netdev+bounces-11325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D528A7329B1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 040001C20AE1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA9BBA53;
	Fri, 16 Jun 2023 08:24:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61EB63BD
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:24:27 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D002D5A;
	Fri, 16 Jun 2023 01:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686903866; x=1718439866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eML8E2sU7mn5R5//8h+Dw1RW5haLJif7kxWE5ja9qZ8=;
  b=bayeFR0TTZxRNYJbA10i1BeZzrMtnwizeHXPu8JOmWfM1B7iEUsUZN2J
   KIk8ybrxFT51IOO0DgWnV5r21OCxit9NeCa2lHYqXOao8mk+3E7FRadhV
   w2UWXUrXUj4eCGRMf3Hi2EyMVsXXmYOMm0dEi7Z2gIWBgvFawQMsgkiSV
   1CS8xO9IS9bTk0kHS20pE2sN+kIhsv8qqdhzR8H81Ub0T7+zABCPglfXj
   3iixEOuUK77a6N5KjeSTGaD3hlXF1JJTNwhpcBaL1Lmc16Y7ifKMadKtT
   kd35ilrIbFXIU38T2iJxJNn+6myQ1ErHx76KxobAl2HKwpb2fxWRktCEx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="362574840"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="362574840"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:24:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="1043009884"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="1043009884"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2023 01:24:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:24:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 01:24:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 01:24:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpA7LOEDNffU0lQFgyZuG5HMPWaiYiKMIiH1jVydHoYhnd1hDcTHRyCMYhIeKfs4/1GRwH4XxGO/5CD2/hZaNqS8fsgzshscan3FsqayaZhlCJ1blOXced7o+0wTwYp135ZONOFV+3J1TfCzdzugQx0smMxR+8d11X+VCdR/lRwNGjYMAoHaK4Sdn+dLNUeqESVVeHIaqzc2FR66rKSXQpwJEtDnSGzxQSN5k47q9VGLwJpp2WNexUpWToXOciyDV5pdWlcMhvKlAg8ttEY6FAX+k0tMJ+BQ4x7/t+bCiGbb6Ob5OAzugTFunIm4C4V9U6GC5Jhb+yIdh214ICfRdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVCzaGu1qr46+igi5IJTsZ2TY2WSPt1QapP423nTcBY=;
 b=gvWIVIox9OTc04qbQHUfS0CXHTtILKU/ishThkpuFDCmaXZK90/PDmx8NSU8+DBKs1jPVuB2jKBX3h8heenq1NFHQJg4njuEEgc5dX945f07Jqa9aO627MSuSwHnxGdJw1loScuFYubxF8xZ5ppgViq0n78+Bz4RWlmh7bPi5iL3yck3YXNtCjG0j4jqxyqYxgLTau4OEAXQwhG6R2fXUAYQ+R/xiEeCblzyDQv+IQgQBnRABxv0cBBgdoTJ72shvvNoqVs06ZWR31CUjkswymhcvDCEIvt1WdEP7NGIkuG8iisfwANJRI7AdTtdGsHVe4/DODjva/2EV1t/sP3oJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7545.namprd11.prod.outlook.com (2603:10b6:a03:4cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 08:24:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 08:24:19 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 6/7] vfio/pds: Add support for firmware recovery
Thread-Topic: [PATCH v10 vfio 6/7] vfio/pds: Add support for firmware recovery
Thread-Index: AQHZlZ4iYEf7MGd6vEaBwxwdToKZqq+NJ8rw
Date: Fri, 16 Jun 2023 08:24:19 +0000
Message-ID: <BN9PR11MB52765DA10BA305647D5D2A7A8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-7-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-7-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7545:EE_
x-ms-office365-filtering-correlation-id: e8daf5bf-6733-417c-4a33-08db6e431525
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Kx6f9QlBvjXeh4jJY2VswUtdWn1Owvldzkd2tnSdw0U5VBxpExCt3ltuUrag7oPiwNhKiFl0NwPzTWNWEm6cYR9biMUEK40SLgf2+yYc7UVzJj8QwAm90nDKcbCzlJNKHD7mKqwMd1gGal3fCiD2iHlNbdlMDcm/11nOLUqqWtcRcIA5GHZMW6aWSpyZmfUqAawXUnSNBxQTdUK2YVAd0mA67N/dX+AIMFF5LeP1DLMXlw0X75g3syhzhQo8AN8rgsbotL5DMdymy7eKkshTU5BYG+WShBJU3xFlRrX8XPnFiL9mL0HFSD1uzYW5NpwQP9By/wAEPyqI1keMM+dOEzuy3DUgZ/mzvf1LTTQ5cn2rt05NSviDPw6sc4pXVLaOcNIBqhuPbxo5xWDzVeW9K5cAXLib/1Lazg8kF1MtTM9HoGx1P5BOFn1CJFnNtylrZDJQYshiDG/LNYgG5j7E3Q/sJs4IklOeqzEtb3yDjFlbXlrw+ZyWs7tJJQ2FUVLrfVBluC04SoAru7lXIhDgvfmJhOguLTBN/tqf3jFr6U6Vj149pDGCTYA0bPIauWSf96y3yO6uuqM0NzqBr/1j7/9Q6K0S9V1SkndJVG6O7aeNEpx32Wc/WTulHzLAgGS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(83380400001)(2906002)(38070700005)(122000001)(82960400001)(38100700002)(55016003)(41300700001)(316002)(7696005)(64756008)(66446008)(66476007)(66556008)(71200400001)(4326008)(52536014)(86362001)(5660300002)(8936002)(8676002)(110136005)(33656002)(478600001)(66946007)(76116006)(9686003)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pmGR/O7i6Q5dXD2DXAHnETr6hVfJ0iWDHr8q7dUGU9onelGm3PgxAGTMR7Qi?=
 =?us-ascii?Q?19SVzxGzD8OJPYgnxa31e2m52kJGiC03tWjX4WV96lADyvmgws6biQ3NVCY3?=
 =?us-ascii?Q?kb2JV/rHm74gJewORMBOMiDfxgJhdfgB41v6KUHWf8BtiFDKvIJa5dEWe9IX?=
 =?us-ascii?Q?K+vnvLSZOxZZKazp0Yf0xiHM+/1LVm6aVnkaHQuge2riigFCcB0kUPXVIqGr?=
 =?us-ascii?Q?5ilX9Nrfcm4AEILliR1UeMKVAjLGNXmhIZ5tDP6QBkwj0nwqhHzr+M9yrrWS?=
 =?us-ascii?Q?PcTZzphEmrWwyV/kgfe54ABrmJrVdOTkAO5d2snm3Nh6jr3Nd5jD1Z4Fc5FV?=
 =?us-ascii?Q?r+fu5HHPqUljBzkvkGKc3mM9gwwSLp7FNxDONW1t3WehpDZ8uSU3d/HaBRN0?=
 =?us-ascii?Q?I5HPWXOO1PEhii06zgZ+92GgcRGw3Qzzdae3JRyoK9/btzaq4UFz5TsNEuP+?=
 =?us-ascii?Q?D2dkithvrLPyipPK+GIs+EAwjdJ8Gy6MTYMtvaAqEiTTXR3rgkn4N0CFMOIl?=
 =?us-ascii?Q?O2pE6JDWq4eF6oxQMy0X1wPBT3ARePy8xhqeyJxaXNJDlS7xV5jikRn2nEEi?=
 =?us-ascii?Q?UyjiCwP693KHOTS57rG+/uflHcIAaYvhUNwYr5V2kd6QfAO3oigfIPyZ4un+?=
 =?us-ascii?Q?U4Zu0Xe2CiKOsPK9BRvBVzEVbJ6jjrE1m0xVPXyHinoEUrDGyp8uq7ZL724W?=
 =?us-ascii?Q?NOF5jsKbFkWRZLdtJhF13JyVOjDQ8gmN77or9RmwSrbg4Jxc3hdB2YI24O+h?=
 =?us-ascii?Q?KuP3+Q8Hf9cCK4oOxOSMBLJiEbb9R+GRWWSqi95jZFjWXdvSvhVQfe87y6/s?=
 =?us-ascii?Q?ywKXyhgyeEAg+lpqNaKLhNZ9xi3E0Fi5Dn+3fk5zwLgrihgTlOztKVbpmKTK?=
 =?us-ascii?Q?pGI9CGM3FY1SrIDSRtKCLvlSbkwex7z/m5UFQnGZB3NBCaI7cdBdhjZ66IYw?=
 =?us-ascii?Q?t2Lh//abl3C6HX82hGbN3D8NsB81WWFgz0VIzZC4sVTckSf7rPI5jca4+KYV?=
 =?us-ascii?Q?l8k3yQnxsD4uxzC7L3zvaAfdSmALlr2NmQrm2XUhl3ktGpnyRlUevPrOwjDt?=
 =?us-ascii?Q?283H/4xRxut/hBynUlj9nM39V8A7aTdVJ3FcBH9VdhqPD87Ugfq6sxiinoxr?=
 =?us-ascii?Q?7XcEKXe0bJs4oBHY0sfKlvgN6HQf6wDftN0hKNHVkvvkmjwKVv0aQAE6YRiP?=
 =?us-ascii?Q?SRXc09XnW5ziVlu3tuDLWMjbeVfnmRIwuNHK1iDhTmMB6wQ9YbYMH2R31DAU?=
 =?us-ascii?Q?dNBaI0FHRoEUy1I8q5+1TG2DgzWFyrvJhr8oXbLh0et4rS5Mrlg+PWesn37/?=
 =?us-ascii?Q?UmkvdjEbX1Q3y5D9t3OV1uDteMxQpInM8ngMvBX+EsmO8iUcCORPn7t6lyc9?=
 =?us-ascii?Q?1EnNGjTkanQ+E15rMnOfeU13REoRI3mSMFuIamkcoM8KqvZKJ1RJ/l+nToiG?=
 =?us-ascii?Q?7RQO1hWC0ASLnU9Jddhxg0WH+rfw3U7Nus4lykyjvxeyC4kIQ6PhIBF3rKNr?=
 =?us-ascii?Q?gsM3wIUSD11qSjBrQML2plgCVZkPr1Eck+3LEC1z8RdsrHWN3UnLZ0AXxMg3?=
 =?us-ascii?Q?qhyBAPzrfi3lHFjJhvsq6AnKNAHHl5gJ4Yn62x8Q?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e8daf5bf-6733-417c-4a33-08db6e431525
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 08:24:19.9104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UaGLZbukH0uju/k9L+AfERQw+AjLmejB0WS2TqKymlVxLzYo01WzlXoNxB2npwi5hJVvHkghY9dQdFzKBy55Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7545
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
> +static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	bool deferred_reset_needed =3D false;
> +
> +	/*
> +	 * Documentation states that the kernel migration driver must not
> +	 * generate asynchronous device state transitions outside of
> +	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
> +	 *
> +	 * Since recovery is an asynchronous event received from the device,
> +	 * initiate a deferred reset. Only issue the deferred reset if a
> +	 * migration is in progress, which will cause the next step of the
> +	 * migration to fail. Also, if the device is in a state that will
> +	 * be set to VFIO_DEVICE_STATE_RUNNING on the next action (i.e.
> VM is
> +	 * shutdown and device is in VFIO_DEVICE_STATE_STOP) as that will
> clear
> +	 * the VFIO_DEVICE_STATE_ERROR when the VM starts back up.

the last sentence after "Also, ..." is incomplete?

> +	 */
> +	mutex_lock(&pds_vfio->state_mutex);
> +	if ((pds_vfio->state !=3D VFIO_DEVICE_STATE_RUNNING &&
> +	     pds_vfio->state !=3D VFIO_DEVICE_STATE_ERROR) ||
> +	    (pds_vfio->state =3D=3D VFIO_DEVICE_STATE_RUNNING &&
> +	     pds_vfio_dirty_is_enabled(pds_vfio)))
> +		deferred_reset_needed =3D true;

any unwind to be done in the dirty tracking path? When firmware crashes
presumably the cmd to retrieve dirty pages is also blocked...

> +	mutex_unlock(&pds_vfio->state_mutex);
> +
> +	/*
> +	 * On the next user initiated state transition, the device will
> +	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the
> user's
> +	 * responsibility to reset the device.
> +	 *
> +	 * If a VFIO_DEVICE_RESET is requested post recovery and before the
> next
> +	 * state transition, then the deferred reset state will be set to
> +	 * VFIO_DEVICE_STATE_RUNNING.
> +	 */
> +	if (deferred_reset_needed)
> +		pds_vfio_deferred_reset(pds_vfio,
> VFIO_DEVICE_STATE_ERROR);

open-code as here is the only caller.

> +}
> +
> +static int pds_vfio_pci_notify_handler(struct notifier_block *nb,
> +				       unsigned long ecode, void *data)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =3D
> +		container_of(nb, struct pds_vfio_pci_device, nb);
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_notifyq_comp *event =3D data;
> +
> +	dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
> +
> +	/*
> +	 * We don't need to do anything for RESET state=3D=3D0 as there is no
> notify
> +	 * or feedback mechanism available, and it is possible that we won't
> +	 * even see a state=3D=3D0 event.
> +	 *
> +	 * Any requests from VFIO while state=3D=3D0 will fail, which will retu=
rn
> +	 * error and may cause migration to fail.
> +	 */
> +	if (ecode =3D=3D PDS_EVENT_RESET) {
> +		dev_info(dev, "%s: PDS_EVENT_RESET event received,
> state=3D=3D%d\n",
> +			 __func__, event->reset.state);
> +		if (event->reset.state =3D=3D 1)
> +			pds_vfio_recovery(pds_vfio);
> +	}

Please explain what state=3D=3D0 is, and why state=3D=3D1 is handled while
state=3D=3D2 is not.

> @@ -33,10 +33,13 @@ void pds_vfio_state_mutex_unlock(struct
> pds_vfio_pci_device *pds_vfio)
>  	if (pds_vfio->deferred_reset) {
>  		pds_vfio->deferred_reset =3D false;
>  		if (pds_vfio->state =3D=3D VFIO_DEVICE_STATE_ERROR) {
> -			pds_vfio->state =3D VFIO_DEVICE_STATE_RUNNING;
> +			pds_vfio->state =3D pds_vfio->deferred_reset_state;
>  			pds_vfio_put_restore_file(pds_vfio);
>  			pds_vfio_put_save_file(pds_vfio);
> +		} else if (pds_vfio->deferred_reset_state =3D=3D
> VFIO_DEVICE_STATE_ERROR) {
> +			pds_vfio->state =3D VFIO_DEVICE_STATE_ERROR;
>  		}
> +		pds_vfio->deferred_reset_state =3D
> VFIO_DEVICE_STATE_RUNNING;

this is not required. 'deferred_reset_state' should be set only when
deferred_reset is true. Currently only in the notify path and reset path.

So the last assignment is pointless.

It's simpler to be:

	if (pds_vfio->deferred_reset) {
		pds_vfio->deferred_reset =3D false;
		if (pds_vfio->state =3D=3D VFIO_DEVICE_STATE_ERROR) {
			pds_vfio_put_restore_file(pds_vfio);
  			pds_vfio_put_save_file(pds_vfio);
		}
		pds_vfio->state =3D pds_vfio->deferred_reset_state;
		...
	}


