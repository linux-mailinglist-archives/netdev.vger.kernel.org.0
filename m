Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E167E286F0A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgJHHOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:14:21 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3627 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHHOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:14:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7ebc3f0000>; Thu, 08 Oct 2020 00:14:07 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 07:14:19 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.52) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 07:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0FqPe2WXWYcXaRFAOuh6JKSQGDWNBwGr5HgweoDDVJesDbrfhvPqe/tEXMeXV2SKLKrzKcwQMPTE+UQVIMISK1oYewQysEi3geX5eaXU5MIZqcH3avkiIMXOKwNV/SuX21pUIYvkXkOSX6sdPcY3pPiE0E0UWiagQQ28lmW20FAI8WQXy09tYOKqNxdQvMo1RSlNibKDb3QtEPTj/Wvu7dWsXnXn4s8EcS8QV6nipIpz94kev9cK6c1NrQdBGpjewrY13fqDv3HIjuU7kBB38nyEs+aIFcnA4dzHQCBMfINqMy3P/IY1v35m3IJ39jZcFaig795FjG0hgLZkkUvRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4ZR/ODNvERLst5ICSYanZkACMwaB+mr7lzt5lxqrmY=;
 b=gLJRfL35nLc64V7WKr0alZhkqsn0eX7lECt4AN4aDl0rUpmIpxDrZx3cVJem9lBxsSEsucZMS3pYFTv9nQdtX+7Pu8F89k16TfQM1iuQUWYSFYDuYY6j/bHsj1QMu4P+LQGwHD2w/eP5D7JRC14TxxFToK5pNxCqDuWzE7MampjJl5Cf1yptjrpl9qcKzzyhrPKAChaejc5rQBdDNLFemnR9O4kAmIUd1RPlAmwI3Y/AsFpjInuIPMwFszAtJagXvI9/t1tfBJnh3tkn7iWQRHfbOdoqK6cdZuFw6fHGiPdBcd5ZNHKitHowfzH4t0Bb7E9QdoNXySRZT8Jj2w7cCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3954.namprd12.prod.outlook.com (2603:10b6:a03:1af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 8 Oct
 2020 07:14:18 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 07:14:18 +0000
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
Thread-Index: AQHWm05cPW7H51WMukmCocLPE63Nf6mKKyGAgACGC4CAAB03gIABpCoAgAAWQgCAAAuCMIAACwKAgAADjQCAAAZvgIAAB6yAgABvlmCAAA/xgIAAF0PQ
Date:   Thu, 8 Oct 2020 07:14:17 +0000
Message-ID: <BY5PR12MB4322D48FADAAAD66DE7159D7DC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201008052623.GB13580@unreal>
In-Reply-To: <20201008052623.GB13580@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 454bfa66-3fe9-4ec8-2d47-08d86b59c56d
x-ms-traffictypediagnostic: BY5PR12MB3954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB39547BF2B057F9B14F37939FDC0B0@BY5PR12MB3954.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0u0DlBvuXQYBxKvYM8uqdtmzUKWS189l3Ptmas5TlHp8jlsu8lXoDXLCjh4uA+wENhyQ5d9AW7sJNDpF7Y3bdaUoqGOvRobgop1FZSQrfMxJl56MujgkwPTZlXbd9ZxaejQCvho61bgJgdFT5JRcRKGv7d6DkM0uiHrqK0afhsstWFwb0xUH1XfjWfemln/3SP0j3w6KCh2LIgptyiHCegHTiMDJ5zkhkxJ/FkGyscK615n04eVfsMMA+LldwQXbw+2iBGw1baRbfsbg6ANHFKsEUGktXHBDzGrQW1b1hvA0PdYd35XgQrzsZsK0QCCF4LRMgnTNPzIR4JMMdp1raBK+1Wp1FjbQjoVks/WRwC7LqcKFSarUw6c3yatsnCZB26uivoe24ySFyIkzpIFR4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(53546011)(316002)(7416002)(55016002)(9686003)(2906002)(4326008)(54906003)(83380400001)(83080400001)(478600001)(8676002)(966005)(26005)(186003)(52536014)(33656002)(6506007)(86362001)(71200400001)(55236004)(6916009)(76116006)(66946007)(66556008)(8936002)(66446008)(64756008)(7696005)(5660300002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IvWvGCce/b1jkbHeiFiwBcOcJx1juAzOnvUpFsuQaT+z/DVUAZ4ZlJJJ0MuKjtgEcU+w2TfElrb6qNE1w+oSgRb5H3kpxD1YOwm4xTEaSrnZD9AV9yyuriE0qKLdk9NI3RcTfPEYWPpCbOHWszWShbBuDj33TctIie0Q32nVcHMuJ4nkoHT+xC0571g8f+La9lNd2E1YjxcF4VVidE89sPcyNIFy9R8kE+OLbpVg3ETfNcrOPNXABMwJKgbPNRxecEI9a1RxfTJGyv68Bs9Z6dycLBN4GVjVnXLlErj5XMe4vwIRoDfv4udUMmb/fJ+VCfeaIPDALtJJ8A0VNwcIvItqV2ABHGEDbHsvCsYDsREYjpW41zgMcWhAjvEhN6mmrIJi1xB8ZqmVWVWVqpbjVjjanaOtA251UHqORkJlBxyP6l2pmCYRc/+JLkMYzlXiDRO9gqZAcQDq7RmOAFVjclUeyhCNXd1/vvgIO1D/Dotd2cj+E3n82o8fgFa9kOoIzErcqYB0RKhBbkSiV1NPiRVwctw+yDQX8cNTCeXKlIxxs+q3bDeJUbWaYDNvm+Muin7MEqlmgdWT3m8JmJEsdKePrfGj3sQCPMFCGsXw78LSOrWfKyLgyDSR6JUR+RKrb8GjYqEHirBeZTfSSdYXBg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454bfa66-3fe9-4ec8-2d47-08d86b59c56d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 07:14:18.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i0gP4yKgzsKxSUGk2nCR6G+/t2p1RPZQ3/CCXMSOWYp/P2fLMItFHlD/nC+L7WvzDZtf/6XSOxzUlefVq3VdZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3954
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602141247; bh=N4ZR/ODNvERLst5ICSYanZkACMwaB+mr7lzt5lxqrmY=;
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
        b=pOaj6xSdrprY479+0debN/8V3cyMlCgnAs564iWLDrNxqZIg20pU30aE17tnojDpu
         y0l8Epkx4BMoPUbimKAREBkc+2bJaja5WvOqet4sP6le6gezVC1xsLQaJl9mT9dqjm
         P3BqmlgoU/hzdd7yyGfyS0jcqwbDwNSEIZVpNtzhzd/7uzeRxwMg4LNjwlNRpwPL2w
         STC98T0dsNa1nmmkwYwvLXvT3aIhvD/khVZ3hfjtT/QHB2bwGBiDixoB9HxcxhqV6D
         rJjsquXK4py/H+Z5sEhqciWOvRi63JQZateGNaLNUcf/s3XkCeDjdKek75hGnkd3jV
         LCVixQYSUH+uw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, October 8, 2020 10:56 AM
>=20
> On Thu, Oct 08, 2020 at 04:56:01AM +0000, Parav Pandit wrote:
> >
> >
> > > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Sent: Thursday, October 8, 2020 3:20 AM
> > >
> > >
> > > On 10/7/20 4:22 PM, Ertman, David M wrote:
> > > >> -----Original Message-----
> > > >> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > >> Sent: Wednesday, October 7, 2020 1:59 PM
> > > >> To: Ertman, David M <david.m.ertman@intel.com>; Parav Pandit
> > > >> <parav@nvidia.com>; Leon Romanovsky <leon@kernel.org>
> > > >> Cc: alsa-devel@alsa-project.org; parav@mellanox.com;
> > > >> tiwai@suse.de; netdev@vger.kernel.org;
> > > >> ranjani.sridharan@linux.intel.com;
> > > >> fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> > > >> dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> > > >> <jgg@nvidia.com>; gregkh@linuxfoundation.org; kuba@kernel.org;
> > > >> Williams, Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > > >> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > > >> <kiran.patil@intel.com>
> > > >> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > > >>
> > > >>
> > > >>
> > > >>>> Below is most simple, intuitive and matching with core APIs for
> > > >>>> name and design pattern wise.
> > > >>>> init()
> > > >>>> {
> > > >>>> 	err =3D ancillary_device_initialize();
> > > >>>> 	if (err)
> > > >>>> 		return ret;
> > > >>>>
> > > >>>> 	err =3D ancillary_device_add();
> > > >>>> 	if (ret)
> > > >>>> 		goto err_unwind;
> > > >>>>
> > > >>>> 	err =3D some_foo();
> > > >>>> 	if (err)
> > > >>>> 		goto err_foo;
> > > >>>> 	return 0;
> > > >>>>
> > > >>>> err_foo:
> > > >>>> 	ancillary_device_del(adev);
> > > >>>> err_unwind:
> > > >>>> 	ancillary_device_put(adev->dev);
> > > >>>> 	return err;
> > > >>>> }
> > > >>>>
> > > >>>> cleanup()
> > > >>>> {
> > > >>>> 	ancillary_device_de(adev);
> > > >>>> 	ancillary_device_put(adev);
> > > >>>> 	/* It is common to have a one wrapper for this as
> > > >>>> ancillary_device_unregister().
> > > >>>> 	 * This will match with core device_unregister() that has
> > > >>>> precise documentation.
> > > >>>> 	 * but given fact that init() code need proper error
> > > >>>> unwinding, like above,
> > > >>>> 	 * it make sense to have two APIs, and no need to export
> > > >>>> another symbol for unregister().
> > > >>>> 	 * This pattern is very easy to audit and code.
> > > >>>> 	 */
> > > >>>> }
> > > >>>
> > > >>> I like this flow +1
> > > >>>
> > > >>> But ... since the init() function is performing both device_init
> > > >>> and device_add - it should probably be called
> > > >>> ancillary_device_register, and we are back to a single exported
> > > >>> API for both register and unregister.
> > > >>
> > > >> Kind reminder that we introduced the two functions to allow the
> > > >> caller to know if it needed to free memory when initialize()
> > > >> fails, and it didn't need to free memory when add() failed since
> > > >> put_device() takes care of it. If you have a single init()
> > > >> function it's impossible to know which behavior to select on error=
.
> > > >>
> > > >> I also have a case with SoundWire where it's nice to first
> > > >> initialize, then set some data and then add.
> > > >>
> > > >
> > > > The flow as outlined by Parav above does an initialize as the
> > > > first step, so every error path out of the function has to do a
> > > > put_device(), so you would never need to manually free the memory
> > > > in
> > > the setup function.
> > > > It would be freed in the release call.
> > >
> > > err =3D ancillary_device_initialize(); if (err)
> > > 	return ret;
> > >
> > > where is the put_device() here? if the release function does any
> > > sort of kfree, then you'd need to do it manually in this case.
> > Since device_initialize() failed, put_device() cannot be done here.
> > So yes, pseudo code should have shown, if (err) {
> > 	kfree(adev);
> > 	return err;
> > }
> >
> > If we just want to follow register(), unregister() pattern,
> >
> > Than,
> >
> > ancillar_device_register() should be,
> >
> > /**
> >  * ancillar_device_register() - register an ancillary device
> >  * NOTE: __never directly free @adev after calling this function, even
> > if it returned
> >  * an error. Always use ancillary_device_put() to give up the reference
> initialized by this function.
> >  * This note matches with the core and caller knows exactly what to be
> done.
> >  */
> > ancillary_device_register()
> > {
> > 	device_initialize(&adev->dev);
> > 	if (!dev->parent || !adev->name)
> > 		return -EINVAL;
> > 	if (!dev->release && !(dev->type && dev->type->release)) {
> > 		/* core is already capable and throws the warning when
> release callback is not set.
> > 		 * It is done at drivers/base/core.c:1798.
> > 		 * For NULL release it says, "does not have a release()
> function, it is broken and must be fixed"
> > 		 */
> > 		return -EINVAL;
> > 	}
> > 	err =3D dev_set_name(adev...);
> > 	if (err) {
> > 		/* kobject_release() -> kobject_cleanup() are capable to
> detect if name is set/ not set
> > 		  * and free the const if it was set.
> > 		  */
> > 		return err;
> > 	}
> > 	err =3D device_add(&adev->dev);
> > 	If (err)
> > 		return err;
> > }
> >
> > Caller code:
> > init()
> > {
> > 	adev =3D kzalloc(sizeof(*foo_adev)..);
> > 	if (!adev)
> > 		return -ENOMEM;
> > 	err =3D ancillary_device_register(&adev);
> > 	if (err)
> > 		goto err;
> >
> > err:
> > 	ancillary_device_put(&adev);
> > 	return err;
> > }
> >
> > cleanup()
> > {
> > 	ancillary_device_unregister(&adev);
> > }
> >
> > Above pattern is fine too matching the core.
> >
> > If I understand Leon correctly, he prefers simple register(), unregiste=
r()
> pattern.
> > If, so it should be explicit register(), unregister() API.
>=20
> This is my summary
> https://lore.kernel.org/linux-rdma/20201008052137.GA13580@unreal
> The API should be symmetric.
>=20

I disagree to your below point.
> 1. You are not providing driver/core API but simplification and obfuscati=
on
> of basic primitives and structures. This is new layer. There is no room f=
or
> a claim that we must to follow internal API.
If ancillary bus has
ancillary_device_add(), it cannot do device_initialize() and device_add() i=
n both.

I provided two examples and what really matters is a given patchset uses (n=
eed to use) which pattern,
initialize() + add(), or register() + unregister().

As we all know that API is not added for future. It is the future patch ext=
ends it.
So lets wait for Pierre to reply if soundwire can follow register(), unregi=
ster() sequence.
This way same APIs can service both use-cases.

Regarding,
> 3. You can't "ask" from users to call internal calls (put_device) over in=
ternal
> fields in ancillary_device.
In that case if should be ancillary_device_put() ancillary_device_release()=
.

Or we should follow the patten of ib_alloc_device [1],
ancillary_device_alloc()
    -> kzalloc(adev + dev) with compile time assert check like rdma and vdp=
a subsystem.
    ->device_initialize()
ancillary_device_add()

ancillar_device_de() <- balances with add
ancillary_device_dealloc() <-- balances with device_alloc(), which does the=
 put_device() + free the memory allocated in alloc().

This approach of [1] also eliminates exposing adev.dev.release =3D <drivers=
_release_method_to_free_adev> in drivers.
And container_of() benefit also continues..

[1] https://elixir.bootlin.com/linux/v5.9-rc8/source/include/rdma/ib_verbs.=
h#L2791

