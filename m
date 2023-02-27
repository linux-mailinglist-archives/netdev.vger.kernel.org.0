Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FAE6A3F32
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjB0KJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjB0KI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:08:58 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E52EB7E
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 02:08:57 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1823943wmo.0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 02:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRfiLd5rrqWzJQUNw1VX4OHWPixKqTocsZUdDpiD0zY=;
        b=K3U7HQaNCs0P2CGtzeLm6s/1V6zu7f2bWgm4qdGmcI9BLszneckhWMoBshxQuV9vao
         rlZ1dBEXo65irhCXVOBdl3QaCVcBj5OyalDVvJdv2MXAxMGFoYEZEl/N7HD0Rf0KNu8R
         TSXiuItfbU+Pa312Slz4zYX8xV9MerracaG+Z1FiKk0P+QjvfujfWeSAxfpIGn1xkpHI
         8/NzM9/SXR0bjwLg5kvGb3jTmudj+WsvI+M2TV9Opvur0dhGUtcDw8vmq8LGGAymH4Ba
         X1yuZFE6J9XttttdP0DuKAr7bV3sY/4LcU/5bvCFzLZeD0sqx1uNfNoCwIV6VhOR/Ejd
         7w3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRfiLd5rrqWzJQUNw1VX4OHWPixKqTocsZUdDpiD0zY=;
        b=l9xoMGKaf+fAIGqJnsptIya+h76b9rIsYlGeXqD0++U5b/SHHR2nsqDO4UK9kfwuTt
         MUYZ5lAPyFjzA+morqXW0AtLHHZ64qzFswm/EsCTlnQMSW3naz+1rgt1ALHLCUYvAjPb
         O8jrv9WzznAftamC0iHcMm1ZppHuF4FkpJcAzGqqUi+79uaYeHv7FNh3HUPRHDfVjXun
         FZfyL4UD24QIey9OmQWyODbbIbZu19FWOemzzSkgXnmROCG/GRNnzNtAhxUOkA/TqlYh
         rkfqUTFcmTwDAQnKjYaAbYTEj0V75pzhSciT8+LYJqCl27gGkh5DZkdaKt0kJ3pYfmZ7
         SXHw==
X-Gm-Message-State: AO0yUKW0YdQ/gZKjSSiloBLrKX9QwEuAVi2EnKeeFB3oWi17H8YjtLJ1
        zsl0KJQ8zfHgQQBe5JRUl5Q4LQ==
X-Google-Smtp-Source: AK7set9zM/062j1o5buNm0Bzw0iHceTIMbQqNSQny5nzqeB3OAlk7lw2smia9JgQhANsDJSo/SjWmw==
X-Received: by 2002:a05:600c:43d6:b0:3eb:3fea:a2ac with SMTP id f22-20020a05600c43d600b003eb3feaa2acmr2928243wmn.22.1677492535716;
        Mon, 27 Feb 2023 02:08:55 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id d24-20020a1c7318000000b003dc522dd25esm8433699wmb.30.2023.02.27.02.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 02:08:55 -0800 (PST)
Message-ID: <b0f65aaa-37aa-378f-fbbf-57d107f29f5f@linaro.org>
Date:   Mon, 27 Feb 2023 11:08:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] nfc: fix memory leak of se_io context in nfc_genl_se_io
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
References: <20230225105614.379382-1-pchelkin@ispras.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230225105614.379382-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/02/2023 11:56, Fedor Pchelkin wrote:
> The callback context for sending/receiving APDUs to/from the selected
> secure element is allocated inside nfc_genl_se_io and supposed to be
> eventually freed in se_io_cb callback function. However, there are several
> error paths where the bwi_timer is not charged to call se_io_cb later, and
> the cb_context is leaked.
> 
> The patch proposes to free the cb_context explicitly on those error paths.

Do not use "This commit/patch".
https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

> 
> At the moment we can't simply check 'dev->ops->se_io()' return value as it
> may be negative in both cases: when the timer was charged and was not.
> 
> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

SoB order is a bit odd. Who is the author?

> ---
>  drivers/nfc/st-nci/se.c   | 6 ++++++
>  drivers/nfc/st21nfca/se.c | 6 ++++++
>  net/nfc/netlink.c         | 4 ++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> index ec87dd21e054..b2f1ced8e6dd 100644
> --- a/drivers/nfc/st-nci/se.c
> +++ b/drivers/nfc/st-nci/se.c
> @@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
>  					ST_NCI_EVT_TRANSMIT_DATA, apdu,
>  					apdu_length)
nci_hci_send_event() should also free it in its error paths.
nci_data_exchange_complete() as well? Who eventually frees it? These
might be separate patches.


>  	default:
> +		/* Need to free cb_context here as at the moment we can't
> +		 * clearly indicate to the caller if the callback function
> +		 * would be called (and free it) or not. In both cases a
> +		 * negative value may be returned to the caller.
> +		 */
> +		kfree(cb_context);
>  		return -ENODEV;
>  	}
>  }
> diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> index df8d27cf2956..dae288bebcb5 100644
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -236,6 +236,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
>  					ST21NFCA_EVT_TRANSMIT_DATA,
>  					apdu, apdu_length);
>  	default:
> +		/* Need to free cb_context here as at the moment we can't
> +		 * clearly indicate to the caller if the callback function
> +		 * would be called (and free it) or not. In both cases a
> +		 * negative value may be returned to the caller.
> +		 */
> +		kfree(cb_context);
>  		return -ENODEV;
>  	}
>  }
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 1fc339084d89..348bf561bc9f 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -1442,7 +1442,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
>  	rc = dev->ops->se_io(dev, se_idx, apdu,
>  			apdu_length, cb, cb_context);
>  
> +	device_unlock(&dev->dev);
> +	return rc;
> +
>  error:
> +	kfree(cb_context);

kfree could be after device_unlock. Although se_io() will free it with
lock held, but error paths usually unwind everything in reverse order
LIFO, so first unlock then kfree.

>  	device_unlock(&dev->dev);
>  	return rc;
>  }

Best regards,
Krzysztof

