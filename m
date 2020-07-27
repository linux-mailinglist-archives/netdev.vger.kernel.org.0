Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE92522FA07
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgG0U2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0U2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:28:23 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4696E206E7;
        Mon, 27 Jul 2020 20:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595881702;
        bh=aYSeVSHouvNAoh4D27QzelNJE605X6Pqy1mo5TW2Y4A=;
        h=Date:From:To:Cc:Subject:From;
        b=wgH46tyrQPCV701y9bxUNPMT8OdNFXzLfyld1hCA4blHuT/HLRdEptgxWAipDur7F
         svTK/RHIq7+4i481ud8/+UxPIjPbKzrS9oxzbTb3Wc44rvBpz4Z2thZQzcqBlF1Xnp
         jWJHJWacMYwHzUVAZSemKQ/34bZu2ZZttiiyGdxo=
Date:   Mon, 27 Jul 2020 15:34:13 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Li Yang <leoyang.li@nxp.com>, Zhang Wei <zw@zh-kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] dmaengine: Use fallthrough pseudo-keyword
Message-ID: <20200727203413.GA6245@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/dma/amba-pl08x.c    | 10 +++++-----
 drivers/dma/fsldma.c        |  2 +-
 drivers/dma/imx-dma.c       |  2 +-
 drivers/dma/iop-adma.h      | 12 ++++++------
 drivers/dma/nbpfaxi.c       |  2 +-
 drivers/dma/pl330.c         | 10 +++-------
 drivers/dma/sh/shdma-base.c |  2 +-
 7 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 9adc7a2fa3d3..a24882ba3764 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1767,7 +1767,7 @@ static u32 pl08x_memcpy_cctl(struct pl08x_driver_data *pl08x)
 	default:
 		dev_err(&pl08x->adev->dev,
 			"illegal burst size for memcpy, set to 1\n");
-		/* Fall through */
+		fallthrough;
 	case PL08X_BURST_SZ_1:
 		cctl |= PL080_BSIZE_1 << PL080_CONTROL_SB_SIZE_SHIFT |
 			PL080_BSIZE_1 << PL080_CONTROL_DB_SIZE_SHIFT;
@@ -1806,7 +1806,7 @@ static u32 pl08x_memcpy_cctl(struct pl08x_driver_data *pl08x)
 	default:
 		dev_err(&pl08x->adev->dev,
 			"illegal bus width for memcpy, set to 8 bits\n");
-		/* Fall through */
+		fallthrough;
 	case PL08X_BUS_WIDTH_8_BITS:
 		cctl |= PL080_WIDTH_8BIT << PL080_CONTROL_SWIDTH_SHIFT |
 			PL080_WIDTH_8BIT << PL080_CONTROL_DWIDTH_SHIFT;
@@ -1850,7 +1850,7 @@ static u32 pl08x_ftdmac020_memcpy_cctl(struct pl08x_driver_data *pl08x)
 	default:
 		dev_err(&pl08x->adev->dev,
 			"illegal bus width for memcpy, set to 8 bits\n");
-		/* Fall through */
+		fallthrough;
 	case PL08X_BUS_WIDTH_8_BITS:
 		cctl |= PL080_WIDTH_8BIT << FTDMAC020_LLI_SRC_WIDTH_SHIFT |
 			PL080_WIDTH_8BIT << FTDMAC020_LLI_DST_WIDTH_SHIFT;
