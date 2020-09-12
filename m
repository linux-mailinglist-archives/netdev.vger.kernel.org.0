Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89374267B1A
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgILO5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgILOlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:41:25 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B01FC0613ED;
        Sat, 12 Sep 2020 07:41:24 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z22so17239947ejl.7;
        Sat, 12 Sep 2020 07:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O3zYRsCuEvjftzoDygBpJn6Vw7evuhv1ZiF/vz+XZQE=;
        b=EsdMwqBY731JEHTQ45r/F98U2bRJ13XpEzSQm0W/tRnGpPccKgi38bnxaaCxl6+PvO
         Yw5fyUZTA7zaAozSmeLeUyLAXOacZdwkBw86xkcGsuBYL/h2zNAUj6mNgluFv8DGVcwx
         XG+2s0BJ3vYQdNk6PZQzB7ke0Ep9tEFgAP/gOfL/O9uPegjxZV3nj492lTLqzSlvugfg
         Sgj/f3gFYWG9WDK20dyUVdQT+Bw7HaZ49teO8Hp/vIutcaoju6JvEx1QanoPfdZw91o9
         kJElEUVczBMlCwldCRx734IxmnQ364S/jNZyROJID0nemqnPBEq4XhUTM6DWNNQyFD5M
         CT/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O3zYRsCuEvjftzoDygBpJn6Vw7evuhv1ZiF/vz+XZQE=;
        b=PTtBaPBl4bE9PjFnf/x8pd9wwzJp59RVFc/I1so5FRYdtL0g4/MAz5x+KV+OcAazeT
         hm9hoJafYowawPc16F3aB/qSoSWg1bo0PQIZdLCn8GDFZjqWuljvj10C+mnQ86pMerQu
         9zx3OIZ+KYjaSwPe/qI+SpfE5Vguw/a9iDA1yxyJjEnoCWVRQfIbdXTf0jy8+T+EiVPZ
         5ODdkUjyrBAjjnEYJn9ThW2cilv706QARmo9i+QzAIkewP/QlhQzzS/10esQjL62v5fJ
         IQ5JlaErEpzP2R5AsKYL+VJc0qQ9aarzujiOa1ufloE1uSn408Olf4MyOB4hRQEKMpBh
         kX/A==
X-Gm-Message-State: AOAM533qDBHk3AZPIuJ9ANz4lMfHqElTgONKr0hwQ1z2g5phO8gAf7CJ
        LL9lS34IGjfV9xtCn+0uE7bievygQDA=
X-Google-Smtp-Source: ABdhPJz6MdGxUOkKjK9GHIjbZQQaUb+9lq0kJEcPnNU2FG2eaiEFTxDXs/cOQtsI7ADZtvV9yCGwYg==
X-Received: by 2002:a17:906:2655:: with SMTP id i21mr1932419ejc.511.1599921680454;
        Sat, 12 Sep 2020 07:41:20 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:19 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 03/14] habanalabs/gaudi: add NIC security configuration
Date:   Sat, 12 Sep 2020 17:40:55 +0300
Message-Id: <20200912144106.11799-4-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Configure the security properties of the NIC IP. This is to prevent the
user process from doing something with the NIC that he shouldn't do. e.g.
crash the server, steal data, etc.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 .../misc/habanalabs/gaudi/gaudi_security.c    | 3973 +++++++++++++++++
 1 file changed, 3973 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi_security.c b/drivers/misc/habanalabs/gaudi/gaudi_security.c
index 2d7add0e5bcc..8a921ab56557 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_security.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_security.c
@@ -5157,6 +5157,3977 @@ static void gaudi_init_dma_protection_bits(struct hl_device *hdev)
 	WREG32(pb_addr + word_offset, ~mask);
 }
 
