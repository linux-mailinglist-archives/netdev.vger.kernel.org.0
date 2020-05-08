Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E041CB38F
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgEHPkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:40:35 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:6089
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727911AbgEHPkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 11:40:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgKKr6FLv3GRdyiRDemccwQDw3YCmW/rQv+nGUxhrzEXcjJyAVD3g4MHXVF1Ou+CnUMl9StN+Iuf7mvLTNkSksXTu0fd3nc5W+X6FjXShHAwxKD+sjmffBdxl2RtvzfdVo8YVXS5FRYrW//ia5CokZpeVrold+js46tfmRmgwpOZtooMuJfuHXlI+en7EB3s/5HlleoQPQslsmeWWX4Xs6CN5jOt8/r8M2LZwxTR+eD2S/Dl63QTbunlHT70Xzbg5V+9MUKdSjjvxFzdY6ir3gX2cLW+tOA0oowMMrS0oML55rM5+Z/ht1mpqoDjix7nXroB5wQVSHYsqtF8uCDjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZzmiEiT9L76W/vLWPPil76MOJOKOiFynxJPToAGuuI=;
 b=YIBSASZmQokUhVebS85e77fAlWZJu4qINMTGfWsBhKVWc8ha4I6l6fBgYlJv5BOJGtnT2fFX3lE70XTfypJumB5YlLtcGBOWaDyZGvVGm85d5E+eISGKu5AvXXirhOsyzWX9XWYOO6DZp33tyiQjVdY2Wu1G573xZXve6slBU99qEDoDS/ItbQ0+8BJqR31Yncba0FGhyYhdhMfZUtf55gz2rZ9yD9up3JnAtuQZpg2811nOYPdy/AkUy78dPiNBoNDOJhJvnZ7d3doZ3dNvC6MPF8W2UK+h2UasVVIczrvKGN/o7JrlTBZfnUnUt+MwteS8iwiwn1dC8RzA/Yrm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZzmiEiT9L76W/vLWPPil76MOJOKOiFynxJPToAGuuI=;
 b=LhpwYlzrEU8hyhBtIUuhrGU1jXLHN5Y+aW2Al8jm6bbjcJD/fL7qzUBHW/iKENsgE4e590JadoYEBO5srLEeCi4QJHFkyVNvaYxVJuafPWQOCnkXp0XKJpY4TJTAiTHHSU9dCrZFfobPCyTOmQ3mK6ohYa5kLFTXTXQ106yAK9k=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB5674.eurprd04.prod.outlook.com (2603:10a6:10:af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 8 May
 2020 15:40:29 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%9]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 15:40:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "hawk@kernel.org" <hawk@kernel.org>
Subject: RE: [PATCH net-next 2/2] dpaa2-eth: add bulking to XDP_TX
Thread-Topic: [PATCH net-next 2/2] dpaa2-eth: add bulking to XDP_TX
Thread-Index: AQHWI85oOerh1UUQyUaBuRERdM8sb6ieViIA
Date:   Fri, 8 May 2020 15:40:29 +0000
Message-ID: <DB8PR04MB6828140A3F38A4B7EB2F17E7E0A20@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200506174718.20916-1-ioana.ciornei@nxp.com>
 <20200506174718.20916-3-ioana.ciornei@nxp.com>
