Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51B2D644F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392967AbgLJSB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:01:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388530AbgLJSBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 13:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607623195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eF9fTYUtMiapZZq2pWe0s4I0eBAl1njblSx8YPZPVc0=;
        b=NgWB3sGnt08q7V9ooCHifEyxa3Iid067P611anzCKaeS3VG+ejWT5D4TB7KWge+aomWHcP
        mWjQ+g3VMM7VUcNXXpRYelUAQXSH6T/EXJYwZt2jlDttDcRMhVL1u4cDi5jWmx1EOh4myW
        twLzyY4BbaWfvFL3KBy4nrr8aOCZdfo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-SX358NyHNhapLwVasoPWhg-1; Thu, 10 Dec 2020 12:59:52 -0500
X-MC-Unique: SX358NyHNhapLwVasoPWhg-1
Received: by mail-wr1-f70.google.com with SMTP id g16so918539wrv.1
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eF9fTYUtMiapZZq2pWe0s4I0eBAl1njblSx8YPZPVc0=;
        b=kAgGtWLlkK7nxSb29Dbtsfqm8oDJEIg0zncT8E7JS9Wvx9Gp4v7RKybrgEnKlycbYQ
         NsYquGq16qAgEb9NfDsREOpwOqSoD+vi/9Ygl6DbbwXc9TKMKdBBA6ZfPLOvumbwCSvK
         zQdGsqx6s/z5oAqqaMMN8Nx4We1vi6EpSz08db1/cxwKFG3/xJm/7Wp78dF1NSkFw4kC
         dtjl2rMROcGIs/YQ+La/KDQQy6fFGE0hXVHYw04tcLcKWWZpo+xTzX/qf0RXJY9dWhTB
         1TLREcQAcRWTcnHNHeby7KRmIa5t5IbzLlc8CgPRAY3uX3KHfKyospuBxQBzXZJnU8Er
         FDbA==
X-Gm-Message-State: AOAM531BVvxXNpf0Av2wRVuhhbRs5+QIQfD6VNCRmM4RMKTRMuEcXlwL
        OzNvgSyUXneRd4x9KIVFGIAPALSPZ7ZvZHJMH9NlFn/f62FoZcED7IS01PvOiaIaxF25Kw+qNEv
        jT2aC/Yziwano4/3/
X-Received: by 2002:a1c:ba44:: with SMTP id k65mr9452411wmf.188.1607623190211;
        Thu, 10 Dec 2020 09:59:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMZoIjCfLn+W0ygwJrEM9K9x5uhElzFIeLXtS/SCbic3X097ADPF1xiDenFfMDyhLXrivDeA==
X-Received: by 2002:a1c:ba44:: with SMTP id k65mr9452380wmf.188.1607623189815;
        Thu, 10 Dec 2020 09:59:49 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id l11sm10080116wmh.46.2020.12.10.09.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 09:59:49 -0800 (PST)
Date:   Thu, 10 Dec 2020 18:59:45 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org
Subject: Re: [PATCH bpf-next] net: xdp: introduce xdp_init_buff utility
 routine
Message-ID: <20201210175945.GB462213@lore-desk>
References: <e54fb61ff17c21f022392f1bb46ec951c9b909cc.1607615094.git.lorenzo@kernel.org>
 <20201210160507.GC45760@ranger.igk.intel.com>
 <20201210163241.GA462213@lore-desk>
 <20201210165556.GA46492@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20201210165556.GA46492@ranger.igk.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Dec 10, Maciej Fijalkowski wrote:
> On Thu, Dec 10, 2020 at 05:32:41PM +0100, Lorenzo Bianconi wrote:
> > > On Thu, Dec 10, 2020 at 04:50:42PM +0100, Lorenzo Bianconi wrote:
> > > > Introduce xdp_init_buff utility routine to initialize xdp_buff data
> > > > structure. Rely on xdp_init_buff in all XDP capable drivers.
> > >=20
> > > Hm, Jesper was suggesting two helpers, one that you implemented for t=
hings
> > > that are set once per NAPI and the other that is set per each buffer.
> > >=20
> > > Not sure about the naming for a second one - xdp_prepare_buff ?
> > > xdp_init_buff that you have feels ok.
> >=20
> > ack, so we can have xdp_init_buff() for initialization done once per NA=
PI run and=20
> > xdp_prepare_buff() for per-NAPI iteration initialization, e.g.
> >=20
> > static inline void
> > xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > 		 int headroom, int data_len)
> > {
> > 	xdp->data_hard_start =3D hard_start;
> > 	xdp->data =3D hard_start + headroom;
> > 	xdp->data_end =3D xdp->data + data_len;
> > 	xdp_set_data_meta_invalid(xdp);
> > }
>=20
> I think we should allow for setting the data_meta as well.
> x64 calling convention states that first four args are placed onto
> registers, so to keep it fast maybe have a third helper:
>=20
> static inline void
> xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char *hard_start,
> 		      int headroom, int data_len)
> {
> 	xdp->data_hard_start =3D hard_start;
> 	xdp->data =3D hard_start + headroom;
> 	xdp->data_end =3D xdp->data + data_len;
> 	xdp->data_meta =3D xdp->data;
> }
>=20
> Thoughts?