+static void gaudi_init_nic_protection_bits(struct hl_device *hdev)
+{
+	u32 pb_addr, mask;
+	u8 word_offset;
+
+	WREG32(mmNIC0_QM0_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+	WREG32(mmNIC0_QM1_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+
+	pb_addr = (mmNIC0_QM0_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+				PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM0_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM0_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM0_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM0_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC0_QM1_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC0_QM1_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC0_QM1_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC0_QM1_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	WREG32(mmNIC1_QM0_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+	WREG32(mmNIC1_QM1_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+
+	pb_addr = (mmNIC1_QM0_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM0_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM0_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM0_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM0_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC1_QM1_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC1_QM1_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC1_QM1_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC1_QM1_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	WREG32(mmNIC2_QM0_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+	WREG32(mmNIC2_QM1_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+
+	pb_addr = (mmNIC2_QM0_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_2 & PROT_BITS_OFFS)
+				>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM0_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM0_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM0_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM0_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC2_QM1_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC2_QM1_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC2_QM1_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC2_QM1_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	WREG32(mmNIC3_QM0_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+	WREG32(mmNIC3_QM1_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+
+	pb_addr = (mmNIC3_QM0_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM0_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM0_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM0_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM0_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC3_QM1_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC3_QM1_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC3_QM1_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC3_QM1_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	WREG32(mmNIC4_QM0_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+	WREG32(mmNIC4_QM1_BASE - CFG_BASE + PROT_BITS_OFFS + 0x7C, 0);
+
+	pb_addr = (mmNIC4_QM0_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM0_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM0_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM0_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM0_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_GLBL_CFG0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_GLBL_CFG0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_GLBL_CFG0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_CFG1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_PROT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_ERR_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_NON_SECURE_PROPS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_NON_SECURE_PROPS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_NON_SECURE_PROPS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_NON_SECURE_PROPS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_NON_SECURE_PROPS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_STS0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_STS1_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_MSG_EN_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_MSG_EN_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_MSG_EN_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_MSG_EN_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_MSG_EN_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_LO_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_PQ_BASE_HI_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_PQ_BASE_HI_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_PQ_BASE_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_BASE_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_SIZE_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_SIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_SIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_SIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_PI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_PI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_PI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_PI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_CFG1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS0_3 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_PQ_STS1_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_PQ_STS1_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_PQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_PQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS0_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS1_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS1_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS1_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_STS1_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_0 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CQ_CTL_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CQ_CTL_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CQ_CTL_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_LO_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_PTR_HI_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_TSIZE_STS_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CQ_CTL_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CQ_CTL_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CQ_CTL_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_CTL_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_IFIFO_CNT_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_IFIFO_CNT_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_IFIFO_CNT_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_IFIFO_CNT_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CQ_IFIFO_CNT_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_2 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CP_STS_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CP_STS_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CP_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_LO_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_LO_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_LO_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_LO_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_LO_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_HI_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_HI_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_HI_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_HI_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_CURRENT_INST_HI_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_BARRIER_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_BARRIER_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_BARRIER_CFG_2 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CP_BARRIER_CFG_3 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CP_BARRIER_CFG_3 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CP_BARRIER_CFG_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_BARRIER_CFG_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_DBG_0_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_DBG_0_1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_CP_DBG_0_2 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_CP_DBG_0_2 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_CP_DBG_0_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_DBG_0_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_DBG_0_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_ARUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_ARUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_ARUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_ARUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_ARUSER_31_11_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_AWUSER_31_11_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_AWUSER_31_11_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_AWUSER_31_11_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_AWUSER_31_11_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CP_AWUSER_31_11_4 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_ARB_CFG_0 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_ARB_CFG_0 & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_ARB_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_19 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_23 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_ARB_MST_AVAIL_CRED_24 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_24 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_AVAIL_CRED_31 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_23 & ~0xFFF) +
+			PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_23 &
+			PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_ARB_SLV_CHOISE_WDT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MSG_MAX_INFLIGHT & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MSG_AWUSER_31_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MSG_AWUSER_SEC_PROP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MSG_AWUSER_NON_SEC_PROP & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_ARB_STATE_STS & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_ARB_STATE_STS & PROT_BITS_OFFS) >> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_ARB_STATE_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_CHOISE_FULLNESS_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MSG_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_SLV_CHOISE_Q_HEAD & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_ERR_CAUSE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_ERR_MSG_EN & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_ERR_STS_DRP & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_2 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_3 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_4 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_5 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_6 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_7 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_8 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_9 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_10 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_11 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_12 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_13 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_14 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_15 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_16 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_17 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_18 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_19 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_ARB_MST_CRED_STS_20 & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_ARB_MST_CRED_STS_20 & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_20 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_21 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_22 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_23 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_24 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_25 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_26 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_27 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_28 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_29 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_30 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_ARB_MST_CRED_STS_31 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CGM_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CGM_STS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CGM_CFG1 & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_LOCAL_RANGE_BASE & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_LOCAL_RANGE_BASE & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_LOCAL_RANGE_BASE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_LOCAL_RANGE_SIZE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_CSMR_STRICT_PRIO_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_HBW_RD_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_LBW_WR_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_LBW_WR_RATE_LIM_CFG_1 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_HBW_RD_RATE_LIM_CFG_0 & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_AXCACHE & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_IND_GW_APB_CFG & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_IND_GW_APB_WDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_IND_GW_APB_RDATA & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_IND_GW_APB_STATUS & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_ERR_ADDR_LO & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_ERR_ADDR_HI & 0x7F) >> 2);
+	mask |= 1U << ((mmNIC4_QM1_GLBL_ERR_WDATA & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+
+	pb_addr = (mmNIC4_QM1_GLBL_MEM_INIT_BUSY & ~0xFFF) + PROT_BITS_OFFS;
+	word_offset = ((mmNIC4_QM1_GLBL_MEM_INIT_BUSY & PROT_BITS_OFFS)
+			>> 7) << 2;
+	mask = 1U << ((mmNIC4_QM1_GLBL_MEM_INIT_BUSY & 0x7F) >> 2);
+
+	WREG32(pb_addr + word_offset, ~mask);
+}
+
 static void gaudi_init_tpc_protection_bits(struct hl_device *hdev)
 {
 	u32 pb_addr, mask;
@@ -8861,6 +12832,8 @@ static void gaudi_init_protection_bits(struct hl_device *hdev)
 
 	gaudi_init_mme_protection_bits(hdev);
 
+	gaudi_init_nic_protection_bits(hdev);
+
 	gaudi_init_tpc_protection_bits(hdev);
 }
 
-- 
2.17.1

