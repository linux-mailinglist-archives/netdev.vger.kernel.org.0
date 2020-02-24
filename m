Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EBA16A0F9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBXJDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:03:37 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:13470 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXJDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 04:03:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582535016; x=1614071016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z4Mr/248p1hw1BvUjxn6zKfGNBtagnBghZHZx6e9Gck=;
  b=Zy5BmYuHm8X4w1s6GPjAcD8sq4XJSKAi176J8MazEEAYOVpB47X/22V3
   9F+BrtQsMo2mSR9NUn9RaSsMs+zENGgORH/FiZ5vTpxptuMg0PtunHybE
   Wl8K2gufGSFn531Kwp0LbZsxr3AE/HWE15aohTppin5YOD2omJyiyq9zK
   M=;
IronPort-SDR: XHB4nR3i9Q1mSyYVdNqR60HqbElrSc6VYayvZ+Iv1lTrU9pd84N7NPRE4xruK925VVclquLG+Y
 kAxpKnAQ8KjQ==
X-IronPort-AV: E=Sophos;i="5.70,479,1574121600"; 
   d="scan'208";a="18650010"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 24 Feb 2020 09:03:34 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 62099A1DF7;
        Mon, 24 Feb 2020 09:03:32 +0000 (UTC)
Received: from EX13D06EUA001.ant.amazon.com (10.43.165.229) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 24 Feb 2020 09:03:31 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D06EUA001.ant.amazon.com (10.43.165.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Feb 2020 09:03:30 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Mon, 24 Feb 2020 09:03:30 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        "Don Fry" <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        "Jay Vosburgh" <j.vosburgh@gmail.com>,
        "linux-acenic@sunsite.dk" <linux-acenic@sunsite.dk>,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ion Badulescu <ionut@badula.org>,
        "Jes Sorensen" <jes@trained-monkey.org>,
        "nios2-dev@lists.rocketboards.org" <nios2-dev@lists.rocketboards.org>,
        Chen-Yu Tsai <wens@csie.org>
Subject: RE: [PATCH net-next v1 12/18] net/amazon: Ensure that driver version
 is aligned to the linux kernel
Thread-Topic: [PATCH net-next v1 12/18] net/amazon: Ensure that driver version
 is aligned to the linux kernel
Thread-Index: AQHV6vAVx5/0sGcsSkmtGfOI/rIICKgqC69w
Date:   Mon, 24 Feb 2020 09:03:14 +0000
Deferred-Delivery: Mon, 24 Feb 2020 09:03:11 +0000
Message-ID: <79ed2b392b4e413faef03f4bb2f8d562@EX13D22EUA004.ant.amazon.com>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-13-leon@kernel.org>
In-Reply-To: <20200224085311.460338-13-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, February 24, 2020 10:53 AM
> To: David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.or=
g>
> Cc: Leon Romanovsky <leonro@mellanox.com>; Tom Lendacky
> <thomas.lendacky@amd.com>; Keyur Chudgar
> <keyur@os.amperecomputing.com>; Don Fry <pcnet32@frontier.com>;
> Veaceslav Falico <vfalico@gmail.com>; Jay Vosburgh <j.vosburgh@gmail.com>=
;
> linux-acenic@sunsite.dk; Maxime Ripard <mripard@kernel.org>; Heiko Stuebn=
er
> <heiko@sntech.de>; Mark Einon <mark.einon@gmail.com>; Chris Snook
> <chris.snook@gmail.com>; linux-rockchip@lists.infradead.org; Iyappan
> Subramanian <iyappan@os.amperecomputing.com>; Igor Russkikh
> <irusskikh@marvell.com>; David Dillow <dave@thedillows.org>; Belgazal,
> Netanel <netanel@amazon.com>; Quan Nguyen
> <quan@os.amperecomputing.com>; Jay Cliburn <jcliburn@gmail.com>; Lino
> Sanfilippo <LinoSanfilippo@gmx.de>; linux-arm-kernel@lists.infradead.org;
> Andreas Larsson <andreas@gaisler.com>; Andy Gospodarek
> <andy@greyhouse.net>; netdev@vger.kernel.org; Thor Thayer
> <thor.thayer@linux.intel.com>; linux-kernel@vger.kernel.org; Ion Badulesc=
u
> <ionut@badula.org>; Kiyanovski, Arthur <akiyano@amazon.com>; Jes Sorensen
> <jes@trained-monkey.org>; nios2-dev@lists.rocketboards.org; Chen-Yu Tsai
> <wens@csie.org>
> Subject: [PATCH net-next v1 12/18] net/amazon: Ensure that driver version=
 is
> aligned to the linux kernel
>=20
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Upstream drivers are managed inside global repository and released all
> together, this ensure that driver version is the same as linux kernel, so=
 update
> amazon drivers to properly reflect it.
>=20
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 -
> drivers/net/ethernet/amazon/ena/ena_netdev.c  | 17 ++---------------
> drivers/net/ethernet/amazon/ena/ena_netdev.h  | 11 -----------
>  3 files changed, 2 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index ced1d577b62a..19262f37db84 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -404,7 +404,6 @@ static void ena_get_drvinfo(struct net_device *dev,
>  	struct ena_adapter *adapter =3D netdev_priv(dev);
>=20
>  	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
> -	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
>  	strlcpy(info->bus_info, pci_name(adapter->pdev),
>  		sizeof(info->bus_info));
>  }
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 0b2fd96b93d7..4faf81c456d8 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -49,12 +49,9 @@
>  #include <linux/bpf_trace.h>
>  #include "ena_pci_id_tbl.h"
>=20
> -static char version[] =3D DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
> -
>  MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
> MODULE_DESCRIPTION(DEVICE_NAME);  MODULE_LICENSE("GPL"); -
> MODULE_VERSION(DRV_MODULE_VERSION);
>=20
>  /* Time in jiffies before concluding the transmitter is hung. */  #defin=
e
> TX_TIMEOUT  (5 * HZ) @@ -3093,11 +3090,7 @@ static void
> ena_config_host_info(struct ena_com_dev *ena_dev,
>  	host_info->os_dist =3D 0;
>  	strncpy(host_info->os_dist_str, utsname()->release,
>  		sizeof(host_info->os_dist_str) - 1);
> -	host_info->driver_version =3D
> -		(DRV_MODULE_VER_MAJOR) |
> -		(DRV_MODULE_VER_MINOR <<
> ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
> -		(DRV_MODULE_VER_SUBMINOR <<
> ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
> -		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
> +	host_info->driver_version =3D LINUX_VERSION_CODE;
>  	host_info->num_cpus =3D num_online_cpus();
>=20
>  	host_info->driver_supported_features =3D @@ -3476,9 +3469,7 @@
> static int ena_restore_device(struct ena_adapter *adapter)
>  		netif_carrier_on(adapter->netdev);
>=20
>  	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
> -	dev_err(&pdev->dev,
> -		"Device reset completed successfully, Driver info: %s\n",
> -		version);
> +	dev_err(&pdev->dev, "Device reset completed successfully\n");
>=20
>  	return rc;
>  err_disable_msix:
> @@ -4116,8 +4107,6 @@ static int ena_probe(struct pci_dev *pdev, const
> struct pci_device_id *ent)
>=20
>  	dev_dbg(&pdev->dev, "%s\n", __func__);
>=20
> -	dev_info_once(&pdev->dev, "%s", version);
> -
>  	rc =3D pci_enable_device_mem(pdev);
>  	if (rc) {
>  		dev_err(&pdev->dev, "pci_enable_device_mem() failed!\n");
> @@ -4429,8 +4418,6 @@ static struct pci_driver ena_pci_driver =3D {
>=20
>  static int __init ena_init(void)
>  {
> -	pr_info("%s", version);
> -
>  	ena_wq =3D create_singlethread_workqueue(DRV_MODULE_NAME);
>  	if (!ena_wq) {
>  		pr_err("Failed to create workqueue\n"); diff --git
> a/drivers/net/ethernet/amazon/ena/ena_netdev.h
> b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> index 8795e0b1dc3c..74c7f10b60dd 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> @@ -45,18 +45,7 @@
>  #include "ena_com.h"
>  #include "ena_eth_com.h"
>=20
> -#define DRV_MODULE_VER_MAJOR	2
> -#define DRV_MODULE_VER_MINOR	1
> -#define DRV_MODULE_VER_SUBMINOR 0
> -
>  #define DRV_MODULE_NAME		"ena"
> -#ifndef DRV_MODULE_VERSION
> -#define DRV_MODULE_VERSION \
> -	__stringify(DRV_MODULE_VER_MAJOR) "."	\
> -	__stringify(DRV_MODULE_VER_MINOR) "."	\
> -	__stringify(DRV_MODULE_VER_SUBMINOR) "K"
> -#endif
> -
>  #define DEVICE_NAME	"Elastic Network Adapter (ENA)"
>=20
>  /* 1 for AENQ + ADMIN */
> --
> 2.24.1

Hi Leon, David,

This patch is not good for the ENA driver as it breaks the interface with t=
he FW of the ENA device in ena_config_host_info(), host_info is later repor=
ted to the FW.
Please do not merge it yet.
We are now working on altering your patch so that it won't break this inter=
face and will send it to you in the next few hours.

Thanks,
Arthur

