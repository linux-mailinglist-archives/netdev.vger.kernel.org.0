Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334FC2BB456
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbgKTSuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:50:35 -0500
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:61537
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731566AbgKTSue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:50:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImLjGezoSbSitav473oBremckK90vYOiH9lUp4KsdlLfGoRRCjFWmSvRzOX3zqB4ecs2kPOSNKrR1bDeiJmVcENkWMc8QGOM4/zMDINN/mq0KkJbjqtqsToJ8QIl3vaT8uO9Qz/p3Y5L5ODulL1NRpasF9oTOGGcMai9+iP4UQMxv+ze9JSaBVmTMCCjKPaieTyG1OvH6eRSZk2YmfK48cpeyj6lyGmj6fnjVKEFz562idOI0gL3ozqBz+SlzzDRCUgM5RkqUvUD96Hgira1wSDi/P2e33QKqJWk5t8MX7yUB5bFOZ6adUNPebE5mmI0dpeVODwkQMYQi5K57AccNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnYXn4HVMn1eNXC0C2Xt3S+CZ2hLEE0E4RpkImsL7WU=;
 b=lWTLozRHTbA6TkS69i0Z/dF5Utc71+uizom7vK4mrw1Y3YCA/2UA3PaTBdDxsGGxhNCcF/J1vYWYVFlDyjVJZ5TmxCqGc9vnGOKJfowFc8hUjhoXC9kq8pKBA+yz5IMmvlmR8fe8hr8bmSjjLof5CKnHck2zD+Zv2WaxsnIQRseZaIlNyb0wDeW104Zu0ZaipZc/eztqpD1TOhfREbgJ9fc0YVp6JPnQ3WDeVDEkMTFmTbVzyBLRXcjPiuokQmwtS/mJ+PQCK3tBIaoRvWHPr0TCwVqCg8Xs4eyQ2UIzBWd2wd911hCGM/9omEmoNOj2NAUdoVAL4dOt9hVAGHMhZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnYXn4HVMn1eNXC0C2Xt3S+CZ2hLEE0E4RpkImsL7WU=;
 b=kkysWpNCqhG/5+dfKrhI8J+GVt5vJubIqlR58HlyE++gCnhQH5kjFBiDBk8ajqbf+2WjQ8tf/EQ/Prs5t2lYsnyp+TrRfb3NX0jL3gxoiKJ7L7c+CbUkXV6xOYN1g+Td4tGoCCZ/80Lg8swtiztFfhX+uEXK+YDaJArSuRVubwk=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6463.eurprd04.prod.outlook.com (2603:10a6:803:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 18:50:28 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Fri, 20 Nov 2020
 18:50:28 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
Thread-Topic: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
Thread-Index: AQHWvpEv5OAASGuNl06qNM5f5YHP2KnQKEcAgAE10LA=
Date:   Fri, 20 Nov 2020 18:50:28 +0000
Message-ID: <VI1PR04MB58076B6D16C76E71247BA12FF2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <257fc3a02512bb4d2fc5eccec1796011ec9f0fbb.1605802951.git.camelia.groza@nxp.com>
 <20201120001844.GB24983@ranger.igk.intel.com>
In-Reply-To: <20201120001844.GB24983@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd21d5fa-23ee-483d-1c92-08d88d852612
x-ms-traffictypediagnostic: VE1PR04MB6463:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6463A7A39878E6A545186586F2FF0@VE1PR04MB6463.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W0bs1907RtaOuLjZSbEwEL3d22sFn6jXQMUwlaHZ4NtRYJ58AwKcdH0kxOW20CyrWC23JxCm+lnSmeBXwFgtTLcAXACjXye+Jrz0QhQgjrJ4geLYmzz7FNH56DgGxNGIo9B6hP4Z/HR+SmkMKgJu4ZeTRoRVw1NRZu7cy7GjjsMqopBBmx1KLczQqaD40YTk2RJyrxL2azzB+8RDJf1bLGOCp1wxj18UZkff89s6b1YTveptqnRntmHjvghM9VV+/0gKSb3FamFuSyuwXmkciPZUsbV2n24iI3m0z7ufJce5pGSS8Nk2s3tqvDgRXHKH/E+oqYn6h6wHmWQ0Pjl4KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39850400004)(366004)(136003)(346002)(55016002)(71200400001)(478600001)(9686003)(316002)(4326008)(8936002)(26005)(53546011)(6916009)(8676002)(7696005)(6506007)(2906002)(54906003)(186003)(33656002)(66946007)(64756008)(66556008)(52536014)(66446008)(83380400001)(66476007)(30864003)(86362001)(76116006)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sDtONI9OnH72cK+B2eIZr89t8rGq6LJkNh3kEttsbTm2lrF9axMAOyzjT1yFA6K1lMYuPzcc8CuZ6JizBxKddrlafeZxJYTp9aqCV3+mUD6u5fpcvfRXr211AMDDQyWZaMaiTp5E5/sGG135tVi2de64DAeDkLoUb1uL2jnYxHsBSNpOAv670M3p2oSKepH8wGtLRwlIK4hTPO4WMxqvgQmiF6/SCtzaaEZrArDJGbfaG1STF0GihxxRT0OyF48XerCz7P/vYD8DozI+Ic8PQrT3tGmSIKAqW8v56O4dHYD8bXlGhTlwmAO3t0o6xqwPxn+kinlU6g+hrPfJPOOJRYnVElxcqHUryrwP/D5HIFIW759F66MTlInllil/zSywnMvtiDHcoYbKMJq49k5YaHu3FJbbTKvbKs6xlFLQDRYopu4HPJOtk8EEDHfGt6L5eENgnrjNvWDG1d8VOE8NP8AegQ2eW/t6PlM9CaPfXDlCqtaqoPY2IclTjNkV4GwUHqxUSE0qi5FW1FlJIS2AXUZpfhvIk69MdtUrHIISNXnmIFYFUi0Hl2K/z/G7huBs2dZBGtQBB99ecEevdDcxg3Ukw6yXMGaqzT6F+KuEQr7afaDQLMWLU/GHXWONgT4RKkoWhGDUFP0dj+0ShoigpT3lqYL9M/AouyPiePrkDR0qG6baL5X4nKW/SAlc4/A2eI+aGFytwzep6RoLcSu6j+jAcXIxxWhMRe0RR0DztBb7ZhE8xlEjFHsZ0nV0/lDsoB6y+zjvjn4zcwlyeJ0aLNQ+aJnmjV5Q0O5eoa8AsHRL6/4dKtd2t1q8hskhlZahBjigV9Jl88aM7OD5oB/Tm96DUbkq8PGv2RiBJMVgOa7Ow0NE/P2/5zNVQCz9mveFFLTmBbLvniYuuWuziojKsg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd21d5fa-23ee-483d-1c92-08d88d852612
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 18:50:28.1203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TzgGM7w5+OLNoo6MpgS7/sVfgRGxCA2/x+rYX8Pi8tcaN/21zYzMtHmxcYnzP1Re2WN2gAQ2R0LZci1BeIFRiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6463
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Friday, November 20, 2020 02:19
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
>=20
> On Thu, Nov 19, 2020 at 06:29:31PM +0200, Camelia Groza wrote:
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
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 158
> ++++++++++++++++++++++---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> >  2 files changed, 144 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 88533a2..102023c 100644
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
>=20
> I feel like a little drawing of xdp_buff layout would help me with
> understanding what is going on over here :)

