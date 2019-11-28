Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207BA10CB27
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfK1PAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 10:00:11 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42434 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfK1O5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 09:57:10 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so4646381ljo.9
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 06:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AiGMJuBYK7a9OjqplEnlhTed0vj3Z2tvo3Sm0/6smWk=;
        b=LWSeFBBM1EDIZG6BRK7BzXkMhomfAGPxWZw5tbDhgh3j0xwb1HqC6ORUdqAUR5hYkz
         tbFM6GCvupYGGSa1wW3LvEjbWfoc5kdkGYD4XmkX+Hmxi8jZ2xrI5mbIBgUADs+agsCg
         Sgeh5ezUo/C4MaGgCfg+Rdd5Xt0dYaqfP4JhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AiGMJuBYK7a9OjqplEnlhTed0vj3Z2tvo3Sm0/6smWk=;
        b=s9yW3Gdhx9NypoG7QAIXxRI3W2GVTeqGvznrTJwdv2gkT/fQ/vp4MFbbdLtuGMxe5O
         vEhe0lWYdsY/a3aWZBjamusITnQClwXQsGmhCYsFVhP76L3d2axdlCn93vbz0JoAopPl
         5bdHawvdwmbquim8WwVDCMUyIPs2kg5a+xfH2mXdOYokMITJUZ+ipSf/HSEib7RpYmGw
         9juXtS4LTrlJhhj+jycqoIY6nRI5tGUdRLO9VkeLM/oaZnse+z+ntelziFOGPukyUD6o
         qzdkNBZM0XNG6ZMDFlOhwKbCxwp/A8tooWZpPU4WGD9vX3FIyl/EPua68Eb8iCRP3uNs
         PQKw==
X-Gm-Message-State: APjAAAWj9cMcX+FbleuIBi8t29Cpoi1kWz0CtaQLaSjk6o36SxuowlSH
        f5f2MxaKPOHCn5gj0Sx67XLONg==
X-Google-Smtp-Source: APXvYqx9GR/tD/ww+OOOfAVWnvsvJ//206lu0T8p7Qzhyj4S2WuGGXqlvt2C1ggQ9Sclp3pDaGgXSg==
X-Received: by 2002:a2e:8855:: with SMTP id z21mr36008857ljj.212.1574953028055;
        Thu, 28 Nov 2019 06:57:08 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id u2sm2456803lfl.18.2019.11.28.06.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 06:57:07 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v6 03/49] soc: fsl: qe: rename qe_(clr/set/clrset)bit* helpers
Date:   Thu, 28 Nov 2019 15:55:08 +0100
Message-Id: <20191128145554.1297-4-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
References: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it clear that these operate on big-endian registers (i.e. use the
iowrite*be primitives) before we introduce more uses of them and allow
the QE drivers to be built for platforms other than ppc32.

Reviewed-by: Timur Tabi <timur@kernel.org>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wan/fsl_ucc_hdlc.c |  4 ++--
 drivers/soc/fsl/qe/ucc.c       | 10 +++++-----
 include/soc/fsl/qe/qe.h        | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index ca0f3be2b6bf..ce6af7d5380f 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -623,8 +623,8 @@ static int ucc_hdlc_poll(struct napi_struct *napi, int budget)
 
 	if (howmany < budget) {
 		napi_complete_done(napi, howmany);
-		qe_setbits32(priv->uccf->p_uccm,
-			     (UCCE_HDLC_RX_EVENTS | UCCE_HDLC_TX_EVENTS) << 16);
+		qe_setbits_be32(priv->uccf->p_uccm,
+				(UCCE_HDLC_RX_EVENTS | UCCE_HDLC_TX_EVENTS) << 16);
 	}
 
 	return howmany;
