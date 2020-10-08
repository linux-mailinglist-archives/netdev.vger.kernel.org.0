Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B55287A11
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgJHQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:39:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:54555 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgJHQj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:39:27 -0400
IronPort-SDR: fymqkbvsVhQlUYXmhAZroj0xHLTfaNl/tyJygPcpGpzX1CNNj8IrWiD8aw+92ePiI27PaJgnCZ
 DfDXg3saaigQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="152284871"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="152284871"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:39:26 -0700
IronPort-SDR: Xb482FMo43Jy9c6jxmHYpEibiLjcOnUFmvEEDrF/uRMm4WmspVlAMbg0PHKGYvqIU3GW7AxBsY
 On1z3BLDVH2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="344796010"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2020 09:39:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 09:39:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 09:39:25 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 09:39:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecY4Uvsbe7CuzcPWh1PTykzcFrrltdndGSqC3EGvQbikft6KxgA2QAyfTODyji6E+fj4mNcOVTyDgJ0CWNAw2TaXQTdWC1a0hRrquLqEVD3ISRSNyPW0SiGl+NjluuH233fdiEhssq8qOdStuhcLT6dNKOnNME+4h0dL7Wq4H6RG6CCbdsqLTdQ46t6w02/m11GMkb6cdhBZ1HVvUgUwGZdZOmiAwWsyfB/ukrFWBMwSVkoo1hoUpZksxZZ6Nx3NtaAp4khkDrUT3Vt1YtqTqjC+Ou2MHorbNYP2avHtKWbqzdpUmZnb+aw+/INlVxtoUbNUMtVVp3xb2DcH8JNhUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVJdgNpeoqSdOow5UClAuryXPxiC5kIzPbxarCujZV4=;
 b=XZhZdYP6m+78sUXYJknRYWmAoAi+SBJrs1aePrEOmdX7Phw1ZqoxfSmFM5xtPFiOKOTj4ZYjiBbtDoZueE29G49SQLcdGzRiim3Q9HQHhjVUR/cSthSWprEE+RRsjzk2mpa/ZrjNC7eZXiIKyGNFwAeN95ugOOUAnN4s6H7d1XlbRSTxTTGNZdwmgnv+Jgrz67C8QJL0jBwtyOdT2+4eLIKgv0btgAdiQHi1bOLz0DnS3r9BIKTJCLR5Cjs+3jrvBSkyWlh3Ho747yzL64Qo6WwcwACzvtcKeozXRYHpL80XN7wEIBn9+FMYPSobw65SvNKYG8qikXL6qF5TBd+WZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVJdgNpeoqSdOow5UClAuryXPxiC5kIzPbxarCujZV4=;
 b=PKCS2VBqWUq4+5Mj5ozJiRLFpCgf7DK6egLGRSt4HJhWeq+t7A5VlEsYDY/6RQTUgpy4rK0oHpTxD/fw2fIrradc3AGkU44h6iM59lrRmUBtb92WcZ66WI5p8o/tmre1CNZSkQBi1RqwxvvYNQ1M98oRUD717P8VDDCSyu9gn3s=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR11MB1353.namprd11.prod.outlook.com (2603:10b6:3:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Thu, 8 Oct 2020 16:39:22 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 16:39:21 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Parav Pandit <parav@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1ggACTy4CAABO4gIAAB+sAgAAKeACAAAOUAIAAN8WAgABTYxA=
Date:   Thu, 8 Oct 2020 16:39:21 +0000
Message-ID: <DM6PR11MB2841DA57E5AAFB8409CFA036DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
 <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
 <20201008070032.GG13580@unreal>
 <CAPcyv4jUbNaR6zoHdSNf1Rsq7MUp2RvdUtDGrmi5Be6hK_oybg@mail.gmail.com>
 <20201008075048.GA254837@kroah.com>
 <BY5PR12MB432291F0683A2295170C2F3BDC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB432291F0683A2295170C2F3BDC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a78342d-d04e-40b5-d9ac-08d86ba8b5b1
x-ms-traffictypediagnostic: DM5PR11MB1353:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1353CBFA39A0CCD5D20D304BDD0B0@DM5PR11MB1353.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KfCCpnY/ZCPE8ozVkQhN0zIwTfYH0JvzbhtpfkwXUN9fanPIOFDzeB75LdQjEhm8sMsYD3YpKfANepRa8zg1l3FcJiIlcBdtAI/58e9VvPYXUpaTgJ75zLji5iQjeooXOrBcwhlljGjJQlZ+X5SiSg2urkG0duL9jq3yPzXH3BiBFH2ILYMqg9EhfY8FhdGN/6Sx+MnVyaK1rj/iRq/UyBVZ0Wkc1/5T98TB1ZcGoKEwoRHN6KWteO6DNEhLZJkUDQNjTR44ObjNRBmcTuKQ750YWRphpeo+kDut1VaDyGR/FoipXSRgzmK28H7o8XEzHcOL6u6jp8UnCDyJdmKp+OwRhgBnHmp7wzXh09ObCWn3rY3UKC3a9eLUX4HApzjK+9jWn5PUiSZFAAe57rwt1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(8676002)(71200400001)(83080400001)(26005)(6506007)(53546011)(4326008)(52536014)(5660300002)(66446008)(64756008)(66556008)(66476007)(76116006)(186003)(478600001)(66946007)(83380400001)(7696005)(316002)(9686003)(8936002)(55016002)(966005)(110136005)(54906003)(33656002)(2906002)(6636002)(86362001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EDDGCOdeBFW0yl7FZPo27rtlq/0W8YPKoHnPND75obNAEJW87iUxPnHXr/aP71QYc0OSOOErojA+UFpfBmy2jF2gvhxSPNsJdkO/yTM2n8lPH7zY/xDZltlawepsQHwi0kJn3Ck8BSiNdrABYACTgw3mq0FdGnc65xUXi9mhWswGR+xtDCuW+b+JGfBwjuBqA7fd+zRTY8Y3odDxd6ZSDQ1oqILlTlJlNkxtoSrr78AMpko2MiCxy/ld0yQG4SdO5fr2jaSalaIPI7B+OMbr6je+d4oLXZKeSD6tnmyxQIao4rmbdG16q8PKj+oOcWrNPoSa0TvfmtlqKP4pFRTW/k8ZbQRvfode045aAQJPKwlKdE22FSNoYvZRS3uv0GKZ6L6viog9q4wpBvCNhyAKQO9W71aiakBkkYcVQOuyk3CCgHW12R94+xWtwKHJ/RudgraL7FhtW2SomULZFcTFs0SoKpVfCYMKazR6aWguzseas4EQ4qTKGVNX32hNQuJzm5AGdy0mtQxuXmYe3dw4ZpdN0JKnp5X1cfJgLEkCoX7xbINMY1eTZzBOEMffMStElFOFpLg256Hkl3bDWWM7bXKk33ezI6IWSq7ar8ohHCTcePF/pSOilxXBvKz9VNHkF5dOTOylUQ77Ja9o54L3Ww==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a78342d-d04e-40b5-d9ac-08d86ba8b5b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 16:39:21.8785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JToqod165t35cNPQaDjsQMmrQ2JPUh+X+a6e1TE+8LgD4j6aLDMo8Un7O9gIKiBUddfNDv5hViNiAIGZ/YPTaWa/g5iZ998wepUpUUv3hAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1353
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Parav Pandit <parav@nvidia.com>
> Sent: Thursday, October 8, 2020 4:10 AM
> To: gregkh@linuxfoundation.org; Williams, Dan J <dan.j.williams@intel.com=
>
> Cc: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> <david.m.ertman@intel.com>; Pierre-Louis Bossart <pierre-
> louis.bossart@linux.intel.com>; alsa-devel@alsa-project.org;
> parav@mellanox.com; tiwai@suse.de; netdev@vger.kernel.org;
> ranjani.sridharan@linux.intel.com; fred.oh@linux.intel.com; linux-
> rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org; Jason
> Gunthorpe <jgg@nvidia.com>; kuba@kernel.org; Saleem, Shiraz
> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: RE: [PATCH v2 1/6] Add ancillary bus support
>=20
>=20
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Thursday, October 8, 2020 1:21 PM
> >
> > On Thu, Oct 08, 2020 at 12:38:00AM -0700, Dan Williams wrote:
> > > On Thu, Oct 8, 2020 at 12:01 AM Leon Romanovsky <leon@kernel.org>
> > wrote:
> > > [..]
> > > > All stated above is my opinion, it can be different from yours.
> > >
> > > Yes, but we need to converge to move this forward. Jason was involved
> > > in the current organization for registration, Greg was angling for
> > > this to be core functionality. I have use cases outside of RDMA and
> > > netdev. Parav was ok with the current organization. The SOF folks
> > > already have a proposed incorporation of it. The argument I am hearin=
g
> > > is that "this registration api seems hard for driver writers" when we
> > > have several driver writers who have already taken a look and can mak=
e
> > > it work. If you want to follow on with a simpler wrappers for your us=
e
> > > case, great, but I do not yet see anyone concurring with your opinion
> > > that the current organization is irretrievably broken or too obscure
> > > to use.
> >
> > That's kind of because I tuned out of this thread a long time ago :)
> >
> > I do agree with Leon that I think the current patch is not the correct =
way to
> > do this the easiest, but don't have a competing proposal to show what I
> > mean.
> >
> > Yet.
> Please consider the approach of ib_alloc_device(), ib_dealloc_device() an=
d
> ib_register_register()/unregister().
> (a) It avoids driver calling put_device() on error unwinding path.
> (b) still achieves container_of().
>=20
> >
> > Let's see what happens after 5.10-rc1 is out, it's too late now for any=
 of this
> > for this next merge window so we can not worry about it for a few weeks=
.
> >
> Ok. INHO giving direction to Dave and others to either refine current API=
s or
> follow ib_alloc_device() approach will be a helpful input.
>=20
> ancillary bus can do better APIs than the newly (march 2020 !) introduced
> vdpa bus [1] and its drivers which follows put_device() pattern in [2] an=
d [3]
> in error unwinding path.
>=20
> [1] https://elixir.bootlin.com/linux/v5.9-rc8/source/drivers/vdpa/vdpa.c
> [2] https://elixir.bootlin.com/linux/v5.9-
> rc8/source/drivers/vdpa/ifcvf/ifcvf_main.c#L475
> [3] https://elixir.bootlin.com/linux/v5.9-
> rc8/source/drivers/vdpa/mlx5/net/mlx5_vnet.c#L1967
>=20
> > thanks,
> >
> > greg k-h

IMHO we need to stay with the two step registration process that we current=
ly
have (initialize then add) so that the driver writer knows if they need to =
explicitly=20
free the memory allocated for auxillary_device.  Sound folks have indicated=
 that=20
this really helps their flow also.  Greg asked to have these two functions =
fully
commented with kernel-doc headers, which has been done.

Without enforcing an "auxillary_object" that contains just an auxillary_dev=
ice and a
void pointer, we cannot do the allocation of memory in the bus infrastructu=
re without
breaking the container_of functionality.

-DaveE

