Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97EB4B6996
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbiBOKmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:42:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbiBOKmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:42:11 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4519A9B5;
        Tue, 15 Feb 2022 02:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644921720; x=1676457720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IBy6APy3QlFaP1vtBp9ldo3MPlY2Q43YIKA3dU2mE5A=;
  b=YpMVTylPXYiyW4QmDGadg0MH/V0d8LdiqLvPZDcVvTB4bAW/3nYDEg1v
   sB4nv5mlgotEeinnKYCXakYwNV6es6YQWrTL5eEDnbt5qGyKVWfrL/a3V
   zFN572p0wm/b5FYdZt6XtJDivuOWc24DWIdvumRgm0zfrR3JPlTX5tDzj
   vj4Y3BChAkmHUVWayB/SIn1Z39KVQFW+7VkEgPl6+XwSCXict13lwB5GG
   5wChvtga09PT7Rm/pOs+qbz+RaRN/ABlyU2q8VbVspXg+kGkGmdTxXHNu
   8iJU2H3OPppVXfNp3chTIQpRSjbJLEpZoCfDlak+WiuTNX1j4J4mzFPH0
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="237728360"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="237728360"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 02:42:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="570761894"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 15 Feb 2022 02:41:59 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 02:41:59 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 02:41:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 02:41:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 02:41:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1SMkV0mZq6hX19xMz4DHIxSFilbItuy78DwArzm3PkkW01u0UZN19eOGFIogwLwiQboZDE5CrRgqkQ42LfQ88KFukeoa/54uw8Z/4nAHaFAVx/ANi8pn3TfimUKiqnJDdKHJiBpR+5nrWXbELltsKjAkX7O6yNnT8Za/PZlakOALLWqlU55wXgbRmZ3WqITxfcZklwWC+yaBsImfKvgGEEXwwqV6QpW4iDl9vLR/F/Qr7awsFd8uVQKcDLelXLAL/2FjLLXEn2VAuZ7Yz0N5RsjHdjx9IPpZd+QN8VKexCaVyXl0dVxkNJp7rWMz2F6hvB5sQ1F9TFHvZyhQzjKIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjhP+lhXdKXHugnpBR/V+G2Bz5n2ARTmFHFwoCQysu4=;
 b=W0tKJszQ/pPX7f56D5hxgVLTdR4I/1wWzEW1xBbcYG5cPnSW9FnptRMKx7G3ItLkM8396guAlPO1gKwMYI/CztDsMXrvsm/bvNaj44/V2TeY576IgedyBCzmgwjOcvDfxmSp6h2uaCBkQrtDuKDr6q9aBmwsud2uRND+4OjVFqO0lBTGPd2Frmr796QEHunIvfrkJ4ZT13Tc3ttgyxaLlSthSw9yN8rlD/K8GDe1t/4YQ1UCW+t3Eni0wcoxsP8vLG8CIUxvBfVS0IR9c3u2mtIyx+D0SCKi+7D7cG7/wnfLmQ0CuRzvUmoSR9Me+kOgqgAh2beHdnvqTnpbuKidOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3228.namprd11.prod.outlook.com (2603:10b6:5:5a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 10:41:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 10:41:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 08/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYHEd8WrQ75CuCwEmQ+4nXbJWyQ6yKWZwAgAAploCACfA7AA==
Date:   Tue, 15 Feb 2022 10:41:56 +0000
Message-ID: <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
In-Reply-To: <20220209023645.GN4160@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb6c0c7e-751d-4570-6be3-08d9f06fca01
x-ms-traffictypediagnostic: DM6PR11MB3228:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB322820E53EF54282729D47DB8C349@DM6PR11MB3228.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xrb+rrhHpPGfdk0JvNvpJFdqjVXncl/PUZlKP6ne6MrppcuydzXEanKweZ0hEUHLYHs0jChxnH0rZFfLfGM9KGdLCOrhrXgOHmfoBiAcg8Gi1FIjlbEkLgZt9/XHQ3kUOyKURUQFXZOqnMufrL3mSWtfVTENt6fSS/ioI43ttYR0zj9qd7GTwcxTvpvz83zbch+SoG5tHA6L+vpwx8g9cboDQAO0iz4B+f5i2xUtmosoXnW+BnfRRLnyVRgeaY21hL1GGVRbDDthKF4q9+HBC/YnJgbXULTvoRXEGy1Vua4WbCve+8UcTp1Sr1Y9fL/hU6whhSB7BUwKjmkJ5LBStc+OkyYQKkzg+FX3z4Ax8x0A4Q+caj5VMbE9O94lu2Nx/OxNZFezvljlCk6VWdey3wmDWN42eEx0Ei567GQXlmVJD87EQKD160d1lOiUe60+xCVZbJl0Gn9SBvoBNpmK/OOIqhN3xk1MAKNW8HASbfYvkxLtDK/UmYxVidabZFzJwwXJUTQKmpbg2wpasxR5Vo9Ds2ki6jUOATWBPthE0jU/IsrelZOf1HjFlmCIinDaZLcd5vON7SgH/rYq2k1nij4NWNPAWMBKs05/XxkQJ1pCNkIgKEjDIzm3qmAhfSiWr6SwzNR7GvQQtl1AQ4/LwjX0G21bYlNgOtKXNmQO0yzRW0l5iu2VwppIPT4qPOOF5cmB3IAU93YkHfFlUNLWEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(9686003)(26005)(7416002)(186003)(5660300002)(55016003)(38070700005)(7696005)(508600001)(38100700002)(33656002)(54906003)(110136005)(4326008)(8676002)(82960400001)(64756008)(86362001)(8936002)(6506007)(66446008)(76116006)(66946007)(71200400001)(316002)(83380400001)(52536014)(122000001)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rNAZiVoNhjzoG3WvhRMcGGqq7cdEPT12cuTcnjzNP93EtPyqrAaFxQO5IgSv?=
 =?us-ascii?Q?e3dasX/30LsKTVlgYE9ByZJ2uEVoir2EGwSdUJumnVZPBf90IzAg9rz93ZmB?=
 =?us-ascii?Q?C+YwIg4vpLAcU9aQfodQTlGFB+fU6kuf05zDidqyLhKNekGQGGmVyzsSgn/l?=
 =?us-ascii?Q?4oq8cHXrHnDVFSbnopMPccO2JVbD9f3Y7q2Go8Kq+x9427rEF6LgVh7ol/GH?=
 =?us-ascii?Q?MUXsjtOWaSK0K/qqn6099ODowGPdHRE/js9SvBpQEHdrkferwKlwlDXpZ3bh?=
 =?us-ascii?Q?wPO6q0cOPfvv5i1uMCljgnGWdINkBHHbQ0QfCSN3gWrGXbuhTU7Tw2k+BJbD?=
 =?us-ascii?Q?Biv2NAi2vId25EyI7UiDYgjuZzfZWpMtvJbYCPUJ4ykqn56l1ZSeu+p/OqCF?=
 =?us-ascii?Q?PVv8zb+iLQteVaaiKlKZBfSAkoOLR0pX2JXzWAtkN2r0qz3N3/QrIdo0wi1r?=
 =?us-ascii?Q?Hr1fPkpEE7T9APsg5yg3DGUDSOAipKPDXlfWvNoWeeNVhnvZKLFLN9b07XMz?=
 =?us-ascii?Q?hPofsjhzkfGmpuHbopYe31/Y9cwPn+b34NhFV5SWG+/LWSrTESZUOJ0aVgeV?=
 =?us-ascii?Q?g4CVU9haFDmo4jK7iE6rI82C2+zSe6c6UCKEyRIdn1FZwOKId0QqZvpxyOr+?=
 =?us-ascii?Q?PRTRa1wSJLTckJ3186dpuBfpLmhkTUyhs8kXjdfFB6R3PfREUexMt3qurR0x?=
 =?us-ascii?Q?rG+IyiP6yCI9CE3sfo7DBqDd8aw4J9pSIh7LN+hcrOgdiz/8ZEx8uizMgis/?=
 =?us-ascii?Q?Cdp+/aSGrOScwa91rIqg+3KfOi2bn431di53ZhgCxiUzFeI8mLib1TpBGynG?=
 =?us-ascii?Q?bE3xJg/hQMRyoGL/DxEcZfnH5/UAqZQAGXp2H4bRiW1lgGp8jMeumUBR5r/5?=
 =?us-ascii?Q?bITBDktWYpqmE0Ddm8cs1gpWGtEbKp2282D7Mg5fA6oKHmD3ZYD5PsOKsT6A?=
 =?us-ascii?Q?IrcWYdUcXeaZdaHO1qeDNg840jI+o2ggN4NPW2YbNitQvn7V6cqpmWGmlY8e?=
 =?us-ascii?Q?NujI6/1xzPFjK59cTUnP7Z60/hqXmE48gr3KnwX1yAxHZ/H4QanHayuWiV2r?=
 =?us-ascii?Q?lKrfSpcUQT5oqlj4UVZzL/LGHulQFq2KLkC8+ml1512OzEtj3OtBGnFAsyyR?=
 =?us-ascii?Q?CSTFUl+BkIuJyyQhctR84JKITtOQMYK5lo/lymt8Gl8wtWGa82CCoTvkGIuw?=
 =?us-ascii?Q?olfIddiwsND3/z+wgiaPcS3tV/txUd9/0djtOgZBEzXUrE9uQtb50jB5g6sn?=
 =?us-ascii?Q?wZaVa3rYCIVa6rGE7n/Xc4bsL8ZcvfImUumILvHT8StsIcf8gVDjmxzTFKoA?=
 =?us-ascii?Q?64oZYMoV3u2ezwFRUREziDNblXV7ZXVtGCl76nw2D+dDZXnH+l1WHWznqGK4?=
 =?us-ascii?Q?tW/pNSHLSJtxbgyH/v85bKadJ/UYDUn4ggrPivcdm+CwhSeW2lEuTCyTbcPe?=
 =?us-ascii?Q?Uv7ERW7sZuHSO3Oy/Qj+B/tswyxsa50jxQm/Tzddvr7cY8882jNVF144Fehc?=
 =?us-ascii?Q?I7vr2AScobeaupeQ0np3LsMBbiJN4Oc6iaA4sQgSUw7HCSttPF4Ntg8oqMwa?=
 =?us-ascii?Q?YX4dSQ5XUB4/pAtwdn7IfgyQ0yfcXJFCCxKaszxY8WLU2IZlZ7bH+MIXQC1F?=
 =?us-ascii?Q?bQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6c0c7e-751d-4570-6be3-08d9f06fca01
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 10:41:56.9200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6gV4v0duTCjXujj/QeOLGRpQSpMjiYpRcMz+RjWq/SvDpbigO+ZBehQ2NPWBchlrVXvT19NA+Fh4Q5TIWpgqNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 9, 2022 10:37 AM
>=20
> > >  /* -------- API for Type1 VFIO IOMMU -------- */
> > >
> > >  /**
> >
> > Otherwise, I'm still not sure how userspace handles the fact that it
> > can't know how much data will be read from the device and how important
> > that is.  There's no replacement of that feature from the v1 protocol
> > here.
>=20
> I'm not sure this was part of the v1 protocol either. Yes it had a
> pending_bytes, but I don't think it was actually expected to be 100%
> accurate. Computing this value accurately is potentially quite
> expensive, I would prefer we not enforce this on an implementation
> without a reason, and qemu currently doesn't make use of it.
>=20
> The ioctl from the precopy patch is probably the best approach, I
> think it would be fine to allow that for stop copy as well, but also
> don't see a usage right now.
>=20
> It is not something that needs decision now, it is very easy to detect
> if an ioctl is supported on the data_fd at runtime to add new things
> here when needed.
>=20

Another interesting thing (not an immediate concern on this series)
is how to handle devices which may have long time (e.g. due to=20
draining outstanding requests, even w/o vPRI) to enter the STOP=20
state. that time is not as deterministic as pending bytes thus cannot
be reported back to the user before the operation is actually done.

Similarly to what we discussed for vPRI an eventfd will be beneficial=20
so the user can timeout-wait on it, but it also needs an arc to create=20
the eventfd between RUNNING->STOP...

Thanks
Kevin