@@ -2612,7 +2612,7 @@ static int pl08x_of_probe(struct amba_device *adev,
 	switch (val) {
 	default:
 		dev_err(&adev->dev, "illegal burst size for memcpy, set to 1\n");
-		/* Fall through */
+		fallthrough;
 	case 1:
 		pd->memcpy_burst_size = PL08X_BURST_SZ_1;
 		break;
@@ -2647,7 +2647,7 @@ static int pl08x_of_probe(struct amba_device *adev,
 	switch (val) {
 	default:
 		dev_err(&adev->dev, "illegal bus width for memcpy, set to 8 bits\n");
-		/* Fall through */
+		fallthrough;
 	case 8:
 		pd->memcpy_bus_width = PL08X_BUS_WIDTH_8_BITS;
 		break;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ad72b3f42ffa..e342cf52d296 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1163,7 +1163,7 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	switch (chan->feature & FSL_DMA_IP_MASK) {
 	case FSL_DMA_IP_85XX:
 		chan->toggle_ext_pause = fsl_chan_toggle_ext_pause;
-		/* Fall through */
+		fallthrough;
 	case FSL_DMA_IP_83XX:
 		chan->toggle_ext_start = fsl_chan_toggle_ext_start;
 		chan->set_src_loop_size = fsl_chan_set_src_loop_size;
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5c0fb3134825..88717506c1f6 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -556,7 +556,7 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 		 * We fall-through here intentionally, since a 2D transfer is
 		 * similar to MEMCPY just adding the 2D slot configuration.
 		 */
-		/* Fall through */
+		fallthrough;
 	case IMXDMA_DESC_MEMCPY:
 		imx_dmav1_writel(imxdma, d->src, DMA_SAR(imxdmac->channel));
 		imx_dmav1_writel(imxdma, d->dest, DMA_DAR(imxdmac->channel));
diff --git a/drivers/dma/iop-adma.h b/drivers/dma/iop-adma.h
index c499c9578f00..d44eabb6f5eb 100644
--- a/drivers/dma/iop-adma.h
+++ b/drivers/dma/iop-adma.h
@@ -496,7 +496,7 @@ iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt,
 		}
 		hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl = edcr;
 		src_cnt = 24;
-		/* fall through */
+		fallthrough;
 	case 17 ... 24:
 		if (!u_desc_ctrl.field.blk_ctrl) {
 			hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl = 0;
@@ -510,7 +510,7 @@ iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt,
 		}
 		hw_desc->src_edc[AAU_EDCR1_IDX].e_desc_ctrl = edcr;
 		src_cnt = 16;
-		/* fall through */
+		fallthrough;
 	case 9 ... 16:
 		if (!u_desc_ctrl.field.blk_ctrl)
 			u_desc_ctrl.field.blk_ctrl = 0x2; /* use EDCR0 */
@@ -522,7 +522,7 @@ iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt,
 		}
 		hw_desc->src_edc[AAU_EDCR0_IDX].e_desc_ctrl = edcr;
 		src_cnt = 8;
-		/* fall through */
+		fallthrough;
 	case 2 ... 8:
 		shift = 1;
 		for (i = 0; i < src_cnt; i++) {
@@ -602,19 +602,19 @@ iop_desc_init_null_xor(struct iop_adma_desc_slot *desc, int src_cnt,
 	case 25 ... 32:
 		u_desc_ctrl.field.blk_ctrl = 0x3; /* use EDCR[2:0] */
 		hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl = 0;
-		/* fall through */
+		fallthrough;
 	case 17 ... 24:
 		if (!u_desc_ctrl.field.blk_ctrl) {
 			hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl = 0;
 			u_desc_ctrl.field.blk_ctrl = 0x3; /* use EDCR[2:0] */
 		}
 		hw_desc->src_edc[AAU_EDCR1_IDX].e_desc_ctrl = 0;
-		/* fall through */
+		fallthrough;
 	case 9 ... 16:
 		if (!u_desc_ctrl.field.blk_ctrl)
 			u_desc_ctrl.field.blk_ctrl = 0x2; /* use EDCR0 */
 		hw_desc->src_edc[AAU_EDCR0_IDX].e_desc_ctrl = 0;
-		/* fall through */
+		fallthrough;
 	case 1 ... 8:
 		if (!u_desc_ctrl.field.blk_ctrl && src_cnt > 4)
 			u_desc_ctrl.field.blk_ctrl = 0x1; /* use mini-desc */
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 74df621402e1..ca4e0930207a 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -483,7 +483,7 @@ static size_t nbpf_xfer_size(struct nbpf_device *nbpf,
 
 	default:
 		pr_warn("%s(): invalid bus width %u\n", __func__, width);
-		/* fall through */
+		fallthrough;
 	case DMA_SLAVE_BUSWIDTH_1_BYTE:
 		size = burst;
 	}
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 2c508ee672b9..9b69716172a4 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1061,16 +1061,16 @@ static bool _start(struct pl330_thread *thrd)
 
 		if (_state(thrd) == PL330_STATE_KILLING)
 			UNTIL(thrd, PL330_STATE_STOPPED)
-		/* fall through */
+		fallthrough;
 
 	case PL330_STATE_FAULTING:
 		_stop(thrd);
-		/* fall through */
+		fallthrough;
 
 	case PL330_STATE_KILLING:
 	case PL330_STATE_COMPLETING:
 		UNTIL(thrd, PL330_STATE_STOPPED)
-		/* fall through */
+		fallthrough;
 
 	case PL330_STATE_STOPPED:
 		return _trigger(thrd);
@@ -1121,7 +1121,6 @@ static u32 _emit_load(unsigned int dry_run, u8 buf[],
 
 	switch (direction) {
 	case DMA_MEM_TO_MEM:
-		/* fall through */
 	case DMA_MEM_TO_DEV:
 		off += _emit_LD(dry_run, &buf[off], cond);
 		break;
@@ -1155,7 +1154,6 @@ static inline u32 _emit_store(unsigned int dry_run, u8 buf[],
 
 	switch (direction) {
 	case DMA_MEM_TO_MEM:
-		/* fall through */
 	case DMA_DEV_TO_MEM:
 		off += _emit_ST(dry_run, &buf[off], cond);
 		break;
@@ -1216,7 +1214,6 @@ static int _bursts(struct pl330_dmac *pl330, unsigned dry_run, u8 buf[],
 
 	switch (pxs->desc->rqtype) {
 	case DMA_MEM_TO_DEV:
-		/* fall through */
 	case DMA_DEV_TO_MEM:
 		off += _ldst_peripheral(pl330, dry_run, &buf[off], pxs, cyc,
 			cond);
@@ -1266,7 +1263,6 @@ static int _dregs(struct pl330_dmac *pl330, unsigned int dry_run, u8 buf[],
 
 	switch (pxs->desc->rqtype) {
 	case DMA_MEM_TO_DEV:
-		/* fall through */
 	case DMA_DEV_TO_MEM:
 		off += _emit_MOV(dry_run, &buf[off], CCR, dregs_ccr);
 		off += _ldst_peripheral(pl330, dry_run, &buf[off], pxs, 1,
diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 2deeaab078a4..788d696323bb 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -383,7 +383,7 @@ static dma_async_tx_callback __ld_cleanup(struct shdma_chan *schan, bool all)
 			switch (desc->mark) {
 			case DESC_COMPLETED:
 				desc->mark = DESC_WAITING;
-				/* Fall through */
+				fallthrough;
 			case DESC_WAITING:
 				if (head_acked)
 					async_tx_ack(&desc->async_tx);
-- 
2.27.0

