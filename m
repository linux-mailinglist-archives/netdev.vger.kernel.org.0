Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF4F1102CB
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLCQqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:46:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfLCQqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 11:46:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3Ge7PV023415;
        Tue, 3 Dec 2019 16:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=TRrZvBB0k7TvqxGvo7xVinjSOka1Vt5iDKskbhfsPQU=;
 b=BL1XJhpWJiy447dY2Sjn61yaXNfiJzlFsMovdamw44Mm+X/7nPg5FisQ1KGZwHAY3QXj
 LMoVqPWq20QyFL1skPaQgmf3Oezhs+fXXEMa1fou/n2akvywnyMekG4wBABG1D7deQnH
 qEhzsavuBY1cs/TWj431uMoi/fe6Z3naEMrMgVYpI1balq4x6w9828X1ta3bXIfGlO9C
 PhWTFd5IwCrrXJl4FQptjVv3JeuHKZFWTQjq0CPgxssFOVYqpkRbHFkTtVGn+rQJ00ZW
 2FS3HrIYOPi8wHhwUTrYW4CiNcwJcNAuCvwkW29R0zRv0BroLUmQraSv18FqXB7Ieffz Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuu93gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 16:42:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3Ge4MF128687;
        Tue, 3 Dec 2019 16:40:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wn4qq7skw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 16:40:43 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB3Ge2xh032526;
        Tue, 3 Dec 2019 16:40:02 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 08:40:02 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v4 7/8] linux/log2.h: Fix 64bit calculations in
 roundup/down_pow_two()
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20191203114743.1294-8-nsaenzjulienne@suse.de>
Date:   Tue, 3 Dec 2019 11:39:56 -0500
Cc:     andrew.murray@arm.com, maz@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        =?utf-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.con>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bruce Fields <bfields@fieldses.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        kexec@lists.infradead.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F7F5DB38-A935-40E4-BDC3-9AA5C8EC9CBE@oracle.com>
References: <20191203114743.1294-1-nsaenzjulienne@suse.de>
 <20191203114743.1294-8-nsaenzjulienne@suse.de>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 3, 2019, at 6:47 AM, Nicolas Saenz Julienne =
