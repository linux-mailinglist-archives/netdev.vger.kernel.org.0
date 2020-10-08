Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A522871C7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgJHJpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:45:36 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7480 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHJpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:45:36 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7edf870001>; Thu, 08 Oct 2020 02:44:39 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 09:45:33 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.50) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 09:45:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJxUGlRKAmS6pqz6XGkwdEe09I5OleL2W3phVPj9R02idVOLR8Go0mUwmK+K7B0sX/fz9ge6AAKkG0fktdv29ikmscSiQh5cuKExsZ0sMvpwOLP1m3+lb5wNQXno558Nbb2J80kKRN6FFeZ9kRmPKADj0qzj0F7SBt0HmibJY7G65YSZ2noyHNDKUzofPgtTALPozCg4F18HhqbFQaWmFyahET0z0uyCmN9/SFx6VmIt4V6j7iDumMDbIcYD6oty6VPlF2+jY+LMzHsGRxy4Ly/W73VTSZ3cWbNwdrvFyCClBkzmTn/c6rlaVdQxKD0fnhXL+jCI93f9pj4Bp8pxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMO0nvWM8hVMvld9xLpPpDoeX+gIBA28x6mWTEdJtaw=;
 b=eUBdnDhrVdiOBkCsz4nmcuC79yV1Vs3eqEak7D5lgnNFAuRCiapOqel2S6+wYMPpjfRgQN6wBhSQrWVjOQ6cdI2RcChzugHZlA2lZa6hHBQvRYhCjxViD4VPQTwbguyJFcFanhOksIhGs0l7smfTjn0tGG74feJr7DQytiFBZ5X/BaJB+tKLM+p1FbnxpQW7iz5jZRLy/r4RdfSKiv7Lag6bfeNP4w6RxPbz9Musv3ggLDXGrQgKg3xty4xRXp+gY4fYs77KrZGIdkhytdNYhGbKCGkjL53zYSelxv/nh+PTsbJSwksbzyODMgJdiwRDtx4JiFE7derm/2jRdKrPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2614.namprd12.prod.outlook.com (2603:10b6:a03:6b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.42; Thu, 8 Oct
 2020 09:45:29 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 09:45:29 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm05cPW7H51WMukmCocLPE63Nf6mKKyGAgACGC4CAAB03gIABpCoAgAAWQgCAAAuCMIAACwKAgAADjQCAAAZvgIAAB6yAgABvlmCAAA/xgIAAF0PQgAAPlYCAAAHb8A==
Date:   Thu, 8 Oct 2020 09:45:29 +0000
Message-ID: <BY5PR12MB4322658669FFC396D8EE5D84DC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201008052623.GB13580@unreal>
 <BY5PR12MB4322D48FADAAAD66DE7159D7DC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201008074525.GJ13580@unreal>
In-Reply-To: <20201008074525.GJ13580@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b43b3b5b-be1c-42b0-c61b-08d86b6ee463
x-ms-traffictypediagnostic: BYAPR12MB2614:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB261444F9FAECFE8CD1EB95E8DC0B0@BYAPR12MB2614.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y86+31MaKzTRJOHDzPjxWK9CB3JhUeh7MzlBEdhX/HcbY97gigCm1nwtxh/iJ5GoAksal6wM8CURDL9GIhfI9dkCiU4fmd4FsmuOoVe0eizM88N0ae43lv8qfM4TOjl6firWb61D5WlYbx9ejtBRDaimeZBljEkLUMIqHZsjquIXxlLdjKKlNSFcDYEEGUx7px1FEITNgl3VTyuBb0ZmNNvndYuGkYCD7jazo92nruxuvPjDCHtYuKZ5aI6HHHr5FxlmL+5uPppPcHAogcIJJ8IJOwFxyWLZ/yBqM1nGjRzod6jfvhkSYz4ue4+vAwcpE9wclbcHF5NTvnbtqEw0WxpK4bWoNRCWbDMD60nWxY00qwKKgGJEMVr28CX0MsREYhdHCTdiv0VQAhMyBechCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(54906003)(7696005)(9686003)(53546011)(6506007)(478600001)(52536014)(6916009)(7416002)(55236004)(4326008)(83080400001)(71200400001)(2906002)(26005)(33656002)(966005)(66446008)(66556008)(64756008)(76116006)(5660300002)(83380400001)(66476007)(66946007)(55016002)(316002)(186003)(8936002)(86362001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: f8zhSdnuCwo3UK7P2shPzyW6i7Km8GdoKcyq2CyrGJa40IuGOqabj7JaWQkSESI/XrgT1P7SYRRfKBbhcMW6lgEtuDAYTiWvxMDiHYyiz+hae2hYJQ41Yh8pF5Ns2VMtnKVFAkV/MqS3kNOJSExV6zh+1k3YYRX0tBE/yb+rVTdJuzBrHHUmS0D4vsqfNhGvWnACynz+pP4Qd/vs8cduIEKD0z4bFeKvXVIxf+vGO4QujDVZ3gYQgAyQK152OG3N1jllqg9tIo0OTtMQsmxOiKjZtYEUMt8wCNM8RbXZ89Rc8t3tAafhUsZ7ky9+I7fdSFSultrktj3vC/oVWJJWwaHvy2GyMZBWXUm6QgTBtJQkhyDqAsyxebM+uq9UyBIff/r/L/zut66PM+x+sy2/COQEP+sVTia06VqDmgnnT3yJiOJB9H2Y3f4W5KOnzQURE7g1inTVKhrXfBMjh+OkCQEhxVAuH7F7oXqKBO8A8IXzAJvoitKOTeyqQg5RBUQ1zWjBwxeAPevJQel31WPe+Rs5EMqo8yqDrQkGwJI0DJ+vyxuO8b3jyMM1BdTnZkvRUEWPPAZax09lRjnsJvdFjNVMgOYIuUc/+6czUYxi3U7D4DIfeH183jlQnWljLDDdErRRYvpLPgsK0Xg0RLKlrw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43b3b5b-be1c-42b0-c61b-08d86b6ee463
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 09:45:29.3312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkvyGA6EDccN7f/mvSfEIoFFKKAmyrXtpZqiShdGCUJNm8YbmiFaaIPFpuMtjBmf6oRrIN42ZxDJcWcEtFziXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2614
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602150279; bh=CMO0nvWM8hVMvld9xLpPpDoeX+gIBA28x6mWTEdJtaw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=gQ5mWgx9H2lqDP9CfjAMgx5eDEc/mwbcNqSV6AVycQn63In8+K+kSx+i0x4qOyJMc
         cylTwbkDdn4wnGY4HxJM4VN78OxUCrN0kFp5PoiIyaGsPppL6lRFOIZQ6yXDJjyUfh
         9dUgsM2Vr12Yx2AatIW1XxbXnx7MtUzjXlULTyhG8W0rQhGoGwwcq3Y3b/Qol1mbh2
         RvI6kjLskcFUBzsmhARPjw/nQGmI8pphmiJvMZfrJwC14/fi79WFUMHYF9KHOfVGYr
         rViYXBGom3lCRpwvmwTAZDTP+dQFsJVi0QJR9h8pH/VylwbdxexpGvVWyp4qo/jhPW
         iMMU4iAT1Wyrg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, October 8, 2020 1:15 PM
>=20
> On Thu, Oct 08, 2020 at 07:14:17AM +0000, Parav Pandit wrote:
> >
> >
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Thursday, October 8, 2020 10:56 AM
> > >
> > > On Thu, Oct 08, 2020 at 04:56:01AM +0000, Parav Pandit wrote:
> > > >
> > > >
> > > > > From: Pierre-Louis Bossart
> > > > > <pierre-louis.bossart@linux.intel.com>
> > > > > Sent: Thursday, October 8, 2020 3:20 AM
> > > > >
> > > > >
> > > > > On 10/7/20 4:22 PM, Ertman, David M wrote:
> > > > > >> -----Original Message-----
> > > > > >> From: Pierre-Louis Bossart
> > > > > >> <pierre-louis.bossart@linux.intel.com>
> > > > > >> Sent: Wednesday, October 7, 2020 1:59 PM
> > > > > >> To: Ertman, David M <david.m.ertman@intel.com>; Parav Pandit
> > > > > >> <parav@nvidia.com>; Leon Romanovsky <leon@kernel.org>
> > > > > >> Cc: alsa-devel@alsa-project.org; parav@mellanox.com;
> > > > > >> tiwai@suse.de; netdev@vger.kernel.org;
> > > > > >> ranjani.sridharan@linux.intel.com;
> > > > > >> fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> > > > > >> dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> > > > > >> <jgg@nvidia.com>; gregkh@linuxfoundation.org;
> > > > > >> kuba@kernel.org; Williams, Dan J <dan.j.williams@intel.com>;
> > > > > >> Saleem, Shiraz <shiraz.saleem@intel.com>;
> > > > > >> davem@davemloft.net; Patil, Kiran <kiran.patil@intel.com>
> > > > > >> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > > > > >>
> > > > > >>
> > > > > >>
> > > > > >>>> Below is most simple, intuitive and matching with core APIs
> > > > > >>>> for name and design pattern wise.
> > > > > >>>> init()
> > > > > >>>> {
> > > > > >>>> 	err =3D ancillary_device_initialize();
> > > > > >>>> 	if (err)
> > > > > >>>> 		return ret;
> > > > > >>>>
> > > > > >>>> 	err =3D ancillary_device_add();
> > > > > >>>> 	if (ret)
> > > > > >>>> 		goto err_unwind;
> > > > > >>>>
> > > > > >>>> 	err =3D some_foo();
> > > > > >>>> 	if (err)
> > > > > >>>> 		goto err_foo;
> > > > > >>>> 	return 0;
> > > > > >>>>
> > > > > >>>> err_foo:
> > > > > >>>> 	ancillary_device_del(adev);
> > > > > >>>> err_unwind:
> > > > > >>>> 	ancillary_device_put(adev->dev);
> > > > > >>>> 	return err;
> > > > > >>>> }
> > > > > >>>>
> > > > > >>>> cleanup()
> > > > > >>>> {
> > > > > >>>> 	ancillary_device_de(adev);
> > > > > >>>> 	ancillary_device_put(adev);
> > > > > >>>> 	/* It is common to have a one wrapper for this as
> > > > > >>>> ancillary_device_unregister().
> > > > > >>>> 	 * This will match with core device_unregister() that has
> > > > > >>>> precise documentation.
> > > > > >>>> 	 * but given fact that init() code need proper error
> > > > > >>>> unwinding, like above,
> > > > > >>>> 	 * it make sense to have two APIs, and no need to export
> > > > > >>>> another symbol for unregister().
> > > > > >>>> 	 * This pattern is very easy to audit and code.
> > > > > >>>> 	 */
> > > > > >>>> }
> > > > > >>>
> > > > > >>> I like this flow +1
> > > > > >>>
> > > > > >>> But ... since the init() function is performing both
> > > > > >>> device_init and device_add - it should probably be called
> > > > > >>> ancillary_device_register, and we are back to a single
> > > > > >>> exported API for both register and unregister.
> > > > > >>
> > > > > >> Kind reminder that we introduced the two functions to allow
> > > > > >> the caller to know if it needed to free memory when
> > > > > >> initialize() fails, and it didn't need to free memory when
> > > > > >> add() failed since
> > > > > >> put_device() takes care of it. If you have a single init()
> > > > > >> function it's impossible to know which behavior to select on e=
rror.
> > > > > >>
> > > > > >> I also have a case with SoundWire where it's nice to first
> > > > > >> initialize, then set some data and then add.
> > > > > >>
> > > > > >
> > > > > > The flow as outlined by Parav above does an initialize as the
> > > > > > first step, so every error path out of the function has to do
> > > > > > a put_device(), so you would never need to manually free the
> > > > > > memory in
> > > > > the setup function.
> > > > > > It would be freed in the release call.
> > > > >
> > > > > err =3D ancillary_device_initialize(); if (err)
> > > > > 	return ret;
> > > > >
> > > > > where is the put_device() here? if the release function does any
> > > > > sort of kfree, then you'd need to do it manually in this case.
> > > > Since device_initialize() failed, put_device() cannot be done here.
> > > > So yes, pseudo code should have shown, if (err) {
> > > > 	kfree(adev);
> > > > 	return err;
> > > > }
> > > >
> > > > If we just want to follow register(), unregister() pattern,
> > > >
> > > > Than,
> > > >
> > > > ancillar_device_register() should be,
> > > >
> > > > /**
> > > >  * ancillar_device_register() - register an ancillary device
> > > >  * NOTE: __never directly free @adev after calling this function,
> > > > even if it returned
> > > >  * an error. Always use ancillary_device_put() to give up the
> > > > reference
> > > initialized by this function.
> > > >  * This note matches with the core and caller knows exactly what
> > > > to be
> > > done.
> > > >  */
> > > > ancillary_device_register()
> > > > {
> > > > 	device_initialize(&adev->dev);
> > > > 	if (!dev->parent || !adev->name)
> > > > 		return -EINVAL;
> > > > 	if (!dev->release && !(dev->type && dev->type->release)) {
> > > > 		/* core is already capable and throws the warning when
> > > release callback is not set.
> > > > 		 * It is done at drivers/base/core.c:1798.
> > > > 		 * For NULL release it says, "does not have a release()
> > > function, it is broken and must be fixed"
> > > > 		 */
> > > > 		return -EINVAL;
> > > > 	}
> > > > 	err =3D dev_set_name(adev...);
> > > > 	if (err) {
> > > > 		/* kobject_release() -> kobject_cleanup() are capable to
> > > detect if name is set/ not set
> > > > 		  * and free the const if it was set.
> > > > 		  */
> > > > 		return err;
> > > > 	}
> > > > 	err =3D device_add(&adev->dev);
> > > > 	If (err)
> > > > 		return err;
> > > > }
> > > >
> > > > Caller code:
> > > > init()
> > > > {
> > > > 	adev =3D kzalloc(sizeof(*foo_adev)..);
> > > > 	if (!adev)
> > > > 		return -ENOMEM;
> > > > 	err =3D ancillary_device_register(&adev);
> > > > 	if (err)
> > > > 		goto err;
> > > >
> > > > err:
> > > > 	ancillary_device_put(&adev);
> > > > 	return err;
> > > > }
> > > >
> > > > cleanup()
> > > > {
> > > > 	ancillary_device_unregister(&adev);
> > > > }
> > > >
> > > > Above pattern is fine too matching the core.
> > > >
> > > > If I understand Leon correctly, he prefers simple register(),
> > > > unregister()
> > > pattern.
> > > > If, so it should be explicit register(), unregister() API.
> > >
> > > This is my summary
> > > https://lore.kernel.org/linux-rdma/20201008052137.GA13580@unreal
> > > The API should be symmetric.
> > >
> >
> > I disagree to your below point.
> > > 1. You are not providing driver/core API but simplification and
> > > obfuscation of basic primitives and structures. This is new layer.
> > > There is no room for a claim that we must to follow internal API.
> > If ancillary bus has
> > ancillary_device_add(), it cannot do device_initialize() and device_add=
() in
> both.
> >
> > I provided two examples and what really matters is a given patchset
> > uses (need to use) which pattern,
> > initialize() + add(), or register() + unregister().
> >
> > As we all know that API is not added for future. It is the future patch
> extends it.
> > So lets wait for Pierre to reply if soundwire can follow register(),
> unregister() sequence.
> > This way same APIs can service both use-cases.
> >
> > Regarding,
> > > 3. You can't "ask" from users to call internal calls (put_device)
> > > over internal fields in ancillary_device.
> > In that case if should be ancillary_device_put() ancillary_device_relea=
se().
> >
> > Or we should follow the patten of ib_alloc_device [1],
> > ancillary_device_alloc()
> >     -> kzalloc(adev + dev) with compile time assert check like rdma and=
 vdpa
> subsystem.
> >     ->device_initialize()
> > ancillary_device_add()
> >
> > ancillar_device_de() <- balances with add
> > ancillary_device_dealloc() <-- balances with device_alloc(), which does=
 the
> put_device() + free the memory allocated in alloc().
> >
> > This approach of [1] also eliminates exposing adev.dev.release =3D
> <drivers_release_method_to_free_adev> in drivers.
> > And container_of() benefit also continues..
> >
> > [1]
> > https://elixir.bootlin.com/linux/v5.9-rc8/source/include/rdma/ib_verbs
> > .h#L2791
> >
>=20
> My code looks like this, probably yours looks the same.
>=20
>   247                 priv->adev[i] =3D kzalloc(sizeof(*priv->adev[i]), G=
FP_KERNEL);
>   248                 if (!priv->adev[i])
>   249                         goto init_err;
>   250
>   251                 adev =3D &priv->adev[i]->adev;
>   252                 adev->id =3D idx;
>   253                 adev->name =3D mlx5_adev_devices[i].suffix;
>   254                 adev->dev.parent =3D dev->device;
>   255                 adev->dev.release =3D adev_release;
>   256                 priv->adev[i]->mdev =3D dev;
>   257
>   258                 ret =3D ancillary_device_initialize(adev);
>   259                 if (ret)
>   260                         goto init_err;
>   261
>   262                 ret =3D ancillary_device_add(adev);
>   263                 if (ret) {
>   264                         put_device(&adev->dev);
>   265                         goto add_err;
>   266                 }

Yes, subfunction code is also very similar.
You expressed concerned that you didn't like put_device() at [1].
But in above code is touching adev->dev.{parent, release} is ok?
>   254                 adev->dev.parent =3D dev->device;
>   255                 adev->dev.release =3D adev_release;

If not,

We can make it elegant by doing,

the patten of ib_alloc_device [1],
ancillary_device_alloc()
    -> kzalloc(adev + dev) with compile time assert check like rdma and vdp=
a subsystem.
    ->device_initialize()
ancillary_device_add()

ancillar_device_de() <- balances with add
ancillary_device_dealloc() <-- balances with device_alloc(), which does the=
 put_device() + free the memory allocated in alloc().

This approach of [2] also eliminates exposing adev.dev.release =3D <drivers=
_release_method_to_free_adev> in drivers.
And container_of() benefit also continues..

[1] https://lore.kernel.org/linux-rdma/20201007192610.GD3964015@unreal/
[2] https://elixir.bootlin.com/linux/v5.9-rc8/source/include/rdma/ib_verbs.=
h#L2791
