Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50606449C2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiLFQyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiLFQym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:54:42 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B1E223
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:54:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vv4so7729348ejc.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vzqbbTfvlcGhXkAxJtWVnd12rliOcj/M8dWbh5Wuvz8=;
        b=GJ9AXpHrzyHNWZ6MD0ZKBtWOC77CgcraKLQMZ+UAAVh6cVD9RV1f9PFoqbC/l6EEeN
         kqNVp9G8BiAXSJ150ElWkmihb6vSyeoMqAeVOUve+AR2T+X1SR0oaul2/RbKdc3pEDl2
         VQ2FmToTfHcLnNjppG08XLXCWZwfEHBi4JA3/oCzm7ASotT9SqA2aM09JXkcZ3hu8GcW
         iYVwbqiaRZC0UkeGFyzQPO8LBnZP0Pi1tJVALEMF/Sct4/hW8wnbjZpYxF1DEQcWZ3TN
         qDOJjZmJ+0jxk5dwGOWR+F68gGe9iIndiVVhPRa7XjiWYw5TfFZIwpWcjgCK831A6krG
         xphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzqbbTfvlcGhXkAxJtWVnd12rliOcj/M8dWbh5Wuvz8=;
        b=4DpzNyiKUwcogR5C6cBAOu0ukQibSrCUjXL7eWInmCvfcvc5QG9tW4JvAE9OoBUB4d
         5wwvuP10qfgP1bExKrloSkHZ61fQFOvy50oIAvr6n4oayihto+9WdWH28uP0zda9A4Rk
         Zx6rpW2ScGhIX0iZYTqGAxGAJf3l7s7FC2sPV2T71Qc4Rh5kMWi5whpMEtliTK/2u/Nq
         xuPRC70RcHDk3dgGm1SRHQjIUNR0NlXC7+Z7aafYYBeLLC+sGkpVUXbldktGdpcfrBee
         dVtx/IdsfzlqzzwtUg7rJ70zbqYucnH0IWqTtF9THu5EKf8gFUGxenVAUuiHMlIYJnkX
         FDSg==
X-Gm-Message-State: ANoB5pnsEG31TAWaaH2O5nqurCjHWayZtDBKSgvLMKzfs0sQbdMZN/9z
        icNWpDOz/l65SlNrvpJuFr7uMw==
X-Google-Smtp-Source: AA0mqf53Gsku8H34rrDGggPtq7Dg4wvL+h11DxRKD8UDk1B2WOwck1mMU1uN/IJ7meXkmnyqUDZ1Tw==
X-Received: by 2002:a17:907:20e2:b0:7c0:bc26:45e1 with SMTP id rh2-20020a17090720e200b007c0bc2645e1mr17673807ejb.645.1670345680181;
        Tue, 06 Dec 2022 08:54:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b19-20020a17090630d300b007adade0e9easm4907203ejb.85.2022.12.06.08.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:54:39 -0800 (PST)
Date:   Tue, 6 Dec 2022 17:54:38 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yuan Can <yuancan@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alice.michael@intel.com,
        piotr.marczak@intel.com, jeffrey.t.kirsher@intel.com,
        leon@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3] intel/i40e: Fix potential memory leak in
 i40e_init_recovery_mode()
Message-ID: <Y49zzo/L9oY1v8OB@nanopsycho>
References: <20221206134146.36465-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206134146.36465-1-yuancan@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 02:41:46PM CET, yuancan@huawei.com wrote:
>The error handling path of i40e_init_recovery_mode() does not handle the
>vsi->netdev and pf->vsi, and resource leak can happen if error occurs.
>
>In the meantime, the i40e_probe() returns directly without release
>pf->qp_pile when i40e_init_recovery_mode() failed.
>
>Fix by properly releasing vsi->netdev in the error handling path of
>i40e_init_recovery_mode() and relying on the error handling path of
>i40e_probe() to release pf->vsi and pf->qp_pile if anything goes wrong.
>
>Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
>Signed-off-by: Yuan Can <yuancan@huawei.com>
>---
>Changes in v3:
>- Introduce more error handling path to handle vsi->netdev
>- Rely on error path of i40e_probe() instead of do all cleanup in
>  i40e_init_recovery_mode() to make sure pf->qp_pile is not leaked
>
>Changes in v2:
>- Add net in patch title
>- Add Leon Romanovsky's reviewed by
>
> drivers/net/ethernet/intel/i40e/i40e_main.c | 21 ++++++++++++---------
> 1 file changed, 12 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>index b5dcd15ced36..d1aadd298ea7 100644
>--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>@@ -15511,13 +15511,13 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
> 		goto err_switch_setup;
> 	err = register_netdev(vsi->netdev);
> 	if (err)
>-		goto err_switch_setup;
>+		goto free_netdev;
> 	vsi->netdev_registered = true;
> 	i40e_dbg_pf_init(pf);
> 
> 	err = i40e_setup_misc_vector_for_recovery_mode(pf);
> 	if (err)
>-		goto err_switch_setup;
>+		goto unreg_netdev;
> 
> 	/* tell the firmware that we're starting */
> 	i40e_send_version(pf);
>@@ -15528,15 +15528,15 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
> 
> 	return 0;
> 
>+unreg_netdev:
>+	unregister_netdev(vsi->netdev);
>+free_netdev:
>+	free_netdev(vsi->netdev);

[...]

> err_switch_setup:
> 	i40e_reset_interrupt_capability(pf);
> 	del_timer_sync(&pf->service_timer);
> 	i40e_shutdown_adminq(hw);

These are on a error patch in i40e_probe(). Again, you should cleanup
here only what you initialized.


>-	iounmap(hw->hw_addr);
>-	pci_disable_pcie_error_reporting(pf->pdev);
>-	pci_release_mem_regions(pf->pdev);
>-	pci_disable_device(pf->pdev);
>-	kfree(pf);
>+	kfree(pf->vsi);
> 
> 	return err;
> }
>@@ -15789,8 +15789,11 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> 		goto err_sw_init;
> 	}
> 
>-	if (test_bit(__I40E_RECOVERY_MODE, pf->state))
>-		return i40e_init_recovery_mode(pf, hw);
>+	if (test_bit(__I40E_RECOVERY_MODE, pf->state)) {
>+		err = i40e_init_recovery_mode(pf, hw);
>+		if (err)
>+			goto err_init_lan_hmc;

Use a new label here.


Also, you need to return 0 here in case of success. Did you test the
patch?





>+	}
> 
> 	err = i40e_init_lan_hmc(hw, hw->func_caps.num_tx_qp,
> 				hw->func_caps.num_rx_qp, 0, 0);
>-- 
>2.17.1
>
