Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0252C2C70
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbgKXQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:12:05 -0500
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:14433
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389426AbgKXQME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:12:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwT/Q5tQrewOBCh9HKqNMJhL7sJGi7qSZ+dASwXZ8f51HL7johCQBlCx1JtuHuKkQ+FsTje8ljg3TwfJobrstVwn0WtMEJDkAeA0oqSJzDO36SO6eGr3MUoo9yPvoidJV7NJG/P9rSxWagj/rnb4vc7KPfNEs1q6kZvM5kEXa2d4NlzBHhB3fMAcR3vKXInYAK3TGl9CHbwMoKgA0MHe0utkuK+vqGChOzja5sEWwFeJWjCKJiNCttR+vAskOxez7IboIZpm7MHiWyRRrxW8XtnrvM3HOWJFHoFnW++uwvlvUtzHV1UgbQ/L7MQdPBzS6yVC8vSh+KzJWxs38kRvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOCwsAT55EvXzO0qr6sVo6xLippVBqhAOvfoyMMMGN0=;
 b=SYg5NWY5Li2v9GrSO0mJiQ2Ty8RjwyDjKWfEspV0drFhYeGRXRCovW5VX+b0OCjyu6I6mZQJDKF8attpqBhFSjuZLCiF5D8Sq3iKs+R6ZfwK6dzncfsQ4C7cSbR0XjkbP9zbMo7BnLPrUMzX3HwHrqEsa+woZXjrw7luLQi/bDT/QskMlXMBAd8x5xaGmOH6My2Od5KMQehtY445PJbrw1US2aD6DNyAF4YtptGo4mdskn4sJhuKuoRnMCURaMzio2eilFkT9nq/TOS907decmaB6s/mdrotdQ9W2CGKrbXtJi5B75AbmlNItWL+jCBQhOrOoWR0yNqueALduCdmOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOCwsAT55EvXzO0qr6sVo6xLippVBqhAOvfoyMMMGN0=;
 b=IFr7/sqwy6FfWbcrJcihJyGiV/LiY6txWmHzvn3YFKIw7IDz8ZDDmrrHXtXHGuszZGbqWqR/YsIs0Agq0iVIrpdFCj3b3JyL33Xr2NJawTtZn+QOb4+nzVa9hwmnddvRcHQhT8wTABjVQ51YYRZdoCNfQSQhgTrh2utGjTP81UA=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB5149.eurprd04.prod.outlook.com (2603:10a6:803:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Tue, 24 Nov
 2020 16:11:58 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Tue, 24 Nov 2020
 16:11:58 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 2/7] dpaa_eth: add basic XDP support
Thread-Topic: [PATCH net-next v4 2/7] dpaa_eth: add basic XDP support
Thread-Index: AQHWwb80fvVwn9J9AkKcYfMl4q5MG6nXTkSAgAAatBA=
Date:   Tue, 24 Nov 2020 16:11:58 +0000
Message-ID: <VI1PR04MB5807E840A7A5AF3D65E663CFF2FB0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <f93f96e77e905c7cd96660095611ef0944feb8da.1606150838.git.camelia.groza@nxp.com>
 <20201124135117.GA12808@ranger.igk.intel.com>
