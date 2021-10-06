Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B862D4248B6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbhJFVSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhJFVSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:18:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD76C061746;
        Wed,  6 Oct 2021 14:16:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y12so1197014eda.4;
        Wed, 06 Oct 2021 14:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zMN0PJSw/kmUZUYUDBwwSaq1S7W29aD0DpcprY8DFv4=;
        b=hE2qO9icgWR8ZPz/2jEIQl00Qag1SjF69Ny2CrM4gRr8etxmUy44XIx1agYFaTBYWU
         fpSn0Nf7qfJh6EdvtqjHtlLF+cm0qJkijWh+y9CNRQG1461benzB/nJxxJzkj5sonXA6
         ZrlrZmIt8xvpwN+POKgybkmAbvjLBWPc8Lnqbo9lEBrKyYdf0tiJwP94hLNwmakC7Yul
         Pu368inQjZ+zbSWOJWEEkVgfDbB84nJ1N/3hSWqxKdxvor0jKJyfwOqbOsxgeHg0gt4b
         p5KCici5eWg0s2XEYHTAZQnCOmVWsuVOl69Tm3b6T5r3Bd3YpsoOW2SqMiZkcFkuc7rW
         BnkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zMN0PJSw/kmUZUYUDBwwSaq1S7W29aD0DpcprY8DFv4=;
        b=sjenEmuqHanWu0m2YNw7DjoJwoNa0m0Rnn2djEjzJuL2yy5XscZcn0U+iQj+iCshro
         PKpG02O90u97fWniIKbCZmWVQhlghk/onuUOOPjRl3O9xFg6VETG+puRZbX5zyKeKeN6
         jgHVTr0L8HbuWouh5evXHZJAm+ygqzFck2mW8cj+ea6D5vvK3M8A00/iPbJju/E1MVNF
         /ozh3XC2+NWWfZv8QKLkunmQdz7uB78MLCwDuTuWubes/uvPuVDCRNz+Pkre1Mkkl0Ex
         yj/dEWyE7RelNAbWeo6VXVzF85RocOqtXQKsYx8KIUrAWvPzqqF2yHyv+Nc8Gs/O2jIr
         9PnA==
X-Gm-Message-State: AOAM5305B/BGtAp+5MPA5D7w8F5ABDRbQ/Hwd8DlLr9JNuAMvNyPdhyK
        TcfXIMv/7sLY44V5Mo7tDnfbRuyABD7b23tH7Xxyhw==
X-Google-Smtp-Source: ABdhPJxTruFef8YM7ESfPUDvfsceyasKtSMB9M1AZI1jPWzsoHrUSN7CCnGvWmlaBxXCf1pO94pirw==
X-Received: by 2002:a17:906:3d22:: with SMTP id l2mr650852ejf.187.1633554972793;
        Wed, 06 Oct 2021 14:16:12 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:473a:8ebc:828b:d6c6? ([2a04:241e:501:3870:473a:8ebc:828b:d6c6])
        by smtp.gmail.com with ESMTPSA id fx4sm9375832ejb.113.2021.10.06.14.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 14:16:12 -0700 (PDT)
Subject: Re: [PATCH 05/11] selftests: net/fcnal: kill_procs via spin instead
 of sleep
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ff71285715d47b8c9b6bedb3b50700a26bc81f41.1633520807.git.cdleonard@gmail.com>
 <b1a213d5-470d-637d-4e78-1b7653d87041@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <7ac2b77d-4633-bd3e-c24f-ec87d34b4516@gmail.com>
Date:   Thu, 7 Oct 2021 00:16:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b1a213d5-470d-637d-4e78-1b7653d87041@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.10.2021 17:45, David Ahern wrote:
> On 10/6/21 5:47 AM, Leonard Crestez wrote:
>> Sleeping for one second after a kill is not necessary and adds up quite
>> quickly. Replace with a fast loop spinning until pidof returns nothing.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   tools/testing/selftests/net/fcnal-test.sh | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
>> index 0bd60cd3bc06..b7fda51deb3f 100755
>> --- a/tools/testing/selftests/net/fcnal-test.sh
>> +++ b/tools/testing/selftests/net/fcnal-test.sh
>> @@ -176,12 +176,19 @@ show_hint()
>>   	fi
>>   }
>>   
>>   kill_procs()
>>   {
>> -	killall nettest ping ping6 >/dev/null 2>&1
>> -	sleep 1
>> +	local pids
>> +	while true; do
>> +		pids=$(pidof nettest ping ping6)
>> +		if [[ -z $pids ]]; then
>> +			break
>> +		fi
>> +		kill $pids
>> +		sleep 0.01
>> +	done
>>   }
>>   
>>   do_run_cmd()
>>   {
>>   	local cmd="$*"
>>
> 
> ideally the script keeps track of processes it launches and only kills
> those. The original killall was just a stop gap until the process
> tracking was added.

That's harder to do. This is much faster and not in any way worse than 
killall + sleep.

Some sort of a wrapper would have to added for each process running the 
background, for each run_ping_bg.

If nettest forks by itself then $! won't work, maybe some sort of 
--pid-file switch would be required?

--
Regards,
Leonard
