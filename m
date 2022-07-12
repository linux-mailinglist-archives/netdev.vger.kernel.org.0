Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8DB5713A3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 09:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiGLH4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 03:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiGLH4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 03:56:43 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443B79C255
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:56:42 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay25so4251850wmb.1
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YGx9nZAqSbS3f88ErZSJciUelEwssPaSeAlW2Gzvf+8=;
        b=aTbzBgOULuxdeFQYxeL7mafGL+peDpN9VRl5FAZziOtOw0VarPvlB72Xj7FIVZRkgi
         Ik2eEBsoVlNtbFJm2pQ7IVbQRkz+ki/3Pr25GdQxWwuZvb1aCQtPb3Xv5pst2PIy3x+Q
         vIDpOOehQEMh0xE7cJglFi8Ub3mCAEkn/y2wtsm4DfBhaSfKmMBlfPNXrJbpVQEQtlKl
         asghlzXnMw6rvoIMeuQTxH9TEnf6ujO7H/+siTfmFWVB+6Ibaa8GHBcn0vX6/XiIEs67
         iSz6I0Pam3OUAQ0+/T+uMhyeyvU+oQoHlKkrbPqlhaNCHJlzn6n1Pbrl0OlDYK1HmYJR
         dxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=YGx9nZAqSbS3f88ErZSJciUelEwssPaSeAlW2Gzvf+8=;
        b=4nCZPq6e+shgf5zH4+GXoAgAnaPn95nlzIzUKTwmnJU4D3E18mdj8G8FW0Vrp9quFK
         kSEUo3zuGV1CxxovM3QkIfGOxuxxFZOjgmaucG64LFy7GryNpIJb0nV3gfSjDiWBc6Pc
         McYCVSeYvsTHyhWF8Sx1+zzwbd34/Z6E6KGC1yYl3hIbjoKNvj+uCSu2L8WqRaWwt6Km
         7x8si5XBrDPYqaIkZwFMiwTW921xCVVwh6syDVEHMG8mXxVjE9drDLZPh3hBZhG97/wq
         XpZoBEAcKrk8g7gJaXNJ9eKbHln7Uw5PM4UgGbvsP62Lr9WBEGc4Y6RQaVGVGAMbu/8U
         oTug==
X-Gm-Message-State: AJIora+aCo0QiymWyQwzUqqDe5p2oOcPr6Knr5ggEEcHN+6o2dRH5cVe
        sEj4lCyPK/quM6aIhBLAnxc=
X-Google-Smtp-Source: AGRyM1tRLfMk0kGxfOwrc8yJcJXMRoR/5sABqKFUQ1YteA8IN7qGvtCAsqby4J+ZtnOIV4zU2QGTHw==
X-Received: by 2002:a7b:cb41:0:b0:3a2:d6eb:135d with SMTP id v1-20020a7bcb41000000b003a2d6eb135dmr2528995wmj.150.1657612600702;
        Tue, 12 Jul 2022 00:56:40 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c4f9200b003a2ec73887fsm1387220wmq.1.2022.07.12.00.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:56:40 -0700 (PDT)
Date:   Tue, 12 Jul 2022 08:56:37 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, sshah@solarflare.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Yanghang Liu <yanghliu@redhat.com>
Subject: Re: [PATCH v2 net] sfc: fix use after free when disabling sriov
Message-ID: <Ys0pNQWAJneX1gQ8@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, sshah@solarflare.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Yanghang Liu <yanghliu@redhat.com>
References: <20220712062642.6915-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220712062642.6915-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 08:26:42AM +0200, Íñigo Huguet wrote:
> Use after free is detected by kfence when disabling sriov. What was read
> after being freed was vf->pci_dev: it was freed from pci_disable_sriov
> and later read in efx_ef10_sriov_free_vf_vports, called from
> efx_ef10_sriov_free_vf_vswitching.
> 
> Set the pointer to NULL at release time to not trying to read it later.

This solution just bypasses the check we have in
efx_ef10_sriov_free_vf_vports():
                /* If VF is assigned, do not free the vport  */
                if (vf->pci_dev && pci_is_dev_assigned(vf->pci_dev))
                        continue;

