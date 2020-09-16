Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FFE26C186
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 12:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIPKMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 06:12:39 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:52795
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbgIPKM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 06:12:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBhhEjit8xODaQZv1dY4Bk7IFphpMaJiYB9f4tlM5Ug7JiuSdumItHp8KFXJQn/TJ8+aTYX6+91+ThyXMHLNqsbBfQHC1e3hnGehARBjf3MdZuWcSAtgAVaOhKNRZLzNOtoEkULdIoFRnrsTivnKvIxf5uEr1ADqoeFqkYNYx6Kxr4kmHkZDt7w/vTAfSqX3m48zmLqfytQ2gjoASFk491S19kbtBrcDIBlMg7uukieEGD7FoqUM3R9D1mTw5ZMbE2FwHRQi6Y1mEncZlM3YeI6HXswTM4GAKVOFgk0X5XAccomYw7gSDx/JAPv8HjYSIDH9uDpZ2Iv2QlAFKcGdZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbFDo8f1PYtw5f6uRsaJdWSPok0n/6yFTlzVO1ysFOQ=;
 b=nVDQ+OxvCornnUx7hrG6yLiSfrky8qXqaI96JUXSZ8VIKjyvoYlMWAMAhMGsVxmcQZULiJobEXZdaJ1Kp6c891liPS8IXbs4QjUnuvvzrEb8q8Zhep1vgca6OkEZM4cmDKUiepOmXDRR2wJDUAnepJKbjPTvqosqLL5BG/EPCukNt5UhP42ShB0Ka8Sa6z8inYcwAx2fWFGm2eieO6IzWnu/JI28ph/OH2NPjqhYKpe+kaUWTemNb7EMUt6/drspvjdONm8ouO6I5Dm33t52yi4pj8n6MWeMXjF+Pb3fdgePDbzc8rGGV4tXRphdLOpE01cFTTItlTZuoR3NSPcQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbFDo8f1PYtw5f6uRsaJdWSPok0n/6yFTlzVO1ysFOQ=;
 b=l6W7uL2x7IzXz37c2Ui0EZan/MDTYODl39Dx5Jl6ipToGvqzQzlTHalK6AOrkj32x4DqMbCN3rLihthxF2aIHuroiRHWeEdSGSHTv4AMp3sfou7a/bhLtjxMX0FFOS1X2pSevhUUts533PtesBaa7HdQcsjndpvu8lmFGvf1JoY=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB4182.eurprd04.prod.outlook.com (2603:10a6:209:44::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 10:12:17 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%7]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 10:12:17 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Thread-Topic: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Thread-Index: AQHWh1ylAaLKGGNBTEK9Ss9ECdkVQqlhq/4AgAlo1IA=
Date:   Wed, 16 Sep 2020 10:12:17 +0000
Message-ID: <AM7PR04MB6885D2A6E1D9666EC11F8AE9F8210@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200910101655.13904-1-yangbo.lu@nxp.com>
 <20200910101655.13904-6-yangbo.lu@nxp.com>
 <VI1PR0402MB387116B67615670D0181B1CFE0270@VI1PR0402MB3871.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB387116B67615670D0181B1CFE0270@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40bc56f6-b8f5-4a5f-e17a-08d85a28fd94
