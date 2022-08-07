Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E5758B9C1
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 08:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiHGGBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 02:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiHGGBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 02:01:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344D2B874
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 23:01:11 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p10so7512808wru.8
        for <netdev@vger.kernel.org>; Sat, 06 Aug 2022 23:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=TKefnLrtTQKsiMi+0BPxYk0WL1t7uR4y4cu8hieo2BE=;
        b=q1KRKhoi6b7DAoKJ9TDHv3U/hSncFbzkESuIvmP+xEgN2SjEgNNhxJRphbPsSsPTEo
         ZbBhv/Nk7lbyMGUpYiq3ycSFU977z+9ulmx9FCl5SJs/jD2QqKzQSL20AzMnqRQz4ppA
         ukdhFPUq+8Tv2+2Kcx2a4BFamM81JmpMpXmvNlVjIB971hz0t+/qczWLSaOPYjNXNmZn
         hqC/H9OU78WWHd2W/tGg5LxbMcUCcwoOPZbwORj+EFEe075HtbxPN6jOLFthw4rKFezi
         eGCt70dbmSbGum3ONc0eqxD28632gwRUU3sUJjlKVCOP1vJg/atbmQ09OD0W2JyVJSHH
         0/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=TKefnLrtTQKsiMi+0BPxYk0WL1t7uR4y4cu8hieo2BE=;
        b=uosI9xOEQEN1UO9G2DhbyKKeLIno2JFunhAOktlB9oOxBUhCdWmmTthZcRjsqiK1Ju
         8kwMceA+Bsq6YXzygNLKRPLMNxQbdyj0IGYdG/QYDJS5eyGWwrlhZDSkUOclSxiPuLHU
         gdPZY904DBDLMXE/WzRQc8JF287ZDOWbHW3BYesSFX4vcuWY1A3m7NWequQT3+18xNl1
         7Ma3T1BDLsj0I77vywdeVDKq+fCfp3k7tqYtvU2o/5Igd0buItyS6d+wd+awH1O2vSzZ
         oyMDXszUrrXrnJaWMXjZT89KY40m1a3Lr/37O0w86WHWPaq1RIUvdircbRrwz9Z+Vziv
         3+Wg==
X-Gm-Message-State: ACgBeo0HIW79/LtBWoGjqd5T8k74cohHBtgePNJ81i42/Fq79HT7A6TR
        1I8Aevz9evRMYAfIzvirLqM=
X-Google-Smtp-Source: AA6agR4rVmjOul6FT271VqPIl45KbaRuHVkA3Hx+w0uVxLRLknw/B1DEExR9ETYQwGI/96sGxAc/8Q==
X-Received: by 2002:adf:e44b:0:b0:220:5bc5:e942 with SMTP id t11-20020adfe44b000000b002205bc5e942mr8156461wrm.179.1659852069746;
        Sat, 06 Aug 2022 23:01:09 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id n11-20020a05600c500b00b003a4fb64efcasm13905062wmr.26.2022.08.06.23.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Aug 2022 23:01:09 -0700 (PDT)
Message-ID: <5696e2f2-1a0d-7da9-700b-d665045c79d9@gmail.com>
Date:   Sun, 7 Aug 2022 09:01:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
 <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
 <20220803182432.363b0c04@kernel.org>
 <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
 <20220804085950.414bfa41@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220804085950.414bfa41@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 6:59 PM, Jakub Kicinski wrote:
> On Thu, 4 Aug 2022 11:05:18 +0300 Tariq Toukan wrote:
>>>    	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,
>>
>> Now we see a different trace:
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 4 PID: 45887 at net/tls/tls_strp.c:53
> 
> OK, if you find another I promise I'll try to hassle a machine with
> offload from somewhere... here's the fix for the new one:
> 
> --->8----------------
> tls: rx: device: don't try to copy too much on detach
> 
> Another device offload bug, we use the length of the output
> skb as an indication of how much data to copy. But that skb
> is sized to offset + record length, and we start from offset.
> So we end up double-counting the offset which leads to
> skb_copy_bits() returning -EFAULT.
> 
> Reported-by: Tariq Toukan <tariqt@nvidia.com>
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   net/tls/tls_strp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
> index f0b7c9122fba..9b79e334dbd9 100644
> --- a/net/tls/tls_strp.c
> +++ b/net/tls/tls_strp.c
> @@ -41,7 +41,7 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
>   	struct sk_buff *skb;
>   	int i, err, offset;
>   
> -	skb = alloc_skb_with_frags(0, strp->anchor->len, TLS_PAGE_ORDER,
> +	skb = alloc_skb_with_frags(0, strp->stm.full_len, TLS_PAGE_ORDER,
>   				   &err, strp->sk->sk_allocation);
>   	if (!skb)
>   		return NULL;

Hi Jakub,
Thanks for the patch.
We're testing it and I'll update.
