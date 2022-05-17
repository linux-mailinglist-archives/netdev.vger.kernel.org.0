Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5052A09F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345368AbiEQLmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiEQLmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:42:46 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567284348A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:42:44 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id bx33so21416529ljb.12
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uj5rCEgrEME0641i65F/SbR6hoTPj4hzhlWTwqHQqWk=;
        b=RcFydaN3PbLyev6mS4qntlxs4M51b7yJgGfZ8ex/bJuWNY0MSRmcIhwi52CSHHNZdN
         ptBAimz8cIO2HJN9H/Ig0xRPIxLfJCNPWQ4+PPpm1u4UiJ/7LDS8rR/9UqByvZlpXKKd
         PMrrZUBBzxyVPDbd6F8cBquq4HN7wkJ+jAm+nTco1smdGWT92QvDiX0L0QsGSXitoGY7
         C/SMR6Bc4k4+9+KRvHwCh8OIsbvDO87DGgOvuIxuHz0qBdwCFF71dHc0k9MI41RKFExh
         NSZ0DnGvT6jTrZMTXXuv6Wk56JTbW7jqg1PhfR6n3Dy2cKXOTTkR1xy69Z5mzIhThqpi
         B+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uj5rCEgrEME0641i65F/SbR6hoTPj4hzhlWTwqHQqWk=;
        b=on1Q+MS7+nutDGKAyZf2WjFUtuk0JdBl9JHUD/JWUFhv3eRINGURNO/Sh9guMmXe2Y
         Fm4nwmOY5SZ2G+vGpkgE4rcpa79kM/l0i5/QPQ1zW8TJU1zJtH8LiL0kjfqE4TfoVQWc
         XR0G3+rO8pyhmEOjw+6v7KnysnrCBIbpinL4UiPaLKQ1lQ5tLfkjkKtNyEqQ/SoHSOgs
         PtmGevKk/I+clfE7bOXlP37sujjauGXW1H9Q7IRrjQxyJ4Z1hEMk7Y/X5HofpPQawizu
         YFrDRw67liGdaVhYa1kPtFnUK2rTkRtBbiY38pY3tz00DTQJky55mSSQ1fXrot90oGHe
         F76Q==
X-Gm-Message-State: AOAM531NistYY8fbXcU23IK1rvw1lsyaHdW+Gt2oCnXPrAqXz5UXSJyZ
        FDSpx2hpy+cRwOKWGl4qgytmpi6c7F6vXTXP
X-Google-Smtp-Source: ABdhPJxNGdUbUsF1H48W0SHvw7YaCknC4xl6XPByeWgTRCruMGoyqvNEwEBWhIoPpVCrhH3vfj0JpQ==
X-Received: by 2002:a2e:81a:0:b0:250:a331:d0b1 with SMTP id 26-20020a2e081a000000b00250a331d0b1mr14297265lji.363.1652787762678;
        Tue, 17 May 2022 04:42:42 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id j20-20020a2e8014000000b0024f3d1dae96sm1874136ljg.30.2022.05.17.04.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 04:42:42 -0700 (PDT)
Message-ID: <2ce7a871-3e55-ae50-955c-bf04a443aba3@linaro.org>
Date:   Tue, 17 May 2022 13:42:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v2] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
References: <20220517105526.114421-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220517105526.114421-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/05/2022 12:55, Duoming Zhou wrote:
> There are sleep in atomic context bugs when the request to secure
> element of st21nfca is timeout. The root cause is that kzalloc and
> alloc_skb with GFP_KERNEL parameter and mutex_lock are called in
> st21nfca_se_wt_timeout which is a timer handler. The call tree shows
> the execution paths that could lead to bugs:
> 
>    (Interrupt context)
> st21nfca_se_wt_timeout
>   nfc_hci_send_event
>     nfc_hci_hcp_message_tx
>       kzalloc(..., GFP_KERNEL) //may sleep
>       alloc_skb(..., GFP_KERNEL) //may sleep
>       mutex_lock() //may sleep
> 
> This patch changes allocation mode of kzalloc and alloc_skb from
> GFP_KERNEL to GFP_ATOMIC and changes mutex_lock to spin_lock in
> order to prevent atomic context from sleeping.
> 
> Fixes: 2130fb97fecf ("NFC: st21nfca: Adding support for secure element")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v2:
>   - Change mutex_lock to spin_lock.
> 
>  include/net/nfc/hci.h |  3 ++-
>  net/nfc/hci/core.c    | 18 +++++++++---------
>  net/nfc/hci/hcp.c     | 10 +++++-----
>  3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
> index 756c11084f6..8f66e6e6b91 100644
> --- a/include/net/nfc/hci.h
> +++ b/include/net/nfc/hci.h
> @@ -103,7 +103,8 @@ struct nfc_hci_dev {
>  
>  	bool shutting_down;
>  
> -	struct mutex msg_tx_mutex;
> +	/* The spinlock is used to protect resources related with hci message TX */
> +	spinlock_t msg_tx_spin;
>  
>  	struct list_head msg_tx_queue;
>  
> diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
> index ceb87db57cd..fa22f9fe5fc 100644
> --- a/net/nfc/hci/core.c
> +++ b/net/nfc/hci/core.c
> @@ -68,7 +68,7 @@ static void nfc_hci_msg_tx_work(struct work_struct *work)
>  	struct sk_buff *skb;
>  	int r = 0;
>  
> -	mutex_lock(&hdev->msg_tx_mutex);
> +	spin_lock(&hdev->msg_tx_spin);
>  	if (hdev->shutting_down)
>  		goto exit;

How did you test your patch?

Did you check, really check, that this can be an atomic (non-sleeping)
section?

I have doubts because I found at least one path leading to device_lock
(which is a mutex) called within your new code.

Before sending a new version, please wait for discussion to reach some
consensus. The quality of these fixes is really poor. :(

Best regards,
Krzysztof
