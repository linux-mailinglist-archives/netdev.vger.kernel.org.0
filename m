Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFED22CE35
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXTBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXTBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 15:01:19 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54157C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:01:19 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so5721561pfm.4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZHhjSTHTI2mkISn6s0kW9hWL4aqRDxv5/uWBSLldThM=;
        b=ahGqzI0MAlUtqsl/szj8KPbnbanqpGkOR5xn8u49cdfCHBkEsweq3nyaOaVVtCaOsy
         i5qYJ9YfqpLyJOY2hkicKQS4uBV82/TgKrN8oo90qSQNG7LZ80FInQFBvs8XPHF31pst
         hUMDFtYE3k2bMmqSH5lDs3cIpoOvpK83s5cnfEc5A1hj9ROryb44mSSa6m+ev4QjIkyW
         hfBM12b/zW4hd6e87uXfg8rWRtSIUG/ivTEYfDw+KVLnliK/C690QEUh3D3dwY9thQWP
         YkYkv/1z+9/qKBdBOHu1eIiCQB8gQ+a7yAlKdfKAfxVU5c3DqqV8H0ln+5G//TF9BM6t
         b1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHhjSTHTI2mkISn6s0kW9hWL4aqRDxv5/uWBSLldThM=;
        b=efbP9FAtZYC4Dp3BS+Jpzj1ivm2OXj96b/mZ0a6NLQ7EnZUgta83tSduMPfc9/tcuk
         vuYv+RuvSSx1eckpfmW7UGlLGVyxnCmFnorIdTeJaTNkOEMtTOONpS+M/XX2kUV6uy3O
         t1KEy0a/Cgl0d2WGNocWUHS7cjHrac/+cmStht5x3J234W5LkRey/a81LwxL+oJbu/ag
         W88IhVBWoBjFbWAyrDSZw5ueCFshwOQxLZwhvCz/vZKnkUS59U4gzt84ITGIq+UfJk6d
         6jagVUQWZNRFdVg0NFTSRjAFECvvjBEcUDz4I/JrpVbZvqnvAF/2eP19eqTSgHw8WFfS
         nRuQ==
X-Gm-Message-State: AOAM530o4HADYZYdGsKl4FDDRHrI8KLgwSiK9RGMtPuDwEXqo32QCfvt
        HgIVTq6os9mmijCzQt8QkP0=
X-Google-Smtp-Source: ABdhPJwl+XKvTv7SPRLo0WL41+h/TpEKCJSRp174FEUvSbQxCNhp5CVSlidxvbYEzxVlBEBASyzg3A==
X-Received: by 2002:a63:d912:: with SMTP id r18mr9822592pgg.358.1595617278935;
        Fri, 24 Jul 2020 12:01:18 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l23sm6357605pjy.45.2020.07.24.12.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 12:01:18 -0700 (PDT)
Subject: Re: [PATCH net] selftests/net: fix clang issues for target arch
 PowerPC and others
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
References: <20200724181757.2331172-1-tannerlove.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <06be2c94-730f-2c0c-e1ee-a4b72c8885eb@gmail.com>
Date:   Fri, 24 Jul 2020 12:01:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200724181757.2331172-1-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/20 11:17 AM, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> Address these warnings observed with clang 9.
> 
> 
> tcp_mmap:
> Compilation yielded:
> warning: result of comparison of constant 34359738368 with \
> expression of type 'size_t' (aka 'unsigned int') is always true \

size_t is not generally 'unsigned int', not sure how you get this ?

> [-Wtautological-constant-out-of-range-compare]
>         while (total < FILE_SZ) {
> 
> Tested: make -C tools/testing/selftests TARGETS="net" run_tests
> 
>


> diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
> index 4555f88252ba..92086d65bd87 100644
> --- a/tools/testing/selftests/net/tcp_mmap.c
> +++ b/tools/testing/selftests/net/tcp_mmap.c
> @@ -344,7 +344,7 @@ int main(int argc, char *argv[])
>  {
>  	struct sockaddr_storage listenaddr, addr;
>  	unsigned int max_pacing_rate = 0;
> -	size_t total = 0;
> +	unsigned long total = 0;
>  	char *host = NULL;
>  	int fd, c, on = 1;
>  	char *buffer;
> 

This will break on 32bit arches, where sizeof(unsigned long) == 4

