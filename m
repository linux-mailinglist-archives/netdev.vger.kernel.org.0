Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A191E63BB62
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiK2IT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiK2ITy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:19:54 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F1B55AB1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:19:53 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bs21so20810477wrb.4
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uAFMRxJXO354MUF2ppu0P/EeMOqIHSZU/HtIGZxMP4M=;
        b=DHyUqScytPg+F3QLkh8MeIvIp2o4/qkyoMvwzUdyi4AKZZ7bEgeusNub0tu8cukCzp
         EUQnz6rQlQiW/G2Ej2+ypNLfXdNpBVLoVCNwSVqBsxkvxRJKV485vJ4iitGaQhw/BXEq
         B3hJxWRX8uegfNMwiMWpayRPGKA0d0Fu8SE1rwvHnaOyqcZqP+t46lncXe66YlVK6FGA
         EoY9/JAq6WJmm9b211QIHGsUYV3enmJToOOPmzWZfS3SiZxNcl/clA2n2E9Lmhj/SL9l
         44nlgpyI66rHB4ymHrT3gTm6b8W3lAxHZ5V482RNfAJurf0qgX9ZdKDeNVpHMN2J+s2r
         /YVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uAFMRxJXO354MUF2ppu0P/EeMOqIHSZU/HtIGZxMP4M=;
        b=HWM/l0cg7l+OrUdXBv8PMY7M0OomCgErx4eNKF07r2IryO0XjKI9CuICpG0A2TPhYZ
         QAgZhdvHw8MlzX+PnFoYwn5m0EjdEcgMNw8pX1BxcTp4zqnzQM+UxvXS4FZYo0nZLu7F
         1BjSjMl1+0a1KiHRi246fWSamj1EOGl+kbpSqb7VkjiRwSoBfNf+lTO/jM9OP+CKiOCr
         xoPs0w3iINyFciFAXc+HD+4Hpy+wXlUAqFquC90g/HWJK8m8RgPyDhyeqMTRmwX9CHXa
         7tiDBcFMDT+2J7xd/UKHtDJYbFG15o7tIPMhki35nZee2CZ4dnz3tVuyyNXq0n32SPy7
         WEzQ==
X-Gm-Message-State: ANoB5pkkZs7RG6t1TP/8Wi5N9Q9bWXeAqyjLaYntqAiB/CvYGVlWBUBV
        dWqgD9BEvdJBHexTDZJ7YR8=
X-Google-Smtp-Source: AA0mqf6GXxz573sjhW/3vnu8pcyFSbaNuhsMncoE31c/NJIaWDRqQxrQizRZ5/dMZVXGkvuk8CiktA==
X-Received: by 2002:a5d:620d:0:b0:241:d0de:1025 with SMTP id y13-20020a5d620d000000b00241d0de1025mr26693463wru.226.1669709992303;
        Tue, 29 Nov 2022 00:19:52 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c4f9200b003a6125562e1sm1189480wmq.46.2022.11.29.00.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 00:19:51 -0800 (PST)
Subject: Re: [PATCH net] sfc: fix error process in
 efx_ef100_pci_sriov_enable()
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     pieter.jansen-van-vuuren@amd.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20221125071958.276454-1-shaozhengchao@huawei.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <3adfad23-b2dd-3bd9-40da-d4dfaa78b435@gmail.com>
Date:   Tue, 29 Nov 2022 08:19:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20221125071958.276454-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2022 07:19, Zhengchao Shao wrote:
> There are two issues in efx_ef100_pci_sriov_enable():
> 1. When it doesn't have MAE Privilege, it doesn't disable pci sriov.
> 2. When creating VF successfully, it should return vf nums instead of 0.

A single patch should do one thing.  If these two issues were
 valid, they ought to be fixed separately by two commits.

> Compiled test only.
> 
> Fixes: 08135eecd07f ("sfc: add skeleton ef100 VF representors")
> Fixes: 78a9b3c47bef ("sfc: add EF100 VF support via a write to sriov_numvfs")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/sfc/ef100_sriov.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_sriov.c b/drivers/net/ethernet/sfc/ef100_sriov.c
> index 94bdbfcb47e8..adf7fb09940e 100644
> --- a/drivers/net/ethernet/sfc/ef100_sriov.c
> +++ b/drivers/net/ethernet/sfc/ef100_sriov.c
> @@ -25,15 +25,17 @@ static int efx_ef100_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
>  	if (rc)
>  		goto fail1;
>  
> -	if (!nic_data->grp_mae)
> +	if (!nic_data->grp_mae) {
> +		pci_disable_sriov(dev);
>  		return 0;
> +	}

NACK to this part; if we don't have MAE privilege, that means
 someone else (e.g. the embedded SoC) is in charge of the MAE
 and is responsible for configuring switching behaviour for any
 VFs we create.
Thus, the existing behaviour — create the VFs without creating
 any corresponding representors — is intended.

>  
>  	for (i = 0; i < num_vfs; i++) {
>  		rc = efx_ef100_vfrep_create(efx, i);
>  		if (rc)
>  			goto fail2;
>  	}
> -	return 0;
> +	return num_vfs;

NACK to this too: this is not returned directly to the PCI
 core but to ef100_pci_sriov_configure(), which already does
 the translation from 0 (success) to num_vfs.  So changing it
 here is unnecessary.

-ed

>  
>  fail2:
>  	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
> 
