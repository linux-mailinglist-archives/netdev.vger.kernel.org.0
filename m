Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93C55EB190
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIZTtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiIZTtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:49:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192B16549
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 12:49:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so13529630pjk.4
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 12:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=q6GRaHpjRQXpIzSgBVJLZ6GqPYsPVZBCvlVnASsVkeo=;
        b=lFWLLjK18opZNToaQMMBYzp2UhPPQcQpWHHhe0yumb0TpznsvyaTd8LGlyKfyGAFKR
         GmDNi6wYMaMtROduujsfCHeLrWjA3hdjcoqDNU+Qd5go92SPsKO2CxP92gw66O25Gg+x
         aQK8GJCPevxUyFUEbt9EKZhSnQk8ig5+OlgBQASlHtWO5hSdwjpu/yYoWvMB4fG6HMyc
         RJGHBnTpG6Lfd5iaR6ugxJN+JRmzK8zrq5GgeQxp/eJZaxlLRL/Im5HGV6LCuf0fRsDB
         ARoPaC2ciW5AqWwCPz2r4PNHOxDVh/xHBx/83gAzhH+nQEixR97Nj+PAS73xLCyPSPwF
         cSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=q6GRaHpjRQXpIzSgBVJLZ6GqPYsPVZBCvlVnASsVkeo=;
        b=mYIngJWUl92J5vhLRSu55krilehuDSu3Ae1fEipyVVe57mzRQLgXtFr/WZzt/KOpLF
         ukq5UogT2SxI5PsVf7G2KEWfDGq3iv25uyvqDEfo8i6MykCl9lsDP28VmUyofRUqoKTl
         Nbpj+rgqQcFzPff+Iip/B1YwvQvtfg2Wm27n6NiuYkgyKYaOUiwwS7MUJxzKBue7RY95
         Tyz+kGj7bETQ+ydSkoXhDzJgF+QUEIArq+tIZj55L9J4OwF9Rx93HJKvFz9uSjRMDlVe
         Fus6MGMovGoXZvAP7AUFU0NToBLVhHsO4tYHm7iirHbQlJtxiZRhtUQZyZSKrH2ucHXU
         Y8XQ==
X-Gm-Message-State: ACrzQf0eAsLzrXb6pJe/AhcbI1wznlmk/QfIaJBP4MuO1cZ3d1Qi75L0
        uCcLM8mzgyDbch2FqJZ2iUDERA==
X-Google-Smtp-Source: AMsMyM584S1JBmiCd8iW0aSDpoWZZZWmehFmwAnWQl7jAypqW5ZXLAge37k3+V1OT/riFc1/8iKCHQ==
X-Received: by 2002:a17:90a:e7d2:b0:200:a220:6495 with SMTP id kb18-20020a17090ae7d200b00200a2206495mr429291pjb.5.1664221758642;
        Mon, 26 Sep 2022 12:49:18 -0700 (PDT)
Received: from [192.168.0.3] ([50.53.169.105])
        by smtp.gmail.com with ESMTPSA id 192-20020a6217c9000000b0053788e9f865sm12601914pfx.21.2022.09.26.12.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 12:49:17 -0700 (PDT)
Message-ID: <b9c41357-4756-03e5-ad7c-2f80c68b11d8@pensando.io>
Date:   Mon, 26 Sep 2022 12:49:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [patch net-next 3/3] ionic: change order of devlink port register
 and netdev register
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        snelson@pensando.io, drivers@pensando.io, f.fainelli@gmail.com,
        yangyingliang@huawei.com
References: <20220926110938.2800005-1-jiri@resnulli.us>
 <20220926110938.2800005-4-jiri@resnulli.us>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20220926110938.2800005-4-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/22 4:09 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Make sure that devlink port is registered first and register netdev
> after. Unregister netdev before devlnk port unregister.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>   .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> index 0a7a757494bc..ce436e97324a 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> @@ -320,16 +320,16 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                          dev_err(dev, "Cannot enable existing VFs: %d\n", err);
>          }
> 
> -       err = ionic_lif_register(ionic->lif);
> +       err = ionic_devlink_register(ionic);
>          if (err) {
> -               dev_err(dev, "Cannot register LIF: %d, aborting\n", err);
> +               dev_err(dev, "Cannot register devlink: %d\n", err);
>                  goto err_out_deinit_lifs;
>          }
> 
> -       err = ionic_devlink_register(ionic);
> +       err = ionic_lif_register(ionic->lif);
>          if (err) {
> -               dev_err(dev, "Cannot register devlink: %d\n", err);
> -               goto err_out_deregister_lifs;
> +               dev_err(dev, "Cannot register LIF: %d, aborting\n", err);
> +               goto err_out_deregister_devlink;
>          }
> 
>          mod_timer(&ionic->watchdog_timer,
> @@ -337,8 +337,8 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> 
>          return 0;
> 
> -err_out_deregister_lifs:
> -       ionic_lif_unregister(ionic->lif);
> +err_out_deregister_devlink:
> +       ionic_devlink_unregister(ionic);
>   err_out_deinit_lifs:
>          ionic_vf_dealloc(ionic);
>          ionic_lif_deinit(ionic->lif);
> @@ -380,8 +380,8 @@ static void ionic_remove(struct pci_dev *pdev)
>          del_timer_sync(&ionic->watchdog_timer);
> 
>          if (ionic->lif) {
> -               ionic_devlink_unregister(ionic);
>                  ionic_lif_unregister(ionic->lif);
> +               ionic_devlink_unregister(ionic);
>                  ionic_lif_deinit(ionic->lif);
>                  ionic_lif_free(ionic->lif);
>                  ionic->lif = NULL;
> --
> 2.37.1
> 

That should be alright - thanks.  -sln

Acked-by: Shannon Nelson <snelson@pensando.io>