ack, I am fine with it. Let's wait for some feedback.

Do you prefer to have xdp_prepare_buff/xdp_prepare_buff_meta in the same se=
ries
of xdp_buff_init() or is it ok to address it in a separate patch?

Regards,
Lorenzo

>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/amazon/ena/ena_netdev.c        | 3 +--
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 3 +--
> > > >  drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 4 ++--
> > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c      | 4 ++--
> > > >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 8 ++++----
> > > >  drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 6 +++---
> > > >  drivers/net/ethernet/intel/ice/ice_txrx.c           | 6 +++---
> > > >  drivers/net/ethernet/intel/igb/igb_main.c           | 6 +++---
> > > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 7 +++----
> > > >  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 7 +++----
> > > >  drivers/net/ethernet/marvell/mvneta.c               | 3 +--
> > > >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 8 +++++---
> > > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 3 +--
> > > >  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 3 +--
> > > >  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++--
> > > >  drivers/net/ethernet/qlogic/qede/qede_fp.c          | 3 +--
> > > >  drivers/net/ethernet/sfc/rx.c                       | 3 +--
> > > >  drivers/net/ethernet/socionext/netsec.c             | 3 +--
> > > >  drivers/net/ethernet/ti/cpsw.c                      | 4 ++--
> > > >  drivers/net/ethernet/ti/cpsw_new.c                  | 4 ++--
> > > >  drivers/net/hyperv/netvsc_bpf.c                     | 3 +--
> > > >  drivers/net/tun.c                                   | 7 +++----
> > > >  drivers/net/veth.c                                  | 8 ++++----
> > > >  drivers/net/virtio_net.c                            | 6 ++----
> > > >  drivers/net/xen-netfront.c                          | 4 ++--
> > > >  include/net/xdp.h                                   | 7 +++++++
> > > >  net/bpf/test_run.c                                  | 4 ++--
> > > >  net/core/dev.c                                      | 8 ++++----
> > > >  28 files changed, 67 insertions(+), 72 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers=
/net/ethernet/amazon/ena/ena_netdev.c
> > > > index 0e98f45c2b22..338dce73927e 100644
> > > > --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > > > +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > > > @@ -1567,8 +1567,7 @@ static int ena_clean_rx_irq(struct ena_ring *=
rx_ring, struct napi_struct *napi,
> > > >  	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
> > > >  		  "%s qid %d\n", __func__, rx_ring->qid);
> > > >  	res_budget =3D budget;
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > > -	xdp.frame_sz =3D ENA_PAGE_SIZE;
> > > > +	xdp_init_buff(&xdp, ENA_PAGE_SIZE, &rx_ring->xdp_rxq);
> > > > =20
> > > >  	do {
> > > >  		xdp_verdict =3D XDP_PASS;
> > > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/driver=
s/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > > > index fcc262064766..b7942c3440c0 100644
> > > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > > > @@ -133,12 +133,11 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt=
_rx_ring_info *rxr, u16 cons,
> > > >  	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->r=
x_dir);
> > > > =20
> > > >  	txr =3D rxr->bnapi->tx_ring;
> > > > +	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
> > > >  	xdp.data_hard_start =3D *data_ptr - offset;
> > > >  	xdp.data =3D *data_ptr;
> > > >  	xdp_set_data_meta_invalid(&xdp);
> > > >  	xdp.data_end =3D *data_ptr + *len;
> > > > -	xdp.rxq =3D &rxr->xdp_rxq;
> > > > -	xdp.frame_sz =3D PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP ena=
bled */
> > > >  	orig_data =3D xdp.data;
> > > > =20
> > > >  	rcu_read_lock();
> > > > diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/dri=
vers/net/ethernet/cavium/thunder/nicvf_main.c
> > > > index f3b7b443f964..9fc672f075f2 100644
> > > > --- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> > > > +++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> > > > @@ -547,12 +547,12 @@ static inline bool nicvf_xdp_rx(struct nicvf =
*nic, struct bpf_prog *prog,
> > > >  	cpu_addr =3D (u64)phys_to_virt(cpu_addr);
> > > >  	page =3D virt_to_page((void *)cpu_addr);
> > > > =20
> > > > +	xdp_init_buff(&xdp, RCV_FRAG_LEN + XDP_PACKET_HEADROOM,
> > > > +		      &rq->xdp_rxq);
> > > >  	xdp.data_hard_start =3D page_address(page);
> > > >  	xdp.data =3D (void *)cpu_addr;
> > > >  	xdp_set_data_meta_invalid(&xdp);
> > > >  	xdp.data_end =3D xdp.data + len;
> > > > -	xdp.rxq =3D &rq->xdp_rxq;
> > > > -	xdp.frame_sz =3D RCV_FRAG_LEN + XDP_PACKET_HEADROOM;
> > > >  	orig_data =3D xdp.data;
> > > > =20
> > > >  	rcu_read_lock();
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drive=
rs/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > index e28510c282e5..93030000e0aa 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > @@ -2536,12 +2536,12 @@ static u32 dpaa_run_xdp(struct dpaa_priv *p=
riv, struct qm_fd *fd, void *vaddr,
> > > >  		return XDP_PASS;
> > > >  	}
> > > > =20
> > > > +	xdp_init_buff(&xdp, DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE,
> > > > +		      &dpaa_fq->xdp_rxq);
> > > >  	xdp.data =3D vaddr + fd_off;
> > > >  	xdp.data_meta =3D xdp.data;
> > > >  	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > > >  	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > > > -	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > > > -	xdp.rxq =3D &dpaa_fq->xdp_rxq;
> > > > =20
> > > >  	/* We reserve a fixed headroom of 256 bytes under the erratum and=
 we
> > > >  	 * offer it all to XDP programs to use. If no room is left for the
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/dri=
vers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > index 91cff93dbdae..a4ade0b5adb0 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > @@ -358,14 +358,14 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth=
_priv *priv,
> > > >  	if (!xdp_prog)
> > > >  		goto out;
> > > > =20
> > > > +	xdp_init_buff(&xdp,
> > > > +		      DPAA2_ETH_RX_BUF_RAW_SIZE -
> > > > +		      (dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM),
> > > > +		      &ch->xdp_rxq);
> > > >  	xdp.data =3D vaddr + dpaa2_fd_get_offset(fd);
> > > >  	xdp.data_end =3D xdp.data + dpaa2_fd_get_len(fd);
> > > >  	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > > >  	xdp_set_data_meta_invalid(&xdp);
> > > > -	xdp.rxq =3D &ch->xdp_rxq;
> > > > -
> > > > -	xdp.frame_sz =3D DPAA2_ETH_RX_BUF_RAW_SIZE -
> > > > -		(dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM);
> > > > =20
> > > >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > =20
> > > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/=
net/ethernet/intel/i40e/i40e_txrx.c
> > > > index 9f73cd7aee09..4dbbbd49c389 100644
> > > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > @@ -2332,7 +2332,7 @@ static void i40e_inc_ntc(struct i40e_ring *rx=
_ring)
> > > >   **/
> > > >  static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
> > > >  {
> > > > -	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
> > > > +	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0, frame_=
sz =3D 0;
> > > >  	struct sk_buff *skb =3D rx_ring->skb;
> > > >  	u16 cleaned_count =3D I40E_DESC_UNUSED(rx_ring);
> > > >  	unsigned int xdp_xmit =3D 0;
> > > > @@ -2340,9 +2340,9 @@ static int i40e_clean_rx_irq(struct i40e_ring=
 *rx_ring, int budget)
> > > >  	struct xdp_buff xdp;
> > > > =20
> > > >  #if (PAGE_SIZE < 8192)
> > > > -	xdp.frame_sz =3D i40e_rx_frame_truesize(rx_ring, 0);
> > > > +	frame_sz =3D i40e_rx_frame_truesize(rx_ring, 0);
> > > >  #endif
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > > +	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
> > > > =20
> > > >  	while (likely(total_rx_packets < (unsigned int)budget)) {
> > > >  		struct i40e_rx_buffer *rx_buffer;
> > > > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/ne=
t/ethernet/intel/ice/ice_txrx.c
> > > > index 77d5eae6b4c2..d52d98d56367 100644
> > > > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > > > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > > > @@ -1077,18 +1077,18 @@ ice_is_non_eop(struct ice_ring *rx_ring, un=
ion ice_32b_rx_flex_desc *rx_desc,
> > > >   */
> > > >  int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
> > > >  {
> > > > -	unsigned int total_rx_bytes =3D 0, total_rx_pkts =3D 0;
> > > > +	unsigned int total_rx_bytes =3D 0, total_rx_pkts =3D 0, frame_sz =
=3D 0;
> > > >  	u16 cleaned_count =3D ICE_DESC_UNUSED(rx_ring);
> > > >  	unsigned int xdp_res, xdp_xmit =3D 0;
> > > >  	struct bpf_prog *xdp_prog =3D NULL;
> > > >  	struct xdp_buff xdp;
> > > >  	bool failure;
> > > > =20
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > >  	/* Frame size depend on rx_ring setup when PAGE_SIZE=3D4K */
> > > >  #if (PAGE_SIZE < 8192)
> > > > -	xdp.frame_sz =3D ice_rx_frame_truesize(rx_ring, 0);
> > > > +	frame_sz =3D ice_rx_frame_truesize(rx_ring, 0);
> > > >  #endif
> > > > +	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
> > > > =20
> > > >  	/* start the loop to process Rx packets bounded by 'budget' */
> > > >  	while (likely(total_rx_pkts < (unsigned int)budget)) {
> > > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/ne=
t/ethernet/intel/igb/igb_main.c
> > > > index 6a4ef4934fcf..365dfc0e3b65 100644
> > > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > @@ -8666,13 +8666,13 @@ static int igb_clean_rx_irq(struct igb_q_ve=
ctor *q_vector, const int budget)
> > > >  	u16 cleaned_count =3D igb_desc_unused(rx_ring);
> > > >  	unsigned int xdp_xmit =3D 0;
> > > >  	struct xdp_buff xdp;
> > > > -
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > > +	u32 frame_sz =3D 0;
> > > > =20
> > > >  	/* Frame size depend on rx_ring setup when PAGE_SIZE=3D4K */
> > > >  #if (PAGE_SIZE < 8192)
> > > > -	xdp.frame_sz =3D igb_rx_frame_truesize(rx_ring, 0);
> > > > +	frame_sz =3D igb_rx_frame_truesize(rx_ring, 0);
> > > >  #endif
> > > > +	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
> > > > =20
> > > >  	while (likely(total_packets < budget)) {
> > > >  		union e1000_adv_rx_desc *rx_desc;
> > > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/driver=
s/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > > index 50e6b8b6ba7b..dcd49cfa36f7 100644
> > > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > > @@ -2282,7 +2282,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_=
vector *q_vector,
> > > >  			       struct ixgbe_ring *rx_ring,
> > > >  			       const int budget)
> > > >  {
> > > > -	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
> > > > +	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0, frame_=
sz =3D 0;
> > > >  	struct ixgbe_adapter *adapter =3D q_vector->adapter;
> > > >  #ifdef IXGBE_FCOE
> > > >  	int ddp_bytes;
> > > > @@ -2292,12 +2292,11 @@ static int ixgbe_clean_rx_irq(struct ixgbe_=
q_vector *q_vector,
> > > >  	unsigned int xdp_xmit =3D 0;
> > > >  	struct xdp_buff xdp;
> > > > =20
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > > -
> > > >  	/* Frame size depend on rx_ring setup when PAGE_SIZE=3D4K */
> > > >  #if (PAGE_SIZE < 8192)
> > > > -	xdp.frame_sz =3D ixgbe_rx_frame_truesize(rx_ring, 0);
> > > > +	frame_sz =3D ixgbe_rx_frame_truesize(rx_ring, 0);
> > > >  #endif
> > > > +	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
> > > > =20
> > > >  	while (likely(total_rx_packets < budget)) {
> > > >  		union ixgbe_adv_rx_desc *rx_desc;
> > > > diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/dr=
ivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> > > > index 4061cd7db5dd..624efcd71569 100644
> > > > --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> > > > +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> > > > @@ -1121,19 +1121,18 @@ static int ixgbevf_clean_rx_irq(struct ixgb=
evf_q_vector *q_vector,
> > > >  				struct ixgbevf_ring *rx_ring,
> > > >  				int budget)
> > > >  {
> > > > -	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
> > > > +	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0, frame_=
sz =3D 0;
> > > >  	struct ixgbevf_adapter *adapter =3D q_vector->adapter;
> > > >  	u16 cleaned_count =3D ixgbevf_desc_unused(rx_ring);
> > > >  	struct sk_buff *skb =3D rx_ring->skb;
> > > >  	bool xdp_xmit =3D false;
> > > >  	struct xdp_buff xdp;
> > > > =20
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > > -
> > > >  	/* Frame size depend on rx_ring setup when PAGE_SIZE=3D4K */
> > > >  #if (PAGE_SIZE < 8192)
> > > > -	xdp.frame_sz =3D ixgbevf_rx_frame_truesize(rx_ring, 0);
> > > > +	frame_sz =3D ixgbevf_rx_frame_truesize(rx_ring, 0);
> > > >  #endif
> > > > +	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
> > > > =20
> > > >  	while (likely(total_rx_packets < budget)) {
> > > >  		struct ixgbevf_rx_buffer *rx_buffer;
> > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/et=
hernet/marvell/mvneta.c
> > > > index 563ceac3060f..acbb9cb85ada 100644
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > @@ -2363,9 +2363,8 @@ static int mvneta_rx_swbm(struct napi_struct =
*napi,
> > > >  	u32 desc_status, frame_sz;
> > > >  	struct xdp_buff xdp_buf;
> > > > =20
> > > > +	xdp_init_buff(&xdp_buf, PAGE_SIZE, &rxq->xdp_rxq);
> > > >  	xdp_buf.data_hard_start =3D NULL;
> > > > -	xdp_buf.frame_sz =3D PAGE_SIZE;
> > > > -	xdp_buf.rxq =3D &rxq->xdp_rxq;
> > > > =20
> > > >  	sinfo.nr_frags =3D 0;
> > > > =20
> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/driv=
ers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > index afdd22827223..ca05dfc05058 100644
> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > @@ -3562,16 +3562,18 @@ static int mvpp2_rx(struct mvpp2_port *port=
, struct napi_struct *napi,
> > > >  			frag_size =3D bm_pool->frag_size;
> > > > =20
> > > >  		if (xdp_prog) {
> > > > +			struct xdp_rxq_info *xdp_rxq;
> > > > +
> > > >  			xdp.data_hard_start =3D data;
> > > >  			xdp.data =3D data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> > > >  			xdp.data_end =3D xdp.data + rx_bytes;
> > > > -			xdp.frame_sz =3D PAGE_SIZE;
> > > > =20
> > > >  			if (bm_pool->pkt_size =3D=3D MVPP2_BM_SHORT_PKT_SIZE)
> > > > -				xdp.rxq =3D &rxq->xdp_rxq_short;
> > > > +				xdp_rxq =3D &rxq->xdp_rxq_short;
> > > >  			else
> > > > -				xdp.rxq =3D &rxq->xdp_rxq_long;
> > > > +				xdp_rxq =3D &rxq->xdp_rxq_long;
> > > > =20
> > > > +			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
> > > >  			xdp_set_data_meta_invalid(&xdp);
> > > > =20
> > > >  			ret =3D mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/n=
et/ethernet/mellanox/mlx4/en_rx.c
> > > > index 7954c1daf2b6..815381b484ca 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > > > @@ -682,8 +682,7 @@ int mlx4_en_process_rx_cq(struct net_device *de=
v, struct mlx4_en_cq *cq, int bud
> > > >  	/* Protect accesses to: ring->xdp_prog, priv->mac_hash list */
> > > >  	rcu_read_lock();
> > > >  	xdp_prog =3D rcu_dereference(ring->xdp_prog);
> > > > -	xdp.rxq =3D &ring->xdp_rxq;
> > > > -	xdp.frame_sz =3D priv->frag_info[0].frag_stride;
> > > > +	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rx=
q);
> > > >  	doorbell_pending =3D false;
> > > > =20
> > > >  	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > > > index 6628a0197b4e..c68628b1f30b 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > > > @@ -1127,12 +1127,11 @@ struct sk_buff *mlx5e_build_linear_skb(stru=
ct mlx5e_rq *rq, void *va,
> > > >  static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16=
 headroom,
> > > >  				u32 len, struct xdp_buff *xdp)
> > > >  {
> > > > +	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
> > > >  	xdp->data_hard_start =3D va;
> > > >  	xdp->data =3D va + headroom;
> > > >  	xdp_set_data_meta_invalid(xdp);
> > > >  	xdp->data_end =3D xdp->data + len;
> > > > -	xdp->rxq =3D &rq->xdp_rxq;
> > > > -	xdp->frame_sz =3D rq->buff.frame0_sz;
> > > >  }
> > > > =20
> > > >  static struct sk_buff *
> > > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/=
drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > > index b4acf2f41e84..68e03e8257f2 100644
> > > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > > @@ -1822,8 +1822,8 @@ static int nfp_net_rx(struct nfp_net_rx_ring =
*rx_ring, int budget)
> > > >  	rcu_read_lock();
> > > >  	xdp_prog =3D READ_ONCE(dp->xdp_prog);
> > > >  	true_bufsz =3D xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
> > > > -	xdp.frame_sz =3D PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM;
> > > > -	xdp.rxq =3D &rx_ring->xdp_rxq;
> > > > +	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
> > > > +		      &rx_ring->xdp_rxq);
> > > >  	tx_ring =3D r_vec->xdp_ring;
> > > > =20
> > > >  	while (pkts_polled < budget) {
> > > > diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/n=
et/ethernet/qlogic/qede/qede_fp.c
> > > > index a2494bf85007..d40220043883 100644
> > > > --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > > > +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > > > @@ -1090,12 +1090,11 @@ static bool qede_rx_xdp(struct qede_dev *ed=
ev,
> > > >  	struct xdp_buff xdp;
> > > >  	enum xdp_action act;
> > > > =20
> > > > +	xdp_init_buff(&xdp, rxq->rx_buf_seg_size, &rxq->xdp_rxq);
> > > >  	xdp.data_hard_start =3D page_address(bd->data);
> > > >  	xdp.data =3D xdp.data_hard_start + *data_offset;
> > > >  	xdp_set_data_meta_invalid(&xdp);
> > > >  	xdp.data_end =3D xdp.data + *len;
> > > > -	xdp.rxq =3D &rxq->xdp_rxq;
> > > > -	xdp.frame_sz =3D rxq->rx_buf_seg_size; /* PAGE_SIZE when XDP enab=
led */
> > > > =20
> > > >  	/* Queues always have a full reset currently, so for the time
> > > >  	 * being until there's atomic program replace just mark read
> > > > diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/s=
fc/rx.c
> > > > index aaa112877561..eaa6650955d1 100644
> > > > --- a/drivers/net/ethernet/sfc/rx.c
> > > > +++ b/drivers/net/ethernet/sfc/rx.c
> > > > @@ -293,14 +293,13 @@ static bool efx_do_xdp(struct efx_nic *efx, s=
truct efx_channel *channel,
> > > >  	memcpy(rx_prefix, *ehp - efx->rx_prefix_size,
> > > >  	       efx->rx_prefix_size);
> > > > =20
> > > > +	xdp_init_buff(&xdp, efx->rx_page_buf_step, &rx_queue->xdp_rxq_inf=
o);
> > > >  	xdp.data =3D *ehp;
> > > >  	xdp.data_hard_start =3D xdp.data - EFX_XDP_HEADROOM;
> > > > =20
> > > >  	/* No support yet for XDP metadata */
> > > >  	xdp_set_data_meta_invalid(&xdp);
> > > >  	xdp.data_end =3D xdp.data + rx_buf->len;
> > > > -	xdp.rxq =3D &rx_queue->xdp_rxq_info;
> > > > -	xdp.frame_sz =3D efx->rx_page_buf_step;
> > > > =20
> > > >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >  	rcu_read_unlock();
> > > > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/=
ethernet/socionext/netsec.c
> > > > index 19d20a6d0d44..945ca9517bf9 100644
> > > > --- a/drivers/net/ethernet/socionext/netsec.c
> > > > +++ b/drivers/net/ethernet/socionext/netsec.c
> > > > @@ -956,8 +956,7 @@ static int netsec_process_rx(struct netsec_priv=
 *priv, int budget)
> > > >  	u32 xdp_act =3D 0;
> > > >  	int done =3D 0;
> > > > =20
> > > > -	xdp.rxq =3D &dring->xdp_rxq;
> > > > -	xdp.frame_sz =3D PAGE_SIZE;
> > > > +	xdp_init_buff(&xdp, PAGE_SIZE, &dring->xdp_rxq);
> > > > =20
> > > >  	rcu_read_lock();
> > > >  	xdp_prog =3D READ_ONCE(priv->xdp_prog);
> > > > diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/=
ti/cpsw.c
> > > > index b0f00b4edd94..78a923391828 100644
> > > > --- a/drivers/net/ethernet/ti/cpsw.c
> > > > +++ b/drivers/net/ethernet/ti/cpsw.c
> > > > @@ -392,6 +392,8 @@ static void cpsw_rx_handler(void *token, int le=
n, int status)
> > > >  	}
> > > > =20
> > > >  	if (priv->xdp_prog) {
> > > > +		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
> > > > +
> > > >  		if (status & CPDMA_RX_VLAN_ENCAP) {
> > > >  			xdp.data =3D pa + CPSW_HEADROOM +
> > > >  				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > > > @@ -405,8 +407,6 @@ static void cpsw_rx_handler(void *token, int le=
n, int status)
> > > >  		xdp_set_data_meta_invalid(&xdp);
> > > > =20
> > > >  		xdp.data_hard_start =3D pa;
> > > > -		xdp.rxq =3D &priv->xdp_rxq[ch];
> > > > -		xdp.frame_sz =3D PAGE_SIZE;
> > > > =20
> > > >  		port =3D priv->emac_port + cpsw->data.dual_emac;
> > > >  		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, port);
> > > > diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ether=
net/ti/cpsw_new.c
> > > > index 2f5e0ad23ad7..1b3385ec9645 100644
> > > > --- a/drivers/net/ethernet/ti/cpsw_new.c
> > > > +++ b/drivers/net/ethernet/ti/cpsw_new.c
> > > > @@ -335,6 +335,8 @@ static void cpsw_rx_handler(void *token, int le=
n, int status)
> > > >  	}
> > > > =20
> > > >  	if (priv->xdp_prog) {
> > > > +		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
> > > > +
> > > >  		if (status & CPDMA_RX_VLAN_ENCAP) {
> > > >  			xdp.data =3D pa + CPSW_HEADROOM +
> > > >  				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > > > @@ -348,8 +350,6 @@ static void cpsw_rx_handler(void *token, int le=
n, int status)
> > > >  		xdp_set_data_meta_invalid(&xdp);
> > > > =20
> > > >  		xdp.data_hard_start =3D pa;
> > > > -		xdp.rxq =3D &priv->xdp_rxq[ch];
> > > > -		xdp.frame_sz =3D PAGE_SIZE;
> > > > =20
> > > >  		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
> > > >  		if (ret !=3D CPSW_XDP_PASS)
> > > > diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/n=
etvsc_bpf.c
> > > > index 440486d9c999..14a7ee4c6899 100644
> > > > --- a/drivers/net/hyperv/netvsc_bpf.c
> > > > +++ b/drivers/net/hyperv/netvsc_bpf.c
> > > > @@ -44,12 +44,11 @@ u32 netvsc_run_xdp(struct net_device *ndev, str=
uct netvsc_channel *nvchan,
> > > >  		goto out;
> > > >  	}
> > > > =20
> > > > +	xdp_init_buff(xdp, PAGE_SIZE, &nvchan->xdp_rxq);
> > > >  	xdp->data_hard_start =3D page_address(page);
> > > >  	xdp->data =3D xdp->data_hard_start + NETVSC_XDP_HDRM;
> > > >  	xdp_set_data_meta_invalid(xdp);
> > > >  	xdp->data_end =3D xdp->data + len;
> > > > -	xdp->rxq =3D &nvchan->xdp_rxq;
> > > > -	xdp->frame_sz =3D PAGE_SIZE;
> > > > =20
> > > >  	memcpy(xdp->data, data, len);
> > > > =20
> > > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > > index fbed05ae7b0f..a82f7823d428 100644
> > > > --- a/drivers/net/tun.c
> > > > +++ b/drivers/net/tun.c
> > > > @@ -1599,12 +1599,11 @@ static struct sk_buff *tun_build_skb(struct=
 tun_struct *tun,
> > > >  		struct xdp_buff xdp;
> > > >  		u32 act;
> > > > =20
> > > > +		xdp_init_buff(&xdp, buflen, &tfile->xdp_rxq);
> > > >  		xdp.data_hard_start =3D buf;
> > > >  		xdp.data =3D buf + pad;
> > > >  		xdp_set_data_meta_invalid(&xdp);
> > > >  		xdp.data_end =3D xdp.data + len;
> > > > -		xdp.rxq =3D &tfile->xdp_rxq;
> > > > -		xdp.frame_sz =3D buflen;
> > > > =20
> > > >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >  		if (act =3D=3D XDP_REDIRECT || act =3D=3D XDP_TX) {
> > > > @@ -2344,9 +2343,9 @@ static int tun_xdp_one(struct tun_struct *tun,
> > > >  			skb_xdp =3D true;
> > > >  			goto build;
> > > >  		}
> > > > +
> > > > +		xdp_init_buff(xdp, buflen, &tfile->xdp_rxq);
> > > >  		xdp_set_data_meta_invalid(xdp);
> > > > -		xdp->rxq =3D &tfile->xdp_rxq;
> > > > -		xdp->frame_sz =3D buflen;
> > > > =20
> > > >  		act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> > > >  		err =3D tun_xdp_act(tun, xdp_prog, xdp, act);
> > > > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > > > index 02bfcdf50a7a..25f3601fb6dd 100644
> > > > --- a/drivers/net/veth.c
> > > > +++ b/drivers/net/veth.c
> > > > @@ -654,7 +654,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct =
veth_rq *rq,
> > > >  					struct veth_xdp_tx_bq *bq,
> > > >  					struct veth_stats *stats)
> > > >  {
> > > > -	u32 pktlen, headroom, act, metalen;
> > > > +	u32 pktlen, headroom, act, metalen, frame_sz;
> > > >  	void *orig_data, *orig_data_end;
> > > >  	struct bpf_prog *xdp_prog;
> > > >  	int mac_len, delta, off;
> > > > @@ -714,11 +714,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struc=
t veth_rq *rq,
> > > >  	xdp.data =3D skb_mac_header(skb);
> > > >  	xdp.data_end =3D xdp.data + pktlen;
> > > >  	xdp.data_meta =3D xdp.data;
> > > > -	xdp.rxq =3D &rq->xdp_rxq;
> > > > =20
> > > >  	/* SKB "head" area always have tailroom for skb_shared_info */
> > > > -	xdp.frame_sz =3D (void *)skb_end_pointer(skb) - xdp.data_hard_sta=
rt;
> > > > -	xdp.frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > +	frame_sz =3D (void *)skb_end_pointer(skb) - xdp.data_hard_start;
> > > > +	frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > +	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> > > > =20
> > > >  	orig_data =3D xdp.data;
> > > >  	orig_data_end =3D xdp.data_end;
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 052975ea0af4..a22ce87bcd9c 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -689,12 +689,11 @@ static struct sk_buff *receive_small(struct n=
et_device *dev,
> > > >  			page =3D xdp_page;
> > > >  		}
> > > > =20
> > > > +		xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> > > >  		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
> > > >  		xdp.data =3D xdp.data_hard_start + xdp_headroom;
> > > >  		xdp.data_end =3D xdp.data + len;
> > > >  		xdp.data_meta =3D xdp.data;
> > > > -		xdp.rxq =3D &rq->xdp_rxq;
> > > > -		xdp.frame_sz =3D buflen;
> > > >  		orig_data =3D xdp.data;
> > > >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >  		stats->xdp_packets++;
> > > > @@ -859,12 +858,11 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >  		 * the descriptor on if we get an XDP_TX return code.
> > > >  		 */
> > > >  		data =3D page_address(xdp_page) + offset;
> > > > +		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
> > > >  		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
> > > >  		xdp.data =3D data + vi->hdr_len;
> > > >  		xdp.data_end =3D xdp.data + (len - vi->hdr_len);
> > > >  		xdp.data_meta =3D xdp.data;
> > > > -		xdp.rxq =3D &rq->xdp_rxq;
> > > > -		xdp.frame_sz =3D frame_sz - vi->hdr_len;
> > > > =20
> > > >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >  		stats->xdp_packets++;
> > > > diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> > > > index b01848ef4649..329397c60d84 100644
> > > > --- a/drivers/net/xen-netfront.c
> > > > +++ b/drivers/net/xen-netfront.c
> > > > @@ -864,12 +864,12 @@ static u32 xennet_run_xdp(struct netfront_que=
ue *queue, struct page *pdata,
> > > >  	u32 act;
> > > >  	int err;
> > > > =20
> > > > +	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> > > > +		      &queue->xdp_rxq);
> > > >  	xdp->data_hard_start =3D page_address(pdata);
> > > >  	xdp->data =3D xdp->data_hard_start + XDP_PACKET_HEADROOM;
> > > >  	xdp_set_data_meta_invalid(xdp);
> > > >  	xdp->data_end =3D xdp->data + len;
> > > > -	xdp->rxq =3D &queue->xdp_rxq;
> > > > -	xdp->frame_sz =3D XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
> > > > =20
> > > >  	act =3D bpf_prog_run_xdp(prog, xdp);
> > > >  	switch (act) {
> > > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > > index 700ad5db7f5d..3fb3a9aa1b71 100644
> > > > --- a/include/net/xdp.h
> > > > +++ b/include/net/xdp.h
> > > > @@ -76,6 +76,13 @@ struct xdp_buff {
> > > >  	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tail=
room*/
> > > >  };
> > > > =20
> > > > +static inline void
> > > > +xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_i=
nfo *rxq)
> > > > +{
> > > > +	xdp->frame_sz =3D frame_sz;
> > > > +	xdp->rxq =3D rxq;
> > > > +}
> > > > +
> > > >  /* Reserve memory area at end-of data area.
> > > >   *
> > > >   * This macro reserves tailroom in the XDP buffer by limiting the
> > > > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > > > index c1c30a9f76f3..a8fa5a9e4137 100644
> > > > --- a/net/bpf/test_run.c
> > > > +++ b/net/bpf/test_run.c
> > > > @@ -640,10 +640,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *pr=
og, const union bpf_attr *kattr,
> > > >  	xdp.data =3D data + headroom;
> > > >  	xdp.data_meta =3D xdp.data;
> > > >  	xdp.data_end =3D xdp.data + size;
> > > > -	xdp.frame_sz =3D headroom + max_data_sz + tailroom;
> > > > =20
> > > >  	rxqueue =3D __netif_get_rx_queue(current->nsproxy->net_ns->loopba=
ck_dev, 0);
> > > > -	xdp.rxq =3D &rxqueue->xdp_rxq;
> > > > +	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
> > > > +		      &rxqueue->xdp_rxq);
> > > >  	bpf_prog_change_xdp(NULL, prog);
> > > >  	ret =3D bpf_test_run(prog, &xdp, repeat, &retval, &duration, true=
);
> > > >  	if (ret)
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index ce8fea2e2788..bac56afcf6bc 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -4588,11 +4588,11 @@ static u32 netif_receive_generic_xdp(struct=
 sk_buff *skb,
> > > >  	struct netdev_rx_queue *rxqueue;
> > > >  	void *orig_data, *orig_data_end;
> > > >  	u32 metalen, act =3D XDP_DROP;
> > > > +	u32 mac_len, frame_sz;
> > > >  	__be16 orig_eth_type;
> > > >  	struct ethhdr *eth;
> > > >  	bool orig_bcast;
> > > >  	int hlen, off;
> > > > -	u32 mac_len;
> > > > =20
> > > >  	/* Reinjected packets coming from act_mirred or similar should
> > > >  	 * not get XDP generic processing.
> > > > @@ -4631,8 +4631,8 @@ static u32 netif_receive_generic_xdp(struct s=
k_buff *skb,
> > > >  	xdp->data_hard_start =3D skb->data - skb_headroom(skb);
> > > > =20
> > > >  	/* SKB "head" area always have tailroom for skb_shared_info */
> > > > -	xdp->frame_sz  =3D (void *)skb_end_pointer(skb) - xdp->data_hard_=
start;
> > > > -	xdp->frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > +	frame_sz =3D (void *)skb_end_pointer(skb) - xdp->data_hard_start;
> > > > +	frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > =20
> > > >  	orig_data_end =3D xdp->data_end;
> > > >  	orig_data =3D xdp->data;
> > > > @@ -4641,7 +4641,7 @@ static u32 netif_receive_generic_xdp(struct s=
k_buff *skb,
> > > >  	orig_eth_type =3D eth->h_proto;
> > > > =20
> > > >  	rxqueue =3D netif_get_rxqueue(skb);
> > > > -	xdp->rxq =3D &rxqueue->xdp_rxq;
> > > > +	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
> > > > =20
> > > >  	act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> > > > =20
> > > > --=20
> > > > 2.29.2
> > > >=20
>=20
>=20

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9JiDwAKCRA6cBh0uS2t
rArPAP9lnTHYSnre73DM/LCaE+XJmy/Yb2+G86k25VL7PM29ugD/X0+us6PjAiIS
Yg9EPEJ3UrUG3UJ3hV/izR2tvYRIJAk=
=173B
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--

