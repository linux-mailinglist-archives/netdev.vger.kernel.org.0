Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA66210B9D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgGANDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730951AbgGANDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:03:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D11C03E979;
        Wed,  1 Jul 2020 06:03:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so4823060pgm.11;
        Wed, 01 Jul 2020 06:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kI+jHdY4m6ujscdkGQmRwNx+jC0maQNTY++oXpNulVY=;
        b=uteFW5cJ7XOW5/Lkb2Bjm1wbAASldz3eVPD6ugPdHG0XD7KSq4/gV3gAa4hR5XaIvO
         tnDnl/MfVwrp5DuUPZtfE4x0J0E9Rx14lqVLLYUVl2tCDXZq8DBuszhdDN5NvPcTm12F
         Zx6fbdgQu19bmo1DOghhDJiRuyUI4VfEaFsOh8G4e3aLtVZNqTNH5dSSSY+G4GM7ELSt
         RJlkQy8+saiFphhBg3I9ns7vZ0qVgccy104uC4Iy5r4IhBgQNI/q9wG8FsAvKU4SRkif
         jFFYJIxnxLUm7jsQPorTa+mxWAnj+SDnKKg3Jrr7L7tzz5Unn/BH923O6cL5yXBZcPDD
         L2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kI+jHdY4m6ujscdkGQmRwNx+jC0maQNTY++oXpNulVY=;
        b=Zd3YnFcF9k+FcdX3Pj5hQ2rKAz+3f8WtW7eLKMxcmpZi7AcTjRQ09wk1+JkA9mTaeP
         6prEQjOr1N54CgDmGc3NlpQuSkCBP0v5TEDB4rE7vTSDJZEo7bbF3nm/h9o5eaoLPu1o
         GcOq7I0wIqGBysbbav27LLk16g93mrKTkm36NNrBygbp7gygaklAwytqZeflpq+bQ9H/
         QfL1/e5XYchcgsmtGrnU4N10zARQu9fHsWgynlM3Re0/yIT+ADM9QLh+WBJj+pNNJ5Ub
         hlOUu5Y3cLLmHBNhUIdLTEUI+fz8WgiVZQj0I08JjCUT/MDH0hsV+m2hzOOcjVF6dJxH
         kvRg==
X-Gm-Message-State: AOAM5325g0HJ9mPaqKfjuhqdkJahUYoCtbEMbL/alLCHopkfd0xBV0n0
        GgyS+DaQqr6ghgSDKaIAT8g=
X-Google-Smtp-Source: ABdhPJzQNYhRDP6nH9+FZrJ6Z/cLClCs5+3vET2wEt75WkzLoaMqOiPuT9H9pvQrzH4Cf2dRBOpLEA==
X-Received: by 2002:a63:ee48:: with SMTP id n8mr19864420pgk.292.1593608586651;
        Wed, 01 Jul 2020 06:03:06 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:03:06 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 08/11] mlx4: use generic power management
Date:   Wed,  1 Jul 2020 18:29:35 +0530
Message-Id: <20200701125938.639447-9-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

Use "struct dev_pm_ops" variable to bind the callbacks.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 3d9aa7da95e9..4cae7db8d49c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4370,8 +4370,9 @@ static const struct pci_error_handlers mlx4_err_handler = {
 	.resume		= mlx4_pci_resume,
 };
 
-static int mlx4_suspend(struct pci_dev *pdev, pm_message_t state)
+static int mlx4_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev	*dev = persist->dev;
 
@@ -4384,8 +4385,9 @@ static int mlx4_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int mlx4_resume(struct pci_dev *pdev)
+static int mlx4_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev	*dev = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -4414,14 +4416,15 @@ static int mlx4_resume(struct pci_dev *pdev)
 	return ret;
 }
 
+static SIMPLE_DEV_PM_OPS(mlx4_pm_ops, mlx4_suspend, mlx4_resume);
+
 static struct pci_driver mlx4_driver = {
 	.name		= DRV_NAME,
 	.id_table	= mlx4_pci_table,
 	.probe		= mlx4_init_one,
 	.shutdown	= mlx4_shutdown,
 	.remove		= mlx4_remove_one,
-	.suspend	= mlx4_suspend,
-	.resume		= mlx4_resume,
+	.driver.pm	= &mlx4_pm_ops,
 	.err_handler    = &mlx4_err_handler,
 };
 
-- 
2.27.0