<nsaenzjulienne@suse.de> wrote:
>=20
> Some users need to make sure their rounding function accepts and =
returns
> 64bit long variables regardless of the architecture. Sadly
> roundup/rounddown_pow_two() takes and returns unsigned longs. It turns
> out ilog2() already handles 32/64bit calculations properly, and being
> the building block to the round functions we can rework them as a
> wrapper around it.
>=20
> Suggested-by: Robin Murphy <robin.murphy@arm.con>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
> drivers/clk/clk-divider.c                    |  8 ++--
> drivers/clk/sunxi/clk-sunxi.c                |  2 +-
> drivers/infiniband/hw/hfi1/chip.c            |  4 +-
> drivers/infiniband/hw/hfi1/init.c            |  4 +-
> drivers/infiniband/hw/mlx4/srq.c             |  2 +-
> drivers/infiniband/hw/mthca/mthca_srq.c      |  2 +-
> drivers/infiniband/sw/rxe/rxe_qp.c           |  4 +-
> drivers/iommu/intel-iommu.c                  |  4 +-
> drivers/iommu/intel-svm.c                    |  4 +-
> drivers/iommu/intel_irq_remapping.c          |  2 +-
> drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c |  4 +-
> drivers/net/ethernet/marvell/sky2.c          |  2 +-
> drivers/net/ethernet/rocker/rocker_hw.h      |  4 +-
> drivers/net/ethernet/sfc/ef10.c              |  2 +-
> drivers/net/ethernet/sfc/efx.h               |  2 +-
> drivers/net/ethernet/sfc/falcon/efx.h        |  2 +-
> drivers/pci/msi.c                            |  2 +-
> include/linux/log2.h                         | 44 +++++---------------
> kernel/kexec_core.c                          |  3 +-
> lib/rhashtable.c                             |  2 +-
> net/sunrpc/xprtrdma/verbs.c                  |  2 +-
> 21 files changed, 41 insertions(+), 64 deletions(-)
>=20
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 098b2b01f0af..ba947e4c8193 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -222,7 +222,7 @@ static int _div_round_up(const struct =
clk_div_table *table,
> 	int div =3D DIV_ROUND_UP_ULL((u64)parent_rate, rate);
>=20
> 	if (flags & CLK_DIVIDER_POWER_OF_TWO)
> -		div =3D __roundup_pow_of_two(div);
> +		div =3D roundup_pow_of_two(div);
> 	if (table)
> 		div =3D _round_up_table(table, div);
>=20
> @@ -240,8 +240,8 @@ static int _div_round_closest(const struct =
clk_div_table *table,
> 	down =3D parent_rate / rate;
>=20
> 	if (flags & CLK_DIVIDER_POWER_OF_TWO) {
> -		up =3D __roundup_pow_of_two(up);
> -		down =3D __rounddown_pow_of_two(down);
> +		up =3D roundup_pow_of_two(up);
> +		down =3D rounddown_pow_of_two(down);
> 	} else if (table) {
> 		up =3D _round_up_table(table, up);
> 		down =3D _round_down_table(table, down);
> @@ -278,7 +278,7 @@ static int _next_div(const struct clk_div_table =
*table, int div,
> 	div++;
>=20
> 	if (flags & CLK_DIVIDER_POWER_OF_TWO)
> -		return __roundup_pow_of_two(div);
> +		return roundup_pow_of_two(div);
> 	if (table)
> 		return _round_up_table(table, div);
>=20
> diff --git a/drivers/clk/sunxi/clk-sunxi.c =
b/drivers/clk/sunxi/clk-sunxi.c
> index 27201fd26e44..faec99dc09c0 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -311,7 +311,7 @@ static void sun6i_get_ahb1_factors(struct =
factors_request *req)
>=20
> 		calcm =3D DIV_ROUND_UP(div, 1 << calcp);
> 	} else {
> -		calcp =3D __roundup_pow_of_two(div);
> +		calcp =3D roundup_pow_of_two(div);
> 		calcp =3D calcp > 3 ? 3 : calcp;
> 	}
>=20
> diff --git a/drivers/infiniband/hw/hfi1/chip.c =
b/drivers/infiniband/hw/hfi1/chip.c
> index 9b1fb84a3d45..96b1d343c32f 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -14199,10 +14199,10 @@ static int qos_rmt_entries(struct =
hfi1_devdata *dd, unsigned int *mp,
> 			max_by_vl =3D krcvqs[i];
> 	if (max_by_vl > 32)
> 		goto no_qos;
> -	m =3D ilog2(__roundup_pow_of_two(max_by_vl));
> +	m =3D ilog2(roundup_pow_of_two(max_by_vl));
>=20
> 	/* determine bits for vl */
> -	n =3D ilog2(__roundup_pow_of_two(num_vls));
> +	n =3D ilog2(roundup_pow_of_two(num_vls));
>=20
> 	/* reject if too much is used */
> 	if ((m + n) > 7)
> diff --git a/drivers/infiniband/hw/hfi1/init.c =
b/drivers/infiniband/hw/hfi1/init.c
> index 26b792bb1027..838c789c7cce 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -467,7 +467,7 @@ int hfi1_create_ctxtdata(struct hfi1_pportdata =
*ppd, int numa,
> 		 * MTU supported.
> 		 */
> 		if (rcd->egrbufs.size < hfi1_max_mtu) {
> -			rcd->egrbufs.size =3D =
__roundup_pow_of_two(hfi1_max_mtu);
> +			rcd->egrbufs.size =3D =
roundup_pow_of_two(hfi1_max_mtu);
> 			hfi1_cdbg(PROC,
> 				  "ctxt%u: eager bufs size too small. =
Adjusting to %u\n",
> 				    rcd->ctxt, rcd->egrbufs.size);
> @@ -1959,7 +1959,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata =
*rcd)
> 	 * to satisfy the "multiple of 8 RcvArray entries" requirement.
> 	 */
> 	if (rcd->egrbufs.size <=3D (1 << 20))
> -		rcd->egrbufs.rcvtid_size =3D max((unsigned =
long)round_mtu,
> +		rcd->egrbufs.rcvtid_size =3D max((unsigned long =
long)round_mtu,
> 			rounddown_pow_of_two(rcd->egrbufs.size / 8));
>=20
> 	while (alloced_bytes < rcd->egrbufs.size &&
> diff --git a/drivers/infiniband/hw/mlx4/srq.c =
b/drivers/infiniband/hw/mlx4/srq.c
> index 8dcf6e3d9ae2..7e685600a7b3 100644
> --- a/drivers/infiniband/hw/mlx4/srq.c
> +++ b/drivers/infiniband/hw/mlx4/srq.c
> @@ -96,7 +96,7 @@ int mlx4_ib_create_srq(struct ib_srq *ib_srq,
> 	srq->msrq.max    =3D roundup_pow_of_two(init_attr->attr.max_wr + =
1);
> 	srq->msrq.max_gs =3D init_attr->attr.max_sge;
>=20
> -	desc_size =3D max(32UL,
> +	desc_size =3D max(32ULL,
> 			roundup_pow_of_two(sizeof (struct =
mlx4_wqe_srq_next_seg) +
> 					   srq->msrq.max_gs *
> 					   sizeof (struct =
mlx4_wqe_data_seg)));
> diff --git a/drivers/infiniband/hw/mthca/mthca_srq.c =
b/drivers/infiniband/hw/mthca/mthca_srq.c
> index a85935ccce88..0c2e14b4142a 100644
> --- a/drivers/infiniband/hw/mthca/mthca_srq.c
> +++ b/drivers/infiniband/hw/mthca/mthca_srq.c
> @@ -225,7 +225,7 @@ int mthca_alloc_srq(struct mthca_dev *dev, struct =
mthca_pd *pd,
> 	else
> 		srq->max =3D srq->max + 1;
>=20
> -	ds =3D max(64UL,
> +	ds =3D max(64ULL,
> 		 roundup_pow_of_two(sizeof (struct mthca_next_seg) +
> 				    srq->max_gs * sizeof (struct =
mthca_data_seg)));
>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c =
b/drivers/infiniband/sw/rxe/rxe_qp.c
> index e2c6d1cedf41..040b707b0877 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -592,7 +592,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct =
ib_qp_attr *attr, int mask,
> 	int err;
>=20
> 	if (mask & IB_QP_MAX_QP_RD_ATOMIC) {
> -		int max_rd_atomic =3D =
__roundup_pow_of_two(attr->max_rd_atomic);
> +		int max_rd_atomic =3D =
roundup_pow_of_two(attr->max_rd_atomic);
>=20
> 		qp->attr.max_rd_atomic =3D max_rd_atomic;
> 		atomic_set(&qp->req.rd_atomic, max_rd_atomic);
> @@ -600,7 +600,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct =
ib_qp_attr *attr, int mask,
>=20
> 	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
> 		int max_dest_rd_atomic =3D
> -			__roundup_pow_of_two(attr->max_dest_rd_atomic);
> +			roundup_pow_of_two(attr->max_dest_rd_atomic);
>=20
> 		qp->attr.max_dest_rd_atomic =3D max_dest_rd_atomic;
>=20
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0c8d81f56a30..ce7c900bd666 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1488,7 +1488,7 @@ static void iommu_flush_iotlb_psi(struct =
intel_iommu *iommu,
> 				  unsigned long pfn, unsigned int pages,
> 				  int ih, int map)
> {
> -	unsigned int mask =3D ilog2(__roundup_pow_of_two(pages));
> +	unsigned int mask =3D ilog2(roundup_pow_of_two(pages));
> 	uint64_t addr =3D (uint64_t)pfn << VTD_PAGE_SHIFT;
> 	u16 did =3D domain->iommu_did[iommu->seq_id];
>=20
> @@ -3390,7 +3390,7 @@ static unsigned long intel_alloc_iova(struct =
device *dev,
> 	/* Restrict dma_mask to the width that the iommu can handle */
> 	dma_mask =3D min_t(uint64_t, DOMAIN_MAX_ADDR(domain->gaw), =
dma_mask);
> 	/* Ensure we reserve the whole size-aligned region */
> -	nrpages =3D __roundup_pow_of_two(nrpages);
> +	nrpages =3D roundup_pow_of_two(nrpages);
>=20
> 	if (!dmar_forcedac && dma_mask > DMA_BIT_MASK(32)) {
> 		/*
> diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
> index 9b159132405d..602caca3cd1a 100644
> --- a/drivers/iommu/intel-svm.c
> +++ b/drivers/iommu/intel-svm.c
> @@ -115,7 +115,7 @@ static void intel_flush_svm_range_dev (struct =
intel_svm *svm, struct intel_svm_d
> 			QI_EIOTLB_TYPE;
> 		desc.qw1 =3D 0;
> 	} else {
> -		int mask =3D ilog2(__roundup_pow_of_two(pages));
> +		int mask =3D ilog2(roundup_pow_of_two(pages));
>=20
> 		desc.qw0 =3D QI_EIOTLB_PASID(svm->pasid) |
> 				QI_EIOTLB_DID(sdev->did) |
> @@ -142,7 +142,7 @@ static void intel_flush_svm_range_dev (struct =
intel_svm *svm, struct intel_svm_d
> 			 * for example, an "address" value of =
0x12345f000 will
> 			 * flush from 0x123440000 to 0x12347ffff =
(256KiB). */
> 			unsigned long last =3D address + ((unsigned =
long)(pages - 1) << VTD_PAGE_SHIFT);
> -			unsigned long mask =3D =
__rounddown_pow_of_two(address ^ last);
> +			unsigned long mask =3D =
rounddown_pow_of_two(address ^ last);
>=20
> 			desc.qw1 =3D QI_DEV_EIOTLB_ADDR((address & =
~mask) |
> 					(mask - 1)) | =
QI_DEV_EIOTLB_SIZE;
> diff --git a/drivers/iommu/intel_irq_remapping.c =
b/drivers/iommu/intel_irq_remapping.c
> index 81e43c1df7ec..935657b2c661 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -113,7 +113,7 @@ static int alloc_irte(struct intel_iommu *iommu,
> 		return -1;
>=20
> 	if (count > 1) {
> -		count =3D __roundup_pow_of_two(count);
> +		count =3D roundup_pow_of_two(count);
> 		mask =3D ilog2(count);
> 	}
>=20
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c =
b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> index 6a757dadb5f1..fd5b12c23eaa 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> @@ -680,13 +680,13 @@ static int xgbe_set_ringparam(struct net_device =
*netdev,
> 		return -EINVAL;
> 	}
>=20
> -	rx =3D __rounddown_pow_of_two(ringparam->rx_pending);
> +	rx =3D rounddown_pow_of_two(ringparam->rx_pending);
> 	if (rx !=3D ringparam->rx_pending)
> 		netdev_notice(netdev,
> 			      "rx ring parameter rounded to power of =
two: %u\n",
> 			      rx);
>=20
> -	tx =3D __rounddown_pow_of_two(ringparam->tx_pending);
> +	tx =3D rounddown_pow_of_two(ringparam->tx_pending);
> 	if (tx !=3D ringparam->tx_pending)
> 		netdev_notice(netdev,
> 			      "tx ring parameter rounded to power of =
two: %u\n",
> diff --git a/drivers/net/ethernet/marvell/sky2.c =
b/drivers/net/ethernet/marvell/sky2.c
> index 5f56ee83e3b1..cc3a03b4a611 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4139,7 +4139,7 @@ static int sky2_set_coalesce(struct net_device =
*dev,
>  */
> static unsigned long roundup_ring_size(unsigned long pending)
> {
> -	return max(128ul, roundup_pow_of_two(pending+1));
> +	return max(128ull, roundup_pow_of_two(pending+1));
> }
>=20
> static void sky2_get_ringparam(struct net_device *dev,
> diff --git a/drivers/net/ethernet/rocker/rocker_hw.h =
b/drivers/net/ethernet/rocker/rocker_hw.h
> index 59f1f8b690d2..d8de15509e2c 100644
> --- a/drivers/net/ethernet/rocker/rocker_hw.h
> +++ b/drivers/net/ethernet/rocker/rocker_hw.h
> @@ -88,8 +88,8 @@ enum rocker_dma_type {
> };
>=20
> /* Rocker DMA ring size limits and default sizes */
> -#define ROCKER_DMA_SIZE_MIN		2ul
> -#define ROCKER_DMA_SIZE_MAX		65536ul
> +#define ROCKER_DMA_SIZE_MIN		2ull
> +#define ROCKER_DMA_SIZE_MAX		65536ull
> #define ROCKER_DMA_CMD_DEFAULT_SIZE	32ul
> #define ROCKER_DMA_EVENT_DEFAULT_SIZE	32ul
> #define ROCKER_DMA_TX_DEFAULT_SIZE	64ul
> diff --git a/drivers/net/ethernet/sfc/ef10.c =
b/drivers/net/ethernet/sfc/ef10.c
> index 4d9bbccc6f89..4f4d9a5b3b75 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -27,7 +27,7 @@ enum {
> };
> /* The maximum size of a shared RSS context */
> /* TODO: this should really be from the mcdi protocol export */
> -#define EFX_EF10_MAX_SHARED_RSS_CONTEXT_SIZE 64UL
> +#define EFX_EF10_MAX_SHARED_RSS_CONTEXT_SIZE 64ULL
>=20
> /* The filter table(s) are managed by firmware and we have write-only
>  * access.  When removing filters we must identify them to the
> diff --git a/drivers/net/ethernet/sfc/efx.h =
b/drivers/net/ethernet/sfc/efx.h
> index 2dd8d5002315..fea2add5860e 100644
> --- a/drivers/net/ethernet/sfc/efx.h
> +++ b/drivers/net/ethernet/sfc/efx.h
> @@ -52,7 +52,7 @@ void efx_schedule_slow_fill(struct efx_rx_queue =
*rx_queue);
>=20
> #define EFX_MAX_DMAQ_SIZE 4096UL
> #define EFX_DEFAULT_DMAQ_SIZE 1024UL
> -#define EFX_MIN_DMAQ_SIZE 512UL
> +#define EFX_MIN_DMAQ_SIZE 512ULL
>=20
> #define EFX_MAX_EVQ_SIZE 16384UL
> #define EFX_MIN_EVQ_SIZE 512UL
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.h =
b/drivers/net/ethernet/sfc/falcon/efx.h
> index d3b4646545fa..0d16257156d6 100644
> --- a/drivers/net/ethernet/sfc/falcon/efx.h
> +++ b/drivers/net/ethernet/sfc/falcon/efx.h
> @@ -55,7 +55,7 @@ void ef4_schedule_slow_fill(struct ef4_rx_queue =
*rx_queue);
>=20
> #define EF4_MAX_DMAQ_SIZE 4096UL
> #define EF4_DEFAULT_DMAQ_SIZE 1024UL
> -#define EF4_MIN_DMAQ_SIZE 512UL
> +#define EF4_MIN_DMAQ_SIZE 512ULL
>=20
> #define EF4_MAX_EVQ_SIZE 16384UL
> #define EF4_MIN_EVQ_SIZE 512UL
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index c7709e49f0e4..f0391e88bc42 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -578,7 +578,7 @@ msi_setup_entry(struct pci_dev *dev, int nvec, =
struct irq_affinity *affd)
> 	entry->msi_attrib.maskbit	=3D !!(control & =
PCI_MSI_FLAGS_MASKBIT);
> 	entry->msi_attrib.default_irq	=3D dev->irq;	/* Save IOAPIC =
IRQ */
> 	entry->msi_attrib.multi_cap	=3D (control & =
PCI_MSI_FLAGS_QMASK) >> 1;
> -	entry->msi_attrib.multiple	=3D =
ilog2(__roundup_pow_of_two(nvec));
> +	entry->msi_attrib.multiple	=3D =
ilog2(roundup_pow_of_two(nvec));
>=20
> 	if (control & PCI_MSI_FLAGS_64BIT)
> 		entry->mask_pos =3D dev->msi_cap + PCI_MSI_MASK_64;
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 83a4a3ca3e8a..53a727303dac 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -47,26 +47,6 @@ bool is_power_of_2(unsigned long n)
> 	return (n !=3D 0 && ((n & (n - 1)) =3D=3D 0));
> }
>=20
> -/**
> - * __roundup_pow_of_two() - round up to nearest power of two
> - * @n: value to round up
> - */
> -static inline __attribute__((const))
> -unsigned long __roundup_pow_of_two(unsigned long n)
> -{
> -	return 1UL << fls_long(n - 1);
> -}
> -
> -/**
> - * __rounddown_pow_of_two() - round down to nearest power of two
> - * @n: value to round down
> - */
> -static inline __attribute__((const))
> -unsigned long __rounddown_pow_of_two(unsigned long n)
> -{
> -	return 1UL << (fls_long(n) - 1);
> -}
> -
> /**
>  * const_ilog2 - log base 2 of 32-bit or a 64-bit constant unsigned =
value
>  * @n: parameter
> @@ -170,14 +150,11 @@ unsigned long __rounddown_pow_of_two(unsigned =
long n)
>  * - the result is undefined when n =3D=3D 0
>  * - this can be used to initialise global variables from constant =
data
>  */
> -#define roundup_pow_of_two(n)			\
> -(						\
> -	__builtin_constant_p(n) ? (		\
> -		(n =3D=3D 1) ? 1 :			\
> -		(1UL << (ilog2((n) - 1) + 1))	\
> -				   ) :		\
> -	__roundup_pow_of_two(n)			\
> - )
> +#define roundup_pow_of_two(n)			  \
> +(						  \
> +	(__builtin_constant_p(n) && ((n) =3D=3D 1)) ? \
> +	1 : (1ULL << (ilog2((n) - 1) + 1))        \
> +)
>=20
> /**
>  * rounddown_pow_of_two - round the given value down to nearest power =
of two
> @@ -187,12 +164,11 @@ unsigned long __rounddown_pow_of_two(unsigned =
long n)
>  * - the result is undefined when n =3D=3D 0
>  * - this can be used to initialise global variables from constant =
data
>  */
> -#define rounddown_pow_of_two(n)			\
> -(						\
> -	__builtin_constant_p(n) ? (		\
> -		(1UL << ilog2(n))) :		\
> -	__rounddown_pow_of_two(n)		\
> - )
> +#define rounddown_pow_of_two(n)			  \
> +(						  \
> +	(__builtin_constant_p(n) && ((n) =3D=3D 1)) ? \
> +	1 : (1ULL << (ilog2(n)))		  \
> +)
>=20
> static inline __attribute_const__
> int __order_base_2(unsigned long n)
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index 15d70a90b50d..bb9efc6944a4 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1094,7 +1094,8 @@ static int __init crash_notes_memory_init(void)
> 	 * crash_notes is allocated inside one physical page.
> 	 */
> 	size =3D sizeof(note_buf_t);
> -	align =3D min(roundup_pow_of_two(sizeof(note_buf_t)), =
PAGE_SIZE);
> +	align =3D min(roundup_pow_of_two(sizeof(note_buf_t)),
> +		    (unsigned long long)PAGE_SIZE);
>=20
> 	/*
> 	 * Break compile if size is bigger than PAGE_SIZE since =
crash_notes
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index bdb7e4cadf05..70908678c7a8 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -950,7 +950,7 @@ static size_t rounded_hashtable_size(const struct =
rhashtable_params *params)
>=20
> 	if (params->nelem_hint)
> 		retsize =3D max(roundup_pow_of_two(params->nelem_hint * =
4 / 3),
> -			      (unsigned long)params->min_size);
> +			      (unsigned long long)params->min_size);
> 	else
> 		retsize =3D max(HASH_DEFAULT_SIZE,
> 			      (unsigned long)params->min_size);
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 77c7dd7f05e8..78fb8ccabddd 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1015,7 +1015,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct =
rpcrdma_xprt *r_xprt, size_t size,
> 	maxhdrsize =3D rpcrdma_fixed_maxsz + 3 +
> 		     r_xprt->rx_ia.ri_max_segs * =
rpcrdma_readchunk_maxsz;
> 	maxhdrsize *=3D sizeof(__be32);
> -	rb =3D rpcrdma_regbuf_alloc(__roundup_pow_of_two(maxhdrsize),
> +	rb =3D rpcrdma_regbuf_alloc(roundup_pow_of_two(maxhdrsize),
> 				  DMA_TO_DEVICE, flags);
> 	if (!rb)
> 		goto out2;

For the xprtrdma chunk:

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>

--
Chuck Lever



