Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3D11D7EBF
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgERQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:41:26 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD570C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 09:41:24 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g185so10727183qke.7
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 09:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=NNPwWzpzXEtzjDe0W7+wdrskQWtwGeQevO0FyuGV560=;
        b=ZN9qZ//YIGEAb5wjSvKHGIez/xDfzImau66I9tAfF36HRhXgeALyqgk33QjLlLX9IY
         Bjm+5RAkXqwKpPWMHKsKGVzsSyBIbDHvh4WtxFLKRNq7VmCwy59NhKIbKtFn6+TqDixl
         pMkbBmvAb8Lpk6F7HLEEEVv6Leiv+4vUNDlvbKHd/P+qx5TALVimPJayoN1ImSUkmwQW
         wYsZX3h03STQs0PffLaaTYQxbIhMb5TV0Qx5PdNGXsr09hSY7d0Lz7ACePxBVwIUO3bJ
         mo2eytH+OQk7woXor3JtFPIAkPf7Pt/VedPLjS2DKRj9+0zQgnU2boUQAer7TiXhTXek
         6NLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=NNPwWzpzXEtzjDe0W7+wdrskQWtwGeQevO0FyuGV560=;
        b=hWIqFHFiycr3xns6XOtHOoi7SUQgyVdaYNT1MtjhbJ0m+kL5yBYfVka2hWvw9efKZC
         nEnTffHUU0XoaGMP5YnBphN1lFZfKlS4SfG1J0NB8nXMJRIFKtoWj2F+F3b/xlpwtdZu
         S/9DIony1w4xk1oev1BW1drP6EwXeYf5lAOJ+bHfgKQD/Aw/cADtw1IYScw5SIYH2Aju
         nCaq2Emd4LeryuwMryqf861VhXfsnr208F4j/cC3V/UTBoFwCmEL/Dy+GCem4LTTQJ7i
         aSF3FQxxSZnMelk6vGp1FdYBiwvEtzjidGhxZkB3PhpkJU6QGALPJjl/JWI3RNfQVgCv
         GBcw==
X-Gm-Message-State: AOAM533McbiRdxlsNX4PSnwz7DKyxAAHCNuOJ8FSXr+BFk4SILhDCAE0
        2I6rdnHKLVZmjBfgRwU+ZOQZDncym9Y4NQ==
X-Google-Smtp-Source: ABdhPJzK6oj8Yz4Nto7djklmgZ99yw5ZDVDhFouunsiAZCmZ3gDsL+NWvrHNqxJChvJOqUx5KE6yXQ==
X-Received: by 2002:a37:6f47:: with SMTP id k68mr16442731qkc.341.1589820083888;
        Mon, 18 May 2020 09:41:23 -0700 (PDT)
Received: from sevai ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id k3sm8711068qkb.112.2020.05.18.09.41.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 09:41:23 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first used
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
        <8f9898bf-3396-a8c4-b8a1-a0d72d5ebc2c@gmail.com>
Date:   Mon, 18 May 2020 12:41:10 -0400
In-Reply-To: <8f9898bf-3396-a8c4-b8a1-a0d72d5ebc2c@gmail.com> (David Ahern's
        message of "Mon, 18 May 2020 09:36:15 -0600")
Message-ID: <85pnb1mc0p.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/17/20 7:28 AM, Roman Mashak wrote:
>> Have print_tm() dump firstuse value along with install, lastuse
>> and expires.
>> 
>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>> ---
>>  tc/tc_util.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/tc/tc_util.c b/tc/tc_util.c
>> index 12f865cc71bf..f6aa2ed552a9 100644
>> --- a/tc/tc_util.c
>> +++ b/tc/tc_util.c
>> @@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>>  		print_uint(PRINT_FP, NULL, " used %u sec",
>>  			   (unsigned int)(tm->lastuse/hz));
>>  	}
>> +	if (tm->firstuse != 0) {
>> +		print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
>> +		print_uint(PRINT_FP, NULL, " firstused %u sec",
>> +			   (unsigned int)(tm->firstuse/hz));
>> +	}
>>  	if (tm->expires != 0) {
>>  		print_uint(PRINT_JSON, "expires", NULL, tm->expires);
>>  		print_uint(PRINT_FP, NULL, " expires %u sec",
>> 
>
> why does this function print different values for json and stdout?

It prints times in jiffies for json mode, and in seconds otherwise. This
inconsistency is likely a bug, and a subject for another fix.

Last time this function was touched in commit
2704bd62558391c00bc1c3e7f8706de8332d8ba0 where json was added.
