Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796293896D1
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhESTgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:36:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232140AbhESTgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:36:02 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JJX3FG020623;
        Wed, 19 May 2021 15:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=ACdWt4YZaARejSQByHKUGm529KID3v94go7oxf/kCQg=;
 b=kHNs2bh637ZZ4TMJx4tfS7e2Isa1jLNozWk/X2JMjlatgsmVK18JHRhwogqFcn8FMaTk
 TxjDRt4FMLWcjxDMe3CieSXURl19Mmz9g9hzmb2MZqbl5mf5gbPhGMQfWe8jT+F+0dcQ
 6qXH+wa2sW3H++jGP6c9GIkiW5QktB343b/j2R78HVULydgxUjOIYVWSGTmUqo37B8F7
 T7PLUbOe6o6YmYrjhCHJ5p20FXjkedbYNVldUWh70Bs6FLQq1wikNWH95WHv1MGs14fB
 lAOxCwruaIkmeX+iJ+mZewQG8sRxQSNenZJw40/cD3bp0QLf70d0mJvUf5VGKLLa9fAd hA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n60rwm0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 15:34:36 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JJWM77028465;
        Wed, 19 May 2021 19:34:36 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 38j5x99n7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 19:34:36 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JJYZSt29688082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 19:34:35 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D56CDB2067;
        Wed, 19 May 2021 19:34:35 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62102B2065;
        Wed, 19 May 2021 19:34:35 +0000 (GMT)
Received: from [9.65.82.165] (unknown [9.65.82.165])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 19 May 2021 19:34:35 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net-next] mlx5: count all link events
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20210519171825.600110-1-kuba@kernel.org>
Date:   Wed, 19 May 2021 14:34:34 -0500
Cc:     saeedm@nvidia.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
References: <20210519171825.600110-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wUquj68ifUbHKz2VrB88TknZMWLAdtSD
X-Proofpoint-ORIG-GUID: wUquj68ifUbHKz2VrB88TknZMWLAdtSD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_09:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105190117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 12:18 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> mlx5 devices were observed generating MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
> events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
> breaks link flap detection based on Linux carrier state transition
> count as netif_carrier_on() does nothing if carrier is already on.
> Make sure we count such events.
>=20
> netif_carrier_event() increments the counters and fires the linkwatch
> events. The latter is not necessary for the use case but seems like
> the right thing to do.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> .../net/ethernet/mellanox/mlx5/core/en_main.c  |  6 +++++-
> include/linux/netdevice.h                      |  2 +-
> net/sched/sch_generic.c                        | 18 ++++++++++++++++++
> 3 files changed, 24 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c =
b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index bca832cdc4cb..5a67ebc0c96c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -91,12 +91,16 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
> {
> 	struct mlx5_core_dev *mdev =3D priv->mdev;
> 	u8 port_state;
> +	bool up;
>=20
> 	port_state =3D mlx5_query_vport_state(mdev,
> 					    =
MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT,
> 					    0);
>=20
> -	if (port_state =3D=3D VPORT_STATE_UP) {
> +	up =3D port_state =3D=3D VPORT_STATE_UP;
> +	if (up =3D=3D netif_carrier_ok(priv->netdev))
> +		netif_carrier_event(priv->netdev);
> +	if (up) {
> 		netdev_info(priv->netdev, "Link up\n");
> 		netif_carrier_on(priv->netdev);
> 	} else {
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5cbc950b34df..be1dcceda5e4 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4187,8 +4187,8 @@ unsigned long dev_trans_start(struct net_device =
*dev);
> void __netdev_watchdog_up(struct net_device *dev);
>=20
> void netif_carrier_on(struct net_device *dev);
> -
> void netif_carrier_off(struct net_device *dev);
> +void netif_carrier_event(struct net_device *dev);
>=20
> /**
>  *	netif_dormant_on - mark device as dormant.
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 44991ea726fc..3090ae32307b 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -515,6 +515,24 @@ void netif_carrier_off(struct net_device *dev)
> }
> EXPORT_SYMBOL(netif_carrier_off);
>=20
> +/**
> + *	netif_carrier_event - report carrier state event
> + *	@dev: network device
> + *
> + * Device has detected a carrier event but the carrier state wasn't =
changed.
> + * Use in drivers when querying carrier state asynchronously, to =
avoid missing
> + * events (link flaps) if link recovers before it's queried.
> + */
> +void netif_carrier_event(struct net_device *dev)
> +{
> +	if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
> +		return;
> +	atomic_inc(&dev->carrier_up_count);
> +	atomic_inc(&dev->carrier_down_count);
> +	linkwatch_fire_event(dev);
> +}
> +EXPORT_SYMBOL_GPL(netif_carrier_event);

Is it possible to integrate netif_carrier_event into netif_carrier_on? =
like,


void netif_carrier_on(struct net_device *dev)
{
	if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
		if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
			return;
		atomic_inc(&dev->carrier_up_count);
		linkwatch_fire_event(dev);
		if (netif_running(dev))
			__netdev_watchdog_up(dev);
	} else {
		if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
			return;
		atomic_inc(&dev->carrier_down_count);
		atomic_inc(&dev->carrier_up_count);
	}
}
EXPORT_SYMBOL(netif_carrier_on);


