Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA590425
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfHPOsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:48:53 -0400
Received: from mail-eopbgr730099.outbound.protection.outlook.com ([40.107.73.99]:13536
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727371AbfHPOsw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 10:48:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E07gdw6I2l08cbgRvTnyjHr4JIU+VXSaHKA2KUYnYW+73OiNHzWI0cmAZo+64ruaBY3AwHp3+retQXbskVeQhih08UtFxod10j4OiHLtf6siXXBe+pTA6hWVT+HeS1YM0lDzE7jpzHhd3X012tSSooGsmOsDgPs06rPfGDo8CgzXYP0wCH22vg56BpWDjQdJd8ZKJyGVnkuVYYkN8rmRKNnc4IL3RyZbIw2x0k6aWjipB7pFqjNf/FnP9XKcsV+RjO0etixL9Fkpr6UmXPxHoh8KkZOvSCqcyYv7/F47geFD+RMrC9I6ilVS6ymx6eqc9/Vy/tFsw0QspIpe4k5qVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY+tg+KOkgEb0DjfbyMaw5efnvppS83nBvwHLIRZBHk=;
 b=FfVYedURHwUfeTWT1144IHLVkpCQXCTGK80IoPQ+xRh9nsnMM1Jff2fMVWpBJPTAvrb4to7S3DXR0IyPDU862Kgqs8YU0aCmSb0ETgsss9p2GCV6PNAsLP0i4xYqeXd5ZypauaC2VfDeVU3OOEFZHLWAjCIf4KaEOHmrJYfMAtIRKIYgahxf6FcoDjF6ozmVqBZ/Ju/rQACfQrV9rSbVwiYq/rvoe2wthZ228M4RJnVDsRrmcuJ6eZrruqsQOLvw2fYy7ZrqvUvZkkWQJg53QMAZJNi3S7cR2HEbmjRwOgZNHVrl/LBT4C7rM+UByNEjer2Tyz9liwIjSFF6vLghDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY+tg+KOkgEb0DjfbyMaw5efnvppS83nBvwHLIRZBHk=;
 b=KgIHaIpX5KvqBcILgsPmsTMd38Rdr9puGKOR8PMU5C7irbdW2D/cEVn1fJiUIO0gVIJzWg5irCmST5SFVGUWQsN4nsoqdTE7lnJbBG8U2VaESJaT5Nv/y4N4HXYEXxiNKzk8oErqpN28D/kLbYSCMG0zmFlPbG2j7z1kVu3kU78=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1292.namprd21.prod.outlook.com (20.179.52.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.5; Fri, 16 Aug 2019 14:48:48 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2199.007; Fri, 16 Aug 2019
 14:48:48 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver for
 software backchannel interface
Thread-Topic: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver for
 software backchannel interface
Thread-Index: AQHVUtO4i0f5rhE14EmISE1mYwr8y6b9tkuAgAAliYA=
Date:   Fri, 16 Aug 2019 14:48:48 +0000
Message-ID: <DM6PR21MB13375FA0BA0220A91EF448E1CAAF0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-3-git-send-email-haiyangz@microsoft.com>
 <878srt8fd8.fsf@vitty.brq.redhat.com>
In-Reply-To: <878srt8fd8.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-16T14:48:47.0931313Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=31ce1e32-5d60-43d7-ad92-451c2d4f5574;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 871fb072-934e-429e-c29d-08d72258d8be
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1292;
x-ms-traffictypediagnostic: DM6PR21MB1292:|DM6PR21MB1292:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1292755D3E03992BAC7BDCFACAAF0@DM6PR21MB1292.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(13464003)(199004)(189003)(71200400001)(102836004)(55016002)(6246003)(54906003)(305945005)(478600001)(8676002)(81156014)(7696005)(25786009)(8990500004)(229853002)(7416002)(99286004)(14454004)(76176011)(81166006)(256004)(9686003)(4326008)(3846002)(2201001)(110136005)(2906002)(7736002)(6436002)(6116002)(74316002)(53936002)(33656002)(66946007)(316002)(2501003)(22452003)(71190400001)(86362001)(10290500003)(5660300002)(486006)(76116006)(446003)(64756008)(66556008)(11346002)(6506007)(26005)(66446008)(8936002)(10090500001)(66066001)(52536014)(186003)(53546011)(476003)(66476007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1292;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IIthBiS3KUpVZ7bZUBDHxE8s0f06PIOGJ8padxBJvqJEPBLtAPqKMoBI2uK1BG1sfRXK/4yhkPLZH+i6GRrsyJ7SsD3G9IWnptl7CRKbSgb8oWrK355cK4RCUM3gmyTK8XKBnd6yYcC+c8hDvKfbKkH9XWGmJ/6KmrOYUcz/4DyAwOtsMCaYFvVgQbNVdrkxNPvvE4jpNJbxxBZ18e7Eb7O3B3xZWe3i3s1NXlYJ6i7ULRibfgs4LFDg62TR2kNXJI3Gfogzi0GBRxm3s4E9wsNs8V8ZDZmiqyiFyd9dVrtl8TKx0UNLi6iCGVa0rqDZNHAtYj+zr+lKO/lFwHa5WtiY8lVOqGl6jaSxBfWa3UnTNwaIXfzQLUXHMa3Jlv4V0aO2QTshfa82xUdqnNCQzLLwSEFJnEsWrrqxe5GcVeo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871fb072-934e-429e-c29d-08d72258d8be
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 14:48:48.3438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IvG1via0dNRD1krqyNGlWtNi87UMTsNNUyx3yYuLIoSQ7DuIC+oFY1PSChKbWHS+5JseSq3Dq+mSx1ID4DsJ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1292
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Friday, August 16, 2019 8:28 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; sashal@kernel.org;
> davem@davemloft.net; saeedm@mellanox.com; leon@kernel.org;
> eranbe@mellanox.com; lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> linux-pci@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver=
 for
> software backchannel interface
>=20
> Haiyang Zhang <haiyangz@microsoft.com> writes:
>=20
> > This mini driver is a helper driver allows other drivers to have a
> > common interface with the Hyper-V PCI frontend driver.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  MAINTAINERS                              |  1 +
> >  drivers/pci/Kconfig                      |  1 +
> >  drivers/pci/controller/Kconfig           |  7 ++++
> >  drivers/pci/controller/Makefile          |  1 +
> >  drivers/pci/controller/pci-hyperv-mini.c | 70
> ++++++++++++++++++++++++++++++++
> >  drivers/pci/controller/pci-hyperv.c      | 12 ++++--
> >  include/linux/hyperv.h                   | 30 ++++++++++----
> >  7 files changed, 111 insertions(+), 11 deletions(-)  create mode
> > 100644 drivers/pci/controller/pci-hyperv-mini.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS index e352550..c4962b9 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7453,6 +7453,7 @@ F:	drivers/hid/hid-hyperv.c
> >  F:	drivers/hv/
> >  F:	drivers/input/serio/hyperv-keyboard.c
> >  F:	drivers/pci/controller/pci-hyperv.c
> > +F:	drivers/pci/controller/pci-hyperv-mini.c
> >  F:	drivers/net/hyperv/
> >  F:	drivers/scsi/storvsc_drv.c
> >  F:	drivers/uio/uio_hv_generic.c
> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig index
> > 2ab9240..bb852f5 100644
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -182,6 +182,7 @@ config PCI_LABEL
> >  config PCI_HYPERV
> >          tristate "Hyper-V PCI Frontend"
> >          depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN
> &&
> > X86_64
> > +	select PCI_HYPERV_MINI
> >          help
> >            The PCI device frontend driver allows the kernel to import a=
rbitrary
> >            PCI devices from a PCI backend to support PCI driver domains=
.
> > diff --git a/drivers/pci/controller/Kconfig
> > b/drivers/pci/controller/Kconfig index fe9f9f1..8e31cba 100644
> > --- a/drivers/pci/controller/Kconfig
> > +++ b/drivers/pci/controller/Kconfig
> > @@ -281,5 +281,12 @@ config VMD
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called vmd.
> >
> > +config PCI_HYPERV_MINI
> > +	tristate "Hyper-V PCI Mini"
> > +	depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN
> && X86_64
> > +	help
> > +	  The Hyper-V PCI Mini is a helper driver allows other drivers to
> > +	  have a common interface with the Hyper-V PCI frontend driver.
> > +
>=20
> Out of pure curiosity, why not just export this interface from PCI_HYPERV
> directly? Why do we need this stub?

The pci_hyperv can only be loaded on VMs on Hyper-V and Azure. Other=20
drivers like MLX5e will have symbolic dependency of pci_hyperv if they=20
use functions exported by pci_hyperv. This dependency will cause other=20
drivers fail to load on other platforms, like VMs on KVM. So we created=20
this mini driver, which can be loaded on any platforms to provide the=20
symbolic dependency.

Thanks,
- Haiyang
