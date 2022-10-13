Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACEC5FD78E
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiJMKDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJMKDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:03:49 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213CEB1C4;
        Thu, 13 Oct 2022 03:03:48 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a13so1943109edj.0;
        Thu, 13 Oct 2022 03:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YkfSrLawJkCOnCmEIszje28r/jjOo0B9M1Q/HwavUR0=;
        b=NXM7iu0eUsDEY12rm2wMW7Qx5rtC+ohPufzxETcK2aTDQ3YN/KeUX6QKr4QdZAyJZg
         ebQOc74W7SoIjtti5VilwBVSO1tp+5hLtbzqBrhj8AhMgXjvjOLSrK0yYrwXDzS3eDJ3
         QkDfw9z0JYBnchuH8OxkC7eHcR17+donYCNkCjA3boqfVos2dfwtDePfEoLbLntT5pIn
         3lPMJ+Pgg1ANTu4Ry6kUEpIOgzLquQbocL6kxugSQh34RnkjdTlnIrSRLV8SMXvI0pf0
         dsbkjHORiE+ayQADNma8fhi1H6GmzUSsO81TgLiv3kU54PUMABsR35yy8rjqQiMTi0ZX
         zsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YkfSrLawJkCOnCmEIszje28r/jjOo0B9M1Q/HwavUR0=;
        b=Vzxj56thF24iChqzWB1PzZ5MOjLREYgpV2b71j+s6btnLJLbFJJg5qaqr3cBVC6GZi
         S0EE1vz9DKdvLweouDUDkeoTN9HMRqyDtXEYuf1inLN6+xBPNPgdfVOl8V+sie6M0ohP
         oZOZ0+SPTPR0GFo7pW0cE3F1FLgIwpybaRbsOC//8XmUws88BG7MdXEkTRMAJwGhkdx1
         58uMsoqQ/js9GG8RjlKRE6WNUH+igBzdmZBUtd7iLI7x7KT05xOnWy4RwaVTha6PnwTM
         urPk0qhGy+Ykg7MsSlZKHozMHXVpK2f0xhkQFhIpp+hPSr8XL3b9wwcrCL2/dqFta4CB
         ZO9Q==
X-Gm-Message-State: ACrzQf2VfeJakSga4qQRYlIPrJM4WZH9XrJQ0/ZTf0vfJ7j7TJneIONG
        Iok2LlODV4B/bOrTh2AdEWM=
X-Google-Smtp-Source: AMsMyM6Ze8RfFcCHJWUGrTWc38UBdjYoIJq7uQFGL9+Ha96tHHz9IQzMbwSIwdjPp+7NX7mTb9tejw==
X-Received: by 2002:aa7:c78d:0:b0:454:fe1d:8eb1 with SMTP id n13-20020aa7c78d000000b00454fe1d8eb1mr31642060eds.59.1665655426590;
        Thu, 13 Oct 2022 03:03:46 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.16.127])
        by smtp.gmail.com with ESMTPSA id d22-20020aa7d5d6000000b0044dbecdcd29sm12874554eds.12.2022.10.13.03.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 03:03:46 -0700 (PDT)
Message-ID: <446abc60-b954-6c41-e6f6-62e0ff02c9e9@gmail.com>
Date:   Thu, 13 Oct 2022 13:03:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH net] net/mlx5e: Cleanup MACsec uninitialization routine
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2022 10:21 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
> doesn't support MACsec (priv->macsec will be NULL) together with useless
> comment line, assignment and extra blank lines.
> 
> Fix everything in one patch.
> 
> Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 11 +----------
>   1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 41970067917b..4331235b21ee 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -1846,25 +1846,16 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
>   void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
>   {
>   	struct mlx5e_macsec *macsec = priv->macsec;
> -	struct mlx5_core_dev *mdev = macsec->mdev;
> +	struct mlx5_core_dev *mdev = priv->mdev;
>   

simply defer the mdev calculation to be after the early return, trying 
to keep this macsec function as independent as possible.

>   	if (!macsec)
>   		return;
>   
>   	mlx5_notifier_unregister(mdev, &macsec->nb);
> -
>   	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
> -
> -	/* Cleanup workqueue */
>   	destroy_workqueue(macsec->wq);
> -
>   	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
> -
> -	priv->macsec = NULL;
> -

Why remove this assignment?

It protects against accessing freed memory, for instance when querying 
the macsec stats, see 
drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c

>   	rhashtable_destroy(&macsec->sci_hash);
> -
>   	mutex_destroy(&macsec->lock);
> -
>   	kfree(macsec);
>   }
