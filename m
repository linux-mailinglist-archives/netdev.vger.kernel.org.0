Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1CE16668F
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgBTSsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:48:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:12649 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbgBTSsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 13:48:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 10:48:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="434925960"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga005.fm.intel.com with ESMTP; 20 Feb 2020 10:48:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Feb 2020 10:48:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Feb 2020 10:48:14 -0800
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 20 Feb 2020 10:48:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Feb 2020 10:48:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQY9+f2htAcSQCVuVQp8g5xd4mzME6xzoARj196MhwpM04o0Rr8yW3tYCBIZqlFFTod+ZkG1+AcVflXjF5RjPj/1v/ZROMMiDyho/qGfVXL3jMv7OsLKNZIa6Zxuda0OxQQn2Of/mJYa6BqD8xG97KoIfqvgi6LW37Rt0FkkS5gsfPa004G+gVt+ZZSE4TWWN5re30vs4RPaC3LcLpNqXwtAQWCtal8c6dPSv1HFmwqoHlJjPQcb+pS/eIem+5prpIE0Xhg8wRE3OmiUheS7r+t1/h/8M495qbZv6CFCM8nJ/7I1Xr1S9SuF1C8WUrLA+Xm74WQybzNfosMVR4rD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0gbn2wKnlXaq4UmyT3nQgoHNcGaapaKaJru9RY71VA=;
 b=YO8hYvytMB58B7SuxcbUSauV4c4Mdr0j13YZczNHlknbNpYKfNTDw7+GzIcqZTMlp5RVqJ1KLv48rXLiLx4CXTPeANObEQT/YyUGsbwu5c1R5l4Vwq7gnUp+LDUtjUXTHbGFQ52piwD8q7ABlkDYk6Eb6XtBGI0etJ9Cc8RHCO0vbg5E86+mgwKaxia/htMdI0JL6cEOOT425VlUrcyO2OJOYnImEMA4CBFtBTmyjVKPHg+FOCqOtv0JsDPZZYGh92xyuq7uiWoNoewZkJAnSeMHnpTgXohg0fQgA9jWtUIxTB5SO+F/+heR2KBSIALUJANfxzagcDevBzvtAGLOdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0gbn2wKnlXaq4UmyT3nQgoHNcGaapaKaJru9RY71VA=;
 b=YbGtSUxKEMcXxRP+fJTjUF3NufuGsylH4h19d8IrkofCHj1uZIkcvFuU2SzcRWm6DutRr/PoUMGydq5Ixg4SfRjosyyHFuJaM+ohpTupRf0WU42nyaScOws+OOr4TpnjYNm5jj8KZB8jhxMcSOwckwsidyX1ff0CyJoBV1cPY30=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (20.176.100.32) by
 DM6PR11MB4564.namprd11.prod.outlook.com (20.180.252.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 20 Feb 2020 18:48:05 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::f01a:b54b:1bc2:5a80]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::f01a:b54b:1bc2:5a80%2]) with mapi id 15.20.2750.016; Thu, 20 Feb 2020
 18:48:05 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [RFC PATCH v4 02/25] ice: Create and register virtual bus for
 RDMA
Thread-Topic: [RFC PATCH v4 02/25] ice: Create and register virtual bus for
 RDMA
Thread-Index: AQHV4di1fPEgbQYDSkiYYN5ptkcxbagbKgcAgAk9o4A=
Date:   Thu, 20 Feb 2020 18:48:04 +0000
Message-ID: <DM6PR11MB2841C1643C0414031941D191DD130@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-3-jeffrey.t.kirsher@intel.com>
 <20200214203932.GY31668@ziepe.ca>
