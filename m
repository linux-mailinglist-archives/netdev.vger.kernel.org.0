Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8B9643F21
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiLFIzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiLFIzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:55:51 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8701B1C3;
        Tue,  6 Dec 2022 00:55:50 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id h7so16456083wrs.6;
        Tue, 06 Dec 2022 00:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dI8JwsgJg/QR7tDv83m6zyJlfaK29SEW3cekH92rK48=;
        b=O1dURCLIs02PcWYzsiyFILscSnW6UN1usVtPSI6W2IxmF/EWWb3CJ3n8EEi+tVE4ea
         mraYLdA37Snw6BWv/wNrd/K6l5g8JNG3/ViEfXGi+nKlzRgz9y5Fl06OfiY2tEhi48io
         5z6gPyrxE0eXTtq45CJtRlx1kTNEwif+tZrN+7SBHxUaV4NMQbHK8BhwkE1CxvwTnvN1
         lFjWaBMMPHVb+QKmR7q4iyNsJpwzhwiSQghHZtX8RCRm9u0YorDaytRxAnDSHwVUi2or
         4/qk2lQZg6FtFCeU9r0P2qLXvWx+zxJ2gyyhn0gORbg6aUmA22XFmicYn5SzvU0fJ9WI
         yLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dI8JwsgJg/QR7tDv83m6zyJlfaK29SEW3cekH92rK48=;
        b=5EsCNEylsh/j5PZL/z5qzZoeECvveGlHLY69tAP0Tg11l3TwVDltqCv24Rz7BZXcE6
         jLdJoTJ9Osczg5g0CCj4ATgT2rjXWsxiNOb1JiPOCgrWqz7AB0bmnySZiaj21FUDWbsE
         bAildf+PftEL8GqXYKuQtoiCuJPr+XS0Dz5+Nd/8mZX5vYd1iJYOPwddPEz5Mnbaa8Qh
         +xcT2qHdIFTPzVqeHcKHqTKVX1x0ltdB+FZcpjKkiF/mN7Kq7Xw2emTdz9jLqiJLHyVz
         DeaEChokGooZLnMINoORBGsdUNi/DlbwLDHEPFyJArReMPE1/jForA8HyKLb9TgHFsYb
         pfcQ==
X-Gm-Message-State: ANoB5pl99Pz/LqxCpXSv9tYehx3YBBGRyS/kdy3CpOY7+HDW73N2D6z7
        FlKlwb6TktFQGme9hwVlgck=
X-Google-Smtp-Source: AA0mqf4mOF/42GKxI9w97Np7mPQL/C+YNPgEgzEAfXkWlX1s7/UeD+SdFwnk1gNsH8bxtEsZiCRrpA==
X-Received: by 2002:adf:ea0a:0:b0:241:fcd5:6b94 with SMTP id q10-20020adfea0a000000b00241fcd56b94mr34237733wrm.592.1670316948535;
        Tue, 06 Dec 2022 00:55:48 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id l41-20020a05600c1d2900b003d1e4f3ac8esm2718168wms.33.2022.12.06.00.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:55:48 -0800 (PST)
Date:   Tue, 6 Dec 2022 08:55:45 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     ye.xingchen@zte.com.cn
Cc:     leon@kernel.org, davem@davemloft.net, ecree.xilinx@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, khalasa@piap.pl, shayagr@amazon.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] sfc: use sysfs_emit() to instead of
 scnprintf()
Message-ID: <Y48DkToW/Yvvid+0@gmail.com>
Mail-Followup-To: ye.xingchen@zte.com.cn, leon@kernel.org,
        davem@davemloft.net, ecree.xilinx@gmail.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, petrm@nvidia.com,
        khalasa@piap.pl, shayagr@amazon.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202212051021451139126@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212051021451139126@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:21:45AM +0800, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
> v1 -> v2
> Fix the Subject.
>  drivers/net/ethernet/sfc/efx_common.c       | 2 +-
>  drivers/net/ethernet/sfc/siena/efx_common.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
> index c2224e41a694..cc30524c2fe4 100644
> --- a/drivers/net/ethernet/sfc/efx_common.c
> +++ b/drivers/net/ethernet/sfc/efx_common.c
> @@ -1164,7 +1164,7 @@ static ssize_t mcdi_logging_show(struct device *dev,
>  	struct efx_nic *efx = dev_get_drvdata(dev);
>  	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> 
> -	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
> +	return sysfs_emit(buf, "%d\n", mcdi->logging_enabled);
>  }
> 
>  static ssize_t mcdi_logging_store(struct device *dev,
> diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
> index 1fd396b00bfb..e4b294b8e9ac 100644
> --- a/drivers/net/ethernet/sfc/siena/efx_common.c
> +++ b/drivers/net/ethernet/sfc/siena/efx_common.c
> @@ -1178,7 +1178,7 @@ static ssize_t mcdi_logging_show(struct device *dev,
>  	struct efx_nic *efx = dev_get_drvdata(dev);
>  	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> 
> -	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
> +	return sysfs_emit(buf, "%d\n", mcdi->logging_enabled);
>  }
> 
>  static ssize_t mcdi_logging_store(struct device *dev,
> -- 
> 2.25.1
