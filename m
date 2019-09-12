Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC97DB14DA
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 21:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfILToL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 15:44:11 -0400
Received: from mail-eopbgr1320138.outbound.protection.outlook.com ([40.107.132.138]:55200
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbfILToL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 15:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDp+E1WMxxfFupn9GeI7/id3Ni9O4WpQ1PAytsFpBVQFoyoFVIxp7oJ72el8LPj7yvHa+/snW5i4uoZq+PynZDHUGuicQHGDC/oYKRTZoD2UJ6E9tK25pAzPrWzgfddBsOJS7fTzJDIsZmq58/f5dq+/6cV/XajjxR0y/p7rWI+YWP4tEgFc02uKA/YoQ0T+R/SLoytuEZkg/fX3DOki7RaeULvyPjrOTGzGpaz+VUQk+jrQiHN7qlbnRdjVwq5XstKHUQ7Bd8hOBtXAYxhXH00Yyr/+RcV7QMApxopLCbW7X5cUEb2C6veDwm8kyiIkmK6uVf0TCasZMUZvDPgbsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLTODrrocgUMdtaY1JPHruyG5UmypxmW9SUHyr33e6M=;
 b=bYymOp1w9Lj3vYqxUpgcWpEnxKZFozQg4JrcGwhzgweotePNeb2wPHW2MTSPqXVaE+RgcZdgT6iIqcOeWrDE8FbO79YtL/YiM6BM61IeK4o01bG7Xa1qhEzMmfELze13n1V4m4c2SwXEvH3eagdvel1KqMeCttKL7yTIs6a0y2EeyGDdp7e/4z2apeU5sUebaAc5Nchh/F+6trthI3iX3FJXUaV9EQUiMB6R8YwGKWZr+94eQxpkScvGiuZL0SRDaSYXGmW7e5b+zTTaoXWf2J/KHDN3no6bauo4aSm1CscJtUcokjhTd7sDsZ74BgrOKKiuy6V/9C7aTn3Hm7E27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLTODrrocgUMdtaY1JPHruyG5UmypxmW9SUHyr33e6M=;
 b=TSPhQkUGHkwT+VYK9bh4ljTJJxTvAzOUrrtSnDoh5/hxc/IDSCRSSZVNvUHIKPEdNzJDtAWdf/c1AVNHcaOTW+dIIQ5dLTKpIvvlVjx9XEgheJ0hk0lrjq/wgWr+nDsdybAd/q2U0rxeU3z6zZdvM+upz9UdQ6yMsIJFv1gkm0Q=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0122.APCP153.PROD.OUTLOOK.COM (10.170.188.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.12; Thu, 12 Sep 2019 19:44:03 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::3415:3493:a660:90e3]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::3415:3493:a660:90e3%4]) with mapi id 15.20.2284.007; Thu, 12 Sep 2019
 19:44:03 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH][PATCH net-next] hv_netvsc: Add the support of hibernation
Thread-Topic: [PATCH][PATCH net-next] hv_netvsc: Add the support of
 hibernation
Thread-Index: AQHVaPnrTXkpPrlV+ESDlk6ioSqLf6coDp1ggABjRoA=
Date:   Thu, 12 Sep 2019 19:44:03 +0000
Message-ID: <PU1P153MB0169D1FB65D53380FEDF3132BFB00@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1568245063-69693-1-git-send-email-decui@microsoft.com>
 <DM6PR21MB1337EEC46A276CAD9FAA5EB4CAB00@DM6PR21MB1337.namprd21.prod.outlook.com>
In-Reply-To: <DM6PR21MB1337EEC46A276CAD9FAA5EB4CAB00@DM6PR21MB1337.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-12T13:50:14.1664906Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cf330f8a-bf0f-452f-9456-da47fa75c1da;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:49e:db48:e427:c2a0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6a1ed88-b1e2-4807-1847-08d737b9911b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0122;
x-ms-traffictypediagnostic: PU1P153MB0122:|PU1P153MB0122:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0122BA2920E5A6C846B99EE8BFB00@PU1P153MB0122.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(189003)(199004)(13464003)(446003)(25786009)(2201001)(1511001)(11346002)(102836004)(86362001)(6506007)(8936002)(8990500004)(305945005)(10090500001)(7736002)(110136005)(22452003)(52536014)(478600001)(6636002)(33656002)(256004)(74316002)(14454004)(14444005)(10290500003)(316002)(71190400001)(71200400001)(76176011)(46003)(66446008)(76116006)(99286004)(66556008)(66946007)(66476007)(7696005)(64756008)(8676002)(81166006)(81156014)(6436002)(6246003)(55016002)(9686003)(486006)(2501003)(5660300002)(2906002)(476003)(6116002)(229853002)(4744005)(186003)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0122;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pcgGC7mzYp8OYe0nWfIl7C2hH7danmcXbaey1tl8broNFYtLwUWtyQupF3EyDTHhCkSyIKQU9VPJ/OOprk8Lc8hX0i5KDXd6WLHbZIRqnYl6OaPUYxU0OwRChyMqUaS0UVYCNwFMoZsZK+MYyqXXvEIg/P7cfeiVzyuesuu0dFoqseihQUfWAvF9qNzglNR2hb8j8iRO+iU0A2xtpSoldFlUg8qvUvGgJ5+WsjOn5OwEra5AlUVzqRKojEEg+dbmb8GCeJFWLLJX3G/lzDSdPRY6S4vYlbH8Q6DRCuyC0zsxgj4BZaXvDoIeDtaXNB5v15cIdHI21o7qLx1WBs/CGkwDLDs1UGA8bXepr3G4fRkWsX8BE7Q0wuW5UKq7W3lrCYE+g5/IJOu60/zxR57nArqxrk3ltHmqRgbyG4Si4as=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a1ed88-b1e2-4807-1847-08d737b9911b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 19:44:03.5466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdjX02OnLQ29cidPU828o1UxtvSINGyk0BpPmcMIrRd+G5XdYgZpct82h00K0UjS/m0AG/QKou3ri5nW8hjicA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Thursday, September 12, 2019 6:50 AM
> > -----Original Message-----
> > From: Dexuan Cui <decui@microsoft.com>
> > Sent: Wednesday, September 11, 2019 7:38 PM

> > +static int netvsc_suspend(struct hv_device *dev)
> > +{
> > +	struct net_device_context *ndev_ctx;
> > +	struct net_device *vf_netdev, *net;
> > +	struct netvsc_device *nvdev;
> > +	int ret;
> > +
> > +	net =3D hv_get_drvdata(dev);
> > +
> > +	ndev_ctx =3D netdev_priv(net);
> > +	cancel_delayed_work_sync(&ndev_ctx->dwork);
> > +
> > +	rtnl_lock();
> > +
> > +	nvdev =3D rtnl_dereference(ndev_ctx->nvdev);
> > +	if (nvdev =3D=3D NULL) {
> > +		ret =3D -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	cancel_work_sync(&nvdev->subchan_work);
>=20
> This looks redundant because netvsc_detach() cancels subchan_work.
> - Haiyang

You are right. I'll remove the superflous line=20
cancel_work_sync(&nvdev->subchan_work);
in netvsc_suspend() in v2.

I'll wait for a few days before posting v2, in case people may have
other comments.

Thanks,
-- Dexuan
