Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6164413E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiLFK2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiLFK2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:28:49 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A9319023
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:28:48 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id x22so5024337ejs.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 02:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCEM+y7m5f5Vlw5yuLAzR/mUK1WXLosujaDAqDy6DB0=;
        b=XOGe3fJHve4wrmge372jlysw/hdgH71trCrue3aF4/+//xQdsKmDQTAoDtHrJ77Gup
         86VGj6JalrohzUXQQhGV3b4qZRsdd8+ThySianusEJMBuo9U6gcnweerM+72bPEoXew5
         d2pL4838T7ZwqhzjLZGBt2PEZ3pU1mzp2yp9lWttsT2Gee6P8u2VBvtDmdQrqoxk7zIK
         sT0rm2CA7bJqTU8hODIuK4uoQvXfgcr+i4hlVEU8D5ERnuoOtWElS2pejLGKaUgWydev
         eufeEe/1aUG8roTvYPgQbR3SJvyHAGFYtBFDPK+axOjbWhUIZCihn7WF8OrsVd9uw/EX
         Ax+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCEM+y7m5f5Vlw5yuLAzR/mUK1WXLosujaDAqDy6DB0=;
        b=xuw1mTbWeSGSlNdsoSdHD4sUUxT5XPp3XeThD/S3A+UItiyPwVT39UpMEl+vurzHuI
         i4J/XwfpKsCQWWhLWRK7Y6WnTK77F/SVKHNYMmliLGDekGOfIVjhKIybT+vRiCaGxBcR
         Y6JZTdOpK7LUr0tcm2xcRvH2zq1RBzNPZO8EF0xVmhdKhdgcB7QbzCsQsOLU7klQE5N5
         lqU/aBeD1+fsBmhptu8AFiQCh29gXvdBfcK6EUBu8P+/8SNr282WNJYb4jJJgUrcGAsL
         BdQqOtCF1iwKeRyrNsuh+AgUbLsBpzwtAfBtLm2pBN7RJbDxxFutwuEr+AMvpJBiXIFu
         tg8w==
X-Gm-Message-State: ANoB5pkDjxHj4kosOGSnKwla+MMdJ+HmU0teT9qdSAFTn2xGrZJqyI6Z
        e+SHcW0fpjaz+PU0dCQxVwYAeg==
X-Google-Smtp-Source: AA0mqf6IsWpflW9B9WFeWkAQqQcqhwTo/1/N1Ws9JQRo5VBUfWelaqnccAT2GCh13VeuvEhT2QShrQ==
X-Received: by 2002:a17:906:fa89:b0:7c0:bc68:c00a with SMTP id lt9-20020a170906fa8900b007c0bc68c00amr17209630ejb.665.1670322526480;
        Tue, 06 Dec 2022 02:28:46 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e24-20020a50fb98000000b004615e1bbaf4sm798259edq.87.2022.12.06.02.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 02:28:45 -0800 (PST)
Date:   Tue, 6 Dec 2022 11:28:44 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yuan Can <yuancan@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jeffrey.t.kirsher@intel.com,
        alice.michael@intel.com, piotr.marczak@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] intel/i40e: Fix potential memory leak in
 i40e_init_recovery_mode()
Message-ID: <Y48ZXIjtsXu/FZQR@nanopsycho>
References: <20221206092613.122952-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206092613.122952-1-yuancan@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 10:26:13AM CET, yuancan@huawei.com wrote:
>If i40e_vsi_mem_alloc() failed in i40e_init_recovery_mode(), the pf will be
>freed with the pf->vsi leaked.
>Fix by free pf->vsi in the error handling path.
>
>Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
>Signed-off-by: Yuan Can <yuancan@huawei.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>index b5dcd15ced36..d23081c224d6 100644
>--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>@@ -15536,6 +15536,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
> 	pci_disable_pcie_error_reporting(pf->pdev);
> 	pci_release_mem_regions(pf->pdev);
> 	pci_disable_device(pf->pdev);
>+	kfree(pf->vsi);

This is not the only thing which is wrong on this error path. Just
quickly looking at the code:
- kfree(pf->qp_pile); should be called here as well
- if i40e_setup_misc_vector_for_recovery_mode() fails,
  unregister_netdev() needs to be called.
- if register_netdev() fails, netdev needs to be freed at least.
Basically the whole error path is completely wrong.
I suggest to:

1) rely on error path of i40e_probe() when call of
   i40e_init_recovery_mode() fails and don't do the cleanup of
   previously inited things in i40e_probe() locally.
2) implement a proper local error path in i40e_init_recovery_mode()


> 	kfree(pf);
> 
> 	return err;
>-- 
>2.17.1
>