x-ms-traffictypediagnostic: AM6PR04MB4182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB418217F6FA3AAD1E3BEA89A7F8210@AM6PR04MB4182.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1o80XPvxEUC5eL5V1dIpcl9tsDxCVAjWbVTrLF99aBw1qHCE/GmxdOI/Msu47wM1gIehThS1XpjcuZt2wACcE9I3aoXO4WSDLENxtOPgTwtbuG3xCdGu58wZr4+1dioIK5TPqhwGhvbFE45YkE3wKH0hcl6qBB3mh5HMH3IoQu9iqnJTOKp6PW5e+oGw2+qD4wTPQr+6QCjXVGh2QapjUOH9t9COeKIm7p5qVvaPxYx7FC8Nr9kRUVFwEo4N5oSCPs3VnMFv7JzNhtyOJQwwFfeZ/W9J9oxf4kjN9OEfdKDNuets/t9nol4P59z349/t9z1YwLqznLBC3Q0yrr6SrbyKqiPQR4ujCTFaa01RVhz96uNSGJ53v87hebL4SDeOKY4yRcXrefifG94vXzOhcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39850400004)(376002)(55016002)(186003)(4326008)(478600001)(9686003)(52536014)(7696005)(5660300002)(316002)(33656002)(86362001)(76116006)(66446008)(66946007)(64756008)(71200400001)(110136005)(66476007)(66556008)(966005)(54906003)(6506007)(2906002)(8936002)(26005)(83380400001)(30864003)(53546011)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vxZdVJ7LBnVs7Phlt0AAnpnC13+s8vY3UY4tX1kZBo0/3BSpFALkn94+u90Tt4YEnv03Tn7TXz8EaQAEr2IoSGVHJ+WKc7ck0+OzWpoQ+ZvLs9uT1znHBz2pHMT4y/OctoPd8huz59mpPVVhceI6R3vJRleA7xlrf6GrQhj6lpMaJjtz8TCEG5n0V74GJ+J4BI4W1PW/Kim8MXg+hHRWscygx9H4Q9kwhTQWJQMxCQBS7JzV5b/inYIRf0eCKs+PKSVUSWGSN1uX6KdxKsaWo50Y3jba7zCHmauZi9xu3DdFTO4MM9LgITHTaAXVdmxoa9cqKSbUqVvlrIpuxiYZrsT2FlWQQbnvDwSbOIiFegmgoNPmJc1FvxVMuf0UNDEDRuk2Nj67GCOyxPtG/BjT33xJ0Jzfyw6iUdEuvtYpYueVWgmI5YBqYja4DUzv6VAPiwnPmjvRAIgOfLfPnRjKQzDEn1VewgLEwbOuhmfYkUd6VGiZLNgiyZoGPKfML6ix6/LYEkqtyDIiIkUHDB2kFk6ls7JYGdgfGzuRUPS17R9pwDrKAs2qkeQKAZTqAPQ6F9Cr/qvDiFFiZks6kwOJdS7LTBB9gpjMnkTt3S3IaotrK7YNSBj/FHVUX/UCYdoLrlPUK108H0DE3OGR+AK9IA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bc56f6-b8f5-4a5f-e17a-08d85a28fd94
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 10:12:17.1464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UfE6S3+63mRP8bftDVnqEMpbC4zBQYOF09APGpL26TpgE7+0tBkYkcFFm0Ol0n4D35yNiYatTlE01oWV/9Xk9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Thursday, September 10, 2020 6:30 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>; netdev@vger.kernel.org
> Cc: Y.b. Lu <yangbo.lu@nxp.com>; David S . Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: RE: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step
> timestamping
>=20
> > Subject: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step
> timestamping
> >
> > This patch is to add PTP sync packet one-step timestamping support.
> > Before egress, one-step timestamping enablement needs,
> >
> > - Enabling timestamp and FAS (Frame Annotation Status) in
> >   dpni buffer layout.
> >
> > - Write timestamp to frame annotation and set PTP bit in
> >   FAS to mark as one-step timestamping event.
> >
> > - Enabling one-step timestamping by dpni_set_single_step_cfg()
> >   API, with offset provided to insert correction time on frame.
> >   The offset must respect all MAC headers, VLAN tags and other
> >   protocol headers accordingly. The correction field update can
> >   consider delays up to one second. So PTP frame needs to be
> >   filtered and parsed, and written timestamp into Sync frame
> >   originTimestamp field.
> >
> > The operation of API dpni_set_single_step_cfg() has to be done when no =
one-
> > step timestamping frames are in flight. So we have to make sure the las=
t one-
> > step timestamping frame has already been transmitted on hardware before
> > starting to send the current one. The resolution is,
> >
> > - Utilize skb->cb[0] to mark timestamping request per packet.
> >   If it is one-step timestamping PTP sync packet, queue to skb queue.
> >   If not, transmit immediately.
> >
> > - Schedule a work to transmit skbs in skb queue.
> >
> > - mutex lock is used to ensure the last one-step timestamping packet
> >   has already been transmitted on hardware through TX confirmation
> queue
> >   before transmitting current packet.
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> > Changes for v2:
> > 	- None.
> > ---
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 206
> > +++++++++++++++++++--
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  32 +++-
> >  .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   4 +-
> >  3 files changed, 226 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index eab9470..e54381c 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/bpf.h>
> >  #include <linux/bpf_trace.h>
> >  #include <linux/fsl/ptp_qoriq.h>
> > +#include <linux/ptp_classify.h>
> >  #include <net/pkt_cls.h>
> >  #include <net/sock.h>
> >
> > @@ -563,11 +564,72 @@ static int dpaa2_eth_consume_frames(struct
> > dpaa2_eth_channel *ch,
> >  	return cleaned;
> >  }
> >
> > +static int dpaa2_eth_ptp_parse(struct sk_buff *skb, u8 *msg_type, u8
> > *two_step,
> > +			       u8 *udp, u16 *correction_offset,
> > +			       u16 *origin_timestamp_offset) {
> > +	unsigned int ptp_class;
> > +	u16 offset =3D 0;
> > +	u8 *data;
> > +
> > +	data =3D skb_mac_header(skb);
> > +	ptp_class =3D ptp_classify_raw(skb);
> > +
> > +	switch (ptp_class & PTP_CLASS_VMASK) {
> > +	case PTP_CLASS_V1:
> > +	case PTP_CLASS_V2:
> > +		break;
> > +	default:
> > +		return -ERANGE;
> > +	}
> > +
> > +	if (ptp_class & PTP_CLASS_VLAN)
> > +		offset +=3D VLAN_HLEN;
> > +
> > +	switch (ptp_class & PTP_CLASS_PMASK) {
> > +	case PTP_CLASS_IPV4:
> > +		offset +=3D ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
> > +		*udp =3D 1;
> > +		break;
> > +	case PTP_CLASS_IPV6:
> > +		offset +=3D ETH_HLEN + IP6_HLEN + UDP_HLEN;
> > +		*udp =3D 1;
> > +		break;
> > +	case PTP_CLASS_L2:
> > +		offset +=3D ETH_HLEN;
> > +		*udp =3D 0;
> > +		break;
> > +	default:
> > +		return -ERANGE;
> > +	}
> > +
> > +	/* PTP header is 34 bytes. */
> > +	if (skb->len < offset + 34)
> > +		return -EINVAL;
> > +
> > +	*msg_type =3D data[offset] & 0x0f;
> > +	*two_step =3D data[offset + 6] & 0x2;
> > +	*correction_offset =3D offset + 8;
> > +	*origin_timestamp_offset =3D offset + 34;
> > +	return 0;
> > +}
> > +
>=20
> Hi Yangbo,
>=20
> Kurt Kanzenbach just added a generic function, ptp_parse_header, that dir=
ectly
> returns a struct ptp_header *.
> https://patchwork.ozlabs.org/project/netdev/list/?series=3D196189&state=
=3D*
>=20
> Maybe use this instead of open-coding it?

