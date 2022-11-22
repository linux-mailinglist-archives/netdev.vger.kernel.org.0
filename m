Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10CF634F96
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbiKWFbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiKWFbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:31:02 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95037ED715
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:30:56 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221123053054epoutp02a788c5c0e0466ec078ad2e1a8f601485~qH7CIj1bY1212912129epoutp02P
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:30:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221123053054epoutp02a788c5c0e0466ec078ad2e1a8f601485~qH7CIj1bY1212912129epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669181455;
        bh=uNgkOuD3RPHcSBkSiq6pg/mVd4Fv7cnPoyYY63AMJPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/Ul7Py14O6vSVVp/3quxEPtto9Mym3Qp8GmBfJA+TsYsLOYKW4xqAXvpHxnZNWug
         l35UnaGGPoSeJ5hei91kQc9uk/liuzuTPOpuyDLdaOG/jbH/v0IpeOEPOdYRinHzei
         ++WdZhs4cQ5znnqxIeycjT6Vt2sbX3+7wVhjFMWw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221123053054epcas5p314c5706d2a650b1ccb7e7046bde2854e~qH7BWnxEq2606226062epcas5p3Z;
        Wed, 23 Nov 2022 05:30:54 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NH8qH2Nsvz4x9QL; Wed, 23 Nov
        2022 05:30:51 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.FF.39477.B00BD736; Wed, 23 Nov 2022 14:30:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b~p4orKHLp42891928919epcas5p3H;
        Tue, 22 Nov 2022 10:50:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221122105022epsmtrp2b68721a6754af3ac3845ff1df5c78888~p4orIvhDV3232832328epsmtrp2S;
        Tue, 22 Nov 2022 10:50:22 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-f1-637db00bd847
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.72.14392.E69AC736; Tue, 22 Nov 2022 19:50:22 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221122105019epsmtip1b22090c23b59f16edbbbe6ac857a6127~p4ooOtWSA0765207652epsmtip1b;
        Tue, 22 Nov 2022 10:50:19 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH v3 1/2] can: m_can: Move mram init to mcan device setup
