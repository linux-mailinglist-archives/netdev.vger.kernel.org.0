Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF512D584
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 02:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLaBfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 20:35:02 -0500
Received: from mail-bn7nam10on2118.outbound.protection.outlook.com ([40.107.92.118]:5496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfLaBfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 20:35:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4eBontDXJ0iDAM5x1ZJJl7bsMZ4/treNUo2PCoAblEbY4lCSCi02uMpvtdtwLuexBvJiTJ/7JVOQsvxMhsgsdtSLIADQU8TLZRkWlRusfZST3xbJ2tHB4EOqakysQEMuEWPnNbUcZ+RTwJ0vkkVqXW0zMZapzLZVJH8tePEJ8Aq5G6BLN7IuuRQtOtDOte+/IIgAwjB54eRO3chgLkoMO6GO+gze4oQIqhSP8GA4hR5E3ueKFJjOfXdCXO1u/15k6EFmkTFS1/LsxE+KIMYhXUsdQq8fAk6P0/YEWlkzTV1Hyf5BkX0FkgLJ7Ya09SPn7qEMrlFEWhH31tJd7TQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy8Wh5SiOFf4HkZEvJfUIfFw9oTCE6p4oyRYYmer240=;
 b=RmGN9nYc0YVR0hzFV2a+T6ifm9QkhNPJDcV2wyHQdP8rKlwfxnMVExK4E7wEdOtLxrVMQVTpa9QrHt6/TbPfe7U/OxyP7qsPz4ZQcJZeD8wppdkeZKxVJVcPdJWJ8jOaUzfmqYsS4M4jUGg2S3i7DVA+PPMJhxljRo4Ph0QBBg0iuFHTYNsfd5bhZLKC4ZFRkVsi3p5/WWXFHt/kMTlo2izmLHGbL3ttCBUvh7tXm9ibxdqxrp1vPUqtPBDdatKZgHm9gTNVtRXd9Im05ewupX9cK1aJTJ37qUT09ekLbAQDctzQdBPykmliShIXSGj2eDx05/KS8MWfCztR9Z0Eig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy8Wh5SiOFf4HkZEvJfUIfFw9oTCE6p4oyRYYmer240=;
 b=TWd3YcM6u587WoNsTgBiQuPiP7tYZraCrZGi4FxV0xxCJ1xM9MuYovnFdEKTEnqmE9+K1aDLvEYn2TuS/FKGKvcE2TKlc5GP6DAvc35fR9LoJjBMtekzton1NXcEMCW4Q6o7yz+uy6uqL90IYi+z0cUhfEcTWVDeA9mJCbMwQ6s=
Received: from CY4PR21MB0629.namprd21.prod.outlook.com (10.175.115.19) by
 CY4PR21MB0277.namprd21.prod.outlook.com (10.173.193.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 01:34:59 +0000
Received: from CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::654d:8bdd:471:e0ac]) by CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::654d:8bdd:471:e0ac%9]) with mapi id 15.20.2602.010; Tue, 31 Dec 2019
 01:34:59 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to sysfs
