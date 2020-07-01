Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82B4211139
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbgGAQxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732376AbgGAQxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:53:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86733C08C5C1;
        Wed,  1 Jul 2020 09:53:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d10so10138416pls.5;
        Wed, 01 Jul 2020 09:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kI+jHdY4m6ujscdkGQmRwNx+jC0maQNTY++oXpNulVY=;
        b=ur1ym4yjHLK++0JCz3oETZ83xil3HXeXa7T9kC4a+zYSqsisr0szH99Xc8SiT19RHz
         3BngHbshALJKHeAhMKHuQ2tnLx5fWdb23Zhgogg2o25uriCc12kkaJN0PPKTM59cgQ2t
         sgPoh/XR+B43OlPRQTLAwwA6xlWNTmew7A9+wfgw3PozrEsdMNIsYGiLp6+zc76wUnvS
         hJqjIjgVgXfjpfCriNlu/TDlSaWVRpiipPiTUwy4Q3HOzw3c1XEklzvCS2eaeAqOy5xP
         yb0PnesDGVk6ktCpGYfBD9qYxoDh9rfd0sAdRFfqOpn1k1mAtijFVL+0CwPFTg9Bvpp7
         M24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kI+jHdY4m6ujscdkGQmRwNx+jC0maQNTY++oXpNulVY=;
        b=k1nPfBS1StsRs52t3pIp3I3PpHVh+Z3RYXDaKaeKM3f8ZHxSVO4ka2+CqqPh6uFZ7z
         GS0sUiwgGcT3TZdGO2AlyJLCgzPwiVP8OdC2ij/tuAYBS0MOeXSzV2Ur4tbzYKO1dTmR
         e1cIjgNw/v6Il8y5Dxfe0yxOZghB7nhAey3d0DbD4uF6CcUMpP41ua2Jodv6MDReudQH
         oCC0E7gDn5oormC4Mrf24pv7xuEZKeksn1KezMShDmcG4RC8+4A8A35WcHosLO4pzaBr
         +1k97DZq3hL3YlpzzgwhknR8jjsSlUAqbygyX20gXzXQX65RAWKr6GsobttDEW19Wtyx
         wejA==
X-Gm-Message-State: AOAM531ibtST+qbHvt1S35yCaf9FLlFL0oGrOIWoRAtAMx3oHAykP0Pd
        YG9aXLLnYYwPmKv9vHQlcDg=
X-Google-Smtp-Source: ABdhPJyFgGaA0OqAiw8EI0MoOyikGYnCY9PhRj/BiZUfY8DDTZvrPNzOcPBsFmCTHaiSsZDXfsp8oQ==
X-Received: by 2002:a17:90b:705:: with SMTP id s5mr22413556pjz.11.1593622418013;
        Wed, 01 Jul 2020 09:53:38 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:53:37 -0700 (PDT)
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
Subject: [PATCH v2 08/11] mlx4: use generic power management
Date:   Wed,  1 Jul 2020 22:20:54 +0530
Message-Id: <20200701165057.667799-9-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
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

