Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52BE6AC4F2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjCFP2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjCFP2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:28:36 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD27530295
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 07:28:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id da10so40268246edb.3
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 07:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678116493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vGoybtGyEZ3XZy7dkoHPImpq+tIMq1JeSmYTyugSWwg=;
        b=JHhIwYWaDlWdH3ONk/YeiIzIg/MCRrWQnx8XS/CnNAfkE2dlB0YIAzQmS91LSHnCXr
         bC6dT4pAH19M3cR+/U1NvJCZjRvTHUtEEMwE5J0ktgieL23DG8W4PlDuzCXO0vPDKYID
         rjBPuNjx5F2xIaMJ4suIva8zIVEcWMGtfrYuKUoltXNwgEYvLU8PyJDN1vQ9RRn+GlH6
         EZ72Gzb5mXuQQv7xuNhKsWLPHnadzLuLOCkIYhyhYGeBbj7WB1B1O1MA+/Ur9XS41nyj
         JDw5jjzHf4MUWB/whq7BH5XxiqCHxugZS7U4+eVWKU0BIjt2yFZQ6C1irqZxIIHSjgtj
         IdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678116493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGoybtGyEZ3XZy7dkoHPImpq+tIMq1JeSmYTyugSWwg=;
        b=ExusplXJYQcH0vuUxlmn00FT01D/1p1zXPx4g/1flBmED0SZaiQk5LbC6PGNUPlZos
         oe5nUeynX7YcX64KpSdaqMZqvXohxWfWcnivTrGhacffcPS3aztQyNG3BhrrT2ZIp05E
         a78Clf2hl+I0eIxlAx5qdqNkAbYdz0rpjfkaOFMJhPaOGuWAq3KBKDAvB1UrTxzRHttF
         klGC3pn9r2F+hpmQGZvNCa8n3mKNj4zjKmUmtJiBPllv91MioZo91DdOCjOe54Bp7tZY
         +wTccgxeh8z1UnZQqEjV8MqFPrq8GvXK+W5ZhnSZ1EK5bUav0u4E5Nq2oxxiKmGCOosV
         8jWQ==
X-Gm-Message-State: AO0yUKXcE/35Dld+ea2lk2dg1ckLhHmww5/TlRT8YLLdjL9aFWZtrnxQ
        9ctzNzfPZuoGsXR7kMnIpQ/Ibg==
X-Google-Smtp-Source: AK7set/s02rywbkwIGSEviqyetPyCayi/HQDzUhcYvpyeZeqt3HtlIOm2vDUQFPqVrdC+QsqSbZJ8g==
X-Received: by 2002:a05:6402:31f8:b0:4ac:b602:3fa4 with SMTP id dy24-20020a05640231f800b004acb6023fa4mr10483952edb.17.1678116493594;
        Mon, 06 Mar 2023 07:28:13 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:c1e7:5006:98ac:f57? ([2a02:810d:15c0:828:c1e7:5006:98ac:f57])
        by smtp.gmail.com with ESMTPSA id w21-20020a1709064a1500b008cce6c5da29sm4683495eju.70.2023.03.06.07.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 07:28:13 -0800 (PST)
Message-ID: <7370a80b-56f9-a858-ff05-5ba9d7206c8c@linaro.org>
Date:   Mon, 6 Mar 2023 16:28:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] nfc: change order inside nfc_se_io error path
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
References: <20230304164844.133931-1-pchelkin@ispras.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230304164844.133931-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/03/2023 17:48, Fedor Pchelkin wrote:
> cb_context should be freed on error paths in nfc_se_io as stated by commit
> 25ff6f8a5a3b ("nfc: fix memory leak of se_io context in nfc_genl_se_io").
> 
> Make the error path in nfc_se_io unwind everything in reverse order, i.e.
> free the cb_context after unlocking the device.
> 
> No functional changes intended - only adjusting to good coding practice.

I would argue that it is functional. Running code in or outside of
critical section/locks is quite functional change.

> 
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  net/nfc/netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 348bf561bc9f..b9264e730fd9 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -1446,8 +1446,8 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
>  	return rc;
>  
>  error:
> -	kfree(cb_context);
>  	device_unlock(&dev->dev);
> +	kfree(cb_context);


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

>  

Best regards,
Krzysztof

