Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD58397107
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhFAKNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:13:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39419 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFAKNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 06:13:02 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lo1Mm-0006ff-2t
        for netdev@vger.kernel.org; Tue, 01 Jun 2021 10:11:20 +0000
Received: by mail-wr1-f72.google.com with SMTP id k11-20020adfe3cb0000b0290115c29d165cso1681155wrm.14
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 03:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qKI7EcbsXTHO2QTIMScd8fUBWjbGKBIAk+4ExxlIwok=;
        b=CNGxZHFYxLIdwDjK+Jq1oPRteHApmyX5rIdzT0o2bYJZoGouF0/4ehkqGFKA5nUOG2
         kPKyjbnTYl6tEZZrCUQ36NoCgoBq9B0uj3GZFYtBYhfW/QjEflA1CH9Qjku8k4lHlyOX
         kXdYLXOdXDIM3V722YgJQrG39utqVGr1nGf07mHL3s5d/fxEkmZb6aQF/fZBHKJhkAaI
         zuJKmiy/2iw2YYUVtbiUMNX3jGkzKavNzw38y4nVQAA8SGxGBnh29WlH+lh61vlKOEWp
         b7IClr/zmODPLBrNtgdpk5ot2PB5hdTEZSqfqRWkec3xmHdgXl4ccVyiBeVeNQbDAR+q
         lltA==
X-Gm-Message-State: AOAM531VYPUkMGf7F4gHUecafxgE7/h5SxwefDCj3wE63tYIDx7Cgs9u
        4uHkntbFbLRqMtfqbIvi6hYNgj+fqH9c6yCtBRdqnT0mUIX9a4TStM4yekF+kmavuVGLZ1XdCST
        8Pp0r/bjUw7l1cd+1VFKf+4BB6N6sBXfwEQ==
X-Received: by 2002:adf:f5c9:: with SMTP id k9mr8718698wrp.180.1622542279879;
        Tue, 01 Jun 2021 03:11:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8N/cp913jwmb4tDS6Dcr9BN5XWWh5nBdCmbejhu/A96UuguWTtuNN1cKnl2UDPzuYXHUmrA==
X-Received: by 2002:adf:f5c9:: with SMTP id k9mr8718687wrp.180.1622542279772;
        Tue, 01 Jun 2021 03:11:19 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id 30sm2746863wrl.37.2021.06.01.03.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 03:11:19 -0700 (PDT)
Subject: Re: [PATCH] NFC: nci: Remove redundant assignment to len
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <1622540990-102660-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <bbe532a0-95d4-bdc8-2caf-dba8ecf4ecda@canonical.com>
Date:   Tue, 1 Jun 2021 12:11:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1622540990-102660-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2021 11:49, Yang Li wrote:
> Variable 'len' is set to conn_info->max_pkt_payload_len but this
> value is never read as it is overwritten with a new value later on,
> hence it is a redundant assignment and can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> net/nfc/nci/hci.c:164:3: warning: Value stored to 'len' is never read
> [clang-analyzer-deadcode.DeadStores]
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  net/nfc/nci/hci.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
> index 9686514..d6732e5 100644
> --- a/net/nfc/nci/hci.c
> +++ b/net/nfc/nci/hci.c
> @@ -161,8 +161,6 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
>  	*(u8 *)skb_push(skb, 1) = data_type;
>  
>  	do {
> -		len = conn_info->max_pkt_payload_len;
> -
>  		/* If last packet add NCI_HFP_NO_CHAINING */
>  		if (i + conn_info->max_pkt_payload_len -
>  		    (skb->len + 1) >= data_len) {
> 

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