diff --git a/drivers/soc/fsl/qe/ucc.c b/drivers/soc/fsl/qe/ucc.c
index 024d239ac1e1..ae9f2cf560cb 100644
--- a/drivers/soc/fsl/qe/ucc.c
+++ b/drivers/soc/fsl/qe/ucc.c
@@ -540,8 +540,8 @@ int ucc_set_tdm_rxtx_clk(u32 tdm_num, enum qe_clock clock,
 	cmxs1cr = (tdm_num < 4) ? &qe_mux_reg->cmxsi1cr_l :
 				  &qe_mux_reg->cmxsi1cr_h;
 
-	qe_clrsetbits32(cmxs1cr, QE_CMXUCR_TX_CLK_SRC_MASK << shift,
-			clock_bits << shift);
+	qe_clrsetbits_be32(cmxs1cr, QE_CMXUCR_TX_CLK_SRC_MASK << shift,
+			   clock_bits << shift);
 
 	return 0;
 }
@@ -650,9 +650,9 @@ int ucc_set_tdm_rxtx_sync(u32 tdm_num, enum qe_clock clock,
 
 	shift = ucc_get_tdm_sync_shift(mode, tdm_num);
 
-	qe_clrsetbits32(&qe_mux_reg->cmxsi1syr,
-			QE_CMXUCR_TX_CLK_SRC_MASK << shift,
-			source << shift);
+	qe_clrsetbits_be32(&qe_mux_reg->cmxsi1syr,
+			   QE_CMXUCR_TX_CLK_SRC_MASK << shift,
+			   source << shift);
 
 	return 0;
 }
diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
index c1036d16ed03..a1aa4eb28f0c 100644
--- a/include/soc/fsl/qe/qe.h
+++ b/include/soc/fsl/qe/qe.h
@@ -241,20 +241,20 @@ static inline int qe_alive_during_sleep(void)
 #define qe_muram_offset cpm_muram_offset
 #define qe_muram_dma cpm_muram_dma
 
-#define qe_setbits32(_addr, _v) iowrite32be(ioread32be(_addr) |  (_v), (_addr))
-#define qe_clrbits32(_addr, _v) iowrite32be(ioread32be(_addr) & ~(_v), (_addr))
+#define qe_setbits_be32(_addr, _v) iowrite32be(ioread32be(_addr) |  (_v), (_addr))
+#define qe_clrbits_be32(_addr, _v) iowrite32be(ioread32be(_addr) & ~(_v), (_addr))
 
-#define qe_setbits16(_addr, _v) iowrite16be(ioread16be(_addr) |  (_v), (_addr))
-#define qe_clrbits16(_addr, _v) iowrite16be(ioread16be(_addr) & ~(_v), (_addr))
+#define qe_setbits_be16(_addr, _v) iowrite16be(ioread16be(_addr) |  (_v), (_addr))
+#define qe_clrbits_be16(_addr, _v) iowrite16be(ioread16be(_addr) & ~(_v), (_addr))
 
-#define qe_setbits8(_addr, _v) iowrite8(ioread8(_addr) |  (_v), (_addr))
-#define qe_clrbits8(_addr, _v) iowrite8(ioread8(_addr) & ~(_v), (_addr))
+#define qe_setbits_8(_addr, _v) iowrite8(ioread8(_addr) |  (_v), (_addr))
+#define qe_clrbits_8(_addr, _v) iowrite8(ioread8(_addr) & ~(_v), (_addr))
 
-#define qe_clrsetbits32(addr, clear, set) \
+#define qe_clrsetbits_be32(addr, clear, set) \
 	iowrite32be((ioread32be(addr) & ~(clear)) | (set), (addr))
-#define qe_clrsetbits16(addr, clear, set) \
+#define qe_clrsetbits_be16(addr, clear, set) \
 	iowrite16be((ioread16be(addr) & ~(clear)) | (set), (addr))
-#define qe_clrsetbits8(addr, clear, set) \
+#define qe_clrsetbits_8(addr, clear, set) \
 	iowrite8((ioread8(addr) & ~(clear)) | (set), (addr))
 
 /* Structure that defines QE firmware binary files.
-- 
2.23.0