In-Reply-To: <20200506174718.20916-3-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5fa623a8-6209-4694-b277-08d7f366231a
x-ms-traffictypediagnostic: DB8PR04MB5674:
x-microsoft-antispam-prvs: <DB8PR04MB5674E798F5AC4573456F16CAE0A20@DB8PR04MB5674.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nd171xRV+qFXHGtwjssXb5w5lntygLhvEI82fIMgY2HwTxeFthdDmuOADuUf0sN2lLdDsgE/EqkC9cvCZLCJQocBIDSENy2aMwd+oO5tQhUsOBa+VaUB+AuhmLIYLqp3FYOzRT6tE1jWkUd13m87P2mcv2njnNNDrRM1FlY4SkzhTxFER7cpuYBSWmiQDnYPnNDUSZqPoDQz74vE3mWNCj9fZ7c4H8hdCufvOVu4bNQWkZbn11mkdVnuxPietq0pSz4zb1MmnXZjdf84Y3M4O/C01Xe+3mjUblAbGz4fRGxHxJOMT1VB8VKMhlxRCuv8YJH7Syckmb5Ee8/E7CvXk/+chAaHAYf2JAkidfVbKeW2RLvW8KVEKlVJJQvemyXN6+vlwkVvS6cZqLc/eMG4iYw6L8cAua18wYzz8r3VwngcoXj0eWw2L+wAtc3gCSk3y5kRXpiDP23U3gaX0GJD5HM7EvblTpvV8eejw47xiVj8i+J3d2cDhG3blPjU02anks7xzzHVe73LU5aPythFKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(33430700001)(71200400001)(7696005)(6506007)(316002)(64756008)(66446008)(66556008)(76116006)(66476007)(26005)(8936002)(66946007)(186003)(52536014)(2906002)(86362001)(5660300002)(83290400001)(44832011)(8676002)(33656002)(110136005)(478600001)(33440700001)(83300400001)(83280400001)(9686003)(4326008)(55016002)(83320400001)(83310400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2IFIvwZxDcehgxuB9KAZqmlckCNo7/QfbhcuwnnbfZ4nvVpKf+hVlTxoHfym9xI1kn76Nprsc8cYSd7gLA3d0eM6zWMK63UKV2qmHEcZq5lUigQmdO3n7z95yhnJgMxqkfi7svP60S6VKoqEi8n3C+SH7YjDfF1jg5CegYOpJW5NOSJOTWDRIXP6y5trFBO9Z2MSEYfmEW90Gsg4ZtWz7PFSa3JaDOGaBx03i/T+yH/oGW/VSo3BMloDACrc0hQo9NIc2Bw56uQMVKUmHKsmYLlE4LO0X15XKqT5WKV6mzveHjQidbvVD0kTr+MDPube2bQ3cQMqQ7cGYHkxCp4vFD9ZjhIsQfbpYXkOQ9y80MxywFYxTBqpEmN+of6E6YKZ7qNxKJMD4wrz/uUtUJ8PIqy6zj9IJvAlTubVNGGQU9HGX+bwSFNdklgkZyx/d9K4CKZB3HWoW/7tyGyDkcGKqPOzPTyulL5+ccR0rD+bqf0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa623a8-6209-4694-b277-08d7f366231a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 15:40:29.5976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qKTbNzga6Oxvc0uzUrS+ZG6zvpLkLGu85UZWTgoqWRlvBMnhQ+x4+KQnGOy9cpNXGWIHIvgugCGzXOeADodnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH net-next 2/2] dpaa2-eth: add bulking to XDP_TX
>=20
> Add driver level bulking to the XDP_TX action.
>=20
> An array of frame descriptors is held for each Tx frame queue and populat=
ed
> accordingly when the action returned by the XDP program is XDP_TX. The fr=
ames
> will be actually enqueued only when the array is filled. At the end of th=
e NAPI
> cycle a flush on the queued frames is performed in order to enqueue the
> remaining FDs.
>=20
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Hi,

I saw that only patch 1/2 was applied on net-next. Should I send a v2 with =
just this patch?

Thanks,
Ioana


