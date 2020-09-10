Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A5726441A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgIJKaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:30:25 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:48987
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbgIJKaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 06:30:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmlYQcSQKLs2GvQRdv7BIZJTOd2igWM+nqwQGzAYRzJFGZsEPx/DoP8hHWB9CbkCSKBoeQLahAQoYrP3eBEqw/qFSOjIoD6Ur7qb8M/kFNxIU8qPVxzhwExkC1RM25cs4hdRpL/53ZuZU+iRm86UXgxryqs8vuWbNyYECp6i7Inea790BKlr2H1JJKoy7Id8An9jlWMCUcQA0Hr84wS5RJeeDBTXYgG34uolLV3GLbwwAurWSxF9Xo5Lk5d0qQNOI1CNOTImDskOxrnU1GSEasH6MNuGT0U3bJZlvSWzar34ClMNfNmCfWDF1/ako/iHTiLU0TeYTzma7UZh+6lx4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iz53bndwD2MSqoZUlClEwzeX7pHxCn0toxqI/2ca2Cw=;
 b=iEHLZ24wylLDE86Ko2i6kp9R6iRbnTxZuoPJQsA0uFqID+K0YVUmwBFUWIiQZE2zMvqcjNQkk6qgtkrrH0opHgTfGW1p3VRaVoIMQfpZrOsM/B0dtDvsPVBFlImjwMxsQx10WLq7UlbMS/bkU9gH+caY0BprdcmwT4J0M3e/XQk48q+Qyw7bmfhKqzBMLKpeNmwfU5VYMy3H8wtwE4HemK/wwyUhFgYi50vnSVETw/xoVBBRJGvdk2Q3K3tHpxQDjOsta2oyaRWau/NhfFBU8mEoAZdGKVJRSLPaHFDPR2YkLuNDddszGUYlS/Guf0iCqi35+7Rxjdva5DPP1JlSBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iz53bndwD2MSqoZUlClEwzeX7pHxCn0toxqI/2ca2Cw=;
 b=ox7FBdkMihV8zTTj38Dr1TZKkwIM+fw0v3dvDSSR6lSSEThom+mIu4xLnrGsTnRLPJ/IfWf8aVrS6yos0nzVL07xW3qOZs3imjuEtDZ/CLxfJDhhdc7pPoxGXwrWS9bMHUmfgrZNeM6aAysUFWyHWq8ElvSUnS7QAa70ZDPvsw4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5725.eurprd04.prod.outlook.com
 (2603:10a6:803:e3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 10:30:10 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037%7]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 10:30:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Thread-Topic: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Thread-Index: AQHWh1ylnpQNwapFD0Wr6iBk8xWKqqlhq5cQ
Date:   Thu, 10 Sep 2020 10:30:10 +0000
Message-ID: <VI1PR0402MB387116B67615670D0181B1CFE0270@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200910101655.13904-1-yangbo.lu@nxp.com>
 <20200910101655.13904-6-yangbo.lu@nxp.com>
