Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4811312DA01
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 17:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLaQBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 11:01:08 -0500
Received: from mail-eopbgr700100.outbound.protection.outlook.com ([40.107.70.100]:18145
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfLaQBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 11:01:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfELhsHRkrqONLCXCSEWMlpLQFLCLX4PKIad2qK8nWffc/DHRDbUDkON+pLL/tIsVKif4bXEuZGNe4yXa3OWr+VjVNxEbJl7T+1Wz3eO6+3/3Js3Op1PiCCnfLQim0Pwh79KQJqZQlgVnNAd1lRbt+FtOpNNPsfcnUHnc9PPl615pI1nqRJPvmFpc6LAND9PqG5UlySmPZKIUBF8Gprs9wGo1jM6AYt3uA+IEnQ1ycLRFZz9TmL52rX4y0afNbVwN/jK+onIxqDAePhCmeLr7a39ljIWR4+DZZykFvpOpvCQYC0pB0tDkvnf9y99PVZWhBPCKOnUFpn/aWpYZn6EIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuNuj3P+Gu4jbIzqvMkOLd0/2dIAR+Shal3mUdbP5uc=;
 b=LyiHyimM3TSDhvAl8LXnrrXVmQbRcEElKqBLQP+l3NZVRlrBFWjs5RLO5rR/SWYjPLsn9nfXvbiU55eEiM18MXClWaFOJvguf0n4T080Ml1tT0YhXZ1xLsyRzoE0sgYc/Kn1hhTBXW4oPsP/ndww3LAkHpgaBs91yDrfc6JXtb5Yq0P3b+mjv9ZlVLNsZnSt88Uekw8OImnMbAlb2sM/GGDbpIQafP1Jv/4aPzRlThyn+Q1rbUbib1hEJmMYzXFrfkuIvUCf5Wekiu1zLVpxzZ/01KhlWOjmhYaGBW0FNZzV6O4AZhpChR0CdFIk3mhx28YhSWISsEy+cD9wEsmfjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuNuj3P+Gu4jbIzqvMkOLd0/2dIAR+Shal3mUdbP5uc=;
 b=PaKjq00uBFrS8moTAFI2AEo6YnGXIZQpoleUi60qL+eiQKXA0TNLqzRa+TKRtr1voNaZpVHC7uSu9k0P31X4I0PTRSsOa4Vtp62CBasiwEvdm3yyZgNO/CkPoZa1YSbuK5R4v25mrIiVOJkl4yrI2dEWOfaYFqv+ZxS3m3lj6JY=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1517.namprd21.prod.outlook.com (20.179.223.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.1; Tue, 31 Dec 2019 16:01:02 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2623.002; Tue, 31 Dec 2019
 16:01:02 +0000
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
Subject: RE: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Topic: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Index: AQHVv027GHCeFuKLhUO4V+gfj0XECKfTdnmAgADvB5A=
Date:   Tue, 31 Dec 2019 16:01:02 +0000
Message-ID: <MN2PR21MB1375F8871A9AEFE95C96FAFACA260@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
 <CY4PR21MB0629771D2D6FECB76339EFA0D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
In-Reply-To: <CY4PR21MB0629771D2D6FECB76339EFA0D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T01:35:09.3127531Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7a2a8dcb-4e6c-4c83-96e4-76533ee43af9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: da4cf225-ffcf-4025-d42a-08d78e0aa2dc
x-ms-traffictypediagnostic: MN2PR21MB1517:|MN2PR21MB1517:|MN2PR21MB1517:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB15172534E0D0BAE1B66439A8CA260@MN2PR21MB1517.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(376002)(39860400002)(136003)(13464003)(199004)(189003)(55016002)(9686003)(26005)(186003)(86362001)(66446008)(6506007)(7696005)(71200400001)(8936002)(53546011)(64756008)(4326008)(66556008)(10290500003)(66476007)(2906002)(66946007)(76116006)(5660300002)(478600001)(52536014)(33656002)(8990500004)(110136005)(54906003)(8676002)(316002)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1517;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MIoJgb+qh690mqNedKtDpMQg+xSE9+YSGrDrkPJV2k2NyoNzf6D86MhJg7+s+1a6xWIfLQCU+STLRNCTcmrONA4M3Z2yzmGW9JmLx85wAKBCuRXAIGAkPTAf6P1n/AdwzpZXkhHqRD+HjRp/KdoQCI5sXMCATe1J1W2bGqKssxrk/jmi4pvSAaehy24mc43S+ewpRdQldTaa5jlHyZfsDXnNDvXv5OKzl56VtP862vs5JWTpdqNF6UzfuJ1GdMgCre/B9LYUWprDXv7RR8j4GAp7KAX73hnVqv69rYVKLm20cThQ87SQkibJRDCZN+5njUSWzfgSvNVH0Y7q5Scyc1ONyMSPeuBVR36vrDwYFABr6oAVvuMAZ/H9H6Zm0Yrz1vIUf9WqeZ8Hg/kGyIecRQi4T5zT62bv77PdCC+Ff/Nnz144Wf9Eaw32lrhu8QZM+sl/KKn0cvR4ySTvxrJcGKdCoJBSMC6r6iCyt1w1W3T4JA4tH3KsHV3WXA+PMz9s
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4cf225-ffcf-4025-d42a-08d78e0aa2dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 16:01:02.7134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Grfj7VXcXa++AdQIuR+EcJkP5UrVYxFK36/Ch+fuosMbtkYK6QtH+ddYLaKcpYORL7zV8Dc9tWab44aMxESviw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1517
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
> Subject: RE: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
> offer sequence and use async probe
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, December 30,
> 2019 12:14 PM
> >
> > The dev_num field in vmbus channel structure is assigned to the first
>=20
> Let's use "VMBus" in text.
I will.

>=20
> > available number when the channel is offered. So netvsc driver uses it
> > for NIC naming based on channel offer sequence. Now re-enable the async
> > probing mode for faster probing.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvs=
c_drv.c
> > index f3f9eb8..39c412f 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *dev,
> >  	struct net_device_context *net_device_ctx;
> >  	struct netvsc_device_info *device_info =3D NULL;
> >  	struct netvsc_device *nvdev;
> > +	char name[IFNAMSIZ];
> >  	int ret =3D -ENOMEM;
> >
> > -	net =3D alloc_etherdev_mq(sizeof(struct net_device_context),
> > -				VRSS_CHANNEL_MAX);
> > +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
> > +	net =3D alloc_netdev_mqs(sizeof(struct net_device_context), name,
> > +			       NET_NAME_ENUM, ether_setup,
> > +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> > +
> >  	if (!net)
> >  		goto no_net;
> >
> > @@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *dev,
> >  		net->max_mtu =3D ETH_DATA_LEN;
> >
> >  	ret =3D register_netdevice(net);
> > +
> > +	if (ret =3D=3D -EEXIST) {
> > +		pr_info("NIC name %s exists, request another name.\n",
> > +			net->name);
> > +		strlcpy(net->name, "eth%d", IFNAMSIZ);
> > +		ret =3D register_netdevice(net);
>=20
> The message above could be confusing.  "request another name" sounds
> like a directive to the user/sysadmin, which I don't think it is.  Perhap=
s
> better would be "requesting another name", which says the system is
> handling the collision automatically.
>=20
> Also will this second call to register_netdevice() actually assign a nume=
ric
> name?  If so, it would be really nice for the message to be output *after=
*
> the second call to register_netdevice() and to show both the originally
> selected name that collided as well as the new name.  We sometimes get
> into NIC naming issues with customers in Azure, and when a new name
> has to be selected it will help debugging if we can show both the origina=
l
> selection and the new selection.  With both pieces of data, there's less
> guessing about who did what regarding NIC naming.
Good idea! I will include both new and old names in the log messages.

>=20
> Finally, having to choose a different name because of a collision does
> *not* update the channel->dev_num value.  Subsequent calls to
> hv_set_devnum() will detect "in use" based on the originally assigned
> dev_num value.  I don't think that fundamentally breaks anything, but
> I wondered if you had thought about that case.   Maybe a comment here
> to that effect would help a future reader of this code.

That's correct. And I'm aware of this situation. But, the dev_num shouldn't=
=20
be changed, because we want it to keep track of the sequence of device=20
offering.
Avoid single or multiple collisions, we should use udev or other daemons to
set name of VF or other types of NICs to different formats, like "vf*", or =
"enP*",
etc. For distros have not done so already, we need to work with the distro =
vendors
to ensure udev or other settings are correctly included in Distros, and Azu=
re images.

Thanks,
- Haiyang

