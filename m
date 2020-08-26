Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1699E253A77
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHZW5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZW4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:43 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB3AC061756;
        Wed, 26 Aug 2020 15:56:43 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v9so4249658ljk.6;
        Wed, 26 Aug 2020 15:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGDCXvFspMO8NQAIm2Bj3sXT+iHnXd7C3vdQptV9New=;
        b=hdYNoVQ7SlUjI2/C2iMha+vQjOKczP0qwRf+g2wycZ98gtprwYQlG5f90v8HjeUBY4
         HmdJtE5LfDIM0lhx+5TsmcBj91cO1YBDfii/8Fqd6KZ+10wqOXNA2trX32dsqYXXNqhx
         fXutFRiRoW3GqXDoQeCCMz4h6/A9upyClKOuewzbF9atHPy/pHd38VwqHJgrhEDDWjNi
         eXhjTKL5WgHBm3te7+PFVqXxx4iyOdSym+aP9qJmbmKQj0rYuz3se3OEkBJeiaW+UXyo
         xJilzPCsKlC3CkPml80cpw0nOpnk8xT5X1HD8VrUKxf/bdYs60FdLj1OqQLr6TCn92gD
         3oHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGDCXvFspMO8NQAIm2Bj3sXT+iHnXd7C3vdQptV9New=;
        b=d6OW0Cu/u1qlNHJiVtcM+EJRI8BwcH5LlDnTAqM0gMTthKd+Z2G+bddrJmdZHiHFJH
         yuVMwz4cd5Ki9E8vBServ1iymtXRLt0FJwA2bJklvWXizRMtvinHq5hp4OlowZLtVvP1
         hDvyYdmBXhX40T8YENQDkD0lNlIslTaCbh4k2qddNSjHqV9v+lHPoWf4lKzEA+4vQ9nG
         f+BbLF33KpVnS8Vj4wI3KyD7mEIUqbh/6f861nIsw05lAHBCpfxAXdoNlkpwFaUu5jC5
         ao+j38Q+jSW/fHGKmQHhddMA9IZtDuXNgxDYbAejc2mgB0vfG0Rq+dDTac5I2fuKiQT0
         RvQQ==
X-Gm-Message-State: AOAM533D+jMz6du00PdCRkr/yDkRhlnozmqjN3fXVMoN2sTJ53YNlA0P
        HFYCjMXVkS9GogistPF2lFM=
X-Google-Smtp-Source: ABdhPJzzBL+4E4BcqqUd9CGQYIHBB7HWBXiQQs3DWkY9XegQYNiExDC7eIrYVSp44qu2pKrgdfCCoA==
X-Received: by 2002:a2e:503:: with SMTP id 3mr8725475ljf.225.1598482601871;
        Wed, 26 Aug 2020 15:56:41 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id u28sm49075ljd.39.2020.08.26.15.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:56:41 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH net-next 3/6] net: renesas: sh_eth: constify bb_ops
Date:   Thu, 27 Aug 2020 00:56:05 +0200
Message-Id: <20200826225608.90299-4-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
References: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of bb_ops is to assign its address to the ops field in
the mdiobb_ctrl struct, which is a const pointer. Make it const to allow
the compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index f45331ed90b0..586642c33d2b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1202,7 +1202,7 @@ static void sh_mdc_ctrl(struct mdiobb_ctrl *ctrl, int bit)
 }
 
 /* mdio bus control struct */
-static struct mdiobb_ops bb_ops = {
+static const struct mdiobb_ops bb_ops = {
 	.owner = THIS_MODULE,
 	.set_mdc = sh_mdc_ctrl,
 	.set_mdio_dir = sh_mmd_ctrl,
-- 
2.28.0

