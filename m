Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69B1435B21
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 08:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhJUGwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 02:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhJUGwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 02:52:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B059AC06161C;
        Wed, 20 Oct 2021 23:50:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso4220905pjw.2;
        Wed, 20 Oct 2021 23:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n/WnfUHGrjFsi7eAxj2cYEnAL+3RQ1e1BC3gS76Zi04=;
        b=XGiKytCGB+rzIOUzb0FJCktz2XSjVhKgD2sIrm5xg56rIWrAwPwPlZaxDAIakqbFTB
         hVJ4nYOkqVl3atAKdydnPh1m/4hr2/yv8M06dOsWFtDSRNXU4D64pkG5szernFOn1eVe
         8e1Ovn9FSb2vox6uXwFEe4ZQYu4WcNUDTDl+rtyLGxI6kZMqJN1z/xwOk/fBF9pXvxMr
         w6baM0fHJD+S6X/MHC6CcT9csCUy4MyKKyavywCM1PIv2UVNZJmMKDWeg4SgEBSmVpjK
         clVHgey03iTqu/bjz+zW8Gw5srae5bmF7hA5Ll1NqedSRl9HyDL8ibSu+VIXI32htO6C
         nLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n/WnfUHGrjFsi7eAxj2cYEnAL+3RQ1e1BC3gS76Zi04=;
        b=FL3X7xOau/w9VoNCAtNjiGFMWQaqcpqXKbKfgn90ms6VztznovejggN4DEb5MsMJkM
         ILnGAzTqsdYFBF2r8Im4utHUqekICV87HhWOXvy2nZAicV+eCOcscGbdPsml/HZLWqPj
         wIUq1hSnYO6J8pa5y0MdHiDHJUOxRVD0cTZwBWEBmqgasJ2xsjEEZifC1J3QKkzr0aHh
         YqhVkPlH6aXN5u1vH/H10WtAQMpz6cFphmDiBl8J5VpcB7RCoI8azMcZc+UXixgOzZg+
         5vdCKAGsgluFi6veswgXbXtyF7KPnMsS0mcBJDwaI0CxXkwKUs70AyKI3YSgCfLtysKZ
         RxPA==
X-Gm-Message-State: AOAM5321mcnvAF0H/hgSC4HR3vB7LnkH45FpRkC1zr5kCbKPJ+PwqkwU
        lJo+GpOs7CLwCCZdVHlvje8=
X-Google-Smtp-Source: ABdhPJwe3rDtYznspODE6CUpVD/gUEDLb6EwFvgQvE8S46S+UPOuzuT6XaBjAM5PgFXD4Bg184ByPg==
X-Received: by 2002:a17:902:f545:b0:13f:7ea:ca43 with SMTP id h5-20020a170902f54500b0013f07eaca43mr3590547plf.76.1634799025276;
        Wed, 20 Oct 2021 23:50:25 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p8sm5024438pfo.112.2021.10.20.23.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 23:50:25 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     SimonHorman <horms@kernel.org>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] octeontx2-af: Remove redundant assignment operations
Date:   Thu, 21 Oct 2021 06:50:19 +0000
Message-Id: <20211021065019.1047768-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable err will be reassigned on subsequent branches, and this
assignment does not perform related value operations.

clang_analyzer complains as follows:

drivers/net/ethernet/marvell/sky2.c:4988: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 8b8bff5..33558aa 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4985,7 +4985,7 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > sizeof(u32) &&
-	    !(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
+	    !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err < 0) {
-- 
2.15.2


