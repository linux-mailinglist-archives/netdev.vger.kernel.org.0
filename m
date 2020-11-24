Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF6D2C28A2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbgKXNsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:48:22 -0500
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:18971
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387707AbgKXNrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 08:47:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqRdSjQJu+dWgxXnckl9YwgoaKd5R3EvXb53bXqjn2bgus/3tfwryijIOHDXenSz07+2J8pq8U68+TX+lnbIF9LEG/8SvLyFx5q5WYlnPjjEuDwFGzdto5UamKzURHuXV6q7WcvFL60MSW+LRH3zOrJIKX9PcPTvP5Z2FweX9iLCVJ9vnrdCnPBEhles2dowAb5W7kIDyRqz37wmItcEPx5X3MP/00w3L5UcDr86ifNEDY3t/SuoO/Tx1nr9/ieU350CRCjnzU+sc8ttr1C8vgL8wBb55GctVhAEBWNruRp/k73on7r6GyYHLhmvficcvZcMp45nKxbBHroyFe6IGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYIg9F/Hc3USApBh8AWAKG2FsYkyeNvbPkU10axCUaE=;
 b=MG8UnclmlySXivcYM1J1ripn4tP1US39JwKqviCaYbzaYXX0vfiEvjNWxdWRkztGziij8Jky93ATCjp8B5q+mchol5sTEYJat1klobzmmkdFZHkcyQ6DahUCq1abRtZAkzCHR2psDnCwA9StIDsKY7PTbzek2KbcG2Ngj2rvKg3ZLB20+1ulEWcRW1+3qSdwWEwyyUGW69YHelvU9oNJeMYKICMFgK88xrL4iP46VQt1dPx2ViKodW3qYGtag45bOr/yMKGCVhpM1Zm7QSREcal7TwV1weYUjrSJPvP2inkW4fF3jLcVeMhgXT56XjfO5GJEi9zTrjXPu8vR7n1F9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYIg9F/Hc3USApBh8AWAKG2FsYkyeNvbPkU10axCUaE=;
 b=DWiM9ZItRjCEOx+jejDlzCqMAbI/uweZXe+/pUb6yFzuHtlewleAdq+3Z1BrTKDjVmYlu0mP3PASrerfv1Upjwvb6KREMrzOtBQ5nBbhaRWOBiRHe+aRV47eLiDS3czg1lFa7vvtM6VtAevVPj2cTAim+WDhmjn4wZP9hFCmQ4o=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6208.eurprd04.prod.outlook.com (2603:10a6:803:f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 13:47:43 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Tue, 24 Nov 2020
 13:47:42 +0000
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
Thread-Index: AQHWvpEv5OAASGuNl06qNM5f5YHP2KnQKEcAgAE10LCABO7zAIABBWYA
Date:   Tue, 24 Nov 2020 13:47:42 +0000
Message-ID: <VI1PR04MB580727D956EC7941C9475991F2FB0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <257fc3a02512bb4d2fc5eccec1796011ec9f0fbb.1605802951.git.camelia.groza@nxp.com>
 <20201120001844.GB24983@ranger.igk.intel.com>
 <VI1PR04MB58076B6D16C76E71247BA12FF2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <20201123220752.GB11618@ranger.igk.intel.com>
In-Reply-To: <20201123220752.GB11618@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3098eb09-614e-4b05-b872-08d8907f846d
x-ms-traffictypediagnostic: VI1PR04MB6208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6208DEDCE1EA3D64C3FC73B0F2FB0@VI1PR04MB6208.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BgVZNyBu6k3eW6ZVZhcVSZDvT47dM7cn0Dae/yu/q3VAAA9igArBCv5MATYddKi3h7XonOGfd+II7gZiZ7UFdPJilMCzrU17eI5GCXEPjN6FPDJYIU3hk8vLKmFTHDVNbZ2VmFAXM4py5scpvluG98y8bocZVmsOjzduIdxpALJ8zArJv/PM6ZQXiB7638ZjlsPrhU/xZVJgcCWZv2tC50q48AeaAYWbmBz9/qQ047nLqL3pmfMVHyGKKr3nF0uYNyeACr3gHW7bB65RRWKAbFD9MSEkOcLBJI8/EululZgd5AkP3JWSFFuJbvY5dvUzIC66Mzjj5KyvnrWJuhU+qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(71200400001)(55016002)(6916009)(7696005)(4326008)(8936002)(8676002)(30864003)(5660300002)(52536014)(33656002)(53546011)(9686003)(498600001)(83380400001)(64756008)(66556008)(66446008)(66946007)(66476007)(76116006)(6506007)(2906002)(186003)(26005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xw58PyQeW0xe757geHUrP6fqC3lbbawkwUD1KIMaO+8Avb2MREIpKiGrWCvW?=
 =?us-ascii?Q?jvpUeJ1XS/oMgmCShPdIXAp+7EHfz//ZXpMb6g1nrez6PT1y7s1xSnRaKTgf?=
 =?us-ascii?Q?FBUbryqU94ALjuADMS0zb4Dvh4K/GNlyuXViXGsEp3SCkY5XfnMtiq/681zw?=
 =?us-ascii?Q?In4urItC4ca3eeH8ttwDQpKIV/82TK8BUbZuEkGfcakOGB3Bs1sXZUGGzwzQ?=
 =?us-ascii?Q?J8os2RtJDylWwOBIdnDnsdklHK3hPhIeoWrg9f3yaPSRlLm354dT1MNtgIsw?=
 =?us-ascii?Q?vpkqwMOS5gnk0HSyqbdgjrxQi7XCAPT/wsdQ/rWvYK5ShvdeGeTkQQ/NZPiH?=
 =?us-ascii?Q?Nt4ZNfL0p0fu7CKAnblOblz/9wPr1ANNjFtMA4qgqoed7Y/4+Q/jHSKFCYJH?=
 =?us-ascii?Q?GoBXg7sDvViAkCvDiDCygz/C+bifvMpOCe2e0TNB7AH/haGYLQeRwZPvEIwR?=
 =?us-ascii?Q?31E0QoUQRmhE3DCgZBYBD8n6CPBqWjWXHfjwGiAJ9WbKe3FaKKKhR2lb8UWy?=
 =?us-ascii?Q?iIcImltsRP6gisDBqsNkCyzbScTu30M2MP6LpjastXd9cvkgOQF/BWbFOd2H?=
 =?us-ascii?Q?eVTuly+e7loGJ8C2z0N8VRIREfCmz6/zOe6tEFjusn+m/opnA7hEnw/qwhth?=
 =?us-ascii?Q?3pmuzOJ1N9s2my6Art8ljgxI/DG9Ys64odkoBb3rL7Vw6nqgc//A5ANCdUnt?=
 =?us-ascii?Q?JOZPHbEHvSHQOqrhLGFzCkL88NHqkEFsShG7TiL9t8Us0aIcVfDt0w3UP0Z8?=
 =?us-ascii?Q?n2Lb+aJMYqu6o/t1X/S+HWgBAMiDqiRy3dIhWMfZrA/EjczcojOudcZfM0NS?=
 =?us-ascii?Q?BROB5x/5k88eDIpo7H++Zszw3iZL7d7D6cIUQ5dBJF3L+Dj3Nu3fO0eR5BZW?=
 =?us-ascii?Q?c3/YrB3J1moEld9K2KLqzWu2PixZOrdARrlC39153kOfmXCEfFVQOWcKgjLm?=
 =?us-ascii?Q?Ijo0LdMU+tIDJtiOk2z9GU/8Tt5F8peyNPw5PdinmgM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3098eb09-614e-4b05-b872-08d8907f846d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 13:47:42.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bZ7+4U4J6fG/OCyEI4ZOVxt6azbu2094F72PhjNyYsNo8h+q1248whxv3DsaaWdbh8rPweY5lBLXpTPykdd2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, November 24, 2020 00:08
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
>=20
> On Fri, Nov 20, 2020 at 06:50:28PM +0000, Camelia Alexandra Groza wrote:
> > > -----Original Message-----
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Sent: Friday, November 20, 2020 02:19
> > > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > > davem@davemloft.net; Madalin Bucur (OSS)
> > > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next v3 2/7] dpaa_eth: add basic XDP support
> > >
> > > On Thu, Nov 19, 2020 at 06:29:31PM +0200, Camelia Groza wrote:
> > > > Implement the XDP_DROP and XDP_PASS actions.
> > > >
> > > > Avoid draining and reconfiguring the buffer pool at each XDP
> > > > setup/teardown by increasing the frame headroom and reserving
> > > > XDP_PACKET_HEADROOM bytes from the start. Since we always
> reserve
> > > an
> > > > entire page per buffer, this change only impacts Jumbo frame scenar=
ios
> > > > where the maximum linear frame size is reduced by 256 bytes. Multi
> > > > buffer Scatter/Gather frames are now used instead in these scenario=
s.
> > > >
> > > > Allow XDP programs to access the entire buffer.
> > > >
> > > > The data in the received frame's headroom can be overwritten by the
> XDP
> > > > program. Extract the relevant fields from the headroom while they a=
re
> > > > still available, before running the XDP program.
> > > >
> > > > Since the headroom might be resized before the frame is passed up t=
o
> the
> > > > stack, remove the check for a fixed headroom value when building an
> skb.
> > > >
> > > > Allow the meta data to be updated and pass the information up the
> stack.
> > > >
> > > > Scatter/Gather frames are dropped when XDP is enabled.
> > > >
> > > > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > > > ---
> > > > Changes in v2:
> > > > - warn only once if extracting the timestamp from a received frame =
fails
> > > >
> > > > Changes in v3:
> > > > - drop received S/G frames when XDP is enabled
> > > >
> > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 158
> > > ++++++++++++++++++++++---
> > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> > > >  2 files changed, 144 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > index 88533a2..102023c 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > @@ -53,6 +53,8 @@
> > > >  #include <linux/dma-mapping.h>
> > > >  #include <linux/sort.h>
> > > >  #include <linux/phy_fixed.h>
> > > > +#include <linux/bpf.h>
> > > > +#include <linux/bpf_trace.h>
> > > >  #include <soc/fsl/bman.h>
> > > >  #include <soc/fsl/qman.h>
> > > >  #include "fman.h"
> > > > @@ -177,7 +179,7 @@
> > > >  #define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE +
> > > DPAA_TIME_STAMP_SIZE \
> > > >  		       + DPAA_HASH_RESULTS_SIZE)
> > > >  #define DPAA_RX_PRIV_DATA_DEFAULT_SIZE
> > > (DPAA_TX_PRIV_DATA_SIZE + \
> > > > -					dpaa_rx_extra_headroom)
> > > > +					XDP_PACKET_HEADROOM -
> > > DPAA_HWA_SIZE)
> > > >  #ifdef CONFIG_DPAA_ERRATUM_A050385
> > > >  #define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN
> -
> > > DPAA_HWA_SIZE)
> > > >  #define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
> > > > @@ -1733,7 +1735,6 @@ static struct sk_buff *contig_fd_to_skb(const
> > > struct dpaa_priv *priv,
> > > >  			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> > > >  	if (WARN_ONCE(!skb, "Build skb failure on Rx\n"))
> > > >  		goto free_buffer;
> > > > -	WARN_ON(fd_off !=3D priv->rx_headroom);
> > > >  	skb_reserve(skb, fd_off);
> > > >  	skb_put(skb, qm_fd_get_length(fd));
> > > >
> > > > @@ -2349,12 +2350,62 @@ static enum qman_cb_dqrr_result
> > > rx_error_dqrr(struct qman_portal *portal,
> > > >  	return qman_cb_dqrr_consume;
> > > >  }
> > > >
> > > > +static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd,
> void
> > > *vaddr,
> > > > +			unsigned int *xdp_meta_len)
> > > > +{
> > > > +	ssize_t fd_off =3D qm_fd_get_offset(fd);
> > > > +	struct bpf_prog *xdp_prog;
> > > > +	struct xdp_buff xdp;
> > > > +	u32 xdp_act;
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	xdp_prog =3D READ_ONCE(priv->xdp_prog);
> > > > +	if (!xdp_prog) {
> > > > +		rcu_read_unlock();
> > > > +		return XDP_PASS;
> > > > +	}
> > > > +
> > > > +	xdp.data =3D vaddr + fd_off;
> > >
> > > I feel like a little drawing of xdp_buff layout would help me with
> > > understanding what is going on over here :)
> >
> > A region at the start of the buffer is reserved for storing hardware
> annotations and room for the XDP_PACKET_HEADROOM, before the actual
> data starts. So vaddr points to the start of the buffer, while fd offset =
provides
> the offset of the data inside the buffer. I don't feel that we are fillin=
g the
> xdp_buff in a majorly different way from other drivers, so please mention
> what is unclear here and I can provide more details.
>=20
> Okay, so fd_off tells me where the frame starts, from vaddr to vaddr +
> fd_off there might be some HW provided data, so you extract it and then
> you are free to go with setting the data_hard_start?

