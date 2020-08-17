Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F9245F0D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHQIRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQIRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:17:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043C9C061388;
        Mon, 17 Aug 2020 01:17:48 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f5so7119656plr.9;
        Mon, 17 Aug 2020 01:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dcFVRpNADqEtdLi4FpRtkurfxDiB5cQRK9Dfdg9x+Fk=;
        b=onQhzXUQgU/a+5iv1eiedq708N2qUvbb9hLqPwbNcMZbrafaVgtTLqod6W5S5EvgwW
         ia2Ga+2FDUNHJJUlvHy5eBfliIeLogU4Wi1w83nBad7XrSZfGbQDw8JL6oyYw8RaTYtb
         GOxydtPyCELUViaGBMuJFHCNSjMyLoNfpvRMuQgrxT2UY8A3e6JIUTqyPNMAL7rw2Z/z
         jRmxaeFeF106x1RJs9MwNGIRcjt7SYVS8LunMdKQB2V5M7ITp8JAW4VZ0O73s28t9dSG
         M8mTaGTmh1K0jOh4sD2d3fwjxfMBFzh2nP52Yc87N5AUdfK33PUFRxYhs2yKIAgHNHgo
         Nr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dcFVRpNADqEtdLi4FpRtkurfxDiB5cQRK9Dfdg9x+Fk=;
        b=he1y93ymJzIHac9nBGCvAf+MmDd3zg3JrjQdD+UUAP9hkdL62S68lFgRVX7fn+luQQ
         /lXzUUZWxpbL/U2Hh1lUd/SFZX/EC0c3ps3GRghX5wxVNFOq0H3eELvxMwXorPpkooGu
         zvN5zljIQl2DGmCG7qkmrsTVeZKDe94jd0IfzVfHxUbttfD786nfD69+xQAtlitPlUCe
         /bI4L81x49hmEgb18Qieq6iV41J5N+K0sT/Czt+L63LbvE8dyPDmLq7vHsZR+X36ZPWC
         3k+hZPOZliRmRoqmaiH4GXrgOJzpwlwCvnnMEJsjpj2WWkwMrcHsauMRn5NWM0Pz30YK
         K0Ng==
X-Gm-Message-State: AOAM533H88ZZiWXke4AHt5nvQIPSKbiYJ5OHCNdk6N3mXvINLfC+TIkL
        HiLt5o3Ibw0EAmRsMKF1BB8=
X-Google-Smtp-Source: ABdhPJzb4y/jT+CQHEdRjViuIc33Qdx/u/JnZxpHs/hd00NvayTZxHDE23pPiqS7tepaKyIUna7B1Q==
X-Received: by 2002:a17:90b:3603:: with SMTP id ml3mr11555104pjb.207.1597652267552;
        Mon, 17 Aug 2020 01:17:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:17:47 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, baohua@kernel.org, mripard@kernel.org,
        wens@csie.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@xilinx.com, matthias.bgg@gmail.com
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 00/35] dma: convert tasklets to use new tasklet_setup()
Date:   Mon, 17 Aug 2020 13:46:51 +0530
Message-Id: <20200817081726.20213-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts 
all the dma drivers to use the new tasklet_setup() API


