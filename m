Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4D35E35F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346716AbhDMQCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhDMQCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:02:16 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6E5C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:01:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so10905733pji.5
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Q/AnNTNlBCjZqChhNddMYNKRfa5HdDTkyK0WivXdYHc=;
        b=i1NAtzOjQ0lsMAwDmYC9XV3ElHbrEqnkWfccIxI72XX3nbpZDq2wOjmgmdGK0LMRMB
         eUjmzKz4UIy/LISe/9abSPbI1WrZQX8ZMkMO6EJkd/LxG0DYbWgQ35pTeUU9wfM9d2p2
         V/ETWnzwYqcBbgQjNaSf49v9VjkmIHO8SzT4lF1vtLssuquPrvwS2FXZrrVddb4ryQRg
         41Sd+SySTNvxrjfLVXw+fyYKuyv+DXaR4iJz1wGVlQNu4AczCQ9gGyiavETu8+o6PO0Q
         ILARH/49mYF9XDCsa/fFCRTug+A1jlFPQCJ+McDwHng0BGlv4H+Mb0Clh60JAwHKq+gP
         Gakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q/AnNTNlBCjZqChhNddMYNKRfa5HdDTkyK0WivXdYHc=;
        b=L6uqSLPIZDIC/eAss6RBk1lrNKbYuxaWf60Hl17fBsEzJ0IID2ngL8BKJU8p+/YFOh
         GY1HM878RcW72Imqn9nI7c0VddW7AqNozLM7/dA519sM0AL7IYZAMuQm8xIYUNc0v+aT
         o1ZaNoMs1xz7PdptTCKFal0XROJRNQiQ0m2ZY6itqi7fMvCbOABLHs0YQWMNykVBalTS
         IatU9AYmLuWfCglpDXKLc58w/FBn9+2oVgUr+KW2JdPO05ytk3kju/4E19O7+4RP6lc2
         iw51iv0VaJq4g7D2ZeWohn3lVCkoqLWx2zyit3ct/Hy5tV99So8QDBozsjPFeEkHZhb5
         BRbg==
X-Gm-Message-State: AOAM532745Zjv/g5yRrU4Q5RwOBmiF0NcjFJ1kZ9OfUy0bfQAcWdqS9f
        Piz8jkC191yxaP8fG9FUiAnPnw==
X-Google-Smtp-Source: ABdhPJyVs41VJHay8GUipc1O1fwMSTLtC6VZibMSMx6M8ls0jgOw9Z1wvMoytdd0berH5lKG2eY/XQ==
X-Received: by 2002:a17:90a:c7d5:: with SMTP id gf21mr748510pjb.80.1618329716359;
        Tue, 13 Apr 2021 09:01:56 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 63sm7233147pfu.43.2021.04.13.09.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 09:01:55 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: return -EFAULT if copy_to_user() fails
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     drivers@pensando.io, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Hubbe <allenbh@pensando.io>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YHV230jUzxBJxlPS@mwanda>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a1581cc4-fa0c-22eb-0a2c-62f1a1a1e215@pensando.io>
Date:   Tue, 13 Apr 2021 09:01:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHV230jUzxBJxlPS@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 3:47 AM, Dan Carpenter wrote:
> The copy_to_user() function returns the number of bytes that it wasn't
> able to copy.  We want to return -EFAULT to the user.
>
> Fixes: fee6efce565d ("ionic: add hw timestamp support files")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_phc.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> index 86ae5011ac9b..d7d8d5e81ea0 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> @@ -225,7 +225,9 @@ int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
>   	memcpy(&config, &lif->phc->ts_config, sizeof(config));
>   	mutex_unlock(&lif->phc->config_lock);
>   
> -	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
>   }
>   
>   static u64 ionic_hwstamp_read(struct ionic *ionic,