Yes, that's right.

> >
> > > > +	xdp.data_meta =3D xdp.data;
> > > > +	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > > > +	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > > > +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > >
> > > Maybe you could fill xdp_buff outside of this function so that later =
on
> > > you could set xdp.rxq once per napi?
> >
> > I admit I haven't looked into exactly how much performance we would gai=
n
> from this, but I don't think it would be enough to justify the code churn=
. We
> don't have a clean loop for processing the received frames like I see the=
 Intel
> and ENA drivers have.
> >
> > > > +
> > > > +	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > +
> > > > +	/* Update the length and the offset of the FD */
> > > > +	qm_fd_set_contig(fd, xdp.data - vaddr, xdp.data_end - xdp.data);
> > > > +
> > > > +	switch (xdp_act) {
> > > > +	case XDP_PASS:
> > > > +		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> > > > +		break;
> > > > +	default:
> > > > +		bpf_warn_invalid_xdp_action(xdp_act);
> > > > +		fallthrough;
> > > > +	case XDP_ABORTED:
> > > > +		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
> > > > +		fallthrough;
> > > > +	case XDP_DROP:
> > > > +		/* Free the buffer */
> > > > +		free_pages((unsigned long)vaddr, 0);
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	rcu_read_unlock();
> > > > +
> > > > +	return xdp_act;
> > > > +}
> > > > +
> > > >  static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal
> > > *portal,
> > > >  						struct qman_fq *fq,
> > > >  						const struct qm_dqrr_entry
> > > *dq,
> > > >  						bool sched_napi)
> > > >  {
> > > > +	bool ts_valid =3D false, hash_valid =3D false;
> > > >  	struct skb_shared_hwtstamps *shhwtstamps;
> > > > +	unsigned int skb_len, xdp_meta_len =3D 0;
> > > >  	struct rtnl_link_stats64 *percpu_stats;
> > > >  	struct dpaa_percpu_priv *percpu_priv;
> > > >  	const struct qm_fd *fd =3D &dq->fd;
> > > > @@ -2362,12 +2413,14 @@ static enum qman_cb_dqrr_result
> > > rx_default_dqrr(struct qman_portal *portal,
> > > >  	enum qm_fd_format fd_format;
> > > >  	struct net_device *net_dev;
> > > >  	u32 fd_status, hash_offset;
> > > > +	struct qm_sg_entry *sgt;
> > > >  	struct dpaa_bp *dpaa_bp;
> > > >  	struct dpaa_priv *priv;
> > > > -	unsigned int skb_len;
> > > >  	struct sk_buff *skb;
> > > >  	int *count_ptr;
> > > > +	u32 xdp_act;
> > > >  	void *vaddr;
> > > > +	u32 hash;
> > > >  	u64 ns;
> > > >
> > > >  	fd_status =3D be32_to_cpu(fd->status);
> > > > @@ -2423,35 +2476,67 @@ static enum qman_cb_dqrr_result
> > > rx_default_dqrr(struct qman_portal *portal,
> > > >  	count_ptr =3D this_cpu_ptr(dpaa_bp->percpu_count);
> > > >  	(*count_ptr)--;
> > > >
> > > > -	if (likely(fd_format =3D=3D qm_fd_contig))
> > > > +	/* Extract the timestamp stored in the headroom before running
> > > XDP */
> > > > +	if (priv->rx_tstamp) {
> > > > +		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr,
> > > &ns))
> > > > +			ts_valid =3D true;
> > > > +		else
> > > > +			WARN_ONCE(1, "fman_port_get_tstamp failed!\n");
> > > > +	}
> > > > +
> > > > +	/* Extract the hash stored in the headroom before running XDP */
> > > > +	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> > > &&
> > > > +	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> > > > +					      &hash_offset)) {
> > > > +		hash =3D be32_to_cpu(*(u32 *)(vaddr + hash_offset));
> > > > +		hash_valid =3D true;
> > > > +	}
> > > > +
> > > > +	if (likely(fd_format =3D=3D qm_fd_contig)) {
> > > > +		xdp_act =3D dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > > > +				       &xdp_meta_len);
> > > > +		if (xdp_act !=3D XDP_PASS) {
> > > > +			percpu_stats->rx_packets++;
> > > > +			percpu_stats->rx_bytes +=3D qm_fd_get_length(fd);
> > > > +			return qman_cb_dqrr_consume;
> > > > +		}
> > > >  		skb =3D contig_fd_to_skb(priv, fd);
> > > > -	else
> > > > +	} else {
> > > > +		/* XDP doesn't support S/G frames. Return the fragments to
> > > the
> > > > +		 * buffer pool and release the SGT.
> > > > +		 */
> > > > +		if (READ_ONCE(priv->xdp_prog)) {
> > > > +			WARN_ONCE(1, "S/G frames not supported under
> > > XDP\n");
> > > > +			sgt =3D vaddr + qm_fd_get_offset(fd);
> > > > +			dpaa_release_sgt_members(sgt);
> > > > +			free_pages((unsigned long)vaddr, 0);
> > > > +			return qman_cb_dqrr_consume;
> > > > +		}
> > > >  		skb =3D sg_fd_to_skb(priv, fd);
> > > > +	}
> > > >  	if (!skb)
> > > >  		return qman_cb_dqrr_consume;
> > > >
> > > > -	if (priv->rx_tstamp) {
> > > > +	if (xdp_meta_len)
> > > > +		skb_metadata_set(skb, xdp_meta_len);
> > >
> > > This is working on a single buffer, right? So there's no need to clea=
r
> > > xdp_meta_len?
> >
> > I don't think I understand what you mean. Are you saying I shouldn't be
> initializing xdp_meta_len to 0? This receive path is used when XDP is dis=
abled
> as well, in which case we don't propagate the metadata.
>=20
> What I meant was that if this function would operate on many buffers then
> we would have to clear the xdp_meta_len, so that next buffers wouldn't ge=
t
> the value from previous bufs, but I suppose that this rx_default_dqrr
> callback is called once per each buffer.

Yes, rx_default_dqrr is processing only one buffer.

> >
> > > > +
> > > > +	/* Set the previously extracted timestamp */
> > > > +	if (ts_valid) {
> > > >  		shhwtstamps =3D skb_hwtstamps(skb);
> > > >  		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> > > > -
> > > > -		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr,
> > > &ns))
> > > > -			shhwtstamps->hwtstamp =3D ns_to_ktime(ns);
> > > > -		else
> > > > -			dev_warn(net_dev->dev.parent,
> > > "fman_port_get_tstamp failed!\n");
> > > > +		shhwtstamps->hwtstamp =3D ns_to_ktime(ns);
> > > >  	}
> > > >
> > > >  	skb->protocol =3D eth_type_trans(skb, net_dev);
> > > >
> > > > -	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use
> > > &&
> > > > -	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
> > > > -					      &hash_offset)) {
> > > > +	/* Set the previously extracted hash */
> > > > +	if (hash_valid) {
> > > >  		enum pkt_hash_types type;
> > > >
> > > >  		/* if L4 exists, it was used in the hash generation */
> > > >  		type =3D be32_to_cpu(fd->status) & FM_FD_STAT_L4CV ?
> > > >  			PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3;
> > > > -		skb_set_hash(skb, be32_to_cpu(*(u32 *)(vaddr +
> > > hash_offset)),
> > > > -			     type);
> > > > +		skb_set_hash(skb, hash, type);
> > > >  	}
> > > >
> > > >  	skb_len =3D skb->len;
> > > > @@ -2671,6 +2756,46 @@ static int dpaa_eth_stop(struct net_device
> > > *net_dev)
> > > >  	return err;
> > > >  }
