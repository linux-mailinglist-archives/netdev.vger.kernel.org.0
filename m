Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7418445356
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKDMzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 08:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKDMzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 08:55:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71059C061714;
        Thu,  4 Nov 2021 05:52:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id f8so21111059edy.4;
        Thu, 04 Nov 2021 05:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DpYzPiVrlxZpQKVyCCJ8zj4zAgXSuVUmCZXLOiQD4c4=;
        b=MxQK9t7Xs9iYEYRHXQZdDHduOCmEaggH8LQAUmUKbjQydjgzmWcPXjvRBpksckLQQK
         snV8IcV33XkIrXIO6E1qLzUfSUvYP49MKd9LZ8lvVhbWUbx3s7fhzoHB6bWq2eVzIPz6
         WU6vBIOUkVbhrqpIsZkyTLKj98aXTbS0VS6b0mMWqPVJm9uqqLCrF76bdpboeDX6EdF/
         LYsLgLx1YIVof/9yxtryPMPMl7eQQfFhOqXa5sbbzvrZLZxVYW3rwlRlYPLDsleNSOEm
         BTH0KVZZ9s3fihX4hWR61hwX3XYtilIlGdWB5Un1BbEKuGxQ3qe2GTT3aRjklsIH8VHq
         qfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DpYzPiVrlxZpQKVyCCJ8zj4zAgXSuVUmCZXLOiQD4c4=;
        b=zq7taLD9hWv4JNPnhS3edK0bvV8UeVfl2eiUVJYNGHYFEICDT0l5orXp2GeEIozeeO
         IXgjq9h2nYl76u8554Vkyc38/9q0hhrF1/EwM6rBODGaWXrCyHXjYBRYZcXjcp5ACFGt
         m84My+mE7M4UWI8FvPGMyJZCjinb+hIfN42rO6iuEu0qNxVE6HL74OT28UNg7o6eo3iW
         VSNiTrvDymMlKHORcBKhjl0MaaafT6VJXMibnkiMWbPTfLef6PNFjifc1oIr7Pnn4feo
         SrizPZjHGGAxxXnXCnE20Iu+xSLIelnwQ/ILRnn++G0k2r+OCIiJY3Nsfxrtg2sHi/Oj
         odBA==
X-Gm-Message-State: AOAM530keRYnd5a9Xy+se0W2VvpUPz9OIsyDLTcXeD0VJkdUUgC7AkkC
        MbAvr8fqBxgHDw7wWIssLvkw/GGJKxc=
X-Google-Smtp-Source: ABdhPJyz7BQ7BD+SGOq8UW0TkjQkBuhLtuQQ2StrBiA9UvOm6qs9skdBWhKUG0k8+wAKyeQI0prG9A==
X-Received: by 2002:a05:6402:3508:: with SMTP id b8mr10593465edd.347.1636030361939;
        Thu, 04 Nov 2021 05:52:41 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id t22sm2759571eds.65.2021.11.04.05.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 05:52:41 -0700 (PDT)
Date:   Thu, 4 Nov 2021 14:52:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Robert Marko <robert.marko@sartura.hr>,
        John Crispin <john@phrozen.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gabor Juhos <j4g8y7@gmail.com>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
Message-ID: <20211104125239.n4a4w5maodygpe4n@skbuf>
References: <20211104124927.364683-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104124927.364683-1-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 01:49:27PM +0100, Robert Marko wrote:
> From: Gabor Juhos <j4g8y7@gmail.com>
> 
> The MIB module needs to be enabled in the MODULE_EN register in
> order to make it to counting. This is done in the qca8k_mib_init()
> function. However instead of only changing the MIB module enable
> bit, the function writes the whole register. As a side effect other
> internal modules gets disabled.
> 
> Fix up the code to only change the MIB module specific bit.
> 
> Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
> Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
>  drivers/net/dsa/qca8k.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a984f06f6f04..a229776924f8 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -583,7 +583,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
>  	if (ret)
>  		goto exit;
>  
> -	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
> +	ret = qca8k_reg_set(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
>  
>  exit:
>  	mutex_unlock(&priv->reg_mutex);
> -- 
> 2.33.1
> 

You should have copied the original patch author too. Adding him now.
