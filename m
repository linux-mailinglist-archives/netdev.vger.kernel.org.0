Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972511529F7
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 12:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgBELds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 06:33:48 -0500
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:13189
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727562AbgBELds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 06:33:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpfE6qfpIYTvrN7eG+72RnY2Ho/HVQ+D3bFxvo/P4bOu0+rkH1GoFXdEG7YmAZLvKroLipPinMjHlrNS8R2bi9pYG/REWZPp2E3lRxIewFpUegvkujRAqUekecGSHbg4LvmFvU5ARNijDiEx4ZqqbR74dLMYiP7dxDAawJ0WH4TFptL7tC3oS0YLHqjFtycJMnZXufdmIZS+almDIEkSIQocpQIgPbHT7kFNrgbXwN9UROTqwn/xlZL6hz7V0LqjGJQXsEeek0/qwNGbTgdxb0W/e2M0kJMeQ6OOdteheUWHBVbfEhAILZSCwAAsNbQDvYTx/uKYFI1ze30rItcJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9z4NqEdh7x1/Eh9fEH3iTMZdHA2T3pBZnlucb64P4w=;
 b=c/0yhXGDr1owC+rIfW5yT35hnlPEH8AfYbGmE2jKHzE1koqnl4wm/3XT8xbaUbqSu5Wrtgx9X2QBMqlMprxX5wlgY9VdJ5n3y+PLXzBYk82iwCcZHYH6kz4zrkDMNrG1HJ9gi/5ZbiGd4NU4HDvaCbSUyP4u4Y49XQM0BsWsFe3K9XTfQ57N5TjWMrEPqGPY9z/bbfT7yDNKG+CWA0tq4AOIobHlFTngNg3aUK4OSifE58SgjCEpfsK3l9LOJeM/9qSYjlq6SzA4LbsBtpV2eT97XMbhojaYPVCqikOVhv6DZGxfJ+X/2161vsLOfQzaTLrx20PcKieJqZjsGQCs+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9z4NqEdh7x1/Eh9fEH3iTMZdHA2T3pBZnlucb64P4w=;
 b=MtYktUQyHRMLbjSoOLujBeKxnoJytwNRsY7cEJlnZ80aztVH7veCrnLpmZ4N5IVGwvnPeDJJVCx5c23Pcm+xozJHMgOzVYN2ajBMqpZBGA6Ok/tACXtIAgyelBv03V2TMkXoN7EwUnliiIOyle8APEXugx3tQPwtkt8DY9Oy/SU=
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB5202.eurprd04.prod.outlook.com (52.134.89.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Wed, 5 Feb 2020 11:33:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2686.034; Wed, 5 Feb 2020
 11:33:40 +0000
From:   "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1 6/7] net: phylink: Introduce
 phylink_fwnode_phy_connect()
Thread-Topic: [EXT] Re: [PATCH v1 6/7] net: phylink: Introduce
 phylink_fwnode_phy_connect()
Thread-Index: AQHV2Ewe+AYJWjXPMEG+NfVVXqSvHKgJ0naAgAKpuiA=
Date:   Wed, 5 Feb 2020 11:33:40 +0000
Message-ID: <AM0PR04MB5636989ED51E9BD72BC78C1093020@AM0PR04MB5636.eurprd04.prod.outlook.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-7-calvin.johnson@nxp.com>
 <20200203184121.GR25745@shell.armlinux.org.uk>
In-Reply-To: <20200203184121.GR25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71de16e8-190a-48b4-ff55-08d7aa2f3feb
x-ms-traffictypediagnostic: AM0PR04MB5202:|AM0PR04MB5202:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB52024AD2A54270FB1244CBA3D2020@AM0PR04MB5202.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(189003)(199004)(76116006)(33656002)(66476007)(66556008)(2906002)(9686003)(64756008)(66946007)(4326008)(55016002)(66446008)(26005)(81156014)(81166006)(86362001)(8936002)(8676002)(71200400001)(54906003)(52536014)(5660300002)(6506007)(53546011)(316002)(7696005)(478600001)(186003)(7416002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5202;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JXBudp9AO4TXk8dcfQyyGNgyBOAv7kCKLWhKWBuO/wDwxCZp6phOQrnN14ouhrhloRSY9CmKPaCTxDvLM4vLpF2PxrWrgZ8aWthi9MvaRRue+0fyNyC4zule3ctlSvAMrQ1O1j2v/GOCPUvKiAxa7TV07cp1MPHGDTAVPyrd4UWhdbtTWbsnUvCVkOH6cZpFsUnIhfD58zJtox0VEo7JVT6OQUUA8QfLaaPDPFolC6eW4R6GQo5pltxbn05xj/0DjKsRw+OEy9b2GePfAF3SRjah1oVTjKLliFc/dFor5ZWxh/WlM5PwIicW793Ana1DBYRgRJfBAmr/+8lySf5gNUncvwNOiYoFj3hTagavRHcSXzduSXozVjx8MPPPCtrMGIz9NakkJVWJHkhysPexprfvi7PDRMIx5DgAPq+UhDgQs/ozRPIwgSHrfjlSsYYm
x-ms-exchange-antispam-messagedata: t/Wli71+Ioefk4CXJXheA5nYXgvbudvSIqB9FnVFeHmCYLJ2K7OeMv1jvApg86lSevlWr6ZyGKjChlHH3FGln9yhNtp0wMv+oBRgD1aoG5gcs2QZeWzENc5KdeO73hkLULr2JfJiiIFthdm2/tSIYQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71de16e8-190a-48b4-ff55-08d7aa2f3feb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 11:33:40.6931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HaouxkScYNNytwHRuqU5tpgMF0opU3h5MJyv/mJp+7Tm/Yp+YSSp1EGt/ct9NZdPo5lVYFRgxLnpvMB6DiOYew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5202
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Tuesday, February 4, 2020 12:11 AM
> To: Calvin Johnson <calvin.johnson@nxp.com>

<snip>

> > Introduce phylink_fwnode_phy_connect API to connect the PHY using
> > fwnode.
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> >  drivers/net/phy/phylink.c | 64
> +++++++++++++++++++++++++++++++++++++++
> >  include/linux/phylink.h   |  2 ++
> >  2 files changed, 66 insertions(+)
> >
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index ee7a718662c6..f211f62283b5 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/timer.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/acpi.h>
> >
> >  #include "sfp.h"
> >  #include "swphy.h"
> > @@ -817,6 +818,69 @@ int phylink_connect_phy(struct phylink *pl,
> > struct phy_device *phy)  }  EXPORT_SYMBOL_GPL(phylink_connect_phy);
> >
> > +/**
> > + * phylink_fwnode_phy_connect() - connect the PHY specified in the
> fwnode.
> > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > + * @dn: a pointer to a &struct device_node.
> > + * @flags: PHY-specific flags to communicate to the PHY device driver
> > + *
> > + * Connect the phy specified in the device node @dn to the phylink
> > +instance
> > + * specified by @pl. Actions specified in phylink_connect_phy() will
> > +be
> > + * performed.
> > + *
> > + * Returns 0 on success or a negative errno.
> > + */
> > +int phylink_fwnode_phy_connect(struct phylink *pl,
> > +                            struct fwnode_handle *fwnode,
> > +                            u32 flags) {
> > +     struct fwnode_handle *phy_node;
> > +     struct phy_device *phy_dev;
> > +     int ret;
> > +     int status;
> > +     struct fwnode_reference_args args;
> > +
> > +     /* Fixed links and 802.3z are handled without needing a PHY */
> > +     if (pl->link_an_mode =3D=3D MLO_AN_FIXED ||
> > +         (pl->link_an_mode =3D=3D MLO_AN_INBAND &&
> > +          phy_interface_mode_is_8023z(pl->link_interface)))
> > +             return 0;
> > +
> > +     status =3D acpi_node_get_property_reference(fwnode, "phy-handle",=
 0,
> > +                                               &args);
> > +     if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> > +             status =3D acpi_node_get_property_reference(fwnode, "phy"=
, 0,
> > +                                                       &args);
> > +     if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> > +             status =3D acpi_node_get_property_reference(fwnode,
> > +                                                       "phy-device", 0=
,
> > +                                                       &args);
>=20
> This is a copy-and-paste of phylink_of_phy_connect() without much thought=
.
>=20
> There is no need to duplicate the legacy DT functionality of phy/phy-
> device/phy-handle in ACPI - there is no legacy to support, so it's pointl=
ess
> trying to find one of three properties here.

Ok. I'll remove it.

> I'd prefer both the DT and ACPI variants to be more integrated, so we don=
't
> have two almost identical functions except for the firmware specific deta=
il.

Did you mean phylink_of_phy_connect replaced with phylink_fwnode_phy_connec=
t?
I can add DT handling also inside phylink_fwnode_phy_connect. Please let me=
 know.

Thanks for pointing out about adding linux-acpi ML. I started added them in=
 my responses.
I was assuming they would be added by get_maintainer.pl.=20

Thanks
Calvin
