Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9329963BC41
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiK2I4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiK2I4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:56:40 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0933C28B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:56:40 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso10257444wmo.1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4K6sGCjp5UJuab3VAd/zZQ790uNoMHShHR16urluBo=;
        b=ANlSPXTi5oGxo+g1r9TuePqHZG3basMmHazGbfrEkCXbBQTPP+kK69sfjuVU36j8ZK
         nMMT67j22ptJpjmrxB1MY/Hq+tOkNQN2+OUQH6QhgOgvdbFCmZcsLj4HXHZCY12Le57N
         FJRWbGUkAtePbk9Mq6f6u2Xd9KQ7ayRySKxOoj+jIXvIReTh73Pzl0VKiGT/8F9S9c+F
         +Hla5xFEH2yKYqAdG6KWCTr4uKMXhcB11Ub9C7h/oO3FChl0fFYPVMBQsCRTyOVo6YCi
         G3jGW/kHMuyosjWf2H9pZ08skyyuCHG/5jdak+7SAoeouTOKSDxW5ylA9mj1ICVfPiVl
         ketg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4K6sGCjp5UJuab3VAd/zZQ790uNoMHShHR16urluBo=;
        b=8PBXeKmFp+UskpC+1gpfyIAg9eh2qHaxgbKtCNueR9FZhDYBhm3Ps5CNKdijLtzmwv
         qeNmTd4YcH4uFCAiEgs6+8e0rnKaFm8yofxKkiRJ9IHPVoTnvQXF5lJ4jw5Ih/Uauabl
         hZ/BUgG3TAbNE/PjXkBBMFXu5pO5+8rYSNw28ZknFmnF9z2NC0ZwF4stDltTPNWxvv/Z
         pbDG4AeeoaRpL+X5OA7+jHh241gN+yb+EerrINLTbbftQ8labeaqcaZF9OFpjGMRrLa7
         pwi6Ys/+r1YK8Chl5gq6wlf97Bp62Geftv62PblTCdzoT8hZSzcHeALPsw9I3adYOR6/
         PfgQ==
X-Gm-Message-State: ANoB5pkx2LYuB9uyNbrLwB5Nn7lpZ+tqFnbv6DQLTCUTeRgES9cvPyuw
        h0GgouXbZ40C7Ukb9q/QT+4=
X-Google-Smtp-Source: AA0mqf41p2JOcr2AkkOktRwvIwUnpszmbUiRWIHfJPubrof2tNkaJsXaKiFll3cLMKNTKyfLK/Y9uA==
X-Received: by 2002:a05:600c:1907:b0:3cf:7981:9a7 with SMTP id j7-20020a05600c190700b003cf798109a7mr40400642wmq.87.1669712198468;
        Tue, 29 Nov 2022 00:56:38 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id y14-20020adff14e000000b00226dba960b4sm13251626wro.3.2022.11.29.00.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:56:38 -0800 (PST)
Date:   Tue, 29 Nov 2022 08:56:35 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pieter.jansen-van-vuuren@amd.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] sfc: fix error process in
 efx_ef100_pci_sriov_enable()
Message-ID: <Y4XJQwhvc51ccjdE@gmail.com>
Mail-Followup-To: Zhengchao Shao <shaozhengchao@huawei.com>,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pieter.jansen-van-vuuren@amd.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20221125071958.276454-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125071958.276454-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 03:19:58PM +0800, Zhengchao Shao wrote:
> There are two issues in efx_ef100_pci_sriov_enable():
> 1. When it doesn't have MAE Privilege, it doesn't disable pci sriov.
> 2. When creating VF successfully, it should return vf nums instead of 0.

This function returns 0 on success, or an error code. It is the higher level
function ef100_pci_sriov_configure() in ef100.c that returns num_vfs if things
are ok.

Martin

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
>  
>  	for (i = 0; i < num_vfs; i++) {
>  		rc = efx_ef100_vfrep_create(efx, i);
>  		if (rc)
>  			goto fail2;
>  	}
> -	return 0;
> +	return num_vfs;
>  
>  fail2:
>  	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
> -- 
> 2.17.1
