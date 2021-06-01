Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EC63973D6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhFANJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:09:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43737 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhFANJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:09:31 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lo47Y-0001r6-Uh
        for netdev@vger.kernel.org; Tue, 01 Jun 2021 13:07:48 +0000
Received: by mail-wr1-f72.google.com with SMTP id c4-20020adfed840000b029011617ea0440so1848889wro.10
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 06:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FpFE3Q169p9I82G663kCNgbGWOU29minA7JKgCHkCBE=;
        b=dawMcYbSu18OGLCPlKFjQ0Q9x37bFyNaDdL1TGMeCD9/anObAsQNW12dmyYyl4SaIn
         0Qklm1X2CtPtiN7kxNOgiN6pw0vGA/HNaPH8oW2f/BaANUcF/buyFnwezaA5XosglqFX
         aBeNFPmfgeomisAHeqL8fKXmptH8jfDvStCGtyCuSE30CJFv+YDaSnEMRiLrOKtz3V3l
         UvpCepYBhYlWs09fmbg4QfD2KELpMNQ4JYmIq5ICKPByoi9ZlOtVJey0M0gDVACWp/gg
         jqnnlYWH4k9lO4GvV180LRjkodmhi+2vFzaqfTGlCF1/083T0j8pSR0Smny91TVGMFqH
         vILQ==
X-Gm-Message-State: AOAM532/Yic8BV8M/6EMr79zBA1bJ38GYOZMSWjcgQeZCmn7V6LA23BH
        8cTnlPK8p03HhRMll+3R9IsP807sZ2BBH5Y/W3elIFhck0alB9s2VISPIQsLhw8ECdtWTv6d/fD
        0VLMw2Zp6WiBsU7qSrf1SIqNCDJPKi4d41w==
X-Received: by 2002:a05:600c:3227:: with SMTP id r39mr26743368wmp.26.1622552868730;
        Tue, 01 Jun 2021 06:07:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPw71Sl27dDWwQIasNqYQAmTjczXg24B0GI/7daRMIzEBWYFDceWeCW6ZZlV/yvXmg1UM8eA==
X-Received: by 2002:a05:600c:3227:: with SMTP id r39mr26743349wmp.26.1622552868588;
        Tue, 01 Jun 2021 06:07:48 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id e17sm3587959wre.79.2021.06.01.06.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 06:07:48 -0700 (PDT)
Subject: Re: [PATCH] NFC: microread: Pass err variable to async_cb()
To:     Nigel Christian <nigel.l.christian@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YLYvcbjuPg1JFr7/@fedora>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <3e2f804b-107a-9f44-2ed2-95e4c2a2e426@canonical.com>
Date:   Tue, 1 Jun 2021 15:07:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLYvcbjuPg1JFr7/@fedora>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2021 15:00, Nigel Christian wrote:
> In the case MICROREAD_CB_TYPE_READER_ALL clang reports a dead
> code warning. The error code is being directly passed to 
> async_cb(). Fix this by passing the err variable, which is also
> done in another path.
> 
> Addresses-Coverity: ("Unused value") 
> Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
> ---
>  drivers/nfc/microread/microread.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
> index 8d3988457c58..130b0f554016 100644
> --- a/drivers/nfc/microread/microread.c
> +++ b/drivers/nfc/microread/microread.c
> @@ -367,7 +367,7 @@ static void microread_im_transceive_cb(void *context, struct sk_buff *skb,
>  				err = -EPROTO;

Remove this line instead, please. The err is argument passed by value so
assigning it within a function is ugly.

>  				kfree_skb(skb);
>  				info->async_cb(info->async_cb_context, NULL,
> -					       -EPROTO);
> +					       err);
>  				return;
>  			}
>  
> 


Best regards,
Krzysztof
