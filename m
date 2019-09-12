Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A52CB105F
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfILNuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:50:19 -0400
Received: from mail-eopbgr690099.outbound.protection.outlook.com ([40.107.69.99]:41455
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731420AbfILNuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 09:50:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3I4zWumsb3u7Uz1RGCK+byGQkgZY9EVX+lJV8WquRC04EZEWIZfexGkPDbwAY0UUL7+97iBcxHNfAg/GFk5UQu11RbuzqZ2IbF0dGtVACc5heAtdsAFR5tWG/UHpnlFF6i+MGJEOfGsVhl7nJG9D8XYzTF0aYso6LOYLE5eSkTr5KxQ6eFwQRumZLk+8BSwMplxolrZlQRyrtUxBlDJNpIojWSHBSosuyla2lHgP47m92OZwf3UT8+zBTWI+QpbuQJr1LcsklMEXyHhBJ4gNhdD9B5w94hi3Mg/dxmMXdsIbmutvoYbSHgwQObCZ1e6BvOoKJUPK83haR/XwTum2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EufRYZ0Hn3z1noUB0hWEcnEZHRxrVu+DY8xVMCLznLU=;
 b=khJ+uJBbkvSrWa7wloog3to78vOegHDgaIEaI/elyCkx16uUVG/M86GbBBERok/wTWJ8TpFCxMAZOzb0vQKqyW4MkO3vjbciyDvpLfMQcfeGtQ4veuz1fQ6sT4SSClo9xTVppysgyru7a/69iV3P86wgB5w/frPo3j9YDORTTRAptX7wZeo09yCH9h1KhBTFYI/iJy9gbwOEJRM3oJ2cD5Q6ouvilQbAMcm2fC7XJ6p7yXEY/j7EGX/gvNXm/+igNTKxDv21tiVIftRu2Kt+txY6A29I0v35xTQhYU6f7H83D3dbgydljp4vvt8UGuFahX0xfdLZyTSz1CSYLvdBsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EufRYZ0Hn3z1noUB0hWEcnEZHRxrVu+DY8xVMCLznLU=;
 b=RO0j8/wW1AgXQmgYx/WVhHZLGtGS0iGAvNP9vlCpWp5TG7bAEfalzeF/xsxNOhwTkVelnoFpMdPWdNcMlt7XT+fSPxVguQ5OkWFklDPJ/795pPyAk/o2JT3R6WpiacA0bvrk+1SxBj7J1tpjFPpWvVjkEDE33lNVT1j1iJI0GHk=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1322.namprd21.prod.outlook.com (20.179.53.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.6; Thu, 12 Sep 2019 13:50:15 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::2cde:35d7:e09a:5639]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::2cde:35d7:e09a:5639%6]) with mapi id 15.20.2263.005; Thu, 12 Sep 2019
 13:50:15 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
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
Thread-Index: AQHVaPnrTXkpPrlV+ESDlk6ioSqLf6coDp1g
Date:   Thu, 12 Sep 2019 13:50:15 +0000
Message-ID: <DM6PR21MB1337EEC46A276CAD9FAA5EB4CAB00@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1568245063-69693-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1568245063-69693-1-git-send-email-decui@microsoft.com>
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
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74d12904-728f-4f0b-cbad-08d7378823f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1322;
x-ms-traffictypediagnostic: DM6PR21MB1322:|DM6PR21MB1322:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR21MB132281832B3FFA0CC41ECB7ECAB00@DM6PR21MB1322.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(40224003)(199004)(189003)(13464003)(76176011)(256004)(81156014)(14444005)(52536014)(66476007)(8936002)(81166006)(476003)(25786009)(11346002)(8990500004)(10090500001)(486006)(229853002)(66066001)(2906002)(3846002)(102836004)(8676002)(6116002)(26005)(5024004)(7696005)(2501003)(33656002)(6246003)(6306002)(186003)(6506007)(99286004)(316002)(66946007)(64756008)(66446008)(86362001)(53546011)(74316002)(66556008)(478600001)(110136005)(446003)(6436002)(76116006)(7736002)(1511001)(55016002)(22452003)(6636002)(305945005)(5660300002)(53936002)(71190400001)(71200400001)(966005)(9686003)(14454004)(2201001)(10290500003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1322;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7xQWIdvXYJ7VZQxd7MuUHPf2s/rFiOTcWUQn4D7TVj6MPeBQPYbqYxn7h4JGC/yLcThK6vGkMUKLeAYTDgJ78L3urntOB1OANH8Gv1Fn/PWCrYsjE3p2f/cKMJofuLUDBZIr0Mi2bCa66zyvvy6oZbYuRCpoJsjZxyY29i0jX9aJV6KZ80zLP8QqFQa+1xTu6w4P3toPnH58BOW9VUGvZNECT/b0QtSu39H+betrVWcyH6oIkAA5EXBuf+6LX6NBkCiaTp7hvjct7Cm2j6zAghM4/qEFzvDyy7OS0P6gpez31fLlLcaUzwFlr8IuLG0F6PCRxc+DlFIogTcGN9j69X37wy21klTE77sXa+MgCFmgSYFBoWdN1T6taPfyiURnywoXJAIQXZxC0MPnXplGaoqG8R8+Chqki4qyA5ed2+w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d12904-728f-4f0b-cbad-08d7378823f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 13:50:15.3261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3O9Nv6T6dPbhpmyt2QUO+n3+UBJ0K3GBC4/oBi1HVKi/ZCo1IL0JAeONiu5xKHOxwxuvM/1NwYTyj0FIvmxpOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1322
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Wednesday, September 11, 2019 7:38 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; davem@davemloft.net;
> linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Michael Kelley <mikelley@microsoft.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Subject: [PATCH][PATCH net-next] hv_netvsc: Add the support of hibernatio=
n
>=20
> The existing netvsc_detach() and netvsc_attach() APIs make it easy to
> implement the suspend/resume callbacks.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>=20
> This patch is basically a pure Hyper-V specific change and it has a
> build dependency on the commit 271b2224d42f ("Drivers: hv: vmbus:
> Implement
> suspend/resume for VSC drivers for hibernation"), which is on Sasha Levin=
's
> Hyper-V tree's hyperv-next branch:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k
> ernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fhyperv%2Flinux.git%2
> Flog%2F%3Fh%3Dhyperv-
> next&amp;data=3D02%7C01%7Chaiyangz%40microsoft.com%7C0b84e40c446
> 648cc35fb08d737110e28%7C72f988bf86f141af91ab2d7cd011db47%7C1%7
> C0%7C637038418703112019&amp;sdata=3Dqd7DGFCJZ%2BDTix0VGcCe1JucV
> O97E0gILpVpcxlA6EE%3D&amp;reserved=3D0
>=20
> I request this patch should go through Sasha's tree rather than the
> net-next tree.
>=20
>  drivers/net/hyperv/hyperv_net.h |  3 +++
>  drivers/net/hyperv/netvsc_drv.c | 59
> +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 62 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h
> b/drivers/net/hyperv/hyperv_net.h
> index ecc9af0..b8763ee 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -952,6 +952,9 @@ struct net_device_context {
>  	u32 vf_alloc;
>  	/* Serial number of the VF to team with */
>  	u32 vf_serial;
> +
> +	/* Used to temporarily save the config info across hibernation */
> +	struct netvsc_device_info *saved_netvsc_dev_info;
>  };
>=20
>  /* Per channel data */
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index afdcc56..f920959 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2392,6 +2392,63 @@ static int netvsc_remove(struct hv_device *dev)
>  	return 0;
>  }
>=20
> +static int netvsc_suspend(struct hv_device *dev)
> +{
> +	struct net_device_context *ndev_ctx;
> +	struct net_device *vf_netdev, *net;
> +	struct netvsc_device *nvdev;
> +	int ret;
> +
> +	net =3D hv_get_drvdata(dev);
> +
> +	ndev_ctx =3D netdev_priv(net);
> +	cancel_delayed_work_sync(&ndev_ctx->dwork);
> +
> +	rtnl_lock();
> +
> +	nvdev =3D rtnl_dereference(ndev_ctx->nvdev);
> +	if (nvdev =3D=3D NULL) {
> +		ret =3D -ENODEV;
> +		goto out;
> +	}
> +
> +	cancel_work_sync(&nvdev->subchan_work);

This looks redundant because netvsc_detach() cancels subchan_work.

Thanks,
- Haiyang