If we don't want to detect this any more we should remove this
check in stead of this patch.
There is another issue here, in efx_ef10_sriov_free_vf_vswitching()
we do free the memory even if a VF was still assigned. This leads me
to think that removing the check above is the better thing to do.

Martin

> Reproducer and dmesg log (note that kfence doesn't detect it every time):
> $ echo 1 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
> $ echo 0 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
> 
>  BUG: KFENCE: use-after-free read in efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
> 
>  Use-after-free read at 0x00000000ff3c1ba5 (in kfence-#224):
>   efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
>   efx_ef10_pci_sriov_disable+0x38/0x70 [sfc]
>   efx_pci_sriov_configure+0x24/0x40 [sfc]
>   sriov_numvfs_store+0xfe/0x140
>   kernfs_fop_write_iter+0x11c/0x1b0
>   new_sync_write+0x11f/0x1b0
>   vfs_write+0x1eb/0x280
>   ksys_write+0x5f/0xe0
>   do_syscall_64+0x5c/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>  kfence-#224: 0x00000000edb8ef95-0x00000000671f5ce1, size=2792, cache=kmalloc-4k
> 
>  allocated by task 6771 on cpu 10 at 3137.860196s:
>   pci_alloc_dev+0x21/0x60
>   pci_iov_add_virtfn+0x2a2/0x320
>   sriov_enable+0x212/0x3e0
>   efx_ef10_sriov_configure+0x67/0x80 [sfc]
>   efx_pci_sriov_configure+0x24/0x40 [sfc]
>   sriov_numvfs_store+0xba/0x140
>   kernfs_fop_write_iter+0x11c/0x1b0
>   new_sync_write+0x11f/0x1b0
>   vfs_write+0x1eb/0x280
>   ksys_write+0x5f/0xe0
>   do_syscall_64+0x5c/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>  freed by task 6771 on cpu 12 at 3170.991309s:
>   device_release+0x34/0x90
>   kobject_cleanup+0x3a/0x130
>   pci_iov_remove_virtfn+0xd9/0x120
>   sriov_disable+0x30/0xe0
>   efx_ef10_pci_sriov_disable+0x57/0x70 [sfc]
>   efx_pci_sriov_configure+0x24/0x40 [sfc]
>   sriov_numvfs_store+0xfe/0x140
>   kernfs_fop_write_iter+0x11c/0x1b0
>   new_sync_write+0x11f/0x1b0
>   vfs_write+0x1eb/0x280
>   ksys_write+0x5f/0xe0
>   do_syscall_64+0x5c/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fixes: 3c5eb87605e85 ("sfc: create vports for VFs and assign random MAC addresses")
> Reported-by: Yanghang Liu <yanghliu@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
> v2: add missing Fixes tag
> 
>  drivers/net/ethernet/sfc/ef10_sriov.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
> index 7f5aa4a8c451..92550c7e85ce 100644
> --- a/drivers/net/ethernet/sfc/ef10_sriov.c
> +++ b/drivers/net/ethernet/sfc/ef10_sriov.c
> @@ -408,8 +408,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
>  static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
>  {
>  	struct pci_dev *dev = efx->pci_dev;
> +	struct efx_ef10_nic_data *nic_data = efx->nic_data;
>  	unsigned int vfs_assigned = pci_vfs_assigned(dev);
> -	int rc = 0;
> +	int i, rc = 0;
>  
>  	if (vfs_assigned && !force) {
>  		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
> @@ -417,10 +418,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
>  		return -EBUSY;
>  	}
>  
> -	if (!vfs_assigned)
> +	if (!vfs_assigned) {
> +		for (i = 0; i < efx->vf_count; i++)
> +			nic_data->vf[i].pci_dev = NULL;
>  		pci_disable_sriov(dev);
> -	else
> +	} else {
>  		rc = -EBUSY;
> +	}
>  
>  	efx_ef10_sriov_free_vf_vswitching(efx);
>  	efx->vf_count = 0;
> -- 
> 2.34.1