Thread-Topic: [PATCH V2,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to
 sysfs
Thread-Index: AQHVv03E7KFQPdbj7ESB02NXlI3++afTcKzA
Date:   Tue, 31 Dec 2019 01:34:59 +0000
Message-ID: <CY4PR21MB06299FE9E4C2023C6D886C84D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-3-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1577736814-21112-3-git-send-email-haiyangz@microsoft.com>
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
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ce8d881-60f0-4e13-7a38-08d78d91a647
x-ms-traffictypediagnostic: CY4PR21MB0277:|CY4PR21MB0277:|CY4PR21MB0277:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB027739CC9EE5EE8651E29A5ED7260@CY4PR21MB0277.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(376002)(346002)(366004)(199004)(189003)(76116006)(10290500003)(8936002)(66476007)(66556008)(66446008)(64756008)(8676002)(4326008)(81166006)(81156014)(52536014)(7696005)(66946007)(26005)(8990500004)(71200400001)(316002)(186003)(86362001)(33656002)(5660300002)(54906003)(478600001)(9686003)(2906002)(6506007)(110136005)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0277;H:CY4PR21MB0629.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgZH0WO6MnBlg7u7SGAKnNGun2G/72HOF6nYqRtugPAw5qjVfiuM5elzyLqFZEAdJ5skDnTepZUlBQoONwuWA0jUBjUqPQDEM+rR/i5KjvM+6cnEKyvTXKT67AHlP1jLZhEvGtJhziV67N2sKp91z7Jn2lIHlfjJ9ixw3EEBGaSGiCe+WTBT/QAOl6efUiIIGWykrfd/khzvouK49ilYAJVDHAePI/jlRSqElhLl8N1w5jHHd0GD+CH5NY2c8VEarYaCEe9Ny6opTGqcmN/ToAC5HUy75ckq8pJV5F9RzMF7ANt0xnii4BT6Dq1NOY+2LZCIQQNBOqo34cDBkPp39UKxGYJWXiNRdb8baLPX2HkyTQtLTo1/cE1Wp5fzdSsV9s0VKD26IBsJcHm+njQROiqCp2BE6EX2vWG0TkpGZN+uFkGn72G4p3babRgsj6un
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce8d881-60f0-4e13-7a38-08d78d91a647
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 01:34:59.4601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XugHctacH2DXvagsODluflIj2JyF3ud48FE1YWnNuseSOT/1NJiUuNJ9zRRp5mk4MXJYlPkcaNnftEvJWeTds5SOWvsoVKl1v7zNY9GDbJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, December 30, 201=
9 12:14 PM
>=20
> It's a number based on the vmbus device offer sequence.

Let's use "VMBus" as the capitalization.

> Useful for device naming when using Async probing.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  Documentation/ABI/stable/sysfs-bus-vmbus |  8 ++++++++
>  drivers/hv/vmbus_drv.c                   | 13 +++++++++++++
>  2 files changed, 21 insertions(+)
>=20
> diff --git a/Documentation/ABI/stable/sysfs-bus-vmbus
> b/Documentation/ABI/stable/sysfs-bus-vmbus
> index 8e8d167..a42225d 100644
> --- a/Documentation/ABI/stable/sysfs-bus-vmbus
> +++ b/Documentation/ABI/stable/sysfs-bus-vmbus
> @@ -49,6 +49,14 @@ Contact:	Stephen Hemminger <sthemmin@microsoft.com>
>  Description:	This NUMA node to which the VMBUS device is
>  		attached, or -1 if the node is unknown.
>=20
> +What:           /sys/bus/vmbus/devices/<UUID>/dev_num
> +Date:		Dec 2019
> +KernelVersion:	5.5
> +Contact:	Haiyang Zhang <haiyangz@microsoft.com>
> +Description:	A number based on the vmbus device offer sequence.

The capitalization of "VMBus" is already inconsistent in this file in that=
=20
we have "VMBus" and "VMBUS" in the text.  Let's not introduce another
capitalization -- use "VMBus".

> +		Useful for device naming when using Async probing.
> +Users:		Debugging tools and userspace drivers
> +
>  What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>
>  Date:		September. 2017
>  KernelVersion:	4.14
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4ef5a66..fe7aefa 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -214,6 +214,18 @@ static ssize_t numa_node_show(struct device *dev,
>  static DEVICE_ATTR_RO(numa_node);
>  #endif
>=20
> +static ssize_t dev_num_show(struct device *dev,
> +			      struct device_attribute *attr, char *buf)
> +{
> +	struct hv_device *hv_dev =3D device_to_hv_device(dev);
> +
> +	if (!hv_dev->channel)
> +		return -ENODEV;
> +
> +	return sprintf(buf, "%d\n", hv_dev->channel->dev_num);
> +}
> +static DEVICE_ATTR_RO(dev_num);
> +
>  static ssize_t server_monitor_pending_show(struct device *dev,
>  					   struct device_attribute *dev_attr,
>  					   char *buf)
> @@ -598,6 +610,7 @@ static ssize_t driver_override_show(struct device *de=
v,
>  #ifdef CONFIG_NUMA
>  	&dev_attr_numa_node.attr,
>  #endif
> +	&dev_attr_dev_num.attr,
>  	&dev_attr_server_monitor_pending.attr,
>  	&dev_attr_client_monitor_pending.attr,
>  	&dev_attr_server_monitor_latency.attr,
> --
> 1.8.3.1

