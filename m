Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79963B9F1A
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhGBKcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 06:32:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231192AbhGBKcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625221779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPxMNn2CCE4cxpTvsVh+CYPLZZTodxuHXGUXkbr4MMw=;
        b=S0Kmn7NtIScTIUSGY9HLR1onvdjkgQXkcoiv2U/qqd1xujwE9oPQaGyqbxvwY2a7qRz8xq
        eDcnCUnoK3WLhIP7mZ+41SClFIi4kc54MTO2I8kZQnUh8f9XC0Yf9UfTTkFh581Miqbw42
        2izhHAk1Wkjlmb4KjwAZxGUzdITP/fA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-hv8HLHc5NL2p1AE1b2lKoA-1; Fri, 02 Jul 2021 06:29:38 -0400
X-MC-Unique: hv8HLHc5NL2p1AE1b2lKoA-1
Received: by mail-ed1-f70.google.com with SMTP id df18-20020a05640230b2b0290397ebdc6c03so791102edb.7
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 03:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DPxMNn2CCE4cxpTvsVh+CYPLZZTodxuHXGUXkbr4MMw=;
        b=RAmgVdhPdWhPdUdPauzMK/+3ZP50W7thC5rBij30iXzhiB45HQL7cF4tBKfpwz624K
         tQ6lqulGANXKvWTNRgXzKQlAohaMQ3rOtiXwQonpAaohj/MIX9GF+F6pWB2rA/lN41Vo
         +ENOKohjOxxUQFAYOD4sxHi+lJq0sw/d+OBsRTPUuxjfSFx2SN1HpSU1/sU0cvu9l2H1
         WVUgy8JMLxvWTnaQDqzUqfXjgt6OvBxxzt+5JA5pb7OPZhlIT5rqpjaO0CMnzvOGLUjS
         66BZIQPdOQFfXXkdx3IH7Pz6N6EO2y/NQoTScUdu5MBTX2VenlfzcmVc1BX3uUmgaH9F
         HYRQ==
X-Gm-Message-State: AOAM532fM/PKRzVKt+uRvq5oW8LnEDk1y3hq5sJ9WlMBDQ8gA98t86R5
        10MghT10BXsKIgIRuAXvyUs1mer1CzZJ8oph9+T2kCp+lh1gVCh9rEpsD+HITUz16mpgLF3E4qi
        smPo7heLHCZDnCxBd
X-Received: by 2002:a05:6402:2813:: with SMTP id h19mr5739019ede.39.1625221776628;
        Fri, 02 Jul 2021 03:29:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeTV7Vr11aiyTEXIqNuKKngfk6mHPBCj/YJvYik4FkcZfq09iNjgHFyinId+fVKL5hjUuW0Q==
X-Received: by 2002:a05:6402:2813:: with SMTP id h19mr5739002ede.39.1625221776482;
        Fri, 02 Jul 2021 03:29:36 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id br4sm666879ejb.110.2021.07.02.03.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 03:29:36 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf] samples/bpf: Fix the error return code of
 xdp_redirect's main()
To:     Wang Hai <wanghai38@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210616042534.315097-1-wanghai38@huawei.com>
Message-ID: <94aad4ed-8384-1841-88ec-6c7e39d63148@redhat.com>
Date:   Fri, 2 Jul 2021 12:29:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616042534.315097-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/06/2021 06.25, Wang Hai wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

The main() function in C should never return a negative value on Unix 
POSIX systems.


There is a good explaination in exit(3p): `man 3p exit`

    The  value  of  status may be 0, EXIT_SUCCESS, EXIT_FAILURE, or any 
other value, though only the least significant 8 bits (that is, status & 
0377) shall be available to a waiting parent process.

Thus, negative values are often seen as 255 in the $? program exit 
status variable $?.


Also explained in exit(3):

     The C standard specifies two constants, EXIT_SUCCESS=0 and 
EXIT_FAILURE=1.

I see the 'samples/bpf/xdp_redirect_user.c' in most places just use 0 or 1.


> If bpf_map_update_elem() failed, main() should return a negative error.
>
> Fixes: 832622e6bd18 ("xdp: sample program for new bpf_redirect helper")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>   samples/bpf/xdp_redirect_user.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
> index 41d705c3a1f7..c903f1ccc15e 100644
> --- a/samples/bpf/xdp_redirect_user.c
> +++ b/samples/bpf/xdp_redirect_user.c
> @@ -213,5 +213,5 @@ int main(int argc, char **argv)
>   	poll_stats(2, ifindex_out);
>   
>   out:
> -	return 0;
> +	return ret;
>   }


(Sorry, I didn't complain it time as I see this patch is already applied)

