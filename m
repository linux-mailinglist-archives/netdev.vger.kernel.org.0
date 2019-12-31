Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03FC12D9F0
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 16:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLaPsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 10:48:54 -0500
Received: from mail-dm6nam10on2101.outbound.protection.outlook.com ([40.107.93.101]:13217
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfLaPsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 10:48:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTh0VEGI0awpXNOK/Egy8b9mLA/dOteTFxiiI6Lctl5sm9IhCL5+wxvuZL6yECx4lIGBxQK+NPevQtbwxFkaJOzShoshETGMuB1rjMphgHaJ9J5K//bhnU5U+1GcshTlsExo+iv0n3C9ZhcQlEIjKdkthO36oc+ek2tjxyhs0OtM+FyXxwtVHJiuZwY7u9L49fxjqQVDG6s3UB7bnMAGODmk+6NprdDgIekxrmocvG5IUxsUVPjtWZIr8cBlEVLnAxKvAgTzAKhlITmSCwZDA+nZ7rWfhpUHTFMsM716O4qFkHRYE8/pG+pFFyxCH3ii3cDwwX9qjD1yNBbPEbYhEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zrx+cQxrt2w8zfVNjyHyGWG+WojgV+kJADzAqU+Duac=;
 b=TOsLljMglFZ2dUqM1KFUcIVkzEiadlQbkx6ShIQbPG7UiI8WLXxh8FGNBR3TvtvmOmx51+eDzTOhdE2Dfvob0M7VxI/dOAd/CrCO8OGMqsDXzhVZXYYKLwjRsnmXXvZ85RNM/kKdUgpe/PQ0RTqGpzysFribbiMlTGWBXdhguoGtNgRtw2fm2H2LeUT/prADkNcCOFInmofGDwBUE975rVwdM58RxEKnjXQdBzr8jpEBTaUigHVOWrsKfbUFbOhvMHLyQtKPIECzBXRr+A67J0nQs/xn0V+rcAd9Xi+rBKjOp3yDY+Npz3NVFQqLzs09an0+IfVESvcPCDZhA7aM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zrx+cQxrt2w8zfVNjyHyGWG+WojgV+kJADzAqU+Duac=;
 b=N+/5gKRxB3ALFscftFu4ujhEgwm9JhSxtIK/SLUK9zxJpKhVrbL8pB631ykXs78SPqyTLvDJYg1f4rAGE1pnJInz5tE3wNJWiOxvj2E7ZCoPIGt0dRciZBhpW1OEUYYhyiT4N90InJ9Psu8PHqQcqRMXrfEtiGg3NGaysgZV26Y=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1166.namprd21.prod.outlook.com (20.178.255.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.1; Tue, 31 Dec 2019 15:48:49 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2623.002; Tue, 31 Dec 2019
 15:48:49 +0000
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
Subject: RE: [PATCH V2,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num
 variable based on channel offer sequence
Thread-Topic: [PATCH V2,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num
 variable based on channel offer sequence
Thread-Index: AQHVv024UVKtE3vlxU+v4ITCgTu7YqfTdlwAgADuAkA=
Date:   Tue, 31 Dec 2019 15:48:49 +0000
Message-ID: <MN2PR21MB13755EDE1568B0E0940E5133CA260@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-2-git-send-email-haiyangz@microsoft.com>
 <CY4PR21MB06294EA44916F9BD16138F94D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
In-Reply-To: <CY4PR21MB06294EA44916F9BD16138F94D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T01:34:44.1639696Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=554a2b6a-063c-4cad-a423-10c76d7c12e4;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22862863-dd27-4f18-1c06-08d78e08edb3
x-ms-traffictypediagnostic: MN2PR21MB1166:|MN2PR21MB1166:|MN2PR21MB1166:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1166D6E4948237C201282EE9CA260@MN2PR21MB1166.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(366004)(396003)(199004)(189003)(13464003)(6506007)(33656002)(26005)(81156014)(52536014)(5660300002)(54906003)(81166006)(110136005)(8676002)(8990500004)(7696005)(86362001)(186003)(53546011)(316002)(8936002)(10290500003)(71200400001)(478600001)(64756008)(66476007)(66556008)(66446008)(76116006)(4326008)(66946007)(9686003)(2906002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1166;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J1IbUjkfIbJmsV50KYVh1DbwUQiJjsQeDPUqMUvt/i4oTaUoV/MAxbgZHG6olQr4YIxqEshL+DqRJS0OyST3O6VkOR6tm/XFentewScblZLAbEbiFXvt2DY+mLpjmywCi1HLQ7Y61PW16w3JuidOCGl+BALpiL1hfS5uFHBgNKou+d4W7215pbqlgnOQoUjVoN1k8fZse8amkYtSxeuAoO3IxgVRRNkaguEV8ZbRJElEgBvIQ2YX59TxL23T0ZGK36M3MRlIs4bdrdhWhMEy6v7ouEgd9zSk41mStxcTvRkUc5C7rD5VAv8UILf3xdBJSlFqJMT4QbU7FGYNRzhqT4hBrQk/G6D9b+SO2a5u3LMpaD1supIYEzSXCBJq6c5c94I4RIg2G0Ok9EIbkbk0DUFHEQwTLfJjZw0f+CXqXi182Quur0ReMN6wywgxDEbj/VGmwpuhFZmGnpwQhBvuf25EaTXY+/ITsmwtpc4FWWdTRXPemCXFvGfMjAe9Dz47
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22862863-dd27-4f18-1c06-08d78e08edb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 15:48:49.3126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nD9vQQ3VFHqYbXqHEDoW7OkarmBnwhsYB/I2zZKN61mc+zS8PXAV8FAPDzC8ittvz3DJNg9NZGt0xbQtWD5PAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1166
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
> Subject: RE: [PATCH V2,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num
> variable based on channel offer sequence
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, December 30,
> 2019 12:14 PM
> >
> > This number is set to the first available number, starting from zero,
> > when a vmbus device's primary channel is offered.
>=20
> Let's use "VMBus" as the capitalization in text.
Sure I will.

>=20
> > It will be used for stable naming when Async probing is used.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> > Changes
> > V2:
> > 	Use nest loops in hv_set_devnum, instead of goto.
> >
> >  drivers/hv/channel_mgmt.c | 38
> ++++++++++++++++++++++++++++++++++++--
> >  include/linux/hyperv.h    |  6 ++++++
> >  2 files changed, 42 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> > index 8eb1675..00fa2db 100644
> > --- a/drivers/hv/channel_mgmt.c
> > +++ b/drivers/hv/channel_mgmt.c
> > @@ -315,6 +315,8 @@ static struct vmbus_channel *alloc_channel(void)
> >  	if (!channel)
> >  		return NULL;
> >
> > +	channel->dev_num =3D HV_DEV_NUM_INVALID;
> > +
> >  	spin_lock_init(&channel->lock);
> >  	init_completion(&channel->rescind_event);
> >
> > @@ -541,6 +543,36 @@ static void vmbus_add_channel_work(struct
> work_struct *work)
> >  }
> >
> >  /*
> > + * Get the first available device number of its type, then
> > + * record it in the channel structure.
> > + */
> > +static void hv_set_devnum(struct vmbus_channel *newchannel)
> > +{
> > +	struct vmbus_channel *channel;
> > +	int i =3D -1;
> > +	bool found;
> > +
> > +	BUG_ON(!mutex_is_locked(&vmbus_connection.channel_mutex));
> > +
> > +	do {
> > +		i++;
> > +		found =3D false;
> > +
> > +		list_for_each_entry(channel, &vmbus_connection.chn_list,
> > +				    listentry) {
> > +			if (i =3D=3D channel->dev_num &&
> > +			    guid_equal(&channel->offermsg.offer.if_type,
> > +				       &newchannel->offermsg.offer.if_type)) {
> > +				found =3D true;
> > +				break;
> > +			}
> > +		}
> > +	} while (found);
> > +
> > +	newchannel->dev_num =3D i;
> > +}
> > +
>=20
> It took me a little while to figure out what the above algorithm is doing=
.
> Perhaps it would help to rename the "found" variable to "in_use", and add
> this comment before the start of the "do" loop:
>=20
> Iterate through each possible device number starting at zero.  If the dev=
ice
> number is already in use for a device of this type, try the next device n=
umber
> until finding one that is not in use.   This approach selects the smalles=
t
> device number that is not in use, and so reuses any numbers that are free=
d
> by devices that have been removed.
I will rename the variable, and add the code comments.
Thanks,

- Haiyang

