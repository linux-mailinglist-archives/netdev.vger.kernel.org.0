Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F660209C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiJRBwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJRBwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:52:11 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E30726A5;
        Mon, 17 Oct 2022 18:52:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so12604660pjf.5;
        Mon, 17 Oct 2022 18:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F3wlL/ajAUZuSQuLqok2LEp7cE4Q1lhw7nG0x3vWvLo=;
        b=P1SVxKZ2xqPlH9qEWdAyz53sslUpBq9ek4rcAhQBWVpGP9XZXylE7eS1/AUJKnWxnP
         P53s/RSQUeZ2CxZU2gBFXZHCg3/NagaMhm9bVmEt1UnpNZsi195LL8jEJFL6fcpJe03m
         WEKuazMMwZtcLk6UgL7jvusDptk0HGr5MxnJ+9K/NNsccecxQB3DpwrfZ30oYJsDwmUg
         zlD6L3ahG9V2wcClpSxnHOBzYnRyW8CW8YSVgq8uPZX7TO89VBjyqZYp4j0Z19k04K4v
         vPHb6Z0hSY0HfLqLPtWdtmhmIZ4w+7CbDaLDDDzsbQc72xNJZUiLCJmvRcfoaAZZF7oP
         YISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F3wlL/ajAUZuSQuLqok2LEp7cE4Q1lhw7nG0x3vWvLo=;
        b=79PyCT4S2xJsAbxTxRAhH+JpSbMACzKe9InT7uBed4JFtnMSs1uuUiZkiI9dxKx8Ay
         LIozZSTCuBLHcmK+MAKVrbHOl03hqAjCGdSWVsp1jBEcPgdxqEcQNgUA+i7vEqvnG0Jf
         F4U7e2xS7onZ4N46Dh5tShGG/lcnNpcW5xptpQ/aYww7tM9dwrS0UEqQUex3npibOkCJ
         jJpj4eUNeUsU8WoHnzDsb6hjur+MLFM7lcLggYdTEIuVYihJGkLmXLbkpAgv/eCYcrKR
         G76ECZ9XxurBKNkkp6JhkKup49z0Fh1ZEm8/NaEJyqbE6m1vfjn2JBxZU/vzZpHYzueW
         xQ7A==
X-Gm-Message-State: ACrzQf0IvT7nadzkRayfyMk8QHzm6U5gsrhlxKIh2mDOeo/TaIVTuu0K
        Z9OZ0rWT9dHR8cL6QIkS8tk1ViXMgeKvmw==
X-Google-Smtp-Source: AMsMyM74RdouSv91fKy3+4W3vZG8c+FzbiKPyhvlH32MBNCQ2sa8lLEHykHSkg1RXwSPvg6JGldPHA==
X-Received: by 2002:a17:90b:2651:b0:20a:daaf:75f0 with SMTP id pa17-20020a17090b265100b0020adaaf75f0mr800721pjb.142.1666057930614;
        Mon, 17 Oct 2022 18:52:10 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z22-20020a62d116000000b0055f209690c0sm7771997pfg.50.2022.10.17.18.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 18:52:10 -0700 (PDT)
From:   yexingchen116@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jacob.e.keller@intel.com, joe@perches.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>
Subject: [PATCH linux-next v2] iavf: Replace __FUNCTION__ with __func__
Date:   Tue, 18 Oct 2022 01:52:04 +0000
Message-Id: <20221018015204.371685-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

__FUNCTION__ exists only for backwards compatibility reasons with old
gcc versions. Replace it with __func__.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v1 -> v2
Fix the message up to use ("message in %s\n", __func__)
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3fc572341781..efa2692af577 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
 		iavf_close(netdev);
 
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
+		dev_warn(&adapter->pdev->dev, "%s: failed to acquire crit_lock\n", __func__);
 	/* Prevent the watchdog from running. */
 	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
-- 
2.25.1