> ---
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 68 ++++++++++++-------
> .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 +
>  2 files changed, 46 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 0f3e842a4fd6..b1c64288a1fb 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -273,13 +273,43 @@ static int dpaa2_eth_xdp_flush(struct dpaa2_eth_pri=
v
> *priv,
>  	return total_enqueued;
>  }
>=20
> -static int xdp_enqueue(struct dpaa2_eth_priv *priv, struct dpaa2_fd *fd,
> -		       void *buf_start, u16 queue_id)
> +static void xdp_tx_flush(struct dpaa2_eth_priv *priv,
> +			 struct dpaa2_eth_channel *ch,
> +			 struct dpaa2_eth_fq *fq)
> +{
> +	struct rtnl_link_stats64 *percpu_stats;
> +	struct dpaa2_fd *fds;
> +	int enqueued, i;
> +
> +	percpu_stats =3D this_cpu_ptr(priv->percpu_stats);
> +
> +	// enqueue the array of XDP_TX frames
> +	enqueued =3D dpaa2_eth_xdp_flush(priv, fq, &fq->xdp_tx_fds);
> +
> +	/* update statistics */
> +	percpu_stats->tx_packets +=3D enqueued;
> +	fds =3D fq->xdp_tx_fds.fds;
> +	for (i =3D 0; i < enqueued; i++) {
> +		percpu_stats->tx_bytes +=3D dpaa2_fd_get_len(&fds[i]);
> +		ch->stats.xdp_tx++;
> +	}
> +	for (i =3D enqueued; i < fq->xdp_tx_fds.num; i++) {
> +		xdp_release_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
> +		percpu_stats->tx_errors++;
> +		ch->stats.xdp_tx_err++;
> +	}
> +	fq->xdp_tx_fds.num =3D 0;
> +}
> +
> +static void xdp_enqueue(struct dpaa2_eth_priv *priv,
> +			struct dpaa2_eth_channel *ch,
> +			struct dpaa2_fd *fd,
> +			void *buf_start, u16 queue_id)
>  {
> -	struct dpaa2_eth_fq *fq;
>  	struct dpaa2_faead *faead;
> +	struct dpaa2_fd *dest_fd;
> +	struct dpaa2_eth_fq *fq;
>  	u32 ctrl, frc;
> -	int i, err;
>=20
>  	/* Mark the egress frame hardware annotation area as valid */
>  	frc =3D dpaa2_fd_get_frc(fd);
> @@ -296,13 +326,13 @@ static int xdp_enqueue(struct dpaa2_eth_priv *priv,
> struct dpaa2_fd *fd,
>  	faead->conf_fqid =3D 0;
>=20
>  	fq =3D &priv->fq[queue_id];
> -	for (i =3D 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
> -		err =3D priv->enqueue(priv, fq, fd, 0, 1, NULL);
> -		if (err !=3D -EBUSY)
> -			break;
> -	}
> +	dest_fd =3D &fq->xdp_tx_fds.fds[fq->xdp_tx_fds.num++];
> +	memcpy(dest_fd, fd, sizeof(*dest_fd));
>=20
> -	return err;
> +	if (fq->xdp_tx_fds.num < DEV_MAP_BULK_SIZE)
> +		return;
> +
> +	xdp_tx_flush(priv, ch, fq);
>  }
>=20
>  static u32 run_xdp(struct dpaa2_eth_priv *priv, @@ -311,14 +341,11 @@ st=
atic
> u32 run_xdp(struct dpaa2_eth_priv *priv,
>  		   struct dpaa2_fd *fd, void *vaddr)
>  {
>  	dma_addr_t addr =3D dpaa2_fd_get_addr(fd);
> -	struct rtnl_link_stats64 *percpu_stats;
>  	struct bpf_prog *xdp_prog;
>  	struct xdp_buff xdp;
>  	u32 xdp_act =3D XDP_PASS;
>  	int err;
>=20
> -	percpu_stats =3D this_cpu_ptr(priv->percpu_stats);
> -
>  	rcu_read_lock();
>=20
>  	xdp_prog =3D READ_ONCE(ch->xdp.prog);
> @@ -341,16 +368,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
>  	case XDP_PASS:
>  		break;
>  	case XDP_TX:
> -		err =3D xdp_enqueue(priv, fd, vaddr, rx_fq->flowid);
> -		if (err) {
> -			xdp_release_buf(priv, ch, addr);
> -			percpu_stats->tx_errors++;
> -			ch->stats.xdp_tx_err++;
> -		} else {
> -			percpu_stats->tx_packets++;
> -			percpu_stats->tx_bytes +=3D dpaa2_fd_get_len(fd);
> -			ch->stats.xdp_tx++;
> -		}
> +		xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
>  		break;
>  	default:
>  		bpf_warn_invalid_xdp_action(xdp_act);
> @@ -1168,6 +1186,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi,=
 int
> budget)
>  	int store_cleaned, work_done;
>  	struct list_head rx_list;
>  	int retries =3D 0;
> +	u16 flowid;
>  	int err;
>=20
>  	ch =3D container_of(napi, struct dpaa2_eth_channel, napi); @@ -1190,6
> +1209,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget=
)
>  			break;
>  		if (fq->type =3D=3D DPAA2_RX_FQ) {
>  			rx_cleaned +=3D store_cleaned;
> +			flowid =3D fq->flowid;
>  		} else {
>  			txconf_cleaned +=3D store_cleaned;
>  			/* We have a single Tx conf FQ on this channel */ @@ -
> 1232,6 +1252,8 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int
> budget)
>=20
>  	if (ch->xdp.res & XDP_REDIRECT)
>  		xdp_do_flush_map();
> +	else if (rx_cleaned && ch->xdp.res & XDP_TX)
> +		xdp_tx_flush(priv, ch, &priv->fq[flowid]);
>=20
>  	return work_done;
>  }
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> index b5f7dbbc2a02..9c37b6946cec 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> @@ -334,6 +334,7 @@ struct dpaa2_eth_fq {
>  	struct dpaa2_eth_fq_stats stats;
>=20
>  	struct dpaa2_eth_xdp_fds xdp_redirect_fds;
> +	struct dpaa2_eth_xdp_fds xdp_tx_fds;
>  };
>=20
>  struct dpaa2_eth_ch_xdp {
> --
> 2.17.1

