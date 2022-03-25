Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95594E7C99
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiCYUEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiCYUDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:03:38 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23E196D5E
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:55:37 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9so5885618ilu.9
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hrsTCAbz+ofsFk3KXU3EyzUXcikKYOkABLLUZ9LcLV4=;
        b=PNc37wRMw7rIGTQml+Sy2CvDN585VeAf4M5XfVDXfnIJXC41EiPaUltn5IH2QUr9Eh
         SI3B+WX+OiXK84CO18BTBogoWhoGPE9IFLkbvA+D+Ih+AMPjTTdFyiAZ92v+gcq/z8tT
         qPx1T20r+DoLuLuPOGoB/YTkLDbJ5e2hJhpb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hrsTCAbz+ofsFk3KXU3EyzUXcikKYOkABLLUZ9LcLV4=;
        b=E1bxKUGTfF2qLIoVRFaW6ycc5s0NHTfrSSd/ZwuSHfwgsdb+YY2pgzTtHZDkjiWklD
         er3YKLl2XqrvvHi42V+qzAkJOF0F025bIJKvgUnw1FikgQt2mtqt3PxpR/3OcImjweFn
         AUKhfyF1rUNFwcpcNhru6Qtna0hVuFueGZeGt/z1erQFpJbrwJSyiAQ5VJTVMBABlr7P
         wbo8aVdLrOKc3C7m1PeXy/tuMpLa3ciTgcPZev9uz7YlKub6fCgqenqBfmjEwl6hnTLe
         /NNfqFmHTlEoeZ9HdYlU2nM6vUc+fqB2XoqqTOhYTrFx1HKDcMdugSpKoBP2A5KDp1B+
         Oy+w==
X-Gm-Message-State: AOAM532Y7nMh0GGlEcuxc18wXHMNya0X+K3O7aPt1zHL6f53tbDYwgcZ
        0yfttMwGfeR7GQtG29UnlHsQrQ==
X-Google-Smtp-Source: ABdhPJxl8DLzWK/2Mo7UlGU1+o7IxDSqMdedu9s4uw2DaczRov3nY4LyV7zXIqyneKl73kQ6P+zPNw==
X-Received: by 2002:a05:6e02:18cb:b0:2c7:fdad:31b8 with SMTP id s11-20020a056e0218cb00b002c7fdad31b8mr160984ilu.123.1648238137038;
        Fri, 25 Mar 2022 12:55:37 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id l19-20020a056e020e5300b002c866dfd494sm3212745ilk.21.2022.03.25.12.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 12:55:36 -0700 (PDT)
Subject: Re: [PATCH] selftests/bpf: Fix warning comparing pointer to 0
To:     Haowen Bai <baihaowen@meizu.com>, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <1648087725-29435-1-git-send-email-baihaowen@meizu.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <29503ac1-69ab-a0b7-53bc-5a7522baa289@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 13:55:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1648087725-29435-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/22 8:08 PM, Haowen Bai wrote:
> Avoid pointer type value compared with 0 to make code clear.
> 

Patch looks good to me. Please include the error/warn message
in the commit log. This gives reviewers information on how
this problem is found.

> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>   tools/testing/selftests/bpf/progs/map_ptr_kern.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> index b64df94..db388f5 100644
> --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> @@ -367,7 +367,7 @@ static inline int check_array_of_maps(void)
>   
>   	VERIFY(check_default(&array_of_maps->map, map));
>   	inner_map = bpf_map_lookup_elem(array_of_maps, &key);
> -	VERIFY(inner_map != 0);
> +	VERIFY(inner_map != NULL);
>   	VERIFY(inner_map->map.max_entries == INNER_MAX_ENTRIES);
>   
>   	return 1;
> @@ -394,7 +394,7 @@ static inline int check_hash_of_maps(void)
>   
>   	VERIFY(check_default(&hash_of_maps->map, map));
>   	inner_map = bpf_map_lookup_elem(hash_of_maps, &key);
> -	VERIFY(inner_map != 0);
> +	VERIFY(inner_map != NULL);
>   	VERIFY(inner_map->map.max_entries == INNER_MAX_ENTRIES);
>   
>   	return 1;
> 

With the change to commit log including the error/warn message and
details on how the problems is found:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