In-Reply-To: <20200910101655.13904-6-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f5e8104-01b8-41e0-c298-08d855747ef6
x-ms-traffictypediagnostic: VI1PR04MB5725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB57253BB5162F641E7C2CF0D1E0270@VI1PR04MB5725.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlqKxJkTNlYO2kaYg5wfZJGwVLbFH5zFFaYQHerModP+gAm6EL64L8KWtGsrEfuooMBXUqO93SltorfRpy3pFrm69CTHmGIgg+ZmQ6E/IrCnW3x8tapGNOsSPbu9m026/5zyReYwpXMWTjfMKYre5QWqZRxb4tXgC5yeIi+MvQyba4jQg7Qj9xmPAl/V3KM3FOcX0hSSynjVvsvaXvxJhwNtHt+EYZUKVj1Az/gIkgQjk2XZfW1cECQbQp0ecQSKPk2ccgqDvs9Dbx8wpf89XOD4+WQwfEgZBBf4zdXbsjTFIF4+zG61+JZ99DKyHZA5PxhWlL8VANHAQZOcPxEUOIdBTXRJdG1EKyhLFqKjHOL6uOEC/jXunJTxTYZk0YI0OZpNm13QUaOA/8x6TUDqUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(4326008)(64756008)(54906003)(66446008)(110136005)(6506007)(966005)(66476007)(30864003)(5660300002)(316002)(8936002)(76116006)(2906002)(26005)(71200400001)(33656002)(8676002)(186003)(44832011)(66556008)(66946007)(7696005)(86362001)(55016002)(52536014)(9686003)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RaYtUyZ/ye0qb5ld8hiEMoEZRCtcuy+2bR74duZr2rX1NQ7eUnx6GPX3MXs7yV7x1Hfice2qR4thUGs2OJtBg9cis2t5sioLhkOGp9H01JncOWFu64hvtAo0f3UrJm3BTouTPgXxqPKM3pK2Woucospc71GRmx063YZpAAK9yd9I6oS/+Rtbz1E685/fpxyXNVAbEkjDWVzxK2v6rpekPywc1x7jZBG8X0ltemG//RcI523PE1g3K2X7KZ5lRUT5mAR7rk92tH5xteS8R2hLIhM+3hbCTT40c1znQ40Ne6k6buW/hk7p179s2O5K2Oo8VEGLFcYPFBcTX7p6kj1JbQcm05KkP8ZOJz5YT+6es//SkERwcMIeVZZj2lbCZilD/VT5TMwrFw2EHBssB7aL/bjbHvpmOlOV/EQaMnzZb1XTAQFDKYmZiPqYb5KXr4BfOoTLa0aERv8l2R4DwW29BqyuC2Wrf9A4WEVMQVL03EqExIjvKs7r9QJEWCcTKaaTunOryV4afeX3yN/27OG/rFRUy7B7Mf4lGYjC+n37xEE8NyMCd+QnrBlhk0QKfX3HmN9bahI63Ns4fNkrNr5G9OFEVMiMHJAEOM090K8247aQJawkf/8Cq9bH0GElkB5D9TxF4cp1564wc2YtSy0MRg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f5e8104-01b8-41e0-c298-08d855747ef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 10:30:10.6064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 28XnwueqiTqWYGil3uTnH72tSXhTVY4a9hYOjEjShVnBHEM+pmCi5YMpXwuRn5YKm1/gt6tpAa06pnDWPgX2Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5725
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step timestampi=
ng
>=20
> This patch is to add PTP sync packet one-step timestamping support.
> Before egress, one-step timestamping enablement needs,
>=20
> - Enabling timestamp and FAS (Frame Annotation Status) in
>   dpni buffer layout.
>=20
> - Write timestamp to frame annotation and set PTP bit in
>   FAS to mark as one-step timestamping event.
>=20
> - Enabling one-step timestamping by dpni_set_single_step_cfg()
>   API, with offset provided to insert correction time on frame.
>   The offset must respect all MAC headers, VLAN tags and other
>   protocol headers accordingly. The correction field update can
>   consider delays up to one second. So PTP frame needs to be
>   filtered and parsed, and written timestamp into Sync frame
>   originTimestamp field.
>=20
> The operation of API dpni_set_single_step_cfg() has to be done when no on=
e-
> step timestamping frames are in flight. So we have to make sure the last =
one-
> step timestamping frame has already been transmitted on hardware before
> starting to send the current one. The resolution is,
>=20
> - Utilize skb->cb[0] to mark timestamping request per packet.
>   If it is one-step timestamping PTP sync packet, queue to skb queue.
>   If not, transmit immediately.
>=20
> - Schedule a work to transmit skbs in skb queue.
>=20
> - mutex lock is used to ensure the last one-step timestamping packet
>   has already been transmitted on hardware through TX confirmation queue
>   before transmitting current packet.
>=20
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- None.
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 206
> +++++++++++++++++++--
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  32 +++-
>  .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   4 +-
>  3 files changed, 226 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index eab9470..e54381c 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -15,6 +15,7 @@
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
>  #include <linux/fsl/ptp_qoriq.h>
> +#include <linux/ptp_classify.h>
>  #include <net/pkt_cls.h>
>  #include <net/sock.h>
>=20
> @@ -563,11 +564,72 @@ static int dpaa2_eth_consume_frames(struct
> dpaa2_eth_channel *ch,
>  	return cleaned;
>  }
>=20
> +static int dpaa2_eth_ptp_parse(struct sk_buff *skb, u8 *msg_type, u8
> *two_step,
> +			       u8 *udp, u16 *correction_offset,
> +			       u16 *origin_timestamp_offset) {
> +	unsigned int ptp_class;
> +	u16 offset =3D 0;
> +	u8 *data;
> +
> +	data =3D skb_mac_header(skb);
> +	ptp_class =3D ptp_classify_raw(skb);
> +
> +	switch (ptp_class & PTP_CLASS_VMASK) {
> +	case PTP_CLASS_V1:
> +	case PTP_CLASS_V2:
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	if (ptp_class & PTP_CLASS_VLAN)
> +		offset +=3D VLAN_HLEN;
> +
> +	switch (ptp_class & PTP_CLASS_PMASK) {
> +	case PTP_CLASS_IPV4:
> +		offset +=3D ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
> +		*udp =3D 1;
> +		break;
> +	case PTP_CLASS_IPV6:
> +		offset +=3D ETH_HLEN + IP6_HLEN + UDP_HLEN;
> +		*udp =3D 1;
> +		break;
> +	case PTP_CLASS_L2:
> +		offset +=3D ETH_HLEN;
> +		*udp =3D 0;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	/* PTP header is 34 bytes. */
> +	if (skb->len < offset + 34)
> +		return -EINVAL;
> +
> +	*msg_type =3D data[offset] & 0x0f;
> +	*two_step =3D data[offset + 6] & 0x2;
> +	*correction_offset =3D offset + 8;
> +	*origin_timestamp_offset =3D offset + 34;
> +	return 0;
> +}
> +

Hi Yangbo,

Kurt Kanzenbach just added a generic function, ptp_parse_header, that direc=
tly returns a struct ptp_header *.
https://patchwork.ozlabs.org/project/netdev/list/?series=3D196189&state=3D*

Maybe use this instead of open-coding it?

Thanks,
Ioana

>  /* Configure the egress frame annotation for timestamp update */ -static=
 void
> dpaa2_eth_enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
> +static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
> +				       struct dpaa2_fd *fd,
> +				       void *buf_start,
> +				       struct sk_buff *skb)
>  {
> +	struct ptp_tstamp origin_timestamp;
> +	struct dpni_single_step_cfg cfg;
> +	u8 msg_type, two_step, udp;
>  	struct dpaa2_faead *faead;
> +	struct dpaa2_fas *fas;
> +	struct timespec64 ts;
> +	u16 offset1, offset2;
>  	u32 ctrl, frc;
> +	__le64 *ns;
> +	u8 *data;
>=20
>  	/* Mark the egress frame annotation area as valid */
>  	frc =3D dpaa2_fd_get_frc(fd);
> @@ -583,6 +645,58 @@ static void dpaa2_eth_enable_tx_tstamp(struct
> dpaa2_fd *fd, void *buf_start)
>  	ctrl =3D DPAA2_FAEAD_A2V | DPAA2_FAEAD_UPDV | DPAA2_FAEAD_UPD;
>  	faead =3D dpaa2_get_faead(buf_start, true);
>  	faead->ctrl =3D cpu_to_le32(ctrl);
> +
> +	if (skb->cb[0] =3D=3D TX_TSTAMP_ONESTEP_SYNC) {
> +		if (dpaa2_eth_ptp_parse(skb, &msg_type, &two_step, &udp,
> +					&offset1, &offset2)) {
> +			netdev_err(priv->net_dev,
> +				   "bad packet for one-step timestamping\n");
> +			return;
> +		}
> +
> +		if (msg_type !=3D 0 || two_step) {
> +			netdev_err(priv->net_dev,
> +				   "bad packet for one-step timestamping\n");
> +			return;
> +		}
> +
> +		/* Mark the frame annotation status as valid */
> +		frc =3D dpaa2_fd_get_frc(fd);
> +		dpaa2_fd_set_frc(fd, frc | DPAA2_FD_FRC_FASV);
> +
> +		/* Mark the PTP flag for one step timestamping */
> +		fas =3D dpaa2_get_fas(buf_start, true);
> +		fas->status =3D cpu_to_le32(DPAA2_FAS_PTP);
> +
> +		/* Write current time to FA timestamp field */
> +		if (!dpaa2_ptp) {
> +			netdev_err(priv->net_dev,
> +				   "ptp driver may not loaded for one-step
> timestamping\n");
> +			return;
> +		}
> +		dpaa2_ptp->caps.gettime64(&dpaa2_ptp->caps, &ts);
> +		ns =3D dpaa2_get_ts(buf_start, true);
> +		*ns =3D cpu_to_le64(timespec64_to_ns(&ts) /
> +				  DPAA2_PTP_CLK_PERIOD_NS);
> +
> +		/* Update current time to PTP message originTimestamp field
> */
> +		ns_to_ptp_tstamp(&origin_timestamp, le64_to_cpup(ns));
> +		data =3D skb_mac_header(skb);
> +		*(__be16 *)(data + offset2) =3D
> htons(origin_timestamp.sec_msb);
> +		*(__be32 *)(data + offset2 + 2) =3D
> +			htonl(origin_timestamp.sec_lsb);
> +		*(__be32 *)(data + offset2 + 6) =3D htonl(origin_timestamp.nsec);
> +
> +		cfg.en =3D 1;
> +		cfg.ch_update =3D udp;
> +		cfg.offset =3D offset1;
> +		cfg.peer_delay =3D 0;
> +
> +		if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token,
> +					     &cfg))
> +			netdev_err(priv->net_dev,
> +				   "dpni_set_single_step_cfg failed\n");
> +	}
>  }
>=20
>  /* Create a frame descriptor based on a fragmented skb */ @@ -820,7 +934=
,7
> @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
>   * This can be called either from dpaa2_eth_tx_conf() or on the error pa=
th of
>   * dpaa2_eth_tx().
>   */
> -static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
> +static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
>  				 struct dpaa2_eth_fq *fq,
>  				 const struct dpaa2_fd *fd, bool in_napi)  { @@
> -903,6 +1017,8 @@ static void dpaa2_eth_free_tx_fd(const struct
> dpaa2_eth_priv *priv,
>  		ns =3D DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
>  		shhwtstamps.hwtstamp =3D ns_to_ktime(ns);
>  		skb_tstamp_tx(skb, &shhwtstamps);
> +	} else if (skb->cb[0] =3D=3D TX_TSTAMP_ONESTEP_SYNC) {
> +		mutex_unlock(&priv->onestep_tstamp_lock);
>  	}
>=20
>  	/* Free SGT buffer allocated on tx */
> @@ -922,7 +1038,8 @@ static void dpaa2_eth_free_tx_fd(const struct
> dpaa2_eth_priv *priv,
>  	napi_consume_skb(skb, in_napi);
>  }
>=20
> -static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device
> *net_dev)
> +static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
> +				  struct net_device *net_dev)
>  {
>  	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
>  	struct dpaa2_fd fd;
> @@ -937,13 +1054,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb=
,
> struct net_device *net_dev)
>  	int err, i;
>  	void *swa;
>=20
> -	/* Utilize skb->cb[0] for timestamping request per skb */
> -	skb->cb[0] =3D 0;
> -
> -	if (priv->tx_tstamp_type =3D=3D HWTSTAMP_TX_ON &&
> -	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
> -		skb->cb[0] =3D TX_TSTAMP;
> -
>  	percpu_stats =3D this_cpu_ptr(priv->percpu_stats);
>  	percpu_extras =3D this_cpu_ptr(priv->percpu_extras);
>=20
> @@ -981,8 +1091,8 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb,
> struct net_device *net_dev)
>  		goto err_build_fd;
>  	}
>=20
> -	if (skb->cb[0] =3D=3D TX_TSTAMP)
> -		dpaa2_eth_enable_tx_tstamp(&fd, swa);
> +	if (skb->cb[0])
> +		dpaa2_eth_enable_tx_tstamp(priv, &fd, swa, skb);
>=20
>  	/* Tracing point */
>  	trace_dpaa2_tx_fd(net_dev, &fd);
> @@ -1037,6 +1147,58 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *sk=
b,
> struct net_device *net_dev)
>  	return NETDEV_TX_OK;
>  }
>=20
> +static void dpaa2_eth_tx_onestep_tstamp(struct work_struct *work) {
> +	struct dpaa2_eth_priv *priv =3D container_of(work, struct dpaa2_eth_pri=
v,
> +						   tx_onestep_tstamp);
> +	struct sk_buff *skb;
> +
> +	while (true) {
> +		skb =3D skb_dequeue(&priv->tx_skbs);
> +		if (!skb)
> +			return;
> +
> +		mutex_lock(&priv->onestep_tstamp_lock);
> +		__dpaa2_eth_tx(skb, priv->net_dev);
> +	}
> +}
> +
> +static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device
> +*net_dev) {
> +	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> +	u8 msg_type, two_step, udp;
> +	u16 offset1, offset2;
> +
> +	/* Utilize skb->cb[0] for timestamping request per skb */
> +	skb->cb[0] =3D 0;
> +
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> +		if (priv->tx_tstamp_type =3D=3D HWTSTAMP_TX_ON)
> +			skb->cb[0] =3D TX_TSTAMP;
> +		else if (priv->tx_tstamp_type =3D=3D
> HWTSTAMP_TX_ONESTEP_SYNC)
> +			skb->cb[0] =3D TX_TSTAMP_ONESTEP_SYNC;
> +	}
> +
> +	/* TX for one-step timestamping PTP Sync packet */
> +	if (skb->cb[0] =3D=3D TX_TSTAMP_ONESTEP_SYNC) {
> +		if (!dpaa2_eth_ptp_parse(skb, &msg_type, &two_step, &udp,
> +					 &offset1, &offset2))
> +			if (msg_type =3D=3D 0 && two_step =3D=3D 0) {
> +				skb_queue_tail(&priv->tx_skbs, skb);
> +				queue_work(priv->dpaa2_ptp_wq,
> +					   &priv->tx_onestep_tstamp);
> +				return NETDEV_TX_OK;
> +			}
> +		/* Use two-step timestamping if not one-step timestamping
> +		 * PTP Sync packet
> +		 */
> +		skb->cb[0] =3D TX_TSTAMP;
> +	}
> +
> +	/* TX for other packets */
> +	return __dpaa2_eth_tx(skb, net_dev);
> +}
> +
>  /* Tx confirmation frame processing routine */  static void
> dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
>  			      struct dpaa2_eth_channel *ch __always_unused,
> @@ -1906,6 +2068,7 @@ static int dpaa2_eth_ts_ioctl(struct net_device *de=
v,
> struct ifreq *rq, int cmd)
>  	switch (config.tx_type) {
>  	case HWTSTAMP_TX_OFF:
>  	case HWTSTAMP_TX_ON:
> +	case HWTSTAMP_TX_ONESTEP_SYNC:
>  		priv->tx_tstamp_type =3D config.tx_type;
>  		break;
>  	default:
> @@ -2731,8 +2894,10 @@ static int dpaa2_eth_set_buffer_layout(struct
> dpaa2_eth_priv *priv)
>  	/* tx buffer */
>  	buf_layout.private_data_size =3D DPAA2_ETH_SWA_SIZE;
>  	buf_layout.pass_timestamp =3D true;
> +	buf_layout.pass_frame_status =3D true;
>  	buf_layout.options =3D DPNI_BUF_LAYOUT_OPT_PRIVATE_DATA_SIZE |
> -			     DPNI_BUF_LAYOUT_OPT_TIMESTAMP;
> +			     DPNI_BUF_LAYOUT_OPT_TIMESTAMP |
> +			     DPNI_BUF_LAYOUT_OPT_FRAME_STATUS;
>  	err =3D dpni_set_buffer_layout(priv->mc_io, 0, priv->mc_token,
>  				     DPNI_QUEUE_TX, &buf_layout);
>  	if (err) {
> @@ -2741,7 +2906,8 @@ static int dpaa2_eth_set_buffer_layout(struct
> dpaa2_eth_priv *priv)
>  	}
>=20
>  	/* tx-confirm buffer */
> -	buf_layout.options =3D DPNI_BUF_LAYOUT_OPT_TIMESTAMP;
> +	buf_layout.options =3D DPNI_BUF_LAYOUT_OPT_TIMESTAMP |
> +			     DPNI_BUF_LAYOUT_OPT_FRAME_STATUS;
>  	err =3D dpni_set_buffer_layout(priv->mc_io, 0, priv->mc_token,
>  				     DPNI_QUEUE_TX_CONFIRM, &buf_layout);
>  	if (err) {
> @@ -3969,6 +4135,16 @@ static int dpaa2_eth_probe(struct fsl_mc_device
> *dpni_dev)
>  	priv->tx_tstamp_type =3D HWTSTAMP_TX_OFF;
>  	priv->rx_tstamp =3D false;
>=20
> +	priv->dpaa2_ptp_wq =3D alloc_workqueue("dpaa2_ptp_wq", 0, 0);
> +	if (!priv->dpaa2_ptp_wq) {
> +		err =3D -ENOMEM;
> +		goto err_wq_alloc;
> +	}
> +
> +	INIT_WORK(&priv->tx_onestep_tstamp,
> dpaa2_eth_tx_onestep_tstamp);
> +
> +	skb_queue_head_init(&priv->tx_skbs);
> +
>  	/* Obtain a MC portal */
>  	err =3D fsl_mc_portal_allocate(dpni_dev,
> FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
>  				     &priv->mc_io);
> @@ -4107,6 +4283,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device
> *dpni_dev)
>  err_dpni_setup:
>  	fsl_mc_portal_free(priv->mc_io);
>  err_portal_alloc:
> +	destroy_workqueue(priv->dpaa2_ptp_wq);
> +err_wq_alloc:
>  	dev_set_drvdata(dev, NULL);
>  	free_netdev(net_dev);
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> index 57e6e6e..c5a8e38 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> @@ -195,6 +195,24 @@ struct dpaa2_faead {
>  #define DPAA2_FAEAD_EBDDV		0x00002000
>  #define DPAA2_FAEAD_UPD			0x00000010
>=20
> +struct ptp_tstamp {
> +	u16 sec_msb;
> +	u32 sec_lsb;
> +	u32 nsec;
> +};
> +
> +static inline void ns_to_ptp_tstamp(struct ptp_tstamp *tstamp, u64 ns)
> +{
> +	u64 sec, nsec;
> +
> +	sec =3D ns / 1000000000ULL;
> +	nsec =3D ns % 1000000000ULL;
> +
> +	tstamp->sec_lsb =3D sec & 0xFFFFFFFF;
> +	tstamp->sec_msb =3D (sec >> 32) & 0xFFFF;
> +	tstamp->nsec =3D nsec;
> +}
> +
>  /* Accessors for the hardware annotation fields that we use */  static i=
nline void
> *dpaa2_get_hwa(void *buf_addr, bool swa)  { @@ -474,9 +492,21 @@ struct
> dpaa2_eth_priv {  #endif
>=20
>  	struct dpaa2_mac *mac;
> +	struct workqueue_struct	*dpaa2_ptp_wq;
> +	struct work_struct	tx_onestep_tstamp;
> +	struct sk_buff_head	tx_skbs;
> +	/* The one-step timestamping configuration on hardware
> +	 * registers could only be done when no one-step
> +	 * timestamping frames are in flight. So we use a mutex
> +	 * lock here to make sure the lock is released by last
> +	 * one-step timestamping packet through TX confirmation
> +	 * queue before transmit current packet.
> +	 */
> +	struct mutex		onestep_tstamp_lock;
>  };
>=20
>  #define TX_TSTAMP		0x1
> +#define TX_TSTAMP_ONESTEP_SYNC	0x2
>=20
>  #define DPAA2_RXH_SUPPORTED	(RXH_L2DA | RXH_VLAN |
> RXH_L3_PROTO \
>  				| RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 \
> @@ -580,7 +610,7 @@ static inline unsigned int
> dpaa2_eth_needed_headroom(struct sk_buff *skb)
>  		return 0;
>=20
>  	/* If we have Tx timestamping, need 128B hardware annotation */
> -	if (skb->cb[0] =3D=3D TX_TSTAMP)
> +	if (skb->cb[0])
>  		headroom +=3D DPAA2_ETH_TX_HWA_SIZE;
>=20
>  	return headroom;
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> index 26bd99b..bf3baf6 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>  /* Copyright 2014-2016 Freescale Semiconductor Inc.
>   * Copyright 2016 NXP
> + * Copyright 2020 NXP
>   */
>=20
>  #include <linux/net_tstamp.h>
> @@ -770,7 +771,8 @@ static int dpaa2_eth_get_ts_info(struct net_device
> *dev,
>  	info->phc_index =3D dpaa2_phc_index;
>=20
>  	info->tx_types =3D (1 << HWTSTAMP_TX_OFF) |
> -			 (1 << HWTSTAMP_TX_ON);
> +			 (1 << HWTSTAMP_TX_ON) |
> +			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
>=20
>  	info->rx_filters =3D (1 << HWTSTAMP_FILTER_NONE) |
>  			   (1 << HWTSTAMP_FILTER_ALL);
> --
> 2.7.4

