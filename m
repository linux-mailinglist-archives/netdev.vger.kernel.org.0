Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209B6424055
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbhJFOq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhJFOq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:46:56 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A59CC061749;
        Wed,  6 Oct 2021 07:45:04 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id e16-20020a4ad250000000b002b5e1f1bc78so897386oos.11;
        Wed, 06 Oct 2021 07:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JBtRY365OM1Ze3t730v+NQ8ra3UU6eUF9sKHTNUsFWA=;
        b=divqiK2PDpi+uR9iGKV787gf0Ytr1H4MZVihs16FhO1uTZig6SXCuE3YF0GKAp9xUH
         74o9AI04hjXjyyAY7wFpqHY69bkARFQ2Izp4VhzlS2ttUDbFkuAuRtaQPa6avGEzKulj
         V6kK4+s02wEeYAJpbZwpR1xp2zZNUtYG8qQTa9Xn/yfgobMSSWnPpS5DNiqdFIpEC6GF
         5D7Y3WA5O+xthteDMs7pGVEkOo4XSriY4pjQ1ciwTjX/paRNNJZnyqYLBmO5SpYKgwKP
         1nLFjFm36fI48Vdkw0ACZI8plSwnJyabbHT8TkvzMMqF/KuK2TZYBaXWDvXYJsJkhX1L
         jD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBtRY365OM1Ze3t730v+NQ8ra3UU6eUF9sKHTNUsFWA=;
        b=MjgfH0OFY0rtZ1uLuCjjOJhvhljdaiW49pTjXYiic/tobLeCLTuw3W549//PO9o0lG
         i3sql5WCgh66AJgP51nM2aHr74UmWiY1BZK5gAZ7ic8FKYIPXlfKsYQbFHTXMFTh2ByI
         sSpqJA4qgoJu176qccUl0TbfoSHxB/C/eli1ATo7vJ7sySy/P5umkmpQtU1F2jpMx2IS
         NIzhjrqLj2gSTfox6BIRXcNFJ6W7Fpq8gpox2qe6etBU+lPBY1x/EoBbBT8OonZsjdDg
         6idTcw7R8Gx+oI5POVUZ3EB15zihe/g/dlU5uVCAHQ4eUqBY5wPzG3SKLLE6l1ClKiv5
         O57w==
X-Gm-Message-State: AOAM530K9F+vaU21lF6uAQI+VZixaj9ciozWVAxMsCpVHwUC77qX1HV8
        9qCL5RUqzFipKzP6/jy+AJkNV5VnAavLog==
X-Google-Smtp-Source: ABdhPJynOGdvV0XmUejc28RvscsjL00B9Bm/oIeBIwzBPTBIlUHkFU0bdHHlCXniu7QMjfOwh5xnWg==
X-Received: by 2002:a4a:bd8a:: with SMTP id k10mr18075050oop.41.1633531502868;
        Wed, 06 Oct 2021 07:45:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e2sm4010099ooh.40.2021.10.06.07.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:45:02 -0700 (PDT)
Subject: Re: [PATCH 05/11] selftests: net/fcnal: kill_procs via spin instead
 of sleep
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ff71285715d47b8c9b6bedb3b50700a26bc81f41.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b1a213d5-470d-637d-4e78-1b7653d87041@gmail.com>
Date:   Wed, 6 Oct 2021 08:45:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ff71285715d47b8c9b6bedb3b50700a26bc81f41.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Sleeping for one second after a kill is not necessary and adds up quite
> quickly. Replace with a fast loop spinning until pidof returns nothing.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index 0bd60cd3bc06..b7fda51deb3f 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -176,12 +176,19 @@ show_hint()
>  	fi
>  }
>  
>  kill_procs()
>  {
> -	killall nettest ping ping6 >/dev/null 2>&1
> -	sleep 1
> +	local pids
> +	while true; do
> +		pids=$(pidof nettest ping ping6)
> +		if [[ -z $pids ]]; then
> +			break
> +		fi
> +		kill $pids
> +		sleep 0.01
> +	done
>  }
>  
>  do_run_cmd()
>  {
>  	local cmd="$*"
> 

ideally the script keeps track of processes it launches and only kills
those. The original killall was just a stop gap until the process
tracking was added.