A region at the start of the buffer is reserved for storing hardware annota=
tions and room for the XDP_PACKET_HEADROOM, before the actual data starts. =
So vaddr points to the start of the buffer, while fd offset provides the of=
fset of the data inside the buffer. I don't feel that we are filling the xd=
p_buff in a majorly different way from other drivers, so please mention wha=
t is unclear here and I can provide more details.

> > +	xdp.data_meta =3D xdp.data;
> > +	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > +	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
>=20
> Maybe you could fill xdp_buff outside of this function so that later on
> you could set xdp.rxq once per napi?

I admit I haven't looked into exactly how much performance we would gain fr=
om this, but I don't think it would be enough to justify the code churn. We=
 don't have a clean loop for processing the received frames like I see the =
Intel and ENA drivers have.

> > +
> > +	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > +
> > +	/* Update the length and the offset of the FD */
> > +	qm_fd_set_contig(fd, xdp.data - vaddr, xdp.data_end - xdp.data);
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
>=20
> This is working on a single buffer, right? So there's no need to clear
> xdp_meta_len?

I don't think I understand what you mean. Are you saying I shouldn't be ini=
tializing xdp_meta_len to 0? This receive path is used when XDP is disabled=
 as well, in which case we don't propagate the metadata.

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
> > @@ -2671,6 +2756,46 @@ static int dpaa_eth_stop(struct net_device
> *net_dev)
> >  	return err;
> >  }
> >
> > +static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog
> *prog)
> > +{
> > +	struct dpaa_priv *priv =3D netdev_priv(net_dev);
> > +	struct bpf_prog *old_prog;
> > +	bool up;
> > +	int err;
> > +
> > +	/* S/G fragments are not supported in XDP-mode */
> > +	if (prog && (priv->dpaa_bp->raw_size <
> > +	    net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN))
> > +		return -EINVAL;
>=20
> Don't you want to include extack message here?

This code is moved in the third patch and a dev_warn() is added. I should h=
ave added the warning from the start. I'll update it in the next version.

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
> > +		if (err)
> > +			return err;
>=20
> Out of curiosity, what should user do for that case? Would he be aware of
> the weird state of interface?

This is an improbable state to reach. An error message would be useful. I'l=
l add it in the next version. Thanks.

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
> > @@ -2737,6 +2862,7 @@ static int dpaa_ioctl(struct net_device *net_dev,
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
