Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43B6592927
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 07:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiHOFpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 01:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHOFo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 01:44:59 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B79414098
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 22:44:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z2so8372055edc.1
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 22:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=mMUN8Qee6AU9PyduawvjEcL4SapJHncscr/7tXu4+K4=;
        b=Tm5jgzTUgOoMSpl3LI8IvwEC8JMinl+dfgcGXsPbqWsYTOq549KDt7bK8DtuIhoqfd
         AFlbevdMUrem9eftVh5qM2VuCXBx1BoQnw2fa/tNbicaGYRDoqkEu0Ungjj0AMd5YBbW
         ClNV4qmZBmiFhJg0D/n2jAeIYC/xIpR7T8X3b/HXdkD9KRu3Ectb0IWkXE/e3REKDILA
         I6mm9CK7IErvIAP/FlFTdF0vXQAq2+TTZlAHaWGYxM589WTZTAnr99Jpav2WcRfbSryo
         7H7MeQ48OrAFyosCRasiMYIiMJE29a8VqsRZRUrgDw3KiXE5MXaoNYXdpVV3JWT1RsFK
         5NPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=mMUN8Qee6AU9PyduawvjEcL4SapJHncscr/7tXu4+K4=;
        b=J3fknsEQpe46G6hN44po1ODXoO6JMLxHGL6fYUqudY8MkOCLMDoCXvvVWBXLz6G/TD
         njFZSwgzk1lKKTYlNnHsX7qzU2IFO6LSEKpcXM6ccyW2jcBgCGlQm4R+D9UDaNZExPx4
         MFLKNCz3kt5o8Zt4eG0Nd+9/Loe3QCbEZOeO+x5LjDzza3OwnJuMQXz5VJk8NOixFHgt
         877Hk7mEtQjr8Rq6uuayTn/dU0jcZjjWSxkYTeJuQalCkDf6lyOFW+Q8dItJYlIHT0NH
         D8hi8fjH83u8yCPXFRchbnLUtSwxE0drNskbiebkBgvZtse9ZlO34R3U1Av8RvhBihRF
         1ZhA==
X-Gm-Message-State: ACgBeo3wHT9NaiMravpSyYXJtr5/LPEfC1GsJCzHZ+5DiJXNYy641+fm
        g6MF3pd97w0swEOZW9v8elrz/MyRJBwQBtL0V2M=
X-Google-Smtp-Source: AA6agR4Z6hwKoMrydksGcFsvhS3VExRGPQc6QMqRIYwU9hUrshQYx5Yt//HSTO0ijqaMxIFKRRB70w==
X-Received: by 2002:a05:6402:3408:b0:43c:2dd3:d86b with SMTP id k8-20020a056402340800b0043c2dd3d86bmr13277953edc.108.1660542297073;
        Sun, 14 Aug 2022 22:44:57 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r21-20020aa7cb95000000b0043cfc872e7dsm5979905edt.10.2022.08.14.22.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 22:44:56 -0700 (PDT)
Message-ID: <feff23c6-529c-3421-c48c-463846e59630@blackwall.org>
Date:   Mon, 15 Aug 2022 08:44:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] net: rtnetlink: fix module reference count leak
 issue in rtnetlink_rcv_msg
Content-Language: en-US
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     idosch@nvidia.com, petrm@nvidia.com, florent.fourcot@wifirst.fr,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20220815024629.240367-1-shaozhengchao@huawei.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220815024629.240367-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/08/2022 05:46, Zhengchao Shao wrote:
> When bulk delete command is received in the rtnetlink_rcv_msg function,
> if bulk delete is not supported, module_put is not called to release
> the reference counting. As a result, module reference count is leaked.
> 
> Fixes: a6cec0bcd342("net: rtnetlink: add bulk delete support flag")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/core/rtnetlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index ac45328607f7..4b5b15c684ed 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -6070,6 +6070,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
>  	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
>  		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
> +		module_put(owner);
>  		goto err_unlock;
>  	}
>  

Oops, thanks.
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
