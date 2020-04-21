Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD7A1B330D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 01:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDUX1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 19:27:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:36529 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUX1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 19:27:30 -0400
IronPort-SDR: +nuxH7TIcDVprek4VSDM9hp0Fur7BdWU3zK+8CkBxgjavF6rsdCqAmNnPl+je4Wr3DjBqedBM3
 SvAfzROzty0w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:27:28 -0700
IronPort-SDR: NRrI7byYHf8lfiCi4lbhw1nFtJHbrzIoQ9s8nkyBBCwyCGG7bQSzkUOWdbM/Us4i0LstMWi5AA
 vVFEWfVWKpZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="456941948"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga006.fm.intel.com with ESMTP; 21 Apr 2020 16:27:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:25 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 16:27:24 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 Apr 2020 16:27:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggqH5J98Qf+A/KlRGdMsc42mGfYBfKuw8BZx/W4qovBPRDc4TCpoySUFS4OhbrBONxeWUcW7mApTNUuOPLDdkhx8d/x+kkqnM/wnxsYSTU0tINHIFpOe9SiLV6iWi/wpHvf31R91OpyiXWDer0gigqKdPr7hpePQhMXIxWEFkaAhV+tDWKk512xfJVHuf8i8h2V9UMM+YrJtdWeVRwxX+aZabtSIlwBUHqmI57nrKk3JQcvMXEfa+VQiYYj49MRVzR1ehlUv5MIftDdGyU73dG58DlaMh51ENuSbNulBx2nVRBNFEzxi3LAMKMXODYqN4VOxuzG/Ii7iEg4tTIVUPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSCy3HniathvYjWFwC2ReC7auhmI+9dob9ONbok/+do=;
 b=Omez/w4OOhxhNT2M437b9HHRQxEdJw3aeQZPZ9MOBsXYzyAhfI8qJbZLRFogsZs4EsxL8Vs8y/9+ovwVGQwNnNXOFz1kiOnsDGK4O+qMlhRsuGbuWPYNSx5I1CfQhZmeXwL055HAWY8iBudxVCKGIC//tdqxd6VljFva+uIAGWn8NsLqe820630v8QKrtQDvtwayqfUKcDO/H9NIhNx+nFoU9YgHs+yJwb9zrJRe/l+ljSFRDIr0fWwO4aYIvSEAnp49lYqtA6TDZpGTJC1kmmEpsMUfZ/tzHhGQ7GcGaPuuarP/gntxGNt5tIzA8Sp/AyyMtoyKwPqLMJWWY1gF7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSCy3HniathvYjWFwC2ReC7auhmI+9dob9ONbok/+do=;
 b=TQM4UfwRf2sywJaNZozpc9Orfh+LE7HvwpNA7RpyFZqEnjo2v19jDyy8pLvmAZeJnJCLOIAc0sIMZYVDlKBXrJg77BL570kResqQVWID+JbixpX0hjNjRLP/jgYWY1W59/wkOixFaH4QokS39UOqfEOTTL2FcJBwday8+ZFX6Nc=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB4594.namprd11.prod.outlook.com (2603:10b6:5:2a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Tue, 21 Apr 2020 23:27:13 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 23:27:13 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next v2 1/9] Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/9] Implementation of Virtual Bus
Thread-Index: AQHWF7NVLB1tcCGx3U+1R3mqkL/BoqiDe9IAgABpa3A=
Date:   Tue, 21 Apr 2020 23:27:13 +0000
Message-ID: <DM6PR11MB28417AFF32355A39994D76CADDD50@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
 <20200421120848.GR26002@ziepe.ca>
