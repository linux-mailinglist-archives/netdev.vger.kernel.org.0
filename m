Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03732301371
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 06:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbhAWF4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 00:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAWF4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 00:56:30 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1980C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 21:55:49 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id h192so8652236oib.1
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 21:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DzXIDoxCShF+D0m41kLIyCBPOiRYQAH/OF2pwzhOznI=;
        b=HqbvXGzVfINRTIUMELzCFmiQYcjjmFLNdZdXaK1F0Zw0z/eU9WqXyyBrccndD9xhpU
         tPtfMhmXCZSV7ZZGMf/qBiSp6d1DSZXz/yrjbOW6d3zsHU+PAkg3r7ePQ17ffiWkSN+L
         t4s7XxIT0EjZMgR7CLj5vJg2uPmsk7xq+lAnRX5C0MEfUsPHbFQHkHFsn333UP0DgDlf
         +axCbJLAU12um4cRe5gL5nisr6fSl4HtjMYuireLTPj8uQMyj4ViHrm1H50vo74plgz2
         uthUma1H4uMw+iSoYuQukDqoCLsnfLcyENMePLVugt6FWQuiQ66luNBCxs1cTzZOQ4gT
         sGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DzXIDoxCShF+D0m41kLIyCBPOiRYQAH/OF2pwzhOznI=;
        b=UjjZ9vYkQvtN9GGK3Q+tM3Z6p/Twy9ew8/qMcNAJzqLDzdWP7tI1dFNOs9I9jjU+39
         uSPADzEMbI6nF3JdpP/TQWfnwG02MwwtVSJJwPsYsv3VwH9JMoptszBYwk36c3mV+ib4
         faLULwjTINFX0A+XiXYBd34c+KJfNeoRrceE7xN/Wus0irWCTz4EEazTtGe4TpBATpbB
         S4bK9BxedcF78xnOAklgJuCeEC6AN2kyJXPQyj8Rcc+KTicXIbH/IMCeR32oKHY4Y+MR
         M0SDJ3BFOQxwnE2cBiywcntROEXi7VVdW07k8fQ9ZAGjQYZj0qNX9uZjLdo/ntzZ0fsr
         19Qw==
X-Gm-Message-State: AOAM532FitCbRKKJ0PeMr43vtdXlvWrPVATGD7JFObFuYnoRaHLmqCum
        E+jaOtQC0oGS3+TULJ6oCGI=
X-Google-Smtp-Source: ABdhPJwiC7Z2pwERrAb94PU913nND6pdv/hS5tmSkLnXywf0qo0kcPo0oKW3R4CL/XZF5A3Wvkr8TA==
X-Received: by 2002:a05:6808:99a:: with SMTP id a26mr5683426oic.40.1611381348209;
        Fri, 22 Jan 2021 21:55:48 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id 49sm2140568oth.31.2021.01.22.21.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 21:55:47 -0800 (PST)
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive
 zerocopy.
To:     Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
 <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com>
Date:   Fri, 22 Jan 2021 22:55:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 9:07 PM, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>> index 768e93bd5b51..b216270105af 100644
>> --- a/include/uapi/linux/tcp.h
>> +++ b/include/uapi/linux/tcp.h
>> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
>>  	__u64 copybuf_address;	/* in: copybuf address (small reads) */
>>  	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
>>  	__u32 flags; /* in: flags */
>> +	__u64 msg_control; /* ancillary data */
>> +	__u64 msg_controllen;
>> +	__u32 msg_flags;
>> +	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> 
> Well, let's hope nobody steps on this landmine.. :)
> 

Past suggestions were made to use anonymous declarations - e.g., __u32
:32; - as a way of reserving the space for future use. That or declare
'__u32 resvd', check that it must be 0 and makes it available for later
(either directly or with a union).

