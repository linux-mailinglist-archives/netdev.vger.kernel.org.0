Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF223C2C6
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHEAyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHEAyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 20:54:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F23C06174A;
        Tue,  4 Aug 2020 17:54:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l60so3565533pjb.3;
        Tue, 04 Aug 2020 17:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BxG05DrFE72MOSGeh/nY3ptdaEd7/gUavlyqDnB6i8I=;
        b=AowsasC1tnaoLsPE+JXPouJvv4SWJ8rby3ouB/3Lk3rA6Ad+K4X8QYIoew3qNP/CSH
         c01KUTKd9ezV2iy1zV1NvrhEdyPZekjBx8GYYtTfk+302Q6BSur1QzeIu/6s/vzuUj2w
         GyLbD/ZMYB+4YUy8w1l7ntsOL4B1s1am4vLLrJ3qBO/KKYS6e7GBJ1cGksgRp3ngMGiW
         TP6XDk5wcK8Gu7WAaagVhn0mihANBOdE9ay1OWO+dS8k0RkSeBaYRBLug1+b0USPh2XN
         WZaxI5XzWcODT3Sp8zBhnuigBT94g4om8oaax00jUWa/bFmW6y6GuOuKHl4q5iLOWD+E
         wHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BxG05DrFE72MOSGeh/nY3ptdaEd7/gUavlyqDnB6i8I=;
        b=gOJtqrarJaJrvwkhPtIA+F0dmy1OFPs++jAkz38DlX2biULwRm4uc1i3yK4dy+qdT/
         kd2SJ6jxwqSBFCOnPpnzGhhMvXkfn9bPjIBWpokVT98GcIp5/YrMFGkrkaiJ+5rruxdm
         D7JrUqLo9UIBhan2ncdrPniXRzQOBOl31FPD3Z7IW9ar1bzOk3twMRWFtiKYWNnI4xLg
         k4LqrZxuxq0uPgfHkvb69oHUej6c/eKBCm0Qx3q6HOwkIT1uwEd/PzJ4u1apPL7L1jHZ
         77oqrWrY+B301WlbWzHq7z8jG4h/bzAxhBiVlbUvxJfAy8+DVOJcQvXcbcDkzmo5XfeI
         5HRA==
X-Gm-Message-State: AOAM530XqK8tUmG4e6CbWr1qMnyqtdFD82Md//NCbjAgrAMlZ80hDekX
        1n9FJehjVvRebislRSM6KgujBWgi
X-Google-Smtp-Source: ABdhPJxr0UjlZMG0OjFUlayZYLfycyN2ymZAc4EBOQ7kJ4SMuC8oXoDn0GJiozFWRN8ChOO0WI3cDg==
X-Received: by 2002:a17:902:bd01:: with SMTP id p1mr843670pls.25.1596588861126;
        Tue, 04 Aug 2020 17:54:21 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s61sm397343pjb.57.2020.08.04.17.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 17:54:20 -0700 (PDT)
Subject: Re: [PATCH] selftests/net: skip msg_zerocopy test if we have less
 than 4 CPUs
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200804123012.378750-1-colin.king@canonical.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b99004ea-cd9d-bec3-5f9f-82dcb00a6284@gmail.com>
Date:   Tue, 4 Aug 2020 17:54:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200804123012.378750-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/20 5:30 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The current test will exit with a failure if it cannot set affinity on
> specific CPUs which is problematic when running this on single CPU
> systems. Add a check for the number of CPUs and skip the test if
> the CPU requirement is not met.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  tools/testing/selftests/net/msg_zerocopy.sh | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/msg_zerocopy.sh b/tools/testing/selftests/net/msg_zerocopy.sh
> index 825ffec85cea..97bc527e1297 100755
> --- a/tools/testing/selftests/net/msg_zerocopy.sh
> +++ b/tools/testing/selftests/net/msg_zerocopy.sh
> @@ -21,6 +21,11 @@ readonly DADDR6='fd::2'
>  
>  readonly path_sysctl_mem="net.core.optmem_max"
>  
> +if [[ $(nproc) -lt 4 ]]; then
> +	echo "SKIP: test requires at least 4 CPUs"
> +	exit 4
> +fi
> +
>  # No arguments: automated test
>  if [[ "$#" -eq "0" ]]; then
>  	$0 4 tcp -t 1
> 

Test explicitly uses CPU 2 and 3, right ?

nproc could be 500, yet cpu 2 or 3 could be offline

# cat /sys/devices/system/cpu/cpu3/online
0
# echo $(nproc)
71
