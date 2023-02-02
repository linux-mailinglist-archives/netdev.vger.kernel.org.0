Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2090F687403
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 04:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBBDj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 22:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjBBDi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 22:38:57 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4C97D2B7
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 19:38:33 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id c2so680759qtw.5
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 19:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YaCGMztxAychzBKWXyg0v44rVDVpPpOLPvV3hnW7dDU=;
        b=DYobpI/QvCuXNbzJ9/u2sWsHRyskkKN8RcPAjlFlWegsHzrWz5/5jf+tNKwMx4XB08
         0CTKABCi99zzxSAXW9+ZUwUWkDthJeELjLnLREm6X7g+qR3DYtpK7Z4IZHi6fiIgUXdJ
         e2jbvn2JWDIFfzd86bEFSVHNiFeJiMZG26oJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YaCGMztxAychzBKWXyg0v44rVDVpPpOLPvV3hnW7dDU=;
        b=OaGukGSL2hszySs/tzUZH6iG2GLeoXestCLVA8Z9uLwEIU/MBJtQImPjjByZxQnkZl
         QpPIM5VJqAZPV90EAAsUny+IvDGD5iWDB0nJUjjKFq/SVJdgswITtROV1+lHr+rZQeGs
         wE/VqZk9vU4Cu7ZOpIurHp6Kj1lCYNexkcFMv9aqn03Ww8j0gBQBPBwqyTK2X+YUvB7F
         5nayAaTFu+1rYeInQLAUY8dyk9K2mCMwzfLLe9PvDXYLW2ihqOm6Zb41n1K4d+lwNvrY
         fSq0EHvus2mpf3zYyEps9s78msXRNiAhURowUlVEVo3ieI/FMF1lznmBzlMwKCdJC70A
         bIww==
X-Gm-Message-State: AO0yUKUPQRhls6FrFXX6t9VfJNYVhzToAHupQzDPVBunhyPtD/l00gl4
        +B7eJloSUtUIcjp3ClcKpLeEtQ==
X-Google-Smtp-Source: AK7set+LRvR3TjH1YT9VGOhDynadySo7GPlaK4vdtuIqKtWrBH2g0J0JUbYcbgnUQmsphPGtd6Ivng==
X-Received: by 2002:a05:622a:11c8:b0:3a5:ff6e:d425 with SMTP id n8-20020a05622a11c800b003a5ff6ed425mr9980716qtk.4.1675309112807;
        Wed, 01 Feb 2023 19:38:32 -0800 (PST)
Received: from localhost.localdomain ([2605:a601:a780:1400:3d86:d226:5cc5:3432])
        by smtp.gmail.com with ESMTPSA id p12-20020ac8408c000000b003b869f71eedsm7244487qtl.66.2023.02.01.19.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 19:38:32 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, gregkh@linuxfoundation.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v11 7/8] RDMA/bnxt_re: Remove the sriov config callback
Date:   Wed,  1 Feb 2023 19:38:08 -0800
Message-Id: <20230202033809.3989-8-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230202033809.3989-1-ajit.khaparde@broadcom.com>
References: <20230202033809.3989-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009350d605f3af4c5b"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009350d605f3af4c5b
Content-Transfer-Encoding: 8bit

Remove the SRIOV config callback which the bnxt_en was calling
to reconfigure the chip resources for a PF device when VFs are
created. The code is now modified to provision the VF resources
based on the total VF count instead of the actual VF count.
This allows the SRIOV config callback to be removed from the
list of ulp_ops.

Suggested-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 11 ++++---
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |  7 +----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 29 -------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  1 -
 4 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index ed7ac6acaaff..60df6809bc60 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -221,13 +221,12 @@ static void bnxt_re_set_resource_limits(struct bnxt_re_dev *rdev)
 		bnxt_re_limit_vf_res(&rdev->qplib_ctx, num_vfs);
 }
 
-static void bnxt_re_sriov_config(void *p, int num_vfs)
+static void bnxt_re_vf_res_config(struct bnxt_re_dev *rdev)
 {
-	struct bnxt_re_dev *rdev = p;
 
 	if (test_bit(BNXT_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags))
 		return;
-	rdev->num_vfs = num_vfs;
+	rdev->num_vfs = pci_sriov_get_totalvfs(rdev->en_dev->pdev);
 	if (!bnxt_qplib_is_chip_gen_p5(rdev->chip_ctx)) {
 		bnxt_re_set_resource_limits(rdev);
 		bnxt_qplib_set_func_resources(&rdev->qplib_res, &rdev->rcfw,
@@ -297,7 +296,6 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 }
 
 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
-	.ulp_sriov_config = bnxt_re_sriov_config,
 	.ulp_irq_stop = bnxt_re_stop_irq,
 	.ulp_irq_restart = bnxt_re_start_irq
 };
@@ -1369,6 +1367,11 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 		INIT_DELAYED_WORK(&rdev->worker, bnxt_re_worker);
 		set_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags);
 		schedule_delayed_work(&rdev->worker, msecs_to_jiffies(30000));
