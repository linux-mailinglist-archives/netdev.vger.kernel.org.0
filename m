Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD12868F2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgJGUTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:19:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:52853 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgJGUTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:19:34 -0400
IronPort-SDR: cktbuaWrZjOUHch70GroQKx6O+3/sQ+YCUkdePZU3HV7bQOGfE6t12ffc59WG615IDhuMM53sn
 cDQoSmt4N/kg==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="152027377"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="152027377"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 12:53:45 -0700
IronPort-SDR: ITkeL7F5rNNEc5gEuNDxKKBZlwlpJ8kc4/aHWHaiqP0vXDPSVHt55uueZcEMZdtQUS+GR52gr7
 VYfXcVOkBmOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="297743417"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2020 12:53:45 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 12:53:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Oct 2020 12:53:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 7 Oct 2020 12:53:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oe4hhcOTEmC4Qq4hrV/Rcr4oBbpjLaKXVLkueD5MxucHUb+zSpi3S52SWspWrjhJaFgSeKpgZNuodX5FoeuOMZqvG0kFAi0r2cYrLqJ2jJrAF71QbkcvccOVYVGLsRq+MWgGoUqJ/6QELZHhUkMKlfffu/vIUaYSinDAgg9asH3UfPGAXkrdZpKGnpFm9anCN8yPlsKZ4JdeRzPoU9KHRyfE5+3AiRX4LyQwaboRCQqKLVbVAGVHnq5xwV8ZR0eTNSBBx7WcNjk3nqrxd2nhBfGOCsQ7CISPJdJ5RN10tpz9JjNeA00IAygccYs+HP8OjgPWeRRcEAsrsK13fS4Wag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxQaddQe4O29gUCjs3wyFIngyh46+moJUOwmP9out3A=;
 b=ISf3/Z846wGSeMCkW9Fyx5uRM9fsygd+PtgCHNxG9lRUJZEfhXxNpsSR1YgUmzJ6Tzsk1bjdUBr90oPy+kXg/1AhkqIZEp7LFwIg57Qv3wuJ+JwHW2t+xWcNDBzqmr/w4A5Si6IfGV/5WeK1Q8TShW+D7h2whUl+6+vAOZfCHlzryhSFxXBc5JAJe7pqCMRcuialFIOqNq6CLHUy4uKc48vSRzC47qwojyw0+07QKlqA+eiXbDAt4JRJk5wOhjeXM2daxWMIgvYOGDogZoR2b4KJrThIMTLw9hqE9Hqkf4V317opBUGtgUeFfyeIqVwI1cxVk/pxTDGN59m7uiEK1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxQaddQe4O29gUCjs3wyFIngyh46+moJUOwmP9out3A=;
 b=j8gOg1LbB/oBCO9THaWEe7IKphTuWdxSSi5KW704uNLyi4M/3GqfXC7vvueVZj0gIyOf3xmooCnG2uw3DqmEN+f+SScIX8nGZVZIeckIHTDlaN0H3Xgyq8+Jtpay8wYUYz7/AyijDRlBafWqRfcWdBVKVCTBH/y8IJxGIUlXk4E=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB2875.namprd11.prod.outlook.com (2603:10b6:5:cc::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Wed, 7 Oct 2020 19:53:40 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 19:53:40 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAAc1oA==
Date:   Wed, 7 Oct 2020 19:53:40 +0000
Message-ID: <DM6PR11MB2841EBB5C27A947789F9DB73DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
In-Reply-To: <20201007192610.GD3964015@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e294902-304e-4390-2609-08d86afab06c
x-ms-traffictypediagnostic: DM6PR11MB2875:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB2875FA21BE67C0F1A7807EB3DD0A0@DM6PR11MB2875.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qh2OLsEB/Lszl/7I0MHdKwkoVtF61aRKXw0DgrdpU3K4qmZkIvDpweE66yML6KAVxBWo1Dv548X1oBXmiCutTz0pzLWi3fQESuS8wcHcJ2iAb1unC3zTtxY25VUayGdZXbhkzx0966BCF9wagb4GsdLlSTnuFsKGvdLePZDfX5CfwzijzxmWYtRm/Zx/hxyGhoN7DfLFWWBKuxueIOfu6dQWwB8i5QJctyU91XE67Y3cR53LM1MVqOztA9iR9flgoIviUE4SUfZLLi1Zs2BYx2OuOGDGf11Pk8ytf/L/Un3QtXUggc3FLR/rlgw+YNDa+6eQCkB6TbIOQXrUbEsyxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(71200400001)(86362001)(9686003)(83380400001)(478600001)(33656002)(6916009)(7416002)(8676002)(8936002)(66946007)(7696005)(2906002)(186003)(53546011)(6506007)(55016002)(64756008)(52536014)(26005)(316002)(4326008)(5660300002)(76116006)(66446008)(66476007)(66556008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wvn1fG6eAqK0kEJ/V1SPEHAkcMXVXcbmmPykAFXqBsa5hFftdUnwwz7yarzyAneca1cm2EzaOKaZb84qExEiHQbbFQz5SGQUmtdPEntxbpSTOoYzfiKmZxcrkgpXAWlTX4gbWDr90cPPTsuOMBIPtPFOBjKfT++22fdulCkpsJYjCqodLPWqMG01e2RiDhyHJtstVrWraV6dcm/1HxyA82k5TMaMIT7Aci2QA4e/tjZ01JB36gMLIEIkXcAW4MmCyHDX9wiY8eexi1SXFFm/vzqleXVXFcMXVx2wjGHCcxqgLQJU7Yu0fov0LcVrUeYqQXh/ZaxLZ5sGfSKxirHLo4B/R5T0/X3iB3zC7Xxn3nfCgYU9pESFIOgp9441Fpj1VcQ+wwGDnEFQJjE/qVJOqo4Pb0RjHxWWy8w5UKAdm1B15Hw7RSAF9f49WHFzxLBapcqawTuqm269LjIzs9B40ojZGV7gz/GOelgIPcZ8CXsFCFv1FqRAJbunpjEGN3NrHfSDrPsAL9ZotU2GVai+DXkkbWMK1OyrZnfFQTfGnkhyrA9aNPPUHuQO4fPwgWVpVnJH8/cfffTyO0QPKycw3NYv23Lr4J7kiKtiPmfDPNglmiRBeC+buApkZ4VrwAZnErvaFmjDzacC9Nb0iWYfjw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e294902-304e-4390-2609-08d86afab06c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 19:53:40.5851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3AsSblxoPlU9cHDcyyLf4Au/f2fFh+8gtpZslrij4y18wAyfozuCe1J08vcL4NjWClWSMDPpE1F+VBU9rJJZFDf9o0ZqlnAkjTFx96lnlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2875
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Alsa-devel <alsa-devel-bounces@alsa-project.org> On Behalf Of Leon
> Romanovsky
> Sent: Wednesday, October 7, 2020 12:26 PM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: alsa-devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com; Pierre-Louis
> Bossart <pierre-louis.bossart@linux.intel.com>; fred.oh@linux.intel.com;
> linux-rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
>=20
> On Wed, Oct 07, 2020 at 06:06:30PM +0000, Ertman, David M wrote:
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, October 6, 2020 10:03 AM
> > > To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Cc: Ertman, David M <david.m.ertman@intel.com>; alsa-devel@alsa-
> > > project.org; parav@mellanox.com; tiwai@suse.de;
> netdev@vger.kernel.org;
> > > ranjani.sridharan@linux.intel.com; fred.oh@linux.intel.com; linux-
> > > rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> > > jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org;
> Williams,
> > > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > > <kiran.patil@intel.com>
> > > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > >
> > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > > Thanks for the review Leon.
> > > >
> > > > > > Add support for the Ancillary Bus, ancillary_device and
> ancillary_driver.
> > > > > > It enables drivers to create an ancillary_device and bind an
> > > > > > ancillary_driver to it.
> > > > >
> > > > > I was under impression that this name is going to be changed.
> > > >
> > > > It's part of the opens stated in the cover letter.
> > >
> > > ok, so what are the variants?
> > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > >
> > > >
> > > > [...]
> > > >
> > > > > > +	const struct my_driver my_drv =3D {
> > > > > > +		.ancillary_drv =3D {
> > > > > > +			.driver =3D {
> > > > > > +				.name =3D "myancillarydrv",
> > > > >
> > > > > Why do we need to give control over driver name to the driver
> authors?
> > > > > It can be problematic if author puts name that already exists.
> > > >
> > > > Good point. When I used the ancillary_devices for my own SoundWire
> test,
> > > the
> > > > driver name didn't seem specifically meaningful but needed to be se=
t to
> > > > something, what mattered was the id_table. Just thinking aloud, may=
be
> we
> > > can
> > > > add prefixing with KMOD_BUILD, as we've done already to avoid
> collisions
> > > > between device names?
> > >
> > > IMHO, it shouldn't be controlled by the drivers at all and need to ha=
ve
> > > kernel module name hardwired. Users will use it later for various
> > > bind/unbind/autoprobe tricks and it will give predictability for them=
.
> > >
> > > >
> > > > [...]
> > > >
> > > > > > +int __ancillary_device_add(struct ancillary_device *ancildev, =
const
> > > char *modname)
> > > > > > +{
> > > > > > +	struct device *dev =3D &ancildev->dev;
> > > > > > +	int ret;
> > > > > > +
> > > > > > +	if (!modname) {
> > > > > > +		pr_err("ancillary device modname is NULL\n");
> > > > > > +		return -EINVAL;
> > > > > > +	}
> > > > > > +
> > > > > > +	ret =3D dev_set_name(dev, "%s.%s.%d", modname, ancildev-
> >name,
> > > ancildev->id);
> > > > > > +	if (ret) {
> > > > > > +		pr_err("ancillary device dev_set_name failed: %d\n",
> ret);
> > > > > > +		return ret;
> > > > > > +	}
> > > > > > +
> > > > > > +	ret =3D device_add(dev);
> > > > > > +	if (ret)
> > > > > > +		dev_err(dev, "adding ancillary device failed!: %d\n",
> ret);
> > > > > > +
> > > > > > +	return ret;
> > > > > > +}
> > > > >
> > > > > Sorry, but this is very strange API that requires users to put
> > > > > internal call to "dev" that is buried inside "struct ancillary_de=
vice".
> > > > >
> > > > > For example in your next patch, you write this "put_device(&cdev-
> > > >ancildev.dev);"
> > > > >
> > > > > I'm pretty sure that the amount of bugs in error unwind will be
> > > > > astonishing, so if you are doing wrappers over core code, better =
do
> not
> > > > > pass complexity to the users.
> > > >
> > > > In initial reviews, there was pushback on adding wrappers that don'=
t do
> > > > anything except for a pointer indirection.
> > > >
> > > > Others had concerns that the API wasn't balanced and blurring layer=
s.
> > >
> > > Are you talking about internal review or public?
> > > If it is public, can I get a link to it?
> > >
> > > >
> > > > Both points have merits IMHO. Do we want wrappers for everything
> and
> > > > completely hide the low-level device?
> > >
> > > This API is partially obscures low level driver-core code and needs t=
o
> > > provide clear and proper abstractions without need to remember about
> > > put_device. There is already _add() interface why don't you do
> > > put_device() in it?
> > >
> >
> > The pushback Pierre is referring to was during our mid-tier internal re=
view.
> It was
> > primarily a concern of Parav as I recall, so he can speak to his reason=
ing.
> >
> > What we originally had was a single API call (ancillary_device_register=
) that
> started
> > with a call to device_initialize(), and every error path out of the fun=
ction
> performed
> > a put_device().
> >
> > Is this the model you have in mind?
>=20
> I don't like this flow:
> ancillary_device_initialize()
> if (ancillary_ancillary_device_add()) {
>   put_device(....)
>   ancillary_device_unregister()
>   return err;
> }
>=20
> And prefer this flow:
> ancillary_device_initialize()
> if (ancillary_device_add()) {
>   ancillary_device_unregister()
>   return err;
> }
>=20
> In this way, the ancillary users won't need to do non-intuitive put_devic=
e();

Isn't there a problem calling device_unregister() if device_add() fails?
device_unregister() does a device_del() and if the device_add() failed ther=
e is
nothing to delete?

-DaveE

>=20
> Thanks
