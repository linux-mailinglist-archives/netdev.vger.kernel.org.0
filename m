Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D63371179
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 08:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhECGHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 02:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhECGHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 02:07:20 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A4C06174A;
        Sun,  2 May 2021 23:06:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id p12so2909840pgj.10;
        Sun, 02 May 2021 23:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCcrSErNxvBoj5fyC3epLiepwpZec0GDdGp71BbCQDU=;
        b=JMwswjCpATlYPl3tgBiU0u/60TfAgIVf1syaut2heTY7hLys0TT6KPVHYf8oN/7eLA
         MCLp/dObeKrjPKXwO7E01UIvFlnwAr5tEKcznnsgFuWvGk3IJL/OHf4aFFu4tsulg3xf
         qEVhFPRing0dfG6HvPV8fYYAKnY3PpBu6RRi7OvYKhvQm7kYueNpeUealabeAzJPsg25
         StKlyryEcWAS3Q4j+YglOIaI6S2H5JVVEmFmk0Q9bwzsjxobLd0M/QymP7WB38Cvb53f
         0ttlS174YP7eLngTKZnIQprp6xIAtjwzQjwMntaRjPchFaJE8IOyEmMAHiEL0QOc1d88
         AMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCcrSErNxvBoj5fyC3epLiepwpZec0GDdGp71BbCQDU=;
        b=YPDHZq3rOsYjGj3LuQy//+CBXsYS9cdA45tzD7WFSeAjr6zq9F/pqWuabU/0uhLrwi
         mmUul9Y4z4qXSS9MlVh5FXLiC5xuB2GFAhpDtZwGrF6SmgGTiswfo0l9k8KDwA3K68NQ
         41jQXDbU1gBQOD+GYtW2bhRe21dhSfDr2uUyclsJFcJTpJDGga58M6D0LNyjRPOEMGBn
         mX55yWdsulcDCDzRLFgeniyXPqTr3tV3dA6pfxn72hmLjFswgizpQ2rMMFtyg6dEDFdQ
         MDPKBZa17OnG+CzNFtFn8i+jeY0rK9/zGPqHmkZ3DEx1z86h9sICkuhBWS2P5o0yal30
         HQTg==
X-Gm-Message-State: AOAM533meTXOvUdHpBFOAOdBm3tbBYTWkK3C0jqL7DZYtNPD2l4v6aF8
        T6vAgfHG44roxIt55+KCUX4=
X-Google-Smtp-Source: ABdhPJy2fmKjRUuk5NXb+58MfObWujx244oddslIcOGT1eiE0nsVxg1Id53Umk4Luq0duWzwxX2NCA==
X-Received: by 2002:a63:570e:: with SMTP id l14mr16714531pgb.159.1620021986721;
        Sun, 02 May 2021 23:06:26 -0700 (PDT)
Received: from shane-XPS-13-9380.attlocal.net ([2600:1700:4ca1:ade0:3a:4810:e38c:9b3])
        by smtp.gmail.com with ESMTPSA id md21sm16757731pjb.3.2021.05.02.23.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 23:06:26 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
Date:   Sun,  2 May 2021 23:06:22 -0700
Message-Id: <20210503060622.27128-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328075008.4770-1-lyl2019@mail.ustc.edu.cn>
References: <20210328075008.4770-1-lyl2019@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In pvc_xmit, if __skb_pad(skb, pad, false) failed, it will free
> the skb in the first time and goto drop. But the same skb is freed
> by kfree_skb(skb) in the second time in drop.
> 
> Maintaining the original function unchanged, my patch adds a new
> label out to avoid the double free if __skb_pad() failed.
> 
> Fixes: f5083d0cee08a ("drivers/net/wan/hdlc_fr: Improvements to the code of pvc_xmit")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>  drivers/net/wan/hdlc_fr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index 0720f5f92caa..4d9dc7d15908 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -415,7 +415,7 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  		if (pad > 0) { /* Pad the frame with zeros */
>  			if (__skb_pad(skb, pad, false))
> -				goto drop;
> +				goto out;
>  			skb_put(skb, pad);
>  		}
>  	}
> @@ -448,8 +448,9 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return NETDEV_TX_OK;
>  
>  drop:
> -	dev->stats.tx_dropped++;
>  	kfree_skb(skb);
> +out:
> +	dev->stats.tx_dropped++;
>  	return NETDEV_TX_OK;
>  }
> 

1. This patch is incorrect. "__skb_pad" will NOT free the skb on failure
when its "free_on_error" parameter is "false".

2. If you think you fix my commit, please CC me so that I can review
your patch.

I have sent another patch to revert this.
