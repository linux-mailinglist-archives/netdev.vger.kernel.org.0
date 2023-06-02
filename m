Return-Path: <netdev+bounces-7271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D60071F701
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27B4C281986
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C771363;
	Fri,  2 Jun 2023 00:04:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDA51360
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 00:04:25 +0000 (UTC)
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B11133
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:04:23 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id a1e0cc1a2514c-7809b741fe6so444394241.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 17:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685664262; x=1688256262;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W3pnAHSVW3eYxnV9ACkFH1u9krZff97VO3pjVJxkYmo=;
        b=jBAkISm68rGZP8e4vIPav3WY1JpJXrNXzM2Uc6SVZKa27q5eZsLnIv201YjPxPEecB
         O5Xzt91ijY8ZnDF7y5YZqFvn53KrdwhbgfFU4eXK+JBkYHPt/ExagiUD3wcw1o2ePhhn
         X7H5KvHec0mSUuJtPCgdaAhyBBicaC9xFTnmhqVj3n8WccMnuYkIzkaqQewuiZf+pPsx
         y4uk5bh1X73TjKbvnFDXsv1nR0nzNcY9b+cAQ8iltXPOxls1gBL/zfRNKaFiHRdA6z0O
         8AGOsQspNBeGSv2AEQyJvS0dx9J0VDnYlmlHRK6iskoC2yOUPFkeQ9A1BnJaCDUnL0b8
         bMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685664262; x=1688256262;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W3pnAHSVW3eYxnV9ACkFH1u9krZff97VO3pjVJxkYmo=;
        b=BtXW+4BCniYUyjyqa7b2wS2SKbtZRWZ13JLVaUVVdIcaY5qXAS+2cnAgsdMD8HYn1U
         9ibenm2tOd0Yo1tqGPERDkt45hpF1zbqtQZt5mtCwCrGFar+CTPLyalbFf99SscDMBxC
         xamgphQ1+83focQ1jbvLLpf/ZdI6j9qHETBIuZZMQTyEJftwZ7QD/eeJwwNSWSDMSOjc
         TPe/u2hjsZ2ZNu9j2W/e/2+n3/uOjl3EkNHZVuUIpR+NVFaDaXRsB8JAccj9PhLOtu1V
         Ew+L28cjCjBuw8WIJBxMq/naeSKVD3QS2h9l3/id8TiDl7G+W4cUcO/omLoMZ7Cgei2O
         RjUQ==
X-Gm-Message-State: AC+VfDyxrN+J7Mpi1O0oz7dbOLlW7atN6FjAyhRXQXIoaLH0zie5CpJU
	eWbjiLcO1qYg+dwXAh3m/zxbd4v9EMxBBTaDR9QmVBHI4G6GzMPhO7mPaYDCIr2RvXGiZ1yI6Pl
	4VZDiF65J6Uxc1Bbx94IPervLz4q80++BpJNHCoAQ69uGHHYFjgMy2IgRPes9Xfju
X-Google-Smtp-Source: ACHHUZ5ol5sbiXba1GCHekbR0EILfk/wzS3Y/s+n2vefP/xibQwJv3xHTuoPN5toPwgCnzPMmH9zd7lGt7bE
X-Received: from morats.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:d9e])
 (user=moritzf job=sendgmr) by 2002:a05:6102:474a:b0:439:3e4c:138c with SMTP
 id ej10-20020a056102474a00b004393e4c138cmr5306960vsb.3.1685664262487; Thu, 01
 Jun 2023 17:04:22 -0700 (PDT)
Date: Fri,  2 Jun 2023 00:04:14 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602000414.3294036-1-moritzf@google.com>
Subject: [PATCH net-next] net: lan743x: Remove extranous gotos
From: Moritz Fischer <moritzf@google.com>
To: netdev@vger.kernel.org
Cc: pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, bryan.whitehead@microchip.com, 
	UNGLinuxDriver@microchip.com, Moritz Fischer <moritzf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The gotos for cleanup aren't required, the function
might as well just return the actual error code.

Signed-off-by: Moritz Fischer <moritzf@google.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 20 +++++--------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 957d96a91a8a..f1bded993edc 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -160,16 +160,13 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
 {
 	struct lan743x_csr *csr = &adapter->csr;
 	resource_size_t bar_start, bar_length;
-	int result;
 
 	bar_start = pci_resource_start(adapter->pdev, 0);
 	bar_length = pci_resource_len(adapter->pdev, 0);
 	csr->csr_address = devm_ioremap(&adapter->pdev->dev,
 					bar_start, bar_length);
-	if (!csr->csr_address) {
-		result = -ENOMEM;
-		goto clean_up;
-	}
+	if (!csr->csr_address)
+		return -ENOMEM;
 
 	csr->id_rev = lan743x_csr_read(adapter, ID_REV);
 	csr->fpga_rev = lan743x_csr_read(adapter, FPGA_REV);
@@ -177,10 +174,8 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
 		   "ID_REV = 0x%08X, FPGA_REV = %d.%d\n",
 		   csr->id_rev,	FPGA_REV_GET_MAJOR_(csr->fpga_rev),
 		   FPGA_REV_GET_MINOR_(csr->fpga_rev));
-	if (!ID_REV_IS_VALID_CHIP_ID_(csr->id_rev)) {
-		result = -ENODEV;
-		goto clean_up;
-	}
+	if (!ID_REV_IS_VALID_CHIP_ID_(csr->id_rev))
+		return -ENODEV;
 
 	csr->flags = LAN743X_CSR_FLAG_SUPPORTS_INTR_AUTO_SET_CLR;
 	switch (csr->id_rev & ID_REV_CHIP_REV_MASK_) {
@@ -193,12 +188,7 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
 		break;
 	}
 
-	result = lan743x_csr_light_reset(adapter);
-	if (result)
-		goto clean_up;
-	return 0;
-clean_up:
-	return result;
+	return lan743x_csr_light_reset(adapter);
 }
 
 static void lan743x_intr_software_isr(struct lan743x_adapter *adapter)
-- 
2.41.0.rc0.172.g3f132b7071-goog