Allen Pais (35):
  dma: altera-msgdma: convert tasklets to use new tasklet_setup() API
  dma: at_hdmac: convert tasklets to use new tasklet_setup() API
  dma: at_xdmac: convert tasklets to use new tasklet_setup() API
  dma: coh901318: convert tasklets to use new tasklet_setup() API
  dma: dw: convert tasklets to use new tasklet_setup() API
  dma: ep93xx: convert tasklets to use new tasklet_setup() API
  dma: fsl: convert tasklets to use new tasklet_setup() API
  dma: imx-dma: convert tasklets to use new tasklet_setup() API
  dma: ioat: convert tasklets to use new tasklet_setup() API
  dma: iop_adma: convert tasklets to use new tasklet_setup() API
  dma: ipu: convert tasklets to use new tasklet_setup() API
  dma: k3dma: convert tasklets to use new tasklet_setup() API
  dma: mediatek: convert tasklets to use new tasklet_setup() API
  dma: mmp: convert tasklets to use new tasklet_setup() API
  dma: mpc512x: convert tasklets to use new tasklet_setup() API
  dma: mv_xor: convert tasklets to use new tasklet_setup() API
  dma: mxs-dma: convert tasklets to use new tasklet_setup() API
  dma: nbpfaxi: convert tasklets to use new tasklet_setup() API
  dma: pch_dma: convert tasklets to use new tasklet_setup() API
  dma: pl330: convert tasklets to use new tasklet_setup() API
  dma: ppc4xx: convert tasklets to use new tasklet_setup() API
  dma: qcom: convert tasklets to use new tasklet_setup() API
  dma: sa11x0: convert tasklets to use new tasklet_setup() API
  dma: sirf-dma: convert tasklets to use new tasklet_setup() API
  dma: ste_dma40: convert tasklets to use new tasklet_setup() API
  dma: sun6i: convert tasklets to use new tasklet_setup() API
  dma: tegra20: convert tasklets to use new tasklet_setup() API
  dma: timb_dma: convert tasklets to use new tasklet_setup() API
  dma: txx9dmac: convert tasklets to use new tasklet_setup() API
  dma: virt-dma: convert tasklets to use new tasklet_setup() API
  dma: xgene: convert tasklets to use new tasklet_setup() API
  dma: xilinx: convert tasklets to use new tasklet_setup() API
  dma: plx_dma: convert tasklets to use new tasklet_setup() API
  dma: sf-pdma: convert tasklets to use new tasklet_setup() API
  dma: k3-udma: convert tasklets to use new tasklet_setup() API

 drivers/dma/altera-msgdma.c      |  6 +++---
 drivers/dma/at_hdmac.c           |  7 +++----
 drivers/dma/at_xdmac.c           |  5 ++---
 drivers/dma/coh901318.c          |  7 +++----
 drivers/dma/dw/core.c            |  6 +++---
 drivers/dma/ep93xx_dma.c         |  7 +++----
 drivers/dma/fsl_raid.c           |  6 +++---
 drivers/dma/fsldma.c             |  6 +++---
 drivers/dma/imx-dma.c            |  7 +++----
 drivers/dma/ioat/dma.c           |  6 +++---
 drivers/dma/ioat/dma.h           |  2 +-
 drivers/dma/ioat/init.c          |  4 +---
 drivers/dma/iop-adma.c           |  8 ++++----
 drivers/dma/ipu/ipu_idmac.c      |  6 +++---
 drivers/dma/k3dma.c              |  6 +++---
 drivers/dma/mediatek/mtk-cqdma.c |  7 +++----
 drivers/dma/mmp_pdma.c           |  6 +++---
 drivers/dma/mmp_tdma.c           |  6 +++---
 drivers/dma/mpc512x_dma.c        |  6 +++---
 drivers/dma/mv_xor.c             |  7 +++----
 drivers/dma/mv_xor_v2.c          |  8 ++++----
 drivers/dma/mxs-dma.c            |  7 +++----
 drivers/dma/nbpfaxi.c            |  6 +++---
 drivers/dma/pch_dma.c            |  7 +++----
 drivers/dma/pl330.c              | 12 ++++++------
 drivers/dma/plx_dma.c            |  7 +++----
 drivers/dma/ppc4xx/adma.c        |  7 +++----
 drivers/dma/qcom/bam_dma.c       |  6 +++---
 drivers/dma/qcom/hidma.c         |  6 +++---
 drivers/dma/qcom/hidma_ll.c      |  6 +++---
 drivers/dma/sa11x0-dma.c         |  6 +++---
 drivers/dma/sf-pdma/sf-pdma.c    | 14 ++++++--------
 drivers/dma/sirf-dma.c           |  6 +++---
 drivers/dma/ste_dma40.c          |  7 +++----
 drivers/dma/sun6i-dma.c          |  6 +++---
 drivers/dma/tegra20-apb-dma.c    |  7 +++----
 drivers/dma/ti/k3-udma.c         |  7 +++----
 drivers/dma/timb_dma.c           |  6 +++---
 drivers/dma/txx9dmac.c           | 14 ++++++--------
 drivers/dma/virt-dma.c           |  6 +++---
 drivers/dma/xgene-dma.c          |  7 +++----
 drivers/dma/xilinx/xilinx_dma.c  |  7 +++----
 drivers/dma/xilinx/zynqmp_dma.c  |  6 +++---
 43 files changed, 135 insertions(+), 157 deletions(-)

-- 
2.17.1

