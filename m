Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D7412D9F5
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLaPvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 10:51:17 -0500
Received: from mail-bn7nam10on2137.outbound.protection.outlook.com ([40.107.92.137]:20673
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfLaPvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 10:51:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDhTImBE2lWLiH+cd8IV4JCQFCZQQJzVLIhjXpT9a/JkS7INKjYIN5qxWqyjJae/jhGPHp+yBywYTIyFaxoPEgxU0lMC7wzJBFoYQsEpFCVX9jV2WWKs62edCoF+ToDBk+uCRhK2t0yz/0IA0kJGnH/nKzs68qtMyCPlEhsXwxl27tKsLO8Sf6uAht4BQ5O51bpre/vWMhiKWqODzKH66iWhmr/m5czg9QckXNe8YxLfnn6wZ6s+NeDZC21R04Z2MslyHSO61mvmewNcQiBEWml48hS1P/Cj/PgKhOn5g4wrzGNJXjhYJa+BqdEfQELqAJc/g1JhnuUmRUwTUAxLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Tnji/5dEtitg6PXF3qqaxMJLFry99yVx1A6+EgyjeE=;
 b=I0WOHI7vlDTsYn+nxeNDgngUQsUOBhlk/JtcQ8K0E9hu6smTTmfs2zITyAU25DOVenJxglSDIgdidRz8BGzIXASF7MDvqIgYkLjPMWoens88eboWDFlqXIGfY7C80HK3i6oRrc2lOgGVYN/ONaa97Ns174btlF29tPHMnZDyZcRX8VbOAtO0Sd519J/Q73eGFNPFNZvF3dD5Y9rYffO9ZUBQshvIWkOREqOUZBwdA2OzGLVAqTqETGdLFZ7EWiBDizYfGvuxS2ehPAz1Z9LHJnn2S6GpmQ6nzGPi5sLRQyQNTxAMMoc6mKPp8D2d6RaaxXpfup8Z/6398OgOzZXpUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Tnji/5dEtitg6PXF3qqaxMJLFry99yVx1A6+EgyjeE=;
 b=O2w2n9iGhm35JtW8dUYjCFm9bD1ERObPh6u9WjrU6QmpEbAiOMuNW/3ni1S7rZ3G6e6LgTxGVPvE3PQheiURPxgvb5NR2kCYZOtEdb5API6Xe9wuzOcteLpxozOcDgrHHigt5lTd/XpwydehL9gUC3QB+1sn5JNe+NbnaozOEJ0=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1181.namprd21.prod.outlook.com (20.179.20.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.1; Tue, 31 Dec 2019 15:50:32 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2623.002; Tue, 31 Dec 2019
 15:50:32 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to sysfs
Thread-Topic: [PATCH V2,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to
 sysfs
Thread-Index: AQHVv025lnTAhtETw0K5slPlS9br8qfTdmuAgADumHA=
Date:   Tue, 31 Dec 2019 15:50:32 +0000
Message-ID: <MN2PR21MB1375DB84228137F30E9C1891CA260@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-3-git-send-email-haiyangz@microsoft.com>
 <CY4PR21MB06299FE9E4C2023C6D886C84D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
In-Reply-To: <CY4PR21MB06299FE9E4C2023C6D886C84D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T01:34:57.1055604Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b5945d63-4c80-451a-8e09-e5ef2be28581;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f97d7ee8-eb4c-474f-e430-08d78e092b09
x-ms-traffictypediagnostic: MN2PR21MB1181:|MN2PR21MB1181:|MN2PR21MB1181:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB11814FDC5BCE017EF26352B5CA260@MN2PR21MB1181.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(346002)(396003)(199004)(189003)(13464003)(9686003)(55016002)(10290500003)(86362001)(52536014)(2906002)(4326008)(186003)(26005)(54906003)(81166006)(81156014)(33656002)(66446008)(71200400001)(53546011)(66946007)(8990500004)(478600001)(6506007)(8676002)(316002)(76116006)(66556008)(110136005)(5660300002)(8936002)(64756008)(66476007)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1181;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDdQ8lC+FySkAGjTJ5U0X3Lhd+6pDtFfef+Od/iqa1JzMaTkgiSsM4NjD1svRHyNm1Sub0yMz1cAXTJM0ANxeZFOMMfxCVhw859XAtQs0lcPU1HXeVnpdtEll2d/CFSc45vMXvVtD4q91ltLn9O1ZsOCr9JVJriDV2WTskUnV4L1mT1hRmFV/Qa6XdL1HqA1AdssaYGF47VEHMa0bBqkG0SWA40e2kcKe24/cIae9yabcFNj+W7bUacCup4oBmtjlIVfDeRn3l1JD2MeE98axkbCxWmwhpXdsoGtWhnbT46B2hHUjtkP5c5TldEMpH8+qDfLN88nOldMwSpIBqz3CDX1LvGNxnUSi7OkW8oobaw9UnoF96Qsdy0fPeO2nLB67L9hWFVutotRSgA6ZriAsGlsjtqBT1efilHRCDrwvR4Z/nOOrWH8UMYNaqiEVeBGZJAtl0u8aSnoJ3TmriROaF7n4kUsqsJ7h5A0abGnvJKWxj9I/dUARGEMw2fBnkVR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97d7ee8-eb4c-474f-e430-08d78e092b09
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 15:50:32.1944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D6AM9JsSqWjl+SiggivMbvIW6b+wb/K13SPanSnaCiEFm89oa0Ed0n3416Ho5/LDfoOm8lQG5Z9IwsVWZUGb8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Monday, December 30, 2019 8:35 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; sashal@kernel.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> olaf@aepfle.de; vkuznets <vkuznets@redhat.com>; davem@davemloft.net;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH V2,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to =
sysfs
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, December 30,
> 2019 12:14 PM
> >
> > It's a number based on the vmbus device offer sequence.
>=20
> Let's use "VMBus" as the capitalization.
I will.

>=20
> > Useful for device naming when using Async probing.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  Documentation/ABI/stable/sysfs-bus-vmbus |  8 ++++++++
> >  drivers/hv/vmbus_drv.c                   | 13 +++++++++++++
> >  2 files changed, 21 insertions(+)
> >
> > diff --git a/Documentation/ABI/stable/sysfs-bus-vmbus
> > b/Documentation/ABI/stable/sysfs-bus-vmbus
> > index 8e8d167..a42225d 100644
> > --- a/Documentation/ABI/stable/sysfs-bus-vmbus
> > +++ b/Documentation/ABI/stable/sysfs-bus-vmbus
> > @@ -49,6 +49,14 @@ Contact:	Stephen Hemminger
> <sthemmin@microsoft.com>
> >  Description:	This NUMA node to which the VMBUS device is
> >  		attached, or -1 if the node is unknown.
> >
> > +What:           /sys/bus/vmbus/devices/<UUID>/dev_num
> > +Date:		Dec 2019
> > +KernelVersion:	5.5
> > +Contact:	Haiyang Zhang <haiyangz@microsoft.com>
> > +Description:	A number based on the vmbus device offer sequence.
>=20
> The capitalization of "VMBus" is already inconsistent in this file in tha=
t
> we have "VMBus" and "VMBUS" in the text.  Let's not introduce another
> capitalization -- use "VMBus".

I will use "VMBus".=20
Thanks,
- Haiyang