In-Reply-To: <20201124135117.GA12808@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77f94a6d-7d98-408c-8830-08d89093aba7
x-ms-traffictypediagnostic: VI1PR04MB5149:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5149AAEADADAE4D47F2D0070F2FB0@VI1PR04MB5149.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lpy/B0nak6F9dHsd0G9jw2Mee96ote6pLAxmZ6GnRcALcRTPHIAcFMAAjEXuVpWCV4K1nGZrSkBd2rT6lyvHL7+dqTb1lbMUt4MtCSulQp3pObojxt7ApBE/KaFiQydz3xaTzTHDflevJsqMWOca0IYrG3eG3XMg6n4gMACNfNv8g1avsMtB3Xzf6KahpwhdhB6iEfRBdPAARc3Kfge8sdBr/Nc4Nu9zWv0nxFxrit2+lzmqO8g+9DkFcR5LUxaJUCRdKnzBKiC6JxsScTP7zUE6kA93c6iTsRwKTX9cYEtcHFgd1q7ceBjEXhMcPHx5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(4326008)(30864003)(86362001)(7696005)(55016002)(33656002)(9686003)(6506007)(53546011)(8936002)(186003)(498600001)(26005)(8676002)(54906003)(52536014)(76116006)(66446008)(64756008)(66946007)(66556008)(2906002)(5660300002)(83380400001)(71200400001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8HK2jnqZR5DzIK2dgtJooKl4PMrXOVy2QHmzTh7dKhW9yez/pQSMxHmK0MYf?=
 =?us-ascii?Q?8NUUsoXZI0pKJvEgCytSp55XbeNuh/0mYDbEtHzEvZCPPMZ+PhDIK8+UdsNr?=
 =?us-ascii?Q?VU/UIa+Ggu2A4HAFL1CMT8aPxwbmDAHP1H900jqrwbnpAoAopKAdmcrXK44w?=
 =?us-ascii?Q?JmM5xvXfMm4YyKJ/AXYVz0gy3w0Ajfdt8gX0cLxAXZ1s6RtebjyQXNAs2R82?=
 =?us-ascii?Q?x1QMlugm7w/63qsSLAT2AHtk8wuScV2SRaLfOcnnBdbLVulyCv5zpfyQPxYb?=
 =?us-ascii?Q?B8Busi0AAPidZU2ZEfoykaWAfB/CpN5kTGh6u+W2V3INqWRXh+nYujTTSfn3?=
 =?us-ascii?Q?MjFDmhrEOPzhcHxEDhen//r0jeTVWckqeqySSIevq2ognfeIH7OyNKZOTjLJ?=
 =?us-ascii?Q?dPx3M+g2V+T5cENkNm4hZg25O5U9BJme3TPYPsQ9/1ea4wkGyitgg/LioG8N?=
 =?us-ascii?Q?b/bK0G3nj6NFl5cvZyj+uEB9UebFig41V2Z8o+wA8IWsvxHW142MUmHgB8HX?=
 =?us-ascii?Q?Qbs5UvkVohC0/38FcFWMmNxEMs5PrTOVlRVay4GGmTiNqSXpcNwLXzYTYxLo?=
 =?us-ascii?Q?rptzbIVJXeNpBqQebasOJBO7c9S734KuiLJPi4a8Cxxv7jhG9EvU3shDloPZ?=
 =?us-ascii?Q?6Uf3/c5ZGvGDyIn4X+o8ga6DFatLMQpLg7tzYVwUp87heX1B0cTAzywOF00z?=
 =?us-ascii?Q?Mc45fMT28Rp3fo98ss80cCf8kfTra5jfm99ohcCwQ4sGAGM+jTtGCTt8mML1?=
 =?us-ascii?Q?8NsFZeQlQeaQVCfvgYjGF3F4Ca7zD/w4gFzaY+84dtZud5mqI+Ml/cSU0asb?=
 =?us-ascii?Q?2RxP1+dGPyJP9+szzk0munFRCaRLZarFE2kW7pKeaaH8Qowx5g5nbwRbm9Jm?=
 =?us-ascii?Q?rg0i2dVeHGSvJ7eo9O0Vne8+Kjz468UEG5HK6oP7hOBWoXud3CTajfjeC8EF?=
 =?us-ascii?Q?Rvc6vi3vit40VGsy0aPD+rKAf1nPWB9V87XGeo93r74=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f94a6d-7d98-408c-8830-08d89093aba7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 16:11:58.6671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aeLVohF7nF5uE8yp4iJaCyRgcIHO69N8f8DAVegNracnxz/igosCm+StZ+UX+3E7P1DuZtfPFvf2PRr7l2svCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, November 24, 2020 15:51
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 2/7] dpaa_eth: add basic XDP support
>=20
> On Mon, Nov 23, 2020 at 07:36:20PM +0200, Camelia Groza wrote:
> > Implement the XDP_DROP and XDP_PASS actions.
> >
> > Avoid draining and reconfiguring the buffer pool at each XDP
> > setup/teardown by increasing the frame headroom and reserving
> > XDP_PACKET_HEADROOM bytes from the start. Since we always reserve
> an
> > entire page per buffer, this change only impacts Jumbo frame scenarios
> > where the maximum linear frame size is reduced by 256 bytes. Multi
> > buffer Scatter/Gather frames are now used instead in these scenarios.
> >
> > Allow XDP programs to access the entire buffer.
> >
> > The data in the received frame's headroom can be overwritten by the XDP
> > program. Extract the relevant fields from the headroom while they are
> > still available, before running the XDP program.
> >
> > Since the headroom might be resized before the frame is passed up to th=
e
> > stack, remove the check for a fixed headroom value when building an skb=
.
> >
> > Allow the meta data to be updated and pass the information up the stack=
.
> >
> > Scatter/Gather frames are dropped when XDP is enabled.
> >
> > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> > Changes in v2:
> > - warn only once if extracting the timestamp from a received frame fail=
s
> >
> > Changes in v3:
> > - drop received S/G frames when XDP is enabled
> >
> > Changes in v4:
> > - report a warning if the MTU is too hight for running XDP
> > - report an error if opening the device fails in the XDP setup
> >
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 166
> ++++++++++++++++++++++---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> >  2 files changed, 152 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 88533a2..8acce62 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -53,6 +53,8 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/sort.h>
> >  #include <linux/phy_fixed.h>
> > +#include <linux/bpf.h>
> > +#include <linux/bpf_trace.h>
> >  #include <soc/fsl/bman.h>
> >  #include <soc/fsl/qman.h>
> >  #include "fman.h"
> > @@ -177,7 +179,7 @@
> >  #define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE +
> DPAA_TIME_STAMP_SIZE \
> >  		       + DPAA_HASH_RESULTS_SIZE)
> >  #define DPAA_RX_PRIV_DATA_DEFAULT_SIZE
> (DPAA_TX_PRIV_DATA_SIZE + \
> > -					dpaa_rx_extra_headroom)
> > +					XDP_PACKET_HEADROOM -
> DPAA_HWA_SIZE)
> >  #ifdef CONFIG_DPAA_ERRATUM_A050385
> >  #define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN -
> DPAA_HWA_SIZE)
> >  #define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
> > @@ -1733,7 +1735,6 @@ static struct sk_buff *contig_fd_to_skb(const
> struct dpaa_priv *priv,
> >  			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> >  	if (WARN_ONCE(!skb, "Build skb failure on Rx\n"))
> >  		goto free_buffer;
> > -	WARN_ON(fd_off !=3D priv->rx_headroom);
> >  	skb_reserve(skb, fd_off);
> >  	skb_put(skb, qm_fd_get_length(fd));
> >
> > @@ -2349,12 +2350,62 @@ static enum qman_cb_dqrr_result
> rx_error_dqrr(struct qman_portal *portal,
> >  	return qman_cb_dqrr_consume;
> >  }
> >
> > +static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void
> *vaddr,
> > +			unsigned int *xdp_meta_len)
> > +{
> > +	ssize_t fd_off =3D qm_fd_get_offset(fd);
> > +	struct bpf_prog *xdp_prog;
> > +	struct xdp_buff xdp;
> > +	u32 xdp_act;
> > +
> > +	rcu_read_lock();
> > +
> > +	xdp_prog =3D READ_ONCE(priv->xdp_prog);
> > +	if (!xdp_prog) {
> > +		rcu_read_unlock();
> > +		return XDP_PASS;
> > +	}
> > +
> > +	xdp.data =3D vaddr + fd_off;
> > +	xdp.data_meta =3D xdp.data;
> > +	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > +	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > +
> > +	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > +
> > +	/* Update the length and the offset of the FD */
> > +	qm_fd_set_contig(fd, xdp.data - vaddr, xdp.data_end - xdp.data);
>=20
> Shouldn't you do this update based on xdp.data_meta, not xdp.data?

Both the xdp.data_meta and xdp.data can be updated when the XDP program run=
s.

In case of XDP_PASS, when building an skb around an fd, we need to know whe=
re the data starts for calling skb_reserve(). The metadata set by the XDP p=
rogram is part of the skb's headroom, not part of the packet data. So we ad=
just the fd's offset and length based on the data, not the metadata. We let=
 the skb know it has metadata set in its headroom through skb_metadata_set(=
).

For XDP_TX we don't pass metadata to the hardware, and for XDP_REDIRECT the=
 xdp_frame points to this information, so there is no need for keeping trac=
k of it in the fd.

> > +
> > +	switch (xdp_act) {
> > +	case XDP_PASS:
> > +		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> > +		break;
> > +	default:
> > +		bpf_warn_invalid_xdp_action(xdp_act);
> > +		fallthrough;
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
> > +		fallthrough;
> > +	case XDP_DROP:
> > +		/* Free the buffer */
> > +		free_pages((unsigned long)vaddr, 0);
> > +		break;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +
> > +	return xdp_act;
> > +}
> > +
> >  static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal
> *portal,
> >  						struct qman_fq *fq,
> >  						const struct qm_dqrr_entry
> *dq,
> >  						bool sched_napi)
> >  {
> > +	bool ts_valid =3D false, hash_valid =3D false;
> >  	struct skb_shared_hwtstamps *shhwtstamps;
> > +	unsigned int skb_len, xdp_meta_len =3D 0;
> >  	struct rtnl_link_stats64 *percpu_stats;
> >  	struct dpaa_percpu_priv *percpu_priv;
> >  	const struct qm_fd *fd =3D &dq->fd;
> > @@ -2362,12 +2413,14 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
> >  	enum qm_fd_format fd_format;
> >  	struct net_device *net_dev;
> >  	u32 fd_status, hash_offset;
> > +	struct qm_sg_entry *sgt;
> >  	struct dpaa_bp *dpaa_bp;
> >  	struct dpaa_priv *priv;
> > -	unsigned int skb_len;
> >  	struct sk_buff *skb;
> >  	int *count_ptr;
> > +	u32 xdp_act;
> >  	void *vaddr;
> > +	u32 hash;
> >  	u64 ns;
> >
> >  	fd_status =3D be32_to_cpu(fd->status);
> > @@ -2423,35 +2476,67 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
> >  	count_ptr =3D this_cpu_ptr(dpaa_bp->percpu_count);
> >  	(*count_ptr)--;
> >
> > -	if (likely(fd_format =3D=3D qm_fd_contig))
> > +	/* Extract the timestamp stored in the headroom before running
> XDP */
> > +	if (priv->rx_tstamp) {
> > +		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr,
> &ns))
> > +			ts_valid =3D true;
> > +		else
> > +			WARN_ONCE(1, "fman_port_get_tstamp failed!\n");
> > +	}
> > +
> > +	/* Extract the hash stored in the headroom before running XDP */
> > +	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> &&
> > +	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> > +					      &hash_offset)) {
> > +		hash =3D be32_to_cpu(*(u32 *)(vaddr + hash_offset));
> > +		hash_valid =3D true;
> > +	}
> > +
> > +	if (likely(fd_format =3D=3D qm_fd_contig)) {
> > +		xdp_act =3D dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > +				       &xdp_meta_len);
> > +		if (xdp_act !=3D XDP_PASS) {
> > +			percpu_stats->rx_packets++;
> > +			percpu_stats->rx_bytes +=3D qm_fd_get_length(fd);
> > +			return qman_cb_dqrr_consume;
> > +		}
> >  		skb =3D contig_fd_to_skb(priv, fd);
> > -	else
> > +	} else {
> > +		/* XDP doesn't support S/G frames. Return the fragments to
> the
> > +		 * buffer pool and release the SGT.
> > +		 */
> > +		if (READ_ONCE(priv->xdp_prog)) {
> > +			WARN_ONCE(1, "S/G frames not supported under
> XDP\n");
> > +			sgt =3D vaddr + qm_fd_get_offset(fd);
> > +			dpaa_release_sgt_members(sgt);
> > +			free_pages((unsigned long)vaddr, 0);
> > +			return qman_cb_dqrr_consume;
> > +		}
> >  		skb =3D sg_fd_to_skb(priv, fd);
> > +	}
> >  	if (!skb)
> >  		return qman_cb_dqrr_consume;
> >
> > -	if (priv->rx_tstamp) {
> > +	if (xdp_meta_len)
> > +		skb_metadata_set(skb, xdp_meta_len);
> > +
> > +	/* Set the previously extracted timestamp */
> > +	if (ts_valid) {
> >  		shhwtstamps =3D skb_hwtstamps(skb);
> >  		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> > -
> > -		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr,
> &ns))
> > -			shhwtstamps->hwtstamp =3D ns_to_ktime(ns);
> > -		else
> > -			dev_warn(net_dev->dev.parent,
> "fman_port_get_tstamp failed!\n");
> > +		shhwtstamps->hwtstamp =3D ns_to_ktime(ns);
> >  	}
> >
> >  	skb->protocol =3D eth_type_trans(skb, net_dev);
> >
> > -	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> &&
> > -	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> > -					      &hash_offset)) {
> > +	/* Set the previously extracted hash */
> > +	if (hash_valid) {
> >  		enum pkt_hash_types type;
> >
> >  		/* if L4 exists, it was used in the hash generation */
> >  		type =3D be32_to_cpu(fd->status) & FM_FD_STAT_L4CV ?
> >  			PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3;
> > -		skb_set_hash(skb, be32_to_cpu(*(u32 *)(vaddr +
> hash_offset)),
> > -			     type);
> > +		skb_set_hash(skb, hash, type);
> >  	}
> >
> >  	skb_len =3D skb->len;
> > @@ -2671,6 +2756,54 @@ static int dpaa_eth_stop(struct net_device
> *net_dev)
> >  	return err;
> >  }
> >
> > +static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog
> *prog)
> > +{
> > +	struct dpaa_priv *priv =3D netdev_priv(net_dev);
> > +	struct bpf_prog *old_prog;
> > +	int err, max_contig_data;
> > +	bool up;
> > +
> > +	max_contig_data =3D priv->dpaa_bp->size - priv->rx_headroom;
> > +
> > +	/* S/G fragments are not supported in XDP-mode */
> > +	if (prog &&
> > +	    (net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN >
> max_contig_data)) {
> > +		dev_warn(net_dev->dev.parent,
> > +			 "The maximum MTU for XDP is %d\n",
> > +			 max_contig_data - VLAN_ETH_HLEN -
> ETH_FCS_LEN);
> > +		return -EINVAL;
> > +	}
> > +
> > +	up =3D netif_running(net_dev);
> > +
> > +	if (up)
> > +		dpaa_eth_stop(net_dev);
> > +
> > +	old_prog =3D xchg(&priv->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	if (up) {
> > +		err =3D dpaa_open(net_dev);
> > +		if (err) {
> > +			dev_err(net_dev->dev.parent, "dpaa_open()
> failed\n");
> > +			return err;
>=20
> So you decided not to take advantage of extack messages?

Sorry, I put more emphasis on reporting the messages than on the actual mea=
ns to do it. I'll wait, if you have more comments, and respin.

> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int dpaa_xdp(struct net_device *net_dev, struct netdev_bpf *xdp=
)
> > +{
> > +	switch (xdp->command) {
> > +	case XDP_SETUP_PROG:
> > +		return dpaa_setup_xdp(net_dev, xdp->prog);
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> >  static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int=
 cmd)
> >  {
> >  	struct dpaa_priv *priv =3D netdev_priv(dev);
> > @@ -2737,6 +2870,7 @@ static int dpaa_ioctl(struct net_device *net_dev,
> struct ifreq *rq, int cmd)
> >  	.ndo_set_rx_mode =3D dpaa_set_rx_mode,
> >  	.ndo_do_ioctl =3D dpaa_ioctl,
> >  	.ndo_setup_tc =3D dpaa_setup_tc,
> > +	.ndo_bpf =3D dpaa_xdp,
> >  };
> >
> >  static int dpaa_napi_add(struct net_device *net_dev)
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > index da30e5d..94e8613 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > @@ -196,6 +196,8 @@ struct dpaa_priv {
> >
> >  	bool tx_tstamp; /* Tx timestamping enabled */
> >  	bool rx_tstamp; /* Rx timestamping enabled */
> > +
> > +	struct bpf_prog *xdp_prog;
> >  };
> >
> >  /* from dpaa_ethtool.c */
> > --
> > 1.9.1
> >
