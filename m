Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F282397480
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhFANn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:43:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44776 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbhFANn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:43:27 -0400
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lo4eP-0005y5-Km
        for netdev@vger.kernel.org; Tue, 01 Jun 2021 13:41:45 +0000
Received: by mail-ej1-f70.google.com with SMTP id qk29-20020a170906d9ddb02903e6eb7046f6so3272605ejb.4
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 06:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8D2cU9WIH4f91nUainalgp07qa8uXynan7ov41ItFDk=;
        b=DVxWMoqk0yr5rkbxXEB0Vcg+fDMyMnmX1sISSB06VKvnaCniF0o+zk+YpQticp2YzE
         LIFlCpwpCrW+jJ4E698swHsnaaetCvZAO7NmTlwtccvKT/9yXpnOWVL0Umz5NaZtGRyL
         PkzonXSl1re58kCw30GilhEoHTIhl6rmMAzGeAfayYJyJIYf2tdVctWgnhT9vPUdzNIL
         FmvPtzL+qsQa3jzF/lfu5svxZlkEHZCpwmsvS3OqKJRQrFjKcdK3LPJW8ve9OjUYsrF1
         713NTRbq37nL9AWNXdO8M0NA3his1gqj67G+/OIcVxELNoRgRTlY6QL4IzJT6xYNbXVP
         e9Ig==
X-Gm-Message-State: AOAM532R2NYSgGyqb+dJhZXYH9U+st4PNpCk5VLxWLraibi4JMavONs8
        +KHYX9nNr2bbnA4EIKXKgg2oAGyJZpmOKl1kAiEYGPiWQQnWJgidsgWUAUAIFQBsPm+TZPbk5J2
        IWbc1V7SrQKZoouF8y8DzPoXsK0NZ9/8sMg==
X-Received: by 2002:a17:906:b2d6:: with SMTP id cf22mr15717471ejb.29.1622554905366;
        Tue, 01 Jun 2021 06:41:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyx9+gdpxkVKY3CEoYk/875InpWjxEeImRktiHYPYvqmpR6IVMcbrWVE/3CTLN0JX3pwP5fLg==
X-Received: by 2002:a17:906:b2d6:: with SMTP id cf22mr15717452ejb.29.1622554905191;
        Tue, 01 Jun 2021 06:41:45 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id dk9sm7224352ejb.91.2021.06.01.06.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 06:41:44 -0700 (PDT)
Subject: Re: [PATCH v2] NFC: microread: Remove redundant assignment to
 variable err
To:     Nigel Christian <nigel.l.christian@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YLY3pSMrpbQxIJxO@fedora>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <e58ddaa5-1bc1-dba9-a038-06022e65da59@canonical.com>
Date:   Tue, 1 Jun 2021 15:41:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLY3pSMrpbQxIJxO@fedora>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2021 15:35, Nigel Christian wrote:
> In the case MICROREAD_CB_TYPE_READER_ALL clang reports a dead code
> warning. The error code assigned to variable err is already passed
> to async_cb(). The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
> ---
>  drivers/nfc/microread/microread.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
> index 8d3988457c58..b1d3975e8a81 100644
> --- a/drivers/nfc/microread/microread.c
> +++ b/drivers/nfc/microread/microread.c
> @@ -364,7 +364,6 @@ static void microread_im_transceive_cb(void *context, struct sk_buff *skb,
>  	case MICROREAD_CB_TYPE_READER_ALL:
>  		if (err == 0) {
>  			if (skb->len == 0) {
> -				err = -EPROTO;
>  				kfree_skb(skb);
>  				info->async_cb(info->async_cb_context, NULL,
>  					       -EPROTO);
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