Date:   Tue, 22 Nov 2022 16:24:54 +0530
Message-Id: <20221122105455.39294-2-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221122105455.39294-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTe1BUVRzu3H3cC87GDVBOW9F6s4ydAXcRtoOBvQiuSg0zTDk2k8vOcocl
        4O62d9dHSUJmDaiAiCnEY0UZZSFYlgVx5bkSqTuBA0Xho1iJYggQoSGVAdtlof77ft/5vvP9
        zu+cQ/D8e4ViIo01MHpWlUEJffktV0JeDl1jyVLLztb6oZGKFiFyNDXjqKz/Cz6q7OkToLHe
        uzjKH3fx0I2WfAGyjg4JkPmfkzzkmtiJBu1lQnS6vwNDDVXFfNRrWofmnZMAVTX/jSPXTBuO
        Sm+0CtDh9h4c3ZqsF6BHZ67wUfWvlwSvr6NtNcMYbbIa6fsDtwBtNecK6dtDbUK66dxBumBR
        Rt/r+ElI59vMgF76vByn56zBiWs+SI/WMKoURi9hWLU2JY1NjaF2JCnfUkYqZPJQeRR6hZKw
        qkwmhopNSAyNS8twH5WS7FFlGN1UoorjqE1bo/Vao4GRaLScIYZidCkZughdGKfK5IxsahjL
        GLbIZbLwSLcwOV1TXGPBdTOB+xznO0E2qHoqD/gQkIyAjsfFgjzgS/iTlwEcKcrhe4tZACuu
        12LeYh7AzgcVvFVL8zX7ykI7gDkTTuAtDmOwpbJH4FEJSSkczTUt7xVI1mLQNudaVvHIUgye
        O3ST71EFkPFwsXMS92A++SLsz+1edovIV+Glvm7gzXse1lq6lrN9yGjY9XMr7tkIkiMEPNLW
        hHtFsbBxLl/gxQFw4nvbCi+Gc9PtQi9Ww9al3BWNBpqOt60EvAa7fixzN0S4uwuBDfZNXvo5
        ePJ6PebBPPJJeGzhd8zLi2BrxSreAMfnCgUeqyfqWF+Al6bhwoPzK4MsAPDi0GO8EASX/p9g
        AsAMnmZ0XGYqw0Xqwllm73/3ptZmWsHyg5ZubwWukZkwB8AI4ACQ4FGBooPbDqj9RSmq/Z8w
        eq1Sb8xgOAeIdM/vOE+8Vq11/wjWoJRHRMkiFApFRNRmhZwKEp09LVX7k6kqA5POMDpGv+rD
        CB9xNnbZaWm2DohDNurGtotfOFHkWpqV+v0pTJnnlPH2ge8iv74dXL+ruGC2nGF23NddTKaC
        2oYSasrzHwas54uKhkfztmgS33D8sbdhSqmz18T7Vg+sv/AuOJU2/FdTcta4WutUZO0DCXeU
        F2wxYb+NGqdiXqqOnvq48dtGfWHowtjDuEE268MTn7J1xMyZ3l2/aO68PTE7WNJ4deOX5rVV
        7793qqTyK/qjDlNCw81ks2U6aFs42l/7REivX/TM4mhOEVu306fq7jvP7KkrT6o/dK/7G8vm
        CScv1kLrCYNd8uZiRYc0e/wz6YHp3RrJ7kcGfMPVZ0v6Zo8yrqSga1udR+w/2OIoPqdRyaU8
        Paf6F5kZ7EFZBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWy7bCSnG7eyppkg1lrZC0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxpSVG9gLPohUHFq+n7GBcZFgFyMnh4SAicTWk7uYuhi5OIQEdjNK
        /Pj8hhkiISUx5cxLFghbWGLlv+fsEEXNTBJ/d81jB0mwCWhJPO5cwAKSEBHYzSTxtnsuWBWz
        wCImiZdXesFGCQu4S/zd/wasg0VAVeJ850FWEJtXwFpi57mDjBAr5CVWbzgAVs8pYCNx4PoO
        sHohoJrH8xqYJjDyLWBkWMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERxDWpo7GLev
        +qB3iJGJg/EQowQHs5IIb71nTbIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1Kz
        U1MLUotgskwcnFINTKxbZLQfPVV4uFNlxe3ParfEpz3zy52RajM17Id3A1urcOB1n9tV0TPm
        7Zi3SrV4yrYqEQM+jXNrmWMePY26Htoh/nBH+er1gj8qHNND55vMDJ7xsHbdyY+b/3zffeuh
        3wS/Ob+zJv3ufPGw0cXdnn1yUf3i55dW/tl3Sv0n5+0FZ+N38p9/m8z74M7kFXmBOe6Sun+L
        CsO385Ub7W6LPBOS2/t3I9dh9xCepUdWOSeY7DdmrQ9oltt+JU/mTM66Axd0rGVLNXi/ymik
        TI2ZfzLxlc6V2xynf8dMezrjwR2nN2wzNZRmrnN7futwyLYYvk97L99b0LVx5mvWeBExZq7Q
        sMeNq7wiSxUWBmX9nbNRiaU4I9FQi7moOBEAm1k9ARADAAA=
X-CMS-MailID: 20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b
References: <20221122105455.39294-1-vivek.2311@samsung.com>
        <CGME20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we try to access the mcan message ram addresses, hclk is
gated by any other drivers or disabled, because of that probe gets
failed.

Move the mram init functionality to mcan device setup called by
mcan class register from mcan probe function, by that time clocks
are enabled.

Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can.c          |  4 ++--
 drivers/net/can/m_can/m_can.h          |  1 +
 drivers/net/can/m_can/m_can_platform.c | 21 +++++++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a776cab1a5a4..5956f0b4d5b1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1516,9 +1516,9 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	}
 
 	if (cdev->ops->init)
-		cdev->ops->init(cdev);
+		err = cdev->ops->init(cdev);
 
-	return 0;
+	return err;
 }
 
 static void m_can_stop(struct net_device *dev)
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 401410022823..c6e77b93f4a2 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -93,6 +93,7 @@ struct m_can_classdev {
 	int is_peripheral;
 
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
+	bool mram_cfg_flag;
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index b5a5bedb3116..1a65b0d256fb 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -67,11 +67,28 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
 	return 0;
 }
 
+static int plat_init(struct m_can_classdev *cdev)
+{
+	int ret = 0;
+
+	if (!cdev->mram_cfg_flag) {
+		/* Initialize mcan message ram */
+		ret = m_can_init_ram(cdev);
+		if (ret)
+			return ret;
+
+		cdev->mram_cfg_flag = true;
+	}
+
+	return 0;
+}
+
 static struct m_can_ops m_can_plat_ops = {
 	.read_reg = iomap_read_reg,
 	.write_reg = iomap_write_reg,
 	.write_fifo = iomap_write_fifo,
 	.read_fifo = iomap_read_fifo,
+	.init = plat_init,
 };
 
 static int m_can_plat_probe(struct platform_device *pdev)
@@ -140,10 +157,6 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	ret = m_can_init_ram(mcan_class);
-	if (ret)
-		goto probe_fail;
-
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
 	if (ret)
-- 
2.17.1

