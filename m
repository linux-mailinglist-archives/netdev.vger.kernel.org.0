Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920E0FAA98
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 08:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfKMHDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 02:03:44 -0500
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:59013
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfKMHDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 02:03:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rw0Sz+lCrnogGnzuHvOcBl2f512jmjvwPr/aWMG67DwnJLzO5QKrx08d2z5Uax/6bZyKplHULUhtAT8aPTQpL9vGOXnk3uspipmoWQ/YdJbOUaGNuCGuVeDJLsjpS8daHYz4Wzpx+oEGUCNJQSxato7v4k93b6fxbHjPuBv+cVZNphsCm0XYyxcnsST2Aj/uXz2z0g/PVdLGF7FJbLGyksdDI3QqHLFlF9wCllFPcXUhHyTsewHZA/auBk8sfy8R9SI16Cm5Wa2+lDuzD2vnqxiXgdVORmdOIXIsMW395zePsMExey/3z/yusU4kt+K2Ked1oRo1uzojYcEaQkG9QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfQs5gcVh04MXP6iyPeEJP4H6TaXr1w9snxvvlsQg2s=;
 b=YuQ+/+V7pnncM6JPTo55jq2aRHkCstsnycfaWcUjldzzSHXhLgE69ZySWWrnnPxylgGKVeRrTpFfZvWGpf8Rb4OWH4Oq8+P/CiTamX0nvbAVUJBNTFiJyuixbPzl2l8H9L6xPCsDHfbCJivnvnPL1xjjAaEjeeUPl8bIDarApoyPq50mfdB3aI4LXsrZyadn0P37yrawLLyVjWIFpkT5HcnURnYe7BnShaQTbavLX6CNGl/X6DFMQQNkPHMUDMTo+4sWJY4KuE4xJx1If5zueUMfLldNpsx2GqDXamgRB/zFOCID4a3abasPJueoHZheooAuqqrMzVz2LSuibWzE4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfQs5gcVh04MXP6iyPeEJP4H6TaXr1w9snxvvlsQg2s=;
 b=iQwyUiyU4Bez4jncLaPs5R6oUnV72W9alVo80FqThMyacqPSwvPf0IKDiHfLV4+EvrXl6u/5b98cZJ5lI6IuWSF6LexHLVDTamhySXdbYtnQUzQqQeKBYBh0zmLrFFgFc39qsLq1OuT81oLBGFuTUG1AHcQ4l/gVsqPgYXMf/mQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6338.eurprd05.prod.outlook.com (20.179.36.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Wed, 13 Nov 2019 07:03:40 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 07:03:40 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>
Subject: RE: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVmMVkwGO915shK0y7Ue5RV91ix6eIDrEAgACb0JA=
Date:   Wed, 13 Nov 2019 07:03:40 +0000
Message-ID: <AM0PR05MB48665308FEE50EAB5C25C086D1760@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
 <20191112212826.GA1837470@kroah.com>
In-Reply-To: <20191112212826.GA1837470@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:64c2:47ad:dfe6:e0d9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22711514-8d6c-4480-9bae-08d768079d03
x-ms-traffictypediagnostic: AM0PR05MB6338:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR05MB63389535D39C45052603F2FDD1760@AM0PR05MB6338.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(189003)(305945005)(14444005)(71190400001)(7416002)(256004)(71200400001)(486006)(14454004)(8936002)(8676002)(81166006)(81156014)(6436002)(74316002)(2906002)(33656002)(6246003)(7736002)(966005)(4326008)(7696005)(76176011)(86362001)(6306002)(99286004)(110136005)(55016002)(186003)(5660300002)(6506007)(9686003)(46003)(11346002)(6116002)(25786009)(52536014)(316002)(476003)(446003)(76116006)(478600001)(66556008)(64756008)(66476007)(66446008)(54906003)(66946007)(102836004)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6338;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jxXwchvUhGwuFjzXE1o2Lt2cRtzgAq8z6cha+skEXQfFSNBa2k46Xe53nH0CMXfDCeTpfNqRya0DRIj1A2XMKBVX8Xn8+EwxLHnLeDDamxx9I8qOIznBNKTUX8wTkackx78dG+LbQROMCwjQllicWo3iLgydB0tVIifvhXSvyMWPOxGMNdhmIURFZe5dj1ylfyWsIDxpCGvB1Vl3p+Ga9eEs/kwjjbohyFBOXu149db4swyP6L59nufajcN6gg9yprk7Fb22wYsi3TEjkt1QFXG2V2HJDLAn3WrfdyZUjME+dJw894R3EXBwh7lDEbfVAG7wcpENz+SUjv6FDB6hMW2N9T6JE72OuR87zuvYL/wXVMEZJMGbMCfpHsmRvu5B0F8KJs0/FuR+B70L+JZHQZI+pGkIJSWGsIb8dv7ftfOinHC+hToJ+4VXa7kw1++fVIFXZaTP5srRHStYdxQYVb7AO6/dXVNqRz2qLgJMwNA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22711514-8d6c-4480-9bae-08d768079d03
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 07:03:40.3744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoaar3NfMTYGAeUe0JURNJj+M7FJUdo1mYxMH2LUQ5dOaVP3x7sIggyeyhereeYVpmQ/DXiwpUUlRSSnZOrE1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg, Jason,

> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, November 12, 2019 3:28 PM
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > This is the initial implementation of the Virtual Bus, virtbus_device
> > and virtbus_driver.  The virtual bus is a software based bus intended
> > to support lightweight devices and drivers and provide matching
> > between them and probing of the registered drivers.
> >
> > Files added:
> > 	drivers/bus/virtual_bus.c
> > 	include/linux/virtual_bus.h
> > 	Documentation/driver-api/virtual_bus.rst
> >
> > The primary purpose of the virual bus is to provide matching services
> > and to pass the data pointer contained in the virtbus_device to the
> > virtbus_driver during its probe call.  This will allow two separate
> > kernel objects to match up and start communication.
> >
> > The bus will support probe/remove shutdown and suspend/resume
> > callbacks.
> >
> > Kconfig and Makefile alterations are included
> >

[..]

I have a basic question with this bus.
I read device-driver model [1] few times but couldn't get the clarity.

mlx5_core driver will create virtbus device on virtbus.
mlx5_ib driver binds to virtbus device in probe().
However mlx5_ib driver's probe() will create rdma device whose parent devic=
e will be PCI device and not virtbus_device.
Is that correct?

If so, bus driver of bus A, creating devices binding to device of bus B (pc=
i) adheres to the linux device model?
If so, such cross binding is not just limited to virtbus, right?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/driver-api/driver-model