Thanks for suggestion. I will use it in next version.

>=20
> Thanks,
> Ioana
>=20
> >  /* Configure the egress frame annotation for timestamp update */ -stat=
ic
> void
> > dpaa2_eth_enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
> > +static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
> > +				       struct dpaa2_fd *fd,
> > +				       void *buf_start,
> > +				       struct sk_buff *skb)
> >  {
> > +	struct ptp_tstamp origin_timestamp;
> > +	struct dpni_single_step_cfg cfg;
> > +	u8 msg_type, two_step, udp;
> >  	struct dpaa2_faead *faead;
> > +	struct dpaa2_fas *fas;
> > +	struct timespec64 ts;
> > +	u16 offset1, offset2;
> >  	u32 ctrl, frc;
> > +	__le64 *ns;
> > +	u8 *data;
> >
> >  	/* Mark the egress frame annotation area as valid */
> >  	frc =3D dpaa2_fd_get_frc(fd);
> > @@ -583,6 +645,58 @@ static void dpaa2_eth_enable_tx_tstamp(struct
> > dpaa2_fd *fd, void *buf_start)
> >  	ctrl =3D DPAA2_FAEAD_A2V | DPAA2_FAEAD_UPDV | DPAA2_FAEAD_UPD;
> >  	faead =3D dpaa2_get_faead(buf_start, true);
> >  	faead->ctrl =3D cpu_to_le32(ctrl);
> > +
> > +	if (skb->cb[0] =3D=3D TX_TSTAMP_ONESTEP_SYNC) {
> > +		if (dpaa2_eth_ptp_parse(skb, &msg_type, &two_step, &udp,
> > +					&offset1, &offset2)) {
> > +			netdev_err(priv->net_dev,
> > +				   "bad packet for one-step timestamping\n");
> > +			return;
> > +		}
> > +
> > +		if (msg_type !=3D 0 || two_step) {
> > +			netdev_err(priv->net_dev,
> > +				   "bad packet for one-step timestamping\n");
> > +			return;
> > +		}
> > +
> > +		/* Mark the frame annotation status as valid */
> > +		frc =3D dpaa2_fd_get_frc(fd);
> > +		dpaa2_fd_set_frc(fd, frc | DPAA2_FD_FRC_FASV);
> > +
> > +		/* Mark the PTP flag for one step timestamping */
> > +		fas =3D dpaa2_get_fas(buf_start, true);
> > +		fas->status =3D cpu_to_le32(DPAA2_FAS_PTP);
> > +
> > +		/* Write current time to FA timestamp field */
> > +		if (!dpaa2_ptp) {
> > +			netdev_err(priv->net_dev,
> > +				   "ptp driver may not loaded for one-step
> > timestamping\n");
> > +			return;
> > +		}
> > +		dpaa2_ptp->caps.gettime64(&dpaa2_ptp->caps, &ts);
> > +		ns =3D dpaa2_get_ts(buf_start, true);
> > +		*ns =3D cpu_to_le64(timespec64_to_ns(&ts) /
> > +				  DPAA2_PTP_CLK_PERIOD_NS);
> > +
> > +		/* Update current time to PTP message originTimestamp field
> > */
> > +		ns_to_ptp_tstamp(&origin_timestamp, le64_to_cpup(ns));
> > +		data =3D skb_mac_header(skb);
> > +		*(__be16 *)(data + offset2) =3D
> > htons(origin_timestamp.sec_msb);
> > +		*(__be32 *)(data + offset2 + 2) =3D
> > +			htonl(origin_timestamp.sec_lsb);
> > +		*(__be32 *)(data + offset2 + 6) =3D htonl(origin_timestamp.nsec);
> > +
> > +		cfg.en =3D 1;
> > +		cfg.ch_update =3D udp;
> > +		cfg.offset =3D offset1;
> > +		cfg.peer_delay =3D 0;
> > +
> > +		if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token,
> > +					     &cfg))
> > +			netdev_err(priv->net_dev,
> > +				   "dpni_set_single_step_cfg failed\n");
> > +	}
> >  }
> >
> >  /* Create a frame descriptor based on a fragmented skb */ @@ -820,7
> +934,7
> > @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
> >   * This can be called either from dpaa2_eth_tx_conf() or on the error =
path
> of
> >   * dpaa2_eth_tx().
> >   */
> > -static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
> > +static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
> >  				 struct dpaa2_eth_fq *fq,
> >  				 const struct dpaa2_fd *fd, bool in_napi)  { @@
> > -903,6 +1017,8 @@ static void dpaa2_eth_free_tx_fd(const struct
> > dpaa2_eth_priv *priv,
> >  		ns =3D DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
> >  		shhwtstamps.hwtstamp =3D ns_to_ktime(ns);
> >  		skb_tstamp_tx(skb, &shhwtstamps);
> > +	} else if (skb->cb[0] =3D=3D TX_TSTAMP_ONESTEP_SYNC) {
> > +		mutex_unlock(&priv->onestep_tstamp_lock);
> >  	}
> >
> >  	/* Free SGT buffer allocated on tx */
> > @@ -922,7 +1038,8 @@ static void dpaa2_eth_free_tx_fd(const struct
> > dpaa2_eth_priv *priv,
> >  	napi_consume_skb(skb, in_napi);
> >  }
> >
> > -static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device
> > *net_dev)
> > +static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
> > +				  struct net_device *net_dev)
> >  {
> >  	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> >  	struct dpaa2_fd fd;
> > @@ -937,13 +1054,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff
> *skb,
> > struct net_device *net_dev)
> >  	int err, i;
> >  	void *swa;
> >
> > -	/* Utilize skb->cb[0] for timestamping request per skb */
> > -	skb->cb[0] =3D 0;
> > -
> > -	if (priv->tx_tstamp_type =3D=3D HWTSTAMP_TX_ON &&
> > -	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
> > -		skb->cb[0] =3D TX_TSTAMP;
> > -
> >  	percpu_stats =3D this_cpu_ptr(priv->percpu_stats);
> >  	percpu_extras =3D this_cpu_ptr(priv->percpu_extras);
> >
> > @@ -981,8 +1091,8 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff
> *skb,
> > struct net_device *net_dev)
> >  		goto err_build_fd;
> >  	}
> >
> > -	if (skb->cb[0] =3D=3D TX_TSTAMP)
> > -		dpaa2_eth_enable_tx_tstamp(&fd, swa);
> > +	if (skb->cb[0])
> > +		dpaa2_eth_enable_tx_tstamp(priv, &fd, swa, skb);
> >
> >  	/* Tracing point */
> >  	trace_dpaa2_tx_fd(net_dev, &fd);
> > @@ -1037,6 +1147,58 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff
> *skb,
> > struct net_device *net_dev)
> >  	return NETDEV_TX_OK;
> >  }
> >
> > +static void dpaa2_eth_tx_onestep_tstamp(struct work_struct *work) {
> > +	struct dpaa2_eth_priv *priv =3D container_of(work, struct dpaa2_eth_p=
riv,
> > +						   tx_onestep_tstamp);
> > +	struct sk_buff *skb;
> > +
> > +	while (true) {
> > +		skb =3D skb_dequeue(&priv->tx_skbs);
> > +		if (!skb)
> > +			return;
> > +
> > +		mutex_lock(&priv->onestep_tstamp_lock);
> > +		__dpaa2_eth_tx(skb, priv->net_dev);
> > +	}
> > +}
> > +
> > +static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device
> > +*net_dev) {
> > +	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> > +	u8 msg_type, two_step, udp;
> > +	u16 offset1, offset2;
> > +
> > +	/* Utilize skb->cb[0] for timestamping request per skb */
> > +	skb->cb[0] =3D 0;
> > +
> > +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > +		if (priv->tx_tstamp_type =3D=3D HWTSTAMP_TX_ON)
> > +			skb->cb[0] =3D TX_TSTAMP;
> > +		else if (priv->tx_tstamp_type =3D=3D
> > HWTSTAMP_TX_ONESTEP_SYNC)
> > +			skb->cb[0] =3D TX_TSTAMP_ONESTEP_SYNC;
> > +	}
> > +
> > +	/* TX for one-step timestamping PTP Sync packet */
> > +	if (skb->cb[0] =3D=3D TX_TSTAMP_ONESTEP_SYNC) {
> > +		if (!dpaa2_eth_ptp_parse(skb, &msg_type, &two_step, &udp,
> > +					 &offset1, &offset2))
> > +			if (msg_type =3D=3D 0 && two_step =3D=3D 0) {
> > +				skb_queue_tail(&priv->tx_skbs, skb);
> > +				queue_work(priv->dpaa2_ptp_wq,
> > +					   &priv->tx_onestep_tstamp);
> > +				return NETDEV_TX_OK;
> > +			}
> > +		/* Use two-step timestamping if not one-step timestamping
> > +		 * PTP Sync packet
> > +		 */
> > +		skb->cb[0] =3D TX_TSTAMP;
> > +	}
> > +
> > +	/* TX for other packets */
> > +	return __dpaa2_eth_tx(skb, net_dev);
> > +}
> > +
> >  /* Tx confirmation frame processing routine */  static void
> > dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
> >  			      struct dpaa2_eth_channel *ch __always_unused,
> > @@ -1906,6 +2068,7 @@ static int dpaa2_eth_ts_ioctl(struct net_device
> *dev,
> > struct ifreq *rq, int cmd)
> >  	switch (config.tx_type) {
> >  	case HWTSTAMP_TX_OFF:
> >  	case HWTSTAMP_TX_ON:
> > +	case HWTSTAMP_TX_ONESTEP_SYNC:
> >  		priv->tx_tstamp_type =3D config.tx_type;
> >  		break;
> >  	default:
> > @@ -2731,8 +2894,10 @@ static int dpaa2_eth_set_buffer_layout(struct
> > dpaa2_eth_priv *priv)
> >  	/* tx buffer */
> >  	buf_layout.private_data_size =3D DPAA2_ETH_SWA_SIZE;
> >  	buf_layout.pass_timestamp =3D true;
> > +	buf_layout.pass_frame_status =3D true;
> >  	buf_layout.options =3D DPNI_BUF_LAYOUT_OPT_PRIVATE_DATA_SIZE |
> > -			     DPNI_BUF_LAYOUT_OPT_TIMESTAMP;
> > +			     DPNI_BUF_LAYOUT_OPT_TIMESTAMP |
> > +			     DPNI_BUF_LAYOUT_OPT_FRAME_STATUS;
> >  	err =3D dpni_set_buffer_layout(priv->mc_io, 0, priv->mc_token,
> >  				     DPNI_QUEUE_TX, &buf_layout);
> >  	if (err) {
> > @@ -2741,7 +2906,8 @@ static int dpaa2_eth_set_buffer_layout(struct
> > dpaa2_eth_priv *priv)
> >  	}
> >
> >  	/* tx-confirm buffer */
> > -	buf_layout.options =3D DPNI_BUF_LAYOUT_OPT_TIMESTAMP;
> > +	buf_layout.options =3D DPNI_BUF_LAYOUT_OPT_TIMESTAMP |
> > +			     DPNI_BUF_LAYOUT_OPT_FRAME_STATUS;
> >  	err =3D dpni_set_buffer_layout(priv->mc_io, 0, priv->mc_token,
> >  				     DPNI_QUEUE_TX_CONFIRM, &buf_layout);
> >  	if (err) {
> > @@ -3969,6 +4135,16 @@ static int dpaa2_eth_probe(struct fsl_mc_device
> > *dpni_dev)
> >  	priv->tx_tstamp_type =3D HWTSTAMP_TX_OFF;
> >  	priv->rx_tstamp =3D false;
> >
> > +	priv->dpaa2_ptp_wq =3D alloc_workqueue("dpaa2_ptp_wq", 0, 0);
> > +	if (!priv->dpaa2_ptp_wq) {
> > +		err =3D -ENOMEM;
> > +		goto err_wq_alloc;
> > +	}
> > +
> > +	INIT_WORK(&priv->tx_onestep_tstamp,
> > dpaa2_eth_tx_onestep_tstamp);
> > +
> > +	skb_queue_head_init(&priv->tx_skbs);
> > +
> >  	/* Obtain a MC portal */
> >  	err =3D fsl_mc_portal_allocate(dpni_dev,
> > FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
> >  				     &priv->mc_io);
> > @@ -4107,6 +4283,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device
> > *dpni_dev)
> >  err_dpni_setup:
> >  	fsl_mc_portal_free(priv->mc_io);
> >  err_portal_alloc:
> > +	destroy_workqueue(priv->dpaa2_ptp_wq);
> > +err_wq_alloc:
> >  	dev_set_drvdata(dev, NULL);
> >  	free_netdev(net_dev);
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > index 57e6e6e..c5a8e38 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > @@ -195,6 +195,24 @@ struct dpaa2_faead {
> >  #define DPAA2_FAEAD_EBDDV		0x00002000
> >  #define DPAA2_FAEAD_UPD			0x00000010
> >
> > +struct ptp_tstamp {
> > +	u16 sec_msb;
> > +	u32 sec_lsb;
> > +	u32 nsec;
> > +};
> > +
> > +static inline void ns_to_ptp_tstamp(struct ptp_tstamp *tstamp, u64 ns)
> > +{
> > +	u64 sec, nsec;
> > +
> > +	sec =3D ns / 1000000000ULL;
> > +	nsec =3D ns % 1000000000ULL;
> > +
> > +	tstamp->sec_lsb =3D sec & 0xFFFFFFFF;
> > +	tstamp->sec_msb =3D (sec >> 32) & 0xFFFF;
> > +	tstamp->nsec =3D nsec;
> > +}
> > +
> >  /* Accessors for the hardware annotation fields that we use */  static
> inline void
> > *dpaa2_get_hwa(void *buf_addr, bool swa)  { @@ -474,9 +492,21 @@
> struct
> > dpaa2_eth_priv {  #endif
> >
> >  	struct dpaa2_mac *mac;
> > +	struct workqueue_struct	*dpaa2_ptp_wq;
> > +	struct work_struct	tx_onestep_tstamp;
> > +	struct sk_buff_head	tx_skbs;
> > +	/* The one-step timestamping configuration on hardware
> > +	 * registers could only be done when no one-step
> > +	 * timestamping frames are in flight. So we use a mutex
> > +	 * lock here to make sure the lock is released by last
> > +	 * one-step timestamping packet through TX confirmation
> > +	 * queue before transmit current packet.
> > +	 */
> > +	struct mutex		onestep_tstamp_lock;
> >  };
> >
> >  #define TX_TSTAMP		0x1
> > +#define TX_TSTAMP_ONESTEP_SYNC	0x2
> >
> >  #define DPAA2_RXH_SUPPORTED	(RXH_L2DA | RXH_VLAN |
> > RXH_L3_PROTO \
> >  				| RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 \
> > @@ -580,7 +610,7 @@ static inline unsigned int
> > dpaa2_eth_needed_headroom(struct sk_buff *skb)
> >  		return 0;
> >
> >  	/* If we have Tx timestamping, need 128B hardware annotation */
> > -	if (skb->cb[0] =3D=3D TX_TSTAMP)
> > +	if (skb->cb[0])
> >  		headroom +=3D DPAA2_ETH_TX_HWA_SIZE;
> >
> >  	return headroom;
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > index 26bd99b..bf3baf6 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > @@ -1,6 +1,7 @@
> >  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> >  /* Copyright 2014-2016 Freescale Semiconductor Inc.
> >   * Copyright 2016 NXP
> > + * Copyright 2020 NXP
> >   */
> >
> >  #include <linux/net_tstamp.h>
> > @@ -770,7 +771,8 @@ static int dpaa2_eth_get_ts_info(struct net_device
> > *dev,
> >  	info->phc_index =3D dpaa2_phc_index;
> >
> >  	info->tx_types =3D (1 << HWTSTAMP_TX_OFF) |
> > -			 (1 << HWTSTAMP_TX_ON);
> > +			 (1 << HWTSTAMP_TX_ON) |
> > +			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
> >
> >  	info->rx_filters =3D (1 << HWTSTAMP_FILTER_NONE) |
> >  			   (1 << HWTSTAMP_FILTER_ALL);
> > --
> > 2.7.4