In-Reply-To: <20200421120848.GR26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=david.m.ertman@intel.com; 
x-originating-ip: [50.38.43.118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04ef8184-3269-42a8-ad52-08d7e64b85b3
x-ms-traffictypediagnostic: DM6PR11MB4594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4594843F6B79E623B671B7A6DDD50@DM6PR11MB4594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(55016002)(9686003)(76116006)(6636002)(64756008)(66946007)(33656002)(498600001)(66476007)(66446008)(52536014)(8936002)(66556008)(5660300002)(2906002)(7416002)(86362001)(7696005)(54906003)(110136005)(8676002)(53546011)(81156014)(71200400001)(6506007)(186003)(4326008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4K5jJ7YncSEyrrfdT/Ofk0SjVZS1Ex70owSVUiACN59NaTgG8amXbJjIGDyAA6IubNSr/gfR1xgs1r8nuTqAnXn4DGsgIikg1MFNpC6vbWpXgLdS6wja3QaVkzxDgdOO7Oat+eXODzuaPP9yKInWvcxNnBJIXKd+lEk8dN7+cxFzunh+R8Z9Y0pO8NX6SHF4O84Ctc6PxVR/0bQQ+DCPr49ptkCZtm00A55j9/Ot/Joe25r27iYpwbkC0y9C/IWJ4P3sVwfhuxXWAsIo6LjYx39jPIYQbGrJ2QS7yW5SS6FQKZ4WdmvE3WOTmcz89XmUTA0kFO9oA7N1v6/2n6+3UoNVejQSQnYDOMzrbHoo9faZsZVWwXDg/aXLaGn1SNyHPvV9/sc/mCStggCkvH6OtlTs+LFPXt+mlnqQNer/KQF6r2/cC1MCAR2F+Th+QXEK
x-ms-exchange-antispam-messagedata: KYs6gIxci2tp3jksCuCXEKzc4nI2xKvy0O0gmNI5B+ZHcMsCa2EJqUxGlUH3ZC1gTTY5oiiBRKKUb2YLaQrPKwV5IWRnELhw9sIL3QhcGx8vDTojL2nOYASCksM9NCLmJnOhTfI1JLNmqnTAuMElGw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ef8184-3269-42a8-ad52-08d7e64b85b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 23:27:13.5715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KhsCMCZI62ZioHb89099Q7f2Yo1CX0iuGoTQK6arxO6mjp0/k6T9viE5S8yrES0DYaNbOeKO44cjvEYvAXnHpx8h7NgJdEcTrOEtTcLIPrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, April 21, 2020 5:09 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> louis.bossart@linux.intel.com; Patil, Kiran <kiran.patil@intel.com>; Bowe=
rs,
> AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
>=20
> On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> > +/**
> > + * virtbus_release_device - Destroy a virtbus device
> > + * @_dev: device to release
> > + */
> > +static void virtbus_release_device(struct device *_dev)
> > +{
> > +	struct virtbus_device *vdev =3D to_virtbus_dev(_dev);
> > +	int ida =3D vdev->id;
> > +
> > +	vdev->release(vdev);
> > +	ida_simple_remove(&virtbus_dev_ida, ida);
> > +}
> > +
> > +/**
> > + * virtbus_register_device - add a virtual bus device
> > + * @vdev: virtual bus device to add
> > + */
> > +int virtbus_register_device(struct virtbus_device *vdev)
> > +{
> > +	int ret;
> > +
> > +	if (!vdev->release) {
> > +		dev_err(&vdev->dev, "virtbus_device MUST have a .release
> callback that does something.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Don't return on error here before the device_initialize.
> > +	 * All error paths out of this function must perform a
> > +	 * put_device(), unless the release callback does not exist,
> > +	 * so that the .release() callback is called, and thus have
> > +	 * to occur after the device_initialize.
> > +	 */
> > +	device_initialize(&vdev->dev);
> > +
> > +	vdev->dev.bus =3D &virtual_bus_type;
> > +	vdev->dev.release =3D virtbus_release_device;
> > +
> > +	/* All device IDs are automatically allocated */
> > +	ret =3D ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > +
> > +	if (ret < 0) {
> > +		dev_err(&vdev->dev, "get IDA idx for virtbus device
> failed!\n");
> > +		goto device_pre_err;
>=20
> This still has the problem I described, why are you resending without
> fixing?
>=20
> Jason

Fix should be in the next revision - sorry for the confusion.

-DaveE