In-Reply-To: <20200214203932.GY31668@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2E0NTlmMGItMmU2Ni00MTk3LTgwNWMtYTEyNzhlZDE1YzBhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoia3lEUUU0NmVyXC84NGdwNWxnMDRWSlZKTVNha3pDNU50N3hMWlNTWGx0b0EzV05ndVwvQ0JFMTd6bUxUNWlicG5VIn0=
x-ctpclassification: CTP_NT
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=david.m.ertman@intel.com; 
x-originating-ip: [134.134.136.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb6dad9c-6cdc-4067-bccd-08d7b6356b9f
x-ms-traffictypediagnostic: DM6PR11MB4564:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB45649DE95AE6223C5C9084BCDD130@DM6PR11MB4564.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(376002)(366004)(346002)(189003)(199004)(66556008)(76116006)(86362001)(64756008)(66446008)(6636002)(8676002)(33656002)(66946007)(66476007)(316002)(6506007)(81166006)(81156014)(7696005)(54906003)(110136005)(8936002)(53546011)(478600001)(26005)(52536014)(9686003)(55016002)(71200400001)(186003)(5660300002)(107886003)(2906002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR11MB4564;H:DM6PR11MB2841.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFKHBICiCSVdVZjozsafb7esfZ3cSfwC2YGkS85Zwkvh6O6LubGCkkdj1tFI0bU86k9y5sQMB4R2DQQTccl9LJ89OoSvX9Zep4PuHv4JztaSwJQz7GD0zWwTJftLWv8g8uWMnuYxU8iowlUi3bJzxyyFAlvVBBqeUc/B+QAfbxHr4A+evoUcCLw6Yj/byH+rr0dRycOpbfzgMnaIzt9SFcu0GHqa2lbi91kAgxARMpaZaIK5lAuTlSwk7Nun1CPj3Q9ZOYuOOo0et8nClcERj4U9UgO73Vqt4Yk7t5gIxIP1ZLb+rIyJcfGSFkYw6qdDuO0t1R761K0WKiVZJClkFeBJFHMMqDMuGaPIakEYdeuGr8DGoQ/y20vzoRjXyihiVo6bzgfstLJ0KU6frDX8Siz2t7TMQiFsBnxQJubmJpvuvR2KyqixS7d2JM1+sBMg
x-ms-exchange-antispam-messagedata: qnlqtHwJkcwx8NfPJMNr95mg7E5PRY6ArttW0cBSBeEEgpMEBEqzDKPcIIjsn09tScVqRk67iIA+QOhKyloJASrWSY2QgUvu7tTrnF23J/zLXk2BFnyJf1mPUuPgZVNMdJRjzEBXWgbQoVT9wbMf6Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6dad9c-6cdc-4067-bccd-08d7b6356b9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 18:48:04.9538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skMJAHlfelJOzjKsxr8SK8PGRH53UaLxPCwMF7BYxCsRw5eXMjgvAMJgJDs0aY9Bl6H9VZfXOO4Hc4hOx/KM7NE1n4VIUL67yKHHyaN6Z3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4564
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, February 14, 2020 12:40 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [RFC PATCH v4 02/25] ice: Create and register virtual bus fo=
r
> RDMA
>=20
> On Wed, Feb 12, 2020 at 11:14:01AM -0800, Jeff Kirsher wrote:
> > +/**
> > + * ice_init_peer_devices - initializes peer devices
> > + * @pf: ptr to ice_pf
> > + *
> > + * This function initializes peer devices on the virtual bus.
> > + */
> > +int ice_init_peer_devices(struct ice_pf *pf)
> > +{
> > +	struct ice_vsi *vsi =3D pf->vsi[0];
> > +	struct pci_dev *pdev =3D pf->pdev;
> > +	struct device *dev =3D &pdev->dev;
> > +	int status =3D 0;
> > +	int i;
> > +
> > +	/* Reserve vector resources */
> > +	status =3D ice_reserve_peer_qvector(pf);
> > +	if (status < 0) {
> > +		dev_err(dev, "failed to reserve vectors for peer drivers\n");
> > +		return status;
> > +	}
> > +	for (i =3D 0; i < ARRAY_SIZE(ice_peers); i++) {
> > +		struct ice_peer_dev_int *peer_dev_int;
> > +		struct ice_peer_drv_int *peer_drv_int;
> > +		struct iidc_qos_params *qos_info;
> > +		struct iidc_virtbus_object *vbo;
> > +		struct msix_entry *entry =3D NULL;
> > +		struct iidc_peer_dev *peer_dev;
> > +		struct virtbus_device *vdev;
> > +		int j;
> > +
> > +		/* structure layout needed for container_of's looks like:
> > +		 * ice_peer_dev_int (internal only ice peer superstruct)
> > +		 * |--> iidc_peer_dev
> > +		 * |--> *ice_peer_drv_int
> > +		 *
> > +		 * iidc_virtbus_object (container_of parent for vdev)
> > +		 * |--> virtbus_device
> > +		 * |--> *iidc_peer_dev (pointer from internal struct)
> > +		 *
> > +		 * ice_peer_drv_int (internal only peer_drv struct)
> > +		 */
> > +		peer_dev_int =3D devm_kzalloc(dev, sizeof(*peer_dev_int),
> > +					    GFP_KERNEL);
> > +		if (!peer_dev_int)
> > +			return -ENOMEM;
> > +
> > +		vbo =3D kzalloc(sizeof(*vbo), GFP_KERNEL);
> > +		if (!vbo) {
> > +			devm_kfree(dev, peer_dev_int);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		peer_drv_int =3D devm_kzalloc(dev, sizeof(*peer_drv_int),
> > +					    GFP_KERNEL);
>=20
> To me, this looks like a lifetime mess. All these devm allocations
> against the parent object are being referenced through the vbo with a
> different kref lifetime. The whole thing has very unclear semantics
> who should be cleaning up on error

Will cover this at the end after addressing your following points =3D)=20

In my reply, I am going to refer to the kernel object that is registering t=
he
virtbus_device(s) as KO_device and the kernel object that is registering
the virtbus_driver(s) as KO_driver.

>=20
> > +		if (!peer_drv_int) {
> > +			devm_kfree(dev, peer_dev_int);
> > +			kfree(vbo);
>=20
> ie here we free two things

At this point in the init flow for KO_device, there has only been kallocs d=
one,
no device has been registered with virtbus.  So, only memory cleanup is
required.

>=20
> > +			return -ENOMEM;
> > +		}
> > +
> > +		pf->peers[i] =3D peer_dev_int;
> > +		vbo->peer_dev =3D &peer_dev_int->peer_dev;
> > +		peer_dev_int->peer_drv_int =3D peer_drv_int;
> > +		peer_dev_int->peer_dev.vdev =3D &vbo->vdev;
> > +
> > +		/* Initialize driver values */
> > +		for (j =3D 0; j < IIDC_EVENT_NBITS; j++)
> > +			bitmap_zero(peer_drv_int->current_events[j].type,
> > +				    IIDC_EVENT_NBITS);
> > +
> > +		mutex_init(&peer_dev_int->peer_dev_state_mutex);
> > +
> > +		peer_dev =3D &peer_dev_int->peer_dev;
> > +		peer_dev->peer_ops =3D NULL;
> > +		peer_dev->hw_addr =3D (u8 __iomem *)pf->hw.hw_addr;
> > +		peer_dev->peer_dev_id =3D ice_peers[i].id;
> > +		peer_dev->pf_vsi_num =3D vsi->vsi_num;
> > +		peer_dev->netdev =3D vsi->netdev;
> > +
> > +		peer_dev_int->ice_peer_wq =3D
> > +			alloc_ordered_workqueue("ice_peer_wq_%d",
> WQ_UNBOUND,
> > +						i);
> > +		if (!peer_dev_int->ice_peer_wq)
> > +			return -ENOMEM;
>=20
> Here we free nothing

This is a miss on my part.  At this point we should keep consistent and fre=
e the memory
that has been allocated as we unwind. =20

>=20
> > +
> > +		peer_dev->pdev =3D pdev;
> > +		qos_info =3D &peer_dev->initial_qos_info;
> > +
> > +		/* setup qos_info fields with defaults */
> > +		qos_info->num_apps =3D 0;
> > +		qos_info->num_tc =3D 1;
> > +
> > +		for (j =3D 0; j < IIDC_MAX_USER_PRIORITY; j++)
> > +			qos_info->up2tc[j] =3D 0;
> > +
> > +		qos_info->tc_info[0].rel_bw =3D 100;
> > +		for (j =3D 1; j < IEEE_8021QAZ_MAX_TCS; j++)
> > +			qos_info->tc_info[j].rel_bw =3D 0;
> > +
> > +		/* for DCB, override the qos_info defaults. */
> > +		ice_setup_dcb_qos_info(pf, qos_info);
> > +
> > +		/* make sure peer specific resources such as msix_count and
> > +		 * msix_entries are initialized
> > +		 */
> > +		switch (ice_peers[i].id) {
> > +		case IIDC_PEER_RDMA_ID:
> > +			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
> > +				peer_dev->msix_count =3D pf-
> >num_rdma_msix;
> > +				entry =3D &pf->msix_entries[pf-
> >rdma_base_vector];
> > +			}
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +
> > +		peer_dev->msix_entries =3D entry;
> > +		ice_peer_state_change(peer_dev_int,
> ICE_PEER_DEV_STATE_INIT,
> > +				      false);
> > +
> > +		vdev =3D &vbo->vdev;
> > +		vdev->name =3D ice_peers[i].name;
> > +		vdev->release =3D ice_peer_vdev_release;
> > +		vdev->dev.parent =3D &pdev->dev;
> > +
> > +		status =3D virtbus_dev_register(vdev);
> > +		if (status) {
> > +			virtbus_dev_unregister(vdev);
> > +			vdev =3D NULL;
>=20
> Here we double unregister and free nothing.
>=20
> You need to go through all of this really carefully and make some kind
> of sane lifetime model and fix all the error unwinding :(

Thanks for catching this.  A failure in virtbus_register_device()  does
*not* require a call virtbus_unregister_device.  The failure path for the
register function handles this.  Also, we need to remain consistent with fr=
eeing
on unwind.

>=20
> Why doesn't the release() function of vbo trigger the free of all this
> peer related stuff?
>=20
> Use a sane design model of splitting into functions to allocate single
> peices of memory, goto error unwind each function, and build things up
> properly.
>=20
> Jason

I am going to add this to the documentation to record the following informa=
tion.

The KO_device is responsible for allocating the memory for the virtbus_devi=
ce
and keeping it viable for the lifetime of the KO_device.  KO_device will ca=
ll
virtbus_register_device to start using the virtbus_device, and KO_device is
responslble for calling virtbus_unregister_device either on KO_device's exi=
t
path (remove/shutdown) or when it is done using the virtbus subsystem.

The KO_driver is responsible for allocating the memory for the virtbus_driv=
er
and keeping it viable for the lifetime of the KO_driver. KO_driver will cal=
l
virtbus_register_driver to start using the virtbus_driver, and KO_driver is
responsible for calling virtbus_unregister_driver either on KO_driver's exi=
t
path (remove/shutdown) or when it is done using the virtbus subsystem.

The premise is that the KO_device and KO_driver can load and unload multipl=
e
times and they can reconnect to each other through the virtbus on each
occurrence of their reloads.  So one example of a flow looks like the follo=
wing:

- KO_device loads (order of KO_device and KO_driver loading is irrelevant)
- KO_device allocates memory for virtbus_device(s) it expects to use and
        any backing memory it is going to use to interact with KO_driver.
- KO_device performs virtbus_register_device() which is the *only* place
        a device_initialize() is performed for virtbus_device.

- KO_driver loads
- KO_driver allocates memory for virtbus_driver(s) it expects to use and
        any backing memory it expects to use to interact with KO_device
- KO_driver performs virtbus_register_driver()

- virtbus matches virtbus_device and virtbus_driver and calls the
        virtbus_drivers's probe()

- KO_driver and KO_device interact with each other however they choose to d=
o so.

- KO_device (for example) receives a call to its remove callback
- KO_device's unload path severs any interaction the KO_device and KO_drive=
r
        were having - implementation dependant
- KO_device's unload path is required to perform a call to
        virtbus_unregister_device().  virtbus_unregister_device() is the *o=
nly*
        place a put_device() is performed.
- KO_device's unload path frees memory associated with the virtbus_device

- vitbus calls KO_drivers's .remove callback defined for the virtbus_driver

So, the lifespan of the virtbus_device is controlled by KO_device and the
lifespan of virtbus_driver is controlled by KO_driver.

It is required for the KO's to "allocate -> register -> unregister -> free"
virtbus objects.

-DaveE