+		/*
+		 * Use the total VF count since the actual VF count may not be
+		 * available at this point.
+		 */
+		bnxt_re_vf_res_config(rdev);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index a4cba7cb2783..3ed3a2b3b3a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -749,7 +749,6 @@ int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset)
 		*num_vfs = rc;
 	}
 
-	bnxt_ulp_sriov_cfg(bp, *num_vfs);
 	return 0;
 }
 
@@ -823,10 +822,8 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 		goto err_out2;
 
 	rc = pci_enable_sriov(bp->pdev, *num_vfs);
-	if (rc) {
-		bnxt_ulp_sriov_cfg(bp, 0);
+	if (rc)
 		goto err_out2;
-	}
 
 	return 0;
 
@@ -872,8 +869,6 @@ void bnxt_sriov_disable(struct bnxt *bp)
 	rtnl_lock();
 	bnxt_restore_pf_fw_resources(bp);
 	rtnl_unlock();
-
-	bnxt_ulp_sriov_cfg(bp, 0);
 }
 
 int bnxt_sriov_configure(struct pci_dev *pdev, int num_vfs)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 132df8275ab1..9525bd368e43 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -259,16 +259,6 @@ int bnxt_send_msg(struct bnxt_en_dev *edev,
 }
 EXPORT_SYMBOL(bnxt_send_msg);
 
-static void bnxt_ulp_get(struct bnxt_ulp *ulp)
-{
-	atomic_inc(&ulp->ref_count);
-}
-
-static void bnxt_ulp_put(struct bnxt_ulp *ulp)
-{
-	atomic_dec(&ulp->ref_count);
-}
-
 void bnxt_ulp_stop(struct bnxt *bp)
 {
 	struct bnxt_aux_priv *aux_priv = bp->aux_priv;
@@ -321,25 +311,6 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 
 }
 
-void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
-{
-	struct bnxt_en_dev *edev = bp->edev;
-	struct bnxt_ulp_ops *ops;
-	struct bnxt_ulp *ulp;
-
-	if (!edev)
-		return;
-	ulp = edev->ulp_tbl;
-
-	ops = rcu_dereference(ulp->ulp_ops);
-	if (!ops || !ops->ulp_sriov_config)
-		return;
-
-	bnxt_ulp_get(ulp);
-	ops->ulp_sriov_config(ulp->handle, num_vfs);
-	bnxt_ulp_put(ulp);
-}
-
 void bnxt_ulp_irq_stop(struct bnxt *bp)
 {
 	struct bnxt_en_dev *edev = bp->edev;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index c62986e4cc82..ed2832975912 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -26,7 +26,6 @@ struct bnxt_msix_entry {
 };
 
 struct bnxt_ulp_ops {
-	void (*ulp_sriov_config)(void *, int);
 	void (*ulp_irq_stop)(void *);
 	void (*ulp_irq_restart)(void *, struct bnxt_msix_entry *);
 };
-- 
2.37.1 (Apple Git-137.1)


--0000000000009350d605f3af4c5b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAi+4cH3q5mQn54hBItk
u56spQZAQflXNlH08l0cOuRAMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDIwMjAzMzgzM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCeVunbCsqhQOyGbWa3xiIs2nc5vR5nTCHztKsS
ChTz/D0K9UcKkpHQS+7LCtgfPXGCaiGWva7VpCbtCWRojm6Fh3eh4NAygvvOJgfq4x5VEv/A33cq
UbtixMQXCjmucHR/XtgUTFt5bs680z7bLGRuaYrmU9k6t1utJuoFuBRPq5Znat4Fy2fcorv+Lo2Z
Uw6EFs9pjh6/ExXEY/kbXCG+kjkDDQUAHDT0W+NbKDjS9r1m9OnKwh2C81h78LM6hBpejp3esEru
1gYJIMuvrctSBz4uMaWULUr+oWEAUBeVN379KBZeGdPFOO3BrZpwN3O8mCHYa7T2OZ4GUTLSuSSm
--0000000000009350d605f3af4c5b--
