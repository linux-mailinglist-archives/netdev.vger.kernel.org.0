Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04F6287E7C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgJHWEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:04:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:56947 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJHWET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 18:04:19 -0400
IronPort-SDR: OZj/Ti9ycpmxOxyfiwi8p3E6+bPO3xEY+Izu6+1eu3PHuIiXxNzJqi0iLrcPhI9DM7cl/+jKLi
 nEtJjRwQkIZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="144733803"
X-IronPort-AV: E=Sophos;i="5.77,352,1596524400"; 
   d="scan'208";a="144733803"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 15:04:18 -0700
IronPort-SDR: 9cvBlHSZc5IlMo2Tb2w9sWOGry/UcSINIktEztH5goeSJqtMJy/EuK7ImLQwZZ6KA//S/HSbFw
 BnIIo4J/d7RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,352,1596524400"; 
   d="scan'208";a="344872668"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2020 15:04:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 15:04:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 15:04:18 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.50) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 15:04:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzjAMkDY/CBtBquXVTE+D84wJdIGqP5NnGkcXUz+p2FALFSDWbJK8iDK8UO5qtkXx44NbEY20Xohf84X7lCXbrODoU6ptTfTMGsQAvT/VYfxl8iepMJwEAXJbyYS8c7IwJWNzinSHAoUwKVGJF2OdYtuIuDqv7Srpee0cXbmhyUZ//OuIuCwdrxLB4zwKPOtfCGcRzo+aEkkMC+PQJaCob6ZjD8434wV10RcV9bEwHNGNjib1F5FqBTrzh97WP8NZK6DAXlvoinutzlTeyNdKK4h6kxc9pUESGIOEr6V3wouOGSQm/1xGP7keVrqF31s2wrNaKIKWH0OCduWrkHskw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HnfsrDraTjXhgpiqKz2kO4fK3C3dIq6bCmZBRCCRVQ=;
 b=WFGUxmSiJ4yEzVgKlLUDZMGPcgFZ02jdZp8qdxRmFAJ2vhcImbwbtnH77DmOrXu9BJtJOjuz/F4dQwbdmYK1+joGo+XiHhB0hjJbbJvV2A2TGlXLpDDeGBHlkiVeaJoc/fEbuvaDUV90ogTXuF+o6T1nYOZANNUfjySeHyKN97zszh2N5ZvshHnqa/8dmgbf5AGrHedTOrDcV7PKprawXMqok3CRdoxlBiG7l5/NSnG1vvs2nJiU7znUY4r33shNofBBsTDreJa5QVyDy7MqxgLFh/8V+S7Rp1aM1kyxMSy7UKrqaRTKKJe+77jG3WaXf/HHHauG60wXvgNMKTIGPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HnfsrDraTjXhgpiqKz2kO4fK3C3dIq6bCmZBRCCRVQ=;
 b=XY45AD2UfgZq5LdvbxsD1ZKXXp4wPHj+eD56DfW2tiPCMsYTUC0VV6FNhFnFNk79JaDjS7OjkDR9xqKIGRACx3D2vWxdOOOKNY/OYEyCZNjl6YL3OqROZKQoXcgtlBLMYnLb1S3P7u2MkyZT0BGJo6kwmrZhjrZG83B89VAZUnM=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB3052.namprd11.prod.outlook.com (2603:10b6:5:69::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.24; Thu, 8 Oct 2020 22:04:13 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 22:04:13 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mK1CSAgANvhAA=
Date:   Thu, 8 Oct 2020 22:04:12 +0000
Message-ID: <DM6PR11MB2841976B8E89C980CCC29AD2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006172317.GN1874917@unreal>
In-Reply-To: <20201006172317.GN1874917@unreal>
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
x-ms-office365-filtering-correlation-id: d3a0c5cc-c596-472a-b433-08d86bd61781
x-ms-traffictypediagnostic: DM6PR11MB3052:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3052A339FF1E69724B1A82DBDD0B0@DM6PR11MB3052.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gXoG3yRcbTeplcVQbAXMfFh+6SjfOriU/OYRvIIU6NRMrLZw+/9GQ/EyGkRKRU4+xbKnVqE1FA3R7zUVmi7LIELvGX9bFPjMVhkCuTjdQXAsseOX0p0FBuTZs4pk33tyobniAJVhh9M3aBvABj1OPVBLXAQ0EoWlEiYY/XpOJPFSnzbRxOkPksS3fE1luHkCusG2O2iR3RwLPPTMS1tShsUV2JcmiiD5amWAsZZ3IMUMmaEd8yEqQB2ISayD+T/PWNytTPJy8CCRWxBut1UaVnvi0IFlRqfpSuAMEZqdBwicHEjulF6tzgl4rAy9JhLCmWZTF1Sjlti7O0o6BrZf4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(71200400001)(66946007)(316002)(76116006)(66476007)(6916009)(9686003)(54906003)(2906002)(7416002)(52536014)(64756008)(66446008)(66556008)(8936002)(478600001)(8676002)(33656002)(86362001)(6506007)(5660300002)(55016002)(83380400001)(186003)(26005)(4326008)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hN5SBCNr4NRrAOO9ifUCzfWev/kOj7K6nr+WlBH7neLQiZpKNYjvQyH7hk1MUvT3o+3fOlU2IIdJPTklgI/ZZ4idToNAiXhp0qYBRVjUU9sI5rWvDKNz8uqUALurRrgBqi2LcbwmmLAXzvEaAGVo6oriD7a/zSO7RFb6dEb1UcGFRnvoeUiZ0fKMCRx+zufGn87VGRjlWuMShdYXPfeDYcFfwdO8p+SsNMrePutoW8TeRNdTTuokn++vJyGzTxAIaPtjlG5TcsdoWaPfk1n+BWA389hfcZkpPAE8fyisp1bTYkIdNkNvPzK0WTlWAI9JoVj2ME3CCC1u5WDdyA2c6dHCDBZvvYF8DJxm9bejTDZumPcEO0D0XosB1cw6R6FXRVrRr0y3A8CCgOXbYbG/BgdPY4UOv4pLcdQT6XhwVIFDwOR1d4gQ/h1g92VtfgTXLI/SfbyeQYO0GnezLEtLV2GD8JsN8E/cKkLjKSmr0DMYHvbLHjfpfZf+cMkACgLhSjXBU5nYb6Gd3EIzu59NND6YkYDv0UGnovcsINSMReEtlmM05JUKv49FW9O/8nWOPpyuTOwKr0HR2cihU1rwd2cwE87rc7GuWlcurt0T+7xtUBocW9x/l99X9Le5NkT95Rrdkj1+f6bRfljvNzRI0A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a0c5cc-c596-472a-b433-08d86bd61781
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 22:04:12.8138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P5rYP5AGZ+CL4npR+8Pi5eU8RF8tdw4Oek/RCoVLfkD4DzyBh8wwHEP1rL7Lo45kysubtYSIykxlf4Gd0y1ilG1L5I/FG/KPZZdXsaxIcyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3052
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, October 6, 2020 10:23 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: alsa-devel@alsa-project.org; tiwai@suse.de; broonie@kernel.org; linux=
-
> rdma@vger.kernel.org; jgg@nvidia.com; dledford@redhat.com;
> netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> gregkh@linuxfoundation.org; ranjani.sridharan@linux.intel.com; pierre-
> louis.bossart@linux.intel.com; fred.oh@linux.intel.com;
> parav@mellanox.com; Saleem, Shiraz <shiraz.saleem@intel.com>; Williams,
> Dan J <dan.j.williams@intel.com>; Patil, Kiran <kiran.patil@intel.com>
> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
>=20
> On Mon, Oct 05, 2020 at 11:24:41AM -0700, Dave Ertman wrote:
> > Add support for the Ancillary Bus, ancillary_device and ancillary_drive=
r.
> > It enables drivers to create an ancillary_device and bind an
> > ancillary_driver to it.
> >
> > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > Each ancillary_device has a unique string based id; driver binds to
> > an ancillary_device based on this id through the bus.
> >
> > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com=
>
> > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > ---
>=20
> <...>
>=20
> > +/**
> > + * __ancillary_driver_register - register a driver for ancillary bus d=
evices
> > + * @ancildrv: ancillary_driver structure
> > + * @owner: owning module/driver
> > + */
> > +int __ancillary_driver_register(struct ancillary_driver *ancildrv, str=
uct
> module *owner)
> > +{
> > +	if (WARN_ON(!ancildrv->probe) || WARN_ON(!ancildrv->remove)
> ||
> > +	    WARN_ON(!ancildrv->shutdown) || WARN_ON(!ancildrv-
> >id_table))
> > +		return -EINVAL;
>=20
> In our driver ->shutdown is empty, it will be best if ancillary bus will
> do "if (->remove) ..->remove()" pattern.
>

Yes, looking it over, only the probe needs to mandatory.  I will change the=
 others to the
conditional model, and adjust the WARN_ONs.

=20
> > +
> > +	ancildrv->driver.owner =3D owner;
> > +	ancildrv->driver.bus =3D &ancillary_bus_type;
> > +	ancildrv->driver.probe =3D ancillary_probe_driver;
> > +	ancildrv->driver.remove =3D ancillary_remove_driver;
> > +	ancildrv->driver.shutdown =3D ancillary_shutdown_driver;
> > +
>
> I think that this part is wrong, probe/remove/shutdown functions should
> come from ancillary_bus_type.=20

From checking other usage cases, this is the model that is used for probe, =
remove,
and shutdown in drivers.  Here is the example from Greybus.

int greybus_register_driver(struct greybus_driver *driver, struct module *o=
wner,
                            const char *mod_name)
{
        int retval;

        if (greybus_disabled())
                return -ENODEV;

        driver->driver.bus =3D &greybus_bus_type;
        driver->driver.name =3D driver->name;
        driver->driver.probe =3D greybus_probe;
        driver->driver.remove =3D greybus_remove;
        driver->driver.owner =3D owner;
        driver->driver.mod_name =3D mod_name;


> You are overwriting private device_driver
> callbacks that makes impossible to make container_of of ancillary_driver
> to chain operations.
>=20

I am sorry, you lost me here.  you cannot perform container_of on the callb=
acks
because they are pointers, but if you are referring to going from device_dr=
iver
to the auxiliary_driver, that is what happens in auxiliary_probe_driver in =
the
very beginning.

static int auxiliary_probe_driver(struct device *dev)
145 {
146         struct auxiliary_driver *auxdrv =3D to_auxiliary_drv(dev->drive=
r);
147         struct auxiliary_device *auxdev =3D to_auxiliary_dev(dev);

Did I miss your meaning?

-DaveE

> > +	return driver_register(&ancildrv->driver);
> > +}
> > +EXPORT_SYMBOL_GPL(__ancillary_driver_register);
>=20
> Thanks
