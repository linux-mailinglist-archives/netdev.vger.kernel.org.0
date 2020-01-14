Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3651913AA9D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANNUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:20:39 -0500
Received: from mail-bn8nam12on2107.outbound.protection.outlook.com ([40.107.237.107]:52960
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbgANNUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 08:20:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I80cMxQHhLDmItSwyyHNPrKEK3IfoIHgxZod6ACbtrZVtA4yzk2M1dFKGrU9Hoy2zcDuaVYK1T7n0W78Q1NmF0lR+PD/ObsVWUMmIYQqrFFnPnjqJ4hITKis+V75bOr+iF6l7rLez7wgoCt7PwOWvZtP6M+a2eGvjg3nXTu/10N2kNP9pO4nHqo8myVIgXoPHDcFqtEdFggaQHw/e6NV1Wuswnz4AYaT2Rsjzzo7ZABgsGfZGFUCpYb/rWwkrya93XylfIJDN0fQBnZazxSx1JaxU4u3SiHZ5TqdgARCkbL3mJSNqeV6CGuxuR1XxMxbHjXPy8HizKrboM7PDQ3rbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfepfA8nFo8LyTvmkFfHa0JSxDvoj1h/lPVdWb1f1Vo=;
 b=NXSs3DJcE3WkIjn7wTo4Ee8qv/Fq9+VTDkGryOrCdB8X/lSG3LgqQAbAifRIwjMVFou73vfERtbT1PbbAT9FsVr2s2oVFXXIRkIQfZBfmp9KFBjMSqNaKXbCHXdzIom5fwbqBUtzKoQFtfgz9PT+dogCCxYmzkmRuSR534OVkyt26LBE6GAdxgbvx/qDbluDKb6yslc/FwpdlIc1MMPf/lDOLHKphwewFjhWVOEv1JNrTmBej1J8EiE0HR5oXHXGye7Xf+9nOIe0NHomK4mwXrskhykxpudd23MQKiN4zJojobKpZqCeBSxIKt2YlmLV8jXxhcTb6TkLZPrCm1zrTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfepfA8nFo8LyTvmkFfHa0JSxDvoj1h/lPVdWb1f1Vo=;
 b=H25FsG3W+FTilyFfTA75woOFiOsGG+W6QVIo8HcPnjyQIWvOh+n6Ki3wEEl4cN6PNxmXvPy1xasoyl3v2k/dIyp+h6m7zZDIbfQfBIIzUPWUaRu427cB8o2oHIqdjY+ohKq74MSwZ69HRnd2kmQUtS/UGD934CzWoogXDBbtUFo=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1230.namprd21.prod.outlook.com (20.179.20.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.2; Tue, 14 Jan 2020 13:20:35 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2644.015; Tue, 14 Jan 2020
 13:20:35 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Mohammed Gamal <mgamal@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        vkuznets <vkuznets@redhat.com>, cavery <cavery@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] hv_netvsc: Fix memory leak when removing rndis device
Thread-Topic: [PATCH v2] hv_netvsc: Fix memory leak when removing rndis device
Thread-Index: AQHVytwK4jNza0jiEEyO0P+JaEFlv6fqJKhg
Date:   Tue, 14 Jan 2020 13:20:35 +0000
Message-ID: <MN2PR21MB1375B535C440C4AEFC30827ECA340@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <20200114130950.6962-1-mgamal@redhat.com>
In-Reply-To: <20200114130950.6962-1-mgamal@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-14T13:20:33.5759006Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=20df002f-84e1-445c-aa72-e4cce63242a9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a58ab14-3532-4c17-2e9d-08d798f48a41
x-ms-traffictypediagnostic: MN2PR21MB1230:|MN2PR21MB1230:|MN2PR21MB1230:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1230B3D3558FBBC32D4D97F6CA340@MN2PR21MB1230.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(189003)(199004)(55016002)(53546011)(6506007)(2906002)(33656002)(316002)(9686003)(7696005)(5660300002)(52536014)(186003)(4326008)(10290500003)(8990500004)(54906003)(76116006)(64756008)(66556008)(66446008)(66476007)(26005)(81166006)(66946007)(8936002)(110136005)(86362001)(8676002)(478600001)(81156014)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1230;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QwX5DB4AVl4V+pfHe7zZhLx4/8EJse7/eK3qEdqdsvV5peEEdw1FD96VUaRNXx8aFnYaMiL8D3d3XocC68XJ8nuRv1BTLE6q5yuao0URy63qKXkd/UMemFiZkGoCYUjiq+PIAXbmhIl81FYK2dBdnglp8oFDQLf6sjG22+aqTY24GEyNRBa9U6INRAAwmEduOOKv+YWw4NPNoIskfry8cirucq4YOEtumbbTCtbecc+k7wPvcME6ec/TT6GvUkWKGX1xyEZbuB3ytt7+HMfWFA1uYGKISldy/sXJ+tMC/MWw2PWv11Cp6sXtqzjPYR+rjgNWXS+SV9VubKZh1ldapeDAjvHENUROmtJOJeHJRtxzy8TAoJvrSIgEDBmpN5M4QMY3XOqKdPR2qyD8G7AqxS57CXVsT1Y1w19InTyipbf+yP3CkP4HUuUtAiK3ndP+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a58ab14-3532-4c17-2e9d-08d798f48a41
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 13:20:35.2625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGFcZj2zNyVy3/++w0HUztNxngoiRPe35SIEGOkrzgNjU1WI6DLhl6x5z/cbHA10oLm82Afu0yyl7uKDGlVFsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1230
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Mohammed Gamal <mgamal@redhat.com>
> Sent: Tuesday, January 14, 2020 8:10 AM
> To: linux-hyperv@vger.kernel.org; Stephen Hemminger
> <sthemmin@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; sashal@kernel.org; vkuznets
> <vkuznets@redhat.com>; cavery <cavery@redhat.com>; linux-
> kernel@vger.kernel.org; Mohammed Gamal <mgamal@redhat.com>
> Subject: [PATCH v2] hv_netvsc: Fix memory leak when removing rndis device
>=20
> kmemleak detects the following memory leak when hot removing a network
> device:
>=20
> unreferenced object 0xffff888083f63600 (size 256):
>   comm "kworker/0:1", pid 12, jiffies 4294831717 (age 1113.676s)
>   hex dump (first 32 bytes):
>     00 40 c7 33 80 88 ff ff 00 00 00 00 10 00 00 00  .@.3............
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>   backtrace:
>     [<00000000d4a8f5be>] rndis_filter_device_add+0x117/0x11c0 [hv_netvsc]
>     [<000000009c02d75b>] netvsc_probe+0x5e7/0xbf0 [hv_netvsc]
>     [<00000000ddafce23>] vmbus_probe+0x74/0x170 [hv_vmbus]
>     [<00000000046e64f1>] really_probe+0x22f/0xb50
>     [<000000005cc35eb7>] driver_probe_device+0x25e/0x370
>     [<0000000043c642b2>] bus_for_each_drv+0x11f/0x1b0
>     [<000000005e3d09f0>] __device_attach+0x1c6/0x2f0
>     [<00000000a72c362f>] bus_probe_device+0x1a6/0x260
>     [<0000000008478399>] device_add+0x10a3/0x18e0
>     [<00000000cf07b48c>] vmbus_device_register+0xe7/0x1e0 [hv_vmbus]
>     [<00000000d46cf032>] vmbus_add_channel_work+0x8ab/0x1770 [hv_vmbus]
>     [<000000002c94bb64>] process_one_work+0x919/0x17d0
>     [<0000000096de6781>] worker_thread+0x87/0xb40
>     [<00000000fbe7397e>] kthread+0x333/0x3f0
>     [<000000004f844269>] ret_from_fork+0x3a/0x50
>=20
> rndis_filter_device_add() allocates an instance of struct rndis_device wh=
ich
> never gets deallocated as rndis_filter_device_remove() sets net_device-
> >extension which points to the rndis_device struct to NULL, leaving the
> rndis_device dangling.
>=20
> Since net_device->extension is eventually freed in free_netvsc_device(), =
we
> refrain from setting it to NULL inside rndis_filter_device_remove()
>=20
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  drivers/net/hyperv/rndis_filter.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 857c4bea451c..e66d77dc28c8 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1443,8 +1443,6 @@ void rndis_filter_device_remove(struct hv_device
> *dev,
>  	/* Halt and release the rndis device */
>  	rndis_filter_halt_device(net_dev, rndis_dev);
>=20
> -	net_dev->extension =3D NULL;
> -
>  	netvsc_device_remove(dev);

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

