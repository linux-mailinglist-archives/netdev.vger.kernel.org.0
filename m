Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAED7527DBF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 08:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbiEPGoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 02:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiEPGon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 02:44:43 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA6336333
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 23:44:42 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id h29so24097461lfj.2
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 23:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1LbC7djwtLM4YZ72y/hNCJx0pEPopsHYbpFNoVttBhA=;
        b=RCmUuhtjhJeNYEVEw1Rol9WRb4ku+esDkaKAShmsnU5o+Q9m6BZwSLu0PICvvwOcXh
         2IN/J1kv0RgTIiQYDUHqWzc4AExXT4nWjeJvI+wLNAghb3kz9Ts5dlKK1B57hZavzY37
         RvW51gSY/S9G/jwF/VKioXGgCHR07sVTghcWjdnlhSfEQC+SaSbzhqBUy4gIDbWZ3yhG
         EZboCW+y1VFmsY6ordwkQq4LmqJo9GYu//djNuAfBDqjeBetka79LaC1SaRdxi1JcNUm
         +Rm2v/e6ktXMpMq0OaynyTFC5FVuRFiBe1EK1F1MRaDK05Y5saajpz9aTXHxF3TMd+f3
         ePOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1LbC7djwtLM4YZ72y/hNCJx0pEPopsHYbpFNoVttBhA=;
        b=2KjS6C4BO3ploPavqwlNMVFuB1l9EANoJeO1A3Z8RjGX3ql3BFKKPq+h/RAOvKtFkG
         hFJV1LNx2hD5IKinzkCG3xx3UFWKQ6GEfTx67HNgHPShPlnOBaSVXtWiBvZvItG57SVn
         PBTcY1BzUJIKQOqyLyQw5BzvPJb5rmihEZ5D80xw0ybjnZGwCOiPemFjPor/YQy2CKCR
         yGVLQKfTXXFBuvAjb2BAaOHRiSB0GSnTmmnqAi/I390AC4sPlN5dTslYtQLHpyJ8OW2n
         sVlvoqw/OcplP6jVmSu0YQwfU//INqNXulMNnIJWEYjpR0M4six4YDuQUELZTk7RE67b
         C8lg==
X-Gm-Message-State: AOAM530NC+JI1qHMxZE2zjs3P1sOdQEJvxWMv1kf2mF52cQNqLYMLrTq
        0ckVl1hBWdrduRbhVjfPgEwaeg==
X-Google-Smtp-Source: ABdhPJy7JBh/EolHXYB9iXXCO/1B6ptm129XpZcRWu58H0Zz4/1TzYvTCpH32xofvi+onbrPm/AWsA==
X-Received: by 2002:a19:7710:0:b0:472:3486:a49e with SMTP id s16-20020a197710000000b004723486a49emr12318505lfc.600.1652683481024;
        Sun, 15 May 2022 23:44:41 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y27-20020a2e545b000000b0024f3d1daef3sm1435220ljd.123.2022.05.15.23.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 23:44:40 -0700 (PDT)
Message-ID: <d5fdfe27-a6de-3030-ce51-9f4f45d552f3@linaro.org>
Date:   Mon, 16 May 2022 08:44:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
References: <20220516021028.54063-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220516021028.54063-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/05/2022 04:10, Duoming Zhou wrote:
> There are sleep in atomic context bugs when the request to secure
> element of st21nfca is timeout. The root cause is that kzalloc and
> alloc_skb with GFP_KERNEL parameter is called in st21nfca_se_wt_timeout
> which is a timer handler. The call tree shows the execution paths that
> could lead to bugs:
> 
>    (Interrupt context)
> st21nfca_se_wt_timeout
>   nfc_hci_send_event
>     nfc_hci_hcp_message_tx
>       kzalloc(..., GFP_KERNEL) //may sleep
>       alloc_skb(..., GFP_KERNEL) //may sleep
> 
> This patch changes allocation mode of kzalloc and alloc_skb from
> GFP_KERNEL to GFP_ATOMIC in order to prevent atomic context from
> sleeping. The GFP_ATOMIC flag makes memory allocation operation
> could be used in atomic context.
> 
> Fixes: 8b8d2e08bf0d ("NFC: HCI support")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  net/nfc/hci/hcp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
> index 05c60988f59..1caf9c2086f 100644
> --- a/net/nfc/hci/hcp.c
> +++ b/net/nfc/hci/hcp.c
> @@ -30,7 +30,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
>  	int hci_len, err;
>  	bool firstfrag = true;
>  
> -	cmd = kzalloc(sizeof(struct hci_msg), GFP_KERNEL);
> +	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);

No, this does not look correct. This function can sleep, so it can use
GFP_KERNEL. Please just look at the function before replacing any flags...



Best regards,
Krzysztof
